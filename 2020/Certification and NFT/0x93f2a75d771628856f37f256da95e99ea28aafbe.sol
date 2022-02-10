['pragma solidity ^0.5.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '/**\n', '    @title ERC-1155 Multi Token Standard\n', '    @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md\n', '    Note: The ERC-165 identifier for this interface is 0xd9b67a26.\n', ' */\n', 'contract IERC1155 is IERC165 {\n', '    /**\n', '        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).\n', '        The `_operator` argument MUST be msg.sender.\n', '        The `_from` argument MUST be the address of the holder whose balance is decreased.\n', '        The `_to` argument MUST be the address of the recipient whose balance is increased.\n', '        The `_id` argument MUST be the token type being transferred.\n', '        The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.\n', '        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).\n', '        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).\n', '    */\n', '    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);\n', '\n', '    /**\n', '        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).\n', '        The `_operator` argument MUST be msg.sender.\n', '        The `_from` argument MUST be the address of the holder whose balance is decreased.\n', '        The `_to` argument MUST be the address of the recipient whose balance is increased.\n', '        The `_ids` argument MUST be the list of tokens being transferred.\n', '        The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.\n', '        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).\n', '        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).\n', '    */\n', '    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);\n', '\n', '    /**\n', '        @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).\n', '    */\n', '    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);\n', '\n', '    /**\n', '        @dev MUST emit when the URI is updated for a token ID.\n', '        URIs are defined in RFC 3986.\n', '        The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".\n', '    */\n', '    event URI(string _value, uint256 indexed _id);\n', '\n', '    /**\n', '        @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).\n', '        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).\n', '        MUST revert if `_to` is the zero address.\n', '        MUST revert if balance of holder for token `_id` is lower than the `_value` sent.\n', '        MUST revert on any other error.\n', '        MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).\n', '        After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '        @param _from    Source address\n', '        @param _to      Target address\n', '        @param _id      ID of the token type\n', '        @param _value   Transfer amount\n', '        @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`\n', '    */\n', '    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;\n', '\n', '    /**\n', '        @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).\n', '        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).\n', '        MUST revert if `_to` is the zero address.\n', '        MUST revert if length of `_ids` is not the same as length of `_values`.\n', '        MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.\n', '        MUST revert on any other error.\n', '        MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).\n', '        Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).\n', '        After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '        @param _from    Source address\n', '        @param _to      Target address\n', '        @param _ids     IDs of each token type (order and length must match _values array)\n', '        @param _values  Transfer amounts per token type (order and length must match _ids array)\n', '        @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`\n', '    */\n', '    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;\n', '\n', '    /**\n', "        @notice Get the balance of an account's Tokens.\n", '        @param _owner  The address of the token holder\n', '        @param _id     ID of the Token\n', "        @return        The _owner's balance of the Token type requested\n", '     */\n', '    function balanceOf(address _owner, uint256 _id) external view returns (uint256);\n', '\n', '    /**\n', '        @notice Get the balance of multiple account/token pairs\n', '        @param _owners The addresses of the token holders\n', '        @param _ids    ID of the Tokens\n', "        @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)\n", '     */\n', '    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', '        @notice Enable or disable approval for a third party ("operator") to manage all of the caller\'s tokens.\n', '        @dev MUST emit the ApprovalForAll event on success.\n', '        @param _operator  Address to add to the set of authorized operators\n', '        @param _approved  True if the operator is approved, false to revoke approval\n', '    */\n', '    function setApprovalForAll(address _operator, bool _approved) external;\n', '\n', '    /**\n', '        @notice Queries the approval status of an operator for a given owner.\n', '        @param _owner     The owner of the Tokens\n', '        @param _operator  Address of authorized operator\n', '        @return           True if the operator is approved, false if not\n', '    */\n', '    function isApprovedForAll(address _owner, address _operator) external view returns (bool);\n', '}\n', '\n', 'library UintLibrary {\n', '    function toString(uint256 _i) internal pure returns (string memory) {\n', '        if (_i == 0) {\n', '            return "0";\n', '        }\n', '        uint j = _i;\n', '        uint len;\n', '        while (j != 0) {\n', '            len++;\n', '            j /= 10;\n', '        }\n', '        bytes memory bstr = new bytes(len);\n', '        uint k = len - 1;\n', '        while (_i != 0) {\n', '            bstr[k--] = byte(uint8(48 + _i % 10));\n', '            _i /= 10;\n', '        }\n', '        return string(bstr);\n', '    }\n', '}\n', '\n', 'library StringLibrary {\n', '    using UintLibrary for uint256;\n', '\n', '    function append(string memory _a, string memory _b) internal pure returns (string memory) {\n', '        bytes memory _ba = bytes(_a);\n', '        bytes memory _bb = bytes(_b);\n', '        bytes memory bab = new bytes(_ba.length + _bb.length);\n', '        uint k = 0;\n', '        for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];\n', '        for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];\n', '        return string(bab);\n', '    }\n', '\n', '    function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {\n', '        bytes memory _ba = bytes(_a);\n', '        bytes memory _bb = bytes(_b);\n', '        bytes memory _bc = bytes(_c);\n', '        bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);\n', '        uint k = 0;\n', '        for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];\n', '        for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];\n', '        for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];\n', '        return string(bbb);\n', '    }\n', '\n', '    function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {\n', '        bytes memory msgBytes = bytes(message);\n', '        bytes memory fullMessage = concat(\n', '            bytes("\\x19Ethereum Signed Message:\\n"),\n', '            bytes(msgBytes.length.toString()),\n', '            msgBytes,\n', '            new bytes(0), new bytes(0), new bytes(0), new bytes(0)\n', '        );\n', '        return ecrecover(keccak256(fullMessage), v, r, s);\n', '    }\n', '\n', '    function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {\n', '        bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);\n', '        uint k = 0;\n', '        for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];\n', '        for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];\n', '        for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];\n', '        for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];\n', '        for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];\n', '        for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];\n', '        for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];\n', '        return resultBytes;\n', '    }\n', '}\n', '\n', 'library AddressLibrary {\n', '    function toString(address _addr) internal pure returns (string memory) {\n', '        bytes32 value = bytes32(uint256(_addr));\n', '        bytes memory alphabet = "0123456789abcdef";\n', '        bytes memory str = new bytes(42);\n', "        str[0] = '0';\n", "        str[1] = 'x';\n", '        for (uint256 i = 0; i < 20; i++) {\n', '            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];\n', '            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];\n', '        }\n', '        return string(str);\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts may inherit from this and call {_registerInterface} to declare\n', ' * their support of an interface.\n', ' */\n', 'contract ERC165 is IERC165 {\n', '    /*\n', "     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7\n", '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    /**\n', "     * @dev Mapping of interface ids to whether or not it's supported.\n", '     */\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () internal {\n', '        // Derived contracts need only register support for their own interfaces,\n', '        // we register support for ERC165 itself here\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     *\n', '     * Time complexity O(1), guaranteed to always use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    /**\n', '     * @dev Registers the contract as an implementer of the interface defined by\n', '     * `interfaceId`. Support of the actual ERC165 interface is automatic and\n', '     * registering its interface id is not required.\n', '     *\n', '     * See {IERC165-supportsInterface}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).\n', '     */\n', '    function _registerInterface(bytes4 interfaceId) internal {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', '\n', 'contract HasSecondarySaleFees is ERC165 {\n', '\n', '    event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);\n', '\n', '    /*\n', "     * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f\n", "     * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb\n", '     *\n', '     * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584\n', '     */\n', '    bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;\n', '\n', '    constructor() public {\n', '        _registerInterface(_INTERFACE_ID_FEES);\n', '    }\n', '\n', '    function getFeeRecipients(uint256 id) public view returns (address payable[] memory);\n', '    function getFeeBps(uint256 id) public view returns (uint[] memory);\n', '}\n', '\n', 'contract AbstractSale is Ownable {\n', '    using UintLibrary for uint256;\n', '    using AddressLibrary for address;\n', '    using StringLibrary for string;\n', '    using SafeMath for uint256;\n', '\n', '    bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;\n', '\n', '    uint public buyerFee = 0;\n', '    address payable public beneficiary;\n', '\n', '    /* An ECDSA signature. */\n', '    struct Sig {\n', '        /* v parameter */\n', '        uint8 v;\n', '        /* r parameter */\n', '        bytes32 r;\n', '        /* s parameter */\n', '        bytes32 s;\n', '    }\n', '\n', '    constructor(address payable _beneficiary) public {\n', '        beneficiary = _beneficiary;\n', '    }\n', '\n', '    function setBuyerFee(uint256 _buyerFee) public onlyOwner {\n', '        buyerFee = _buyerFee;\n', '    }\n', '\n', '    function setBeneficiary(address payable _beneficiary) public onlyOwner {\n', '        beneficiary = _beneficiary;\n', '    }\n', '\n', '    function prepareMessage(address token, uint256 tokenId, uint256 price, uint256 fee, uint256 nonce) internal pure returns (string memory) {\n', '        string memory result = string(strConcat(\n', '                bytes(token.toString()),\n', '                bytes(". tokenId: "),\n', '                bytes(tokenId.toString()),\n', '                bytes(". price: "),\n', '                bytes(price.toString()),\n', '                bytes(". nonce: "),\n', '                bytes(nonce.toString())\n', '            ));\n', '        if (fee != 0) {\n', '            return result.append(". fee: ", fee.toString());\n', '        } else {\n', '            return result;\n', '        }\n', '    }\n', '\n', '    function strConcat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {\n', '        bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);\n', '        uint k = 0;\n', '        for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];\n', '        for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];\n', '        for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];\n', '        for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];\n', '        for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];\n', '        for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];\n', '        for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];\n', '        return resultBytes;\n', '    }\n', '\n', '    function transferEther(IERC165 token, uint256 tokenId, address payable owner, uint256 total, uint256 sellerFee) internal {\n', '        uint value = transferFeeToBeneficiary(total, sellerFee);\n', '        if (token.supportsInterface(_INTERFACE_ID_FEES)) {\n', '            HasSecondarySaleFees withFees = HasSecondarySaleFees(address(token));\n', '            address payable[] memory recipients = withFees.getFeeRecipients(tokenId);\n', '            uint[] memory fees = withFees.getFeeBps(tokenId);\n', '            require(fees.length == recipients.length);\n', '            for (uint256 i = 0; i < fees.length; i++) {\n', '                (uint newValue, uint current) = subFee(value, total.mul(fees[i]).div(10000));\n', '                value = newValue;\n', '                recipients[i].transfer(current);\n', '            }\n', '        }\n', '        owner.transfer(value);\n', '    }\n', '\n', '    function transferFeeToBeneficiary(uint total, uint sellerFee) internal returns (uint) {\n', '        (uint value, uint sellerFeeValue) = subFee(total, total.mul(sellerFee).div(10000));\n', '        uint buyerFeeValue = total.mul(buyerFee).div(10000);\n', '        uint beneficiaryFee = buyerFeeValue.add(sellerFeeValue);\n', '        if (beneficiaryFee > 0) {\n', '            beneficiary.transfer(beneficiaryFee);\n', '        }\n', '        return value;\n', '    }\n', '\n', '    function subFee(uint value, uint fee) internal pure returns (uint newValue, uint realFee) {\n', '        if (value > fee) {\n', '            newValue = value - fee;\n', '            realFee = fee;\n', '        } else {\n', '            newValue = 0;\n', '            realFee = value;\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'contract IERC721 is IERC165 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of NFTs in `owner`'s account.\n", '     */\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the NFT specified by `tokenId`.\n', '     */\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    /**\n', '     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     *\n', '     *\n', '     * Requirements:\n', '     * - `from`, `to` cannot be zero.\n', '     * - `tokenId` must be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this\n', '     * NFT by either {approve} or {setApprovalForAll}.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '    /**\n', '     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Requirements:\n', '     * - If the caller is not `from`, it must be approved to move this NFT by\n', '     * either {approve} or {setApprovalForAll}.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev Give an account access to this role.\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(!has(role, account), "Roles: account already has role");\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev Remove an account's access to this role.\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(has(role, account), "Roles: account does not have role");\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Check if an account has this role.\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0), "Roles: account is the zero address");\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', 'contract OperatorRole is Context {\n', '    using Roles for Roles.Role;\n', '\n', '    event OperatorAdded(address indexed account);\n', '    event OperatorRemoved(address indexed account);\n', '\n', '    Roles.Role private _operators;\n', '\n', '    constructor () internal {\n', '\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(isOperator(_msgSender()), "OperatorRole: caller does not have the Operator role");\n', '        _;\n', '    }\n', '\n', '    function isOperator(address account) public view returns (bool) {\n', '        return _operators.has(account);\n', '    }\n', '\n', '    function _addOperator(address account) internal {\n', '        _operators.add(account);\n', '        emit OperatorAdded(account);\n', '    }\n', '\n', '    function _removeOperator(address account) internal {\n', '        _operators.remove(account);\n', '        emit OperatorRemoved(account);\n', '    }\n', '}\n', '\n', 'contract OwnableOperatorRole is Ownable, OperatorRole {\n', '    function addOperator(address account) public onlyOwner {\n', '        _addOperator(account);\n', '    }\n', '\n', '    function removeOperator(address account) public onlyOwner {\n', '        _removeOperator(account);\n', '    }\n', '}\n', '\n', 'contract TransferProxy is OwnableOperatorRole {\n', '\n', '    function erc721safeTransferFrom(IERC721 token, address from, address to, uint256 tokenId) external onlyOperator {\n', '        token.safeTransferFrom(from, to, tokenId);\n', '    }\n', '\n', '    function erc1155safeTransferFrom(IERC1155 token, address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external onlyOperator {\n', '        token.safeTransferFrom(_from, _to, _id, _value, _data);\n', '    }\n', '}\n', '\n', 'contract ERC1155SaleNonceHolder is OwnableOperatorRole {\n', '    // keccak256(token, owner, tokenId) => nonce\n', '    mapping(bytes32 => uint256) public nonces;\n', '\n', '    // keccak256(token, owner, tokenId, nonce) => completed amount\n', '    mapping(bytes32 => uint256) public completed;\n', '\n', '    function getNonce(address token, uint256 tokenId, address owner) view public returns (uint256) {\n', '        return nonces[getNonceKey(token, tokenId, owner)];\n', '    }\n', '\n', '    function setNonce(address token, uint256 tokenId, address owner, uint256 nonce) public onlyOperator {\n', '        nonces[getNonceKey(token, tokenId, owner)] = nonce;\n', '    }\n', '\n', '    function getNonceKey(address token, uint256 tokenId, address owner) pure public returns (bytes32) {\n', '        return keccak256(abi.encodePacked(token, tokenId, owner));\n', '    }\n', '\n', '    function getCompleted(address token, uint256 tokenId, address owner, uint256 nonce) view public returns (uint256) {\n', '        return completed[getCompletedKey(token, tokenId, owner, nonce)];\n', '    }\n', '\n', '    function setCompleted(address token, uint256 tokenId, address owner, uint256 nonce, uint256 _completed) public onlyOperator {\n', '        completed[getCompletedKey(token, tokenId, owner, nonce)] = _completed;\n', '    }\n', '\n', '    function getCompletedKey(address token, uint256 tokenId, address owner, uint256 nonce) pure public returns (bytes32) {\n', '        return keccak256(abi.encodePacked(token, tokenId, owner, nonce));\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract ERC1155Sale is Ownable, AbstractSale {\n', '    using StringLibrary for string;\n', '\n', '    event CloseOrder(address indexed token, uint256 indexed tokenId, address owner, uint256 nonce);\n', '    event Buy(address indexed token, uint256 indexed tokenId, address owner, uint256 price, address buyer, uint256 value);\n', '\n', '    bytes constant EMPTY = "";\n', '\n', '    TransferProxy public transferProxy;\n', '    ERC1155SaleNonceHolder public nonceHolder;\n', '\n', '    constructor(TransferProxy _transferProxy, ERC1155SaleNonceHolder _nonceHolder, address payable beneficiary) AbstractSale(beneficiary) public {\n', '        transferProxy = _transferProxy;\n', '        nonceHolder = _nonceHolder;\n', '    }\n', '\n', '    function buy(IERC1155 token, uint256 tokenId, address payable owner, uint256 selling, uint256 buying, uint256 price, uint256 sellerFee, Sig memory signature) public payable {\n', '        uint256 nonce = verifySignature(address(token), tokenId, owner, selling, price, sellerFee, signature);\n', '        uint256 total = price.mul(buying);\n', '        uint256 buyerFeeValue = total.mul(buyerFee).div(10000);\n', '        require(total + buyerFeeValue == msg.value, "msg.value is incorrect");\n', '        bool closed = verifyOpenAndModifyState(address(token), tokenId, owner, nonce, selling, buying);\n', '\n', '        transferProxy.erc1155safeTransferFrom(token, owner, msg.sender, tokenId, buying, EMPTY);\n', '\n', '        transferEther(token, tokenId, owner, total, sellerFee);\n', '        emit Buy(address(token), tokenId, owner, price, msg.sender, buying);\n', '        if (closed) {\n', '            emit CloseOrder(address(token), tokenId, owner, nonce + 1);\n', '        }\n', '    }\n', '\n', '    function cancel(address token, uint256 tokenId) public payable {\n', '        uint nonce = nonceHolder.getNonce(token, tokenId, msg.sender);\n', '        nonceHolder.setNonce(token, tokenId, msg.sender, nonce + 1);\n', '\n', '        emit CloseOrder(token, tokenId, msg.sender, nonce + 1);\n', '    }\n', '\n', '    function verifySignature(address token, uint256 tokenId, address payable owner, uint256 selling, uint256 price, uint256 sellerFee, Sig memory signature) view internal returns (uint256 nonce) {\n', '        nonce = nonceHolder.getNonce(token, tokenId, owner);\n', '        require(prepareMessage(token, tokenId, price, selling, sellerFee, nonce).recover(signature.v, signature.r, signature.s) == owner, "incorrect signature");\n', '    }\n', '\n', '    function verifyOpenAndModifyState(address token, uint256 tokenId, address payable owner, uint256 nonce, uint256 selling, uint256 buying) internal returns (bool) {\n', '        uint comp = nonceHolder.getCompleted(token, tokenId, owner, nonce).add(buying);\n', '        require(comp <= selling);\n', '        nonceHolder.setCompleted(token, tokenId, owner, nonce, comp);\n', '\n', '        if (comp == selling) {\n', '            nonceHolder.setNonce(token, tokenId, owner, nonce + 1);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function prepareMessage(address token, uint256 tokenId, uint256 price, uint256 value, uint256 fee, uint256 nonce) internal pure returns (string memory) {\n', '        return prepareMessage(token, tokenId, price, fee, nonce).append(". value: ", value.toString());\n', '    }\n', '}']