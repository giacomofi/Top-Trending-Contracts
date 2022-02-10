['pragma solidity ^0.4.11;\n', '\n', 'contract VKBToken {\n', '\tstring public constant symbol = "VKB";\n', '\tstring public constant name = "VKBToken";\n', '\tuint8 public constant decimals = 18;\n', '\tuint256 _totalSupply = 210000;\n', '\t\n', '\taddress public owner;\n', '\t\n', '\tmapping(address => uint256) balances;\n', '\t\n', '\tmapping(address => mapping(address => uint256)) allowed;\n', '\t\n', '\tevent Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\t\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\t\n', '\tmodifier onlyOwner() {\n', '\t    require(msg.sender == owner);\n', '\t    _;\n', '\t}\n', '\t\n', '\tfunction VKBToken() {\n', '\t    owner = msg.sender;\n', '\t    balances[owner] = _totalSupply;\n', '\t}\n', '\n', '\tfunction totalSupply() constant returns (uint256 totalSupply) {\n', '\t    totalSupply = _totalSupply;\n', '\t}\n', '\t\n', '\tfunction balanceOf(address _owner) constant returns (uint256 balance) {\n', '\t    return balances[_owner];\n', '\t}\n', '\t\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount \n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '    \n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) returns (bool success) {\n', '        if (balances[_from] >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', ' \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']