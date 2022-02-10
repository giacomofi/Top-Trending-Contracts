['pragma solidity 0.4.23;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="5f3b3e293a1f3e3430323d3e713c3032">[email&#160;protected]</a>\n', '// released under Apache 2.0 licence\n', '// input  /Users/zacharykilgore/src/flexa/smart-contracts/contracts/Flexacoin.sol\n', '// flattened :  Saturday, 05-Jan-19 14:38:33 UTC\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface methods */\n', '  function isUpgradeAgent() public view returns (bool);\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Reclaim all ERC20Basic compatible tokens\n', '   * @param token ERC20Basic The address of the token contract\n', '   */\n', '  function reclaimToken(ERC20Basic token) external onlyOwner {\n', '    uint256 balance = token.balanceOf(this);\n', '    token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', 'contract Recoverable is CanReclaimToken, Claimable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Transfer all ether held by the contract to the contract owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    owner.transfer(address(this).balance);\n', '  }\n', '\n', '}\n', '\n', 'contract UpgradeableToken is StandardToken, Recoverable {\n', '\n', '  /** The contract that will handle the upgrading the tokens. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens have been upgraded. */\n', '  uint256 public totalUpgraded = 0;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - `Unknown`: Zero state to prevent erroneous state reporting. Should never be returned\n', '   * - `NotAllowed`: The child contract has not reached a condition where the upgrade can begin\n', '   * - `WaitingForAgent`: Allowed to upgrade, but agent has not been set\n', '   * - `ReadyToUpgrade`: The agent is set, but no tokens has been upgraded yet\n', '   * - `Upgrading`: Upgrade agent is set, and balance holders are upgrading their tokens\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '\n', '  /**\n', '   * Event to track that a token holder has upgraded some of their tokens.\n', '   * @param from Address of the token holder\n', '   * @param to Address of the upgrade agent\n', '   * @param value Number of tokens upgraded\n', '   */\n', '  event Upgrade(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * Event to signal that an upgrade agent contract has been set.\n', '   * @param upgradeAgent Address of the new upgrade agent\n', '   */\n', '  event UpgradeAgentSet(address upgradeAgent);\n', '\n', '\n', '  /**\n', '   * @notice Allow the token holder to upgrade some of their tokens to the new\n', '   * contract.\n', '   * @param _value The amount of tokens to upgrade\n', '   */\n', '  function upgrade(uint256 _value) public {\n', '    UpgradeState _state = getUpgradeState();\n', '    require(\n', '      _state == UpgradeState.ReadyToUpgrade || _state == UpgradeState.Upgrading,\n', '      "State must be correct for upgrade"\n', '    );\n', '    require(_value > 0, "Upgrade value must be greater than zero");\n', '\n', '    // Take tokens out of circulation\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '\n', '    totalUpgraded = totalUpgraded.add(_value);\n', '\n', '    // Hand control to upgrade agent to process new tokens for the sender\n', '    upgradeAgent.upgradeFrom(msg.sender, _value);\n', '\n', '    emit Upgrade(msg.sender, upgradeAgent, _value);\n', '  }\n', '\n', '  /**\n', '   * @notice Set an upgrade agent contract to process the upgrade.\n', '   * @dev The _upgradeAgent contract address must satisfy the UpgradeAgent\n', '   * interface.\n', '   * @param _upgradeAgent The address of the new UpgradeAgent smart contract\n', '   */\n', '  function setUpgradeAgent(UpgradeAgent _upgradeAgent) external onlyOwner {\n', '    require(canUpgrade(), "Ensure the token is upgradeable in the first place");\n', '    require(_upgradeAgent != address(0), "Ensure upgrade agent address is not blank");\n', '    require(getUpgradeState() != UpgradeState.Upgrading, "Ensure upgrade has not started");\n', '\n', '    upgradeAgent = _upgradeAgent;\n', '\n', '    require(upgradeAgent.isUpgradeAgent(), "New upgradeAgent must be UpgradeAgent");\n', '    require(\n', '      upgradeAgent.originalSupply() == totalSupply_,\n', '      "Make sure that token supplies match in source and target token contracts"\n', '    );\n', '\n', '    emit UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * @notice Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public view returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * @notice Can the contract be upgradead?\n', '   * @dev Child contract must implement and provide the condition when the upgrade\n', '   * can begin.\n', '   * @return true if the contract can be upgraded, false if not\n', '   */\n', '  function canUpgrade() public view returns(bool);\n', '\n', '}\n', '\n', 'contract Flexacoin is PausableToken, UpgradeableToken {\n', '\n', '  string public constant name = "Flexacoin";\n', '  string public constant symbol = "FXC";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));\n', '\n', '\n', '  /**\n', '    * @notice Flexacoin (ERC20 Token) contract constructor.\n', '    * @dev Assigns all tokens to contract creator.\n', '    */\n', '  constructor() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '  /**\n', '   * @dev Allow UpgradeableToken functionality only if contract is not paused.\n', '   */\n', '  function canUpgrade() public view returns(bool) {\n', '    return !paused;\n', '  }\n', '\n', '}']
['pragma solidity 0.4.23;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', '// input  /Users/zacharykilgore/src/flexa/smart-contracts/contracts/Flexacoin.sol\n', '// flattened :  Saturday, 05-Jan-19 14:38:33 UTC\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface methods */\n', '  function isUpgradeAgent() public view returns (bool);\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Reclaim all ERC20Basic compatible tokens\n', '   * @param token ERC20Basic The address of the token contract\n', '   */\n', '  function reclaimToken(ERC20Basic token) external onlyOwner {\n', '    uint256 balance = token.balanceOf(this);\n', '    token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', 'contract Recoverable is CanReclaimToken, Claimable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  /**\n', '   * @dev Transfer all ether held by the contract to the contract owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    owner.transfer(address(this).balance);\n', '  }\n', '\n', '}\n', '\n', 'contract UpgradeableToken is StandardToken, Recoverable {\n', '\n', '  /** The contract that will handle the upgrading the tokens. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens have been upgraded. */\n', '  uint256 public totalUpgraded = 0;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - `Unknown`: Zero state to prevent erroneous state reporting. Should never be returned\n', '   * - `NotAllowed`: The child contract has not reached a condition where the upgrade can begin\n', '   * - `WaitingForAgent`: Allowed to upgrade, but agent has not been set\n', '   * - `ReadyToUpgrade`: The agent is set, but no tokens has been upgraded yet\n', '   * - `Upgrading`: Upgrade agent is set, and balance holders are upgrading their tokens\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '\n', '  /**\n', '   * Event to track that a token holder has upgraded some of their tokens.\n', '   * @param from Address of the token holder\n', '   * @param to Address of the upgrade agent\n', '   * @param value Number of tokens upgraded\n', '   */\n', '  event Upgrade(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * Event to signal that an upgrade agent contract has been set.\n', '   * @param upgradeAgent Address of the new upgrade agent\n', '   */\n', '  event UpgradeAgentSet(address upgradeAgent);\n', '\n', '\n', '  /**\n', '   * @notice Allow the token holder to upgrade some of their tokens to the new\n', '   * contract.\n', '   * @param _value The amount of tokens to upgrade\n', '   */\n', '  function upgrade(uint256 _value) public {\n', '    UpgradeState _state = getUpgradeState();\n', '    require(\n', '      _state == UpgradeState.ReadyToUpgrade || _state == UpgradeState.Upgrading,\n', '      "State must be correct for upgrade"\n', '    );\n', '    require(_value > 0, "Upgrade value must be greater than zero");\n', '\n', '    // Take tokens out of circulation\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '\n', '    totalUpgraded = totalUpgraded.add(_value);\n', '\n', '    // Hand control to upgrade agent to process new tokens for the sender\n', '    upgradeAgent.upgradeFrom(msg.sender, _value);\n', '\n', '    emit Upgrade(msg.sender, upgradeAgent, _value);\n', '  }\n', '\n', '  /**\n', '   * @notice Set an upgrade agent contract to process the upgrade.\n', '   * @dev The _upgradeAgent contract address must satisfy the UpgradeAgent\n', '   * interface.\n', '   * @param _upgradeAgent The address of the new UpgradeAgent smart contract\n', '   */\n', '  function setUpgradeAgent(UpgradeAgent _upgradeAgent) external onlyOwner {\n', '    require(canUpgrade(), "Ensure the token is upgradeable in the first place");\n', '    require(_upgradeAgent != address(0), "Ensure upgrade agent address is not blank");\n', '    require(getUpgradeState() != UpgradeState.Upgrading, "Ensure upgrade has not started");\n', '\n', '    upgradeAgent = _upgradeAgent;\n', '\n', '    require(upgradeAgent.isUpgradeAgent(), "New upgradeAgent must be UpgradeAgent");\n', '    require(\n', '      upgradeAgent.originalSupply() == totalSupply_,\n', '      "Make sure that token supplies match in source and target token contracts"\n', '    );\n', '\n', '    emit UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * @notice Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public view returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * @notice Can the contract be upgradead?\n', '   * @dev Child contract must implement and provide the condition when the upgrade\n', '   * can begin.\n', '   * @return true if the contract can be upgraded, false if not\n', '   */\n', '  function canUpgrade() public view returns(bool);\n', '\n', '}\n', '\n', 'contract Flexacoin is PausableToken, UpgradeableToken {\n', '\n', '  string public constant name = "Flexacoin";\n', '  string public constant symbol = "FXC";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));\n', '\n', '\n', '  /**\n', '    * @notice Flexacoin (ERC20 Token) contract constructor.\n', '    * @dev Assigns all tokens to contract creator.\n', '    */\n', '  constructor() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '  /**\n', '   * @dev Allow UpgradeableToken functionality only if contract is not paused.\n', '   */\n', '  function canUpgrade() public view returns(bool) {\n', '    return !paused;\n', '  }\n', '\n', '}']