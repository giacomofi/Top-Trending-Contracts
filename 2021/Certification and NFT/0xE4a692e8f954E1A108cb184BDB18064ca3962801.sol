['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-23\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '/*\n', '   ____            __   __        __   _\n', '  / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __\n', ' _\\ \\ / // // _ \\/ __// _ \\/ -_)/ __// / \\ \\ /\n', '/___/ \\_, //_//_/\\__//_//_/\\__/ \\__//_/ /_\\_\\\n', '     /___/\n', '* Synthetix: StakingRewards.sol\n', '*\n', '* Docs: https://docs.synthetix.io/\n', '*\n', '*\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2020 Synthetix\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * > It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through `transferFrom`. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when `approve` or `transferFrom` are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * > Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an `Approval` event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to `approve`. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IStakingRewards {\n', '    // Views\n', '    function lastTimeRewardApplicable() external view returns (uint256);\n', '\n', '    function rewardPerToken() external view returns (uint256);\n', '\n', '    function earned(address account) external view returns (uint256);\n', '\n', '    function getRewardForDuration() external view returns (uint256);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    // Mutative\n', '\n', '    function stake(uint256 amount) external;\n', '\n', '    function withdraw(uint256 amount) external;\n', '\n', '    function getReward() external;\n', '\n', '    function exit() external;\n', '}\n', '\n', 'library Math {\n', '    /**\n', '     * @dev Returns the largest of two numbers.\n', '     */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public nominatedOwner;\n', '\n', '    constructor(address _owner) public {\n', '        require(_owner != address(0), "Owner address cannot be 0");\n', '        owner = _owner;\n', '        emit OwnerChanged(address(0), _owner);\n', '    }\n', '\n', '    function nominateNewOwner(address _owner) external onlyOwner {\n', '        nominatedOwner = _owner;\n', '        emit OwnerNominated(_owner);\n', '    }\n', '\n', '    function acceptOwnership() external {\n', '        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");\n', '        emit OwnerChanged(owner, nominatedOwner);\n', '        owner = nominatedOwner;\n', '        nominatedOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        _onlyOwner();\n', '        _;\n', '    }\n', '\n', '    function _onlyOwner() private view {\n', '        require(msg.sender == owner, "Only the contract owner may perform this action");\n', '    }\n', '\n', '    event OwnerNominated(address newOwner);\n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '}\n', '\n', 'contract Pausable is Owned {\n', '    uint public lastPauseTime;\n', '    bool public paused;\n', '\n', '    constructor() internal {\n', '        // This contract is abstract, and thus cannot be instantiated directly\n', '        require(owner != address(0), "Owner must be set");\n', '        // Paused will be false, and lastPauseTime will be 0 upon initialisation\n', '    }\n', '\n', '    /**\n', '     * @notice Change the paused state of the contract\n', '     * @dev Only the contract owner may call this.\n', '     */\n', '    function setPaused(bool _paused) external onlyOwner {\n', "        // Ensure we're actually changing the state before we do anything\n", '        if (_paused == paused) {\n', '            return;\n', '        }\n', '\n', '        // Set our paused state.\n', '        paused = _paused;\n', '\n', '        // If applicable, set the last pause time.\n', '        if (paused) {\n', '            lastPauseTime = now;\n', '        }\n', '\n', '        // Let everyone know that our pause state has changed.\n', '        emit PauseChanged(paused);\n', '    }\n', '\n', '    event PauseChanged(bool isPaused);\n', '\n', '    modifier notPaused {\n', '        require(!paused, "This action cannot be performed while the contract is paused");\n', '        _;\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard {\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        // The counter starts at one to prevent changing it from zero to a non-zero\n', '        // value, which is a more expensive operation.\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");\n', '    }\n', '}\n', '\n', 'contract RewardsDistributionRecipient is Owned {\n', '    address public rewardsDistribution;\n', '\n', '    function notifyRewardAmount(uint256 reward) external;\n', '\n', '    modifier onlyRewardsDistribution() {\n', '        require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");\n', '        _;\n', '    }\n', '\n', '    function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {\n', '        rewardsDistribution = _rewardsDistribution;\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    /* ========== STATE VARIABLES ========== */\n', '\n', '    IERC20 public rewardsToken;\n', '    IERC20 public stakingToken;\n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public rewardsDuration;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    /* ========== CONSTRUCTOR ========== */\n', '\n', '    constructor(\n', '        address _owner,\n', '        address _rewardsDistribution,\n', '        address _rewardsToken,\n', '        address _stakingToken,\n', '        uint256 _rewardsDuration\n', '    ) public Owned(_owner) {\n', '        rewardsToken = IERC20(_rewardsToken);\n', '        stakingToken = IERC20(_stakingToken);\n', '        rewardsDistribution = _rewardsDistribution;\n', '        rewardsDuration = _rewardsDuration;\n', '    }\n', '\n', '    /* ========== VIEWS ========== */\n', '\n', '    function totalSupply() external view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) external view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (_totalSupply == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '            rewardPerTokenStored.add(\n', '                lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)\n', '            );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);\n', '    }\n', '\n', '    function getRewardForDuration() external view returns (uint256) {\n', '        return rewardRate.mul(rewardsDuration);\n', '    }\n', '\n', '    /* ========== MUTATIVE FUNCTIONS ========== */\n', '\n', '    function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {\n', '        require(amount > 0, "Cannot stake 0");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '        stakingToken.safeTransferFrom(msg.sender, address(this), amount);\n', '        emit Staked(msg.sender, amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        stakingToken.safeTransfer(msg.sender, amount);\n', '        emit Withdrawn(msg.sender, amount);\n', '    }\n', '\n', '    function getReward() public nonReentrant updateReward(msg.sender) {\n', '        uint256 reward = rewards[msg.sender];\n', '        if (reward > 0) {\n', '            rewards[msg.sender] = 0;\n', '            rewardsToken.safeTransfer(msg.sender, reward);\n', '            emit RewardPaid(msg.sender, reward);\n', '        }\n', '    }\n', '\n', '    function exit() external {\n', '        withdraw(_balances[msg.sender]);\n', '        getReward();\n', '    }\n', '\n', '    /* ========== RESTRICTED FUNCTIONS ========== */\n', '\n', '    function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {\n', '        // handle the transfer of reward tokens via `transferFrom` to reduce the number\n', '        // of transactions required and ensure correctness of the reward amount\n', '        rewardsToken.safeTransferFrom(msg.sender, address(this), reward);\n', '\n', '        if (block.timestamp >= periodFinish) {\n', '            rewardRate = reward.div(rewardsDuration);\n', '        } else {\n', '            uint256 remaining = periodFinish.sub(block.timestamp);\n', '            uint256 leftover = remaining.mul(rewardRate);\n', '            rewardRate = reward.add(leftover).div(rewardsDuration);\n', '        }\n', '\n', '        lastUpdateTime = block.timestamp;\n', '        periodFinish = block.timestamp.add(rewardsDuration);\n', '        emit RewardAdded(reward);\n', '    }\n', '\n', '    // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders\n', '    function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {\n', '        require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");\n', '        IERC20(tokenAddress).safeTransfer(owner, tokenAmount);\n', '        emit Recovered(tokenAddress, tokenAmount);\n', '    }\n', '\n', '    function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {\n', '        require(\n', '            block.timestamp > periodFinish,\n', '            "Previous rewards period must be complete before changing the duration for the new period"\n', '        );\n', '        rewardsDuration = _rewardsDuration;\n', '        emit RewardsDurationUpdated(rewardsDuration);\n', '    }\n', '\n', '    /* ========== MODIFIERS ========== */\n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    /* ========== EVENTS ========== */\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '    event RewardsDurationUpdated(uint256 newDuration);\n', '    event Recovered(address token, uint256 amount);\n', '}']