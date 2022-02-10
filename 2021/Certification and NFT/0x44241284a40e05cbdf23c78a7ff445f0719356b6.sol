['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-11\n', '*/\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            size := extcodesize(account)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data)\n', '        internal\n', '        returns (bytes memory)\n', '    {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return\n', '            functionCallWithValue(\n', '                target,\n', '                data,\n', '                value,\n', '                "Address: low-level call with value failed"\n', '            );\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(\n', '            address(this).balance >= value,\n', '            "Address: insufficient balance for call"\n', '        );\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) =\n', '            target.call{value: value}(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data)\n', '        internal\n', '        view\n', '        returns (bytes memory)\n', '    {\n', '        return\n', '            functionStaticCall(\n', '                target,\n', '                data,\n', '                "Address: low-level static call failed"\n', '            );\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(\n', '        bool success,\n', '        bytes memory returndata,\n', '        string memory errorMessage\n', '    ) private pure returns (bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transfer.selector, to, value)\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, value)\n', '        );\n', '    }\n', '\n', '    function safeIncreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance =\n', '            token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    function safeDecreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance =\n', '            token.allowance(address(this), spender).sub(\n', '                value,\n', '                "SafeERC20: decreased allowance below zero"\n', '            );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata =\n', '            address(token).functionCall(\n', '                data,\n', '                "SafeERC20: low-level call failed"\n', '            );\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(\n', '                abi.decode(returndata, (bool)),\n', '                "SafeERC20: ERC20 operation did not succeed"\n', '            );\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/interface/IERC20Usdt.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20Usdt {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external;\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external;\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '// File: contracts/Config.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract Config {\n', '    // function signature of "postProcess()"\n', '    bytes4 public constant POSTPROCESS_SIG = 0xc2722916;\n', '\n', '    // The base amount of percentage function\n', '    uint256 public constant PERCENTAGE_BASE = 1 ether;\n', '\n', '    // Handler post-process type. Others should not happen now.\n', '    enum HandlerType {Token, Custom, Others}\n', '}\n', '\n', '// File: contracts/lib/LibCache.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library LibCache {\n', '    function set(\n', '        mapping(bytes32 => bytes32) storage _cache,\n', '        bytes32 _key,\n', '        bytes32 _value\n', '    ) internal {\n', '        _cache[_key] = _value;\n', '    }\n', '\n', '    function setAddress(\n', '        mapping(bytes32 => bytes32) storage _cache,\n', '        bytes32 _key,\n', '        address _value\n', '    ) internal {\n', '        _cache[_key] = bytes32(uint256(uint160(_value)));\n', '    }\n', '\n', '    function setUint256(\n', '        mapping(bytes32 => bytes32) storage _cache,\n', '        bytes32 _key,\n', '        uint256 _value\n', '    ) internal {\n', '        _cache[_key] = bytes32(_value);\n', '    }\n', '\n', '    function getAddress(\n', '        mapping(bytes32 => bytes32) storage _cache,\n', '        bytes32 _key\n', '    ) internal view returns (address ret) {\n', '        ret = address(uint160(uint256(_cache[_key])));\n', '    }\n', '\n', '    function getUint256(\n', '        mapping(bytes32 => bytes32) storage _cache,\n', '        bytes32 _key\n', '    ) internal view returns (uint256 ret) {\n', '        ret = uint256(_cache[_key]);\n', '    }\n', '\n', '    function get(mapping(bytes32 => bytes32) storage _cache, bytes32 _key)\n', '        internal\n', '        view\n', '        returns (bytes32 ret)\n', '    {\n', '        ret = _cache[_key];\n', '    }\n', '}\n', '\n', '// File: contracts/lib/LibStack.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library LibStack {\n', '    function setAddress(bytes32[] storage _stack, address _input) internal {\n', '        _stack.push(bytes32(uint256(uint160(_input))));\n', '    }\n', '\n', '    function set(bytes32[] storage _stack, bytes32 _input) internal {\n', '        _stack.push(_input);\n', '    }\n', '\n', '    function setHandlerType(bytes32[] storage _stack, Config.HandlerType _input)\n', '        internal\n', '    {\n', '        _stack.push(bytes12(uint96(_input)));\n', '    }\n', '\n', '    function getAddress(bytes32[] storage _stack)\n', '        internal\n', '        returns (address ret)\n', '    {\n', '        ret = address(uint160(uint256(peek(_stack))));\n', '        _stack.pop();\n', '    }\n', '\n', '    function getSig(bytes32[] storage _stack) internal returns (bytes4 ret) {\n', '        ret = bytes4(peek(_stack));\n', '        _stack.pop();\n', '    }\n', '\n', '    function get(bytes32[] storage _stack) internal returns (bytes32 ret) {\n', '        ret = peek(_stack);\n', '        _stack.pop();\n', '    }\n', '\n', '    function peek(bytes32[] storage _stack)\n', '        internal\n', '        view\n', '        returns (bytes32 ret)\n', '    {\n', '        require(_stack.length > 0, "stack empty");\n', '        ret = _stack[_stack.length - 1];\n', '    }\n', '}\n', '\n', '// File: contracts/Storage.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/// @notice A cache structure composed by a bytes32 array\n', 'contract Storage {\n', '    using LibCache for mapping(bytes32 => bytes32);\n', '    using LibStack for bytes32[];\n', '\n', '    bytes32[] public stack;\n', '    mapping(bytes32 => bytes32) public cache;\n', '\n', '    // keccak256 hash of "msg.sender"\n', '    // prettier-ignore\n', '    bytes32 public constant MSG_SENDER_KEY = 0xb2f2618cecbbb6e7468cc0f2aa43858ad8d153e0280b22285e28e853bb9d453a;\n', '\n', '    // keccak256 hash of "cube.counter"\n', '    // prettier-ignore\n', '    bytes32 public constant CUBE_COUNTER_KEY = 0xf9543f11459ccccd21306c8881aaab675ff49d988c1162fd1dd9bbcdbe4446be;\n', '\n', '    modifier isStackEmpty() {\n', '        require(stack.length == 0, "Stack not empty");\n', '        _;\n', '    }\n', '\n', '    modifier isCubeCounterZero() {\n', '        require(_getCubeCounter() == 0, "Cube counter not zero");\n', '        _;\n', '    }\n', '\n', '    modifier isInitialized() {\n', '        require(_getSender() != address(0), "Sender is not initialized");\n', '        _;\n', '    }\n', '\n', '    modifier isNotInitialized() {\n', '        require(_getSender() == address(0), "Sender is initialized");\n', '        _;\n', '    }\n', '\n', '    function _setSender() internal isNotInitialized {\n', '        cache.setAddress(MSG_SENDER_KEY, msg.sender);\n', '    }\n', '\n', '    function _resetSender() internal {\n', '        cache.setAddress(MSG_SENDER_KEY, address(0));\n', '    }\n', '\n', '    function _getSender() internal view returns (address) {\n', '        return cache.getAddress(MSG_SENDER_KEY);\n', '    }\n', '\n', '    function _addCubeCounter() internal {\n', '        cache.setUint256(CUBE_COUNTER_KEY, _getCubeCounter() + 1);\n', '    }\n', '\n', '    function _resetCubeCounter() internal {\n', '        cache.setUint256(CUBE_COUNTER_KEY, 0);\n', '    }\n', '\n', '    function _getCubeCounter() internal view returns (uint256) {\n', '        return cache.getUint256(CUBE_COUNTER_KEY);\n', '    }\n', '}\n', '\n', '// File: contracts/handlers/HandlerBase.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'abstract contract HandlerBase is Storage, Config {\n', '    using SafeERC20 for IERC20;\n', '\n', '    function postProcess() external payable virtual {\n', '        revert("Invalid post process");\n', '        /* Implementation template\n', '        bytes4 sig = stack.getSig();\n', '        if (sig == bytes4(keccak256(bytes("handlerFunction_1()")))) {\n', '            // Do something\n', '        } else if (sig == bytes4(keccak256(bytes("handlerFunction_2()")))) {\n', '            bytes32 temp = stack.get();\n', '            // Do something\n', '        } else revert("Invalid post process");\n', '        */\n', '    }\n', '\n', '    function _updateToken(address token) internal {\n', '        stack.setAddress(token);\n', '        // Ignore token type to fit old handlers\n', '        // stack.setHandlerType(uint256(HandlerType.Token));\n', '    }\n', '\n', '    function _updatePostProcess(bytes32[] memory params) internal {\n', '        for (uint256 i = params.length; i > 0; i--) {\n', '            stack.set(params[i - 1]);\n', '        }\n', '        stack.set(msg.sig);\n', '        stack.setHandlerType(HandlerType.Custom);\n', '    }\n', '\n', '    function getContractName() public pure virtual returns (string memory);\n', '\n', '    function _revertMsg(string memory functionName, string memory reason)\n', '        internal\n', '        view\n', '    {\n', '        revert(\n', '            string(\n', '                abi.encodePacked(\n', '                    _uint2String(_getCubeCounter()),\n', '                    "_",\n', '                    getContractName(),\n', '                    "_",\n', '                    functionName,\n', '                    ": ",\n', '                    reason\n', '                )\n', '            )\n', '        );\n', '    }\n', '\n', '    function _revertMsg(string memory functionName) internal view {\n', '        _revertMsg(functionName, "Unspecified");\n', '    }\n', '\n', '    function _uint2String(uint256 n) internal pure returns (string memory) {\n', '        if (n == 0) {\n', '            return "0";\n', '        } else {\n', '            uint256 len = 0;\n', '            for (uint256 temp = n; temp > 0; temp /= 10) {\n', '                len++;\n', '            }\n', '            bytes memory str = new bytes(len);\n', '            for (uint256 i = len; i > 0; i--) {\n', '                str[i - 1] = bytes1(uint8(48 + (n % 10)));\n', '                n /= 10;\n', '            }\n', '            return string(str);\n', '        }\n', '    }\n', '\n', '    function _getBalance(address token, uint256 amount)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        if (amount != uint256(-1)) {\n', '            return amount;\n', '        }\n', '\n', '        // ETH case\n', '        if (\n', '            token == address(0) ||\n', '            token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)\n', '        ) {\n', '            return address(this).balance;\n', '        }\n', '        // ERC20 token case\n', '        return IERC20(token).balanceOf(address(this));\n', '    }\n', '\n', '    function _tokenApprove(\n', '        address token,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal {\n', '        try IERC20Usdt(token).approve(spender, amount) {} catch {\n', '            IERC20(token).safeApprove(spender, 0);\n', '            IERC20(token).safeApprove(spender, amount);\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/handlers/kybernetwork/IKyberNetworkProxy.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IKyberNetworkProxy {\n', '    // Simple interface for Kyber Network\n', '    function swapTokenToToken(\n', '        IERC20 src,\n', '        uint256 srcAmount,\n', '        IERC20 dest,\n', '        uint256 minConversionRate\n', '    ) external returns (uint256);\n', '\n', '    function swapEtherToToken(IERC20 token, uint256 minConversionRate)\n', '        external\n', '        payable\n', '        returns (uint256);\n', '\n', '    function swapTokenToEther(\n', '        IERC20 token,\n', '        uint256 srcAmount,\n', '        uint256 minConversionRate\n', '    ) external returns (uint256);\n', '\n', '    function maxGasPrice() external view returns (uint256);\n', '\n', '    function getUserCapInWei(address user) external view returns (uint256);\n', '\n', '    function getUserCapInTokenWei(address user, IERC20 token)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function enabled() external view returns (bool);\n', '\n', '    function info(bytes32 id) external view returns (uint256);\n', '\n', '    function getExpectedRate(\n', '        IERC20 src,\n', '        IERC20 dest,\n', '        uint256 srcQty\n', '    ) external view returns (uint256 expectedRate, uint256 slippageRate);\n', '\n', '    function tradeWithHint(\n', '        IERC20 src,\n', '        uint256 srcAmount,\n', '        IERC20 dest,\n', '        address destAddress,\n', '        uint256 maxDestAmount,\n', '        uint256 minConversionRate,\n', '        address walletId,\n', '        bytes calldata hint\n', '    ) external payable returns (uint256);\n', '\n', '    function admin() external view returns (address);\n', '}\n', '\n', '// File: contracts/handlers/kybernetwork/HKyberNetwork.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract HKyberNetwork is HandlerBase {\n', '    using SafeERC20 for IERC20;\n', '\n', '    // prettier-ignore\n', '    address public constant ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    // prettier-ignore\n', '    address public constant KYBERNETWORK_PROXY = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;\n', '\n', '    function getContractName() public pure override returns (string memory) {\n', '        return "HKyberNetwork";\n', '    }\n', '\n', '    function swapEtherToToken(\n', '        uint256 value,\n', '        address token,\n', '        uint256 minRate\n', '    ) external payable returns (uint256 destAmount) {\n', '        IKyberNetworkProxy kyber = IKyberNetworkProxy(KYBERNETWORK_PROXY);\n', '        value = _getBalance(ETH_TOKEN_ADDRESS, value);\n', '        try\n', '            kyber.swapEtherToToken.value(value)(IERC20(token), minRate)\n', '        returns (uint256 amount) {\n', '            destAmount = amount;\n', '        } catch Error(string memory reason) {\n', '            _revertMsg("swapEtherToToken", reason);\n', '        } catch {\n', '            _revertMsg("swapEtherToToken");\n', '        }\n', '\n', '        // Update involved token\n', '        _updateToken(token);\n', '    }\n', '\n', '    function swapTokenToEther(\n', '        address token,\n', '        uint256 tokenQty,\n', '        uint256 minRate\n', '    ) external payable returns (uint256 destAmount) {\n', '        IKyberNetworkProxy kyber = IKyberNetworkProxy(KYBERNETWORK_PROXY);\n', '        tokenQty = _getBalance(token, tokenQty);\n', '        IERC20(token).safeApprove(address(kyber), tokenQty);\n', '        try kyber.swapTokenToEther(IERC20(token), tokenQty, minRate) returns (\n', '            uint256 amount\n', '        ) {\n', '            destAmount = amount;\n', '        } catch Error(string memory reason) {\n', '            _revertMsg("swapTokenToEther", reason);\n', '        } catch {\n', '            _revertMsg("swapTokenToEther");\n', '        }\n', '        IERC20(token).safeApprove(address(kyber), 0);\n', '    }\n', '\n', '    function swapTokenToToken(\n', '        address srcToken,\n', '        uint256 srcQty,\n', '        address destToken,\n', '        uint256 minRate\n', '    ) external payable returns (uint256 destAmount) {\n', '        IKyberNetworkProxy kyber = IKyberNetworkProxy(KYBERNETWORK_PROXY);\n', '        srcQty = _getBalance(srcToken, srcQty);\n', '        IERC20(srcToken).safeApprove(address(kyber), srcQty);\n', '        try\n', '            kyber.swapTokenToToken(\n', '                IERC20(srcToken),\n', '                srcQty,\n', '                IERC20(destToken),\n', '                minRate\n', '            )\n', '        returns (uint256 amount) {\n', '            destAmount = amount;\n', '        } catch Error(string memory reason) {\n', '            _revertMsg("swapTokenToToken", reason);\n', '        } catch {\n', '            _revertMsg("swapTokenToToken");\n', '        }\n', '        IERC20(srcToken).safeApprove(address(kyber), 0);\n', '\n', '        // Update involved token\n', '        _updateToken(destToken);\n', '    }\n', '}']