['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// interface standard erc20\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event transferOwner(address indexed existingOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '      emit transferOwner(msg.sender, owner);\n', '    }\n', '  }\n', '}\n', '\n', '\n', '// more common interface erc20\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  // implementation of transfer token\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value > 0);\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // check balance user (map)\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  // implementation transfer from another user\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_value > 0);\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // implementation approval to allowed transfer\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(_value > 0);\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  // check total allowance particular user\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', ' // implementation increase total approval from particular user\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    require(_addedValue > 0);\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  // implementation decrease total approval from particular user\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    require(_subtractedValue > 0);\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '  \n', '//@dev Modifier to make a function callable only when the contract is not paused.\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '\n', '//@dev Modifier to make a function callable only when the contract is paused.\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '\n', '//@dev called by the owner to pause, triggers stopped state\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '\n', '//@dev called by the owner to unpause, returns to normal state\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// implementation pauseable erc20\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  // call whenNotPaused modifier to check next state\n', '  \n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract BraveToken is PausableToken {  \n', '  string public constant name = "Brave Sound Token";\n', '  string public constant symbol = "BRST";\n', '  uint8 public constant decimals = 0;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 21600000000 * (10 ** uint256(decimals));\n', '\n', '  constructor(address reserve) public {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[reserve] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, reserve, INITIAL_SUPPLY);\n', '  }\n', '\n', '}']