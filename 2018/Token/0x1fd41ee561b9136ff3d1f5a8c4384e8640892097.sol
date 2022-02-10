['pragma solidity ^0.4.21;\n', '\n', 'contract owned {\n', '\n', '    address public owner;\n', '\n', '    function owned() public {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '\n', '        owner = newOwner;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', '\n', 'contract TokenERC20 {\n', '\n', '    string public name;\n', '\n', '    string public symbol;\n', '\n', '    uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '\n', '    // 用mapping保存每个地址对应的余额\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    \n', '\n', '    // 存储对账号的控制\n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '\n', '    // 事件，用来通知客户端交易发生\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '\n', '    // 事件，用来通知客户端代币被消费\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\t\n', '\n', '\t\n', '\n', '    /**\n', '\n', '     * 初始化构造\n', '\n', '     */\n', '\n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。\n', '\n', '        balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币\n', '\n', '        name = tokenName;                                   // 代币名称\n', '\n', '        symbol = tokenSymbol;                               // 代币符号\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 代币交易转移的内部实现\n', '\n', '     */\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', '        // 确保目标地址不为0x0，因为0x0地址代表销毁\n', '\n', '        require(_to != 0x0);\n', '\n', '        // 检查发送者余额\n', '\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        // 确保转移为正数个\n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '\n', '\n', '        // 以下用来检查交易，\n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '        // Subtract from the sender\n', '\n', '        balanceOf[_from] -= _value;\n', '\n', '        // Add the same to the recipient\n', '\n', '        balanceOf[_to] += _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '\n', '\n', '        // 用assert来检查代码逻辑。\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     *  代币交易转移\n', '\n', '     * 从创建交易者账号发送`_value`个代币到 `_to`账号\n', '\n', '     *\n', '\n', '     * @param _to 接收者地址\n', '\n', '     * @param _value 转移数额\n', '\n', '     */\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '\n', '        _transfer(msg.sender, _to, _value);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 账号之间代币交易转移\n', '\n', '     * @param _from 发送者地址\n', '\n', '     * @param _to 接收者地址\n', '\n', '     * @param _value 转移数额\n', '\n', '     */\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        _transfer(_from, _to, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 设置某个地址（合约）可以交易者名义花费的代币数。\n', '\n', '     *\n', '\n', '     * 允许发送者`_spender` 花费不多于 `_value` 个代币\n', '\n', '     *\n', '\n', '     * @param _spender The address authorized to spend\n', '\n', '     * @param _value the max amount they can spend\n', '\n', '     */\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '\n', '        returns (bool success) {\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。\n', '\n', '     *\n', '\n', '     * @param _spender 被授权的地址（合约）\n', '\n', '     * @param _value 最大可花费代币数\n', '\n', '     * @param _extraData 发送给合约的附加数据\n', '\n', '     */\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '\n', '        public\n', '\n', '        returns (bool success) {\n', '\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '        if (approve(_spender, _value)) {\n', '\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\n', '            return true;\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 销毁创建者账户中指定个代币\n', '\n', '     */\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '\n', '        Burn(msg.sender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 销毁用户账户中指定个代币\n', '\n', '     *\n', '\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '\n', '     *\n', '\n', '     * @param _from the address of the sender\n', '\n', '     * @param _value the amount of money to burn\n', '\n', '     */\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '\n', '        totalSupply -= _value;                              // Update totalSupply\n', '\n', '        Burn(_from, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract EncryptedToken is owned, TokenERC20 {\n', '\n', '  uint256 INITIAL_SUPPLY = 500000000;\n', '    \n', '  uint256 public sellPrice = 1000000000000000000;\n', '    \n', '  uint256 public buyPrice = 5000000000000000;\n', '    \n', '  mapping (address => bool) public frozenAccount;\n', '\n', '\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '\t\n', '\n', '\tfunction EncryptedToken() TokenERC20(INITIAL_SUPPLY, &#39;YXFTT&#39;, &#39;YXFTT&#39;) payable public {\n', '\n', '    \t\t\n', '\n', '    \t\t\n', '\n', '    }\n', '\n', '    \n', '\n', '\t/* Internal transfer, only can be called by this contract */\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '\n', '    /// @param target Address to receive the tokens\n', '\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '\n', '        balanceOf[target] += mintedAmount;\n', '\n', '        totalSupply += mintedAmount;\n', '\n', '        Transfer(0, this, mintedAmount);\n', '\n', '        Transfer(this, target, mintedAmount);\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '\n', '    /// @param target Address to be frozen\n', '\n', '    /// @param freeze either to freeze it or not\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '\n', '        frozenAccount[target] = freeze;\n', '\n', '        FrozenFunds(target, freeze);\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '\n', '        sellPrice = newSellPrice;\n', '\n', '        buyPrice = newBuyPrice;\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '\n', '    function buy() payable public {\n', '\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '\n', '    /// @param amount amount of tokens to be sold\n', '\n', '    function sell(uint256 amount) public {\n', '\n', '        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', '\n', '        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It&#39;s important to do this last to avoid recursion attacks\n', '\n', '    }\n', '    \n', '    //自动兑换\n', '    function () payable public {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(owner, msg.sender, amount);              // makes the transfers\n', '    }\n', '        \n', '    //提现\n', '    function withdraw (address _to,uint _amount) onlyOwner public {\n', '        require(this.balance >= _amount);\n', '        msg.sender.transfer(_amount);\n', '    }\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'contract owned {\n', '\n', '    address public owner;\n', '\n', '    function owned() public {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '\n', '        owner = newOwner;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', '\n', 'contract TokenERC20 {\n', '\n', '    string public name;\n', '\n', '    string public symbol;\n', '\n', '    uint8 public decimals = 18;  // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '\n', '    // 用mapping保存每个地址对应的余额\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    \n', '\n', '    // 存储对账号的控制\n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '\n', '    // 事件，用来通知客户端交易发生\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '\n', '    // 事件，用来通知客户端代币被消费\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\t\n', '\n', '\t\n', '\n', '    /**\n', '\n', '     * 初始化构造\n', '\n', '     */\n', '\n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。\n', '\n', '        balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币\n', '\n', '        name = tokenName;                                   // 代币名称\n', '\n', '        symbol = tokenSymbol;                               // 代币符号\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 代币交易转移的内部实现\n', '\n', '     */\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', '        // 确保目标地址不为0x0，因为0x0地址代表销毁\n', '\n', '        require(_to != 0x0);\n', '\n', '        // 检查发送者余额\n', '\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        // 确保转移为正数个\n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '\n', '\n', '        // 以下用来检查交易，\n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', '        // Subtract from the sender\n', '\n', '        balanceOf[_from] -= _value;\n', '\n', '        // Add the same to the recipient\n', '\n', '        balanceOf[_to] += _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '\n', '\n', '        // 用assert来检查代码逻辑。\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     *  代币交易转移\n', '\n', '     * 从创建交易者账号发送`_value`个代币到 `_to`账号\n', '\n', '     *\n', '\n', '     * @param _to 接收者地址\n', '\n', '     * @param _value 转移数额\n', '\n', '     */\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '\n', '        _transfer(msg.sender, _to, _value);\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 账号之间代币交易转移\n', '\n', '     * @param _from 发送者地址\n', '\n', '     * @param _to 接收者地址\n', '\n', '     * @param _value 转移数额\n', '\n', '     */\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        _transfer(_from, _to, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 设置某个地址（合约）可以交易者名义花费的代币数。\n', '\n', '     *\n', '\n', '     * 允许发送者`_spender` 花费不多于 `_value` 个代币\n', '\n', '     *\n', '\n', '     * @param _spender The address authorized to spend\n', '\n', '     * @param _value the max amount they can spend\n', '\n', '     */\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '\n', '        returns (bool success) {\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。\n', '\n', '     *\n', '\n', '     * @param _spender 被授权的地址（合约）\n', '\n', '     * @param _value 最大可花费代币数\n', '\n', '     * @param _extraData 发送给合约的附加数据\n', '\n', '     */\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '\n', '        public\n', '\n', '        returns (bool success) {\n', '\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '        if (approve(_spender, _value)) {\n', '\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\n', '            return true;\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 销毁创建者账户中指定个代币\n', '\n', '     */\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '\n', '        Burn(msg.sender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    /**\n', '\n', '     * 销毁用户账户中指定个代币\n', '\n', '     *\n', '\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '\n', '     *\n', '\n', '     * @param _from the address of the sender\n', '\n', '     * @param _value the amount of money to burn\n', '\n', '     */\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '\n', '        totalSupply -= _value;                              // Update totalSupply\n', '\n', '        Burn(_from, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract EncryptedToken is owned, TokenERC20 {\n', '\n', '  uint256 INITIAL_SUPPLY = 500000000;\n', '    \n', '  uint256 public sellPrice = 1000000000000000000;\n', '    \n', '  uint256 public buyPrice = 5000000000000000;\n', '    \n', '  mapping (address => bool) public frozenAccount;\n', '\n', '\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '\t\n', '\n', "\tfunction EncryptedToken() TokenERC20(INITIAL_SUPPLY, 'YXFTT', 'YXFTT') payable public {\n", '\n', '    \t\t\n', '\n', '    \t\t\n', '\n', '    }\n', '\n', '    \n', '\n', '\t/* Internal transfer, only can be called by this contract */\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '\n', '    /// @param target Address to receive the tokens\n', '\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '\n', '        balanceOf[target] += mintedAmount;\n', '\n', '        totalSupply += mintedAmount;\n', '\n', '        Transfer(0, this, mintedAmount);\n', '\n', '        Transfer(this, target, mintedAmount);\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '\n', '    /// @param target Address to be frozen\n', '\n', '    /// @param freeze either to freeze it or not\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '\n', '        frozenAccount[target] = freeze;\n', '\n', '        FrozenFunds(target, freeze);\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '\n', '        sellPrice = newSellPrice;\n', '\n', '        buyPrice = newBuyPrice;\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '\n', '    function buy() payable public {\n', '\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '\n', '    }\n', '\n', '\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '\n', '    /// @param amount amount of tokens to be sold\n', '\n', '    function sell(uint256 amount) public {\n', '\n', '        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', '\n', "        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '\n', '    }\n', '    \n', '    //自动兑换\n', '    function () payable public {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(owner, msg.sender, amount);              // makes the transfers\n', '    }\n', '        \n', '    //提现\n', '    function withdraw (address _to,uint _amount) onlyOwner public {\n', '        require(this.balance >= _amount);\n', '        msg.sender.transfer(_amount);\n', '    }\n', '\n', '\n', '\n', '}']