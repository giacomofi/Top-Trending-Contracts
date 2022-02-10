['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '    \n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '  \n', '}\n', 'contract CPX is SafeMath{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '\taddress public owner;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\tmapping (address => uint256) public freezeOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount frozen */\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount unfrozen */\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function CPX(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        address holder)  public{\n', '        totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply\n', '        balanceOf[holder] = totalSupply;                       // Give the creator all initial tokens\n', '        name = tokenName;                                      // Set the name for display purposes\n', '        symbol = tokenSymbol;                                  // Set the symbol for display purposes\n', '\t\towner = holder;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public{\n', '        require(_to != 0x0);  // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\trequire(_value > 0); \n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '\t\trequire(_value > 0); \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\trequire(_value > 0); \n', '        require(balanceOf[_from] >= _value);                 // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough\n', '\t\trequire(_value > 0); \n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction freeze(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough\n', '\t\trequire(_value > 0); \n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply\n', '        Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 _value) public returns (bool success) {\n', '        require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough\n', '\t\trequire(_value > 0); \n', '        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender\n', '\t\tbalanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);\n', '        Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '}']