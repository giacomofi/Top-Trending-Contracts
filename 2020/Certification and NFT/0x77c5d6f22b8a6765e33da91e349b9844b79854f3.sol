['// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', 'pragma solidity =0.6.6;\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', '\n', '\n', '// computes square roots using the babylonian method\n', '// https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method\n', 'library Babylonian {\n', '    function sqrt(uint y) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '        // else z = 0\n', '    }\n', '}\n', '\n', '\n', '// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', 'library FixedPoint {\n', '    // range: [0, 2**112 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq112x112 {\n', '        uint224 _x;\n', '    }\n', '\n', '    // range: [0, 2**144 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq144x112 {\n', '        uint _x;\n', '    }\n', '\n', '    uint8 private constant RESOLUTION = 112;\n', '    uint private constant Q112 = uint(1) << RESOLUTION;\n', '    uint private constant Q224 = Q112 << RESOLUTION;\n', '\n', '    // encode a uint112 as a UQ112x112\n', '    function encode(uint112 x) internal pure returns (uq112x112 memory) {\n', '        return uq112x112(uint224(x) << RESOLUTION);\n', '    }\n', '\n', '    // encodes a uint144 as a UQ144x112\n', '    function encode144(uint144 x) internal pure returns (uq144x112 memory) {\n', '        return uq144x112(uint256(x) << RESOLUTION);\n', '    }\n', '\n', '    // divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {\n', "        require(x != 0, 'FixedPoint: DIV_BY_ZERO');\n", '        return uq112x112(self._x / uint224(x));\n', '    }\n', '\n', '    // multiply a UQ112x112 by a uint, returning a UQ144x112\n', '    // reverts on overflow\n', '    function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {\n', '        uint z;\n', '        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");\n', '        return uq144x112(z);\n', '    }\n', '\n', '    // returns a UQ112x112 which represents the ratio of the numerator to the denominator\n', '    // equivalent to encode(numerator).div(denominator)\n', '    function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {\n', '        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");\n', '        return uq112x112((uint224(numerator) << RESOLUTION) / denominator);\n', '    }\n', '\n', '    // decode a UQ112x112 into a uint112 by truncating after the radix point\n', '    function decode(uq112x112 memory self) internal pure returns (uint112) {\n', '        return uint112(self._x >> RESOLUTION);\n', '    }\n', '\n', '    // decode a UQ144x112 into a uint144 by truncating after the radix point\n', '    function decode144(uq144x112 memory self) internal pure returns (uint144) {\n', '        return uint144(self._x >> RESOLUTION);\n', '    }\n', '\n', '    // take the reciprocal of a UQ112x112\n', '    function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {\n', "        require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');\n", '        return uq112x112(uint224(Q224 / self._x));\n', '    }\n', '\n', '    // square root of a UQ112x112\n', '    function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {\n', '        return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));\n', '    }\n', '}\n', '\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '\n', 'library UniswapV2Library {\n', '    using SafeMath for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// library with helper methods for oracles that are concerned with computing average prices\n', 'library UniswapV2OracleLibrary {\n', '    using FixedPoint for *;\n', '\n', '    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]\n', '    function currentBlockTimestamp() internal view returns (uint32) {\n', '        return uint32(block.timestamp % 2 ** 32);\n', '    }\n', '\n', '    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.\n', '    function currentCumulativePrices(\n', '        address pair\n', '    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {\n', '        blockTimestamp = currentBlockTimestamp();\n', '        price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();\n', '        price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();\n', '\n', '        // if time has elapsed since the last update on the pair, mock the accumulated price values\n', '        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();\n', '        if (blockTimestampLast != blockTimestamp) {\n', '            // subtraction overflow is desired\n', '            uint32 timeElapsed = blockTimestamp - blockTimestampLast;\n', '            // addition overflow is desired\n', '            // counterfactual\n', '            price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;\n', '            // counterfactual\n', '            price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;\n', '        }\n', '    }\n', '}\n', '\n', '// fixed window oracle that recomputes the average price for the entire period once every period\n', '// note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period\n', 'contract ExampleOracleSimple {\n', '    using FixedPoint for *;\n', '\n', '    uint public constant PERIOD = 10 minutes;\n', '\n', '    IUniswapV2Pair immutable pair;\n', '    address public immutable token0;\n', '    address public immutable token1;\n', '\n', '    uint    public price0CumulativeLast;\n', '    uint    public price1CumulativeLast;\n', '    uint32  public blockTimestampLast;\n', '    FixedPoint.uq112x112 public price0Average;\n', '    FixedPoint.uq112x112 public price1Average;\n', '\n', '    constructor(address factory, address tokenA, address tokenB) public {\n', '        IUniswapV2Pair _pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));\n', '        pair = _pair;\n', '        token0 = _pair.token0();\n', '        token1 = _pair.token1();\n', '        price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)\n', '        price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)\n', '        uint112 reserve0;\n', '        uint112 reserve1;\n', '        (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();\n', "        require(reserve0 != 0 && reserve1 != 0, 'ExampleOracleSimple: NO_RESERVES'); // ensure that there's liquidity in the pair\n", '    }\n', '\n', '    function update() external {\n', '        (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =\n', '            UniswapV2OracleLibrary.currentCumulativePrices(address(pair));\n', '        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired\n', '\n', '        // ensure that at least one full period has passed since the last update\n', "        require(timeElapsed >= PERIOD, 'ExampleOracleSimple: PERIOD_NOT_ELAPSED');\n", '\n', '        // overflow is desired, casting never truncates\n', '        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed\n', '        price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));\n', '        price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));\n', '\n', '        price0CumulativeLast = price0Cumulative;\n', '        price1CumulativeLast = price1Cumulative;\n', '        blockTimestampLast = blockTimestamp;\n', '    }\n', '\n', '    // note this will always return 0 before update has been called successfully for the first time.\n', '    function consult(address token, uint amountIn) external view returns (uint amountOut) {\n', '        if (token == token0) {\n', '            amountOut = price0Average.mul(amountIn).decode144();\n', '        } else {\n', "            require(token == token1, 'ExampleOracleSimple: INVALID_TOKEN');\n", '            amountOut = price1Average.mul(amountIn).decode144();\n', '        }\n', '    }\n', '}']