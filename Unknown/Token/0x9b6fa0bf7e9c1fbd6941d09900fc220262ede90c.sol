['pragma solidity ^0.4.8;\n', 'contract BOBOToken {\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '\n', '  mapping( address => uint ) _balances;\n', '  mapping( address => mapping( address => uint ) ) _approvals;\n', '  uint256 public totalSupply=21000000;\n', '  string public name="BOBOToken";\n', '  uint8 public decimals=8;                \n', '  string public symbol="BOBO";   \n', '\n', '  function BOBOToken() {\n', '        _balances[msg.sender] = totalSupply;               // Give the creator all initial tokens\n', '  }\n', '\n', '  function balanceOf( address _owner ) constant returns (uint balanbce) {\n', '    return _balances[_owner];\n', '  }\n', '\n', '  function transfer( address _to, uint _value) returns (bool success) {\n', '    if ( _balances[msg.sender] < _value ) {\n', '      revert();\n', '    }\n', '    if ( !safeToAdd(_balances[_to], _value) ) {\n', '      revert();\n', '    }\n', '    _balances[msg.sender] -= _value;\n', '    _balances[_to] += _value;\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  function transferFrom( address _from, address _to, uint _value) returns (bool success) {\n', '    // if you don&#39;t have enough balance, throw\n', '    if ( _balances[_from] < _value ) {\n', '      revert();\n', '    }\n', '    // if you don&#39;t have approval, throw\n', '    if ( _approvals[_from][msg.sender] < _value ) {\n', '      revert();\n', '    }\n', '    if ( !safeToAdd(_balances[_to], _value) ) {\n', '      revert();\n', '    }\n', '    // transfer and return true\n', '    _approvals[_from][msg.sender] -= _value;\n', '    _balances[_from] -= _value;\n', '    _balances[_to] += _value;\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    // TODO: should increase instead\n', '    _approvals[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return _approvals[_owner][_spender];\n', '  }\n', '  function safeToAdd(uint a, uint b) internal returns (bool) {\n', '    return (a + b >= a);\n', '  }\n', '}']
['pragma solidity ^0.4.8;\n', 'contract BOBOToken {\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '\n', '  mapping( address => uint ) _balances;\n', '  mapping( address => mapping( address => uint ) ) _approvals;\n', '  uint256 public totalSupply=21000000;\n', '  string public name="BOBOToken";\n', '  uint8 public decimals=8;                \n', '  string public symbol="BOBO";   \n', '\n', '  function BOBOToken() {\n', '        _balances[msg.sender] = totalSupply;               // Give the creator all initial tokens\n', '  }\n', '\n', '  function balanceOf( address _owner ) constant returns (uint balanbce) {\n', '    return _balances[_owner];\n', '  }\n', '\n', '  function transfer( address _to, uint _value) returns (bool success) {\n', '    if ( _balances[msg.sender] < _value ) {\n', '      revert();\n', '    }\n', '    if ( !safeToAdd(_balances[_to], _value) ) {\n', '      revert();\n', '    }\n', '    _balances[msg.sender] -= _value;\n', '    _balances[_to] += _value;\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  function transferFrom( address _from, address _to, uint _value) returns (bool success) {\n', "    // if you don't have enough balance, throw\n", '    if ( _balances[_from] < _value ) {\n', '      revert();\n', '    }\n', "    // if you don't have approval, throw\n", '    if ( _approvals[_from][msg.sender] < _value ) {\n', '      revert();\n', '    }\n', '    if ( !safeToAdd(_balances[_to], _value) ) {\n', '      revert();\n', '    }\n', '    // transfer and return true\n', '    _approvals[_from][msg.sender] -= _value;\n', '    _balances[_from] -= _value;\n', '    _balances[_to] += _value;\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    // TODO: should increase instead\n', '    _approvals[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return _approvals[_owner][_spender];\n', '  }\n', '  function safeToAdd(uint a, uint b) internal returns (bool) {\n', '    return (a + b >= a);\n', '  }\n', '}']