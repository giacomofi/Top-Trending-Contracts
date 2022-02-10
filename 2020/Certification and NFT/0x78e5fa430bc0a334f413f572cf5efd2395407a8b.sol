['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', 'library FixedPoint {\n', '    // range: [0, 2**112 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq112x112 {\n', '        uint224 _x;\n', '    }\n', '\n', '    // range: [0, 2**144 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq144x112 {\n', '        uint _x;\n', '    }\n', '\n', '    uint8 private constant RESOLUTION = 112;\n', '\n', '    // encode a uint112 as a UQ112x112\n', '    function encode(uint112 x) internal pure returns (uq112x112 memory) {\n', '        return uq112x112(uint224(x) << RESOLUTION);\n', '    }\n', '\n', '    // encodes a uint144 as a UQ144x112\n', '    function encode144(uint144 x) internal pure returns (uq144x112 memory) {\n', '        return uq144x112(uint256(x) << RESOLUTION);\n', '    }\n', '\n', '    // divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {\n', "        require(x != 0, 'FixedPoint: DIV_BY_ZERO');\n", '        return uq112x112(self._x / uint224(x));\n', '    }\n', '\n', '    // multiply a UQ112x112 by a uint, returning a UQ144x112\n', '    // reverts on overflow\n', '    function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {\n', '        uint z;\n', '        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");\n', '        return uq144x112(z);\n', '    }\n', '\n', '    // returns a UQ112x112 which represents the ratio of the numerator to the denominator\n', '    // equivalent to encode(numerator).div(denominator)\n', '    function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {\n', '        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");\n', '        return uq112x112((uint224(numerator) << RESOLUTION) / denominator);\n', '    }\n', '\n', '    // decode a UQ112x112 into a uint112 by truncating after the radix point\n', '    function decode(uq112x112 memory self) internal pure returns (uint112) {\n', '        return uint112(self._x >> RESOLUTION);\n', '    }\n', '\n', '    // decode a UQ144x112 into a uint144 by truncating after the radix point\n', '    function decode144(uq144x112 memory self) internal pure returns (uint144) {\n', '        return uint144(self._x >> RESOLUTION);\n', '    }\n', '}\n', '\n', '// library with helper methods for oracles that are concerned with computing average prices\n', 'library UniswapV2OracleLibrary {\n', '    using FixedPoint for *;\n', '\n', '    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]\n', '    function currentBlockTimestamp() internal view returns (uint32) {\n', '        return uint32(block.timestamp % 2 ** 32);\n', '    }\n', '\n', '    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.\n', '    function currentCumulativePrices(\n', '        address pair\n', '    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {\n', '        blockTimestamp = currentBlockTimestamp();\n', '        price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();\n', '        price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();\n', '\n', '        // if time has elapsed since the last update on the pair, mock the accumulated price values\n', '        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();\n', '        if (blockTimestampLast != blockTimestamp) {\n', '            // subtraction overflow is desired\n', '            uint32 timeElapsed = blockTimestamp - blockTimestampLast;\n', '            // addition overflow is desired\n', '            // counterfactual\n', '            price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;\n', '            // counterfactual\n', '            price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;\n', '        }\n', '    }\n', '}\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', 'library UniswapV2Library {\n', '    using SafeMath for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', 'interface IKeep3r {\n', '    function isKeeper(address) external returns (bool);\n', '    function worked(address keeper) external;\n', '}\n', '\n', '// sliding window oracle that uses observations collected over a window to provide moving price averages in the past\n', '// `windowSize` with a precision of `windowSize / granularity`\n', 'contract UniswapV2Oracle {\n', '    using FixedPoint for *;\n', '    using SafeMath for uint;\n', '\n', '    struct Observation {\n', '        uint timestamp;\n', '        uint price0Cumulative;\n', '        uint price1Cumulative;\n', '    }\n', '    \n', '    modifier upkeep() {\n', '      require(KPR.isKeeper(msg.sender), "::isKeeper: keeper is not registered");\n', '      _;\n', '      KPR.worked(msg.sender);\n', '    }\n', '    \n', '    address public governance;\n', '    address public pendingGovernance;\n', '    \n', '    /**\n', '     * @notice Allows governance to change governance (for future upgradability)\n', '     * @param _governance new governance address to set\n', '     */\n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "setGovernance: !gov");\n', '        pendingGovernance = _governance;\n', '    }\n', '\n', '    /**\n', '     * @notice Allows pendingGovernance to accept their role as governance (protection pattern)\n', '     */\n', '    function acceptGovernance() external {\n', '        require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");\n', '        governance = pendingGovernance;\n', '    }\n', '    \n', '    IKeep3r public constant KPR = IKeep3r(0xB63650C42d6fCcA02f5353A711cB85400dB6a8FE);\n', '\n', '    address public immutable factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '    // the desired amount of time over which the moving average should be computed, e.g. 24 hours\n', '    uint public immutable windowSize = 14400;\n', '    // the number of observations stored for each pair, i.e. how many price observations are stored for the window.\n', '    // as granularity increases from 1, more frequent updates are needed, but moving averages become more precise.\n', '    // averages are computed over intervals with sizes in the range:\n', '    //   [windowSize - (windowSize / granularity) * 2, windowSize]\n', '    // e.g. if the window size is 24 hours, and the granularity is 24, the oracle will return the average price for\n', '    //   the period:\n', '    //   [now - [22 hours, 24 hours], now]\n', '    uint8 public immutable granularity = 8;\n', '    // this is redundant with granularity and windowSize, but stored for gas savings & informational purposes.\n', '    uint public immutable periodSize = 1800;\n', '    \n', '    address[] internal _pairs;\n', '    mapping(address => bool) internal _known;\n', '    mapping(address => uint) public lastUpdated;\n', '    \n', '    function pairs() external view returns (address[] memory) {\n', '        return _pairs;\n', '    }\n', '\n', '    // mapping from pair address to a list of price observations of that pair\n', '    mapping(address => Observation[]) public pairObservations;\n', '\n', '    constructor() public {\n', '        governance = msg.sender;\n', '    }\n', '\n', '    // returns the index of the observation corresponding to the given timestamp\n', '    function observationIndexOf(uint timestamp) public view returns (uint8 index) {\n', '        uint epochPeriod = timestamp / periodSize;\n', '        return uint8(epochPeriod % granularity);\n', '    }\n', '\n', '    // returns the observation from the oldest epoch (at the beginning of the window) relative to the current time\n', '    function getFirstObservationInWindow(address pair) private view returns (Observation storage firstObservation) {\n', '        uint8 observationIndex = observationIndexOf(block.timestamp);\n', '        // no overflow issue. if observationIndex + 1 overflows, result is still zero.\n', '        uint8 firstObservationIndex = (observationIndex + 1) % granularity;\n', '        firstObservation = pairObservations[pair][firstObservationIndex];\n', '    }\n', '    \n', '    function updatePair(address pair) external returns (bool) {\n', '        return _update(pair);\n', '    }\n', '\n', '    // update the cumulative price for the observation at the current timestamp. each observation is updated at most\n', '    // once per epoch period.\n', '    function update(address tokenA, address tokenB) external returns (bool) {\n', '        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);\n', '        return _update(pair);\n', '    }\n', '    \n', '    function add(address tokenA, address tokenB) external {\n', '        require(msg.sender == governance, "UniswapV2Oracle::add: !gov");\n', '        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);\n', '        require(!_known[pair], "known");\n', '        _known[pair] = true;\n', '        _pairs.push(pair);\n', '    }\n', '    \n', '    function work() public upkeep {\n', '        bool worked = updateAll();\n', '        require(worked, "UniswapV2Oracle: no work");\n', '    }\n', '    \n', '    function updateAll() public returns (bool updated) {\n', '        for (uint i = 0; i < _pairs.length; i++) {\n', '            if (_update(_pairs[i])) {\n', '                updated = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function updateFor(uint i, uint length) external returns (bool updated) {\n', '        for (; i < length; i++) {\n', '            if (_update(_pairs[i])) {\n', '                updated = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function updateableList() external view returns (address[] memory list) {\n', '        uint _index = 0;\n', '        for (uint i = 0; i < _pairs.length; i++) {\n', '            if (updateable(_pairs[i])) {\n', '               list[_index++] = _pairs[i];\n', '            }\n', '        }\n', '    }\n', '    \n', '    function updateable(address pair) public view returns (bool) {\n', '        return (block.timestamp - lastUpdated[pair]) > periodSize;\n', '    }\n', '    \n', '    function updateable() external view returns (bool) {\n', '        for (uint i = 0; i < _pairs.length; i++) {\n', '            if (updateable(_pairs[i])) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function updateableFor(uint i, uint length) external view returns (bool) {\n', '        for (; i < length; i++) {\n', '            if (updateable(_pairs[i])) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function _update(address pair) internal returns (bool) {\n', '        // populate the array with empty observations (first call only)\n', '        for (uint i = pairObservations[pair].length; i < granularity; i++) {\n', '            pairObservations[pair].push();\n', '        }\n', '\n', '        // get the observation for the current period\n', '        uint8 observationIndex = observationIndexOf(block.timestamp);\n', '        Observation storage observation = pairObservations[pair][observationIndex];\n', '\n', '        // we only want to commit updates once per period (i.e. windowSize / granularity)\n', '        uint timeElapsed = block.timestamp - observation.timestamp;\n', '        if (timeElapsed > periodSize) {\n', '            (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);\n', '            observation.timestamp = block.timestamp;\n', '            lastUpdated[pair] = block.timestamp;\n', '            observation.price0Cumulative = price0Cumulative;\n', '            observation.price1Cumulative = price1Cumulative;\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '\n', '    // given the cumulative prices of the start and end of a period, and the length of the period, compute the average\n', '    // price in terms of how much amount out is received for the amount in\n', '    function computeAmountOut(\n', '        uint priceCumulativeStart, uint priceCumulativeEnd,\n', '        uint timeElapsed, uint amountIn\n', '    ) private pure returns (uint amountOut) {\n', '        // overflow is desired.\n', '        FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(\n', '            uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)\n', '        );\n', '        amountOut = priceAverage.mul(amountIn).decode144();\n', '    }\n', '\n', '    // returns the amount out corresponding to the amount in for a given token using the moving average over the time\n', '    // range [now - [windowSize, windowSize - periodSize * 2], now]\n', '    // update must have been called for the bucket corresponding to timestamp `now - windowSize`\n', '    function consult(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {\n', '        address pair = UniswapV2Library.pairFor(factory, tokenIn, tokenOut);\n', '        Observation storage firstObservation = getFirstObservationInWindow(pair);\n', '\n', '        uint timeElapsed = block.timestamp - firstObservation.timestamp;\n', "        require(timeElapsed <= windowSize, 'SlidingWindowOracle: MISSING_HISTORICAL_OBSERVATION');\n", '        // should never happen.\n', "        require(timeElapsed >= windowSize - periodSize * 2, 'SlidingWindowOracle: UNEXPECTED_TIME_ELAPSED');\n", '\n', '        (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.currentCumulativePrices(pair);\n', '        (address token0,) = UniswapV2Library.sortTokens(tokenIn, tokenOut);\n', '\n', '        if (token0 == tokenIn) {\n', '            return computeAmountOut(firstObservation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);\n', '        } else {\n', '            return computeAmountOut(firstObservation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);\n', '        }\n', '    }\n', '}']