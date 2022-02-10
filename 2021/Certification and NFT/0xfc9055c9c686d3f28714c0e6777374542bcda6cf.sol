['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-28\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/introspection/IERC165.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/introspection/ERC165.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check\n', ' * for the additional interface id that will be supported. For example:\n', ' *\n', ' * ```solidity\n', ' * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', ' *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);\n', ' * }\n', ' * ```\n', ' *\n', ' * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.\n', ' */\n', 'abstract contract ERC165 is IERC165 {\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        return interfaceId == type(IERC165).interfaceId;\n', '    }\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/IERC721.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'interface IERC721 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n', '     */\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 indexed tokenId\n', '    );\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed approved,\n', '        uint256 indexed tokenId\n', '    );\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n', '     */\n', '    event ApprovalForAll(\n', '        address indexed owner,\n', '        address indexed operator,\n', '        bool approved\n', '    );\n', '\n', '    /**\n', "     * @dev Returns the number of tokens in ``owner``'s account.\n", '     */\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) external;\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) external;\n', '\n', '    /**\n', '     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n', '     * The approval is cleared when the token is transferred.\n', '     *\n', '     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own the token or be an approved operator.\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Returns the account approved for `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function getApproved(uint256 tokenId)\n', '        external\n', '        view\n', '        returns (address operator);\n', '\n', '    /**\n', '     * @dev Approve or remove `operator` as an operator for the caller.\n', '     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The `operator` cannot be the caller.\n', '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     */\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    /**\n', '     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n', '     *\n', '     * See {setApprovalForAll}\n', '     */\n', '    function isApprovedForAll(address owner, address operator)\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes calldata data\n', '    ) external;\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/Strings.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev String operations.\n', ' */\n', 'library Strings {\n', '    bytes16 private constant alphabet = "0123456789abcdef";\n', '\n', '    /**\n', '     * @dev Converts a `uint256` to its ASCII `string` decimal representation.\n', '     */\n', '    function toString(uint256 value) internal pure returns (string memory) {\n', "        // Inspired by OraclizeAPI's implementation - MIT licence\n", '        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol\n', '\n', '        if (value == 0) {\n', '            return "0";\n', '        }\n', '        uint256 temp = value;\n', '        uint256 digits;\n', '        while (temp != 0) {\n', '            digits++;\n', '            temp /= 10;\n', '        }\n', '        bytes memory buffer = new bytes(digits);\n', '        while (value != 0) {\n', '            digits -= 1;\n', '            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));\n', '            value /= 10;\n', '        }\n', '        return string(buffer);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.\n', '     */\n', '    function toHexString(uint256 value) internal pure returns (string memory) {\n', '        if (value == 0) {\n', '            return "0x00";\n', '        }\n', '        uint256 temp = value;\n', '        uint256 length = 0;\n', '        while (temp != 0) {\n', '            length++;\n', '            temp >>= 8;\n', '        }\n', '        return toHexString(value, length);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.\n', '     */\n', '    function toHexString(uint256 value, uint256 length)\n', '        internal\n', '        pure\n', '        returns (string memory)\n', '    {\n', '        bytes memory buffer = new bytes(2 * length + 2);\n', '        buffer[0] = "0";\n', '        buffer[1] = "x";\n', '        for (uint256 i = 2 * length + 1; i > 1; --i) {\n', '            buffer[i] = alphabet[value & 0xf];\n', '            value >>= 4;\n', '        }\n', '        require(value == 0, "Strings: hex length insufficient");\n', '        return string(buffer);\n', '    }\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/Context.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/extensions/IERC721Enumerable.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension\n', ' * @dev See https://eips.ethereum.org/EIPS/eip-721\n', ' */\n', 'interface IERC721Enumerable is IERC721 {\n', '    /**\n', '     * @dev Returns the total amount of tokens stored by the contract.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.\n', "     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.\n", '     */\n', '    function tokenOfOwnerByIndex(address owner, uint256 index)\n', '        external\n', '        view\n', '        returns (uint256 tokenId);\n', '\n', '    /**\n', '     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.\n', '     * Use along with {totalSupply} to enumerate all tokens.\n', '     */\n', '    function tokenByIndex(uint256 index) external view returns (uint256);\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/extensions/IERC721Metadata.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional metadata extension\n', ' * @dev See https://eips.ethereum.org/EIPS/eip-721\n', ' */\n', 'interface IERC721Metadata is IERC721 {\n', '    /**\n', '     * @dev Returns the token collection name.\n', '     */\n', '    function name() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the token collection symbol.\n', '     */\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.\n', '     */\n', '    function tokenURI(uint256 tokenId) external view returns (string memory);\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/IERC721Receiver.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title ERC721 token receiver interface\n', ' * @dev Interface for any contract that wants to support safeTransfers\n', ' * from ERC721 asset contracts.\n', ' */\n', 'interface IERC721Receiver {\n', '    /**\n', '     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}\n', '     * by `operator` from `from`, this function is called.\n', '     *\n', '     * It must return its Solidity selector to confirm the token transfer.\n', '     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.\n', '     *\n', '     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.\n', '     */\n', '    function onERC721Received(\n', '        address operator,\n', '        address from,\n', '        uint256 tokenId,\n', '        bytes calldata data\n', '    ) external returns (bytes4);\n', '}\n', '\n', '// File: contracts/erc.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {\n', '    using Strings for uint256;\n', '    address public creator;\n', '    address public beloved = 0x26f2867eE0d0A0EdfcFd9d6757DD0D3CaE52794A;\n', '\n', '    string private _name;\n', '\n', '    string private _symbol;\n', '\n', '    mapping(uint256 => address) private _owners;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    constructor(string memory name_, string memory symbol_) {\n', '        creator = msg.sender;\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '        mint(beloved, 520);\n', '        mint(beloved, 223);\n', '        mint(beloved, 1013);\n', '    }\n', '\n', '    function supportsInterface(bytes4 interfaceId)\n', '        public\n', '        view\n', '        virtual\n', '        override(ERC165, IERC165)\n', '        returns (bool)\n', '    {\n', '        return\n', '            interfaceId == type(IERC721).interfaceId ||\n', '            interfaceId == type(IERC721Metadata).interfaceId ||\n', '            super.supportsInterface(interfaceId);\n', '    }\n', '\n', '    function balanceOf(address owner)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint256)\n', '    {\n', '        return _balances[owner];\n', '    }\n', '\n', '    function ownerOf(uint256 tokenId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (address)\n', '    {\n', '        return _owners[tokenId];\n', '    }\n', '\n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function tokenURI(uint256 tokenId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (string memory)\n', '    {\n', '        require(\n', '            _exists(tokenId),\n', '            "ERC721Metadata: URI query for nonexistent token"\n', '        );\n', '\n', '        string memory baseURI = "https://nft.love.zhusun.in/";\n', '        return\n', '            bytes(baseURI).length > 0\n', '                ? string(abi.encodePacked(baseURI, tokenId.toString()))\n', '                : "";\n', '    }\n', '\n', '    function approve(address to, uint256 tokenId) public virtual override {\n', '        require(false, "You can\'t give the token of love to others");\n', '        to;\n', '        tokenId;\n', '    }\n', '\n', '    function getApproved(uint256 tokenId)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (address)\n', '    {\n', '        tokenId;\n', '        return address(0);\n', '    }\n', '\n', '    function setApprovalForAll(address operator, bool approved)\n', '        public\n', '        virtual\n', '        override\n', '    {\n', '        require(false, "You can\'t give the token of love to others");\n', '        operator;\n', '        approved;\n', '    }\n', '\n', '    function isApprovedForAll(address owner, address operator)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        operator;\n', '        owner;\n', '        return false;\n', '    }\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) public virtual override {\n', '        _transfer(from, to, tokenId);\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) public virtual override {\n', '        safeTransferFrom(from, to, tokenId, "");\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes memory _data\n', '    ) public virtual override {\n', '        _data;\n', '        _transfer(from, to, tokenId);\n', '    }\n', '\n', '    function _exists(uint256 tokenId) internal view virtual returns (bool) {\n', '        return _owners[tokenId] != address(0);\n', '    }\n', '\n', '    function mint(address to, uint256 tokenId) public {\n', '        require(msg.sender == creator, "You are not the creator");\n', '        require(to == beloved, "You can only give tokens to your only lover");\n', '        require(!_exists(tokenId), "ERC721: token already minted");\n', '\n', '        _balances[to] += 1;\n', '        _owners[tokenId] = to;\n', '\n', '        emit Transfer(address(0), to, tokenId);\n', '    }\n', '\n', '    function _transfer(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    ) internal virtual {\n', '        from;\n', '        to;\n', '        tokenId;\n', '\n', '        require(false, "You can\'t give the token of love to others");\n', '    }\n', '}']