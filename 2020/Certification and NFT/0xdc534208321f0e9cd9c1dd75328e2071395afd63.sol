['/*\n', '███╗   ██╗███████╗████████╗       \n', '████╗  ██║██╔════╝╚══██╔══╝       \n', '██╔██╗ ██║█████╗     ██║          \n', '██║╚██╗██║██╔══╝     ██║          \n', '██║ ╚████║██║        ██║\n', '\n', '██╗    ██╗██████╗  █████╗ ██████╗ \n', '██║    ██║██╔══██╗██╔══██╗██╔══██╗\n', '██║ █╗ ██║██████╔╝███████║██████╔╝\n', '██║███╗██║██╔══██╗██╔══██║██╔═══╝ \n', '╚███╔███╔╝██║  ██║██║  ██║██║     \n', '*/\n', '// SPDX-License-Identifier: MIT\n', '/**\n', 'MIT License\n', 'Copyright (c) 2020 Openlaw\n', 'Permission is hereby granted, free of charge, to any person obtaining a copy\n', 'of this software and associated documentation files (the "Software"), to deal\n', 'in the Software without restriction, including without limitation the rights\n', 'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', 'copies of the Software, and to permit persons to whom the Software is\n', 'furnished to do so, subject to the following conditions:\n', 'The above copyright notice and this permission notice shall be included in all\n', 'copies or substantial portions of the Software.\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', 'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', 'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', 'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', 'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', 'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', 'SOFTWARE.\n', ' */\n', 'pragma solidity 0.7.4;\n', '\n', 'interface IERC20 { // brief interface for erc20 token\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '}\n', '\n', 'interface IERC721transferFrom { // brief interface for erc721 token (nft)\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '}\n', '\n', 'library SafeMath { // arithmetic wrapper for unit under/overflow check\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract NFTWrap { // multi NFT wrapper adapted from LexToken - https://github.com/lexDAO/LexCorpus/blob/master/contracts/token/lextoken/solidity/LexToken.sol\n', '    using SafeMath for uint256;\n', '    \n', "    address payable public manager; // account managing token rules & sale - see 'Manager Functions' - updateable by manager\n", '    address public resolver; // account acting as backup for lost token & arbitration of disputed token transfers - updateable by manager\n', '    uint8   public decimals; // fixed unit scaling factor - default 18 to match ETH\n', '    uint256 public saleRate; // rate of token purchase when sending ETH to contract - e.g., 10 saleRate returns 10 token per 1 ETH - updateable by manager\n', '    uint256 public totalSupply; // tracks outstanding token mint - mint updateable by manager\n', '    uint256 public totalSupplyCap; // maximum of token mintable\n', '    bytes32 public DOMAIN_SEPARATOR; // eip-2612 permit() pattern - hash identifies contract\n', '    bytes32 constant public PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"); // eip-2612 permit() pattern - hash identifies function for signature\n', '    string  public details; // details token offering, redemption, etc. - updateable by manager\n', '    string  public name; // fixed token name\n', '    string  public symbol; // fixed token symbol\n', '    bool    public forSale; // status of token sale - e.g., if `false`, ETH sent to token address will not return token per saleRate - updateable by manager\n', '    bool    private initialized; // internally tracks token deployment under eip-1167 proxy pattern\n', '    bool    public transferable; // transferability of token - does not affect token sale - updateable by manager\n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event BalanceResolution(string resolution);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event UpdateGovernance(address indexed manager, address indexed resolver, string details);\n', '    event UpdateSale(uint256 saleRate, bool forSale);\n', '    event UpdateTransferability(bool transferable);\n', '    \n', '    mapping(address => mapping(address => uint256)) public allowances;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => uint256) public nonces;\n', '    \n', '    modifier onlyManager {\n', '        require(msg.sender == manager, "!manager");\n', '        _;\n', '    }\n', '    \n', '    function init(\n', '        address payable _manager,\n', '        address _resolver,\n', '        uint8 _decimals, \n', '        uint256 _managerSupply,\n', '        uint256 _saleRate, \n', '        uint256 _saleSupply, \n', '        uint256 _totalSupplyCap,\n', '        string calldata _name, \n', '        string calldata _symbol,  \n', '        bool _forSale, \n', '        bool _transferable\n', '    ) external {\n', '        require(!initialized, "initialized"); \n', '        manager = _manager; \n', '        resolver = _resolver;\n', '        decimals = _decimals; \n', '        saleRate = _saleRate; \n', '        totalSupplyCap = _totalSupplyCap; \n', '        name = _name; \n', '        symbol = _symbol;  \n', '        forSale = _forSale; \n', '        initialized = true; \n', '        transferable = _transferable; \n', '        _mint(_manager, _managerSupply);\n', '        _mint(address(this), _saleSupply);\n', '        // eip-2612 permit() pattern:\n', '        uint256 chainId;\n', '        assembly {chainId := chainid()}\n', '        DOMAIN_SEPARATOR = keccak256(abi.encode(\n', '            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),\n', '            keccak256(bytes(name)),\n', '            keccak256(bytes("1")),\n', '            chainId,\n', '            address(this)));\n', '    }\n', '    \n', '    receive() external payable { // SALE \n', '        require(forSale, "!forSale");\n', '        (bool success, ) = manager.call{value: msg.value}("");\n', '        require(success, "!ethCall");\n', '        _transfer(address(this), msg.sender, msg.value.mul(saleRate));\n', '    } \n', '    \n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        allowances[owner][spender] = value; \n', '        emit Approval(owner, spender, value); \n', '    }\n', '    \n', '    function approve(address spender, uint256 value) external returns (bool) {\n', '        require(value == 0 || allowances[msg.sender][spender] == 0, "!reset"); \n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    \n', '    function balanceResolution(address from, address to, uint256 value, string calldata resolution) external { // resolve disputed or lost balances\n', '        require(msg.sender == resolver, "!resolver"); \n', '        _transfer(from, to, value); \n', '        emit BalanceResolution(resolution);\n', '    }\n', '    \n', '    function burn(uint256 value) external {\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(value); \n', '        totalSupply = totalSupply.sub(value); \n', '        emit Transfer(msg.sender, address(0), value);\n', '    }\n', '    \n', '    // Adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {\n', '        require(block.timestamp <= deadline, "expired");\n', '        bytes32 hashStruct = keccak256(abi.encode(\n', '                PERMIT_TYPEHASH,\n', '                owner,\n', '                spender,\n', '                value,\n', '                nonces[owner]++,\n', '                deadline));\n', '        bytes32 hash = keccak256(abi.encodePacked(\n', "                '\\x19\\x01',\n", '                DOMAIN_SEPARATOR,\n', '                hashStruct));\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require(signer != address(0) && signer == owner, "!signer");\n', '        _approve(owner, spender, value);\n', '    }\n', '    \n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        balanceOf[from] = balanceOf[from].sub(value); \n', '        balanceOf[to] = balanceOf[to].add(value); \n', '        emit Transfer(from, to, value); \n', '    }\n', '    \n', '    function transfer(address to, uint256 value) external returns (bool) {\n', '        require(transferable, "!transferable"); \n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function transferBatch(address[] calldata to, uint256[] calldata value) external {\n', '        require(to.length == value.length, "!to/value");\n', '        require(transferable, "!transferable");\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            _transfer(msg.sender, to[i], value[i]);\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 value) external returns (bool) {\n', '        require(transferable, "!transferable");\n', '        _approve(from, msg.sender, allowances[from][msg.sender].sub(value));\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '    /****************\n', '    MANAGER FUNCTIONS\n', '    ****************/\n', '    function _mint(address to, uint256 value) internal {\n', '        require(totalSupply.add(value) <= totalSupplyCap, "capped"); \n', '        balanceOf[to] = balanceOf[to].add(value); \n', '        totalSupply = totalSupply.add(value); \n', '        emit Transfer(address(0), to, value); \n', '    }\n', '    \n', '    function mint(address to, uint256 value) external onlyManager {\n', '        _mint(to, value);\n', '    }\n', '    \n', '    function mintBatch(address[] calldata to, uint256[] calldata value) external onlyManager {\n', '        require(to.length == value.length, "!to/value");\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            _mint(to[i], value[i]); \n', '        }\n', '    }\n', '    \n', '    function updateGovernance(address payable _manager, address _resolver, string calldata _details) external onlyManager {\n', '        manager = _manager;\n', '        resolver = _resolver;\n', '        details = _details;\n', '        emit UpdateGovernance(_manager, _resolver, _details);\n', '    }\n', '\n', '    function updateSale(uint256 _saleRate, uint256 _saleSupply, bool _forSale) external onlyManager {\n', '        saleRate = _saleRate;\n', '        forSale = _forSale;\n', '        _mint(address(this), _saleSupply);\n', '        emit UpdateSale(_saleRate, _forSale);\n', '    }\n', '    \n', '    function updateTransferability(bool _transferable) external onlyManager {\n', '        transferable = _transferable;\n', '        emit UpdateTransferability(_transferable);\n', '    }\n', '    \n', '    function withdrawNFT(address[] calldata nft, address[] calldata withrawTo, uint256[] calldata tokenId) external onlyManager { // withdraw NFT sent to contract\n', '        require(nft.length == withrawTo.length && nft.length == tokenId.length, "!nft/withdrawTo/tokenId");\n', '        for (uint256 i = 0; i < nft.length; i++) {\n', '            IERC721transferFrom(nft[i]).transferFrom(address(this), withrawTo[i], tokenId[i]);\n', '        }\n', '    }\n', '    \n', '    function withdrawToken(address[] calldata token, address[] calldata withrawTo, uint256[] calldata value, bool max) external onlyManager { // withdraw token sent to contract\n', '        require(token.length == withrawTo.length && token.length == value.length, "!token/withdrawTo/value");\n', '        for (uint256 i = 0; i < token.length; i++) {\n', '            uint256 withdrawalValue = value[i];\n', '            if (max) {withdrawalValue = IERC20(token[i]).balanceOf(address(this));}\n', '            IERC20(token[i]).transfer(withrawTo[i], withdrawalValue);\n', '        }\n', '    }\n', '}\n', '\n', '/*\n', 'The MIT License (MIT)\n', 'Copyright (c) 2018 Murray Software, LLC.\n', 'Permission is hereby granted, free of charge, to any person obtaining\n', 'a copy of this software and associated documentation files (the\n', '"Software"), to deal in the Software without restriction, including\n', 'without limitation the rights to use, copy, modify, merge, publish,\n', 'distribute, sublicense, and/or sell copies of the Software, and to\n', 'permit persons to whom the Software is furnished to do so, subject to\n', 'the following conditions:\n', 'The above copyright notice and this permission notice shall be included\n', 'in all copies or substantial portions of the Software.\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', 'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', 'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', 'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', 'contract CloneFactory {\n', '    function createClone(address payable target) internal returns (address payable result) { // eip-1167 proxy pattern adapted for payable contract\n', '        bytes20 targetBytes = bytes20(target);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), targetBytes)\n', '            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            result := create(0, clone, 0x37)\n', '        }\n', '    }\n', '}\n', '\n', 'contract NFTWrapper is CloneFactory {\n', '    address payable immutable public template;\n', '    string  public details;\n', '    \n', '    event WrapNFT(address indexed manager, address indexed resolver, address indexed wrap, uint256 saleRate, bool forSale);\n', '    \n', '    constructor(address payable _template, string memory _details) {\n', '        template = _template;\n', '        details = _details;\n', '    }\n', '    \n', '    function wrapNFT(\n', '        address payable _manager,\n', '        address[] memory _nftToWrap,\n', '        address _resolver,\n', '        uint8 _decimals, \n', '        uint256 _managerSupply, \n', '        uint256[] memory _nftToWrapId,\n', '        uint256 _saleRate, \n', '        uint256 _saleSupply, \n', '        uint256 _totalSupplyCap,\n', '        string memory _name, \n', '        string memory _symbol, \n', '        bool _forSale, \n', '        bool _transferable\n', '    ) public {\n', '        require(_nftToWrap.length == _nftToWrapId.length, "!_nftToWrap/_nftToWrapId");\n', '        \n', '        NFTWrap wrap = NFTWrap(createClone(template));\n', '\n', '        wrap.init(\n', '            _manager,\n', '            _resolver,\n', '            _decimals, \n', '            _managerSupply,\n', '            _saleRate, \n', '            _saleSupply, \n', '            _totalSupplyCap,\n', '            _name, \n', '            _symbol, \n', '            _forSale, \n', '            _transferable);\n', '        \n', '        for (uint256 i = 0; i < _nftToWrap.length; i++) {\n', '            IERC721transferFrom(_nftToWrap[i]).transferFrom(msg.sender, address(wrap), _nftToWrapId[i]);\n', '        }\n', '        \n', '        emit WrapNFT(_manager, _resolver, address(wrap), _saleRate, _forSale);\n', '    }\n', '}']