['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-09\n', '*/\n', '\n', '// SPDX-License-Identifier: unlicensed\n', '\n', 'pragma solidity ^0.5.12;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value); \n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub( uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) { return 0;}\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div( uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod( uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { \n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function toPayable(address account) internal pure returns (address payable){\n', '        return address(uint160(account));\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount,"Address: insufficient balance");\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success,"Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom( IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),"SafeERC20: approve from non-zero to non-zero allowance");\n', '        callOptionalReturn( token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance( IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn( token, abi.encodeWithSelector( token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance( IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value,"SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn( token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // solhint-disable-next-line max-line-length\n', '            require( abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard {\n', '    bool private _notEntered;\n', '\n', '    constructor() internal {\n', '        _notEntered = true;\n', '    }\n', '\n', '    modifier nonReentrant() {\n', '        require(_notEntered, "ReentrancyGuard: reentrant call");\n', '        _notEntered = false;\n', '        _;\n', '        _notEntered = true;\n', '    }\n', '}\n', '\n', 'contract Context {\n', '    constructor() internal {}\n', '\n', '    // solhint-disable-previous-line no-empty-blocks\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address payable public _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', ' \n', '    constructor() internal {\n', '        address payable msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address payable newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address payable newOwner) internal {\n', '        require( newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'library Babylonian {\n', '    function sqrt(uint256 y) internal pure returns (uint256 z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint256 x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function withdraw(uint256) external;\n', '}\n', '\n', 'interface IUniswapV2Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address);    \n', '}\n', '\n', 'interface IUniswapV2Router02 {\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountADesired,\n', '        uint256 amountBDesired,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint256 amountTokenDesired,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);\n', '\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactTokens(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactETHForTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactETH(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactTokensForETH(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapETHForExactTokens(\n', '        uint256 amountOut,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable;\n', '\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '\n', '    function quote( uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);\n', '    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);\n', '    function getAmountIn( uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);\n', '    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);\n', '    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '    function token0() external pure returns (address);\n', '    function token1() external pure returns (address);\n', '    function getReserves() external view returns ( uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '    function totalSupply() external view returns (uint256);\n', '}\n', '\n', 'interface Iuniswap {\n', '    function tokenToTokenTransferInput(    // converting ERC20 to ERC20 and transfer\n', '        uint256 tokens_sold,\n', '        uint256 min_tokens_bought,\n', '        uint256 min_eth_bought,\n', '        uint256 deadline,\n', '        address recipient,\n', '        address token_addr\n', '    ) external returns (uint256 tokens_bought);\n', '\n', '    function tokenToTokenSwapInput(\n', '        uint256 tokens_sold,\n', '        uint256 min_tokens_bought,\n', '        uint256 min_eth_bought,\n', '        uint256 deadline,\n', '        address token_addr\n', '    ) external returns (uint256 tokens_bought);\n', '\n', '    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);\n', '    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256 eth_bought);\n', '    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256 tokens_bought);\n', '    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256 tokens_bought);\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);\n', '}\n', '\n', 'interface IBFactory {\n', '    function isBPool(address b) external view returns (bool);\n', '}\n', '\n', 'interface IBPool {\n', '    function joinswapExternAmountIn(address tokenIn, uint256 tokenAmountIn, uint256 minPoolAmountOut) external payable returns (uint256 poolAmountOut);\n', '    function isBound(address t) external view returns (bool);\n', '    function getFinalTokens() external view returns (address[] memory tokens);\n', '    function totalSupply() external view returns (uint256);\n', '    function getDenormalizedWeight(address token) external view returns (uint256);\n', '    function getTotalDenormalizedWeight() external view returns (uint256);\n', '    function getSwapFee() external view returns (uint256);\n', '    function getBalance(address token) external view returns (uint256);\n', '    function calcPoolOutGivenSingleIn(\n', '        uint256 tokenBalanceIn,\n', '        uint256 tokenWeightIn,\n', '        uint256 poolSupply,\n', '        uint256 totalWeight,\n', '        uint256 tokenAmountIn,\n', '        uint256 swapFee\n', '    ) external pure returns (uint256 poolAmountOut);\n', '}\n', '\n', 'interface IBPool_Balancer_RemoveLiquidity_V1_1 {\n', '    function exitswapPoolAmountIn(address tokenOut, uint256 poolAmountIn, uint256 minAmountOut) external payable returns (uint256 tokenAmountOut);\n', '    function totalSupply() external view returns (uint256);\n', '    function getFinalTokens() external view returns (address[] memory tokens);\n', '    function getDenormalizedWeight(address token)external view returns (uint256);\n', '    function getTotalDenormalizedWeight() external view returns (uint256);\n', '    function getSwapFee() external view returns (uint256);\n', '    function isBound(address t) external view returns (bool);\n', '    function getBalance(address token) external view returns (uint256);\n', '    function calcSingleOutGivenPoolIn(\n', '        uint256 tokenBalanceOut,\n', '        uint256 tokenWeightOut,\n', '        uint256 poolSupply,\n', '        uint256 totalWeight,\n', '        uint256 poolAmountIn,\n', '        uint256 swapFee\n', '    ) external pure returns (uint256 tokenAmountOut);\n', '}\n', '\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint256 value) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))),  "TransferHelper: APPROVE_FAILED");\n', '    }\n', '\n', '    function safeTransfer(address token, address to, uint256 value) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))),"TransferHelper: TRANSFER_FAILED"); \n', '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint256 value) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FROM_FAILED");\n', '    }\n', '}\n', '\n', 'interface ICurveRegistry {\n', '    function metaPools(address tokenAddress) external view returns (address swapAddress);\n', '    function getTokenAddress(address swapAddress) external view returns (address tokenAddress);\n', '    function getPoolTokens(address swapAddress) external view returns (address[4] memory poolTokens);\n', '    function isMetaPool(address swapAddress) external view returns (bool);\n', '    function getNumTokens(address swapAddress) external view returns (uint8 numTokens);\n', '    function isBtcPool(address swapAddress) external view returns (bool);\n', '    function isUnderlyingToken( address swapAddress, address tokenContractAddress) external view returns (bool, uint8);\n', '    function getIntermediateStableWithdraw(address swapAddress) external view returns (uint8 stableIndex, address stableAddress);  \n', '}\n', '\n', 'interface yERC20 {\n', '    function deposit(uint256 _amount) external;\n', '}\n', '\n', 'interface ICurveSwap {\n', '    function coins(int128 arg0) external view returns (address);\n', '    function coins(uint256 arg0) external view returns (address);\n', '    function balances(int128 arg0) external view returns (uint256);\n', '    function balances(uint256 arg0) external view returns (uint256);\n', '    function underlying_coins(int128 arg0) external view returns (address);\n', '    function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount) external;\n', '    function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount) external;\n', '    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external;\n', '    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_amount) external;\n', '}\n', '\n', 'contract UniswapV2RemoveLiquidity is ReentrancyGuard, Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    bool public stopped = false;\n', '    uint16 public goodwill = 0;\n', '\n', '    address public goodwillAddress              = address(0);\n', '    uint256 private constant deadline           = 0xf000000000000000000000000000000000000000000000000000000000000000;\n', '    address private constant wethTokenAddress   = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    \n', '    IUniswapV2Router02 private constant uniswapV2Router         = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    IUniswapV2Factory private constant UniSwapV2FactoryAddress  = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);\n', '   \n', '\n', '    \n', '    constructor(uint16 _goodwill, address payable _goodwillAddress) public {\n', '        goodwill = _goodwill;\n', '        goodwillAddress = _goodwillAddress;\n', '    }\n', '\n', '    modifier stopInEmergency {\n', '        if (stopped) {\n', '            revert("Temporarily Paused");\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function RemoveLiquidity2PairToken(address _FromUniPoolAddress, uint256 _IncomingLP) public nonReentrant stopInEmergency returns (uint256 amountA, uint256 amountB){\n', '        IUniswapV2Pair pair = IUniswapV2Pair(_FromUniPoolAddress);\n', '\n', '        require(address(pair) != address(0), "Error: Invalid Unipool Address");\n', '\n', '        address token0 = pair.token0();\n', '        address token1 = pair.token1();\n', '\n', '        IERC20(_FromUniPoolAddress).safeTransferFrom( msg.sender, address(this), _IncomingLP);\n', '\n', '        uint256 goodwillPortion = _transferGoodwill( _FromUniPoolAddress, _IncomingLP);\n', ' \n', '        IERC20(_FromUniPoolAddress).safeApprove(address(uniswapV2Router), SafeMath.sub(_IncomingLP, goodwillPortion));\n', '\n', '        if (token0 == wethTokenAddress || token1 == wethTokenAddress) {\n', '            address _token = token0 == wethTokenAddress ? token1 : token0;\n', '            (amountA, amountB) = uniswapV2Router.removeLiquidityETH(_token, SafeMath.sub(_IncomingLP, goodwillPortion), 1, 1, msg.sender, deadline);\n', '        } else {\n', '            (amountA, amountB) = uniswapV2Router.removeLiquidity( token0, token1, SafeMath.sub(_IncomingLP, goodwillPortion), 1, 1, msg.sender, deadline);\n', '        }\n', '    }\n', '\n', '    function RemoveLiquidity(\n', '        address _ToTokenContractAddress,\n', '        address _FromUniPoolAddress,\n', '        uint256 _IncomingLP, \n', '        uint256 _minTokensRec\n', '    ) public nonReentrant stopInEmergency returns (uint256) {\n', '        IUniswapV2Pair pair = IUniswapV2Pair(_FromUniPoolAddress);\n', '\n', '        require(address(pair) != address(0), "Error: Invalid Unipool Address");\n', '\n', '        address token0 = pair.token0();\n', '        address token1 = pair.token1();\n', '\n', '        IERC20(_FromUniPoolAddress).safeTransferFrom( msg.sender, address(this), _IncomingLP);\n', '   \n', '        uint256 goodwillPortion = _transferGoodwill(_FromUniPoolAddress, _IncomingLP);\n', '\n', '        IERC20(_FromUniPoolAddress).safeApprove(address(uniswapV2Router), SafeMath.sub(_IncomingLP, goodwillPortion));\n', '\n', '        (uint256 amountA, uint256 amountB) = uniswapV2Router.removeLiquidity( token0, token1, SafeMath.sub(_IncomingLP, goodwillPortion), 1, 1, address(this), deadline);\n', '\n', '        uint256 tokenBought;\n', '        if (canSwapFromV2(_ToTokenContractAddress, token0) && canSwapFromV2(_ToTokenContractAddress, token1)) {\n', '            tokenBought = swapFromV2(token0, _ToTokenContractAddress, amountA);\n', '            tokenBought += swapFromV2(token1, _ToTokenContractAddress, amountB);\n', '        } else if (canSwapFromV2(_ToTokenContractAddress, token0)) {\n', '            uint256 token0Bought = swapFromV2(token1, token0, amountB);\n', '            tokenBought = swapFromV2(token0, _ToTokenContractAddress, token0Bought.add(amountA));\n', '        } else if (canSwapFromV2(_ToTokenContractAddress, token1)) {\n', '            uint256 token1Bought = swapFromV2(token0, token1, amountA);\n', '            tokenBought = swapFromV2( token1, _ToTokenContractAddress, token1Bought.add(amountB));\n', '        }\n', '\n', '        require(tokenBought >= _minTokensRec, "High slippage");\n', '\n', '        if (_ToTokenContractAddress == address(0)) {\n', '            msg.sender.transfer(tokenBought);\n', '        } else {\n', '            IERC20(_ToTokenContractAddress).safeTransfer(msg.sender, tokenBought);\n', '        }\n', '\n', '        return tokenBought;\n', '    }\n', '\n', '    function RemoveLiquidity2PairTokenWithPermit(\n', '        address _FromUniPoolAddress,\n', '        uint256 _IncomingLP,\n', '        uint256 _approvalAmount,\n', '        uint256 _deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external stopInEmergency returns (uint256 amountA, uint256 amountB) {\n', '        IUniswapV2Pair(_FromUniPoolAddress).permit(msg.sender, address(this), _approvalAmount, _deadline, v, r, s);\n', '        (amountA, amountB) = RemoveLiquidity2PairToken(_FromUniPoolAddress, _IncomingLP);\n', '    }\n', '\n', '    function RemoveLiquidityWithPermit(\n', '        address _ToTokenContractAddress,\n', '        address _FromUniPoolAddress,\n', '        uint256 _IncomingLP,\n', '        uint256 _minTokensRec,\n', '        uint256 _approvalAmount,\n', '        uint256 _deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external stopInEmergency returns (uint256) {\n', '        IUniswapV2Pair(_FromUniPoolAddress).permit(msg.sender, address(this), _approvalAmount, _deadline, v, r, s);\n', '        return (RemoveLiquidity(_ToTokenContractAddress, _FromUniPoolAddress, _IncomingLP, _minTokensRec));\n', '    }\n', '\n', '    function swapFromV2(address _fromToken, address _toToken, uint256 amount) internal returns (uint256) {\n', '        require(_fromToken != address(0) || _toToken != address(0), "Invalid Exchange values");\n', '        if (_fromToken == _toToken) return amount;\n', '        require(canSwapFromV2(_fromToken, _toToken), "Cannot be exchanged");\n', '        require(amount > 0, "Invalid amount");\n', '\n', '        if (_fromToken == address(0)) {\n', '            if (_toToken == wethTokenAddress) {\n', '                IWETH(wethTokenAddress).deposit.value(amount)();\n', '                return amount;\n', '            }\n', '\n', '            address[] memory path = new address[](2);\n', '            path[0] = wethTokenAddress;\n', '            path[1] = _toToken;\n', '            uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];\n', '\n', '            minTokens = SafeMath.div(SafeMath.mul(minTokens, SafeMath.sub(10000, 200)), 10000);\n', '\n', '            uint256[] memory amounts = uniswapV2Router.swapExactETHForTokens.value(amount)(minTokens, path, address(this), deadline);\n', '                \n', '            return amounts[1];\n', '        } else if (_toToken == address(0)) {\n', '            if (_fromToken == wethTokenAddress) {\n', '                IWETH(wethTokenAddress).withdraw(amount);\n', '                return amount;\n', '            }\n', '            address[] memory path = new address[](2);\n', '            IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);\n', '            path[0] = _fromToken;\n', '            path[1] = wethTokenAddress;\n', '            uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];\n', '\n', '            minTokens = SafeMath.div(SafeMath.mul(minTokens, SafeMath.sub(10000, 200)), 10000);\n', '\n', '            uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(amount, minTokens, path, address(this), deadline);\n', '\n', '            return amounts[1];\n', '        } else {\n', '            IERC20(_fromToken).safeApprove(address(uniswapV2Router), amount);\n', '            uint256 returnedAmount = _swapTokenToTokenV2(_fromToken, _toToken, amount);\n', '            require(returnedAmount > 0, "Error in swap");\n', '            return returnedAmount;\n', '        }\n', '    }\n', '\n', '    function _swapTokenToTokenV2(address _fromToken, address _toToken, uint256 amount) internal returns (uint256) {\n', '        IUniswapV2Pair pair1 = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress));\n', '        IUniswapV2Pair pair2 = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress));\n', '        IUniswapV2Pair pair3 = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_fromToken, _toToken));\n', '\n', '        uint256[] memory amounts;\n', '\n', '        if (_haveReserve(pair3)) {\n', '            address[] memory path = new address[](2);\n', '            path[0] = _fromToken;\n', '            path[1] = _toToken;\n', '            uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];\n', '            minTokens = SafeMath.div(SafeMath.mul(minTokens, SafeMath.sub(10000, 200)), 10000);\n', '            amounts = uniswapV2Router.swapExactTokensForTokens(amount, minTokens, path, address(this), deadline);\n', '\n', '            return amounts[1];\n', '        } else if (_haveReserve(pair1) && _haveReserve(pair2)) {\n', '            address[] memory path = new address[](3);\n', '            path[0] = _fromToken;\n', '            path[1] = wethTokenAddress;\n', '            path[2] = _toToken;\n', '            uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[2];\n', '            minTokens = SafeMath.div(SafeMath.mul(minTokens, SafeMath.sub(10000, 200)), 10000);\n', '            amounts = uniswapV2Router.swapExactTokensForTokens(amount, minTokens, path, address(this), deadline);\n', '\n', '            return amounts[2];\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function canSwapFromV2(address _fromToken, address _toToken) internal view returns (bool){\n', '        require(_fromToken != address(0) || _toToken != address(0), "Invalid Exchange values");\n', ' \n', '        if (_fromToken == _toToken) return true;\n', '\n', '        if (_fromToken == address(0) || _fromToken == wethTokenAddress) {\n', '            if (_toToken == wethTokenAddress || _toToken == address(0))\n', '                return true;\n', '            IUniswapV2Pair pair = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress));\n', '                \n', '            if (_haveReserve(pair)) return true;\n', '\n', '        } else if (_toToken == address(0) || _toToken == wethTokenAddress) {\n', '            if (_fromToken == wethTokenAddress || _fromToken == address(0))\n', '                return true;\n', '            IUniswapV2Pair pair = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress));\n', '                \n', '            if (_haveReserve(pair)) return true;\n', '            \n', '        } else {\n', '            IUniswapV2Pair pair1 = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress));\n', '            IUniswapV2Pair pair2 = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress));  \n', '            IUniswapV2Pair pair3 = IUniswapV2Pair(UniSwapV2FactoryAddress.getPair(_fromToken, _toToken));\n', '                \n', '            if (_haveReserve(pair1) && _haveReserve(pair2)) return true;\n', '            if (_haveReserve(pair3)) return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    function _haveReserve(IUniswapV2Pair pair) internal view returns (bool) {\n', '        if (address(pair) != address(0)) {\n', '            uint256 totalSupply = pair.totalSupply();\n', '            if (totalSupply > 0) return true;\n', '        }\n', '    }\n', '\n', '     function _transferGoodwill(address _tokenContractAddress, uint256 tokens2Trade) internal returns (uint256 goodwillPortion) {\n', '        if (goodwill == 0) {\n', '            return 0;\n', '        }\n', '\n', '        goodwillPortion = SafeMath.div(SafeMath.mul(tokens2Trade, goodwill), 10000);\n', '\n', '        IERC20(_tokenContractAddress).safeTransfer(goodwillAddress,goodwillPortion);\n', '    }\n', '\n', '    function setNewGoodwill(uint16 _new_goodwill) public onlyOwner {\n', '        require(_new_goodwill >= 0 && _new_goodwill < 10000, "GoodWill Value not allowed");\n', '        goodwill = _new_goodwill;\n', '    }\n', '\n', '    function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {\n', '        uint256 qty = _TokenAddress.balanceOf(address(this));\n', '        _TokenAddress.safeTransfer(owner(), qty);\n', '    }\n', '\n', '    function toggleContractActive() public onlyOwner {\n', '        stopped = !stopped;\n', '    }\n', '\n', '    function withdraw() public onlyOwner {\n', '        uint256 contractBalance = address(this).balance;\n', '        address payable _to = owner().toPayable();\n', '        _to.transfer(contractBalance);\n', '    }\n', '\n', '    function setNewGoodwillAddress(address _newGoodwillAddress) public onlyOwner{\n', '        goodwillAddress = _newGoodwillAddress;\n', '    }\n', '\n', '    function() external payable {\n', '        require(msg.sender != tx.origin, "Do not send ETH directly");\n', '    }\n', '}']