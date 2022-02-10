['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface sbStrongPoolInterface {\n', '  function serviceMinMined(address miner) external view returns (bool);\n', '\n', '  function minerMinMined(address miner) external view returns (bool);\n', '\n', '  function mineFor(address miner, uint256 amount) external;\n', '\n', '  function getMineData(uint256 day)\n', '    external\n', '    view\n', '    returns (\n', '      uint256,\n', '      uint256,\n', '      uint256\n', '    );\n', '\n', '  function receiveRewards(uint256 day, uint256 amount) external;\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface sbVotesInterface {\n', '  function getCommunityData(address community, uint256 day)\n', '    external\n', '    view\n', '    returns (\n', '      uint256,\n', '      uint256,\n', '      uint256\n', '    );\n', '\n', '  function getPriorProposalVotes(address account, uint256 blockNumber) external view returns (uint96);\n', '\n', '  function receiveServiceRewards(uint256 day, uint256 amount) external;\n', '\n', '  function receiveVoterRewards(uint256 day, uint256 amount) external;\n', '\n', '  function updateVotes(\n', '    address staker,\n', '    uint256 rawAmount,\n', '    bool adding\n', '  ) external;\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./SafeMath.sol";\n', 'import "./IERC20.sol";\n', 'import "./sbTokensInterface.sol";\n', 'import "./sbCommunityInterface.sol";\n', 'import "./sbStrongPoolInterface.sol";\n', 'import "./sbVotesInterface.sol";\n', '\n', 'contract sbControllerV3 {\n', '    event CommunityAdded(address indexed community);\n', '    event RewardsReleased(\n', '        address indexed receiver,\n', '        uint256 amount,\n', '        uint256 indexed day\n', '    );\n', '\n', '    using SafeMath for uint256;\n', '\n', '    bool internal initDone;\n', '\n', '    address internal sbTimelock;\n', '    IERC20 internal strongToken;\n', '    sbTokensInterface internal sbTokens;\n', '    sbStrongPoolInterface internal sbStrongPool;\n', '    sbVotesInterface internal sbVotes;\n', '    uint256 internal startDay;\n', '\n', '    mapping(uint256 => uint256) internal COMMUNITY_DAILY_REWARDS_BY_YEAR;\n', '    mapping(uint256 => uint256) internal STRONGPOOL_DAILY_REWARDS_BY_YEAR;\n', '    mapping(uint256 => uint256) internal VOTER_DAILY_REWARDS_BY_YEAR;\n', '    uint256 internal MAX_YEARS;\n', '\n', '    address[] internal communities;\n', '\n', '    mapping(uint256 => uint256) internal dayMineSecondsUSDTotal;\n', '    mapping(address => mapping(uint256 => uint256))\n', '        internal communityDayMineSecondsUSD;\n', '    mapping(address => mapping(uint256 => uint256))\n', '        internal communityDayRewards;\n', '    mapping(address => uint256) internal communityDayStart;\n', '    uint256 internal dayLastReleasedRewardsFor;\n', '\n', '    address internal superAdmin;\n', '    address internal pendingSuperAdmin;\n', '\n', '    function removeTokens(address account, uint256 amount) public {\n', '        require(msg.sender == superAdmin, "not superAdmin");\n', '        strongToken.transfer(account, amount);\n', '    }\n', '\n', '    function setPendingSuperAdmin(address newPendingSuperAdmin) public {\n', '        require(\n', '            msg.sender == superAdmin && msg.sender != address(0),\n', '            "not superAdmin"\n', '        );\n', '        pendingSuperAdmin = newPendingSuperAdmin;\n', '    }\n', '\n', '    function acceptSuperAdmin() public {\n', '        require(\n', '            msg.sender == pendingSuperAdmin && msg.sender != address(0),\n', '            "not pendingSuperAdmin"\n', '        );\n', '        superAdmin = pendingSuperAdmin;\n', '        pendingSuperAdmin = address(0);\n', '    }\n', '\n', '    function getSuperAdminAddressUsed() public view returns (address) {\n', '        return superAdmin;\n', '    }\n', '\n', '    function getPendingSuperAdminAddressUsed() public view returns (address) {\n', '        return pendingSuperAdmin;\n', '    }\n', '\n', '    function updateCommunityDailyRewardsByYear(uint256 amount) public {\n', '        require(\n', '            msg.sender == superAdmin && msg.sender != address(0),\n', '            "not superAdmin"\n', '        );\n', '        uint256 year = _getYearDayIsIn(_getCurrentDay());\n', '        require(year <= MAX_YEARS, "invalid year");\n', '        COMMUNITY_DAILY_REWARDS_BY_YEAR[year] = amount;\n', '    }\n', '\n', '    function updateStrongPoolDailyRewardsByYear(uint256 amount) public {\n', '        require(\n', '            msg.sender == superAdmin && msg.sender != address(0),\n', '            "not superAdmin"\n', '        );\n', '        uint256 year = _getYearDayIsIn(_getCurrentDay());\n', '        require(year <= MAX_YEARS, "invalid year");\n', '        STRONGPOOL_DAILY_REWARDS_BY_YEAR[year] = amount;\n', '    }\n', '\n', '    function updateVoterDailyRewardsByYear(uint256 amount) public {\n', '        require(\n', '            msg.sender == superAdmin && msg.sender != address(0),\n', '            "not superAdmin"\n', '        );\n', '        uint256 year = _getYearDayIsIn(_getCurrentDay());\n', '        require(year <= MAX_YEARS, "invalid year");\n', '        VOTER_DAILY_REWARDS_BY_YEAR[year] = amount;\n', '    }\n', '\n', '    function upToDate() external pure returns (bool) {\n', '        return true;\n', '        // return dayLastReleasedRewardsFor == _getCurrentDay().sub(1);\n', '    }\n', '\n', '    function addCommunity(address community) external {\n', '        require(msg.sender == sbTimelock, "not sbTimelock");\n', '        require(community != address(0), "community not zero address");\n', '        require(!_communityExists(community), "community exists");\n', '        communities.push(community);\n', '        communityDayStart[community] = _getCurrentDay();\n', '        emit CommunityAdded(community);\n', '    }\n', '\n', '    function getCommunities() external view returns (address[] memory) {\n', '        return communities;\n', '    }\n', '\n', '    function getDayMineSecondsUSDTotal(uint256 day)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', "        // require(day >= startDay, '1: invalid day');\n", "        // require(day <= dayLastReleasedRewardsFor, '2: invalid day');\n", '        return dayMineSecondsUSDTotal[day];\n', '    }\n', '\n', '    function getCommunityDayMineSecondsUSD(address community, uint256 day)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(_communityExists(community), "invalid community");\n', "        // require(day >= communityDayStart[community], '1: invalid day');\n", "        // require(day <= dayLastReleasedRewardsFor, '2: invalid day');\n", '        return communityDayMineSecondsUSD[community][day];\n', '    }\n', '\n', '    function getCommunityDayRewards(address community, uint256 day)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(_communityExists(community), "invalid community");\n', "        // require(day >= communityDayStart[community], '1: invalid day');\n", "        // require(day <= dayLastReleasedRewardsFor, '2: invalid day');\n", '        return communityDayRewards[community][day];\n', '    }\n', '\n', '    function getCommunityDailyRewards(uint256 day)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(day >= startDay, "invalid day");\n', '        uint256 year = _getYearDayIsIn(day);\n', '        require(year <= MAX_YEARS, "invalid year");\n', '        return COMMUNITY_DAILY_REWARDS_BY_YEAR[year];\n', '    }\n', '\n', '    function getStrongPoolDailyRewards(uint256 day)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(day >= startDay, "invalid day");\n', '        uint256 year = _getYearDayIsIn(day);\n', '        require(year <= MAX_YEARS, "invalid year");\n', '        return STRONGPOOL_DAILY_REWARDS_BY_YEAR[year];\n', '    }\n', '\n', '    function getVoterDailyRewards(uint256 day) external view returns (uint256) {\n', '        require(day >= startDay, "invalid day");\n', '        uint256 year = _getYearDayIsIn(day);\n', '        require(year <= MAX_YEARS, "invalid year");\n', '        return VOTER_DAILY_REWARDS_BY_YEAR[year];\n', '    }\n', '\n', '    function getStartDay() external view returns (uint256) {\n', '        return startDay;\n', '    }\n', '\n', '    function communityAccepted(address community) external view returns (bool) {\n', '        return _communityExists(community);\n', '    }\n', '\n', '    function getMaxYears() public view returns (uint256) {\n', '        return MAX_YEARS;\n', '    }\n', '\n', '    function getCommunityDayStart(address community)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(_communityExists(community), "invalid community");\n', '        return communityDayStart[community];\n', '    }\n', '\n', '    function getSbTimelockAddressUsed() public view returns (address) {\n', '        return sbTimelock;\n', '    }\n', '\n', '    function getStrongAddressUsed() public view returns (address) {\n', '        return address(strongToken);\n', '    }\n', '\n', '    function getSbTokensAddressUsed() public view returns (address) {\n', '        return address(sbTokens);\n', '    }\n', '\n', '    function getSbStrongPoolAddressUsed() public view returns (address) {\n', '        return address(sbStrongPool);\n', '    }\n', '\n', '    function getSbVotesAddressUsed() public view returns (address) {\n', '        return address(sbVotes);\n', '    }\n', '\n', '    function getCurrentYear() public view returns (uint256) {\n', '        uint256 day = _getCurrentDay().sub(startDay);\n', '        return _getYearDayIsIn(day == 0 ? startDay : day);\n', '    }\n', '\n', '    function getYearDayIsIn(uint256 day) public view returns (uint256) {\n', '        require(day >= startDay, "invalid day");\n', '        return _getYearDayIsIn(day);\n', '    }\n', '\n', '    function getCurrentDay() public view returns (uint256) {\n', '        return _getCurrentDay();\n', '    }\n', '\n', '    function getDayLastReleasedRewardsFor() public view returns (uint256) {\n', '        return dayLastReleasedRewardsFor;\n', '    }\n', '\n', '    // function releaseRewards() public {\n', '    // uint256 currentDay = _getCurrentDay();\n', "    // require(currentDay > dayLastReleasedRewardsFor.add(1), 'already released');\n", "    // require(sbTokens.upToDate(), 'need token prices');\n", '    // dayLastReleasedRewardsFor = dayLastReleasedRewardsFor.add(1);\n', '    // uint256 year = _getYearDayIsIn(dayLastReleasedRewardsFor);\n', "    // require(year <= MAX_YEARS, 'invalid year');\n", '    // address[] memory tokenAddresses = sbTokens.getTokens();\n', '    // uint256[] memory tokenPrices = sbTokens.getTokenPrices(dayLastReleasedRewardsFor);\n', '    // for (uint256 i = 0; i < communities.length; i++) {\n', '    //   address community = communities[i];\n', '    //   uint256 sum = 0;\n', '    //   for (uint256 j = 0; j < tokenAddresses.length; j++) {\n', '    //     address token = tokenAddresses[j];\n', '    //     (, , uint256 minedSeconds) = sbCommunityInterface(community).getTokenData(token, dayLastReleasedRewardsFor);\n', '    //     uint256 tokenPrice = tokenPrices[j];\n', '    //     uint256 minedSecondsUSD = tokenPrice.mul(minedSeconds).div(1e18);\n', '    //     sum = sum.add(minedSecondsUSD);\n', '    //   }\n', '    //   communityDayMineSecondsUSD[community][dayLastReleasedRewardsFor] = sum;\n', '    //   dayMineSecondsUSDTotal[dayLastReleasedRewardsFor] = dayMineSecondsUSDTotal[dayLastReleasedRewardsFor].add(sum);\n', '    // }\n', '    // for (uint256 i = 0; i < communities.length; i++) {\n', '    //   address community = communities[i];\n', '    //   if (communityDayMineSecondsUSD[community][dayLastReleasedRewardsFor] == 0) {\n', '    //     continue;\n', '    //   }\n', '    //   communityDayRewards[community][dayLastReleasedRewardsFor] = communityDayMineSecondsUSD[community][dayLastReleasedRewardsFor]\n', '    //     .mul(COMMUNITY_DAILY_REWARDS_BY_YEAR[year])\n', '    //     .div(dayMineSecondsUSDTotal[dayLastReleasedRewardsFor]);\n', '\n', '    //   uint256 amount = communityDayRewards[community][dayLastReleasedRewardsFor];\n', '    //   strongToken.approve(community, amount);\n', '    //   sbCommunityInterface(community).receiveRewards(dayLastReleasedRewardsFor, amount);\n', '    //   emit RewardsReleased(community, amount, currentDay);\n', '    // }\n', '    // (, , uint256 strongPoolMineSeconds) = sbStrongPool.getMineData(dayLastReleasedRewardsFor);\n', '    // if (strongPoolMineSeconds != 0) {\n', '    //   strongToken.approve(address(sbStrongPool), STRONGPOOL_DAILY_REWARDS_BY_YEAR[year]);\n', '    //   sbStrongPool.receiveRewards(dayLastReleasedRewardsFor, STRONGPOOL_DAILY_REWARDS_BY_YEAR[year]);\n', '    //   emit RewardsReleased(address(sbStrongPool), STRONGPOOL_DAILY_REWARDS_BY_YEAR[year], currentDay);\n', '    // }\n', '    // bool hasVoteSeconds = false;\n', '    // for (uint256 i = 0; i < communities.length; i++) {\n', '    //   address community = communities[i];\n', '    //   (, , uint256 voteSeconds) = sbVotes.getCommunityData(community, dayLastReleasedRewardsFor);\n', '    //   if (voteSeconds > 0) {\n', '    //     hasVoteSeconds = true;\n', '    //     break;\n', '    //   }\n', '    // }\n', '    // if (hasVoteSeconds) {\n', '    //   strongToken.approve(address(sbVotes), VOTER_DAILY_REWARDS_BY_YEAR[year]);\n', '    //   sbVotes.receiveVoterRewards(dayLastReleasedRewardsFor, VOTER_DAILY_REWARDS_BY_YEAR[year]);\n', '    //   emit RewardsReleased(address(sbVotes), VOTER_DAILY_REWARDS_BY_YEAR[year], currentDay);\n', '    // }\n', '    // }\n', '\n', '    function _getCurrentDay() internal view returns (uint256) {\n', '        return block.timestamp.div(1 days).add(1);\n', '    }\n', '\n', '    function _communityExists(address community) internal view returns (bool) {\n', '        for (uint256 i = 0; i < communities.length; i++) {\n', '            if (communities[i] == community) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function _getYearDayIsIn(uint256 day) internal view returns (uint256) {\n', '        return day.sub(startDay).div(366).add(1); // dividing by 366 makes day 1 and 365 be in year 1\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface sbCommunityInterface {\n', '  function getTokenData(address token, uint256 day)\n', '    external\n', '    view\n', '    returns (\n', '      uint256,\n', '      uint256,\n', '      uint256\n', '    );\n', '\n', '  function receiveRewards(uint256 day, uint256 amount) external;\n', '\n', '  function serviceAccepted(address service) external view returns (bool);\n', '\n', '  function getMinerRewardPercentage() external view returns (uint256);\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface sbTokensInterface {\n', '  function getTokens() external view returns (address[] memory);\n', '\n', '  function getTokenPrices(uint256 day) external view returns (uint256[] memory);\n', '\n', '  function tokenAccepted(address token) external view returns (bool);\n', '\n', '  function upToDate() external view returns (bool);\n', '\n', '  function getTokenPrice(address token, uint256 day) external view returns (uint256);\n', '}\n']
