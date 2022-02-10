['pragma solidity ^0.4.18;\n', '\n', 'contract Owner {\n', '    address public owner;\n', '    //添加断路器\n', '    bool public stopped = false;\n', '\n', '    function Owner() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '       require (msg.sender == owner);\n', '       _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require (newOwner != 0x0);\n', '        require (newOwner != owner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function toggleContractActive() onlyOwner public {\n', '        //可以预置改变状态的条件，如基于投票人数\n', '        stopped = !stopped;\n', '    }\n', '\n', '    modifier stopInEmergency {\n', '        require(stopped == false);\n', '        _;\n', '    }\n', '\n', '    modifier onlyInEmergency {\n', '        require(stopped == true);\n', '        _;\n', '    }\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '}\n', '\n', 'contract Mortal is Owner {\n', '    //销毁合约\n', '    function close() external onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token is Owner, Mortal {\n', '    using SafeMath for uint256;\n', '\n', '    string public name; //代币名称\n', '    string public symbol; //代币符号\n', '    uint8 public decimals; //显示多少小数点\n', '    uint256 public totalSupply; //总供应量\n', '\n', '    //冻结的基金,解锁的数量根据时间动态计算出来\n', '    struct Fund{\n', '        uint amount;            //总冻结数量，固定值\n', '\n', '        uint unlockStartTime;   //从什么时候开始解锁\n', '        uint unlockInterval;    //每次解锁的周期，单位 秒\n', '        uint unlockPercent;     //每次解锁的百分比 50 为50%\n', '\n', '        bool isValue; // exist value\n', '    }\n', '\n', '    //所有的账户数据\n', '    mapping (address => uint) public balances;\n', '    //代理\n', '    mapping(address => mapping(address => uint)) approved;\n', '\n', '    //所有的账户冻结数据，时间，到期自动解冻，同时只支持一次冻结\n', '    mapping (address => Fund) public frozenAccount;\n', '\n', '    //事件日志\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event FrozenFunds(address indexed target, uint value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent);\n', '    event Approval(address indexed accountOwner, address indexed spender, uint256 value);\n', '\n', '    /**\n', '    *\n', '    * Fix for the ERC20 short address attack\n', '    *\n', '    * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '    */\n', '    modifier onlyPayloadSize(uint256 size) {\n', '        require(msg.data.length == size + 4);\n', '        _;\n', '    }\n', '\n', '    //冻结固定时间\n', '    function freezeAccount(address target, uint value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent) external onlyOwner freezeOutCheck(target, 0) {\n', '        require (value > 0);\n', '        require (frozenAccount[target].isValue == false);\n', '        require (balances[msg.sender] >= value);\n', '        require (unlockStartTime > now);\n', '        require (unlockInterval > 0);\n', '        require (unlockPercent > 0 && unlockPercent <= 100);\n', '\n', '        uint unlockIntervalSecond = toSecond(unlockIntervalUnit, unlockInterval);\n', '\n', '        frozenAccount[target] = Fund(value, unlockStartTime, unlockIntervalSecond, unlockPercent, true);\n', '        emit FrozenFunds(target, value, unlockStartTime, unlockIntervalUnit, unlockInterval, unlockPercent);\n', '    }\n', '\n', '    //转账并冻结\n', '    function transferAndFreeze(address target, uint256 value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent) external onlyOwner freezeOutCheck(target, 0) {\n', '        require (value > 0);\n', '        require (frozenAccount[target].isValue == false);\n', '        require (unlockStartTime > now);\n', '        require (unlockInterval > 0);\n', '        require (unlockPercent > 0 && unlockPercent <= 100);\n', '\n', '        _transfer(msg.sender, target, value);\n', '\n', '        uint unlockIntervalSecond = toSecond(unlockIntervalUnit, unlockInterval);\n', '        frozenAccount[target] = Fund(value, unlockStartTime, unlockIntervalSecond, unlockPercent, true);\n', '        emit FrozenFunds(target, value, unlockStartTime, unlockIntervalUnit, unlockInterval, unlockPercent);\n', '    }\n', '\n', '    //转换单位时间到秒\n', '    function toSecond(uint unitType, uint value) internal pure returns (uint256 Seconds) {\n', '        uint _seconds;\n', '        if (unitType == 5){\n', '            _seconds = value.mul(1 years);\n', '        }else if(unitType == 4){\n', '            _seconds = value.mul(1 days);\n', '        }else if (unitType == 3){\n', '            _seconds = value.mul(1 hours);\n', '        }else if (unitType == 2){\n', '            _seconds = value.mul(1 minutes);\n', '        }else if (unitType == 1){\n', '            _seconds = value;\n', '        }else{\n', '            revert();\n', '        }\n', '        return _seconds;\n', '    }\n', '\n', '    modifier freezeOutCheck(address sender, uint value) {\n', '        require ( getAvailableBalance(sender) >= value);\n', '        _;\n', '    }\n', '\n', '    //计算可用余额 去除冻结部分\n', '    function getAvailableBalance(address sender) internal returns(uint balance) {\n', '        if (frozenAccount[sender].isValue) {\n', '            //未开始解锁\n', '            if (now < frozenAccount[sender].unlockStartTime){\n', '                return balances[sender] - frozenAccount[sender].amount;\n', '            }else{\n', '                //计算解锁了多少数量\n', '                uint unlockPercent = ((now - frozenAccount[sender].unlockStartTime ) / frozenAccount[sender].unlockInterval + 1) * frozenAccount[sender].unlockPercent;\n', '                if (unlockPercent > 100){\n', '                    unlockPercent = 100;\n', '                }\n', '\n', '                //计算可用余额 = 总额 - 冻结总额\n', '                assert(frozenAccount[sender].amount <= balances[sender]);\n', '                uint available = balances[sender] - (100 - unlockPercent) * frozenAccount[sender].amount / 100;\n', '                if ( unlockPercent >= 100){\n', '                    //release\n', '                    frozenAccount[sender].isValue = false;\n', '                    delete frozenAccount[sender];\n', '                }\n', '\n', '                return available;\n', '            }\n', '        }\n', '        return balances[sender];\n', '    }\n', '\n', '    function balanceOf(address sender) constant external returns (uint256 balance){\n', '        return balances[sender];\n', '    }\n', '\n', '    /* 代币转移的函数 */\n', '    function transfer(address to, uint256 value) external stopInEmergency onlyPayloadSize(2 * 32) {\n', '        _transfer(msg.sender, to, value);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal freezeOutCheck(_from, _value) {\n', '        require(_to != 0x0);\n', '        require(_from != _to);\n', '        require(_value > 0);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    //设置代理交易\n', '    //允许spender多次取出您的帐户，最高达value金额。value可以设置超过账户余额\n', '    function approve(address spender, uint value) external returns (bool success) {\n', '        approved[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    //返回spender仍然被允许从accountOwner提取的金额\n', '    function allowance(address accountOwner, address spender) constant external returns (uint remaining) {\n', '        return approved[accountOwner][spender];\n', '    }\n', '\n', '    //使用代理交易\n', '    //0值的传输必须被视为正常传输并触发传输事件\n', '    //代理交易不自动为对方补充gas\n', '    function transferFrom(address from, address to, uint256 value) external stopInEmergency freezeOutCheck(from, value)  returns (bool success) {\n', '        require(value > 0);\n', '        require(value <= approved[from][msg.sender]);\n', '        require(value <= balances[from]);\n', '\n', '        approved[from][msg.sender] = approved[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MigrationAgent {\n', '  function migrateFrom(address from, uint256 value) public;\n', '}\n', '\n', 'contract UpgradeableToken is Owner, Token {\n', '  address public migrationAgent;\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  // Migrate tokens to the new token contract\n', '  function migrate() public {\n', '    require(migrationAgent != 0);\n', '    uint value = balances[msg.sender];\n', '    balances[msg.sender] = balances[msg.sender].sub(value);\n', '    totalSupply = totalSupply.sub(value);\n', '    MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);\n', '    emit Upgrade(msg.sender, migrationAgent, value);\n', '  }\n', '\n', '  function () public payable {\n', '    require(migrationAgent != 0);\n', '    require(balances[msg.sender] > 0);\n', '    migrate();\n', '    msg.sender.transfer(msg.value);\n', '  }\n', '\n', '  function setMigrationAgent(address _agent) onlyOwner external {\n', '    migrationAgent = _agent;\n', '    emit UpgradeAgentSet(_agent);\n', '  }\n', '}\n', '\n', 'contract MIToken is UpgradeableToken {\n', '\n', '  function MIToken() public {\n', '    name = "MI Token";\n', '    symbol = "MI";\n', '    decimals = 18;\n', '\n', '    owner = msg.sender;\n', '    uint initialSupply = 100000000;\n', '\n', '    totalSupply = initialSupply * 10 ** uint256(decimals);\n', '    require (totalSupply >= initialSupply);\n', '\n', '    balances[msg.sender] = totalSupply;\n', '    emit Transfer(0x0, msg.sender, totalSupply);\n', '  }\n', '  \n', '  function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {\n', '      totalSupply = totalSupply.add(_amount);\n', '      balances[_to] = balances[_to].add(_amount);\n', '      \n', '      emit Transfer(address(0), _to, _amount);\n', '      return true;\n', '  }\n', '  \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Owner {\n', '    address public owner;\n', '    //添加断路器\n', '    bool public stopped = false;\n', '\n', '    function Owner() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '       require (msg.sender == owner);\n', '       _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require (newOwner != 0x0);\n', '        require (newOwner != owner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function toggleContractActive() onlyOwner public {\n', '        //可以预置改变状态的条件，如基于投票人数\n', '        stopped = !stopped;\n', '    }\n', '\n', '    modifier stopInEmergency {\n', '        require(stopped == false);\n', '        _;\n', '    }\n', '\n', '    modifier onlyInEmergency {\n', '        require(stopped == true);\n', '        _;\n', '    }\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '}\n', '\n', 'contract Mortal is Owner {\n', '    //销毁合约\n', '    function close() external onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token is Owner, Mortal {\n', '    using SafeMath for uint256;\n', '\n', '    string public name; //代币名称\n', '    string public symbol; //代币符号\n', '    uint8 public decimals; //显示多少小数点\n', '    uint256 public totalSupply; //总供应量\n', '\n', '    //冻结的基金,解锁的数量根据时间动态计算出来\n', '    struct Fund{\n', '        uint amount;            //总冻结数量，固定值\n', '\n', '        uint unlockStartTime;   //从什么时候开始解锁\n', '        uint unlockInterval;    //每次解锁的周期，单位 秒\n', '        uint unlockPercent;     //每次解锁的百分比 50 为50%\n', '\n', '        bool isValue; // exist value\n', '    }\n', '\n', '    //所有的账户数据\n', '    mapping (address => uint) public balances;\n', '    //代理\n', '    mapping(address => mapping(address => uint)) approved;\n', '\n', '    //所有的账户冻结数据，时间，到期自动解冻，同时只支持一次冻结\n', '    mapping (address => Fund) public frozenAccount;\n', '\n', '    //事件日志\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event FrozenFunds(address indexed target, uint value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent);\n', '    event Approval(address indexed accountOwner, address indexed spender, uint256 value);\n', '\n', '    /**\n', '    *\n', '    * Fix for the ERC20 short address attack\n', '    *\n', '    * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '    */\n', '    modifier onlyPayloadSize(uint256 size) {\n', '        require(msg.data.length == size + 4);\n', '        _;\n', '    }\n', '\n', '    //冻结固定时间\n', '    function freezeAccount(address target, uint value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent) external onlyOwner freezeOutCheck(target, 0) {\n', '        require (value > 0);\n', '        require (frozenAccount[target].isValue == false);\n', '        require (balances[msg.sender] >= value);\n', '        require (unlockStartTime > now);\n', '        require (unlockInterval > 0);\n', '        require (unlockPercent > 0 && unlockPercent <= 100);\n', '\n', '        uint unlockIntervalSecond = toSecond(unlockIntervalUnit, unlockInterval);\n', '\n', '        frozenAccount[target] = Fund(value, unlockStartTime, unlockIntervalSecond, unlockPercent, true);\n', '        emit FrozenFunds(target, value, unlockStartTime, unlockIntervalUnit, unlockInterval, unlockPercent);\n', '    }\n', '\n', '    //转账并冻结\n', '    function transferAndFreeze(address target, uint256 value, uint unlockStartTime, uint unlockIntervalUnit, uint unlockInterval, uint unlockPercent) external onlyOwner freezeOutCheck(target, 0) {\n', '        require (value > 0);\n', '        require (frozenAccount[target].isValue == false);\n', '        require (unlockStartTime > now);\n', '        require (unlockInterval > 0);\n', '        require (unlockPercent > 0 && unlockPercent <= 100);\n', '\n', '        _transfer(msg.sender, target, value);\n', '\n', '        uint unlockIntervalSecond = toSecond(unlockIntervalUnit, unlockInterval);\n', '        frozenAccount[target] = Fund(value, unlockStartTime, unlockIntervalSecond, unlockPercent, true);\n', '        emit FrozenFunds(target, value, unlockStartTime, unlockIntervalUnit, unlockInterval, unlockPercent);\n', '    }\n', '\n', '    //转换单位时间到秒\n', '    function toSecond(uint unitType, uint value) internal pure returns (uint256 Seconds) {\n', '        uint _seconds;\n', '        if (unitType == 5){\n', '            _seconds = value.mul(1 years);\n', '        }else if(unitType == 4){\n', '            _seconds = value.mul(1 days);\n', '        }else if (unitType == 3){\n', '            _seconds = value.mul(1 hours);\n', '        }else if (unitType == 2){\n', '            _seconds = value.mul(1 minutes);\n', '        }else if (unitType == 1){\n', '            _seconds = value;\n', '        }else{\n', '            revert();\n', '        }\n', '        return _seconds;\n', '    }\n', '\n', '    modifier freezeOutCheck(address sender, uint value) {\n', '        require ( getAvailableBalance(sender) >= value);\n', '        _;\n', '    }\n', '\n', '    //计算可用余额 去除冻结部分\n', '    function getAvailableBalance(address sender) internal returns(uint balance) {\n', '        if (frozenAccount[sender].isValue) {\n', '            //未开始解锁\n', '            if (now < frozenAccount[sender].unlockStartTime){\n', '                return balances[sender] - frozenAccount[sender].amount;\n', '            }else{\n', '                //计算解锁了多少数量\n', '                uint unlockPercent = ((now - frozenAccount[sender].unlockStartTime ) / frozenAccount[sender].unlockInterval + 1) * frozenAccount[sender].unlockPercent;\n', '                if (unlockPercent > 100){\n', '                    unlockPercent = 100;\n', '                }\n', '\n', '                //计算可用余额 = 总额 - 冻结总额\n', '                assert(frozenAccount[sender].amount <= balances[sender]);\n', '                uint available = balances[sender] - (100 - unlockPercent) * frozenAccount[sender].amount / 100;\n', '                if ( unlockPercent >= 100){\n', '                    //release\n', '                    frozenAccount[sender].isValue = false;\n', '                    delete frozenAccount[sender];\n', '                }\n', '\n', '                return available;\n', '            }\n', '        }\n', '        return balances[sender];\n', '    }\n', '\n', '    function balanceOf(address sender) constant external returns (uint256 balance){\n', '        return balances[sender];\n', '    }\n', '\n', '    /* 代币转移的函数 */\n', '    function transfer(address to, uint256 value) external stopInEmergency onlyPayloadSize(2 * 32) {\n', '        _transfer(msg.sender, to, value);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal freezeOutCheck(_from, _value) {\n', '        require(_to != 0x0);\n', '        require(_from != _to);\n', '        require(_value > 0);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    //设置代理交易\n', '    //允许spender多次取出您的帐户，最高达value金额。value可以设置超过账户余额\n', '    function approve(address spender, uint value) external returns (bool success) {\n', '        approved[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    //返回spender仍然被允许从accountOwner提取的金额\n', '    function allowance(address accountOwner, address spender) constant external returns (uint remaining) {\n', '        return approved[accountOwner][spender];\n', '    }\n', '\n', '    //使用代理交易\n', '    //0值的传输必须被视为正常传输并触发传输事件\n', '    //代理交易不自动为对方补充gas\n', '    function transferFrom(address from, address to, uint256 value) external stopInEmergency freezeOutCheck(from, value)  returns (bool success) {\n', '        require(value > 0);\n', '        require(value <= approved[from][msg.sender]);\n', '        require(value <= balances[from]);\n', '\n', '        approved[from][msg.sender] = approved[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MigrationAgent {\n', '  function migrateFrom(address from, uint256 value) public;\n', '}\n', '\n', 'contract UpgradeableToken is Owner, Token {\n', '  address public migrationAgent;\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  // Migrate tokens to the new token contract\n', '  function migrate() public {\n', '    require(migrationAgent != 0);\n', '    uint value = balances[msg.sender];\n', '    balances[msg.sender] = balances[msg.sender].sub(value);\n', '    totalSupply = totalSupply.sub(value);\n', '    MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);\n', '    emit Upgrade(msg.sender, migrationAgent, value);\n', '  }\n', '\n', '  function () public payable {\n', '    require(migrationAgent != 0);\n', '    require(balances[msg.sender] > 0);\n', '    migrate();\n', '    msg.sender.transfer(msg.value);\n', '  }\n', '\n', '  function setMigrationAgent(address _agent) onlyOwner external {\n', '    migrationAgent = _agent;\n', '    emit UpgradeAgentSet(_agent);\n', '  }\n', '}\n', '\n', 'contract MIToken is UpgradeableToken {\n', '\n', '  function MIToken() public {\n', '    name = "MI Token";\n', '    symbol = "MI";\n', '    decimals = 18;\n', '\n', '    owner = msg.sender;\n', '    uint initialSupply = 100000000;\n', '\n', '    totalSupply = initialSupply * 10 ** uint256(decimals);\n', '    require (totalSupply >= initialSupply);\n', '\n', '    balances[msg.sender] = totalSupply;\n', '    emit Transfer(0x0, msg.sender, totalSupply);\n', '  }\n', '  \n', '  function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {\n', '      totalSupply = totalSupply.add(_amount);\n', '      balances[_to] = balances[_to].add(_amount);\n', '      \n', '      emit Transfer(address(0), _to, _amount);\n', '      return true;\n', '  }\n', '  \n', '}']
