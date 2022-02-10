['pragma solidity ^0.4.16;\n', 'contract Token{\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns   \n', '    (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns \n', '    (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 \n', '    _value);\n', '}\n', '\n', 'contract TTNCoin is Token {\n', '\n', '    string public constant name = "TTN";                   \n', '    uint8 public constant decimals = 2; \n', '    string public constant symbol = "TTN";\n', '\n', '    function TTNCoin(uint256 _initialAmount) public {\n', '        totalSupply = _initialAmount * 10 ** uint256(decimals);         // 设置初始总量\n', '        balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        //默认totalSupply 不会超过最大值 (2^256 - 1).\n', '        //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常\n', '        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(_to != 0x0);\n', '        balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value\n', '        balances[_to] += _value;//往接收账户增加token数量_value\n', '        Transfer(msg.sender, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns \n', '    (bool success) {\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;//接收账户增加token数量_value\n', '        balances[_from] -= _value; //支出账户_from减去token数量_value\n', '        allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value\n', '        Transfer(_from, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success)   \n', '    { \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数\n', '    }\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}']