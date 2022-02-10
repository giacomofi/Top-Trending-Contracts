['pragma solidity ^0.4.16;\n', '\n', '// copyright contact@Etheremon.com\n', '\n', 'contract SafeMath {\n', '\n', '    /* function assert(bool assertion) internal { */\n', '    /*   if (!assertion) { */\n', '    /*     throw; */\n', '    /*   } */\n', '    /* }      // assert no longer needed once solidity is on 0.4.10 */\n', '\n', '    function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '}\n', '\n', 'contract BasicAccessControl {\n', '    address public owner;\n', '    // address[] public moderators;\n', '    uint16 public totalModerators = 0;\n', '    mapping (address => bool) public moderators;\n', '    bool public isMaintaining = true;\n', '\n', '    function BasicAccessControl() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyModerators() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier isActive {\n', '        require(!isMaintaining);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '\n', '    function AddModerator(address _newModerator) onlyOwner public {\n', '        if (moderators[_newModerator] == false) {\n', '            moderators[_newModerator] = true;\n', '            totalModerators += 1;\n', '        }\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner public {\n', '        if (moderators[_oldModerator] == true) {\n', '            moderators[_oldModerator] = false;\n', '            totalModerators -= 1;\n', '        }\n', '    }\n', '\n', '    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '}\n', '\n', 'contract EtheremonEnum {\n', '\n', '    enum ResultCode {\n', '        SUCCESS,\n', '        ERROR_CLASS_NOT_FOUND,\n', '        ERROR_LOW_BALANCE,\n', '        ERROR_SEND_FAIL,\n', '        ERROR_NOT_TRAINER,\n', '        ERROR_NOT_ENOUGH_MONEY,\n', '        ERROR_INVALID_AMOUNT,\n', '        ERROR_OBJ_NOT_FOUND,\n', '        ERROR_OBJ_INVALID_OWNERSHIP\n', '    }\n', '    \n', '    enum ArrayType {\n', '        CLASS_TYPE,\n', '        STAT_STEP,\n', '        STAT_START,\n', '        STAT_BASE,\n', '        OBJ_SKILL\n', '    }\n', '\n', '    enum PropertyType {\n', '        ANCESTOR,\n', '        XFACTOR\n', '    }\n', '    \n', '    enum BattleResult {\n', '        CASTLE_WIN,\n', '        CASTLE_LOSE,\n', '        CASTLE_DESTROYED\n', '    }\n', '    \n', '    enum CacheClassInfoType {\n', '        CLASS_TYPE,\n', '        CLASS_STEP,\n', '        CLASS_ANCESTOR\n', '    }\n', '}\n', '\n', 'contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {\n', '    \n', '    uint64 public totalMonster;\n', '    uint32 public totalClass;\n', '    \n', '    // read\n', '    function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);\n', '    function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);\n', '    function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);\n', '    function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);\n', '    function getMonsterName(uint64 _objId) constant public returns(string name);\n', '    function getExtraBalance(address _trainer) constant public returns(uint256);\n', '    function getMonsterDexSize(address _trainer) constant public returns(uint);\n', '    function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);\n', '    function getExpectedBalance(address _trainer) constant public returns(uint256);\n', '    function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);\n', '}\n', '\n', 'interface EtheremonTradeInterface {\n', '    function isOnTrading(uint64 _objId) constant external returns(bool);\n', '}\n', '\n', 'contract EtheremonGateway is EtheremonEnum, BasicAccessControl {\n', '    // using for battle contract later\n', '    function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;\n', '    function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;\n', '    \n', '    // read \n', '    function isGason(uint64 _objId) constant external returns(bool);\n', '    function getObjBattleInfo(uint64 _objId) constant external returns(uint32 classId, uint32 exp, bool isGason, \n', '        uint ancestorLength, uint xfactorsLength);\n', '    function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint);\n', '    function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32);\n', '}\n', '\n', 'contract EtheremonCastleContract is EtheremonEnum, BasicAccessControl{\n', '\n', '    uint32 public totalCastle = 0;\n', '    uint64 public totalBattle = 0;\n', '    \n', '    function getCastleBasicInfo(address _owner) constant external returns(uint32, uint, uint32);\n', '    function getCastleBasicInfoById(uint32 _castleId) constant external returns(uint, address, uint32);\n', '    function countActiveCastle() constant external returns(uint);\n', '    function getCastleObjInfo(uint32 _castleId) constant external returns(uint64, uint64, uint64, uint64, uint64, uint64);\n', '    function getCastleStats(uint32 _castleId) constant external returns(string, address, uint32, uint32, uint32, uint);\n', '    function isOnCastle(uint32 _castleId, uint64 _objId) constant external returns(bool);\n', '    function getCastleWinLose(uint32 _castleId) constant external returns(uint32, uint32, uint32);\n', '    function getTrainerBrick(address _trainer) constant external returns(uint32);\n', '\n', '    function addCastle(address _trainer, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _brickNumber) \n', '        onlyModerators external returns(uint32 currentCastleId);\n', '    function renameCastle(uint32 _castleId, string _name) onlyModerators external;\n', '    function removeCastleFromActive(uint32 _castleId) onlyModerators external;\n', '    function deductTrainerBrick(address _trainer, uint32 _deductAmount) onlyModerators external returns(bool);\n', '    \n', '    function addBattleLog(uint32 _castleId, address _attacker, \n', '        uint8 _ran1, uint8 _ran2, uint8 _ran3, uint8 _result, uint32 _castleExp1, uint32 _castleExp2, uint32 _castleExp3) onlyModerators external returns(uint64);\n', '    function addBattleLogMonsterInfo(uint64 _battleId, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _exp1, uint32 _exp2, uint32 _exp3) onlyModerators external;\n', '}\n', '\n', 'contract EtheremonBattle is EtheremonEnum, BasicAccessControl, SafeMath {\n', '    uint8 constant public NO_MONSTER = 3;\n', '    uint8 constant public STAT_COUNT = 6;\n', '    uint8 constant public GEN0_NO = 24;\n', '    \n', '    struct MonsterClassAcc {\n', '        uint32 classId;\n', '        uint256 price;\n', '        uint256 returnPrice;\n', '        uint32 total;\n', '        bool catchable;\n', '    }\n', '\n', '    struct MonsterObjAcc {\n', '        uint64 monsterId;\n', '        uint32 classId;\n', '        address trainer;\n', '        string name;\n', '        uint32 exp;\n', '        uint32 createIndex;\n', '        uint32 lastClaimIndex;\n', '        uint createTime;\n', '    }\n', '    \n', '    struct BattleMonsterData {\n', '        uint64 a1;\n', '        uint64 a2;\n', '        uint64 a3;\n', '        uint64 s1;\n', '        uint64 s2;\n', '        uint64 s3;\n', '    }\n', '\n', '    struct SupporterData {\n', '        uint32 classId1;\n', '        bool isGason1;\n', '        uint8 type1;\n', '        uint32 classId2;\n', '        bool isGason2;\n', '        uint8 type2;\n', '        uint32 classId3;\n', '        bool isGason3;\n', '        uint8 type3;\n', '    }\n', '\n', '    struct AttackData {\n', '        uint64 aa;\n', '        SupporterData asup;\n', '        uint16 aAttackSupport;\n', '        uint64 ba;\n', '        SupporterData bsup;\n', '        uint16 bAttackSupport;\n', '        uint8 index;\n', '    }\n', '    \n', '    struct MonsterBattleLog {\n', '        uint64 objId;\n', '        uint32 exp;\n', '    }\n', '    \n', '    struct BattleLogData {\n', '        address castleOwner;\n', '        uint64 battleId;\n', '        uint32 castleId;\n', '        uint32 castleBrickBonus;\n', '        uint castleIndex;\n', '        uint32[6] monsterExp;\n', '        uint8[3] randoms;\n', '        bool win;\n', '        BattleResult result;\n', '    }\n', '    \n', '    struct CacheClassInfo {\n', '        uint8[] types;\n', '        uint8[] steps;\n', '        uint32[] ancestors;\n', '    }\n', '\n', '    // event\n', '    event EventCreateCastle(address indexed owner, uint32 castleId);\n', '    event EventAttackCastle(address indexed attacker, uint32 castleId, uint8 result);\n', '    event EventRemoveCastle(uint32 indexed castleId);\n', '    \n', '    // linked smart contract\n', '    address public worldContract;\n', '    address public dataContract;\n', '    address public tradeContract;\n', '    address public castleContract;\n', '    \n', '    // global variable\n', '    mapping(uint8 => uint8) typeAdvantages;\n', '    mapping(uint32 => CacheClassInfo) cacheClasses;\n', '    mapping(uint8 => uint32) levelExps;\n', '    uint8 public ancestorBuffPercentage = 10;\n', '    uint8 public gasonBuffPercentage = 10;\n', '    uint8 public typeBuffPercentage = 20;\n', '    uint8 public maxLevel = 100;\n', '    uint16 public maxActiveCastle = 30;\n', '    uint8 public maxRandomRound = 4;\n', '    \n', '    uint8 public winBrickReturn = 8;\n', '    uint32 public castleMinBrick = 5;\n', '    uint256 public brickPrice = 0.008 ether;\n', '    uint8 public minHpDeducted = 10;\n', '    \n', '    uint256 public totalEarn = 0;\n', '    uint256 public totalWithdraw = 0;\n', '    \n', '    address private lastAttacker = address(0x0);\n', '    \n', '    // modifier\n', '    modifier requireDataContract {\n', '        require(dataContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    modifier requireTradeContract {\n', '        require(tradeContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    modifier requireCastleContract {\n', '        require(castleContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    modifier requireWorldContract {\n', '        require(worldContract != address(0));\n', '        _;\n', '    }\n', '\n', '\n', '    function EtheremonBattle(address _dataContract, address _worldContract, address _tradeContract, address _castleContract) public {\n', '        dataContract = _dataContract;\n', '        worldContract = _worldContract;\n', '        tradeContract = _tradeContract;\n', '        castleContract = _castleContract;\n', '    }\n', '    \n', '     // admin & moderators\n', '    function setTypeAdvantages() onlyModerators external {\n', '        typeAdvantages[1] = 14;\n', '        typeAdvantages[2] = 16;\n', '        typeAdvantages[3] = 8;\n', '        typeAdvantages[4] = 9;\n', '        typeAdvantages[5] = 2;\n', '        typeAdvantages[6] = 11;\n', '        typeAdvantages[7] = 3;\n', '        typeAdvantages[8] = 5;\n', '        typeAdvantages[9] = 15;\n', '        typeAdvantages[11] = 18;\n', '        // skipp 10\n', '        typeAdvantages[12] = 7;\n', '        typeAdvantages[13] = 6;\n', '        typeAdvantages[14] = 17;\n', '        typeAdvantages[15] = 13;\n', '        typeAdvantages[16] = 12;\n', '        typeAdvantages[17] = 1;\n', '        typeAdvantages[18] = 4;\n', '    }\n', '    \n', '    function setTypeAdvantage(uint8 _type1, uint8 _type2) onlyModerators external {\n', '        typeAdvantages[_type1] = _type2;\n', '    }\n', '    \n', '    function setCacheClassInfo(uint32 _classId) onlyModerators requireDataContract requireWorldContract public {\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '         EtheremonGateway gateway = EtheremonGateway(worldContract);\n', '        uint i = 0;\n', '        CacheClassInfo storage classInfo = cacheClasses[_classId];\n', '\n', '        // add type\n', '        i = data.getSizeArrayType(ArrayType.CLASS_TYPE, uint64(_classId));\n', '        uint8[] memory aTypes = new uint8[](i);\n', '        for(; i > 0 ; i--) {\n', '            aTypes[i-1] = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(_classId), i-1);\n', '        }\n', '        classInfo.types = aTypes;\n', '\n', '        // add steps\n', '        i = data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId));\n', '        uint8[] memory steps = new uint8[](i);\n', '        for(; i > 0 ; i--) {\n', '            steps[i-1] = data.getElementInArrayType(ArrayType.STAT_STEP, uint64(_classId), i-1);\n', '        }\n', '        classInfo.steps = steps;\n', '        \n', '        // add ancestor\n', '        i = gateway.getClassPropertySize(_classId, PropertyType.ANCESTOR);\n', '        uint32[] memory ancestors = new uint32[](i);\n', '        for(; i > 0 ; i--) {\n', '            ancestors[i-1] = gateway.getClassPropertyValue(_classId, PropertyType.ANCESTOR, i-1);\n', '        }\n', '        classInfo.ancestors = ancestors;\n', '    }\n', '     \n', '    function withdrawEther(address _sendTo, uint _amount) onlyModerators external {\n', '        if (_amount > this.balance) {\n', '            revert();\n', '        }\n', '        uint256 validAmount = safeSubtract(totalEarn, totalWithdraw);\n', '        if (_amount > validAmount) {\n', '            revert();\n', '        }\n', '        totalWithdraw += _amount;\n', '        _sendTo.transfer(_amount);\n', '    }\n', '    \n', '    function setContract(address _dataContract, address _worldContract, address _tradeContract, address _castleContract) onlyModerators external {\n', '        dataContract = _dataContract;\n', '        worldContract = _worldContract;\n', '        tradeContract = _tradeContract;\n', '        castleContract = _castleContract;\n', '    }\n', '    \n', '    function setConfig(uint8 _ancestorBuffPercentage, uint8 _gasonBuffPercentage, uint8 _typeBuffPercentage, uint32 _castleMinBrick, \n', '        uint8 _maxLevel, uint16 _maxActiveCastle, uint8 _maxRandomRound, uint8 _minHpDeducted) onlyModerators external{\n', '        ancestorBuffPercentage = _ancestorBuffPercentage;\n', '        gasonBuffPercentage = _gasonBuffPercentage;\n', '        typeBuffPercentage = _typeBuffPercentage;\n', '        castleMinBrick = _castleMinBrick;\n', '        maxLevel = _maxLevel;\n', '        maxActiveCastle = _maxActiveCastle;\n', '        maxRandomRound = _maxRandomRound;\n', '        minHpDeducted = _minHpDeducted;\n', '    }\n', '    \n', '    function genLevelExp() onlyModerators external {\n', '        uint8 level = 1;\n', '        uint32 requirement = 100;\n', '        uint32 sum = requirement;\n', '        while(level <= 100) {\n', '            levelExps[level] = sum;\n', '            level += 1;\n', '            requirement = (requirement * 11) / 10 + 5;\n', '            sum += requirement;\n', '        }\n', '    }\n', '    \n', '    // public \n', '    function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {\n', '        CacheClassInfo storage classInfo = cacheClasses[_classId];\n', '        return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);\n', '    }\n', '    \n', '    function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {\n', '        uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);\n', '        for (uint8 i = 0; i < index && i < 6; i ++) {\n', '            genNum /= 256;\n', '        }\n', '        return uint8(genNum % maxRan);\n', '    }\n', '    \n', '    function getLevel(uint32 exp) view public returns (uint8) {\n', '        uint8 minIndex = 1;\n', '        uint8 maxIndex = 100;\n', '        uint8 currentIndex;\n', '     \n', '        while (minIndex < maxIndex) {\n', '            currentIndex = (minIndex + maxIndex) / 2;\n', '            while (minIndex < maxIndex) {\n', '                currentIndex = (minIndex + maxIndex) / 2;\n', '                if (exp < levelExps[currentIndex])\n', '                    maxIndex = currentIndex;\n', '                else\n', '                    minIndex = currentIndex + 1;\n', '            }\n', '        }\n', '        return minIndex;\n', '    }\n', '    \n', '    function getGainExp(uint32 _exp1, uint32 _exp2, bool _win) view public returns(uint32){\n', '        uint8 level = getLevel(_exp2);\n', '        uint8 level2 = getLevel(_exp1);\n', '        uint8 halfLevel1 = level;\n', '        if (level > level2 + 3) {\n', '            halfLevel1 = (level2 + 3) / 2;\n', '        } else {\n', '            halfLevel1 = level / 2;\n', '        }\n', '        uint32 gainExp = 1;\n', '        uint256 rate = (21 ** uint256(halfLevel1)) * 1000 / (20 ** uint256(halfLevel1));\n', '        rate = rate * rate;\n', '        if ((level > level2 + 3 && level2 + 3 > 2 * halfLevel1) || (level <= level2 + 3 && level > 2 * halfLevel1)) rate = rate * 21 / 20;\n', '        if (_win) {\n', '            gainExp = uint32(30 * rate / 1000000);\n', '        } else {\n', '            gainExp = uint32(10 * rate / 1000000);\n', '        }\n', '        \n', '        if (level2 >= level + 5) {\n', '            gainExp /= uint32(2) ** ((level2 - level) / 5);\n', '        }\n', '        return gainExp;\n', '    }\n', '    \n', '    function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterObjAcc memory obj;\n', '        uint32 _ = 0;\n', '        (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);\n', '     \n', '        return (obj.exp, getLevel(obj.exp));\n', '    }\n', '    \n', '    function getMonsterCP(uint64 _objId) constant external returns(uint64) {\n', '        uint16[6] memory stats;\n', '        uint32 classId = 0;\n', '        uint32 exp = 0;\n', '        (classId, exp, stats) = getCurrentStats(_objId);\n', '        \n', '        uint256 total;\n', '        for(uint i=0; i < STAT_COUNT; i+=1) {\n', '            total += stats[i];\n', '        }\n', '        return uint64(total/STAT_COUNT);\n', '    }\n', '    \n', '    function isOnBattle(uint64 _objId) constant external returns(bool) {\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        EtheremonCastleContract castle = EtheremonCastleContract(castleContract);\n', '        uint32 castleId;\n', '        uint castleIndex = 0;\n', '        uint256 price = 0;\n', '        MonsterObjAcc memory obj;\n', '        (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);\n', '        (castleId, castleIndex, price) = castle.getCastleBasicInfo(obj.trainer);\n', '        if (castleId > 0 && castleIndex > 0)\n', '            return castle.isOnCastle(castleId, _objId);\n', '        return false;\n', '    }\n', '    \n', '    function isValidOwner(uint64 _objId, address _owner) constant public returns(bool) {\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterObjAcc memory obj;\n', '        (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);\n', '        return (obj.trainer == _owner);\n', '    }\n', '    \n', '    function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterObjAcc memory obj;\n', '        uint32 _ = 0;\n', '        (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);\n', '        return (obj.classId, obj.exp);\n', '    }\n', '    \n', '    function getCurrentStats(uint64 _objId) constant public returns(uint32, uint32, uint16[6]){\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        uint16[6] memory stats;\n', '        uint32 classId;\n', '        uint32 exp;\n', '        (classId, exp) = getObjExp(_objId);\n', '        if (classId == 0)\n', '            return (classId, exp, stats);\n', '        \n', '        uint i = 0;\n', '        uint8 level = getLevel(exp);\n', '        for(i=0; i < STAT_COUNT; i+=1) {\n', '            stats[i] += data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);\n', '        }\n', '        for(i=0; i < cacheClasses[classId].steps.length; i++) {\n', '            stats[i] += uint16(safeMult(cacheClasses[classId].steps[i], level*3));\n', '        }\n', '        return (classId, exp, stats);\n', '    }\n', '    \n', '    function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){\n', '        if (a > b) {\n', '            return a - b;\n', '        }\n', '        return 0;\n', '    }\n', '    \n', '    function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){\n', '        if (_lucky) {\n', '            _attack = _attack * 13 / 10;\n', '            _specialAttack = _specialAttack * 13 / 10;\n', '        }\n', '        uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);\n', '        uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);\n', '        if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)\n', '            return minHpDeducted;\n', '        if (hpDeducted > hpSpecialDeducted)\n', '            return hpDeducted;\n', '        return hpSpecialDeducted;\n', '    }\n', '    \n', '    function getAncestorBuff(uint32 _classId, SupporterData _support) constant private returns(uint16){\n', '        // check ancestors\n', '        uint i =0;\n', '        uint8 countEffect = 0;\n', '        uint ancestorSize = cacheClasses[_classId].ancestors.length;\n', '        if (ancestorSize > 0) {\n', '            uint32 ancestorClass = 0;\n', '            for (i=0; i < ancestorSize; i ++) {\n', '                ancestorClass = cacheClasses[_classId].ancestors[i];\n', '                if (ancestorClass == _support.classId1 || ancestorClass == _support.classId2 || ancestorClass == _support.classId3) {\n', '                    countEffect += 1;\n', '                }\n', '            }\n', '        }\n', '        return countEffect * ancestorBuffPercentage;\n', '    }\n', '    \n', '    function getGasonSupport(uint32 _classId, SupporterData _sup) constant private returns(uint16 defenseSupport) {\n', '        uint i = 0;\n', '        uint8 classType = 0;\n', '        for (i = 0; i < cacheClasses[_classId].types.length; i++) {\n', '            classType = cacheClasses[_classId].types[i];\n', '             if (_sup.isGason1) {\n', '                if (classType == _sup.type1) {\n', '                    defenseSupport += 1;\n', '                    continue;\n', '                }\n', '            }\n', '            if (_sup.isGason2) {\n', '                if (classType == _sup.type2) {\n', '                    defenseSupport += 1;\n', '                    continue;\n', '                }\n', '            }\n', '            if (_sup.isGason3) {\n', '                if (classType == _sup.type3) {\n', '                    defenseSupport += 1;\n', '                    continue;\n', '                }\n', '            }\n', '            defenseSupport = defenseSupport * gasonBuffPercentage;\n', '        }\n', '    }\n', '    \n', '    function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (uint16 aAttackSupport, uint16 bAttackSupport) {\n', '        // check types \n', '        bool aHasAdvantage;\n', '        bool bHasAdvantage;\n', '        for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {\n', '            for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {\n', '                if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {\n', '                    aHasAdvantage = true;\n', '                }\n', '                if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {\n', '                    bHasAdvantage = true;\n', '                }\n', '            }\n', '        }\n', '        \n', '        if (aHasAdvantage)\n', '            aAttackSupport += typeBuffPercentage;\n', '        if (bHasAdvantage)\n', '            bAttackSupport += typeBuffPercentage;\n', '    }\n', '    \n', '    function calculateBattleStats(AttackData att) constant private returns(uint32 aExp, uint16[6] aStats, uint32 bExp, uint16[6] bStats) {\n', '        uint32 aClassId = 0;\n', '        (aClassId, aExp, aStats) = getCurrentStats(att.aa);\n', '        uint32 bClassId = 0;\n', '        (bClassId, bExp, bStats) = getCurrentStats(att.ba);\n', '        \n', '        // check gasonsupport\n', '        (att.aAttackSupport, att.bAttackSupport) = getTypeSupport(aClassId, bClassId);\n', '        att.aAttackSupport += getAncestorBuff(aClassId, att.asup);\n', '        att.bAttackSupport += getAncestorBuff(bClassId, att.bsup);\n', '        \n', '        uint16 aDefenseBuff = getGasonSupport(aClassId, att.asup);\n', '        uint16 bDefenseBuff = getGasonSupport(bClassId, att.bsup);\n', '        \n', '        // add attack\n', '        aStats[1] += aStats[1] * att.aAttackSupport;\n', '        aStats[3] += aStats[3] * att.aAttackSupport;\n', '        bStats[1] += bStats[1] * att.aAttackSupport;\n', '        bStats[3] += bStats[3] * att.aAttackSupport;\n', '        \n', '        // add offense\n', '        aStats[2] += aStats[2] * aDefenseBuff;\n', '        aStats[4] += aStats[4] * aDefenseBuff;\n', '        bStats[2] += bStats[2] * bDefenseBuff;\n', '        bStats[4] += bStats[4] * bDefenseBuff;\n', '        \n', '    }\n', '    \n', '    function attack(AttackData att) constant private returns(uint32 aExp, uint32 bExp, uint8 ran, bool win) {\n', '        uint16[6] memory aStats;\n', '        uint16[6] memory bStats;\n', '        (aExp, aStats, bExp, bStats) = calculateBattleStats(att);\n', '        \n', '        ran = getRandom(maxRandomRound+2, att.index, lastAttacker);\n', '        uint16 round = 0;\n', '        while (round < maxRandomRound && aStats[0] > 0 && bStats[0] > 0) {\n', '            if (aStats[5] > bStats[5]) {\n', '                if (round % 2 == 0) {\n', '                    // a attack \n', '                    bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));\n', '                } else {\n', '                    aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));\n', '                }\n', '                \n', '            } else {\n', '                if (round % 2 != 0) {\n', '                    bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));\n', '                } else {\n', '                    aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));\n', '                }\n', '            }\n', '            round+= 1;\n', '        }\n', '        \n', '        win = aStats[0] >= bStats[0];\n', '    }\n', '    \n', '    function destroyCastle(uint32 _castleId, bool win) requireCastleContract private returns(uint32){\n', '        // if castle win, ignore\n', '        if (win)\n', '            return 0;\n', '        EtheremonCastleContract castle = EtheremonCastleContract(castleContract);\n', '        uint32 totalWin;\n', '        uint32 totalLose;\n', '        uint32 brickNumber;\n', '        (totalWin, totalLose, brickNumber) = castle.getCastleWinLose(_castleId);\n', '        if (brickNumber + totalWin/winBrickReturn <= totalLose + 1) {\n', '            castle.removeCastleFromActive(_castleId);\n', '            return brickNumber;\n', '        }\n', '        return 0;\n', '    }\n', '    \n', '    function hasValidParam(address trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {\n', '        if (_a1 == 0 || _a2 == 0 || _a3 == 0)\n', '            return false;\n', '        if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)\n', '            return false;\n', '        if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)\n', '            return false;\n', '        if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)\n', '            return false;\n', '        if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))\n', '            return false;\n', '        if (_s2 > 0 && (_s2 == _s3))\n', '            return false;\n', '        \n', '        if (!isValidOwner(_a1, trainer) || !isValidOwner(_a2, trainer) || !isValidOwner(_a3, trainer))\n', '            return false;\n', '        if (_s1 > 0 && !isValidOwner(_s1, trainer))\n', '            return false;\n', '        if (_s2 > 0 && !isValidOwner(_s2, trainer))\n', '            return false;\n', '        if (_s3 > 0 && !isValidOwner(_s3, trainer))\n', '            return false;\n', '        return true;\n', '    }\n', '    \n', '    // public\n', '    function createCastle(string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract \n', '        requireTradeContract requireCastleContract payable external {\n', '        \n', '        if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))\n', '            revert();\n', '        \n', '        EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);\n', '        if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || \n', '            trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))\n', '            revert();\n', '        \n', '        EtheremonCastleContract castle = EtheremonCastleContract(castleContract);\n', '        uint32 castleId;\n', '        uint castleIndex = 0;\n', '        uint32 numberBrick = 0;\n', '        (castleId, castleIndex, numberBrick) = castle.getCastleBasicInfo(msg.sender);\n', '        if (castleId > 0 || castleIndex > 0)\n', '            revert();\n', '\n', '        if (castle.countActiveCastle() >= uint(maxActiveCastle))\n', '            revert();\n', '        numberBrick = uint32(msg.value / brickPrice) + castle.getTrainerBrick(msg.sender);\n', '        if (numberBrick < castleMinBrick) {\n', '            revert();\n', '        }\n', '        castle.deductTrainerBrick(msg.sender, castle.getTrainerBrick(msg.sender));\n', '        totalEarn += msg.value;\n', '        castleId = castle.addCastle(msg.sender, _name, _a1, _a2, _a3, _s1, _s2, _s3, numberBrick);\n', '        EventCreateCastle(msg.sender, castleId);\n', '    }\n', '    \n', '    function renameCastle(uint32 _castleId, string _name) isActive requireCastleContract external {\n', '        EtheremonCastleContract castle = EtheremonCastleContract(castleContract);\n', '        uint index;\n', '        address owner;\n', '        uint256 price;\n', '        (index, owner, price) = castle.getCastleBasicInfoById(_castleId);\n', '        if (owner != msg.sender)\n', '            revert();\n', '        castle.renameCastle(_castleId, _name);\n', '    }\n', '    \n', '    function removeCastle(uint32 _castleId) isActive requireCastleContract external {\n', '        EtheremonCastleContract castle = EtheremonCastleContract(castleContract);\n', '        uint index;\n', '        address owner;\n', '        uint256 price;\n', '        (index, owner, price) = castle.getCastleBasicInfoById(_castleId);\n', '        if (owner != msg.sender)\n', '            revert();\n', '        if (index > 0) {\n', '            castle.removeCastleFromActive(_castleId);\n', '        }\n', '        EventRemoveCastle(_castleId);\n', '    }\n', '    \n', '    function getSupporterInfo(uint64 s1, uint64 s2, uint64 s3) constant public returns(SupporterData sData) {\n', '        uint temp;\n', '        uint32 __;\n', '        EtheremonGateway gateway = EtheremonGateway(worldContract);\n', '        if (s1 > 0)\n', '            (sData.classId1, __, sData.isGason1, temp, temp) = gateway.getObjBattleInfo(s1);\n', '        if (s2 > 0)\n', '            (sData.classId2, __, sData.isGason2, temp, temp) = gateway.getObjBattleInfo(s2);\n', '        if (s3 > 0)\n', '            (sData.classId3, __, sData.isGason3, temp, temp) = gateway.getObjBattleInfo(s3);\n', '\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        if (sData.isGason1) {\n', '            sData.type1 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId1), 0);\n', '        }\n', '        \n', '        if (sData.isGason2) {\n', '            sData.type2 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId2), 0);\n', '        }\n', '        \n', '        if (sData.isGason3) {\n', '            sData.type3 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId3), 0);\n', '        }\n', '    }\n', '    \n', '    function attackCastle(uint32 _castleId, uint64 _aa1, uint64 _aa2, uint64 _aa3, uint64 _as1, uint64 _as2, uint64 _as3) isActive requireDataContract \n', '        requireTradeContract requireCastleContract external {\n', '        if (!hasValidParam(msg.sender, _aa1, _aa2, _aa3, _as1, _as2, _as3))\n', '            revert();\n', '        \n', '        EtheremonCastleContract castle = EtheremonCastleContract(castleContract);\n', '        BattleLogData memory log;\n', '        (log.castleIndex, log.castleOwner, log.castleBrickBonus) = castle.getCastleBasicInfoById(_castleId);\n', '        if (log.castleIndex == 0 || log.castleOwner == msg.sender)\n', '            revert();\n', '        \n', '        EtheremonGateway gateway = EtheremonGateway(worldContract);\n', '        BattleMonsterData memory b;\n', '        (b.a1, b.a2, b.a3, b.s1, b.s2, b.s3) = castle.getCastleObjInfo(_castleId);\n', '        lastAttacker = msg.sender;\n', '\n', '        // init data\n', '        uint8 countWin = 0;\n', '        AttackData memory att;\n', '        att.asup = getSupporterInfo(b.s1, b.s2, b.s3);\n', '        att.bsup = getSupporterInfo(_as1, _as2, _as3);\n', '        \n', '        att.index = 0;\n', '        att.aa = b.a1;\n', '        att.ba = _aa1;\n', '        (log.monsterExp[0], log.monsterExp[3], log.randoms[0], log.win) = attack(att);\n', '        gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[0], log.monsterExp[3], log.win));\n', '        gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[3], log.monsterExp[0], !log.win));\n', '        if (log.win)\n', '            countWin += 1;\n', '        \n', '        \n', '        att.index = 1;\n', '        att.aa = b.a2;\n', '        att.ba = _aa2;\n', '        (log.monsterExp[1], log.monsterExp[4], log.randoms[1], log.win) = attack(att);\n', '        gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[1], log.monsterExp[4], log.win));\n', '        gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[4], log.monsterExp[1], !log.win));\n', '        if (log.win)\n', '            countWin += 1;   \n', '\n', '        att.index = 2;\n', '        att.aa = b.a3;\n', '        att.ba = _aa3;\n', '        (log.monsterExp[2], log.monsterExp[5], log.randoms[2], log.win) = attack(att);\n', '        gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[2], log.monsterExp[5], log.win));\n', '        gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[5], log.monsterExp[2], !log.win));\n', '        if (log.win)\n', '            countWin += 1; \n', '        \n', '        \n', '        log.castleBrickBonus = destroyCastle(_castleId, countWin>1);\n', '        if (countWin>1) {\n', '            log.result = BattleResult.CASTLE_WIN;\n', '        } else {\n', '            if (log.castleBrickBonus > 0) {\n', '                log.result = BattleResult.CASTLE_DESTROYED;\n', '            } else {\n', '                log.result = BattleResult.CASTLE_LOSE;\n', '            }\n', '        }\n', '        \n', '        log.battleId = castle.addBattleLog(_castleId, msg.sender, log.randoms[0], log.randoms[1], log.randoms[2], \n', '            uint8(log.result), log.monsterExp[0], log.monsterExp[1], log.monsterExp[2]);\n', '        \n', '        castle.addBattleLogMonsterInfo(log.battleId, _aa1, _aa2, _aa3, _as1, _as2, _as3, log.monsterExp[3], log.monsterExp[4], log.monsterExp[5]);\n', '    \n', '        EventAttackCastle(msg.sender, _castleId, uint8(log.result));\n', '    }\n', '    \n', '}']