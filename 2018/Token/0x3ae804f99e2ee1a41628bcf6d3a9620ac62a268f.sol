['pragma solidity ^0.4.24;\n', '\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        role.bearer[account] = true;\n', '    }\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        role.bearer[account] = false;\n', '    }\n', '    function has(Role storage role, address account)\n', '        internal\n', '        view\n', '        returns (bool)\n', '    {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', 'contract MinterRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event MinterAdded(address indexed account);\n', '    event MinterRemoved(address indexed account);\n', '\n', '    Roles.Role private minters;\n', '\n', '    constructor() public {\n', '        minters.add(msg.sender);\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        require(isMinter(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isMinter(address account) public view returns (bool) {\n', '        return minters.has(account);\n', '    }\n', '\n', '    function addMinter(address account) public onlyMinter {\n', '        minters.add(account);\n', '        emit MinterAdded(account);\n', '    }\n', '\n', '    function renounceMinter() public {\n', '        minters.remove(msg.sender);\n', '    }\n', '\n', '    function _removeMinter(address account) internal {\n', '        minters.remove(account);\n', '        emit MinterRemoved(account);\n', '    }\n', '}\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '        return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '    \n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', 'interface IERC165 {\n', '    function supportsInterface(bytes4 interfaceId)\n', '        external\n', '        view\n', '        returns (bool);\n', '}\n', 'contract ERC165 is IERC165 {\n', '    bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;\n', '    mapping(bytes4 => bool) internal _supportedInterfaces;\n', '    constructor()\n', '        public\n', '    {\n', '        _registerInterface(_InterfaceId_ERC165);\n', '    }\n', '    function supportsInterface(bytes4 interfaceId)\n', '        external\n', '        view\n', '        returns (bool)\n', '    {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '    function _registerInterface(bytes4 interfaceId)\n', '        internal\n', '    {\n', '        require(interfaceId != 0xffffffff);\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', 'contract IERC721 is IERC165 {\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 indexed tokenId\n', '    );\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed approved,\n', '        uint256 indexed tokenId\n', '    );\n', '    event ApprovalForAll(\n', '        address indexed owner,\n', '        address indexed operator,\n', '        bool approved\n', '    );\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getApproved(uint256 tokenId)\n', '        public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '    function isApprovedForAll(address owner, address operator)\n', '        public view returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '    function safeTransferFrom(address from, address to, uint256 tokenId)\n', '        public;\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes data\n', '    )\n', '        public;\n', '}\n', 'contract IERC721Enumerable is IERC721 {\n', '    function totalSupply() public view returns (uint256);\n', '    function tokenOfOwnerByIndex(\n', '        address owner,\n', '        uint256 index\n', '    )\n', '        public\n', '        view\n', '        returns (uint256 tokenId);\n', '\n', '    function tokenByIndex(uint256 index) public view returns (uint256);\n', '}\n', 'contract IERC721Metadata is IERC721 {\n', '    function name() external view returns (string);\n', '    function symbol() external view returns (string);\n', '    function tokenURI(uint256 tokenId) public view returns (string);\n', '}\n', 'contract IERC721Receiver {\n', '    function onERC721Received(\n', '        address operator,\n', '        address from,\n', '        uint256 tokenId,\n', '        bytes data\n', '    )\n', '        public\n', '        returns(bytes4);\n', '}\n', 'contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {\n', '}\n', 'contract ERC721 is ERC165, IERC721 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;\n', '\n', '    mapping (uint256 => address) private _tokenOwner;\n', '\n', '    mapping (uint256 => address) private _tokenApprovals;\n', '\n', '    mapping (address => uint256) private _ownedTokensCount;\n', '\n', '    mapping (address => mapping (address => bool)) private _operatorApprovals;\n', '\n', '    bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;\n', '\n', '    constructor()\n', '        public\n', '    {\n', '        _registerInterface(_InterfaceId_ERC721);\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        require(owner != address(0));\n', '        return _ownedTokensCount[owner];\n', '    }\n', '\n', '    function ownerOf(uint256 tokenId) public view returns (address) {\n', '        address owner = _tokenOwner[tokenId];\n', '        require(owner != address(0));\n', '        return owner;\n', '    }\n', '\n', '    function approve(address to, uint256 tokenId) public {\n', '        address owner = ownerOf(tokenId);\n', '        require(to != owner);\n', '        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));\n', '\n', '        _tokenApprovals[tokenId] = to;\n', '        emit Approval(owner, to, tokenId);\n', '    }\n', '\n', '    function getApproved(uint256 tokenId) public view returns (address) {\n', '        require(_exists(tokenId));\n', '        return _tokenApprovals[tokenId];\n', '    }\n', '\n', '    function setApprovalForAll(address to, bool approved) public {\n', '        require(to != msg.sender);\n', '        _operatorApprovals[msg.sender][to] = approved;\n', '        emit ApprovalForAll(msg.sender, to, approved);\n', '    }\n', '\n', '    function isApprovedForAll(\n', '        address owner,\n', '        address operator\n', '    )\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        return _operatorApprovals[owner][operator];\n', '    }\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    )\n', '        public\n', '    {\n', '        require(_isApprovedOrOwner(msg.sender, tokenId));\n', '        require(to != address(0));\n', '\n', '        _clearApproval(from, tokenId);\n', '        _removeTokenFrom(from, tokenId);\n', '        _addTokenTo(to, tokenId);\n', '\n', '        emit Transfer(from, to, tokenId);\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId\n', '    )\n', '        public\n', '    {\n', '        safeTransferFrom(from, to, tokenId, "");\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes _data\n', '    )\n', '        public\n', '    {\n', '        transferFrom(from, to, tokenId);\n', '        require(_checkAndCallSafeTransfer(from, to, tokenId, _data));\n', '    }\n', '\n', '    function _exists(uint256 tokenId) internal view returns (bool) {\n', '        address owner = _tokenOwner[tokenId];\n', '        return owner != address(0);\n', '    }\n', '\n', '    function _isApprovedOrOwner(\n', '        address spender,\n', '        uint256 tokenId\n', '    )\n', '        internal\n', '        view\n', '        returns (bool)\n', '    {\n', '        address owner = ownerOf(tokenId);\n', '        return (\n', '        spender == owner ||\n', '        getApproved(tokenId) == spender ||\n', '        isApprovedForAll(owner, spender)\n', '        );\n', '    }\n', '\n', '    function _mint(address to, uint256 tokenId) internal {\n', '        require(to != address(0));\n', '        _addTokenTo(to, tokenId);\n', '        emit Transfer(address(0), to, tokenId);\n', '    }\n', '\n', '    function _burn(address owner, uint256 tokenId) internal {\n', '        _clearApproval(owner, tokenId);\n', '        _removeTokenFrom(owner, tokenId);\n', '        emit Transfer(owner, address(0), tokenId);\n', '    }\n', '\n', '    function _clearApproval(address owner, uint256 tokenId) internal {\n', '        require(ownerOf(tokenId) == owner);\n', '        if (_tokenApprovals[tokenId] != address(0)) {\n', '        _tokenApprovals[tokenId] = address(0);\n', '        }\n', '    }\n', '\n', '    function _addTokenTo(address to, uint256 tokenId) internal {\n', '        require(_tokenOwner[tokenId] == address(0));\n', '        _tokenOwner[tokenId] = to;\n', '        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);\n', '    }\n', '\n', '    function _removeTokenFrom(address from, uint256 tokenId) internal {\n', '        require(ownerOf(tokenId) == from);\n', '        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);\n', '        _tokenOwner[tokenId] = address(0);\n', '    }\n', '\n', '    function _checkAndCallSafeTransfer(\n', '        address from,\n', '        address to,\n', '        uint256 tokenId,\n', '        bytes _data\n', '    )\n', '        internal\n', '        returns (bool)\n', '    {\n', '        if (!to.isContract()) {\n', '        return true;\n', '        }\n', '        bytes4 retval = IERC721Receiver(to).onERC721Received(\n', '        msg.sender, from, tokenId, _data);\n', '        return (retval == _ERC721_RECEIVED);\n', '    }\n', '}\n', 'contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {\n', '    string internal _name;\n', '\n', '    string internal _symbol;\n', '\n', '    mapping(uint256 => string) private _tokenURIs;\n', '\n', '    bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;\n', '\n', '    constructor(string name, string symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '\n', '        _registerInterface(InterfaceId_ERC721Metadata);\n', '    }\n', '\n', '    function name() external view returns (string) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() external view returns (string) {\n', '        return _symbol;\n', '    }\n', '\n', '    function tokenURI(uint256 tokenId) public view returns (string) {\n', '        require(_exists(tokenId));\n', '        return _tokenURIs[tokenId];\n', '    }\n', '\n', '    function _setTokenURI(uint256 tokenId, string uri) internal {\n', '        require(_exists(tokenId));\n', '        _tokenURIs[tokenId] = uri;\n', '    }\n', '\n', '    function _burn(address owner, uint256 tokenId) internal {\n', '        super._burn(owner, tokenId);\n', '\n', '        if (bytes(_tokenURIs[tokenId]).length != 0) {\n', '        delete _tokenURIs[tokenId];\n', '        }\n', '    }\n', '}\n', 'contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {\n', '    mapping(address => uint256[]) private _ownedTokens;\n', '\n', '    mapping(uint256 => uint256) private _ownedTokensIndex;\n', '\n', '    uint256[] private _allTokens;\n', '\n', '    mapping(uint256 => uint256) private _allTokensIndex;\n', '\n', '    bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;\n', '\n', '    constructor() public {\n', '        _registerInterface(_InterfaceId_ERC721Enumerable);\n', '    }\n', '\n', '    function tokenOfOwnerByIndex(\n', '        address owner,\n', '        uint256 index\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(index < balanceOf(owner));\n', '        return _ownedTokens[owner][index];\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _allTokens.length;\n', '    }\n', '\n', '    function tokenByIndex(uint256 index) public view returns (uint256) {\n', '        require(index < totalSupply());\n', '        return _allTokens[index];\n', '    }\n', '\n', '    function _addTokenTo(address to, uint256 tokenId) internal {\n', '        super._addTokenTo(to, tokenId);\n', '        uint256 length = _ownedTokens[to].length;\n', '        _ownedTokens[to].push(tokenId);\n', '        _ownedTokensIndex[tokenId] = length;\n', '    }\n', '\n', '    function _removeTokenFrom(address from, uint256 tokenId) internal {\n', '        super._removeTokenFrom(from, tokenId);\n', '\n', '        uint256 tokenIndex = _ownedTokensIndex[tokenId];\n', '        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);\n', '        uint256 lastToken = _ownedTokens[from][lastTokenIndex];\n', '\n', '        _ownedTokens[from][tokenIndex] = lastToken;\n', '        _ownedTokens[from].length--;\n', '\n', '        _ownedTokensIndex[tokenId] = 0;\n', '        _ownedTokensIndex[lastToken] = tokenIndex;\n', '    }\n', '\n', '    function _mint(address to, uint256 tokenId) internal {\n', '        super._mint(to, tokenId);\n', '\n', '        _allTokensIndex[tokenId] = _allTokens.length;\n', '        _allTokens.push(tokenId);\n', '    }\n', '\n', '    function _burn(address owner, uint256 tokenId) internal {\n', '        super._burn(owner, tokenId);\n', '\n', '        uint256 tokenIndex = _allTokensIndex[tokenId];\n', '        uint256 lastTokenIndex = _allTokens.length.sub(1);\n', '        uint256 lastToken = _allTokens[lastTokenIndex];\n', '\n', '        _allTokens[tokenIndex] = lastToken;\n', '        _allTokens[lastTokenIndex] = 0;\n', '\n', '        _allTokens.length--;\n', '        _allTokensIndex[tokenId] = 0;\n', '        _allTokensIndex[lastToken] = tokenIndex;\n', '    }\n', '}\n', 'contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {\n', '    constructor(string name, string symbol) ERC721Metadata(name, symbol)\n', '        public\n', '    {\n', '    }\n', '}\n', 'contract ERC721Mintable is ERC721Full, MinterRole {\n', '    event MintingFinished();\n', '\n', '    bool private _mintingFinished = false;\n', '\n', '    modifier onlyBeforeMintingFinished() {\n', '        require(!_mintingFinished);\n', '        _;\n', '    }\n', '\n', '    function mintingFinished() public view returns(bool) {\n', '        return _mintingFinished;\n', '    }\n', '\n', '    function mint(\n', '        address to,\n', '        uint256 tokenId\n', '    )\n', '        public\n', '        onlyMinter\n', '        onlyBeforeMintingFinished\n', '        returns (bool)\n', '    {\n', '        _mint(to, tokenId);\n', '        return true;\n', '    }\n', '\n', '    function mintWithTokenURI(\n', '        address to,\n', '        uint256 tokenId,\n', '        string tokenURI\n', '    )\n', '        public\n', '        onlyMinter\n', '        onlyBeforeMintingFinished\n', '        returns (bool)\n', '    {\n', '        mint(to, tokenId);\n', '        _setTokenURI(tokenId, tokenURI);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting()\n', '        public\n', '        onlyMinter\n', '        onlyBeforeMintingFinished\n', '        returns (bool)\n', '    {\n', '        _mintingFinished = true;\n', '        emit MintingFinished();\n', '        return true;\n', '    }\n', '}\n', 'contract ERC721Burnable is ERC721 {\n', '    function burn(uint256 tokenId)\n', '        public\n', '    {\n', '        require(_isApprovedOrOwner(msg.sender, tokenId));\n', '        _burn(ownerOf(tokenId), tokenId);\n', '    }\n', '}\n', 'contract ERC721Contract is ERC721Full, ERC721Mintable, ERC721Burnable {\n', '    constructor(string name, string symbol) public\n', '        ERC721Mintable()\n', '        ERC721Full(name, symbol)\n', '    {}\n', '\n', '    function exists(uint256 tokenId) public view returns (bool) {\n', '        return _exists(tokenId);\n', '    }\n', '\n', '    function setTokenURI(uint256 tokenId, string uri) public {\n', '        _setTokenURI(tokenId, uri);\n', '    }\n', '\n', '    function removeTokenFrom(address from, uint256 tokenId) public {\n', '        _removeTokenFrom(from, tokenId);\n', '    }\n', '}\n', 'contract ERC721Constructor {\n', '    event newERC721(address contractAddress, string name, string symbol, address owner);\n', '\n', '    function CreateAdminERC721(string name, string symbol, address owner) public {\n', '        ERC721Contract ERC721Construct = new ERC721Contract(name, symbol);\n', '        ERC721Construct.addMinter(owner);\n', '        ERC721Construct.renounceMinter();\n', '        emit newERC721(address(ERC721Construct), name, symbol, owner);\n', '    }\n', '}']