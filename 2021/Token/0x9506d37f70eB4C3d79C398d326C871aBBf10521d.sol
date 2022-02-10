['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-14\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.4;\n', '\n', 'abstract contract Context {\n', '  function _msgSender() internal view virtual returns (address) {\n', '    return msg.sender;\n', '  }\n', '\n', '  function _msgData() internal view virtual returns (bytes calldata) {\n', '    this;\n', '    return msg.data;\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address account) external view returns (uint256);\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IERC20Metadata is IERC20 {\n', '\n', '  function name() external view returns (string memory);\n', '  function symbol() external view returns (string memory);\n', '  function decimals() external view returns (uint8);\n', '}\n', '\n', 'abstract contract Ownable is Context {\n', '\n', '  // Holds the owner address\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor () {\n', '    address msgSender = _msgSender();\n', '    _owner = msgSender;\n', '    emit OwnershipTransferred(address(0), msgSender);\n', '  }\n', '\n', '  function owner() public view virtual returns (address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public virtual onlyOwner {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '// Our main contract which implements all ERC20 standard methods\n', 'contract MediaLicensingToken is Context, IERC20, IERC20Metadata, Ownable {\n', '\n', '  // Holds all the balances\n', '  mapping (address => uint256) private _balances;\n', '\n', '  // Holds all allowances\n', '  mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '  // Holds all blacklisted addresses\n', '  mapping (address => bool) private _blocklist;\n', '\n', '  // They can only be decreased\n', '  uint256 private _totalSupply;\n', '\n', '  // Immutable they can only be set once during construction\n', '  string private _name;\n', '  string private _symbol;\n', '  uint256 private _maxTokens;\n', '\n', '  // Events\n', '  event Blocklist(address indexed account, bool indexed status);\n', '\n', '  // The initializer of our contract\n', '  constructor () {\n', '    _name = "Media Licensing Token";\n', '    _symbol = "MLT";\n', '\n', '    // Holds max mintable limit, 200 million tokens\n', '    _maxTokens = 200000000000000000000000000;\n', '    _mint(_msgSender(), _maxTokens);\n', '  }\n', '\n', '  /*\n', '   * PUBLIC RETURNS\n', '   */\n', '\n', '  // Returns the name of the token.\n', '  function name() public view virtual override returns (string memory) {\n', '    return _name;\n', '  }\n', '\n', '  // Returns the symbol of the token\n', '  function symbol() public view virtual override returns (string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  // Returns the number of decimals used\n', '  function decimals() public view virtual override returns (uint8) {\n', '    return 18;\n', '  }\n', '\n', '  // Returns the total supply\n', '  function totalSupply() public view virtual override returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  // Returns the balance of a given address\n', '  function balanceOf(address account) public view virtual override returns (uint256) {\n', '    return _balances[account];\n', '  }\n', '\n', '  // Returns the allowances of the given addresses\n', '  function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '    return _allowances[owner][spender];\n', '  }\n', '\n', '  // Returns a blocked address of a given address\n', '  function isBlocked(address account) public view virtual returns (bool) {\n', '    return _blocklist[account];\n', '  }\n', '\n', '  /*\n', '   * PUBLIC FUNCTIONS\n', '   */\n', '\n', '  // Calls the _transfer function for a given recipient and amount\n', '  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '    _transfer(_msgSender(), recipient, amount);\n', '    return true;\n', '  }\n', '\n', '  // Calls the _transfer function for a given array of recipients and amounts\n', '  function transferArray(address[] calldata recipients, uint256[] calldata amounts) public virtual returns (bool) {\n', '    for (uint8 count = 0; count < recipients.length; count++) {\n', '      _transfer(_msgSender(), recipients[count], amounts[count]);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  // Calls the _approve function for a given spender and amount\n', '  function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '    _approve(_msgSender(), spender, amount);\n', '    return true;\n', '  }\n', '\n', '  // Calls the _transfer and _approve function for a given sender, recipient and amount\n', '  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '    _transfer(sender, recipient, amount);\n', '\n', '    uint256 currentAllowance = _allowances[sender][_msgSender()];\n', '    require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '    _approve(sender, _msgSender(), currentAllowance - amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  // Calls the _approve function for a given spender and added value (amount)\n', '  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '    _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n', '    return true;\n', '  }\n', '\n', '  // Calls the _approve function for a given spender and substracted value (amount)\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '    uint256 currentAllowance = _allowances[_msgSender()][spender];\n', '    require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '    _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n', '\n', '    return true;\n', '  }\n', '\n', '  /*\n', '   * PUBLIC (Only Owner)\n', '   */\n', '\n', '  // Calls the _burn internal function for a given amount\n', '  function burn(uint256 amount) public virtual onlyOwner {\n', '    _burn(_msgSender(), amount);\n', '  }\n', '\n', '  function blockAddress (address account) public virtual onlyOwner {\n', '    _block(account, true);\n', '  }\n', '\n', '  function unblockAddress (address account) public virtual onlyOwner {\n', '    _block(account, false);\n', '  }\n', '\n', '  /*\n', '   * INTERNAL (PRIVATE)\n', '   */\n', '\n', '  function _block (address account, bool status) internal virtual {\n', '    require(account != _msgSender(), "ERC20: message sender can not block or unblock himself");\n', '    _blocklist[account] = status;\n', '\n', '    emit Blocklist(account, status);\n', '  }\n', '\n', '  // Implements the transfer function for a given sender, recipient and amount\n', '  function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '    require(sender != address(0), "ERC20: transfer from the zero address");\n', '    require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '    _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '    uint256 senderBalance = _balances[sender];\n', '    require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '    _balances[sender] = senderBalance - amount;\n', '    _balances[recipient] += amount;\n', '\n', '    emit Transfer(sender, recipient, amount);\n', '  }\n', '\n', '  // Implements the mint function for a given account and amount\n', '  function _mint(address account, uint256 amount) internal virtual {\n', '    require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '    _beforeTokenTransfer(address(0), account, amount);\n', '\n', '    _totalSupply += amount;\n', '    // Paranoid security\n', '    require(_totalSupply <= _maxTokens, "ERC20: mint exceeds total supply limit");\n', '\n', '    _balances[account] += amount;\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  // Implements the burn function for a given account and amount\n', '  function _burn(address account, uint256 amount) internal virtual {\n', '    require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '    _beforeTokenTransfer(account, address(0), amount);\n', '\n', '    uint256 accountBalance = _balances[account];\n', '    require(accountBalance >= amount, "ERC20: burn amount exceeds balance");\n', '    _balances[account] = accountBalance - amount;\n', '    _totalSupply -= amount;\n', '\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  // Implements the approve function for a given owner, spender and amount\n', '  function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '    require(owner != address(0), "ERC20: approve from the zero address");\n', '    require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '    _allowances[owner][spender] = amount;\n', '    emit Approval(owner, spender, amount);\n', '  }\n', '\n', '  /*\n', '   * INTERNAL (PRIVATE) HELPERS\n', '   */\n', '\n', '  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {\n', '    require(_blocklist[from] == false && _blocklist[to] == false, "MLTERC20: transfer not allowed");\n', '    require(amount > 0, "ERC20: amount must be above zero");\n', '  }\n', '}']