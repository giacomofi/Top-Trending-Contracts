['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', "import './libraries/Ownable.sol';\n", "import './libraries/Math.sol';\n", "import './MahaswapV1ERC20.sol';\n", "import './interfaces/IERC20.sol';\n", "import './libraries/UQ112x112.sol';\n", "import './interfaces/IMahaswapV1Pair.sol';\n", "import './interfaces/IMahaswapV1Callee.sol';\n", "import './interfaces/IMahaswapV1Factory.sol';\n", "import './interfaces/IIncentiveController.sol';\n", '\n', 'contract MahaswapV1Pair is IMahaswapV1Pair, MahaswapV1ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    using UQ112x112 for uint224;\n', '\n', '    uint256 public constant MINIMUM_LIQUIDITY = 10**3;\n', "    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '\n', '    address public factory;\n', '    address public token0;\n', '    address public token1;\n', '\n', '    uint112 private reserve0; // uses single storage slot, accessible via getReserves\n', '    uint112 private reserve1; // uses single storage slot, accessible via getReserves\n', '    uint32 private blockTimestampLast; // uses single storage slot, accessible via getReserves\n', '\n', '    uint256 public price0CumulativeLast;\n', '    uint256 public price1CumulativeLast;\n', '\n', '    uint256 public price0Last;\n', '    uint256 public price1Last;\n', '\n', '    uint256 public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event\n', '\n', '    uint256 private unlocked = 1;\n', '\n', '    // Controller which controls the incentives.\n', '    IIncentiveController public controller;\n', '\n', '    // Used to pause swaping activity.\n', '    bool swapingPaused = false;\n', '\n', '    modifier lock() {\n', "        require(unlocked == 1, 'UniswapV2: LOCKED');\n", '        unlocked = 0;\n', '        _;\n', '        unlocked = 1;\n', '    }\n', '\n', '    modifier checkIfPaused {\n', "        require(!swapingPaused, 'Pair: swapping is paused');\n", '\n', '        _;\n', '    }\n', '\n', '    function getReserves()\n', '        public\n', '        view\n', '        returns (\n', '            uint112 _reserve0,\n', '            uint112 _reserve1,\n', '            uint32 _blockTimestampLast\n', '        )\n', '    {\n', '        _reserve0 = reserve0;\n', '        _reserve1 = reserve1;\n', '        _blockTimestampLast = blockTimestampLast;\n', '    }\n', '\n', '    function _safeTransfer(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) private {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');\n", '    }\n', '\n', '    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n', '    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint256 amount0In,\n', '        uint256 amount1In,\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    constructor() public {\n', '        factory = msg.sender;\n', '    }\n', '\n', '    // called once by the factory at time of deployment\n', '    function initialize(address _token0, address _token1) external {\n', "        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check\n", '        token0 = _token0;\n', '        token1 = _token1;\n', '    }\n', '\n', '    function setSwapingPaused(bool isSet) public onlyOwner {\n', '        swapingPaused = isSet;\n', '    }\n', '\n', '    function setIncentiveController(address newController) external onlyOwner {\n', "        require(newController != address(0), 'Pair: invalid address');\n", '        controller = IIncentiveController(newController);\n', '    }\n', '\n', '    // update reserves and, on the first call per block, price accumulators\n', '    function _update(\n', '        uint256 balance0,\n', '        uint256 balance1,\n', '        uint112 _reserve0,\n', '        uint112 _reserve1\n', '    ) private {\n', "        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');\n", '        uint32 blockTimestamp = uint32(block.timestamp % 2**32);\n', '        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired\n', '        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {\n', '            // * never overflows, and + overflow is desired\n', '            price0Last = uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0));\n', '            price1Last = uint256(UQ112x112.encode(_reserve0).uqdiv(_reserve1));\n', '\n', '            price0CumulativeLast += price0Last * timeElapsed;\n', '            price1CumulativeLast += price1Last * timeElapsed;\n', '        }\n', '        reserve0 = uint112(balance0);\n', '        reserve1 = uint112(balance1);\n', '        blockTimestampLast = blockTimestamp;\n', '        emit Sync(reserve0, reserve1);\n', '    }\n', '\n', '    // calls our special reward controller\n', '    function _reward(\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        uint256 amount0In,\n', '        uint256 amount1In,\n', '        address to\n', '    ) private {\n', '        if (address(controller) == address(0)) return;\n', '        controller.conductChecks(\n', '            reserve0,\n', '            reserve1,\n', '            price0Last,\n', '            price1Last,\n', '            amount0Out,\n', '            amount1Out,\n', '            amount0In,\n', '            amount1In,\n', '            msg.sender,\n', '            to\n', '        );\n', '    }\n', '\n', '    // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)\n', '    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {\n', '        address feeTo = IUniswapV2Factory(factory).feeTo();\n', '        feeOn = feeTo != address(0);\n', '        uint256 _kLast = kLast; // gas savings\n', '        if (feeOn) {\n', '            if (_kLast != 0) {\n', '                uint256 rootK = Math.sqrt(uint256(_reserve0).mul(_reserve1));\n', '                uint256 rootKLast = Math.sqrt(_kLast);\n', '                if (rootK > rootKLast) {\n', '                    uint256 numerator = totalSupply.mul(rootK.sub(rootKLast));\n', '                    uint256 denominator = rootK.mul(5).add(rootKLast);\n', '                    uint256 liquidity = numerator / denominator;\n', '                    if (liquidity > 0) _mint(feeTo, liquidity);\n', '                }\n', '            }\n', '        } else if (_kLast != 0) {\n', '            kLast = 0;\n', '        }\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function mint(address to) external lock returns (uint256 liquidity) {\n', '        (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings\n', '        uint256 balance0 = IERC20(token0).balanceOf(address(this));\n', '        uint256 balance1 = IERC20(token1).balanceOf(address(this));\n', '        uint256 amount0 = balance0.sub(_reserve0);\n', '        uint256 amount1 = balance1.sub(_reserve1);\n', '\n', '        bool feeOn = _mintFee(_reserve0, _reserve1);\n', '        uint256 _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee\n', '        if (_totalSupply == 0) {\n', '            liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);\n', '            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens\n', '        } else {\n', '            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);\n', '        }\n', "        require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');\n", '        _mint(to, liquidity);\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        if (feeOn) kLast = uint256(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date\n', '        emit Mint(msg.sender, amount0, amount1);\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function burn(address to) external lock returns (uint256 amount0, uint256 amount1) {\n', '        (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings\n', '        address _token0 = token0; // gas savings\n', '        address _token1 = token1; // gas savings\n', '        uint256 balance0 = IERC20(_token0).balanceOf(address(this));\n', '        uint256 balance1 = IERC20(_token1).balanceOf(address(this));\n', '        uint256 liquidity = balanceOf[address(this)];\n', '\n', '        bool feeOn = _mintFee(_reserve0, _reserve1);\n', '        uint256 _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee\n', '        amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution\n', '        amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution\n', "        require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');\n", '        _burn(address(this), liquidity);\n', '        _safeTransfer(_token0, to, amount0);\n', '        _safeTransfer(_token1, to, amount1);\n', '        balance0 = IERC20(_token0).balanceOf(address(this));\n', '        balance1 = IERC20(_token1).balanceOf(address(this));\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        if (feeOn) kLast = uint256(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date\n', '        emit Burn(msg.sender, amount0, amount1, to);\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function swap(\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        address to,\n', '        bytes calldata data\n', '    ) external lock checkIfPaused {\n', "        require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');\n", '        (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings\n', "        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');\n", '\n', '        uint256 balance0;\n', '        uint256 balance1;\n', '        {\n', '            // scope for _token{0,1}, avoids stack too deep errors\n', '            address _token0 = token0;\n', '            address _token1 = token1;\n', "            require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');\n", '            if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens\n', '            if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens\n', '            if (data.length > 0) IMahaswapV1Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);\n', '            balance0 = IERC20(_token0).balanceOf(address(this));\n', '            balance1 = IERC20(_token1).balanceOf(address(this));\n', '        }\n', '        uint256 amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;\n', '        uint256 amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;\n', "        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');\n", '        {\n', '            // scope for reserve{0,1}Adjusted, avoids stack too deep errors\n', '            uint256 balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));\n', '            uint256 balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));\n', '            require(\n', '                balance0Adjusted.mul(balance1Adjusted) >= uint256(_reserve0).mul(_reserve1).mul(1000**2),\n', "                'UniswapV2: K'\n", '            );\n', '        }\n', '\n', '        // Get reserves after the trade was made.\n', '        _reward(amount0Out, amount1Out, amount0In, amount1In, to);\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '\n', '        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);\n', '    }\n', '\n', '    // force balances to match reserves\n', '    function skim(address to) external lock {\n', '        address _token0 = token0; // gas savings\n', '        address _token1 = token1; // gas savings\n', '        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));\n', '        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));\n', '    }\n', '\n', '    // force reserves to match balances\n', '    function sync() external lock {\n', '        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', "        require(owner() == msg.sender, 'Ownable: caller is not the owner');\n", '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', "        require(newOwner != address(0), 'Ownable: new owner is the zero address');\n", '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * A library for performing various math operations\n', ' */\n', 'library Math {\n', '    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = x > y ? x : y;\n', '    }\n', '\n', '    // Babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint256 y) internal pure returns (uint256 z) {\n', '        if (y > 3) {\n', '            z = y;\n', '\n', '            uint256 x = y / 2 + 1;\n', '\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', 'pragma solidity =0.5.16;\n', '\n', "import './interfaces/IUniswapV2ERC20.sol';\n", "import './libraries/SafeMath.sol';\n", '\n', 'contract MahaswapV1ERC20 is IUniswapV2ERC20 {\n', '    using SafeMath for uint256;\n', '\n', "    string public constant name = 'MahaSwap LP V1';\n", "    string public constant symbol = 'MLP-V1';\n", '    uint8 public constant decimals = 18;\n', '    uint256 public totalSupply;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    bytes32 public DOMAIN_SEPARATOR;\n', '    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;\n', '    mapping(address => uint256) public nonces;\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    constructor() public {\n', '        uint256 chainId;\n', '        assembly {\n', '            chainId := chainid\n', '        }\n', '        DOMAIN_SEPARATOR = keccak256(\n', '            abi.encode(\n', "                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),\n", '                keccak256(bytes(name)),\n', "                keccak256(bytes('1')),\n", '                chainId,\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    function _mint(address to, uint256 value) internal {\n', '        totalSupply = totalSupply.add(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(address(0), to, value);\n', '    }\n', '\n', '    function _burn(address from, uint256 value) internal {\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '        emit Transfer(from, address(0), value);\n', '    }\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 value\n', '    ) private {\n', '        allowance[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    function _transfer(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) private {\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) external returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint256 value) external returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool) {\n', '        if (allowance[from][msg.sender] != uint256(-1)) {\n', '            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);\n', '        }\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external {\n', "        require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');\n", '        bytes32 digest =\n', '            keccak256(\n', '                abi.encodePacked(\n', "                    '\\x19\\x01',\n", '                    DOMAIN_SEPARATOR,\n', '                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))\n', '                )\n', '            );\n', '        address recoveredAddress = ecrecover(digest, v, r, s);\n', "        require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');\n", '        _approve(owner, spender, value);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * A library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', ' * range: [0, 2**112 - 1]\n', ' * resolution: 1 / 2**112\n', ' */\n', 'library UQ112x112 {\n', '    uint224 constant Q112 = 2**112;\n', '\n', '    // Encode a uint112 as a UQ112x112\n', '    function encode(uint112 y) internal pure returns (uint224 z) {\n', '        z = uint224(y) * Q112; // never overflows\n', '    }\n', '\n', '    // Multiply a UQ112x112 by a uint112, returning a UQ112x112\n', '    function uqmul(uint224 x, uint112 y) internal pure returns (uint224 z) {\n', '        z = x * uint224(y);\n', '    }\n', '\n', '    // Divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {\n', '        z = x / uint224(y);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IMahaswapV1Pair {\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint256);\n', '\n', '    function factory() external view returns (address);\n', '\n', '    function token0() external view returns (address);\n', '\n', '    function token1() external view returns (address);\n', '\n', '    function price0CumulativeLast() external view returns (uint256);\n', '\n', '    function price1CumulativeLast() external view returns (uint256);\n', '\n', '    function kLast() external view returns (uint256);\n', '\n', '    function getReserves()\n', '        external\n', '        view\n', '        returns (\n', '            uint112 reserve0,\n', '            uint112 reserve1,\n', '            uint32 blockTimestampLast\n', '        );\n', '\n', '    function mint(address to) external returns (uint256 liquidity);\n', '\n', '    function burn(address to) external returns (uint256 amount0, uint256 amount1);\n', '\n', '    function swap(\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        address to,\n', '        bytes calldata data\n', '    ) external;\n', '\n', '    function skim(address to) external;\n', '\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '\n', '    function setSwapingPaused(bool isSet) external;\n', '\n', '    function setIncentiveController(address controller) external;\n', '\n', '    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n', '    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint256 amount0In,\n', '        uint256 amount1In,\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IMahaswapV1Callee {\n', '    function uniswapV2Call(\n', '        address sender,\n', '        uint256 amount0,\n', '        uint256 amount1,\n', '        bytes calldata data\n', '    ) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', "import './IUniswapV2Factory.sol';\n", '\n', 'interface IMahaswapV1Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);\n', '\n', '    function feeTo() external view returns (address);\n', '\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '\n', '    function allPairs(uint256) external view returns (address pair);\n', '\n', '    function allPairsLength() external view returns (uint256);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '\n', '    function setFeeToSetter(address) external;\n', '\n', '    function setIncentiveControllerForPair(address pair, address controller) external;\n', '\n', '    function setSwapingPausedForPair(address pair, bool isSet) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IIncentiveController {\n', '    function conductChecks(\n', '        uint112 reserveA,\n', '        uint112 reserveB,\n', '        uint256 priceALast,\n', '        uint256 priceBLast,\n', '        uint256 amountOutA,\n', '        uint256 amountOutB,\n', '        uint256 amountInA,\n', '        uint256 amountInB,\n', '        address from,\n', '        address to\n', '    ) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2ERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function name() external pure returns (string memory);\n', '\n', '    function symbol() external pure returns (string memory);\n', '\n', '    function decimals() external pure returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '\n', '    function nonces(address owner) external view returns (uint256);\n', '\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * A library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', "        require(c >= a, 'SafeMath: addition overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return sub(a, b, 'SafeMath: subtraction overflow');\n", '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', "        require(c / a == b, 'SafeMath: multiplication overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return div(a, b, 'SafeMath: division by zero');\n", '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return mod(a, b, 'SafeMath: modulo by zero');\n", '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);\n', '\n', '    function feeTo() external view returns (address);\n', '\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '\n', '    function allPairs(uint256) external view returns (address pair);\n', '\n', '    function allPairsLength() external view returns (uint256);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '\n', '    function setFeeToSetter(address) external;\n', '}']