['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-06\n', '*/\n', '\n', '// File: @openzeppelin/contracts/introspection/IERC165.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol\n', '\n', '\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '\n', '/**\n', ' * @dev Required interface of an ERC1155 compliant contract, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-1155[EIP].\n', ' *\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.\n', '     */\n', '    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n', '\n', '    /**\n', '     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all\n', '     * transfers.\n', '     */\n', '    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);\n', '\n', '    /**\n', '     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to\n', '     * `approved`.\n', '     */\n', '    event ApprovalForAll(address indexed account, address indexed operator, bool approved);\n', '\n', '    /**\n', '     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.\n', '     *\n', '     * If an {URI} event was emitted for `id`, the standard\n', '     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value\n', '     * returned by {IERC1155MetadataURI-uri}.\n', '     */\n', '    event URI(string value, uint256 indexed id);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens of token type `id` owned by `account`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     */\n', '    function balanceOf(address account, uint256 id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `accounts` and `ids` must have the same length.\n', '     */\n', '    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', "     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,\n", '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `operator` cannot be the caller.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) external;\n', '\n', '    /**\n', "     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.\n", '     *\n', '     * See {setApprovalForAll}.\n', '     */\n', '    function isApprovedForAll(address account, address operator) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.\n', '     *\n', '     * Emits a {TransferSingle} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', "     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.\n", '     * - `from` must have a balance of tokens of type `id` of at least `amount`.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.\n', '     *\n', '     * Emits a {TransferBatch} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `ids` and `amounts` must have the same length.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol\n', '\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '\n', '/**\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155Receiver is IERC165 {\n', '\n', '    /**\n', '        @dev Handles the receipt of a single ERC1155 token type. This function is\n', '        called at the end of a `safeTransferFrom` after the balance has been updated.\n', '        To accept the transfer, this must return\n', '        `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`\n', '        (i.e. 0xf23a6e61, or its own function selector).\n', '        @param operator The address which initiated the transfer (i.e. msg.sender)\n', '        @param from The address which previously owned the token\n', '        @param id The ID of the token being transferred\n', '        @param value The amount of tokens being transferred\n', '        @param data Additional data with no specified format\n', '        @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed\n', '    */\n', '    function onERC1155Received(\n', '        address operator,\n', '        address from,\n', '        uint256 id,\n', '        uint256 value,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '\n', '    /**\n', '        @dev Handles the receipt of a multiple ERC1155 token types. This function\n', '        is called at the end of a `safeBatchTransferFrom` after the balances have\n', '        been updated. To accept the transfer(s), this must return\n', '        `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`\n', '        (i.e. 0xbc197c81, or its own function selector).\n', '        @param operator The address which initiated the batch transfer (i.e. msg.sender)\n', '        @param from The address which previously owned the token\n', '        @param ids An array containing ids of each token being transferred (order and length must match values array)\n', '        @param values An array containing amounts of each token being transferred (order and length must match ids array)\n', '        @param data Additional data with no specified format\n', '        @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed\n', '    */\n', '    function onERC1155BatchReceived(\n', '        address operator,\n', '        address from,\n', '        uint256[] calldata ids,\n', '        uint256[] calldata values,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '}\n', '\n', '// File: @openzeppelin/contracts/introspection/ERC165.sol\n', '\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts may inherit from this and call {_registerInterface} to declare\n', ' * their support of an interface.\n', ' */\n', 'abstract contract ERC165 is IERC165 {\n', '    /*\n', "     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7\n", '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    /**\n', "     * @dev Mapping of interface ids to whether or not it's supported.\n", '     */\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () internal {\n', '        // Derived contracts need only register support for their own interfaces,\n', '        // we register support for ERC165 itself here\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     *\n', '     * Time complexity O(1), guaranteed to always use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    /**\n', '     * @dev Registers the contract as an implementer of the interface defined by\n', '     * `interfaceId`. Support of the actual ERC165 interface is automatic and\n', '     * registering its interface id is not required.\n', '     *\n', '     * See {IERC165-supportsInterface}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).\n', '     */\n', '    function _registerInterface(bytes4 interfaceId) internal virtual {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol\n', '\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '\n', '\n', '/**\n', ' * @dev _Available since v3.1._\n', ' */\n', 'abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {\n', '    constructor() internal {\n', '        _registerInterface(\n', '            ERC1155Receiver(address(0)).onERC1155Received.selector ^\n', '            ERC1155Receiver(address(0)).onERC1155BatchReceived.selector\n', '        );\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/interfaces/IGenMarketFactory.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IGenMarketFactory {\n', '    event MarketCreated(address indexed caller, address indexed genMarket);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeDivisor() external view returns (uint256);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getGenMarket(address) external view returns (uint);\n', '    function ticketToMarket(address) external view returns (address);\n', '    function genMarkets(uint) external view returns (address);\n', '    function genMarketsLength() external view returns (uint);\n', '\n', '    function createGenMarket(\n', '        address _genTicket,\n', '        // Prices are in ETH\n', '        uint256[] memory _prices,\n', '        // Number of each ticket type being sold\n', '        uint256[] memory _numTickets,\n', '        uint256[] memory _purchaseLimits\n', '    ) external returns (address);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '    function setFeeDivisor(uint256) external;\n', '}\n', '\n', '// File: contracts/GenMarket.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', '\n', '\n', 'contract GenMarket is ERC1155Receiver {\n', '    using SafeMath for uint;\n', '\n', '    address public genTicket;\n', '\n', '    uint256[] public prices;\n', '    uint256[] public numTickets;\n', '    uint256[] public purchaseLimits;\n', '    IGenMarketFactory public factory;\n', '    address public creator;\n', '    bool public active = false;\n', '    mapping(uint256 => mapping(address => bool)) public whitelist;\n', '    mapping(uint256 => mapping(address => uint256)) public purchases;\n', '    mapping(uint256 => uint256) public ticketsPurchased;\n', '    // Expected start time, start at max uint256\n', '    uint public startTime = type(uint).max;\n', '\n', "    bytes private constant VALIDATOR = bytes('JC');\n", '    \n', '    constructor (\n', '        address _genTicket,\n', '        uint256[] memory _prices,\n', '        uint256[] memory _numTickets,\n', '        uint256[] memory _purchaseLimits,\n', '        IGenMarketFactory _factory,\n', '        address _creator\n', '    ) \n', '        public \n', '    {\n', '        genTicket = _genTicket;\n', '        prices = _prices;\n', '        numTickets = _numTickets;\n', '        purchaseLimits = _purchaseLimits;\n', '        factory = _factory;\n', '        creator = _creator;\n', '    }\n', '\n', '    function ticketTypes() external view returns (uint) {\n', '        return numTickets.length;\n', '    }\n', '\n', '    function updateStartTime(uint timestamp) external {\n', '        require(msg.sender == creator, "GenMarket: Only creator can update start time");\n', '        require(getBlockTimestamp() < startTime, "GenMarket: Start time already occurred");\n', '        require(getBlockTimestamp() < timestamp, "GenMarket: New start time must be in the future");\n', '\n', '        startTime = timestamp;\n', '    }\n', '\n', '    function setWhiteList(uint256 id, address[] memory addresses, bool whiteListOn) external {\n', '        require(msg.sender == creator, "GenMarket: Only creator can update whitelist");\n', '        require(addresses.length < 200, "GenMarket: Whitelist less than 200 at a time");\n', '\n', '        for (uint8 i=0; i<200; i++) {\n', '            if (i == addresses.length) {\n', '                break;\n', '            }\n', '\n', '            whitelist[id][addresses[i]] = whiteListOn;\n', '        }\n', '    }\n', '\n', '    function deposit() external {\n', '        require(msg.sender == creator, "GenMarket: Only the creator can deposit the tickets");\n', '        require(!active, "GenMarket: Market is already active");\n', '\n', '        uint256[] memory tokenIDs = new uint256[](numTickets.length);\n', '        for (uint8 i = 0; i < numTickets.length; i++)\n', '            tokenIDs[i] = i;\n', '\n', '        IERC1155(genTicket).safeBatchTransferFrom(msg.sender, address(this), tokenIDs, numTickets, VALIDATOR);\n', '\n', '        active = true;\n', '    }\n', '\n', '    function buy(uint256 _id, uint256 _amount) external payable {\n', '        require(active, "GenMarket: Market is not active");\n', '        require(getBlockTimestamp() >= startTime, "GenMarket: Start time must pass");\n', '        require(whitelist[_id][msg.sender], "GenMarket: User not on whitelist");\n', '        require(purchases[_id][msg.sender].add(_amount) <= purchaseLimits[_id], "GenMarket: User will exceed purchase limit");\n', '        require(ticketsPurchased[_id].add(_amount) <= numTickets[_id], "GenMarket: Not enough tickets remaining");\n', '        require(prices[_id].mul(_amount) <= msg.value, "GenMarket: Insufficient payment");\n', '\n', '        purchases[_id][msg.sender] = purchases[_id][msg.sender].add(_amount);\n', '        ticketsPurchased[_id] = ticketsPurchased[_id].add(_amount);\n', '\n', '        if (factory.feeTo() != address(0)) {\n', '            // Send fees to fee address\n', '            (bool sent, bytes memory data) = factory.feeTo().call{value: msg.value.div(factory.feeDivisor())}("");\n', '            require(sent, "GenMarket: Failed to send Ether");\n', '        }\n', '        \n', '        bytes memory data;\n', '        IERC1155(genTicket).safeTransferFrom(address(this), msg.sender, _id, _amount, data);\n', '    }\n', '\n', '    function claim() external {\n', '        require(msg.sender == creator, "GenMarket: Only the creator can claim");\n', '\n', '        (bool sent, bytes memory data) = msg.sender.call{value: address(this).balance}("");\n', '        require(sent, "GenMarket: Failed to send Ether");\n', '    }\n', '\n', '    function getBlockTimestamp() internal view returns (uint) {\n', '        // solium-disable-next-line security/no-block-members\n', '        return block.timestamp;\n', '    }\n', '\n', '    /**\n', '     * ERC1155 Token ERC1155Receiver\n', '     */\n', '    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) override external returns(bytes4) {\n', '        if(keccak256(_data) == keccak256(VALIDATOR)){\n', '            return 0xf23a6e61;\n', '        }\n', '    }\n', '\n', '    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) override external returns(bytes4) {\n', '        if(keccak256(_data) == keccak256(VALIDATOR)){\n', '            return 0xbc197c81;\n', '        }\n', '    }\n', '}']