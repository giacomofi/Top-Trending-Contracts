['pragma solidity ^0.5.5;\n', '\n', 'library Math {\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Context {\n', '    constructor () internal {}\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function mint(address account, uint amount) external;\n', '    function burn(uint amount) external;\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', 'library Address {\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {codehash := extcodehash(account)}\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success,) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    \n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        \n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {// Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract IRewardDistributionRecipient is Ownable {\n', '    address public rewardVote;\n', '\n', '    function setRewardVote(address _rewardVote) external onlyOwner {\n', '        rewardVote = _rewardVote;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract LPTokenWrapper {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '\n', '    IERC20 public y = IERC20(0x5aeEc06Be0Ac269cE284dBB3186454eA56484712);  //define uni token\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function tokenStake(uint256 amount) internal {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '        y.safeTransferFrom(msg.sender, address(this), amount);\n', '    }\n', '\n', '    function tokenWithdraw(uint256 amount, uint256 gracePeriodUser) internal {\n', '        if (block.timestamp > gracePeriodUser){\n', '            _totalSupply = _totalSupply.sub(amount);\n', '            _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '            y.safeTransfer(msg.sender, amount);\n', '        }\n', '        \n', '        else {\n', '            uint256 gracePenalty = amount.mul(20).div(100);\n', '            _totalSupply = _totalSupply.sub(amount);\n', '            _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '            uint256 sentUserAmount= amount - gracePenalty;\n', '            \n', '            y.safeTransfer(msg.sender, sentUserAmount);\n', '            y.safeTransfer(address(0x2222222222222222222222222222222222222222),gracePenalty);\n', '        }\n', '    }\n', '}\n', '\n', 'interface IBerserkVote {\n', '    function averageVotingValue(address poolAddress, uint256 votingItem) external view returns (uint16);\n', '    function getNumVotes( address poolAddressStake, uint256 valueAmount ) external view returns (uint256);\n', '}\n', '\n', 'interface IBerserkToken{\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function burn(uint amount) external;\n', '    function mint(address account, uint amount) external;\n', '    \n', '\n', '    function resetBurnAmount() external;\n', '\tfunction getBurnAmount()  external returns (uint256);\n', '\t\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BerserkETHPool is LPTokenWrapper, IRewardDistributionRecipient {\n', '    IBerserkToken public berserk = IBerserkToken(0x7a9d78B9e8F32038E580457D497f79E660101D88);    //define token\n', '\n', '    uint256 public  DURATION = 1 weeks;\n', '    uint256 public  NUMBER_EPOCHS = 100000000;\n', '\n', '    uint256 public  EPOCH_REWARD = 26 ether;\n', '\n', '    uint256 public gracePeriod = 2 weeks;   // Period for unstaking without penalty\n', '    uint256 public currentEpochReward = EPOCH_REWARD;\n', '\n', '    uint256 public totalAccumulatedReward = 0;\n', '    uint256 public currentEpoch = 1;\n', '    uint256 public starttime = 1605114000;  //Start time at : 11th November 6:00 PM CEST\n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '    mapping(address => uint256) public accumulatedStakingPower; // will accumulate every time staker does getReward()\n', '    mapping (address => uint256) public gracePeriodList;\n', '    uint256 public burnAmountTest= 0;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Burned(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '    event CommissionPaid(address indexed user, uint256 reward);\n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (totalSupply() == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '        rewardPerTokenStored.add(\n', '            lastTimeRewardApplicable()\n', '            .sub(lastUpdateTime)\n', '            .mul(rewardRate)\n', '            .mul(1e18)\n', '            .div(totalSupply())\n', '        );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        uint256 calculatedEarned = balanceOf(account)\n', '            .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))\n', '            .div(1e18)\n', '            .add(rewards[account]);\n', '        return calculatedEarned;\n', '    }\n', '\n', '    function stakingPower(address account) public view returns (uint256) {\n', '        return accumulatedStakingPower[account].add(earned(account));\n', '    }\n', '    \n', '    function continueStaking() public updateReward(msg.sender) checkNextEpoch checkStart {\n', '        \n', '    }\n', '\n', '    function stake(uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart {\n', '        require(amount > 0, "Cannot stake 0");\n', '        gracePeriodList[msg.sender]= block.timestamp + gracePeriod;\n', '        super.tokenStake(amount);\n', '        emit Staked(msg.sender, amount);\n', '    }\n', '    \n', '    function withdraw(uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        super.tokenWithdraw(amount, gracePeriodList[msg.sender]);\n', '        emit Withdrawn(msg.sender, amount);\n', '    }\n', '\n', '    \n', '    function getPeriodFinish() public view returns (uint256){\n', '        return periodFinish;\n', '    }\n', '    \n', '\n', '    function getReward() public updateReward(msg.sender) checkNextEpoch checkStart returns (uint256) {\n', '        uint256 reward = earned(msg.sender);\n', '            if (reward > 1) {\n', '            accumulatedStakingPower[msg.sender] = accumulatedStakingPower[msg.sender].add(rewards[msg.sender]);\n', '            rewards[msg.sender] = 0;\n', '\n', '            berserk.transfer(msg.sender, reward);\n', '            emit RewardPaid(msg.sender, reward);\n', '                \n', '            return reward;\n', '            \n', '        }\n', '        return 0;\n', '    }\n', '    \n', '    function getAmountBurned() public returns (uint256){\n', '        burnAmountTest= berserk.getBurnAmount();\n', '        return burnAmountTest;\n', '    }\n', '    \n', '    function getUserGracePeriod() public view returns(uint256){\n', '        return gracePeriodList[msg.sender];\n', '    }\n', '    \n', '    function getBoolUserGracePeriod() public view returns (bool){\n', '        if (block.timestamp>gracePeriodList[msg.sender])\n', '            return true;\n', '        else return false;\n', '    }\n', '    \n', '    function getcheck() public view returns(uint256){\n', '        return burnAmountTest;\n', '    }\n', '    \n', '    function resetBurnPoolAmount() public {\n', '        berserk.resetBurnAmount();\n', '    }\n', '\n', '    function nextRewardMultiplier() public view returns (uint16) {\n', '        if (rewardVote != address(0)) {\n', '            uint256 numberOfVotes = IBerserkVote(rewardVote).getNumVotes(address(this), periodFinish);\n', '            \n', '            if (numberOfVotes >=30) {\n', '                uint16 votingValue = IBerserkVote(rewardVote).averageVotingValue(address(this), periodFinish);\n', '                if (votingValue > 0) return votingValue;\n', '            }\n', '        }\n', '        return 100;\n', '    }\n', '\n', '    modifier checkNextEpoch() {\n', '        if (block.timestamp >= periodFinish) {\n', '            uint256 rewardMultiplier = nextRewardMultiplier(); // 50% -> 200% (by vote)\n', '            \n', '            if (currentEpoch == 1){\n', '                currentEpochReward= EPOCH_REWARD.mul(2).div(7);\n', '                DURATION = 2 days;\n', '            }\n', '            \n', '            if (currentEpoch ==2 ){\n', '                currentEpochReward= EPOCH_REWARD;\n', '                DURATION= 1 weeks;\n', '            }\n', '            \n', '            if (currentEpoch > 2){\n', '                currentEpochReward= EPOCH_REWARD.mul(rewardMultiplier).div(100);\n', '            }\n', '            \n', '            if (currentEpochReward > 0) {\n', '                berserk.mint(address(this), currentEpochReward);\n', '                burnAmountTest= berserk.getBurnAmount();\n', '                currentEpochReward = currentEpochReward+burnAmountTest;\n', '                berserk.resetBurnAmount();\n', '       \n', '                totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);\n', '                currentEpoch++;\n', '            }\n', '\n', '            rewardRate = currentEpochReward.div(DURATION);\n', '            lastUpdateTime = block.timestamp;\n', '            periodFinish = block.timestamp.add(DURATION);\n', '            emit RewardAdded(currentEpochReward);\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier checkStart() {\n', '        require(block.timestamp > starttime, "not start");\n', '        _;\n', '    }\n', '    \n', '}']