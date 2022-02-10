['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract VCCoin  {\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    string public name = "VC Coin";\n', '    string public symbol = "VCC";\n', '    uint public decimals = 18;\n', '\n', '\n', '    // Initial founder address (set in constructor)\n', '    // All deposited ETH will be instantly forwarded to this address.\n', '    address public founder = 0x0;\n', '\n', '    uint256 public totalSupply = 5625000 * 10**decimals;\n', '\n', '    event AllocateFounderTokens(address indexed sender);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    //constructor\n', '    function VCCoin(address founderInput) {\n', '        founder = founderInput;\n', '        balances[founder] = totalSupply;\n', '    }\n', '\n', '\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (msg.sender != founder) revert();\n', '\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function() {\n', '        revert();\n', '    }\n', '\n', '    // only owner can kill\n', '    function kill() { \n', '        if (msg.sender == founder) suicide(founder); \n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract VCCoin  {\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    string public name = "VC Coin";\n', '    string public symbol = "VCC";\n', '    uint public decimals = 18;\n', '\n', '\n', '    // Initial founder address (set in constructor)\n', '    // All deposited ETH will be instantly forwarded to this address.\n', '    address public founder = 0x0;\n', '\n', '    uint256 public totalSupply = 5625000 * 10**decimals;\n', '\n', '    event AllocateFounderTokens(address indexed sender);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    //constructor\n', '    function VCCoin(address founderInput) {\n', '        founder = founderInput;\n', '        balances[founder] = totalSupply;\n', '    }\n', '\n', '\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (msg.sender != founder) revert();\n', '\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function() {\n', '        revert();\n', '    }\n', '\n', '    // only owner can kill\n', '    function kill() { \n', '        if (msg.sender == founder) suicide(founder); \n', '    }\n', '\n', '}']
