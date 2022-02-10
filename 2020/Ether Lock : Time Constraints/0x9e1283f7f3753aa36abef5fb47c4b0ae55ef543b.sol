['pragma solidity ^0.5.5;\n', '\n', 'library Math {\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Context {\n', '    constructor () internal {}\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function mint(address account, uint amount) external;\n', '\n', '    function burn(uint amount) external;\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', 'library Address {\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {codehash := extcodehash(account)}\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success,) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    \n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        \n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {// Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract IRewardDistributionRecipient is Ownable {\n', '    address public rewardVote;\n', '\n', '    function setRewardVote(address _rewardVote) external onlyOwner {\n', '        rewardVote = _rewardVote;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract LPTokenWrapper {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '\n', '    IERC20 public y = IERC20(0x17f690bA194FCADDDb6ADbAD29fC70E100F391E8);  //define uni token\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function tokenStake(uint256 amount) internal {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '        y.safeTransferFrom(msg.sender, address(this), amount);\n', '    }\n', '\n', '    function tokenWithdraw(uint256 amount) internal {\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        y.safeTransfer(msg.sender, amount);\n', '    }\n', '}\n', '\n', 'interface YALPHAVote {\n', '    function averageVotingValue(address poolAddress, uint256 votingItem) external view returns (uint16);\n', '}\n', '\n', 'interface ALPHAStake {\n', '    function stakeOnBehalf(address stakeFor, uint256 amount) external;\n', '}\n', '\n', 'contract YALPHAPoolRewardsUSDC is LPTokenWrapper, IRewardDistributionRecipient {\n', '    IERC20 public yalpha = IERC20(0xD91A89F797592eCa6C599BA4BDCab41EF79818D5);    //define token\n', '\n', '    uint256 public  DURATION = 7 days;\n', '    uint256 public  NUMBER_EPOCHS = 100000000;\n', '\n', '    uint256 public  EPOCH_REWARD = 15 ether;\n', '\n', '    uint256 public currentEpochReward = EPOCH_REWARD;\n', '    uint256 public firstEpochReward = EPOCH_REWARD;\n', '    \n', '    uint256 public totalAccumulatedReward = 0;\n', '    uint256 public currentEpoch = 1;\n', '    uint256 public starttime = 1601467200; // Wednesday, 30th September 2020 14:00:00 GMT+02:00\n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public epochDuration = DURATION;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '    \n', '    uint256 public realEpochReward;\n', '    uint256 public constant dur_1= 60;\n', '    \n', '\n', '    mapping(address => uint256) public accumulatedStakingPower; // will accumulate every time staker does getReward()\n', '\n', '    address public rewardStake;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Burned(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '    event CommissionPaid(address indexed user, uint256 reward);\n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (totalSupply() == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '        rewardPerTokenStored.add(\n', '            lastTimeRewardApplicable()\n', '            .sub(lastUpdateTime)\n', '            .mul(rewardRate)\n', '            .mul(1e18)\n', '            .div(totalSupply())\n', '        );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        uint256 calculatedEarned = balanceOf(account)\n', '            .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))\n', '            .div(1e18)\n', '            .add(rewards[account]);\n', '        uint256 poolBalance = yalpha.balanceOf(address(this));\n', '        if (calculatedEarned > poolBalance) return poolBalance;\n', '        return calculatedEarned;\n', '    }\n', '\n', '    function stakingPower(address account) public view returns (uint256) {\n', '        return accumulatedStakingPower[account].add(earned(account));\n', '    }\n', '\n', '    function setRewardStake(address _rewardStake) external onlyOwner {\n', '        rewardStake = _rewardStake;\n', '        yalpha.approve(rewardStake, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);\n', '    }\n', '\n', '    function stake(uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart {\n', '        require(amount > 0, "Cannot stake 0");\n', '        super.tokenStake(amount);\n', '        emit Staked(msg.sender, amount);\n', '    }\n', '\n', '    function stakeReward() public updateReward(msg.sender) checkNextEpoch checkStart {\n', '        require(rewardStake != address(0), "Dont know the staking pool");\n', '        uint256 reward = getReward();\n', '        yalpha.safeTransferFrom(msg.sender, address(this), reward);\n', '        require(reward > 1, "Earned too little");\n', '        ALPHAStake(rewardStake).stakeOnBehalf(msg.sender, reward);\n', '    }\n', '    \n', '    function setMaxEpoch(uint256 number,uint256 _epochReward, uint256 _duration) external onlyOwner{\n', '        NUMBER_EPOCHS= number;\n', '        EPOCH_REWARD= _epochReward;\n', '        DURATION= _duration;\n', '    }\n', '\n', '    function withdraw(uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        super.tokenWithdraw(amount);\n', '        emit Withdrawn(msg.sender, amount);\n', '    }\n', '\n', '    function exit() external {\n', '        withdraw(balanceOf(msg.sender));\n', '        getReward();\n', '    }\n', '    \n', '    function getPeriodFinish() public view returns (uint256){\n', '        return periodFinish;\n', '    }\n', '\n', '    function getReward() public updateReward(msg.sender) checkNextEpoch checkStart returns (uint256) {\n', '        uint256 reward = earned(msg.sender);\n', '        if (reward > 1) {\n', '            accumulatedStakingPower[msg.sender] = accumulatedStakingPower[msg.sender].add(rewards[msg.sender]);\n', '            rewards[msg.sender] = 0;\n', '\n', '            yalpha.safeTransfer(msg.sender, reward);\n', '            emit RewardPaid(msg.sender, reward);\n', '            \n', '            return reward;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function nextRewardMultiplier() public view returns (uint16) {\n', '        if (rewardVote != address(0)) {\n', '            uint16 votingValue = YALPHAVote(rewardVote).averageVotingValue(address(this), periodFinish);\n', '            if (votingValue > 0) return votingValue;\n', '        }\n', '        return 100;\n', '    }\n', '\n', '    modifier checkNextEpoch() {\n', '        if (block.timestamp >= periodFinish) {\n', '            uint256 rewardMultiplier = nextRewardMultiplier(); // 50% -> 200% (by vote)\n', '\n', '            if (currentEpoch==1){\n', '                currentEpochReward = EPOCH_REWARD.mul(20);\n', '            }\n', '            \n', '            if (currentEpoch==2){\n', '                currentEpochReward = EPOCH_REWARD.mul(15);\n', '            }\n', '            \n', '            if (currentEpoch==3){\n', '                currentEpochReward = EPOCH_REWARD.mul(10);\n', '            }\n', '            \n', '            if (currentEpoch==4){\n', '                currentEpochReward = EPOCH_REWARD.mul(5);\n', '            }\n', '            \n', '            if (currentEpoch==5)\n', '               { currentEpochReward = EPOCH_REWARD;\n', '                }\n', '            \n', '            if (currentEpoch>5) \n', '            {\n', '                currentEpochReward = currentEpochReward.mul(rewardMultiplier).div(100);\n', '            }\n', '            \n', '            if (currentEpochReward > 0) {\n', '                yalpha.mint(address(this), currentEpochReward);\n', '                totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);\n', '                currentEpoch++;\n', '            }\n', '\n', '            rewardRate = currentEpochReward.div(DURATION);\n', '            lastUpdateTime = block.timestamp;\n', '            periodFinish = block.timestamp.add(DURATION);\n', '            emit RewardAdded(currentEpochReward);\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier checkStart() {\n', '        require(block.timestamp > starttime, "not start");\n', '        _;\n', '    }\n', '    \n', '}']