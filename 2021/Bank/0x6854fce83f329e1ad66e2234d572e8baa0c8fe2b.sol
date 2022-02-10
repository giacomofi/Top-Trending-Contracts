['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-06\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'library Constants {\n', '    uint256 private constant MAX = ~uint256(0);\n', '    uint256 private constant _launchSupply = 60450 * 10**9;\n', '    uint256 private constant _largeTotal = (MAX - (MAX % _launchSupply));\n', '\n', '    uint256 private constant _baseExpansionFactor = 100;\n', '    uint256 private constant _baseContractionFactor = 100;\n', '    uint256 private constant _baseUtilityFee = 50;\n', '    uint256 private constant _baseContractionCap = 1000;\n', '\n', '    uint256 private constant _stabilizerFee = 250;\n', '    uint256 private constant _stabilizationLowerBound = 50;\n', '    uint256 private constant _stabilizationLowerReset = 75;\n', '    uint256 private constant _stabilizationUpperBound = 150;\n', '    uint256 private constant _stabilizationUpperReset = 125;\n', '    uint256 private constant _stabilizePercent = 10;\n', '\n', '    uint256 private constant _treasuryFee = 250;\n', '\n', '    uint256 private constant _presaleMinIndividualCap = 1 ether;\n', '    uint256 private constant _presaleMaxIndividualCap = 4 ether;\n', '    uint256 private constant _presaleCap = 37200 * 10**9; \n', '    uint256 private constant _maxPresaleGas = 200000000000;\n', '\n', '    uint256 private constant _epochLength = 4 hours;\n', '\n', '    uint256 private constant _liquidityReward = 2 * 10**9;\n', '    uint256 private constant _minForLiquidity = 10 * 10**9;\n', '    uint256 private constant _minForCallerLiquidity = 10 * 10**9;\n', '\n', '    address private constant _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '    address private constant _factoryAddress = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '    address payable private constant _deployerAddress = 0xB4a43aEd87902A24cD66afBD3349Af812325Ca01;\n', '    address private constant _treasuryAddress = 0xB4a43aEd87902A24cD66afBD3349Af812325Ca01;\n', '\n', '    uint256 private constant _presaleRate = 31000;\n', '    uint256 private constant _listingRate = 29063;\n', '\n', '    string private constant _name = "YFStable";\n', '    string private constant _symbol = "YFST";\n', '    uint8 private constant _decimals = 9;\n', '    \n', '    /****** Getters *******/\n', '    function getPresaleRate() internal pure returns (uint256) {\n', '        return _presaleRate;\n', '    }\n', '     function getListingRate() internal pure returns (uint256) {\n', '        return _listingRate;\n', '    }\n', '    function getLaunchSupply() internal pure returns (uint256) {\n', '        return _launchSupply;\n', '    }\n', '    function getLargeTotal() internal pure returns (uint256) {\n', '        return _largeTotal;\n', '    }\n', '    function getPresaleCap() internal pure returns (uint256) {\n', '        return _presaleCap;\n', '    }\n', '    function getPresaleMinIndividualCap() internal pure returns (uint256) {\n', '        return _presaleMinIndividualCap;\n', '    }\n', '    function getPresaleMaxIndividualCap() internal pure returns (uint256) {\n', '        return _presaleMaxIndividualCap;\n', '    }\n', '    function getMaxPresaleGas() internal pure returns (uint256) {\n', '        return _maxPresaleGas;\n', '    }\n', '    function getBaseExpansionFactor() internal pure returns (uint256) {\n', '        return _baseExpansionFactor;\n', '    }\n', '    function getBaseContractionFactor() internal pure returns (uint256) {\n', '        return _baseContractionFactor;\n', '    }\n', '    function getBaseContractionCap() internal pure returns (uint256) {\n', '        return _baseContractionCap;\n', '    }\n', '    function getBaseUtilityFee() internal pure returns (uint256) {\n', '        return _baseUtilityFee;\n', '    }\n', '    function getStabilizerFee() internal pure returns (uint256) {\n', '        return _stabilizerFee;\n', '    }\n', '    function getStabilizationLowerBound() internal pure returns (uint256) {\n', '        return _stabilizationLowerBound;\n', '    }\n', '    function getStabilizationLowerReset() internal pure returns (uint256) {\n', '        return _stabilizationLowerReset;\n', '    }\n', '    function getStabilizationUpperBound() internal pure returns (uint256) {\n', '        return _stabilizationUpperBound;\n', '    }\n', '    function getStabilizationUpperReset() internal pure returns (uint256) {\n', '        return _stabilizationUpperReset;\n', '    }\n', '    function getStabilizePercent() internal pure returns (uint256) {\n', '        return _stabilizePercent;\n', '    }\n', '    function getTreasuryFee() internal pure returns (uint256) {\n', '        return _treasuryFee;\n', '    }\n', '    function getEpochLength() internal pure returns (uint256) {\n', '        return _epochLength;\n', '    }\n', '    function getLiquidityReward() internal pure returns (uint256) {\n', '        return _liquidityReward;\n', '    }\n', '    function getMinForLiquidity() internal pure returns (uint256) {\n', '        return _minForLiquidity;\n', '    }\n', '    function getMinForCallerLiquidity() internal pure returns (uint256) {\n', '        return _minForCallerLiquidity;\n', '    }\n', '    function getRouterAdd() internal pure returns (address) {\n', '        return _routerAddress;\n', '    }\n', '    function getFactoryAdd() internal pure returns (address) {\n', '        return _factoryAddress;\n', '    }\n', '    function getDeployerAdd() internal pure returns (address payable) {\n', '        return _deployerAddress;\n', '    }\n', '    function getTreasuryAdd() internal pure returns (address) {\n', '        return _treasuryAddress;\n', '    }\n', '    function getName() internal pure returns (string memory)  {\n', '        return _name;\n', '    }\n', '    function getSymbol() internal pure returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function getDecimals() internal pure returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'interface IYFStable is IERC20 {\n', '    function isPresaleDone() external view returns (bool);\n', '    function mint(address to, uint256 amount) external;\n', '    function setPresaleDone() external payable;\n', '    function setTaxless(bool flag) external;\n', '    function silentSyncPair(address pool) external;\n', '}\n', 'contract LiquidityReserve is Context, Ownable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '    IYFStable token;\n', '    IUniswapV2Router02 public uniswapRouterV2;\n', '    IUniswapV2Factory public uniswapFactory;\n', '\n', '    modifier sendTaxless {\n', '        token.setTaxless(true);\n', '        _;\n', '        token.setTaxless(false);\n', '    }\n', '    constructor (address tokenAdd) public {\n', '        token = IYFStable(tokenAdd);\n', '        uniswapRouterV2 = IUniswapV2Router02(Constants.getRouterAdd());\n', '        uniswapFactory = IUniswapV2Factory(Constants.getFactoryAdd());\n', '    }\n', '    function addLiquidityETHOnly() external payable sendTaxless {\n', '        require(msg.value > 0, "Need to provide eth for liquidity");\n', '        address tokenUniswapPair = uniswapFactory.getPair(address(token),uniswapRouterV2.WETH());\n', '        uint256 initialBalance = address(this).balance.sub(msg.value);\n', '        uint256 initialTokenBalance = token.balanceOf(address(this));\n', '        uint256 amountToSwap = msg.value.div(2);\n', '        address[] memory path = new address[](2);\n', '        path[0] = uniswapRouterV2.WETH();\n', '        path[1] = address(token);\n', '        uniswapRouterV2.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountToSwap}(0,path,address(this),block.timestamp);\n', '        uint256 newTokenBalance = token.balanceOf(address(this)).sub(initialTokenBalance);\n', '        token.approve(address(uniswapRouterV2),newTokenBalance);\n', '        uniswapRouterV2.addLiquidityETH{value: amountToSwap}(address(token),newTokenBalance,0,0,_msgSender(),block.timestamp);\n', '        uint256 excessTokens = token.balanceOf(address(this)).sub(initialTokenBalance);\n', '        token.silentSyncPair(tokenUniswapPair);\n', '        if (excessTokens >0) {\n', '            token.transfer(_msgSender(),excessTokens);\n', '        }\n', '        uint256 dustEth = address(this).balance.sub(initialBalance);\n', '        if (dustEth>0) _msgSender().transfer(dustEth);\n', '    }\n', '}']