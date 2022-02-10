['// Sources flattened with buidler v1.4.3 https://buidler.dev\n', '\n', '// File @openzeppelin/contracts/GSN/Context.sol@v3.1.0\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/access/Ownable.sol@v3.1.0\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/utils/Pausable.sol@v3.1.0\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'contract Pausable is Context {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/introspection/IERC165.sol@v3.1.0\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/introspection/ERC165.sol@v3.1.0\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts may inherit from this and call {_registerInterface} to declare\n', ' * their support of an interface.\n', ' */\n', 'contract ERC165 is IERC165 {\n', '    /*\n', "     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7\n", '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    /**\n', "     * @dev Mapping of interface ids to whether or not it's supported.\n", '     */\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () internal {\n', '        // Derived contracts need only register support for their own interfaces,\n', '        // we register support for ERC165 itself here\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     *\n', '     * Time complexity O(1), guaranteed to always use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    /**\n', '     * @dev Registers the contract as an implementer of the interface defined by\n', '     * `interfaceId`. Support of the actual ERC165 interface is automatic and\n', '     * registering its interface id is not required.\n', '     *\n', '     * See {IERC165-supportsInterface}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).\n', '     */\n', '    function _registerInterface(bytes4 interfaceId) internal virtual {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', '\n', '\n', '// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155TokenReceiver.sol@v5.0.0\n', '\n', 'pragma solidity 0.6.8;\n', '\n', '/**\n', ' * @title ERC-1155 Multi Token Standard, token receiver\n', ' * @dev See https://eips.ethereum.org/EIPS/eip-1155\n', ' * Interface for any contract that wants to support transfers from ERC1155 asset contracts.\n', ' * Note: The ERC-165 identifier for this interface is 0x4e2312e0.\n', ' */\n', 'interface IERC1155TokenReceiver {\n', '\n', '    /**\n', '     * @notice Handle the receipt of a single ERC1155 token type.\n', '     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.\n', '     * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.\n', '     * This function MUST revert if it rejects the transfer.\n', '     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.\n', '     * @param operator  The address which initiated the transfer (i.e. msg.sender)\n', '     * @param from      The address which previously owned the token\n', '     * @param id        The ID of the token being transferred\n', '     * @param value     The amount of tokens being transferred\n', '     * @param data      Additional data with no specified format\n', '     * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`\n', '    */\n', '    function onERC1155Received(\n', '        address operator,\n', '        address from,\n', '        uint256 id,\n', '        uint256 value,\n', '        bytes calldata data\n', '    ) external returns (bytes4);\n', '\n', '    /**\n', '     * @notice Handle the receipt of multiple ERC1155 token types.\n', '     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.\n', '     * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).\n', '     * This function MUST revert if it rejects the transfer(s).\n', '     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.\n', '     * @param operator  The address which initiated the batch transfer (i.e. msg.sender)\n', '     * @param from      The address which previously owned the token\n', '     * @param ids       An array containing ids of each token being transferred (order and length must match _values array)\n', '     * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)\n', '     * @param data      Additional data with no specified format\n', '     * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`\n', '    */\n', '    function onERC1155BatchReceived(\n', '        address operator,\n', '        address from,\n', '        uint256[] calldata ids,\n', '        uint256[] calldata values,\n', '        bytes calldata data\n', '    ) external returns (bytes4);\n', '}\n', '\n', '\n', '// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/ERC1155TokenReceiver.sol@v5.0.0\n', '\n', 'pragma solidity 0.6.8;\n', '\n', '\n', '\n', 'abstract contract ERC1155TokenReceiver is IERC1155TokenReceiver, ERC165 {\n', '\n', '    // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))\n', '    bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;\n', '\n', '    // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))\n', '    bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;\n', '\n', '    bytes4 internal constant _ERC1155_REJECTED = 0xffffffff;\n', '\n', '    constructor() internal {\n', '        _registerInterface(type(IERC1155TokenReceiver).interfaceId);\n', '    }\n', '}\n', '\n', '\n', '// File @animoca/f1dt-ethereum-contracts/contracts/token/ERC1155721/NFTRepairCentre.sol@v0.4.0\n', '\n', 'pragma solidity ^0.6.8;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title NFTRepairCentre\n', ' * This contract is used to manage F1 Delta Time defective tokens. Defective tokens are NFTs which were created with an incorrect id.\n', ' * As the core metadata attributes are encoded in the token id, tokens with an incorrect id may not be usable some in ecosystem contracts.\n', ' *\n', ' * This contract has two missions:\n', ' * - Publish a public list of defective tokens (through `repairList`) that ecosystem contracts relying on core metadata attributes can consult as a blacklist,\n', ' * - Let the owners of the defective tokens swap them for replacement tokens. Defective tokens are sent to the `tokensGraveyard` when replaced.\n', ' *\n', ' * The owners of defective tokens who want to use them in these ecosystem contracts will have to repair them first,\n', ' * but will be compensated for their trouble with `revvCompensation` REVVs for each repaired token.\n', ' */\n', 'contract NFTRepairCentre is ERC1155TokenReceiver, Ownable, Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    event TokensToRepairAdded(uint256[] defectiveTokens, uint256[] replacementTokens);\n', '    event RepairedSingle(uint256 defectiveToken, uint256 replacementToken);\n', '    event RepairedBatch(uint256[] defectiveTokens, uint256[] replacementTokens);\n', '\n', '    IDeltaTimeInventory inventoryContract;\n', '    address tokensGraveyard;\n', '    IREVV revvContract;\n', '    uint256 revvCompensation;\n', '\n', '    mapping(uint256 => uint256) repairList;\n', '\n', '    /**\n', '     * Constructor.\n', '     * @dev Reverts if one of the argument addresses is zero.\n', '     * @param inventoryContract_ the address of the DeltaTimeInventoryContract.\n', '     * @param tokensGraveyard_ the address of the tokens graveyard.\n', '     * @param revvContract_ the address of the REVV contract.\n', '     * @param revvCompensation_ the amount of REVV to compensate for each token replacement.\n', '     */\n', '    constructor(\n', '        address inventoryContract_,\n', '        address tokensGraveyard_,\n', '        address revvContract_,\n', '        uint256 revvCompensation_\n', '    ) public {\n', '        require(\n', '            inventoryContract_ != address(0) && tokensGraveyard_ != address(0) && revvContract_ != address(0),\n', '            "RepairCentre: zero address"\n', '        );\n', '        inventoryContract = IDeltaTimeInventory(inventoryContract_);\n', '        tokensGraveyard = tokensGraveyard_;\n', '        revvContract = IREVV(revvContract_);\n', '        revvCompensation = revvCompensation_;\n', '    }\n', '\n', '    /*                                             Public Admin Functions                                             */\n', '\n', '    /**\n', '     * @notice Adds tokens to the repair list and transfers the necessary amount of REVV for the compensations to the contract.\n', '     * @dev Reverts if not called by the owner.\n', '     * @dev Reverts if `defectiveTokens` and `replacementTokens` have inconsistent lengths.\n', '     * @dev Reverts if the REVV transfer fails.\n', '     * @dev Emits a TokensToRepairAdded event.\n', '     * @param defectiveTokens the list of defective tokens.\n', '     * @param replacementTokens the list of replacement tokens.\n', '     */\n', '    function addTokensToRepair(uint256[] calldata defectiveTokens, uint256[] calldata replacementTokens)\n', '        external\n', '        onlyOwner\n', '    {\n', '        uint256 length = defectiveTokens.length;\n', '        require(length != 0 && length == replacementTokens.length, "RepairCentre: wrong lengths");\n', '        for (uint256 i = 0; i < length; ++i) {\n', '            repairList[defectiveTokens[i]] = replacementTokens[i];\n', '        }\n', '        revvContract.transferFrom(msg.sender, address(this), revvCompensation.mul(length));\n', '        emit TokensToRepairAdded(defectiveTokens, replacementTokens);\n', '    }\n', '\n', '    /**\n', '     * Removes this contract as minter for the inventory contract\n', '     * @dev Reverts if the sender is not the contract owner.\n', '     */\n', '    function renounceMinter() external onlyOwner {\n', '        inventoryContract.renounceMinter();\n', '    }\n', '\n', '    /**\n', '     * Pauses the repair operations.\n', '     * @dev Reverts if the sender is not the contract owner.\n', '     * @dev Reverts if the contract is paused already.\n', '     */\n', '    function pause() external onlyOwner {\n', '        _pause();\n', '    }\n', '\n', '    /**\n', '     * Unpauses the repair operations.\n', '     * @dev Reverts if the sender is not the contract owner.\n', '     * @dev Reverts if the contract is not paused.\n', '     */\n', '    function unpause() external onlyOwner {\n', '        _unpause();\n', '    }\n', '\n', '    /*                                             ERC1155TokenReceiver                                             */\n', '\n', '    /**\n', '     * @notice ERC1155 single transfer receiver which repairs a single token and removes it from the repair list.\n', '     * @dev This contract must have been given a minter role for the inventory prior to caslling this function.\n', '     * @dev Reverts if the transfer was not operated through `inventoryContract`.\n', '     * @dev Reverts if `id` is not in the repair list.\n', '     * @dev Reverts if the defective token transfer to the graveyard fails.\n', '     * @dev Reverts if the replacement token minting to the owner fails.\n', '     * @dev Reverts if the REVV compensation transfer fails.\n', '     * @dev Emits an ERC1155 TransferSingle event for the defective token transfer to the graveyard.\n', '     * @dev Emits an ERC1155 TransferSingle event for the replacement token minting to the owner.\n', '     * @dev Emits an ERC20 Transfer event for the REVV compensation transfer.\n', '     * @dev Emits a RepairedSingle event.\n', '     * @param /operator the address which initiated the transfer (i.e. msg.sender).\n', '     * @param from the address which previously owned the token.\n', '     * @param defectiveToken the id of the token to repair.\n', '     * @param /value the amount of tokens being transferred.\n', '     * @param /data additional data with no specified format.\n', '     * @return bytes4 `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`\n', '     */\n', '    function onERC1155Received(\n', '        address, /*operator*/\n', '        address from,\n', '        uint256 defectiveToken,\n', '        uint256, /*value*/\n', '        bytes calldata /*data*/\n', '    ) external virtual override whenNotPaused returns (bytes4) {\n', '        require(msg.sender == address(inventoryContract), "RepairCentre: wrong inventory");\n', '\n', '        uint256 replacementToken = repairList[defectiveToken];\n', '        require(replacementToken != 0, "RepairCentre: token not defective");\n', '        delete repairList[defectiveToken];\n', '\n', '        inventoryContract.safeTransferFrom(address(this), tokensGraveyard, defectiveToken, 1, bytes(""));\n', '\n', '        try inventoryContract.mintNonFungible(from, replacementToken, bytes32(""), true)  {} catch {\n', '            inventoryContract.mintNonFungible(from, replacementToken, bytes32(""), false);\n', '        }\n', '        revvContract.transfer(from, revvCompensation);\n', '\n', '        emit RepairedSingle(defectiveToken, replacementToken);\n', '\n', '        return _ERC1155_RECEIVED;\n', '    }\n', '\n', '    /**\n', '     * @notice ERC1155 batch transfer receiver which repairs a batch of tokens and removes them from the repair list.\n', '     * @dev This contract must have been given a minter role for the inventory prior to caslling this function.\n', '     * @dev Reverts if `ids` is an empty array.\n', '     * @dev Reverts if the transfer was not operated through `inventoryContract`.\n', '     * @dev Reverts if `ids` contains an id not in the repair list.\n', '     * @dev Reverts if the defective tokens transfer to the graveyard fails.\n', '     * @dev Reverts if the replacement tokens minting to the owner fails.\n', '     * @dev Reverts if the REVV compensation transfer fails.\n', '     * @dev Emits an ERC1155 TransferBatch event for the defective tokens transfer to the graveyard.\n', '     * @dev Emits an ERC1155 TransferBatch event for the replacement tokens minting to the owner.\n', '     * @dev Emits an ERC20 Transfer event for the REVV compensation transfer.\n', '     * @dev Emits a RepairedBatch event.\n', '     * @param /operator the address which initiated the batch transfer (i.e. msg.sender).\n', '     * @param from the address which previously owned the token.\n', '     * @param defectiveTokens an array containing the ids of the defective tokens to repair.\n', '     * @param values an array containing amounts of each token being transferred (order and length must match _ids array).\n', '     * @param /data additional data with no specified format.\n', '     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`\n', '     */\n', '    function onERC1155BatchReceived(\n', '        address, /*operator*/\n', '        address from,\n', '        uint256[] calldata defectiveTokens,\n', '        uint256[] calldata values,\n', '        bytes calldata /*data*/\n', '    ) external virtual override whenNotPaused returns (bytes4) {\n', '        require(msg.sender == address(inventoryContract), "RepairCentre: wrong inventory");\n', '\n', '        uint256 length = defectiveTokens.length;\n', '        require(length != 0, "RepairCentre: empty array");\n', '\n', '        address[] memory recipients = new address[](length);\n', '        uint256[] memory replacementTokens = new uint256[](length);\n', '        bytes32[] memory uris = new bytes32[](length);\n', '        for (uint256 i = 0; i < length; ++i) {\n', '            uint256 defectiveToken = defectiveTokens[i];\n', '            uint256 replacementToken = repairList[defectiveToken];\n', '            require(replacementToken != 0, "RepairCentre: token not defective");\n', '            delete repairList[defectiveToken];\n', '            recipients[i] = from;\n', '            replacementTokens[i] = replacementToken;\n', '        }\n', '\n', '        inventoryContract.safeBatchTransferFrom(address(this), tokensGraveyard, defectiveTokens, values, bytes(""));\n', '\n', '        try inventoryContract.batchMint(recipients, replacementTokens, uris, values, true)  {} catch {\n', '            inventoryContract.batchMint(recipients, replacementTokens, uris, values, false);\n', '        }\n', '\n', '        revvContract.transfer(from, revvCompensation.mul(length));\n', '\n', '        emit RepairedBatch(defectiveTokens, replacementTokens);\n', '\n', '        return _ERC1155_BATCH_RECEIVED;\n', '    }\n', '\n', '    /*                                             Other Public Functions                                             */\n', '\n', '    /**\n', '     * @notice Verifies whether a list of tokens contains a defective token.\n', '     * This function can be used by contracts having logic based on NFTs core attributes, in which case the repair list is a blacklist.\n', '     * @param tokens an array containing the token ids to verify.\n', '     * @return true if the array contains a defective token, false otherwise.\n', '     */\n', '    function containsDefectiveToken(uint256[] calldata tokens) external view returns(bool) {\n', '        for (uint256 i = 0; i < tokens.length; ++i) {\n', '            if (repairList[tokens[i]] != 0) {\n', '                return true;\n', '            }\n', '        } \n', '        return false;\n', '    }\n', '}\n', '\n', 'interface IDeltaTimeInventory {\n', '    /**\n', '     * @notice Transfers `value` amount of an `id` from  `from` to `to`  (with safety call).\n', '     * @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).\n', '     * MUST revert if `to` is the zero address.\n', '     * MUST revert if balance of holder for token `id` is lower than the `value` sent.\n', '     * MUST revert on any other error.\n', '     * MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).\n', '     * After the above conditions are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '     * @param from    Source address\n', '     * @param to      Target address\n', '     * @param id      ID of the token type\n', '     * @param value   Transfer amount\n', '     * @param data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`\n', '     */\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 id,\n', '        uint256 value,\n', '        bytes calldata data\n', '    ) external;\n', '\n', '    /**\n', '     * @notice Transfers `values` amount(s) of `ids` from the `from` address to the `to` address specified (with safety call).\n', '     * @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).\n', '     * MUST revert if `to` is the zero address.\n', '     * MUST revert if length of `ids` is not the same as length of `values`.\n', '     * MUST revert if any of the balance(s) of the holder(s) for token(s) in `ids` is lower than the respective amount(s) in `values` sent to the recipient.\n', '     * MUST revert on any other error.\n', '     * MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).\n', '     * Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).\n', '     * After the above conditions for the transfer(s) in the batch are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).\n', '     * @param from    Source address\n', '     * @param to      Target address\n', '     * @param ids     IDs of each token type (order and length must match _values array)\n', '     * @param values  Transfer amounts per token type (order and length must match _ids array)\n', '     * @param data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `to`\n', '     */\n', '    function safeBatchTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256[] calldata ids,\n', '        uint256[] calldata values,\n', '        bytes calldata data\n', '    ) external;\n', '\n', '    /**\n', '     * @dev Public function to mint a batch of new tokens\n', '     * Reverts if some the given token IDs already exist\n', '     * @param to address[] List of addresses that will own the minted tokens\n', '     * @param ids uint256[] List of ids of the tokens to be minted\n', '     * @param uris bytes32[] Concatenated metadata URIs of nfts to be minted\n', '     * @param values uint256[] List of quantities of ft to be minted\n', '     */\n', '    function batchMint(\n', '        address[] calldata to,\n', '        uint256[] calldata ids,\n', '        bytes32[] calldata uris,\n', '        uint256[] calldata values,\n', '        bool safe\n', '    ) external;\n', '\n', '    /**\n', '     * @dev Public function to mint one non fungible token id\n', '     * Reverts if the given token ID is not non fungible token id\n', '     * @param to address recipient that will own the minted tokens\n', '     * @param tokenId uint256 ID of the token to be minted\n', '     * @param byteUri bytes32 Concatenated metadata URI of nft to be minted\n', '     */\n', '    function mintNonFungible(\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes32 byteUri,\n', '        bool safe\n', '    ) external;\n', '\n', '    /**\n', '     * Removes the minter role for the message sender\n', '     */\n', '    function renounceMinter() external;\n', '}\n', '\n', 'interface IREVV {\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '}']