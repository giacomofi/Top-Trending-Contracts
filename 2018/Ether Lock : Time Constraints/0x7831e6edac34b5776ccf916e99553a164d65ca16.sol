['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '    return a / b;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface IDonQuixoteToken{\n', '    function withhold(address _user,  uint256 _amount) external returns (bool _result);\n', '    function transfer(address _to, uint256 _value) external;\n', '    function sendGameGift(address _player) external returns (bool _result);\n', '    function logPlaying(address _player) external returns (bool _result);\n', '    function balanceOf(address _user) constant  external returns (uint256 _balance);\n', '\n', '}\n', 'contract BaseGame {\n', '  string public gameName = "ScratchTickets";\n', '  uint public constant  gameType = 2005;\n', '  string public officialGameUrl;\n', '  mapping (address => uint256) public userTokenOf;\n', '  uint public bankerBeginTime;\n', '  uint public bankerEndTime;\n', '  address public currentBanker;\n', '\n', '  function depositToken(uint256 _amount) public;\n', '  function withdrawToken(uint256 _amount) public;\n', '  function withdrawAllToken() public;\n', '  function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);\n', '  function canSetBanker() view public returns (bool _result);\n', '}\n', '\n', '\n', '\n', 'contract Base is BaseGame {\n', '  using SafeMath for uint256;\n', '  uint public createTime = now;\n', '  address public owner;\n', '  IDonQuixoteToken public DonQuixoteToken;\n', '\n', '  function Base() public {\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  function setOwner(address _newOwner)  public  onlyOwner {\n', '    require(_newOwner != 0x0);\n', '    owner = _newOwner;\n', '  }\n', '\n', '  bool public globalLocked = false;\n', '\n', '  function lock() internal {\n', '    require(!globalLocked);\n', '    globalLocked = true;\n', '  }\n', '\n', '  function unLock() internal {\n', '    require(globalLocked);\n', '    globalLocked = false;\n', '  }\n', '\n', '  function setLock()  public onlyOwner{\n', '    globalLocked = false;\n', '  }\n', '\n', '  function tokenOf(address _user) view public returns(uint256 _result){\n', '    _result = DonQuixoteToken.balanceOf(_user);\n', '  }\n', '\n', '  function depositToken(uint256 _amount) public {\n', '    lock();\n', '    _depositToken(msg.sender, _amount);\n', '    unLock();\n', '  }\n', '\n', '  function _depositToken(address _to, uint256 _amount) internal {\n', '    require(_to != 0x0);\n', '    DonQuixoteToken.withhold(_to, _amount);\n', '    userTokenOf[_to] = userTokenOf[_to].add(_amount);\n', '  }\n', '\n', '  function withdrawAllToken() public{\n', '    uint256 _amount = userTokenOf[msg.sender];\n', '    withdrawToken(_amount);\n', '  }\n', '\n', '  function withdrawToken(uint256 _amount) public {\n', '    lock();\n', '    _withdrawToken(msg.sender, _amount);\n', '    unLock();\n', '  }\n', '\n', '  function _withdrawToken(address _to, uint256 _amount) internal {\n', '    require(_to != 0x0);\n', '    userTokenOf[_to] = userTokenOf[_to].sub(_amount);\n', '    DonQuixoteToken.transfer(_to, _amount);\n', '  }\n', '\n', '  uint public currentEventId = 1;\n', '\n', '  function getEventId() internal returns(uint _result) {\n', '    _result = currentEventId;\n', '    currentEventId ++;\n', '  }\n', '\n', '  function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{\n', '    officialGameUrl = _newOfficialGameUrl;\n', '  }\n', '}\n', '\n', 'contract ScratchTickets is Base\n', '{\n', '\n', '  uint256 public gameMaxBetAmount = 10**9;\n', '  uint256 public gameMinBetAmount = 10**7;\n', '\n', '  uint public playNo = 1;\n', '  uint256 public lockTime = 3600;\n', '  address public auction;\n', '\n', '  uint public donGameGiftLineTime =  now + 60 days + 30 days;\n', '\n', '  struct awardInfo{\n', '    uint Type;\n', '    uint Num;\n', '    uint WinMultiplePer;\n', '    uint KeyNumber;\n', '    uint AddIndex;\n', '  }\n', '\n', '  mapping (uint => awardInfo) public awardInfoOf;\n', '\n', '  struct betInfo\n', '  {\n', '    address Player;\n', '    uint256 BetAmount;\n', '    uint256 BlockNumber;\n', '    string RandomStr;\n', '    address Banker;\n', '    uint BetNum;\n', '    uint EventId;\n', '    bool IsReturnAward;\n', '  }\n', '  mapping (uint => betInfo) public playerBetInfoOf;\n', '\n', '  modifier onlyAuction {\n', '    require(msg.sender == auction);\n', '    _;\n', '  }\n', '  modifier onlyBanker {\n', '    require(msg.sender == currentBanker);\n', '    require(bankerBeginTime <= now);\n', '    require(now < bankerEndTime);\n', '    _;\n', '  }\n', '\n', '  function canSetBanker() public view returns (bool _result){\n', '    _result =  bankerEndTime <= now;\n', '  }\n', '\n', '  function ScratchTickets(string _gameName,uint256 _gameMinBetAmount,uint256 _gameMaxBetAmount,address _DonQuixoteToken) public{\n', '    require(_DonQuixoteToken != 0x0);\n', '    owner = msg.sender;\n', '    gameName = _gameName;\n', '    DonQuixoteToken = IDonQuixoteToken(_DonQuixoteToken);\n', '    gameMinBetAmount = _gameMinBetAmount;\n', '    gameMaxBetAmount = _gameMaxBetAmount;\n', '\n', '    _initAwardInfo();\n', '  }\n', '\n', '  function _initAwardInfo() private {\n', '    awardInfo memory a1 = awardInfo({\n', '      Type : 1,\n', '      Num : 1,\n', '      WinMultiplePer :1000,\n', '      KeyNumber : 7777,\n', '      AddIndex : 0\n', '    });\n', '    awardInfoOf[1] = a1;\n', '\n', '    awardInfo memory a2 = awardInfo({\n', '      Type : 2,\n', '      Num : 10,\n', '      WinMultiplePer :100,\n', '      KeyNumber : 888,\n', '      AddIndex : 1000\n', '    });\n', '    awardInfoOf[2] = a2;\n', '\n', '    awardInfo memory a3 = awardInfo({\n', '      Type : 3,\n', '      Num : 100,\n', '      WinMultiplePer :10,\n', '      KeyNumber : 99,\n', '      AddIndex : 100\n', '    });\n', '    awardInfoOf[3] = a3;\n', '\n', '    awardInfo memory a4 = awardInfo({\n', '      Type : 4,\n', '      Num : 1000,\n', '      WinMultiplePer :2,\n', '      KeyNumber : 6,\n', '      AddIndex : 10\n', '    });\n', '    awardInfoOf[4] = a4;\n', '\n', '    awardInfo memory a5 = awardInfo({\n', '      Type : 5,\n', '      Num : 2000,\n', '      WinMultiplePer :1,\n', '      KeyNumber : 3,\n', '      AddIndex : 5\n', '    });\n', '    awardInfoOf[5] = a5;\n', '  }\n', '\n', '  event OnSetNewBanker(address _caller, address _banker, uint _beginTime, uint _endTime, uint _code,uint _eventTime, uint eventId);\n', '  event OnPlay(address indexed _player, uint256 _betAmount,string _randomStr, uint _blockNumber,uint _playNo, uint _eventTime, uint eventId);\n', '  event OnGetAward(address indexed _player,uint indexed _awardType, uint256 _playNo,string _randomStr, uint _blockNumber,bytes32 _blockHash,uint256 _betAmount, uint _eventTime, uint eventId,uint256 _allAmount,uint256 _awardAmount);\n', '\n', '  function setAuction(address _newAuction) public onlyOwner{\n', '    auction = _newAuction;\n', '  }\n', '\n', '  function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result){\n', '    _result = false;\n', '    require(_banker != 0x0);\n', '    if(now < bankerEndTime){\n', '      emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 1, now, getEventId());\n', '      return;\n', '    }\n', '    if(_beginTime > now){\n', '      emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 3, now, getEventId());\n', '      return;\n', '    }\n', '    if(_endTime <= now){\n', '      emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 4, now, getEventId());\n', '      return;\n', '    }\n', '    currentBanker = _banker;\n', '    bankerBeginTime = _beginTime;\n', '    bankerEndTime = _endTime;\n', '    emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime,0, now, getEventId());\n', '    if(now < donGameGiftLineTime){\n', '      DonQuixoteToken.logPlaying(_banker);\n', '    }\n', '    _result = true;\n', '  }\n', '\n', '  function tokenOf(address _user) view public returns(uint256 _result){\n', '    _result = DonQuixoteToken.balanceOf(_user);\n', '  }\n', '\n', '  function play(string _randomStr,uint256 _betAmount) public returns(bool _result){\n', '    _result = _play(_randomStr, _betAmount);\n', '  }\n', '\n', '  function _play(string _randomStr, uint256 _betAmount) private  returns(bool _result){\n', '    _result = false;\n', '    require(msg.sender != currentBanker);\n', '    require(now < bankerEndTime.sub(lockTime));\n', '    require(userTokenOf[currentBanker]>=gameMaxBetAmount.mul(1000));\n', '    require(bytes(_randomStr).length<=18);\n', '\n', '    uint256 ba = _betAmount;\n', '    if (ba > gameMaxBetAmount){\n', '      ba = gameMaxBetAmount;\n', '    }\n', '    require(ba >= gameMinBetAmount);\n', '\n', '    if(userTokenOf[msg.sender] < _betAmount){\n', '      depositToken(_betAmount.sub(userTokenOf[msg.sender]));\n', '    }\n', '    require(userTokenOf[msg.sender] >= ba);\n', '    betInfo memory bi = betInfo({\n', '      Player :  msg.sender,\n', '      BetAmount : ba,\n', '      BlockNumber : block.number,\n', '      RandomStr : _randomStr,\n', '      Banker : currentBanker,\n', '      BetNum : 0,\n', '      EventId : currentEventId,\n', '      IsReturnAward: false\n', '    });\n', '    playerBetInfoOf[playNo] = bi;\n', '    userTokenOf[msg.sender] = userTokenOf[msg.sender].sub(ba);\n', '    userTokenOf[currentBanker] = userTokenOf[currentBanker].add(ba);\n', '    emit OnPlay(msg.sender,  ba,  _randomStr, block.number,playNo,now, getEventId());\n', '    if(now < donGameGiftLineTime){\n', '      DonQuixoteToken.logPlaying(msg.sender);\n', '    }\n', '    playNo++;\n', '    _result = true;\n', '  }\n', '\n', '  function getAward(uint _playNo) public returns(bool _result){\n', '    _result = _getaward(_playNo);\n', '  }\n', '\n', '  function _getaward(uint _playNo) private  returns(bool _result){\n', '    require(_playNo<=playNo);\n', '    _result = false;\n', '    bool isAward = false;\n', '    betInfo storage bi = playerBetInfoOf[_playNo];\n', '    require(!bi.IsReturnAward);\n', '    require(bi.BlockNumber>block.number.sub(256));\n', '    bytes32 blockHash = block.blockhash(bi.BlockNumber);\n', '    lock();\n', '    uint256 randomNum = bi.EventId%1000;\n', '    bytes32 encrptyHash = keccak256(bi.RandomStr,bi.Player,blockHash,uint8ToString(randomNum));\n', '    bi.BetNum = uint(encrptyHash)%10000;\n', '    bi.IsReturnAward = true;\n', '    for (uint i = 1; i < 6; i++) {\n', '      awardInfo memory ai = awardInfoOf[i];\n', '      uint x = bi.BetNum%(10000/ai.Num);\n', '      if(x == ai.KeyNumber){\n', '        uint256 AllAmount = bi.BetAmount.mul(ai.WinMultiplePer);\n', '        uint256 awadrAmount = AllAmount;\n', '        if(AllAmount >= userTokenOf[bi.Banker]){\n', '          awadrAmount = userTokenOf[bi.Banker];\n', '        }\n', '        userTokenOf[bi.Banker] = userTokenOf[bi.Banker].sub(awadrAmount) ;\n', '        userTokenOf[bi.Player] =userTokenOf[bi.Player].add(awadrAmount);\n', '        isAward = true;\n', '        emit OnGetAward(bi.Player,i, _playNo,bi.RandomStr,bi.BlockNumber,blockHash,bi.BetAmount,now,getEventId(),AllAmount,awadrAmount);\n', '        break;\n', '      }\n', '    }\n', '    if(!isAward){\n', '      if(now < donGameGiftLineTime){\n', '        DonQuixoteToken.sendGameGift(bi.Player);\n', '      }\n', '      emit OnGetAward(bi.Player,0, _playNo,bi.RandomStr,bi.BlockNumber,blockHash,bi.BetAmount,now,getEventId(),0,0);\n', '    }\n', '    _result = true;\n', '    unLock();\n', '  }\n', '\n', '  function _withdrawToken(address _to, uint256 _amount) internal {\n', '    require(_to != 0x0);\n', '    if(_to == currentBanker){\n', '      require(userTokenOf[currentBanker] > gameMaxBetAmount.mul(1000));\n', '      _amount = userTokenOf[currentBanker].sub(gameMaxBetAmount.mul(1000));\n', '    }\n', '    userTokenOf[_to] = userTokenOf[_to].sub(_amount);\n', '    DonQuixoteToken.transfer(_to, _amount);\n', '  }\n', '\n', '  function uint8ToString(uint v) private pure returns (string)\n', '  {\n', '    uint maxlength = 8;\n', '    bytes memory reversed = new bytes(maxlength);\n', '    uint i = 0;\n', '    while (v != 0) {\n', '      uint remainder = v % 10;\n', '      v = v / 10;\n', '      reversed[i++] = byte(48 + remainder);\n', '    }\n', '    bytes memory s = new bytes(i);\n', '    for (uint j = 0; j < i; j++) {\n', '      s[j] = reversed[i - j - 1];\n', '    }\n', '    string memory str = string(s);\n', '    return str;\n', '  }\n', '\n', '  function setLockTime(uint256 _lockTIme)public onlyOwner(){\n', '    lockTime = _lockTIme;\n', '  }\n', '\n', '  function transEther() public onlyOwner()\n', '  {\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '\n', '  function () public payable {\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '    return a / b;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface IDonQuixoteToken{\n', '    function withhold(address _user,  uint256 _amount) external returns (bool _result);\n', '    function transfer(address _to, uint256 _value) external;\n', '    function sendGameGift(address _player) external returns (bool _result);\n', '    function logPlaying(address _player) external returns (bool _result);\n', '    function balanceOf(address _user) constant  external returns (uint256 _balance);\n', '\n', '}\n', 'contract BaseGame {\n', '  string public gameName = "ScratchTickets";\n', '  uint public constant  gameType = 2005;\n', '  string public officialGameUrl;\n', '  mapping (address => uint256) public userTokenOf;\n', '  uint public bankerBeginTime;\n', '  uint public bankerEndTime;\n', '  address public currentBanker;\n', '\n', '  function depositToken(uint256 _amount) public;\n', '  function withdrawToken(uint256 _amount) public;\n', '  function withdrawAllToken() public;\n', '  function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);\n', '  function canSetBanker() view public returns (bool _result);\n', '}\n', '\n', '\n', '\n', 'contract Base is BaseGame {\n', '  using SafeMath for uint256;\n', '  uint public createTime = now;\n', '  address public owner;\n', '  IDonQuixoteToken public DonQuixoteToken;\n', '\n', '  function Base() public {\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  function setOwner(address _newOwner)  public  onlyOwner {\n', '    require(_newOwner != 0x0);\n', '    owner = _newOwner;\n', '  }\n', '\n', '  bool public globalLocked = false;\n', '\n', '  function lock() internal {\n', '    require(!globalLocked);\n', '    globalLocked = true;\n', '  }\n', '\n', '  function unLock() internal {\n', '    require(globalLocked);\n', '    globalLocked = false;\n', '  }\n', '\n', '  function setLock()  public onlyOwner{\n', '    globalLocked = false;\n', '  }\n', '\n', '  function tokenOf(address _user) view public returns(uint256 _result){\n', '    _result = DonQuixoteToken.balanceOf(_user);\n', '  }\n', '\n', '  function depositToken(uint256 _amount) public {\n', '    lock();\n', '    _depositToken(msg.sender, _amount);\n', '    unLock();\n', '  }\n', '\n', '  function _depositToken(address _to, uint256 _amount) internal {\n', '    require(_to != 0x0);\n', '    DonQuixoteToken.withhold(_to, _amount);\n', '    userTokenOf[_to] = userTokenOf[_to].add(_amount);\n', '  }\n', '\n', '  function withdrawAllToken() public{\n', '    uint256 _amount = userTokenOf[msg.sender];\n', '    withdrawToken(_amount);\n', '  }\n', '\n', '  function withdrawToken(uint256 _amount) public {\n', '    lock();\n', '    _withdrawToken(msg.sender, _amount);\n', '    unLock();\n', '  }\n', '\n', '  function _withdrawToken(address _to, uint256 _amount) internal {\n', '    require(_to != 0x0);\n', '    userTokenOf[_to] = userTokenOf[_to].sub(_amount);\n', '    DonQuixoteToken.transfer(_to, _amount);\n', '  }\n', '\n', '  uint public currentEventId = 1;\n', '\n', '  function getEventId() internal returns(uint _result) {\n', '    _result = currentEventId;\n', '    currentEventId ++;\n', '  }\n', '\n', '  function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{\n', '    officialGameUrl = _newOfficialGameUrl;\n', '  }\n', '}\n', '\n', 'contract ScratchTickets is Base\n', '{\n', '\n', '  uint256 public gameMaxBetAmount = 10**9;\n', '  uint256 public gameMinBetAmount = 10**7;\n', '\n', '  uint public playNo = 1;\n', '  uint256 public lockTime = 3600;\n', '  address public auction;\n', '\n', '  uint public donGameGiftLineTime =  now + 60 days + 30 days;\n', '\n', '  struct awardInfo{\n', '    uint Type;\n', '    uint Num;\n', '    uint WinMultiplePer;\n', '    uint KeyNumber;\n', '    uint AddIndex;\n', '  }\n', '\n', '  mapping (uint => awardInfo) public awardInfoOf;\n', '\n', '  struct betInfo\n', '  {\n', '    address Player;\n', '    uint256 BetAmount;\n', '    uint256 BlockNumber;\n', '    string RandomStr;\n', '    address Banker;\n', '    uint BetNum;\n', '    uint EventId;\n', '    bool IsReturnAward;\n', '  }\n', '  mapping (uint => betInfo) public playerBetInfoOf;\n', '\n', '  modifier onlyAuction {\n', '    require(msg.sender == auction);\n', '    _;\n', '  }\n', '  modifier onlyBanker {\n', '    require(msg.sender == currentBanker);\n', '    require(bankerBeginTime <= now);\n', '    require(now < bankerEndTime);\n', '    _;\n', '  }\n', '\n', '  function canSetBanker() public view returns (bool _result){\n', '    _result =  bankerEndTime <= now;\n', '  }\n', '\n', '  function ScratchTickets(string _gameName,uint256 _gameMinBetAmount,uint256 _gameMaxBetAmount,address _DonQuixoteToken) public{\n', '    require(_DonQuixoteToken != 0x0);\n', '    owner = msg.sender;\n', '    gameName = _gameName;\n', '    DonQuixoteToken = IDonQuixoteToken(_DonQuixoteToken);\n', '    gameMinBetAmount = _gameMinBetAmount;\n', '    gameMaxBetAmount = _gameMaxBetAmount;\n', '\n', '    _initAwardInfo();\n', '  }\n', '\n', '  function _initAwardInfo() private {\n', '    awardInfo memory a1 = awardInfo({\n', '      Type : 1,\n', '      Num : 1,\n', '      WinMultiplePer :1000,\n', '      KeyNumber : 7777,\n', '      AddIndex : 0\n', '    });\n', '    awardInfoOf[1] = a1;\n', '\n', '    awardInfo memory a2 = awardInfo({\n', '      Type : 2,\n', '      Num : 10,\n', '      WinMultiplePer :100,\n', '      KeyNumber : 888,\n', '      AddIndex : 1000\n', '    });\n', '    awardInfoOf[2] = a2;\n', '\n', '    awardInfo memory a3 = awardInfo({\n', '      Type : 3,\n', '      Num : 100,\n', '      WinMultiplePer :10,\n', '      KeyNumber : 99,\n', '      AddIndex : 100\n', '    });\n', '    awardInfoOf[3] = a3;\n', '\n', '    awardInfo memory a4 = awardInfo({\n', '      Type : 4,\n', '      Num : 1000,\n', '      WinMultiplePer :2,\n', '      KeyNumber : 6,\n', '      AddIndex : 10\n', '    });\n', '    awardInfoOf[4] = a4;\n', '\n', '    awardInfo memory a5 = awardInfo({\n', '      Type : 5,\n', '      Num : 2000,\n', '      WinMultiplePer :1,\n', '      KeyNumber : 3,\n', '      AddIndex : 5\n', '    });\n', '    awardInfoOf[5] = a5;\n', '  }\n', '\n', '  event OnSetNewBanker(address _caller, address _banker, uint _beginTime, uint _endTime, uint _code,uint _eventTime, uint eventId);\n', '  event OnPlay(address indexed _player, uint256 _betAmount,string _randomStr, uint _blockNumber,uint _playNo, uint _eventTime, uint eventId);\n', '  event OnGetAward(address indexed _player,uint indexed _awardType, uint256 _playNo,string _randomStr, uint _blockNumber,bytes32 _blockHash,uint256 _betAmount, uint _eventTime, uint eventId,uint256 _allAmount,uint256 _awardAmount);\n', '\n', '  function setAuction(address _newAuction) public onlyOwner{\n', '    auction = _newAuction;\n', '  }\n', '\n', '  function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result){\n', '    _result = false;\n', '    require(_banker != 0x0);\n', '    if(now < bankerEndTime){\n', '      emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 1, now, getEventId());\n', '      return;\n', '    }\n', '    if(_beginTime > now){\n', '      emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 3, now, getEventId());\n', '      return;\n', '    }\n', '    if(_endTime <= now){\n', '      emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 4, now, getEventId());\n', '      return;\n', '    }\n', '    currentBanker = _banker;\n', '    bankerBeginTime = _beginTime;\n', '    bankerEndTime = _endTime;\n', '    emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime,0, now, getEventId());\n', '    if(now < donGameGiftLineTime){\n', '      DonQuixoteToken.logPlaying(_banker);\n', '    }\n', '    _result = true;\n', '  }\n', '\n', '  function tokenOf(address _user) view public returns(uint256 _result){\n', '    _result = DonQuixoteToken.balanceOf(_user);\n', '  }\n', '\n', '  function play(string _randomStr,uint256 _betAmount) public returns(bool _result){\n', '    _result = _play(_randomStr, _betAmount);\n', '  }\n', '\n', '  function _play(string _randomStr, uint256 _betAmount) private  returns(bool _result){\n', '    _result = false;\n', '    require(msg.sender != currentBanker);\n', '    require(now < bankerEndTime.sub(lockTime));\n', '    require(userTokenOf[currentBanker]>=gameMaxBetAmount.mul(1000));\n', '    require(bytes(_randomStr).length<=18);\n', '\n', '    uint256 ba = _betAmount;\n', '    if (ba > gameMaxBetAmount){\n', '      ba = gameMaxBetAmount;\n', '    }\n', '    require(ba >= gameMinBetAmount);\n', '\n', '    if(userTokenOf[msg.sender] < _betAmount){\n', '      depositToken(_betAmount.sub(userTokenOf[msg.sender]));\n', '    }\n', '    require(userTokenOf[msg.sender] >= ba);\n', '    betInfo memory bi = betInfo({\n', '      Player :  msg.sender,\n', '      BetAmount : ba,\n', '      BlockNumber : block.number,\n', '      RandomStr : _randomStr,\n', '      Banker : currentBanker,\n', '      BetNum : 0,\n', '      EventId : currentEventId,\n', '      IsReturnAward: false\n', '    });\n', '    playerBetInfoOf[playNo] = bi;\n', '    userTokenOf[msg.sender] = userTokenOf[msg.sender].sub(ba);\n', '    userTokenOf[currentBanker] = userTokenOf[currentBanker].add(ba);\n', '    emit OnPlay(msg.sender,  ba,  _randomStr, block.number,playNo,now, getEventId());\n', '    if(now < donGameGiftLineTime){\n', '      DonQuixoteToken.logPlaying(msg.sender);\n', '    }\n', '    playNo++;\n', '    _result = true;\n', '  }\n', '\n', '  function getAward(uint _playNo) public returns(bool _result){\n', '    _result = _getaward(_playNo);\n', '  }\n', '\n', '  function _getaward(uint _playNo) private  returns(bool _result){\n', '    require(_playNo<=playNo);\n', '    _result = false;\n', '    bool isAward = false;\n', '    betInfo storage bi = playerBetInfoOf[_playNo];\n', '    require(!bi.IsReturnAward);\n', '    require(bi.BlockNumber>block.number.sub(256));\n', '    bytes32 blockHash = block.blockhash(bi.BlockNumber);\n', '    lock();\n', '    uint256 randomNum = bi.EventId%1000;\n', '    bytes32 encrptyHash = keccak256(bi.RandomStr,bi.Player,blockHash,uint8ToString(randomNum));\n', '    bi.BetNum = uint(encrptyHash)%10000;\n', '    bi.IsReturnAward = true;\n', '    for (uint i = 1; i < 6; i++) {\n', '      awardInfo memory ai = awardInfoOf[i];\n', '      uint x = bi.BetNum%(10000/ai.Num);\n', '      if(x == ai.KeyNumber){\n', '        uint256 AllAmount = bi.BetAmount.mul(ai.WinMultiplePer);\n', '        uint256 awadrAmount = AllAmount;\n', '        if(AllAmount >= userTokenOf[bi.Banker]){\n', '          awadrAmount = userTokenOf[bi.Banker];\n', '        }\n', '        userTokenOf[bi.Banker] = userTokenOf[bi.Banker].sub(awadrAmount) ;\n', '        userTokenOf[bi.Player] =userTokenOf[bi.Player].add(awadrAmount);\n', '        isAward = true;\n', '        emit OnGetAward(bi.Player,i, _playNo,bi.RandomStr,bi.BlockNumber,blockHash,bi.BetAmount,now,getEventId(),AllAmount,awadrAmount);\n', '        break;\n', '      }\n', '    }\n', '    if(!isAward){\n', '      if(now < donGameGiftLineTime){\n', '        DonQuixoteToken.sendGameGift(bi.Player);\n', '      }\n', '      emit OnGetAward(bi.Player,0, _playNo,bi.RandomStr,bi.BlockNumber,blockHash,bi.BetAmount,now,getEventId(),0,0);\n', '    }\n', '    _result = true;\n', '    unLock();\n', '  }\n', '\n', '  function _withdrawToken(address _to, uint256 _amount) internal {\n', '    require(_to != 0x0);\n', '    if(_to == currentBanker){\n', '      require(userTokenOf[currentBanker] > gameMaxBetAmount.mul(1000));\n', '      _amount = userTokenOf[currentBanker].sub(gameMaxBetAmount.mul(1000));\n', '    }\n', '    userTokenOf[_to] = userTokenOf[_to].sub(_amount);\n', '    DonQuixoteToken.transfer(_to, _amount);\n', '  }\n', '\n', '  function uint8ToString(uint v) private pure returns (string)\n', '  {\n', '    uint maxlength = 8;\n', '    bytes memory reversed = new bytes(maxlength);\n', '    uint i = 0;\n', '    while (v != 0) {\n', '      uint remainder = v % 10;\n', '      v = v / 10;\n', '      reversed[i++] = byte(48 + remainder);\n', '    }\n', '    bytes memory s = new bytes(i);\n', '    for (uint j = 0; j < i; j++) {\n', '      s[j] = reversed[i - j - 1];\n', '    }\n', '    string memory str = string(s);\n', '    return str;\n', '  }\n', '\n', '  function setLockTime(uint256 _lockTIme)public onlyOwner(){\n', '    lockTime = _lockTIme;\n', '  }\n', '\n', '  function transEther() public onlyOwner()\n', '  {\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '\n', '  function () public payable {\n', '  }\n', '}']