['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-18\n', '*/\n', '\n', '// SPDX-License-Identifier: bsl-1.1\n', '\n', 'pragma solidity ^0.8.1;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IKeep3rV1Quote {\n', '    struct LiquidityParams {\n', '        uint sReserveA;\n', '        uint sReserveB;\n', '        uint uReserveA;\n', '        uint uReserveB;\n', '        uint sLiquidity;\n', '        uint uLiquidity;\n', '    }\n', '    \n', '    struct QuoteParams {\n', '        uint quoteOut;\n', '        uint amountOut;\n', '        uint currentOut;\n', '        uint sTWAP;\n', '        uint uTWAP;\n', '        uint sCUR;\n', '        uint uCUR;\n', '    }\n', '    \n', '    function assetToUsd(address tokenIn, uint amountIn, uint granularity) external returns (QuoteParams memory q, LiquidityParams memory l);\n', '    function assetToEth(address tokenIn, uint amountIn, uint granularity) external view returns (QuoteParams memory q, LiquidityParams memory l);\n', '    function ethToUsd(uint amountIn, uint granularity) external view returns (QuoteParams memory q, LiquidityParams memory l);\n', '    function pairFor(address tokenA, address tokenB) external pure returns (address sPair, address uPair);\n', '    function sPairFor(address tokenA, address tokenB) external pure returns (address sPair);\n', '    function uPairFor(address tokenA, address tokenB) external pure returns (address uPair);\n', '    function getLiquidity(address tokenA, address tokenB) external view returns (LiquidityParams memory l);\n', '    function assetToAsset(address tokenIn, uint amountIn, address tokenOut, uint granularity) external view returns (QuoteParams memory q, LiquidityParams memory l);\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function decimals() external view returns (uint8);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '}\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract SynthetixAMM  {\n', '    using SafeERC20 for IERC20;\n', '    \n', '    address public governance;\n', '    address public pendingGovernance;\n', '    \n', '    mapping(address => address) synths;\n', '    \n', '    IKeep3rV1Quote public constant exchange = IKeep3rV1Quote(0xDd6eb7F03F8cd9b5C9565172E37C0Bb98D67E078);\n', '    \n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    \n', '    constructor() {\n', '        governance = msg.sender;\n', '    }\n', '    \n', '    function setGovernance(address _gov) external {\n', '        require(msg.sender == governance);\n', '        pendingGovernance = _gov;\n', '    } \n', '    \n', '    function acceptGovernance() external {\n', '        require(msg.sender == pendingGovernance);\n', '        governance = pendingGovernance;\n', '    }\n', '    \n', '    function withdraw(address token, uint amount) external {\n', '        require(msg.sender == governance);\n', '        IERC20(token).safeTransfer(governance, amount);\n', '    }\n', '    \n', '    function withdrawAll(address token) external {\n', '        require(msg.sender == governance);\n', '        IERC20(token).safeTransfer(governance, IERC20(token).balanceOf(address(this)));\n', '    }\n', '    \n', '    function addSynth(address synth, address token) external {\n', '        require(msg.sender == governance);\n', '        synths[synth] = token;\n', '    }\n', '    \n', '    function quote(address synthIn, uint amountIn, address synthOut) public view returns (uint amountOut) {\n', '        address _tokenOut = synths[synthOut];\n', '        address _tokenIn = synths[synthIn];\n', '        (IKeep3rV1Quote.QuoteParams memory q,) = exchange.assetToAsset(_tokenIn, amountIn * 10 ** IERC20(_tokenIn).decimals() / 10 ** 18, _tokenOut, 2);\n', '        amountOut = q.quoteOut * 10 ** 18 / 10 ** IERC20(_tokenOut).decimals();\n', '        require(amountOut <= IERC20(synthOut).balanceOf(address(this)), "SynthetixAMM: Insufficient liquidity for trade");\n', '        return amountOut;\n', '    }\n', '    \n', '    function swap(address synthIn, uint amountIn, address synthOut, uint minOut, address recipient) external returns (uint) {\n', '        uint quoteOut = quote(synthIn, amountIn, synthOut);\n', '        require(quoteOut >= minOut, "SynthetixAMM: Quote less than mininum output");\n', '        IERC20(synthIn).safeTransferFrom(msg.sender, address(this), amountIn);\n', '        IERC20(synthOut).safeTransfer(recipient, quoteOut);\n', '        emit Swap(msg.sender, amountIn, 0, 0, quoteOut, recipient);\n', '        return quoteOut;\n', '    }\n', '}']