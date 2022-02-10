['pragma solidity ^0.4.19;\n', '\n', '/*  base token */\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public  returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public  returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public  returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)  public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant  public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract WBSToken is StandardToken{\n', '\n', '    // metadata\n', '    string public constant name = "Wisdom Beauty Star";\n', '    string public constant symbol = "WBS";\n', '    uint256 public constant decimals = 8;\n', '    string public version = "1.0";\n', '    \n', '    // total\n', '    uint256 public constant tokenCreationCap = 10 * (10**8) * 10**decimals;\n', '\n', '    function WBSToken ()  public {\n', '        balances[msg.sender] = tokenCreationCap;\n', '        totalSupply = tokenCreationCap;\n', '    }\n', '\t\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '/*  base token */\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public  returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public  returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public  returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)  public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant  public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract WBSToken is StandardToken{\n', '\n', '    // metadata\n', '    string public constant name = "Wisdom Beauty Star";\n', '    string public constant symbol = "WBS";\n', '    uint256 public constant decimals = 8;\n', '    string public version = "1.0";\n', '    \n', '    // total\n', '    uint256 public constant tokenCreationCap = 10 * (10**8) * 10**decimals;\n', '\n', '    function WBSToken ()  public {\n', '        balances[msg.sender] = tokenCreationCap;\n', '        totalSupply = tokenCreationCap;\n', '    }\n', '\t\n', '}']
