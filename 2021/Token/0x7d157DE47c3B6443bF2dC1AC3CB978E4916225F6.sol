['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-14\n', '*/\n', '\n', '//Cryptoken\n', '//Ȼ\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', 'contract Token {\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', 'contract StandardToken is Token {\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '}\n', 'function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', 'contract Cryptoken is StandardToken {\n', '\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '\n', '   \n', '\n', '\n', '    string public name = "Cryptoken";      \n', '    uint8 public decimals = 22;                \n', '    string public symbol = "CTN";\n', "    string public version = 'H1.0';    \n", '\n', '\n', '\n', '\n', '    function Cryptoken(\n', '        ) {\n', '        balances[msg.sender] = 500000000000000000000000000000000;               \n', '        totalSupply = 500000000000000000000000000000000;                       \n', '        name = "Cryptoken";                                  \n', '        decimals = 22;                            \n', '        symbol = "CTN";                               \n', '    }\n', '\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        \n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}']