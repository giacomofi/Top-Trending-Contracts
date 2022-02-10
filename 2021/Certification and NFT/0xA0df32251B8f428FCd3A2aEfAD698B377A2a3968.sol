['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', 'import "../interface/IERC20.sol";\n', 'import "../interface/ILiquidatorQualifier.sol";\n', 'import "../math/UnsignedSafeMath.sol";\n', 'import "./SafeERC20.sol";\n', '\n', '/**\n', ' * @title Deri Protocol liquidator quanlifier implementation\n', ' */\n', 'contract LiquidatorQualifier is ILiquidatorQualifier {\n', '\n', '    using SafeERC20 for IERC20;\n', '    using UnsignedSafeMath for uint256;\n', '\n', '    address public controller;\n', '\n', '    // ERC20 token used as stake to judge the qualification of a liquidator\n', '    // Stake token is designed to be DERI token\n', '    address public stakeTokenAddress;\n', '    // Total staked tokens\n', '    uint256 public totalStakedTokens;\n', '    // Total number of stakers\n', '    uint256 public totalStakers;\n', "    // Stakers' balance record\n", '    mapping (address => uint256) public stakes;\n', '\n', '    constructor (address stakeTokenAddress_) {\n', '        controller = msg.sender;\n', '        stakeTokenAddress = stakeTokenAddress_;\n', '    }\n', '\n', '    function setController(address newController) public {\n', '        require(newController != address(0), "LiquidatorQualifier: setController to 0 address");\n', '        require(msg.sender == controller, "LiquidatorQualifier: setController can only be called by controller");\n', '        controller = newController;\n', '    }\n', '\n', '    /**\n', '     * @dev Depoist `amount` of stake token to compete to be a qualified liquidator\n', '     */\n', '    function deposit(uint256 amount) public {\n', '        require(amount != 0, "LiquidatorQualifier: deposit 0 stake tokens");\n', '        IERC20(stakeTokenAddress).safeTransferFrom(msg.sender, address(this), amount);\n', '\n', '        totalStakedTokens = totalStakedTokens.add(amount);\n', '        if (stakes[msg.sender] == 0) {\n', '            totalStakers = totalStakers.add(1);\n', '        }\n', '        stakes[msg.sender] = stakes[msg.sender].add(amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw `amount` of stake token\n', '     * The caller must at least have `amount` of stake token deposited before\n', '     */\n', '    function withdraw(uint256 amount) public {\n', '        require(amount != 0, "LiquidatorQualifier: withdraw 0 stake tokens");\n', '        require(amount <= stakes[msg.sender], "LiquidatorQualifier: withdraw amount exceeds staked");\n', '\n', '        totalStakedTokens = totalStakedTokens.sub(amount);\n', '        if (stakes[msg.sender] == amount) {\n', '            totalStakers = totalStakers.sub(1);\n', '        }\n', '        stakes[msg.sender] = stakes[msg.sender].sub(amount);\n', '\n', '        IERC20(stakeTokenAddress).safeTransfer(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Check if `liquidator` is qualified as a liquidator\n', "     * In this version, the only requirement is `liquidator`'s deposited stake token\n", '     * is above or equal to the average deposition\n', '     */\n', '    function isQualifiedLiquidator(address liquidator) public view override returns (bool) {\n', '        if (totalStakers == 0) {\n', '            return false;\n', '        }\n', '        return stakes[liquidator] >= totalStakedTokens / totalStakers;\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `amount` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '\n', '    /**\n', '     * @dev Emitted when `amount` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `amount` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the name.\n', '     */\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is\n', '     * called.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() external view returns (uint8);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `to`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address to, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `from` to `to` using the allowance mechanism.\n', "     * `amount` is then deducted from the caller's allowance.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @title Deri Protocol liquidator qualifier interface\n', ' */\n', 'interface ILiquidatorQualifier {\n', '\n', '    /**\n', '     * @dev Check if `liquidator` is a qualified liquidator to call the `liquidate` function in PerpetualPool\n', '     */\n', '    function isQualifiedLiquidator(address liquidator) external view returns (bool);\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @title Unsigned safe math\n', ' */\n', 'library UnsignedSafeMath {\n', '\n', '    /**\n', '     * @dev Addition of unsigned integers, counterpart to `+`\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "UnsignedSafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtraction of unsigned integers, counterpart to `-`\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(a >= b, "UnsignedSafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Multiplication of unsigned integers, counterpart to `*`\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero,\n", "        // but the benefit is lost if 'b' is also tested\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "UnsignedSafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Division of unsigned integers, counterpart to `/`\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "UnsignedSafeMath: division by zero");\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Modulo of unsigned integers, counterpart to `%`\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "UnsignedSafeMath: modulo by zero");\n', '        uint256 c = a % b;\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "../interface/IERC20.sol";\n', 'import "../math/UnsignedSafeMath.sol";\n', 'import "./Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using UnsignedSafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}']