['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', "import './dependencies/uniswap-v2-periphery/contracts/dependencies/uniswap-v2-core/contracts/interfaces/IUniswapV2Pair.sol';\n", "import './dependencies/uniswap-v2-periphery/contracts/dependencies/uniswap-v2-core/contracts/interfaces/IUniswapV2Factory.sol';\n", "import './interfaces/IRenaswapV1Wrapper.sol';\n", "import './RenaswapV1Pair.sol';\n", '\n', '/**\n', ' * RenaswapV1Factory allows for the creation of RenaswapV1Pair contracts\n', ' * Behaves the same as UniswapV2Factory\n', ' */\n', 'contract RenaswapV1Factory is IUniswapV2Factory {\n', '\n', '    /// @dev Sends fees to this address\n', '    address public override feeTo;\n', '    /// @dev Address able to change the feeTo value (owner)\n', '    address public override feeToSetter;\n', '    /// @dev Maps pair addresses by tokenA and tokenB keys\n', '    mapping(address => mapping(address => address)) public override getPair;\n', '    /// @dev List of all created pairs addresses\n', '    address[] public override allPairs;\n', '    /// @dev Wrapper address used with the pairs\n', '    IRenaswapV1Wrapper public wrapper;\n', '\n', '    /**\n', '     * @param _feeToSetter Owner address\n', '     * @param _wrapper Wrapper address\n', '     */\n', '    constructor(address _feeToSetter, IRenaswapV1Wrapper _wrapper) {\n', '        wrapper = _wrapper;\n', '        feeToSetter = _feeToSetter;\n', '    }\n', '\n', '    /**\n', '     * @dev creates a new pair for tokenA and B\n', '     * @param tokenA ERC20 tokenA address\n', '     * @param tokenB ERC20 tokenB address, which is to be wrapped\n', '     * @return pair new pair address\n', '     */\n', '    function createPair(address tokenA, address tokenB) external override returns (address pair) {\n', "        require(tx.origin == feeToSetter, 'RenaswapV1: FORBIDDEN');\n", "        require(tokenA != tokenB, 'RenaswapV1: IDENTICAL_ADDRESSES');\n", "        require(tokenA != address(0) && tokenB != address(0), 'RenaswapV1: ZERO_ADDRESS');\n", "        require(getPair[tokenA][tokenB] == address(0), 'RenaswapV1: PAIR_EXISTS'); // single check is sufficient\n", '        bytes memory bytecode = type(RenaswapV1Pair).creationCode;\n', '        bytes32 salt = keccak256(abi.encodePacked(tokenA, tokenB));\n', '        assembly {\n', '            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)\n', '        }\n', '        IUniswapV2Pair(pair).initialize(tokenA, address(wrapper));\n', '        getPair[tokenA][tokenB] = pair;\n', '        allPairs.push(pair);\n', '        /// @dev Adds tokenB as wrapped token linked to the pair\n', '        wrapper.addWrappedToken(tokenB, pair);\n', '        emit PairCreated(tokenA, tokenB, pair, allPairs.length);\n', '    }\n', '    \n', '    function setFeeTo(address _feeTo) external override {\n', "        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');\n", '        feeTo = _feeTo;\n', '    }\n', '\n', '    function setFeeToSetter(address _feeToSetter) external override {\n', "        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');\n", '        feeToSetter = _feeToSetter;\n', '    }\n', '\n', '    function allPairsLength() external view override returns (uint) {\n', '        return allPairs.length;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'import "./IUniswapV2ERC20.sol";\n', '\n', 'interface IUniswapV2Pair is IUniswapV2ERC20 {\n', '    // event Approval(address indexed owner, address indexed spender, uint value);\n', '    // event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '\n', '    // function name() external pure returns (string memory);\n', '    // function symbol() external pure returns (string memory);\n', '    // function decimals() external pure returns (uint8);\n', '    // function totalSupply() external view returns (uint);\n', '    // function balanceOf(address owner) external view returns (uint);\n', '    // function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    // function approve(address spender, uint value) external returns (bool);\n', '    // function transfer(address to, uint value) external returns (bool);\n', '    // function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    // function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    // function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    // function nonces(address owner) external view returns (uint);\n', '\n', '    // function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IRenaswapV1Wrapper {\n', '    function addWrappedToken(address token, address pair) external returns (uint256 id);\n', '    function balanceFor(address token, address account) external view returns (uint256);\n', '    function rBurn(address token, uint256 burnDivisor) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', "import './dependencies/uniswap-v2-periphery/contracts/dependencies/uniswap-v2-core/contracts/UniswapV2Pair.sol';\n", 'import "@openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol";\n', '\n', '/**\n', ' * RenaswapV1Pair works as a UniswapV2Pair\n', ' * Adds ERC1155Receiver interface used by the wrapper\n', ' */\n', 'contract RenaswapV1Pair is UniswapV2Pair, ERC1155Receiver {\n', '\n', '    constructor() UniswapV2Pair() ERC1155Receiver() {\n', '    }\n', '\n', '    function onERC1155Received(\n', '        address /*operator*/,\n', '        address /*from*/,\n', '        uint256 /*id*/,\n', '        uint256 /*value*/,\n', '        bytes calldata /*data*/\n', '    )\n', '        external override pure\n', '        returns(bytes4) {\n', '            return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));\n', '        }\n', '\n', '    function onERC1155BatchReceived(\n', '        address /*operator*/,\n', '        address /*from*/,\n', '        uint256[] calldata /*ids*/,\n', '        uint256[] calldata /*values*/,\n', '        bytes calldata /*data*/\n', '    )\n', '        external override pure\n', '        returns(bytes4) {\n', '        }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IUniswapV2ERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', "import './interfaces/IUniswapV2Pair.sol';\n", "import './UniswapV2ERC20.sol';\n", "import './libraries/Math.sol';\n", "import './libraries/UQ112x112.sol';\n", "import './interfaces/IERC20.sol';\n", "import './interfaces/IUniswapV2Factory.sol';\n", "import './interfaces/IUniswapV2Callee.sol';\n", '\n', 'contract UniswapV2Pair is IUniswapV2Pair, UniswapV2ERC20 {\n', '    using SafeMath  for uint;\n', '    using UQ112x112 for uint224;\n', '\n', '    // event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    uint internal constant _MINIMUM_LIQUIDITY = 10**3;\n', "    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '\n', '    address internal _factory;\n', '    address internal _token0;\n', '    address internal _token1;\n', '\n', '    uint112 private reserve0;           // uses single storage slot, accessible via getReserves\n', '    uint112 private reserve1;           // uses single storage slot, accessible via getReserves\n', '    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves\n', '\n', '    uint internal _price0CumulativeLast;\n', '    uint internal _price1CumulativeLast;\n', '    uint internal _kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event\n', '\n', '    uint private unlocked = 1;\n', '    modifier lock() {\n', "        require(unlocked == 1, 'UniswapV2: LOCKED');\n", '        unlocked = 0;\n', '        _;\n', '        unlocked = 1;\n', '    }\n', '\n', '    constructor() {\n', '        _factory = msg.sender;\n', '    }\n', '\n', '    function MINIMUM_LIQUIDITY() external pure override returns (uint) {\n', '        return _MINIMUM_LIQUIDITY;\n', '    }\n', '\n', '    function factory() external view override returns (address) {\n', '        return _factory;\n', '    }\n', '\n', '    function token0() external view override returns (address) {\n', '        return _token0;\n', '    }\n', '    function token1() external view override returns (address) {\n', '        return _token1;\n', '    }\n', '\n', '    function price0CumulativeLast() external view override returns (uint) {\n', '        return _price0CumulativeLast;\n', '    }\n', '\n', '    function price1CumulativeLast() external view override returns (uint) {\n', '        return _price1CumulativeLast;\n', '    }\n', '\n', '    function kLast() external view override returns (uint) {\n', '        return _kLast;\n', '    }\n', '\n', '    function getReserves() public view override returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {\n', '        _reserve0 = reserve0;\n', '        _reserve1 = reserve1;\n', '        _blockTimestampLast = blockTimestampLast;\n', '    }\n', '\n', '    function _safeTransfer(address token, address to, uint value) private {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');\n", '    }\n', '\n', '    // event Mint(address indexed sender, uint amount0, uint amount1);\n', '    // event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    // event Swap(\n', '    //     address indexed sender,\n', '    //     uint amount0In,\n', '    //     uint amount1In,\n', '    //     uint amount0Out,\n', '    //     uint amount1Out,\n', '    //     address indexed to\n', '    // );\n', '\n', '    // called once by the factory at time of deployment\n', '    function initialize(address token0_, address token1_) external override {\n', "        require(msg.sender == _factory, 'UniswapV2: FORBIDDEN'); // sufficient check\n", '        _token0 = token0_;\n', '        _token1 = token1_;\n', '    }\n', '\n', '    // update reserves and, on the first call per block, price accumulators\n', '    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {\n', "        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');\n", '        uint32 blockTimestamp = uint32(block.timestamp % 2**32);\n', '        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired\n', '        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {\n', '            // * never overflows, and + overflow is desired\n', '            _price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;\n', '            _price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;\n', '        }\n', '        reserve0 = uint112(balance0);\n', '        reserve1 = uint112(balance1);\n', '        blockTimestampLast = blockTimestamp;\n', '        emit Sync(reserve0, reserve1);\n', '    }\n', '\n', '    // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)\n', '    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {\n', '        address feeTo = IUniswapV2Factory(_factory).feeTo();\n', '        feeOn = feeTo != address(0);\n', '        uint kLast_ = _kLast; // gas savings\n', '        if (feeOn) {\n', '            if (kLast_ != 0) {\n', '                uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));\n', '                uint rootKLast = Math.sqrt(kLast_);\n', '                if (rootK > rootKLast) {\n', '                    uint numerator = _totalSupply.mul(rootK.sub(rootKLast));\n', '                    uint denominator = rootK.mul(5).add(rootKLast);\n', '                    uint liquidity = numerator / denominator;\n', '                    if (liquidity > 0) _mint(feeTo, liquidity);\n', '                }\n', '            }\n', '        } else if (kLast_ != 0) {\n', '            kLast_ = 0;\n', '        }\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function mint(address to) external lock override returns (uint liquidity) {\n', '        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings\n', '        uint balance0 = IERC20(_token0).balanceOf(address(this));\n', '        uint balance1 = IERC20(_token1).balanceOf(address(this));\n', '        uint amount0 = balance0.sub(_reserve0);\n', '        uint amount1 = balance1.sub(_reserve1);\n', '\n', '        bool feeOn = _mintFee(_reserve0, _reserve1);\n', '        uint totalSupply_ = _totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee\n', '        if ( totalSupply_ == 0) {\n', '            liquidity = Math.sqrt(amount0.mul(amount1)).sub(_MINIMUM_LIQUIDITY);\n', '           _mint(address(0), _MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens\n', '        } else {\n', '            liquidity = Math.min(amount0.mul(totalSupply_) / _reserve0, amount1.mul(totalSupply_) / _reserve1);\n', '        }\n', "        require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');\n", '        _mint(to, liquidity);\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        if (feeOn) _kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date\n', '        emit Mint(msg.sender, amount0, amount1);\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function burn(address to) external lock override returns (uint amount0, uint amount1) {\n', '        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings\n', '        address token0_ = _token0;                                // gas savings\n', '        address token1_ = _token1;                                // gas savings\n', '        uint balance0 = IERC20(token0_).balanceOf(address(this));\n', '        uint balance1 = IERC20(token1_).balanceOf(address(this));\n', '        uint liquidity = _balanceOf[address(this)];\n', '\n', '        bool feeOn = _mintFee(_reserve0, _reserve1);\n', '        uint totalSupply_ = _totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee\n', '        amount0 = liquidity.mul(balance0) / totalSupply_; // using balances ensures pro-rata distribution\n', '        amount1 = liquidity.mul(balance1) / totalSupply_; // using balances ensures pro-rata distribution\n', "        require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');\n", '        _burn(address(this), liquidity);\n', '        _safeTransfer(token0_, to, amount0);\n', '        _safeTransfer(token1_, to, amount1);\n', '        balance0 = IERC20(token0_).balanceOf(address(this));\n', '        balance1 = IERC20(token1_).balanceOf(address(this));\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        if (feeOn) _kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date\n', '        emit Burn(msg.sender, amount0, amount1, to);\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external override lock {\n', "        require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');\n", '        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings\n', "        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');\n", '\n', '        uint balance0;\n', '        uint balance1;\n', '        { // scope for _token{0,1}, avoids stack too deep errors\n', '        address token0_ = _token0;\n', '        address token1_ = _token1;\n', "        require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');\n", '        if (amount0Out > 0) _safeTransfer(token0_, to, amount0Out); // optimistically transfer tokens\n', '        if (amount1Out > 0) _safeTransfer(token1_, to, amount1Out); // optimistically transfer tokens\n', '        if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);\n', '        balance0 = IERC20(token0_).balanceOf(address(this));\n', '        balance1 = IERC20(token1_).balanceOf(address(this));\n', '        }\n', '        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;\n', '        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;\n', "        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');\n", '        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors\n', '        uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));\n', '        uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));\n', "        require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');\n", '        }\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);\n', '    }\n', '\n', '    // force balances to match reserves\n', '    function skim(address to) external override lock {\n', '        address token0_ = _token0; // gas savings\n', '        address token1_ = _token1; // gas savings\n', '        _safeTransfer(token0_, to, IERC20(token0_).balanceOf(address(this)).sub(reserve0));\n', '        _safeTransfer(token1_, to, IERC20(token1_).balanceOf(address(this)).sub(reserve1));\n', '    }\n', '\n', '    // force reserves to match balances\n', '    function sync() external override lock {\n', '        _update(IERC20(_token0).balanceOf(address(this)), IERC20(_token1).balanceOf(address(this)), reserve0, reserve1);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./IERC1155Receiver.sol";\n', 'import "../../introspection/ERC165.sol";\n', '\n', '/**\n', ' * @dev _Available since v3.1._\n', ' */\n', 'abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {\n', '    constructor() internal {\n', '        _registerInterface(\n', '            ERC1155Receiver(address(0)).onERC1155Received.selector ^\n', '            ERC1155Receiver(address(0)).onERC1155BatchReceived.selector\n', '        );\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', "import './interfaces/IUniswapV2ERC20.sol';\n", "import './libraries/SafeMath.sol';\n", '\n', 'contract UniswapV2ERC20 is IUniswapV2ERC20 {\n', '    using SafeMath for uint;\n', '\n', "    string internal constant _name = 'Uniswap V2';\n", "    string private constant _symbol = 'UNI-V2';\n", '    uint8 internal constant _decimals = 18;\n', '    uint  internal _totalSupply;\n', '    mapping(address => uint) internal _balanceOf;\n', '    mapping(address => mapping(address => uint)) internal _allowance;\n', '\n', '    bytes32 internal _DOMAIN_SEPARATOR;\n', '    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    bytes32 internal constant _PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;\n', '    mapping(address => uint) internal _nonces;\n', '\n', '    // event Approval(address indexed owner, address indexed spender, uint value);\n', '    // event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    constructor() {\n', '        uint chainId;\n', '        // assembly {\n', '        //     chainId := chainid\n', '        // }\n', '        _DOMAIN_SEPARATOR = keccak256(\n', '            abi.encode(\n', "                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),\n", '                keccak256(bytes(_name)),\n', "                keccak256(bytes('1')),\n", '                chainId,\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    function DOMAIN_SEPARATOR() external view override returns (bytes32) {\n', '        return _DOMAIN_SEPARATOR;\n', '    }\n', '\n', '    function PERMIT_TYPEHASH() external pure override returns (bytes32) {\n', '        return _PERMIT_TYPEHASH;\n', '    }\n', '\n', '    function allowance(address owner, address spender) external view override returns (uint) {\n', '        return _allowance[owner][spender];\n', '    }\n', '\n', '    function balanceOf(address owner) external view override returns (uint) {\n', '        return _balanceOf[owner];\n', '    }\n', '    \n', '    function decimals() external pure override returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function name() external pure override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function nonces(address owner) external view override returns (uint) {\n', '        return _nonces[owner];\n', '    }\n', '\n', '    function symbol() external pure override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function totalSupply() external view override returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function _mint(address to, uint value) internal {\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balanceOf[to] = _balanceOf[to].add(value);\n', '        emit Transfer(address(0), to, value);\n', '    }\n', '\n', '    function _burn(address from, uint value) internal {\n', '        _balanceOf[from] = _balanceOf[from].sub(value);\n', '        _totalSupply = _totalSupply.sub(value);\n', '        emit Transfer(from, address(0), value);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint value) private {\n', '        _allowance[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    function _transfer(address from, address to, uint value) private {\n', '        _balanceOf[from] = _balanceOf[from].sub(value);\n', '        _balanceOf[to] = _balanceOf[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint value) external override returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint value) external override returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint value) external override returns (bool) {\n', '        if (_allowance[from][msg.sender] != uint(-1)) {\n', '            _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);\n', '        }\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {\n', "        require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');\n", '        bytes32 digest = keccak256(\n', '            abi.encodePacked(\n', "                '\\x19\\x01',\n", '                _DOMAIN_SEPARATOR,\n', '                keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _nonces[owner]++, deadline))\n', '            )\n', '        );\n', '        address recoveredAddress = ecrecover(digest, v, r, s);\n', "        require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');\n", '        _approve(owner, spender, value);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', '// a library for performing various math operations\n', '\n', 'library Math {\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint y) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', '// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', '\n', '// range: [0, 2**112 - 1]\n', '// resolution: 1 / 2**112\n', '\n', 'library UQ112x112 {\n', '    uint224 constant Q112 = 2**112;\n', '\n', '    // encode a uint112 as a UQ112x112\n', '    function encode(uint112 y) internal pure returns (uint224 z) {\n', '        z = uint224(y) * Q112; // never overflows\n', '    }\n', '\n', '    // divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {\n', '        z = x / uint224(y);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IUniswapV2Callee {\n', '    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "../../introspection/IERC165.sol";\n', '\n', '/**\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155Receiver is IERC165 {\n', '\n', '    /**\n', '        @dev Handles the receipt of a single ERC1155 token type. This function is\n', '        called at the end of a `safeTransferFrom` after the balance has been updated.\n', '        To accept the transfer, this must return\n', '        `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`\n', '        (i.e. 0xf23a6e61, or its own function selector).\n', '        @param operator The address which initiated the transfer (i.e. msg.sender)\n', '        @param from The address which previously owned the token\n', '        @param id The ID of the token being transferred\n', '        @param value The amount of tokens being transferred\n', '        @param data Additional data with no specified format\n', '        @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed\n', '    */\n', '    function onERC1155Received(\n', '        address operator,\n', '        address from,\n', '        uint256 id,\n', '        uint256 value,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '\n', '    /**\n', '        @dev Handles the receipt of a multiple ERC1155 token types. This function\n', '        is called at the end of a `safeBatchTransferFrom` after the balances have\n', '        been updated. To accept the transfer(s), this must return\n', '        `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`\n', '        (i.e. 0xbc197c81, or its own function selector).\n', '        @param operator The address which initiated the batch transfer (i.e. msg.sender)\n', '        @param from The address which previously owned the token\n', '        @param ids An array containing ids of each token being transferred (order and length must match values array)\n', '        @param values An array containing amounts of each token being transferred (order and length must match ids array)\n', '        @param data Additional data with no specified format\n', '        @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed\n', '    */\n', '    function onERC1155BatchReceived(\n', '        address operator,\n', '        address from,\n', '        uint256[] calldata ids,\n', '        uint256[] calldata values,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./IERC165.sol";\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts may inherit from this and call {_registerInterface} to declare\n', ' * their support of an interface.\n', ' */\n', 'abstract contract ERC165 is IERC165 {\n', '    /*\n', "     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7\n", '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    /**\n', "     * @dev Mapping of interface ids to whether or not it's supported.\n", '     */\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () internal {\n', '        // Derived contracts need only register support for their own interfaces,\n', '        // we register support for ERC165 itself here\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     *\n', '     * Time complexity O(1), guaranteed to always use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    /**\n', '     * @dev Registers the contract as an implementer of the interface defined by\n', '     * `interfaceId`. Support of the actual ERC165 interface is automatic and\n', '     * registering its interface id is not required.\n', '     *\n', '     * See {IERC165-supportsInterface}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).\n', '     */\n', '    function _registerInterface(bytes4 interfaceId) internal virtual {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']