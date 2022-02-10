['// File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol\n', '\n', '\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '    function migrator() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '    function setMigrator(address) external;\n', '}\n', '\n', '// File: contracts/Migrator.sol\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract Migrator {\n', '    address public chef;\n', '    address public oldFactory;\n', '    IUniswapV2Factory public factory;\n', '    uint256 public notBeforeBlock;\n', '    uint256 public desiredLiquidity = uint256(-1);\n', '\n', '    constructor(\n', '        address _chef,\n', '        address _oldFactory,\n', '        IUniswapV2Factory _factory,\n', '        uint256 _notBeforeBlock\n', '    ) public {\n', '        chef = _chef;\n', '        oldFactory = _oldFactory;\n', '        factory = _factory;\n', '        notBeforeBlock = _notBeforeBlock;\n', '    }\n', '\n', '    function migrate(IUniswapV2Pair orig) public returns (IUniswapV2Pair) {\n', '        require(msg.sender == chef, "not from master chef");\n', '        require(block.number >= notBeforeBlock, "too early to migrate");\n', '        require(orig.factory() == oldFactory, "not from old factory");\n', '        address token0 = orig.token0();\n', '        address token1 = orig.token1();\n', '        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token0, token1));\n', '        if (pair == IUniswapV2Pair(address(0))) {\n', '            pair = IUniswapV2Pair(factory.createPair(token0, token1));\n', '        }\n', '        uint256 lp = orig.balanceOf(msg.sender);\n', '        if (lp == 0) return pair;\n', '        desiredLiquidity = lp;\n', '        orig.transferFrom(msg.sender, address(orig), lp);\n', '        orig.burn(address(pair));\n', '        pair.mint(msg.sender);\n', '        desiredLiquidity = uint256(-1);\n', '        return pair;\n', '    }\n', '}']