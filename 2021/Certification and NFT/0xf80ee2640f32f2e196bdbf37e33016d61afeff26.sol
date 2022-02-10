['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-28\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '// File: @openzeppelin/contracts/utils/Context.sol\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '  function _msgSender() internal view virtual returns (address payable) {\n', '    return msg.sender;\n', '  }\n', '\n', '  function _msgData() internal view virtual returns (bytes memory) {\n', '    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '    return msg.data;\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '  /**\n', '   * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '   *\n', '   * _Available since v3.4._\n', '   */\n', '  function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '    uint256 c = a + b;\n', '    if (c < a) return (false, 0);\n', '    return (true, c);\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '   *\n', '   * _Available since v3.4._\n', '   */\n', '  function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '    if (b > a) return (false, 0);\n', '    return (true, a - b);\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '   *\n', '   * _Available since v3.4._\n', '   */\n', '  function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '    if (a == 0) return (true, 0);\n', '    uint256 c = a * b;\n', '    if (c / a != b) return (false, 0);\n', '    return (true, c);\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '   *\n', '   * _Available since v3.4._\n', '   */\n', '  function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '    if (b == 0) return (false, 0);\n', '    return (true, a / b);\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '   *\n', '   * _Available since v3.4._\n', '   */\n', '  function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '    if (b == 0) return (false, 0);\n', '    return (true, a % b);\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the addition of two unsigned integers, reverting on\n', '   * overflow.\n', '   *\n', "   * Counterpart to Solidity's `+` operator.\n", '   *\n', '   * Requirements:\n', '   *\n', '   * - Addition cannot overflow.\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a, "SafeMath: addition overflow");\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the subtraction of two unsigned integers, reverting on\n', '   * overflow (when the result is negative).\n', '   *\n', "   * Counterpart to Solidity's `-` operator.\n", '   *\n', '   * Requirements:\n', '   *\n', '   * - Subtraction cannot overflow.\n', '   */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a, "SafeMath: subtraction overflow");\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the multiplication of two unsigned integers, reverting on\n', '   * overflow.\n', '   *\n', "   * Counterpart to Solidity's `*` operator.\n", '   *\n', '   * Requirements:\n', '   *\n', '   * - Multiplication cannot overflow.\n', '   */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) return 0;\n', '    uint256 c = a * b;\n', '    require(c / a == b, "SafeMath: multiplication overflow");\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the integer division of two unsigned integers, reverting on\n', '   * division by zero. The result is rounded towards zero.\n', '   *\n', "   * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '   * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '   * uses an invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   *\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0, "SafeMath: division by zero");\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '   * reverting when dividing by zero.\n', '   *\n', "   * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '   * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '   * invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   *\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0, "SafeMath: modulo by zero");\n', '    return a % b;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '   * overflow (when the result is negative).\n', '   *\n', '   * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '   * message unnecessarily. For custom revert reasons use {trySub}.\n', '   *\n', "   * Counterpart to Solidity's `-` operator.\n", '   *\n', '   * Requirements:\n', '   *\n', '   * - Subtraction cannot overflow.\n', '   */\n', '  function sub(\n', '    uint256 a,\n', '    uint256 b,\n', '    string memory errorMessage\n', '  ) internal pure returns (uint256) {\n', '    require(b <= a, errorMessage);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '   * division by zero. The result is rounded towards zero.\n', '   *\n', '   * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '   * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '   *\n', "   * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '   * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '   * uses an invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   *\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function div(\n', '    uint256 a,\n', '    uint256 b,\n', '    string memory errorMessage\n', '  ) internal pure returns (uint256) {\n', '    require(b > 0, errorMessage);\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '   * reverting with custom message when dividing by zero.\n', '   *\n', '   * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '   * message unnecessarily. For custom revert reasons use {tryMod}.\n', '   *\n', "   * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '   * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '   * invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   *\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function mod(\n', '    uint256 a,\n', '    uint256 b,\n', '    string memory errorMessage\n', '  ) internal pure returns (uint256) {\n', '    require(b > 0, errorMessage);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '  /**\n', '   * @dev Returns true if `account` is a contract.\n', '   *\n', '   * [IMPORTANT]\n', '   * ====\n', '   * It is unsafe to assume that an address for which this function returns\n', '   * false is an externally-owned account (EOA) and not a contract.\n', '   *\n', '   * Among others, `isContract` will return false for the following\n', '   * types of addresses:\n', '   *\n', '   *  - an externally-owned account\n', '   *  - a contract in construction\n', '   *  - an address where a contract will be created\n', '   *  - an address where a contract lived, but was destroyed\n', '   * ====\n', '   */\n', '  function isContract(address account) internal view returns (bool) {\n', '    // This method relies on extcodesize, which returns 0 for contracts in\n', '    // construction, since the code is only stored at the end of the\n', '    // constructor execution.\n', '\n', '    uint256 size;\n', '    // solhint-disable-next-line no-inline-assembly\n', '    assembly {\n', '      size := extcodesize(account)\n', '    }\n', '    return size > 0;\n', '  }\n', '\n', '  /**\n', "   * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '   * `recipient`, forwarding all available gas and reverting on errors.\n', '   *\n', '   * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '   * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '   * imposed by `transfer`, making them unable to receive funds via\n', '   * `transfer`. {sendValue} removes this limitation.\n', '   *\n', '   * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '   *\n', '   * IMPORTANT: because control is transferred to `recipient`, care must be\n', '   * taken to not create reentrancy vulnerabilities. Consider using\n', '   * {ReentrancyGuard} or the\n', '   * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '   */\n', '  function sendValue(address payable recipient, uint256 amount) internal {\n', '    require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '    (bool success, ) = recipient.call{ value: amount }("");\n', '    require(\n', '      success,\n', '      "Address: unable to send value, recipient may have reverted"\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev Performs a Solidity function call using a low level `call`. A\n', '   * plain`call` is an unsafe replacement for a function call: use this\n', '   * function instead.\n', '   *\n', '   * If `target` reverts with a revert reason, it is bubbled up by this\n', '   * function (like regular Solidity function calls).\n', '   *\n', '   * Returns the raw returned data. To convert to the expected return value,\n', '   * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '   *\n', '   * Requirements:\n', '   *\n', '   * - `target` must be a contract.\n', '   * - calling `target` with `data` must not revert.\n', '   *\n', '   * _Available since v3.1._\n', '   */\n', '  function functionCall(address target, bytes memory data)\n', '    internal\n', '    returns (bytes memory)\n', '  {\n', '    return functionCall(target, data, "Address: low-level call failed");\n', '  }\n', '\n', '  /**\n', '   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '   * `errorMessage` as a fallback revert reason when `target` reverts.\n', '   *\n', '   * _Available since v3.1._\n', '   */\n', '  function functionCall(\n', '    address target,\n', '    bytes memory data,\n', '    string memory errorMessage\n', '  ) internal returns (bytes memory) {\n', '    return functionCallWithValue(target, data, 0, errorMessage);\n', '  }\n', '\n', '  /**\n', '   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '   * but also transferring `value` wei to `target`.\n', '   *\n', '   * Requirements:\n', '   *\n', '   * - the calling contract must have an ETH balance of at least `value`.\n', '   * - the called Solidity function must be `payable`.\n', '   *\n', '   * _Available since v3.1._\n', '   */\n', '  function functionCallWithValue(\n', '    address target,\n', '    bytes memory data,\n', '    uint256 value\n', '  ) internal returns (bytes memory) {\n', '    return\n', '      functionCallWithValue(\n', '        target,\n', '        data,\n', '        value,\n', '        "Address: low-level call with value failed"\n', '      );\n', '  }\n', '\n', '  /**\n', '   * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '   * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '   *\n', '   * _Available since v3.1._\n', '   */\n', '  function functionCallWithValue(\n', '    address target,\n', '    bytes memory data,\n', '    uint256 value,\n', '    string memory errorMessage\n', '  ) internal returns (bytes memory) {\n', '    require(\n', '      address(this).balance >= value,\n', '      "Address: insufficient balance for call"\n', '    );\n', '    require(isContract(target), "Address: call to non-contract");\n', '\n', '    // solhint-disable-next-line avoid-low-level-calls\n', '    (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '    return _verifyCallResult(success, returndata, errorMessage);\n', '  }\n', '\n', '  /**\n', '   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '   * but performing a static call.\n', '   *\n', '   * _Available since v3.3._\n', '   */\n', '  function functionStaticCall(address target, bytes memory data)\n', '    internal\n', '    view\n', '    returns (bytes memory)\n', '  {\n', '    return\n', '      functionStaticCall(target, data, "Address: low-level static call failed");\n', '  }\n', '\n', '  /**\n', '   * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '   * but performing a static call.\n', '   *\n', '   * _Available since v3.3._\n', '   */\n', '  function functionStaticCall(\n', '    address target,\n', '    bytes memory data,\n', '    string memory errorMessage\n', '  ) internal view returns (bytes memory) {\n', '    require(isContract(target), "Address: static call to non-contract");\n', '\n', '    // solhint-disable-next-line avoid-low-level-calls\n', '    (bool success, bytes memory returndata) = target.staticcall(data);\n', '    return _verifyCallResult(success, returndata, errorMessage);\n', '  }\n', '\n', '  /**\n', '   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '   * but performing a delegate call.\n', '   *\n', '   * _Available since v3.4._\n', '   */\n', '  function functionDelegateCall(address target, bytes memory data)\n', '    internal\n', '    returns (bytes memory)\n', '  {\n', '    return\n', '      functionDelegateCall(\n', '        target,\n', '        data,\n', '        "Address: low-level delegate call failed"\n', '      );\n', '  }\n', '\n', '  /**\n', '   * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '   * but performing a delegate call.\n', '   *\n', '   * _Available since v3.4._\n', '   */\n', '  function functionDelegateCall(\n', '    address target,\n', '    bytes memory data,\n', '    string memory errorMessage\n', '  ) internal returns (bytes memory) {\n', '    require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '    // solhint-disable-next-line avoid-low-level-calls\n', '    (bool success, bytes memory returndata) = target.delegatecall(data);\n', '    return _verifyCallResult(success, returndata, errorMessage);\n', '  }\n', '\n', '  function _verifyCallResult(\n', '    bool success,\n', '    bytes memory returndata,\n', '    string memory errorMessage\n', '  ) private pure returns (bytes memory) {\n', '    if (success) {\n', '      return returndata;\n', '    } else {\n', '      // Look for revert reason and bubble it up if present\n', '      if (returndata.length > 0) {\n', '        // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '          let returndata_size := mload(returndata)\n', '          revert(add(32, returndata), returndata_size)\n', '        }\n', '      } else {\n', '        revert(errorMessage);\n', '      }\n', '    }\n', '  }\n', '}\n', '\n', '// File: @openzeppelin/contracts/payment/PaymentSplitter.sol\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @title PaymentSplitter\n', ' * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware\n', ' * that the Ether will be split in this way, since it is handled transparently by the contract.\n', ' *\n', ' * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each\n', ' * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim\n', ' * an amount proportional to the percentage of total shares they were assigned.\n', ' *\n', ' * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the\n', ' * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}\n', ' * function.\n', ' */\n', 'contract PaymentSplitter is Context {\n', '  using SafeMath for uint256;\n', '\n', '  event PayeeAdded(address account, uint256 shares);\n', '  event PaymentReleased(address to, uint256 amount);\n', '  event PaymentReceived(address from, uint256 amount);\n', '\n', '  uint256 private _totalShares;\n', '  uint256 private _totalReleased;\n', '\n', '  mapping(address => uint256) private _shares;\n', '  mapping(address => uint256) private _released;\n', '  address[] private _payees;\n', '\n', '  /**\n', '   * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at\n', '   * the matching position in the `shares` array.\n', '   *\n', '   * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no\n', '   * duplicates in `payees`.\n', '   */\n', '  constructor(address[] memory payees, uint256[] memory shares_)\n', '    public\n', '    payable\n', '  {\n', '    // solhint-disable-next-line max-line-length\n', '    require(\n', '      payees.length == shares_.length,\n', '      "PaymentSplitter: payees and shares length mismatch"\n', '    );\n', '    require(payees.length > 0, "PaymentSplitter: no payees");\n', '\n', '    for (uint256 i = 0; i < payees.length; i++) {\n', '      _addPayee(payees[i], shares_[i]);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully\n', "   * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the\n", '   * reliability of the events, and not the actual splitting of Ether.\n', '   *\n', '   * To learn more about this see the Solidity documentation for\n', '   * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback\n', '   * functions].\n', '   */\n', '  receive() external payable {\n', '    emit PaymentReceived(_msgSender(), msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev Getter for the total shares held by payees.\n', '   */\n', '  function totalShares() public view returns (uint256) {\n', '    return _totalShares;\n', '  }\n', '\n', '  /**\n', '   * @dev Getter for the total amount of Ether already released.\n', '   */\n', '  function totalReleased() public view returns (uint256) {\n', '    return _totalReleased;\n', '  }\n', '\n', '  /**\n', '   * @dev Getter for the amount of shares held by an account.\n', '   */\n', '  function shares(address account) public view returns (uint256) {\n', '    return _shares[account];\n', '  }\n', '\n', '  /**\n', '   * @dev Getter for the amount of Ether already released to a payee.\n', '   */\n', '  function released(address account) public view returns (uint256) {\n', '    return _released[account];\n', '  }\n', '\n', '  /**\n', '   * @dev Getter for the address of the payee number `index`.\n', '   */\n', '  function payee(uint256 index) public view returns (address) {\n', '    return _payees[index];\n', '  }\n', '\n', '  /**\n', '   * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the\n', '   * total shares and their previous withdrawals.\n', '   */\n', '  function release(address payable account) public virtual {\n', '    require(_shares[account] > 0, "PaymentSplitter: account has no shares");\n', '\n', '    uint256 totalReceived = address(this).balance.add(_totalReleased);\n', '    uint256 payment =\n', '      totalReceived.mul(_shares[account]).div(_totalShares).sub(\n', '        _released[account]\n', '      );\n', '\n', '    require(payment != 0, "PaymentSplitter: account is not due payment");\n', '\n', '    _released[account] = _released[account].add(payment);\n', '    _totalReleased = _totalReleased.add(payment);\n', '\n', '    Address.sendValue(account, payment);\n', '    emit PaymentReleased(account, payment);\n', '  }\n', '\n', '  /**\n', '   * @dev Add a new payee to the contract.\n', '   * @param account The address of the payee to add.\n', '   * @param shares_ The number of shares owned by the payee.\n', '   */\n', '  function _addPayee(address account, uint256 shares_) private {\n', '    require(\n', '      account != address(0),\n', '      "PaymentSplitter: account is the zero address"\n', '    );\n', '    require(shares_ > 0, "PaymentSplitter: shares are 0");\n', '    require(\n', '      _shares[account] == 0,\n', '      "PaymentSplitter: account already has shares"\n', '    );\n', '\n', '    _payees.push(account);\n', '    _shares[account] = shares_;\n', '    _totalShares = _totalShares.add(shares_);\n', '    emit PayeeAdded(account, shares_);\n', '  }\n', '}\n', '\n', '// File: contracts/PaymentSplitter.sol\n', '\n', 'pragma solidity >=0.7.6;']