['// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "../interfaces/IUniswapV2Pair.sol";\n', 'import "../interfaces/IUniswapV2Factory.sol";\n', 'import "../interfaces/IPriceOracle.sol";\n', 'import "../misc/SafeMath.sol";\n', 'import "../misc/Math.sol";\n', '\n', '/** @title UniswapV2PriceProvider\n', ' * @notice Price provider for a Uniswap V2 pair token\n', " * It calculates the price using Chainlink as an external price source and the pair's tokens reserves using the weighted arithmetic mean formula.\n", ' * If there is a price deviation, instead of the reserves, it uses a weighted geometric mean with the constant invariant K.\n', ' */\n', '\n', 'contract UniswapV2PriceProvider {\n', '    using SafeMath for uint256;\n', '\n', '    IUniswapV2Pair public immutable pair;\n', '    address[] public tokens;\n', '    bool[] public isPeggedToEth;\n', '    uint8[] public decimals;\n', '    IPriceOracle immutable priceOracle;\n', '    uint256 public immutable maxPriceDeviation;\n', '\n', '    /**\n', '     * UniswapV2PriceProvider constructor.\n', '     * @param _pair Uniswap V2 pair address.\n', '     * @param _isPeggedToEth For each token, true if it is pegged to ETH.\n', '     * @param _decimals Number of decimals for each token.\n', '     * @param _priceOracle Aave price oracle.\n', '     * @param _maxPriceDeviation Threshold of spot prices deviation: 10ˆ16 represents a 1% deviation.\n', '     */\n', '    constructor(\n', '        IUniswapV2Pair _pair,\n', '        bool[] memory _isPeggedToEth,\n', '        uint8[] memory _decimals,\n', '        IPriceOracle _priceOracle,\n', '        uint256 _maxPriceDeviation\n', '    ) public {\n', '        require(_isPeggedToEth.length == 2, "ERR_INVALID_PEGGED_LENGTH");\n', '        require(_decimals.length == 2, "ERR_INVALID_DECIMALS_LENGTH");\n', '        require(\n', '            _decimals[0] <= 18 && _decimals[1] <= 18,\n', '            "ERR_INVALID_DECIMALS"\n', '        );\n', '        require(\n', '            address(_priceOracle) != address(0),\n', '            "ERR_INVALID_PRICE_PROVIDER"\n', '        );\n', '        require(_maxPriceDeviation < Math.BONE, "ERR_INVALID_PRICE_DEVIATION");\n', '\n', '        pair = _pair;\n', '        //Get tokens\n', '        tokens.push(_pair.token0());\n', '        tokens.push(_pair.token1());\n', '        isPeggedToEth = _isPeggedToEth;\n', '        decimals = _decimals;\n', '        priceOracle = _priceOracle;\n', '        maxPriceDeviation = _maxPriceDeviation;\n', '    }\n', '\n', '    /**\n', '     * Returns the token balance in ethers by multiplying its reserves with its price in ethers.\n', '     * @param index Token index.\n', '     * @param reserve Token reserves.\n', '     */\n', '    function getEthBalanceByToken(uint256 index, uint112 reserve)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        uint256 pi = isPeggedToEth[index]\n', '            ? Math.BONE\n', '            : uint256(priceOracle.getAssetPrice(tokens[index]));\n', '        require(pi > 0, "ERR_NO_ORACLE_PRICE");\n', '        uint256 missingDecimals = uint256(18).sub(decimals[index]);\n', '        uint256 bi = uint256(reserve).mul(10**(missingDecimals));\n', '        return Math.bmul(bi, pi);\n', '    }\n', '\n', '    /**\n', '     * Returns true if there is a price deviation.\n', '     * @param ethTotal_0 Total eth for token 0.\n', '     * @param ethTotal_1 Total eth for token 1.\n', '     */\n', '    function hasDeviation(uint256 ethTotal_0, uint256 ethTotal_1)\n', '        internal\n', '        view\n', '        returns (bool)\n', '    {\n', '        //Check for a price deviation\n', '        uint256 price_deviation = Math.bdiv(ethTotal_0, ethTotal_1); \n', '        if (\n', '            price_deviation > (Math.BONE.add(maxPriceDeviation)) ||\n', '            price_deviation < (Math.BONE.sub(maxPriceDeviation))\n', '        ) {\n', '            return true;\n', '        }\n', '        price_deviation = Math.bdiv(ethTotal_1, ethTotal_0);\n', '        if (\n', '            price_deviation > (Math.BONE.add(maxPriceDeviation)) ||\n', '            price_deviation < (Math.BONE.sub(maxPriceDeviation))\n', '        ) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * Calculates the price of the pair token using the formula of arithmetic mean.\n', '     * @param ethTotal_0 Total eth for token 0.\n', '     * @param ethTotal_1 Total eth for token 1.\n', '     */\n', '    function getArithmeticMean(uint256 ethTotal_0, uint256 ethTotal_1)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        uint256 totalEth = ethTotal_0 + ethTotal_1;\n', '        return Math.bdiv(totalEth, getTotalSupplyAtWithdrawal());\n', '    }\n', '\n', '    /**\n', '     * Calculates the price of the pair token using the formula of weighted geometric mean.\n', '     * @param ethTotal_0 Total eth for token 0.\n', '     * @param ethTotal_1 Total eth for token 1.\n', '     */\n', '    function getWeightedGeometricMean(uint256 ethTotal_0, uint256 ethTotal_1)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        uint256 square = Math.bsqrt(Math.bmul(ethTotal_0, ethTotal_1), true);\n', '        return\n', '            Math.bdiv(\n', '                Math.bmul(Math.TWO_BONES, square),\n', '                getTotalSupplyAtWithdrawal()\n', '            );\n', '    }\n', '\n', '    /**\n', "     * Returns the pair's token price.\n", "     * It calculates the price using Chainlink as an external price source and the pair's tokens reserves using the arithmetic mean formula.\n", '     * If there is a price deviation, instead of the reserves, it uses a weighted geometric mean with constant invariant K.\n', '     */\n', '    function latestAnswer() external view returns (uint256) {\n', '        //Get token reserves in ethers\n', '        (uint112 reserve_0, uint112 reserve_1, ) = pair.getReserves();\n', '        uint256 ethTotal_0 = getEthBalanceByToken(0, reserve_0);\n', '        uint256 ethTotal_1 = getEthBalanceByToken(1, reserve_1);\n', '\n', '        if (hasDeviation(ethTotal_0, ethTotal_1)) {\n', '            //Calculate the weighted geometric mean\n', '            return getWeightedGeometricMean(ethTotal_0, ethTotal_1);\n', '        } else {\n', '            //Calculate the arithmetic mean\n', '            return getArithmeticMean(ethTotal_0, ethTotal_1);\n', '        }\n', '    }\n', '\n', '    \n', '    /**\n', '     * Returns Uniswap V2 pair total supply at the time of withdrawal.\n', '     */\n', '    function getTotalSupplyAtWithdrawal()\n', '        private\n', '        view\n', '        returns (uint256 totalSupply)\n', '    {\n', '        totalSupply = pair.totalSupply();\n', '        address feeTo = IUniswapV2Factory(IUniswapV2Pair(pair).factory())\n', '            .feeTo();\n', '        bool feeOn = feeTo != address(0);\n', '        if (feeOn) {\n', '            uint256 kLast = IUniswapV2Pair(pair).kLast();\n', '            if (kLast != 0) {\n', '                (uint112 reserve_0, uint112 reserve_1, ) = pair.getReserves();\n', '                uint256 rootK = Math.bsqrt(\n', '                    uint256(reserve_0).mul(reserve_1),\n', '                    false\n', '                );\n', '                uint256 rootKLast = Math.bsqrt(kLast, false);\n', '                if (rootK > rootKLast) {\n', '                    uint256 numerator = totalSupply.mul(rootK.sub(rootKLast));\n', '                    uint256 denominator = rootK.mul(5).add(rootKLast);\n', '                    uint256 liquidity = numerator / denominator;\n', '                    totalSupply = totalSupply.add(liquidity);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns Uniswap V2 pair address.\n', '     */\n', '    function getPair() external view returns (IUniswapV2Pair) {\n', '        return pair;\n', '    }\n', '\n', '    /**\n', '     * Returns all tokens.\n', '     */\n', '    function getTokens() external view returns (address[] memory) {\n', '        return tokens;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IUniswapV2Pair {\n', '  function totalSupply() external view returns (uint);\n', '  function token0() external view returns (address);\n', '  function token1() external view returns (address);\n', '  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '  function kLast() external view returns (uint);\n', '  function factory() external view returns (address);\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IUniswapV2Factory {\n', '    function feeTo() external view returns (address);\n', '}\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.6.12;\n', '\n', '/************\n', '@title IPriceOracle interface\n', '@notice Interface for the Aave price oracle.*/\n', 'interface IPriceOracle {\n', '    /***********\n', '    @dev returns the asset price in ETH\n', '     */\n', '    function getAssetPrice(address _asset) external view returns (uint256);\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.6.12;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.6.12;\n', '\n', '// a library for performing various math operations\n', '\n', 'library Math {\n', '    uint256 public constant BONE        = 10**18;\n', '    uint256 public constant TWO_BONES   = 2*10**18;\n', '\n', '    /**\n', '     * @notice Returns the square root of an uint256 x using the Babylonian method\n', '     * @param y The number to calculate the sqrt from\n', '     * @param bone True when y has 18 decimals\n', '     */\n', '    function bsqrt(uint y, bool bone) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                if(bone) {\n', '                    x = (bdiv(y, x) + x) / 2;\n', '                }\n', '                else {\n', '                    x = (y / x + x) / 2;\n', '                }\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '\n', '    function bmul(uint a, uint b) //Bone mul\n', '        internal pure\n', '        returns (uint)\n', '    {\n', '        uint c0 = a * b;\n', '        require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");\n', '        uint c1 = c0 + (BONE / 2);\n', '        require(c1 >= c0, "ERR_MUL_OVERFLOW");\n', '        uint c2 = c1 / BONE;\n', '        return c2;\n', '    }\n', '\n', '    function bdiv(uint a, uint b) //Bone div\n', '        internal pure\n', '        returns (uint)\n', '    {\n', '        require(b != 0, "ERR_DIV_ZERO");\n', '        uint c0 = a * BONE;\n', '        require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow\n', '        uint c1 = c0 + (b / 2);\n', '        require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require\n', '        uint c2 = c1 / b;\n', '        return c2;\n', '    }\n', '}']