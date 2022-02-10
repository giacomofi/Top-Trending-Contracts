['pragma solidity ^0.4.20;\n', '\n', '\n', 'library safeMath\n', '{\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256)\n', '  {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256)\n', '  {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Variable\n', '{\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  uint256 public totalSupply;\n', '  address public owner;\n', '  address public watchdog;\n', '\n', '  uint256 internal _decimals;\n', '  bool internal transferLock;\n', '  bool internal depositLock;\n', '  mapping (address => bool) public allowedAddress;\n', '  mapping (address => bool) public blockedAddress;\n', '  mapping (address => uint256) public tempLockedAddress;\n', '\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '  constructor() public\n', '  {\n', '    name = "GMB";\n', '    symbol = "GMB";\n', '    decimals = 18;\n', '    _decimals = 10 ** uint256(decimals);\n', '    totalSupply = _decimals * 5000000000;\n', '    transferLock = true;\n', '    depositLock = true;\n', '    owner =  msg.sender;\n', '    balanceOf[owner] = totalSupply;\n', '    allowedAddress[owner] = true;\n', '    watchdog = 0xC124570F91c00105bF8ccD56c03405997918fbd8;\n', '  }\n', '}\n', '\n', 'contract Modifiers is Variable\n', '{\n', '  address public newWatchdog;\n', '  address public newOwner;\n', '\n', '  modifier isOwner\n', '  {\n', '    assert(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  modifier isValidAddress\n', '  {\n', '    assert(0x0 != msg.sender);\n', '    _;\n', '  }\n', '\n', '  modifier isWatchdog\n', '  {\n', '    assert(watchdog == msg.sender);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public isWatchdog\n', '  {\n', '      newOwner = _newOwner;\n', '  }\n', '\n', '  function transferOwnershipWatchdog(address _newWatchdog) public isOwner\n', '  {\n', '      newWatchdog = _newWatchdog;\n', '  }\n', '\n', '  function acceptOwnership() public isOwner\n', '  {\n', '      require(newOwner != 0x0);\n', '      owner = newOwner;\n', '      newOwner = address(0);\n', '  }\n', '\n', '  function acceptOwnershipWatchdog() public isWatchdog\n', '  {\n', '      require(newWatchdog != 0x0);\n', '      watchdog = newWatchdog;\n', '      newWatchdog = address(0);\n', '  }\n', '}\n', '\n', 'contract Event\n', '{\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Deposit(address indexed sender, uint256 amount , string status);\n', '  event TokenBurn(address indexed from, uint256 value);\n', '  event TokenAdd(address indexed from, uint256 value);\n', '  event BlockedAddress(address blockedAddress);\n', '}\n', '\n', 'contract manageAddress is Variable, Modifiers, Event\n', '{\n', '  function add_allowedAddress(address _address) public isOwner\n', '  {\n', '    allowedAddress[_address] = true;\n', '  }\n', '\n', '  function add_blockedAddress(address _address) public isOwner\n', '  {\n', '    require(_address != owner);\n', '    blockedAddress[_address] = true;\n', '    emit BlockedAddress(_address);\n', '  }\n', '\n', '  function delete_allowedAddress(address _address) public isOwner\n', '  {\n', '    require(_address != owner);\n', '    allowedAddress[_address] = false;\n', '  }\n', '\n', '  function delete_blockedAddress(address _address) public isOwner\n', '  {\n', '    blockedAddress[_address] = false;\n', '  }\n', '}\n', '\n', 'contract Admin is Variable, Modifiers, Event\n', '{\n', '  function admin_transferFrom(address _from, uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[_from] >= _value);\n', '    require(balanceOf[owner] + (_value ) >= balanceOf[owner]);\n', '    balanceOf[_from] -= _value;\n', '    balanceOf[owner] += _value;\n', '    emit Transfer(_from, owner, _value);\n', '    return true;\n', '  }\n', '  function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[msg.sender] >= _value);\n', '    balanceOf[msg.sender] -= _value;\n', '    totalSupply -= _value;\n', '    emit TokenBurn(msg.sender, _value);\n', '    return true;\n', '  }\n', '  function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    balanceOf[msg.sender] += _value;\n', '    totalSupply += _value;\n', '    emit TokenAdd(msg.sender, _value);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract Get is Variable, Modifiers\n', '{\n', '  function get_transferLock() public view returns(bool)\n', '  {\n', '    return transferLock;\n', '  }\n', '  function get_depositLock() public view returns(bool)\n', '  {\n', '    return depositLock;\n', '  }\n', '}\n', '\n', 'contract Set is Variable, Modifiers, Event\n', '{\n', '  function setTransferLock(bool _transferLock) public isOwner returns(bool success)\n', '  {\n', '    transferLock = _transferLock;\n', '    return true;\n', '  }\n', '  function setDepositLock(bool _depositLock) public isOwner returns(bool success)\n', '  {\n', '    depositLock = _depositLock;\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract GMB is Variable, Event, Get, Set, Admin, manageAddress\n', '{\n', '  using safeMath for uint256;\n', '\n', '  function() payable public\n', '  {\n', '    revert();\n', '  }\n', '  function transfer(address _to, uint256 _value) public isValidAddress\n', '  {\n', '    require(allowedAddress[msg.sender] || transferLock == false);\n', '    require(!blockedAddress[msg.sender] && !blockedAddress[_to]);\n', '    require(balanceOf[msg.sender] >= _value);\n', '    require((balanceOf[_to].add(_value)) >= balanceOf[_to]);\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '  }\n', '}']