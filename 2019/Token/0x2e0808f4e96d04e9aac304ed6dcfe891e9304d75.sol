['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  \n', '  struct Admins {\n', '    mapping(address=>bool) isAdmin;\n', '  }\n', '  \n', '  Admins internal admins;\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  \n', '  function addAdmin(address candidate) public onlyOwner returns(bool) {\n', '    admins.isAdmin[candidate] = true;\n', '    return true;\n', '  }\n', '  \n', '  function removeAdmin(address candidate) public onlyOwner returns(bool) {\n', '    admins.isAdmin[candidate] = false;\n', '    return true;\n', '  }\n', '  \n', '  function checkAdmin(address candidate) public onlyOwner view returns(bool) {\n', '    return admins.isAdmin[candidate];\n', '  }\n', '  \n', '  \n', '  modifier onlyAdmins() {\n', '    require(admins.isAdmin[msg.sender] == true);\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  \n', '  constructor(uint256 totalSupply) public {\n', '      totalSupply_ = totalSupply;\n', '      balances[msg.sender] = totalSupply_;\n', '  }\n', '  \n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) {\n', '      uint cnt = _receivers.length;\n', '      uint256 amount = _value.mul(uint256(cnt));\n', '      require(cnt > 0 && cnt <= 20);\n', '      require(_value > 0 && balances[msg.sender] >= amount);\n', '  \n', '      balances[msg.sender] = balances[msg.sender].sub(amount);\n', '      for (uint i = 0; i < cnt; i++) {\n', '          balances[_receivers[i]] = balances[_receivers[i]].add(_value);\n', '          emit Transfer(msg.sender, _receivers[i], _value);\n', '      }\n', '      return true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract DetailedERC20 is ERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', "contract StandardToken is DetailedERC20('Gold Features Coin Token','GFCT',18), BasicToken(10000000000000000000000000000) {\n", '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  \n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(allowed[msg.sender][_spender] == 0);\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  \n', '  function recoverLost(\n', '    address lost,\n', '    uint256 amount\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    this.transfer(lost,amount);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract GFCT_Token is StandardToken, Pausable {\n', '\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function batchTransfer (\n', '      address[] _receivers,\n', '      uint256 _value\n', '    )\n', '      public\n', '      whenNotPaused\n', '      onlyAdmins\n', '      returns (bool) \n', '    {\n', '      return super.batchTransfer(_receivers, _value);\n', '    }\n', '\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '  \n', '  function recoverLost(\n', '      address lost,\n', '      uint256 amount\n', '    )\n', '      public\n', '      whenNotPaused\n', '      onlyOwner\n', '      returns(bool)\n', '    {\n', '        return super.recoverLost(lost,amount);\n', '    }\n', '}']