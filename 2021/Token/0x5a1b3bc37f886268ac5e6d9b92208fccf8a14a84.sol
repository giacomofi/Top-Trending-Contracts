['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-24\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity >=0.5.0 <0.8.0;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; \n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return safeSub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract CollieInu is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => bool) private _blacklist;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '    uint256 private _amount;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event PutToBlacklist(address indexed target, bool indexed status);\n', '\n', '    constructor () {\n', '        _name = "Collie Inu";\n', '        _symbol = "COLLIE";\n', '        _amount = 3 * 10**12 * 10**18;\n', '        _decimals = 18;\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        _mint(msgSender, _amount);\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    \n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    \n', '    function isBlackList(address account) public view returns (bool) {\n', '        return _blacklist[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address funder, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[funder][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].safeSub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function blacklistTarget(address payable targetaddress) public onlyOwner returns (bool){\n', '        require(targetaddress != address(0), "ERC20: Can\'t blacklist zero address");\n', '        require(_blacklist[targetaddress] == false, "ERC20: Address already in blacklist");\n', '        _blacklist[targetaddress] = true;\n', '        emit PutToBlacklist(targetaddress, true);\n', '        return true;\n', '    }\n', '    \n', '    function unblacklistTarget(address payable targetaddress) public onlyOwner returns (bool){\n', '        require(targetaddress != address(0), "ERC20: Can\'t blacklist zero address");\n', '        require(_blacklist[targetaddress] == true, "ERC20: Address not blacklisted");\n', '\n', '        _blacklist[targetaddress] = false;\n', '        emit PutToBlacklist(targetaddress, false);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(_blacklist[sender] == false, "ERC20: sender address ");\n', '        _balances[sender] = _balances[sender].safeSub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].safeAdd(amount);\n', '    \n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _approve(address funder, address spender, uint256 amount) internal virtual {\n', '        require(funder != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[funder][spender] = amount;\n', '        emit Approval(funder, spender, amount);\n', '    }\n', '    \n', '      function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.safeAdd(amount);\n', '        _balances[account] = _balances[account].safeAdd(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '}']