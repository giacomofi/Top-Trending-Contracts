['// SPDX-License-Identifier: MIT\n', "// Derived from OpenZeppelin's ERC721 implementation, with changes for gas-efficiency.\n", '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";\n', 'import "@openzeppelin/contracts/utils/introspection/ERC165.sol";\n', 'import "@openzeppelin/contracts/utils/Address.sol";\n', 'import "./IAmulet.sol";\n', 'import "./ProxyRegistryWhitelist.sol";\n', '\n', '/**\n', ' * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including\n', ' * the Metadata extension, but not including the Enumerable extension, which is available separately as\n', ' * {ERC721Enumerable}.\n', ' */\n', 'contract Amulet is IAmulet, ERC165, ProxyRegistryWhitelist {\n', '    using Address for address;\n', '\n', '    // Mapping from token ID to token data\n', '    // Values are packed in the form:\n', '    // [score (32 bits)][blockRevealed (64 bits)][owner (160 bits)]\n', '    // This is equivalent to the following Solidity structure,\n', '    // but saves us about 4200 gas on mint, 3600 gas on reveal,\n', '    // and 140 gas on transfer.\n', '    // struct Token {\n', '    //   uint32 score;\n', '    //   uint64 blockRevealed;\n', '    //   address owner;\n', '    // }\n', '    mapping (uint256 => uint256) private _tokens;\n', '\n', '    // Mapping from owner to operator approvals\n', '    mapping (address => mapping (address => bool)) private _operatorApprovals;\n', '\n', '    constructor (address proxyRegistryAddress, MintData[] memory premineMints, MintAndRevealData[] memory premineReveals) ProxyRegistryWhitelist(proxyRegistryAddress) {\n', '        mintAll(premineMints);\n', '        mintAndRevealAll(premineReveals);\n', '    }\n', '\n', '    /**************************************************************************\n', '     * Opensea-specific methods\n', '     *************************************************************************/\n', '\n', '    function contractURI() external pure returns (string memory) {\n', '        return "https://at.amulet.garden/contract.json";\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-name}.\n', '     */\n', '    function name() public view virtual returns (string memory) {\n', '        return "Amulets";\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-symbol}.\n', '     */\n', '    function symbol() public view virtual returns (string memory) {\n', '        return "AMULET";\n', '    }\n', '\n', '    /**************************************************************************\n', '     * ERC721 methods\n', '     *************************************************************************/\n', '\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {\n', '        return interfaceId == type(IERC1155).interfaceId\n', '            || interfaceId == type(IERC1155MetadataURI).interfaceId\n', '            || super.supportsInterface(interfaceId);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC1155Metadata-uri}.\n', '     */\n', '    function uri(uint256 /*tokenId*/) public view virtual override returns (string memory) {\n', '        return "https://at.amulet.garden/token/{id}.json";\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC1155-balanceOf}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     */\n', '    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {\n', '        require(account != address(0), "ERC1155: balance query for the zero address");\n', '        (address owner,,) = getData(id);\n', '        if(owner == account) {\n', '            return 1;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC1155-balanceOfBatch}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `accounts` and `ids` must have the same length.\n', '     */\n', '    function balanceOfBatch(\n', '        address[] memory accounts,\n', '        uint256[] memory ids\n', '    )\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint256[] memory)\n', '    {\n', '        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");\n', '\n', '        uint256[] memory batchBalances = new uint256[](accounts.length);\n', '\n', '        for (uint256 i = 0; i < accounts.length; ++i) {\n', '            batchBalances[i] = balanceOf(accounts[i], ids[i]);\n', '        }\n', '\n', '        return batchBalances;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC1155-setApprovalForAll}.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) public virtual override {\n', '        require(msg.sender != operator, "ERC1155: setting approval status for self");\n', '\n', '        _operatorApprovals[msg.sender][operator] = approved;\n', '        emit ApprovalForAll(msg.sender, operator, approved);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC1155-isApprovedForAll}.\n', '     */\n', '    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {\n', '        return _operatorApprovals[account][operator] || isProxyForOwner(account, operator);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC1155-safeTransferFrom}.\n', '     */\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 id,\n', '        uint256 amount,\n', '        bytes memory data\n', '    )\n', '        public\n', '        virtual\n', '        override\n', '    {\n', '        require(to != address(0), "ERC1155: transfer to the zero address");\n', '        require(\n', '            from == msg.sender || isApprovedForAll(from, msg.sender),\n', '            "ERC1155: caller is not owner nor approved"\n', '        );\n', '\n', '        (address oldOwner, uint64 blockRevealed, uint32 score) = getData(id);\n', '        require(amount == 1 && oldOwner == from, "ERC1155: Insufficient balance for transfer");\n', '        setData(id, to, blockRevealed, score);\n', '\n', '        emit TransferSingle(msg.sender, from, to, id, amount);\n', '\n', '        _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, amount, data);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC1155-safeBatchTransferFrom}.\n', '     */\n', '    function safeBatchTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256[] memory ids,\n', '        uint256[] memory amounts,\n', '        bytes memory data\n', '    )\n', '        public\n', '        virtual\n', '        override\n', '    {\n', '        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");\n', '        require(to != address(0), "ERC1155: transfer to the zero address");\n', '        require(\n', '            from == msg.sender || isApprovedForAll(from, msg.sender),\n', '            "ERC1155: transfer caller is not owner nor approved"\n', '        );\n', '\n', '        for (uint256 i = 0; i < ids.length; ++i) {\n', '            uint256 id = ids[i];\n', '            uint256 amount = amounts[i];\n', '\n', '            (address oldOwner, uint64 blockRevealed, uint32 score) = getData(id);\n', '            require(amount == 1 && oldOwner == from, "ERC1155: insufficient balance for transfer");\n', '            setData(id, to, blockRevealed, score);\n', '        }\n', '\n', '        emit TransferBatch(msg.sender, from, to, ids, amounts);\n', '\n', '        _doSafeBatchTransferAcceptanceCheck(msg.sender, from, to, ids, amounts, data);\n', '    }\n', '\n', '    /**************************************************************************\n', '     * Amulet-specific methods\n', '     *************************************************************************/\n', '\n', '    /**\n', '     * @dev Returns the owner of the token with id `id`.\n', '     */\n', '    function ownerOf(uint256 id) external override view returns(address) {\n', '        (address owner,,) = getData(id);\n', '        return owner;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Returns the score of an amulet.\n', '     *      0-3: Not an amulet\n', '     *      4: common\n', '     *      5: uncommon\n', '     *      6: rare\n', '     *      7: epic\n', '     *      8: legendary\n', '     *      9: mythic\n', '     *      10+: beyond mythic\n', '     */\n', '    function getScore(string memory amulet) public override pure returns(uint32) {\n', '        uint256 hash = uint256(sha256(bytes(amulet)));\n', '        uint maxlen = 0;\n', '        uint len = 0;\n', '        for(;hash > 0; hash >>= 4) {\n', '            if(hash & 0xF == 8) {\n', '                len += 1;\n', '                if(len > maxlen) {\n', '                    maxlen = len;\n', '                }\n', '            } else {\n', '                len = 0;\n', '            }\n', '        }\n', '        return uint32(maxlen);        \n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if an amulet has been revealed.\n', "     *      If this returns false, we cannot be sure the amulet even exists! Don't accept an amulet from someone\n", "     *      if it's not revealed and they won't show you the text of the amulet.\n", '     */\n', '    function isRevealed(uint256 tokenId) external override view returns(bool) {\n', '        (address owner, uint64 blockRevealed,) = getData(tokenId);\n', '        require(owner != address(0), "ERC721: isRevealed query for nonexistent token");\n', '        return blockRevealed > 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Mint a new amulet.\n', '     * @param data The ID and owner for the new token.\n', '     */\n', '    function mint(MintData memory data) public override {\n', '        require(data.owner != address(0), "ERC1155: mint to the zero address");\n', '        require(_tokens[data.tokenId] == 0, "ERC1155: mint of existing token");\n', '\n', '        _tokens[data.tokenId] = uint256(uint160(data.owner));\n', '        emit TransferSingle(msg.sender, address(0), data.owner, data.tokenId, 1);\n', '\n', '        _doSafeTransferAcceptanceCheck(msg.sender, address(0), data.owner, data.tokenId, 1, "");\n', '    }\n', '\n', '    /**\n', '     * @dev Mint new amulets.\n', '     * @param data The IDs and amulets for the new tokens.\n', '     */\n', '    function mintAll(MintData[] memory data) public override {\n', '        for(uint i = 0; i < data.length; i++) {\n', '            mint(data[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Reveals an amulet.\n', '     * @param data The title, text, and offset URL for the amulet.\n', '     */\n', '    function reveal(RevealData calldata data) public override {\n', '        require(bytes(data.amulet).length <= 64, "Amulet: Too long");\n', '        uint256 tokenId = uint256(keccak256(bytes(data.amulet)));\n', '        (address owner, uint64 blockRevealed, uint32 score) = getData(tokenId);\n', '        require(\n', '            owner == msg.sender || isApprovedForAll(owner, msg.sender),\n', '            "Amulet: reveal caller is not owner nor approved"\n', '        );\n', '        require(blockRevealed == 0, "Amulet: Already revealed");\n', '\n', '        score = getScore(data.amulet);\n', '        require(score >= 4, "Amulet: Score too low");\n', '\n', '        setData(tokenId, owner, uint64(block.number), score);\n', '        emit AmuletRevealed(tokenId, msg.sender, data.title, data.amulet, data.offsetURL);\n', '    }\n', '\n', '    /**\n', '     * @dev Reveals multiple amulets\n', '     * @param data The titles, texts, and offset URLs for the amulets.\n', '     */\n', '    function revealAll(RevealData[] calldata data) external override {\n', '        for(uint i = 0; i < data.length; i++) {\n', '            reveal(data[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Mint and reveal an amulet.\n', '     * @param data The title, text, offset URL, and owner for the new amulet.\n', '     */\n', '    function mintAndReveal(MintAndRevealData memory data) public override {\n', '        require(bytes(data.amulet).length <= 64, "Amulet: Too long");\n', '        uint256 tokenId = uint256(keccak256(bytes(data.amulet)));\n', '        (address owner,,) = getData(tokenId);\n', '        require(owner == address(0), "ERC1155: mint of existing token");\n', '        require(data.owner != address(0), "ERC1155: mint to the zero address");\n', '\n', '        uint32 score = getScore(data.amulet);\n', '        require(score >= 4, "Amulet: Score too low");\n', '\n', '        setData(tokenId, data.owner, uint64(block.number), score);\n', '        emit TransferSingle(msg.sender, address(0), data.owner, tokenId, 1);\n', '        emit AmuletRevealed(tokenId, msg.sender, data.title, data.amulet, data.offsetURL);\n', '    }\n', '\n', '    /**\n', '     * @dev Mint and reveal amulets.\n', '     * @param data The titles, texts, offset URLs, and owners for the new amulets.\n', '     */\n', '    function mintAndRevealAll(MintAndRevealData[] memory data) public override {\n', '        for(uint i = 0; i < data.length; i++) {\n', '            mintAndReveal(data[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', "     * @dev Returns the Amulet's owner address, the block it was revealed in, and its score.\n", '     */\n', '    function getData(uint256 tokenId) public override view returns(address owner, uint64 blockRevealed, uint32 score) {\n', '        uint256 t = _tokens[tokenId];\n', '        owner = address(uint160(t));\n', '        blockRevealed = uint64(t >> 160);\n', '        score = uint32(t >> 224);\n', '    }\n', '\n', '    /**\n', "     * @dev Sets the amulet's owner address, reveal block, and score.\n", '     */\n', '    function setData(uint256 tokenId, address owner, uint64 blockRevealed, uint32 score) internal {\n', '        _tokens[tokenId] = uint256(uint160(owner)) | (uint256(blockRevealed) << 160) | (uint256(score) << 224);\n', '    }\n', '\n', '    /**************************************************************************\n', '     * Internal/private methods\n', '     *************************************************************************/\n', '\n', '    function _doSafeTransferAcceptanceCheck(\n', '        address operator,\n', '        address from,\n', '        address to,\n', '        uint256 id,\n', '        uint256 amount,\n', '        bytes memory data\n', '    )\n', '        private\n', '    {\n', '        if (to.isContract()) {\n', '            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {\n', '                if (response != IERC1155Receiver(to).onERC1155Received.selector) {\n', '                    revert("ERC1155: ERC1155Receiver rejected tokens");\n', '                }\n', '            } catch Error(string memory reason) {\n', '                revert(reason);\n', '            } catch {\n', '                revert("ERC1155: transfer to non ERC1155Receiver implementer");\n', '            }\n', '        }\n', '    }\n', '\n', '    function _doSafeBatchTransferAcceptanceCheck(\n', '        address operator,\n', '        address from,\n', '        address to,\n', '        uint256[] memory ids,\n', '        uint256[] memory amounts,\n', '        bytes memory data\n', '    )\n', '        private\n', '    {\n', '        if (to.isContract()) {\n', '            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {\n', '                if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {\n', '                    revert("ERC1155: ERC1155Receiver rejected tokens");\n', '                }\n', '            } catch Error(string memory reason) {\n', '                revert(reason);\n', '            } catch {\n', '                revert("ERC1155: transfer to non ERC1155Receiver implementer");\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../../utils/introspection/IERC165.sol";\n', '\n', '/**\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155Receiver is IERC165 {\n', '\n', '    /**\n', '        @dev Handles the receipt of a single ERC1155 token type. This function is\n', '        called at the end of a `safeTransferFrom` after the balance has been updated.\n', '        To accept the transfer, this must return\n', '        `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`\n', '        (i.e. 0xf23a6e61, or its own function selector).\n', '        @param operator The address which initiated the transfer (i.e. msg.sender)\n', '        @param from The address which previously owned the token\n', '        @param id The ID of the token being transferred\n', '        @param value The amount of tokens being transferred\n', '        @param data Additional data with no specified format\n', '        @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed\n', '    */\n', '    function onERC1155Received(\n', '        address operator,\n', '        address from,\n', '        uint256 id,\n', '        uint256 value,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '\n', '    /**\n', '        @dev Handles the receipt of a multiple ERC1155 token types. This function\n', '        is called at the end of a `safeBatchTransferFrom` after the balances have\n', '        been updated. To accept the transfer(s), this must return\n', '        `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`\n', '        (i.e. 0xbc197c81, or its own function selector).\n', '        @param operator The address which initiated the batch transfer (i.e. msg.sender)\n', '        @param from The address which previously owned the token\n', '        @param ids An array containing ids of each token being transferred (order and length must match values array)\n', '        @param values An array containing amounts of each token being transferred (order and length must match ids array)\n', '        @param data Additional data with no specified format\n', '        @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed\n', '    */\n', '    function onERC1155BatchReceived(\n', '        address operator,\n', '        address from,\n', '        uint256[] calldata ids,\n', '        uint256[] calldata values,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./IERC165.sol";\n', '\n', '/**\n', ' * @dev Implementation of the {IERC165} interface.\n', ' *\n', ' * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check\n', ' * for the additional interface id that will be supported. For example:\n', ' *\n', ' * ```solidity\n', ' * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', ' *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);\n', ' * }\n', ' * ```\n', ' *\n', ' * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.\n', ' */\n', 'abstract contract ERC165 is IERC165 {\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return interfaceId == type(IERC165).interfaceId;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";\n', 'import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";\n', '\n', 'interface IAmulet is IERC1155, IERC1155MetadataURI {\n', '    event AmuletRevealed(uint256 indexed tokenId, address revealedBy, string title, string amulet, string offsetUrl);\n', '\n', '    struct MintData {\n', '        address owner;\n', '        uint256 tokenId;\n', '    }\n', '\n', '    struct RevealData {\n', '        string title;\n', '        string amulet;\n', '        string offsetURL;\n', '    }\n', '\n', '    struct MintAndRevealData {\n', '        string title;\n', '        string amulet;\n', '        string offsetURL;\n', '        address owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the owner of the token with id `id`.\n', '     */\n', '    function ownerOf(uint256 id) external view returns(address);\n', '\n', '    /**\n', '     * @dev Returns the score of an amulet.\n', '     *      0-3: Not an amulet\n', '     *      4: common\n', '     *      5: uncommon\n', '     *      6: rare\n', '     *      7: epic\n', '     *      8: legendary\n', '     *      9: mythic\n', '     *      10+: beyond mythic\n', '     */\n', '    function getScore(string calldata amulet) external pure returns(uint32);\n', '\n', '    /**\n', '     * @dev Returns true if an amulet has been revealed.\n', "     *      If this returns false, we cannot be sure the amulet even exists! Don't accept an amulet from someone\n", "     *      if it's not revealed and they won't show you the text of the amulet.\n", '     */\n', '    function isRevealed(uint256 tokenId) external view returns(bool);\n', '\n', '    /**\n', '     * @dev Mint a new amulet.\n', '     * @param data The ID and owner for the new token.\n', '     */\n', '    function mint(MintData calldata data) external;\n', '\n', '    /**\n', '     * @dev Mint new amulets.\n', '     * @param data The IDs and amulets for the new tokens.\n', '     */\n', '    function mintAll(MintData[] calldata data) external;\n', '\n', '    /**\n', '     * @dev Reveals an amulet.\n', '     * @param data The title, text, and offset URL for the amulet.\n', '     */\n', '    function reveal(RevealData calldata data) external;\n', '\n', '    /**\n', '     * @dev Reveals multiple amulets\n', '     * @param data The titles, texts, and offset URLs for the amulets.\n', '     */\n', '    function revealAll(RevealData[] calldata data) external;\n', '\n', '    /**\n', '     * @dev Mint and reveal an amulet.\n', '     * @param data The title, text, offset URL, and owner for the new amulet.\n', '     */\n', '    function mintAndReveal(MintAndRevealData calldata data) external;\n', '\n', '    /**\n', '     * @dev Mint and reveal amulets.\n', '     * @param data The titles, texts, offset URLs, and owners for the new amulets.\n', '     */\n', '    function mintAndRevealAll(MintAndRevealData[] calldata data) external;\n', '\n', '    /**\n', "     * @dev Returns the Amulet's owner address, the block it was revealed in, and its score.\n", '     */\n', '    function getData(uint256 tokenId) external view returns(address owner, uint64 blockRevealed, uint32 score);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', "// Derived from OpenZeppelin's ERC721 implementation, with changes for gas-efficiency.\n", '\n', 'pragma solidity ^0.8.0;\n', '\n', 'contract ProxyRegistry {\n', '    mapping(address => address) public proxies;\n', '}\n', '\n', 'contract ProxyRegistryWhitelist {\n', '    ProxyRegistry public proxyRegistry;\n', '\n', '    constructor(address proxyRegistryAddress) {\n', '        proxyRegistry = ProxyRegistry(proxyRegistryAddress);\n', '    }\n', '\n', '    function isProxyForOwner(address owner, address caller) internal view returns(bool) {\n', '        if(address(proxyRegistry) == address(0)) {\n', '            return false;\n', '        }\n', '        return proxyRegistry.proxies(owner) == caller;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../../utils/introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC1155 compliant contract, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-1155[EIP].\n', ' *\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.\n', '     */\n', '    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n', '\n', '    /**\n', '     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all\n', '     * transfers.\n', '     */\n', '    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);\n', '\n', '    /**\n', '     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to\n', '     * `approved`.\n', '     */\n', '    event ApprovalForAll(address indexed account, address indexed operator, bool approved);\n', '\n', '    /**\n', '     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.\n', '     *\n', '     * If an {URI} event was emitted for `id`, the standard\n', '     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value\n', '     * returned by {IERC1155MetadataURI-uri}.\n', '     */\n', '    event URI(string value, uint256 indexed id);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens of token type `id` owned by `account`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     */\n', '    function balanceOf(address account, uint256 id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `accounts` and `ids` must have the same length.\n', '     */\n', '    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);\n', '\n', '    /**\n', "     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,\n", '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `operator` cannot be the caller.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) external;\n', '\n', '    /**\n', "     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.\n", '     *\n', '     * See {setApprovalForAll}.\n', '     */\n', '    function isApprovedForAll(address account, address operator) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.\n', '     *\n', '     * Emits a {TransferSingle} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', "     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.\n", '     * - `from` must have a balance of tokens of type `id` of at least `amount`.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;\n', '\n', '    /**\n', '     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.\n', '     *\n', '     * Emits a {TransferBatch} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `ids` and `amounts` must have the same length.\n', '     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the\n', '     * acceptance magic value.\n', '     */\n', '    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../IERC1155.sol";\n', '\n', '/**\n', ' * @dev Interface of the optional ERC1155MetadataExtension interface, as defined\n', ' * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].\n', ' *\n', ' * _Available since v3.1._\n', ' */\n', 'interface IERC1155MetadataURI is IERC1155 {\n', '    /**\n', '     * @dev Returns the URI for token type `id`.\n', '     *\n', '     * If the `\\{id\\}` substring is present in the URI, it must be replaced by\n', '     * clients with the actual token type ID.\n', '     */\n', '    function uri(uint256 id) external view returns (string memory);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 10000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']