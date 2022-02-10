['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-09\n', '*/\n', '\n', '/*\n', '██████╗ ██╗ ██████╗ █████╗ ██████╗ ██████╗ ██╗ █████╗ ███╗   ██╗\n', '██╔══██╗██║██╔════╝██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗████╗  ██║\n', '██████╔╝██║██║     ███████║██████╔╝██║  ██║██║███████║██╔██╗ ██║\n', '██╔══██╗██║██║     ██╔══██║██╔══██╗██║  ██║██║██╔══██║██║╚██╗██║\n', '██║  ██║██║╚██████╗██║  ██║██║  ██║██████╔╝██║██║  ██║██║ ╚████║\n', '╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝\n', '██╗     ██╗      ██████╗                                        \n', '██║     ██║     ██╔════╝                                        \n', '██║     ██║     ██║                                             \n', '██║     ██║     ██║                                             \n', '███████╗███████╗╚██████╗                                        \n', '╚══════╝╚══════╝ ╚═════╝*/\n', '/// Presented by LexDAO LLC\n', '/// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.8.1;\n', '\n', 'contract RicardianLLC {\n', '    address payable public governance;\n', '    uint256 public totalSupply;\n', '    string public commonURI;\n', '    string public masterOperatingAgreement;\n', '    string constant public name = "Ricardian LLC, Series";\n', '    string constant public symbol = "LLC";\n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(uint256 => address) public getApproved;\n', '    mapping(uint256 => address) public ownerOf;\n', '    mapping(uint256 => string) public tokenDetails;\n', '    mapping(uint256 => string) public tokenURI;\n', '    mapping(uint256 => Sale) public sale;\n', '    mapping(bytes4 => bool) public supportsInterface; // eip-165 \n', '    mapping(address => mapping(address => bool)) public isApprovedForAll;\n', '    \n', '    event Approval(address indexed approver, address indexed spender, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed approver, address indexed operator, bool approved);\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event UpdateTokenDetails(uint256 indexed tokenId, string details);\n', '    event SetSale(address indexed buyer, uint256 indexed price, uint256 indexed tokenId);\n', '    event GovTribute(address indexed caller, uint256 indexed amount, string details);\n', '    event GovUpdateSettings(address indexed governance, string commonURI, string masterOperatingAgreement);\n', '    event GovUpdateTokenURI(uint256 indexed tokenId, string tokenURI);\n', '    \n', '    struct Sale {\n', '        address buyer;\n', '        uint256 price;\n', '    }\n', '    \n', '    constructor(address payable _governance, string memory _commonURI, string memory _masterOperatingAgreement) {\n', '        governance = _governance; \n', '        commonURI = _commonURI;\n', '        masterOperatingAgreement = _masterOperatingAgreement; \n', '        supportsInterface[0x80ac58cd] = true; // ERC721 \n', '        supportsInterface[0x5b5e139f] = true; // METADATA\n', '    }\n', '    \n', '    /****************\n', '    PRIVATE FUNCTIONS\n', '    ****************/\n', '    function _mint(address to) private { \n', '        totalSupply++;\n', '        uint256 tokenId = totalSupply;\n', '        balanceOf[to]++;\n', '        ownerOf[tokenId] = to;\n', '        tokenURI[tokenId] = commonURI;\n', '        emit Transfer(address(0), to, tokenId); \n', '    }\n', '    \n', '    function _transfer(address from, address to, uint256 tokenId) private {\n', '        require(from == ownerOf[tokenId], "!owner");\n', '        balanceOf[from]--; \n', '        balanceOf[to]++; \n', '        getApproved[tokenId] = address(0); // reset spender approval\n', '        ownerOf[tokenId] = to; \n', '        sale[tokenId].buyer = address(0); // reset buyer address\n', '        sale[tokenId].price = 0; // reset sale price\n', '        emit Transfer(from, to, tokenId); \n', '    }\n', '    \n', '    /***************\n', '    PUBLIC FUNCTIONS\n', '    ***************/\n', '    // **********\n', '    // TOKEN MINT\n', '    // **********\n', '    receive() external payable {\n', '        _mint(msg.sender); \n', '    }\n', '    \n', '    function mintLLC(address to) external payable {\n', '        _mint(to);\n', '    }\n', '    \n', '    function mintLLCbatch(address[] calldata to) external payable {\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            _mint(to[i]); \n', '        }\n', '    }\n', '    \n', '    // **********\n', '    // TOKEN MGMT\n', '    // **********\n', '    function approve(address spender, uint256 tokenId) external {\n', '        address owner = ownerOf[tokenId];\n', '        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "!owner/operator");\n', '        getApproved[tokenId] = spender;\n', '        emit Approval(msg.sender, spender, tokenId); \n', '    }\n', '    \n', '    function setApprovalForAll(address operator, bool approved) external {\n', '        isApprovedForAll[msg.sender][operator] = approved;\n', '        emit ApprovalForAll(msg.sender, operator, approved);\n', '    }\n', '    \n', '    function transfer(address to, uint256 tokenId) external returns (bool) { // erc20-formatted transfer\n', '        _transfer(msg.sender, to, tokenId);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 tokenId) external {\n', '        require(msg.sender == from || getApproved[tokenId] == msg.sender || isApprovedForAll[from][msg.sender], "!owner/spender/operator");\n', '        _transfer(from, to, tokenId);\n', '    }\n', '    \n', '    function transferFromBatch(address[] calldata from, address[] calldata to, uint256[] calldata tokenId) external {\n', '        require(from.length == to.length && to.length == tokenId.length, "!from/to/tokenId");\n', '        for (uint256 i = 0; i < from.length; i++) {\n', '            require(msg.sender == from[i] || getApproved[tokenId[i]] == msg.sender || isApprovedForAll[from[i]][msg.sender], "!owner/spender/operator");\n', '            _transfer(from[i], to[i], tokenId[i]);\n', '        }\n', '    }\n', '    \n', '    function updateTokenDetails(uint256 tokenId, string calldata details) external {\n', '        require(msg.sender == ownerOf[tokenId], "!owner");\n', '        tokenDetails[tokenId] = details;\n', '        emit UpdateTokenDetails(tokenId, details);\n', '    }\n', '    \n', '    // **********\n', '    // TOKEN SALE\n', '    // **********\n', '    function purchase(uint256 tokenId) external payable {\n', '        if (sale[tokenId].buyer != address(0)) { // if buyer is preset, require caller match\n', '            require(msg.sender == sale[tokenId].buyer, "!buyer");\n', '        }\n', '        uint256 price = sale[tokenId].price;\n', '        require(price > 0, "!forSale"); // token price must be non-zero to be considered \'for sale\'\n', '        require(msg.value == price, "!price");\n', '        address owner = ownerOf[tokenId];\n', '        (bool success, ) = owner.call{value: msg.value}("");\n', '        require(success, "!ethCall");\n', '        balanceOf[owner]--; \n', '        balanceOf[msg.sender]++; \n', '        getApproved[tokenId] = address(0); // reset spender approval\n', '        ownerOf[tokenId] = msg.sender;\n', '        sale[tokenId].buyer = address(0); // reset buyer address\n', '        sale[tokenId].price = 0; // reset sale price\n', '        emit Transfer(owner, msg.sender, tokenId); \n', '    }\n', '    \n', '    function setSale(address buyer, uint256 price, uint256 tokenId) external {\n', '        require(msg.sender == ownerOf[tokenId], "!owner");\n', '        sale[tokenId].buyer = buyer; // set buyer address\n', '        sale[tokenId].price = price; // set sale price\n', '        emit SetSale(buyer, price, tokenId);\n', '    }\n', '    \n', '    /*******************\n', '    GOVERNANCE FUNCTIONS\n', '    *******************/\n', '    modifier onlyGovernance {\n', '        require(msg.sender == governance, "!governance");\n', '        _;\n', '    }\n', '\n', '    function govTransferFrom(address from, address to, uint256 tokenId) external onlyGovernance {\n', '        _transfer(from, to, tokenId);\n', '    }\n', '    \n', '    function govTransferFromBatch(address[] calldata from, address[] calldata to, uint256[] calldata tokenId) external onlyGovernance {\n', '        require(from.length == to.length && to.length == tokenId.length, "!from/to/tokenId");\n', '        for (uint256 i = 0; i < from.length; i++) {\n', '            _transfer(from[i], to[i], tokenId[i]);\n', '        }\n', '    }\n', '    \n', '    function govTribute(string calldata details) external payable {\n', '        emit GovTribute(msg.sender, msg.value, details);\n', '    }\n', '    \n', '    function govUpdateSettings(address payable _governance, string calldata _commonURI, string calldata _masterOperatingAgreement) external onlyGovernance {\n', '        governance = _governance;\n', '        commonURI = _commonURI;\n', '        masterOperatingAgreement = _masterOperatingAgreement;\n', '        emit GovUpdateSettings(_governance, _commonURI, _masterOperatingAgreement);\n', '    }\n', '    \n', '    function govUpdateTokenURI(uint256 tokenId, string calldata _tokenURI) external onlyGovernance {\n', '        require(tokenId <= totalSupply, "!exist");\n', '        tokenURI[tokenId] = _tokenURI;\n', '        emit GovUpdateTokenURI(tokenId, _tokenURI);\n', '    }\n', '    \n', '    function govUpdateTokenURIbatch(uint256[] calldata tokenId, string[] calldata _tokenURI) external onlyGovernance {\n', '        require(tokenId.length == _tokenURI.length, "!tokenId/_tokenURI");\n', '        for (uint256 i = 0; i < tokenId.length; i++) {\n', '            require(tokenId[i] <= totalSupply, "!exist");\n', '            tokenURI[tokenId[i]] = _tokenURI[i];\n', '            emit GovUpdateTokenURI(tokenId[i], _tokenURI[i]);\n', '        }\n', '    }\n', '    \n', '    function govWithdrawETH() external onlyGovernance {\n', '        (bool success, ) = msg.sender.call{value: address(this).balance}("");\n', '        require(success, "!ethCall");\n', '    }\n', '}']