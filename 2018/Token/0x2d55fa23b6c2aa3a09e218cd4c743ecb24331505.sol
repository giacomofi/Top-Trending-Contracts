['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '\t\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256  _value);\n', '}\n', '\n', '\n', 'contract BossCoin is ERC20 {\n', '\t\n', '\tusing SafeMath for uint256;\n', '\t\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\t\n', '    uint256 public totalSupply = 500000000000000000;\n', '\tstring public constant name = "BossCoin";\n', '    string public constant symbol = "BOCO";\n', '    uint public constant decimals = 8;\n', '\t\n', '\tfunction BossCoin(){\n', '\t\tbalances[msg.sender] = totalSupply;\n', '\t}\n', '\t\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '\t\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\t\tallowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\t\tbalances[_to] = balances[_to].add(_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\t\n', '\tfunction () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '\t\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256  _value);\n', '}\n', '\n', '\n', 'contract BossCoin is ERC20 {\n', '\t\n', '\tusing SafeMath for uint256;\n', '\t\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\t\n', '    uint256 public totalSupply = 500000000000000000;\n', '\tstring public constant name = "BossCoin";\n', '    string public constant symbol = "BOCO";\n', '    uint public constant decimals = 8;\n', '\t\n', '\tfunction BossCoin(){\n', '\t\tbalances[msg.sender] = totalSupply;\n', '\t}\n', '\t\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '\t\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\t\tallowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\t\tbalances[_to] = balances[_to].add(_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\t\n', '\tfunction () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '    \n', '}']
