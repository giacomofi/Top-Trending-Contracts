['/*\n', '██╗     ███████╗██╗  ██╗                    \n', '██║     ██╔════╝╚██╗██╔╝                    \n', '██║     █████╗   ╚███╔╝                     \n', '██║     ██╔══╝   ██╔██╗                     \n', '███████╗███████╗██╔╝ ██╗                    \n', '╚══════╝╚══════╝╚═╝  ╚═╝                    \n', '████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗\n', '╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║\n', '   ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║\n', '   ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║\n', '   ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║\n', '   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝\n', 'DEAR MSG.SENDER(S):\n', '/ LexToken is a project in beta.\n', '// Please audit and use at your own risk.\n', '/// Entry into LexToken shall not create an attorney/client relationship.\n', '//// Likewise, LexToken should not be construed as legal advice or replacement for professional counsel.\n', '///// STEAL THIS C0D3SL4W \n', '////// presented by LexDAO LLC\n', '*/\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.7.0;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract LexToken {\n', '    using SafeMath for uint256;\n', '    \n', "    address payable public manager; // account managing token rules & sale - see 'Manager Functions' - updateable by manager\n", '    address public resolver; // account acting as backup for lost token & arbitration of disputed token transfers - updateable by manager\n', '    uint8   public decimals; // fixed unit scaling factor - default 18 to match ETH\n', '    uint256 public saleRate; // rate of token purchase when sending ETH to contract - e.g., 10 saleRate returns 10 token per 1 ETH - updateable by manager\n', '    uint256 public totalSupply; // tracks outstanding token mint - mint updateable by manager\n', '    uint256 public totalSupplyCap; // maximum of token mintable\n', '    bytes32 public DOMAIN_SEPARATOR; // eip-2612 permit() pattern - hash identifies contract\n', '    bytes32 constant public PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"); // eip-2612 permit() pattern - hash identifies function for signature\n', '    string  public details; // details token offering, redemption, etc. - updateable by manager\n', '    string  public name; // fixed token name\n', '    string  public symbol; // fixed token symbol\n', '    bool    public forSale; // status of token sale - e.g., if `false`, ETH sent to token address will not return token per saleRate - updateable by manager\n', '    bool    private initialized; // internally tracks token deployment under eip-1167 proxy pattern\n', '    bool    public transferable; // transferability of token - does not affect token sale - updateable by manager\n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event BalanceResolution(string indexed resolution);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    mapping(address => mapping(address => uint256)) public allowances;\n', '    mapping(address => uint256) private _balanceOf;\n', '    mapping(address => uint256) public nonces;\n', '    \n', '    modifier onlyManager {\n', '        require(msg.sender == manager, "!manager");\n', '        _;\n', '    }\n', '    \n', '    function init(\n', '        address payable _manager,\n', '        address _resolver,\n', '        uint8 _decimals, \n', '        uint256 managerSupply, \n', '        uint256 _saleRate, \n', '        uint256 saleSupply, \n', '        uint256 _totalSupplyCap,\n', '        string memory _details, \n', '        string memory _name, \n', '        string memory _symbol,  \n', '        bool _forSale, \n', '        bool _transferable\n', '    ) external {\n', '        require(!initialized, "initialized"); \n', '        manager = _manager; \n', '        resolver = _resolver;\n', '        decimals = _decimals; \n', '        saleRate = _saleRate; \n', '        totalSupplyCap = _totalSupplyCap; \n', '        details = _details; \n', '        name = _name; \n', '        symbol = _symbol;  \n', '        forSale = _forSale; \n', '        initialized = true; \n', '        transferable = _transferable; \n', '        _balanceOf[address(this)] = type(uint256).max; // trick to prevent token transfer to contract itself\n', '        _mint(manager, managerSupply);\n', '        _mint(address(this), saleSupply);\n', '        // eip-2612 permit() pattern:\n', '        uint256 chainId;\n', '        assembly {chainId := chainid()}\n', '        DOMAIN_SEPARATOR = keccak256(abi.encode(\n', '            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),\n', '            keccak256(bytes(name)),\n', '            keccak256(bytes("1")),\n', '            chainId,\n', '            address(this)));\n', '    }\n', '    \n', '    receive() external payable { // SALE \n', '        require(forSale, "!forSale");\n', '        (bool success, ) = manager.call{value: msg.value}("");\n', '        require(success, "!ethCall");\n', '        uint256 value = msg.value.mul(saleRate); \n', '        _transfer(address(this), msg.sender, value);\n', '    } \n', '    \n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        allowances[owner][spender] = value; \n', '        emit Approval(owner, spender, value); \n', '    }\n', '    \n', '    function approve(address spender, uint256 value) external returns (bool) {\n', '        require(value == 0 || allowances[msg.sender][spender] == 0, "!reset"); \n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    \n', '    function balanceOf(address account) external view returns (uint256) {\n', '        return account == address(this) ? 0 : _balanceOf[account];\n', '    }\n', '\n', '    function balanceResolution(address from, address to, uint256 value, string memory resolution) external { // resolve disputed or lost balances\n', '        require(msg.sender == resolver, "!resolver"); \n', '        _transfer(from, to, value); \n', '        emit BalanceResolution(resolution);\n', '    }\n', '    \n', '    function burn(uint256 value) external {\n', '        _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(value); \n', '        totalSupply = totalSupply.sub(value); \n', '        emit Transfer(msg.sender, address(0), value);\n', '    }\n', '    \n', '    // Adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {\n', '        require(block.timestamp <= deadline, "expired");\n', '        bytes32 hashStruct = keccak256(abi.encode(\n', '                PERMIT_TYPEHASH,\n', '                owner,\n', '                spender,\n', '                value,\n', '                nonces[owner]++,\n', '                deadline));\n', '        bytes32 hash = keccak256(abi.encodePacked(\n', "                '\\x19\\x01',\n", '                DOMAIN_SEPARATOR,\n', '                hashStruct));\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require(signer != address(0) && signer == owner, "!signer");\n', '        _approve(owner, spender, value);\n', '    }\n', '    \n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        _balanceOf[from] = _balanceOf[from].sub(value); \n', '        _balanceOf[to] = _balanceOf[to].add(value); \n', '        emit Transfer(from, to, value); \n', '    }\n', '    \n', '    function transfer(address to, uint256 value) external returns (bool) {\n', '        require(transferable, "!transferable"); \n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function transferBatch(address[] memory to, uint256[] memory value) external {\n', '        require(to.length == value.length, "!to/value");\n', '        require(transferable, "!transferable");\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            _transfer(msg.sender, to[i], value[i]);\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 value) external returns (bool) {\n', '        require(transferable, "!transferable");\n', '        _approve(from, msg.sender, allowances[from][msg.sender].sub(value));\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '    /****************\n', '    MANAGER FUNCTIONS\n', '    ****************/\n', '    function _mint(address to, uint256 value) internal {\n', '        require(totalSupply.add(value) <= totalSupplyCap, "capped"); \n', '        _balanceOf[to] = _balanceOf[to].add(value); \n', '        totalSupply = totalSupply.add(value); \n', '        emit Transfer(address(0), to, value); \n', '    }\n', '    \n', '    function mint(address to, uint256 value) external onlyManager {\n', '        _mint(to, value);\n', '    }\n', '    \n', '    function mintBatch(address[] memory to, uint256[] memory value) external onlyManager {\n', '        require(to.length == value.length, "!to/value");\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            _mint(to[i], value[i]); \n', '        }\n', '    }\n', '    \n', '    function updateGovernance(address payable _manager, address _resolver, string memory _details) external onlyManager {\n', '        manager = _manager;\n', '        resolver = _resolver;\n', '        details = _details;\n', '    }\n', '\n', '    function updateSale(uint256 _saleRate, uint256 saleSupply, bool _forSale) external onlyManager {\n', '        saleRate = _saleRate;\n', '        forSale = _forSale;\n', '        _mint(address(this), saleSupply);\n', '    }\n', '    \n', '    function updateTransferability(bool _transferable) external onlyManager {\n', '        transferable = _transferable;\n', '    }\n', '}\n', '\n', '/*\n', 'The MIT License (MIT)\n', 'Copyright (c) 2018 Murray Software, LLC.\n', 'Permission is hereby granted, free of charge, to any person obtaining\n', 'a copy of this software and associated documentation files (the\n', '"Software"), to deal in the Software without restriction, including\n', 'without limitation the rights to use, copy, modify, merge, publish,\n', 'distribute, sublicense, and/or sell copies of the Software, and to\n', 'permit persons to whom the Software is furnished to do so, subject to\n', 'the following conditions:\n', 'The above copyright notice and this permission notice shall be included\n', 'in all copies or substantial portions of the Software.\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', 'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', 'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', 'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', 'contract CloneFactory {\n', '    function createClone(address payable target) internal returns (address payable result) { // eip-1167 proxy pattern adapted for payable lexToken\n', '        bytes20 targetBytes = bytes20(target);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), targetBytes)\n', '            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            result := create(0, clone, 0x37)\n', '        }\n', '    }\n', '}\n', '\n', 'interface IERC20Transfer { // brief interface for erc20 token transfer\n', '    function transfer(address recipient, uint256 value) external returns (bool);\n', '}\n', '\n', 'contract LexTokenFactory is CloneFactory {\n', '    address payable public lexDAO;\n', '    address public lexDAOtoken;\n', '    address payable immutable public template;\n', '    uint256 public userReward;\n', '    string  public details;\n', '    \n', '    event LaunchLexToken(address indexed lexToken, address indexed manager, address indexed resolver, uint256 saleRate, bool forSale);\n', '    event UpdateGovernance(address indexed lexDAO, address indexed lexDAOtoken, uint256 indexed userReward, string details);\n', '    \n', '    constructor(address payable _lexDAO, address _lexDAOtoken, address payable _template, uint256 _userReward, string memory _details) {\n', '        lexDAO = _lexDAO;\n', '        lexDAOtoken = _lexDAOtoken;\n', '        template = _template;\n', '        userReward = _userReward;\n', '        details = _details;\n', '    }\n', '    \n', '    function launchLexToken(\n', '        address payable _manager,\n', '        address _resolver,\n', '        uint8 _decimals, \n', '        uint256 managerSupply, \n', '        uint256 _saleRate, \n', '        uint256 saleSupply, \n', '        uint256 _totalSupplyCap,\n', '        string memory _details,\n', '        string memory _name, \n', '        string memory _symbol, \n', '        bool _forSale, \n', '        bool _transferable\n', '    ) external payable {\n', '        LexToken lex = LexToken(createClone(template));\n', '        \n', '        lex.init(\n', '            _manager,\n', '            _resolver,\n', '            _decimals, \n', '            managerSupply, \n', '            _saleRate, \n', '            saleSupply, \n', '            _totalSupplyCap,\n', '            _details,\n', '            _name, \n', '            _symbol, \n', '            _forSale, \n', '            _transferable);\n', '        \n', '        (bool success, ) = lexDAO.call{value: msg.value}("");\n', '        require(success, "!ethCall");\n', '        IERC20Transfer(lexDAOtoken).transfer(_manager, userReward);\n', '        emit LaunchLexToken(address(lex), _manager, _resolver, _saleRate, _forSale);\n', '    }\n', '    \n', '    function updateGovernance(address payable _lexDAO, address _lexDAOtoken, uint256 _userReward, string memory _details) external {\n', '        require(msg.sender == lexDAO, "!lexDAO");\n', '        lexDAO = _lexDAO;\n', '        lexDAOtoken = _lexDAOtoken;\n', '        userReward = _userReward;\n', '        details = _details;\n', '        emit UpdateGovernance(_lexDAO, _lexDAOtoken, _userReward, _details);\n', '    }\n', '}']