['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-01\n', '*/\n', '\n', 'pragma solidity ^0.6.6;\n', '\n', '\n', '// SPDX-License-Identifier: MIT\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface IController {\n', '  function withdraw(address, uint256) external;\n', '\n', '  function balanceOf(address) external view returns (uint256);\n', '\n', '  function earn(address, uint256) external;\n', '\n', '  function want(address) external view returns (address);\n', '\n', '  function rewards() external view returns (address);\n', '\n', '  function vaults(address) external view returns (address);\n', '\n', '  function strategies(address) external view returns (address);\n', '}\n', '\n', 'interface dERC20 {\n', '  function mint(address, uint256) external;\n', '\n', '  function redeem(address, uint256) external;\n', '\n', '  function getTokenBalance(address) external view returns (uint256);\n', '\n', '  function getExchangeRate() external view returns (uint256);\n', '}\n', '\n', 'interface dRewards {\n', '  function withdraw(uint256) external;\n', '\n', '  function getReward() external;\n', '\n', '  function stake(uint256) external;\n', '\n', '  function balanceOf(address) external view returns (uint256);\n', '\n', '  function exit() external;\n', '}\n', '\n', 'interface UniswapRouter {\n', '  function swapExactTokensForTokens(\n', '    uint256,\n', '    uint256,\n', '    address[] calldata,\n', '    address,\n', '    uint256\n', '  ) external;\n', '}\n', '\n', 'contract StrategyDForceDAI {\n', '  using SafeERC20 for IERC20;\n', '  using Address for address;\n', '  using SafeMath for uint256;\n', '\n', '  address public want; //// = address(0x6B175474E89094C44Da98b954EedeAC495271d0F); // DAI\n', '  address public constant d = address(0x02285AcaafEB533e03A7306C55EC031297df9224);\n', '  address public constant pool = address(0xD2fA07cD6Cd4A5A96aa86BacfA6E50bB3aaDBA8B);\n', '  address public constant df = address(0x431ad2ff6a9C365805eBaD47Ee021148d6f7DBe0);\n', '  address public constant uni = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '  address public constant weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // used for df <> weth <> dai route\n', '\n', '  uint256 public performanceFee = 5000;\n', '  uint256 public constant performanceMax = 10000;\n', '\n', '  uint256 public withdrawalFee = 50;\n', '  uint256 public constant withdrawalMax = 10000;\n', '\n', '  address public governance;\n', '  address public controller;\n', '  address public strategist;\n', '\n', '  constructor(address _controller, address _want) public {\n', '    governance = msg.sender;\n', '    strategist = msg.sender;\n', '    controller = _controller;\n', '    want = _want;\n', '  }\n', '\n', '  function getName() external pure returns (string memory) {\n', '    return "StrategyDForceDAI";\n', '  }\n', '\n', '  function setStrategist(address _strategist) external {\n', '    require(msg.sender == governance, "!governance");\n', '    strategist = _strategist;\n', '  }\n', '\n', '  function setWithdrawalFee(uint256 _withdrawalFee) external {\n', '    require(msg.sender == governance, "!governance");\n', '    withdrawalFee = _withdrawalFee;\n', '  }\n', '\n', '  function setPerformanceFee(uint256 _performanceFee) external {\n', '    require(msg.sender == governance, "!governance");\n', '    performanceFee = _performanceFee;\n', '  }\n', '\n', '  function deposit() public {\n', '    uint256 _want = IERC20(want).balanceOf(address(this));\n', '    if (_want > 0) {\n', '      IERC20(want).safeApprove(d, 0);\n', '      IERC20(want).safeApprove(d, _want);\n', '      dERC20(d).mint(address(this), _want);\n', '    }\n', '\n', '    uint256 _d = IERC20(d).balanceOf(address(this));\n', '    if (_d > 0) {\n', '      IERC20(d).safeApprove(pool, 0);\n', '      IERC20(d).safeApprove(pool, _d);\n', '      dRewards(pool).stake(_d);\n', '    }\n', '  }\n', '\n', '  // Controller only function for creating additional rewards from dust\n', '  function withdraw(IERC20 _asset) external returns (uint256 balance) {\n', '    require(msg.sender == controller, "!controller");\n', '    require(want != address(_asset), "want");\n', '    require(d != address(_asset), "d");\n', '    balance = _asset.balanceOf(address(this));\n', '    _asset.safeTransfer(controller, balance);\n', '  }\n', '\n', '  // Withdraw partial funds, normally used with a vault withdrawal\n', '  function withdraw(uint256 _amount) external {\n', '    require(msg.sender == controller, "!controller");\n', '    uint256 _balance = IERC20(want).balanceOf(address(this));\n', '    if (_balance < _amount) {\n', '      _amount = _withdrawSome(_amount.sub(_balance));\n', '      _amount = _amount.add(_balance);\n', '    }\n', '\n', '    uint256 _fee = _amount.mul(withdrawalFee).div(withdrawalMax);\n', '\n', '    IERC20(want).safeTransfer(IController(controller).rewards(), _fee);\n', '    address _vault = IController(controller).vaults(address(want));\n', '    require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '\n', '    IERC20(want).safeTransfer(_vault, _amount.sub(_fee));\n', '  }\n', '\n', '  // Withdraw all funds, normally used when migrating strategies\n', '  function withdrawAll() external returns (uint256 balance) {\n', '    require(msg.sender == controller, "!controller");\n', '    _withdrawAll();\n', '\n', '    balance = IERC20(want).balanceOf(address(this));\n', '\n', '    address _vault = IController(controller).vaults(address(want));\n', '    require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '    IERC20(want).safeTransfer(_vault, balance);\n', '  }\n', '\n', '  function _withdrawAll() internal {\n', '    dRewards(pool).exit();\n', '    uint256 _d = IERC20(d).balanceOf(address(this));\n', '    if (_d > 0) {\n', '      dERC20(d).redeem(address(this), _d);\n', '    }\n', '  }\n', '\n', '  function harvest() public {\n', '    require(msg.sender == strategist || msg.sender == governance, "!authorized");\n', '    dRewards(pool).getReward();\n', '    uint256 _df = IERC20(df).balanceOf(address(this));\n', '    if (_df > 0) {\n', '      IERC20(df).safeApprove(uni, 0);\n', '      IERC20(df).safeApprove(uni, _df);\n', '\n', '      address[] memory path = new address[](3);\n', '      path[0] = df;\n', '      path[1] = weth;\n', '      path[2] = want;\n', '\n', '      UniswapRouter(uni).swapExactTokensForTokens(_df, uint256(0), path, address(this), now.add(1800));\n', '    }\n', '    uint256 _want = IERC20(want).balanceOf(address(this));\n', '    if (_want > 0) {\n', '      uint256 _fee = _want.mul(performanceFee).div(performanceMax);\n', '      IERC20(want).safeTransfer(IController(controller).rewards(), _fee);\n', '      deposit();\n', '    }\n', '  }\n', '\n', '  function _withdrawSome(uint256 _amount) internal returns (uint256) {\n', '    uint256 _d = _amount.mul(1e18).div(dERC20(d).getExchangeRate());\n', '    uint256 _before = IERC20(d).balanceOf(address(this));\n', '    dRewards(pool).withdraw(_d);\n', '    uint256 _after = IERC20(d).balanceOf(address(this));\n', '    uint256 _withdrew = _after.sub(_before);\n', '    _before = IERC20(want).balanceOf(address(this));\n', '    dERC20(d).redeem(address(this), _withdrew);\n', '    _after = IERC20(want).balanceOf(address(this));\n', '    _withdrew = _after.sub(_before);\n', '    return _withdrew;\n', '  }\n', '\n', '  function balanceOfWant() public view returns (uint256) {\n', '    return IERC20(want).balanceOf(address(this));\n', '  }\n', '\n', '  function balanceOfPool() public view returns (uint256) {\n', '    return (dRewards(pool).balanceOf(address(this))).mul(dERC20(d).getExchangeRate()).div(1e18);\n', '  }\n', '\n', '  function getExchangeRate() public view returns (uint256) {\n', '    return dERC20(d).getExchangeRate();\n', '  }\n', '\n', '  function balanceOfD() public view returns (uint256) {\n', '    return dERC20(d).getTokenBalance(address(this));\n', '  }\n', '\n', '  function balanceOf() public view returns (uint256) {\n', '    return balanceOfWant().add(balanceOfD()).add(balanceOfPool());\n', '  }\n', '\n', '  function setGovernance(address _governance) external {\n', '    require(msg.sender == governance, "!governance");\n', '    governance = _governance;\n', '  }\n', '\n', '  function setController(address _controller) external {\n', '    require(msg.sender == governance, "!governance");\n', '    controller = _controller;\n', '  }\n', '}']