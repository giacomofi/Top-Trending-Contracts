['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值\n', '    uint256 public totalSupply;\n', '\n', '    // 用mapping保存每个地址对应的余额\n', '    mapping (address => uint256) public balanceOf;\n', '    // 存储对账号的控制\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // 事件，用来通知客户端交易发生\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // 事件，用来通知客户端代币被消费\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * 初始化构造\n', '     */\n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。\n', '        balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币\n', '        name = tokenName;                                   // 代币名称\n', '        symbol = tokenSymbol;                               // 代币符号\n', '    }\n', '\n', '    /**\n', '     * 代币交易转移的内部实现\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // 确保目标地址不为0x0，因为0x0地址代表销毁\n', '        require(_to != 0x0);\n', '        // 检查发送者余额\n', '        require(balanceOf[_from] >= _value);\n', '        // 溢出检查\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '        // 以下用来检查交易，\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        // 用assert来检查代码逻辑。\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     *  代币交易转移\n', '     * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号\n', '     *\n', '     * @param _to 接收者地址\n', '     * @param _value 转移数额\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * 账号之间代币交易转移\n', '     * @param _from 发送者地址\n', '     * @param _to 接收者地址\n', '     * @param _value 转移数额\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置某个地址（合约）可以创建交易者名义花费的代币数。\n', '     *\n', '     * 允许发送者`_spender` 花费不多于 `_value` 个代币\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。\n', '     *\n', '     * @param _spender 被授权的地址（合约）\n', '     * @param _value 最大可花费代币数\n', '     * @param _extraData 发送给合约的附加数据\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            // 通知合约\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * 销毁我（创建交易者）账户中指定个代币\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 销毁用户账户中指定个代币\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值\n', '    uint256 public totalSupply;\n', '\n', '    // 用mapping保存每个地址对应的余额\n', '    mapping (address => uint256) public balanceOf;\n', '    // 存储对账号的控制\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // 事件，用来通知客户端交易发生\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // 事件，用来通知客户端代币被消费\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * 初始化构造\n', '     */\n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。\n', '        balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币\n', '        name = tokenName;                                   // 代币名称\n', '        symbol = tokenSymbol;                               // 代币符号\n', '    }\n', '\n', '    /**\n', '     * 代币交易转移的内部实现\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // 确保目标地址不为0x0，因为0x0地址代表销毁\n', '        require(_to != 0x0);\n', '        // 检查发送者余额\n', '        require(balanceOf[_from] >= _value);\n', '        // 溢出检查\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '        // 以下用来检查交易，\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        // 用assert来检查代码逻辑。\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     *  代币交易转移\n', '     * 从自己（创建交易者）账号发送`_value`个代币到 `_to`账号\n', '     *\n', '     * @param _to 接收者地址\n', '     * @param _value 转移数额\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * 账号之间代币交易转移\n', '     * @param _from 发送者地址\n', '     * @param _to 接收者地址\n', '     * @param _value 转移数额\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置某个地址（合约）可以创建交易者名义花费的代币数。\n', '     *\n', '     * 允许发送者`_spender` 花费不多于 `_value` 个代币\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数。\n', '     *\n', '     * @param _spender 被授权的地址（合约）\n', '     * @param _value 最大可花费代币数\n', '     * @param _extraData 发送给合约的附加数据\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            // 通知合约\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * 销毁我（创建交易者）账户中指定个代币\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 销毁用户账户中指定个代币\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
