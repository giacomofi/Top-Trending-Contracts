['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-07\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-13\n', '*/\n', '\n', 'pragma solidity >=0.6.0 <0.8.4;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Administrators\n', '// ----------------------------------------------------------------------------\n', 'contract Admined is Owned {\n', '\n', '    mapping (address => bool) public admins;\n', '\n', '    event AdminAdded(address addr);\n', '    event AdminRemoved(address addr);\n', '\n', '    modifier onlyAdmin() {\n', '        require(isAdmin(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isAdmin(address addr) public returns (bool) {\n', '        return (admins[addr] || owner == addr);\n', '    }\n', '    function addAdmin(address addr) public onlyOwner {\n', '        require(!admins[addr] && addr != owner);\n', '        admins[addr] = true;\n', '        emit AdminAdded(addr);\n', '    }\n', '    function removeAdmin(address addr) public onlyOwner {\n', '        require(admins[addr]);\n', '        delete admins[addr];\n', '        emit AdminRemoved(addr);\n', '    }\n', '}\n', '\n', '\n', '\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '\n', 'interface IERC721 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n', '     */\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n', '     */\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of tokens in ``owner``'s account.\n", '     */\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n', '     * The approval is cleared when the token is transferred.\n', '     *\n', '     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own the token or be an approved operator.\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Returns the account approved for `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function getApproved(uint256 tokenId) external view returns (address operator);\n', '\n', '    /**\n', '     * @dev Approve or remove `operator` as an operator for the caller.\n', '     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The `operator` cannot be the caller.\n', '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     */\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    /**\n', '     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n', '     *\n', '     * See {setApprovalForAll}\n', '     */\n', '    function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '\n', '    /**\n', '      * @dev Safely transfers `tokenId` token from `from` to `to`.\n', '      *\n', '      * Requirements:\n', '      *\n', '      * - `from` cannot be the zero address.\n', '      * - `to` cannot be the zero address.\n', '      * - `tokenId` token must exist and be owned by `from`.\n', '      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '      *\n', '      * Emits a {Transfer} event.\n', '      */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;\n', '}\n', '\n', 'interface IERC721Metadata is IERC721 {\n', '\n', '    /**\n', '     * @dev Returns the token collection name.\n', '     */\n', '    function name() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the token collection symbol.\n', '     */\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.\n', '     */\n', '    function tokenURI(uint256 tokenId) external view returns (string memory);\n', '}\n', '\n', '\n', 'contract MetadataDeveryERC721Wrapper is IERC721, IERC721Metadata, Admined{\n', '\n', '\n', '    address public token;\n', '    IERC721 public tokenContract;\n', '    mapping (uint256 => string) private _tokenURIs;\n', '\n', '    function setERC721(address _token) public onlyAdmin {\n', '        token = _token;\n', '        tokenContract = IERC721(_token);\n', '    }\n', '\n', '    function balanceOf(address owner) public virtual override  view returns  (uint256 balance){\n', '        return tokenContract.balanceOf(owner);\n', '    }\n', '\n', '    function ownerOf(uint256 tokenId) public virtual override view returns (address owner){\n', '        return tokenContract.ownerOf(tokenId);\n', '    }\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override{\n', '          (bool success, bytes memory data) = token.delegatecall(\n', '            abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", from,to, tokenId)\n', '        );\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId )public virtual override{\n', '         (bool success, bytes memory data) = token.delegatecall(\n', '            abi.encodeWithSignature("transferFrom(address,address,uint256)", from,to, tokenId)\n', '        );\n', '    }\n', '\n', '    function approve(address to, uint256 tokenId)public virtual override{\n', '     (bool success, bytes memory data) = token.delegatecall(\n', '            abi.encodeWithSignature("approve(address,uint256)",to, tokenId)\n', '        );\n', '    }\n', '\n', '    function getApproved(uint256 tokenId) public virtual override view returns (address operator){\n', '        return tokenContract.getApproved(tokenId);\n', '    }\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public virtual override{\n', '         (bool success, bytes memory data) = token.delegatecall(\n', '            abi.encodeWithSignature("setApprovalForAll(address,bool)",operator, _approved)\n', '        );\n', '    }\n', '\n', '    function isApprovedForAll(address owner, address operator) public virtual override view returns (bool){\n', '        return tokenContract.isApprovedForAll(owner, operator);\n', '    }\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public virtual override{\n', '         (bool success, bytes memory data) = token.delegatecall(\n', '            abi.encodeWithSignature("safeTransferFrom(address,address,uint256,bytes)",from, to, tokenId, data)\n', '        );\n', '    }\n', '\n', '    function setTokenURI(uint256 tokenId, string memory _tokenURI) public virtual {\n', '        require(ownerOf(tokenId) == msg.sender, "Only the owner of a token can set its metadata");\n', '        _tokenURIs[tokenId] = _tokenURI;\n', '    }\n', '\n', '\n', '    function supportsInterface(bytes4 interfaceId)  public virtual override view returns (bool){\n', '        return true;\n', '    }\n', '\n', '    function name()  public virtual override view  returns (string memory){\n', '        return "Devery NFT";\n', '    }\n', '    \n', '    function symbol()  public virtual override view  returns (string memory){\n', '        return "EVENFT";\n', '    }\n', '    \n', '    function tokenURI(uint256 tokenId) public virtual override view returns (string memory){\n', '        return _tokenURIs[tokenId];\n', '    }\n', '}']