['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', 'contract Base\n', '{\n', '    uint8 constant HEROLEVEL_MIN = 1;\n', '    uint8 constant HEROLEVEL_MAX = 5;\n', '\n', '    uint8 constant LIMITCHIP_MINLEVEL = 3;\n', '    uint constant PARTWEIGHT_NORMAL = 100;\n', '    uint constant PARTWEIGHT_LIMIT = 40;\n', '\n', '    address creator;\n', '\n', '    constructor() public\n', '    {\n', '        creator = msg.sender;\n', '    }\n', '\n', '    modifier CreatorAble()\n', '    {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    function IsLimitPart(uint8 level, uint part) internal pure returns(bool)\n', '    {\n', '        if (level < LIMITCHIP_MINLEVEL) return false;\n', '        if (part < GetPartNum(level)) return false;\n', '        return true;\n', '    }\n', '\n', '    function GetPartWeight(uint8 level, uint part) internal pure returns(uint)\n', '    {\n', '        if (IsLimitPart(level, part)) return PARTWEIGHT_LIMIT;\n', '        return PARTWEIGHT_NORMAL;\n', '    }\n', '    \n', '    function GetPartNum(uint8 level) internal pure returns(uint)\n', '    {\n', '        if (level <= 2) return 3;\n', '        else if (level <= 4) return 4;\n', '        return 5;\n', '    }\n', '\n', '    function GetPartLimit(uint8 level, uint part) internal pure returns(uint8)\n', '    {\n', '        if (!IsLimitPart(level, part)) return 0;\n', '        if (level == 5) return 1;\n', '        if (level == 4) return 8;\n', '        return 15;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract BasicAuth is Base\n', '{\n', '\n', '    mapping(address => bool) auth_list;\n', '\n', '    modifier OwnerAble(address acc)\n', '    {\n', '        require(acc == tx.origin);\n', '        _;\n', '    }\n', '\n', '    modifier AuthAble()\n', '    {\n', '        require(auth_list[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier ValidHandleAuth()\n', '    {\n', '        require(tx.origin==creator || msg.sender==creator);\n', '        _;\n', '    }\n', '   \n', '    function SetAuth(address target) external ValidHandleAuth\n', '    {\n', '        auth_list[target] = true;\n', '    }\n', '\n', '    function ClearAuth(address target) external ValidHandleAuth\n', '    {\n', '        delete auth_list[target];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract StoreChipBag is BasicAuth\n', '{\n', '\n', '    mapping(address => uint32[]) g_ChipBag;\n', '\n', '    function AddChip(address acc, uint32 iChip) external OwnerAble(acc) AuthAble\n', '    {\n', '        g_ChipBag[acc].push(iChip);\n', '    }\n', '\n', '    function CollectChips(address acc) external OwnerAble(acc) AuthAble returns(uint32[] chips)\n', '    {\n', '        chips = g_ChipBag[acc];\n', '        delete g_ChipBag[acc];\n', '    }\n', '\n', '    function GetChipsInfo(address acc) external view returns(uint32[] chips)\n', '    {\n', '        chips = g_ChipBag[acc];\n', '    }\n', '\n', '}']