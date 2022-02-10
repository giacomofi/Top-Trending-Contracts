['pragma solidity 0.4.24;\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '      function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '// assert(a == b * c + a % b); \n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'assert(b <= a);\n', 'return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'uint256 c = a + b;\n', 'assert(c >= a);\n', 'return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', 'require(_to != address(0));\n', 'require(_value <= balances[msg.sender]);\n', '\n', '// SafeMath.sub will throw if there is not enough balance.\n', 'balances[msg.sender] = balances[msg.sender].sub(_value);\n', 'balances[_to] = balances[_to].add(_value);\n', 'emit Transfer(msg.sender, _to, _value);\n', 'return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', 'return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', 'require(_to != address(0));\n', 'require(_value <= balances[_from]);\n', 'require(_value <= allowed[_from][msg.sender]);\n', '\n', 'balances[_from] = balances[_from].sub(_value);\n', 'balances[_to] = balances[_to].add(_value);\n', 'allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', 'emit Transfer(_from, _to, _value);\n', 'return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', 'allowed[msg.sender][_spender] = _value;\n', 'emit Approval(msg.sender, _spender, _value);\n', 'return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', 'return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', 'allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', 'emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', 'return true;\n', '  }\n', '\n', '        function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', 'uint oldValue = allowed[msg.sender][_spender];\n', 'if (_subtractedValue > oldValue) {\n', '  allowed[msg.sender][_spender] = 0;\n', '} else {\n', '  allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '}\n', 'emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', 'return true;\n', '  }\n', '\n', '    }\n', '\n', 'contract Ownable {\n', '   address public owner;\n', '\n', '\n', '   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  function Ownable() public {\n', 'owner = msg.sender;\n', '  }\n', '\n', '   modifier onlyOwner() {\n', 'require(msg.sender == owner);\n', '_;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', 'require(newOwner != address(0));\n', 'emit OwnershipTransferred(owner, newOwner);\n', 'owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '   event Pause();\n', '   event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', 'require(!paused);\n', '_;\n', '  }\n', '\n', '  modifier whenPaused() {\n', 'require(paused);\n', '_;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', 'paused = true;\n', 'emit Pause();\n', '  }\n', '\n', '   function unpause() onlyOwner whenPaused public {\n', 'paused = false;\n', 'emit Unpause();\n', '  }\n', ' }\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.transfer(_to, _value);\n', '  }\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.transferFrom(_from, _to, _value);\n', '   }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', 'return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', 'return super.decreaseApproval(_spender, _subtractedValue);\n', ' }\n', '}\n', '\n', 'contract Uptrennd is StandardToken, PausableToken {\n', '   string public constant name = &#39;Uptrennd&#39;;                                      // Set the token name for display\n', '   string public constant symbol = &#39;1UP&#39;;                                       // Set the token symbol for display\n', '   uint8 public constant decimals = 18;                                          // Set the number of decimals for display\n', '   uint256 public constant INITIAL_SUPPLY = 10000000000 * 1**uint256(decimals);  // 50 billions \n', '\n', '  function Uptrennd() public{\n', 'totalSupply = INITIAL_SUPPLY;                               // Set the total supply\n', 'balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all\n', 'emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'require(_to != address(0));\n', 'return super.transfer(_to, _value);\n', '   }\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'require(_to != address(0));\n', 'return super.transferFrom(_from, _to, _value);\n', '   }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.approve(_spender, _value);\n', '  }\n', '\n', '    event Burn(address indexed _burner, uint _value);\n', '\n', '    function burn(uint _value) public returns (bool)\n', '{\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(msg.sender, _value);\n', '    emit Transfer(msg.sender, address(0x0), _value);\n', '    return true;\n', '    }\n', ' }']
['pragma solidity 0.4.24;\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '      function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '// assert(a == b * c + a % b); \n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'assert(b <= a);\n', 'return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'uint256 c = a + b;\n', 'assert(c >= a);\n', 'return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', 'require(_to != address(0));\n', 'require(_value <= balances[msg.sender]);\n', '\n', '// SafeMath.sub will throw if there is not enough balance.\n', 'balances[msg.sender] = balances[msg.sender].sub(_value);\n', 'balances[_to] = balances[_to].add(_value);\n', 'emit Transfer(msg.sender, _to, _value);\n', 'return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', 'return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', 'require(_to != address(0));\n', 'require(_value <= balances[_from]);\n', 'require(_value <= allowed[_from][msg.sender]);\n', '\n', 'balances[_from] = balances[_from].sub(_value);\n', 'balances[_to] = balances[_to].add(_value);\n', 'allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', 'emit Transfer(_from, _to, _value);\n', 'return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', 'allowed[msg.sender][_spender] = _value;\n', 'emit Approval(msg.sender, _spender, _value);\n', 'return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', 'return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', 'allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', 'emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', 'return true;\n', '  }\n', '\n', '        function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', 'uint oldValue = allowed[msg.sender][_spender];\n', 'if (_subtractedValue > oldValue) {\n', '  allowed[msg.sender][_spender] = 0;\n', '} else {\n', '  allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '}\n', 'emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', 'return true;\n', '  }\n', '\n', '    }\n', '\n', 'contract Ownable {\n', '   address public owner;\n', '\n', '\n', '   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  function Ownable() public {\n', 'owner = msg.sender;\n', '  }\n', '\n', '   modifier onlyOwner() {\n', 'require(msg.sender == owner);\n', '_;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', 'require(newOwner != address(0));\n', 'emit OwnershipTransferred(owner, newOwner);\n', 'owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '   event Pause();\n', '   event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', 'require(!paused);\n', '_;\n', '  }\n', '\n', '  modifier whenPaused() {\n', 'require(paused);\n', '_;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', 'paused = true;\n', 'emit Pause();\n', '  }\n', '\n', '   function unpause() onlyOwner whenPaused public {\n', 'paused = false;\n', 'emit Unpause();\n', '  }\n', ' }\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.transfer(_to, _value);\n', '  }\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.transferFrom(_from, _to, _value);\n', '   }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', 'return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', 'return super.decreaseApproval(_spender, _subtractedValue);\n', ' }\n', '}\n', '\n', 'contract Uptrennd is StandardToken, PausableToken {\n', "   string public constant name = 'Uptrennd';                                      // Set the token name for display\n", "   string public constant symbol = '1UP';                                       // Set the token symbol for display\n", '   uint8 public constant decimals = 18;                                          // Set the number of decimals for display\n', '   uint256 public constant INITIAL_SUPPLY = 10000000000 * 1**uint256(decimals);  // 50 billions \n', '\n', '  function Uptrennd() public{\n', 'totalSupply = INITIAL_SUPPLY;                               // Set the total supply\n', 'balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all\n', 'emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'require(_to != address(0));\n', 'return super.transfer(_to, _value);\n', '   }\n', '\n', '   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', 'require(_to != address(0));\n', 'return super.transferFrom(_from, _to, _value);\n', '   }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', 'return super.approve(_spender, _value);\n', '  }\n', '\n', '    event Burn(address indexed _burner, uint _value);\n', '\n', '    function burn(uint _value) public returns (bool)\n', '{\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(msg.sender, _value);\n', '    emit Transfer(msg.sender, address(0x0), _value);\n', '    return true;\n', '    }\n', ' }']