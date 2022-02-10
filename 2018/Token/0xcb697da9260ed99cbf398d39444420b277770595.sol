['pragma solidity ^0.4.4;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// MANHATTAN:PROXY BY KEVIN ABOSCH &#169;2018\n', '// 12TH AVENUE (10,000 ERC-20 TOKENS)\n', '// VERIFY SMART CONTRACT ADDRESS WITH LIST AT HTTP://MANHATTANPROXY.COM\n', '// ----------------------------------------------------------------------------------------------\n', '\n', '\n', 'contract Token {\n', '\n', '    \n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '   \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        \n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        \n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', '\n', 'contract MANHATTANPROXY12THAVE is StandardToken {\n', '\n', '    function () {\n', '       \n', '        throw;\n', '    }\n', '\n', '    \n', '\n', '    \n', '    string public name;                   \n', '    uint8 public decimals;                \n', '    string public symbol;                 \n', '    string public version = &#39;H1.0&#39;;       \n', '\n', '\n', '    function MANHATTANPROXY12THAVE (\n', '        ) {\n', '        totalSupply = 10000;                        \n', '        balances[msg.sender] = 10000;               \n', '        name = "MP12THAV";                                             \n', '        decimals = 0;                            \n', '        symbol = "MP12THAV";                               \n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        \n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}']