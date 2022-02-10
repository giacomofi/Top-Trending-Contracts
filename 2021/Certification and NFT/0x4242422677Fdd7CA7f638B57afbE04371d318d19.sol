['pragma solidity ^0.8.1;\n', '\n', '//   █████ ██ ██ ██   ██  ███████\n', '//   ██    ██ ██ ██   ██       ██    █   ███ ███ ███   ███ ███ █ ██ ███ ███ ███ ███ ███\n', '//   ██ █████ ██ ██ █████ ██ ████    █   █ █ █ █ █ █   █   █ █ █ ██  █  █ █ █ █ █    █\n', '//   ██    ██ ██      ██  ██         █   █ █ █ █ ███   █   █ █ ██ █  █  ██  ███ █    █\n', '//   ██    ██ ██      ██  ███████    ███ ███ ███ █     ███ ███ █  █  █  █ █ █ █ ███  █\n', '\n', 'import "./Address.sol";\n', 'import "./EnumerableMap.sol";\n', 'import "./EnumerableSet.sol";\n', 'import "./SafeMath.sol";\n', 'import "./Context.sol";\n', 'import "./Ownable.sol";\n', 'import "./Strings.sol";\n', '\n', 'import "./IERC165.sol";\n', 'import "./ERC165Storage.sol";\n', 'import "./IERC721Enumerable.sol";\n', 'import "./IERC721Metadata.sol";\n', 'import "./IERC721Receiver.sol";\n', 'import "./IERC20.sol";\n', 'import "./IDUST.sol";\n', '\n', '/**\n', ' * @dev Loops (a ERC721 non-fungible token)\n', ' */\n', 'contract Loops is Context, Ownable, ERC165Storage, IERC721Enumerable, IERC721Metadata {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '    using EnumerableSet for EnumerableSet.UintSet;\n', '    using EnumerableMap for EnumerableMap.UintToAddressMap;\n', '\n', '    // Public variables\n', '    string  public constant LOOPS_PROOF             = "9a87b113c77c7cdfedbbf644194914432a704073c836f9783a79696b088c62fa";\n', '    uint256 public constant LOOP_SALESTART_TS       = 1617460944; // Sat Apr 03 2021 14:42:24 UTC\n', '    uint256 public constant LOOP_CHANGE_NAME_PRICE  = 1024000000000000000000;\n', '    uint256 public constant LOOP_MINT_REWARD        = 2048000000000000000000;\n', '    uint256 public constant LOOP_DESTROY_REWARD     = 4096000000000000000000;\n', '    uint256 public constant LOOP_MAX_SUPPLY         = 10101;\n', '\n', '    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`\n', '    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;\n', '\n', '    // Mapping from holder address to their (enumerable) set of owned tokens\n', '    mapping (address => EnumerableSet.UintSet) private _holderTokens;\n', '\n', '    // Enumerable mapping from token ids to their owners\n', '    EnumerableMap.UintToAddressMap private _tokenOwners;\n', '\n', '    // Mapping from token ID to approved address\n', '    mapping (uint256 => address) private _tokenApprovals;\n', '\n', '    // Mapping from token ID to name\n', '    mapping (uint256 => string) private _tokenName;\n', '\n', '    // Mapping if certain Loop is currently hidden from public\n', '    mapping (uint256 => bool) private _loopHidden;\n', '\n', '    // Mapping from owner to operator approvals\n', '    mapping (address => mapping (address => bool)) private _operatorApprovals;\n', '\n', '    // Token name\n', '    string private _name;\n', '\n', '    // Token symbol\n', '    string private _symbol;\n', '\n', '    // DUST Token address\n', '    address private _dustAddress;\n', '\n', '    // Number of burned loops\n', '    uint256 private _burnedLoops;\n', '\n', '    /*\n', "     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231\n", "     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e\n", "     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3\n", "     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc\n", "     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465\n", "     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5\n", "     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd\n", "     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e\n", "     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde\n", '     *\n', '     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^\n', '     *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd\n', '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;\n', '\n', '    /*\n', '     * 0x5b5e139f ===\n', "     *     bytes4(keccak256('name()')) ^\n", "     *     bytes4(keccak256('symbol()')) ^\n", "     *     bytes4(keccak256('tokenURI(uint256)'))\n", '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;\n', '\n', '    /*\n', "     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd\n", "     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59\n", "     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7\n", '     *\n', '     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63\n', '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;\n', '\n', '    // Events\n', '    event ChangedLoopName(uint256 indexed loopId, string newName);\n', '    event MintedLoops(address minter, uint256 loopId, uint256 count);\n', '    event DestroyedLoop(uint256 indexed loopId, address destroyer, string lastWords);\n', '    event HiddenLoop(uint256 indexed loopId, bool isHidden);\n', '\n', '    /**\n', '     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.\n', '     */\n', '    constructor (string memory cname, string memory csymbol, address dustAddress) {\n', '        _name = cname;\n', '        _symbol = csymbol;\n', '        _dustAddress = dustAddress;\n', '        _burnedLoops = 0;\n', '\n', '        // register the supported interfaces to conform to ERC721 via ERC165\n', '        _registerInterface(_INTERFACE_ID_ERC721);\n', '        _registerInterface(_INTERFACE_ID_ERC721_METADATA);\n', '        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns base token URI \n', '     */\n', '    function baseTokenURI() public pure returns (string memory) {\n', '        return "https://app.ai42.art/api/loop/";\n', '    }\n', '\n', '    /**\n', '     * @dev Returns an URI for a given token ID\n', '     * Throws if the token ID does not exist. May return an empty string.\n', '     * @param tokenId uint256 ID of the token to query\n', '     */\n', '    function tokenURI(uint256 tokenId) external view returns (string memory) {\n', '      require(_exists(tokenId));\n', '      return string(abi.encodePacked(baseTokenURI(), Strings.toString(tokenId)));\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-balanceOf}.\n', '     */\n', '    function balanceOf(address owner) public view override returns (uint256) {\n', '        require(owner != address(0), "ERC721: balance query for the zero address");\n', '\n', '        return _holderTokens[owner].length();\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-ownerOf}.\n', '     */\n', '    function ownerOf(uint256 tokenId) public view override returns (address) {\n', '        return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-name}.\n', '     */\n', '    function name() public view override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-symbol}.\n', '     */\n', '    function symbol() public view override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.\n', '     */\n', '    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {\n', '        return _holderTokens[owner].at(index);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Enumerable-totalSupply}.\n', '     */\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _tokenOwners.length().sub(_burnedLoops);\n', '    }\n', '\n', '    function mintedSupply() public view returns (uint256) {\n', '        return _tokenOwners.length();\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Enumerable-tokenByIndex}.\n', '     */\n', '    function tokenByIndex(uint256 index) public view override returns (uint256) {\n', '        (uint256 tokenId, ) = _tokenOwners.at(index);\n', '        return tokenId;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns name of the NFT at index.\n', '     */\n', '    function tokenNameByIndex(uint256 index) public view returns (string memory) {\n', '        return _tokenName[index];\n', '    }\n', '\n', '    /**\n', '     * @dev check if the loop is hidden or not\n', '     */\n', '    function isHidden(uint256 index) public view returns(bool) {\n', '        return _loopHidden[index];\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current price for a Loop\n', '     */\n', '    function getCurrentPrice(uint256 count) public view returns (uint256) {\n', '\trequire(block.timestamp >= LOOP_SALESTART_TS, "ERROR: sale not started yet");\n', '        require((count > 0) && (count < 17), "ERROR: number of Loops must be between 1 and 16");\n', '        require(mintedSupply() < LOOP_MAX_SUPPLY, "ERROR: all loops have been sold");\n', '\n', '        uint currentNumOfLoops = mintedSupply();\n', '        uint256 price;\n', '\n', '        if (currentNumOfLoops < 1024) {         price = 80000000000000000;     // 0-1023     ... 0.08E\n', '        } else if (currentNumOfLoops < 2048) {  price = 160000000000000000;    // 1023-2047  ... 0.16E\n', '        } else if (currentNumOfLoops < 4096) {  price = 320000000000000000;    // 2048-4095  ... 0.32E\n', '        } else if (currentNumOfLoops < 8192) {  price = 640000000000000000;    // 4096-8191  ... 0.64E\n', '        } else if (currentNumOfLoops < 9216) {  price = 1280000000000000000;   // 8192-9215  ... 1.28E\n', '        } else {                                price = 2560000000000000000;   // 9216-10100 ....2.56E\n', '        }\n', '\n', '        return price.mul(count);\n', '    } \n', '\n', '    /**\n', '    * @dev Buy a Loop\n', '    */\n', '    function mintLoop(uint256 count) public payable {\n', '        require((count > 0) && (count < 17), "Number of Loops must be between 1 and 16");\n', '        require(msg.value >= getCurrentPrice(count) , "Payment not enough for loops");\n', '\n', '\tuint mintStart = mintedSupply();\n', '\n', '        for (uint i = 0; i < count; i++) {\n', '            require(LOOP_MAX_SUPPLY >= mintedSupply().add(count), "Not enough Loops left");\n', '            _safeMint(msg.sender, mintedSupply());\n', '        }\n', '\n', '        IDUST(_dustAddress).mint(msg.sender, count.mul(LOOP_MINT_REWARD));\n', '\n', '        emit MintedLoops(msg.sender, mintStart, count);\n', '    }\n', '\n', '    /**\n', '     * @dev hides or unhides a loop\n', '     */\n', '    function hideLoop(uint256 tokenId, bool hide) external {\n', '        require(_msgSender() == ownerOf(tokenId), "ERC721: caller is not the owner");\n', '        _loopHidden[tokenId] = hide;\n', '\n', '        emit HiddenLoop(tokenId, hide);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Changes the Loop name, optimized for gas\n', '     */\n', '    function changeLoopName(uint256 tokenId, string memory newName) external {\n', '        require(_msgSender() == ownerOf(tokenId), "ERC721: caller is not the owner");\n', '        require(checkName(newName) == true, "ERROR: name does not follow rules");\n', '        require(keccak256(bytes(newName)) != keccak256(bytes(_tokenName[tokenId])), "ERROR: name is the same");\n', '\n', '        IDUST(_dustAddress).transferFrom(msg.sender, address(this), LOOP_CHANGE_NAME_PRICE);\n', '        _tokenName[tokenId] = newName;\n', '        IDUST(_dustAddress).burn(LOOP_CHANGE_NAME_PRICE);\n', '\n', '        emit ChangedLoopName(tokenId, newName);\n', '    }\n', '\n', '    /**\n', '     * @dev Burns `tokenId`. See {ERC721-_burn}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own `tokenId` or be an approved operator.\n', '     * - Last words must be supplied.\n', '     */\n', '    function burn(uint256 tokenId, string memory lastWords) public virtual {\n', '        //solhint-disable-next-line max-line-length\n', '        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");\n', '        require(checkName(lastWords) == true, "ERROR: name does not follow rules");\n', '\n', '        _tokenName[tokenId] = lastWords;\n', '        _burn(tokenId);\n', '        IDUST(_dustAddress).mint(msg.sender, LOOP_DESTROY_REWARD);\n', '\n', '\temit DestroyedLoop(tokenId, _msgSender(), lastWords);\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw ether from this contract (Callable by owner)\n', '    */\n', '    function withdraw() external onlyOwner {\n', '        address payable ownerPay = payable(owner());\n', '        ownerPay.transfer(address(this).balance);\n', '    }\n', '\n', '    /**\n', '     * @dev Withdraw stuck ERC20s from this contract (Callable by owner)\n', '    */\n', '    function withdrawStuckERC20(address token, uint256 amount) external onlyOwner {\n', "        require(token != _dustAddress, 'ERROR: cannot remove dust tokens');\n", '        IERC20(token).transfer(owner(), amount);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-approve}.\n', '     */\n', '    function approve(address to, uint256 tokenId) public virtual override {\n', '        address owner = ownerOf(tokenId);\n', '        require(to != owner, "ERC721: approval to current owner");\n', '\n', '        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),\n', '            "ERC721: approve caller is not owner nor approved for all"\n', '        );\n', '\n', '        _approve(to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-getApproved}.\n', '     */\n', '    function getApproved(uint256 tokenId) public view override returns (address) {\n', '        require(_exists(tokenId), "ERC721: approved query for nonexistent token");\n', '\n', '        return _tokenApprovals[tokenId];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-setApprovalForAll}.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) public virtual override {\n', '        require(operator != _msgSender(), "ERC721: approve to caller");\n', '\n', '        _operatorApprovals[_msgSender()][operator] = approved;\n', '        emit ApprovalForAll(_msgSender(), operator, approved);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-isApprovedForAll}.\n', '     */\n', '    function isApprovedForAll(address owner, address operator) public view override returns (bool) {\n', '        return _operatorApprovals[owner][operator];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-transferFrom}.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) public virtual override {\n', '        //solhint-disable-next-line max-line-length\n', '        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");\n', '\n', '        _transfer(from, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-safeTransferFrom}.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {\n', '        safeTransferFrom(from, to, tokenId, "");\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-safeTransferFrom}.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {\n', '        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");\n', '        _safeTransfer(from, to, tokenId, _data);\n', '    }\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * `_data` is additional data, it has no specified format and it is sent in call to `to`.\n', '     *\n', '     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.\n', '     * implement alternative mechanisms to perform token transfer, such as signature-based.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {\n', '        _transfer(from, to, tokenId);\n', '        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether `tokenId` exists.\n', '     *\n', '     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.\n', '     *\n', '     * Tokens start existing when they are minted (`_mint`),\n', '     * and stop existing when they are burned (`_burn`).\n', '     */\n', '    function _exists(uint256 tokenId) internal view returns (bool) {\n', '        return _tokenOwners.contains(tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether `spender` is allowed to manage `tokenId`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {\n', '        require(_exists(tokenId), "ERC721: operator query for nonexistent token");\n', '        address owner = ownerOf(tokenId);\n', '        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Safely mints `tokenId` and transfers it to `to`.\n', '     *\n', '     * Requirements:\n', '     d*\n', '     * - `tokenId` must not exist.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _safeMint(address to, uint256 tokenId) internal virtual {\n', '        _safeMint(to, tokenId, "");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is\n', '     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.\n', '     */\n', '    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {\n', '        _mint(to, tokenId);\n', '        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");\n', '    }\n', '\n', '    /**\n', '     * @dev Mints `tokenId` and transfers it to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must not exist.\n', '     * - `to` cannot be the zero address.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _mint(address to, uint256 tokenId) internal virtual {\n', '        require(to != address(0), "ERC721: mint to the zero address");\n', '        require(!_exists(tokenId), "ERC721: token already minted");\n', '\n', '        _beforeTokenTransfer(address(0), to, tokenId);\n', '\n', '        _holderTokens[to].add(tokenId);\n', '\n', '        _tokenOwners.set(tokenId, to);\n', '\n', '        emit Transfer(address(0), to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `tokenId`.\n', '     * The approval is cleared when the token is burned.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _burn(uint256 tokenId) internal virtual {\n', '        address owner = ownerOf(tokenId);\n', '\n', '        _beforeTokenTransfer(owner, address(0), tokenId);\n', '\n', '        // Clear approvals\n', '        _approve(address(0), tokenId);\n', '\n', '        _holderTokens[owner].remove(tokenId);\n', '\n', '        _tokenOwners.set(tokenId, address(0));\n', '\n', '\t_burnedLoops++;\n', '\n', '        emit Transfer(owner, address(0), tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` from `from` to `to`.\n', '     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _transfer(address from, address to, uint256 tokenId) internal virtual {\n', '        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");\n', '        require(to != address(0), "ERC721: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(from, to, tokenId);\n', '\n', '        // Clear approvals from the previous owner\n', '        _approve(address(0), tokenId);\n', '\n', '        _holderTokens[from].remove(tokenId);\n', '        _holderTokens[to].add(tokenId);\n', '\n', '        _tokenOwners.set(tokenId, to);\n', '\n', '        emit Transfer(from, to, tokenId);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.\n', '     * The call is not executed if the target address is not a contract.\n', '     *\n', '     * @param from address representing the previous owner of the given token ID\n', '     * @param to target address that will receive the tokens\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @param _data bytes optional data to send along with the call\n', '     * @return bool whether the call correctly returned the expected magic value\n', '     */\n', '    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)\n', '        private returns (bool)\n', '    {\n', '        if (!to.isContract()) {\n', '            return true;\n', '        }\n', '        bytes memory returndata = to.functionCall(abi.encodeWithSelector(\n', '            IERC721Receiver(to).onERC721Received.selector,\n', '            _msgSender(),\n', '            from,\n', '            tokenId,\n', '            _data\n', '        ), "ERC721: transfer to non ERC721Receiver implementer");\n', '        bytes4 retval = abi.decode(returndata, (bytes4));\n', '        return (retval == _ERC721_RECEIVED);\n', '    }\n', '\n', '    function _approve(address to, uint256 tokenId) private {\n', '        _tokenApprovals[tokenId] = to;\n', '        emit Approval(ownerOf(tokenId), to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Hook that is called before any token transfer. This includes minting\n', '     * and burning.\n', '     *\n', '     * Calling conditions:\n', '     *\n', "     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be\n", '     * transferred to `to`.\n', '     * - When `from` is zero, `tokenId` will be minted for `to`.\n', "     * - When `to` is zero, ``from``'s `tokenId` will be burned.\n", '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     *\n', '     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n', '     */\n', '    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }\n', '\n', '    /**\n', '     * @dev check if name is valid (ascii range 0x20-0x7E without leading/trailing spaces)\n', '     */\n', '    function checkName(string memory str) public pure returns (bool){\n', '        bytes memory b = bytes(str);\n', '        if (b.length == 0) return false; // not empty\n', '        if (b.length > 24) return false; // max 24 chars \n', '        if (b[0] == 0x20) return false;  // no leading space\n', '        if (b[b.length - 1] == 0x20) return false; // no trailing space\n', '\n', '        for(uint i; i < b.length; i++) { // asci range 0x20 to 0x7E\n', '\t    if (b[i] > 0x7E || b[i] < 0x20)\n', '\t\treturn false;\n', '        }\n', '        return true;\n', '    }\n', '}']