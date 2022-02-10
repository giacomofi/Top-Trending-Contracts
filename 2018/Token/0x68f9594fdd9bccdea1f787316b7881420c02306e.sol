['// Abstract contract for the full ERC 20 Token standard\n', '//@ create by m-chain jerry\n', 'pragma solidity ^0.4.8;\n', '\n', 'contract Token {\n', '    \n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*\n', 'You should inherit from StandardToken or, for a token like you would want to\n', 'deploy in something like Mist, see WalStandardToken.sol.\n', '(This implements ONLY the standard functions and NOTHING else.\n', 'If you deploy this, you won&#39;t have anything useful.)\n', '\n', 'Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '.*/\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract NXE_Coin is StandardToken {\n', '\n', '    /* Public variables of the token */\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show. ie. \n', '    string public symbol;                 //An identifier: eg SBX\n', '    function NXE_Coin() {\n', '        balances[msg.sender] = 300000000000000000;               // Give the creator all initial tokens\n', '        totalSupply = 300000000000000000;                        // Update total supply\n', '        name = "Next eCommerce Chain";                                   // Set the name for display purposes\n', '        decimals = 8;                            // Amount of decimals for display purposes\n', '        symbol = "NXE";                               // Set the symbol for display purposes\n', '    }\n', '}']
['// Abstract contract for the full ERC 20 Token standard\n', '//@ create by m-chain jerry\n', 'pragma solidity ^0.4.8;\n', '\n', 'contract Token {\n', '    \n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*\n', 'You should inherit from StandardToken or, for a token like you would want to\n', 'deploy in something like Mist, see WalStandardToken.sol.\n', '(This implements ONLY the standard functions and NOTHING else.\n', "If you deploy this, you won't have anything useful.)\n", '\n', 'Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '.*/\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract NXE_Coin is StandardToken {\n', '\n', '    /* Public variables of the token */\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show. ie. \n', '    string public symbol;                 //An identifier: eg SBX\n', '    function NXE_Coin() {\n', '        balances[msg.sender] = 300000000000000000;               // Give the creator all initial tokens\n', '        totalSupply = 300000000000000000;                        // Update total supply\n', '        name = "Next eCommerce Chain";                                   // Set the name for display purposes\n', '        decimals = 8;                            // Amount of decimals for display purposes\n', '        symbol = "NXE";                               // Set the symbol for display purposes\n', '    }\n', '}']
