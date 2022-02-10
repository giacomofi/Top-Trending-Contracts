['pragma solidity ^0.4.17;\n', '\n', '// ----------------------------------------------------------------------------\n', '// FIXED ERCX token contract\n', '//\n', '// Symbol      : ERCX\n', '// Name        : Edel Rosten Coin\n', '// Total supply: 122,000,000\n', '// Decimals    : 18\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe math\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERCX Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERCX20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERCX20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract EdelRostenCoin is ERCX20Interface {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    address public owner;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function EdelRostenCoin() public {\n', '        symbol = "ERCX";\n', '        name = "Edel Rosten Coin";\n', '        decimals = 18;\n', '        _totalSupply = 122000000 * 10**uint(decimals);\n', '        owner = 0xDeE7D782Fa2645070e3c15CabF8324A0ccceAC78;\n', '        balances[owner] = _totalSupply;\n', '        Transfer(address(0), owner, _totalSupply);\n', '    }\n', '    \n', '    function() public payable {\n', '        revert();\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        if(balances[msg.sender] >= tokens && tokens > 0 && to!=address(0)) {\n', '            balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            Transfer(msg.sender, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        if(tokens > 0 && spender != address(0)) {\n', '            allowed[msg.sender][spender] = tokens;\n', '            Approval(msg.sender, spender, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {\n', '            balances[from] = balances[from].sub(tokens);\n', '            allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            Transfer(from, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.17;\n', '\n', '// ----------------------------------------------------------------------------\n', '// FIXED ERCX token contract\n', '//\n', '// Symbol      : ERCX\n', '// Name        : Edel Rosten Coin\n', '// Total supply: 122,000,000\n', '// Decimals    : 18\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe math\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERCX Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERCX20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERCX20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract EdelRostenCoin is ERCX20Interface {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    address public owner;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function EdelRostenCoin() public {\n', '        symbol = "ERCX";\n', '        name = "Edel Rosten Coin";\n', '        decimals = 18;\n', '        _totalSupply = 122000000 * 10**uint(decimals);\n', '        owner = 0xDeE7D782Fa2645070e3c15CabF8324A0ccceAC78;\n', '        balances[owner] = _totalSupply;\n', '        Transfer(address(0), owner, _totalSupply);\n', '    }\n', '    \n', '    function() public payable {\n', '        revert();\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        if(balances[msg.sender] >= tokens && tokens > 0 && to!=address(0)) {\n', '            balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            Transfer(msg.sender, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        if(tokens > 0 && spender != address(0)) {\n', '            allowed[msg.sender][spender] = tokens;\n', '            Approval(msg.sender, spender, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {\n', '            balances[from] = balances[from].sub(tokens);\n', '            allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '            balances[to] = balances[to].add(tokens);\n', '            Transfer(from, to, tokens);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '}']
