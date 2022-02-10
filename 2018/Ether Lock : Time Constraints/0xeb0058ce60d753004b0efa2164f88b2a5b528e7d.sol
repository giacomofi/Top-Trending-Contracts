['pragma solidity ^0.4.16;\n', '\n', '// copyright <span class="__cf_email__" data-cfemail="66050908120705122623120e0314030b09084805090b">[email&#160;protected]</span>\n', '\n', 'contract SafeMath {\n', '\n', '    /* function assert(bool assertion) internal { */\n', '    /*   if (!assertion) { */\n', '    /*     throw; */\n', '    /*   } */\n', '    /* }      // assert no longer needed once solidity is on 0.4.10 */\n', '\n', '    function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '}\n', '\n', 'contract BasicAccessControl {\n', '    address public owner;\n', '    // address[] public moderators;\n', '    uint16 public totalModerators = 0;\n', '    mapping (address => bool) public moderators;\n', '    bool public isMaintaining = false;\n', '\n', '    function BasicAccessControl() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyModerators() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier isActive {\n', '        require(!isMaintaining);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '\n', '    function AddModerator(address _newModerator) onlyOwner public {\n', '        if (moderators[_newModerator] == false) {\n', '            moderators[_newModerator] = true;\n', '            totalModerators += 1;\n', '        }\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner public {\n', '        if (moderators[_oldModerator] == true) {\n', '            moderators[_oldModerator] = false;\n', '            totalModerators -= 1;\n', '        }\n', '    }\n', '\n', '    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '}\n', '\n', 'contract EtheremonEnum {\n', '\n', '    enum ResultCode {\n', '        SUCCESS,\n', '        ERROR_CLASS_NOT_FOUND,\n', '        ERROR_LOW_BALANCE,\n', '        ERROR_SEND_FAIL,\n', '        ERROR_NOT_TRAINER,\n', '        ERROR_NOT_ENOUGH_MONEY,\n', '        ERROR_INVALID_AMOUNT\n', '    }\n', '    \n', '    enum ArrayType {\n', '        CLASS_TYPE,\n', '        STAT_STEP,\n', '        STAT_START,\n', '        STAT_BASE,\n', '        OBJ_SKILL\n', '    }\n', '    \n', '    enum PropertyType {\n', '        ANCESTOR,\n', '        XFACTOR\n', '    }\n', '}\n', '\n', 'contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {\n', '    \n', '    uint64 public totalMonster;\n', '    uint32 public totalClass;\n', '    \n', '    // write\n', '    function withdrawEther(address _sendTo, uint _amount) onlyOwner public returns(ResultCode);\n', '    function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);\n', '    function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) onlyModerators public returns(uint);\n', '    function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);\n', '    function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);\n', '    function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;\n', '    function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;\n', '    function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;\n', '    function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;\n', '    function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;\n', '    function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);\n', '    function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);\n', '    function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);\n', '    function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);\n', '    function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);\n', '    function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;\n', '    \n', '    // read\n', '    function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);\n', '    function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);\n', '    function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);\n', '    function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);\n', '    function getMonsterName(uint64 _objId) constant public returns(string name);\n', '    function getExtraBalance(address _trainer) constant public returns(uint256);\n', '    function getMonsterDexSize(address _trainer) constant public returns(uint);\n', '    function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);\n', '    function getExpectedBalance(address _trainer) constant public returns(uint256);\n', '    function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '}\n', '\n', 'contract BattleInterface {\n', '    function createCastleWithToken(address _trainer, uint32 _noBrick, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) external;\n', '}\n', '\n', 'contract TransformInterface {\n', '    function removeHatchingTimeWithToken(address _trainer) external;\n', '    function buyEggWithToken(address _trainer) external;\n', '}\n', '\n', 'contract AdventureInterface {\n', '    function placeEMONTBid(address _bidder, uint8 _siteId, uint _bidAmount) external;\n', '}\n', '\n', 'contract EtheremonPayment is EtheremonEnum, BasicAccessControl, SafeMath {\n', '    uint8 constant public STAT_COUNT = 6;\n', '    uint8 constant public STAT_MAX = 32;\n', '    uint8 constant public GEN0_NO = 24;\n', '    \n', '    enum PayServiceType {\n', '        NONE,\n', '        FAST_HATCHING,\n', '        RANDOM_EGG,\n', '        ADVENTURE_PRESALE\n', '    }\n', '    \n', '    struct MonsterClassAcc {\n', '        uint32 classId;\n', '        uint256 price;\n', '        uint256 returnPrice;\n', '        uint32 total;\n', '        bool catchable;\n', '    }\n', '\n', '    struct MonsterObjAcc {\n', '        uint64 monsterId;\n', '        uint32 classId;\n', '        address trainer;\n', '        string name;\n', '        uint32 exp;\n', '        uint32 createIndex;\n', '        uint32 lastClaimIndex;\n', '        uint createTime;\n', '    }\n', '    \n', '    // linked smart contract\n', '    address public dataContract;\n', '    address public battleContract;\n', '    address public tokenContract;\n', '    address public transformContract;\n', '    address public adventureContract;\n', '    \n', '    address private lastHunter = address(0x0);\n', '    \n', '    // config\n', '    uint public brickPrice = 6 * 10 ** 8; // 6 tokens\n', '    uint public fastHatchingPrice = 35 * 10 ** 8; // 15 tokens \n', '    uint public buyEggPrice = 80 * 10 ** 8; // 80 tokens\n', '    uint public tokenPrice = 0.004 ether / 10 ** 8;\n', '    uint public maxDexSize = 200;\n', '    \n', '    // event\n', '    event EventCatchMonster(address indexed trainer, uint64 objId);\n', '    \n', '    // modifier\n', '    modifier requireDataContract {\n', '        require(dataContract != address(0));\n', '        _;        \n', '    }\n', '    \n', '    modifier requireBattleContract {\n', '        require(battleContract != address(0));\n', '        _;\n', '    }\n', '\n', '    modifier requireTokenContract {\n', '        require(tokenContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    modifier requireTransformContract {\n', '        require(transformContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    function EtheremonPayment(address _dataContract, address _battleContract, address _tokenContract, address _transformContract, address _adventureContract) public {\n', '        dataContract = _dataContract;\n', '        battleContract = _battleContract;\n', '        tokenContract = _tokenContract;\n', '        transformContract = _transformContract;\n', '        adventureContract = _adventureContract;\n', '    }\n', '    \n', '    // helper\n', '    function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {\n', '        uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);\n', '        for (uint8 i = 0; i < index && i < 6; i ++) {\n', '            genNum /= 256;\n', '        }\n', '        return uint8(genNum % maxRan);\n', '    }\n', '    \n', '    // admin\n', '    function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {\n', '        ERC20Interface token = ERC20Interface(tokenContract);\n', '        if (_amount > token.balanceOf(address(this))) {\n', '            revert();\n', '        }\n', '        token.transfer(_sendTo, _amount);\n', '    }\n', '    \n', '    function setContract(address _dataContract, address _battleContract, address _tokenContract, address _transformContract, address _adventureContract) onlyModerators external {\n', '        dataContract = _dataContract;\n', '        battleContract = _battleContract;\n', '        tokenContract = _tokenContract;\n', '        transformContract = _transformContract;\n', '        adventureContract = _adventureContract;\n', '    }\n', '    \n', '    function setConfig(uint _brickPrice, uint _tokenPrice, uint _maxDexSize, uint _fastHatchingPrice, uint _buyEggPrice) onlyModerators external {\n', '        brickPrice = _brickPrice;\n', '        tokenPrice = _tokenPrice;\n', '        maxDexSize = _maxDexSize;\n', '        fastHatchingPrice = _fastHatchingPrice;\n', '        buyEggPrice = _buyEggPrice;\n', '    }\n', '    \n', '    // battle\n', '    function giveBattleBonus(address _trainer, uint _amount) isActive requireBattleContract requireTokenContract public {\n', '        if (msg.sender != battleContract)\n', '            revert();\n', '        ERC20Interface token = ERC20Interface(tokenContract);\n', '        token.transfer(_trainer, _amount);\n', '    }\n', '    \n', '    function createCastle(address _trainer, uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireBattleContract requireTokenContract public returns(uint){\n', '        if (msg.sender != tokenContract)\n', '            revert();\n', '        BattleInterface battle = BattleInterface(battleContract);\n', '        battle.createCastleWithToken(_trainer, uint32(_tokens/brickPrice), _name, _a1, _a2, _a3, _s1, _s2, _s3);\n', '        return _tokens;\n', '    }\n', '    \n', '    function catchMonster(address _trainer, uint _tokens, uint32 _classId, string _name) isActive requireDataContract requireTokenContract public returns(uint){\n', '        if (msg.sender != tokenContract)\n', '            revert();\n', '        \n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterClassAcc memory class;\n', '        (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);\n', '        \n', '        if (class.classId == 0 || class.catchable == false) {\n', '            revert();\n', '        }\n', '        \n', '        // can not keep too much etheremon \n', '        if (data.getMonsterDexSize(_trainer) > maxDexSize)\n', '            revert();\n', '\n', '        uint requiredToken = class.price/tokenPrice;\n', '        if (_tokens < requiredToken)\n', '            revert();\n', '\n', '        // add monster\n', '        uint64 objId = data.addMonsterObj(_classId, _trainer, _name);\n', '        // generate base stat for the previous one\n', '        for (uint i=0; i < STAT_COUNT; i+= 1) {\n', '            uint8 value = getRandom(STAT_MAX, uint8(i), lastHunter) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);\n', '            data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);\n', '        }\n', '        \n', '        lastHunter = _trainer;\n', '        EventCatchMonster(_trainer, objId);\n', '        return requiredToken;\n', '    }\n', '    \n', '\n', '    function payService(address _trainer, uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3, uint64 _param4, uint64 _param5, uint64 _param6) isActive requireTransformContract  public returns(uint result) {\n', '        if (msg.sender != tokenContract)\n', '            revert();\n', '        \n', '        TransformInterface transform = TransformInterface(transformContract);\n', '        AdventureInterface adventure = AdventureInterface(adventureContract);\n', '        if (_type == uint32(PayServiceType.FAST_HATCHING)) {\n', '            // remove hatching time \n', '            if (_tokens < fastHatchingPrice)\n', '                revert();\n', '            transform.removeHatchingTimeWithToken(_trainer);\n', '            \n', '            return fastHatchingPrice;\n', '        } else if (_type == uint32(PayServiceType.RANDOM_EGG)) {\n', '            if (_tokens < buyEggPrice)\n', '                revert();\n', '            transform.buyEggWithToken(_trainer);\n', '\n', '            return buyEggPrice;\n', '        } else if (_type == uint32(PayServiceType.ADVENTURE_PRESALE)) {\n', '            adventure.placeEMONTBid(_trainer, uint8(_param1), _tokens);\n', '            return _tokens;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '// copyright contact@Etheremon.com\n', '\n', 'contract SafeMath {\n', '\n', '    /* function assert(bool assertion) internal { */\n', '    /*   if (!assertion) { */\n', '    /*     throw; */\n', '    /*   } */\n', '    /* }      // assert no longer needed once solidity is on 0.4.10 */\n', '\n', '    function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '}\n', '\n', 'contract BasicAccessControl {\n', '    address public owner;\n', '    // address[] public moderators;\n', '    uint16 public totalModerators = 0;\n', '    mapping (address => bool) public moderators;\n', '    bool public isMaintaining = false;\n', '\n', '    function BasicAccessControl() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyModerators() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier isActive {\n', '        require(!isMaintaining);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '\n', '    function AddModerator(address _newModerator) onlyOwner public {\n', '        if (moderators[_newModerator] == false) {\n', '            moderators[_newModerator] = true;\n', '            totalModerators += 1;\n', '        }\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner public {\n', '        if (moderators[_oldModerator] == true) {\n', '            moderators[_oldModerator] = false;\n', '            totalModerators -= 1;\n', '        }\n', '    }\n', '\n', '    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '}\n', '\n', 'contract EtheremonEnum {\n', '\n', '    enum ResultCode {\n', '        SUCCESS,\n', '        ERROR_CLASS_NOT_FOUND,\n', '        ERROR_LOW_BALANCE,\n', '        ERROR_SEND_FAIL,\n', '        ERROR_NOT_TRAINER,\n', '        ERROR_NOT_ENOUGH_MONEY,\n', '        ERROR_INVALID_AMOUNT\n', '    }\n', '    \n', '    enum ArrayType {\n', '        CLASS_TYPE,\n', '        STAT_STEP,\n', '        STAT_START,\n', '        STAT_BASE,\n', '        OBJ_SKILL\n', '    }\n', '    \n', '    enum PropertyType {\n', '        ANCESTOR,\n', '        XFACTOR\n', '    }\n', '}\n', '\n', 'contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {\n', '    \n', '    uint64 public totalMonster;\n', '    uint32 public totalClass;\n', '    \n', '    // write\n', '    function withdrawEther(address _sendTo, uint _amount) onlyOwner public returns(ResultCode);\n', '    function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);\n', '    function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) onlyModerators public returns(uint);\n', '    function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);\n', '    function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);\n', '    function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;\n', '    function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;\n', '    function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;\n', '    function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;\n', '    function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;\n', '    function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);\n', '    function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);\n', '    function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);\n', '    function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);\n', '    function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);\n', '    function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;\n', '    \n', '    // read\n', '    function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);\n', '    function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);\n', '    function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);\n', '    function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);\n', '    function getMonsterName(uint64 _objId) constant public returns(string name);\n', '    function getExtraBalance(address _trainer) constant public returns(uint256);\n', '    function getMonsterDexSize(address _trainer) constant public returns(uint);\n', '    function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);\n', '    function getExpectedBalance(address _trainer) constant public returns(uint256);\n', '    function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '}\n', '\n', 'contract BattleInterface {\n', '    function createCastleWithToken(address _trainer, uint32 _noBrick, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) external;\n', '}\n', '\n', 'contract TransformInterface {\n', '    function removeHatchingTimeWithToken(address _trainer) external;\n', '    function buyEggWithToken(address _trainer) external;\n', '}\n', '\n', 'contract AdventureInterface {\n', '    function placeEMONTBid(address _bidder, uint8 _siteId, uint _bidAmount) external;\n', '}\n', '\n', 'contract EtheremonPayment is EtheremonEnum, BasicAccessControl, SafeMath {\n', '    uint8 constant public STAT_COUNT = 6;\n', '    uint8 constant public STAT_MAX = 32;\n', '    uint8 constant public GEN0_NO = 24;\n', '    \n', '    enum PayServiceType {\n', '        NONE,\n', '        FAST_HATCHING,\n', '        RANDOM_EGG,\n', '        ADVENTURE_PRESALE\n', '    }\n', '    \n', '    struct MonsterClassAcc {\n', '        uint32 classId;\n', '        uint256 price;\n', '        uint256 returnPrice;\n', '        uint32 total;\n', '        bool catchable;\n', '    }\n', '\n', '    struct MonsterObjAcc {\n', '        uint64 monsterId;\n', '        uint32 classId;\n', '        address trainer;\n', '        string name;\n', '        uint32 exp;\n', '        uint32 createIndex;\n', '        uint32 lastClaimIndex;\n', '        uint createTime;\n', '    }\n', '    \n', '    // linked smart contract\n', '    address public dataContract;\n', '    address public battleContract;\n', '    address public tokenContract;\n', '    address public transformContract;\n', '    address public adventureContract;\n', '    \n', '    address private lastHunter = address(0x0);\n', '    \n', '    // config\n', '    uint public brickPrice = 6 * 10 ** 8; // 6 tokens\n', '    uint public fastHatchingPrice = 35 * 10 ** 8; // 15 tokens \n', '    uint public buyEggPrice = 80 * 10 ** 8; // 80 tokens\n', '    uint public tokenPrice = 0.004 ether / 10 ** 8;\n', '    uint public maxDexSize = 200;\n', '    \n', '    // event\n', '    event EventCatchMonster(address indexed trainer, uint64 objId);\n', '    \n', '    // modifier\n', '    modifier requireDataContract {\n', '        require(dataContract != address(0));\n', '        _;        \n', '    }\n', '    \n', '    modifier requireBattleContract {\n', '        require(battleContract != address(0));\n', '        _;\n', '    }\n', '\n', '    modifier requireTokenContract {\n', '        require(tokenContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    modifier requireTransformContract {\n', '        require(transformContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    function EtheremonPayment(address _dataContract, address _battleContract, address _tokenContract, address _transformContract, address _adventureContract) public {\n', '        dataContract = _dataContract;\n', '        battleContract = _battleContract;\n', '        tokenContract = _tokenContract;\n', '        transformContract = _transformContract;\n', '        adventureContract = _adventureContract;\n', '    }\n', '    \n', '    // helper\n', '    function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {\n', '        uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);\n', '        for (uint8 i = 0; i < index && i < 6; i ++) {\n', '            genNum /= 256;\n', '        }\n', '        return uint8(genNum % maxRan);\n', '    }\n', '    \n', '    // admin\n', '    function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {\n', '        ERC20Interface token = ERC20Interface(tokenContract);\n', '        if (_amount > token.balanceOf(address(this))) {\n', '            revert();\n', '        }\n', '        token.transfer(_sendTo, _amount);\n', '    }\n', '    \n', '    function setContract(address _dataContract, address _battleContract, address _tokenContract, address _transformContract, address _adventureContract) onlyModerators external {\n', '        dataContract = _dataContract;\n', '        battleContract = _battleContract;\n', '        tokenContract = _tokenContract;\n', '        transformContract = _transformContract;\n', '        adventureContract = _adventureContract;\n', '    }\n', '    \n', '    function setConfig(uint _brickPrice, uint _tokenPrice, uint _maxDexSize, uint _fastHatchingPrice, uint _buyEggPrice) onlyModerators external {\n', '        brickPrice = _brickPrice;\n', '        tokenPrice = _tokenPrice;\n', '        maxDexSize = _maxDexSize;\n', '        fastHatchingPrice = _fastHatchingPrice;\n', '        buyEggPrice = _buyEggPrice;\n', '    }\n', '    \n', '    // battle\n', '    function giveBattleBonus(address _trainer, uint _amount) isActive requireBattleContract requireTokenContract public {\n', '        if (msg.sender != battleContract)\n', '            revert();\n', '        ERC20Interface token = ERC20Interface(tokenContract);\n', '        token.transfer(_trainer, _amount);\n', '    }\n', '    \n', '    function createCastle(address _trainer, uint _tokens, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireBattleContract requireTokenContract public returns(uint){\n', '        if (msg.sender != tokenContract)\n', '            revert();\n', '        BattleInterface battle = BattleInterface(battleContract);\n', '        battle.createCastleWithToken(_trainer, uint32(_tokens/brickPrice), _name, _a1, _a2, _a3, _s1, _s2, _s3);\n', '        return _tokens;\n', '    }\n', '    \n', '    function catchMonster(address _trainer, uint _tokens, uint32 _classId, string _name) isActive requireDataContract requireTokenContract public returns(uint){\n', '        if (msg.sender != tokenContract)\n', '            revert();\n', '        \n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterClassAcc memory class;\n', '        (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);\n', '        \n', '        if (class.classId == 0 || class.catchable == false) {\n', '            revert();\n', '        }\n', '        \n', '        // can not keep too much etheremon \n', '        if (data.getMonsterDexSize(_trainer) > maxDexSize)\n', '            revert();\n', '\n', '        uint requiredToken = class.price/tokenPrice;\n', '        if (_tokens < requiredToken)\n', '            revert();\n', '\n', '        // add monster\n', '        uint64 objId = data.addMonsterObj(_classId, _trainer, _name);\n', '        // generate base stat for the previous one\n', '        for (uint i=0; i < STAT_COUNT; i+= 1) {\n', '            uint8 value = getRandom(STAT_MAX, uint8(i), lastHunter) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);\n', '            data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);\n', '        }\n', '        \n', '        lastHunter = _trainer;\n', '        EventCatchMonster(_trainer, objId);\n', '        return requiredToken;\n', '    }\n', '    \n', '\n', '    function payService(address _trainer, uint _tokens, uint32 _type, string _text, uint64 _param1, uint64 _param2, uint64 _param3, uint64 _param4, uint64 _param5, uint64 _param6) isActive requireTransformContract  public returns(uint result) {\n', '        if (msg.sender != tokenContract)\n', '            revert();\n', '        \n', '        TransformInterface transform = TransformInterface(transformContract);\n', '        AdventureInterface adventure = AdventureInterface(adventureContract);\n', '        if (_type == uint32(PayServiceType.FAST_HATCHING)) {\n', '            // remove hatching time \n', '            if (_tokens < fastHatchingPrice)\n', '                revert();\n', '            transform.removeHatchingTimeWithToken(_trainer);\n', '            \n', '            return fastHatchingPrice;\n', '        } else if (_type == uint32(PayServiceType.RANDOM_EGG)) {\n', '            if (_tokens < buyEggPrice)\n', '                revert();\n', '            transform.buyEggWithToken(_trainer);\n', '\n', '            return buyEggPrice;\n', '        } else if (_type == uint32(PayServiceType.ADVENTURE_PRESALE)) {\n', '            adventure.placeEMONTBid(_trainer, uint8(_param1), _tokens);\n', '            return _tokens;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '}']