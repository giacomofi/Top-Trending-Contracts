['pragma solidity ^0.4.21;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract FXNOW is IERC20{\n', '    \n', '    uint256 public constant _totalSupply = 830000000000000000;\n', '    string public constant symbol = "FNCT";\n', '    string public constant name = "FXNOW";\n', '    uint8 public constant decimals = 8;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    function FXNOW(){\n', '        balances[msg.sender] = _totalSupply;\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint256 totalSupply){\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance){\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success){\n', '        require(\n', '                balances[msg.sender] >= _value\n', '                && _value > 0 \n', '            );\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '        require(\n', '                allowed[_from][msg.sender] >= _value\n', '                && balances[_from] >= _value\n', '                && _value > 0 \n', '            );\n', '            balances[_from] -= _value;\n', '            balances[_to] += _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success){\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract FXNOW is IERC20{\n', '    \n', '    uint256 public constant _totalSupply = 830000000000000000;\n', '    string public constant symbol = "FNCT";\n', '    string public constant name = "FXNOW";\n', '    uint8 public constant decimals = 8;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    function FXNOW(){\n', '        balances[msg.sender] = _totalSupply;\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint256 totalSupply){\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance){\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success){\n', '        require(\n', '                balances[msg.sender] >= _value\n', '                && _value > 0 \n', '            );\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '        require(\n', '                allowed[_from][msg.sender] >= _value\n', '                && balances[_from] >= _value\n', '                && _value > 0 \n', '            );\n', '            balances[_from] -= _value;\n', '            balances[_to] += _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success){\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
