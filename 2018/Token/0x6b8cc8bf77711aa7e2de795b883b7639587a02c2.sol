['pragma solidity ^0.4.11;\n', '/// @author Rodrigo Cremer - DEV Bth\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract BitHaus is StandardToken {\n', '\n', '    string constant public name = "BitHaus";\n', '    string constant public symbol = "BTH";\n', '    uint8 constant public decimals = 8;\n', '\n', '\n', '    function () {\n', '\n', '        throw;\n', '    }\n', '\n', '\n', '    function BitHaus() {\n', '        balances[msg.sender] = 10000000000000000;\n', '        totalSupply = 10000000000000000; //\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '/// @author Rodrigo Cremer - DEV Bth\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract BitHaus is StandardToken {\n', '\n', '    string constant public name = "BitHaus";\n', '    string constant public symbol = "BTH";\n', '    uint8 constant public decimals = 8;\n', '\n', '\n', '    function () {\n', '\n', '        throw;\n', '    }\n', '\n', '\n', '    function BitHaus() {\n', '        balances[msg.sender] = 10000000000000000;\n', '        totalSupply = 10000000000000000; //\n', '    }\n', '}']
