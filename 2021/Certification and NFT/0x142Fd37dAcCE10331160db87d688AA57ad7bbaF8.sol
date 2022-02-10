['pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "@openzeppelin/contracts/access/AccessControl.sol";\n', 'import "@openzeppelin/contracts/GSN/Context.sol";\n', 'import "@openzeppelin/contracts/token/ERC721/ERC721.sol";\n', '\n', 'contract FirstPrinciples is Context, AccessControl, ERC721 {\n', '\n', '    uint256 public constant MAX_SUPPLY = 1000;\n', '    uint256 public constant PRICE = 10000000000000000;\n', '    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");\n', '    address public constant recipient = 0xD2927a91570146218eD700566DF516d67C5ECFAB;\n', '\n', '\n', '\n', '    /**\n', '     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the\n', '     * account that deploys the contract.\n', '     *\n', '     * Token URIs will be autogenerated based on `baseURI` and their token IDs.\n', '     * See {ERC721-tokenURI}.\n', '     */\n', '    constructor(string memory baseURI, address admin) public ERC721("First Principles", "FIRSTPRINCIPLES") {\n', '        _setupRole(DEFAULT_ADMIN_ROLE, admin);\n', '        _setupRole(MINTER_ROLE, admin);\n', '        _setBaseURI(baseURI);\n', '    }\n', '\n', '\n', '    function setBaseURI(string memory newBaseURI) public {\n', '        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));\n', '        _setBaseURI(newBaseURI);\n', '    }\n', '\n', '    /**\n', '     * @dev Creates a new token for `to`. Its token ID will be automatically\n', '     * assigned (and available on the emitted {IERC721-Transfer} event), and the token\n', '     * URI autogenerated based on the base URI passed at construction.\n', '     *\n', '     * See {ERC721-_mint}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must have the `MINTER_ROLE`.\n', '     */\n', '    function mint(address to) public payable virtual {\n', '        require(msg.value == PRICE || hasRole(MINTER_ROLE, _msgSender()));\n', '        require(totalSupply() + 1 < MAX_SUPPLY);\n', '        uint256 IDToMint = totalSupply();\n', '        _mint(to, IDToMint);\n', '        payable(recipient).transfer(msg.value);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721) {\n', '        super._beforeTokenTransfer(from, to, tokenId);\n', '    }\n', '}']