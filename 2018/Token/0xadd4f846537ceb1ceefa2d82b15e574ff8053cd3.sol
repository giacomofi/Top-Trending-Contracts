['pragma solidity 0.4.21;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '  }\n', '\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '  \n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    function burn(uint256 tokens) public returns (bool success);\n', '    function freeze(uint256 tokens) public returns (bool success);\n', '    function unfreeze(uint256 tokens) public returns (bool success);\n', '\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    \n', '    /* This approve the allowance for the spender  */\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    \n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 tokens);\n', '    \n', '    /* This notifies clients about the amount frozen */\n', '    event Freeze(address indexed from, uint256 tokens);\n', '\t\n', '    /* This notifies clients about the amount unfrozen */\n', '    event Unfreeze(address indexed from, uint256 tokens);\n', ' }\n', ' \n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial CTC supply\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract WILLTOKEN is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public _totalSupply;\n', '    address public owner;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping (address => uint256) public freezeOf;\n', '    \n', ' \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function WILLTOKEN (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) public {\n', '\t\n', '        decimals = decimalUnits;\t\t\t\t// Amount of decimals for display purposes\n', '        _totalSupply = initialSupply * 10**uint(decimals);      // Update total supply\n', '        name = tokenName;                                       // Set the name for display purposes\n', '        symbol = tokenSymbol;                                   // Set the symbol for display purpose\n', '        owner = msg.sender;                                     // Set the creator as owner\n', '        balances[owner] = _totalSupply;                         // Give the creator all initial tokens\n', '\t\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require( tokens > 0 && to != 0x0 );\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md \n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public onlyOwner returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require( tokens > 0 && to != 0x0 && from != 0x0 );\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Burns the amount of tokens by the owner\n', '    // ------------------------------------------------------------------------\n', '    function burn(uint256 tokens) public  onlyOwner returns (bool success) {\n', '       require (balances[msg.sender] >= tokens) ;                        // Check if the sender has enough\n', '       require (tokens > 0) ; \n', '       balances[msg.sender] = balances[msg.sender].sub(tokens);         // Subtract from the sender\n', '       _totalSupply = _totalSupply.sub(tokens);                         // Updates totalSupply\n', '       emit Burn(msg.sender, tokens);\n', '       return true;\n', '    }\n', '\t\n', '    // ------------------------------------------------------------------------\n', '    // Freeze the amount of tokens by the owner\n', '    // ------------------------------------------------------------------------\n', '    function freeze(uint256 tokens) public onlyOwner returns (bool success) {\n', '       require (balances[msg.sender] >= tokens) ;                   // Check if the sender has enough\n', '       require (tokens > 0) ; \n', '       balances[msg.sender] = balances[msg.sender].sub(tokens);    // Subtract from the sender\n', '       freezeOf[msg.sender] = freezeOf[msg.sender].add(tokens);     // Updates totalSupply\n', '       emit Freeze(msg.sender, tokens);\n', '       return true;\n', '    }\n', '\t\n', '    // ------------------------------------------------------------------------\n', '    // Unfreeze the amount of tokens by the owner\n', '    // ------------------------------------------------------------------------\n', '    function unfreeze(uint256 tokens) public onlyOwner returns (bool success) {\n', '       require (freezeOf[msg.sender] >= tokens) ;                    // Check if the sender has enough\n', '       require (tokens > 0) ; \n', '       freezeOf[msg.sender] = freezeOf[msg.sender].sub(tokens);    // Subtract from the sender\n', '       balances[msg.sender] = balances[msg.sender].add(tokens);\n', '       emit Unfreeze(msg.sender, tokens);\n', '       return true;\n', '    }\n', '\n', '\n', '   // ------------------------------------------------------------------------\n', '   // Don&#39;t accept ETH\n', '   // ------------------------------------------------------------------------\n', '   function () public payable {\n', '      revert();\n', '   }\n', '\n', '}']
['pragma solidity 0.4.21;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '  }\n', '\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '  \n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    function burn(uint256 tokens) public returns (bool success);\n', '    function freeze(uint256 tokens) public returns (bool success);\n', '    function unfreeze(uint256 tokens) public returns (bool success);\n', '\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    \n', '    /* This approve the allowance for the spender  */\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    \n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 tokens);\n', '    \n', '    /* This notifies clients about the amount frozen */\n', '    event Freeze(address indexed from, uint256 tokens);\n', '\t\n', '    /* This notifies clients about the amount unfrozen */\n', '    event Unfreeze(address indexed from, uint256 tokens);\n', ' }\n', ' \n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial CTC supply\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract WILLTOKEN is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public _totalSupply;\n', '    address public owner;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping (address => uint256) public freezeOf;\n', '    \n', ' \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function WILLTOKEN (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) public {\n', '\t\n', '        decimals = decimalUnits;\t\t\t\t// Amount of decimals for display purposes\n', '        _totalSupply = initialSupply * 10**uint(decimals);      // Update total supply\n', '        name = tokenName;                                       // Set the name for display purposes\n', '        symbol = tokenSymbol;                                   // Set the symbol for display purpose\n', '        owner = msg.sender;                                     // Set the creator as owner\n', '        balances[owner] = _totalSupply;                         // Give the creator all initial tokens\n', '\t\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require( tokens > 0 && to != 0x0 );\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md \n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public onlyOwner returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require( tokens > 0 && to != 0x0 && from != 0x0 );\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Burns the amount of tokens by the owner\n', '    // ------------------------------------------------------------------------\n', '    function burn(uint256 tokens) public  onlyOwner returns (bool success) {\n', '       require (balances[msg.sender] >= tokens) ;                        // Check if the sender has enough\n', '       require (tokens > 0) ; \n', '       balances[msg.sender] = balances[msg.sender].sub(tokens);         // Subtract from the sender\n', '       _totalSupply = _totalSupply.sub(tokens);                         // Updates totalSupply\n', '       emit Burn(msg.sender, tokens);\n', '       return true;\n', '    }\n', '\t\n', '    // ------------------------------------------------------------------------\n', '    // Freeze the amount of tokens by the owner\n', '    // ------------------------------------------------------------------------\n', '    function freeze(uint256 tokens) public onlyOwner returns (bool success) {\n', '       require (balances[msg.sender] >= tokens) ;                   // Check if the sender has enough\n', '       require (tokens > 0) ; \n', '       balances[msg.sender] = balances[msg.sender].sub(tokens);    // Subtract from the sender\n', '       freezeOf[msg.sender] = freezeOf[msg.sender].add(tokens);     // Updates totalSupply\n', '       emit Freeze(msg.sender, tokens);\n', '       return true;\n', '    }\n', '\t\n', '    // ------------------------------------------------------------------------\n', '    // Unfreeze the amount of tokens by the owner\n', '    // ------------------------------------------------------------------------\n', '    function unfreeze(uint256 tokens) public onlyOwner returns (bool success) {\n', '       require (freezeOf[msg.sender] >= tokens) ;                    // Check if the sender has enough\n', '       require (tokens > 0) ; \n', '       freezeOf[msg.sender] = freezeOf[msg.sender].sub(tokens);    // Subtract from the sender\n', '       balances[msg.sender] = balances[msg.sender].add(tokens);\n', '       emit Unfreeze(msg.sender, tokens);\n', '       return true;\n', '    }\n', '\n', '\n', '   // ------------------------------------------------------------------------\n', "   // Don't accept ETH\n", '   // ------------------------------------------------------------------------\n', '   function () public payable {\n', '      revert();\n', '   }\n', '\n', '}']
