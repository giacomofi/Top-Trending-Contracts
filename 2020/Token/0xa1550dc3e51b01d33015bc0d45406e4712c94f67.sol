['// SPDX-License-Identifier: MIT\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', 'abstract contract Context {\n', '\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '\n', '        return msg.sender;\n', '\n', '    }\n', '\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '\n', '        return msg.data;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        uint256 c = a + b;\n', '\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', ' \n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '\n', '    }\n', '\n', '\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '\n', '        require(b <= a, errorMessage);\n', '\n', '        uint256 c = a - b;\n', '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', ' \n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '  \n', '\n', '        if (a == 0) {\n', '\n', '            return 0;\n', '\n', '        }\n', '\n', '\n', '        uint256 c = a * b;\n', '\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        return div(a, b, "SafeMath: division by zero");\n', '\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '\n', '        require(b > 0, errorMessage);\n', '\n', '        uint256 c = a / b;\n', '\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '\n', '        return c;\n', '\n', '    }\n', '\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '\n', '    }\n', '\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '\n', '        require(b != 0, errorMessage);\n', '\n', '        return a % b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract Pausable is Context {\n', '\n', '\n', '    event Paused(address account);\n', '\n', '\n', '    event Unpaused(address account);\n', '\n', '\n', '    bool private _paused;\n', '\n', '\n', '    constructor () internal {\n', '\n', '        _paused = false;\n', '\n', '    }\n', '\n', '\n', '    function paused() public view returns (bool) {\n', '\n', '        return _paused;\n', '\n', '    }\n', '\n', '\n', '\n', '    modifier whenNotPaused() {\n', '\n', '        require(!_paused, "Pausable: paused");\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    modifier whenPaused() {\n', '\n', '        require(_paused, "Pausable: not paused");\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    function _pause() internal virtual whenNotPaused {\n', '\n', '        _paused = true;\n', '\n', '        emit Paused(_msgSender());\n', '\n', '    }\n', '\n', '\n', '\n', '    function _unpause() internal virtual whenPaused {\n', '\n', '        _paused = false;\n', '\n', '        emit Unpaused(_msgSender());\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'interface IERC20 {\n', '\n', '\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '\n', '\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external  returns (bool);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract Ownable is Context {\n', '\n', '    address private _owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', ' \n', '\n', '    constructor () internal {\n', '\n', '        address msgSender = _msgSender();\n', '\n', '        _owner = msgSender;\n', '\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '\n', '    }\n', '\n', '\n', ' \n', '\n', '    function owner() public view returns (address) {\n', '\n', '        return _owner;\n', '\n', '    }\n', '\n', '\n', ' \n', '\n', '    modifier onlyOwner() {\n', '\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '\n', '        _owner = newOwner;\n', '\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 is Context, IERC20, Pausable,Ownable  {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) public blackList;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Blacklisted(address indexed target);\n', '\n', '    event DeleteFromBlacklist(address indexed target);\n', '\n', '    event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint value);\n', '\n', '    event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint value);\n', '\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '\n', '    string private _symbol;\n', '\n', '    uint8 private _decimals;\n', '\n', '\n', '    constructor (string memory name, string memory symbol) public {\n', '\n', '        _name = name;\n', '\n', '        _symbol = symbol;\n', '\n', '        _decimals = 18;\n', '\n', '    }\n', '\n', '    \n', '\n', '    function blacklisting(address _addr) onlyOwner() public{\n', '\n', '        blackList[_addr] = 1;\n', '\n', '        Blacklisted(_addr);\n', '\n', '    }\n', '\n', '    \n', '\n', '    function deleteFromBlacklist(address _addr) onlyOwner() public{\n', '\n', '        blackList[_addr] = 0;\n', '\n', '        DeleteFromBlacklist(_addr);\n', '\n', '    }\n', '\n', '\n', '    function name() public view returns (string memory) {\n', '\n', '        return _name;\n', '\n', '    }\n', '\n', '\n', '    function symbol() public view returns (string memory) {\n', '\n', '        return _symbol;\n', '\n', '    }\n', '\n', '\n', '    function decimals() public view returns (uint8) {\n', '\n', '        return _decimals;\n', '\n', '    }\n', '\n', '\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '\n', '        return _totalSupply;\n', '\n', '    }\n', '\n', '\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '\n', '        return _balances[account];\n', '\n', '    }\n', '\n', '\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual whenNotPaused() override returns (bool) {\n', '\n', '        _transfer(_msgSender(), recipient, amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '\n', '        return _allowances[owner][spender];\n', '\n', '    }\n', '\n', '\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '\n', '        _approve(_msgSender(), spender, amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual whenNotPaused() override returns (bool) {\n', '\n', '        _transfer(sender, recipient, amount);\n', '\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '         if(blackList[msg.sender] == 1){\n', '\n', '        RejectedPaymentFromBlacklistedAddr(msg.sender, recipient, amount);\n', '\n', '        require(false,"You are BlackList");\n', '\n', '        }\n', '\n', '        else if(blackList[recipient] == 1){\n', '\n', '            RejectedPaymentToBlacklistedAddr(msg.sender, recipient, amount);\n', '\n', '            require(false,"recipient are BlackList");\n', '\n', '        }\n', '\n', '        else{\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");\n', '\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '\n', '        _balances[account] = _balances[account].add(amount);\n', '\n', '        emit Transfer(address(0), account, amount);\n', '\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '\n', '        _totalSupply = _totalSupply.sub(amount);\n', '\n', '        emit Transfer(account, address(0), amount);\n', '\n', '    }\n', '\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        _allowances[owner][spender] = amount;\n', '\n', '        emit Approval(owner, spender, amount);\n', '\n', '    }\n', '\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '\n', '        _decimals = decimals_;\n', '\n', '    }\n', '\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '\n', '}\n', '\n', '\n', 'abstract contract ERC20Burnable is Context, ERC20 {\n', '\n', '\n', '    function burn(uint256 amount) public virtual {\n', '\n', '        _burn(_msgSender(), amount);\n', '\n', '    }\n', '\n', '\n', '    function burnFrom(address account, uint256 amount) public virtual {\n', '\n', '        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");\n', '\n', '\n', '        _approve(account, _msgSender(), decreasedAllowance);\n', '\n', '        _burn(account, amount);\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract GINIToken is ERC20,ERC20Burnable {\n', '\n', '    constructor(uint256 initialSupply) public ERC20("GINI", "GINI") {\n', '\n', '        _mint(msg.sender, initialSupply);\n', '\n', '    }\n', '\n', '            function mint(uint256 initialSupply) onlyOwner() public {\n', '\n', '        _mint(msg.sender, initialSupply);\n', '\n', '    }\n', '\n', '    \n', '\n', '        function pause() onlyOwner() public {\n', '\n', '        _pause();\n', '\n', '        }\n', '\n', '       function unpause() onlyOwner() public {\n', '\n', '        _unpause();\n', '\n', '    }\n', '\n', '}']