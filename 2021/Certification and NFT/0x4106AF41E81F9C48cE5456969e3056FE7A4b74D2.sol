['pragma solidity 0.7.5;\n', '\n', '/**\n', ' * @title Staking interface, as defined by EIP-900.\n', ' * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md\n', ' */\n', 'interface IStaking {\n', '    event Staked(address indexed user, uint256 amount, uint256 total, bytes data);\n', '    event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);\n', '\n', '    function stake(uint256 amount) external;\n', '    function stakeFor(address user, uint256 amount) external;\n', '    function unstake(uint256 amount) external;\n', '    function totalStakedFor(address addr) external view returns (uint256);\n', '    function totalStaked() external view returns (uint256);\n', '    function token() external view returns (address);\n', '}\n', '\n', 'pragma solidity 0.7.5;\n', '\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', '\n', 'import "./IStaking.sol";\n', 'import "./TokenPool.sol";\n', '\n', '/**\n', ' * @title Token Geyser\n', ' * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by\n', ' *      Compound and Uniswap.\n', ' *\n', ' *      Distribution tokens are added to a locked pool in the contract and become unlocked over time\n', ' *      according to a once-configurable unlock schedule. Once unlocked, they are available to be\n', ' *      claimed by users.\n', ' *\n', ' *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share\n', ' *      is a function of the number of tokens deposited as well as the length of time deposited.\n', ' *      Specifically, a user\'s share of the currently-unlocked pool equals their "deposit-seconds"\n', ' *      divided by the global "deposit-seconds". This aligns the new token distribution with long\n', ' *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.\n', ' */\n', 'contract TokenGeyser is IStaking, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event TokensClaimed(address indexed user, uint256 amount);\n', '    event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);\n', '    // amount: Unlocked tokens, total: Total locked tokens\n', '    event TokensUnlocked(uint256 amount, uint256 total);\n', '\n', '    TokenPool private _stakingPool;\n', '    TokenPool private _unlockedPool;\n', '    TokenPool private _lockedPool;\n', '\n', '    //\n', '    // Time-bonus params\n', '    //\n', '    uint256 public constant BONUS_DECIMALS = 2;\n', '    uint256 public startBonus;\n', '    uint256 public bonusPeriodSec;\n', '\n', '    //\n', '    // Global accounting state\n', '    //\n', '    uint256 public totalLockedShares;\n', '    uint256 public totalStakingShares;\n', '    uint256 private _totalStakingShareSeconds;\n', '    uint256 private _lastAccountingTimestampSec;\n', '    uint256 private _maxUnlockSchedules;\n', '    uint256 private _initialSharesPerToken;\n', '\n', '    //\n', '    // User accounting state\n', '    //\n', '    // Represents a single stake for a user. A user may have multiple.\n', '    struct Stake {\n', '        uint256 stakingShares;\n', '        uint256 timestampSec;\n', '    }\n', '\n', '    // Caches aggregated values from the User->Stake[] map to save computation.\n', "    // If lastAccountingTimestampSec is 0, there's no entry for that user.\n", '    struct UserTotals {\n', '        uint256 stakingShares;\n', '        uint256 stakingShareSeconds;\n', '        uint256 lastAccountingTimestampSec;\n', '    }\n', '\n', '    // Aggregated staking values per user\n', '    mapping(address => UserTotals) private _userTotals;\n', '\n', '    // The collection of stakes for each user. Ordered by timestamp, earliest to latest.\n', '    mapping(address => Stake[]) private _userStakes;\n', '\n', '    //\n', '    // Locked/Unlocked Accounting state\n', '    //\n', '    struct UnlockSchedule {\n', '        uint256 initialLockedShares;\n', '        uint256 unlockedShares;\n', '        uint256 lastUnlockTimestampSec;\n', '        uint256 endAtSec;\n', '        uint256 durationSec;\n', '    }\n', '\n', '    UnlockSchedule[] public unlockSchedules;\n', '\n', '    /**\n', '     * @param stakingToken The token users deposit as stake.\n', '     * @param distributionToken The token users receive as they unstake.\n', '     * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.\n', '     * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.\n', '     *                    e.g. 25% means user gets 25% of max distribution tokens.\n', '     * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.\n', '     * @param initialSharesPerToken Number of shares to mint per staking token on first stake.\n', '     */\n', '    constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,\n', '                uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {\n', '        // The start bonus must be some fraction of the max. (i.e. <= 100%)\n', "        require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenGeyser: start bonus too high');\n", '        // If no period is desired, instead set startBonus = 100%\n', '        // and bonusPeriod to a small value like 1sec.\n', "        require(bonusPeriodSec_ != 0, 'TokenGeyser: bonus period is zero');\n", "        require(initialSharesPerToken > 0, 'TokenGeyser: initialSharesPerToken is zero');\n", '\n', '        _stakingPool = new TokenPool(stakingToken);\n', '        _unlockedPool = new TokenPool(distributionToken);\n', '        _lockedPool = new TokenPool(distributionToken);\n', '        startBonus = startBonus_;\n', '        bonusPeriodSec = bonusPeriodSec_;\n', '        _maxUnlockSchedules = maxUnlockSchedules;\n', '        _initialSharesPerToken = initialSharesPerToken;\n', '        _lastAccountingTimestampSec = block.timestamp;\n', '    }\n', '\n', '    /**\n', '     * @return The token users deposit as stake.\n', '     */\n', '    function getStakingToken() public view returns (IERC20) {\n', '        return _stakingPool.token();\n', '    }\n', '\n', '    /**\n', '     * @return The token users receive as they unstake.\n', '     */\n', '    function getDistributionToken() public view returns (IERC20) {\n', '        assert(_unlockedPool.token() == _lockedPool.token());\n', '        return _unlockedPool.token();\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers amount of deposit tokens from the user.\n', '     * @param amount Number of deposit tokens to stake.\n', '     */\n', '    function stake(uint256 amount) external override {\n', '        _stakeFor(msg.sender, msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers amount of deposit tokens from the caller on behalf of user.\n', '     * @param user User address who gains credit for this stake operation.\n', '     * @param amount Number of deposit tokens to stake.\n', '     */\n', '    function stakeFor(address user, uint256 amount) external override onlyOwner {\n', '        _stakeFor(msg.sender, user, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Private implementation of staking methods.\n', '     * @param staker User address who deposits tokens to stake.\n', '     * @param beneficiary User address who gains credit for this stake operation.\n', '     * @param amount Number of deposit tokens to stake.\n', '     */\n', '    function _stakeFor(address staker, address beneficiary, uint256 amount) private {\n', "        require(amount > 0, 'TokenGeyser: stake amount is zero');\n", "        require(beneficiary != address(0), 'TokenGeyser: beneficiary is zero address');\n", '        require(totalStakingShares == 0 || totalStaked() > 0,\n', "                'TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do');\n", '\n', '        uint256 mintedStakingShares = (totalStakingShares > 0)\n', '            ? totalStakingShares.mul(amount).div(totalStaked())\n', '            : amount.mul(_initialSharesPerToken);\n', "        require(mintedStakingShares > 0, 'TokenGeyser: Stake amount is too small');\n", '\n', '        updateAccounting();\n', '\n', '        // 1. User Accounting\n', '        UserTotals storage totals = _userTotals[beneficiary];\n', '        totals.stakingShares = totals.stakingShares.add(mintedStakingShares);\n', '        totals.lastAccountingTimestampSec = block.timestamp;\n', '\n', '        Stake memory newStake = Stake(mintedStakingShares, block.timestamp);\n', '        _userStakes[beneficiary].push(newStake);\n', '\n', '        // 2. Global Accounting\n', '        totalStakingShares = totalStakingShares.add(mintedStakingShares);\n', '        // Already set in updateAccounting()\n', '        // _lastAccountingTimestampSec = block.timestamp;\n', '\n', '        // interactions\n', '        require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),\n', "            'TokenGeyser: transfer into staking pool failed');\n", '\n', '        emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");\n', '    }\n', '\n', '    /**\n', '     * @dev Unstakes a certain amount of previously deposited tokens. User also receives their\n', '     * alotted number of distribution tokens.\n', '     * @param amount Number of deposit tokens to unstake / withdraw.\n', '     */\n', '    function unstake(uint256 amount) external override {\n', '        _unstake(amount);\n', '    }\n', '\n', '    /**\n', '     * @param amount Number of deposit tokens to unstake / withdraw.\n', '     * @return The total number of distribution tokens that would be rewarded.\n', '     */\n', '    function unstakeQuery(uint256 amount) public returns (uint256) {\n', '        return _unstake(amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Unstakes a certain amount of previously deposited tokens. User also receives their\n', '     * alotted number of distribution tokens.\n', '     * @param amount Number of deposit tokens to unstake / withdraw.\n', '     * @return The total number of distribution tokens rewarded.\n', '     */\n', '    function _unstake(uint256 amount) private returns (uint256) {\n', '        updateAccounting();\n', '\n', '        // checks\n', "        require(amount > 0, 'TokenGeyser: unstake amount is zero');\n", '        require(totalStakedFor(msg.sender) >= amount,\n', "            'TokenGeyser: unstake amount is greater than total user stakes');\n", '        uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());\n', "        require(stakingSharesToBurn > 0, 'TokenGeyser: Unable to unstake amount this small');\n", '\n', '        // 1. User Accounting\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '        Stake[] storage accountStakes = _userStakes[msg.sender];\n', '\n', '        // Redeem from most recent stake and go backwards in time.\n', '        uint256 stakingShareSecondsToBurn = 0;\n', '        uint256 sharesLeftToBurn = stakingSharesToBurn;\n', '        uint256 rewardAmount = 0;\n', '        while (sharesLeftToBurn > 0) {\n', '            Stake storage lastStake = accountStakes[accountStakes.length - 1];\n', '            uint256 stakeTimeSec = block.timestamp.sub(lastStake.timestampSec);\n', '            uint256 newStakingShareSecondsToBurn = 0;\n', '            if (lastStake.stakingShares <= sharesLeftToBurn) {\n', '                // fully redeem a past stake\n', '                newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSec);\n', '                rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);\n', '                stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);\n', '                sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);\n', '                accountStakes.pop();\n', '            } else {\n', '                // partially redeem a past stake\n', '                newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);\n', '                rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSec);\n', '                stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);\n', '                lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);\n', '                sharesLeftToBurn = 0;\n', '            }\n', '        }\n', '        totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);\n', '        totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);\n', '        // Already set in updateAccounting\n', '        // totals.lastAccountingTimestampSec = block.timestamp;\n', '\n', '        // 2. Global Accounting\n', '        _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);\n', '        totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);\n', '        // Already set in updateAccounting\n', '        // _lastAccountingTimestampSec = block.timestamp;\n', '\n', '        // interactions\n', '        require(_stakingPool.transfer(msg.sender, amount),\n', "            'TokenGeyser: transfer out of staking pool failed');\n", '        require(_unlockedPool.transfer(msg.sender, rewardAmount),\n', "            'TokenGeyser: transfer out of unlocked pool failed');\n", '\n', '        emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");\n', '        emit TokensClaimed(msg.sender, rewardAmount);\n', '\n', '        require(totalStakingShares == 0 || totalStaked() > 0,\n', '                "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do");\n', '        return rewardAmount;\n', '    }\n', '\n', '    /**\n', '     * @dev Applies an additional time-bonus to a distribution amount. This is necessary to\n', '     *      encourage long-term deposits instead of constant unstake/restakes.\n', '     *      The bonus-multiplier is the result of a linear function that starts at startBonus and\n', '     *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.\n', '     * @param currentRewardTokens The current number of distribution tokens already alotted for this\n', '     *                            unstake op. Any bonuses are already applied.\n', '     * @param stakingShareSeconds The stakingShare-seconds that are being burned for new\n', '     *                            distribution tokens.\n', '     * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate\n', '     *                     the time-bonus.\n', '     * @return Updated amount of distribution tokens to award, with any bonus included on the\n', '     *         newly added tokens.\n', '     */\n', '    function computeNewReward(uint256 currentRewardTokens,\n', '                                uint256 stakingShareSeconds,\n', '                                uint256 stakeTimeSec) private view returns (uint256) {\n', '\n', '        uint256 newRewardTokens =\n', '            totalUnlocked()\n', '            .mul(stakingShareSeconds)\n', '            .div(_totalStakingShareSeconds);\n', '\n', '        if (stakeTimeSec >= bonusPeriodSec) {\n', '            return currentRewardTokens.add(newRewardTokens);\n', '        }\n', '\n', '        uint256 oneHundredPct = 10**BONUS_DECIMALS;\n', '        uint256 bonusedReward =\n', '            startBonus\n', '            .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))\n', '            .mul(newRewardTokens)\n', '            .div(oneHundredPct);\n', '        return currentRewardTokens.add(bonusedReward);\n', '    }\n', '\n', '    /**\n', '     * @param addr The user to look up staking information for.\n', '     * @return The number of staking tokens deposited for addr.\n', '     */\n', '    function totalStakedFor(address addr) public override view returns (uint256) {\n', '        return totalStakingShares > 0 ?\n', '            totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;\n', '    }\n', '\n', '    /**\n', '     * @return The total number of deposit tokens staked globally, by all users.\n', '     */\n', '    function totalStaked() public override view returns (uint256) {\n', '        return _stakingPool.balance();\n', '    }\n', '\n', '    /**\n', '     * @dev Note that this application has a staking token as well as a distribution token, which\n', '     * may be different. This function is required by EIP-900.\n', '     * @return The deposit token used for staking.\n', '     */\n', '    function token() external override view returns (address) {\n', '        return address(getStakingToken());\n', '    }\n', '\n', '    /**\n', '     * @dev A globally callable function to update the accounting state of the system.\n', '     *      Global state and state for the caller are updated.\n', '     * @return [0] balance of the locked pool\n', '     * @return [1] balance of the unlocked pool\n', "     * @return [2] caller's staking share seconds\n", '     * @return [3] global staking share seconds\n', '     * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.\n', '     * @return [5] block timestamp\n', '     */\n', '    function updateAccounting() public returns (\n', '        uint256, uint256, uint256, uint256, uint256, uint256) {\n', '\n', '        unlockTokens();\n', '\n', '        // Global accounting\n', '        uint256 newStakingShareSeconds =\n', '            block.timestamp\n', '            .sub(_lastAccountingTimestampSec)\n', '            .mul(totalStakingShares);\n', '        _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);\n', '        _lastAccountingTimestampSec = block.timestamp;\n', '\n', '        // User Accounting\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '        uint256 newUserStakingShareSeconds =\n', '            block.timestamp\n', '            .sub(totals.lastAccountingTimestampSec)\n', '            .mul(totals.stakingShares);\n', '        totals.stakingShareSeconds =\n', '            totals.stakingShareSeconds\n', '            .add(newUserStakingShareSeconds);\n', '        totals.lastAccountingTimestampSec = block.timestamp;\n', '\n', '        uint256 totalUserRewards = (_totalStakingShareSeconds > 0)\n', '            ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)\n', '            : 0;\n', '\n', '        return (\n', '            totalLocked(),\n', '            totalUnlocked(),\n', '            totals.stakingShareSeconds,\n', '            _totalStakingShareSeconds,\n', '            totalUserRewards,\n', '            block.timestamp\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @return Total number of locked distribution tokens.\n', '     */\n', '    function totalLocked() public view returns (uint256) {\n', '        return _lockedPool.balance();\n', '    }\n', '\n', '    /**\n', '     * @return Total number of unlocked distribution tokens.\n', '     */\n', '    function totalUnlocked() public view returns (uint256) {\n', '        return _unlockedPool.balance();\n', '    }\n', '\n', '    /**\n', '     * @return Number of unlock schedules.\n', '     */\n', '    function unlockScheduleCount() public view returns (uint256) {\n', '        return unlockSchedules.length;\n', '    }\n', '\n', '    /**\n', '     * @dev This funcion allows the contract owner to add more locked distribution tokens, along\n', '     *      with the associated "unlock schedule". These locked tokens immediately begin unlocking\n', '     *      linearly over the duraction of durationSec timeframe.\n', '     * @param amount Number of distribution tokens to lock. These are transferred from the caller.\n', '     * @param durationSec Length of time to linear unlock the tokens.\n', '     */\n', '    function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {\n', '        require(unlockSchedules.length < _maxUnlockSchedules,\n', "            'TokenGeyser: reached maximum unlock schedules');\n", '\n', '        // Update lockedTokens amount before using it in computations after.\n', '        updateAccounting();\n', '\n', '        uint256 lockedTokens = totalLocked();\n', '        uint256 mintedLockedShares = (lockedTokens > 0)\n', '            ? totalLockedShares.mul(amount).div(lockedTokens)\n', '            : amount.mul(_initialSharesPerToken);\n', '\n', '        UnlockSchedule memory schedule;\n', '        schedule.initialLockedShares = mintedLockedShares;\n', '        schedule.lastUnlockTimestampSec = block.timestamp;\n', '        schedule.endAtSec = block.timestamp.add(durationSec);\n', '        schedule.durationSec = durationSec;\n', '        unlockSchedules.push(schedule);\n', '\n', '        totalLockedShares = totalLockedShares.add(mintedLockedShares);\n', '\n', '        require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),\n', "            'TokenGeyser: transfer into locked pool failed');\n", '        emit TokensLocked(amount, durationSec, totalLocked());\n', '    }\n', '\n', '    /**\n', '     * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the\n', '     *      previously defined unlock schedules. Publicly callable.\n', '     * @return Number of newly unlocked distribution tokens.\n', '     */\n', '    function unlockTokens() public returns (uint256) {\n', '        uint256 unlockedTokens = 0;\n', '        uint256 lockedTokens = totalLocked();\n', '\n', '        if (totalLockedShares == 0) {\n', '            unlockedTokens = lockedTokens;\n', '        } else {\n', '            uint256 unlockedShares = 0;\n', '            for (uint256 s = 0; s < unlockSchedules.length; s++) {\n', '                unlockedShares = unlockedShares.add(unlockScheduleShares(s));\n', '            }\n', '            unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);\n', '            totalLockedShares = totalLockedShares.sub(unlockedShares);\n', '        }\n', '\n', '        if (unlockedTokens > 0) {\n', '            require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),\n', "                'TokenGeyser: transfer out of locked pool failed');\n", '            emit TokensUnlocked(unlockedTokens, totalLocked());\n', '        }\n', '\n', '        return unlockedTokens;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of unlockable shares from a given schedule. The returned value\n', '     *      depends on the time since the last unlock. This function updates schedule accounting,\n', '     *      but does not actually transfer any tokens.\n', '     * @param s Index of the unlock schedule.\n', '     * @return The number of unlocked shares.\n', '     */\n', '    function unlockScheduleShares(uint256 s) private returns (uint256) {\n', '        UnlockSchedule storage schedule = unlockSchedules[s];\n', '\n', '        if(schedule.unlockedShares >= schedule.initialLockedShares) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 sharesToUnlock = 0;\n', '        // Special case to handle any leftover dust from integer division\n', '        if (block.timestamp >= schedule.endAtSec) {\n', '            sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));\n', '            schedule.lastUnlockTimestampSec = schedule.endAtSec;\n', '        } else {\n', '            sharesToUnlock = block.timestamp.sub(schedule.lastUnlockTimestampSec)\n', '                .mul(schedule.initialLockedShares)\n', '                .div(schedule.durationSec);\n', '            schedule.lastUnlockTimestampSec = block.timestamp;\n', '        }\n', '\n', '        schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);\n', '        return sharesToUnlock;\n', '    }\n', '\n', '    /**\n', '     * @dev Lets the owner rescue funds air-dropped to the staking pool.\n', '     * @param tokenToRescue Address of the token to be rescued.\n', '     * @param to Address to which the rescued funds are to be sent.\n', '     * @param amount Amount of tokens to be rescued.\n', '     * @return Transfer success.\n', '     */\n', '    function rescueFundsFromStakingPool(address tokenToRescue, address to, uint256 amount)\n', '        public onlyOwner returns (bool) {\n', '\n', '        return _stakingPool.rescueFunds(tokenToRescue, to, amount);\n', '    }\n', '}\n', '\n', 'pragma solidity 0.7.5;\n', '\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', '/**\n', ' * @title A simple holder of tokens.\n', " * This is a simple contract to hold tokens. It's useful in the case where a separate contract\n", ' * needs to hold multiple distinct pools of the same token.\n', ' */\n', 'contract TokenPool is Ownable {\n', '    IERC20 public token;\n', '\n', '    constructor(IERC20 _token) public {\n', '        token = _token;\n', '    }\n', '\n', '    function balance() public view returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    function transfer(address to, uint256 value) external onlyOwner returns (bool) {\n', '        return token.transfer(to, value);\n', '    }\n', '\n', '    function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {\n', "        require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');\n", '\n', '        return IERC20(tokenToRescue).transfer(to, amount);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "../GSN/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}']