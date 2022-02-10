['pragma solidity 0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', 'contract ControllerInterface {\n', '\n', '\n', '  // State Variables\n', '  bool public paused;\n', '\n', '  // Nutz functions\n', '  function babzBalanceOf(address _owner) constant returns (uint256);\n', '  function activeSupply() constant returns (uint256);\n', '  function burnPool() constant returns (uint256);\n', '  function powerPool() constant returns (uint256);\n', '  function totalSupply() constant returns (uint256);\n', '  function allowance(address _owner, address _spender) constant returns (uint256);\n', '\n', '  function approve(address _owner, address _spender, uint256 _amountBabz) public;\n', '  function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool);\n', '  function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool);\n', '\n', '  // Market functions\n', '  function floor() constant returns (uint256);\n', '  function ceiling() constant returns (uint256);\n', '\n', '  function purchase(address _sender, uint256 _price) public payable returns (uint256, bool);\n', '  function sell(address _from, uint256 _price, uint256 _amountBabz) public;\n', '\n', '  // Power functions\n', '  function powerBalanceOf(address _owner) constant returns (uint256);\n', '  function outstandingPower() constant returns (uint256);\n', '  function authorizedPower() constant returns (uint256);\n', '  function powerTotalSupply() constant returns (uint256);\n', '\n', '  function powerUp(address _sender, address _from, uint256 _amountBabz) public;\n', '  function downTick(uint256 _pos, uint256 _now) public;\n', '  function createDownRequest(address _owner, uint256 _amountPower) public;\n', '}\n', '\n', '/**\n', ' * @title PullPayment\n', ' * @dev Base contract supporting async send for pull payments.\n', ' */\n', 'contract PullPayment is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  struct Payment {\n', '    uint256 value;  // TODO: use compact storage\n', '    uint256 date;   //\n', '  }\n', '\n', '  uint public dailyLimit = 1000000000000000000000;  // 1 ETH\n', '  uint public lastDay;\n', '  uint public spentToday;\n', '\n', '  mapping(address => Payment) internal payments;\n', '\n', '  modifier whenNotPaused () {\n', '    require(!ControllerInterface(owner).paused());\n', '     _;\n', '  }\n', '  function balanceOf(address _owner) constant returns (uint256 value) {\n', '    return payments[_owner].value;\n', '  }\n', '\n', '  function paymentOf(address _owner) constant returns (uint256 value, uint256 date) {\n', '    value = payments[_owner].value;\n', '    date = payments[_owner].date;\n', '    return;\n', '  }\n', '\n', '  /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.\n', '  /// @param _dailyLimit Amount in wei.\n', '  function changeDailyLimit(uint _dailyLimit) public onlyOwner {\n', '      dailyLimit = _dailyLimit;\n', '  }\n', '\n', '  function changeWithdrawalDate(address _owner, uint256 _newDate)  public onlyOwner {\n', '    // allow to withdraw immediately\n', '    // move witdrawal date more days into future\n', '    payments[_owner].date = _newDate;\n', '  }\n', '\n', '  function asyncSend(address _dest) public payable onlyOwner {\n', '    require(msg.value > 0);\n', '    uint256 newValue = payments[_dest].value.add(msg.value);\n', '    uint256 newDate;\n', '    if (isUnderLimit(msg.value)) {\n', '      newDate = (payments[_dest].date > now) ? payments[_dest].date : now;\n', '    } else {\n', '      newDate = now.add(3 days);\n', '    }\n', '    spentToday = spentToday.add(msg.value);\n', '    payments[_dest] = Payment(newValue, newDate);\n', '  }\n', '\n', '\n', '  function withdraw() public whenNotPaused {\n', '    address untrustedRecipient = msg.sender;\n', '    uint256 amountWei = payments[untrustedRecipient].value;\n', '\n', '    require(amountWei != 0);\n', '    require(now >= payments[untrustedRecipient].date);\n', '    require(this.balance >= amountWei);\n', '\n', '    payments[untrustedRecipient].value = 0;\n', '\n', '    untrustedRecipient.transfer(amountWei);\n', '  }\n', '\n', '  /*\n', '   * Internal functions\n', '   */\n', '  /// @dev Returns if amount is within daily limit and resets spentToday after one day.\n', '  /// @param amount Amount to withdraw.\n', '  /// @return Returns if amount is under daily limit.\n', '  function isUnderLimit(uint amount) internal returns (bool) {\n', '    if (now > lastDay.add(24 hours)) {\n', '      lastDay = now;\n', '      spentToday = 0;\n', '    }\n', '    // not using safe math because we don&#39;t want to throw;\n', '    if (spentToday + amount > dailyLimit || spentToday + amount < spentToday) {\n', '      return false;\n', '    }\n', '    return true;\n', '  }\n', '\n', '}']
['pragma solidity 0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', 'contract ControllerInterface {\n', '\n', '\n', '  // State Variables\n', '  bool public paused;\n', '\n', '  // Nutz functions\n', '  function babzBalanceOf(address _owner) constant returns (uint256);\n', '  function activeSupply() constant returns (uint256);\n', '  function burnPool() constant returns (uint256);\n', '  function powerPool() constant returns (uint256);\n', '  function totalSupply() constant returns (uint256);\n', '  function allowance(address _owner, address _spender) constant returns (uint256);\n', '\n', '  function approve(address _owner, address _spender, uint256 _amountBabz) public;\n', '  function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool);\n', '  function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool);\n', '\n', '  // Market functions\n', '  function floor() constant returns (uint256);\n', '  function ceiling() constant returns (uint256);\n', '\n', '  function purchase(address _sender, uint256 _price) public payable returns (uint256, bool);\n', '  function sell(address _from, uint256 _price, uint256 _amountBabz) public;\n', '\n', '  // Power functions\n', '  function powerBalanceOf(address _owner) constant returns (uint256);\n', '  function outstandingPower() constant returns (uint256);\n', '  function authorizedPower() constant returns (uint256);\n', '  function powerTotalSupply() constant returns (uint256);\n', '\n', '  function powerUp(address _sender, address _from, uint256 _amountBabz) public;\n', '  function downTick(uint256 _pos, uint256 _now) public;\n', '  function createDownRequest(address _owner, uint256 _amountPower) public;\n', '}\n', '\n', '/**\n', ' * @title PullPayment\n', ' * @dev Base contract supporting async send for pull payments.\n', ' */\n', 'contract PullPayment is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  struct Payment {\n', '    uint256 value;  // TODO: use compact storage\n', '    uint256 date;   //\n', '  }\n', '\n', '  uint public dailyLimit = 1000000000000000000000;  // 1 ETH\n', '  uint public lastDay;\n', '  uint public spentToday;\n', '\n', '  mapping(address => Payment) internal payments;\n', '\n', '  modifier whenNotPaused () {\n', '    require(!ControllerInterface(owner).paused());\n', '     _;\n', '  }\n', '  function balanceOf(address _owner) constant returns (uint256 value) {\n', '    return payments[_owner].value;\n', '  }\n', '\n', '  function paymentOf(address _owner) constant returns (uint256 value, uint256 date) {\n', '    value = payments[_owner].value;\n', '    date = payments[_owner].date;\n', '    return;\n', '  }\n', '\n', '  /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.\n', '  /// @param _dailyLimit Amount in wei.\n', '  function changeDailyLimit(uint _dailyLimit) public onlyOwner {\n', '      dailyLimit = _dailyLimit;\n', '  }\n', '\n', '  function changeWithdrawalDate(address _owner, uint256 _newDate)  public onlyOwner {\n', '    // allow to withdraw immediately\n', '    // move witdrawal date more days into future\n', '    payments[_owner].date = _newDate;\n', '  }\n', '\n', '  function asyncSend(address _dest) public payable onlyOwner {\n', '    require(msg.value > 0);\n', '    uint256 newValue = payments[_dest].value.add(msg.value);\n', '    uint256 newDate;\n', '    if (isUnderLimit(msg.value)) {\n', '      newDate = (payments[_dest].date > now) ? payments[_dest].date : now;\n', '    } else {\n', '      newDate = now.add(3 days);\n', '    }\n', '    spentToday = spentToday.add(msg.value);\n', '    payments[_dest] = Payment(newValue, newDate);\n', '  }\n', '\n', '\n', '  function withdraw() public whenNotPaused {\n', '    address untrustedRecipient = msg.sender;\n', '    uint256 amountWei = payments[untrustedRecipient].value;\n', '\n', '    require(amountWei != 0);\n', '    require(now >= payments[untrustedRecipient].date);\n', '    require(this.balance >= amountWei);\n', '\n', '    payments[untrustedRecipient].value = 0;\n', '\n', '    untrustedRecipient.transfer(amountWei);\n', '  }\n', '\n', '  /*\n', '   * Internal functions\n', '   */\n', '  /// @dev Returns if amount is within daily limit and resets spentToday after one day.\n', '  /// @param amount Amount to withdraw.\n', '  /// @return Returns if amount is under daily limit.\n', '  function isUnderLimit(uint amount) internal returns (bool) {\n', '    if (now > lastDay.add(24 hours)) {\n', '      lastDay = now;\n', '      spentToday = 0;\n', '    }\n', "    // not using safe math because we don't want to throw;\n", '    if (spentToday + amount > dailyLimit || spentToday + amount < spentToday) {\n', '      return false;\n', '    }\n', '    return true;\n', '  }\n', '\n', '}']