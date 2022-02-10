['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/// @author: manifold.xyz\n', '\n', 'import "./core/IERC721CreatorCore.sol";\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', '\n', '/**\n', ' * resolver.addr\n', ' */\n', 'contract resolver is Ownable {\n', '    \n', '    address private _creator;\n', '    uint256 private _minted;\n', '\n', '    constructor(address creator) {\n', '        _creator = creator;\n', '    }\n', '\n', '    function setBaseTokenURI(string calldata uri, bool identical) external onlyOwner {\n', '        IERC721CreatorCore(_creator).setBaseTokenURIExtension(uri, identical);\n', '    }\n', '\n', '    function setTokenURI(uint256[] calldata tokenIds, string[] calldata uris) external onlyOwner {\n', '        IERC721CreatorCore(_creator).setTokenURIExtension(tokenIds, uris);\n', '    }    \n', '\n', '    function setTokenURIPrefix(string calldata prefix) external onlyOwner {\n', '        IERC721CreatorCore(_creator).setTokenURIPrefixExtension(prefix);\n', '    }\n', '\n', '    function resolve(address[] calldata receivers, string[] calldata hashes) external onlyOwner {\n', '        require(receivers.length == hashes.length, "Invalid input");\n', '        require(_minted+receivers.length <= 100, "Only 100 available");\n', '        for (uint i = 0; i < receivers.length; i++) {\n', '            IERC721CreatorCore(_creator).mintExtension(receivers[i], hashes[i]);\n', '        }\n', '        _minted += receivers.length;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/// @author: manifold.xyz\n', '\n', 'import "./ICreatorCore.sol";\n', '\n', '/**\n', ' * @dev Core ERC721 creator interface\n', ' */\n', 'interface IERC721CreatorCore is ICreatorCore {\n', '\n', '    /**\n', '     * @dev mint a token with no extension. Can only be called by an admin.\n', '     * Returns tokenId minted\n', '     */\n', '    function mintBase(address to) external returns (uint256);\n', '\n', '    /**\n', '     * @dev mint a token with no extension. Can only be called by an admin.\n', '     * Returns tokenId minted\n', '     */\n', '    function mintBase(address to, string calldata uri) external returns (uint256);\n', '\n', '    /**\n', '     * @dev batch mint a token with no extension. Can only be called by an admin.\n', '     * Returns tokenId minted\n', '     */\n', '    function mintBaseBatch(address to, uint16 count) external returns (uint256[] memory);\n', '\n', '    /**\n', '     * @dev batch mint a token with no extension. Can only be called by an admin.\n', '     * Returns tokenId minted\n', '     */\n', '    function mintBaseBatch(address to, string[] calldata uris) external returns (uint256[] memory);\n', '\n', '    /**\n', '     * @dev mint a token. Can only be called by a registered extension.\n', '     * Returns tokenId minted\n', '     */\n', '    function mintExtension(address to) external returns (uint256);\n', '\n', '    /**\n', '     * @dev mint a token. Can only be called by a registered extension.\n', '     * Returns tokenId minted\n', '     */\n', '    function mintExtension(address to, string calldata uri) external returns (uint256);\n', '\n', '    /**\n', '     * @dev batch mint a token. Can only be called by a registered extension.\n', '     * Returns tokenIds minted\n', '     */\n', '    function mintExtensionBatch(address to, uint16 count) external returns (uint256[] memory);\n', '\n', '    /**\n', '     * @dev batch mint a token. Can only be called by a registered extension.\n', '     * Returns tokenId minted\n', '     */\n', '    function mintExtensionBatch(address to, string[] calldata uris) external returns (uint256[] memory);\n', '\n', '    /**\n', '     * @dev burn a token. Can only be called by token owner or approved address.\n', "     * On burn, calls back to the registered extension's onBurn method\n", '     */\n', '    function burn(uint256 tokenId) external;\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/// @author: manifold.xyz\n', '\n', 'import "@openzeppelin/contracts/utils/introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Core creator interface\n', ' */\n', 'interface ICreatorCore is IERC165 {\n', '\n', '    event ExtensionRegistered(address indexed extension, address indexed sender);\n', '    event ExtensionUnregistered(address indexed extension, address indexed sender);\n', '    event ExtensionBlacklisted(address indexed extension, address indexed sender);\n', '    event MintPermissionsUpdated(address indexed extension, address indexed permissions, address indexed sender);\n', '    event RoyaltiesUpdated(uint256 indexed tokenId, address payable[] receivers, uint256[] basisPoints);\n', '    event DefaultRoyaltiesUpdated(address payable[] receivers, uint256[] basisPoints);\n', '    event ExtensionRoyaltiesUpdated(address indexed extension, address payable[] receivers, uint256[] basisPoints);\n', '    event ExtensionApproveTransferUpdated(address indexed extension, bool enabled);\n', '\n', '    /**\n', '     * @dev gets address of all extensions\n', '     */\n', '    function getExtensions() external view returns (address[] memory);\n', '\n', '    /**\n', '     * @dev add an extension.  Can only be called by contract owner or admin.\n', '     * extension address must point to a contract implementing ICreatorExtension.\n', '     * Returns True if newly added, False if already added.\n', '     */\n', '    function registerExtension(address extension, string calldata baseURI) external;\n', '\n', '    /**\n', '     * @dev add an extension.  Can only be called by contract owner or admin.\n', '     * extension address must point to a contract implementing ICreatorExtension.\n', '     * Returns True if newly added, False if already added.\n', '     */\n', '    function registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) external;\n', '\n', '    /**\n', '     * @dev add an extension.  Can only be called by contract owner or admin.\n', '     * Returns True if removed, False if already removed.\n', '     */\n', '    function unregisterExtension(address extension) external;\n', '\n', '    /**\n', '     * @dev blacklist an extension.  Can only be called by contract owner or admin.\n', '     * This function will destroy all ability to reference the metadata of any tokens created\n', '     * by the specified extension. It will also unregister the extension if needed.\n', '     * Returns True if removed, False if already removed.\n', '     */\n', '    function blacklistExtension(address extension) external;\n', '\n', '    /**\n', '     * @dev set the baseTokenURI of an extension.  Can only be called by extension.\n', '     */\n', '    function setBaseTokenURIExtension(string calldata uri) external;\n', '\n', '    /**\n', '     * @dev set the baseTokenURI of an extension.  Can only be called by extension.\n', '     * For tokens with no uri configured, tokenURI will return "uri+tokenId"\n', '     */\n', '    function setBaseTokenURIExtension(string calldata uri, bool identical) external;\n', '\n', '    /**\n', '     * @dev set the common prefix of an extension.  Can only be called by extension.\n', '     * If configured, and a token has a uri set, tokenURI will return "prefixURI+tokenURI"\n', '     * Useful if you want to use ipfs/arweave\n', '     */\n', '    function setTokenURIPrefixExtension(string calldata prefix) external;\n', '\n', '    /**\n', '     * @dev set the tokenURI of a token extension.  Can only be called by extension that minted token.\n', '     */\n', '    function setTokenURIExtension(uint256 tokenId, string calldata uri) external;\n', '\n', '    /**\n', '     * @dev set the tokenURI of a token extension for multiple tokens.  Can only be called by extension that minted token.\n', '     */\n', '    function setTokenURIExtension(uint256[] memory tokenId, string[] calldata uri) external;\n', '\n', '    /**\n', '     * @dev set the baseTokenURI for tokens with no extension.  Can only be called by owner/admin.\n', '     * For tokens with no uri configured, tokenURI will return "uri+tokenId"\n', '     */\n', '    function setBaseTokenURI(string calldata uri) external;\n', '\n', '    /**\n', '     * @dev set the common prefix for tokens with no extension.  Can only be called by owner/admin.\n', '     * If configured, and a token has a uri set, tokenURI will return "prefixURI+tokenURI"\n', '     * Useful if you want to use ipfs/arweave\n', '     */\n', '    function setTokenURIPrefix(string calldata prefix) external;\n', '\n', '    /**\n', '     * @dev set the tokenURI of a token with no extension.  Can only be called by owner/admin.\n', '     */\n', '    function setTokenURI(uint256 tokenId, string calldata uri) external;\n', '\n', '    /**\n', '     * @dev set the tokenURI of multiple tokens with no extension.  Can only be called by owner/admin.\n', '     */\n', '    function setTokenURI(uint256[] memory tokenIds, string[] calldata uris) external;\n', '\n', '    /**\n', '     * @dev set a permissions contract for an extension.  Used to control minting.\n', '     */\n', '    function setMintPermissions(address extension, address permissions) external;\n', '\n', '    /**\n', '     * @dev Configure so transfers of tokens created by the caller (must be extension) gets approval\n', '     * from the extension before transferring\n', '     */\n', '    function setApproveTransferExtension(bool enabled) external;\n', '\n', '    /**\n', '     * @dev get the extension of a given token\n', '     */\n', '    function tokenExtension(uint256 tokenId) external view returns (address);\n', '\n', '    /**\n', '     * @dev Set default royalties\n', '     */\n', '    function setRoyalties(address payable[] calldata receivers, uint256[] calldata basisPoints) external;\n', '\n', '    /**\n', '     * @dev Set royalties of a token\n', '     */\n', '    function setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) external;\n', '\n', '    /**\n', '     * @dev Set royalties of an extension\n', '     */\n', '    function setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) external;\n', '\n', '    /**\n', '     * @dev Get royalites of a token.  Returns list of receivers and basisPoints\n', '     */\n', '    function getRoyalties(uint256 tokenId) external view returns (address payable[] memory, uint256[] memory);\n', '    \n', '    // Royalty support for various other standards\n', '    function getFeeRecipients(uint256 tokenId) external view returns (address payable[] memory);\n', '    function getFeeBps(uint256 tokenId) external view returns (uint[] memory);\n', '    function getFees(uint256 tokenId) external view returns (address payable[] memory, uint256[] memory);\n', '    function royaltyInfo(uint256 tokenId, uint256 value, bytes calldata data) external view returns (address, uint256, bytes memory);\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 300\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']