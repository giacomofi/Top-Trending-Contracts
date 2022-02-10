['// SPDX-License-Identifier: BUSL-1.1\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./@openzeppelin/contracts/access/Ownable.sol";\n', 'import "./@openzeppelin/contracts/contracts/token/ERC1155/IERC1155.sol";\n', 'import "./IFeeV2.sol";\n', '\n', 'contract FeeFixedV2 is IFeeV2, Ownable {\n', '    uint256 public fee;\n', '\n', '    constructor(uint256 fee_) {\n', '        setFee(fee_);\n', '    }\n', '\n', '    function setFee(uint256 fee_) public onlyOwner {\n', '        fee = fee_;\n', '    }\n', '\n', '    function calculate(address, uint256) public view override returns (uint256) {\n', '        return fee;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../../utils/introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC1155 compliant contract, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-1155[EIP].\n', ' *\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.\n', '     */\n', '    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n', '\n', '    /**\n', '     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all\n', '     * transfers.\n', '     */\n', '    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);\n', '\n', '    /**\n', '     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to\n', '     * `approved`.\n', '     */\n', '    event ApprovalForAll(address indexed account, address indexed operator, bool approved);\n', '\n', '    /**\n', '     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.\n', '     *\n', '     * If an {URI} event was emitted for `id`, the standard\n', '     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value\n', '     * returned by {IERC1155MetadataURI-uri}.\n', '     */\n', '    event URI(string value, uint256 indexed id);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens of token type `id` owned by `account`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     */\n', '    function balanceOf(address account, uint256 id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `accounts` and `ids` must have the same length.\n', '     */\n', '    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', "     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,\n", '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `operator` cannot be the caller.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) external;\n', '\n', '    /**\n', "     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.\n", '     *\n', '     * See {setApprovalForAll}.\n', '     */\n', '    function isApprovedForAll(address account, address operator) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.\n', '     *\n', '     * Emits a {TransferSingle} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', "     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.\n", '     * - `from` must have a balance of tokens of type `id` of at least `amount`.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.\n', '     *\n', '     * Emits a {TransferBatch} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `ids` and `amounts` must have the same length.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: BUSL-1.1\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IFeeV2 {\n', '    function calculate(address sender, uint256 amount) external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']