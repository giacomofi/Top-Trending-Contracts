['contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract Socrates {\n', "    string public version = '0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    address public owner;\n', '    uint256 public _totalSupply;\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowances;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function Socrates() {\n', '        balances[msg.sender] = 46900000000000000;\n', '        _totalSupply = 46900000000000000;\n', "        name = 'Socrates';\n", "        symbol = 'SAPIS';\n", '        decimals = 8;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) return false;\n', '        if (balances[msg.sender] < _value) return false;\n', '        if (balances[_to] + _value < balances[_to]) return false;\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) return false;\n', '        if (balances[_from] < _value) return false;\n', '        if (balances[_to] + _value < balances[_to]) return false;\n', '        if (_value > allowances[_from][msg.sender]) return false;\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        allowances[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] < _value) return false;\n', '        balances[msg.sender] -= _value;\n', '        _totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '        if (balances[_from] < _value) return false;\n', '        if (_value > allowances[_from][msg.sender]) return false;\n', '        balances[_from] -= _value;\n', '        _totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']