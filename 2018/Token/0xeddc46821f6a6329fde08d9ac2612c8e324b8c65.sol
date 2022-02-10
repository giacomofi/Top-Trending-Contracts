['pragma solidity ^0.4.10;\n', '\n', '\n', 'contract SafeMath {\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns  (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token , SafeMath {\n', '\n', '    bool public status = true;\n', '    modifier on() {\n', '        require(status == true);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) on returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0 && _to != 0X0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] = safeAdd(balances[_to],_value);\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) on returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = safeAdd(balances[_to],_value);\n', '            balances[_from] = safeSubtract(balances[_from],_value);\n', '            allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) on constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) on returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) on constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '\n', '\n', '\n', 'contract HuobiPoolToken is StandardToken {\n', '    string public name = "HuobiPoolToken";\n', '    uint8 public decimals = 8;\n', '    string public symbol = "HPT";\n', '    bool private init =true;\n', '    function turnon() controller {\n', '        status = true;\n', '    }\n', '    function turnoff() controller {\n', '        status = false;\n', '    }\n', '    function HuobiPoolToken() {\n', '        require(init==true);\n', '        totalSupply = 100000000000;\n', '        balances[0x3567cafb8bf2a83bbea4e79f3591142fb4ebe86d] = totalSupply;\n', '        init = false;\n', '    }\n', '    address public controller1 =0x14de73a5602ee3769fb7a968daAFF23A4A6D4Bb5;\n', '    address public controller2 =0x3567cafb8bf2a83bbea4e79f3591142fb4ebe86d;\n', '\n', '    modifier controller () {\n', '        require(msg.sender == controller1||msg.sender == controller2);\n', '        _;\n', '    }\n', '}']