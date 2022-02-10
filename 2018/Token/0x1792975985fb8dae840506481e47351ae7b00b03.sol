['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', '/**\n', ' * 一个标准合约\n', ' */\n', 'contract StandardTokenERC20 {\n', '    //- Token 名称\n', '    string public name; \n', '    //- Token 符号\n', '    string public symbol;\n', '    //- Token 小数位\n', '    uint8 public decimals;\n', '    //- Token 总发行量\n', '    uint256 public totalSupply;\n', '    //- 合约锁定状态\n', '    bool public lockAll = true;\n', '    //- 合约创造者\n', '    address public creator;\n', '    //- 合约所有者\n', '    address public owner;\n', '    //- 合约新所有者\n', '    address internal newOwner = 0x0;\n', '\n', '    //- 地址映射关系\n', '    mapping (address => uint256) public balanceOf;\n', '    //- 地址对应 Token\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    //- 冻结列表\n', '    mapping (address => bool) public frozens;\n', '\n', '    //- Token 交易通知事件\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    //- Token 批准通知事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    //- Token 消耗通知事件\n', '    event Burn(address indexed _from, uint256 _value);\n', '    //- 合约所有者变更通知\n', '    event OwnerChanged(address _oldOwner, address _newOwner);\n', '    //- 地址冻结通知\n', '    event FreezeAddress(address _target, bool _frozen);\n', '\n', '    /**\n', '     * 构造函数\n', '     *\n', '     * 初始化一个合约\n', '     * @param initialSupplyHM 初始总量（单位亿）\n', '     * @param tokenName Token 名称\n', '     * @param tokenSymbol Token 符号\n', '     * @param tokenDecimals Token 小数位\n', '     */\n', '    constructor(uint256 initialSupplyHM, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals = tokenDecimals;\n', '        totalSupply = initialSupplyHM * 10000 * 10000 * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        owner = msg.sender;\n', '        creator = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * 所有者修饰符\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * 转移合约所有者\n', '     * @param _newOwner 新合约所有者地址\n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        require(owner != _newOwner);\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    /**\n', '     * 接受并成为新的合约所有者\n', '     */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner && newOwner != 0x0);\n', '        address oldOwner = owner;\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '        emit OwnerChanged(oldOwner, owner);\n', '    }\n', '\n', '    /**\n', '     * 设定合约锁定状态\n', '     * @param _lockAll 状态\n', '     */\n', '    function setLockAll(bool _lockAll) onlyOwner public {\n', '        lockAll = _lockAll;\n', '    }\n', '\n', '    /**\n', '     * 设定账户冻结状态\n', '     * @param _target 冻结目标\n', '     * @param _freeze 冻结状态\n', '     */\n', '    function setFreezeAddress(address _target, bool _freeze) onlyOwner public {\n', '        frozens[_target] = _freeze;\n', '        emit FreezeAddress(_target, _freeze);\n', '    }\n', '\n', '    /**\n', '     * 从持有方转移指定数量的 Token 给接收方\n', '     * @param _from 持有方\n', '     * @param _to 接收方\n', '     * @param _value 数量\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        //- 锁定校验\n', '        require(!lockAll);\n', '        //- 地址有效验证\n', '        require(_to != 0x0);\n', '        //- 余额验证\n', '        require(balanceOf[_from] >= _value);\n', '        //- 非负数验证\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        //- 持有方冻结校验\n', '        require(!frozens[_from]); \n', '        //- 接收方冻结校验\n', '        //require(!frozenAccount[_to]); \n', '\n', '        //- 保存预校验总量\n', '        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        //- 持有方减少代币\n', '        balanceOf[_from] -= _value;\n', '        //- 接收方增加代币\n', '        balanceOf[_to] += _value;\n', '        //- 触发转账事件\n', '        emit Transfer(_from, _to, _value);\n', '        //- 确保交易过后，持有方和接收方持有总量不变\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * 转移转指定数量的 Token 给接收方\n', '     *\n', '     * @param _to 接收方地址\n', '     * @param _value 数量\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 从持有方转移指定数量的 Token 给接收方\n', '     *\n', '     * @param _from 持有方\n', '     * @param _to 接收方\n', '     * @param _value 数量\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //- 授权额度校验\n', '        require(_value <= allowance[_from][msg.sender]);\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 授权指定地址的转移额度\n', '     *\n', '     * @param _spender 代理方\n', '     * @param _value 授权额度\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 授权指定地址的转移额度，并通知代理方合约\n', '     *\n', '     * @param _spender 代理方\n', '     * @param _value 转账最高额度\n', '     * @param _extraData 扩展数据（传递给代理方合约）\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);//- 代理方合约\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function _burn(address _from, uint256 _value) internal {\n', '        //- 锁定校验\n', '        require(!lockAll);\n', '        //- 余额验证\n', '        require(balanceOf[_from] >= _value);\n', '        //- 冻结校验\n', '        require(!frozens[_from]); \n', '\n', '        //- 消耗 Token\n', '        balanceOf[_from] -= _value;\n', '        //- 总量下调\n', '        totalSupply -= _value;\n', '\n', '        emit Burn(_from, _value);\n', '    }\n', '\n', '    /**\n', '     * 消耗指定数量的 Token\n', '     *\n', '     * @param _value 消耗数量\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        _burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * 消耗持有方授权额度内指定数量的 Token\n', '     *\n', '     * @param _from 持有方\n', '     * @param _value 消耗数量\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        //- 授权额度校验\n', '        require(_value <= allowance[_from][msg.sender]);\n', '      \n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        _burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    function() payable public{\n', '    }\n', '}']