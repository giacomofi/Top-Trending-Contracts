['pragma solidity ^0.4.8;\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', 'contract SiniCoin is SafeMath{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\taddress public owner;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\tmapping (address => uint256) public freezeOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount frozen */\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount unfrozen */\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function SiniCoin(\n', '        string tokenName,uint256 tokenSupply,uint8 decimalUnits,string tokenSymbol) {\n', '        owner = msg.sender;\n', '        totalSupply = tokenSupply;  \n', '        balanceOf[msg.sender] = totalSupply;              \n', '        name = tokenName;                                  \n', '        symbol = tokenSymbol;                               \n', '        decimals = decimalUnits;                            \n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        require(balanceOf[_to] + _value > balanceOf[_to]); // overflow chk\n', '        require(_to != 0x0); //deny 0x0 adr\n', '        \n', '        require(_value > 0);\n', '        require(balanceOf[msg.sender] > _value);\n', '\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                    \n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            \n', '        Transfer(msg.sender, _to, _value);                      \n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        require(_value > 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(balanceOf[_to] + _value > balanceOf[_to]); // overflow chk\n', '        require(_to != 0x0); //deny 0x0 adr\n', '        require(_value > 0);\n', '        require(balanceOf[_from] > _value);\n', '        require(_value < allowance[_from][msg.sender]); //alw chk\n', '\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           \n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             \n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool success) {\n', '        require(balanceOf[msg.sender] > _value);\n', '        require(_value > 0);\n', '\t\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      \n', '        totalSupply = SafeMath.safeSub(totalSupply,_value);                                \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction freeze(uint256 _value) returns (bool success) {\n', '        require(balanceOf[msg.sender] > _value);\n', '        require(_value > 0);\n', '\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      \n', '        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                \n', '        Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction unfreeze(uint256 _value) returns (bool success) {\n', '        require(freezeOf[msg.sender] > _value);\n', '        require(_value > 0);\n', '       \n', '        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      \n', '\t\tbalanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);\n', '        Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '\tfunction()  {\n', '        \n', '    }\n', '}']