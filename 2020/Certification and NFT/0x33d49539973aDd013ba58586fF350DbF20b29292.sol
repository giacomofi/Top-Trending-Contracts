['// Created By BitDNS.vip\n', '// contact : Reward Pool\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.8;\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * IMPORTANT: It is unsafe to assume that an address for which this\n', '     * function returns false is an externally-owned account (EOA) and not a\n', '     * contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '      \n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract IMinableERC20 is IERC20 {\n', '    function mint(address account, uint amount) public;\n', '}\n', '\n', 'contract RewardLockPool {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '    using SafeERC20 for IERC20;\n', '    using SafeERC20 for IMinableERC20;\n', '\n', '    IERC20 public stakeToken;\n', '    IMinableERC20 public rewardToken;\n', '    \n', '    bool public started;\n', '    uint256 public totalSupply;\n', '    uint256 public rewardFinishTime = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => uint256) public lockTimeOf;\n', '    address private governance;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount, uint256 beforeT, uint256 afterT);\n', '    event Withdrawn(address indexed user, uint256 amount, uint256 beforeT, uint256 afterT);\n', '    event RewardPaid(address indexed user, uint256 reward, uint256 beforeT, uint256 afterT);\n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == governance, "!governance");\n', '        _;\n', '    }\n', '\n', '    constructor () public {\n', '        governance = msg.sender;\n', '    }\n', '\n', '    function start(address stake_token, address reward_token, uint256 reward, uint256 duration) public onlyOwner {\n', '        require(!started, "already started");\n', '        require(stake_token != address(0) && stake_token.isContract(), "stake token is non-contract");\n', '        require(reward_token != address(0) && reward_token.isContract(), "reward token is non-contract");\n', '\n', '        started = true;\n', '        stakeToken = IERC20(stake_token);\n', '        rewardToken = IMinableERC20(reward_token);\n', '        rewardRate = reward.mul(1e18).div(duration);\n', '        lastUpdateTime = block.timestamp;\n', '        rewardFinishTime = block.timestamp.add(duration);\n', '    }\n', '\n', '    function lastTimeRewardApplicable() internal view returns (uint256) {\n', '        return block.timestamp < rewardFinishTime ? block.timestamp : rewardFinishTime;\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (totalSupply == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '        rewardPerTokenStored.add(\n', '            lastTimeRewardApplicable()\n', '            .sub(lastUpdateTime)\n', '            .mul(rewardRate)\n', '            .mul(1e18)\n', '            .div(totalSupply)\n', '        );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        return\n', '        balanceOf[account]\n', '        .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))\n', '        .div(1e18)\n', '        .add(rewards[account]);\n', '    }\n', '\n', '    function stake(uint256 amount) public updateReward(msg.sender) {\n', '        require(started, "Not start yet");\n', '        require(amount > 0, "Cannot stake 0");\n', '        require(stakeToken.balanceOf(msg.sender) >= amount, "insufficient balance to stake");\n', '        uint256 beforeT = stakeToken.balanceOf(address(this));\n', '        \n', '        stakeToken.safeTransferFrom(msg.sender, address(this), amount);\n', '        totalSupply = totalSupply.add(amount);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);\n', '        \n', '        uint256 afterT = stakeToken.balanceOf(address(this));\n', '\n', '        // Add Lock Time Begin:\n', '        lockTimeOf[msg.sender] = block.timestamp.add(14 days);\n', '        // Add Lock Time End!!!\n', '\n', '        emit Staked(msg.sender, amount, beforeT, afterT);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public updateReward(msg.sender) {\n', '        require(started, "Not start yet");\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        require(balanceOf[msg.sender] >= amount, "Insufficient balance to withdraw");\n', '\n', '        // Add Lock Time Begin:\n', '        require(canWithdraw(msg.sender), "Must be locked for 14 days or Mining ended");\n', '        // Add Lock Time End!!!\n', '\n', '        uint256 beforeT = stakeToken.balanceOf(address(this));\n', '        \n', '        totalSupply = totalSupply.sub(amount);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);\n', '        stakeToken.safeTransfer(msg.sender, amount);\n', '\n', '        uint256 afterT = stakeToken.balanceOf(address(this));\n', '        emit Withdrawn(msg.sender, amount, beforeT, afterT);\n', '    }\n', '\n', '    function exit() external {\n', '        require(started, "Not start yet");\n', '        withdraw(balanceOf[msg.sender]);\n', '        getReward();\n', '    }\n', '\n', '    function getReward() public updateReward(msg.sender) {\n', '        require(started, "Not start yet");\n', '        \n', '        uint256 reward = earned(msg.sender);\n', '        if (reward > 0) {\n', '            rewards[msg.sender] = 0;\n', '            uint256 beforeT = rewardToken.balanceOf(address(this));\n', '            rewardToken.mint(msg.sender, reward);\n', '            //rewardToken.safeTransfer(msg.sender, reward);\n', '            uint256 afterT = rewardToken.balanceOf(address(this));\n', '            emit RewardPaid(msg.sender, reward, beforeT, afterT);\n', '        }\n', '    }\n', '\n', '    // Add Lock Time Begin:\n', '    function canWithdraw(address account) public view returns (bool) {\n', '        return started && (balanceOf[account] > 0) && \n', '            (block.timestamp >= lockTimeOf[account] || block.timestamp >= rewardFinishTime);\n', '    }\n', '    // Add Lock Time End!!!\n', '}']