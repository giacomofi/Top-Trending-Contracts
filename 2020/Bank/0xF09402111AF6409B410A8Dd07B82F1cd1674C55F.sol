['pragma solidity >=0.4.24;\n', '\n', "//import '@uniswap/v2-periphery/contracts/libraries/SafeMath.sol';\n", '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library RB_SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '\n', '    function div(uint x, uint y) internal pure returns (uint z) {\n', '        require(y != 0);\n', '        z = x / y;    \n', '    }\n', '}\n', '\n', 'library RB_UnsignedSafeMath {\n', '    function add(int x, int y) internal pure returns (int z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(int x, int y) internal pure returns (int z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(int x, int y) internal pure returns (int z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '\n', '    function div(int x, int y) internal pure returns (int z) {\n', '        require(y != 0);\n', '        z = x / y;    \n', '    }\n', '}\n', '\n', '\n', "//import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';\n", '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes /* calldata */ data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '\n', '/** Calculates the Delta for a rebase based on the ratio\n', '*** between the price of two different token pairs on \n', '*** Uniswap \n', '***\n', '*** - minimalist design\n', '*** - low gas design\n', '*** - free for anyone to call. \n', '***\n', '****/\n', 'contract RebaseDelta {\n', '\n', '    using RB_SafeMath for uint256;\n', '    using RB_UnsignedSafeMath for int256;\n', '    \n', '    uint256 private constant PRICE_PRECISION = 10**9;\n', '\n', '    function getPrice(IUniswapV2Pair pair_, bool flip_) \n', '    public\n', '    view\n', '    returns (uint256) \n', '    {\n', '        require(address(pair_) != address(0));\n', '\n', '        (uint256 reserves0, uint256 reserves1, ) = pair_.getReserves();\n', '\n', '        if (flip_) {\n', '            (reserves0, reserves1) = (reserves1, reserves0);            \n', '        }\n', '\n', '        // reserves0 = base (probably ETH/WETH)\n', '        // reserves1 = token of interest (maybe ampleforthgold or paxusgold etc)\n', '\n', '        // multiply to equate decimals, multiply up to PRICE_PRECISION\n', '\n', '        uint256 price = (reserves1.mul(PRICE_PRECISION)).div(reserves0);\n', '\n', '        return price;\n', '    }\n', '\n', '    // calculates the supply delta for moving the price of token X to the price\n', '    // of token Y (with the understanding that they are both priced in a common\n', '    // tokens value, i.e. WETH).  \n', '    function calculate(IUniswapV2Pair X_,\n', '                      bool flipX_,\n', '                      uint256 decimalsX_,\n', '                      uint256 SupplyX_, \n', '                      IUniswapV2Pair Y_,\n', '                      bool flipY_,\n', '                      uint256 decimalsY_)\n', '    public\n', '    view\n', '    returns (int256)\n', '    {\n', '        uint256 px = getPrice(X_, flipX_);\n', '        require(px != uint256(0));\n', '        uint256 py = getPrice(Y_, flipY_);\n', '        require(py != uint256(0));\n', '\n', '        uint256 targetSupply = (SupplyX_.mul(py)).div(px);\n', '\n', '        // adust for decimals\n', '        if (decimalsX_ == decimalsY_) {\n', '            // do nothing\n', '        }\n', '        else if (decimalsX_ > decimalsY_) {\n', '            uint256 ddg = (10**decimalsX_).div(10**decimalsY_);\n', '            require (ddg != uint256(0));\n', '            targetSupply = targetSupply.mul(ddg); \n', '        }\n', '        else {\n', '            uint256 ddl = (10**decimalsY_).div(10**decimalsX_);\n', '            require (ddl != uint256(0));\n', '            targetSupply = targetSupply.div(ddl);        \n', '        }\n', '\n', '        int256 delta = int256(SupplyX_).sub(int256(targetSupply));\n', '\n', '        return delta;\n', '    }\n', '}']