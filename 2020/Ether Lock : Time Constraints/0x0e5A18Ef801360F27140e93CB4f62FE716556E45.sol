['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract NFTStaking {\n', '\n', '  bool public active;\n', '  uint256 public startTime;\n', '  uint256 public cutoffTime;\n', '  address public governance;\n', '  IERC20 internal immutable NFTProtocol;\n', '  struct rewardSchedule {\n', '    uint64 days30;\n', '    uint64 days45;\n', '    uint64 days60;\n', '    uint64 days90;\n', '  }\n', '  rewardSchedule public rewardMultiplier = rewardSchedule({\n', '    days30: 2,\n', '    days45: 3,\n', '    days60: 5,\n', '    days90: 10\n', '  });\n', '\n', '  mapping(address=>uint256) public userDepositTotal;\n', '  mapping(address=>uint256) public numUserDeposits;\n', '  address[] public allStakingUsers;\n', '  struct userDeposit {\n', '    uint256 amountNFT;\n', '    uint256 depositTime;\n', '  }\n', '  mapping(address=>userDeposit[]) public userDeposits;\n', '\n', '  uint256 public totalDeposited;\n', '  uint256 public userFunds;\n', '  uint256 public stakingFunds;\n', '  uint256 public constant maxContractStakingCapacity = 7500000 * 1 ether;\n', '  uint256 public constant userMaxDeposits = 5;\n', '  uint256 public constant totalRewardSupply = 750000 * 1 ether;\n', '  uint256 public constant minStakingAmount = 10000 * 1 ether;\n', '  uint256 public constant maxStakingAmount = 1000000 * 1 ether;\n', '\n', '  constructor (address nftAddress) public {\n', '    //NFTProtocol = IERC20(0xB5a9f4270157BeDe68070df7A070525644fc782D); // Kovan\n', '    //NFTProtocol = IERC20(0xcB8d1260F9c92A3A545d409466280fFdD7AF7042); // Mainnet\n', '    NFTProtocol = IERC20(nftAddress);\n', '    governance = msg.sender;\n', '  }\n', '\n', '  function deposit(uint256 depositAmount) external {\n', '    require(NFTProtocol.balanceOf(msg.sender) >= depositAmount, "not enough NFT tokens");\n', '    require(active == true, "staking has not begun yet");\n', '    require(depositAmount >= minStakingAmount, "depositAmount too low");\n', '    require(depositAmount <= maxStakingAmount, "depositAmount too high");\n', '    require(numUserDeposits[msg.sender] < userMaxDeposits, "users can only have 5 total deposits");\n', '    require(totalDeposited < maxContractStakingCapacity, "contract staking capacity exceeded");\n', '    require(block.timestamp < cutoffTime, "contract staking deposit time period over");\n', '    if (userDepositTotal[msg.sender] == 0) allStakingUsers.push(msg.sender);\n', '    userDepositTotal[msg.sender] += depositAmount;\n', '    totalDeposited += depositAmount;\n', '    userFunds += depositAmount;\n', '    userDeposits[msg.sender].push(userDeposit({\n', '      amountNFT: depositAmount,\n', '      depositTime: block.timestamp\n', '    }));\n', '    numUserDeposits[msg.sender] = numUserDeposits[msg.sender] + 1;\n', '    NFTProtocol.transferFrom(msg.sender, address(this), depositAmount);\n', '  }\n', '\n', '  event WithdrawAll(address userAddress, uint256 principal, uint256 yield, uint256 userFundsRemaining, uint256 stakingFundsRemaining);\n', '  function withdrawAll() public {\n', '    require(active == true, "staking has not begun yet");\n', '    require(userDepositTotal[msg.sender] > 0, "nothing to withdraw");\n', '    uint256 withdrawalAmount = userDepositTotal[msg.sender];\n', '    uint256 userYield = getUserYield(msg.sender);\n', '    userDepositTotal[msg.sender] = 0;\n', '    userFunds -= withdrawalAmount;\n', '    stakingFunds -= userYield;\n', '    for (uint256 i = 0; i < userDeposits[msg.sender].length; i++) {\n', '        delete userDeposits[msg.sender][i];\n', '    }\n', '    NFTProtocol.transfer(msg.sender, withdrawalAmount);\n', '    NFTProtocol.transfer(msg.sender, userYield);\n', '    emit WithdrawAll(msg.sender, withdrawalAmount, userYield, userFunds, stakingFunds);\n', '  }\n', '\n', '  event WithdrawPrincipal(address userAddress, uint256 principal, uint256 userFundsRemaining);\n', '  function withdrawPrincipal() public {\n', '    require(active == true, "staking has not begun yet");\n', '    uint256 withdrawalAmount = userDepositTotal[msg.sender];\n', '    userDepositTotal[msg.sender] = 0;\n', '    userFunds -= withdrawalAmount;\n', '    for (uint256 i = 0; i < userDeposits[msg.sender].length; i++) {\n', '        delete userDeposits[msg.sender][i];\n', '    }\n', '    NFTProtocol.transfer(msg.sender, withdrawalAmount);\n', '    emit WithdrawPrincipal(msg.sender, withdrawalAmount, userFunds);\n', '  }\n', '\n', '  event StakingBegins(uint256 timestamp, uint256 stakingFunds);\n', '  function beginStaking() external {\n', '    require(msg.sender == governance, "only governance can begin staking");\n', '    require(NFTProtocol.balanceOf(address(this)) == totalRewardSupply, "not enough staking rewards");\n', '    active = true;\n', '    startTime = block.timestamp;\n', '    cutoffTime = startTime + 60 days;\n', '    stakingFunds = totalRewardSupply;\n', '    emit StakingBegins(startTime, stakingFunds);\n', '  }\n', '\n', '  function getYieldMultiplier(uint256 daysStaked) public view returns(uint256) {\n', '    if (daysStaked >= 90) return rewardMultiplier.days90;\n', '    if (daysStaked >= 60) return rewardMultiplier.days60;\n', '    if (daysStaked >= 45) return rewardMultiplier.days45;\n', '    if (daysStaked >= 30) return rewardMultiplier.days30;\n', '    return 0;\n', '  }\n', '\n', '  function getUserYield(address userAddress) public view returns(uint256) {\n', '    uint256 totalYield;\n', '    for (uint256 i = 0; i < userDeposits[userAddress].length; i++) {\n', '      uint256 daysStaked = (block.timestamp - userDeposits[userAddress][i].depositTime) / 1 days;\n', '      uint256 yieldMultiplier = getYieldMultiplier(daysStaked);\n', '      totalYield += userDeposits[userAddress][i].amountNFT * 1 ether * yieldMultiplier / (1 ether * 100);\n', '    }\n', '    return totalYield;\n', '  }\n', '  \n', '  function getUserDeposits(address userAddress) external view returns(userDeposit[] memory) {\n', '    return userDeposits[userAddress];\n', '  }\n', '\n', '}']