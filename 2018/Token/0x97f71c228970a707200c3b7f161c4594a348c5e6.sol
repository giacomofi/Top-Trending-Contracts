['pragma solidity ^0.4.4;\n', '\n', 'contract TPP2018TOKEN  {\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '\tfunction transfer(address _to, uint256 _value)public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function  transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    function () {\n', '        \n', '        throw;\n', '    }\n', '\n', '    string public name;                  \n', '    uint8 public decimals;               \n', '    string public symbol;                \n', '    string public version = &#39;H1.0&#39;;       \n', '\n', '    function TPP2018TOKEN () public{\n', '        balances[msg.sender] = 8600000000;               // Give the creator all initial tokens \n', '        totalSupply = 8600000000;  \n', '        name = "TPP TOKEN";      \n', '        decimals = 2;           \n', '        symbol = "TPPT"; \n', '    }\n', '}']
['pragma solidity ^0.4.4;\n', '\n', 'contract TPP2018TOKEN  {\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '\tfunction transfer(address _to, uint256 _value)public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function  transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    function () {\n', '        \n', '        throw;\n', '    }\n', '\n', '    string public name;                  \n', '    uint8 public decimals;               \n', '    string public symbol;                \n', "    string public version = 'H1.0';       \n", '\n', '    function TPP2018TOKEN () public{\n', '        balances[msg.sender] = 8600000000;               // Give the creator all initial tokens \n', '        totalSupply = 8600000000;  \n', '        name = "TPP TOKEN";      \n', '        decimals = 2;           \n', '        symbol = "TPPT"; \n', '    }\n', '}']
