['pragma solidity ^0.4.8;\n', 'contract Token{\n', '\n', '    uint256 public totalSupply;    //Token amount, by default, generates a getter function interface for the public variable with the name of totalSupply().\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);    // Gets the number of tokens owned by the account _owner\n', '\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);    //Token that transfers amount to _value from message sender account\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns   // token transferred from account _from to account _to is used in conjunction with the approve method\n', '    (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns // get the number of tokens that the account _spender can transfer from the account _owner\n', '    (uint256 remaining);\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success); // message sending account setting account _spender can transfer the number of token as _value from the sending account\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 \n', '    _value);\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //The default totalSupply does not exceed the maximum (2^256 - 1).\n', '        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;//Subtract the token number _value from the message sender account\n', '        balances[_to] += _value;//Add token number _value to receive account\n', '        Transfer(msg.sender, _to, _value);//Trigger the exchange transaction event\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns \n', '    (bool success) {\n', '        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= \n', '        // _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;//Receive account increases token number _value\n', '        balances[_from] -= _value; //The expenditure account _from minus the number of tokens _value\n', '        allowed[_from][msg.sender] -= _value;//The number of messages sent from the account _from can be reduced by _value\n', '        Transfer(_from, _to, _value);//Trigger the exchange transaction event\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success)   \n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract TIAToken is StandardToken { \n', '\n', '    /* Public variables of the token */\n', '    string public name;                   //eg Simon Bucks\n', "    uint8 public decimals;               //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '    string public symbol;              \n', "    string public version = 'H0.1';  \n", '\n', '    function TIAToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {\n', '        balances[msg.sender] = _initialAmount; \n', '        totalSupply = _initialAmount;       \n', '        name = _tokenName;                   \n', '        decimals = _decimalUnits;          \n', '        symbol = _tokenSymbol;            \n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        return true;\n', '    }\n', '\n', '}']