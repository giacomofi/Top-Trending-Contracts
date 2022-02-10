['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', 'contract CyberVeinToken is StandardToken {\n', '\n', '  string public constant name = "CyberVeinToken";\n', '  string public constant symbol = "CVT";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 public constant TOTAL_SUPPLY = 2 ** 31 * (10 ** uint256(decimals));\n', '  uint256 public constant PRIVATESALE_SUPPLY = TOTAL_SUPPLY * 60 / 100;\n', '  uint256 public constant PROJECTOPERATION_SUPPLY = TOTAL_SUPPLY * 25 / 100;\n', '  uint256 public constant TEAM_AND_ANGEL_SUPPLY = TOTAL_SUPPLY * 15 / 100;\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public privatesale_beneficiary;\n', '\n', '  address public projectoperation_beneficiary;\n', '\n', '  address public team_and_angel_beneficiary;\n', '  // timestamp when token release is enabled\n', '  uint256 public releaseTime;\n', '\n', '  bool public released;\n', '\n', '  function CyberVeinToken(address _privatesale_beneficiary, address _projectoperation_beneficiary, address _team_and_angel_beneficiary, uint256 _releaseTime) public {\n', '    require(_releaseTime > now);\n', '    totalSupply = TOTAL_SUPPLY;\n', '    privatesale_beneficiary = _privatesale_beneficiary;\n', '    projectoperation_beneficiary = _projectoperation_beneficiary;\n', '    team_and_angel_beneficiary = _team_and_angel_beneficiary;\n', '    releaseTime = _releaseTime;\n', '    released = false;\n', '\n', '    balances[privatesale_beneficiary] = PRIVATESALE_SUPPLY;\n', '    balances[projectoperation_beneficiary] = PROJECTOPERATION_SUPPLY;\n', '  }\n', '\n', '  function release() public {\n', '    require(released == false);\n', '    require(now >= releaseTime);\n', '\n', '    balances[team_and_angel_beneficiary] = TEAM_AND_ANGEL_SUPPLY;\n', '    released = true;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', 'contract CyberVeinToken is StandardToken {\n', '\n', '  string public constant name = "CyberVeinToken";\n', '  string public constant symbol = "CVT";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 public constant TOTAL_SUPPLY = 2 ** 31 * (10 ** uint256(decimals));\n', '  uint256 public constant PRIVATESALE_SUPPLY = TOTAL_SUPPLY * 60 / 100;\n', '  uint256 public constant PROJECTOPERATION_SUPPLY = TOTAL_SUPPLY * 25 / 100;\n', '  uint256 public constant TEAM_AND_ANGEL_SUPPLY = TOTAL_SUPPLY * 15 / 100;\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public privatesale_beneficiary;\n', '\n', '  address public projectoperation_beneficiary;\n', '\n', '  address public team_and_angel_beneficiary;\n', '  // timestamp when token release is enabled\n', '  uint256 public releaseTime;\n', '\n', '  bool public released;\n', '\n', '  function CyberVeinToken(address _privatesale_beneficiary, address _projectoperation_beneficiary, address _team_and_angel_beneficiary, uint256 _releaseTime) public {\n', '    require(_releaseTime > now);\n', '    totalSupply = TOTAL_SUPPLY;\n', '    privatesale_beneficiary = _privatesale_beneficiary;\n', '    projectoperation_beneficiary = _projectoperation_beneficiary;\n', '    team_and_angel_beneficiary = _team_and_angel_beneficiary;\n', '    releaseTime = _releaseTime;\n', '    released = false;\n', '\n', '    balances[privatesale_beneficiary] = PRIVATESALE_SUPPLY;\n', '    balances[projectoperation_beneficiary] = PROJECTOPERATION_SUPPLY;\n', '  }\n', '\n', '  function release() public {\n', '    require(released == false);\n', '    require(now >= releaseTime);\n', '\n', '    balances[team_and_angel_beneficiary] = TEAM_AND_ANGEL_SUPPLY;\n', '    released = true;\n', '  }\n', '\n', '}']
