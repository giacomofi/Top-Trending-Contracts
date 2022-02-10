['pragma solidity ^0.4.0;\n', '\n', '/**\n', ' * ----------------\n', ' * Application-agnostic user permission (owner, manager) contract\n', ' * ----------------\n', ' */\n', 'contract withOwners {\n', '  uint public ownersCount = 0;\n', '  uint public managersCount = 0;\n', '\n', '  /**\n', '   * Owner: full privilege\n', '   * Manager: lower privilege (set status, but not withdraw)\n', '   */\n', '  mapping (address => bool) public owners;\n', '  mapping (address => bool) public managers;\n', '\n', '  modifier onlyOwners {\n', '    if (owners[msg.sender] != true) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier onlyManagers {\n', '    if (owners[msg.sender] != true && managers[msg.sender] != true) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function addOwner(address _candidate) public onlyOwners {\n', '    if (owners[_candidate] == true) {\n', '      throw; // already owner\n', '    }\n', '\n', '    owners[_candidate] = true;\n', '    ++ownersCount;\n', '  }\n', '\n', '  function removeOwner(address _candidate) public onlyOwners {\n', '    // Stop removing the only/last owner\n', '    if (ownersCount <= 1 || owners[_candidate] == false) {\n', '      throw;\n', '    }\n', '\n', '    owners[_candidate] = false;\n', '    --ownersCount;\n', '  }\n', '\n', '  function addManager(address _candidate) public onlyOwners {\n', '    if (managers[_candidate] == true) {\n', '      throw; // already manager\n', '    }\n', '\n', '    managers[_candidate] = true;\n', '    ++managersCount;\n', '  }\n', '\n', '  function removeManager(address _candidate) public onlyOwners {\n', '    if (managers[_candidate] == false) {\n', '      throw;\n', '    }\n', '\n', '    managers[_candidate] = false;\n', '    --managersCount;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * ----------------\n', ' * Application-agnostic user account contract\n', ' * ----------------\n', ' */\n', 'contract withAccounts is withOwners {\n', '  uint defaultTimeoutPeriod = 2 days; // if locked fund is not settled within timeout period, account holders can refund themselves\n', '\n', '  struct AccountTx {\n', '    uint timeCreated;\n', '    address user;\n', '    uint amountHeld;\n', '    uint amountSpent;\n', '    uint8 state; // 1: on-hold/locked; 2: processed and refunded;\n', '  }\n', '\n', '  uint public txCount = 0;\n', '  mapping (uint => AccountTx) public accountTxs;\n', '  //mapping (address => uint) public userTxs;\n', '\n', '  /**\n', '   * Handling user account funds\n', '   */\n', '  uint public availableBalance = 0;\n', '  uint public onholdBalance = 0;\n', '  uint public spentBalance = 0; // total withdrawal balance by owner (service provider)\n', '\n', '  mapping (address => uint) public availableBalances;\n', '  mapping (address => uint) public onholdBalances;\n', '  mapping (address => bool) public doNotAutoRefund;\n', '\n', '  modifier handleDeposit {\n', '    deposit(msg.sender, msg.value);\n', '    _;\n', '  }\n', '\n', '/**\n', ' * ----------------------\n', ' * PUBLIC FUNCTIONS\n', ' * ----------------------\n', ' */\n', '\n', '  /**\n', "   * Deposit into other's account\n", '   * Useful for services that you wish to not hold funds and not having to keep refunding after every tx and wasting gas\n', '   */\n', '  function depositFor(address _address) public payable {\n', '    deposit(_address, msg.value);\n', '  }\n', '\n', '  /**\n', '   * Account owner withdraw funds\n', "   * leave blank at _amount to collect all funds on user's account\n", '   */\n', '  function withdraw(uint _amount) public {\n', '    if (_amount == 0) {\n', '      _amount = availableBalances[msg.sender];\n', '    }\n', '    if (_amount > availableBalances[msg.sender]) {\n', '      throw;\n', '    }\n', '\n', '    incrUserAvailBal(msg.sender, _amount, false);\n', '    if (!msg.sender.call.value(_amount)()) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Checks if an AccountTx is timed out\n', '   * can be called by anyone, not only account owner or provider\n', "   * If an AccountTx is already timed out, return balance to the user's available balance.\n", '   */\n', '  function checkTimeout(uint _id) public {\n', '    if (\n', '      accountTxs[_id].state != 1 ||\n', '      (now - accountTxs[_id].timeCreated) < defaultTimeoutPeriod\n', '    ) {\n', '      throw;\n', '    }\n', '\n', '    settle(_id, 0); // no money is spent, settle the tx\n', '\n', '    // Specifically for Notification contract\n', '    // updateState(_id, 60, 0);\n', '  }\n', '\n', '  /**\n', "   * Sets doNotAutoRefundTo of caller's account to:\n", '   * true: stops auto refund after every single transaction\n', '   * false: proceeds with auto refund after every single transaction\n', '   *\n', '   * Manually use withdraw() to withdraw available funds\n', '   */\n', '  function setDoNotAutoRefundTo(bool _option) public {\n', '    doNotAutoRefund[msg.sender] = _option;\n', '  }\n', '\n', '  /**\n', '   * Update defaultTimeoutPeriod\n', '   */\n', '  function updateDefaultTimeoutPeriod(uint _defaultTimeoutPeriod) public onlyOwners {\n', '    if (_defaultTimeoutPeriod < 1 hours) {\n', '      throw;\n', '    }\n', '\n', '    defaultTimeoutPeriod = _defaultTimeoutPeriod;\n', '  }\n', '\n', '  /**\n', '   * Owner - collect spentBalance\n', '   */\n', '  function collectRev() public onlyOwners {\n', '    uint amount = spentBalance;\n', '    spentBalance = 0;\n', '\n', '    if (!msg.sender.call.value(amount)()) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Owner: release availableBalance to account holder\n', '   * leave blank at _amount to release all\n', "   * set doNotAutoRefund to true to stop auto funds returning (keep funds on user's available balance account)\n", '   */\n', '  function returnFund(address _user, uint _amount) public onlyManagers {\n', '    if (doNotAutoRefund[_user] || _amount > availableBalances[_user]) {\n', '      throw;\n', '    }\n', '    if (_amount == 0) {\n', '      _amount = availableBalances[_user];\n', '    }\n', '\n', '    incrUserAvailBal(_user, _amount, false);\n', '    if (!_user.call.value(_amount)()) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '/**\n', ' * ----------------------\n', ' * INTERNAL FUNCTIONS\n', ' * ----------------------\n', ' */\n', '\n', '  /**\n', '   * Deposit funds into account\n', '   */\n', '  function deposit(address _user, uint _amount) internal {\n', '    if (_amount > 0) {\n', '      incrUserAvailBal(_user, _amount, true);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Creates a transaction\n', '   */\n', '  function createTx(uint _id, address _user, uint _amount) internal {\n', '    if (_amount > availableBalances[_user]) {\n', '      throw;\n', '    }\n', '\n', '    accountTxs[_id] = AccountTx({\n', '      timeCreated: now,\n', '      user: _user,\n', '      amountHeld: _amount,\n', '      amountSpent: 0,\n', '      state: 1 // on hold\n', '    });\n', '\n', '    incrUserAvailBal(_user, _amount, false);\n', '    incrUserOnholdBal(_user, _amount, true);\n', '  }\n', '\n', '  function settle(uint _id, uint _amountSpent) internal {\n', '    if (accountTxs[_id].state != 1 || _amountSpent > accountTxs[_id].amountHeld) {\n', '      throw;\n', '    }\n', '\n', '    // Deliberately not checking for timeout period\n', '    // because if provider has actual update, it should stand\n', '\n', '    accountTxs[_id].amountSpent = _amountSpent;\n', '    accountTxs[_id].state = 2; // processed and refunded;\n', '\n', '    spentBalance += _amountSpent;\n', '    uint changeAmount = accountTxs[_id].amountHeld - _amountSpent;\n', '\n', '    incrUserOnholdBal(accountTxs[_id].user, accountTxs[_id].amountHeld, false);\n', '    incrUserAvailBal(accountTxs[_id].user, changeAmount, true);\n', '  }\n', '\n', '  function incrUserAvailBal(address _user, uint _by, bool _increase) internal {\n', '    if (_increase) {\n', '      availableBalances[_user] += _by;\n', '      availableBalance += _by;\n', '    } else {\n', '      availableBalances[_user] -= _by;\n', '      availableBalance -= _by;\n', '    }\n', '  }\n', '\n', '  function incrUserOnholdBal(address _user, uint _by, bool _increase) internal {\n', '    if (_increase) {\n', '      onholdBalances[_user] += _by;\n', '      onholdBalance += _by;\n', '    } else {\n', '      onholdBalances[_user] -= _by;\n', '      onholdBalance -= _by;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract Notifier is withOwners, withAccounts {\n', '  string public xIPFSPublicKey;\n', '  uint public minEthPerNotification = 0.02 ether;\n', '\n', '  struct Task {\n', '    address sender;\n', '    uint8 state; // 10: pending\n', '                 // 20: processed, but tx still open\n', '                 // [ FINAL STATES >= 50 ]\n', '                 // 50: processed, costing done, tx settled\n', '                 // 60: rejected or error-ed, costing done, tx settled\n', '\n', '    bool isxIPFS;  // true: IPFS-augmented call (xIPFS); false: on-chain call\n', '  }\n', '\n', '  struct Notification {\n', '    uint8 transport; // 1: sms, 2: email\n', '    string destination;\n', '    string message;\n', '  }\n', '\n', '  mapping(uint => Task) public tasks;\n', '  mapping(uint => Notification) public notifications;\n', '  mapping(uint => string) public xnotifications; // IPFS-augmented Notification (hash)\n', '  uint public tasksCount = 0;\n', '\n', '  /**\n', '   * Events to be picked up by API\n', '   */\n', '  event TaskUpdated(uint id, uint8 state);\n', '\n', '  function Notifier(string _xIPFSPublicKey) public {\n', '    xIPFSPublicKey = _xIPFSPublicKey;\n', '    ownersCount++;\n', '    owners[msg.sender] = true;\n', '  }\n', '\n', '/**\n', ' * --------------\n', ' * Main functions\n', ' * --------------\n', ' */\n', '\n', '  /**\n', '   * Sends notification\n', '   */\n', '  function notify(uint8 _transport, string _destination, string _message) public payable handleDeposit {\n', '    if (_transport != 1 && _transport != 2) {\n', '      throw;\n', '    }\n', '\n', '    uint id = tasksCount;\n', '    uint8 state = 10; // pending\n', '\n', '    createTx(id, msg.sender, minEthPerNotification);\n', '    notifications[id] = Notification({\n', '      transport: _transport,\n', '      destination: _destination,\n', '      message: _message\n', '    });\n', '    tasks[id] = Task({\n', '      sender: msg.sender,\n', '      state: state,\n', '      isxIPFS: false // on-chain\n', '    });\n', '\n', '    TaskUpdated(id, state);\n', '    ++tasksCount;\n', '  }\n', '\n', '/**\n', ' * --------------\n', ' * Extended functions, for\n', ' * - IPFS-augmented calls\n', ' * - Encrypted calls\n', ' * --------------\n', ' */\n', '\n', '  function xnotify(string _hash) public payable handleDeposit {\n', '    uint id = tasksCount;\n', '    uint8 state = 10; // pending\n', '\n', '    createTx(id, msg.sender, minEthPerNotification);\n', '    xnotifications[id] = _hash;\n', '    tasks[id] = Task({\n', '      sender: msg.sender,\n', '      state: state,\n', '      isxIPFS: true\n', '    });\n', '\n', '    TaskUpdated(id, state);\n', '    ++tasksCount;\n', '  }\n', '\n', '/**\n', ' * --------------\n', ' * Owner-only functions\n', ' * ---------------\n', ' */\n', '\n', '  function updateMinEthPerNotification(uint _newMin) public onlyManagers {\n', '    minEthPerNotification = _newMin;\n', '  }\n', '\n', '  /**\n', '   * Mark task as processed, but no costing yet\n', '   * This is an optional state\n', '   */\n', '  function taskProcessedNoCosting(uint _id) public onlyManagers {\n', '    updateState(_id, 20, 0);\n', '  }\n', '\n', '  /**\n', '   * Mark task as processed, and process funds + costings\n', '   * This is a FINAL state\n', '   */\n', '  function taskProcessedWithCosting(uint _id, uint _cost) public onlyManagers {\n', '    updateState(_id, 50, _cost);\n', '  }\n', '\n', '  /**\n', '   * Mark task as rejected or error-ed,  and processed funds + costings\n', '   * This is a FINAL state\n', '   */\n', '  function taskRejected(uint _id, uint _cost) public onlyManagers {\n', '    updateState(_id, 60, _cost);\n', '  }\n', '\n', '  /**\n', '   * Update public key for xIPFS\n', '   */\n', '  function updateXIPFSPublicKey(string _publicKey) public onlyOwners {\n', '    xIPFSPublicKey = _publicKey;\n', '  }\n', '\n', '  function updateState(uint _id, uint8 _state, uint _cost) internal {\n', '    if (tasks[_id].state == 0 || tasks[_id].state >= 50) {\n', '      throw;\n', '    }\n', '\n', '    tasks[_id].state = _state;\n', '\n', '    // Cost settlement is done only for final states (>= 50)\n', '    if (_state >= 50) {\n', '      settle(_id, _cost);\n', '    }\n', '    TaskUpdated(_id, _state);\n', '  }\n', '\n', '  /**\n', '   * Handle deposits\n', '   */\n', '  function () payable handleDeposit {\n', '  }\n', '}']