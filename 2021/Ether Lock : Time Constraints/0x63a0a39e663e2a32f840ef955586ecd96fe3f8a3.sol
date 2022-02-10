['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-18\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '// eFear.io initial code with beta-staking pre-coding notes (staking NOT live, code will be re-writen before ETH 2.0 Update)\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Interface coding\n', '//\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe Math Library coding\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', 'contract eFEARio is ERC20Interface, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals; // \n', '\n', '    uint256 public _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    constructor() public {\n', '        name = "eFEARio";\n', '        symbol = "eFEAR";\n', '        decimals = 18;\n', '        _totalSupply = 600000000000000000000000000;\n', '\n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '\n', '// ----------------------------------------------------------------------------\n', '/* Pre-coding of Staking Rewards\n', '// ----------------------------------------------------------------------------\n', '  \n', '    interface IStakingRewards {\n', '    // Views\n', '    function lastTimeRewardApplicable() external view returns (uint256);\n', '\n', '    function rewardPerToken() external view returns (uint256);\n', '\n', '    function earned(address account) external view returns (uint256);\n', '\n', '    function getRewardForDuration() external view returns (uint256);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    // Mutative\n', '\n', '    function stake(uint256 amount) external;\n', '\n', '    function withdraw(uint256 amount) external;\n', '\n', '    function getReward() external;\n', '\n', '    function exit() external;\n', '   }\n', '\n', 'contract RewardsDistributionRecipient is Owned {\n', '    address public rewardsDistribution;\n', '\n', '    function notifyRewardAmount(uint256 reward) external;\n', '\n', '    modifier onlyRewardsDistribution() {\n', '        require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");\n', '        _;\n', '    }\n', '\n', '    function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {\n', '        rewardsDistribution = _rewardsDistribution;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public nominatedOwner;\n', '\n', '    constructor(address _owner) public {\n', '        require(_owner != address(0), "Owner address cannot be 0");\n', '        owner = _owner;\n', '        emit OwnerChanged(address(0), _owner);\n', '    }\n', '\n', '    function nominateNewOwner(address _owner) external onlyOwner {\n', '        nominatedOwner = _owner;\n', '        emit OwnerNominated(_owner);\n', '    }\n', '\n', '    function acceptOwnership() external {\n', '        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");\n', '        emit OwnerChanged(owner, nominatedOwner);\n', '        owner = nominatedOwner;\n', '        nominatedOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        _onlyOwner();\n', '        _;\n', '    }\n', '\n', '    function _onlyOwner() private view {\n', '        require(msg.sender == owner, "Only the contract owner may perform this action");\n', '    }\n', '\n', '    event OwnerNominated(address newOwner);\n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '}\n', '\n', '\n', 'contract Pausable is Owned {\n', '    uint public lastPauseTime;\n', '    bool public paused;\n', '\n', '    constructor() internal {\n', '        // This contract is abstract, and thus cannot be instantiated directly\n', '        require(owner != address(0), "Owner must be set");\n', '        // Paused will be false, and lastPauseTime will be 0 upon initialisation\n', '    }\n', '\n', '    /**\n', '     * @notice Change the paused state of the contract\n', '     * @dev Only the contract owner may call this.\n', '     \n', '    function setPaused(bool _paused) external onlyOwner {\n', "        // Ensure we're actually changing the state before we do anything\n", '        if (_paused == paused) {\n', '            return;\n', '        }\n', '\n', '        // Set our paused state.\n', '        paused = _paused;\n', '\n', '        // If applicable, set the last pause time.\n', '        if (paused) {\n', '            lastPauseTime = now;\n', '        }\n', '\n', '        // Let everyone know that our pause state has changed.\n', '        emit PauseChanged(paused);\n', '    }\n', '\n', '    event PauseChanged(bool isPaused);\n', '\n', '    modifier notPaused {\n', '        require(!paused, "This action cannot be performed while the contract is paused");\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, Pausable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    /** @notice SafeERC20 implementation will be added later\n', '\n', '    /* ========== STATE VARIABLES ========== \n', '\n', '    IERC20 public rewardsToken;\n', '    IERC20 public stakingToken;\n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public rewardsDuration = 7 days;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    /* ========== CONSTRUCTOR ========== \n', '\n', '    constructor(\n', '        address _owner,\n', '        address _rewardsDistribution,\n', '        address _rewardsToken,\n', '        address _stakingToken\n', '    ) public Owned(_owner) {\n', '        rewardsToken = IERC20(_rewardsToken);\n', '        stakingToken = IERC20(_stakingToken);\n', '        rewardsDistribution = _rewardsDistribution;\n', '    }\n', '\n', '    /* ========== VIEWS ========== \n', '\n', '    function totalSupply() external view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) external view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (_totalSupply == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '            rewardPerTokenStored.add(\n', '                lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)\n', '            );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);\n', '    }\n', '\n', '    function getRewardForDuration() external view returns (uint256) {\n', '        return rewardRate.mul(rewardsDuration);\n', '    }\n', '\n', '    /* ========== MUTATIVE FUNCTIONS ========== \n', '\n', '    function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {\n', '        require(amount > 0, "Cannot stake 0");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '        stakingToken.safeTransferFrom(msg.sender, address(this), amount);\n', '        emit Staked(msg.sender, amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        stakingToken.safeTransfer(msg.sender, amount);\n', '        emit Withdrawn(msg.sender, amount);\n', '    }\n', '\n', '    function getReward() public nonReentrant updateReward(msg.sender) {\n', '        uint256 reward = rewards[msg.sender];\n', '        if (reward > 0) {\n', '            rewards[msg.sender] = 0;\n', '            rewardsToken.safeTransfer(msg.sender, reward);\n', '            emit RewardPaid(msg.sender, reward);\n', '        }\n', '    }\n', '\n', '    function exit() external {\n', '        withdraw(_balances[msg.sender]);\n', '        getReward();\n', '    }\n', '\n', '    /* ========== RESTRICTED FUNCTIONS ========== \n', '\n', '    function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {\n', '        if (block.timestamp >= periodFinish) {\n', '            rewardRate = reward.div(rewardsDuration);\n', '        } else {\n', '            uint256 remaining = periodFinish.sub(block.timestamp);\n', '            uint256 leftover = remaining.mul(rewardRate);\n', '            rewardRate = reward.add(leftover).div(rewardsDuration);\n', '        }\n', '\n', '        // Ensure the provided reward amount is not more than the balance in the contract.\n', '        // This keeps the reward rate in the right range, preventing overflows due to\n', '        // very high values of rewardRate in the earned and rewardsPerToken functions;\n', '        // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.\n', '        uint balance = rewardsToken.balanceOf(address(this));\n', '        require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");\n', '\n', '        lastUpdateTime = block.timestamp;\n', '        periodFinish = block.timestamp.add(rewardsDuration);\n', '        emit RewardAdded(reward);\n', '    }\n', '\n', '    // End rewards emission earlier\n', '    function updatePeriodFinish(uint timestamp) external onlyOwner updateReward(address(0)) {\n', '        periodFinish = timestamp;\n', '    }\n', '\n', '    // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders\n', '    function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {\n', '        require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");\n', '        IERC20(tokenAddress).safeTransfer(owner, tokenAmount);\n', '        emit Recovered(tokenAddress, tokenAmount);\n', '    }\n', '\n', '    function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {\n', '        require(\n', '            block.timestamp > periodFinish,\n', '            "Previous rewards period must be complete before changing the duration for the new period"\n', '        );\n', '        rewardsDuration = _rewardsDuration;\n', '        emit RewardsDurationUpdated(rewardsDuration);\n', '    }\n', '\n', '    /* ========== MODIFIERS ========== \n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '   /* ========== EVENTS ========== \n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '    event RewardsDurationUpdated(uint256 newDuration);\n', '    event Recovered(address token, uint256 amount);\n', '\n', '    */\n', '   } \n', '}']