['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', ' contract ERC20Interface {\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '        \n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    }\n', 'contract Deluxo is ERC20Interface {\n', '     \n', '     using SafeMath for uint256;\n', '     \n', '     string public constant symbol = "DLUX";\n', '     string public constant name = "Deluxo";\n', '     uint8 public constant decimals = 18;\n', '     uint256 public _totalSupply = 4700000000000000000000000;\n', '     \n', '     address public owner;\n', ' \n', '    mapping(address => uint256) balances;\n', '    \n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    modifier onlyOwner() {\n', '         if (msg.sender != owner) {\n', '             revert();\n', '         }\n', '         _;\n', '     }\n', '     \n', '    function Deluxo() {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    } \n', '    \n', '    function totalSupply() constant returns (uint256) {        \n', '\t\treturn _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount \n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '             balances[_to] = balances[_to].add(_amount);\n', '             Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '    }\n', '    \n', '    function transferFrom(\n', '            address _from,\n', '            address _to,\n', '            uint256 _amount\n', '        )   returns (bool success) {\n', '            if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] = balances[_from].sub(_amount);\n', '             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '             balances[_to] = balances[_to].add(_amount);\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         }  else {\n', '             return false;\n', '         }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', ' contract ERC20Interface {\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '        \n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    }\n', 'contract Deluxo is ERC20Interface {\n', '     \n', '     using SafeMath for uint256;\n', '     \n', '     string public constant symbol = "DLUX";\n', '     string public constant name = "Deluxo";\n', '     uint8 public constant decimals = 18;\n', '     uint256 public _totalSupply = 4700000000000000000000000;\n', '     \n', '     address public owner;\n', ' \n', '    mapping(address => uint256) balances;\n', '    \n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    modifier onlyOwner() {\n', '         if (msg.sender != owner) {\n', '             revert();\n', '         }\n', '         _;\n', '     }\n', '     \n', '    function Deluxo() {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    } \n', '    \n', '    function totalSupply() constant returns (uint256) {        \n', '\t\treturn _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount \n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '             balances[_to] = balances[_to].add(_amount);\n', '             Transfer(msg.sender, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '    }\n', '    \n', '    function transferFrom(\n', '            address _from,\n', '            address _to,\n', '            uint256 _amount\n', '        )   returns (bool success) {\n', '            if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] = balances[_from].sub(_amount);\n', '             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '             balances[_to] = balances[_to].add(_amount);\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         }  else {\n', '             return false;\n', '         }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
