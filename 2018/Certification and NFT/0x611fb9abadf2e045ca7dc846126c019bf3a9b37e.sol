['pragma solidity ^0.4.18;\n', '/* ==================================================================== */\n', '/* Copyright (c) 2018 The MagicAcademy Project.  All rights reserved.\n', '/* \n', '/* https://www.magicacademy.io One of the world&#39;s first idle strategy games of blockchain \n', '/*  \n', '/* authors rainy@livestar.com/fanny.zheng@livestar.com\n', '/*                 \n', '/* ==================================================================== */\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /*\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract AccessAdmin is Ownable {\n', '\n', '  /// @dev Admin Address\n', '  mapping (address => bool) adminContracts;\n', '\n', '  /// @dev Trust contract\n', '  mapping (address => bool) actionContracts;\n', '\n', '  function setAdminContract(address _addr, bool _useful) public onlyOwner {\n', '    require(_addr != address(0));\n', '    adminContracts[_addr] = _useful;\n', '  }\n', '\n', '  modifier onlyAdmin {\n', '    require(adminContracts[msg.sender]); \n', '    _;\n', '  }\n', '\n', '  function setActionContract(address _actionAddr, bool _useful) public onlyAdmin {\n', '    actionContracts[_actionAddr] = _useful;\n', '  }\n', '\n', '  modifier onlyAccess() {\n', '    require(actionContracts[msg.sender]);\n', '    _;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract JadeCoin is ERC20, AccessAdmin {\n', '  using SafeMath for SafeMath;\n', '  string public constant name  = "MAGICACADEMY JADE";\n', '  string public constant symbol = "Jade";\n', '  uint8 public constant decimals = 0;\n', '  uint256 public roughSupply;\n', '  uint256 public totalJadeProduction;\n', '\n', '  uint256[] public totalJadeProductionSnapshots; // The total goo production for each prior day past\n', '     \n', '  uint256 public nextSnapshotTime;\n', '  uint256 public researchDivPercent = 10;\n', '\n', '  // Balances for each player\n', '  mapping(address => uint256) public jadeBalance;\n', '  mapping(address => mapping(uint8 => uint256)) public coinBalance;\n', '  mapping(uint8 => uint256) totalEtherPool; //Total Pool\n', '  \n', '  mapping(address => mapping(uint256 => uint256)) public jadeProductionSnapshots; // Store player&#39;s jade production for given day (snapshot)\n', ' \n', '  mapping(address => mapping(uint256 => bool)) private jadeProductionZeroedSnapshots; // This isn&#39;t great but we need know difference between 0 production and an unused/inactive day.\n', '    \n', '  mapping(address => uint256) public lastJadeSaveTime; // Seconds (last time player claimed their produced jade)\n', '  mapping(address => uint256) public lastJadeProductionUpdate; // Days (last snapshot player updated their production)\n', '  mapping(address => uint256) private lastJadeResearchFundClaim; // Days (snapshot number)\n', '  \n', '  mapping(address => uint256) private lastJadeDepositFundClaim; // Days (snapshot number)\n', '  uint256[] private allocatedJadeResearchSnapshots; // Div pot #1 (research eth allocated to each prior day past)\n', '\n', '  // Mapping of approved ERC20 transfers (by player)\n', '  mapping(address => mapping(address => uint256)) private allowed;\n', '\n', '  event ReferalGain(address player, address referal, uint256 amount);\n', '\n', '  // Constructor\n', '  function JadeCoin() public {\n', '  }\n', '\n', '  function() external payable {\n', '    totalEtherPool[1] += msg.value;\n', '  }\n', '\n', '  // Incase community prefers goo deposit payments over production %, can be tweaked for balance\n', '  function tweakDailyDividends(uint256 newResearchPercent) external {\n', '    require(msg.sender == owner);\n', '    require(newResearchPercent > 0 && newResearchPercent <= 10);\n', '        \n', '    researchDivPercent = newResearchPercent;\n', '  }\n', '\n', '  function totalSupply() public constant returns(uint256) {\n', '    return roughSupply; // Stored jade (rough supply as it ignores earned/unclaimed jade)\n', '  }\n', '  /// balance of jade in-game\n', '  function balanceOf(address player) public constant returns(uint256) {\n', '    return SafeMath.add(jadeBalance[player],balanceOfUnclaimed(player));\n', '  }\n', '\n', '  /// unclaimed jade\n', '  function balanceOfUnclaimed(address player) public constant returns (uint256) {\n', '    uint256 lSave = lastJadeSaveTime[player];\n', '    if (lSave > 0 && lSave < block.timestamp) { \n', '      return SafeMath.mul(getJadeProduction(player),SafeMath.div(SafeMath.sub(block.timestamp,lSave),10));\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  /// production/s\n', '  function getJadeProduction(address player) public constant returns (uint256){\n', '    return jadeProductionSnapshots[player][lastJadeProductionUpdate[player]];\n', '  }\n', '\n', '  /// return totalJadeProduction/s\n', '  function getTotalJadeProduction() external view returns (uint256) {\n', '    return totalJadeProduction;\n', '  }\n', '\n', '  function getlastJadeProductionUpdate(address player) public view returns (uint256) {\n', '    return lastJadeProductionUpdate[player];\n', '  }\n', '    /// increase prodution \n', '  function increasePlayersJadeProduction(address player, uint256 increase) public onlyAccess {\n', '    jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length] = SafeMath.add(getJadeProduction(player),increase);\n', '    lastJadeProductionUpdate[player] = allocatedJadeResearchSnapshots.length;\n', '    totalJadeProduction = SafeMath.add(totalJadeProduction,increase);\n', '  }\n', '\n', '  /// reduce production  20180702\n', '  function reducePlayersJadeProduction(address player, uint256 decrease) public onlyAccess {\n', '    uint256 previousProduction = getJadeProduction(player);\n', '    uint256 newProduction = SafeMath.sub(previousProduction, decrease);\n', '\n', '    if (newProduction == 0) { \n', '      jadeProductionZeroedSnapshots[player][allocatedJadeResearchSnapshots.length] = true;\n', '      delete jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length]; // 0\n', '    } else {\n', '      jadeProductionSnapshots[player][allocatedJadeResearchSnapshots.length] = newProduction;\n', '    }   \n', '    lastJadeProductionUpdate[player] = allocatedJadeResearchSnapshots.length;\n', '    totalJadeProduction = SafeMath.sub(totalJadeProduction,decrease);\n', '  }\n', '\n', '  /// update player&#39;s jade balance\n', '  function updatePlayersCoin(address player) internal {\n', '    uint256 coinGain = balanceOfUnclaimed(player);\n', '    lastJadeSaveTime[player] = block.timestamp;\n', '    roughSupply = SafeMath.add(roughSupply,coinGain);  \n', '    jadeBalance[player] = SafeMath.add(jadeBalance[player],coinGain);  \n', '  }\n', '\n', '  /// update player&#39;s jade balance\n', '  function updatePlayersCoinByOut(address player) external onlyAccess {\n', '    uint256 coinGain = balanceOfUnclaimed(player);\n', '    lastJadeSaveTime[player] = block.timestamp;\n', '    roughSupply = SafeMath.add(roughSupply,coinGain);  \n', '    jadeBalance[player] = SafeMath.add(jadeBalance[player],coinGain);  \n', '  }\n', '  /// transfer\n', '  function transfer(address recipient, uint256 amount) public returns (bool) {\n', '    updatePlayersCoin(msg.sender);\n', '    require(amount <= jadeBalance[msg.sender]);\n', '    jadeBalance[msg.sender] = SafeMath.sub(jadeBalance[msg.sender],amount);\n', '    jadeBalance[recipient] = SafeMath.add(jadeBalance[recipient],amount);\n', '    //event\n', '    Transfer(msg.sender, recipient, amount);\n', '    return true;\n', '  }\n', '  /// transferfrom\n', '  function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {\n', '    updatePlayersCoin(player);\n', '    require(amount <= allowed[player][msg.sender] && amount <= jadeBalance[player]);\n', '        \n', '    jadeBalance[player] = SafeMath.sub(jadeBalance[player],amount); \n', '    jadeBalance[recipient] = SafeMath.add(jadeBalance[recipient],amount); \n', '    allowed[player][msg.sender] = SafeMath.sub(allowed[player][msg.sender],amount); \n', '        \n', '    Transfer(player, recipient, amount);  \n', '    return true;\n', '  }\n', '  \n', '  function approve(address approvee, uint256 amount) public returns (bool) {\n', '    allowed[msg.sender][approvee] = amount;  \n', '    Approval(msg.sender, approvee, amount);\n', '    return true;\n', '  }\n', '  \n', '  function allowance(address player, address approvee) public constant returns(uint256) {\n', '    return allowed[player][approvee];  \n', '  }\n', '  \n', '  /// update Jade via purchase\n', '  function updatePlayersCoinByPurchase(address player, uint256 purchaseCost) public onlyAccess {\n', '    uint256 unclaimedJade = balanceOfUnclaimed(player);\n', '        \n', '    if (purchaseCost > unclaimedJade) {\n', '      uint256 jadeDecrease = SafeMath.sub(purchaseCost, unclaimedJade);\n', '      require(jadeBalance[player] >= jadeDecrease);\n', '      roughSupply = SafeMath.sub(roughSupply,jadeDecrease);\n', '      jadeBalance[player] = SafeMath.sub(jadeBalance[player],jadeDecrease);\n', '    } else {\n', '      uint256 jadeGain = SafeMath.sub(unclaimedJade,purchaseCost);\n', '      roughSupply = SafeMath.add(roughSupply,jadeGain);\n', '      jadeBalance[player] = SafeMath.add(jadeBalance[player],jadeGain);\n', '    }\n', '        \n', '    lastJadeSaveTime[player] = block.timestamp;\n', '  }\n', '\n', '  function JadeCoinMining(address _addr, uint256 _amount) external onlyAdmin {\n', '    roughSupply = SafeMath.add(roughSupply,_amount);\n', '    jadeBalance[_addr] = SafeMath.add(jadeBalance[_addr],_amount);\n', '  }\n', '\n', '  function setRoughSupply(uint256 iroughSupply) external onlyAccess {\n', '    roughSupply = SafeMath.add(roughSupply,iroughSupply);\n', '  }\n', '  /// balance of coin  in-game\n', '  function coinBalanceOf(address player,uint8 itype) external constant returns(uint256) {\n', '    return coinBalance[player][itype];\n', '  }\n', '\n', '  function setJadeCoin(address player, uint256 coin, bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      jadeBalance[player] = SafeMath.add(jadeBalance[player],coin);\n', '    } else if (!iflag) {\n', '      jadeBalance[player] = SafeMath.sub(jadeBalance[player],coin);\n', '    }\n', '  }\n', '  \n', '  function setCoinBalance(address player, uint256 eth, uint8 itype, bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      coinBalance[player][itype] = SafeMath.add(coinBalance[player][itype],eth);\n', '    } else if (!iflag) {\n', '      coinBalance[player][itype] = SafeMath.sub(coinBalance[player][itype],eth);\n', '    }\n', '  }\n', '\n', '  function setLastJadeSaveTime(address player) external onlyAccess {\n', '    lastJadeSaveTime[player] = block.timestamp;\n', '  }\n', '\n', '  function setTotalEtherPool(uint256 inEth, uint8 itype, bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      totalEtherPool[itype] = SafeMath.add(totalEtherPool[itype],inEth);\n', '     } else if (!iflag) {\n', '      totalEtherPool[itype] = SafeMath.sub(totalEtherPool[itype],inEth);\n', '    }\n', '  }\n', '\n', '  function getTotalEtherPool(uint8 itype) external view returns (uint256) {\n', '    return totalEtherPool[itype];\n', '  }\n', '\n', '  function setJadeCoinZero(address player) external onlyAccess {\n', '    jadeBalance[player]=0;\n', '  }\n', '\n', '  function getNextSnapshotTime() external view returns(uint256) {\n', '    return nextSnapshotTime;\n', '  }\n', '  \n', '  // To display on website\n', '  function viewUnclaimedResearchDividends() external constant returns (uint256, uint256, uint256) {\n', '    uint256 startSnapshot = lastJadeResearchFundClaim[msg.sender];\n', '    uint256 latestSnapshot = allocatedJadeResearchSnapshots.length - 1; // No snapshots to begin with\n', '        \n', '    uint256 researchShare;\n', '    uint256 previousProduction = jadeProductionSnapshots[msg.sender][lastJadeResearchFundClaim[msg.sender] - 1]; // Underflow won&#39;t be a problem as gooProductionSnapshots[][0xfffffffffffff] = 0;\n', '    for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {     \n', '    // Slightly complex things by accounting for days/snapshots when user made no tx&#39;s\n', '      uint256 productionDuringSnapshot = jadeProductionSnapshots[msg.sender][i];\n', '      bool soldAllProduction = jadeProductionZeroedSnapshots[msg.sender][i];\n', '      if (productionDuringSnapshot == 0 && !soldAllProduction) {\n', '        productionDuringSnapshot = previousProduction;\n', '      } else {\n', '        previousProduction = productionDuringSnapshot;\n', '    }\n', '            \n', '      researchShare += (allocatedJadeResearchSnapshots[i] * productionDuringSnapshot) / totalJadeProductionSnapshots[i];\n', '    }\n', '    return (researchShare, startSnapshot, latestSnapshot);\n', '  }\n', '      \n', '  function claimResearchDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {\n', '    require(startSnapshot <= endSnapShot);\n', '    require(startSnapshot >= lastJadeResearchFundClaim[msg.sender]);\n', '    require(endSnapShot < allocatedJadeResearchSnapshots.length);\n', '        \n', '    uint256 researchShare;\n', '    uint256 previousProduction = jadeProductionSnapshots[msg.sender][lastJadeResearchFundClaim[msg.sender] - 1]; // Underflow won&#39;t be a problem as gooProductionSnapshots[][0xffffffffff] = 0;\n', '    for (uint256 i = startSnapshot; i <= endSnapShot; i++) {\n', '            \n', '    // Slightly complex things by accounting for days/snapshots when user made no tx&#39;s\n', '      uint256 productionDuringSnapshot = jadeProductionSnapshots[msg.sender][i];\n', '      bool soldAllProduction = jadeProductionZeroedSnapshots[msg.sender][i];\n', '      if (productionDuringSnapshot == 0 && !soldAllProduction) {\n', '        productionDuringSnapshot = previousProduction;\n', '      } else {\n', '        previousProduction = productionDuringSnapshot;\n', '      }\n', '            \n', '      researchShare += (allocatedJadeResearchSnapshots[i] * productionDuringSnapshot) / totalJadeProductionSnapshots[i];\n', '      }\n', '        \n', '        \n', '    if (jadeProductionSnapshots[msg.sender][endSnapShot] == 0 && !jadeProductionZeroedSnapshots[msg.sender][endSnapShot] && previousProduction > 0) {\n', '      jadeProductionSnapshots[msg.sender][endSnapShot] = previousProduction; // Checkpoint for next claim\n', '    }\n', '        \n', '    lastJadeResearchFundClaim[msg.sender] = endSnapShot + 1;\n', '        \n', '    uint256 referalDivs;\n', '    if (referer != address(0) && referer != msg.sender) {\n', '      referalDivs = researchShare / 100; // 1%\n', '      coinBalance[referer][1] += referalDivs;\n', '      ReferalGain(referer, msg.sender, referalDivs);\n', '    }\n', '    coinBalance[msg.sender][1] += SafeMath.sub(researchShare,referalDivs);\n', '  }    \n', '    \n', '  // Allocate pot divs for the day (00:00 cron job)\n', '  function snapshotDailyGooResearchFunding() external onlyAdmin {\n', '    uint256 todaysGooResearchFund = (totalEtherPool[1] * researchDivPercent) / 100; // 10% of pool daily\n', '    totalEtherPool[1] -= todaysGooResearchFund;\n', '        \n', '    totalJadeProductionSnapshots.push(totalJadeProduction);\n', '    allocatedJadeResearchSnapshots.push(todaysGooResearchFund);\n', '    nextSnapshotTime = block.timestamp + 24 hours;\n', '  }\n', '}\n', '\n', 'interface GameConfigInterface {\n', '  function productionCardIdRange() external constant returns (uint256, uint256);\n', '  function battleCardIdRange() external constant returns (uint256, uint256);\n', '  function upgradeIdRange() external constant returns (uint256, uint256);\n', '  function unitCoinProduction(uint256 cardId) external constant returns (uint256);\n', '  function unitAttack(uint256 cardId) external constant returns (uint256);\n', '  function unitDefense(uint256 cardId) external constant returns (uint256);\n', '  function unitStealingCapacity(uint256 cardId) external constant returns (uint256);\n', '}\n', '\n', '/// @notice define the players,cards,jadecoin\n', '/// @author rainysiu rainy@livestar.com\n', '/// @dev MagicAcademy Games \n', '\n', 'contract CardsBase is JadeCoin {\n', '\n', '  function CardsBase() public {\n', '    setAdminContract(msg.sender,true);\n', '    setActionContract(msg.sender,true);\n', '  }\n', '  // player  \n', '  struct Player {\n', '    address owneraddress;\n', '  }\n', '\n', '  Player[] players;\n', '  bool gameStarted;\n', '  \n', '  GameConfigInterface public schema;\n', '\n', '  // Stuff owned by each player\n', '  mapping(address => mapping(uint256 => uint256)) public unitsOwned;  //number of normal card\n', '  mapping(address => mapping(uint256 => uint256)) public upgradesOwned;  //Lv of upgrade card\n', '\n', '  mapping(address => uint256) public uintsOwnerCount; // total number of cards\n', '  mapping(address=> mapping(uint256 => uint256)) public uintProduction;  //card&#39;s production 单张卡牌总产量\n', '\n', '  // Rares & Upgrades (Increase unit&#39;s production / attack etc.)\n', '  mapping(address => mapping(uint256 => uint256)) public unitCoinProductionIncreases; // Adds to the coin per second\n', '  mapping(address => mapping(uint256 => uint256)) public unitCoinProductionMultiplier; // Multiplies the coin per second\n', '  mapping(address => mapping(uint256 => uint256)) public unitAttackIncreases;\n', '  mapping(address => mapping(uint256 => uint256)) public unitAttackMultiplier;\n', '  mapping(address => mapping(uint256 => uint256)) public unitDefenseIncreases;\n', '  mapping(address => mapping(uint256 => uint256)) public unitDefenseMultiplier;\n', '  mapping(address => mapping(uint256 => uint256)) public unitJadeStealingIncreases;\n', '  mapping(address => mapping(uint256 => uint256)) public unitJadeStealingMultiplier;\n', '  mapping(address => mapping(uint256 => uint256)) private unitMaxCap; // external cap\n', '\n', '  //setting configuration\n', '  function setConfigAddress(address _address) external onlyOwner {\n', '    schema = GameConfigInterface(_address);\n', '  }\n', '\n', '/// start game\n', '  function beginGame(uint256 firstDivsTime) external payable onlyOwner {\n', '    require(!gameStarted);\n', '    gameStarted = true;\n', '    nextSnapshotTime = firstDivsTime;\n', '    totalEtherPool[1] = msg.value;  // Seed pot \n', '  }\n', '\n', '  function endGame() external payable onlyOwner {\n', '    require(gameStarted);\n', '    gameStarted = false;\n', '  }\n', '\n', '  function getGameStarted() external constant returns (bool) {\n', '    return gameStarted;\n', '  }\n', '  function AddPlayers(address _address) external onlyAccess { \n', '    Player memory _player= Player({\n', '      owneraddress: _address\n', '    });\n', '    players.push(_player);\n', '  }\n', '\n', '  /// @notice ranking of production\n', '  /// @notice rainysiu\n', '  function getRanking() external view returns (address[], uint256[],uint256[]) {\n', '    uint256 len = players.length;\n', '    uint256[] memory arr = new uint256[](len);\n', '    address[] memory arr_addr = new address[](len);\n', '    uint256[] memory arr_def = new uint256[](len);\n', '  \n', '    uint counter =0;\n', '    for (uint k=0;k<len; k++){\n', '      arr[counter] =  getJadeProduction(players[k].owneraddress);\n', '      arr_addr[counter] = players[k].owneraddress;\n', '      (,arr_def[counter],,) = getPlayersBattleStats(players[k].owneraddress);\n', '      counter++;\n', '    }\n', '\n', '    for(uint i=0;i<len-1;i++) {\n', '      for(uint j=0;j<len-i-1;j++) {\n', '        if(arr[j]<arr[j+1]) {\n', '          uint256 temp = arr[j];\n', '          address temp_addr = arr_addr[j];\n', '          uint256 temp_def = arr_def[j];\n', '          arr[j] = arr[j+1];\n', '          arr[j+1] = temp;\n', '          arr_addr[j] = arr_addr[j+1];\n', '          arr_addr[j+1] = temp_addr;\n', '\n', '          arr_def[j] = arr_def[j+1];\n', '          arr_def[j+1] = temp_def;\n', '        }\n', '      }\n', '    }\n', '    return (arr_addr,arr,arr_def);\n', '  }\n', '\n', '  //total users\n', '  function getTotalUsers()  external view returns (uint256) {\n', '    return players.length;\n', '  }\n', '  function getMaxCap(address _addr,uint256 _cardId) external view returns (uint256) {\n', '    return unitMaxCap[_addr][_cardId];\n', '  }\n', '\n', '  /// UnitsProuction\n', '  function getUnitsProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256) {\n', '    return (amount * (schema.unitCoinProduction(unitId) + unitCoinProductionIncreases[player][unitId]) * (10 + unitCoinProductionMultiplier[player][unitId])) / 10; \n', '  } \n', '\n', '  /// one card&#39;s production\n', '  function getUnitsInProduction(address player, uint256 unitId, uint256 amount) external constant returns (uint256) {\n', '    return SafeMath.div(SafeMath.mul(amount,uintProduction[player][unitId]),unitsOwned[player][unitId]);\n', '  } \n', '\n', '  /// UnitsAttack\n', '  function getUnitsAttack(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {\n', '    return (amount * (schema.unitAttack(unitId) + unitAttackIncreases[player][unitId]) * (10 + unitAttackMultiplier[player][unitId])) / 10;\n', '  }\n', '  /// UnitsDefense\n', '  function getUnitsDefense(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {\n', '    return (amount * (schema.unitDefense(unitId) + unitDefenseIncreases[player][unitId]) * (10 + unitDefenseMultiplier[player][unitId])) / 10;\n', '  }\n', '  /// UnitsStealingCapacity\n', '  function getUnitsStealingCapacity(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {\n', '    return (amount * (schema.unitStealingCapacity(unitId) + unitJadeStealingIncreases[player][unitId]) * (10 + unitJadeStealingMultiplier[player][unitId])) / 10;\n', '  }\n', ' \n', '  // player&#39;s attacking & defending & stealing & battle power\n', '  function getPlayersBattleStats(address player) public constant returns (\n', '    uint256 attackingPower, \n', '    uint256 defendingPower, \n', '    uint256 stealingPower,\n', '    uint256 battlePower) {\n', '\n', '    uint256 startId;\n', '    uint256 endId;\n', '    (startId, endId) = schema.battleCardIdRange();\n', '\n', '    // Not ideal but will only be a small number of units (and saves gas when buying units)\n', '    while (startId <= endId) {\n', '      attackingPower = SafeMath.add(attackingPower,getUnitsAttack(player, startId, unitsOwned[player][startId]));\n', '      stealingPower = SafeMath.add(stealingPower,getUnitsStealingCapacity(player, startId, unitsOwned[player][startId]));\n', '      defendingPower = SafeMath.add(defendingPower,getUnitsDefense(player, startId, unitsOwned[player][startId]));\n', '      battlePower = SafeMath.add(attackingPower,defendingPower); \n', '      startId++;\n', '    }\n', '  }\n', '\n', '  // @nitice number of normal card\n', '  function getOwnedCount(address player, uint256 cardId) external view returns (uint256) {\n', '    return unitsOwned[player][cardId];\n', '  }\n', '  function setOwnedCount(address player, uint256 cardId, uint256 amount, bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitsOwned[player][cardId] = SafeMath.add(unitsOwned[player][cardId],amount);\n', '     } else if (!iflag) {\n', '      unitsOwned[player][cardId] = SafeMath.sub(unitsOwned[player][cardId],amount);\n', '    }\n', '  }\n', '\n', '  // @notice Lv of upgrade card\n', '  function getUpgradesOwned(address player, uint256 upgradeId) external view returns (uint256) {\n', '    return upgradesOwned[player][upgradeId];\n', '  }\n', '  //set upgrade\n', '  function setUpgradesOwned(address player, uint256 upgradeId) external onlyAccess {\n', '    upgradesOwned[player][upgradeId] = SafeMath.add(upgradesOwned[player][upgradeId],1);\n', '  }\n', '\n', '  function getUintsOwnerCount(address _address) external view returns (uint256) {\n', '    return uintsOwnerCount[_address];\n', '  }\n', '  function setUintsOwnerCount(address _address, uint256 amount, bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      uintsOwnerCount[_address] = SafeMath.add(uintsOwnerCount[_address],amount);\n', '    } else if (!iflag) {\n', '      uintsOwnerCount[_address] = SafeMath.sub(uintsOwnerCount[_address],amount);\n', '    }\n', '  }\n', '\n', '  function getUnitCoinProductionIncreases(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitCoinProductionIncreases[_address][cardId];\n', '  }\n', '\n', '  function setUnitCoinProductionIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitCoinProductionIncreases[_address][cardId] = SafeMath.add(unitCoinProductionIncreases[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitCoinProductionIncreases[_address][cardId] = SafeMath.sub(unitCoinProductionIncreases[_address][cardId],iValue);\n', '    }\n', '  }\n', '\n', '  function getUnitCoinProductionMultiplier(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitCoinProductionMultiplier[_address][cardId];\n', '  }\n', '\n', '  function setUnitCoinProductionMultiplier(address _address, uint256 cardId, uint256 iValue, bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitCoinProductionMultiplier[_address][cardId] = SafeMath.add(unitCoinProductionMultiplier[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitCoinProductionMultiplier[_address][cardId] = SafeMath.sub(unitCoinProductionMultiplier[_address][cardId],iValue);\n', '    }\n', '  }\n', '\n', '  function setUnitAttackIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitAttackIncreases[_address][cardId] = SafeMath.add(unitAttackIncreases[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitAttackIncreases[_address][cardId] = SafeMath.sub(unitAttackIncreases[_address][cardId],iValue);\n', '    }\n', '  }\n', '\n', '  function getUnitAttackIncreases(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitAttackIncreases[_address][cardId];\n', '  } \n', '  function setUnitAttackMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitAttackMultiplier[_address][cardId] = SafeMath.add(unitAttackMultiplier[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitAttackMultiplier[_address][cardId] = SafeMath.sub(unitAttackMultiplier[_address][cardId],iValue);\n', '    }\n', '  }\n', '  function getUnitAttackMultiplier(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitAttackMultiplier[_address][cardId];\n', '  } \n', '\n', '  function setUnitDefenseIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitDefenseIncreases[_address][cardId] = SafeMath.add(unitDefenseIncreases[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitDefenseIncreases[_address][cardId] = SafeMath.sub(unitDefenseIncreases[_address][cardId],iValue);\n', '    }\n', '  }\n', '  function getUnitDefenseIncreases(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitDefenseIncreases[_address][cardId];\n', '  }\n', '  function setunitDefenseMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitDefenseMultiplier[_address][cardId] = SafeMath.add(unitDefenseMultiplier[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitDefenseMultiplier[_address][cardId] = SafeMath.sub(unitDefenseMultiplier[_address][cardId],iValue);\n', '    }\n', '  }\n', '  function getUnitDefenseMultiplier(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitDefenseMultiplier[_address][cardId];\n', '  }\n', '  function setUnitJadeStealingIncreases(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitJadeStealingIncreases[_address][cardId] = SafeMath.add(unitJadeStealingIncreases[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitJadeStealingIncreases[_address][cardId] = SafeMath.sub(unitJadeStealingIncreases[_address][cardId],iValue);\n', '    }\n', '  }\n', '  function getUnitJadeStealingIncreases(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitJadeStealingIncreases[_address][cardId];\n', '  } \n', '\n', '  function setUnitJadeStealingMultiplier(address _address, uint256 cardId, uint256 iValue,bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      unitJadeStealingMultiplier[_address][cardId] = SafeMath.add(unitJadeStealingMultiplier[_address][cardId],iValue);\n', '    } else if (!iflag) {\n', '      unitJadeStealingMultiplier[_address][cardId] = SafeMath.sub(unitJadeStealingMultiplier[_address][cardId],iValue);\n', '    }\n', '  }\n', '  function getUnitJadeStealingMultiplier(address _address, uint256 cardId) external view returns (uint256) {\n', '    return unitJadeStealingMultiplier[_address][cardId];\n', '  } \n', '\n', '  function setUintCoinProduction(address _address, uint256 cardId, uint256 iValue, bool iflag) external onlyAccess {\n', '    if (iflag) {\n', '      uintProduction[_address][cardId] = SafeMath.add(uintProduction[_address][cardId],iValue);\n', '     } else if (!iflag) {\n', '      uintProduction[_address][cardId] = SafeMath.sub(uintProduction[_address][cardId],iValue);\n', '    }\n', '  }\n', '\n', '  function getUintCoinProduction(address _address, uint256 cardId) external view returns (uint256) {\n', '    return uintProduction[_address][cardId];\n', '  }\n', '\n', '  function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external onlyAccess {\n', '    uint256 productionGain;\n', '    if (upgradeClass == 0) {\n', '      unitCoinProductionIncreases[player][unitId] += upgradeValue;\n', '      productionGain = unitsOwned[player][unitId] * upgradeValue * (10 + unitCoinProductionMultiplier[player][unitId]);\n', '      increasePlayersJadeProduction(player, productionGain);\n', '    } else if (upgradeClass == 1) {\n', '      unitCoinProductionMultiplier[player][unitId] += upgradeValue;\n', '      productionGain = unitsOwned[player][unitId] * upgradeValue * (schema.unitCoinProduction(unitId) + unitCoinProductionIncreases[player][unitId]);\n', '      increasePlayersJadeProduction(player, productionGain);\n', '    } else if (upgradeClass == 2) {\n', '      unitAttackIncreases[player][unitId] += upgradeValue;\n', '    } else if (upgradeClass == 3) {\n', '      unitAttackMultiplier[player][unitId] += upgradeValue;\n', '    } else if (upgradeClass == 4) {\n', '      unitDefenseIncreases[player][unitId] += upgradeValue;\n', '    } else if (upgradeClass == 5) {\n', '      unitDefenseMultiplier[player][unitId] += upgradeValue;\n', '    } else if (upgradeClass == 6) {\n', '      unitJadeStealingIncreases[player][unitId] += upgradeValue;\n', '    } else if (upgradeClass == 7) {\n', '      unitJadeStealingMultiplier[player][unitId] += upgradeValue;\n', '    } else if (upgradeClass == 8) {\n', '      unitMaxCap[player][unitId] = upgradeValue; // Housing upgrade (new capacity)\n', '    }\n', '  }\n', '    \n', '  function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) external onlyAccess {\n', '    uint256 productionLoss;\n', '    if (upgradeClass == 0) {\n', '      unitCoinProductionIncreases[player][unitId] -= upgradeValue;\n', '      productionLoss = unitsOwned[player][unitId] * upgradeValue * (10 + unitCoinProductionMultiplier[player][unitId]);\n', '      reducePlayersJadeProduction(player, productionLoss);\n', '    } else if (upgradeClass == 1) {\n', '      unitCoinProductionMultiplier[player][unitId] -= upgradeValue;\n', '      productionLoss = unitsOwned[player][unitId] * upgradeValue * (schema.unitCoinProduction(unitId) + unitCoinProductionIncreases[player][unitId]);\n', '      reducePlayersJadeProduction(player, productionLoss);\n', '    } else if (upgradeClass == 2) {\n', '      unitAttackIncreases[player][unitId] -= upgradeValue;\n', '    } else if (upgradeClass == 3) {\n', '      unitAttackMultiplier[player][unitId] -= upgradeValue;\n', '    } else if (upgradeClass == 4) {\n', '      unitDefenseIncreases[player][unitId] -= upgradeValue;\n', '    } else if (upgradeClass == 5) {\n', '      unitDefenseMultiplier[player][unitId] -= upgradeValue;\n', '    } else if (upgradeClass == 6) {\n', '      unitJadeStealingIncreases[player][unitId] -= upgradeValue;\n', '    } else if (upgradeClass == 7) {\n', '      unitJadeStealingMultiplier[player][unitId] -= upgradeValue;\n', '    }\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']