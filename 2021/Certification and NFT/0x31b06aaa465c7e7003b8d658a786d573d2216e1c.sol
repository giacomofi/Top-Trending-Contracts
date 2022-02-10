['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-18\n', '*/\n', '\n', '// SPDX-License-Identifier: bsl-1.1\n', '\n', 'pragma solidity ^0.8.1;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/**\n', ' * @dev Standard math utilities missing in the Solidity language.\n', ' */\n', 'library Math {\n', '    /**\n', '     * @dev Returns the largest of two numbers.\n', '     */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', 'interface IKeep3rV1Oracle {\n', '    function quote(address tokenIn, uint amountIn, address tokenOut, uint granularity) external view returns (uint);\n', '    function current(address tokenIn, uint amountIn, address tokenOut) external view returns (uint);\n', '}\n', '\n', '\n', 'interface ISushiswapV2Pair {\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function sync() external;\n', '}\n', '\n', 'library SushiswapV2Library {\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function sushiPairFor(address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint160(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash\n", '            )))));\n', '    }\n', '    \n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function uniPairFor(address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint160(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            )))));\n', '    }\n', '\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address pair, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pair).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '}\n', '\n', 'interface IChainLinkFeedsRegistry {\n', '    function getPriceETH(address tokenIn) external view returns (uint);\n', '}\n', '\n', 'contract Keep3rV1OracleUSD  {\n', '    \n', '    struct LiquidityParams {\n', '        uint sReserveA;\n', '        uint sReserveB;\n', '        uint uReserveA;\n', '        uint uReserveB;\n', '        uint sLiquidity;\n', '        uint uLiquidity;\n', '    }\n', '    \n', '    struct QuoteParams {\n', '        uint quoteOut;\n', '        uint amountOut;\n', '        uint currentOut;\n', '        uint sTWAP;\n', '        uint uTWAP;\n', '        uint sCUR;\n', '        uint uCUR;\n', '        uint cl;\n', '    }\n', '    \n', '    IKeep3rV1Oracle public constant sushiswapV1Oracle = IKeep3rV1Oracle(0xf67Ab1c914deE06Ba0F264031885Ea7B276a7cDa);\n', '    IKeep3rV1Oracle public constant uniswapV1Oracle = IKeep3rV1Oracle(0x73353801921417F465377c8d898c6f4C0270282C);\n', '    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;\n', '    IChainLinkFeedsRegistry constant chainlink = IChainLinkFeedsRegistry(0x271bf4568fb737cc2e6277e9B1EE0034098cDA2a);\n', '\n', '    function assetToUsd(address tokenIn, uint amountIn, uint granularity) public view returns (QuoteParams memory q, LiquidityParams memory l) {\n', '        (q,) = assetToEth(tokenIn, amountIn, granularity);\n', '        return ethToUsd(q.amountOut, granularity);\n', '    }\n', '    \n', '    function assetToEth(address tokenIn, uint amountIn, uint granularity) public view returns (QuoteParams memory q, LiquidityParams memory l) {\n', '        q.sTWAP = sushiswapV1Oracle.quote(tokenIn, amountIn, WETH, granularity);\n', '        q.uTWAP = uniswapV1Oracle.quote(tokenIn, amountIn, WETH, granularity);\n', '        q.sCUR = sushiswapV1Oracle.current(tokenIn, amountIn, WETH);\n', '        q.uCUR = uniswapV1Oracle.current(tokenIn, amountIn, WETH);\n', '        q.cl = chainlink.getPriceETH(tokenIn) * amountIn / 10 ** 18;\n', '        l = getLiquidity(tokenIn, WETH);\n', '        \n', '        q.amountOut = (q.sTWAP * l.sLiquidity + q.uTWAP * l.uLiquidity) / (l.sLiquidity + l.uLiquidity);\n', '        q.currentOut = (q.sCUR * l.sLiquidity + q.uCUR * l.uLiquidity) / (l.sLiquidity + l.uLiquidity);\n', '        q.quoteOut = Math.min(Math.min(q.amountOut, q.currentOut), q.cl);\n', '    }\n', '    \n', '    function ethToAsset(uint amountIn, address tokenOut, uint granularity) public view returns (QuoteParams memory q, LiquidityParams memory l) {\n', '        q.sTWAP = sushiswapV1Oracle.quote(WETH, amountIn, tokenOut, granularity);\n', '        q.uTWAP = uniswapV1Oracle.quote(WETH, amountIn, tokenOut, granularity);\n', '        q.sCUR = sushiswapV1Oracle.current(WETH, amountIn, tokenOut);\n', '        q.uCUR = uniswapV1Oracle.current(WETH, amountIn, tokenOut);\n', '        q.cl = amountIn * 10 ** 18 / chainlink.getPriceETH(tokenOut);\n', '        l = getLiquidity(WETH, tokenOut);\n', '        \n', '        q.amountOut = (q.sTWAP * l.sLiquidity + q.uTWAP * l.uLiquidity) / (l.sLiquidity + l.uLiquidity);\n', '        q.currentOut = (q.sCUR * l.sLiquidity + q.uCUR * l.uLiquidity) / (l.sLiquidity + l.uLiquidity);\n', '        q.quoteOut = Math.min(q.amountOut, q.currentOut);\n', '        q.quoteOut = Math.min(Math.min(q.amountOut, q.currentOut), q.cl);\n', '    }\n', '    \n', '    function ethToUsd(uint amountIn, uint granularity) public view returns (QuoteParams memory q, LiquidityParams memory l) {\n', '        return assetToAsset(WETH, amountIn, DAI, granularity);\n', '    }\n', '    \n', '    function pairFor(address tokenA, address tokenB) external pure returns (address sPair, address uPair) {\n', '        sPair = SushiswapV2Library.sushiPairFor(tokenA, tokenB);\n', '        uPair = SushiswapV2Library.uniPairFor(tokenA, tokenB);\n', '    }\n', '    \n', '    function sPairFor(address tokenA, address tokenB) external pure returns (address sPair) {\n', '        sPair = SushiswapV2Library.sushiPairFor(tokenA, tokenB);\n', '    }\n', '    \n', '    function uPairFor(address tokenA, address tokenB) external pure returns (address uPair) {\n', '        uPair = SushiswapV2Library.uniPairFor(tokenA, tokenB);\n', '    }\n', '    \n', '    function getLiquidity(address tokenA, address tokenB) public view returns (LiquidityParams memory l) {\n', '        address sPair = SushiswapV2Library.sushiPairFor(tokenA, tokenB);\n', '        address uPair = SushiswapV2Library.uniPairFor(tokenA, tokenB);\n', '        (l.sReserveA, l.sReserveB) =  SushiswapV2Library.getReserves(sPair, tokenA, tokenB);\n', '        (l.uReserveA, l.uReserveB) =  SushiswapV2Library.getReserves(uPair, tokenA, tokenB);\n', '        l.sLiquidity = l.sReserveA * l.sReserveB;\n', '        l.uLiquidity = l.uReserveA * l.uReserveB;\n', '    }\n', '    \n', '    function assetToAsset(address tokenIn, uint amountIn, address tokenOut, uint granularity) public view returns (QuoteParams memory q, LiquidityParams memory l) {\n', '        if (tokenIn == WETH) {\n', '            return ethToAsset(amountIn, tokenOut, granularity);\n', '        } else if (tokenOut == WETH) {\n', '            return assetToEth(tokenIn, amountIn, granularity);\n', '        } else {\n', '            (q,) = assetToEth(tokenIn, amountIn, granularity);\n', '            return ethToAsset(q.quoteOut, tokenOut, granularity);\n', '        }\n', '        \n', '    }\n', '}']