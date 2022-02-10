['// Dependency file: contracts/libraries/SafeMath.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '// Dependency file: contracts/libraries/DemaxSwapLibrary.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', "// import '../interfaces/IDemaxPair.sol';\n", "// import '../interfaces/IDemaxFactory.sol';\n", '// import "./SafeMath.sol";\n', '\n', 'library DemaxSwapLibrary {\n', '    using SafeMath for uint;\n', '\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'DemaxSwapLibrary: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'DemaxSwapLibrary: ZERO_ADDRESS');\n", '    }\n', '\n', '     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        bytes32 salt = keccak256(abi.encodePacked(token0, token1));\n', '        bytes32 rawAddress = keccak256(\n', '         abi.encodePacked(\n', '            bytes1(0xff),\n', '            factory,\n', '            salt,\n', '            IDemaxFactory(factory).contractCodeHash()\n', '            )\n', '        );\n', '     return address(bytes20(rawAddress << 96));\n', '    }\n', '\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IDemaxPair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '    \n', '    function quoteEnhance(address factory, address tokenA, address tokenB, uint amountA) internal view returns(uint amountB) {\n', '        (uint reserveA, uint reserveB) = getReserves(factory, tokenA, tokenB);\n', '        return quote(amountA, reserveA, reserveB);\n', '    }\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'DemaxSwapLibrary: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'DemaxSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = amountIn.mul(reserveOut);\n', '        uint denominator = reserveIn.add(amountIn);\n', '        amountOut = numerator / denominator;\n', '    }\n', '    \n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut);\n', '        uint denominator = reserveOut.sub(amountOut);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '}\n', '// Dependency file: contracts/interfaces/IDemaxPair.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IDemaxPair {\n', '  \n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address) external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address from, address to, uint amount) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address tokenA, address tokenB, address platform, address dgas) external;\n', '    function swapFee(uint amount, address token, address to) external ;\n', '    function queryReward() external view returns (uint rewardAmount, uint blockNumber);\n', '    function mintReward() external returns (uint rewardAmount);\n', '    function getDGASReserve() external view returns (uint);\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IERC20.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IDemaxFactory.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IDemaxFactory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function contractCodeHash() external view returns (bytes32);\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function isPair(address pair) external view returns (bool);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '    function playerPairs(address player, uint index) external view returns (address pair);\n', '    function getPlayerPairCount(address player) external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '    function addPlayerPair(address player, address _pair) external returns (bool);\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IDgas.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IDgas {\n', '    function amountPerBlock() external view returns (uint);\n', '    function changeAmountPerBlock(uint value) external returns (bool);\n', '    function getProductivity(address user) external view returns (uint, uint);\n', '    function increaseProductivity(address user, uint value) external returns (bool);\n', '    function decreaseProductivity(address user, uint value) external returns (bool);\n', '    function take() external view returns (uint);\n', '    function takes() external view returns (uint, uint);\n', '    function mint() external returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function upgradeImpl(address _newImpl) external;\n', '    function upgradeGovernance(address _newGovernor) external;\n', '}\n', '// Dependency file: contracts/modules/Ownable.sol\n', '\n', '// pragma solidity >=0.5.16;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnerChanged(address indexed _oldOwner, address indexed _newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', "        require(msg.sender == owner, 'Ownable: FORBIDDEN');\n", '        _;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', "        require(_newOwner != address(0), 'Ownable: INVALID_ADDRESS');\n", '        emit OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity >=0.6.6;\n', "// import './modules/Ownable.sol';\n", "// import './interfaces/IDgas.sol';\n", "// import './interfaces/IDemaxFactory.sol';\n", "// import './interfaces/IERC20.sol';\n", "// import './interfaces/IDemaxPair.sol';\n", "// import './libraries/DemaxSwapLibrary.sol';\n", "// import './libraries/SafeMath.sol';\n", '\n', 'contract DemaxTransferListener is Ownable {\n', '    uint256 public version = 1;\n', '    address public DGAS;\n', '    address public PLATFORM;\n', '    address public WETH;\n', '    address public FACTORY;\n', '    event Transfer(address indexed from, address indexed to, address indexed token, uint256 amount);\n', '\n', '    function initialize(\n', '        address _DGAS,\n', '        address _FACTORY,\n', '        address _WETH,\n', '        address _PLATFORM\n', '    ) external onlyOwner {\n', '        require(\n', '            _DGAS != address(0) && _FACTORY != address(0) && _WETH != address(0) && _PLATFORM != address(0),\n', "            'DEMAX TRANSFER LISTENER : INPUT ADDRESS IS ZERO'\n", '        );\n', '        DGAS = _DGAS;\n', '        FACTORY = _FACTORY;\n', '        WETH = _WETH;\n', '        PLATFORM = _PLATFORM;\n', '    }\n', '\n', '    function updateDGASImpl(address _newImpl) external onlyOwner {\n', '        IDgas(DGAS).upgradeImpl(_newImpl);\n', '    }\n', '\n', '    function transferNotify(\n', '        address from,\n', '        address to,\n', '        address token,\n', '        uint256 amount\n', '    ) external returns (bool) {\n', "        require(msg.sender == PLATFORM, 'DEMAX TRANSFER LISTENER: PERMISSION');\n", '        if (token == WETH) {\n', '            if (IDemaxFactory(FACTORY).isPair(from)) {\n', '                uint256 decreasePower = IDemaxFactory(FACTORY).getPair(DGAS, WETH) == from\n', '                    ? SafeMath.mul(amount, 2)\n', '                    : amount;\n', '                IDgas(DGAS).decreaseProductivity(from, decreasePower);\n', '            }\n', '            if (IDemaxFactory(FACTORY).isPair(to)) {\n', '                uint256 increasePower = IDemaxFactory(FACTORY).getPair(DGAS, WETH) == to\n', '                    ? SafeMath.mul(amount, 2)\n', '                    : amount;\n', '                IDgas(DGAS).increaseProductivity(to, increasePower);\n', '            }\n', '        } else if (token == DGAS) {\n', '            (uint256 reserveDGAS, uint256 reserveWETH) = DemaxSwapLibrary.getReserves(FACTORY, DGAS, WETH);\n', '            if (IDemaxFactory(FACTORY).isPair(to) && IDemaxFactory(FACTORY).getPair(DGAS, WETH) != to) {\n', '                IDgas(DGAS).increaseProductivity(to, DemaxSwapLibrary.quote(amount, reserveDGAS, reserveWETH));\n', '            }\n', '            if (IDemaxFactory(FACTORY).isPair(from) && IDemaxFactory(FACTORY).getPair(DGAS, WETH) != from) {\n', '                (uint256 pairPower, ) = IDgas(DGAS).getProductivity(from);\n', '                uint256 balance = IDemaxPair(from).getDGASReserve();\n', '                uint256 decrasePower = (SafeMath.mul(amount, pairPower)) / (SafeMath.add(balance, amount));\n', '                if (decrasePower > 0) IDgas(DGAS).decreaseProductivity(from, decrasePower);\n', '            }\n', '        }\n', '        emit Transfer(from, to, token, amount);\n', '        return true;\n', '    }\n', '}']