['/**\n', ' *Submitted for verification at Etherscan.io on 2021-01-31\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', 'New808token ERC20 contract\n', 'Symbol        : T808\n', 'Name          : New808token\n', 'Decimals      : 0\n', 'Owner Account : 0x9BDD969B35b0BA80014A9Ba771a3842883Eac1bA\n', '(c) by Didar Metu  2021. MIT Licence.\n', '*/\n', '\n', '/** Lib: Safe Math */\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '/**\n', 'ERC Token Standard #20 Interface\n', 'https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '*/\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Mint(address indexed to, uint tokens);\n', '    event Burn(address indexed from, uint tokens);\n', '}\n', '\n', '/**\n', 'Contract function to receive approval and execute function in one call\n', '*/\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '/**\n', 'ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers\n', '*/\n', 'contract New808token is ERC20Interface, SafeMath {\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    address public contract_owner;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    /** Constructor */\n', '    constructor() public {\n', '        symbol = "T808";\n', '        name = "New808token";\n', '        decimals = 0;\n', '        _totalSupply = 1000000; //1 million\n', '        contract_owner = 0x9BDD969B35b0BA80014A9Ba771a3842883Eac1bA; // didarmetu\n', '        balances[0x6c431c70ce1a5e06e171478824721c35925c6ab1] = 200000; // Lifenaked\n', '        balances[0xFd3066a5299299514E5C796D3B3fae8C744320F5] = 200000; //cunningstunt\n', '        balances[contract_owner] = 600000;\n', '        emit Transfer(address(0), contract_owner, 600000);\n', '        emit Transfer(address(0), 0x6c431c70ce1a5e06e171478824721c35925c6ab1, 200000);\n', '        emit Transfer(address(0), 0xFd3066a5299299514E5C796D3B3fae8C744320F5, 200000);\n', '    }\n', '\n', '    /** Total supply */\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '    /** Get the token balance for account tokenOwner */\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    /**\n', "    Transfer the balance from token owner's account to to account\n", "    - Owner's account must have sufficient balance to transfer\n", '    */\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "    Token owner can approve for spender to transferFrom(...) tokens from the token owner's account\n", '    */\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    Transfer tokens from the from account to the to account\n', '    The calling account must already have sufficient tokens approve(...)-d for spending from the from account and\n', '    - From account must have sufficient balance to transfer\n', '    - Spender must have sufficient allowance to transfer\n', '    */\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "    Returns the amount of tokens approved by the owner that can be transferred to the spender's account\n", '    */\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    /**\n', "    Token owner can approve for spender to transferFrom(...) tokens from the token owner's account. The spender contract function\n", '    receiveApproval(...) is then executed\n', '    */\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    Mintable ERC20\n', '    Simple ERC20 Token example, with mintable token creation\n', '    Based on code by TokenMarketNet: https://github.com/TokenMarketNet/smart-contracts/blob/master/contracts/MintableToken.sol\n', '    */\n', '    function CreateT808(address to, uint tokens) public returns (bool success) {\n', '        require(msg.sender == contract_owner);\n', '        _totalSupply = safeAdd(_totalSupply,tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(address(0), to, tokens);\n', '        emit Mint(to, tokens);\n', '        return true;\n', '    }\n', '\n', '    /** Burn Tokens */\n', '    function BurnT808(uint tokens) public returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);                           // Check if the sender has enough\n', '        balances[msg.sender] = safeSub(balances[msg.sender],tokens);       // Subtract from the sender\n', '        _totalSupply = safeSub(_totalSupply, tokens);                      // Updates totalSupply\n', '        emit Transfer(msg.sender, address(0), tokens);\n', '        emit Burn(msg.sender, tokens);\n', '        return true;\n', '    }\n', '\n', "    /** Don't accept ETH */\n", '    function () public payable {\n', '        revert();\n', '    }\n', '}']