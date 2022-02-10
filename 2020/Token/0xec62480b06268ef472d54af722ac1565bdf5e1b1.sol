['/*\n', '██████╗ ██╗ ██████╗ █████╗ ██████╗ ██████╗ ██╗ █████╗ ███╗   ██╗\n', '██╔══██╗██║██╔════╝██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗████╗  ██║\n', '██████╔╝██║██║     ███████║██████╔╝██║  ██║██║███████║██╔██╗ ██║\n', '██╔══██╗██║██║     ██╔══██║██╔══██╗██║  ██║██║██╔══██║██║╚██╗██║\n', '██║  ██║██║╚██████╗██║  ██║██║  ██║██████╔╝██║██║  ██║██║ ╚████║\n', '╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝\n', '██╗     ██╗      ██████╗                                        \n', '██║     ██║     ██╔════╝                                        \n', '██║     ██║     ██║                                             \n', '██║     ██║     ██║                                             \n', '███████╗███████╗╚██████╗   \n', 'DEAR MSG.SENDER(S):\n', '/ Ricardian LLC is a project in beta.\n', '// Please audit and use at your own risk.\n', '/// Entry into Ricardian LLC shall not create an attorney/client relationship.\n', '//// Likewise, Ricardian LLC should not be construed as legal advice or replacement for professional counsel.\n', '///// STEAL THIS C0D3SL4W\n', '~presented by Open, ESQ || LexDAO LLC\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', 'contract RicardianLLC { // based on GAMMA nft - 0xeF0ff94B152C00ED4620b149eE934f2F4A526387\n', '    address payable public ricardianLLCdao;\n', '    uint256 public mintFee;\n', '    uint256 public totalSupply;\n', '    uint256 public constant totalSupplyCap = uint256(-1);\n', '    uint256 public version;\n', '    string public masterOperatingAgreement;\n', '    string public name = "Ricardian LLC, Series";\n', '    string public symbol = "LLC";\n', '    bool public mintOpen;\n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(uint256 => address) public getApproved;\n', '    mapping(uint256 => address) public ownerOf;\n', '    mapping(uint256 => uint256) public tokenByIndex;\n', '    mapping(uint256 => string) public tokenURI;\n', '    mapping(bytes4 => bool) public supportsInterface; // eip-165 \n', '    mapping(address => mapping(address => bool)) public isApprovedForAll;\n', '    mapping(address => mapping(uint256 => uint256)) public tokenOfOwnerByIndex;\n', '    \n', '    event Approval(address indexed approver, address indexed spender, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed holder, address indexed operator, bool approved);\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event UpdateMasterOperatingAgreement(uint256 indexed version, string indexed masterOperatingAgreement);\n', '    event UpdateMintFee(uint256 indexed mintFee);\n', '    event UpdateMintStatus(bool indexed mintOpen);\n', '    event UpdateRicardianLLCdao(address indexed ricardianLLCdao);\n', '\n', '    constructor (string memory _masterOperatingAgreement) public {\n', '        ricardianLLCdao = msg.sender;\n', '        masterOperatingAgreement = _masterOperatingAgreement;\n', '        supportsInterface[0x80ac58cd] = true; // ERC721 \n', '        supportsInterface[0x5b5e139f] = true; // METADATA\n', '        supportsInterface[0x780e9d63] = true; // ENUMERABLE\n', '    }\n', '    \n', '    function approve(address spender, uint256 tokenId) external {\n', '        require(msg.sender == ownerOf[tokenId] || isApprovedForAll[ownerOf[tokenId]][msg.sender], "!owner/operator");\n', '        getApproved[tokenId] = spender;\n', '        emit Approval(msg.sender, spender, tokenId); \n', '    }\n', '    \n', '    function mint() payable external { \n', '        if (!mintOpen) {require(msg.sender == ricardianLLCdao);}\n', '        require(msg.value == mintFee);\n', '        totalSupply++;\n', '        require(totalSupply <= totalSupplyCap, "capped");\n', '        uint256 tokenId = totalSupply;\n', '        balanceOf[msg.sender]++;\n', '        ownerOf[tokenId] = msg.sender;\n', '        tokenByIndex[tokenId - 1] = tokenId;\n', '        tokenURI[tokenId] = "https://ipfs.globalupload.io/QmWnD9Tv6YGyMFCytGvoGTvnaGU8B6GPWWt1FwKfkuKD4V";\n', '        tokenOfOwnerByIndex[msg.sender][tokenId - 1] = tokenId;\n', '        (bool success, ) = ricardianLLCdao.call.value(msg.value)("");\n', '        require(success, "!transfer");\n', '        emit Transfer(address(0), msg.sender, tokenId); \n', '    }\n', '    \n', '    function setApprovalForAll(address operator, bool approved) external {\n', '        isApprovedForAll[msg.sender][operator] = approved;\n', '        emit ApprovalForAll(msg.sender, operator, approved);\n', '    }\n', '    \n', '    function _transfer(address from, address to, uint256 tokenId) internal {\n', '        balanceOf[from]--; \n', '        balanceOf[to]++; \n', '        getApproved[tokenId] = address(0);\n', '        ownerOf[tokenId] = to;\n', '        tokenOfOwnerByIndex[from][tokenId - 1] = 0;\n', '        tokenOfOwnerByIndex[to][tokenId - 1] = tokenId;\n', '        emit Transfer(from, to, tokenId); \n', '    }\n', '    \n', '    function transfer(address to, uint256 tokenId) external {\n', '        require(msg.sender == ownerOf[tokenId], "!owner");\n', '        _transfer(msg.sender, to, tokenId);\n', '    }\n', '    \n', '    function transferBatch(address[] calldata to, uint256[] calldata tokenId) external {\n', '        require(to.length == tokenId.length, "!to/tokenId");\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            require(msg.sender == ownerOf[tokenId[i]], "!owner");\n', '            _transfer(msg.sender, to[i], tokenId[i]);\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 tokenId) external {\n', '        require(msg.sender == ownerOf[tokenId] || getApproved[tokenId] == msg.sender || isApprovedForAll[ownerOf[tokenId]][msg.sender], "!owner/spender/operator");\n', '        _transfer(from, to, tokenId);\n', '    }\n', '    \n', '    /************\n', '    DAO FUNCTIONS\n', '    ************/\n', '    modifier onlyRicardianLLCdao() {\n', '        require(msg.sender == ricardianLLCdao, "!ricardianLLCdao");\n', '        _;\n', '    }\n', '\n', '    function updateMasterOperatingAgreement(string calldata _masterOperatingAgreement) external onlyRicardianLLCdao {\n', '        version++;\n', '        masterOperatingAgreement = _masterOperatingAgreement;\n', '        emit UpdateMasterOperatingAgreement(version, masterOperatingAgreement);\n', '    }\n', '\n', '    function updateMintFee(uint256 _mintFee) external onlyRicardianLLCdao {\n', '        mintFee = _mintFee;\n', '        emit UpdateMintFee(mintFee);\n', '    }\n', '    \n', '    function updateMintStatus(bool _mintOpen) external onlyRicardianLLCdao {\n', '        mintOpen = _mintOpen;\n', '        emit UpdateMintStatus(mintOpen);\n', '    }\n', '\n', '    function updateRicardianLLCdao(address payable _ricardianLLCdao) external onlyRicardianLLCdao {\n', '        ricardianLLCdao = _ricardianLLCdao;\n', '        emit UpdateRicardianLLCdao(ricardianLLCdao);\n', '    }\n', '}']