['pragma solidity ^0.4.18;\n', '/* ==================================================================== */\n', '/* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.\n', '/* \n', '/* https://www.magicacademy.io One of the world&#39;s first idle strategy games of blockchain \n', '/*  \n', '/* authors rainy@livestar.com/fanny.zheng@livestar.com\n', '/*                 \n', '/* ==================================================================== */\n', 'interface CardsInterface {\n', '  function getJadeProduction(address player) external constant returns (uint256);\n', '  function getOwnedCount(address player, uint256 cardId) external view returns (uint256);\n', '  function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256);\n', '  function getUintCoinProduction(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitAttackIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitAttackMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitDefenseIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitDefenseMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitJadeStealingIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitJadeStealingMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitsProduction(address player, uint256 cardId, uint256 amount) external constant returns (uint256);\n', '  function getTotalEtherPool(uint8 itype) external view returns (uint256);\n', '  function coinBalanceOf(address player,uint8 itype) external constant returns(uint256);\n', '  function balanceOf(address player) public constant returns(uint256);\n', '   function getPlayersBattleStats(address player) public constant returns (\n', '    uint256 attackingPower, \n', '    uint256 defendingPower, \n', '    uint256 stealingPower,\n', '    uint256 battlePower);\n', '  function getTotalJadeProduction() external view returns (uint256);\n', '  function getNextSnapshotTime() external view returns(uint256);\n', '}\n', '\n', 'interface GameConfigInterface {\n', '  function productionCardIdRange() external constant returns (uint256, uint256);\n', '  function battleCardIdRange() external constant returns (uint256, uint256);\n', '  function upgradeIdRange() external constant returns (uint256, uint256); \n', '  function unitCoinProduction(uint256 cardId) external constant returns (uint256);\n', '  function unitAttack(uint256 cardId) external constant returns (uint256);\n', '  function unitDefense(uint256 cardId) external constant returns (uint256); \n', '  function unitStealingCapacity(uint256 cardId) external constant returns (uint256);\n', '}\n', '\n', 'contract CardsRead {\n', '  using SafeMath for SafeMath;\n', '\n', '  CardsInterface public cards;\n', '  GameConfigInterface public schema;\n', '  address owner;\n', '  \n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function CardsRead() public {\n', '    owner = msg.sender;\n', '  }\n', '    //setting configuration\n', '  function setConfigAddress(address _address) external onlyOwner {\n', '    schema = GameConfigInterface(_address);\n', '  }\n', '\n', '     //setting configuration\n', '  function setCardsAddress(address _address) external onlyOwner {\n', '    cards = CardsInterface(_address);\n', '  }\n', '\n', '  // get normal cardlist;\n', '  function getNormalCardList(address _owner) external view returns(uint256[],uint256[]){\n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId,endId) = schema.productionCardIdRange(); \n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory itemId = new uint256[](len);\n', '    uint256[] memory itemNumber = new uint256[](len);\n', '\n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      itemId[i] = startId;\n', '      itemNumber[i] = cards.getOwnedCount(_owner,startId);\n', '      i++;\n', '      startId++;\n', '      }   \n', '    return (itemId, itemNumber);\n', '  }\n', '\n', '  // get normal cardlist;\n', '  function getBattleCardList(address _owner) external view returns(uint256[],uint256[]){\n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId,endId) = schema.battleCardIdRange();\n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory itemId = new uint256[](len);\n', '    uint256[] memory itemNumber = new uint256[](len);\n', '\n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      itemId[i] = startId;\n', '      itemNumber[i] = cards.getOwnedCount(_owner,startId);\n', '      i++;\n', '      startId++;\n', '      }   \n', '    return (itemId, itemNumber);\n', '  }\n', '\n', '  // get upgrade cardlist;\n', '  function getUpgradeCardList(address _owner) external view returns(uint256[],uint256[]){\n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId, endId) = schema.upgradeIdRange();\n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory itemId = new uint256[](len);\n', '    uint256[] memory itemNumber = new uint256[](len);\n', '\n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      itemId[i] = startId;\n', '      itemNumber[i] = cards.getUpgradesOwned(_owner,startId);\n', '      i++;\n', '      startId++;\n', '      }   \n', '    return (itemId, itemNumber);\n', '  }\n', '\n', '    //get up value\n', '  function getUpgradeValue(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external view returns (\n', '    uint256 productionGain ,uint256 preValue,uint256 afterValue) {\n', '    if (cards.getOwnedCount(player,unitId) == 0) {\n', '      if (upgradeClass == 0) {\n', '        productionGain = upgradeValue * 10;\n', '        preValue = schema.unitCoinProduction(unitId);\n', '        afterValue   = preValue + productionGain;\n', '      } else if (upgradeClass == 1){\n', '        productionGain = upgradeValue * schema.unitCoinProduction(unitId);\n', '        preValue = schema.unitCoinProduction(unitId);\n', '        afterValue   = preValue + productionGain;\n', '      } \n', '    }else { // >= 1\n', '      if (upgradeClass == 0) {\n', '        productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (10 + cards.getUnitCoinProductionMultiplier(player,unitId)));\n', '        preValue = cards.getUintCoinProduction(player,unitId);\n', '        afterValue   = preValue + productionGain;\n', '     } else if (upgradeClass == 1) {\n', '        productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId)));\n', '        preValue = cards.getUintCoinProduction(player,unitId);\n', '        afterValue   = preValue + productionGain;\n', '     }\n', '    }\n', '  }\n', '\n', ' // To display on website\n', '  function getGameInfo() external view returns (uint256,  uint256, uint256, uint256, uint256, uint256, uint256[], uint256[], uint256[]){  \n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId,endId) = schema.productionCardIdRange();\n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1); \n', '    uint256[] memory units = new uint256[](len);\n', '        \n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      units[i] = cards.getOwnedCount(msg.sender,startId);\n', '      i++;\n', '      startId++;\n', '    }\n', '      \n', '    (startId,endId) = schema.battleCardIdRange();\n', '    len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory battles = new uint256[](len);\n', '    \n', '    i=0; //reset for battle cards\n', '    while (startId <= endId) {\n', '      battles[i] = cards.getOwnedCount(msg.sender,startId);\n', '      i++;\n', '      startId++;\n', '    }\n', '        \n', '    // Reset for upgrades\n', '    i = 0;\n', '    (startId, endId) = schema.upgradeIdRange();\n', '    len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory upgrades = new uint256[](len);\n', '\n', '    while (startId <= endId) {\n', '      upgrades[i] = cards.getUpgradesOwned(msg.sender,startId);\n', '      i++;\n', '      startId++;\n', '    }\n', '    return (\n', '    cards.getTotalEtherPool(1), \n', '    cards.getJadeProduction(msg.sender),\n', '    cards.balanceOf(msg.sender), \n', '    cards.coinBalanceOf(msg.sender,1),\n', '    cards.getTotalJadeProduction(),\n', '    cards.getNextSnapshotTime(), \n', '    units, battles,upgrades\n', '    );\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '/* ==================================================================== */\n', '/* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.\n', '/* \n', "/* https://www.magicacademy.io One of the world's first idle strategy games of blockchain \n", '/*  \n', '/* authors rainy@livestar.com/fanny.zheng@livestar.com\n', '/*                 \n', '/* ==================================================================== */\n', 'interface CardsInterface {\n', '  function getJadeProduction(address player) external constant returns (uint256);\n', '  function getOwnedCount(address player, uint256 cardId) external view returns (uint256);\n', '  function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256);\n', '  function getUintCoinProduction(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitAttackIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitAttackMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitDefenseIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitDefenseMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitJadeStealingIncreases(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitJadeStealingMultiplier(address _address, uint256 cardId) external view returns (uint256);\n', '  function getUnitsProduction(address player, uint256 cardId, uint256 amount) external constant returns (uint256);\n', '  function getTotalEtherPool(uint8 itype) external view returns (uint256);\n', '  function coinBalanceOf(address player,uint8 itype) external constant returns(uint256);\n', '  function balanceOf(address player) public constant returns(uint256);\n', '   function getPlayersBattleStats(address player) public constant returns (\n', '    uint256 attackingPower, \n', '    uint256 defendingPower, \n', '    uint256 stealingPower,\n', '    uint256 battlePower);\n', '  function getTotalJadeProduction() external view returns (uint256);\n', '  function getNextSnapshotTime() external view returns(uint256);\n', '}\n', '\n', 'interface GameConfigInterface {\n', '  function productionCardIdRange() external constant returns (uint256, uint256);\n', '  function battleCardIdRange() external constant returns (uint256, uint256);\n', '  function upgradeIdRange() external constant returns (uint256, uint256); \n', '  function unitCoinProduction(uint256 cardId) external constant returns (uint256);\n', '  function unitAttack(uint256 cardId) external constant returns (uint256);\n', '  function unitDefense(uint256 cardId) external constant returns (uint256); \n', '  function unitStealingCapacity(uint256 cardId) external constant returns (uint256);\n', '}\n', '\n', 'contract CardsRead {\n', '  using SafeMath for SafeMath;\n', '\n', '  CardsInterface public cards;\n', '  GameConfigInterface public schema;\n', '  address owner;\n', '  \n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function CardsRead() public {\n', '    owner = msg.sender;\n', '  }\n', '    //setting configuration\n', '  function setConfigAddress(address _address) external onlyOwner {\n', '    schema = GameConfigInterface(_address);\n', '  }\n', '\n', '     //setting configuration\n', '  function setCardsAddress(address _address) external onlyOwner {\n', '    cards = CardsInterface(_address);\n', '  }\n', '\n', '  // get normal cardlist;\n', '  function getNormalCardList(address _owner) external view returns(uint256[],uint256[]){\n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId,endId) = schema.productionCardIdRange(); \n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory itemId = new uint256[](len);\n', '    uint256[] memory itemNumber = new uint256[](len);\n', '\n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      itemId[i] = startId;\n', '      itemNumber[i] = cards.getOwnedCount(_owner,startId);\n', '      i++;\n', '      startId++;\n', '      }   \n', '    return (itemId, itemNumber);\n', '  }\n', '\n', '  // get normal cardlist;\n', '  function getBattleCardList(address _owner) external view returns(uint256[],uint256[]){\n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId,endId) = schema.battleCardIdRange();\n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory itemId = new uint256[](len);\n', '    uint256[] memory itemNumber = new uint256[](len);\n', '\n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      itemId[i] = startId;\n', '      itemNumber[i] = cards.getOwnedCount(_owner,startId);\n', '      i++;\n', '      startId++;\n', '      }   \n', '    return (itemId, itemNumber);\n', '  }\n', '\n', '  // get upgrade cardlist;\n', '  function getUpgradeCardList(address _owner) external view returns(uint256[],uint256[]){\n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId, endId) = schema.upgradeIdRange();\n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory itemId = new uint256[](len);\n', '    uint256[] memory itemNumber = new uint256[](len);\n', '\n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      itemId[i] = startId;\n', '      itemNumber[i] = cards.getUpgradesOwned(_owner,startId);\n', '      i++;\n', '      startId++;\n', '      }   \n', '    return (itemId, itemNumber);\n', '  }\n', '\n', '    //get up value\n', '  function getUpgradeValue(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external view returns (\n', '    uint256 productionGain ,uint256 preValue,uint256 afterValue) {\n', '    if (cards.getOwnedCount(player,unitId) == 0) {\n', '      if (upgradeClass == 0) {\n', '        productionGain = upgradeValue * 10;\n', '        preValue = schema.unitCoinProduction(unitId);\n', '        afterValue   = preValue + productionGain;\n', '      } else if (upgradeClass == 1){\n', '        productionGain = upgradeValue * schema.unitCoinProduction(unitId);\n', '        preValue = schema.unitCoinProduction(unitId);\n', '        afterValue   = preValue + productionGain;\n', '      } \n', '    }else { // >= 1\n', '      if (upgradeClass == 0) {\n', '        productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (10 + cards.getUnitCoinProductionMultiplier(player,unitId)));\n', '        preValue = cards.getUintCoinProduction(player,unitId);\n', '        afterValue   = preValue + productionGain;\n', '     } else if (upgradeClass == 1) {\n', '        productionGain = (cards.getOwnedCount(player,unitId) * upgradeValue * (schema.unitCoinProduction(unitId) + cards.getUnitCoinProductionIncreases(player,unitId)));\n', '        preValue = cards.getUintCoinProduction(player,unitId);\n', '        afterValue   = preValue + productionGain;\n', '     }\n', '    }\n', '  }\n', '\n', ' // To display on website\n', '  function getGameInfo() external view returns (uint256,  uint256, uint256, uint256, uint256, uint256, uint256[], uint256[], uint256[]){  \n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId,endId) = schema.productionCardIdRange();\n', '    uint256 len = SafeMath.add(SafeMath.sub(endId,startId),1); \n', '    uint256[] memory units = new uint256[](len);\n', '        \n', '    uint256 i;\n', '    while (startId <= endId) {\n', '      units[i] = cards.getOwnedCount(msg.sender,startId);\n', '      i++;\n', '      startId++;\n', '    }\n', '      \n', '    (startId,endId) = schema.battleCardIdRange();\n', '    len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory battles = new uint256[](len);\n', '    \n', '    i=0; //reset for battle cards\n', '    while (startId <= endId) {\n', '      battles[i] = cards.getOwnedCount(msg.sender,startId);\n', '      i++;\n', '      startId++;\n', '    }\n', '        \n', '    // Reset for upgrades\n', '    i = 0;\n', '    (startId, endId) = schema.upgradeIdRange();\n', '    len = SafeMath.add(SafeMath.sub(endId,startId),1);\n', '    uint256[] memory upgrades = new uint256[](len);\n', '\n', '    while (startId <= endId) {\n', '      upgrades[i] = cards.getUpgradesOwned(msg.sender,startId);\n', '      i++;\n', '      startId++;\n', '    }\n', '    return (\n', '    cards.getTotalEtherPool(1), \n', '    cards.getJadeProduction(msg.sender),\n', '    cards.balanceOf(msg.sender), \n', '    cards.coinBalanceOf(msg.sender,1),\n', '    cards.getTotalJadeProduction(),\n', '    cards.getNextSnapshotTime(), \n', '    units, battles,upgrades\n', '    );\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']