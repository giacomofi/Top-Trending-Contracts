['pragma solidity ^0.4.24;\n', '// ----------------------------------------------------------------------------\n', '// &#39;Bitway&#39; &#39;ERC20 Token&#39;\n', '// \n', '// Name        : Bitway\n', '// Symbol      : BTWX\n', '// Max supply  : 21m\n', '// Decimals    : 18\n', '//\n', '// Bitway "BTWX"\n', '// ----------------------------------------------------------------------------\n', '//\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token Standard\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name, decimals and totalSupply\n', '// ----------------------------------------------------------------------------\n', 'contract Bitway is ERC20 {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public name = "Bitway";\n', '    string public symbol = "BTWX";\n', '    uint public totalSupply = 0;\n', '    uint8 public decimals = 18;\n', '    uint public RATE = 1000;\n', '    \n', '    uint multiplier = 10 ** uint(decimals);\n', '    uint million = 10 ** 6;\n', '    uint millionTokens = 1 * million * multiplier;\n', '    \n', '    uint constant stageTotal = 5;\n', '    uint stage = 0;\n', '    uint [stageTotal] targetSupply = [\n', '         1 * millionTokens,\n', '         2 * millionTokens,\n', '         5 * millionTokens,\n', '         10 * millionTokens,\n', '         21 * millionTokens\n', '    ];\n', '    \n', '    address public owner;\n', '    bool public completed = true;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    constructor() public {\n', '    owner = msg.sender;\n', '    supplyTokens(millionTokens);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Payable token creation\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        createTokens();\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Returns currentStage\n', '    // ------------------------------------------------------------------------\n', '    function currentStage() public constant returns (uint) {\n', '        return stage + 1;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Returns maxSupplyReached True / False\n', '    // ------------------------------------------------------------------------\n', '    function maxSupplyReached() public constant returns (bool) {\n', '        return stage >= stageTotal;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token creation\n', '    // ------------------------------------------------------------------------\n', '    function createTokens() public payable {\n', '        require(!completed);\n', '        supplyTokens(msg.value.mul((15 - stage) * RATE / 10)); \n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Complete token sale\n', '    // ------------------------------------------------------------------------\n', '    function setComplete(bool _completed) public {\n', '        require(msg.sender == owner);\n', '        completed = _completed;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Check totalSupply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return totalSupply;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Create tokens and supply to msg.sender balances\n', '    // ------------------------------------------------------------------------\n', '    function supplyTokens(uint tokens) private {\n', '        require(!maxSupplyReached());\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        totalSupply = totalSupply.add(tokens);\n', '        if (totalSupply >= targetSupply[stage]) {\n', '            stage += 1;\n', '        }\n', '        emit Transfer(address(0), msg.sender, tokens);\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}']
['pragma solidity ^0.4.24;\n', '// ----------------------------------------------------------------------------\n', "// 'Bitway' 'ERC20 Token'\n", '// \n', '// Name        : Bitway\n', '// Symbol      : BTWX\n', '// Max supply  : 21m\n', '// Decimals    : 18\n', '//\n', '// Bitway "BTWX"\n', '// ----------------------------------------------------------------------------\n', '//\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token Standard\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name, decimals and totalSupply\n', '// ----------------------------------------------------------------------------\n', 'contract Bitway is ERC20 {\n', '    \n', '    using SafeMath for uint;\n', '\n', '    string public name = "Bitway";\n', '    string public symbol = "BTWX";\n', '    uint public totalSupply = 0;\n', '    uint8 public decimals = 18;\n', '    uint public RATE = 1000;\n', '    \n', '    uint multiplier = 10 ** uint(decimals);\n', '    uint million = 10 ** 6;\n', '    uint millionTokens = 1 * million * multiplier;\n', '    \n', '    uint constant stageTotal = 5;\n', '    uint stage = 0;\n', '    uint [stageTotal] targetSupply = [\n', '         1 * millionTokens,\n', '         2 * millionTokens,\n', '         5 * millionTokens,\n', '         10 * millionTokens,\n', '         21 * millionTokens\n', '    ];\n', '    \n', '    address public owner;\n', '    bool public completed = true;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    constructor() public {\n', '    owner = msg.sender;\n', '    supplyTokens(millionTokens);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Payable token creation\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        createTokens();\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Returns currentStage\n', '    // ------------------------------------------------------------------------\n', '    function currentStage() public constant returns (uint) {\n', '        return stage + 1;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Returns maxSupplyReached True / False\n', '    // ------------------------------------------------------------------------\n', '    function maxSupplyReached() public constant returns (bool) {\n', '        return stage >= stageTotal;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token creation\n', '    // ------------------------------------------------------------------------\n', '    function createTokens() public payable {\n', '        require(!completed);\n', '        supplyTokens(msg.value.mul((15 - stage) * RATE / 10)); \n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Complete token sale\n', '    // ------------------------------------------------------------------------\n', '    function setComplete(bool _completed) public {\n', '        require(msg.sender == owner);\n', '        completed = _completed;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Check totalSupply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return totalSupply;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account\n", '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Returns the amount of tokens approved by the owner that can be transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Create tokens and supply to msg.sender balances\n', '    // ------------------------------------------------------------------------\n', '    function supplyTokens(uint tokens) private {\n', '        require(!maxSupplyReached());\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        totalSupply = totalSupply.add(tokens);\n', '        if (totalSupply >= targetSupply[stage]) {\n', '            stage += 1;\n', '        }\n', '        emit Transfer(address(0), msg.sender, tokens);\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}']
