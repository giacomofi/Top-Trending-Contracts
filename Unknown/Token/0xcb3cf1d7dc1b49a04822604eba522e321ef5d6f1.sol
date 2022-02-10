['pragma solidity ^0.4.11;\n', '\n', 'contract MichaelCoin {\n', '\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  string public name = "Michael Coin";\n', '  string public symbol = "MC";\n', '  uint8 public decimals = 18;\n', '  uint256 public totalAmount = 1000000 ether;\n', '\n', '  event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval (address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  function MichaelCoin() {\n', '    // constructor\n', '    balances[msg.sender] = totalAmount;\n', '  }\n', '  function totalSupply() constant returns(uint) {\n', '        return totalAmount;\n', '    }\n', '  function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (balances[msg.sender] >= _value\n', '        && balances[_to] + _value > balances[_to]) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    if(balances[_from] >= _value\n', '        && _value > 0\n', '        && balances[_to] + _value > balances[_to]\n', '        && allowed[_from][msg.sender] >= _value) {\n', '\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '    return false;\n', '}\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function() {\n', '    revert();\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract MichaelCoin {\n', '\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  string public name = "Michael Coin";\n', '  string public symbol = "MC";\n', '  uint8 public decimals = 18;\n', '  uint256 public totalAmount = 1000000 ether;\n', '\n', '  event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval (address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  function MichaelCoin() {\n', '    // constructor\n', '    balances[msg.sender] = totalAmount;\n', '  }\n', '  function totalSupply() constant returns(uint) {\n', '        return totalAmount;\n', '    }\n', '  function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (balances[msg.sender] >= _value\n', '        && balances[_to] + _value > balances[_to]) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    if(balances[_from] >= _value\n', '        && _value > 0\n', '        && balances[_to] + _value > balances[_to]\n', '        && allowed[_from][msg.sender] >= _value) {\n', '\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '    return false;\n', '}\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function() {\n', '    revert();\n', '  }\n', '}']
