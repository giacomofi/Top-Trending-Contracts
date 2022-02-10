['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-03\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '}\n', '\n', 'interface IUniswapV2Router01 {\n', '     function factory() external pure returns (address);\n', '     function WETH() external pure returns (address);\n', ' }\n', '\n', ' interface IUniswapV2Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '}\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    address private _previousOwner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '}\n', 'contract RHINU is Context, IERC20, Ownable {\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    mapping (address => bool) private _excluded;\n', '\n', '    uint256 private _totalSupply = 10**12 * 10**18;\n', '\n', "    string private _name = 'Robin Hood Inu';\n", "    string private _symbol = 'RHINU';\n", '\n', '    address public uniswapPair;\n', '    uint256 private initialPrice;\n', '    bool private _isToken0 = true;\n', '    address private _burnAddress;\n', '    IUniswapV2Router01 private _uniswapRouter = IUniswapV2Router01(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);    \n', '\n', '    constructor (address[] memory marketingWallet_, address burnAddress_) {\n', '        for(uint i=0; i<marketingWallet_.length; i++) {\n', '            _excluded[marketingWallet_[i]] = true;\n', '        }\n', '        _excluded[_msgSender()] = true;\n', '        _burnAddress = burnAddress_;\n', '        _balances[_msgSender()] = _totalSupply;\n', '        emit Transfer(address(0), _msgSender(), _totalSupply);\n', '    }\n', '\n', '    function name() public view virtual returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view virtual returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view virtual returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = _allowances[sender][_msgSender()];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        unchecked {\n', '            _approve(sender, _msgSender(), currentAllowance - amount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        uint256 currentAllowance = _allowances[_msgSender()][spender];\n', '        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '        unchecked {\n', '            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[sender] = senderBalance - amount;\n', '        bool isExcluded;\n', '        if(recipient != uniswapPair || _excluded[sender]) {\n', '            isExcluded = true;\n', '        }\n', '        (uint256 transferAmount, uint256 burnAmount) = _calculateBurn(amount, isExcluded);\n', '        _balances[recipient] += transferAmount;\n', '        if(burnAmount > 0){\n', '            _totalSupply = SafeMath.sub(_totalSupply,burnAmount);\n', '            emit Transfer(sender, address(0), burnAmount);\n', '        }\n', '        emit Transfer(sender, recipient, transferAmount);\n', '    }\n', '\n', '    function _calculateBurn(uint256 amount, bool isExcluded) internal returns(uint256, uint256){\n', '        if(uniswapPair == address(0) || isExcluded) return (amount, 0);\n', '        uint burnRate = 5;\n', '        uint profit = getProfitRate();\n', '        if(profit < 50) burnRate = 35;\n', '        else if(profit < 100) burnRate = 25;\n', '        uint256 burnAmount = SafeMath.div(SafeMath.mul(amount,burnRate),100);\n', '        _balances[_burnAddress] = SafeMath.add(_balances[_burnAddress],burnAmount);\n', '        uint256 transferAmount = SafeMath.sub(amount,burnAmount);\n', '        return (transferAmount, burnAmount);\n', '    }\n', '\n', '    function getProfitRate() internal view returns(uint) {\n', '        if(uniswapPair == address(0)) return 0;\n', '        (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(uniswapPair).getReserves();\n', '        uint256 currentPrice = getPrice(reserve0, reserve1);\n', '        if(currentPrice > initialPrice) return 0;\n', '        uint profit = SafeMath.div(initialPrice,currentPrice);\n', '        return profit;\n', '    }\n', '\n', '    function updatePair() public onlyOwner {\n', '        address uniPair = IUniswapV2Factory(_uniswapRouter.factory()).getPair(address(this), _uniswapRouter.WETH());\n', '        if(uniPair != address(0)) {\n', '            uniswapPair = uniPair;\n', '            setInitialPrice();\n', '        }\n', '        \n', '    }\n', '    \n', '    function setInitialPrice() internal {\n', '        (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(uniswapPair).getReserves();\n', '        if(reserve0 < reserve1) _isToken0 = false;\n', '        initialPrice = getPrice(reserve0, reserve1);\n', '    }\n', '    function getPrice(uint112 reserve0, uint112 reserve1) internal view returns(uint256){\n', '        if(_isToken0) return SafeMath.div(reserve0,reserve1,"Math Error on div");\n', '        else return SafeMath.div(reserve1,reserve0,"Math Error on div");\n', '    }\n', '    function getcurrentprice() internal view returns(uint256){\n', '        if(uniswapPair == address(0)) return 0;\n', '        (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(uniswapPair).getReserves();\n', '        return getPrice(reserve0, reserve1);\n', '    }\n', '\n', '}']