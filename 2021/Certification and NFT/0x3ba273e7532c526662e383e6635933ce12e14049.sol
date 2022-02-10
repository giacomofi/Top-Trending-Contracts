['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-23\n', '*/\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/TokenPool.sol\n', '\n', 'pragma solidity 0.5.0;\n', '\n', '\n', 'contract TokenPool {\n', '    IERC20 public token;\n', '\n', '    address public _owner;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    constructor(IERC20 _token) public {\n', '        token = _token;\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    function balance() public view returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    function transfer(address to, uint256 value) external onlyOwner returns (bool) {\n', '        return token.transfer(to, value);\n', '    }\n', '\n', '    function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {\n', "        require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');\n", '\n', '        return IERC20(tokenToRescue).transfer(to, amount);\n', '    }\n', '}\n', '\n', '// File: contracts/TokenGeyser.sol\n', '\n', 'pragma solidity 0.5.0;\n', '\n', '\n', '\n', '\n', 'contract TokenGeyser {\n', '    using SafeMath for uint256;\n', '\n', '    event Staked(address indexed user, uint256 amount, uint256 total, bytes data);\n', '    event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);\n', '    event TokensClaimed(address indexed user, uint256 amount);\n', '    event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);\n', '    event TokensAdded(uint256 amount, uint256 total);\n', '    event TokensUnlocked(uint256 amount, uint256 total);\n', '\n', '    TokenPool private _stakingPool;\n', '    TokenPool private _unlockedPool;\n', '    TokenPool private _lockedPool;\n', '\n', '    //\n', '    // Time-bonus params\n', '    //\n', '    uint256 public startBonus = 0;\n', '    uint256 public bonusPeriodSec = 0;\n', '\n', '    //\n', '    // Global accounting state\n', '    //\n', '    uint256 public totalLockedTokens = 0;\n', '    uint256 public totalStakingTokens = 0;\n', '    uint256 private _totalStakingTokensSeconds = 0;\n', '    uint256 private _lastAccountingTimestampSec = now;\n', '\n', '    //\n', '    // User accounting state\n', '    //\n', '    // Represents a single stake for a user. A user may have multiple.\n', '    struct Stake {\n', '        uint256 stakingTokens;\n', '        uint256 timestampSec;\n', '    }\n', '\n', '    // Caches aggregated values from the User->Stake[] map to save computation.\n', "    // If lastAccountingTimestampSec is 0, there's no entry for that user.\n", '    struct UserTotals {\n', '        uint256 stakingTokens;\n', '        uint256 stakingTokensSeconds;\n', '        uint256 lastAccountingTimestampSec;\n', '    }\n', '\n', '    // Aggregated staking values per user\n', '    mapping(address => UserTotals) private _userTotals;\n', '\n', '    // The collection of stakes for each user. Ordered by timestamp, earliest to latest.\n', '    mapping(address => Stake[]) private _userStakes;\n', '\n', '    //\n', '    // Locked/Unlocked Accounting state\n', '    //\n', '    struct UnlockSchedule {\n', '        uint256 initialLockedTokens;\n', '        uint256 unlockedTokens;\n', '        uint256 lastUnlockTimestampSec;\n', '        uint256 endAtSec;\n', '        uint256 durationSec;\n', '    }\n', '\n', '    UnlockSchedule[] public unlockSchedules;\n', '\n', '    address public _owner;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 _startBonus, uint256 _bonusPeriod) public {\n', '        _stakingPool = new TokenPool(stakingToken);\n', '        _unlockedPool = new TokenPool(distributionToken);\n', '        _lockedPool = new TokenPool(distributionToken);\n', '        startBonus = _startBonus; //33;\n', '        bonusPeriodSec = _bonusPeriod; //5184000; // 60 days\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    function getStakingToken() public view returns (IERC20) {\n', '        return _stakingPool.token();\n', '    }\n', '\n', '    function getDistributionToken() public view returns (IERC20) {\n', '        return _unlockedPool.token();\n', '    }\n', '\n', '    function stake(uint256 amount, bytes calldata data) external {\n', '        _stakeFor(msg.sender, msg.sender, amount);\n', '    }\n', '\n', '    function _stakeFor(address staker, address beneficiary, uint256 amount) private {\n', "        require(amount > 0, 'TokenGeyser: stake amount is zero');\n", "        require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');\n", '        require(totalStakingTokens == 0 || totalStaked() > 0,\n', "                'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');\n", '\n', "        require(amount > 0, 'TokenGeyser: Stake amount is too small');\n", '\n', '        updateAccounting();\n', '\n', '        // 1. User Accounting\n', '        UserTotals storage totals = _userTotals[beneficiary];\n', '        totals.stakingTokens = totals.stakingTokens.add(amount);\n', '        totals.lastAccountingTimestampSec = now;\n', '\n', '        Stake memory newStake = Stake(amount, now);\n', '        _userStakes[beneficiary].push(newStake);\n', '\n', '        // 2. Global Accounting\n', '        totalStakingTokens = totalStakingTokens.add(amount);\n', '\n', '        // interactions\n', '        require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),\n', "            'TokenGeyser: transfer into staking pool failed');\n", '\n', '        emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");\n', '    }\n', '\n', '    function unstake(uint256 amount, bytes calldata data) external {\n', '        _unstake(amount);\n', '    }\n', '\n', '    function unstakeQuery(uint256 amount) public returns (uint256) {\n', '        return _unstake(amount);\n', '    }\n', '\n', '    function _unstake(uint256 amount) private returns (uint256) {\n', '        updateAccounting();\n', '        // checks\n', "        require(amount > 0, 'TokenGeyser: unstake amount is zero');\n", '        require(totalStakedFor(msg.sender) >= amount,\n', "            'TokenGeyser: unstake amount is greater than total user stakes');\n", '\n', '        // 1. User Accounting\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '        Stake[] storage accountStakes = _userStakes[msg.sender];\n', '\n', '        // Redeem from most recent stake and go backwards in time.\n', '        uint256 stakingTokensSecondsToBurn = 0;\n', '        uint256 sharesLeftToBurn = amount;\n', '        uint256 rewardAmount = 0;\n', '        while (sharesLeftToBurn > 0) {\n', '            Stake storage lastStake = accountStakes[accountStakes.length - 1];\n', '            uint256 stakeTimeSec = now.sub(lastStake.timestampSec);\n', '            uint256 newstakingTokensSecondsToBurn = 0;\n', '            if (lastStake.stakingTokens <= sharesLeftToBurn) {\n', '                // fully redeem a past stake\n', '                newstakingTokensSecondsToBurn = lastStake.stakingTokens.mul(stakeTimeSec);\n', '                rewardAmount = computeNewReward(rewardAmount, newstakingTokensSecondsToBurn, stakeTimeSec);\n', '                stakingTokensSecondsToBurn = stakingTokensSecondsToBurn.add(newstakingTokensSecondsToBurn);\n', '                sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingTokens);\n', '                accountStakes.length--;\n', '            } else {\n', '                // partially redeem a past stake\n', '                newstakingTokensSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);\n', '                rewardAmount = computeNewReward(rewardAmount, newstakingTokensSecondsToBurn, stakeTimeSec);\n', '                stakingTokensSecondsToBurn = stakingTokensSecondsToBurn.add(newstakingTokensSecondsToBurn);\n', '                lastStake.stakingTokens = lastStake.stakingTokens.sub(sharesLeftToBurn);\n', '                sharesLeftToBurn = 0;\n', '            }\n', '        }\n', '        totals.stakingTokensSeconds = totals.stakingTokensSeconds.sub(stakingTokensSecondsToBurn);\n', '        totals.stakingTokens = totals.stakingTokens.sub(amount);\n', '\n', '        // 2. Global Accounting\n', '        _totalStakingTokensSeconds = _totalStakingTokensSeconds.sub(stakingTokensSecondsToBurn);\n', '        totalStakingTokens = totalStakingTokens.sub(amount);\n', '\n', '        // unlock 99% only, leave 1% locked as a liquidity tax\n', '        uint256 amountMinusTax = amount.mul(99).div(100);\n', '        uint256 amountTax = amount.sub(amountMinusTax);\n', '        // interactions\n', '        require(_stakingPool.transfer(msg.sender, amountMinusTax),\n', "            'TokenGeyser: transfer out of staking pool failed');\n", '        require(_stakingPool.transfer(address(this), amountTax),\n', "            'TokenGeyser: transfer out of staking pool failed');\n", '        require(_unlockedPool.transfer(msg.sender, rewardAmount),\n', "            'TokenGeyser: transfer out of unlocked pool failed');\n", '\n', '        emit Unstaked(msg.sender, amountMinusTax, totalStakedFor(msg.sender), "");\n', '        emit TokensClaimed(msg.sender, rewardAmount);\n', '\n', '        require(totalStakingTokens == 0 || totalStaked() > 0,\n', '                "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");\n', '        return rewardAmount;\n', '    }\n', '\n', '    function computeNewReward(uint256 currentRewardTokens, uint256 stakingTokensSeconds, uint256 stakeTimeSec) private view returns (uint256) {\n', '\n', '        uint256 newRewardTokens = totalUnlocked().mul(stakingTokensSeconds).div(_totalStakingTokensSeconds);\n', '\n', '        if (stakeTimeSec >= bonusPeriodSec) {\n', '            return currentRewardTokens.add(newRewardTokens);\n', '        }\n', '\n', '        uint256 oneHundredPct = 100;\n', '        uint256 bonusedReward =\n', '            startBonus\n', '            .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))\n', '            .mul(newRewardTokens)\n', '            .div(oneHundredPct);\n', '        return currentRewardTokens.add(bonusedReward);\n', '    }\n', '\n', '    function totalStakedFor(address addr) public view returns (uint256) {\n', '        return totalStakingTokens > 0 ?\n', '            totalStaked().mul(_userTotals[addr].stakingTokens).div(totalStakingTokens) : 0;\n', '    }\n', '\n', '    function totalStaked() public view returns (uint256) {\n', '        return _stakingPool.balance();\n', '    }\n', '\n', '    function token() external view returns (address) {\n', '        return address(getStakingToken());\n', '    }\n', '\n', '    function updateAccounting() public returns (uint256, uint256, uint256, uint256, uint256, uint256) {\n', '\n', '        unlockTokens();\n', '\n', '        // Global accounting\n', '        uint256 newstakingTokensSeconds =\n', '            now\n', '            .sub(_lastAccountingTimestampSec)\n', '            .mul(totalStakingTokens);\n', '        _totalStakingTokensSeconds = _totalStakingTokensSeconds.add(newstakingTokensSeconds);\n', '        _lastAccountingTimestampSec = now;\n', '\n', '        // User Accounting\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '        uint256 newUserstakingTokensSeconds =\n', '            now\n', '            .sub(totals.lastAccountingTimestampSec)\n', '            .mul(totals.stakingTokens);\n', '        totals.stakingTokensSeconds =\n', '            totals.stakingTokensSeconds\n', '            .add(newUserstakingTokensSeconds);\n', '        totals.lastAccountingTimestampSec = now;\n', '\n', '        uint256 totalUserRewards = (_totalStakingTokensSeconds > 0)\n', '            ? totalUnlocked().mul(totals.stakingTokensSeconds).div(_totalStakingTokensSeconds)\n', '            : 0;\n', '\n', '        return (\n', '            totalLocked(),\n', '            totalUnlocked(),\n', '            totals.stakingTokensSeconds,\n', '            _totalStakingTokensSeconds,\n', '            totalUserRewards,\n', '            now\n', '        );\n', '    }\n', '\n', '    function totalLocked() public view returns (uint256) {\n', '        return _lockedPool.balance();\n', '    }\n', '\n', '    function totalUnlocked() public view returns (uint256) {\n', '        return _unlockedPool.balance();\n', '    }\n', '\n', '    function unlockScheduleCount() public view returns (uint256) {\n', '        return unlockSchedules.length;\n', '    }\n', '\n', '    function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {\n', '        // Update lockedTokens amount before using it in computations after.\n', '        updateAccounting();\n', '\n', '        uint256 lockedTokens = totalLocked();\n', '\n', '        UnlockSchedule memory schedule;\n', '        schedule.initialLockedTokens = amount;\n', '        schedule.lastUnlockTimestampSec = now;\n', '        schedule.endAtSec = now.add(durationSec);\n', '        schedule.durationSec = durationSec;\n', '        unlockSchedules.push(schedule);\n', '\n', '        totalLockedTokens = lockedTokens.add(amount);\n', '\n', '        require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),\n', "            'TokenGeyser: transfer into locked pool failed');\n", '        emit TokensLocked(amount, durationSec, totalLocked());\n', '    }\n', '\n', '    function addTokens(uint256 amount) external {\n', '        UnlockSchedule storage schedule = unlockSchedules[unlockSchedules.length - 1];\n', '\n', "        // if we don't have an active schedule, create one\n", '        if(schedule.endAtSec < now){\n', '          uint256 lockedTokens = totalLocked();\n', '\n', '          UnlockSchedule memory schedule;\n', '          schedule.initialLockedTokens = amount;\n', '          schedule.lastUnlockTimestampSec = now;\n', '          schedule.endAtSec = now.add(60 * 60 * 24 * 135);\n', '          schedule.durationSec = 60 * 60 * 24 * 135;\n', '          unlockSchedules.push(schedule);\n', '\n', '          totalLockedTokens = lockedTokens.add(amount);\n', '\n', '          require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),\n', "              'TokenGeyser: transfer into locked pool failed');\n", '          emit TokensLocked(amount, 60 * 60 * 24 * 135, totalLocked());\n', '        } else {\n', '          // normalize the amount weight to offset lost time\n', '          uint256 mintedLockedShares = amount.mul(schedule.durationSec.div(schedule.endAtSec.sub(now)));\n', '          schedule.initialLockedTokens = schedule.initialLockedTokens.add(mintedLockedShares);\n', '\n', '          uint256 balanceBefore = _lockedPool.token().balanceOf(address(_lockedPool));\n', '          require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),\n', "              'TokenGeyser: transfer into locked pool failed');\n", '          uint256 balanceAfter = _lockedPool.token().balanceOf(address(_lockedPool));\n', '\n', '          totalLockedTokens = totalLockedTokens.add(balanceAfter.sub(balanceBefore));\n', '          emit TokensAdded(balanceAfter.sub(balanceBefore), totalLocked());\n', '        }\n', '\n', '    }\n', '\n', '    function unlockTokens() public returns (uint256) {\n', '        uint256 unlockedTokens = 0;\n', '\n', '        if (totalLockedTokens == 0) {\n', '            unlockedTokens = totalLocked();\n', '        } else {\n', '            for (uint256 s = 0; s < unlockSchedules.length; s++) {\n', '                unlockedTokens = unlockedTokens.add(unlockScheduleShares(s));\n', '            }\n', '            totalLockedTokens = totalLockedTokens.sub(unlockedTokens);\n', '        }\n', '\n', '        if (unlockedTokens > 0) {\n', '            require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),\n', "                'TokenGeyser: transfer out of locked pool failed');\n", '            emit TokensUnlocked(unlockedTokens, totalLocked());\n', '        }\n', '\n', '        return unlockedTokens;\n', '    }\n', '\n', '    function unlockScheduleShares(uint256 s) private returns (uint256) {\n', '        UnlockSchedule storage schedule = unlockSchedules[s];\n', '\n', '        if(schedule.unlockedTokens >= schedule.initialLockedTokens) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 sharesToUnlock = 0;\n', '        // Special case to handle any leftover dust from integer division\n', '        if (now >= schedule.endAtSec) {\n', '            sharesToUnlock = (schedule.initialLockedTokens.sub(schedule.unlockedTokens));\n', '            schedule.lastUnlockTimestampSec = schedule.endAtSec;\n', '        } else {\n', '            sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)\n', '                .mul(schedule.initialLockedTokens)\n', '                .div(schedule.durationSec);\n', '            schedule.lastUnlockTimestampSec = now;\n', '        }\n', '\n', '        schedule.unlockedTokens = schedule.unlockedTokens.add(sharesToUnlock);\n', '        return sharesToUnlock;\n', '    }\n', '\n', '    function rescueFundsFromStakingPool(address tokenToRescue, address to, uint256 amount) public onlyOwner returns (bool) {\n', '        return _stakingPool.rescueFunds(tokenToRescue, to, amount);\n', '    }\n', '}']