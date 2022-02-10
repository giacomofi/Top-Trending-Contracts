['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-15\n', '*/\n', '\n', '// SPDX-License-Identifier: unlicensed\n', '\n', 'pragma solidity ^0.5.12;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value); \n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub( uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) { return 0;}\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div( uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod( uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { \n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function toPayable(address account) internal pure returns (address payable){\n', '        return address(uint160(account));\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount,"Address: insufficient balance");\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success,"Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom( IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),"SafeERC20: approve from non-zero to non-zero allowance");\n', '        callOptionalReturn( token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance( IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn( token, abi.encodeWithSelector( token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance( IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value,"SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn( token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // solhint-disable-next-line max-line-length\n', '            require( abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard {\n', '    bool private _notEntered;\n', '\n', '    constructor() internal {\n', '        _notEntered = true;\n', '    }\n', '\n', '    modifier nonReentrant() {\n', '        require(_notEntered, "ReentrancyGuard: reentrant call");\n', '        _notEntered = false;\n', '        _;\n', '        _notEntered = true;\n', '    }\n', '}\n', '\n', 'contract Context {\n', '    constructor() internal {}\n', '\n', '    // solhint-disable-previous-line no-empty-blocks\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address payable public _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', ' \n', '    constructor() internal {\n', '        address payable msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address payable newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address payable newOwner) internal {\n', '        require( newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'library Babylonian {\n', '    function sqrt(uint256 y) internal pure returns (uint256 z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint256 x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function withdraw(uint256) external;\n', '}\n', '\n', 'interface IUniswapV2Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address);    \n', '}\n', '\n', 'interface IUniswapV2Router02 {\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountADesired,\n', '        uint256 amountBDesired,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint256 amountTokenDesired,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);\n', '\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactTokens(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactETHForTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactETH(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactTokensForETH(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapETHForExactTokens(\n', '        uint256 amountOut,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable;\n', '\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '\n', '    function quote( uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);\n', '    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);\n', '    function getAmountIn( uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);\n', '    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);\n', '    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '    function token0() external pure returns (address);\n', '    function token1() external pure returns (address);\n', '    function getReserves() external view returns ( uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '    function totalSupply() external view returns (uint256);\n', '}\n', '\n', 'interface Iuniswap {\n', '    function tokenToTokenTransferInput(    // converting ERC20 to ERC20 and transfer\n', '        uint256 tokens_sold,\n', '        uint256 min_tokens_bought,\n', '        uint256 min_eth_bought,\n', '        uint256 deadline,\n', '        address recipient,\n', '        address token_addr\n', '    ) external returns (uint256 tokens_bought);\n', '\n', '    function tokenToTokenSwapInput(\n', '        uint256 tokens_sold,\n', '        uint256 min_tokens_bought,\n', '        uint256 min_eth_bought,\n', '        uint256 deadline,\n', '        address token_addr\n', '    ) external returns (uint256 tokens_bought);\n', '\n', '    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);\n', '    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256 eth_bought);\n', '    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256 tokens_bought);\n', '    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256 tokens_bought);\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);\n', '}\n', '\n', 'interface IBFactory {\n', '    function isBPool(address b) external view returns (bool);\n', '}\n', '\n', 'interface IBPool {\n', '    function joinswapExternAmountIn(address tokenIn, uint256 tokenAmountIn, uint256 minPoolAmountOut) external payable returns (uint256 poolAmountOut);\n', '    function isBound(address t) external view returns (bool);\n', '    function getFinalTokens() external view returns (address[] memory tokens);\n', '    function totalSupply() external view returns (uint256);\n', '    function getDenormalizedWeight(address token) external view returns (uint256);\n', '    function getTotalDenormalizedWeight() external view returns (uint256);\n', '    function getSwapFee() external view returns (uint256);\n', '    function getBalance(address token) external view returns (uint256);\n', '    function calcPoolOutGivenSingleIn(\n', '        uint256 tokenBalanceIn,\n', '        uint256 tokenWeightIn,\n', '        uint256 poolSupply,\n', '        uint256 totalWeight,\n', '        uint256 tokenAmountIn,\n', '        uint256 swapFee\n', '    ) external pure returns (uint256 poolAmountOut);\n', '}\n', '\n', 'interface IBPool_Balancer_RemoveLiquidity_V1_1 {\n', '    function exitswapPoolAmountIn(address tokenOut, uint256 poolAmountIn, uint256 minAmountOut) external payable returns (uint256 tokenAmountOut);\n', '    function totalSupply() external view returns (uint256);\n', '    function getFinalTokens() external view returns (address[] memory tokens);\n', '    function getDenormalizedWeight(address token)external view returns (uint256);\n', '    function getTotalDenormalizedWeight() external view returns (uint256);\n', '    function getSwapFee() external view returns (uint256);\n', '    function isBound(address t) external view returns (bool);\n', '    function getBalance(address token) external view returns (uint256);\n', '    function calcSingleOutGivenPoolIn(\n', '        uint256 tokenBalanceOut,\n', '        uint256 tokenWeightOut,\n', '        uint256 poolSupply,\n', '        uint256 totalWeight,\n', '        uint256 poolAmountIn,\n', '        uint256 swapFee\n', '    ) external pure returns (uint256 tokenAmountOut);\n', '}\n', '\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint256 value) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))),  "TransferHelper: APPROVE_FAILED");\n', '    }\n', '\n', '    function safeTransfer(address token, address to, uint256 value) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))),"TransferHelper: TRANSFER_FAILED"); \n', '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint256 value) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FROM_FAILED");\n', '    }\n', '}\n', '\n', 'interface ICurveRegistry {\n', '    function metaPools(address tokenAddress) external view returns (address swapAddress);\n', '    function getTokenAddress(address swapAddress) external view returns (address tokenAddress);\n', '    function getPoolTokens(address swapAddress) external view returns (address[4] memory poolTokens);\n', '    function isMetaPool(address swapAddress) external view returns (bool);\n', '    function getNumTokens(address swapAddress) external view returns (uint8 numTokens);\n', '    function isBtcPool(address swapAddress) external view returns (bool);\n', '    function isUnderlyingToken( address swapAddress, address tokenContractAddress) external view returns (bool, uint8);\n', '    function getIntermediateStableWithdraw(address swapAddress) external view returns (uint8 stableIndex, address stableAddress);  \n', '}\n', '\n', 'interface yERC20 {\n', '    function deposit(uint256 _amount) external;\n', '}\n', '\n', 'interface ICurveSwap {\n', '    function coins(int128 arg0) external view returns (address);\n', '    function coins(uint256 arg0) external view returns (address);\n', '    function balances(int128 arg0) external view returns (uint256);\n', '    function balances(uint256 arg0) external view returns (uint256);\n', '    function underlying_coins(int128 arg0) external view returns (address);\n', '    function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount) external;\n', '    function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount) external;\n', '    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external;\n', '    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_amount) external;\n', '}\n', '\n', 'contract CurveRemoveLiquidity is ReentrancyGuard, Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    bool public stopped = false;\n', '    uint16 public goodwill = 0;\n', '    ICurveRegistry public curveReg;\n', '\n', '    address public goodwillAddress      = address(0);\n', '    address private constant wethToken  = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address private constant wbtcToken  = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;\n', '    address public intermediateStable   = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;\n', '    uint256 private constant deadline   = 0xf000000000000000000000000000000000000000000000000000000000000000;\n', '\n', '    IUniswapV2Factory private constant UniSwapV2FactoryAddress = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);\n', '    IUniswapV2Router02 private constant uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '\n', '    modifier stopInEmergency {\n', '        if (stopped) {\n', '            revert("Temporarily Paused");\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '\n', '    constructor(uint16 _goodwill, address payable _goodwillAddress, ICurveRegistry _curveRegistry) public {\n', '        goodwill = _goodwill;\n', '        goodwillAddress = _goodwillAddress;\n', '        curveReg = _curveRegistry;\n', '    }\n', '\n', '    function RemoveLiquidity(\n', '        address payable toWhomToIssue,\n', '        address swapAddress,\n', '        uint256 incomingCrv,\n', '        address toToken,\n', '        uint256 minToTokens\n', '    ) external stopInEmergency returns (uint256 ToTokensBought) {\n', '        address poolTokenAddress = curveReg.getTokenAddress(swapAddress);\n', '        uint256 goodwillPortion;\n', '        if (goodwill > 0) {\n', '            goodwillPortion = SafeMath.div(SafeMath.mul(incomingCrv, goodwill), 10000);\n', '            IERC20(poolTokenAddress).safeTransferFrom(msg.sender, goodwillAddress, goodwillPortion);  \n', '        }\n', '        IERC20(poolTokenAddress).safeTransferFrom(msg.sender, address(this), SafeMath.sub(incomingCrv, goodwillPortion));\n', '\n', '        (bool isUnderlying, uint8 underlyingIndex) = curveReg.isUnderlyingToken(swapAddress, toToken);\n', '\n', '        if (isUnderlying) {\n', '            ToTokensBought = _exitCurve(swapAddress, incomingCrv, underlyingIndex);\n', '        } else if (curveReg.isMetaPool(swapAddress)) {\n', '            address[4] memory poolTokens = curveReg.getPoolTokens(swapAddress);\n', '            address intermediateSwapAddress;\n', '            uint8 i;\n', '            for (; i < 4; i++) {\n', '                if (curveReg.metaPools(poolTokens[i]) != address(0)) {\n', '                    intermediateSwapAddress = curveReg.metaPools(poolTokens[i]);\n', '                    break;\n', '                }\n', '            }\n', '\n', '            uint256 intermediateBought = _exitCurve(swapAddress, incomingCrv, i);\n', '\n', '            ToTokensBought = _performRemoveLiquidity(intermediateSwapAddress, intermediateBought, toToken);\n', '        } else {\n', '            ToTokensBought = _performRemoveLiquidity(swapAddress, incomingCrv, toToken);\n', '        }\n', '\n', '        require(ToTokensBought >= minToTokens, "High Slippage");\n', '        if (toToken == address(0)) {\n', '            Address.sendValue(toWhomToIssue, ToTokensBought);\n', '        } else {\n', '            IERC20(toToken).safeTransfer(toWhomToIssue, ToTokensBought);\n', '        }\n', '    }\n', '\n', '    function _performRemoveLiquidity( address swapAddress, uint256 incomingCrv, address toToken) internal returns (uint256 ToTokensBought) {\n', '        if (curveReg.isBtcPool(swapAddress)) {\n', '            (, uint8 wbtcIndex) = curveReg.isUnderlyingToken(swapAddress, wbtcToken);\n', '            uint256 intermediateBought = _exitCurve(swapAddress, incomingCrv, wbtcIndex);\n', '            ToTokensBought = _token2Token(wbtcToken, toToken, intermediateBought);\n', '        } else {\n', '            (bool isUnderlyingIntermediate, uint8 intermediateStableIndex) = curveReg.isUnderlyingToken(swapAddress, intermediateStable);\n', '            require(isUnderlyingIntermediate, "Pool does not support intermediate");\n', '            uint256 intermediateBought = _exitCurve(swapAddress, incomingCrv, intermediateStableIndex);\n', '            ToTokensBought = _token2Token(intermediateStable, toToken, intermediateBought);\n', '        }\n', '    }\n', '\n', '    function _exitCurve(address swapAddress, uint256 incomingCrv, uint256 index) internal returns (uint256 tokensReceived) {\n', '        address exitTokenAddress = curveReg.getPoolTokens(swapAddress)[index];\n', '        uint256 iniTokenBal = IERC20(exitTokenAddress).balanceOf(address(this));\n', '\n', '        address tokenAddress = curveReg.getTokenAddress(swapAddress);\n', '        IERC20(tokenAddress).safeApprove(swapAddress, 0);\n', '        IERC20(tokenAddress).safeApprove(swapAddress, incomingCrv);\n', '        ICurveSwap(swapAddress).remove_liquidity_one_coin(incomingCrv, int128(index), 0);\n', '\n', '        tokensReceived = (IERC20(exitTokenAddress).balanceOf(address(this))).sub(iniTokenBal);\n', '            \n', '    }\n', '\n', '    function _token2Token(address fromToken, address toToken, uint256 tokens2Trade) internal returns (uint256 tokenBought) {\n', '        if (fromToken == toToken) {\n', '            return tokens2Trade;\n', '        }\n', '\n', '        if (fromToken == address(0)) {\n', '            if (toToken == wethToken) {\n', '                IWETH(wethToken).deposit.value(tokens2Trade)();\n', '                return tokens2Trade;\n', '            }\n', '\n', '            address[] memory path = new address[](2);\n', '            path[0] = wethToken;\n', '            path[1] = toToken;\n', '            tokenBought = uniswapRouter.swapExactETHForTokens.value(tokens2Trade)(1, path, address(this), deadline)[path.length - 1];\n', '                \n', '           \n', '        } else if (toToken == address(0)) {\n', '            if (fromToken == wethToken) {\n', '                IWETH(wethToken).withdraw(tokens2Trade);\n', '                return tokens2Trade;\n', '            }\n', '\n', '            IERC20(fromToken).safeApprove(address(uniswapRouter), tokens2Trade);\n', '\n', '            address[] memory path = new address[](2);\n', '            path[0] = fromToken;\n', '            path[1] = wethToken;\n', '            tokenBought = uniswapRouter.swapExactTokensForETH(tokens2Trade, 1, path, address(this), deadline)[path.length - 1];\n', '        } else {\n', '            IERC20(fromToken).safeApprove(address(uniswapRouter), tokens2Trade);\n', '\n', '            if (fromToken != wethToken) {\n', '                if (toToken != wethToken) {\n', '                    address pairA = UniSwapV2FactoryAddress.getPair(fromToken, toToken);\n', '                    address[] memory pathA = new address[](2);\n', '                    pathA[0] = fromToken;\n', '                    pathA[1] = toToken;\n', '                    uint256 amtA;\n', '                    if (pairA != address(0)) {\n', '                        amtA = uniswapRouter.getAmountsOut(tokens2Trade, pathA)[1];\n', '                    }\n', '\n', '                    address[] memory pathB = new address[](3);\n', '                    pathB[0] = fromToken;\n', '                    pathB[1] = wethToken;\n', '                    pathB[2] = toToken;\n', '\n', '                    uint256 amtB = uniswapRouter.getAmountsOut(tokens2Trade, pathB)[2];\n', '                        \n', '                    if (amtA >= amtB) {\n', '                        tokenBought = uniswapRouter.swapExactTokensForTokens(tokens2Trade, 1, pathA, address(this), deadline)[pathA.length - 1];\n', '                    } else {\n', '                        tokenBought = uniswapRouter.swapExactTokensForTokens(tokens2Trade, 1, pathB, address(this), deadline)[pathB.length - 1]; \n', '                    }\n', '                } else {\n', '                    address[] memory path = new address[](2);\n', '                    path[0] = fromToken;\n', '                    path[1] = wethToken;\n', '\n', '                    tokenBought = uniswapRouter.swapExactTokensForTokens(tokens2Trade, 1, path, address(this), deadline)[path.length - 1];\n', '                }\n', '            } else {\n', '                address[] memory path = new address[](2);\n', '                path[0] = wethToken;\n', '                path[1] = toToken;\n', '                tokenBought = uniswapRouter.swapExactTokensForTokens( tokens2Trade, 1, path, address(this), deadline)[path.length - 1];   \n', '            }\n', '        }\n', '        require(tokenBought > 0, "Error Swapping Tokens");\n', '    }\n', '\n', '    function updateCurveRegistry(ICurveRegistry newCurveRegistry) external onlyOwner{\n', '        require(newCurveRegistry != curveReg, "Already using this Registry");\n', '        curveReg = newCurveRegistry;\n', '    }\n', '\n', '    function inCaseTokengetsStuck(IERC20 _TokenAddress) external onlyOwner {\n', '        uint256 qty = _TokenAddress.balanceOf(address(this));\n', '        IERC20(_TokenAddress).safeTransfer(_owner, qty);\n', '    }\n', '\n', '    function setNewGoodwill(uint16 _new_goodwill) public onlyOwner {\n', '        require(_new_goodwill >= 0 && _new_goodwill < 10000, "GoodWill Value not allowed");\n', '        goodwill = _new_goodwill;\n', '    }\n', '\n', '    function setNewGoodwillAddress(address _newGoodwillAddress) public onlyOwner{\n', '        goodwillAddress = _newGoodwillAddress;\n', '    }\n', '\n', '    function toggleContractActive() external onlyOwner {\n', '        stopped = !stopped;\n', '    }\n', '\n', '    function withdraw() external onlyOwner {\n', '        _owner.transfer(address(this).balance);\n', '    }\n', '\n', '    function updateIntermediateStable(address newIntermediate) external onlyOwner{\n', '        require(newIntermediate != intermediateStable, "Already using this intermediate");\n', '        intermediateStable = newIntermediate;\n', '    }\n', '\n', '    function() external payable {\n', '        require(msg.sender != tx.origin, "Do not send ETH directly");\n', '    }\n', '}']