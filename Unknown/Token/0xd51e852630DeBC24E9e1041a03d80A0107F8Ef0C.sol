['library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract ORIUMCOIN {\n', '    using SafeMath\n', '    for uint256;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => uint256) balances;\n', '    uint256 public totalSupply;\n', '    uint256 public decimals;\n', '    address public owner;\n', '    bytes32 public symbol;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed _owner, address indexed spender, uint256 value);\n', '\n', '    function ORIUMCOIN() {\n', '        totalSupply = 200000000;\n', '        symbol = &#39;ORM&#39;;\n', '        owner = 0x106ceae9db9a3249084aa2140add5fab057f8ea6;\n', '        balances[owner] = totalSupply;\n', '        decimals = 0;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns(bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns(bool) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function() {\n', '        revert();\n', '    }\n', '}']