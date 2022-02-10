['pragma solidity ^0.4.8;\n', 'contract Token{\n', '    // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().\n', '    uint256 public totalSupply;\n', '\n', '    /// 获取账户_owner拥有token的数量 \n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    //从消息发送者账户中往_to账户转数量为_value的token\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用\n', '    function transferFrom(address _from, address _to, uint256 _value) returns   \n', '    (bool success);\n', '\n', '    //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    //获取账户_spender可以从账户_owner中转出token的数量\n', '    function allowance(address _owner, address _spender) constant returns \n', '    (uint256 remaining);\n', '\n', '    //发生转账时必须要触发的事件 \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 \n', '    _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //默认totalSupply 不会超过最大值 (2^256 - 1).\n', '        //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常\n', '        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value\n', '        balances[_to] += _value;//往接收账户增加token数量_value\n', '        Transfer(msg.sender, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns \n', '    (bool success) {\n', '        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= \n', '        // _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;//接收账户增加token数量_value\n', '        balances[_from] -= _value; //支出账户_from减去token数量_value\n', '        allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value\n', '        Transfer(_from, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success)   \n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract CDEos is StandardToken { \n', '\n', '    /* Public variables of the token */\n', '    string public name;                   //名称: eg Simon Bucks\n', '    uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It&#39;s like comparing 1 wei to 1 ether.\n', '    string public symbol;               //token简称: eg SBX\n', '    string public version = &#39;H0.1&#39;;    //版本\n', '\n', '    function CDEos(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {\n', '        balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者\n', '        totalSupply = _initialAmount;         // 设置初始总量\n', '        name = _tokenName;                   // token名称\n', '        decimals = _decimalUnits;           // 小数位数\n', '        symbol = _tokenSymbol;             // token简称\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.8;\n', 'contract Token{\n', '    // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().\n', '    uint256 public totalSupply;\n', '\n', '    /// 获取账户_owner拥有token的数量 \n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    //从消息发送者账户中往_to账户转数量为_value的token\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用\n', '    function transferFrom(address _from, address _to, uint256 _value) returns   \n', '    (bool success);\n', '\n', '    //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    //获取账户_spender可以从账户_owner中转出token的数量\n', '    function allowance(address _owner, address _spender) constant returns \n', '    (uint256 remaining);\n', '\n', '    //发生转账时必须要触发的事件 \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 \n', '    _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //默认totalSupply 不会超过最大值 (2^256 - 1).\n', '        //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常\n', '        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value\n', '        balances[_to] += _value;//往接收账户增加token数量_value\n', '        Transfer(msg.sender, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns \n', '    (bool success) {\n', '        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= \n', '        // _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;//接收账户增加token数量_value\n', '        balances[_from] -= _value; //支出账户_from减去token数量_value\n', '        allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value\n', '        Transfer(_from, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success)   \n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract CDEos is StandardToken { \n', '\n', '    /* Public variables of the token */\n', '    string public name;                   //名称: eg Simon Bucks\n', "    uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '    string public symbol;               //token简称: eg SBX\n', "    string public version = 'H0.1';    //版本\n", '\n', '    function CDEos(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {\n', '        balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者\n', '        totalSupply = _initialAmount;         // 设置初始总量\n', '        name = _tokenName;                   // token名称\n', '        decimals = _decimalUnits;           // 小数位数\n', '        symbol = _tokenSymbol;             // token简称\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        return true;\n', '    }\n', '\n', '}']
