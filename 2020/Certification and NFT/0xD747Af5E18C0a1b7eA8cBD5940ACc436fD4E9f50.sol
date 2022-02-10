['// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', 'pragma solidity 0.5.15;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            size := extcodesize(account)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data)\n', '        internal\n', '        returns (bytes memory)\n', '    {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return\n', '            functionCallWithValue(\n', '                target,\n', '                data,\n', '                value,\n', '                "Address: low-level call with value failed"\n', '            );\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(\n', '            address(this).balance >= value,\n', '            "Address: insufficient balance for call"\n', '        );\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 weiValue,\n', '        string memory errorMessage\n', '    ) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call.value(weiValue)(\n', '            data\n', '        );\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transfer.selector, to, value)\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, value)\n', '        );\n', '    }\n', '\n', '    function safeIncreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(\n', '            value\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    function safeDecreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(\n', '            value,\n', '            "SafeERC20: decreased allowance below zero"\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(\n', '            data,\n', '            "SafeERC20: low-level call failed"\n', '        );\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(\n', '                abi.decode(returndata, (bool)),\n', '                "SafeERC20: ERC20 operation did not succeed"\n', '            );\n', '        }\n', '    }\n', '}\n', '\n', '// Storage for a YUAN token\n', 'contract YUANTokenStorage {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev Guard variable for re-entrancy checks. Not currently used\n', '     */\n', '    bool internal _notEntered;\n', '\n', '    /**\n', '     * @notice EIP-20 token name for this token\n', '     */\n', '    string public name;\n', '\n', '    /**\n', '     * @notice EIP-20 token symbol for this token\n', '     */\n', '    string public symbol;\n', '\n', '    /**\n', '     * @notice EIP-20 token decimals for this token\n', '     */\n', '    uint8 public decimals;\n', '\n', '    /**\n', '     * @notice Governor for this contract\n', '     */\n', '    address public gov;\n', '\n', '    /**\n', '     * @notice Pending governance for this contract\n', '     */\n', '    address public pendingGov;\n', '\n', '    /**\n', '     * @notice Approved rebaser for this contract\n', '     */\n', '    address public rebaser;\n', '\n', '    /**\n', '     * @notice Approved migrator for this contract\n', '     */\n', '    address public migrator;\n', '\n', '    /**\n', '     * @notice Incentivizer address of YUAN protocol\n', '     */\n', '    address public incentivizer;\n', '\n', '    /**\n', '     * @notice Total supply of YUANs\n', '     */\n', '    uint256 public totalSupply;\n', '\n', '    /**\n', '     * @notice Internal decimals used to handle scaling factor\n', '     */\n', '    uint256 public constant internalDecimals = 10**24;\n', '\n', '    /**\n', '     * @notice Used for percentage maths\n', '     */\n', '    uint256 public constant BASE = 10**18;\n', '\n', '    /**\n', "     * @notice Scaling factor that adjusts everyone's balances\n", '     */\n', '    uint256 public yuansScalingFactor;\n', '\n', '    mapping(address => uint256) internal _yuanBalances;\n', '\n', '    mapping(address => mapping(address => uint256)) internal _allowedFragments;\n', '\n', '    uint256 public initSupply;\n', '\n', '    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    bytes32\n', '        public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;\n', '    bytes32 public DOMAIN_SEPARATOR;\n', '}\n', '\n', '/* Copyright 2020 Compound Labs, Inc.\n', '\n', 'Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n', '\n', '1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n', '\n', '2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n', '\n', '3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n', '\n', 'THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */\n', '\n', 'contract YUANGovernanceStorage {\n', '    /// @notice A record of each accounts delegate\n', '    mapping(address => address) internal _delegates;\n', '\n', '    /// @notice A checkpoint for marking number of votes from a given block\n', '    struct Checkpoint {\n', '        uint32 fromBlock;\n', '        uint256 votes;\n', '    }\n', '\n', '    /// @notice A record of votes checkpoints for each account, by index\n', '    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;\n', '\n', '    /// @notice The number of checkpoints for each account\n', '    mapping(address => uint32) public numCheckpoints;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256(\n', '        "EIP712Domain(string name,uint256 chainId,address verifyingContract)"\n', '    );\n', '\n', '    /// @notice The EIP-712 typehash for the delegation struct used by the contract\n', '    bytes32 public constant DELEGATION_TYPEHASH = keccak256(\n', '        "Delegation(address delegatee,uint256 nonce,uint256 expiry)"\n', '    );\n', '\n', '    /// @notice A record of states for signing / validating signatures\n', '    mapping(address => uint256) public nonces;\n', '}\n', '\n', 'contract YUANTokenInterface is YUANTokenStorage, YUANGovernanceStorage {\n', '    /// @notice An event thats emitted when an account changes its delegate\n', '    event DelegateChanged(\n', '        address indexed delegator,\n', '        address indexed fromDelegate,\n', '        address indexed toDelegate\n', '    );\n', '\n', "    /// @notice An event thats emitted when a delegate account's vote balance changes\n", '    event DelegateVotesChanged(\n', '        address indexed delegate,\n', '        uint256 previousBalance,\n', '        uint256 newBalance\n', '    );\n', '\n', '    /**\n', '     * @notice Event emitted when tokens are rebased\n', '     */\n', '    event Rebase(\n', '        uint256 epoch,\n', '        uint256 prevYuansScalingFactor,\n', '        uint256 newYuansScalingFactor\n', '    );\n', '\n', '    /*** Gov Events ***/\n', '\n', '    /**\n', '     * @notice Event emitted when pendingGov is changed\n', '     */\n', '    event NewPendingGov(address oldPendingGov, address newPendingGov);\n', '\n', '    /**\n', '     * @notice Event emitted when gov is changed\n', '     */\n', '    event NewGov(address oldGov, address newGov);\n', '\n', '    /**\n', '     * @notice Sets the rebaser contract\n', '     */\n', '    event NewRebaser(address oldRebaser, address newRebaser);\n', '\n', '    /**\n', '     * @notice Sets the migrator contract\n', '     */\n', '    event NewMigrator(address oldMigrator, address newMigrator);\n', '\n', '    /**\n', '     * @notice Sets the incentivizer contract\n', '     */\n', '    event NewIncentivizer(address oldIncentivizer, address newIncentivizer);\n', '\n', '    /* - ERC20 Events - */\n', '\n', '    /**\n', '     * @notice EIP20 Transfer event\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '\n', '    /**\n', '     * @notice EIP20 Approval event\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 amount\n', '    );\n', '\n', '    /* - Extra Events - */\n', '    /**\n', '     * @notice Tokens minted event\n', '     */\n', '    event Mint(address to, uint256 amount);\n', '\n', '    // Public functions\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function balanceOfUnderlying(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner_, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        external\n', '        returns (bool);\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        external\n', '        returns (bool);\n', '\n', '    function maxScalingFactor() external view returns (uint256);\n', '\n', '    function yuanToFragment(uint256 yuan) external view returns (uint256);\n', '\n', '    function fragmentToYuan(uint256 value) external view returns (uint256);\n', '\n', '    /* - Governance Functions - */\n', '    function getPriorVotes(address account, uint256 blockNumber)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function delegateBySig(\n', '        address delegatee,\n', '        uint256 nonce,\n', '        uint256 expiry,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '\n', '    function delegate(address delegatee) external;\n', '\n', '    function delegates(address delegator) external view returns (address);\n', '\n', '    function getCurrentVotes(address account) external view returns (uint256);\n', '\n', '    /* - Permissioned/Governance functions - */\n', '    function mint(address to, uint256 amount) external returns (bool);\n', '\n', '    function rebase(\n', '        uint256 epoch,\n', '        uint256 indexDelta,\n', '        bool positive\n', '    ) external returns (uint256);\n', '\n', '    function _setRebaser(address rebaser_) external;\n', '\n', '    function _setIncentivizer(address incentivizer_) external;\n', '\n', '    function _setPendingGov(address pendingGov_) external;\n', '\n', '    function _acceptGov() external;\n', '}\n', '\n', 'contract YUANReserves {\n', '    // Token that serves as a reserve for YUAN\n', '    address public reserveToken;\n', '\n', '    address public gov;\n', '\n', '    address public pendingGov;\n', '\n', '    address public rebaser;\n', '\n', '    address public yuanAddress;\n', '\n', '    /*** Gov Events ***/\n', '\n', '    /**\n', '     * @notice Event emitted when pendingGov is changed\n', '     */\n', '    event NewPendingGov(address oldPendingGov, address newPendingGov);\n', '\n', '    /**\n', '     * @notice Event emitted when gov is changed\n', '     */\n', '    event NewGov(address oldGov, address newGov);\n', '\n', '    /**\n', '     * @notice Event emitted when rebaser is changed\n', '     */\n', '    event NewRebaser(address oldRebaser, address newRebaser);\n', '\n', '    modifier onlyGov() {\n', '        require(msg.sender == gov);\n', '        _;\n', '    }\n', '\n', '    constructor(address reserveToken_, address yuanAddress_) public {\n', '        reserveToken = reserveToken_;\n', '        yuanAddress = yuanAddress_;\n', '        gov = msg.sender;\n', '    }\n', '\n', '    function _setRebaser(address rebaser_) external onlyGov {\n', '        address oldRebaser = rebaser;\n', '        YUANTokenInterface(yuanAddress).decreaseAllowance(\n', '            oldRebaser,\n', '            uint256(-1)\n', '        );\n', '        rebaser = rebaser_;\n', '        YUANTokenInterface(yuanAddress).approve(rebaser_, uint256(-1));\n', '        emit NewRebaser(oldRebaser, rebaser_);\n', '    }\n', '\n', '    /** @notice sets the pendingGov\n', '     * @param pendingGov_ The address of the gov contract to use for authentication.\n', '     */\n', '    function _setPendingGov(address pendingGov_) external onlyGov {\n', '        address oldPendingGov = pendingGov;\n', '        pendingGov = pendingGov_;\n', '        emit NewPendingGov(oldPendingGov, pendingGov_);\n', '    }\n', '\n', '    /**\n', '     * @notice lets msg.sender accept governance\n', '     */\n', '    function _acceptGov() external {\n', '        require(msg.sender == pendingGov, "!pending");\n', '        address oldGov = gov;\n', '        gov = pendingGov;\n', '        pendingGov = address(0);\n', '        emit NewGov(oldGov, gov);\n', '    }\n', '\n', '    /// @notice Moves all tokens to a new reserve contract\n', '    function migrateReserves(address newReserve, address[] memory tokens)\n', '        public\n', '        onlyGov\n', '    {\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            IERC20 token = IERC20(tokens[i]);\n', '            uint256 bal = token.balanceOf(address(this));\n', '            SafeERC20.safeTransfer(token, newReserve, bal);\n', '        }\n', '    }\n', '\n', '    /// @notice Gets the current amount of reserves token held by this contract\n', '    function reserves() public view returns (uint256) {\n', '        return IERC20(reserveToken).balanceOf(address(this));\n', '    }\n', '}']