['pragma solidity ^0.4.11;\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Hodl is IERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint public _totalSupply = 0;\n', '    \n', '    string public constant symbol = "HODL";\n', '    string public constant name = "Hodl";\n', '    uint8 public constant decimals = 18;\n', '    \n', '    uint256 public constant RATE = 500;\n', '    \n', '    address public owner;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address =>uint256)) allowed;\n', '    \n', '    function () payable {\n', '        createTokens();\n', '    }\n', '    \n', '   function Hodl() {\n', '       owner = msg.sender;\n', '   }\n', '    \n', '    function createTokens() payable {\n', '        require(msg.value > 0);\n', '        \n', '        uint256 tokens = msg.value.mul(RATE);\n', '        balances[msg.sender] = balances [msg.sender].add(tokens);\n', '        _totalSupply = _totalSupply.add(tokens);\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '\n', '        return balances[_owner];\n', '        \n', '    }\n', '    \n', '     function transfer(address _to, uint256 _value) returns (bool success) {\n', '        \n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && _value > 0\n', '            ); \n', '            \n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '     \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '        require(\n', '            allowed[_from][msg.sender] >= _value\n', '            && balances[_from] >= _value\n', '            && _value > 0\n', '        );\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }     \n', '              \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '     \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '        \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowed [_owner][_spender];\n', '        \n', '    }\n', '\n', '\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']