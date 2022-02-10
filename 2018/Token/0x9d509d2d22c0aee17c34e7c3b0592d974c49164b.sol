['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = _a * _b;\n', '    require(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    require(_b > 0);\n', '    uint256 c = _a / _b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    require(_b <= _a);\n', '    uint256 c = _a - _b;\n', '    return c;\n', '  }\n', '\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    uint256 c = _a + _b;\n', '    require(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  function add(Role storage _role, address _account) internal {\n', '    require(_account != address(0));\n', '    _role.bearer[_account] = true;\n', '  }\n', '\n', '  function remove(Role storage _role, address _account) internal {\n', '    require(_account != address(0));\n', '    _role.bearer[_account] = false;\n', '  }\n', '\n', '  function has(Role storage _role, address _account) internal view returns (bool)\n', '  {\n', '    require(_account != address(0));\n', '    return _role.bearer[_account];\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address _who) external view returns (uint256);\n', '\n', '  function allowance(address _owner, address _spender) external view returns (uint256);\n', '\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) external returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) private balances;\n', '\n', '  mapping(address => mapping (address => uint256)) private allowed;\n', '\n', '  uint256 private totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(_spender != address(0));\n', '    \n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {\n', '    require(_spender != address(0));\n', '\n', '    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '    require(_spender != address(0));\n', '\n', '    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].sub(_subtractedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function _mint(address _account, uint256 _amount) internal {\n', '    require(_account != 0);\n', '\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_account] = balances[_account].add(_amount);\n', '    emit Transfer(address(0), _account, _amount);\n', '  }\n', '\n', '  function _burn(address _account, uint256 _amount) internal {\n', '    require(_account != 0);\n', '    require(_amount <= balances[_account]);\n', '\n', '    totalSupply_ = totalSupply_.sub(_amount);\n', '    balances[_account] = balances[_account].sub(_amount);\n', '    emit Transfer(_account, address(0), _amount);\n', '  }\n', '}\n', '\n', 'contract PauserRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event PauserAdded(address indexed _account);\n', '  event PauserRemoved(address indexed _account);\n', '\n', '  Roles.Role private pausers;\n', '\n', '  constructor() public {\n', '    addPauser_(msg.sender);\n', '  }\n', '\n', '  modifier onlyPauser() {\n', '    require(isPauser(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isPauser(address _account) public view returns (bool) {\n', '    return pausers.has(_account);\n', '  }\n', '\n', '  function addPauser(address _account) public onlyPauser {\n', '    addPauser_(_account);\n', '  }\n', '\n', '  function renouncePauser() public {\n', '    removePauser_(msg.sender);\n', '  }\n', '\n', '  function addPauser_(address _account) internal {\n', '    pausers.add(_account);\n', '    emit PauserAdded(_account);\n', '  }\n', '\n', '  function removePauser_(address _account) internal {\n', '    pausers.remove(_account);\n', '    emit PauserRemoved(_account);\n', '  }\n', '}\n', '\n', 'contract Pausable is PauserRole {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool private paused_ = false;\n', '\n', '  function paused() public view returns(bool) {\n', '    return paused_;\n', '  }\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused_);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused_);\n', '    _;\n', '  }\n', '\n', '  function pause() public onlyPauser whenNotPaused {\n', '    paused_ = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() public onlyPauser whenPaused {\n', '    paused_ = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20Pausable is ERC20, Pausable {\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseAllowance(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseAllowance(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseAllowance(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseAllowance(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract XEXToken is ERC20Pausable {\n', '  string public constant name = "Cross exchange token";\n', '  string public constant symbol = "XEX";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));\n', '\n', '  constructor() public {\n', '    _mint(msg.sender, INITIAL_SUPPLY);\n', '  }\n', '}']