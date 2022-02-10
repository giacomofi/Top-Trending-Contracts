['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', 'contract Base\n', '{\n', '    uint8 constant HEROLEVEL_MIN = 1;\n', '    uint8 constant HEROLEVEL_MAX = 5;\n', '\n', '    uint8 constant LIMITCHIP_MINLEVEL = 3;\n', '    uint constant PARTWEIGHT_NORMAL = 100;\n', '    uint constant PARTWEIGHT_LIMIT = 40;\n', '\n', '    address creator;\n', '\n', '    constructor() public\n', '    {\n', '        creator = msg.sender;\n', '    }\n', '\n', '    modifier CreatorAble()\n', '    {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    function IsLimitPart(uint8 level, uint part) internal pure returns(bool)\n', '    {\n', '        if (level < LIMITCHIP_MINLEVEL) return false;\n', '        if (part < GetPartNum(level)) return false;\n', '        return true;\n', '    }\n', '\n', '    function GetPartWeight(uint8 level, uint part) internal pure returns(uint)\n', '    {\n', '        if (IsLimitPart(level, part)) return PARTWEIGHT_LIMIT;\n', '        return PARTWEIGHT_NORMAL;\n', '    }\n', '    \n', '    function GetPartNum(uint8 level) internal pure returns(uint)\n', '    {\n', '        if (level <= 2) return 3;\n', '        else if (level <= 4) return 4;\n', '        return 5;\n', '    }\n', '\n', '    function GetPartLimit(uint8 level, uint part) internal pure returns(uint8)\n', '    {\n', '        if (!IsLimitPart(level, part)) return 0;\n', '        if (level == 5) return 1;\n', '        if (level == 4) return 8;\n', '        return 15;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract BasicAuth is Base\n', '{\n', '\n', '    mapping(address => bool) auth_list;\n', '\n', '    modifier OwnerAble(address acc)\n', '    {\n', '        require(acc == tx.origin);\n', '        _;\n', '    }\n', '\n', '    modifier AuthAble()\n', '    {\n', '        require(auth_list[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier ValidHandleAuth()\n', '    {\n', '        require(tx.origin==creator || msg.sender==creator);\n', '        _;\n', '    }\n', '   \n', '    function SetAuth(address target) external ValidHandleAuth\n', '    {\n', '        auth_list[target] = true;\n', '    }\n', '\n', '    function ClearAuth(address target) external ValidHandleAuth\n', '    {\n', '        delete auth_list[target];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract OldProductionBoiler\n', '{\n', '    function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[]);\n', '}\n', '\n', 'contract ProductionBoiler is BasicAuth\n', '{\n', '\n', '    struct Boiler\n', '    {\n', '        uint m_Expire;\n', '        uint32[] m_Chips;\n', '    }\n', '\n', '    mapping(address => mapping(uint => Boiler)) g_Boilers;\n', '\n', '    bool g_Synced = false;\n', '    function SyncOldData(OldProductionBoiler oldBoiler, address[] accounts) external CreatorAble\n', '    {\n', '        require(!g_Synced);\n', '        g_Synced = true;\n', '        for (uint i=0; i<accounts.length; i++)\n', '        {\n', '            address acc = accounts[i];\n', '            for (uint idx=0; idx<3; idx++)\n', '            {\n', '                (uint expire, uint32[] memory chips) = oldBoiler.GetBoilerInfo(acc,idx);\n', '                if (expire == 0) continue;\n', '                g_Boilers[acc][idx].m_Expire = expire;\n', '                g_Boilers[acc][idx].m_Chips = chips;\n', '            }\n', '        }\n', '    }\n', '\n', '    //=========================================================================\n', '    function IsBoilerValid(address acc, uint idx) external view returns(bool)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        if (obj.m_Chips.length > 0) return false;\n', '        return true;\n', '    }\n', '\n', '    function IsBoilerExpire(address acc, uint idx) external view returns(bool)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        return obj.m_Expire <= now;\n', '    }\n', '\n', '    //=========================================================================\n', '\n', '    function GenerateChips(address acc, uint idx, uint cd, uint32[] chips) external AuthAble OwnerAble(acc)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        obj.m_Expire = cd+now;\n', '        obj.m_Chips = chips;\n', '    }\n', '\n', '    function CollectChips(address acc, uint idx) external AuthAble OwnerAble(acc) returns(uint32[] chips)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        chips = obj.m_Chips;\n', '        delete g_Boilers[acc][idx];\n', '    }\n', '\n', '    function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[])\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        return (obj.m_Expire,obj.m_Chips);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', 'contract Base\n', '{\n', '    uint8 constant HEROLEVEL_MIN = 1;\n', '    uint8 constant HEROLEVEL_MAX = 5;\n', '\n', '    uint8 constant LIMITCHIP_MINLEVEL = 3;\n', '    uint constant PARTWEIGHT_NORMAL = 100;\n', '    uint constant PARTWEIGHT_LIMIT = 40;\n', '\n', '    address creator;\n', '\n', '    constructor() public\n', '    {\n', '        creator = msg.sender;\n', '    }\n', '\n', '    modifier CreatorAble()\n', '    {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    function IsLimitPart(uint8 level, uint part) internal pure returns(bool)\n', '    {\n', '        if (level < LIMITCHIP_MINLEVEL) return false;\n', '        if (part < GetPartNum(level)) return false;\n', '        return true;\n', '    }\n', '\n', '    function GetPartWeight(uint8 level, uint part) internal pure returns(uint)\n', '    {\n', '        if (IsLimitPart(level, part)) return PARTWEIGHT_LIMIT;\n', '        return PARTWEIGHT_NORMAL;\n', '    }\n', '    \n', '    function GetPartNum(uint8 level) internal pure returns(uint)\n', '    {\n', '        if (level <= 2) return 3;\n', '        else if (level <= 4) return 4;\n', '        return 5;\n', '    }\n', '\n', '    function GetPartLimit(uint8 level, uint part) internal pure returns(uint8)\n', '    {\n', '        if (!IsLimitPart(level, part)) return 0;\n', '        if (level == 5) return 1;\n', '        if (level == 4) return 8;\n', '        return 15;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract BasicAuth is Base\n', '{\n', '\n', '    mapping(address => bool) auth_list;\n', '\n', '    modifier OwnerAble(address acc)\n', '    {\n', '        require(acc == tx.origin);\n', '        _;\n', '    }\n', '\n', '    modifier AuthAble()\n', '    {\n', '        require(auth_list[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier ValidHandleAuth()\n', '    {\n', '        require(tx.origin==creator || msg.sender==creator);\n', '        _;\n', '    }\n', '   \n', '    function SetAuth(address target) external ValidHandleAuth\n', '    {\n', '        auth_list[target] = true;\n', '    }\n', '\n', '    function ClearAuth(address target) external ValidHandleAuth\n', '    {\n', '        delete auth_list[target];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract OldProductionBoiler\n', '{\n', '    function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[]);\n', '}\n', '\n', 'contract ProductionBoiler is BasicAuth\n', '{\n', '\n', '    struct Boiler\n', '    {\n', '        uint m_Expire;\n', '        uint32[] m_Chips;\n', '    }\n', '\n', '    mapping(address => mapping(uint => Boiler)) g_Boilers;\n', '\n', '    bool g_Synced = false;\n', '    function SyncOldData(OldProductionBoiler oldBoiler, address[] accounts) external CreatorAble\n', '    {\n', '        require(!g_Synced);\n', '        g_Synced = true;\n', '        for (uint i=0; i<accounts.length; i++)\n', '        {\n', '            address acc = accounts[i];\n', '            for (uint idx=0; idx<3; idx++)\n', '            {\n', '                (uint expire, uint32[] memory chips) = oldBoiler.GetBoilerInfo(acc,idx);\n', '                if (expire == 0) continue;\n', '                g_Boilers[acc][idx].m_Expire = expire;\n', '                g_Boilers[acc][idx].m_Chips = chips;\n', '            }\n', '        }\n', '    }\n', '\n', '    //=========================================================================\n', '    function IsBoilerValid(address acc, uint idx) external view returns(bool)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        if (obj.m_Chips.length > 0) return false;\n', '        return true;\n', '    }\n', '\n', '    function IsBoilerExpire(address acc, uint idx) external view returns(bool)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        return obj.m_Expire <= now;\n', '    }\n', '\n', '    //=========================================================================\n', '\n', '    function GenerateChips(address acc, uint idx, uint cd, uint32[] chips) external AuthAble OwnerAble(acc)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        obj.m_Expire = cd+now;\n', '        obj.m_Chips = chips;\n', '    }\n', '\n', '    function CollectChips(address acc, uint idx) external AuthAble OwnerAble(acc) returns(uint32[] chips)\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        chips = obj.m_Chips;\n', '        delete g_Boilers[acc][idx];\n', '    }\n', '\n', '    function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[])\n', '    {\n', '        Boiler storage obj = g_Boilers[acc][idx];\n', '        return (obj.m_Expire,obj.m_Chips);\n', '    }\n', '\n', '}']
