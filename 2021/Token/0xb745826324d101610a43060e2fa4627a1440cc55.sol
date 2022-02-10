['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-29\n', '*/\n', '\n', 'pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    // 令牌的公有变量\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals 极力推荐使用默认值，尽量别改\n', '    uint256 public totalSupply;\n', '\n', '    // 创建所有账户余额数组\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // 在区块链上创建一个公共事件，它触发就会通知所有客户端\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // 通知客户端销毁数额\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * 合约方法\n', '     *\n', '     * 初始化合约，将最初的令牌打入创建者的账户中\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // 更新总发行量\n', '        balanceOf[msg.sender] = totalSupply;                // 给创建者所有初始令牌\n', '        name = tokenName;                                   // 设置显示名称\n', '        symbol = tokenSymbol;                               // 设置显示缩写，例如比特币是BTC\n', '    }\n', '\n', '    /**\n', '     * 内部转账，只能被该合约调用\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // 如果转账到 0x0 地址. 使用 burn() 替代\n', '        require(_to != 0x0);\n', '        // 检查发送者是否拥有足够的币\n', '        require(balanceOf[_from] >= _value);\n', '        // 检查越界\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // 将此信息保存用于将来确认\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // 从发送者扣币\n', '        balanceOf[_from] -= _value;\n', '        // 给接收者加相同数量币\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // 使用assert是为了使用静态分析找到代码bug. 它永远不会失败\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * 发送令牌\n', '     *\n', '     * 从你的账户发送个`_value` 令牌到 `_to` \n', '     *\n', '     * @param _to 接收地址\n', '     * @param _value 发送数量\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * 从其他地址发送令牌\n', '     *\n', '     * 从`_from` 发送 `_value` 个令牌到 `_to` \n', '     *\n', '     * @param _from 发送地址\n', '     * @param _to 接收地址\n', '     * @param _value 发送数量\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置其他地址限额\n', '     *\n', '     * 允许 `_spender` 以你的名义使用不超过 `_value`令牌 \n', '     *\n', '     * @param _spender 授权使用的地址\n', '     * @param _value 最大可使用数量\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置其他地址限额，并通知\n', '     *\n', '     * 允许 `_spender`以你的名义使用最多 `_value`个令牌, 然后通知合约\n', '     *\n', '     * @param _spender 授权使用的地址\n', '     * @param _value  最大使用额度\n', '     * @param _extraData 发送给已经证明的合约额外信息\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * 销毁令牌\n', '     *\n', '     * 永久除去 `_value` 个令牌，不可恢复\n', '     *\n', '     * @param _value 数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 从其他账户销毁令牌\n', '     *\n', '     * 以‘_from’的名义，移除其 `_value`个令牌，不可恢复.\n', '     *\n', '     * @param _from 地址\n', '     * @param _value 销毁数量\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']