['pragma solidity ^0.4.20;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', 'library safeMath\n', '{\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256)\n', '  {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256)\n', '  {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Event\n', '{\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Deposit(address indexed sender, uint256 amount , string status);\n', '  event TokenBurn(address indexed from, uint256 value);\n', '  event TokenAdd(address indexed from, uint256 value);\n', '  event Set_Status(string changedStatus);\n', '  event Set_TokenReward(uint256 changedTokenReward);\n', '  event Set_TimeStamp(uint256 ICO_startingTime, uint256 ICO_closingTime);\n', '  event WithdrawETH(uint256 amount);\n', '  event BlockedAddress(address blockedAddress);\n', '  event TempLockedAddress(address tempLockAddress, uint256 unlockTime);\n', '}\n', '\n', 'contract Variable\n', '{\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  uint256 public totalSupply;\n', '  address public owner;\n', '  string public status;\n', '\n', '  uint256 internal _decimals;\n', '  uint256 internal tokenReward;\n', '  uint256 internal ICO_startingTime;\n', '  uint256 internal ICO_closingTime;\n', '  bool internal transferLock;\n', '  bool internal depositLock;\n', '  mapping (address => bool) public allowedAddress;\n', '  mapping (address => bool) public blockedAddress;\n', '  mapping (address => uint256) public tempLockedAddress;\n', '\n', '  address withdraw_wallet;\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '\n', '  constructor() public\n', '  {\n', '    name = "GMB";\n', '    symbol = "GMB";\n', '    decimals = 18;\n', '    _decimals = 10 ** uint256(decimals);\n', '    tokenReward = 0;\n', '    totalSupply = _decimals * 5000000000;\n', '    status = "";\n', '    ICO_startingTime = 0;// 18.01.01 00:00:00 1514732400;\n', '    ICO_closingTime = 0;// 18.12.31 23.59.59 1546268399;\n', '    transferLock = true;\n', '    depositLock = true;\n', '    owner =  0xEfe9f7A61083ffE83Cbf833EeE61Eb1757Dd17BB;\n', '    balanceOf[owner] = totalSupply;\n', '    allowedAddress[owner] = true;\n', '    withdraw_wallet = 0x7f7e8355A4c8fA72222DC66Bbb3E701779a2808F;\n', '  }\n', '}\n', '\n', 'contract Modifiers is Variable\n', '{\n', '  modifier isOwner\n', '  {\n', '    assert(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  modifier isValidAddress\n', '  {\n', '    assert(0x0 != msg.sender);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract Set is Variable, Modifiers, Event\n', '{\n', '  function setStatus(string _status) public isOwner returns(bool success)\n', '  {\n', '    status = _status;\n', '    emit Set_Status(status);\n', '    return true;\n', '  }\n', '  function setTokenReward(uint256 _tokenReward) public isOwner returns(bool success)\n', '  {\n', '    tokenReward = _tokenReward;\n', '    emit Set_TokenReward(tokenReward);\n', '    return true;\n', '  }\n', '  function setTimeStamp(uint256 _ICO_startingTime,uint256 _ICO_closingTime) public isOwner returns(bool success)\n', '  {\n', '    ICO_startingTime = _ICO_startingTime;\n', '    ICO_closingTime = _ICO_closingTime;\n', '\n', '    emit Set_TimeStamp(ICO_startingTime, ICO_closingTime);\n', '    return true;\n', '  }\n', '  function setTransferLock(bool _transferLock) public isOwner returns(bool success)\n', '  {\n', '    transferLock = _transferLock;\n', '    return true;\n', '  }\n', '  function setDepositLock(bool _depositLock) public isOwner returns(bool success)\n', '  {\n', '    depositLock = _depositLock;\n', '    return true;\n', '  }\n', '  function setTimeStampStatus(uint256 _ICO_startingTime, uint256 _ICO_closingTime, string _status) public isOwner returns(bool success)\n', '  {\n', '    ICO_startingTime = _ICO_startingTime;\n', '    ICO_closingTime = _ICO_closingTime;\n', '    status = _status;\n', '    emit Set_TimeStamp(ICO_startingTime,ICO_closingTime);\n', '    emit Set_Status(status);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract manageAddress is Variable, Modifiers, Event\n', '{\n', '\n', '  function add_allowedAddress(address _address) public isOwner\n', '  {\n', '    allowedAddress[_address] = true;\n', '  }\n', '\n', '  function add_blockedAddress(address _address) public isOwner\n', '  {\n', '    require(_address != owner);\n', '    blockedAddress[_address] = true;\n', '    emit BlockedAddress(_address);\n', '  }\n', '\n', '  function delete_allowedAddress(address _address) public isOwner\n', '  {\n', '    require(_address != owner);\n', '    allowedAddress[_address] = false;\n', '  }\n', '\n', '  function delete_blockedAddress(address _address) public isOwner\n', '  {\n', '    blockedAddress[_address] = false;\n', '  }\n', '}\n', '\n', 'contract Get is Variable, Modifiers\n', '{\n', '  function get_tokenTime() public view returns(uint256 start, uint256 stop)\n', '  {\n', '    return (ICO_startingTime,ICO_closingTime);\n', '  }\n', '  function get_transferLock() public view returns(bool)\n', '  {\n', '    return transferLock;\n', '  }\n', '  function get_depositLock() public view returns(bool)\n', '  {\n', '    return depositLock;\n', '  }\n', '  function get_tokenReward() public view returns(uint256)\n', '  {\n', '    return tokenReward;\n', '  }\n', '\n', '}\n', '\n', 'contract Admin is Variable, Modifiers, Event\n', '{\n', '  function admin_transfer_tempLockAddress(address _to, uint256 _value, uint256 _unlockTime) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[msg.sender] >= _value);\n', '    require(balanceOf[_to] + (_value ) >= balanceOf[_to]);\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    tempLockedAddress[_to] = _unlockTime;\n', '    emit Transfer(msg.sender, _to, _value);\n', '    emit TempLockedAddress(_to, _unlockTime);\n', '    return true;\n', '  }\n', '  function admin_transferFrom(address _from, address _to, uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[_from] >= _value);\n', '    require(balanceOf[_to] + (_value ) >= balanceOf[_to]);\n', '    balanceOf[_from] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[msg.sender] >= _value);\n', '    balanceOf[msg.sender] -= _value;\n', '    totalSupply -= _value;\n', '    emit TokenBurn(msg.sender, _value);\n', '    return true;\n', '  }\n', '  function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    balanceOf[msg.sender] += _value;\n', '    totalSupply += _value;\n', '    emit TokenAdd(msg.sender, _value);\n', '    return true;\n', '  }\n', '  function admin_renewLockedAddress(address _address, uint256 _unlockTime) public isOwner returns(bool success)\n', '  {\n', '    tempLockedAddress[_address] = _unlockTime;\n', '    emit TempLockedAddress(_address, _unlockTime);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract GMB is Variable, Event, Get, Set, Admin, manageAddress\n', '{\n', '  using safeMath for uint256;\n', '\n', '  function() payable public\n', '  {\n', '    require(ICO_startingTime < block.timestamp && ICO_closingTime > block.timestamp);\n', '    require(!depositLock);\n', '    uint256 tokenValue;\n', '    tokenValue = (msg.value).mul(tokenReward);\n', '    require(balanceOf[owner] >= tokenValue);\n', '    require(balanceOf[msg.sender].add(tokenValue) >= balanceOf[msg.sender]);\n', '    emit Deposit(msg.sender, msg.value, status);\n', '    balanceOf[owner] -= tokenValue;\n', '    balanceOf[msg.sender] += tokenValue;\n', '    emit Transfer(owner, msg.sender, tokenValue);\n', '  }\n', '  function transfer(address _to, uint256 _value) public isValidAddress\n', '  {\n', '    require(allowedAddress[msg.sender] || transferLock == false);\n', '    require(tempLockedAddress[msg.sender] < block.timestamp);\n', '    require(!blockedAddress[msg.sender] && !blockedAddress[_to]);\n', '    require(balanceOf[msg.sender] >= _value);\n', '    require((balanceOf[_to].add(_value)) >= balanceOf[_to]);\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '  }\n', '  function ETH_withdraw(uint256 amount) public isOwner returns(bool)\n', '  {\n', '    withdraw_wallet.transfer(amount);\n', '    emit WithdrawETH(amount);\n', '    return true;\n', '  }\n', '}']
['pragma solidity ^0.4.20;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', 'library safeMath\n', '{\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256)\n', '  {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256)\n', '  {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Event\n', '{\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Deposit(address indexed sender, uint256 amount , string status);\n', '  event TokenBurn(address indexed from, uint256 value);\n', '  event TokenAdd(address indexed from, uint256 value);\n', '  event Set_Status(string changedStatus);\n', '  event Set_TokenReward(uint256 changedTokenReward);\n', '  event Set_TimeStamp(uint256 ICO_startingTime, uint256 ICO_closingTime);\n', '  event WithdrawETH(uint256 amount);\n', '  event BlockedAddress(address blockedAddress);\n', '  event TempLockedAddress(address tempLockAddress, uint256 unlockTime);\n', '}\n', '\n', 'contract Variable\n', '{\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  uint256 public totalSupply;\n', '  address public owner;\n', '  string public status;\n', '\n', '  uint256 internal _decimals;\n', '  uint256 internal tokenReward;\n', '  uint256 internal ICO_startingTime;\n', '  uint256 internal ICO_closingTime;\n', '  bool internal transferLock;\n', '  bool internal depositLock;\n', '  mapping (address => bool) public allowedAddress;\n', '  mapping (address => bool) public blockedAddress;\n', '  mapping (address => uint256) public tempLockedAddress;\n', '\n', '  address withdraw_wallet;\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '\n', '  constructor() public\n', '  {\n', '    name = "GMB";\n', '    symbol = "GMB";\n', '    decimals = 18;\n', '    _decimals = 10 ** uint256(decimals);\n', '    tokenReward = 0;\n', '    totalSupply = _decimals * 5000000000;\n', '    status = "";\n', '    ICO_startingTime = 0;// 18.01.01 00:00:00 1514732400;\n', '    ICO_closingTime = 0;// 18.12.31 23.59.59 1546268399;\n', '    transferLock = true;\n', '    depositLock = true;\n', '    owner =  0xEfe9f7A61083ffE83Cbf833EeE61Eb1757Dd17BB;\n', '    balanceOf[owner] = totalSupply;\n', '    allowedAddress[owner] = true;\n', '    withdraw_wallet = 0x7f7e8355A4c8fA72222DC66Bbb3E701779a2808F;\n', '  }\n', '}\n', '\n', 'contract Modifiers is Variable\n', '{\n', '  modifier isOwner\n', '  {\n', '    assert(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  modifier isValidAddress\n', '  {\n', '    assert(0x0 != msg.sender);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract Set is Variable, Modifiers, Event\n', '{\n', '  function setStatus(string _status) public isOwner returns(bool success)\n', '  {\n', '    status = _status;\n', '    emit Set_Status(status);\n', '    return true;\n', '  }\n', '  function setTokenReward(uint256 _tokenReward) public isOwner returns(bool success)\n', '  {\n', '    tokenReward = _tokenReward;\n', '    emit Set_TokenReward(tokenReward);\n', '    return true;\n', '  }\n', '  function setTimeStamp(uint256 _ICO_startingTime,uint256 _ICO_closingTime) public isOwner returns(bool success)\n', '  {\n', '    ICO_startingTime = _ICO_startingTime;\n', '    ICO_closingTime = _ICO_closingTime;\n', '\n', '    emit Set_TimeStamp(ICO_startingTime, ICO_closingTime);\n', '    return true;\n', '  }\n', '  function setTransferLock(bool _transferLock) public isOwner returns(bool success)\n', '  {\n', '    transferLock = _transferLock;\n', '    return true;\n', '  }\n', '  function setDepositLock(bool _depositLock) public isOwner returns(bool success)\n', '  {\n', '    depositLock = _depositLock;\n', '    return true;\n', '  }\n', '  function setTimeStampStatus(uint256 _ICO_startingTime, uint256 _ICO_closingTime, string _status) public isOwner returns(bool success)\n', '  {\n', '    ICO_startingTime = _ICO_startingTime;\n', '    ICO_closingTime = _ICO_closingTime;\n', '    status = _status;\n', '    emit Set_TimeStamp(ICO_startingTime,ICO_closingTime);\n', '    emit Set_Status(status);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract manageAddress is Variable, Modifiers, Event\n', '{\n', '\n', '  function add_allowedAddress(address _address) public isOwner\n', '  {\n', '    allowedAddress[_address] = true;\n', '  }\n', '\n', '  function add_blockedAddress(address _address) public isOwner\n', '  {\n', '    require(_address != owner);\n', '    blockedAddress[_address] = true;\n', '    emit BlockedAddress(_address);\n', '  }\n', '\n', '  function delete_allowedAddress(address _address) public isOwner\n', '  {\n', '    require(_address != owner);\n', '    allowedAddress[_address] = false;\n', '  }\n', '\n', '  function delete_blockedAddress(address _address) public isOwner\n', '  {\n', '    blockedAddress[_address] = false;\n', '  }\n', '}\n', '\n', 'contract Get is Variable, Modifiers\n', '{\n', '  function get_tokenTime() public view returns(uint256 start, uint256 stop)\n', '  {\n', '    return (ICO_startingTime,ICO_closingTime);\n', '  }\n', '  function get_transferLock() public view returns(bool)\n', '  {\n', '    return transferLock;\n', '  }\n', '  function get_depositLock() public view returns(bool)\n', '  {\n', '    return depositLock;\n', '  }\n', '  function get_tokenReward() public view returns(uint256)\n', '  {\n', '    return tokenReward;\n', '  }\n', '\n', '}\n', '\n', 'contract Admin is Variable, Modifiers, Event\n', '{\n', '  function admin_transfer_tempLockAddress(address _to, uint256 _value, uint256 _unlockTime) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[msg.sender] >= _value);\n', '    require(balanceOf[_to] + (_value ) >= balanceOf[_to]);\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    tempLockedAddress[_to] = _unlockTime;\n', '    emit Transfer(msg.sender, _to, _value);\n', '    emit TempLockedAddress(_to, _unlockTime);\n', '    return true;\n', '  }\n', '  function admin_transferFrom(address _from, address _to, uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[_from] >= _value);\n', '    require(balanceOf[_to] + (_value ) >= balanceOf[_to]);\n', '    balanceOf[_from] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    require(balanceOf[msg.sender] >= _value);\n', '    balanceOf[msg.sender] -= _value;\n', '    totalSupply -= _value;\n', '    emit TokenBurn(msg.sender, _value);\n', '    return true;\n', '  }\n', '  function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)\n', '  {\n', '    balanceOf[msg.sender] += _value;\n', '    totalSupply += _value;\n', '    emit TokenAdd(msg.sender, _value);\n', '    return true;\n', '  }\n', '  function admin_renewLockedAddress(address _address, uint256 _unlockTime) public isOwner returns(bool success)\n', '  {\n', '    tempLockedAddress[_address] = _unlockTime;\n', '    emit TempLockedAddress(_address, _unlockTime);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract GMB is Variable, Event, Get, Set, Admin, manageAddress\n', '{\n', '  using safeMath for uint256;\n', '\n', '  function() payable public\n', '  {\n', '    require(ICO_startingTime < block.timestamp && ICO_closingTime > block.timestamp);\n', '    require(!depositLock);\n', '    uint256 tokenValue;\n', '    tokenValue = (msg.value).mul(tokenReward);\n', '    require(balanceOf[owner] >= tokenValue);\n', '    require(balanceOf[msg.sender].add(tokenValue) >= balanceOf[msg.sender]);\n', '    emit Deposit(msg.sender, msg.value, status);\n', '    balanceOf[owner] -= tokenValue;\n', '    balanceOf[msg.sender] += tokenValue;\n', '    emit Transfer(owner, msg.sender, tokenValue);\n', '  }\n', '  function transfer(address _to, uint256 _value) public isValidAddress\n', '  {\n', '    require(allowedAddress[msg.sender] || transferLock == false);\n', '    require(tempLockedAddress[msg.sender] < block.timestamp);\n', '    require(!blockedAddress[msg.sender] && !blockedAddress[_to]);\n', '    require(balanceOf[msg.sender] >= _value);\n', '    require((balanceOf[_to].add(_value)) >= balanceOf[_to]);\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '  }\n', '  function ETH_withdraw(uint256 amount) public isOwner returns(bool)\n', '  {\n', '    withdraw_wallet.transfer(amount);\n', '    emit WithdrawETH(amount);\n', '    return true;\n', '  }\n', '}']
