['pragma solidity ^0.4.23;\n', '\n', 'contract BasicAccessControl {\n', '    address public owner;\n', '    // address[] public moderators;\n', '    uint16 public totalModerators = 0;\n', '    mapping (address => bool) public moderators;\n', '    bool public isMaintaining = false;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyModerators() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier isActive {\n', '        require(!isMaintaining);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '\n', '    function AddModerator(address _newModerator) onlyOwner public {\n', '        if (moderators[_newModerator] == false) {\n', '            moderators[_newModerator] = true;\n', '            totalModerators += 1;\n', '        }\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner public {\n', '        if (moderators[_oldModerator] == true) {\n', '            moderators[_oldModerator] = false;\n', '            totalModerators -= 1;\n', '        }\n', '    }\n', '\n', '    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '}\n', '\n', 'interface EtheremonMonsterNFTInterface {\n', '   function triggerTransferEvent(address _from, address _to, uint _tokenId) external;\n', '   function getMonsterCP(uint64 _monsterId) constant external returns(uint cp);\n', '}\n', '\n', 'contract EtheremonEnum {\n', '\n', '    enum ResultCode {\n', '        SUCCESS,\n', '        ERROR_CLASS_NOT_FOUND,\n', '        ERROR_LOW_BALANCE,\n', '        ERROR_SEND_FAIL,\n', '        ERROR_NOT_TRAINER,\n', '        ERROR_NOT_ENOUGH_MONEY,\n', '        ERROR_INVALID_AMOUNT\n', '    }\n', '    \n', '    enum ArrayType {\n', '        CLASS_TYPE,\n', '        STAT_STEP,\n', '        STAT_START,\n', '        STAT_BASE,\n', '        OBJ_SKILL\n', '    }\n', '    \n', '    enum PropertyType {\n', '        ANCESTOR,\n', '        XFACTOR\n', '    }\n', '}\n', '\n', 'contract EtheremonDataBase {\n', '    \n', '    uint64 public totalMonster;\n', '    uint32 public totalClass;\n', '    \n', '    // write\n', '    function addElementToArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint8 _value) external returns(uint);\n', '    function addMonsterObj(uint32 _classId, address _trainer, string _name) external returns(uint64);\n', '    function removeMonsterIdMapping(address _trainer, uint64 _monsterId) external;\n', '    \n', '    // read\n', '    function getElementInArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint _index) constant external returns(uint8);\n', '    function getMonsterClass(uint32 _classId) constant external returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);\n', '    function getMonsterObj(uint64 _objId) constant external returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);\n', '}\n', '\n', 'contract EtheremonWorldNFT is BasicAccessControl {\n', '    uint8 constant public STAT_COUNT = 6;\n', '    uint8 constant public STAT_MAX = 32;\n', '    \n', '    struct MonsterClassAcc {\n', '        uint32 classId;\n', '        uint256 price;\n', '        uint256 returnPrice;\n', '        uint32 total;\n', '        bool catchable;\n', '    }\n', '\n', '    struct MonsterObjAcc {\n', '        uint64 monsterId;\n', '        uint32 classId;\n', '        address trainer;\n', '        string name;\n', '        uint32 exp;\n', '        uint32 createIndex;\n', '        uint32 lastClaimIndex;\n', '        uint createTime;\n', '    }\n', '    \n', '    address public dataContract;\n', '    address public monsterNFT;\n', '    \n', '    mapping(uint32 => bool) classWhitelist;\n', '    mapping(address => bool) addressWhitelist;\n', '    \n', '    uint public gapFactor = 5;\n', '    uint public priceIncreasingRatio = 1000;\n', '    \n', '    function setContract(address _dataContract, address _monsterNFT) onlyModerators external {\n', '        dataContract = _dataContract;\n', '        monsterNFT = _monsterNFT;\n', '    }\n', '    \n', '    function setConfig(uint _gapFactor, uint _priceIncreasingRatio) onlyModerators external {\n', '        gapFactor = _gapFactor;\n', '        priceIncreasingRatio = _priceIncreasingRatio;\n', '    }\n', '    \n', '    function setClassWhitelist(uint32 _classId, bool _status) onlyModerators external {\n', '        classWhitelist[_classId] = _status;\n', '    }\n', '\n', '    function setAddressWhitelist(address _smartcontract, bool _status) onlyModerators external {\n', '        addressWhitelist[_smartcontract] = _status;\n', '    }\n', '    \n', '    function withdrawEther(address _sendTo, uint _amount) onlyOwner public {\n', '        if (_amount > address(this).balance) {\n', '            revert();\n', '        }\n', '        _sendTo.transfer(_amount);\n', '    }\n', '    \n', '    function mintMonster(uint32 _classId, address _trainer, string _name) onlyModerators external returns(uint){\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        // add monster\n', '        uint64 objId = data.addMonsterObj(_classId, _trainer, _name);\n', '        uint8 value;\n', '        uint seed = getRandom(_trainer, block.number-1, objId);\n', '        // generate base stat for the previous one\n', '        for (uint i=0; i < STAT_COUNT; i+= 1) {\n', '            seed /= 100;\n', '            value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);\n', '            data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);\n', '        }\n', '        \n', '        EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _trainer, objId);\n', '        return objId;\n', '    }\n', '    \n', '    function burnMonster(uint64 _tokenId) onlyModerators external {\n', '        // need to check condition before calling this function\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterObjAcc memory obj;\n', '        (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_tokenId);\n', '        require(obj.trainer != address(0));\n', '        data.removeMonsterIdMapping(obj.trainer, _tokenId);\n', '        EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(obj.trainer, address(0), _tokenId);\n', '    }\n', '    \n', '    // public api \n', '    function getRandom(address _player, uint _block, uint _count) view public returns(uint) {\n', '        return uint(keccak256(abi.encodePacked(blockhash(_block), _player, _count)));\n', '    }\n', '    \n', '    function getMonsterClassBasic(uint32 _classId) constant external returns(uint256, uint256, uint256, bool) {\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterClassAcc memory class;\n', '        (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);\n', '        return (class.price, class.returnPrice, class.total, class.catchable);\n', '    }\n', '    \n', '    function getPrice(uint32 _classId) constant external returns(bool catchable, uint price) {\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterClassAcc memory class;\n', '        (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);\n', '        \n', '        price = class.price;\n', '        if (class.total > 0)\n', '            price += class.price*(class.total-1)/priceIncreasingRatio;\n', '        \n', '        if (class.catchable == false) {\n', '            return (classWhitelist[_classId], price);\n', '        } else {\n', '            return (true, price);\n', '        }\n', '    }\n', '    \n', '    function catchMonsterNFT(uint32 _classId, string _name) isActive external payable{\n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterClassAcc memory class;\n', '        (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);\n', '        if (class.classId == 0 || class.catchable == false) {\n', '            revert();\n', '        }\n', '        \n', '        uint price = class.price;\n', '        if (class.total > 0)\n', '            price += class.price*(class.total-1)/priceIncreasingRatio;\n', '        if (msg.value < price) {\n', '            revert();\n', '        }\n', '        \n', '        // add new monster \n', '        uint64 objId = data.addMonsterObj(_classId, msg.sender, _name);\n', '        uint8 value;\n', '        uint seed = getRandom(msg.sender, block.number-1, objId);\n', '        // generate base stat for the previous one\n', '        for (uint i=0; i < STAT_COUNT; i+= 1) {\n', '            seed /= 100;\n', '            value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);\n', '            data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);\n', '        }\n', '        \n', '        EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), msg.sender, objId);\n', '        // refund extra\n', '        if (msg.value > price) {\n', '            msg.sender.transfer((msg.value - price));\n', '        }\n', '    }\n', '    \n', '    // for whitelist contracts, no refund extra\n', '    function catchMonster(address _player, uint32 _classId, string _name) isActive external payable returns(uint tokenId) {\n', '        if (addressWhitelist[msg.sender] == false) {\n', '            revert();\n', '        }\n', '        \n', '        EtheremonDataBase data = EtheremonDataBase(dataContract);\n', '        MonsterClassAcc memory class;\n', '        (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);\n', '        if (class.classId == 0) {\n', '            revert();\n', '        }\n', '        \n', '        if (class.catchable == false && classWhitelist[_classId] == false) {\n', '            revert();\n', '        }\n', '        \n', '        uint price = class.price;\n', '        if (class.total > gapFactor) {\n', '            price += class.price*(class.total - gapFactor)/priceIncreasingRatio;\n', '        }\n', '        if (msg.value < price) {\n', '            revert();\n', '        }\n', '        \n', '        // add new monster \n', '        uint64 objId = data.addMonsterObj(_classId, _player, _name);\n', '        uint8 value;\n', '        uint seed = getRandom(_player, block.number-1, objId);\n', '        // generate base stat for the previous one\n', '        for (uint i=0; i < STAT_COUNT; i+= 1) {\n', '            seed /= 100;\n', '            value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);\n', '            data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);\n', '        }\n', '        \n', '        EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _player, objId);\n', '        return objId; \n', '    }\n', '    \n', '}']