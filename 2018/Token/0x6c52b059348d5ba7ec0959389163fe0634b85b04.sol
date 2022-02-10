['pragma solidity ^0.4.16;  \n', 'contract Token{  \n', '    uint256 public totalSupply;  \n', '  \n', '    function balanceOf(address _owner) public constant returns (uint256 balance);  \n', '    function transfer(address _to, uint256 _value) public returns (bool success);  \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns     \n', '    (bool success);  \n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success);  \n', '  \n', '    function allowance(address _owner, address _spender) public constant returns   \n', '    (uint256 remaining);  \n', '  \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);  \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);  \n', '}  \n', '  \n', 'contract LhsToken is Token {  \n', '  \n', '    string public name;                   //名称，例如"My test token"  \n', '    uint8 public decimals;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.  \n', '    string public symbol;               //token简称,like MTT  \n', '    \n', '    mapping (address => uint256) balances;  \n', '    mapping (address => mapping (address => uint256)) allowed;  \n', '    \n', '    function LhsToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {  \n', '        totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);         // 设置初始总量  \n', '        balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者  \n', '  \n', '        name = _tokenName;                     \n', '        decimals = _decimalUnits;            \n', '        symbol = _tokenSymbol;  \n', '    }  \n', '\n', '\n', '\n', '    // token的发送函数\n', '    function _transferFunc(address _from, address _to, uint _value) internal {\n', '\n', '        require(_to != 0x0);    // 不是零地址\n', '        require(balances[_from] >= _value);        // 有足够的余额来发送\n', '        require(balances[_to] + _value > balances[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)\n', '\n', '        uint previousBalances = balances[_from] + balances[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?\n', '        balances[_from] -= _value; //发钱 不多说\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event\n', '        assert(balances[_from] + balances[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错\n', '    }\n', '  \n', '    function transfer(address _to, uint256 _value) public  returns (bool success) {\n', '        _transferFunc(msg.sender, _to, _value); // 这里已经储存了 合约创建者的信息, 这个函数是只能被合约创建者使用\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowed[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)\n', '        allowed[_from][msg.sender] -= _value;\n', '        _transferFunc(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {  \n', '        return balances[_owner];  \n', '    }  \n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success)     \n', '    {   \n', '        allowed[msg.sender][_spender] = _value;  \n', '        Approval(msg.sender, _spender, _value);  \n', '        return true;  \n', '    }  \n', '  \n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {  \n', '        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数  \n', '    }  \n', '}']
['pragma solidity ^0.4.16;  \n', 'contract Token{  \n', '    uint256 public totalSupply;  \n', '  \n', '    function balanceOf(address _owner) public constant returns (uint256 balance);  \n', '    function transfer(address _to, uint256 _value) public returns (bool success);  \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns     \n', '    (bool success);  \n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success);  \n', '  \n', '    function allowance(address _owner, address _spender) public constant returns   \n', '    (uint256 remaining);  \n', '  \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);  \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);  \n', '}  \n', '  \n', 'contract LhsToken is Token {  \n', '  \n', '    string public name;                   //名称，例如"My test token"  \n', '    uint8 public decimals;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.  \n', '    string public symbol;               //token简称,like MTT  \n', '    \n', '    mapping (address => uint256) balances;  \n', '    mapping (address => mapping (address => uint256)) allowed;  \n', '    \n', '    function LhsToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {  \n', '        totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);         // 设置初始总量  \n', '        balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者  \n', '  \n', '        name = _tokenName;                     \n', '        decimals = _decimalUnits;            \n', '        symbol = _tokenSymbol;  \n', '    }  \n', '\n', '\n', '\n', '    // token的发送函数\n', '    function _transferFunc(address _from, address _to, uint _value) internal {\n', '\n', '        require(_to != 0x0);    // 不是零地址\n', '        require(balances[_from] >= _value);        // 有足够的余额来发送\n', '        require(balances[_to] + _value > balances[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)\n', '\n', '        uint previousBalances = balances[_from] + balances[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?\n', '        balances[_from] -= _value; //发钱 不多说\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event\n', '        assert(balances[_from] + balances[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错\n', '    }\n', '  \n', '    function transfer(address _to, uint256 _value) public  returns (bool success) {\n', '        _transferFunc(msg.sender, _to, _value); // 这里已经储存了 合约创建者的信息, 这个函数是只能被合约创建者使用\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowed[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)\n', '        allowed[_from][msg.sender] -= _value;\n', '        _transferFunc(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {  \n', '        return balances[_owner];  \n', '    }  \n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success)     \n', '    {   \n', '        allowed[msg.sender][_spender] = _value;  \n', '        Approval(msg.sender, _spender, _value);  \n', '        return true;  \n', '    }  \n', '  \n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {  \n', '        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数  \n', '    }  \n', '}']