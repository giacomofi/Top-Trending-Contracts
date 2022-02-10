['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-16\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '//\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    \n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe Math Library\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a); c = a - b; \n', '    } \n', '    function safeMul(uint a, uint b) public pure returns (uint c) { \n', '        c = a * b; require(a == 0 || c / a == b); \n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) { \n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// AddOns: Minting, Burning, DisableBurning, DisableMinting, Roles, Token Retrieval\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Extras { \n', '    \n', '    function Mint(address to, uint _mintage) public returns (bool success);\n', '    function Burn(address from, uint _burnage) public returns (bool success);\n', '    function DisableMinting() public returns (bool success);\n', '    function DisableBurning() public returns (bool success);\n', '    function SetSafety(uint8 position, address from) public returns (bool success);\n', '    function GetSafetyStatus() public view returns (uint _safety);\n', '    function GetMintingStatus() public view returns (bool _mintingstatus);\n', '    function GetBurningStatus() public view returns (bool _burningstatus);\n', '    \n', '    function addAdmin(address manager) public returns (bool success);\n', '    function RemoveAdmin(address newadmin) public returns (bool success);\n', '    function GetRole(address user) public view returns(string memory);\n', '    \n', '// To retrieve native tokens accidentally sent to the contract and send them somewhere. \n', '    function RetrieveTokens(address to, uint amount) public returns (bool success);\n', '    function GetTokenBalance() public view returns (uint balance);\n', '    \n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '//Ether Transfers, for managing Ether sent to the contract directly or accidentally\n', '// ----------------------------------------------------------------------------\n', '   \n', 'contract EtherTransactions {\n', '     function () payable external {} \n', '     function sendEther(address payable recipient, uint256 amount) public returns (bool success);\n', '     function getBalance() public view returns (uint);\n', '}\n', '\n', '\n', 'contract SailtheStars is ERC20Interface, SafeMath, Extras, EtherTransactions {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals; \n', '    bool MintingAllowed = true;\n', '    bool BurningAllowed = true;\n', '    uint SafetyKey = 1;\n', '    uint256 public _totalSupply;\n', '    \n', '    address public _sailthestars;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    mapping(address => bool) admins;\n', '     \n', '    constructor() public {\n', '        name = "SAIL";\n', '        symbol = "SAIL";\n', '        decimals = 18;\n', '        _totalSupply = 8888888000000000000000000;\n', '        _sailthestars = msg.sender;\n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '    \n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    \n', ' \n', '// ----------------------------------------------------------------------------\n', '// Minting and Burning additional tokens, \n', '// only operable while MintingAllowed and BurningAllowed are true\n', '// ----------------------------------------------------------------------------   \n', '    \n', '    \n', '    function Mint(address to, uint _mintage) public returns (bool success)\n', '    {\n', '        require(MintingAllowed == true);\n', '        require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '        _totalSupply = safeAdd(_totalSupply, _mintage);\n', '        balances[to] = safeAdd(balances[to], _mintage);\n', '        emit Transfer(address(0), to, _mintage);\n', '        return true;\n', '     }\n', '     \n', '     function Burn(address from, uint _burnage) public returns (bool success)\n', '    {\n', '        require(BurningAllowed == true);\n', '        require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '        _totalSupply = safeSub(_totalSupply, _burnage);\n', '        balances[from] = safeSub(balances[from], _burnage);\n', '        emit Transfer(from, address(0), _burnage);\n', '        return true;\n', '    }\n', '   \n', '// ----------------------------------------------------------------------------\n', '// Permnanantly disable minting or burning\n', '// operations cannot be reversed\n', '// ----------------------------------------------------------------------------   \n', '\n', '     function DisableMinting() public returns (bool success)\n', '    {\n', '        require(SafetyKey == 0);\n', '        require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '        \n', '        MintingAllowed = false;\n', '        SafetyKey=1;\n', '        return true;\n', '    }\n', '    \n', '    function DisableBurning() public returns (bool success)\n', '    {\n', '        require(SafetyKey == 0);\n', '        require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '        BurningAllowed = false;\n', '        SafetyKey=1;\n', '        return true;\n', '    }\n', '    \n', '   \n', '// ----------------------------------------------------------------------------\n', '// Enables/Disables/Reports Safety Key which allows access to DisableMinting()/DisableBurning()\n', '// This is to prevent the accidental calling of these functions with major consequences.\n', '// ----------------------------------------------------------------------------   \n', '    \n', '     function SetSafety(uint8 position, address from) public returns (bool success)\n', '    {\n', '        require(msg.sender == from);\n', '        require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '        \n', '        SafetyKey = position;\n', '        return true;\n', '        \n', '    }\n', '    \n', '// ----------------------------------------------------------------------------\n', '// Functins for Get Minting / Burning Status\n', '// ----------------------------------------------------------------------------   \n', '\n', '     function GetSafetyStatus() public view returns (uint _safety)\n', '    {\n', '        return SafetyKey;\n', '    }\n', '    \n', '     function GetMintingStatus() public view returns (bool _mintingstatus)\n', '    {\n', '        return MintingAllowed;\n', '    }\n', '    \n', '    function GetBurningStatus() public view returns (bool _burningstatus)\n', '    {\n', '        return BurningAllowed;\n', '    }\n', '    \n', '// ----------------------------------------------------------------------------\n', '// Functions for adding admins and managers\n', '// ----------------------------------------------------------------------------       \n', '    \n', '    \n', '     function addAdmin(address newadmin) public returns (bool success) {\n', '       require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '       admins[newadmin] = true;\n', '       return true;\n', '    }\n', '    \n', '     function RemoveAdmin(address newadmin) public returns (bool success) {\n', '       require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '       admins[newadmin] = false;\n', '       return true; \n', '    }\n', '    \n', '    function GetRole(address user) public view returns(string memory) { \n', '       if(user == _sailthestars) { return "User is Sail the Stars"; }\n', '       if(admins[user]==true) { return "User is an admin."; }\n', '       if(admins[user]==false) { return "User has no permissions."; }\n', '    }\n', '    \n', '// ----------------------------------------------------------------------------\n', '// For sending Ether accidentally sent to the contract\n', '// ----------------------------------------------------------------------------          \n', '    \n', '    function getBalance() public view returns (uint)\n', '     {\n', '        return address(this).balance;\n', '     }\n', '     \n', '    function sendEther(address payable recipient, uint256 amount) public returns (bool success) {\n', '        require(msg.sender == _sailthestars || admins[msg.sender] == true);\n', '        recipient.transfer(amount);\n', '        return true;\n', '    }\n', '    \n', '// ----------------------------------------------------------------------------\n', '// For retrieving Tokens accidentally sent to the contract\n', '// ----------------------------------------------------------------------------    \n', '    \n', '    function GetTokenBalance() public view returns (uint balance) {\n', '        return balances[address(this)];\n', '    }\n', '    \n', '    function RetrieveTokens(address to, uint amount) public returns (bool success) {\n', '        require(msg.sender == _sailthestars || admins[msg.sender] == true); \n', '        require(to != address(this));\n', '        balances[address(this)] = safeSub(balances[address(this)], amount);\n', '        balances[to] = safeAdd(balances[to], amount);\n', '        return true; \n', '    }\n', '\n', '    \n', '}']