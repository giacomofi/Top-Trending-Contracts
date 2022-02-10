['/**\n', ' * ERC20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  // token总量\n', '  uint public totalSupply;\n', '  // 获取账户_owner拥有token的数量\n', '  function balanceOf(address _owner) constant returns (uint);\n', '  //获取账户_spender可以从账户_owner中转出token的数量\n', '  function allowance(address _owner, address _spender) constant returns (uint);\n', '  // 从发送者账户中往_to账户转数量为_value的token\n', '  function transfer(address _to, uint _value) returns (bool ok);\n', '  //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool ok);\n', '  // 消息发送账户设置账户_spender能从发送账户中转出数量为_value的token\n', '  function approve(address _spender, uint _value) returns (bool ok);\n', '  //发生转账时必须要触发的事件, 由transfer函数的最后一行代码触发。\n', '  event Transfer(address indexed _from, address indexed _to, uint _value);\n', '  //当函数approve(address spender, uint value)成功执行时必须触发的事件\n', '  event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * 带安全检查的数学运算符\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * 修复了ERC20 short address attack问题的标准ERC20 Token.\n', ' *\n', ' * Based on:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  //创建一个状态变量，该类型将一些address映射到无符号整数uint256。\n', '  mapping(address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /**\n', '   *\n', '   * 修复ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    //从消息发送者账户中减去token数量_value\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    //往接收账户增加token数量_value\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    //触发转币交易事件\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value)  returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    //接收账户增加token数量_value\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    //支出账户_from减去token数量_value\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    //消息发送者可以从账户_from中转出的数量减少_value\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    //触发转币交易事件\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    //允许_spender从_owner中转出的token数\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * 允许token拥有者减少token总量\n', ' * 加Burned事件使其区别于正常的transfers\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '  address public constant BURN_ADDRESS = 0;\n', '\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '  /**\n', '   * 销毁Token\n', '   *\n', '   */\n', '  function burn(uint burnAmount) {\n', '    address burner = msg.sender;\n', '    balances[burner] = safeSub(balances[burner], burnAmount);\n', '    totalSupply = safeSub(totalSupply, burnAmount);\n', '    Burned(burner, burnAmount);\n', '    Transfer(burner, BURN_ADDRESS, burnAmount);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * 发行Ethereum token.\n', ' *\n', ' * 创建token总量并分配给owner.\n', ' * owner之后可以把token分配给其他人\n', ' * owner可以销毁token\n', ' *\n', ' */\n', 'contract HLCToken is BurnableToken {\n', '\n', '  string public name;  // Token名称，例如：Halal chain token\n', '  string public symbol;  // Token标识，例如：HLC\n', '  uint8 public decimals = 18;  // 最多的小数位数 18 是建议的默认值\n', '  uint256 public totalSupply;\n', '  function HLCToken(address _owner, string _name, string _symbol, uint _totalSupply, uint8 _decimals) {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    totalSupply = _totalSupply * 10 ** uint256(_decimals);\n', '    decimals = _decimals;\n', '\n', '    // 把创建token的总量分配给owner\n', '    balances[_owner] = totalSupply;\n', '  }\n', '}']
['/**\n', ' * ERC20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  // token总量\n', '  uint public totalSupply;\n', '  // 获取账户_owner拥有token的数量\n', '  function balanceOf(address _owner) constant returns (uint);\n', '  //获取账户_spender可以从账户_owner中转出token的数量\n', '  function allowance(address _owner, address _spender) constant returns (uint);\n', '  // 从发送者账户中往_to账户转数量为_value的token\n', '  function transfer(address _to, uint _value) returns (bool ok);\n', '  //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool ok);\n', '  // 消息发送账户设置账户_spender能从发送账户中转出数量为_value的token\n', '  function approve(address _spender, uint _value) returns (bool ok);\n', '  //发生转账时必须要触发的事件, 由transfer函数的最后一行代码触发。\n', '  event Transfer(address indexed _from, address indexed _to, uint _value);\n', '  //当函数approve(address spender, uint value)成功执行时必须触发的事件\n', '  event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * 带安全检查的数学运算符\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * 修复了ERC20 short address attack问题的标准ERC20 Token.\n', ' *\n', ' * Based on:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  //创建一个状态变量，该类型将一些address映射到无符号整数uint256。\n', '  mapping(address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /**\n', '   *\n', '   * 修复ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    //从消息发送者账户中减去token数量_value\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    //往接收账户增加token数量_value\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    //触发转币交易事件\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value)  returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    //接收账户增加token数量_value\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    //支出账户_from减去token数量_value\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    //消息发送者可以从账户_from中转出的数量减少_value\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    //触发转币交易事件\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    //允许_spender从_owner中转出的token数\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * 允许token拥有者减少token总量\n', ' * 加Burned事件使其区别于正常的transfers\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '  address public constant BURN_ADDRESS = 0;\n', '\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '  /**\n', '   * 销毁Token\n', '   *\n', '   */\n', '  function burn(uint burnAmount) {\n', '    address burner = msg.sender;\n', '    balances[burner] = safeSub(balances[burner], burnAmount);\n', '    totalSupply = safeSub(totalSupply, burnAmount);\n', '    Burned(burner, burnAmount);\n', '    Transfer(burner, BURN_ADDRESS, burnAmount);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * 发行Ethereum token.\n', ' *\n', ' * 创建token总量并分配给owner.\n', ' * owner之后可以把token分配给其他人\n', ' * owner可以销毁token\n', ' *\n', ' */\n', 'contract HLCToken is BurnableToken {\n', '\n', '  string public name;  // Token名称，例如：Halal chain token\n', '  string public symbol;  // Token标识，例如：HLC\n', '  uint8 public decimals = 18;  // 最多的小数位数 18 是建议的默认值\n', '  uint256 public totalSupply;\n', '  function HLCToken(address _owner, string _name, string _symbol, uint _totalSupply, uint8 _decimals) {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    totalSupply = _totalSupply * 10 ** uint256(_decimals);\n', '    decimals = _decimals;\n', '\n', '    // 把创建token的总量分配给owner\n', '    balances[_owner] = totalSupply;\n', '  }\n', '}']
