['pragma solidity ^0.4.21;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', '\n', 'contract token {\n', '    /* 公共变量 */\n', '    string public name; //代币名称\n', '    string public symbol; //代币符号\n', '    uint8 public decimals = 4;  //代币单位，展示的小数点后面多少个0\n', '    uint256 public totalSupply; //代币总量\n', '\n', '    /*记录所有余额的映射*/\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件\n', '    event Burn(address indexed from, uint256 value);  //减去用户余额事件\n', '\n', '    /* 初始化合约，并且把初始的所有代币都给这合约的创建者\n', '     * @param initialSupply 代币的总数\n', '     * @param tokenName 代币名称\n', '     * @param tokenSymbol 代币符号\n', '     */\n', '    function token(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '\n', '        //初始化总量\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);    \n', '\n', '        //给指定帐户初始化代币总量，初始化用于奖励合约创建者\n', '        balanceOf[msg.sender] = totalSupply;\n', '\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '\n', '    }\n', '\n', '\n', '    /**\n', '     * 私有方法从一个帐户发送给另一个帐户代币\n', '     * @param  _from address 发送代币的地址\n', '     * @param  _to address 接受代币的地址\n', '     * @param  _value uint256 接受代币的数量\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '\n', '      //避免转帐的地址是0x0\n', '      require(_to != 0x0);\n', '\n', '      //检查发送者是否拥有足够余额\n', '      require(balanceOf[_from] >= _value);\n', '\n', '      //检查是否溢出\n', '      require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '      //保存数据用于后面的判断\n', '      uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '      //从发送者减掉发送额\n', '      balanceOf[_from] -= _value;\n', '\n', '      //给接收者加上相同的量\n', '      balanceOf[_to] += _value;\n', '\n', '      //通知任何监听该交易的客户端\n', '      Transfer(_from, _to, _value);\n', '\n', '      //判断买、卖双方的数据是否和转换前一致\n', '      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', '    }\n', '\n', '    /**\n', '     * 从主帐户合约调用者发送给别人代币\n', '     * @param  _to address 接受代币的地址\n', '     * @param  _value uint256 接受代币的数量\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * 从某个指定的帐户中，向另一个帐户发送代币\n', '     *\n', '     * 调用过程，会检查设置的允许最大交易额\n', '     *\n', '     * @param  _from address 发送者地址\n', '     * @param  _to address 接受者地址\n', '     * @param  _value uint256 要转移的代币数量\n', '     * @return success        是否交易成功\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){\n', '        //检查发送者是否拥有足够余额\n', '        require(_value <= allowance[_from][msg.sender]);   // Check allowance\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        _transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置帐户允许支付的最大金额\n', '     *\n', '     * 一般在智能合约的时候，避免支付过多，造成风险\n', '     *\n', '     * @param _spender 帐户地址\n', '     * @param _value 金额\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置帐户允许支付的最大金额\n', '     *\n', '     * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作\n', '     *\n', '     * @param _spender 帐户地址\n', '     * @param _value 金额\n', '     * @param _extraData 操作的时间\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * 减少代币调用者的余额\n', '     *\n', '     * 操作以后是不可逆的\n', '     *\n', '     * @param _value 要删除的数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', '        //给指定帐户减去余额\n', '        balanceOf[msg.sender] -= _value;\n', '\n', '        //代币问题做相应扣除\n', '        totalSupply -= _value;\n', '\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 删除帐户的余额（含其他帐户）\n', '     *\n', '     * 删除以后是不可逆的\n', '     *\n', '     * @param _from 要操作的帐户地址\n', '     * @param _value 要减去的数量\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        //检查 其他帐户 的余额是否够使用\n', '        require(_value <= allowance[_from][msg.sender]);\n', '\n', '        //减掉代币\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        //更新总量\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', '\n', 'contract token {\n', '    /* 公共变量 */\n', '    string public name; //代币名称\n', '    string public symbol; //代币符号\n', '    uint8 public decimals = 4;  //代币单位，展示的小数点后面多少个0\n', '    uint256 public totalSupply; //代币总量\n', '\n', '    /*记录所有余额的映射*/\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件\n', '    event Burn(address indexed from, uint256 value);  //减去用户余额事件\n', '\n', '    /* 初始化合约，并且把初始的所有代币都给这合约的创建者\n', '     * @param initialSupply 代币的总数\n', '     * @param tokenName 代币名称\n', '     * @param tokenSymbol 代币符号\n', '     */\n', '    function token(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '\n', '        //初始化总量\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);    \n', '\n', '        //给指定帐户初始化代币总量，初始化用于奖励合约创建者\n', '        balanceOf[msg.sender] = totalSupply;\n', '\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '\n', '    }\n', '\n', '\n', '    /**\n', '     * 私有方法从一个帐户发送给另一个帐户代币\n', '     * @param  _from address 发送代币的地址\n', '     * @param  _to address 接受代币的地址\n', '     * @param  _value uint256 接受代币的数量\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '\n', '      //避免转帐的地址是0x0\n', '      require(_to != 0x0);\n', '\n', '      //检查发送者是否拥有足够余额\n', '      require(balanceOf[_from] >= _value);\n', '\n', '      //检查是否溢出\n', '      require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '      //保存数据用于后面的判断\n', '      uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '      //从发送者减掉发送额\n', '      balanceOf[_from] -= _value;\n', '\n', '      //给接收者加上相同的量\n', '      balanceOf[_to] += _value;\n', '\n', '      //通知任何监听该交易的客户端\n', '      Transfer(_from, _to, _value);\n', '\n', '      //判断买、卖双方的数据是否和转换前一致\n', '      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', '    }\n', '\n', '    /**\n', '     * 从主帐户合约调用者发送给别人代币\n', '     * @param  _to address 接受代币的地址\n', '     * @param  _value uint256 接受代币的数量\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * 从某个指定的帐户中，向另一个帐户发送代币\n', '     *\n', '     * 调用过程，会检查设置的允许最大交易额\n', '     *\n', '     * @param  _from address 发送者地址\n', '     * @param  _to address 接受者地址\n', '     * @param  _value uint256 要转移的代币数量\n', '     * @return success        是否交易成功\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){\n', '        //检查发送者是否拥有足够余额\n', '        require(_value <= allowance[_from][msg.sender]);   // Check allowance\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        _transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置帐户允许支付的最大金额\n', '     *\n', '     * 一般在智能合约的时候，避免支付过多，造成风险\n', '     *\n', '     * @param _spender 帐户地址\n', '     * @param _value 金额\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置帐户允许支付的最大金额\n', '     *\n', '     * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作\n', '     *\n', '     * @param _spender 帐户地址\n', '     * @param _value 金额\n', '     * @param _extraData 操作的时间\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * 减少代币调用者的余额\n', '     *\n', '     * 操作以后是不可逆的\n', '     *\n', '     * @param _value 要删除的数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', '        //给指定帐户减去余额\n', '        balanceOf[msg.sender] -= _value;\n', '\n', '        //代币问题做相应扣除\n', '        totalSupply -= _value;\n', '\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 删除帐户的余额（含其他帐户）\n', '     *\n', '     * 删除以后是不可逆的\n', '     *\n', '     * @param _from 要操作的帐户地址\n', '     * @param _value 要减去的数量\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        //检查 其他帐户 的余额是否够使用\n', '        require(_value <= allowance[_from][msg.sender]);\n', '\n', '        //减掉代币\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        //更新总量\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
