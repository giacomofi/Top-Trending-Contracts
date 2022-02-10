['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * \n', ' * World War Goo - Competitive Idle Game\n', ' * \n', ' * https://ethergoo.io\n', ' * \n', ' */\n', '\n', 'contract Factories {\n', '\n', '    GooToken constant goo = GooToken(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);\n', '    Units units = Units(0x0);\n', '    Inventory inventory = Inventory(0x0);\n', '\n', '    mapping(address => uint256[]) private playerFactories;\n', '    mapping(uint256 => mapping(uint256 => uint32[8])) public tileBonuses; // Tile -> UnitId -> Bonus\n', '    mapping(address => bool) operator;\n', '\n', '    address owner; // Minor management\n', '    uint256 public constant MAX_SIZE = 40;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function setUnits(address unitsContract) external {\n', '        require(msg.sender == owner); // TODO hardcode for launch?\n', '        units = Units(unitsContract);\n', '    }\n', '\n', '    function setInventory(address inventoryContract) external {\n', '        require(msg.sender == owner); // TODO hardcode for launch?\n', '        inventory = Inventory(inventoryContract);\n', '    }\n', '\n', '    function setOperator(address gameContract, bool isOperator) external {\n', '        require(msg.sender == owner);\n', '        operator[gameContract] = isOperator;\n', '    }\n', '\n', '    function getFactories(address player) external view returns (uint256[]) {\n', '        return playerFactories[player];\n', '    }\n', '\n', '    // For website\n', '    function getPlayersUnits(address player) external view returns (uint256[], uint80[], uint224[], uint32[], uint256[]) {\n', '        uint80[] memory unitsOwnedByFactory = new uint80[](playerFactories[player].length);\n', '        uint224[] memory unitsExperience = new uint224[](playerFactories[player].length);\n', '        uint32[] memory unitsLevel = new uint32[](playerFactories[player].length);\n', '        uint256[] memory unitsEquipment = new uint256[](playerFactories[player].length);\n', '\n', '        for (uint256 i = 0; i < playerFactories[player].length; i++) {\n', '            (unitsOwnedByFactory[i],) = units.unitsOwned(player, playerFactories[player][i]);\n', '            (unitsExperience[i], unitsLevel[i]) = units.unitExp(player, playerFactories[player][i]);\n', '            unitsEquipment[i] = inventory.getEquippedItemId(player, playerFactories[player][i]);\n', '        }\n', '\n', '        return (playerFactories[player], unitsOwnedByFactory, unitsExperience, unitsLevel, unitsEquipment);\n', '    }\n', '\n', '    function addFactory(address player, uint8 position, uint256 unitId) external {\n', '        require(position < MAX_SIZE);\n', '        require(msg.sender == address(units));\n', '\n', '        uint256[] storage factories = playerFactories[player];\n', '        if (factories.length > position) {\n', '            require(factories[position] == 0); // Empty space\n', '        } else {\n', '            factories.length = position + 1; // Make space\n', '        }\n', '        factories[position] = unitId;\n', '\n', '        // Grant buff to unit\n', '        uint32[8] memory upgradeGains = tileBonuses[getAddressDigit(player, position)][unitId];\n', '        if (upgradeGains[0] > 0 || upgradeGains[1] > 0 || upgradeGains[2] > 0 || upgradeGains[3] > 0 || upgradeGains[4] > 0 || upgradeGains[5] > 0 || upgradeGains[6] > 0 || upgradeGains[7] > 0) {\n', '            units.increaseUpgradesExternal(player, unitId, upgradeGains[0], upgradeGains[1], upgradeGains[2], upgradeGains[3], upgradeGains[4], upgradeGains[5], upgradeGains[6], upgradeGains[7]);\n', '        }\n', '    }\n', '\n', '    function moveFactory(uint8 position, uint8 newPosition) external {\n', '        require(newPosition < MAX_SIZE);\n', '\n', '        uint256[] storage factories = playerFactories[msg.sender];\n', '        uint256 existingFactory = factories[position];\n', '        require(existingFactory > 0); // Existing factory\n', '\n', '        if (factories.length > newPosition) {\n', '            require(factories[newPosition] == 0); // Empty space\n', '        } else {\n', '            factories.length = newPosition + 1; // Make space\n', '        }\n', '\n', '        factories[newPosition] = existingFactory;\n', '        delete factories[position];\n', '\n', '        uint32[8] memory newBonus = tileBonuses[getAddressDigit(msg.sender, newPosition)][existingFactory];\n', '        uint32[8] memory oldBonus = tileBonuses[getAddressDigit(msg.sender, position)][existingFactory];\n', '        units.swapUpgradesExternal(msg.sender, existingFactory, newBonus, oldBonus);\n', '    }\n', '\n', '    function getAddressDigit(address player, uint8 position) public pure returns (uint) {\n', '        return (uint(player) >> (156 - position * 4)) & 0x0f;\n', '    }\n', '\n', '    function addTileBonus(uint256 tile, uint256 unit, uint32[8] upgradeGains) external {\n', '        require(operator[msg.sender]);\n', '        tileBonuses[tile][unit] = upgradeGains;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract GooToken {\n', '    function updatePlayersGoo(address player) external;\n', '    function increasePlayersGooProduction(address player, uint256 increase) external;\n', '}\n', '\n', 'contract Units {\n', '    mapping(address => mapping(uint256 => UnitsOwned)) public unitsOwned;\n', '    mapping(address => mapping(uint256 => UnitExperience)) public unitExp;\n', '    function increaseUpgradesExternal(address player, uint256 unitId, uint32 prodIncrease, uint32 prodMultiplier, uint32 attackIncrease, uint32 attackMultiplier, uint32 defenseIncrease, uint32 defenseMultiplier, uint32 lootingIncrease, uint32 lootingMultiplier) external;\n', '    function swapUpgradesExternal(address player, uint256 unitId, uint32[8] upgradeGains, uint32[8] upgradeLosses) external;\n', '    \n', '    struct UnitsOwned {\n', '        uint80 units;\n', '        uint8 factoryBuiltFlag; // Incase user sells units, we still want to keep factory\n', '    }\n', '    \n', '    struct UnitExperience {\n', '        uint224 experience;\n', '        uint32 level;\n', '    }\n', '}\n', '\n', 'contract Inventory {\n', '    function getEquippedItemId(address player, uint256 unitId) external view returns (uint256);\n', '}']