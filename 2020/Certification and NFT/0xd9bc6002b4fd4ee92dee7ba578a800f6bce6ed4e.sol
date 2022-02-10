['pragma solidity 0.4.25;\n', '\n', 'contract Auth {\n', '\n', '  address internal mainAdmin;\n', '  address internal backupAdmin;\n', '\n', '  event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);\n', '\n', '  constructor(\n', '    address _mainAdmin,\n', '    address _backupAdmin\n', '  ) internal {\n', '    mainAdmin = _mainAdmin;\n', '    backupAdmin = _backupAdmin;\n', '  }\n', '\n', '  modifier onlyMainAdmin() {\n', '    require(isMainAdmin(), "onlyMainAdmin");\n', '    _;\n', '  }\n', '\n', '  modifier onlyBackupAdmin() {\n', '    require(isBackupAdmin(), "onlyBackupAdmin");\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) onlyBackupAdmin internal {\n', '    require(_newOwner != address(0x0));\n', '    mainAdmin = _newOwner;\n', '    emit OwnershipTransferred(msg.sender, _newOwner);\n', '  }\n', '\n', '  function isMainAdmin() public view returns (bool) {\n', '    return msg.sender == mainAdmin;\n', '  }\n', '\n', '  function isBackupAdmin() public view returns (bool) {\n', '    return msg.sender == backupAdmin;\n', '  }\n', '}\n', '\n', 'contract Ethbot is Auth {\n', '\n', '  struct User {\n', '    bool isExist;\n', '    uint id;\n', '    uint referrerID;\n', '    address[] referral;\n', '    mapping(uint => uint) levelExpired;\n', '    uint level;\n', '  }\n', '\n', '  uint REFERRER_1_LEVEL_LIMIT = 2;\n', '  uint PERIOD_LENGTH = 100 days;\n', '  uint public totalUser = 1;\n', '\n', '  mapping(uint => uint) public LEVEL_PRICE;\n', '\n', '  mapping (address => User) public users;\n', '  mapping (uint => address) public userLists;\n', '  uint public userIdCounter = 0;\n', '  address cAccount;\n', '\n', '  event Registered(address indexed user, address indexed inviter, uint id, uint time);\n', '  event LevelBought(address indexed user, uint indexed id, uint level, uint time);\n', '  event MoneyReceived(address indexed user, uint indexed id, address indexed from, uint level, uint amount, uint time);\n', '  event MoneyMissed(address indexed user, uint indexed id, address indexed from, uint level, uint amount, uint time);\n', '\n', '  constructor(\n', '    address _rootAccount,\n', '    address _cAccount,\n', '    address _backupAdmin\n', '  )\n', '  public\n', '  Auth(msg.sender, _backupAdmin)\n', '  {\n', '    LEVEL_PRICE[1] = 0.1 ether;\n', '    LEVEL_PRICE[2] = 0.16 ether;\n', '    LEVEL_PRICE[3] = 0.3 ether;\n', '    LEVEL_PRICE[4] = 1 ether;\n', '    LEVEL_PRICE[5] = 3 ether;\n', '    LEVEL_PRICE[6] = 8 ether;\n', '    LEVEL_PRICE[7] = 16 ether;\n', '    LEVEL_PRICE[8] = 31 ether;\n', '    LEVEL_PRICE[9] = 60 ether;\n', '    LEVEL_PRICE[10] = 120 ether;\n', '\n', '    User memory user;\n', '\n', '    user = User({\n', '      isExist: true,\n', '      id: userIdCounter,\n', '      referrerID: 0,\n', '      referral: new address[](0),\n', '      level: 1\n', '    });\n', '    users[_rootAccount] = user;\n', '    userLists[userIdCounter] = _rootAccount;\n', '    cAccount = _cAccount;\n', '  }\n', '\n', '  function updateMainAdmin(address _admin) public {\n', '    transferOwnership(_admin);\n', '  }\n', '\n', '  function updateCAccount(address _cAccount) onlyMainAdmin public {\n', '    cAccount = _cAccount;\n', '  }\n', '\n', '  function () external payable {\n', '    uint level;\n', '\n', '    if(msg.value == LEVEL_PRICE[1]) level = 1;\n', '    else if(msg.value == LEVEL_PRICE[2]) level = 2;\n', '    else if(msg.value == LEVEL_PRICE[3]) level = 3;\n', '    else if(msg.value == LEVEL_PRICE[4]) level = 4;\n', '    else if(msg.value == LEVEL_PRICE[5]) level = 5;\n', '    else if(msg.value == LEVEL_PRICE[6]) level = 6;\n', '    else if(msg.value == LEVEL_PRICE[7]) level = 7;\n', '    else if(msg.value == LEVEL_PRICE[8]) level = 8;\n', '    else if(msg.value == LEVEL_PRICE[9]) level = 9;\n', '    else if(msg.value == LEVEL_PRICE[10]) level = 10;\n', "    else revert('Incorrect Value send');\n", '\n', '    if(users[msg.sender].isExist) buyLevel(level);\n', '    else if(level == 1) {\n', '      uint refId = 0;\n', '      address referrer = bytesToAddress(msg.data);\n', '\n', '      if(users[referrer].isExist) refId = users[referrer].id;\n', "      else revert('Incorrect referrer');\n", '\n', '      regUser(refId);\n', '    }\n', "    else revert('Please buy first level for 0.1 ETH');\n", '  }\n', '\n', '  function regUser(uint _referrerID) public payable {\n', "    require(!users[msg.sender].isExist, 'User exist');\n", "    require(_referrerID >= 0 && _referrerID <= userIdCounter, 'Incorrect referrer Id');\n", "    require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');\n", '\n', '    if(users[userLists[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userLists[_referrerID])].id;\n', '\n', '    User memory user;\n', '    userIdCounter++;\n', '\n', '    user = User({\n', '      isExist: true,\n', '      id: userIdCounter,\n', '      referrerID: _referrerID,\n', '      referral: new address[](0),\n', '      level: 1\n', '    });\n', '\n', '    users[msg.sender] = user;\n', '    userLists[userIdCounter] = msg.sender;\n', '\n', '    users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;\n', '\n', '    users[userLists[_referrerID]].referral.push(msg.sender);\n', '    totalUser += 1;\n', '    emit Registered(msg.sender, userLists[_referrerID], userIdCounter, now);\n', '\n', '    payForLevel(1, msg.sender);\n', '  }\n', '\n', '  function buyLevel(uint _level) public payable {\n', "    require(users[msg.sender].isExist, 'User not exist');\n", "    require(_level > 0 && _level <= 10, 'Incorrect level');\n", '\n', '    if(_level == 1) {\n', "      require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');\n", '      users[msg.sender].levelExpired[1] += PERIOD_LENGTH;\n', '    }\n', '    else {\n', "      require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');\n", '\n', "      for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');\n", '\n', '      if(users[msg.sender].levelExpired[_level] == 0 || users[msg.sender].levelExpired[_level] < now) {\n', '        users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;\n', '      } else {\n', '        users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;\n', '      }\n', '    }\n', '    users[msg.sender].level = _level;\n', '    emit LevelBought(msg.sender, users[msg.sender].id, _level, now);\n', '\n', '    payForLevel(_level, msg.sender);\n', '  }\n', '\n', '  function payForLevel(uint _level, address _user) internal {\n', '    address referer;\n', '    address referer1;\n', '    address referer2;\n', '    address referer3;\n', '    address referer4;\n', '\n', '    if(_level == 1 || _level == 6) {\n', '      referer = userLists[users[_user].referrerID];\n', '    }\n', '    else if(_level == 2 || _level == 7) {\n', '      referer1 = userLists[users[_user].referrerID];\n', '      referer = userLists[users[referer1].referrerID];\n', '    }\n', '    else if(_level == 3 || _level == 8) {\n', '      referer1 = userLists[users[_user].referrerID];\n', '      referer2 = userLists[users[referer1].referrerID];\n', '      referer = userLists[users[referer2].referrerID];\n', '    }\n', '    else if(_level == 4 || _level == 9) {\n', '      referer1 = userLists[users[_user].referrerID];\n', '      referer2 = userLists[users[referer1].referrerID];\n', '      referer3 = userLists[users[referer2].referrerID];\n', '      referer = userLists[users[referer3].referrerID];\n', '    }\n', '    else if(_level == 5 || _level == 10) {\n', '      referer1 = userLists[users[_user].referrerID];\n', '      referer2 = userLists[users[referer1].referrerID];\n', '      referer3 = userLists[users[referer2].referrerID];\n', '      referer4 = userLists[users[referer3].referrerID];\n', '      referer = userLists[users[referer4].referrerID];\n', '    }\n', '\n', '    if(users[referer].isExist && users[referer].id > 0) {\n', '      bool sent = false;\n', '      if(users[referer].levelExpired[_level] >= now && users[referer].level == _level) {\n', '        sent = address(uint160(referer)).send(LEVEL_PRICE[_level]);\n', '\n', '        if (sent) {\n', '          emit MoneyReceived(referer, users[referer].id, msg.sender, _level, LEVEL_PRICE[_level], now);\n', '        }\n', '      }\n', '      if(!sent) {\n', '        emit MoneyMissed(referer, users[referer].id, msg.sender, _level, LEVEL_PRICE[_level], now);\n', '\n', '        payForLevel(_level, referer);\n', '      }\n', '    } else {\n', '      cAccount.transfer(LEVEL_PRICE[_level]);\n', '    }\n', '  }\n', '\n', '  function findFreeReferrer(address _user) public view returns(address) {\n', '    if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;\n', '\n', '    address[] memory referrals = new address[](126);\n', '    referrals[0] = users[_user].referral[0];\n', '    referrals[1] = users[_user].referral[1];\n', '\n', '    address freeReferrer;\n', '    bool noFreeReferrer = true;\n', '\n', '    for(uint i = 0; i < 126; i++) {\n', '      if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {\n', '        if(i < 62) {\n', '          referrals[(i+1)*2] = users[referrals[i]].referral[0];\n', '          referrals[(i+1)*2+1] = users[referrals[i]].referral[1];\n', '        }\n', '      }\n', '      else {\n', '        noFreeReferrer = false;\n', '        freeReferrer = referrals[i];\n', '        break;\n', '      }\n', '    }\n', '\n', "    require(!noFreeReferrer, 'No Free Referrer');\n", '\n', '    return freeReferrer;\n', '  }\n', '\n', '  function viewUserReferral(address _user) public view returns(address[] memory) {\n', '    return users[_user].referral;\n', '  }\n', '\n', '  function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {\n', '    return users[_user].levelExpired[_level];\n', '  }\n', '\n', '  function showMe() public view returns (bool, uint, uint) {\n', '    User storage user = users[msg.sender];\n', '    return (user.isExist, user.id, user.level);\n', '  }\n', '\n', '  function levelData() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {\n', '    return (\n', '      users[msg.sender].levelExpired[1],\n', '      users[msg.sender].levelExpired[2],\n', '      users[msg.sender].levelExpired[3],\n', '      users[msg.sender].levelExpired[4],\n', '      users[msg.sender].levelExpired[5],\n', '      users[msg.sender].levelExpired[6],\n', '      users[msg.sender].levelExpired[7],\n', '      users[msg.sender].levelExpired[8],\n', '      users[msg.sender].levelExpired[9],\n', '      users[msg.sender].levelExpired[10]\n', '    );\n', '  }\n', '\n', '  function bytesToAddress(bytes memory bys) private pure returns (address addr) {\n', '    assembly {\n', '      addr := mload(add(bys, 20))\n', '    }\n', '  }\n', '}']