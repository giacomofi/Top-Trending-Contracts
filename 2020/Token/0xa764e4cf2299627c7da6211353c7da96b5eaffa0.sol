['/*   \n', '\n', 'Sunrisenet Finance\n', '\n', 'https://sunrisenet.finance\n', '\n', 'SPDX-License-Identifier: MIT\n', '\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// library to prevent overflow for uint256\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/ERC20.sol\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) internal _balances;\n', '    mapping (address => mapping (address => uint256)) internal _allowances;\n', '    mapping (address => bool) internal _whitelist;\n', '    bool internal _globalWhitelist = true;\n', '\n', '    uint256 internal _totalSupply;\n', '\n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal burnRate = 10; // Burn Rate is 10%\n', '\n', '    constructor (string memory name, string memory symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = 18;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', ' \n', '        if (_globalWhitelist == false) {\n', '          if (_whitelist[sender] == false && _whitelist[recipient] == false) { // recipient being staking pools; sender used for presale airdrop\n', '            amount = _burn(sender, amount, burnRate);\n', '          }\n', '        }\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual { }\n', '\n', '    /* Takes an amount, burns % of it, returns remaining amount */\n', '    function _burn(address account, uint256 amount, uint256 bRate) internal virtual returns(uint256) { \n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '        require(bRate <= 100, "Can\'t burn more than 100%!");\n', '\n', '        uint256 burnCalc = (amount.mul(bRate).div(100));\n', '        uint256 remainingAfterBurn = amount.sub(burnCalc);\n', '\n', '        _balances[account] = _balances[account].sub(burnCalc, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(burnCalc);\n', '        emit Transfer(account, address(0), burnCalc);\n', '        return (remainingAfterBurn);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol\n', '\n', 'abstract contract ERC20Capped is ERC20 {\n', '    uint256 private _cap;\n', '\n', '    constructor (uint256 cap) public {\n', '        require(cap > 0, "ERC20Capped: cap is 0");\n', '        _cap = cap;\n', '    }\n', '\n', '    function cap() public view returns (uint256) {\n', '        return _cap;\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual override(ERC20) {\n', '        require(account != address(0), " ERC20: mint to the zeroaddress");\n', '        require((_totalSupply.add(amount)) < _cap, " ERC20: Minting exceeds cap!");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', 'contract Ownable {\n', '    \n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, " Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), " Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: eth-token-recover/contracts/TokenRecover.sol\n', '\n', 'contract TokenRecover is Ownable {\n', '\n', '    function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {\n', '        IERC20(tokenAddress).transfer(owner(), tokenAmount);\n', '    }\n', '}\n', '\n', '// File: contracts/BaseToken.sol\n', '\n', 'contract Sunrisenet is ERC20Capped, TokenRecover {\n', '\n', '    // indicates if minting is finished\n', '    bool private _mintingFinished = false;\n', '    bool _transferEnabled = false;\n', '    event MintFinished();\n', '    event TransferEnabled();\n', '\n', '    mapping (address => bool) internal _transWhitelist;\n', '        \n', '\n', '    modifier canMint() {\n', '        require(!_mintingFinished, "BaseToken: minting is finished");\n', '        _;\n', '    }\n', '\n', "    constructor() public ERC20('Sunrisenet Finance', 'SRN') ERC20Capped(10e23) {\n", '      uint256 initialSupply = 10e22;\n', '\n', '      _mint(owner(), initialSupply);\n', '      whitelist(msg.sender);\n', '      transferWhitelist(msg.sender);\n', '\n', '    }\n', '    function burn(uint256 amount, uint256 bRate) public returns(uint256) {\n', '        return _burn(msg.sender, amount, bRate);\n', '    }\n', '\n', '    function mintingFinished() public view returns (bool) {\n', '        return _mintingFinished;\n', '    }\n', '\n', '    function mint(address to, uint256 value) public canMint onlyOwner {\n', '        _mint(to, value);\n', '    }\n', '\n', '    function finishMinting() public canMint onlyOwner {\n', '        _mintingFinished = true;\n', '        emit MintFinished();\n', '    }\n', '\n', '    modifier canTransfer(address from) {\n', '        require(\n', '            _transferEnabled || _transWhitelist[from],\n', '            "BaseToken:transfer is not enabled or from isn\'t whitelisted."\n', '        );\n', '        _;\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(msg.sender) returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '\n', '    function enableTransfer() public onlyOwner {\n', '        _transferEnabled = true;\n', '        emit TransferEnabled();\n', '    }\n', '\n', '    function isTransferEnabled() public view returns(bool) {\n', '        return _transferEnabled;\n', '    }\n', '\n', '    function isTransferWhitelisted(address user) public view returns(bool) {\n', '        return _transWhitelist[user];\n', '    }\n', '\n', '    // Ensuring an equitable public launch \n', '    function transferWhitelist(address user) public onlyOwner returns(bool) {\n', '        _transWhitelist[user] = true;\n', '        return true;\n', '    }\n', '\n', '    function setGlobalWhitelist(bool state) public onlyOwner {\n', '       _globalWhitelist = state;\n', '    }\n', '\n', '    function globalWhitelistState() public view returns(bool) {\n', '        return _globalWhitelist;\n', '    }\n', '\n', '    // Removes user burn immunity\n', '    function unwhitelist(address user) public onlyOwner returns(bool) {\n', '       _whitelist[user] = false;\n', '       return true;\n', '    }\n', '\n', '    function isWhitelisted(address user) public view returns(bool) {\n', '       return _whitelist[user];\n', '    }\n', '    \n', '    // Allows user to be immune to burn during transfer\n', '    function whitelist(address user) public onlyOwner returns(bool) {\n', '       _whitelist[user] = true;\n', '       return true;\n', '    }\n', '\n', '    // In case of catastrophic failure\n', '    function setBurnRate(uint256 rate) public onlyOwner {\n', '       burnRate = rate;\n', '    }\n', '\n', '}']