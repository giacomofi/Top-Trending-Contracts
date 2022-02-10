['// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: contracts/Ownable.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', '\n', 'contract Ownable is Context {\n', '\n', '    address payable public owner;\n', '\n', '    event TransferredOwnership(address _previous, address _next, uint256 _time);\n', '\n', '    modifier onlyOwner() {\n', '        require(_msgSender() == owner, "Owner only");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = _msgSender();\n', '    }\n', '\n', '    function transferOwnership(address payable _owner) public onlyOwner() {\n', '        address previousOwner = owner;\n', '        owner = _owner;\n', '        emit TransferredOwnership(previousOwner, owner, now);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/LUCOVault.sol\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', 'contract LUCOVault is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    struct User {\n', '        uint256 _LPDeposited;\n', '        uint256 _rewardDebt;\n', '    }\n', '\n', '    event StakeCompleted(address _staker, uint256 _amount, uint256 _totalStaked, uint256 _time);\n', '    event PoolUpdated(uint256 _blocksRewarded, uint256 _amountRewarded, uint256 _time);\n', '    event RewardsClaimed(address _staker, uint256 _rewardsClaimed, uint256 _time);\n', '    event EmergencyWithdrawOn(address _caller, bool _emergencyWithdraw, uint256 _time);\n', '    event WithdrawCompleted(address _staker, uint256 _amount, uint256 _time);\n', '\n', '    IERC20 public LPToken;\n', '    IERC20 public LucoToken;\n', '    address public rewardPool;\n', '    uint256 public dailyReward;\n', '    uint256 public accLucoPerShare;\n', '    uint256 public lastRewardBlock;\n', '    uint256 public totalStaked;\n', '\n', '    bool public emergencyWithdraw = false;\n', '\n', '    mapping(address => User) public userDetails;\n', '\n', '    // Constructor will set the address of LUCO/ETH LP token\n', '    constructor(address _LPToken, address _LucoToken, address _rewardPool, uint256 _dailyReward) Ownable() public {\n', '        LPToken = IERC20(_LPToken);\n', '        LucoToken = IERC20(_LucoToken);\n', '        rewardPool = _rewardPool;\n', '        lastRewardBlock = block.number;\n', '        setDailyReward(_dailyReward);\n', '        accLucoPerShare = 0;\n', '    }\n', '\n', '    // 6500 blocks in average day --- decimals * Luco balance of rewardPool / blocks / 10000 * dailyReward (in hundredths of %) = rewardPerBlock\n', '    function getRewardPerBlock() public view returns(uint256) {\n', '        return LucoToken.balanceOf(rewardPool).div(6500).div(10000).mul(dailyReward);\n', '    }\n', '\n', '    // % of reward pool to be distributed each day --- in hundredths of % 150 == 1.50%\n', '    function setDailyReward(uint256 _dailyReward) public onlyOwner {\n', '        dailyReward = _dailyReward;\n', '    }\n', '\n', '    // Function that will get balance of a certain stake\n', '    function getUserBalance(address _staker) public view returns(uint256 _amountStaked) {\n', '        return userDetails[_staker]._LPDeposited;\n', '    }\n', '\n', "    // Function that returns User's pending rewards\n", '    function pendingRewards(address _staker) public view returns(uint256) {\n', '        User storage user = userDetails[_staker];\n', '\n', '        uint256 _accLucoPerShare = accLucoPerShare;\n', '\n', '        if (block.number > lastRewardBlock && totalStaked != 0) {\n', '            uint256 blocksToReward = block.number.sub(lastRewardBlock);\n', '            uint256 lucoReward = blocksToReward.mul(getRewardPerBlock());\n', '            _accLucoPerShare = _accLucoPerShare.add(lucoReward.mul(1e18).div(totalStaked));\n', '        }\n', '\n', '        return user._LPDeposited.mul(_accLucoPerShare).div(1e18).sub(user._rewardDebt);\n', '    }\n', '\n', '    // Function that updates LUCO/ETH LP pool\n', '    function updatePool() public {\n', '        if (block.number <= lastRewardBlock) {\n', '            return;\n', '        }\n', '\n', '        if (totalStaked == 0) {\n', '            lastRewardBlock = block.number;\n', '            return;\n', '        }\n', '\n', '        uint256 blocksToReward = block.number.sub(lastRewardBlock);\n', '\n', '        uint256 lucoReward = blocksToReward.mul(getRewardPerBlock());\n', '\n', '        LucoToken.transferFrom(rewardPool, address(this), lucoReward);\n', '\n', '        accLucoPerShare = accLucoPerShare.add(lucoReward.mul(1e18).div(totalStaked));\n', '        lastRewardBlock = block.number;\n', '\n', '        emit PoolUpdated(blocksToReward, lucoReward, now);\n', '    }\n', '\n', '    // Function that lets user stake LUCO/ETH LP\n', '    function stakeLP(uint256 _amount) public {\n', '        require(emergencyWithdraw == false, "emergency withdraw is on, cannot stake");\n', '        require(_amount > 0, "Can not stake 0 LP tokens");\n', '        require(LPToken.balanceOf(_msgSender()) >= _amount, "Do not have enough LP tokens to stake");\n', '\n', '        updatePool();\n', '\n', '        User storage user = userDetails[_msgSender()];\n', '\n', '        if(user._LPDeposited > 0) {\n', '            uint256 _pendingRewards = user._LPDeposited.mul(accLucoPerShare).div(1e18).sub(user._rewardDebt);\n', '\n', '            if(_pendingRewards > 0) {\n', '                LucoToken.transfer(_msgSender(), _pendingRewards);\n', '                emit RewardsClaimed(_msgSender(), _pendingRewards, now);\n', '            }\n', '        }\n', '\n', '        LPToken.transferFrom(_msgSender(), address(this), _amount);\n', '        user._LPDeposited = user._LPDeposited.add(_amount);\n', '        totalStaked = totalStaked.add(_amount);\n', '\n', '        user._rewardDebt = user._LPDeposited.mul(accLucoPerShare).div(1e18);\n', '\n', '        emit StakeCompleted(_msgSender(), _amount, user._LPDeposited, now);\n', '    }\n', '\n', '    // Function that will allow user to claim rewards\n', '    function claimRewards() public {\n', '        updatePool();\n', '\n', '        User storage user = userDetails[_msgSender()];\n', '\n', '        uint256 _pendingRewards = user._LPDeposited.mul(accLucoPerShare).div(1e18).sub(user._rewardDebt);\n', '        require(_pendingRewards > 0, "No rewards to claim!");\n', '\n', '        LucoToken.transfer(_msgSender(), _pendingRewards);\n', '\n', '        user._rewardDebt = user._LPDeposited.mul(accLucoPerShare).div(1e18);\n', '\n', '        emit RewardsClaimed(_msgSender(), _pendingRewards, now);\n', '    }\n', '\n', '    // Function that lets user unstake Luco/ETH LP in system\n', '    function unstakeLP() public {\n', '        require(emergencyWithdraw == true, "Can not withdraw");\n', '\n', '        updatePool();\n', '\n', '        User storage user = userDetails[_msgSender()];\n', '        require(user._LPDeposited > 0, "User has no stake");\n', '\n', '        uint256 _pendingRewards = user._LPDeposited.mul(accLucoPerShare).div(1e18).sub(user._rewardDebt);\n', '\n', '        uint256 beingWithdrawn = user._LPDeposited;\n', '\n', '        user._LPDeposited = 0;\n', '        user._rewardDebt = 0;\n', '\n', '        totalStaked = totalStaked.sub(beingWithdrawn);\n', '\n', '        LPToken.transfer(_msgSender(), beingWithdrawn);\n', '        LucoToken.transfer(_msgSender(), _pendingRewards);\n', '\n', '        emit WithdrawCompleted(_msgSender(), beingWithdrawn, now);\n', '        emit RewardsClaimed(_msgSender(), _pendingRewards, now);\n', '    }\n', '\n', '    // Function that will turn on emergency withdraws\n', '    function turnEmergencyWithdrawOn() public onlyOwner() {\n', '        require(emergencyWithdraw == false, "emergency withdrawing already allowed");\n', '        emergencyWithdraw = true;\n', '        emit EmergencyWithdrawOn(_msgSender(), emergencyWithdraw, now);\n', '    }\n', '\n', '}']