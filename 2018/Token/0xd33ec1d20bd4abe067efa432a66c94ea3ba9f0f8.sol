['pragma solidity ^0.4.20;\n', '\n', 'interface tokenRecipient { \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; \n', '    \n', '}\n', '\n', 'contract owned {\n', '    address public owner;\n', '   \n', '    constructor () public{\n', '        owner = msg.sender;\n', '    }\n', '   \n', '    modifier onlyOwner {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', '  \n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract token {\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '  \n', '    event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件\n', '\n', '    constructor () public{\n', '      \n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '      //避免转帐的地址是0x0\n', '      require(_to != 0x0);\n', '      //检查发送者是否拥有足够余额\n', '      require(balanceOf[_from] >= _value);\n', '      //检查是否溢出\n', '      require(balanceOf[_to] + _value > balanceOf[_to]);\n', '      //保存数据用于后面的判断\n', '      uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '      //从发送者减掉发送额\n', '      balanceOf[_from] -= _value;\n', '      //给接收者加上相同的量\n', '      balanceOf[_to] += _value;\n', '      //通知任何监听该交易的客户端\n', '      emit Transfer(_from, _to, _value);\n', '      //判断买、卖双方的数据是否和转换前一致\n', '      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '  \n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {\n', '        //检查发送者是否拥有足够余额\n', '        require(_value <= allowance[_from][msg.sender]);   // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', ' \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '  \n', '    \n', '}\n', '\n', 'contract XMX is owned, token {\n', '    string public name = &#39;China dragon&#39;; //代币名称\n', '    string public symbol = &#39;CYT3&#39;; //代币符号比如&#39;$&#39;\n', '    uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0\n', '    uint256 public totalSupply; //代币总量\n', '    uint256 initialSupply =0;\n', '  \n', '    //是否冻结帐户的列表\n', '    mapping (address => bool) public frozenAccount;\n', '    //定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address indexed from, uint256 value);  //减去用户余额事件\n', '   \n', '    constructor () token () public {\n', '        //初始化总量\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18\n', '        //给指定帐户初始化代币总量，初始化用于奖励合约创建者\n', '        //balanceOf[msg.sender] = totalSupply;\n', '        balanceOf[this] = totalSupply;\n', '        //设置合约的管理者\n', '        //if(centralMinter != 0 ) owner = centralMinter;\n', '      \n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        //避免转帐的地址是0x0\n', '        require (_to != 0x0);\n', '        //检查发送者是否拥有足够余额\n', '        require (balanceOf[_from] > _value);\n', '        //检查是否溢出\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '        //检查 冻结帐户\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        //从发送者减掉发送额\n', '        balanceOf[_from] -= _value;\n', '        //给接收者加上相同的量\n', '        balanceOf[_to] += _value;\n', '        //通知任何监听该交易的客户端\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        //给指定地址增加代币，同时总量也相加\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    function burn(uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        //给指定帐户减去余额\n', '        balanceOf[msg.sender] -= _value;\n', '        //代币问题做相应扣除\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '  \n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[_from] >= _value);\n', '        //检查 其他帐户 的余额是否够使用\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        //减掉代币\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        //更新总量\n', '        totalSupply -= _value;\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '   \n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'interface tokenRecipient { \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; \n', '    \n', '}\n', '\n', 'contract owned {\n', '    address public owner;\n', '   \n', '    constructor () public{\n', '        owner = msg.sender;\n', '    }\n', '   \n', '    modifier onlyOwner {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', '  \n', '    function transferOwnership(address newOwner) onlyOwner public{\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract token {\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '  \n', '    event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件\n', '\n', '    constructor () public{\n', '      \n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '      //避免转帐的地址是0x0\n', '      require(_to != 0x0);\n', '      //检查发送者是否拥有足够余额\n', '      require(balanceOf[_from] >= _value);\n', '      //检查是否溢出\n', '      require(balanceOf[_to] + _value > balanceOf[_to]);\n', '      //保存数据用于后面的判断\n', '      uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '      //从发送者减掉发送额\n', '      balanceOf[_from] -= _value;\n', '      //给接收者加上相同的量\n', '      balanceOf[_to] += _value;\n', '      //通知任何监听该交易的客户端\n', '      emit Transfer(_from, _to, _value);\n', '      //判断买、卖双方的数据是否和转换前一致\n', '      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '  \n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {\n', '        //检查发送者是否拥有足够余额\n', '        require(_value <= allowance[_from][msg.sender]);   // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', ' \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '  \n', '    \n', '}\n', '\n', 'contract XMX is owned, token {\n', "    string public name = 'China dragon'; //代币名称\n", "    string public symbol = 'CYT3'; //代币符号比如'$'\n", '    uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0\n', '    uint256 public totalSupply; //代币总量\n', '    uint256 initialSupply =0;\n', '  \n', '    //是否冻结帐户的列表\n', '    mapping (address => bool) public frozenAccount;\n', '    //定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address indexed from, uint256 value);  //减去用户余额事件\n', '   \n', '    constructor () token () public {\n', '        //初始化总量\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);    //以太币是10^18，后面18个0，所以默认decimals是18\n', '        //给指定帐户初始化代币总量，初始化用于奖励合约创建者\n', '        //balanceOf[msg.sender] = totalSupply;\n', '        balanceOf[this] = totalSupply;\n', '        //设置合约的管理者\n', '        //if(centralMinter != 0 ) owner = centralMinter;\n', '      \n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        //避免转帐的地址是0x0\n', '        require (_to != 0x0);\n', '        //检查发送者是否拥有足够余额\n', '        require (balanceOf[_from] > _value);\n', '        //检查是否溢出\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '        //检查 冻结帐户\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        //从发送者减掉发送额\n', '        balanceOf[_from] -= _value;\n', '        //给接收者加上相同的量\n', '        balanceOf[_to] += _value;\n', '        //通知任何监听该交易的客户端\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        //给指定地址增加代币，同时总量也相加\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    function burn(uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        //给指定帐户减去余额\n', '        balanceOf[msg.sender] -= _value;\n', '        //代币问题做相应扣除\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '  \n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        //检查帐户余额是否大于要减去的值\n', '        require(balanceOf[_from] >= _value);\n', '        //检查 其他帐户 的余额是否够使用\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        //减掉代币\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        //更新总量\n', '        totalSupply -= _value;\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '   \n', '}']