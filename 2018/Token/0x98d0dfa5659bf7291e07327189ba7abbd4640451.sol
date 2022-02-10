['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    //构造函数，自动执行\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    //转移合约到新的合约拥有者\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}\n', '\n', 'contract TokenERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    // Public variables of the token\n', '    string public name;    // 代币符合，一般用代币名称的缩写，如 LBJ\n', '    string public symbol;  // token 标志\n', '    uint8 public decimals = 18;  // 每个代币可细分的到多少位，即最小代币单位\n', '    // 代币总供应量，这里指的是一共有多少个以最小单位所计量的代币\n', '    uint256 public totalSupply;\n', '\n', '    // 用mapping保存每个地址对应的余额\n', '    mapping(address => uint256) public balanceOf;\n', '    // 返回_owner给_spender授权token的剩余量\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    // 事件，用来通知客户端交易发生\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // 事件，用来通知客户端代币被销毁\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * 构造函数，自动执行\n', '     *\n', '     */\n', '    constructor (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals\n', '        balanceOf[msg.sender] = totalSupply;\n', '        // 创建者拥有所有的代币\n', '        name = tokenName;\n', '        // 代币名称\n', '        symbol = tokenSymbol;\n', '        // 代币符号\n', '    }\n', '\n', '    /**\n', '     * @dev 代币交易转移的内部实现,只能被本合约调用\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // 确保目地地址不为0x0，因为0x0地址代表的是销毁\n', '        require(_to != 0x0);\n', '        // 确保发送者账户有足够的余额\n', '        require(balanceOf[_from] >= _value && _value > 0);\n', '        // 确保_value为正数，如果为负数，那相当于付款者账户钱越买越多～哈哈～\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // 交易前，双方账户余额总和\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // 将发送方账户余额减value\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // 将接收方账户余额加value\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        //通知客户端交易发生 Transfer(_from, _to, _value);\n', '        emit Transfer(_from, _to, _value);\n', '        // 用assert来检查代码逻辑,即交易前后双发账户余额的和应该是相同的\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * @dev 从合约创建交易者账号发送`_value`个代币到 `_to`账号\n', '     *\n', '     * @param _to 接收者地址\n', '     * @param _value 转移数额\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        //_from始终是合约创建者的地址 _transfer(msg.sender, _to, _value); }\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 批量转账固定金额\n', '     */\n', '    function batchTransfer(address[] _to, uint _value) public returns (bool success) {\n', '        require(_to.length > 0 && _to.length <= 20);\n', '        for (uint i = 0; i < _to.length; i++) {\n', '            _transfer(msg.sender, _to[i], _value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        // Check allowance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 授权_spender地址可以操作msg.sender账户下最多数量为_value的token。\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '    returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 设置允许一个地址（合约）以我（创建交易者）的名义可最多花费的代币数\n', '     *\n', '     * @param _spender 被授权的地址（合约）\n', '     * @param _value 最大可花费代币数\n', '     * @param _extraData 发送给合约的附加数据\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '    public\n', '    returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            // 通知合约\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * 销毁合约账户中指定数量的代币\n', '     *\n', '     * @param _value 销毁的数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        // 检查合约账户是否有足够的代币\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        // 将合约账户余额减少\n', '        totalSupply = totalSupply.sub(_value);\n', '        // 更新总币数\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 销毁用户账户中指定个代币\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        // Subtract from the sender&#39;s allowance\n', '        totalSupply = totalSupply.sub(_value);\n', '        // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract HYZToken is Ownable, TokenERC20 {\n', '\n', '    //设置买卖价格\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    uint minBalanceForAccounts;\n', '\n', '    mapping(address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balanceOf[_from] >= _value);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Check for overflows\n', '        require(!frozenAccount[_from]);\n', '        // 检查发送人账号是否被冻结\n', '        require(!frozenAccount[_to]);\n', '        // 检查接收人账号是否被冻结\n', '\n', '        if (msg.sender.balance < minBalanceForAccounts)\n', '            sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// 给指定的账户增加代币，同时增加总供应量，只有合约部署者可调用\n', '    /// @notice 创建`mintedAmount`标记并将其发送到`target`\n', '    /// @param target 目标地址可以收到增发的token，同时发币总数增加\n', '    /// @param mintedAmount 增发的数量 单位为wei\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] = balanceOf[target].add(mintedAmount);\n', '        totalSupply = totalSupply.add(mintedAmount);\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// 资产冻结\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target 目标冻结的账户地址\n', '    /// @param freeze 是否冻结 true|false\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// 代币买卖（兑换）只有合约部署者可调用\n', '    /// 注意买卖的价格单位是wei（最小的货币单位： 1 eth = 1000000000000000000 wei)\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    /**\n', '    这个函数是设置代币的汇率。包括购买汇率buyPrice，出售汇率sellPrice。我们在实验时，为了简单，设置buyPrice=sellPrice=0.01ETH。当然这个比例是自由设定的。在实际中，你可以设计买入代币buyPrice的价格是1ETH，卖出代币sellPrice的价格是0.8ETH，这意味着每个代币的流入流出，你可以收取0.2ETH的交易费。是不是很激动，前提是你要忽悠大家用你的代币。0.01eth = 10**16\n', '    */\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    /// 从合约购买货币的函数\n', '    // 这个value是用户输入的购买代币支付的以太币数目。amount是根据汇率算出来的代币数目\n', '    function buy() payable public {\n', '        uint amount = msg.value.div(buyPrice);\n', '        // 计算数量\n', '        _transfer(this, msg.sender, amount);\n', '        // makes the transfers\n', '    }\n', '\n', '    /// 向合约出售货币的函数\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        address myAddress = this;\n', '        require(myAddress.balance >= amount * sellPrice);\n', '        // 检查合约是否有足够的以太币去购买\n', '        _transfer(msg.sender, this, amount);\n', '        // makes the transfers\n', '        msg.sender.transfer(amount.mul(sellPrice));\n', '        // 发送以太币给卖家. 最后做这件事很重要，以避免递归攻击\n', '    }\n', '\n', '    /* 设置自动补充gas的阈值信息 */\n', '    function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {\n', '        minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '    }\n', '}']