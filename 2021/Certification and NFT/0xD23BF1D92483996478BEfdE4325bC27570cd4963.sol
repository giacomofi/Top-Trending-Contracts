['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts may inherit from this and call {_registerInterface} to declare\n', ' * their support of an interface.\n', ' */\n', 'abstract contract ERC165 is IERC165 {\n', '    /*\n', "     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7\n", '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    /**\n', "     * @dev Mapping of interface ids to whether or not it's supported.\n", '     */\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () {\n', '        // Derived contracts need only register support for their own interfaces,\n', '        // we register support for ERC165 itself here\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     *\n', '     * Time complexity O(1), guaranteed to always use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    /**\n', '     * @dev Registers the contract as an implementer of the interface defined by\n', '     * `interfaceId`. Support of the actual ERC165 interface is automatic and\n', '     * registering its interface id is not required.\n', '     *\n', '     * See {IERC165-supportsInterface}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).\n', '     */\n', '    function _registerInterface(bytes4 interfaceId) internal virtual {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', '\n', '/**\n', '    @title ERC-1155 Multi Token Standard\n', '    @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md\n', '    Note: The ERC-165 identifier for this interface is 0xd9b67a26.\n', ' */\n', 'interface IERC1155 is IERC165 {\n', '    /**\n', '        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).\n', '        The `_operator` argument MUST be msg.sender.\n', '        The `_from` argument MUST be the address of the holder whose balance is decreased.\n', '        The `_to` argument MUST be the address of the recipient whose balance is increased.\n', '        The `_id` argument MUST be the token type being transferred.\n', '        The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.\n', '        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).\n', '        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).\n', '    */\n', '    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);\n', '\n', '    /**\n', '        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).\n', '        The `_operator` argument MUST be msg.sender.\n', '        The `_from` argument MUST be the address of the holder whose balance is decreased.\n', '        The `_to` argument MUST be the address of the recipient whose balance is increased.\n', '        The `_ids` argument MUST be the list of tokens being transferred.\n', '        The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.\n', '        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).\n', '        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).\n', '    */\n', '    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);\n', '\n', '    /**\n', '        @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).\n', '    */\n', '    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);\n', '\n', '    /**\n', '        @dev MUST emit when the URI is updated for a token ID.\n', '        URIs are defined in RFC 3986.\n', '        The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".\n', '    */\n', '    event URI(string _value, uint256 indexed _id);\n', '\n', '    /**\n', '        @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).\n', '        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).\n', '        MUST revert if `_to` is the zero address.\n', '        MUST revert if balance of holder for token `_id` is lower than the `_value` sent.\n', '        MUST revert on any other error.\n', '        MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).\n', '        After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '        @param _from    Source address\n', '        @param _to      Target address\n', '        @param _id      ID of the token type\n', '        @param _value   Transfer amount\n', '        @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`\n', '    */\n', '    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;\n', '\n', '    /**\n', '        @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).\n', '        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).\n', '        MUST revert if `_to` is the zero address.\n', '        MUST revert if length of `_ids` is not the same as length of `_values`.\n', '        MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.\n', '        MUST revert on any other error.\n', '        MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).\n', '        Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).\n', '        After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '        @param _from    Source address\n', '        @param _to      Target address\n', '        @param _ids     IDs of each token type (order and length must match _values array)\n', '        @param _values  Transfer amounts per token type (order and length must match _ids array)\n', '        @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`\n', '    */\n', '    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;\n', '\n', '    /**\n', "        @notice Get the balance of an account's Tokens.\n", '        @param _owner  The address of the token holder\n', '        @param _id     ID of the Token\n', "        @return        The _owner's balance of the Token type requested\n", '     */\n', '    function balanceOf(address _owner, uint256 _id) external view returns (uint256);\n', '\n', '    /**\n', '        @notice Get the balance of multiple account/token pairs\n', '        @param _owners The addresses of the token holders\n', '        @param _ids    ID of the Tokens\n', "        @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)\n", '     */\n', '    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', '        @notice Enable or disable approval for a third party ("operator") to manage all of the caller\'s tokens.\n', '        @dev MUST emit the ApprovalForAll event on success.\n', '        @param _operator  Address to add to the set of authorized operators\n', '        @param _approved  True if the operator is approved, false to revoke approval\n', '    */\n', '    function setApprovalForAll(address _operator, bool _approved) external;\n', '\n', '    /**\n', '        @notice Queries the approval status of an operator for a given owner.\n', '        @param _owner     The owner of the Tokens\n', '        @param _operator  Address of authorized operator\n', '        @return           True if the operator is approved, false if not\n', '    */\n', '    function isApprovedForAll(address _owner, address _operator) external view returns (bool);\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * Collection instance\n', ' */\n', 'abstract contract Collection is IERC1155 {\n', '    mapping (uint256 => address) public creators;\n', '    function getFeeRecipients(uint256 id) external virtual view returns (address[] memory);\n', '    function getFeeBps(uint256 id) external virtual view returns (uint[] memory);\n', '}\n', '\n', '/**\n', ' * Marketplace Contract\n', ' */\n', 'contract NiftyPlanetMarketplace is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Structs\n', '    struct Item {\n', '        address collection;\n', '        uint256 id;\n', '    }\n', '    struct Position {\n', '        Item item;\n', '        uint256 amount;\n', '        uint256 price;\n', '        address owner;\n', '    }\n', '\n', '    // Variables\n', '    mapping (uint256 => Position) public positions;\n', '    uint256 public positionsCount = 0;\n', '    address private beneficiaryAddress;\n', '    uint256 private beneficiaryFee = 100;\n', '\n', '    // Events\n', '    event PositionCreated(address indexed owner, address indexed collection, uint256 indexed tokenId, uint256 id);\n', '    event PositionDeleted(address operator, uint256 position, address indexed collection, uint256 indexed tokenId);\n', '    event PositionPurchased(address indexed owner, uint256 position, address indexed collection, uint256 indexed token, uint256 amount, uint256 price, address buyer);\n', '\n', '    // —\n', '    constructor(address _beneficiaryAddress) {\n', '        beneficiaryAddress = _beneficiaryAddress;\n', '    }\n', '\n', '    // —\n', '    function changeBeneficiary(address _beneficiaryAddress) external onlyOwner {\n', '        beneficiaryAddress = _beneficiaryAddress;\n', '    }\n', '\n', '    // —\n', '    function changeBeneficiaryFee(uint256 _beneficiaryFee) external onlyOwner {\n', '        beneficiaryFee = _beneficiaryFee;\n', '    }\n', '\n', '    // —\n', '    function getFee(uint256 _sum, uint256 _fee) internal pure returns(uint256) {\n', '        return _sum.mul(_fee).div(10000);\n', '    }\n', '\n', '    // —\n', '    function createPosition(address _collection, uint256 _id, uint256 _amount, uint256 _price) external returns(uint256) {\n', '        require(Collection(_collection).balanceOf(msg.sender, _id) >= _amount, "Create: not enough amount of NFT on owner\'s balance");\n', '        require(Collection(_collection).creators(_id) != address(0), "Create: creator is null");\n', '\n', '        positionsCount++;\n', '        positions[positionsCount] = Position(Item(_collection, _id), _amount, _price, msg.sender);\n', '\n', '        emit PositionCreated(msg.sender, _collection, _id, positionsCount);\n', '        return positionsCount;\n', '    }\n', '\n', '    // —\n', '    function deletePosition(uint256 _id) external {\n', '        require(msg.sender == positions[_id].owner || msg.sender == this.owner(), "Delete: access restricted");\n', '        positions[_id].amount = 0;\n', '\n', '        emit PositionDeleted(msg.sender, _id, positions[_id].item.collection, positions[_id].item.id);\n', '    }\n', '\n', '    // —\n', '    function purchasePosition(uint256 _position, uint256 _amount, address _buyer, bytes calldata _data) payable external {\n', '        Position memory position = positions[_position];\n', '        Collection collection = Collection(position.item.collection);\n', '        require(position.amount >= _amount, "Purchase: not enough amount of items on marketplace");\n', '        require(position.price <= msg.value, "Purchase: wrong transaction value");\n', '\n', '        if (_buyer == address(0x0)) {\n', '            _buyer = msg.sender;\n', '        }\n', '\n', '        require(transferWithFees(_position, _amount) == true, "Purchase: fees not transferred");\n', '        collection.safeTransferFrom(position.owner, _buyer, position.item.id, _amount, _data);\n', '        emit PositionPurchased(position.owner, _position, position.item.collection, position.item.id, _amount, position.price, _buyer);\n', '    }\n', '\n', '    // —\n', '    function transferWithFees(uint256 _position, uint256 _amount) internal returns(bool) {\n', '        Position storage position = positions[_position];\n', '        uint256 sum = position.price.mul(_amount);\n', '        uint256 fee = getFee(sum, beneficiaryFee);\n', '        uint256 total = sum.add(fee);\n', '        require(msg.value >= total, "Fees: insufficient balance");\n', '\n', '        uint256 rollback = msg.value.sub(total);\n', '        if(rollback > 0) {\n', '            // Rollback transaction\n', '            payable(msg.sender).transfer(rollback);\n', '\n', '            return false;\n', '        } else {\n', '            // Proceed transfers\n', '            position.amount = position.amount.sub(_amount);\n', '\n', '            // Beneficiary fees\n', '            if (fee > 0) {\n', '                payable(beneficiaryAddress).transfer(fee);\n', '            }\n', '\n', '            // Owner and other fees\n', '            uint256 fees = transferFees(position.item, sum);\n', '            payable(position.owner).transfer(sum.sub(fees));\n', '\n', '            return true;\n', '        }\n', '    }\n', '\n', '    // —\n', '    function transferFees(Item memory _item, uint256 _sum) internal returns(uint256) {\n', '        Collection collection = Collection(_item.collection);\n', '        uint[] memory fees = collection.getFeeBps(_item.id);\n', '        address[] memory recipients = collection.getFeeRecipients(_item.id);\n', '        uint256 total = 0;\n', '\n', '        for (uint256 i = 0; i < fees.length; i++) {\n', '            uint256 fee = getFee(_sum, fees[i]);\n', '            if (fee > 0) {\n', '                payable(recipients[i]).transfer(fee);\n', '                total = total.add(fee);\n', '            }\n', '        }\n', '        return total;\n', '    }\n', '}\n', '\n', '{\n', '  "remappings": [],\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']