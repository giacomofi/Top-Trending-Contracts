['pragma solidity ^0.4.7;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) pure internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) pure internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) pure internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '  function approve(address spender, uint value) public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transfer(address _to, uint _value) public returns (bool success) {\n', '    // This test is implied by safeSub()\n', '    // if (balances[msg.sender] < _value) { throw; }\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // These tests are implied by safeSub()\n', '    // if (balances[_from] < _value) { throw; }\n', '    // if (_allowance < _value) { throw; }\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract MLQD is StandardToken {\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name = "Maolulu LQD";   // Fancy name: eg: Maolulu LQD\n', '    string public symbol = "MLQD"; // An identifier: eg MLQD\n', '    uint public decimals = 8;      // Unit precision\n', '\n', '    function MLQD() public {\n', '        totalSupply = 250000000000000;       // Set the total supply (in base units)\n', '        balances[0xbfC729007CE9CBBE54132Fb9BFa097D80AAC791C] = 250000000000000;    // Initially assign the entire supply to the specified account\n', '    }\n', '\n', '    // do not allow deposits\n', '    function() public {\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.7;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) pure internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) pure internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) pure internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '  function approve(address spender, uint value) public returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transfer(address _to, uint _value) public returns (bool success) {\n', '    // This test is implied by safeSub()\n', '    // if (balances[msg.sender] < _value) { throw; }\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // These tests are implied by safeSub()\n', '    // if (balances[_from] < _value) { throw; }\n', '    // if (_allowance < _value) { throw; }\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract MLQD is StandardToken {\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name = "Maolulu LQD";   // Fancy name: eg: Maolulu LQD\n', '    string public symbol = "MLQD"; // An identifier: eg MLQD\n', '    uint public decimals = 8;      // Unit precision\n', '\n', '    function MLQD() public {\n', '        totalSupply = 250000000000000;       // Set the total supply (in base units)\n', '        balances[0xbfC729007CE9CBBE54132Fb9BFa097D80AAC791C] = 250000000000000;    // Initially assign the entire supply to the specified account\n', '    }\n', '\n', '    // do not allow deposits\n', '    function() public {\n', '        revert();\n', '    }\n', '}']
