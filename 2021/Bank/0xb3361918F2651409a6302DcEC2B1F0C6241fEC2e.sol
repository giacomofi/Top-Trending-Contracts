['pragma solidity >=0.4.0;\n', '\n', '// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', 'library FixedPoint {\n', '    // range: [0, 2**112 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq112x112 {\n', '        uint224 _x;\n', '    }\n', '\n', '    // range: [0, 2**144 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq144x112 {\n', '        uint _x;\n', '    }\n', '\n', '    uint8 private constant RESOLUTION = 112;\n', '\n', '    // encode a uint112 as a UQ112x112\n', '    function encode(uint112 x) internal pure returns (uq112x112 memory) {\n', '        return uq112x112(uint224(x) << RESOLUTION);\n', '    }\n', '\n', '    // encodes a uint144 as a UQ144x112\n', '    function encode144(uint144 x) internal pure returns (uq144x112 memory) {\n', '        return uq144x112(uint256(x) << RESOLUTION);\n', '    }\n', '\n', '    // divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {\n', "        require(x != 0, 'FixedPoint: DIV_BY_ZERO');\n", '        return uq112x112(self._x / uint224(x));\n', '    }\n', '\n', '    // multiply a UQ112x112 by a uint, returning a UQ144x112\n', '    // reverts on overflow\n', '    function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {\n', '        uint z;\n', '        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");\n', '        return uq144x112(z);\n', '    }\n', '\n', '    // returns a UQ112x112 which represents the ratio of the numerator to the denominator\n', '    // equivalent to encode(numerator).div(denominator)\n', '    function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {\n', '        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");\n', '        return uq112x112((uint224(numerator) << RESOLUTION) / denominator);\n', '    }\n', '\n', '    // decode a UQ112x112 into a uint112 by truncating after the radix point\n', '    function decode(uq112x112 memory self) internal pure returns (uint112) {\n', '        return uint112(self._x >> RESOLUTION);\n', '    }\n', '\n', '    // decode a UQ144x112 into a uint144 by truncating after the radix point\n', '    function decode144(uq144x112 memory self) internal pure returns (uint144) {\n', '        return uint144(self._x >> RESOLUTION);\n', '    }\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', "import './IUniswapV2Router01.sol';\n", '\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', "import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';\n", "import '@uniswap/lib/contracts/libraries/FixedPoint.sol';\n", '\n', '// library with helper methods for oracles that are concerned with computing average prices\n', 'library UniswapV2OracleLibrary {\n', '    using FixedPoint for *;\n', '\n', '    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]\n', '    function currentBlockTimestamp() internal view returns (uint32) {\n', '        return uint32(block.timestamp % 2 ** 32);\n', '    }\n', '\n', '    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.\n', '    function currentCumulativePrices(\n', '        address pair\n', '    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {\n', '        blockTimestamp = currentBlockTimestamp();\n', '        price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();\n', '        price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();\n', '\n', '        // if time has elapsed since the last update on the pair, mock the accumulated price values\n', '        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();\n', '        if (blockTimestampLast != blockTimestamp) {\n', '            // subtraction overflow is desired\n', '            uint32 timeElapsed = blockTimestamp - blockTimestampLast;\n', '            // addition overflow is desired\n', '            // counterfactual\n', '            price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;\n', '            // counterfactual\n', '            price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity 0.8.3;\n', '\n', 'import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";\n', 'import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";\n', 'import "@uniswap/lib/contracts/libraries/FixedPoint.sol";\n', '\n', 'import "@uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol";\n', 'import "./interfaces/IOracleSimple.sol";\n', '\n', '// fixed window oracle that recomputes the average price for the entire period once every period\n', '// note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period\n', 'contract OracleSimple is IOracleSimple {\n', '    using FixedPoint for *;\n', '\n', '    /* solhint-disable var-name-mixedcase */\n', '    uint256 public immutable PERIOD;\n', '    IUniswapV2Pair public immutable PAIR;\n', '\n', '    /* solhint-enable */\n', '\n', '    address public immutable token0;\n', '    address public immutable token1;\n', '\n', '    uint256 public price0CumulativeLast;\n', '    uint256 public price1CumulativeLast;\n', '    uint32 public blockTimestampLast;\n', '    FixedPoint.uq112x112 public price0Average;\n', '    FixedPoint.uq112x112 public price1Average;\n', '    bool public isStale;\n', '\n', '    constructor(address _pair, uint256 _period) {\n', '        PERIOD = _period;\n', '        IUniswapV2Pair pair = IUniswapV2Pair(_pair);\n', '        PAIR = pair;\n', '        token0 = pair.token0();\n', '        token1 = pair.token1();\n', '        price0CumulativeLast = pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)\n', '        price1CumulativeLast = pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)\n', '        uint112 reserve0;\n', '        uint112 reserve1;\n', '        (reserve0, reserve1, blockTimestampLast) = pair.getReserves();\n', '        require(reserve0 != 0 && reserve1 != 0, "OracleSimple: NO_RESERVES"); // ensure that there\'s liquidity in the pair\n', '    }\n', '\n', '    function update() external override returns (bool) {\n', '        (\n', '            uint256 price0Cumulative,\n', '            uint256 price1Cumulative,\n', '            uint32 blockTimestamp\n', '        ) = UniswapV2OracleLibrary.currentCumulativePrices(address(PAIR));\n', '        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired\n', '\n', '        // ensure that at least one full period has passed since the last update\n', '        if (timeElapsed < PERIOD) return false;\n', '\n', '        // overflow is desired, casting never truncates\n', '        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed\n', '        price0Average = FixedPoint.uq112x112(\n', '            uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)\n', '        );\n', '        price1Average = FixedPoint.uq112x112(\n', '            uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)\n', '        );\n', '\n', '        price0CumulativeLast = price0Cumulative;\n', '        price1CumulativeLast = price1Cumulative;\n', '        blockTimestampLast = blockTimestamp;\n', '        return true;\n', '    }\n', '\n', '    // note this will always return 0 before update has been called successfully for the first time.\n', '    function consult(address token, uint256 amountIn)\n', '        external\n', '        view\n', '        override\n', '        returns (uint256 amountOut)\n', '    {\n', '        if (token == token0) {\n', '            amountOut = price0Average.mul(amountIn).decode144();\n', '        } else {\n', '            require(token == token1, "OracleSimple: INVALID_TOKEN");\n', '            amountOut = price1Average.mul(amountIn).decode144();\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.8.3;\n', '\n', 'import "./OracleSimple.sol";\n', 'import "./interfaces/ISwapManager.sol";\n', 'import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";\n', 'import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";\n', '\n', 'abstract contract SwapManagerBase is ISwapManager {\n', '    uint256 public constant override N_DEX = 2;\n', '    /* solhint-disable */\n', '    string[N_DEX] public dexes = ["UNISWAP", "SUSHISWAP"];\n', '    address[N_DEX] public override ROUTERS;\n', '    address[N_DEX] public factories;\n', '\n', '    /* solhint-enable */\n', '\n', '    constructor(\n', '        string[2] memory _dexes,\n', '        address[2] memory _routers,\n', '        address[2] memory _factories\n', '    ) {\n', '        dexes = _dexes;\n', '        ROUTERS = _routers;\n', '        factories = _factories;\n', '    }\n', '\n', '    function bestPathFixedInput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn,\n', '        uint256 _i\n', '    ) public view virtual override returns (address[] memory path, uint256 amountOut);\n', '\n', '    function bestPathFixedOutput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountOut,\n', '        uint256 _i\n', '    ) public view virtual override returns (address[] memory path, uint256 amountIn);\n', '\n', '    function bestOutputFixedInput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn\n', '    )\n', '        external\n', '        view\n', '        override\n', '        returns (\n', '            address[] memory path,\n', '            uint256 amountOut,\n', '            uint256 rIdx\n', '        )\n', '    {\n', '        // Iterate through each DEX and evaluate the best output\n', '        for (uint256 i = 0; i < N_DEX; i++) {\n', '            (address[] memory tPath, uint256 tAmountOut) = bestPathFixedInput(\n', '                _from,\n', '                _to,\n', '                _amountIn,\n', '                i\n', '            );\n', '            if (tAmountOut > amountOut) {\n', '                path = tPath;\n', '                amountOut = tAmountOut;\n', '                rIdx = i;\n', '            }\n', '        }\n', '        return (path, amountOut, rIdx);\n', '    }\n', '\n', '    function bestInputFixedOutput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountOut\n', '    )\n', '        external\n', '        view\n', '        override\n', '        returns (\n', '            address[] memory path,\n', '            uint256 amountIn,\n', '            uint256 rIdx\n', '        )\n', '    {\n', '        // Iterate through each DEX and evaluate the best input\n', '        for (uint256 i = 0; i < N_DEX; i++) {\n', '            (address[] memory tPath, uint256 tAmountIn) = bestPathFixedOutput(\n', '                _from,\n', '                _to,\n', '                _amountOut,\n', '                i\n', '            );\n', '            if (amountIn == 0 || tAmountIn < amountIn) {\n', '                if (tAmountIn != 0) {\n', '                    path = tPath;\n', '                    amountIn = tAmountIn;\n', '                    rIdx = i;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    // Rather than let the getAmountsOut call fail due to low liquidity, we\n', '    // catch the error and return 0 in place of the reversion\n', '    // this is useful when we want to proceed with logic\n', '    function safeGetAmountsOut(\n', '        uint256 _amountIn,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) public view override returns (uint256[] memory result) {\n', '        try IUniswapV2Router02(ROUTERS[_i]).getAmountsOut(_amountIn, _path) returns (\n', '            uint256[] memory amounts\n', '        ) {\n', '            result = amounts;\n', '        } catch {\n', '            result = new uint256[](_path.length);\n', '            result[0] = _amountIn;\n', '        }\n', '    }\n', '\n', '    // Just a wrapper for the uniswap call\n', '    // This can fail (revert) in two scenarios\n', '    // 1. (path.length == 2 && insufficient reserves)\n', '    // 2. (path.length > 2 and an intermediate pair has an output amount of 0)\n', '    function unsafeGetAmountsOut(\n', '        uint256 _amountIn,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) external view override returns (uint256[] memory result) {\n', '        result = IUniswapV2Router02(ROUTERS[_i]).getAmountsOut(_amountIn, _path);\n', '    }\n', '\n', '    // Rather than let the getAmountsIn call fail due to low liquidity, we\n', '    // catch the error and return 0 in place of the reversion\n', '    // this is useful when we want to proceed with logic (occurs when amountOut is\n', '    // greater than avaiable reserve (ds-math-sub-underflow)\n', '    function safeGetAmountsIn(\n', '        uint256 _amountOut,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) public view override returns (uint256[] memory result) {\n', '        try IUniswapV2Router02(ROUTERS[_i]).getAmountsIn(_amountOut, _path) returns (\n', '            uint256[] memory amounts\n', '        ) {\n', '            result = amounts;\n', '        } catch {\n', '            result = new uint256[](_path.length);\n', '            result[_path.length - 1] = _amountOut;\n', '        }\n', '    }\n', '\n', '    // Just a wrapper for the uniswap call\n', '    // This can fail (revert) in one scenario\n', '    // 1. amountOut provided is greater than reserve for out currency\n', '    function unsafeGetAmountsIn(\n', '        uint256 _amountOut,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) external view override returns (uint256[] memory result) {\n', '        result = IUniswapV2Router02(ROUTERS[_i]).getAmountsIn(_amountOut, _path);\n', '    }\n', '\n', '    function comparePathsFixedInput(\n', '        address[] memory pathA,\n', '        address[] memory pathB,\n', '        uint256 _amountIn,\n', '        uint256 _i\n', '    ) public view override returns (address[] memory path, uint256 amountOut) {\n', '        path = pathA;\n', '        amountOut = safeGetAmountsOut(_amountIn, pathA, _i)[pathA.length - 1];\n', '        uint256 bAmountOut = safeGetAmountsOut(_amountIn, pathB, _i)[pathB.length - 1];\n', '        if (bAmountOut > amountOut) {\n', '            path = pathB;\n', '            amountOut = bAmountOut;\n', '        }\n', '    }\n', '\n', '    function comparePathsFixedOutput(\n', '        address[] memory pathA,\n', '        address[] memory pathB,\n', '        uint256 _amountOut,\n', '        uint256 _i\n', '    ) public view override returns (address[] memory path, uint256 amountIn) {\n', '        path = pathA;\n', '        amountIn = safeGetAmountsIn(_amountOut, pathA, _i)[0];\n', '        uint256 bAmountIn = safeGetAmountsIn(_amountOut, pathB, _i)[0];\n', '        if (bAmountIn == 0) return (path, amountIn);\n', '        if (amountIn == 0 || bAmountIn < amountIn) {\n', '            path = pathB;\n', '            amountIn = bAmountIn;\n', '        }\n', '    }\n', '\n', '    // TWAP Oracle Factory\n', '    address[] private _oracles;\n', '    mapping(address => bool) private _isOurs;\n', '    // Pair -> period -> oracle\n', '    mapping(address => mapping(uint256 => address)) private _oraclesByPair;\n', '\n', '    function ours(address a) external view override returns (bool) {\n', '        return _isOurs[a];\n', '    }\n', '\n', '    function oracleCount() external view override returns (uint256) {\n', '        return _oracles.length;\n', '    }\n', '\n', '    function oracleAt(uint256 idx) external view override returns (address) {\n', '        require(idx < _oracles.length, "Index exceeds list length");\n', '        return _oracles[idx];\n', '    }\n', '\n', '    function getOracle(\n', '        address _tokenA,\n', '        address _tokenB,\n', '        uint256 _period,\n', '        uint256 _i\n', '    ) external view override returns (address) {\n', '        return _oraclesByPair[IUniswapV2Factory(factories[_i]).getPair(_tokenA, _tokenB)][_period];\n', '    }\n', '\n', '    function createOrUpdateOracle(\n', '        address _tokenA,\n', '        address _tokenB,\n', '        uint256 _period,\n', '        uint256 _i\n', '    ) external override returns (address oracleAddr) {\n', '        address pair = IUniswapV2Factory(factories[_i]).getPair(_tokenA, _tokenB);\n', '        require(pair != address(0), "Nonexistant-pair");\n', '\n', '        // If the oracle exists, try to update it\n', '        if (_oraclesByPair[pair][_period] != address(0)) {\n', '            OracleSimple(_oraclesByPair[pair][_period]).update();\n', '            oracleAddr = _oraclesByPair[pair][_period];\n', '            return oracleAddr;\n', '        }\n', '\n', '        // create new oracle contract\n', '        oracleAddr = address(new OracleSimple(pair, _period));\n', '\n', '        // remember oracle\n', '        _oracles.push(oracleAddr);\n', '        _isOurs[oracleAddr] = true;\n', '        _oraclesByPair[pair][_period] = oracleAddr;\n', '\n', '        // log creation\n', '        emit OracleCreated(msg.sender, oracleAddr, _period);\n', '    }\n', '\n', '    function consultForFree(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn,\n', '        uint256 _period,\n', '        uint256 _i\n', '    ) public view override returns (uint256 amountOut, uint256 lastUpdatedAt) {\n', '        OracleSimple oracle = OracleSimple(\n', '            _oraclesByPair[IUniswapV2Factory(factories[_i]).getPair(_from, _to)][_period]\n', '        );\n', '        lastUpdatedAt = oracle.blockTimestampLast();\n', '        amountOut = oracle.consult(_from, _amountIn);\n', '    }\n', '\n', '    /// get the data we want and pay the gas to update\n', '    function consult(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn,\n', '        uint256 _period,\n', '        uint256 _i\n', '    )\n', '        public\n', '        override\n', '        returns (\n', '            uint256 amountOut,\n', '            uint256 lastUpdatedAt,\n', '            bool updated\n', '        )\n', '    {\n', '        OracleSimple oracle = OracleSimple(\n', '            _oraclesByPair[IUniswapV2Factory(factories[_i]).getPair(_from, _to)][_period]\n', '        );\n', '        lastUpdatedAt = oracle.blockTimestampLast();\n', '        amountOut = oracle.consult(_from, _amountIn);\n', '        try oracle.update() {\n', '            updated = true;\n', '        } catch {\n', '            updated = false;\n', '        }\n', '    }\n', '\n', '    function updateOracles() external override returns (uint256 updated, uint256 expected) {\n', '        expected = _oracles.length;\n', '        for (uint256 i = 0; i < expected; i++) {\n', '            if (OracleSimple(_oracles[i]).update()) updated++;\n', '        }\n', '    }\n', '\n', '    function updateOracles(address[] memory _oracleAddrs)\n', '        external\n', '        override\n', '        returns (uint256 updated, uint256 expected)\n', '    {\n', '        expected = _oracleAddrs.length;\n', '        for (uint256 i = 0; i < expected; i++) {\n', '            if (OracleSimple(_oracleAddrs[i]).update()) updated++;\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.3;\n', '\n', 'import "./OracleSimple.sol";\n', 'import "./SwapManagerBase.sol";\n', 'import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";\n', 'import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";\n', '\n', 'contract SwapManagerEth is SwapManagerBase {\n', '    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '\n', '    /* solhint-enable */\n', '    /** \n', '     UNISWAP: {router: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, factory: 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f}\n', '     SUSHISWAP: {router: 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F, factory: 0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac}\n', '    */\n', '    constructor()\n', '        SwapManagerBase(\n', '            ["UNISWAP", "SUSHISWAP"],\n', '            [\n', '                0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,\n', '                0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F\n', '            ],\n', '            [0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac]\n', '        )\n', '    {}\n', '\n', '    function bestPathFixedInput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn,\n', '        uint256 _i\n', '    ) public view override returns (address[] memory path, uint256 amountOut) {\n', '        path = new address[](2);\n', '        path[0] = _from;\n', '        path[1] = _to;\n', '        if (_from == WETH || _to == WETH) {\n', '            amountOut = safeGetAmountsOut(_amountIn, path, _i)[path.length - 1];\n', '            return (path, amountOut);\n', '        }\n', '\n', '        address[] memory pathB = new address[](3);\n', '        pathB[0] = _from;\n', '        pathB[1] = WETH;\n', '        pathB[2] = _to;\n', '        // is one of these WETH\n', '        if (IUniswapV2Factory(factories[_i]).getPair(_from, _to) == address(0x0)) {\n', '            // does a direct liquidity pair not exist?\n', '            amountOut = safeGetAmountsOut(_amountIn, pathB, _i)[pathB.length - 1];\n', '            path = pathB;\n', '        } else {\n', '            // if a direct pair exists, we want to know whether pathA or path B is better\n', '            (path, amountOut) = comparePathsFixedInput(path, pathB, _amountIn, _i);\n', '        }\n', '    }\n', '\n', '    function bestPathFixedOutput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountOut,\n', '        uint256 _i\n', '    ) public view override returns (address[] memory path, uint256 amountIn) {\n', '        path = new address[](2);\n', '        path[0] = _from;\n', '        path[1] = _to;\n', '        if (_from == WETH || _to == WETH) {\n', '            amountIn = safeGetAmountsIn(_amountOut, path, _i)[0];\n', '            return (path, amountIn);\n', '        }\n', '\n', '        address[] memory pathB = new address[](3);\n', '        pathB[0] = _from;\n', '        pathB[1] = WETH;\n', '        pathB[2] = _to;\n', '\n', '        // is one of these WETH\n', '        if (IUniswapV2Factory(factories[_i]).getPair(_from, _to) == address(0x0)) {\n', '            // does a direct liquidity pair not exist?\n', '            amountIn = safeGetAmountsIn(_amountOut, pathB, _i)[0];\n', '            path = pathB;\n', '        } else {\n', '            // if a direct pair exists, we want to know whether pathA or path B is better\n', '            (path, amountIn) = comparePathsFixedOutput(path, pathB, _amountOut, _i);\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity 0.8.3;\n', '\n', 'interface IOracleSimple {\n', '    function update() external returns (bool);\n', '\n', '    function consult(address token, uint256 amountIn) external view returns (uint256 amountOut);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.3;\n', '\n', 'import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";\n', '\n', '/* solhint-disable func-name-mixedcase */\n', '\n', 'interface ISwapManager {\n', '    event OracleCreated(address indexed _sender, address indexed _newOracle, uint256 _period);\n', '\n', '    function N_DEX() external view returns (uint256);\n', '\n', '    function ROUTERS(uint256 i) external view returns (address);\n', '\n', '    function bestOutputFixedInput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn\n', '    )\n', '        external\n', '        view\n', '        returns (\n', '            address[] memory path,\n', '            uint256 amountOut,\n', '            uint256 rIdx\n', '        );\n', '\n', '    function bestPathFixedInput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn,\n', '        uint256 _i\n', '    ) external view returns (address[] memory path, uint256 amountOut);\n', '\n', '    function bestInputFixedOutput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountOut\n', '    )\n', '        external\n', '        view\n', '        returns (\n', '            address[] memory path,\n', '            uint256 amountIn,\n', '            uint256 rIdx\n', '        );\n', '\n', '    function bestPathFixedOutput(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountOut,\n', '        uint256 _i\n', '    ) external view returns (address[] memory path, uint256 amountIn);\n', '\n', '    function safeGetAmountsOut(\n', '        uint256 _amountIn,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) external view returns (uint256[] memory result);\n', '\n', '    function unsafeGetAmountsOut(\n', '        uint256 _amountIn,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) external view returns (uint256[] memory result);\n', '\n', '    function safeGetAmountsIn(\n', '        uint256 _amountOut,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) external view returns (uint256[] memory result);\n', '\n', '    function unsafeGetAmountsIn(\n', '        uint256 _amountOut,\n', '        address[] memory _path,\n', '        uint256 _i\n', '    ) external view returns (uint256[] memory result);\n', '\n', '    function comparePathsFixedInput(\n', '        address[] memory pathA,\n', '        address[] memory pathB,\n', '        uint256 _amountIn,\n', '        uint256 _i\n', '    ) external view returns (address[] memory path, uint256 amountOut);\n', '\n', '    function comparePathsFixedOutput(\n', '        address[] memory pathA,\n', '        address[] memory pathB,\n', '        uint256 _amountOut,\n', '        uint256 _i\n', '    ) external view returns (address[] memory path, uint256 amountIn);\n', '\n', '    function ours(address a) external view returns (bool);\n', '\n', '    function oracleCount() external view returns (uint256);\n', '\n', '    function oracleAt(uint256 idx) external view returns (address);\n', '\n', '    function getOracle(\n', '        address _tokenA,\n', '        address _tokenB,\n', '        uint256 _period,\n', '        uint256 _i\n', '    ) external view returns (address);\n', '\n', '    function createOrUpdateOracle(\n', '        address _tokenA,\n', '        address _tokenB,\n', '        uint256 _period,\n', '        uint256 _i\n', '    ) external returns (address oracleAddr);\n', '\n', '    function consultForFree(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn,\n', '        uint256 _period,\n', '        uint256 _i\n', '    ) external view returns (uint256 amountOut, uint256 lastUpdatedAt);\n', '\n', '    /// get the data we want and pay the gas to update\n', '    function consult(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amountIn,\n', '        uint256 _period,\n', '        uint256 _i\n', '    )\n', '        external\n', '        returns (\n', '            uint256 amountOut,\n', '            uint256 lastUpdatedAt,\n', '            bool updated\n', '        );\n', '\n', '    function updateOracles() external returns (uint256 updated, uint256 expected);\n', '\n', '    function updateOracles(address[] memory _oracleAddrs)\n', '        external\n', '        returns (uint256 updated, uint256 expected);\n', '}\n', '\n', '{\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "metadata": {\n', '    "bytecodeHash": "ipfs",\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']