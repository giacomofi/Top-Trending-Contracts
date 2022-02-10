['pragma solidity >=0.4.19;\n', '\n', 'contract SafeMath {\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token, SafeMath {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '    returns (bool success)\n', '    {\n', '        if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] = safeSubtract(balances[msg.sender], _value);\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '    returns (bool success)\n', '    {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] = safeAdd(balances[_to], _value);\n', '            balances[_from] = safeSubtract(balances[_from], _value);\n', '            allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '    onlyPayloadSize(2)\n', '    returns (bool success)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)\n', '    constant\n', '    onlyPayloadSize(2)\n', '    returns (uint256 remaining)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '/**\n', ' * @title YONDcoin\n', ' * @dev ERC20 Token, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `StandardToken` functions.\n', ' */\n', 'contract   Beyondcoin is StandardToken {\n', '\n', '  string public name = "YOND";\n', '  string public symbol = "YOND";\n', '  uint256 public decimals = 18;\n', '  uint256 public INITIAL_SUPPLY = 7967000000 * 1 ether;\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens.\n', '   */\n', '  function YONDcoin() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '\n', '}']