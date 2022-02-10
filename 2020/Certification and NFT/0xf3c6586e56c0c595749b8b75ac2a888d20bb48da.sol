['// File: contracts/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see `ERC20Detailed`.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through `transferFrom`. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when `approve` or `transferFrom` are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * > Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an `Approval` event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to `approve`. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type,\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * > It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '// File: contracts/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/TokenPool.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '/**\n', ' * @title A simple holder of tokens.\n', " * This is a simple contract to hold tokens. It's useful in the case where a separate contract\n", ' * needs to hold multiple distinct pools of the same token.\n', ' */\n', 'contract TokenPool is Ownable {\n', '    IERC20 public token;\n', '\n', '    constructor(IERC20 _token) public {\n', '        token = _token;\n', '    }\n', '\n', '    function balance() public view returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    function transfer(address to, uint256 value) external onlyOwner returns (bool) {\n', '        return token.transfer(to, value);\n', '    }\n', '\n', '    function rescueFunds(address tokenToRescue, address to, uint256 amount) external onlyOwner returns (bool) {\n', "        require(address(token) != tokenToRescue, 'TokenPool: Cannot claim token held by the contract');\n", '\n', '        return IERC20(tokenToRescue).transfer(to, amount);\n', '    }\n', '}\n', '\n', '// File: contracts/LiquidityMining.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Token Geyser\n', ' * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by\n', ' *      Compound and Uniswap.\n', ' *\n', ' *      Distribution tokens are added to a locked pool in the contract and become unlocked over time\n', ' *      according to a once-configurable unlock schedule. Once unlocked, they are available to be\n', ' *      claimed by users.\n', ' *\n', ' *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share\n', ' *      is a function of the number of tokens deposited as well as the length of time deposited.\n', ' *      Specifically, a user\'s share of the currently-unlocked pool equals their "deposit-seconds"\n', ' *      divided by the global "deposit-seconds". This aligns the new token distribution with long\n', ' *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.\n', ' *\n', ' *      More background and motivation available at:\n', ' *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md\n', ' */\n', 'contract LiquidityMining is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  event Staked(address indexed user, uint256 amount, uint256 total, bytes data);\n', '  event Unstaked(\n', '    address indexed user,\n', '    uint256 amount,\n', '    uint256 total,\n', '    bytes data\n', '  );\n', '  event TokensClaimed(address indexed user, uint256 amount);\n', '  event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);\n', '  // amount: Unlocked tokens, total: Total locked tokens\n', '  event TokensUnlocked(uint256 amount, uint256 total);\n', '\n', '  TokenPool private _stakingPool;\n', '  TokenPool private _unlockedPool;\n', '  TokenPool private _lockedPool;\n', '\n', '  //\n', '  // Time-bonus params\n', '  //\n', '  uint256 public constant BONUS_DECIMALS = 2;\n', '  uint256 public startBonus = 0;\n', '  uint256 public bonusPeriodSec = 0;\n', '\n', '  //\n', '  // Global accounting state\n', '  //\n', '  uint256 public totalLockedShares = 0;\n', '  uint256 public totalStakingShares = 0;\n', '  uint256 private _totalStakingShareSeconds = 0;\n', '  uint256 private _lastAccountingTimestampSec = now;\n', '  uint256 private _maxUnlockSchedules = 0;\n', '  uint256 private _initialSharesPerToken = 0;\n', '\n', '  //\n', '  // User accounting state\n', '  //\n', '  // Represents a single stake for a user. A user may have multiple.\n', '  struct Stake {\n', '    uint256 stakingShares;\n', '    uint256 timestampSec;\n', '  }\n', '\n', '  // Caches aggregated values from the User->Stake[] map to save computation.\n', "  // If lastAccountingTimestampSec is 0, there's no entry for that user.\n", '  struct UserTotals {\n', '    uint256 stakingShares;\n', '    uint256 stakingShareSeconds;\n', '    uint256 lastAccountingTimestampSec;\n', '  }\n', '\n', '  // Aggregated staking values per user\n', '  mapping(address => UserTotals) private _userTotals;\n', '\n', '  // The collection of stakes for each user. Ordered by timestamp, earliest to latest.\n', '  mapping(address => Stake[]) private _userStakes;\n', '\n', '  //\n', '  // Locked/Unlocked Accounting state\n', '  //\n', '  struct UnlockSchedule {\n', '    uint256 initialLockedShares;\n', '    uint256 unlockedShares;\n', '    uint256 lastUnlockTimestampSec;\n', '    uint256 endAtSec;\n', '    uint256 durationSec;\n', '  }\n', '\n', '  UnlockSchedule[] public unlockSchedules;\n', '\n', '  /**\n', '   * @param stakingToken The token users deposit as stake.\n', '   * @param distributionToken The token users receive as they unstake.\n', '   * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.\n', '   * @param startBonus_ Starting time bonus, BONUS_DECIMALS fixed point.\n', '   *                    e.g. 25% means user gets 25% of max distribution tokens.\n', '   * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.\n', '   * @param initialSharesPerToken Number of shares to mint per staking token on first stake.\n', '   */\n', '  constructor(\n', '    address stakingToken,\n', '    address distributionToken,\n', '    uint256 maxUnlockSchedules,\n', '    uint256 startBonus_,\n', '    uint256 bonusPeriodSec_,\n', '    uint256 initialSharesPerToken\n', '  ) public {\n', '    // The start bonus must be some fraction of the max. (i.e. <= 100%)\n', '    require(\n', '      startBonus_ <= 10**BONUS_DECIMALS,\n', '      "TokenGeyser: start bonus too high"\n', '    );\n', '    // If no period is desired, instead set startBonus = 100%\n', '    // and bonusPeriod to a small value like 1sec.\n', '    require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");\n', '    require(\n', '      initialSharesPerToken > 0,\n', '      "TokenGeyser: initialSharesPerToken is zero"\n', '    );\n', '\n', '    _stakingPool = new TokenPool(IERC20(stakingToken));\n', '    _unlockedPool = new TokenPool(IERC20(distributionToken));\n', '    _lockedPool = new TokenPool(IERC20(distributionToken));\n', '    startBonus = startBonus_;\n', '    bonusPeriodSec = bonusPeriodSec_;\n', '    _maxUnlockSchedules = maxUnlockSchedules;\n', '    _initialSharesPerToken = initialSharesPerToken;\n', '  }\n', '\n', '  /**\n', '   * @return The token users deposit as stake.\n', '   */\n', '  function getStakingToken() public view returns (IERC20) {\n', '    return _stakingPool.token();\n', '  }\n', '\n', '  /**\n', '   * @return The token users receive as they unstake.\n', '   */\n', '  function getDistributionToken() public view returns (IERC20) {\n', '    assert(_unlockedPool.token() == _lockedPool.token());\n', '    return _unlockedPool.token();\n', '  }\n', '\n', '\n', '  function stake(uint256 amount) external {\n', '    _stakeFor(msg.sender, msg.sender, amount);\n', '  }\n', '\n', '\n', '  function stakeFor(\n', '    address user,\n', '    uint256 amount\n', '   \n', '  ) external onlyOwner {\n', '    _stakeFor(msg.sender, user, amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Private implementation of staking methods.\n', '   * @param staker User address who deposits tokens to stake.\n', '   * @param beneficiary User address who gains credit for this stake operation.\n', '   * @param amount Number of deposit tokens to stake.\n', '   */\n', '  function _stakeFor(\n', '    address staker,\n', '    address beneficiary,\n', '    uint256 amount\n', '  ) private {\n', '    require(amount > 0, "TokenGeyser: stake amount is zero");\n', '    require(\n', '      beneficiary != address(0),\n', '      "TokenGeyser: beneficiary is zero address"\n', '    );\n', '    require(\n', '      totalStakingShares == 0 || totalStaked() > 0,\n', '      "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"\n', '    );\n', '\n', '    uint256 mintedStakingShares = (totalStakingShares > 0)\n', '      ? totalStakingShares.mul(amount).div(totalStaked())\n', '      : amount.mul(_initialSharesPerToken);\n', '    require(mintedStakingShares > 0, "TokenGeyser: Stake amount is too small");\n', '\n', '    updateAccounting();\n', '\n', '    // 1. User Accounting\n', '    _userTotals[beneficiary].stakingShares = _userTotals[beneficiary]\n', '      .stakingShares\n', '      .add(mintedStakingShares);\n', '    _userTotals[beneficiary].lastAccountingTimestampSec = now;\n', '\n', '    Stake memory newStake = Stake(mintedStakingShares, now);\n', '    _userStakes[beneficiary].push(newStake);\n', '\n', '    // 2. Global Accounting\n', '    totalStakingShares = totalStakingShares.add(mintedStakingShares);\n', '    // Already set in updateAccounting()\n', '    // _lastAccountingTimestampSec = now;\n', '\n', '    // interactions\n', '    require(\n', '      _stakingPool.token().transferFrom(staker, address(_stakingPool), amount),\n', '      "TokenGeyser: transfer into staking pool failed"\n', '    );\n', '\n', '    emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");\n', '  }\n', '\n', '\n', '  function unstake(uint256 amount) external {\n', '    _unstake(amount);\n', '  }\n', '\n', '  /**\n', '   * @param amount Number of deposit tokens to unstake / withdraw.\n', '   * @return The total number of distribution tokens that would be rewarded.\n', '   */\n', '  function unstakeQuery(uint256 amount) public returns (uint256) {\n', '    return _unstake(amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Unstakes a certain amount of previously deposited tokens. User also receives their\n', '   * alotted number of distribution tokens.\n', '   * @param amount Number of deposit tokens to unstake / withdraw.\n', '   * @return The total number of distribution tokens rewarded.\n', '   */\n', '  function _unstake(uint256 amount) private returns (uint256) {\n', '    updateAccounting();\n', '\n', '    // checks\n', '    require(amount > 0, "TokenGeyser: unstake amount is zero");\n', '    require(\n', '      totalStakedFor(msg.sender) >= amount,\n', '      "TokenGeyser: unstake amount is greater than total user stakes"\n', '    );\n', '    uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(\n', '      totalStaked()\n', '    );\n', '    require(\n', '      stakingSharesToBurn > 0,\n', '      "TokenGeyser: Unable to unstake amount this small"\n', '    );\n', '\n', '    // Redeem from most recent stake and go backwards in time.\n', '    uint256 stakingShareSecondsToBurn = 0;\n', '    uint256 sharesLeftToBurn = stakingSharesToBurn;\n', '    uint256 rewardAmount = 0;\n', '    while (sharesLeftToBurn > 0) {\n', '      Stake storage lastStake = _userStakes[msg.sender][_userStakes[msg.sender]\n', '        .length - 1];\n', '      uint256 stakeTimeSec = now.sub(lastStake.timestampSec);\n', '      uint256 newStakingShareSecondsToBurn = 0;\n', '      if (lastStake.stakingShares <= sharesLeftToBurn) {\n', '        // fully redeem a past stake\n', '        newStakingShareSecondsToBurn = lastStake.stakingShares.mul(\n', '          stakeTimeSec\n', '        );\n', '        rewardAmount = computeNewReward(\n', '          rewardAmount,\n', '          newStakingShareSecondsToBurn,\n', '          stakeTimeSec\n', '        );\n', '        stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(\n', '          newStakingShareSecondsToBurn\n', '        );\n', '        sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.stakingShares);\n', '        _userStakes[msg.sender].length--;\n', '      } else {\n', '        // partially redeem a past stake\n', '        newStakingShareSecondsToBurn = sharesLeftToBurn.mul(stakeTimeSec);\n', '        rewardAmount = computeNewReward(\n', '          rewardAmount,\n', '          newStakingShareSecondsToBurn,\n', '          stakeTimeSec\n', '        );\n', '        stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(\n', '          newStakingShareSecondsToBurn\n', '        );\n', '        lastStake.stakingShares = lastStake.stakingShares.sub(sharesLeftToBurn);\n', '        sharesLeftToBurn = 0;\n', '      }\n', '    }\n', '    _userTotals[msg.sender].stakingShareSeconds = _userTotals[msg.sender]\n', '      .stakingShareSeconds\n', '      .sub(stakingShareSecondsToBurn);\n', '    _userTotals[msg.sender].stakingShares = _userTotals[msg.sender]\n', '      .stakingShares\n', '      .sub(stakingSharesToBurn);\n', '    // Already set in updateAccounting\n', '    // totals.lastAccountingTimestampSec = now;\n', '\n', '    // 2. Global Accounting\n', '    _totalStakingShareSeconds = _totalStakingShareSeconds.sub(\n', '      stakingShareSecondsToBurn\n', '    );\n', '    totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);\n', '    // Already set in updateAccounting\n', '    // _lastAccountingTimestampSec = now;\n', '\n', '    // interactions\n', '    require(\n', '      _stakingPool.transfer(msg.sender, amount),\n', '      "TokenGeyser: transfer out of staking pool failed"\n', '    );\n', '    require(\n', '      _unlockedPool.transfer(msg.sender, rewardAmount),\n', '      "TokenGeyser: transfer out of unlocked pool failed"\n', '    );\n', '\n', '    emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");\n', '    emit TokensClaimed(msg.sender, rewardAmount);\n', '\n', '    require(\n', '      totalStakingShares == 0 || totalStaked() > 0,\n', '      "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"\n', '    );\n', '    return rewardAmount;\n', '  }\n', '\n', '  /**\n', '   * @dev Applies an additional time-bonus to a distribution amount. This is necessary to\n', '   *      encourage long-term deposits instead of constant unstake/restakes.\n', '   *      The bonus-multiplier is the result of a linear function that starts at startBonus and\n', '   *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.\n', '   * @param currentRewardTokens The current number of distribution tokens already alotted for this\n', '   *                            unstake op. Any bonuses are already applied.\n', '   * @param stakingShareSeconds The stakingShare-seconds that are being burned for new\n', '   *                            distribution tokens.\n', '   * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate\n', '   *                     the time-bonus.\n', '   * @return Updated amount of distribution tokens to award, with any bonus included on the\n', '   *         newly added tokens.\n', '   */\n', '  function computeNewReward(\n', '    uint256 currentRewardTokens,\n', '    uint256 stakingShareSeconds,\n', '    uint256 stakeTimeSec\n', '  ) private view returns (uint256) {\n', '    uint256 newRewardTokens = totalUnlocked().mul(stakingShareSeconds).div(\n', '      _totalStakingShareSeconds\n', '    );\n', '\n', '    if (stakeTimeSec >= bonusPeriodSec) {\n', '      return currentRewardTokens.add(newRewardTokens);\n', '    }\n', '\n', '    uint256 oneHundredPct = 10**BONUS_DECIMALS;\n', '    uint256 bonusedReward = startBonus\n', '      .add(oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(bonusPeriodSec))\n', '      .mul(newRewardTokens)\n', '      .div(oneHundredPct);\n', '    return currentRewardTokens.add(bonusedReward);\n', '  }\n', '\n', '  /**\n', '   * @param addr The user to look up staking information for.\n', '   * @return The number of staking tokens deposited for addr.\n', '   */\n', '  function totalStakedFor(address addr) public view returns (uint256) {\n', '    return\n', '      totalStakingShares > 0\n', '        ? totalStaked().mul(_userTotals[addr].stakingShares).div(\n', '          totalStakingShares\n', '        )\n', '        : 0;\n', '  }\n', '\n', '  function totalShares() public view returns (uint256) {\n', '    return totalStakingShares;\n', '  }\n', '\n', '  function userStakingShares(address addr) public view returns (uint256) {\n', '    return _userTotals[addr].stakingShares;\n', '  }\n', '\n', '  /**\n', '   * @return The total number of deposit tokens staked globally, by all users.\n', '   */\n', '  function totalStaked() public view returns (uint256) {\n', '    return _stakingPool.balance();\n', '  }\n', '\n', '  /**\n', '   * @dev Note that this application has a staking token as well as a distribution token, which\n', '   * may be different. This function is required by EIP-900.\n', '   * @return The deposit token used for staking.\n', '   */\n', '  function token() external view returns (address) {\n', '    return address(getStakingToken());\n', '  }\n', '\n', '  /**\n', '   * @dev A globally callable function to update the accounting state of the system.\n', '   *      Global state and state for the caller are updated.\n', '   * @return [0] balance of the locked pool\n', '   * @return [1] balance of the unlocked pool\n', "   * @return [2] caller's staking share seconds\n", '   * @return [3] global staking share seconds\n', '   * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.\n', '   * @return [5] block timestamp\n', '   */\n', '  function updateAccounting()\n', '    public\n', '    returns (\n', '      uint256,\n', '      uint256,\n', '      uint256,\n', '      uint256,\n', '      uint256,\n', '      uint256\n', '    )\n', '  {\n', '    unlockTokens();\n', '\n', '    // Global accounting\n', '    uint256 newStakingShareSeconds = now.sub(_lastAccountingTimestampSec).mul(\n', '      totalStakingShares\n', '    );\n', '    _totalStakingShareSeconds = _totalStakingShareSeconds.add(\n', '      newStakingShareSeconds\n', '    );\n', '    _lastAccountingTimestampSec = now;\n', '\n', '    // User Accounting\n', '    uint256 newUserStakingShareSeconds = now\n', '      .sub(_userTotals[msg.sender].lastAccountingTimestampSec)\n', '      .mul(_userTotals[msg.sender].stakingShares);\n', '    _userTotals[msg.sender].stakingShareSeconds = _userTotals[msg.sender]\n', '      .stakingShareSeconds\n', '      .add(newUserStakingShareSeconds);\n', '    _userTotals[msg.sender].lastAccountingTimestampSec = now;\n', '\n', '    uint256 totalUserRewards = (_totalStakingShareSeconds > 0)\n', '      ? totalUnlocked().mul(_userTotals[msg.sender].stakingShareSeconds).div(\n', '        _totalStakingShareSeconds\n', '      )\n', '      : 0;\n', '\n', '    return (\n', '      totalLocked(),\n', '      totalUnlocked(),\n', '      _userTotals[msg.sender].stakingShareSeconds,\n', '      _totalStakingShareSeconds,\n', '      totalUserRewards,\n', '      now\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @return Total number of locked distribution tokens.\n', '   */\n', '  function totalLocked() public view returns (uint256) {\n', '    return _lockedPool.balance();\n', '  }\n', '\n', '  /**\n', '   * @return Total number of unlocked distribution tokens.\n', '   */\n', '  function totalUnlocked() public view returns (uint256) {\n', '    return _unlockedPool.balance();\n', '  }\n', '\n', '  /**\n', '   * @return Number of unlock schedules.\n', '   */\n', '  function unlockScheduleCount() public view returns (uint256) {\n', '    return unlockSchedules.length;\n', '  }\n', '\n', '  /**\n', '   * @dev This funcion allows the contract owner to add more locked distribution tokens, along\n', '   *      with the associated "unlock schedule". These locked tokens immediately begin unlocking\n', '   *      linearly over the duraction of durationSec timeframe.\n', '   * @param amount Number of distribution tokens to lock. These are transferred from the caller.\n', '   * @param durationSec Length of time to linear unlock the tokens.\n', '   */\n', '  function lockTokens(uint256 amount, uint256 durationSec) external onlyOwner {\n', '    require(\n', '      unlockSchedules.length < _maxUnlockSchedules,\n', '      "TokenGeyser: reached maximum unlock schedules"\n', '    );\n', '\n', '    // Update lockedTokens amount before using it in computations after.\n', '    updateAccounting();\n', '\n', '    uint256 lockedTokens = totalLocked();\n', '    uint256 mintedLockedShares = (lockedTokens > 0)\n', '      ? totalLockedShares.mul(amount).div(lockedTokens)\n', '      : amount.mul(_initialSharesPerToken);\n', '\n', '    UnlockSchedule memory schedule;\n', '    schedule.initialLockedShares = mintedLockedShares;\n', '    schedule.lastUnlockTimestampSec = now;\n', '    schedule.endAtSec = now.add(durationSec);\n', '    schedule.durationSec = durationSec;\n', '    unlockSchedules.push(schedule);\n', '\n', '    totalLockedShares = totalLockedShares.add(mintedLockedShares);\n', '\n', '    require(\n', '      _lockedPool.token().transferFrom(\n', '        msg.sender,\n', '        address(_lockedPool),\n', '        amount\n', '      ),\n', '      "TokenGeyser: transfer into locked pool failed"\n', '    );\n', '    emit TokensLocked(amount, durationSec, totalLocked());\n', '  }\n', '\n', '  /**\n', '   * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the\n', '   *      previously defined unlock schedules. Publicly callable.\n', '   * @return Number of newly unlocked distribution tokens.\n', '   */\n', '  function unlockTokens() public returns (uint256) {\n', '    uint256 unlockedTokens = 0;\n', '    uint256 lockedTokens = totalLocked();\n', '\n', '    if (totalLockedShares == 0) {\n', '      unlockedTokens = lockedTokens;\n', '    } else {\n', '      uint256 unlockedShares = 0;\n', '      for (uint256 s = 0; s < unlockSchedules.length; s++) {\n', '        unlockedShares = unlockedShares.add(unlockScheduleShares(s));\n', '      }\n', '      unlockedTokens = unlockedShares.mul(lockedTokens).div(totalLockedShares);\n', '      totalLockedShares = totalLockedShares.sub(unlockedShares);\n', '    }\n', '\n', '    if (unlockedTokens > 0) {\n', '      require(\n', '        _lockedPool.transfer(address(_unlockedPool), unlockedTokens),\n', '        "TokenGeyser: transfer out of locked pool failed"\n', '      );\n', '      emit TokensUnlocked(unlockedTokens, totalLocked());\n', '    }\n', '\n', '    return unlockedTokens;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the number of unlockable shares from a given schedule. The returned value\n', '   *      depends on the time since the last unlock. This function updates schedule accounting,\n', '   *      but does not actually transfer any tokens.\n', '   * @param s Index of the unlock schedule.\n', '   * @return The number of unlocked shares.\n', '   */\n', '  function unlockScheduleShares(uint256 s) private returns (uint256) {\n', '    UnlockSchedule storage schedule = unlockSchedules[s];\n', '\n', '    if (schedule.unlockedShares >= schedule.initialLockedShares) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 sharesToUnlock = 0;\n', '    // Special case to handle any leftover dust from integer division\n', '    if (now >= schedule.endAtSec) {\n', '      sharesToUnlock = (\n', '        schedule.initialLockedShares.sub(schedule.unlockedShares)\n', '      );\n', '      schedule.lastUnlockTimestampSec = schedule.endAtSec;\n', '    } else {\n', '      sharesToUnlock = now\n', '        .sub(schedule.lastUnlockTimestampSec)\n', '        .mul(schedule.initialLockedShares)\n', '        .div(schedule.durationSec);\n', '      schedule.lastUnlockTimestampSec = now;\n', '    }\n', '\n', '    schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);\n', '    return sharesToUnlock;\n', '  }\n', '\n', '  /**\n', '   * @dev Lets the owner rescue funds air-dropped to the staking pool.\n', '   * @param tokenToRescue Address of the token to be rescued.\n', '   * @param to Address to which the rescued funds are to be sent.\n', '   * @param amount Amount of tokens to be rescued.\n', '   * @return Transfer success.\n', '   */\n', '  function rescueFundsFromStakingPool(\n', '    address tokenToRescue,\n', '    address to,\n', '    uint256 amount\n', '  ) public onlyOwner returns (bool) {\n', '    return _stakingPool.rescueFunds(tokenToRescue, to, amount);\n', '  }\n', '}']