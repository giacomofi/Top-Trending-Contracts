['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract TokenDestructible is Ownable {\n', '\n', '  constructor() public payable { }\n', '\n', '  /**\n', '   * @notice Terminate contract and refund to owner\n', '   * @param _tokens List of addresses of ERC20 or ERC20Basic token contracts to\n', '   refund.\n', '   * @notice The called token contracts could try to re-enter this contract. Only\n', '   supply token contracts you trust.\n', '   */\n', '  function destroy(address[] _tokens) public onlyOwner {\n', '\n', '    // Transfer tokens to owner\n', '    for (uint256 i = 0; i < _tokens.length; i++) {\n', '      ERC20Basic token = ERC20Basic(_tokens[i]);\n', '      uint256 balance = token.balanceOf(this);\n', '      token.transfer(owner, balance);\n', '    }\n', '\n', '    // Transfer Eth to owner and terminate contract\n', '    selfdestruct(owner);\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract IndividualLockableToken is PausableToken{\n', '\n', '  using SafeMath for uint256;\n', '\n', '\n', '\n', '  event LockTimeSetted(address indexed holder, uint256 old_release_time, uint256 new_release_time);\n', '\n', '  event Locked(address indexed holder, uint256 locked_balance_change, uint256 total_locked_balance, uint256 release_time);\n', '\n', '\n', '\n', '  struct lockState {\n', '\n', '    uint256 locked_balance;\n', '\n', '    uint256 release_time;\n', '\n', '  }\n', '\n', '\n', '\n', '  // default lock period\n', '\n', '  uint256 public lock_period = 24 weeks;\n', '\n', '\n', '\n', '  mapping(address => lockState) internal userLock;\n', '\n', '\n', '\n', "  // Specify the time that a particular person's lock will be released\n", '\n', '  function setReleaseTime(address _holder, uint256 _release_time)\n', '\n', '    public\n', '\n', '    onlyOwner\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    require(_holder != address(0));\n', '\n', '\trequire(_release_time >= block.timestamp);\n', '\n', '\n', '\n', '\tuint256 old_release_time = userLock[_holder].release_time;\n', '\n', '\n', '\n', '\tuserLock[_holder].release_time = _release_time;\n', '\n', '\temit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);\n', '\n', '\treturn true;\n', '\n', '  }\n', '\n', '  \n', '\n', "  // Returns the point at which token holder's lock is released\n", '\n', '  function getReleaseTime(address _holder)\n', '\n', '    public\n', '\n', '    view\n', '\n', '    returns (uint256)\n', '\n', '  {\n', '\n', '    require(_holder != address(0));\n', '\n', '\n', '\n', '\treturn userLock[_holder].release_time;\n', '\n', '  }\n', '\n', '\n', '\n', '  // Unlock a specific person. Free trading even with a lock balance\n', '\n', '  function clearReleaseTime(address _holder)\n', '\n', '    public\n', '\n', '    onlyOwner\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    require(_holder != address(0));\n', '\n', '    require(userLock[_holder].release_time > 0);\n', '\n', '\n', '\n', '\tuint256 old_release_time = userLock[_holder].release_time;\n', '\n', '\n', '\n', '\tuserLock[_holder].release_time = 0;\n', '\n', '\temit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);\n', '\n', '\treturn true;\n', '\n', '  }\n', '\n', '\n', '\n', '  // Increase the lock balance of a specific person.\n', '\n', '  // If you only want to increase the balance, the release_time must be specified in advance.\n', '\n', '  function increaseLockBalance(address _holder, uint256 _value)\n', '\n', '    public\n', '\n', '    onlyOwner\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '\trequire(_holder != address(0));\n', '\n', '\trequire(_value > 0);\n', '\n', '\trequire(balances[_holder] >= _value);\n', '\n', '\t\n', '\n', '\tif (userLock[_holder].release_time == 0) {\n', '\n', '\t\tuserLock[_holder].release_time = block.timestamp + lock_period;\n', '\n', '\t}\n', '\n', '\t\n', '\n', '\tuserLock[_holder].locked_balance = (userLock[_holder].locked_balance).add(_value);\n', '\n', '\temit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);\n', '\n', '\treturn true;\n', '\n', '  }\n', '\n', '\n', '\n', '  // Decrease the lock balance of a specific person.\n', '\n', '  function decreaseLockBalance(address _holder, uint256 _value)\n', '\n', '    public\n', '\n', '    onlyOwner\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '\trequire(_holder != address(0));\n', '\n', '\trequire(_value > 0);\n', '\n', '\trequire(userLock[_holder].locked_balance >= _value);\n', '\n', '\n', '\n', '\tuserLock[_holder].locked_balance = (userLock[_holder].locked_balance).sub(_value);\n', '\n', '\temit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);\n', '\n', '\treturn true;\n', '\n', '  }\n', '\n', '\n', '\n', '  // Clear the lock.\n', '\n', '  function clearLock(address _holder)\n', '\n', '    public\n', '\n', '    onlyOwner\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '\trequire(_holder != address(0));\n', '\n', '\trequire(userLock[_holder].release_time > 0);\n', '\n', '\n', '\n', '\tuserLock[_holder].locked_balance = 0;\n', '\n', '\tuserLock[_holder].release_time = 0;\n', '\n', '\temit Locked(_holder, 0, userLock[_holder].locked_balance, userLock[_holder].release_time);\n', '\n', '\treturn true;\n', '\n', '  }\n', '\n', '\n', '\n', '  // Check the amount of the lock\n', '\n', '  function getLockedBalance(address _holder)\n', '\n', '    public\n', '\n', '    view\n', '\n', '    returns (uint256)\n', '\n', '  {\n', '\n', '    if(block.timestamp >= userLock[_holder].release_time) return uint256(0);\n', '\n', '    return userLock[_holder].locked_balance;\n', '\n', '  }\n', '\n', '\n', '\n', '  // Check your remaining balance\n', '\n', '  function getFreeBalance(address _holder)\n', '\n', '    public\n', '\n', '    view\n', '\n', '    returns (uint256)\n', '\n', '  {\n', '\n', '    if(block.timestamp >= userLock[_holder].release_time) return balances[_holder];\n', '\n', '    return balances[_holder].sub(userLock[_holder].locked_balance);\n', '\n', '  }\n', '\n', '\n', '\n', '  // transfer overrride\n', '\n', '  function transfer(\n', '\n', '    address _to,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    require(getFreeBalance(msg.sender) >= _value);\n', '\n', '    return super.transfer(_to, _value);\n', '\n', '  }\n', '\n', '\n', '\n', '  // transferFrom overrride\n', '\n', '  function transferFrom(\n', '\n', '    address _from,\n', '\n', '    address _to,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    require(getFreeBalance(_from) >= _value);\n', '\n', '    return super.transferFrom(_from, _to, _value);\n', '\n', '  }\n', '\n', '\n', '\n', '  // approve overrride\n', '\n', '  function approve(\n', '\n', '    address _spender,\n', '\n', '    uint256 _value\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool)\n', '\n', '  {\n', '\n', '    require(getFreeBalance(msg.sender) >= _value);\n', '\n', '    return super.approve(_spender, _value);\n', '\n', '  }\n', '\n', '\n', '\n', '  // increaseApproval overrride\n', '\n', '  function increaseApproval(\n', '\n', '    address _spender,\n', '\n', '    uint _addedValue\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool success)\n', '\n', '  {\n', '\n', '    require(getFreeBalance(msg.sender) >= allowed[msg.sender][_spender].add(_addedValue));\n', '\n', '    return super.increaseApproval(_spender, _addedValue);\n', '\n', '  }\n', '\n', '  \n', '\n', '  // decreaseApproval overrride\n', '\n', '  function decreaseApproval(\n', '\n', '    address _spender,\n', '\n', '    uint _subtractedValue\n', '\n', '  )\n', '\n', '    public\n', '\n', '    returns (bool success)\n', '\n', '  {\n', '\n', '\tuint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '\t\n', '\n', '    if (_subtractedValue < oldValue) {\n', '\n', '      require(getFreeBalance(msg.sender) >= oldValue.sub(_subtractedValue));\t  \n', '\n', '    }    \n', '\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '  }\n', '\n', '}\n', '\n', 'contract EthereumRed is IndividualLockableToken, TokenDestructible {\n', '\n', '  using SafeMath for uint256;\n', '\n', '\n', '\n', '  string public constant name = "Ethereum Red";\n', '\n', '  string public constant symbol = "ERED";\n', '\n', '  uint8  public constant decimals = 18;\n', '\n', '\n', '\n', '  // 24,000,000,000 YRE\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));\n', '\n', '\n', '\n', '  constructor()\n', '\n', '    public\n', '\n', '  {\n', '\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '\n', '    balances[msg.sender] = totalSupply_;\n', '\n', '  }\n', '\n', '}']