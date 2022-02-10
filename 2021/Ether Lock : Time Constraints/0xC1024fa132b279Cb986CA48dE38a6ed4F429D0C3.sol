['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', '\n', 'import "./IERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./StrongPoolInterface.sol";\n', 'import "./rewards.sol";\n', '\n', 'contract PoolV4 {\n', '  event Mined(address indexed miner, uint256 amount);\n', '  event Unmined(address indexed miner, uint256 amount);\n', '  event Claimed(address indexed miner, uint256 reward);\n', '\n', '  using SafeMath for uint256;\n', '\n', '  bool public initDone;\n', '  address public admin;\n', '  address public pendingAdmin;\n', '  address public superAdmin;\n', '  address public pendingSuperAdmin;\n', '  address public parameterAdmin;\n', '  address payable public feeCollector;\n', '\n', '  IERC20 public token;\n', '  IERC20 public strongToken;\n', '  StrongPoolInterface public strongPool;\n', '\n', '  mapping(address => uint256) public minerBalance;\n', '  uint256 public totalBalance;\n', '  mapping(address => uint256) public minerBlockLastClaimedOn;\n', '\n', '  uint256 public rewardBalance;\n', '\n', '  uint256 public rewardPerBlockNumerator;\n', '  uint256 public rewardPerBlockDenominator;\n', '\n', '  uint256 public miningFeeNumerator;\n', '  uint256 public miningFeeDenominator;\n', '\n', '  uint256 public unminingFeeNumerator;\n', '  uint256 public unminingFeeDenominator;\n', '\n', '  uint256 public claimingFeeNumerator;\n', '  uint256 public claimingFeeDenominator;\n', '\n', '  uint256 public claimingFeeInWei;\n', '\n', '  uint256 public rewardPerBlockNumeratorNew;\n', '  uint256 public rewardPerBlockDenominatorNew;\n', '  uint256 public rewardPerBlockNewEffectiveBlock;\n', '\n', '  function init(\n', '    address strongTokenAddress,\n', '    address tokenAddress,\n', '    address strongPoolAddress,\n', '    address adminAddress,\n', '    address superAdminAddress,\n', '    uint256 rewardPerBlockNumeratorValue,\n', '    uint256 rewardPerBlockDenominatorValue,\n', '    uint256 miningFeeNumeratorValue,\n', '    uint256 miningFeeDenominatorValue,\n', '    uint256 unminingFeeNumeratorValue,\n', '    uint256 unminingFeeDenominatorValue,\n', '    uint256 claimingFeeNumeratorValue,\n', '    uint256 claimingFeeDenominatorValue\n', '  ) public {\n', '    require(!initDone, "init done");\n', '    strongToken = IERC20(strongTokenAddress);\n', '    token = IERC20(tokenAddress);\n', '    strongPool = StrongPoolInterface(strongPoolAddress);\n', '    admin = adminAddress;\n', '    superAdmin = superAdminAddress;\n', '    rewardPerBlockNumerator = rewardPerBlockNumeratorValue;\n', '    rewardPerBlockDenominator = rewardPerBlockDenominatorValue;\n', '    miningFeeNumerator = miningFeeNumeratorValue;\n', '    miningFeeDenominator = miningFeeDenominatorValue;\n', '    unminingFeeNumerator = unminingFeeNumeratorValue;\n', '    unminingFeeDenominator = unminingFeeDenominatorValue;\n', '    claimingFeeNumerator = claimingFeeNumeratorValue;\n', '    claimingFeeDenominator = claimingFeeDenominatorValue;\n', '    initDone = true;\n', '  }\n', '\n', '  // ADMIN\n', '  // *************************************************************************************\n', '  function updateParameterAdmin(address newParameterAdmin) public {\n', '    require(newParameterAdmin != address(0), "zero");\n', '    require(msg.sender == superAdmin);\n', '    parameterAdmin = newParameterAdmin;\n', '  }\n', '\n', '  function setPendingAdmin(address newPendingAdmin) public {\n', '    require(newPendingAdmin != address(0), "zero");\n', '    require(msg.sender == admin, "not admin");\n', '    pendingAdmin = newPendingAdmin;\n', '  }\n', '\n', '  function acceptAdmin() public {\n', '    require(msg.sender == pendingAdmin && msg.sender != address(0), "not pendingAdmin");\n', '    admin = pendingAdmin;\n', '    pendingAdmin = address(0);\n', '  }\n', '\n', '  function setPendingSuperAdmin(address newPendingSuperAdmin) public {\n', '    require(newPendingSuperAdmin != address(0), "zero");\n', '    require(msg.sender == superAdmin, "not superAdmin");\n', '    pendingSuperAdmin = newPendingSuperAdmin;\n', '  }\n', '\n', '  function acceptSuperAdmin() public {\n', '    require(msg.sender == pendingSuperAdmin && msg.sender != address(0), "not pendingSuperAdmin");\n', '    superAdmin = pendingSuperAdmin;\n', '    pendingSuperAdmin = address(0);\n', '  }\n', '\n', '  // REWARD\n', '  // *************************************************************************************\n', '  function updateRewardPerBlock(uint256 numerator, uint256 denominator) public {\n', '    require(msg.sender == admin || msg.sender == parameterAdmin || msg.sender == superAdmin, "not an admin");\n', '    require(denominator != 0, "invalid value");\n', '    rewardPerBlockNumerator = numerator;\n', '    rewardPerBlockDenominator = denominator;\n', '  }\n', '\n', '  function deposit(uint256 amount) public {\n', '    require(msg.sender == superAdmin, "not an admin");\n', '    require(amount > 0, "zero");\n', '    strongToken.transferFrom(msg.sender, address(this), amount);\n', '    rewardBalance = rewardBalance.add(amount);\n', '  }\n', '\n', '  function withdraw(address destination, uint256 amount) public {\n', '    require(msg.sender == superAdmin, "not an admin");\n', '    require(amount > 0, "zero");\n', '    require(rewardBalance >= amount, "not enough");\n', '    strongToken.transfer(destination, amount);\n', '    rewardBalance = rewardBalance.sub(amount);\n', '  }\n', '\n', '  // FEES\n', '  // *************************************************************************************\n', '  function updateFeeCollector(address payable newFeeCollector) public {\n', '    require(newFeeCollector != address(0), "zero");\n', '    require(msg.sender == superAdmin);\n', '    feeCollector = newFeeCollector;\n', '  }\n', '\n', '  function updateMiningFee(uint256 numerator, uint256 denominator) public {\n', '    require(msg.sender == admin || msg.sender == parameterAdmin || msg.sender == superAdmin, "not an admin");\n', '    require(denominator != 0, "invalid value");\n', '    miningFeeNumerator = numerator;\n', '    miningFeeDenominator = denominator;\n', '  }\n', '\n', '  function updateUnminingFee(uint256 numerator, uint256 denominator) public {\n', '    require(msg.sender == admin || msg.sender == parameterAdmin || msg.sender == superAdmin, "not an admin");\n', '    require(denominator != 0, "invalid value");\n', '    unminingFeeNumerator = numerator;\n', '    unminingFeeDenominator = denominator;\n', '  }\n', '\n', '  function updateClaimingFee(uint256 numerator, uint256 denominator) public {\n', '    require(msg.sender == admin || msg.sender == parameterAdmin || msg.sender == superAdmin, "not an admin");\n', '    require(denominator != 0, "invalid value");\n', '    claimingFeeNumerator = numerator;\n', '    claimingFeeDenominator = denominator;\n', '  }\n', '\n', '  // CORE\n', '  // *************************************************************************************\n', '  function mine(uint256 amount) public payable {\n', '    require(amount > 0, "zero");\n', '    uint256 fee = amount.mul(miningFeeNumerator).div(miningFeeDenominator);\n', '    require(msg.value == fee, "invalid fee");\n', '    feeCollector.transfer(msg.value);\n', '    if (block.number > minerBlockLastClaimedOn[msg.sender]) {\n', '      uint256 reward = getReward(msg.sender);\n', '      if (reward > 0) {\n', '        rewardBalance = rewardBalance.sub(reward);\n', '        strongToken.approve(address(strongPool), reward);\n', '        strongPool.mineFor(msg.sender, reward);\n', '        minerBlockLastClaimedOn[msg.sender] = block.number;\n', '      }\n', '    }\n', '    token.transferFrom(msg.sender, address(this), amount);\n', '    minerBalance[msg.sender] = minerBalance[msg.sender].add(amount);\n', '    totalBalance = totalBalance.add(amount);\n', '    if (minerBlockLastClaimedOn[msg.sender] == 0) {\n', '      minerBlockLastClaimedOn[msg.sender] = block.number;\n', '    }\n', '    emit Mined(msg.sender, amount);\n', '  }\n', '\n', '  function unmine(uint256 amount) public payable {\n', '    require(amount > 0, "zero");\n', '    uint256 fee = amount.mul(unminingFeeNumerator).div(unminingFeeDenominator);\n', '    require(msg.value == fee, "invalid fee");\n', '    require(minerBalance[msg.sender] >= amount, "not enough");\n', '    feeCollector.transfer(msg.value);\n', '    if (block.number > minerBlockLastClaimedOn[msg.sender]) {\n', '      uint256 reward = getReward(msg.sender);\n', '      if (reward > 0) {\n', '        rewardBalance = rewardBalance.sub(reward);\n', '        strongToken.approve(address(strongPool), reward);\n', '        strongPool.mineFor(msg.sender, reward);\n', '        minerBlockLastClaimedOn[msg.sender] = block.number;\n', '      }\n', '    }\n', '    minerBalance[msg.sender] = minerBalance[msg.sender].sub(amount);\n', '    totalBalance = totalBalance.sub(amount);\n', '    token.transfer(msg.sender, amount);\n', '    if (minerBalance[msg.sender] == 0) {\n', '      minerBlockLastClaimedOn[msg.sender] = 0;\n', '    }\n', '    emit Unmined(msg.sender, amount);\n', '  }\n', '\n', '  function claim(uint256 blockNumber) public payable {\n', '    require(blockNumber <= block.number, "invalid block number");\n', '    require(minerBlockLastClaimedOn[msg.sender] != 0, "error");\n', '    require(blockNumber > minerBlockLastClaimedOn[msg.sender], "too soon");\n', '    uint256 reward = getRewardByBlock(msg.sender, blockNumber);\n', '    require(reward > 0, "no reward");\n', '    uint256 fee = reward.mul(claimingFeeNumerator).div(claimingFeeDenominator);\n', '    require(msg.value == fee, "invalid fee");\n', '    feeCollector.transfer(msg.value);\n', '    strongToken.approve(address(strongPool), reward);\n', '    strongPool.mineFor(msg.sender, reward);\n', '    rewardBalance = rewardBalance.sub(reward);\n', '    minerBlockLastClaimedOn[msg.sender] = blockNumber;\n', '    emit Claimed(msg.sender, reward);\n', '  }\n', '\n', '  function getReward(address miner) public view returns (uint256) {\n', '    return getRewardByBlock(miner, block.number);\n', '  }\n', '\n', '  function getRewardByBlock(address miner, uint256 blockNumber) public view returns (uint256) {\n', '    uint256 blockLastClaimedOn = minerBlockLastClaimedOn[miner];\n', '\n', '    if (blockNumber > block.number) return 0;\n', '    if (blockLastClaimedOn == 0) return 0;\n', '    if (blockNumber < blockLastClaimedOn) return 0;\n', '    if (totalBalance == 0) return 0;\n', '\n', '    uint256[2] memory rewardBlocks = rewards.blocks(blockLastClaimedOn, rewardPerBlockNewEffectiveBlock, blockNumber);\n', '    uint256 rewardOld = rewardPerBlockDenominator > 0 ? rewardBlocks[0].mul(rewardPerBlockNumerator).div(rewardPerBlockDenominator) : 0;\n', '    uint256 rewardNew = rewardPerBlockDenominatorNew > 0 ? rewardBlocks[1].mul(rewardPerBlockNumeratorNew).div(rewardPerBlockDenominatorNew) : 0;\n', '\n', '    return rewardOld.add(rewardNew).mul(minerBalance[miner]).div(totalBalance);\n', '  }\n', '\n', '  function updateRewardPerBlockNew(\n', '    uint256 numerator,\n', '    uint256 denominator,\n', '    uint256 effectiveBlock\n', '  ) public {\n', '    require(msg.sender == admin || msg.sender == parameterAdmin || msg.sender == superAdmin, "not admin");\n', '\n', '    rewardPerBlockNumeratorNew = numerator;\n', '    rewardPerBlockDenominatorNew = denominator;\n', '    rewardPerBlockNewEffectiveBlock = effectiveBlock != 0 ? effectiveBlock : block.number;\n', '  }\n', '}']