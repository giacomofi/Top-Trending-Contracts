['pragma solidity ^0.4.24;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) public pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) public pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    require(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) public pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract FNX is ERC20Interface, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\taddress public owner;\n', '\t\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\tmapping(address => uint256) freezes;\n', '\t\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    constructor(uint initialSupply, string tokenName,\n', '                uint8 decimalUnits, string tokenSymbol) public {\n', '        symbol = tokenSymbol;\n', '        name = tokenName;\n', '        decimals = decimalUnits;\n', '        _totalSupply = initialSupply;\n', '\t\towner = msg.sender;\n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '    \n', '    function freezeOf(address _tokenOwner) public constant returns (uint) {\n', '        return freezes[_tokenOwner];\n', '    }\n', '    \n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _tokenOwner) public constant returns (uint balance) {\n', '        return balances[_tokenOwner];\n', '    }\n', '\n', '    function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_tokenOwner][_spender];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));\n', '\t\trequire(tokens > 0);\n', '        require(balances[msg.sender] >= tokens);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '\t\trequire(tokens > 0); \n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));                                      // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\trequire(tokens > 0); \n', '        require(balances[from] >= tokens);                              // Check if the sender has enough\n', '        require(allowed[from][msg.sender] >= tokens);                   // Check allowance\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);                   // Updates balance\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '\tfunction freeze(uint256 tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);                        // Check if the sender has enough\n', '\t\trequire(tokens > 0); \n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender\n', '        freezes[msg.sender] = safeAdd(freezes[msg.sender], tokens);     // Updates freeze\n', '        emit Freeze(msg.sender, tokens);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);                        // Check if the sender has enough\n', '\t\trequire(tokens > 0); \n', '        freezes[msg.sender] = safeSub(freezes[msg.sender], tokens);     // Subtract from the sender\n', '\t\tbalances[msg.sender] = safeAdd(balances[msg.sender], tokens);   // Updates balance\n', '        emit Unfreeze(msg.sender, tokens);\n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);                        // Check if the sender has enough\n', '\t\trequire(tokens > 0); \n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender\n', '        _totalSupply = safeSub(_totalSupply, tokens);                   // Updates totalSupply\n', '        emit Burn(msg.sender, tokens);\n', '        return true;\n', '    }\n', '\n', '\tfunction() public payable {\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) public pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) public pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    require(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) public pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract FNX is ERC20Interface, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\taddress public owner;\n', '\t\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\tmapping(address => uint256) freezes;\n', '\t\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    constructor(uint initialSupply, string tokenName,\n', '                uint8 decimalUnits, string tokenSymbol) public {\n', '        symbol = tokenSymbol;\n', '        name = tokenName;\n', '        decimals = decimalUnits;\n', '        _totalSupply = initialSupply;\n', '\t\towner = msg.sender;\n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '    \n', '    function freezeOf(address _tokenOwner) public constant returns (uint) {\n', '        return freezes[_tokenOwner];\n', '    }\n', '    \n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _tokenOwner) public constant returns (uint balance) {\n', '        return balances[_tokenOwner];\n', '    }\n', '\n', '    function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_tokenOwner][_spender];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));\n', '\t\trequire(tokens > 0);\n', '        require(balances[msg.sender] >= tokens);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '\t\trequire(tokens > 0); \n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(to != address(0));                                      // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\trequire(tokens > 0); \n', '        require(balances[from] >= tokens);                              // Check if the sender has enough\n', '        require(allowed[from][msg.sender] >= tokens);                   // Check allowance\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);                   // Updates balance\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '\tfunction freeze(uint256 tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);                        // Check if the sender has enough\n', '\t\trequire(tokens > 0); \n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender\n', '        freezes[msg.sender] = safeAdd(freezes[msg.sender], tokens);     // Updates freeze\n', '        emit Freeze(msg.sender, tokens);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);                        // Check if the sender has enough\n', '\t\trequire(tokens > 0); \n', '        freezes[msg.sender] = safeSub(freezes[msg.sender], tokens);     // Subtract from the sender\n', '\t\tbalances[msg.sender] = safeAdd(balances[msg.sender], tokens);   // Updates balance\n', '        emit Unfreeze(msg.sender, tokens);\n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);                        // Check if the sender has enough\n', '\t\trequire(tokens > 0); \n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender\n', '        _totalSupply = safeSub(_totalSupply, tokens);                   // Updates totalSupply\n', '        emit Burn(msg.sender, tokens);\n', '        return true;\n', '    }\n', '\n', '\tfunction() public payable {\n', '        revert();\n', '    }\n', '}']