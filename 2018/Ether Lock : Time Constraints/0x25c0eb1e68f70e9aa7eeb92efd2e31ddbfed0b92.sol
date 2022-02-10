['pragma solidity ^0.4.24;\n', '\n', 'library MathLib {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        assert(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0 || b == 0) {\n', '            c = 0;\n', '        } else {\n', '            c = a * b;\n', '            assert(c / a == b);\n', '        }\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', 'interface IMultiOwnable {\n', '\n', '    function owners() external view returns (address[]);\n', '    function transferOwnership(address newOwner) external;\n', '    function appointHeir(address heir) external;\n', '    function succeedOwner(address owner) external;\n', '\n', '    event OwnershipTransfer(address indexed owner, address indexed newOwner);\n', '    event HeirAppointment(address indexed owner, address indexed heir);\n', '    event OwnershipSuccession(address indexed owner, address indexed heir);\n', '}\n', '\n', '\n', 'library AddressLib {\n', '\n', '    using AddressLib for AddressLib.Set;\n', '\n', '    function isEmpty(address value) internal pure returns (bool) {\n', '        return value == address(0);\n', '    }\n', '\n', '    function isSender(address value) internal view returns (bool) {\n', '        return value == msg.sender;\n', '    }\n', '\n', '    struct Set {\n', '        address[] vals;\n', '        mapping(address => uint256) seqs;\n', '    }\n', '\n', '    function values(Set storage set) internal view returns (address[]) {\n', '        return set.vals;\n', '    }\n', '\n', '    function count(Set storage set) internal view returns (uint256) {\n', '        return set.vals.length;\n', '    }\n', '\n', '    function first(Set storage set) internal view returns (address) {\n', '        require(set.count() > 0, "Set cannot be empty");\n', '\n', '        return set.vals[0];\n', '    }\n', '\n', '    function last(Set storage set) internal view returns (address) {\n', '        require(set.count() > 0, "Set cannot be empty");\n', '\n', '        return set.vals[set.vals.length - 1];\n', '    }\n', '\n', '    function contains(Set storage set, address value) internal view returns (bool) {\n', '        return set.seqs[value] > 0;\n', '    }\n', '\n', '    function add(Set storage set, address value) internal {\n', '        if (!set.contains(value)) {\n', '            set.seqs[value] = set.vals.push(value);\n', '        }\n', '    }\n', '\n', '    function remove(Set storage set, address value) internal {\n', '        if (set.contains(value)) {\n', '            uint256 seq = set.seqs[value];\n', '\n', '            if (seq < set.count()) {\n', '                address lastVal = set.last();\n', '\n', '                set.vals[seq - 1] = lastVal;\n', '                set.seqs[lastVal] = seq;\n', '            }\n', '\n', '            set.vals.length--;\n', '            set.seqs[value] = 0;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract MultiOwnable is IMultiOwnable {\n', '\n', '    using AddressLib for address;\n', '    using AddressLib for AddressLib.Set;\n', '\n', '    AddressLib.Set private _owners;\n', '    mapping(address => address) private _heirs;\n', '\n', '    modifier onlyOwner {\n', '        require(_owners.contains(msg.sender), "Only allowed for a owner");\n', '        _;\n', '    }\n', '\n', '    constructor (address[] owners) internal {\n', '        for (uint256 i = 0; i < owners.length; i++) {\n', '            _owners.add(owners[i]);\n', '        }\n', '    }\n', '\n', '    function owners() external view returns (address[]) {\n', '        return _owners.values();\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        _transferOwnership(msg.sender, newOwner);\n', '\n', '        emit OwnershipTransfer(msg.sender, newOwner);\n', '    }\n', '\n', '    function appointHeir(address heir) external onlyOwner {\n', '        _heirs[msg.sender] = heir;\n', '\n', '        emit HeirAppointment(msg.sender, heir);\n', '    }\n', '\n', '    function succeedOwner(address owner) external {\n', '        require(_heirs[owner].isSender(), "Only heir may succeed owner");\n', '\n', '        _transferOwnership(owner, msg.sender);\n', '        \n', '        emit OwnershipSuccession(owner, msg.sender);\n', '    }\n', '\n', '    function _transferOwnership(address owner, address newOwner) private {\n', '        _owners.remove(owner);\n', '        _owners.add(newOwner);\n', '        _heirs[owner] = address(0);\n', '    }\n', '}\n', '\n', '\n', 'contract Geo {\n', '\n', '    enum Class { District, Zone, Target }\n', '    enum Status { Locked, Unlocked, Owned }\n', '\n', '    struct Area {\n', '        Class class;\n', '        Status status;\n', '        uint256 parent;\n', '        uint256[] siblings;\n', '        uint256[] children;\n', '        address owner;\n', '        uint256 cost;\n', '        uint256 unlockTime;\n', '    }\n', '\n', '    mapping(uint256 => Area) internal areas;\n', '\n', '    constructor () internal { }\n', '\n', '    function initAreas() internal {\n', '        areas[0].class = Class.Target;\n', '\n', '        areas[1].class = Class.District;\n', '        areas[1].parent = 46;\n', '        areas[1].siblings = [2,3];\n', '        areas[2].class = Class.District;\n', '        areas[2].parent = 46;\n', '        areas[2].siblings = [1,3];\n', '        areas[3].class = Class.District;\n', '        areas[3].parent = 46;\n', '        areas[3].siblings = [1,2,4,6,8,9,11,13];\n', '        areas[4].class = Class.District;\n', '        areas[4].parent = 46;\n', '        areas[4].siblings = [3,5,6,9];\n', '        areas[5].class = Class.District;\n', '        areas[5].parent = 46;\n', '        areas[5].siblings = [4,6,7,9,37,38,39,41];\n', '        areas[6].class = Class.District;\n', '        areas[6].parent = 46;\n', '        areas[6].siblings = [3,4,5,7,13,22];\n', '        areas[7].class = Class.District;\n', '        areas[7].parent = 46;\n', '        areas[7].siblings = [5,6,21,22,26,38];\n', '        areas[8].class = Class.District;\n', '        areas[8].parent = 46;\n', '\n', '        areas[9].class = Class.District;\n', '        areas[9].parent = 47;\n', '        areas[9].siblings = [3,4,5,10,11,12,39,41];\n', '        areas[10].class = Class.District;\n', '        areas[10].parent = 47;\n', '        areas[10].siblings = [9,11,12];\n', '        areas[11].class = Class.District;\n', '        areas[11].parent = 47;\n', '        areas[11].siblings = [3,9,10,14];\n', '        areas[12].class = Class.District;\n', '        areas[12].parent = 47;\n', '        areas[12].siblings = [9,10];\n', '        areas[13].class = Class.District;\n', '        areas[13].parent = 47;\n', '        areas[13].siblings = [3,6,15,16,17,22];\n', '        areas[14].class = Class.District;\n', '        areas[14].parent = 47;\n', '        areas[15].class = Class.District;\n', '        areas[15].parent = 47;\n', '        areas[16].class = Class.District;\n', '        areas[16].parent = 47;\n', '\n', '        areas[17].class = Class.District;\n', '        areas[17].parent = 48;\n', '        areas[17].siblings = [13,18,19,22,23];\n', '        areas[18].class = Class.District;\n', '        areas[18].parent = 48;\n', '        areas[18].siblings = [17,19];\n', '        areas[19].class = Class.District;\n', '        areas[19].parent = 48;\n', '        areas[19].siblings = [17,18,20,21,22,25];\n', '        areas[20].class = Class.District;\n', '        areas[20].parent = 48;\n', '        areas[20].siblings = [19,21,24,27];\n', '        areas[21].class = Class.District;\n', '        areas[21].parent = 48;\n', '        areas[21].siblings = [7,19,20,22,26,27];\n', '        areas[22].class = Class.District;\n', '        areas[22].parent = 48;\n', '        areas[22].siblings = [6,7,13,17,19,21];\n', '        areas[23].class = Class.District;\n', '        areas[23].parent = 48;\n', '        areas[24].class = Class.District;\n', '        areas[24].parent = 48;\n', '        areas[25].class = Class.District;\n', '        areas[25].parent = 48;\n', '\n', '        areas[26].class = Class.District;\n', '        areas[26].parent = 49;\n', '        areas[26].siblings = [7,21,27,28,31,38];\n', '        areas[27].class = Class.District;\n', '        areas[27].parent = 49;\n', '        areas[27].siblings = [20,21,26,28,29,32,33,34,36];\n', '        areas[28].class = Class.District;\n', '        areas[28].parent = 49;\n', '        areas[28].siblings = [26,27,30,31,35];\n', '        areas[29].class = Class.District;\n', '        areas[29].parent = 49;\n', '        areas[29].siblings = [27];\n', '        areas[30].class = Class.District;\n', '        areas[30].parent = 49;\n', '        areas[30].siblings = [28,31,37,42];\n', '        areas[31].class = Class.District;\n', '        areas[31].parent = 49;\n', '        areas[31].siblings = [26,28,30,37,38];\n', '        areas[32].class = Class.District;\n', '        areas[32].parent = 49;\n', '        areas[32].siblings = [27];\n', '        areas[33].class = Class.District;\n', '        areas[33].parent = 49;\n', '        areas[33].siblings = [27];\n', '        areas[34].class = Class.District;\n', '        areas[34].parent = 49;\n', '        areas[35].class = Class.District;\n', '        areas[35].parent = 49;\n', '        areas[36].class = Class.District;\n', '        areas[36].parent = 49;\n', '\n', '        areas[37].class = Class.District;\n', '        areas[37].parent = 50;\n', '        areas[37].siblings = [5,30,31,38,39,40,42,45];\n', '        areas[38].class = Class.District;\n', '        areas[38].parent = 50;\n', '        areas[38].siblings = [5,7,26,31,37];\n', '        areas[39].class = Class.District;\n', '        areas[39].parent = 50;\n', '        areas[39].siblings = [5,9,37,40,41,43,44];\n', '        areas[40].class = Class.District;\n', '        areas[40].parent = 50;\n', '        areas[40].siblings = [37,39,42,43];\n', '        areas[41].class = Class.District;\n', '        areas[41].parent = 50;\n', '        areas[41].siblings = [5,9,39];\n', '        areas[42].class = Class.District;\n', '        areas[42].parent = 50;\n', '        areas[42].siblings = [30,37,40,43];\n', '        areas[43].class = Class.District;\n', '        areas[43].parent = 50;\n', '        areas[43].siblings = [39,40,42];\n', '        areas[44].class = Class.District;\n', '        areas[44].parent = 50;\n', '        areas[45].class = Class.District;\n', '        areas[45].parent = 50;\n', '\n', '        areas[46].class = Class.Zone;\n', '        areas[46].children = [1,2,3,4,5,6,7,8];\n', '        areas[47].class = Class.Zone;\n', '        areas[47].children = [9,10,11,12,13,14,15,16];\n', '        areas[48].class = Class.Zone;\n', '        areas[48].children = [17,18,19,20,21,22,23,24,25];\n', '        areas[49].class = Class.Zone;\n', '        areas[49].children = [26,27,28,29,30,31,32,33,34,35,36];\n', '        areas[50].class = Class.Zone;\n', '        areas[50].children = [37,38,39,40,41,42,43,44,45];\n', '    }\n', '}\n', '\n', '\n', 'contract Configs {\n', '\n', '    address[] internal GAME_MASTER_ADDRESSES = [\n', '        0x33e03f9F3eFe593D10327245f8107eAaD09730B7,\n', '        0xbcec8fc952776F4F83829837881092596C29A666,\n', '        0x4Eb1E2B89Aba03b7383F07cC80003937b7814B54,\n', '        address(0),\n', '        address(0)\n', '    ];\n', '\n', '    address internal constant ROYALTY_ADDRESS = 0x8C1A581a19A08Ddb1dB271c82da20D88977670A8;\n', '\n', '    uint256 internal constant AREA_COUNT = 51;\n', '    uint256 internal constant TARGET_AREA = 0;\n', '    uint256 internal constant SOURCE_AREA = 1;\n', '    uint256 internal constant ZONE_START = 46;\n', '    uint256 internal constant ZONE_COUNT = 5;\n', '\n', '    uint256[][] internal UNLOCKED_CONFIGS = [\n', '        [uint256(16 * 10**15), 0, 0, 0, 5, 4],\n', '        [uint256(32 * 10**15), 0, 0, 0, 4, 3],\n', '        [uint256(128 * 10**15), 0, 0, 0, 3, 2]\n', '    ];\n', '\n', '    uint256[][] internal OWNED_CONFIGS = [\n', '        [uint256(90), 2, 3, 5, 4],\n', '        [uint256(80), 0, 5, 4, 3],\n', '        [uint256(99), 0, 1, 3, 2]\n', '    ];\n', '\n', '    uint256 internal constant DISTRICT_UNLOCK_TIME = 1 minutes;\n', '    uint256 internal constant ZONE_UNLOCK_TIME = 3 minutes;\n', '    uint256 internal constant TARGET_UNLOCK_TIME = 10 minutes;\n', '\n', '    uint256 internal constant END_TIME_COUNTDOWN = 6 hours;\n', '    uint256 internal constant DISTRICT_END_TIME_EXTENSION = 30 seconds;\n', '    uint256 internal constant ZONE_END_TIME_EXTENSION = 1 minutes;\n', '    uint256 internal constant TARGET_END_TIME_EXTENSION = 3 minutes;\n', '\n', '    uint256 internal constant LAST_OWNER_SHARE = 55;\n', '    uint256 internal constant TARGET_OWNER_SHARE = 30;\n', '    uint256 internal constant SOURCE_OWNER_SHARE = 5;\n', '    uint256 internal constant ZONE_OWNERS_SHARE = 10;\n', '}\n', '\n', '\n', 'contract Main is Configs, Geo, MultiOwnable {\n', '\n', '    using MathLib for uint256;\n', '\n', '    uint256 private endTime;\n', '    uint256 private countdown;\n', '    address private lastOwner;\n', '\n', '    event Settings(uint256 lastOwnerShare, uint256 targetOwnerShare, uint256 sourceOwnerShare, uint256 zoneOwnersShare);\n', '    event Summary(uint256 currentTime, uint256 endTime, uint256 prize, address lastOwner);\n', '    event Reset();\n', '    event Start();\n', '    event Finish();\n', '    event Unlock(address indexed player, uint256 indexed areaId, uint256 unlockTime);\n', '    event Acquisition(address indexed player, uint256 indexed areaId, uint256 price, uint256 newPrice);\n', '    event Post(address indexed player, uint256 indexed areaId, string message);\n', '    event Dub(address indexed player, string nickname);\n', '\n', '    modifier onlyHuman {\n', '        uint256 codeSize;\n', '        address sender = msg.sender;\n', '        assembly { codeSize := extcodesize(sender) }\n', '\n', '        require(sender == tx.origin, "Sorry, human only");\n', '        require(codeSize == 0, "Sorry, human only");\n', '\n', '        _;\n', '    }\n', '\n', '    constructor () public MultiOwnable(GAME_MASTER_ADDRESSES) { }\n', '\n', '    function init() external onlyOwner {\n', '        require(countdown == 0 && endTime == 0, "Game has already been initialized");\n', '\n', '        initAreas();\n', '        reset();\n', '\n', '        emit Settings(LAST_OWNER_SHARE, TARGET_OWNER_SHARE, SOURCE_OWNER_SHARE, ZONE_OWNERS_SHARE);\n', '    }\n', '\n', '    function start() external onlyOwner {\n', '        require(areas[SOURCE_AREA].status == Status.Locked, "Game has already started");\n', '\n', '        areas[SOURCE_AREA].status = Status.Unlocked;\n', '\n', '        emit Start();\n', '    }\n', '\n', '    function finish() external onlyOwner {\n', '        require(endTime > 0 && now >= endTime, "Cannot end yet");\n', '\n', '        uint256 unitValue = address(this).balance.div(100);\n', '        uint256 zoneValue = unitValue.mul(ZONE_OWNERS_SHARE).div(ZONE_COUNT);\n', '\n', '        for (uint256 i = 0; i < ZONE_COUNT; i++) {\n', '            areas[ZONE_START.add(i)].owner.transfer(zoneValue);\n', '        }\n', '        lastOwner.transfer(unitValue.mul(LAST_OWNER_SHARE));\n', '        areas[TARGET_AREA].owner.transfer(unitValue.mul(TARGET_OWNER_SHARE));\n', '        areas[SOURCE_AREA].owner.transfer(unitValue.mul(SOURCE_OWNER_SHARE));\n', '\n', '        emit Finish();\n', '\n', '        for (i = 0; i < AREA_COUNT; i++) {\n', '            delete areas[i].cost;\n', '            delete areas[i].owner;\n', '            delete areas[i].status;\n', '            delete areas[i].unlockTime;\n', '        }\n', '        reset();\n', '    }\n', '\n', '    function acquire(uint256 areaId) external payable onlyHuman {\n', '        //TODO: trigger special events within this function somewhere\n', '\n', '        require(endTime == 0 || now < endTime, "Game has ended");\n', '\n', '        Area storage area = areas[areaId];\n', '        if (area.status == Status.Unlocked) {\n', '            area.cost = getInitialCost(area);            \n', '        }\n', '\n', '        require(area.status != Status.Locked, "Cannot acquire locked area");\n', '        require(area.unlockTime <= now, "Cannot acquire yet");\n', '        require(area.owner != msg.sender, "Cannot acquire already owned area");\n', '        require(area.cost == msg.value, "Incorrect value for acquiring this area");\n', '\n', '        uint256 unitValue = msg.value.div(100);\n', '        uint256 ownerShare;\n', '        uint256 parentShare;\n', '        uint256 devShare;\n', '        uint256 inflationNum;\n', '        uint256 inflationDenom;\n', '        (ownerShare, parentShare, devShare, inflationNum, inflationDenom) = getConfigs(area);\n', '\n', '        if (ownerShare > 0) {\n', '            area.owner.transfer(unitValue.mul(ownerShare));\n', '        }\n', '        if (parentShare > 0 && areas[area.parent].status == Status.Owned) {\n', '            areas[area.parent].owner.transfer(unitValue.mul(parentShare));\n', '        }\n', '        if (devShare > 0) {\n', '            ROYALTY_ADDRESS.transfer(unitValue.mul(devShare));\n', '        }\n', '\n', '        area.cost = area.cost.mul(inflationNum).div(inflationDenom);\n', '        area.owner = msg.sender;\n', '        if (area.class != Class.Target) {\n', '            lastOwner = msg.sender;\n', '        }\n', '\n', '        emit Acquisition(msg.sender, areaId, msg.value, area.cost);        \n', '\n', '        if (area.status == Status.Unlocked) {\n', '            area.status = Status.Owned;\n', '            countdown = countdown.sub(1);\n', '\n', '            if (area.class == Class.District) {\n', '                tryUnlockSiblings(area);\n', '                tryUnlockParent(area);\n', '            } else if (area.class == Class.Zone) {\n', '                tryUnlockTarget();\n', '            } else if (area.class == Class.Target) {\n', '                endTime = now.add(END_TIME_COUNTDOWN);\n', '            }\n', '        } else if (area.status == Status.Owned) {\n', '            if (endTime > 0) {\n', '                if (area.class == Class.District) {\n', '                    endTime = endTime.add(DISTRICT_END_TIME_EXTENSION);\n', '                } else if (area.class == Class.Zone) {\n', '                    endTime = endTime.add(ZONE_END_TIME_EXTENSION);\n', '                } else if (area.class == Class.Target) {\n', '                    endTime = endTime.add(TARGET_END_TIME_EXTENSION);\n', '                }\n', '            }\n', '\n', '            if (endTime > now.add(END_TIME_COUNTDOWN)) {\n', '                endTime = now.add(END_TIME_COUNTDOWN);\n', '            }\n', '        }\n', '\n', '        emit Summary(now, endTime, address(this).balance, lastOwner);\n', '    }\n', '\n', '    function post(uint256 areaId, string message) external onlyHuman {\n', '        require(areas[areaId].owner == msg.sender, "Cannot post message on other\'s area");\n', '\n', '        emit Post(msg.sender, areaId, message);\n', '    }\n', '\n', '    function dub(string nickname) external onlyHuman {\n', '        emit Dub(msg.sender, nickname);\n', '    }\n', '\n', '\n', '\n', '    function reset() private {\n', '        delete endTime;\n', '        countdown = AREA_COUNT;\n', '        delete lastOwner;\n', '        \n', '        emit Reset();\n', '    }\n', '\n', '    function tryUnlockSiblings(Area storage area) private {\n', '        for (uint256 i = 0; i < area.siblings.length; i++) {\n', '            Area storage sibling = areas[area.siblings[i]];\n', '\n', '            if (sibling.status == Status.Locked) {\n', '                sibling.status = Status.Unlocked;\n', '                sibling.unlockTime = now.add(DISTRICT_UNLOCK_TIME);\n', '\n', '                emit Unlock(msg.sender, area.siblings[i], sibling.unlockTime);\n', '            }\n', '        }\n', '    }\n', '\n', '    function tryUnlockParent(Area storage area) private {\n', '        Area storage parent = areas[area.parent];\n', '\n', '        for (uint256 i = 0; i < parent.children.length; i++) {\n', '            Area storage child = areas[parent.children[i]];\n', '\n', '            if (child.status != Status.Owned) {\n', '                return;\n', '            }\n', '        }\n', '\n', '        parent.status = Status.Unlocked;\n', '        parent.unlockTime = now.add(ZONE_UNLOCK_TIME);\n', '\n', '        emit Unlock(msg.sender, area.parent, parent.unlockTime);\n', '    }\n', '\n', '    function tryUnlockTarget() private {\n', '        if (countdown == 1) {\n', '            areas[TARGET_AREA].status = Status.Unlocked;\n', '            areas[TARGET_AREA].unlockTime = now.add(TARGET_UNLOCK_TIME);\n', '\n', '            emit Unlock(msg.sender, TARGET_AREA, areas[TARGET_AREA].unlockTime);\n', '        }\n', '    }\n', '\n', '\n', '\n', '    function getInitialCost(Area storage area) private view returns (uint256) {\n', '        return UNLOCKED_CONFIGS[uint256(area.class)][0];\n', '    }\n', '\n', '    function getConfigs(Area storage area) private view returns (uint256, uint256, uint256, uint256, uint256) {\n', '        uint256 index = uint256(area.class);\n', '        \n', '        if (area.status == Status.Unlocked) {\n', '            return (UNLOCKED_CONFIGS[index][1], UNLOCKED_CONFIGS[index][2], UNLOCKED_CONFIGS[index][3], UNLOCKED_CONFIGS[index][4], UNLOCKED_CONFIGS[index][5]);\n', '        } else if (area.status == Status.Owned) {\n', '            return (OWNED_CONFIGS[index][0], OWNED_CONFIGS[index][1], OWNED_CONFIGS[index][2], OWNED_CONFIGS[index][3], OWNED_CONFIGS[index][4]);\n', '        }\n', '    }\n', '}']