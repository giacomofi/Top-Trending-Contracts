['pragma solidity ^0.4.24;\n', '\n', 'contract Token{\n', '    // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().\n', '    uint256 public totalSupply;\n', '\n', '    /// 获取账户_owner拥有token的数量 \n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    //从消息发送者账户中往_to账户转数量为_value的token\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns   \n', '    (bool success);\n', '\n', '    //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    //获取账户_spender可以从账户_owner中转出token的数量\n', '    function allowance(address _owner, address _spender) constant public returns \n', '    (uint256 remaining);\n', '\n', '    //发生转账时必须要触发的事件 \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 \n', '    _value);\n', '    \n', '    event Burn(address indexed from, uint256 value);  //减去用户余额事件\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        //默认totalSupply 不会超过最大值 (2^256 - 1).\n', '        //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常\n', '        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value\n', '        balances[_to] += _value;//往接收账户增加token数量_value\n', '        emit Transfer(msg.sender, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns \n', '    (bool success) {\n', '        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= \n', '        // _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;//接收账户增加token数量_value\n', '        balances[_from] -= _value; //支出账户_from减去token数量_value\n', '        allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value\n', '        emit Transfer(_from, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success)   \n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数\n', '    }\n', '    \n', '    \n', '    /**\n', '     * 减少代币调用者的余额\n', '     *\n', '     * 操作以后是不可逆的\n', '     *\n', '     * @param _value 要删除的数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', '        //给指定帐户减去余额\n', '        balances[msg.sender] -= _value;\n', '\n', '        //代币问题做相应扣除\n', '        totalSupply -= _value;\n', '\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 删除帐户的余额（含其他帐户）\n', '     *\n', '     * 删除以后是不可逆的\n', '     *\n', '     * @param _from 要操作的帐户地址\n', '     * @param _value 要减去的数量\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balances[_from] >= _value);\n', '\n', '        //检查 其他帐户 的余额是否够使用\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        //减掉代币\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        //更新总量\n', '        totalSupply -= _value;\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '// ERC20 standard token\n', 'contract MUSD is StandardToken{\n', '    \n', '    address public admin; // 管理员\n', '    string public name = "CHINA MOROCCO MERCANTILE EXCHANGE CLIENT TRUST ACCOUNT"; // 代币名称\n', '    string public symbol = "MUSD"; // 代币符号\n', '    uint8 public decimals = 18; // 代币精度\n', '    uint256 public INITIAL_SUPPLY = 10000000000000000000000000; // 总量80亿 *10^18\n', '    // 同一个账户满足任意冻结条件均被冻结\n', '    mapping (address => bool) public frozenAccount; //无限期冻结的账户\n', '    mapping (address => uint256) public frozenTimestamp; // 有限期冻结的账户\n', '\n', '    bool public exchangeFlag = true; // 代币兑换开启\n', '    // 不满足条件或募集完成多出的eth均返回给原账户\n', '    uint256 public minWei = 1;  //最低打 1 wei  1eth = 1*10^18 wei\n', '    uint256 public maxWei = 20000000000000000000000; // 最多一次打 20000 eth\n', '    uint256 public maxRaiseAmount = 20000000000000000000000; // 募集上限 20000 eth\n', '    uint256 public raisedAmount = 0; // 已募集 0 eth\n', '    uint256 public raiseRatio = 200000; // 兑换比例 1eth = 20万token\n', '    // event 通知\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // 构造函数\n', '    constructor() public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        admin = msg.sender;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '    }\n', '\n', '    // fallback 向合约地址转账 or 调用非合约函数触发\n', '    // 代币自动兑换eth\n', '    function()\n', '    public payable {\n', '        require(msg.value > 0);\n', '        if (exchangeFlag) {\n', '            if (msg.value >= minWei && msg.value <= maxWei){\n', '                if (raisedAmount < maxRaiseAmount) {\n', '                    uint256 valueNeed = msg.value;\n', '                    raisedAmount = raisedAmount + msg.value;\n', '                    if (raisedAmount > maxRaiseAmount) {\n', '                        uint256 valueLeft = raisedAmount - maxRaiseAmount;\n', '                        valueNeed = msg.value - valueLeft;\n', '                        msg.sender.transfer(valueLeft);\n', '                        raisedAmount = maxRaiseAmount;\n', '                    }\n', '                    if (raisedAmount >= maxRaiseAmount) {\n', '                        exchangeFlag = false;\n', '                    }\n', '                    // 已处理过精度 *10^18\n', '                    uint256 _value = valueNeed * raiseRatio;\n', '\n', '                    require(_value <= balances[admin]);\n', '                    balances[admin] = balances[admin] - _value;\n', '                    balances[msg.sender] = balances[msg.sender] + _value;\n', '\n', '                    emit Transfer(admin, msg.sender, _value);\n', '\n', '                }\n', '            } else {\n', '                msg.sender.transfer(msg.value);\n', '            }\n', '        } else {\n', '            msg.sender.transfer(msg.value);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * 修改管理员\n', '    */\n', '    function changeAdmin(\n', '        address _newAdmin\n', '    )\n', '    public\n', '    returns (bool)  {\n', '        require(msg.sender == admin);\n', '        require(_newAdmin != address(0));\n', '        balances[_newAdmin] = balances[_newAdmin] + balances[admin];\n', '        balances[admin] = 0;\n', '        admin = _newAdmin;\n', '        return true;\n', '    }\n', '    /**\n', '    * 增发\n', '    */\n', '    function generateToken(\n', '        address _target,\n', '        uint256 _amount\n', '    )\n', '    public\n', '    returns (bool)  {\n', '        require(msg.sender == admin);\n', '        require(_target != address(0));\n', '        balances[_target] = balances[_target] + _amount;\n', '        totalSupply = totalSupply + _amount;\n', '        INITIAL_SUPPLY = totalSupply;\n', '        return true;\n', '    }\n', '\n', '    // 从合约提现\n', '    // 只能提给管理员\n', '    function withdraw (\n', '        uint256 _amount\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        msg.sender.transfer(_amount);\n', '        return true;\n', '    }\n', '    /**\n', '    * 锁定账户\n', '    */\n', '    function freeze(\n', '        address _target,\n', '        bool _freeze\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_target != address(0));\n', '        frozenAccount[_target] = _freeze;\n', '        return true;\n', '    }\n', '    /**\n', '    * 通过时间戳锁定账户\n', '    */\n', '    function freezeWithTimestamp(\n', '        address _target,\n', '        uint256 _timestamp\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_target != address(0));\n', '        frozenTimestamp[_target] = _timestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        * 批量锁定账户\n', '        */\n', '    function multiFreeze(\n', '        address[] _targets,\n', '        bool[] _freezes\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_targets.length == _freezes.length);\n', '        uint256 len = _targets.length;\n', '        require(len > 0);\n', '        for (uint256 i = 0; i < len; i += 1) {\n', '            address _target = _targets[i];\n', '            require(_target != address(0));\n', '            bool _freeze = _freezes[i];\n', '            frozenAccount[_target] = _freeze;\n', '        }\n', '        return true;\n', '    }\n', '    /**\n', '            * 批量通过时间戳锁定账户\n', '            */\n', '    function multiFreezeWithTimestamp(\n', '        address[] _targets,\n', '        uint256[] _timestamps\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_targets.length == _timestamps.length);\n', '        uint256 len = _targets.length;\n', '        require(len > 0);\n', '        for (uint256 i = 0; i < len; i += 1) {\n', '            address _target = _targets[i];\n', '            require(_target != address(0));\n', '            uint256 _timestamp = _timestamps[i];\n', '            frozenTimestamp[_target] = _timestamp;\n', '        }\n', '        return true;\n', '    }\n', '    /**\n', '    * 批量转账\n', '    */\n', '    function multiTransfer(\n', '        address[] _tos,\n', '        uint256[] _values\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        require(now > frozenTimestamp[msg.sender]);\n', '        require(_tos.length == _values.length);\n', '        uint256 len = _tos.length;\n', '        require(len > 0);\n', '        uint256 amount = 0;\n', '        for (uint256 i = 0; i < len; i += 1) {\n', '            amount = amount + _values[i];\n', '        }\n', '        require(amount <= balances[msg.sender]);\n', '        for (uint256 j = 0; j < len; j += 1) {\n', '            address _to = _tos[j];\n', '            require(_to != address(0));\n', '            balances[_to] = balances[_to] + _values[j];\n', '            balances[msg.sender] = balances[msg.sender] - _values[j];\n', '            emit Transfer(msg.sender, _to, _values[j]);\n', '        }\n', '        return true;\n', '    }\n', '    /**\n', '    * 从调用者转账至_to\n', '    */\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        require(now > frozenTimestamp[msg.sender]);\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    /*\n', '    * 从调用者作为from代理将from账户中的token转账至to\n', '    * 调用者在from的许可额度中必须>=value\n', '    */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        require(!frozenAccount[_from]);\n', '        require(now > frozenTimestamp[msg.sender]);\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    /**\n', '    * 调整转账代理方spender的代理的许可额度\n', '    */\n', '    function approve(\n', '        address _spender,\n', '        uint256 _value\n', '    ) public\n', '    returns (bool) {\n', '        // 转账的时候会校验balances，该处require无意义\n', '        // require(_value <= balances[msg.sender]);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    /**\n', '    * 增加转账代理方spender的代理的许可额度\n', '    * 意义不大的function\n', '    */\n', '    // function increaseApproval(\n', '    //     address _spender,\n', '    //     uint256 _addedValue\n', '    // )\n', '    // public\n', '    // returns (bool)\n', '    // {\n', '    //     // uint256 value_ = allowed[msg.sender][_spender].add(_addedValue);\n', '    //     // require(value_ <= balances[msg.sender]);\n', '    //     // allowed[msg.sender][_spender] = value_;\n', '\n', '    //     // emit Approval(msg.sender, _spender, value_);\n', '    //     return true;\n', '    // }\n', '    /**\n', '    * 减少转账代理方spender的代理的许可额度\n', '    * 意义不大的function\n', '    */\n', '    // function decreaseApproval(\n', '    //     address _spender,\n', '    //     uint256 _subtractedValue\n', '    // )\n', '    // public\n', '    // returns (bool)\n', '    // {\n', '    //     // uint256 oldValue = allowed[msg.sender][_spender];\n', '    //     // if (_subtractedValue > oldValue) {\n', '    //     //    allowed[msg.sender][_spender] = 0;\n', '    //     // } else {\n', '    //     //    uint256 newValue = oldValue.sub(_subtractedValue);\n', '    //     //    require(newValue <= balances[msg.sender]);\n', '    //     //   allowed[msg.sender][_spender] = newValue;\n', '    //     //}\n', '\n', '    //     // emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    //     return true;\n', '    // }\n', '\n', '    //********************************************************************************\n', '    //查询账户是否存在锁定时间戳\n', '    function getFrozenTimestamp(\n', '        address _target\n', '    )\n', '    public view\n', '    returns (uint256) {\n', '        require(_target != address(0));\n', '        return frozenTimestamp[_target];\n', '    }\n', '    //查询账户是否被锁定\n', '    function getFrozenAccount(\n', '        address _target\n', '    )\n', '    public view\n', '    returns (bool) {\n', '        require(_target != address(0));\n', '        return frozenAccount[_target];\n', '    }\n', '    //查询合约的余额\n', '    function getBalance()\n', '    public view\n', '    returns (uint256) {\n', '        return address(this).balance;\n', '    }\n', '    // 修改name\n', '    function setName (\n', '        string _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        name = _value;\n', '        return true;\n', '    }\n', '    // 修改symbol\n', '    function setSymbol (\n', '        string _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        symbol = _value;\n', '        return true;\n', '    }\n', '\n', '    // 修改募集flag\n', '    function setExchangeFlag (\n', '        bool _flag\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        exchangeFlag = _flag;\n', '        return true;\n', '\n', '    }\n', '    // 修改单笔募集下限\n', '    function setMinWei (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        minWei = _value;\n', '        return true;\n', '\n', '    }\n', '    // 修改单笔募集上限\n', '    function setMaxWei (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        maxWei = _value;\n', '        return true;\n', '    }\n', '    // 修改总募集上限\n', '    function setMaxRaiseAmount (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        maxRaiseAmount = _value;\n', '        return true;\n', '    }\n', '\n', '    // 修改已募集数\n', '    function setRaisedAmount (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        raisedAmount = _value;\n', '        return true;\n', '    }\n', '\n', '    // 修改募集比例\n', '    function setRaiseRatio (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        raiseRatio = _value;\n', '        return true;\n', '    }\n', '\n', '    // 销毁合约\n', '    function kill()\n', '    public {\n', '        require(msg.sender == admin);\n', '        selfdestruct(admin);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract Token{\n', '    // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().\n', '    uint256 public totalSupply;\n', '\n', '    /// 获取账户_owner拥有token的数量 \n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    //从消息发送者账户中往_to账户转数量为_value的token\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns   \n', '    (bool success);\n', '\n', '    //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    //获取账户_spender可以从账户_owner中转出token的数量\n', '    function allowance(address _owner, address _spender) constant public returns \n', '    (uint256 remaining);\n', '\n', '    //发生转账时必须要触发的事件 \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 \n', '    _value);\n', '    \n', '    event Burn(address indexed from, uint256 value);  //减去用户余额事件\n', '}\n', '\n', 'contract StandardToken is Token {\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        //默认totalSupply 不会超过最大值 (2^256 - 1).\n', '        //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常\n', '        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value\n', '        balances[_to] += _value;//往接收账户增加token数量_value\n', '        emit Transfer(msg.sender, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns \n', '    (bool success) {\n', '        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= \n', '        // _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;//接收账户增加token数量_value\n', '        balances[_from] -= _value; //支出账户_from减去token数量_value\n', '        allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value\n', '        emit Transfer(_from, _to, _value);//触发转币交易事件\n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success)   \n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数\n', '    }\n', '    \n', '    \n', '    /**\n', '     * 减少代币调用者的余额\n', '     *\n', '     * 操作以后是不可逆的\n', '     *\n', '     * @param _value 要删除的数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', '        //给指定帐户减去余额\n', '        balances[msg.sender] -= _value;\n', '\n', '        //代币问题做相应扣除\n', '        totalSupply -= _value;\n', '\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 删除帐户的余额（含其他帐户）\n', '     *\n', '     * 删除以后是不可逆的\n', '     *\n', '     * @param _from 要操作的帐户地址\n', '     * @param _value 要减去的数量\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balances[_from] >= _value);\n', '\n', '        //检查 其他帐户 的余额是否够使用\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        //减掉代币\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        //更新总量\n', '        totalSupply -= _value;\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '// ERC20 standard token\n', 'contract MUSD is StandardToken{\n', '    \n', '    address public admin; // 管理员\n', '    string public name = "CHINA MOROCCO MERCANTILE EXCHANGE CLIENT TRUST ACCOUNT"; // 代币名称\n', '    string public symbol = "MUSD"; // 代币符号\n', '    uint8 public decimals = 18; // 代币精度\n', '    uint256 public INITIAL_SUPPLY = 10000000000000000000000000; // 总量80亿 *10^18\n', '    // 同一个账户满足任意冻结条件均被冻结\n', '    mapping (address => bool) public frozenAccount; //无限期冻结的账户\n', '    mapping (address => uint256) public frozenTimestamp; // 有限期冻结的账户\n', '\n', '    bool public exchangeFlag = true; // 代币兑换开启\n', '    // 不满足条件或募集完成多出的eth均返回给原账户\n', '    uint256 public minWei = 1;  //最低打 1 wei  1eth = 1*10^18 wei\n', '    uint256 public maxWei = 20000000000000000000000; // 最多一次打 20000 eth\n', '    uint256 public maxRaiseAmount = 20000000000000000000000; // 募集上限 20000 eth\n', '    uint256 public raisedAmount = 0; // 已募集 0 eth\n', '    uint256 public raiseRatio = 200000; // 兑换比例 1eth = 20万token\n', '    // event 通知\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // 构造函数\n', '    constructor() public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        admin = msg.sender;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '    }\n', '\n', '    // fallback 向合约地址转账 or 调用非合约函数触发\n', '    // 代币自动兑换eth\n', '    function()\n', '    public payable {\n', '        require(msg.value > 0);\n', '        if (exchangeFlag) {\n', '            if (msg.value >= minWei && msg.value <= maxWei){\n', '                if (raisedAmount < maxRaiseAmount) {\n', '                    uint256 valueNeed = msg.value;\n', '                    raisedAmount = raisedAmount + msg.value;\n', '                    if (raisedAmount > maxRaiseAmount) {\n', '                        uint256 valueLeft = raisedAmount - maxRaiseAmount;\n', '                        valueNeed = msg.value - valueLeft;\n', '                        msg.sender.transfer(valueLeft);\n', '                        raisedAmount = maxRaiseAmount;\n', '                    }\n', '                    if (raisedAmount >= maxRaiseAmount) {\n', '                        exchangeFlag = false;\n', '                    }\n', '                    // 已处理过精度 *10^18\n', '                    uint256 _value = valueNeed * raiseRatio;\n', '\n', '                    require(_value <= balances[admin]);\n', '                    balances[admin] = balances[admin] - _value;\n', '                    balances[msg.sender] = balances[msg.sender] + _value;\n', '\n', '                    emit Transfer(admin, msg.sender, _value);\n', '\n', '                }\n', '            } else {\n', '                msg.sender.transfer(msg.value);\n', '            }\n', '        } else {\n', '            msg.sender.transfer(msg.value);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * 修改管理员\n', '    */\n', '    function changeAdmin(\n', '        address _newAdmin\n', '    )\n', '    public\n', '    returns (bool)  {\n', '        require(msg.sender == admin);\n', '        require(_newAdmin != address(0));\n', '        balances[_newAdmin] = balances[_newAdmin] + balances[admin];\n', '        balances[admin] = 0;\n', '        admin = _newAdmin;\n', '        return true;\n', '    }\n', '    /**\n', '    * 增发\n', '    */\n', '    function generateToken(\n', '        address _target,\n', '        uint256 _amount\n', '    )\n', '    public\n', '    returns (bool)  {\n', '        require(msg.sender == admin);\n', '        require(_target != address(0));\n', '        balances[_target] = balances[_target] + _amount;\n', '        totalSupply = totalSupply + _amount;\n', '        INITIAL_SUPPLY = totalSupply;\n', '        return true;\n', '    }\n', '\n', '    // 从合约提现\n', '    // 只能提给管理员\n', '    function withdraw (\n', '        uint256 _amount\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        msg.sender.transfer(_amount);\n', '        return true;\n', '    }\n', '    /**\n', '    * 锁定账户\n', '    */\n', '    function freeze(\n', '        address _target,\n', '        bool _freeze\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_target != address(0));\n', '        frozenAccount[_target] = _freeze;\n', '        return true;\n', '    }\n', '    /**\n', '    * 通过时间戳锁定账户\n', '    */\n', '    function freezeWithTimestamp(\n', '        address _target,\n', '        uint256 _timestamp\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_target != address(0));\n', '        frozenTimestamp[_target] = _timestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        * 批量锁定账户\n', '        */\n', '    function multiFreeze(\n', '        address[] _targets,\n', '        bool[] _freezes\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_targets.length == _freezes.length);\n', '        uint256 len = _targets.length;\n', '        require(len > 0);\n', '        for (uint256 i = 0; i < len; i += 1) {\n', '            address _target = _targets[i];\n', '            require(_target != address(0));\n', '            bool _freeze = _freezes[i];\n', '            frozenAccount[_target] = _freeze;\n', '        }\n', '        return true;\n', '    }\n', '    /**\n', '            * 批量通过时间戳锁定账户\n', '            */\n', '    function multiFreezeWithTimestamp(\n', '        address[] _targets,\n', '        uint256[] _timestamps\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_targets.length == _timestamps.length);\n', '        uint256 len = _targets.length;\n', '        require(len > 0);\n', '        for (uint256 i = 0; i < len; i += 1) {\n', '            address _target = _targets[i];\n', '            require(_target != address(0));\n', '            uint256 _timestamp = _timestamps[i];\n', '            frozenTimestamp[_target] = _timestamp;\n', '        }\n', '        return true;\n', '    }\n', '    /**\n', '    * 批量转账\n', '    */\n', '    function multiTransfer(\n', '        address[] _tos,\n', '        uint256[] _values\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        require(now > frozenTimestamp[msg.sender]);\n', '        require(_tos.length == _values.length);\n', '        uint256 len = _tos.length;\n', '        require(len > 0);\n', '        uint256 amount = 0;\n', '        for (uint256 i = 0; i < len; i += 1) {\n', '            amount = amount + _values[i];\n', '        }\n', '        require(amount <= balances[msg.sender]);\n', '        for (uint256 j = 0; j < len; j += 1) {\n', '            address _to = _tos[j];\n', '            require(_to != address(0));\n', '            balances[_to] = balances[_to] + _values[j];\n', '            balances[msg.sender] = balances[msg.sender] - _values[j];\n', '            emit Transfer(msg.sender, _to, _values[j]);\n', '        }\n', '        return true;\n', '    }\n', '    /**\n', '    * 从调用者转账至_to\n', '    */\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(!frozenAccount[msg.sender]);\n', '        require(now > frozenTimestamp[msg.sender]);\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    /*\n', '    * 从调用者作为from代理将from账户中的token转账至to\n', '    * 调用者在from的许可额度中必须>=value\n', '    */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        require(!frozenAccount[_from]);\n', '        require(now > frozenTimestamp[msg.sender]);\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    /**\n', '    * 调整转账代理方spender的代理的许可额度\n', '    */\n', '    function approve(\n', '        address _spender,\n', '        uint256 _value\n', '    ) public\n', '    returns (bool) {\n', '        // 转账的时候会校验balances，该处require无意义\n', '        // require(_value <= balances[msg.sender]);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    /**\n', '    * 增加转账代理方spender的代理的许可额度\n', '    * 意义不大的function\n', '    */\n', '    // function increaseApproval(\n', '    //     address _spender,\n', '    //     uint256 _addedValue\n', '    // )\n', '    // public\n', '    // returns (bool)\n', '    // {\n', '    //     // uint256 value_ = allowed[msg.sender][_spender].add(_addedValue);\n', '    //     // require(value_ <= balances[msg.sender]);\n', '    //     // allowed[msg.sender][_spender] = value_;\n', '\n', '    //     // emit Approval(msg.sender, _spender, value_);\n', '    //     return true;\n', '    // }\n', '    /**\n', '    * 减少转账代理方spender的代理的许可额度\n', '    * 意义不大的function\n', '    */\n', '    // function decreaseApproval(\n', '    //     address _spender,\n', '    //     uint256 _subtractedValue\n', '    // )\n', '    // public\n', '    // returns (bool)\n', '    // {\n', '    //     // uint256 oldValue = allowed[msg.sender][_spender];\n', '    //     // if (_subtractedValue > oldValue) {\n', '    //     //    allowed[msg.sender][_spender] = 0;\n', '    //     // } else {\n', '    //     //    uint256 newValue = oldValue.sub(_subtractedValue);\n', '    //     //    require(newValue <= balances[msg.sender]);\n', '    //     //   allowed[msg.sender][_spender] = newValue;\n', '    //     //}\n', '\n', '    //     // emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    //     return true;\n', '    // }\n', '\n', '    //********************************************************************************\n', '    //查询账户是否存在锁定时间戳\n', '    function getFrozenTimestamp(\n', '        address _target\n', '    )\n', '    public view\n', '    returns (uint256) {\n', '        require(_target != address(0));\n', '        return frozenTimestamp[_target];\n', '    }\n', '    //查询账户是否被锁定\n', '    function getFrozenAccount(\n', '        address _target\n', '    )\n', '    public view\n', '    returns (bool) {\n', '        require(_target != address(0));\n', '        return frozenAccount[_target];\n', '    }\n', '    //查询合约的余额\n', '    function getBalance()\n', '    public view\n', '    returns (uint256) {\n', '        return address(this).balance;\n', '    }\n', '    // 修改name\n', '    function setName (\n', '        string _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        name = _value;\n', '        return true;\n', '    }\n', '    // 修改symbol\n', '    function setSymbol (\n', '        string _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        symbol = _value;\n', '        return true;\n', '    }\n', '\n', '    // 修改募集flag\n', '    function setExchangeFlag (\n', '        bool _flag\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        exchangeFlag = _flag;\n', '        return true;\n', '\n', '    }\n', '    // 修改单笔募集下限\n', '    function setMinWei (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        minWei = _value;\n', '        return true;\n', '\n', '    }\n', '    // 修改单笔募集上限\n', '    function setMaxWei (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        maxWei = _value;\n', '        return true;\n', '    }\n', '    // 修改总募集上限\n', '    function setMaxRaiseAmount (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        maxRaiseAmount = _value;\n', '        return true;\n', '    }\n', '\n', '    // 修改已募集数\n', '    function setRaisedAmount (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        raisedAmount = _value;\n', '        return true;\n', '    }\n', '\n', '    // 修改募集比例\n', '    function setRaiseRatio (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        raiseRatio = _value;\n', '        return true;\n', '    }\n', '\n', '    // 销毁合约\n', '    function kill()\n', '    public {\n', '        require(msg.sender == admin);\n', '        selfdestruct(admin);\n', '    }\n', '\n', '}']
