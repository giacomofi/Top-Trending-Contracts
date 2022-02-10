['pragma solidity ^0.4.24;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) { return 0; }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  address public pendingOwner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    pendingOwner = address(0);\n', '  }\n', '\n', '\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) onlyOwner external {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  function claimOwnership() external {\n', '    require(msg.sender == pendingOwner);\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused external {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused external {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract TokenBase is ERC20, Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  modifier isValidDestination(address _to) {\n', '    require(_to != address(0x0));\n', '    require(_to != address(this));\n', '    _;\n', '  }\n', '\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {\n', '    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract MintableToken is TokenBase {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() onlyOwner canMint external returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is MintableToken {\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '  function burn(uint256 _value) external {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(msg.sender, _value);\n', '    emit Transfer(msg.sender, address(0), _value);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract SleekPlayToken is BurnableToken {\n', '  string public constant name = "SleekPlay Token";\n', '  string public constant symbol = "SKP";\n', '  uint8 public constant decimals = 18;\n', '\n', '\n', '  /**\n', '  * @dev Allows the owner to take out wrongly sent tokens to this contract by mistake.\n', '  * @param _token The contract address of the token that is getting pulled out.\n', '  * @param _amount The amount to pull out.\n', '  */\n', '  function pullOut(ERC20 _token, uint256 _amount) external onlyOwner {\n', '    _token.transfer(owner, _amount);\n', '  }\n', '\n', '  /**\n', '  * @dev &#39;tokenFallback&#39; function in accordance to the ERC223 standard. Rejects all incoming ERC223 token transfers.\n', '  */\n', '  function tokenFallback(address from_, uint256 value_, bytes data_) public {\n', '    from_; value_; data_;\n', '    revert();\n', '  }\n', '\n', '  function() external payable {\n', '      revert("This contract does not accept Ethereum!");\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) { return 0; }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  address public pendingOwner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    pendingOwner = address(0);\n', '  }\n', '\n', '\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) onlyOwner external {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  function claimOwnership() external {\n', '    require(msg.sender == pendingOwner);\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused external {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused external {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract TokenBase is ERC20, Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  modifier isValidDestination(address _to) {\n', '    require(_to != address(0x0));\n', '    require(_to != address(this));\n', '    _;\n', '  }\n', '\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {\n', '    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract MintableToken is TokenBase {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() onlyOwner canMint external returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is MintableToken {\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '  function burn(uint256 _value) external {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(msg.sender, _value);\n', '    emit Transfer(msg.sender, address(0), _value);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract SleekPlayToken is BurnableToken {\n', '  string public constant name = "SleekPlay Token";\n', '  string public constant symbol = "SKP";\n', '  uint8 public constant decimals = 18;\n', '\n', '\n', '  /**\n', '  * @dev Allows the owner to take out wrongly sent tokens to this contract by mistake.\n', '  * @param _token The contract address of the token that is getting pulled out.\n', '  * @param _amount The amount to pull out.\n', '  */\n', '  function pullOut(ERC20 _token, uint256 _amount) external onlyOwner {\n', '    _token.transfer(owner, _amount);\n', '  }\n', '\n', '  /**\n', "  * @dev 'tokenFallback' function in accordance to the ERC223 standard. Rejects all incoming ERC223 token transfers.\n", '  */\n', '  function tokenFallback(address from_, uint256 value_, bytes data_) public {\n', '    from_; value_; data_;\n', '    revert();\n', '  }\n', '\n', '  function() external payable {\n', '      revert("This contract does not accept Ethereum!");\n', '    }\n', '\n', '}']
