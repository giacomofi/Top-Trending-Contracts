['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-10\n', '*/\n', '\n', 'pragma solidity ^0.4.8;\n', 'contract Token{\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns   \n', '    (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns \n', '    (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 \n', '    _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns \n', '    (bool success) {\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value; \n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success)   \n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract TokenGME is StandardToken { \n', '\n', '    /* Public variables of the token */\n', '    string public name;                   \n', '    uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It&#39;s like comparing 1 wei to 1 ether.\n', '    string public symbol;               //token简称: eg SBX\n', '    string public version = &#39;H0.1&#39;;    //版本\n', '\n', '    function TokenGME(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {\n', '        balances[msg.sender] = _initialAmount; \n', '        totalSupply = _initialAmount;         // 设置初始总量\n', '        name = _tokenName;                   // token名称\n', '        decimals = _decimalUnits;           // 小数位数\n', '        symbol = _tokenSymbol;             // token简称\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        return true;\n', '    }\n', '\n', '}']