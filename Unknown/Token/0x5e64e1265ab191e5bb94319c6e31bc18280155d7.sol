['pragma solidity ^0.4.13;\n', '\n', 'contract AML {\n', '  string public constant name = "AML Token";\n', '  string public constant symbol = "AML";\n', '  uint8 public constant decimals = 18;\n', '  \n', '  uint256 public totalSupply;\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  \n', '  function AML() {\n', '    balances[msg.sender] = 51000000000000000000000000;\n', '    totalSupply = 51000000000000000000000000;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _amount) returns (bool success) {\n', '    if (balances[msg.sender] >= _amount \n', '      && _amount > 0\n', '      && balances[_to] + _amount > balances[_to]) {\n', '        balances[msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    } else {\n', '      return false;\n', '    }\n', '}\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function transferFrom(\n', '       address _from,\n', '       address _to,\n', '       uint256 _amount\n', '   ) returns (bool success) {\n', '       if (balances[_from] >= _amount\n', '           && allowed[_from][msg.sender] >= _amount\n', '           && _amount > 0\n', '           && balances[_to] + _amount > balances[_to]) {\n', '           balances[_from] -= _amount;\n', '           allowed[_from][msg.sender] -= _amount;\n', '           balances[_to] += _amount;\n', '           Transfer(_from, _to, _amount);\n', '           return true;\n', '      } else {\n', '           return false;\n', '       }\n', '  }\n', '  \n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  \n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract AML {\n', '  string public constant name = "AML Token";\n', '  string public constant symbol = "AML";\n', '  uint8 public constant decimals = 18;\n', '  \n', '  uint256 public totalSupply;\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  \n', '  function AML() {\n', '    balances[msg.sender] = 51000000000000000000000000;\n', '    totalSupply = 51000000000000000000000000;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _amount) returns (bool success) {\n', '    if (balances[msg.sender] >= _amount \n', '      && _amount > 0\n', '      && balances[_to] + _amount > balances[_to]) {\n', '        balances[msg.sender] -= _amount;\n', '        balances[_to] += _amount;\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    } else {\n', '      return false;\n', '    }\n', '}\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function transferFrom(\n', '       address _from,\n', '       address _to,\n', '       uint256 _amount\n', '   ) returns (bool success) {\n', '       if (balances[_from] >= _amount\n', '           && allowed[_from][msg.sender] >= _amount\n', '           && _amount > 0\n', '           && balances[_to] + _amount > balances[_to]) {\n', '           balances[_from] -= _amount;\n', '           allowed[_from][msg.sender] -= _amount;\n', '           balances[_to] += _amount;\n', '           Transfer(_from, _to, _amount);\n', '           return true;\n', '      } else {\n', '           return false;\n', '       }\n', '  }\n', '  \n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  \n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}']
