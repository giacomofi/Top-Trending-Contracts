['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-04\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.6.0 <0.8.0;\n', 'pragma experimental ABIEncoderV2;\n', ' \n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '\t/**\n', '\t * @dev Returns the addition of two unsigned integers, reverting on\n', '\t * overflow.\n', '\t *\n', "\t * Counterpart to Solidity's `+` operator.\n", '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - Addition cannot overflow.\n', '\t */\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\trequire(c >= a, "SafeMath: addition overflow");\n', '\n', '\t\treturn c;\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the subtraction of two unsigned integers, reverting on\n', '\t * overflow (when the result is negative).\n', '\t *\n', "\t * Counterpart to Solidity's `-` operator.\n", '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - Subtraction cannot overflow.\n', '\t */\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\treturn sub(a, b, "SafeMath: subtraction overflow");\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '\t * overflow (when the result is negative).\n', '\t *\n', "\t * Counterpart to Solidity's `-` operator.\n", '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - Subtraction cannot overflow.\n', '\t */\n', '\tfunction sub(\n', '\t\tuint256 a,\n', '\t\tuint256 b,\n', '\t\tstring memory errorMessage\n', '\t) internal pure returns (uint256) {\n', '\t\trequire(b <= a, errorMessage);\n', '\t\tuint256 c = a - b;\n', '\n', '\t\treturn c;\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the multiplication of two unsigned integers, reverting on\n', '\t * overflow.\n', '\t *\n', "\t * Counterpart to Solidity's `*` operator.\n", '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - Multiplication cannot overflow.\n', '\t */\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "\t\t// Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "\t\t// benefit is lost if 'b' is also tested.\n", '\t\t// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\n', '\t\tuint256 c = a * b;\n', '\t\trequire(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '\t\treturn c;\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the integer division of two unsigned integers. Reverts on\n', '\t * division by zero. The result is rounded towards zero.\n', '\t *\n', "\t * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '\t * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '\t * uses an invalid opcode to revert (consuming all remaining gas).\n', '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - The divisor cannot be zero.\n', '\t */\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\treturn div(a, b, "SafeMath: division by zero");\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '\t * division by zero. The result is rounded towards zero.\n', '\t *\n', "\t * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '\t * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '\t * uses an invalid opcode to revert (consuming all remaining gas).\n', '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - The divisor cannot be zero.\n', '\t */\n', '\tfunction div(\n', '\t\tuint256 a,\n', '\t\tuint256 b,\n', '\t\tstring memory errorMessage\n', '\t) internal pure returns (uint256) {\n', '\t\trequire(b > 0, errorMessage);\n', '\t\tuint256 c = a / b;\n', "\t\t// assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '\t\treturn c;\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '\t * Reverts when dividing by zero.\n', '\t *\n', "\t * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '\t * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '\t * invalid opcode to revert (consuming all remaining gas).\n', '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - The divisor cannot be zero.\n', '\t */\n', '\tfunction mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\treturn mod(a, b, "SafeMath: modulo by zero");\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '\t * Reverts with custom message when dividing by zero.\n', '\t *\n', "\t * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '\t * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '\t * invalid opcode to revert (consuming all remaining gas).\n', '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - The divisor cannot be zero.\n', '\t */\n', '\tfunction mod(\n', '\t\tuint256 a,\n', '\t\tuint256 b,\n', '\t\tstring memory errorMessage\n', '\t) internal pure returns (uint256) {\n', '\t\trequire(b != 0, errorMessage);\n', '\t\treturn a % b;\n', '\t}\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '\tfunction _msgSender() internal view virtual returns (address payable) {\n', '\t\treturn msg.sender;\n', '\t}\n', '\n', '\tfunction _msgData() internal view virtual returns (bytes memory) {\n', '\t\tthis; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '\t\treturn msg.data;\n', '\t}\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '\t/**\n', '\t * @dev Returns true if `account` is a contract.\n', '\t *\n', '\t * [IMPORTANT]\n', '\t * ====\n', '\t * It is unsafe to assume that an address for which this function returns\n', '\t * false is an externally-owned account (EOA) and not a contract.\n', '\t *\n', '\t * Among others, `isContract` will return false for the following\n', '\t * types of addresses:\n', '\t *\n', '\t *  - an externally-owned account\n', '\t *  - a contract in construction\n', '\t *  - an address where a contract will be created\n', '\t *  - an address where a contract lived, but was destroyed\n', '\t * ====\n', '\t */\n', '\tfunction isContract(address account) internal view returns (bool) {\n', '\t\t// This method relies in extcodesize, which returns 0 for contracts in\n', '\t\t// construction, since the code is only stored at the end of the\n', '\t\t// constructor execution.\n', '\n', '\t\tuint256 size;\n', '\t\t// solhint-disable-next-line no-inline-assembly\n', '\t\tassembly {\n', '\t\t\tsize := extcodesize(account)\n', '\t\t}\n', '\t\treturn size > 0;\n', '\t}\n', '\n', '\t/**\n', "\t * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '\t * `recipient`, forwarding all available gas and reverting on errors.\n', '\t *\n', '\t * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '\t * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '\t * imposed by `transfer`, making them unable to receive funds via\n', '\t * `transfer`. {sendValue} removes this limitation.\n', '\t *\n', '\t * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '\t *\n', '\t * IMPORTANT: because control is transferred to `recipient`, care must be\n', '\t * taken to not create reentrancy vulnerabilities. Consider using\n', '\t * {ReentrancyGuard} or the\n', '\t * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '\t */\n', '\tfunction sendValue(address payable recipient, uint256 amount) internal {\n', '\t\trequire(\n', '\t\t\taddress(this).balance >= amount,\n', '\t\t\t"Address: insufficient balance"\n', '\t\t);\n', '\n', '\t\t// solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '\t\t(bool success, ) = recipient.call{ value: amount }("");\n', '\t\trequire(\n', '\t\t\tsuccess,\n', '\t\t\t"Address: unable to send value, recipient may have reverted"\n', '\t\t);\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Performs a Solidity function call using a low level `call`. A\n', '\t * plain`call` is an unsafe replacement for a function call: use this\n', '\t * function instead.\n', '\t *\n', '\t * If `target` reverts with a revert reason, it is bubbled up by this\n', '\t * function (like regular Solidity function calls).\n', '\t *\n', '\t * Returns the raw returned data. To convert to the expected return value,\n', '\t * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - `target` must be a contract.\n', '\t * - calling `target` with `data` must not revert.\n', '\t *\n', '\t * _Available since v3.1._\n', '\t */\n', '\tfunction functionCall(address target, bytes memory data)\n', '\t\tinternal\n', '\t\treturns (bytes memory)\n', '\t{\n', '\t\treturn functionCall(target, data, "Address: low-level call failed");\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '\t * `errorMessage` as a fallback revert reason when `target` reverts.\n', '\t *\n', '\t * _Available since v3.1._\n', '\t */\n', '\tfunction functionCall(\n', '\t\taddress target,\n', '\t\tbytes memory data,\n', '\t\tstring memory errorMessage\n', '\t) internal returns (bytes memory) {\n', '\t\treturn _functionCallWithValue(target, data, 0, errorMessage);\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '\t * but also transferring `value` wei to `target`.\n', '\t *\n', '\t * Requirements:\n', '\t *\n', '\t * - the calling contract must have an ETH balance of at least `value`.\n', '\t * - the called Solidity function must be `payable`.\n', '\t *\n', '\t * _Available since v3.1._\n', '\t */\n', '\tfunction functionCallWithValue(\n', '\t\taddress target,\n', '\t\tbytes memory data,\n', '\t\tuint256 value\n', '\t) internal returns (bytes memory) {\n', '\t\treturn\n', '\t\t\tfunctionCallWithValue(\n', '\t\t\t\ttarget,\n', '\t\t\t\tdata,\n', '\t\t\t\tvalue,\n', '\t\t\t\t"Address: low-level call with value failed"\n', '\t\t\t);\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '\t * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '\t *\n', '\t * _Available since v3.1._\n', '\t */\n', '\tfunction functionCallWithValue(\n', '\t\taddress target,\n', '\t\tbytes memory data,\n', '\t\tuint256 value,\n', '\t\tstring memory errorMessage\n', '\t) internal returns (bytes memory) {\n', '\t\trequire(\n', '\t\t\taddress(this).balance >= value,\n', '\t\t\t"Address: insufficient balance for call"\n', '\t\t);\n', '\t\treturn _functionCallWithValue(target, data, value, errorMessage);\n', '\t}\n', '\n', '\tfunction _functionCallWithValue(\n', '\t\taddress target,\n', '\t\tbytes memory data,\n', '\t\tuint256 weiValue,\n', '\t\tstring memory errorMessage\n', '\t) private returns (bytes memory) {\n', '\t\trequire(isContract(target), "Address: call to non-contract");\n', '\n', '\t\t// solhint-disable-next-line avoid-low-level-calls\n', '\t\t(bool success, bytes memory returndata) =\n', '\t\t\ttarget.call{ value: weiValue }(data);\n', '\t\tif (success) {\n', '\t\t\treturn returndata;\n', '\t\t} else {\n', '\t\t\t// Look for revert reason and bubble it up if present\n', '\t\t\tif (returndata.length > 0) {\n', '\t\t\t\t// The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '\t\t\t\t// solhint-disable-next-line no-inline-assembly\n', '\t\t\t\tassembly {\n', '\t\t\t\t\tlet returndata_size := mload(returndata)\n', '\t\t\t\t\trevert(add(32, returndata), returndata_size)\n', '\t\t\t\t}\n', '\t\t\t} else {\n', '\t\t\t\trevert(errorMessage);\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '\taddress private _owner;\n', '\n', '\tevent OwnershipTransferred(\n', '\t\taddress indexed previousOwner,\n', '\t\taddress indexed newOwner\n', '\t);\n', '\n', '\t/**\n', '\t * @dev Initializes the contract setting the deployer as the initial owner.\n', '\t */\n', '\tconstructor() public{\n', '\t\taddress msgSender = _msgSender();\n', '\t\t_owner = msgSender;\n', '\t\temit OwnershipTransferred(address(0), msgSender);\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Returns the address of the current owner.\n', '\t */\n', '\tfunction owner() public view returns (address) {\n', '\t\treturn _owner;\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Throws if called by any account other than the owner.\n', '\t */\n', '\tmodifier onlyOwner() {\n', '\t\trequire(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '\t\t_;\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Leaves the contract without owner. It will not be possible to call\n', '\t * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '\t *\n', '\t * NOTE: Renouncing ownership will leave the contract without an owner,\n', '\t * thereby removing any functionality that is only available to the owner.\n', '\t */\n', '\tfunction renounceOwnership() public virtual onlyOwner {\n', '\t\temit OwnershipTransferred(_owner, address(0));\n', '\t\t_owner = address(0);\n', '\t}\n', '\n', '\t/**\n', '\t * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '\t * Can only be called by the current owner.\n', '\t */\n', '\tfunction transferOwnership(address newOwner) public virtual onlyOwner {\n', '\t\trequire(\n', '\t\t\tnewOwner != address(0),\n', '\t\t\t"Ownable: new owner is the zero address"\n', '\t\t);\n', '\t\temit OwnershipTransferred(_owner, newOwner);\n', '\t\t_owner = newOwner;\n', '\t}\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '\t/**\n', '\t * @dev Returns the amount of tokens in existence.\n', '\t */\n', '\tfunction totalSupply() external view returns (uint256);\n', '\n', '\t/**\n', '\t * @dev Returns the amount of tokens owned by `account`.\n', '\t */\n', '\tfunction balanceOf(address account) external view returns (uint256);\n', '\n', '\t/**\n', "\t * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '\t *\n', '\t * Returns a boolean value indicating whether the operation succeeded.\n', '\t *\n', '\t * Emits a {Transfer} event.\n', '\t */\n', '\tfunction transfer(address recipient, uint256 amount)\n', '\t\texternal\n', '\t\treturns (bool);\n', '\n', '\t/**\n', '\t * @dev Returns the remaining number of tokens that `spender` will be\n', '\t * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '\t * zero by default.\n', '\t *\n', '\t * This value changes when {approve} or {transferFrom} are called.\n', '\t */\n', '\tfunction allowance(address owner, address spender)\n', '\t\texternal\n', '\t\tview\n', '\t\treturns (uint256);\n', '\n', '\t/**\n', "\t * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '\t *\n', '\t * Returns a boolean value indicating whether the operation succeeded.\n', '\t *\n', '\t * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '\t * that someone may use both the old and the new allowance by unfortunate\n', '\t * transaction ordering. One possible solution to mitigate this race\n', "\t * condition is to first reduce the spender's allowance to 0 and set the\n", '\t * desired value afterwards:\n', '\t * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\t *\n', '\t * Emits an {Approval} event.\n', '\t */\n', '\tfunction approve(address spender, uint256 amount) external returns (bool);\n', '\n', '\t/**\n', '\t * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "\t * allowance mechanism. `amount` is then deducted from the caller's\n", '\t * allowance.\n', '\t *\n', '\t * Returns a boolean value indicating whether the operation succeeded.\n', '\t *\n', '\t * Emits a {Transfer} event.\n', '\t */ \n', '\tfunction transferFrom(\n', '\t\taddress sender,\n', '\t\taddress recipient,\n', '\t\tuint256 amount\n', '\t) external returns (bool);\n', '\n', '\t/**\n', '\t * @dev Mint amount of token to specified account by an operator address\n', '\t */\n', '\tfunction mint(address account, uint256 amount) external returns (bool);\n', '\n', '\t/**\n', '\t * @dev Burn amount of token from specified account by an operator address\n', '\t */\n', '\tfunction burn(address account, uint256 amount) external returns (bool);\n', '\n', '\t/**\n', '\t * @dev Add an address to operator list of token\n', '\t */\n', '\tfunction addOperator(address minter) external returns (bool);\n', '\n', '\t/**\n', '\t * @dev Remove an address from operator list of token\n', '\t */\n', '\tfunction removeOperator(address minter) external returns (bool);\n', '\n', '\t/**\n', '\t * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '\t * another (`to`).\n', '\t *\n', '\t * Note that `value` may be zero.\n', '\t */\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\t/**\n', '\t * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '\t * a call to {approve}. `value` is the new allowance.\n', '\t */\n', '\tevent Approval(\n', '\t\taddress indexed owner,\n', '\t\taddress indexed spender,\n', '\t\tuint256 value\n', '\t);\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', ' \n', 'contract SwapUSDTtoUSDL is Ownable {\n', '\tusing SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\tIERC20 public token;\n', '\tIERC20 public poolUSDL;\n', '\tuint256 public USDLDecimal;\n', '\tevent TokenSwap(\n', '\t\taddress indexed wallet,\n', '\t\tuint256 amount,\n', '\t\tstring reason,\n', '\t\tuint256 datetime\n', '\t);\n', '\n', '\tconstructor(\n', '\t\taddress _token,  //USDT\n', '        uint256 _USDLDecimal, //18\n', '\t\taddress _poolUSDL  //USDL\n', '\t) public {\n', '\t\ttoken = IERC20(_token);\n', '        USDLDecimal = _USDLDecimal;\n', '\t\tpoolUSDL = IERC20(_poolUSDL);\n', '\t}\n', '\n', '\tfunction convertToken(uint256 _amount) external {\n', '\t\trequire(_amount > 0, "need gt 0");\n', '        token.safeTransferFrom(msg.sender, address(this), _amount);\n', '        uint256 amountTransfer = _amount.mul(uint256(1e18)).div(10**USDLDecimal);\n', '        poolUSDL.mint(msg.sender, amountTransfer);\n', ' \n', '        emit TokenSwap(\n', '            msg.sender,\n', '            _amount,\n', '            "Swap USDT to USDL",\n', '            block.timestamp\n', '        );\n', '\t}\n', '\n', '    function revertToken(uint _amount) external {\n', '        require(poolUSDL.balanceOf(msg.sender) >= _amount && _amount > 0, "not enough");\n', '        poolUSDL.burn(msg.sender, _amount); \n', '        uint256 amountTransfer = _amount.mul(10**USDLDecimal).div(uint256(1e18));\n', '        token.safeTransfer(msg.sender, amountTransfer);\n', '\n', '        emit TokenSwap(\n', '            msg.sender,\n', '            _amount,\n', '            "Swap USDL to USDT",\n', '            block.timestamp\n', '        );\n', '    }\n', '\n', '\t\n', '}']