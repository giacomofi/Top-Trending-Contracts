['pragma solidity ^0.4.11;\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\tbool public disabled = false;\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (disabled != true && balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (disabled != true && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract NexxusToken is StandardToken {\n', '\n', '    function () {throw;}\n', '\n', '    string public name = "Nexxus";\n', '    uint8 public decimals = 8;\n', '    string public symbol = "NXX";\n', '    address public owner;\n', '\n', '    function NexxusToken() {\n', '        totalSupply = 31500000000000000;\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '    }\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '\tfunction mintToken(uint256 _amount) {\n', '        if (msg.sender == owner) {\n', '    \t\ttotalSupply += _amount;\n', '            balances[owner] += _amount;\n', '    \t\tTransfer(0, owner, _amount);\n', '        }\n', '\t}\n', '\tfunction disableToken(bool _disable) { \n', '        if (msg.sender == owner)\n', '\t\t\tdisabled = _disable;\n', '    }\n', '}']