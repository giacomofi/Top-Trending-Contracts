['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  bool public paused = false;\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused returns(bool) {\n', '    paused = true;\n', '    emit Pause();\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused returns(bool) {\n', '    paused = false;\n', '    emit Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '  uint256 public totalSupply;\n', '\n', '  function transfer(address _to, uint256 _value) public returns(bool success);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);\n', '\n', '  function balanceOf(address _owner) constant public returns(uint256 balance);\n', '\n', '  function approve(address _spender, uint256 _value) public returns(bool success);\n', '\n', '  function allowance(address _owner, address _spender) constant public returns(uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract BasicToken is ERC20, Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  event Frozen(address indexed _address, bool _value);\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => bool) public frozens;\n', '  mapping(address => mapping(address => uint256)) allowed;\n', '\n', '  function _transfer(address _from, address _to, uint256 _value) internal returns(bool success) {\n', '    require(_to != 0x0);\n', '    require(_value > 0);\n', '    require(frozens[_from] == false);\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns(bool success) {\n', '    require(balances[msg.sender] >= _value);\n', '    return _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool success) {\n', '    require(balances[_from] >= _value);\n', '    require(allowed[_from][msg.sender] >= _value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    return _transfer(_from, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant public returns(uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns(bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant public returns(uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function freeze(address[] _targets, bool _value) public onlyOwner returns(bool success) {\n', '    require(_targets.length > 0);\n', '    require(_targets.length <= 255);\n', '    for (uint8 i = 0; i < _targets.length; i++) {\n', '      assert(_targets[i] != 0x0);\n', '      frozens[_targets[i]] = _value;\n', '      emit Frozen(_targets[i], _value);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function transferMulti(address[] _to, uint256[] _value) public whenNotPaused returns(bool success) {\n', '    require(_to.length > 0);\n', '    require(_to.length <= 255);\n', '    require(_to.length == _value.length);\n', '    require(frozens[msg.sender] == false);\n', '    uint8 i;\n', '    uint256 amount;\n', '    for (i = 0; i < _to.length; i++) {\n', '      assert(_to[i] != 0x0);\n', '      assert(_value[i] > 0);\n', '      amount = amount.add(_value[i]);\n', '    }\n', '    require(balances[msg.sender] >= amount);\n', '    balances[msg.sender] = balances[msg.sender].sub(amount);\n', '    for (i = 0; i < _to.length; i++) {\n', '      balances[_to[i]] = balances[_to[i]].add(_value[i]);\n', '      emit Transfer(msg.sender, _to[i], _value[i]);\n', '    }\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract CTCK is BasicToken {\n', '\n', '  string public constant name = "CTCK";\n', '  string public constant symbol = "CTCK";\n', '  uint256 public constant decimals = 18;\n', '\n', '  constructor() public {\n', '    // 私募\n', '    _assign(0xF51E57F12ED5d44761d4480633FD6c5632A5B2B1, 1500);\n', '    // 团队\n', '    _assign(0x44C63e5EEa2b75Bb79D77BEF45716724f4A662eC, 1500);\n', '    // 商城返利\n', '    _assign(0x21d47FCDA2FAe5E3D7f45b6f0b71372df3F6acE4, 1000);\n', '    // 推广分红\n', '    _assign(0x64659538446aE6f80b96219B3E2bEe4EED40C045, 250);\n', '    // 持仓分红\n', '    _assign(0xAaED68389Fd3f5c3254744c8D3e42E3B141c706D, 250);\n', '    // 交易分红\n', '    _assign(0x35ab3BDEeD40fb8Cd9E5795Ce33A01Ae00d8b59B, 250);\n', '    // 二次分红\n', '    _assign(0x8A3382E8aF54130859Cdd387aeA16B3A3F2A784b, 250);\n', '  }\n', '\n', '  function _assign(address _address, uint256 _value) private {\n', '    uint256 amount = _value * (10 ** 6) * (10 ** decimals);\n', '    balances[_address] = amount;\n', '    allowed[_address][owner] = amount;\n', '    totalSupply = totalSupply.add(amount);\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  bool public paused = false;\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused returns(bool) {\n', '    paused = true;\n', '    emit Pause();\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused returns(bool) {\n', '    paused = false;\n', '    emit Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '  uint256 public totalSupply;\n', '\n', '  function transfer(address _to, uint256 _value) public returns(bool success);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);\n', '\n', '  function balanceOf(address _owner) constant public returns(uint256 balance);\n', '\n', '  function approve(address _spender, uint256 _value) public returns(bool success);\n', '\n', '  function allowance(address _owner, address _spender) constant public returns(uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract BasicToken is ERC20, Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  event Frozen(address indexed _address, bool _value);\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => bool) public frozens;\n', '  mapping(address => mapping(address => uint256)) allowed;\n', '\n', '  function _transfer(address _from, address _to, uint256 _value) internal returns(bool success) {\n', '    require(_to != 0x0);\n', '    require(_value > 0);\n', '    require(frozens[_from] == false);\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns(bool success) {\n', '    require(balances[msg.sender] >= _value);\n', '    return _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool success) {\n', '    require(balances[_from] >= _value);\n', '    require(allowed[_from][msg.sender] >= _value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    return _transfer(_from, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant public returns(uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns(bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant public returns(uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function freeze(address[] _targets, bool _value) public onlyOwner returns(bool success) {\n', '    require(_targets.length > 0);\n', '    require(_targets.length <= 255);\n', '    for (uint8 i = 0; i < _targets.length; i++) {\n', '      assert(_targets[i] != 0x0);\n', '      frozens[_targets[i]] = _value;\n', '      emit Frozen(_targets[i], _value);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function transferMulti(address[] _to, uint256[] _value) public whenNotPaused returns(bool success) {\n', '    require(_to.length > 0);\n', '    require(_to.length <= 255);\n', '    require(_to.length == _value.length);\n', '    require(frozens[msg.sender] == false);\n', '    uint8 i;\n', '    uint256 amount;\n', '    for (i = 0; i < _to.length; i++) {\n', '      assert(_to[i] != 0x0);\n', '      assert(_value[i] > 0);\n', '      amount = amount.add(_value[i]);\n', '    }\n', '    require(balances[msg.sender] >= amount);\n', '    balances[msg.sender] = balances[msg.sender].sub(amount);\n', '    for (i = 0; i < _to.length; i++) {\n', '      balances[_to[i]] = balances[_to[i]].add(_value[i]);\n', '      emit Transfer(msg.sender, _to[i], _value[i]);\n', '    }\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract CTCK is BasicToken {\n', '\n', '  string public constant name = "CTCK";\n', '  string public constant symbol = "CTCK";\n', '  uint256 public constant decimals = 18;\n', '\n', '  constructor() public {\n', '    // 私募\n', '    _assign(0xF51E57F12ED5d44761d4480633FD6c5632A5B2B1, 1500);\n', '    // 团队\n', '    _assign(0x44C63e5EEa2b75Bb79D77BEF45716724f4A662eC, 1500);\n', '    // 商城返利\n', '    _assign(0x21d47FCDA2FAe5E3D7f45b6f0b71372df3F6acE4, 1000);\n', '    // 推广分红\n', '    _assign(0x64659538446aE6f80b96219B3E2bEe4EED40C045, 250);\n', '    // 持仓分红\n', '    _assign(0xAaED68389Fd3f5c3254744c8D3e42E3B141c706D, 250);\n', '    // 交易分红\n', '    _assign(0x35ab3BDEeD40fb8Cd9E5795Ce33A01Ae00d8b59B, 250);\n', '    // 二次分红\n', '    _assign(0x8A3382E8aF54130859Cdd387aeA16B3A3F2A784b, 250);\n', '  }\n', '\n', '  function _assign(address _address, uint256 _value) private {\n', '    uint256 amount = _value * (10 ** 6) * (10 ** decimals);\n', '    balances[_address] = amount;\n', '    allowed[_address][owner] = amount;\n', '    totalSupply = totalSupply.add(amount);\n', '  }\n', '}']