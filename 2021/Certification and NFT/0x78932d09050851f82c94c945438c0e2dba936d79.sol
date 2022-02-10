['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-27\n', '*/\n', '\n', '// Dependency file: contracts/libraries/Math.sol\n', '\n', '// pragma solidity ^0.6.12;\n', '\n', '// a library for performing various math operations\n', '\n', 'library Math {\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint y) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/libraries/SafeMath.sol\n', '\n', '// pragma solidity ^0.6.12;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '\n', '// Dependency file: contracts/interfaces/IERC20.sol\n', '\n', '// pragma solidity ^0.6.12;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '\n', '// Dependency file: contracts/libraries/Address.sol\n', '\n', '// pragma solidity ^0.6.12;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [// importANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * // importANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// Dependency file: contracts/libraries/SafeERC20.sol\n', '\n', '// pragma solidity ^0.6.12;\n', '\n', '// import "contracts/interfaces/IERC20.sol";\n', '// import "contracts/libraries/SafeMath.sol";\n', '// import "contracts/libraries/Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IWSERC20.sol\n', '\n', '// pragma solidity ^0.6.12;\n', '\n', 'interface IWSERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '}\n', '\n', '\n', '// Dependency file: contracts/interfaces/IStakingRewards.sol\n', '\n', '// pragma solidity ^0.6.12;\n', '\n', '\n', 'interface IStakingRewards {\n', '    // Views\n', '    function lastTimeRewardApplicable() external view returns (uint256);\n', '\n', '    function rewardPerToken() external view returns (uint256);\n', '\n', '    function earned(address account) external view returns (uint256);\n', '\n', '    function getRewardForDuration() external view returns (uint256);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    // Mutative\n', '\n', '    function stake(uint256 amount) external;\n', '\n', '    function withdraw(uint256 amount) external;\n', '\n', '    function getReward() external;\n', '\n', '    function exit() external;\n', '}\n', '\n', '// Dependency file: contracts/ReentrancyGuard.sol\n', '\n', '// pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier\n', ' * available, which can be applied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' *\n', ' * TIP: If you would like to learn more about reentrancy and alternative ways\n', ' * to protect against it, check out our blog post\n', ' * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].\n', ' */\n', 'contract ReentrancyGuard {\n', '    // Booleans are more expensive than uint256 or any type that takes up a full\n', '    // word because each write operation emits an extra SLOAD to first read the\n', "    // slot's contents, replace the bits taken up by the boolean, and then write\n", "    // back. This is the compiler's defense against contract upgrades and\n", '    // pointer aliasing, and it cannot be disabled.\n', '\n', '    // The values being non-zero value makes deployment a bit more expensive,\n', '    // but in exchange the refund on every call to nonReentrant will be lower in\n', '    // amount. Since refunds are capped to a percentage of the total\n', "    // transaction's gas, it is best to keep them low in cases like this one, to\n", '    // increase the likelihood of the full refund coming into effect.\n', '    uint256 private constant _NOT_ENTERED = 1;\n', '    uint256 private constant _ENTERED = 2;\n', '\n', '    uint256 private _status;\n', '\n', '    constructor () internal {\n', '        _status = _NOT_ENTERED;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        _status = _ENTERED;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        _status = _NOT_ENTERED;\n', '    }\n', '}\n', '\n', '\n', '// Root file: contracts/staking/StakingRewardsV2.sol\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '\n', "// import 'contracts/libraries/Math.sol';\n", "// import 'contracts/libraries/SafeMath.sol';\n", '// import "contracts/libraries/SafeERC20.sol";\n', '\n', "// import 'contracts/interfaces/IERC20.sol';\n", "// import 'contracts/interfaces/IWSERC20.sol';\n", "// import 'contracts/interfaces/IStakingRewards.sol';\n", '\n', "// import 'contracts/ReentrancyGuard.sol';\n", '\n', 'contract StakingRewardsV2 is ReentrancyGuard, IStakingRewards {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    bool public initialized;\n', '    IERC20 public rewardsToken;\n', '    IERC20 public stakingToken;\n', '    address public rewardsDistributor;\n', '    address public externalController;\n', '\n', '    struct RewardEpoch {\n', '        uint id;\n', '        uint totalSupply;\n', '        uint startEpoch;\n', '        uint finishEpoch;\n', '        uint rewardRate;\n', '        uint lastUpdateTime;\n', '        uint rewardPerTokenStored;\n', '    }\n', '    // epoch\n', '    mapping(uint => RewardEpoch) public epochData;\n', '    mapping(uint => mapping(address => uint)) public userRewardPerTokenPaid;\n', '    mapping(uint => mapping(address => uint)) public rewards;\n', '    mapping(uint => mapping(address => uint)) private _balances;\n', '    mapping(address => uint) public lastAccountEpoch;\n', '    uint public currentEpochId;\n', '\n', '    function initialize(\n', '        address _externalController,\n', '        address _rewardsDistributor,\n', '        address _rewardsToken,\n', '        address _stakingToken\n', '        ) external {\n', '            require(initialized == false, "Contract already initialized.");\n', '            rewardsToken = IERC20(_rewardsToken);\n', '            stakingToken = IERC20(_stakingToken);\n', '            rewardsDistributor = _rewardsDistributor;\n', '            externalController = _externalController;\n', '            initialized = true;\n', '    }\n', '\n', '    function fixPool(bool cleanRewards, bool recalcRate, address[] memory accounts) public {\n', '        require(msg.sender == address(0x95Db09ff2644eca19cB4b99318483254BFD52dAe), "Not allowed");\n', '        if (cleanRewards){\n', '            for(uint i = 0; i < accounts.length; i++) {\n', '                delete rewards[currentEpochId][accounts[i]];\n', '            }\n', '        }\n', '        if (recalcRate) {\n', '            RewardEpoch memory curepoch = epochData[currentEpochId];\n', '            uint rewardsDuration = curepoch.finishEpoch - curepoch.startEpoch;\n', '            epochData[currentEpochId].rewardRate = rewardsToken.balanceOf(address(this)).div(rewardsDuration);\n', '            epochData[currentEpochId].rewardPerTokenStored = 0;\n', '        }\n', '        initialized = true;\n', '    }\n', '\n', '    function _totalSupply(uint epoch) internal view returns (uint) {\n', '        return epochData[epoch].totalSupply;\n', '    }\n', '\n', '    function _balanceOf(uint epoch, address account) public view returns (uint) {\n', '        return _balances[epoch][account];\n', '    }\n', '\n', '    function _lastTimeRewardApplicable(uint epoch) internal view returns (uint) {\n', '        if (block.timestamp < epochData[epoch].startEpoch) {\n', '            return epochData[epoch].startEpoch;\n', '        }\n', '        return Math.min(block.timestamp, epochData[epoch].finishEpoch);\n', '    }\n', '\n', '    function totalSupply() external override view returns (uint) {\n', '        return _totalSupply(currentEpochId);\n', '    }\n', '\n', '    function balanceOf(address account) external override view returns (uint) {\n', '        return _balanceOf(currentEpochId, account);\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public override view returns (uint) {\n', '        return _lastTimeRewardApplicable(currentEpochId);\n', '    }\n', '\n', '    function _rewardPerToken(uint _epoch) internal view returns (uint) {\n', '        RewardEpoch memory epoch = epochData[_epoch];\n', '        if (epoch.totalSupply == 0) {\n', '            return epoch.rewardPerTokenStored;\n', '        }\n', '        return\n', '            epoch.rewardPerTokenStored.add(\n', '                _lastTimeRewardApplicable(_epoch).sub(epoch.lastUpdateTime).mul(epoch.rewardRate).mul(1e18).div(epoch.totalSupply)\n', '            );\n', '    }\n', '\n', '    function rewardPerToken() public override view returns (uint) {\n', '        _rewardPerToken(currentEpochId);\n', '    }\n', '\n', '    function _earned(uint _epoch, address account) internal view returns (uint256) {\n', '        return _balances[_epoch][account].mul(_rewardPerToken(_epoch).sub(userRewardPerTokenPaid[_epoch][account])).div(1e18).add(rewards[_epoch][account]);\n', '    }\n', '\n', '    function earned(address account) public override view returns (uint256) {\n', '        return _earned(currentEpochId, account);\n', '    }\n', '\n', '    function getRewardForDuration() external override view returns (uint256) {\n', '        RewardEpoch memory epoch = epochData[currentEpochId];\n', '        return epoch.rewardRate.mul(epoch.finishEpoch - epoch.startEpoch);\n', '    }\n', '\n', '    function _stake(uint amount, bool withDepositTransfer) internal {\n', '        require(amount > 0, "Cannot stake 0");\n', '        require(currentEpochId > 0, "Any epoch should be started before stake");\n', '        require(lastAccountEpoch[msg.sender] == currentEpochId || lastAccountEpoch[msg.sender] == 0, "Account should update epoch to stake.");\n', '        epochData[currentEpochId].totalSupply = epochData[currentEpochId].totalSupply.add(amount);\n', '        _balances[currentEpochId][msg.sender] = _balances[currentEpochId][msg.sender].add(amount);\n', '        if(withDepositTransfer) {\n', '            stakingToken.safeTransferFrom(msg.sender, address(this), amount);\n', '        }\n', '        lastAccountEpoch[msg.sender] = currentEpochId;\n', '        emit Staked(msg.sender, amount, currentEpochId);\n', '    }\n', '\n', '    function stake(uint256 amount) nonReentrant updateReward(msg.sender) override external {\n', '        _stake(amount, true);\n', '    }\n', '\n', '    function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {\n', '        // permit\n', '        IWSERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);\n', '        _stake(amount, true);\n', '    }\n', '\n', '    function withdraw(uint256 amount) override public nonReentrant updateReward(msg.sender) {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        uint lastEpoch = lastAccountEpoch[msg.sender];\n', '        epochData[lastEpoch].totalSupply = epochData[lastEpoch].totalSupply.sub(amount);\n', '        _balances[lastEpoch][msg.sender] = _balances[lastEpoch][msg.sender].sub(amount);\n', '        stakingToken.safeTransfer(msg.sender, amount);\n', '        emit Withdrawn(msg.sender, amount, lastEpoch);\n', '    }\n', '\n', '    function getReward() override public nonReentrant updateReward(msg.sender) {\n', '        uint lastEpoch = lastAccountEpoch[msg.sender];\n', '        uint reward = rewards[lastEpoch][msg.sender];\n', '        if (reward > 0) {\n', '            rewards[lastEpoch][msg.sender] = 0;\n', '            rewardsToken.safeTransfer(msg.sender, reward);\n', '            emit RewardPaid(msg.sender, reward);\n', '        }\n', '    }\n', '\n', '    function exit() override external {\n', '        withdraw(_balances[lastAccountEpoch[msg.sender]][msg.sender]);\n', '        getReward();\n', '    }\n', '\n', '    function updateStakingEpoch() public {\n', '        uint lastEpochId = lastAccountEpoch[msg.sender];\n', '        if (lastEpochId != currentEpochId) {\n', '            _updateRewardForEpoch(msg.sender, lastEpochId);\n', '\n', '        // Remove record about staking on last account epoch\n', '        uint stakedAmount = _balances[lastEpochId][msg.sender];\n', '        _balances[lastEpochId][msg.sender] = 0;\n', '        epochData[lastEpochId].totalSupply = epochData[lastEpochId].totalSupply.sub(stakedAmount);\n', '        // Move collected rewards from last epoch to the current\n', '        rewards[currentEpochId][msg.sender] = rewards[lastEpochId][msg.sender];\n', '        rewards[lastEpochId][msg.sender] = 0;\n', '\n', '        // Restake\n', '        lastAccountEpoch[msg.sender] = currentEpochId;\n', '        _stake(stakedAmount, false);\n', '        }\n', '    }\n', '\n', '    function _updateRewardForEpoch(address account, uint epoch) internal {\n', '        epochData[epoch].rewardPerTokenStored = _rewardPerToken(epoch);\n', '        epochData[epoch].lastUpdateTime = _lastTimeRewardApplicable(epoch);\n', '        if (account != address(0)) {\n', '            rewards[epoch][account] = _earned(epoch, account);\n', '            userRewardPerTokenPaid[epoch][account] = epochData[epoch].rewardPerTokenStored;\n', '        }\n', '    }\n', '\n', '\n', '    modifier updateReward(address account) {\n', '        uint lastEpoch = lastAccountEpoch[account];\n', '        if(account == address(0) || lastEpoch == 0) {\n', '            lastEpoch = currentEpochId;\n', '        }\n', '        _updateRewardForEpoch(account, lastEpoch);\n', '        _;\n', '    }\n', '\n', '    function notifyRewardAmount(uint reward, uint startEpoch, uint finishEpoch) nonReentrant external {\n', '        require(msg.sender == rewardsDistributor, "Only reward distribured allowed.");\n', '        require(startEpoch >= block.timestamp, "Provided start date too late.");\n', '        require(finishEpoch > startEpoch, "Wrong end date epoch.");\n', '        require(reward > 0, "Wrong reward amount");\n', '        uint rewardsDuration = finishEpoch - startEpoch;\n', '\n', '        RewardEpoch memory newEpoch;\n', '        // Initialize new epoch\n', '        currentEpochId++;\n', '        newEpoch.id = currentEpochId;\n', '        newEpoch.startEpoch = startEpoch;\n', '        newEpoch.finishEpoch = finishEpoch;\n', '        newEpoch.rewardRate = reward.div(rewardsDuration);\n', '        // last update time will be right when epoch starts\n', '        newEpoch.lastUpdateTime = startEpoch;\n', '\n', '        epochData[newEpoch.id] = newEpoch;\n', '\n', '        emit EpochAdded(newEpoch.id, startEpoch, finishEpoch, reward);\n', '    }\n', '\n', '    function externalWithdraw() external {\n', '        require(msg.sender == externalController, "Only external controller allowed.");\n', '        rewardsToken.transfer(msg.sender, rewardsToken.balanceOf(msg.sender));\n', '    }\n', '\n', '    event EpochAdded(uint epochId, uint startEpoch, uint finishEpoch, uint256 reward);\n', '    event Staked(address indexed user, uint amount, uint epoch);\n', '    event Withdrawn(address indexed user, uint amount, uint epoch);\n', '    event RewardPaid(address indexed user, uint reward);\n', '\n', '\n', '}']