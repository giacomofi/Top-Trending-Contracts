['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-01\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity 0.5.0;\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/GSN/Context.sol\n', '\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/IStaking.sol\n', '\n', 'contract IStaking {\n', '    event Staked(address indexed user, uint256 amount, uint256 total, uint256 time, bytes data);\n', '    event Unstaked(address indexed user, uint256 amount, uint256 total, uint256 penaltyAmount, bytes data);\n', '\n', '    function stake(uint256 amount, bytes calldata data) external;\n', '    function stakeFor(address user, uint256 amount, bytes calldata data) external;\n', '    function unstake(uint256 amount, bytes calldata data) external;\n', '    function unstakeAtIndex(uint256 index, bytes calldata data) external;\n', '    function totalStakedFor(address addr) public view returns (uint256);\n', '    function totalStaked() public view returns (uint256);\n', '    function token() external view returns (address);\n', '\n', '    function supportsHistory() external pure returns (bool) {\n', '        return false;\n', '    }\n', '}\n', '\n', '// File: contracts/TokenPool.sol\n', '\n', 'contract TokenPool is Ownable {\n', '    IERC20 public token;\n', '\n', '    constructor(IERC20 _token) public {\n', '        token = _token;\n', '    }\n', '\n', '    function balance() public view returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    function transfer(address to, uint256 value) external onlyOwner returns (bool) {\n', '        return token.transfer(to, value);\n', '    }\n', '}\n', '\n', '// File: contracts/TokenSpring.sol\n', '\n', 'contract TokenSpring is IStaking, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Staked(address indexed user, uint256 amount, uint256 total, uint256 time, bytes data);\n', '    event Unstaked(address indexed user, uint256 amount, uint256 total, uint256 penaltyAmount, bytes data);\n', '    event TokensClaimed(address indexed user, uint256 amount);\n', '    event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);\n', '    // amount: Unlocked tokens, total: Total locked tokens\n', '    event TokensUnlocked(uint256 amount, uint256 total);\n', '\n', '    event LogPenaltyAddressUpdated(address penaltyAddress_);\n', '\n', '    TokenPool private _stakingPool;\n', '    TokenPool private _unlockedPool;\n', '    TokenPool private _lockedPool;\n', '\n', '    //\n', '    // Time-bonus params\n', '    //\n', '    uint256 public constant BONUS_DECIMALS = 2;\n', '    uint256 public startBonus = 0;\n', '    uint256 public bonusPeriodSec = 0;\n', '    uint256 public lockTimeSeconds = 30 days;\n', '\n', '    //\n', '    // Global accounting state\n', '    //\n', '    uint256 public totalLockedShares = 0;\n', '    uint256 public totalStakingShares = 0;\n', '    uint256 private _totalStakingShareSeconds = 0;\n', '    uint256 private _maxUnlockSchedules = 0;\n', '    uint256 private _initialSharesPerToken = 0;\n', '\n', '    //\n', '    // User accounting state\n', '    //\n', '    // Represents a single stake for a user. A user may have multiple.\n', '    struct Stake {\n', '        uint256 stakingShares;\n', '        uint256 timestampSec;\n', '        uint256 lockTimestampSec;\n', '    }\n', '\n', '    // Caches aggregated values from the User->Stake[] map to save computation.\n', "    // If lastAccountingTimestampSec is 0, there's no entry for that user.\n", '    struct UserTotals {\n', '        uint256 stakingShares;\n', '        uint256 stakingShareSeconds;\n', '    }\n', '\n', '    // Aggregated staking values per user\n', '    mapping(address => UserTotals) private _userTotals;\n', '\n', '    // The collection of stakes for each user. Ordered by timestamp, earliest to latest.\n', '    mapping(address => Stake[]) private _userStakes;\n', '\n', '    //\n', '    // Locked/Unlocked Accounting state\n', '    //\n', '    struct UnlockSchedule {\n', '        uint256 initialLockedShares;\n', '        uint256 unlockedShares;\n', '        uint256 lastUnlockTimestampSec;\n', '        uint256 endAtSec;\n', '        uint256 durationSec;\n', '    }\n', '\n', '    UnlockSchedule[] public unlockSchedules;\n', '\n', '    // This address receives all penalty UNI-V2 LP tokens\n', '    address public penaltyAddress;\n', '\n', '    constructor(IERC20 stakingToken, IERC20 distributionToken, uint256 maxUnlockSchedules,\n', '                uint256 startBonus_, uint256 bonusPeriodSec_, uint256 initialSharesPerToken) public {\n', '        // The start bonus must be some fraction of the max. (i.e. <= 100%)\n', "        require(startBonus_ <= 10**BONUS_DECIMALS, 'TokenSpring: start bonus too high');\n", '        // If no period is desired, instead set startBonus = 100%\n', '        // and bonusPeriod to a small value like 1sec.\n', "        require(bonusPeriodSec_ != 0, 'TokenSpring: bonus period is zero');\n", "        require(initialSharesPerToken > 0, 'TokenSpring: initialSharesPerToken is zero');\n", '\n', '        _stakingPool = new TokenPool(stakingToken);\n', '        _unlockedPool = new TokenPool(distributionToken);\n', '        _lockedPool = new TokenPool(distributionToken);\n', '        startBonus = startBonus_;\n', '        bonusPeriodSec = bonusPeriodSec_;\n', '        _maxUnlockSchedules = maxUnlockSchedules;\n', '        _initialSharesPerToken = initialSharesPerToken;\n', '        lockTimeSeconds = 30 days;\n', '    }\n', '\n', '    function setPenaltyAddress(address penaltyAddress_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        penaltyAddress = penaltyAddress_;\n', '        emit LogPenaltyAddressUpdated(penaltyAddress_);\n', '    }\n', '\n', '    function setLockTimeSeconds(uint256 lockTimeSeconds_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        lockTimeSeconds = lockTimeSeconds_;\n', '    }\n', '\n', '    function getStakingToken() public view returns (IERC20) {\n', '        return _stakingPool.token();\n', '    }\n', '\n', '    function getDistributionToken() public view returns (IERC20) {\n', '        assert(_unlockedPool.token() == _lockedPool.token());\n', '        return _unlockedPool.token();\n', '    }\n', '\n', '    function stake(uint256 amount, bytes calldata data) external {\n', '        _stakeFor(msg.sender, msg.sender, amount);\n', '    }\n', '\n', '    function stakeFor(address user, uint256 amount, bytes calldata data) external {\n', '        _stakeFor(msg.sender, user, amount);\n', '    }\n', '\n', '    function _stakeFor(address staker, address beneficiary, uint256 amount) private {\n', "        require(amount > 0, 'TokenSpring: stake amount is zero');\n", "        require(beneficiary != address(0), 'TokenSpring: beneficiary is zero address');\n", '        require(totalStakingShares == 0 || totalStaked() > 0,\n', "                'TokenSpring: Invalid state. Staking shares exist, but no staking tokens do');\n", '\n', '        uint256 expiryTime = now.add(lockTimeSeconds);\n', '\n', '        uint256 mintedStakingShares = (totalStakingShares > 0)\n', '            ? totalStakingShares.mul(amount).div(totalStaked())\n', '            : amount.mul(_initialSharesPerToken);\n', "        require(mintedStakingShares > 0, 'TokenSpring: Stake amount is too small');\n", '\n', '        // 1. User Accounting\n', '        UserTotals storage totals = _userTotals[beneficiary];\n', '        totals.stakingShares = totals.stakingShares.add(mintedStakingShares);\n', '\n', '        Stake memory newStake = Stake(mintedStakingShares, now, expiryTime);\n', '        _userStakes[beneficiary].push(newStake);\n', '\n', '        // 2. Global Accounting\n', '        totalStakingShares = totalStakingShares.add(mintedStakingShares);\n', '\n', '        // interactions\n', '        require(_stakingPool.token().transferFrom(staker, address(_stakingPool), amount),\n', "            'TokenSpring: transfer into staking pool failed');\n", '\n', '        // set global and user weights after CD is deposited\n', '        updateAccounting(expiryTime, mintedStakingShares);\n', '\n', '        emit Staked(beneficiary, amount, totalStakedFor(beneficiary), expiryTime, "");\n', '    }\n', '\n', '    function unstake(uint256 amount, bytes calldata data) external {\n', '        _unstake(amount);\n', '    }\n', '\n', '    function unstakeAtIndex(uint256 index, bytes calldata data) external {\n', '        _unstakeAtIndex(index);\n', '    }\n', '\n', '    function unstakeQuery(uint256 amount) public returns (uint256) {\n', '        return _unstake(amount);\n', '    }\n', '\n', '    function unstakeAtIndexQuery(uint256 index) public returns (uint256) {\n', '        return _unstakeAtIndex(index);\n', '    }\n', '\n', '    function _unstake(uint256 amount) private returns (uint256) {\n', '        //updateAccounting();\n', '        unlockTokens();\n', '\n', '        // checks\n', "        require(amount > 0, 'TokenSpring: unstake amount is zero');\n", '        require(totalStakedFor(msg.sender) >= amount,\n', "            'TokenSpring: unstake amount is greater than total user stakes');\n", '        uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(totalStaked());\n', "        require(stakingSharesToBurn > 0, 'TokenSpring: Unable to unstake amount this small');\n", '\n', '        // 1. User Accounting\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '        Stake[] storage accountStakes = _userStakes[msg.sender];\n', '\n', '        // Redeem from most recent stake and go backwards in time.\n', '        uint256 stakingShareSecondsToBurn = 0;\n', '        uint256 sharesLeftToBurn = stakingSharesToBurn;\n', '        uint256 rewardAmount = 0;\n', '        uint256 penaltyAmount = 0;\n', '        uint256 totalAmount = 0;\n', '        while (sharesLeftToBurn > 0) {\n', '            Stake storage lastStake = accountStakes[accountStakes.length - 1];\n', '            // normalized amount from this CD\n', '            uint256 newAmount = lastStake.stakingShares.mul(totalStaked()).div(totalStakingShares);\n', '            totalAmount = totalAmount.add(newAmount);\n', '            uint256 stakeTimeSec = now.sub(lastStake.timestampSec);\n', '            uint256 stakeTimeSecCalculated = lastStake.lockTimestampSec.sub(lastStake.timestampSec);\n', '            uint256 newStakingShareSecondsToBurn = 0;\n', '\n', '            // MUST fully redeem a past stake, CD gets destroyed\n', '            newStakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSecCalculated);\n', '            stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(newStakingShareSecondsToBurn);\n', '\n', '            if(lastStake.stakingShares > sharesLeftToBurn){\n', '              sharesLeftToBurn = 0;\n', '            } else {\n', '              sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);\n', '            }\n', '\n', '            // Need to be penalized\n', '            if(lastStake.lockTimestampSec > now){\n', '              // amountOfThisStake * (totalLock - actualLock)/totalLock) / 2\n', '              penaltyAmount = penaltyAmount.add(stakeTimeSecCalculated.sub(stakeTimeSec).mul(newAmount).div(stakeTimeSecCalculated).div(2));\n', '            } else {\n', '              // this contract was fulfilled, make sure to pay out the reward based on the calculated time\n', '              rewardAmount = computeNewReward(rewardAmount, newStakingShareSecondsToBurn, stakeTimeSecCalculated);\n', '            }\n', '\n', '            accountStakes.length--;\n', '        }\n', '\n', '        totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);\n', '        totals.stakingShares = totals.stakingShares.sub(totalStakingShares.mul(totalAmount).div(totalStaked()));\n', '\n', '        // 2. Global Accounting\n', '        _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);\n', '        totalStakingShares = totalStakingShares.sub(totalStakingShares.mul(totalAmount).div(totalStaked()));\n', '\n', '        // what the staker should receive\n', '        uint256 amountMinusPenalty = totalAmount.sub(penaltyAmount);\n', "        require(totalAmount >= penaltyAmount, 'TokenSpring: penalty amount exceeds amount being redeemed');\n", '\n', '        // just because we have penalties, does not mean we do not have rewards to pay out\n', '        if(rewardAmount > 0) {\n', '          // this unstake has no penalty, pay out the rewards\n', '          require(_unlockedPool.transfer(msg.sender, rewardAmount),\n', "              'TokenSpring: transfer out of unlocked pool failed');\n", '        }\n', '\n', '        // pay out the contract deposit amount minus any penalty\n', '        require(_stakingPool.transfer(msg.sender, amountMinusPenalty),\n', "            'TokenSpring: transfer out of staking pool failed');\n", '\n', '        if(penaltyAmount > 0){\n', '          // need to send penalty amount to the pool\n', '          require(_stakingPool.transfer(penaltyAddress, penaltyAmount),\n', "            'TokenSpring: transfer into staking pool failed');\n", '        }\n', '\n', '        emit Unstaked(msg.sender, amountMinusPenalty, totalStakedFor(msg.sender), penaltyAmount, "");\n', '        emit TokensClaimed(msg.sender, rewardAmount);\n', '\n', '        require(totalStakingShares == 0 || totalStaked() > 0,\n', '                "TokenSpring: Error unstaking. Staking shares exist, but no staking tokens do");\n', '        return rewardAmount;\n', '    }\n', '\n', '    function _unstakeAtIndex(uint256 index) private returns (uint256) {\n', '        unlockTokens();\n', '\n', '        // checks\n', '        require(totalStakedFor(msg.sender) >= 0,\n', "            'TokenSpring: user has zero staked');\n", '\n', '        // 1. User Accounting\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '        Stake[] storage accountStakes = _userStakes[msg.sender];\n', '\n', '        require(accountStakes.length > index,\n', "            'TokenSpring: unstake index is not available');\n", '\n', '        Stake storage lastStake = accountStakes[index];\n', '\n', '        // Redeem from most recent stake and go backwards in time.\n', '        uint256 stakingShareSecondsToBurn = 0;\n', '        uint256 rewardAmount = 0;\n', '        uint256 penaltyAmount = 0;\n', '        // normalized amount from this CD\n', '        uint256 totalAmount = lastStake.stakingShares.mul(totalStaked()).div(totalStakingShares);\n', "        require(totalAmount > 0, 'TokenSpring: unstake index amount is zero');\n", '\n', '        uint256 stakeTimeSec = now.sub(lastStake.timestampSec);\n', '        uint256 stakeTimeSecCalculated = lastStake.lockTimestampSec.sub(lastStake.timestampSec);\n', '\n', '        // MUST fully redeem a past stake, CD gets destroyed\n', '        stakingShareSecondsToBurn = lastStake.stakingShares.mul(stakeTimeSecCalculated);\n', '\n', '        // Need to be penalized\n', '        if(lastStake.lockTimestampSec > now){\n', '          // amountOfThisStake * (totalLock - actualLock)/totalLock) / 2\n', '          penaltyAmount = penaltyAmount.add(stakeTimeSecCalculated.sub(stakeTimeSec).mul(totalAmount).div(stakeTimeSecCalculated).div(2));\n', '        } else {\n', '          // this contract was fulfilled, make sure to pay out the reward based on the calculated time\n', '          rewardAmount = computeNewReward(rewardAmount, stakingShareSecondsToBurn, stakeTimeSecCalculated);\n', '        }\n', '\n', '        delete accountStakes[index];\n', '\n', '        totals.stakingShareSeconds = totals.stakingShareSeconds.sub(stakingShareSecondsToBurn);\n', '        totals.stakingShares = totals.stakingShares.sub(totalStakingShares.mul(totalAmount).div(totalStaked()));\n', '\n', '        // 2. Global Accounting\n', '        _totalStakingShareSeconds = _totalStakingShareSeconds.sub(stakingShareSecondsToBurn);\n', '        totalStakingShares = totalStakingShares.sub(totalStakingShares.mul(totalAmount).div(totalStaked()));\n', '\n', '        // what the staker should receive\n', '        uint256 amountMinusPenalty = totalAmount.sub(penaltyAmount);\n', "        require(totalAmount >= penaltyAmount, 'TokenSpring: penalty amount exceeds amount being redeemed');\n", '\n', '        // just because we have penalties, does not mean we do not have rewards to pay out\n', '        if(rewardAmount > 0) {\n', '          // this unstake has no penalty, pay out the rewards\n', '          require(_unlockedPool.transfer(msg.sender, rewardAmount),\n', "              'TokenSpring: transfer out of unlocked pool failed');\n", '        }\n', '\n', '        // pay out the contract deposit amount minus any penalty\n', '        require(_stakingPool.transfer(msg.sender, amountMinusPenalty),\n', "            'TokenSpring: transfer out of staking pool failed');\n", '\n', '        if(penaltyAmount > 0){\n', '          // need to send penalty amount to the pool\n', '          require(_stakingPool.transfer(penaltyAddress, penaltyAmount),\n', "            'TokenSpring: transfer into staking pool failed');\n", '        }\n', '\n', '        emit Unstaked(msg.sender, amountMinusPenalty, totalStakedFor(msg.sender), penaltyAmount, "");\n', '        emit TokensClaimed(msg.sender, rewardAmount);\n', '\n', '        require(totalStakingShares == 0 || totalStaked() > 0,\n', '                "TokenSpring: Error unstaking. Staking shares exist, but no staking tokens do");\n', '        return rewardAmount;\n', '    }\n', '\n', '    function computeNewReward(uint256 currentRewardTokens,\n', '                                uint256 stakingShareSeconds,\n', '                                uint256 stakeTimeSec) private view returns (uint256) {\n', '\n', '        uint256 newRewardTokens =\n', '            totalUnlocked()\n', '            .mul(stakingShareSeconds)\n', '            .div(_totalStakingShareSeconds);\n', '\n', '        if (stakeTimeSec >= bonusPeriodSec) {\n', '            return currentRewardTokens.add(newRewardTokens);\n', '        }\n', '\n', '        uint256 oneHundredPct = 10**BONUS_DECIMALS;\n', '        uint256 bonusedReward =\n', '            startBonus\n', '            .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))\n', '            .mul(newRewardTokens)\n', '            .div(oneHundredPct);\n', '        return currentRewardTokens.add(bonusedReward);\n', '    }\n', '\n', '\n', '    function totalStakedFor(address addr) public view returns (uint256) {\n', '        return totalStakingShares > 0 ?\n', '            totalStaked().mul(_userTotals[addr].stakingShares).div(totalStakingShares) : 0;\n', '    }\n', '\n', '\n', '    function totalStaked() public view returns (uint256) {\n', '        return _stakingPool.balance();\n', '    }\n', '\n', '\n', '    function token() external view returns (address) {\n', '        return address(getStakingToken());\n', '    }\n', '\n', '    function updateAccounting(uint256 timeForContract, uint256 amountForContract) internal returns (\n', '        uint256, uint256, uint256, uint256, uint256, uint256) {\n', '\n', '        unlockTokens();\n', '\n', '        // Global accounting, should ONLY happen on new stake\n', '        uint256 newStakingShareSeconds =\n', '            timeForContract\n', '            .sub(now)\n', '            .mul(amountForContract);\n', '        _totalStakingShareSeconds = _totalStakingShareSeconds.add(newStakingShareSeconds);\n', '\n', '        // User Accounting, should ONLY happen on new stake\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '        uint256 newUserStakingShareSeconds =\n', '            timeForContract\n', '            .sub(now)\n', '            .mul(amountForContract);\n', '        totals.stakingShareSeconds =\n', '            totals.stakingShareSeconds\n', '            .add(newUserStakingShareSeconds);\n', '\n', '        uint256 totalUserRewards = (_totalStakingShareSeconds > 0)\n', '            ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)\n', '            : 0;\n', '\n', '        return (\n', '            totalLocked(),\n', '            totalUnlocked(),\n', '            totals.stakingShareSeconds,\n', '            _totalStakingShareSeconds,\n', '            totalUserRewards,\n', '            now\n', '        );\n', '    }\n', '\n', '    function getAccounting() public returns (\n', '        uint256, uint256, uint256, uint256, uint256, uint256) {\n', '\n', '        unlockTokens();\n', '\n', '        // User Accounting\n', '        UserTotals storage totals = _userTotals[msg.sender];\n', '\n', '        uint256 totalUserRewards = (_totalStakingShareSeconds > 0)\n', '            ? totalUnlocked().mul(totals.stakingShareSeconds).div(_totalStakingShareSeconds)\n', '            : 0;\n', '\n', '        return (\n', '            totalLocked(),\n', '            totalUnlocked(),\n', '            totals.stakingShareSeconds,\n', '            _totalStakingShareSeconds,\n', '            totalUserRewards,\n', '            now\n', '        );\n', '    }\n', '\n', '    function getContractAtIndex(address addr, uint256 index) public view returns (uint256, uint256, uint256) {\n', '        // User Accounting\n', '        Stake[] storage accountStakes = _userStakes[addr];\n', '        uint256 stakingShares = 0;\n', '        uint256 timestampSec = 0;\n', '        uint256 lockTimestampSec = 0;\n', '\n', '        if(accountStakes.length > index){\n', '          Stake storage indexStake = accountStakes[index];\n', '          stakingShares = indexStake.stakingShares;\n', '          timestampSec = indexStake.timestampSec;\n', '          lockTimestampSec = indexStake.lockTimestampSec;\n', '        }\n', '\n', '        return (\n', '            stakingShares,\n', '            timestampSec,\n', '            lockTimestampSec\n', '        );\n', '    }\n', '\n', '\n', '    function totalLocked() public view returns (uint256) {\n', '        return _lockedPool.balance();\n', '    }\n', '\n', '\n', '    function totalUnlocked() public view returns (uint256) {\n', '        return _unlockedPool.balance();\n', '    }\n', '\n', '    function unlockScheduleCount() public view returns (uint256) {\n', '        return unlockSchedules.length;\n', '    }\n', '\n', '\n', '    function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {\n', '        require(unlockSchedules.length < _maxUnlockSchedules,\n', "            'TokenSpring: reached maximum unlock schedules');\n", '\n', '        // Update lockedTokens amount before using it in computations after.\n', '        //updateAccounting();\n', '        unlockTokens();\n', '\n', '        uint256 lockedTokens = totalLocked();\n', '        uint256 mintedLockedShares = (lockedTokens > 0)\n', '            ? totalLockedShares.mul(amount).div(lockedTokens)\n', '            : amount.mul(_initialSharesPerToken);\n', '\n', '        UnlockSchedule memory schedule;\n', '        schedule.initialLockedShares = mintedLockedShares;\n', '        schedule.lastUnlockTimestampSec = now;\n', '        schedule.endAtSec = now.add(durationSec);\n', '        schedule.durationSec = durationSec;\n', '        unlockSchedules.push(schedule);\n', '\n', '        totalLockedShares = totalLockedShares.add(mintedLockedShares);\n', '\n', '        require(_lockedPool.token().transferFrom(msg.sender, address(_lockedPool), amount),\n', "            'TokenSpring: transfer into locked pool failed');\n", '        emit TokensLocked(amount, durationSec, totalLocked());\n', '    }\n', '\n', '\n', '    function unlockTokens() public returns (uint256) {\n', '        uint256 unlockedTokens = 0;\n', '        uint256 lockedTokens = totalLocked();\n', '\n', '        if (totalLockedShares == 0) {\n', '            unlockedTokens = lockedTokens;\n', '        } else {\n', '            uint256 unlockedShares = 0;\n', '            for (uint256 s = 0; s < unlockSchedules.length; s++) {\n', '                unlockedShares = unlockedShares.add(unlockScheduleShares(s));\n', '            }\n', '            unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);\n', '            totalLockedShares = totalLockedShares.sub(unlockedShares);\n', '        }\n', '\n', '        if (unlockedTokens > 0) {\n', '            require(_lockedPool.transfer(address(_unlockedPool), unlockedTokens),\n', "                'TokenSpring: transfer out of locked pool failed');\n", '            emit TokensUnlocked(unlockedTokens, totalLocked());\n', '        }\n', '\n', '        return unlockedTokens;\n', '    }\n', '\n', '\n', '    function unlockScheduleShares(uint256 s) private returns (uint256) {\n', '        UnlockSchedule storage schedule = unlockSchedules[s];\n', '\n', '        if(schedule.unlockedShares >= schedule.initialLockedShares) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 sharesToUnlock = 0;\n', '        // Special case to handle any leftover dust from integer division\n', '        if (now >= schedule.endAtSec) {\n', '            sharesToUnlock = (schedule.initialLockedShares.sub(schedule.unlockedShares));\n', '            schedule.lastUnlockTimestampSec = schedule.endAtSec;\n', '        } else {\n', '            sharesToUnlock = now.sub(schedule.lastUnlockTimestampSec)\n', '                .mul(schedule.initialLockedShares)\n', '                .div(schedule.durationSec);\n', '            schedule.lastUnlockTimestampSec = now;\n', '        }\n', '\n', '        schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);\n', '        return sharesToUnlock;\n', '    }\n', '}']