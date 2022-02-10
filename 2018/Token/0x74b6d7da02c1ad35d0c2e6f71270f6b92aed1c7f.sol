['pragma solidity ^0.4.8;\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      revert();\n', '    }\n', '  }\n', '}\n', 'contract QRLT is SafeMath{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\taddress public owner;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() public {\n', '        balanceOf[msg.sender] = 500000000 * 10 ** 18;              // Give the creator all initial tokens\n', '        totalSupply = 500000000 * 10 ** 18;                        // Update total supply\n', '        name = "QURALT";                                   // Set the name for display purposes\n', '        symbol = "QRLT";                               // Set the symbol for display purposes\n', '        decimals = 18;                            // Amount of decimals for display purposes\n', '\t\towner = msg.sender;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public {\n', '        if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\tif (_value <= 0) revert(); \n', '        if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '\t\tif (_value <= 0) revert(); \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\tif (_value <= 0) revert(); \n', '        if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) revert();     // Check allowance\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough\n', '\t\tif (_value <= 0) revert(); \n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender\n', '        totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}']