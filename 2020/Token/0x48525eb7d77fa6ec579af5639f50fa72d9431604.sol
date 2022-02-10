['pragma solidity ^0.4.26;\n', ' \n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '/**\n', ' * owned是合约的管理者\n', ' */\n', 'contract owned {\n', '    address public owner;\n', ' \n', '    /**\n', '     * 初台化构造函数\n', '     */\n', '    function owned () public {\n', '        owner = msg.sender;\n', '    }\n', ' \n', '    /**\n', '     * 判断当前合约调用者是否是合约的所有者\n', '     */\n', '    modifier onlyOwner {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', ' \n', '    /**\n', '     * 合约的所有者指派一个新的管理员\n', '     * @param  newOwner address 新的管理员帐户地址\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '        owner = newOwner;\n', '      }\n', '    }\n', '}\n', ' \n', '/**\n', ' * 基础代币合约\n', ' */\n', 'contract TokenERC20 {\n', '    string public name; //发行的代币名称\n', '    string public symbol; //发行的代币符号\n', '    uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0。\n', '    uint256 public totalSupply; //发行的代币总量\n', ' \n', '    /*记录所有余额的映射*/\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', ' \n', '    /* 在区块链上创建一个事件，用以通知客户端*/\n', '    //转帐通知事件\n', '    event Transfer(address indexed from, address indexed to, uint256 value);  \n', '    event Burn(address indexed from, uint256 value);  //减去用户余额事件\n', ' \n', '    /* 初始化合约，并且把初始的所有代币都给这合约的创建者\n', '     * @param initialSupply 代币的总数\n', '     * @param tokenName 代币名称\n', '     * @param tokenSymbol 代币符号\n', '     */\n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        //初始化总量\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);   \n', '        //给指定帐户初始化代币总量，初始化用于奖励合约创建者\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '    }\n', ' \n', ' \n', '    /**\n', '     * 私有方法从一个帐户发送给另一个帐户代币\n', '     * @param  _from address 发送代币的地址\n', '     * @param  _to address 接受代币的地址\n', '     * @param  _value uint256 接受代币的数量\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', ' \n', '      //避免转帐的地址是0x0\n', '      require(_to != 0x0);\n', ' \n', '      //检查发送者是否拥有足够余额\n', '      require(balanceOf[_from] >= _value);\n', ' \n', '      //检查是否溢出\n', '      require(balanceOf[_to] + _value > balanceOf[_to]);\n', ' \n', '      //保存数据用于后面的判断\n', '      uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', ' \n', '      //从发送者减掉发送额\n', '      balanceOf[_from] -= _value;\n', ' \n', '      //给接收者加上相同的量\n', '      balanceOf[_to] += _value;\n', ' \n', '      //通知任何监听该交易的客户端\n', '      Transfer(_from, _to, _value);\n', ' \n', '      //判断买、卖双方的数据是否和转换前一致\n', '      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', ' \n', '    }\n', ' \n', '    /**\n', '     * 从主帐户合约调用者发送给别人代币\n', '     * @param  _to address 接受代币的地址\n', '     * @param  _value uint256 接受代币的数量\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', ' \n', '    /**\n', '     * 从某个指定的帐户中，向另一个帐户发送代币\n', '     * 调用过程，会检查设置的允许最大交易额\n', '     * @param  _from address 发送者地址\n', '     * @param  _to address 接受者地址\n', '     * @param  _value uint256 要转移的代币数量\n', '     * @return success        是否交易成功\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //检查发送者是否拥有足够余额\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '     * 设置帐户允许支付的最大金额\n', '     * 一般在智能合约的时候，避免支付过多，造成风险\n', '     * @param _spender 帐户地址\n', '     * @param _value 金额\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '     * 设置帐户允许支付的最大金额\n', '     * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作\n', '     * @param _spender 帐户地址\n', '     * @param _value 金额\n', '     * @param _extraData 操作的时间\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', ' \n', '    /**\n', '     * 减少代币调用者的余额\n', '     * 操作以后是不可逆的\n', '     * @param _value 要删除的数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[msg.sender] >= _value);\n', '        //给指定帐户减去余额\n', '        balanceOf[msg.sender] -= _value;\n', '        //代币问题做相应扣除\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '     * 删除帐户的余额（含其他帐户）\n', '     * 删除以后是不可逆的\n', '     * @param _from 要操作的帐户地址\n', '     * @param _value 要减去的数量\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[_from] >= _value);\n', '        //检查 其他帐户 的余额是否够使用\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        //减掉代币\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        //更新总量\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', ' \n', '/**\n', ' * 代币增发、\n', ' * 代币冻结、\n', ' * 代币自动销售和购买、\n', ' * 高级代币功能\n', ' */\n', 'contract MyAdvancedToken is owned, TokenERC20 {\n', ' \n', '    //卖出的汇率,一个代币，可以卖出多少个以太币，单位是wei\n', '    uint256 public sellPrice;\n', ' \n', '    //买入的汇率,1个以太币，可以买几个代币\n', '    uint256 public buyPrice;\n', ' \n', '    //是否冻结帐户的列表\n', '    mapping (address => bool) public frozenAccount;\n', ' \n', '    //定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端\n', '    event FrozenFunds(address target, bool frozen);\n', ' \n', ' \n', '    /*初始化合约，并且把初始的所有的令牌都给这合约的创建者\n', '     * @param initialSupply 所有币的总数\n', '     * @param tokenName 代币名称\n', '     * @param tokenSymbol 代币符号\n', '     */\n', '        function MyAdvancedToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}\n', ' \n', ' \n', '    /**\n', '     * 私有方法，从指定帐户转出余额\n', '     * @param  _from address 发送代币的地址\n', '     * @param  _to address 接受代币的地址\n', '     * @param  _value uint256 接受代币的数量\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', ' \n', '        //避免转帐的地址是0x0\n', '        require (_to != 0x0);\n', ' \n', '        //检查发送者是否拥有足够余额\n', '        require (balanceOf[_from] > _value);\n', ' \n', '        //检查是否溢出\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', ' \n', '        //检查 冻结帐户\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', ' \n', '        //从发送者减掉发送额\n', '        balanceOf[_from] -= _value;\n', ' \n', '        //给接收者加上相同的量\n', '        balanceOf[_to] += _value;\n', ' \n', '        //通知任何监听该交易的客户端\n', '        Transfer(_from, _to, _value);\n', ' \n', '    }\n', ' \n', '    /**\n', '     * 合约拥有者，可以为指定帐户创造一些代币\n', '     * @param  target address 帐户地址\n', '     * @param  mintedAmount uint256 增加的金额(单位是wei)\n', '     */\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', ' \n', '        //给指定地址增加代币，同时总量也相加\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', ' \n', ' \n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', ' \n', '    /**\n', '     * 增加冻结帐户名称\n', '     *\n', '     * 你可能需要监管功能以便你能控制谁可以/谁不可以使用你创建的代币合约\n', '     *\n', '     * @param  target address 帐户地址\n', '     * @param  freeze bool    是否冻结\n', '     */\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', ' \n', '    /**\n', '     * 设置买卖价格\n', '     *\n', '     * 如果你想让ether(或其他代币)为你的代币进行背书,以便可以市场价自动化买卖代币,我们可以这么做。如果要使用浮动的价格，也可以在这里设置\n', '     *\n', '     * @param newSellPrice 新的卖出价格\n', '     * @param newBuyPrice 新的买入价格\n', '     */\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', ' \n', '    /**\n', '     * 使用以太币购买代币\n', '     */\n', '    function buy() payable public {\n', '      uint amount = msg.value / buyPrice;\n', ' \n', '      _transfer(this, msg.sender, amount);\n', '    }\n', ' \n', '    /**\n', '     * @dev 卖出代币\n', '     * @return 要卖出的数量(单位是wei)\n', '     */\n', '    function sell(uint256 amount) public {\n', ' \n', '        //检查合约的余额是否充足\n', '        require(this.balance >= amount * sellPrice);\n', ' \n', '        _transfer(msg.sender, this, amount);\n', ' \n', '        msg.sender.transfer(amount * sellPrice);\n', '    }\n', '}']