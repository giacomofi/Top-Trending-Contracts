['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract SPBToken is StandardToken {\n', '\n', '  address public administror;\n', '  string public name = "SPBToken";\n', '  string public symbol = "SPB";\n', '  uint8 public decimals = 8;\n', '  uint256 public INITIAL_SUPPLY = 1000000000*10**8;\n', '  mapping (address => uint256) public frozenAccount;\n', '\n', '  // 事件\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Burn(address indexed target, uint256 value);\n', '\n', '  constructor() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    administror = msg.sender;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '\n', '  // 增发\n', '  function SEOS(uint256 _amount) public returns (bool) {\n', '    require(msg.sender == administror);\n', '    balances[msg.sender] = balances[msg.sender].add(_amount);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    INITIAL_SUPPLY = totalSupply_;\n', '    return true;\n', '  }\n', '\n', '  // 锁定帐户\n', '  function freezeAccount(address _target, uint _timestamp) public returns (bool) {\n', '    require(msg.sender == administror);\n', '    require(_target != address(0));\n', '    frozenAccount[_target] = _timestamp;\n', '    return true;\n', '  }\n', '\n', '  // 批量锁定帐户\n', '  function multiFreezeAccount(address[] _targets, uint _timestamp) public returns (bool) {\n', '    require(msg.sender == administror);\n', '    uint256 len = _targets.length;\n', '    require(len > 0);\n', '    for (uint256 i = 0; i < len; i = i.add(1)) {\n', '      address _target = _targets[i];\n', '      require(_target != address(0));\n', '      frozenAccount[_target] = _timestamp;\n', '    }\n', '    return true;\n', '  }\n', '\n', '  // 转帐\n', '  function transfer(address _target, uint256 _amount) public returns (bool) {\n', '    require(now > frozenAccount[msg.sender]);\n', '    require(_target != address(0));\n', '    require(balances[msg.sender] >= _amount);\n', '    balances[_target] = balances[_target].add(_amount);\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '\n', '    emit Transfer(msg.sender, _target, _amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  // 批量转帐\n', '  function multiTransfer(address[] _targets, uint256[] _amounts) public returns (bool) {\n', '    require(now > frozenAccount[msg.sender]);\n', '    uint256 len = _targets.length;\n', '    require(len > 0);\n', '    uint256 totalAmount = 0;\n', '    for (uint256 i = 0; i < len; i = i.add(1)) {\n', '      totalAmount = totalAmount.add(_amounts[i]);\n', '    }\n', '    require(balances[msg.sender] >= totalAmount);\n', '    for (uint256 j = 0; j < len; j = j.add(1)) {\n', '      address _target = _targets[j];\n', '      uint256 _amount = _amounts[j];\n', '      require(_target != address(0));\n', '      balances[_target] = balances[_target].add(_amount);\n', '      balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '\n', '      emit Transfer(msg.sender, _target, _amount);\n', '    }\n', '  }\n', '\n', '  // 燃烧\n', '  function burn(address _target, uint256 _amount) public returns (bool) {\n', '    require(msg.sender == administror);\n', '    require(_target != address(0));\n', '    require(balances[_target] >= _amount);\n', '    balances[_target] = balances[_target].sub(_amount);\n', '    totalSupply_ = totalSupply_.sub(_amount);\n', '    INITIAL_SUPPLY = totalSupply_;\n', '\n', '    emit Burn(_target, _amount);\n', '\n', '    return true;\n', '  }\n', '\n', '  // 查询帐户是否被锁定\n', '  function frozenOf(address _target) public view returns (uint256) {\n', '    require(_target != address(0));\n', '    return frozenAccount[_target];\n', '  }\n', '}']