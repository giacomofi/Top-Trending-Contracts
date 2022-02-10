['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract ReceivingContractCallback {\n', '\n', '  function tokenFallback(address _from, uint _value) public;\n', '\n', '}\n', '\n', 'contract WalletsPercents is Ownable {\n', '\n', '  address[] public wallets;\n', '\n', '  mapping (address => uint) public percents;\n', '\n', '  function addWallet(address wallet, uint percent) public onlyOwner {\n', '    wallets.push(wallet);\n', '    percents[wallet] = percent;\n', '  }\n', ' \n', '  function cleanWallets() public onlyOwner {\n', '    wallets.length = 0;\n', '  }\n', '\n', '}\n', '\n', 'contract CommonToken is StandardToken, WalletsPercents {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  uint public constant PERCENT_RATE = 100;\n', '\n', '  uint32 public constant decimals = 18;\n', '\n', '  address[] public tokenHolders;\n', '\n', '  bool public locked = false;\n', '\n', '  mapping (address => bool)  public registeredCallbacks;\n', '\n', '  mapping (address => bool) public unlockedAddresses;\n', '  \n', '  bool public initialized = false;\n', '\n', '  function init() public onlyOwner {\n', '    require(!initialized);\n', '    totalSupply = 500000000000000000000000000;\n', '    balances[this] = totalSupply;\n', '    tokenHolders.push(this);\n', '    Mint(this, totalSupply);\n', '    unlockedAddresses[this] = true;\n', '    unlockedAddresses[owner] = true;\n', '    for(uint i = 0; i < wallets.length; i++) {\n', '      address wallet = wallets[i];\n', '      uint amount = totalSupply.mul(percents[wallet]).div(PERCENT_RATE);\n', '      balances[this] = balances[this].sub(amount);\n', '      balances[wallet] = balances[wallet].add(amount);\n', '      tokenHolders.push(wallet);\n', '      Transfer(this, wallet, amount);\n', '    }\n', '    initialized = true;\n', '  }\n', '\n', '  modifier notLocked(address sender) {\n', '    require(!locked || unlockedAddresses[sender]);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address to) public {\n', '    unlockedAddresses[owner] = false;\n', '    super.transferOwnership(to);\n', '    unlockedAddresses[owner] = true;\n', '  }\n', '\n', '  function addUnlockedAddress(address addressToUnlock) public onlyOwner {\n', '    unlockedAddresses[addressToUnlock] = true;\n', '  }\n', '\n', '  function removeUnlockedAddress(address addressToUnlock) public onlyOwner {\n', '    unlockedAddresses[addressToUnlock] = false;\n', '  }\n', '\n', '  function unlockBatchOfAddresses(address[] addressesToUnlock) public onlyOwner {\n', '    for(uint i = 0; i < addressesToUnlock.length; i++) unlockedAddresses[addressesToUnlock[i]] = true;\n', '  }\n', '\n', '  function setLocked(bool newLock) public onlyOwner {\n', '    locked = newLock;\n', '  }\n', '\n', '  function transfer(address to, uint256 value) public notLocked(msg.sender) returns (bool) {\n', '    tokenHolders.push(to);\n', '    return processCallback(super.transfer(to, value), msg.sender, to, value);\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {\n', '    tokenHolders.push(to);\n', '    return processCallback(super.transferFrom(from, to, value), from, to, value);\n', '  }\n', '\n', '  function registerCallback(address callback) public onlyOwner {\n', '    registeredCallbacks[callback] = true;\n', '  }\n', '\n', '  function deregisterCallback(address callback) public onlyOwner {\n', '    registeredCallbacks[callback] = false;\n', '  }\n', '\n', '  function processCallback(bool result, address from, address to, uint value) internal returns(bool) {\n', '    if (result && registeredCallbacks[to]) {\n', '      ReceivingContractCallback targetCallback = ReceivingContractCallback(to);\n', '      targetCallback.tokenFallback(from, value);\n', '    }\n', '    return result;\n', '  }\n', '\n', '}\n', '\n', 'contract BITTToken is CommonToken {\n', '\n', '  string public constant name = "BITT";\n', '\n', '  string public constant symbol = "BITT";\n', '\n', '}\n', '\n', '\n', 'contract BITZToken is CommonToken {\n', '\n', '  string public constant name = "BITZ";\n', '\n', '  string public constant symbol = "BITZ";\n', '\n', '}\n', '\n', 'contract Configurator is Ownable {\n', '\n', '  CommonToken public bittToken;\n', '\n', '  CommonToken public bitzToken;\n', '\n', '  function Configurator() public onlyOwner {\n', '    address manager = 0xe99c8d442a5484bE05E3A5AB1AeA967caFf07133;\n', '\n', '    bittToken = new BITTToken();\n', '    bittToken.addWallet(0x08C32a099E59c7e913B16cAd4a6C988f1a5A7216, 60);\n', '    bittToken.addWallet(0x5b2A9b86113632d086CcD8c9dAf67294eda78105, 20);\n', '    bittToken.addWallet(0x3019B9ad002Ddec2F49e14FB591c8CcD81800847, 10);\n', '    bittToken.addWallet(0x18fd87AAB645fd4c0cEBc21fb0a271E1E2bA5363, 5);\n', '    bittToken.addWallet(0x1eC03A084Cc02754776a9fEffC4b47dAE4800620, 3);\n', '    bittToken.addWallet(0xb119f842E6A10Dc545Af3c53ff28250B5F45F9b2, 2);\n', '    bittToken.init();\n', '    bittToken.transferOwnership(manager);\n', '\n', '    bitzToken = new BITZToken();\n', '    bitzToken.addWallet(0xc0f1a3E91C2D0Bcc5CD398D05F851C2Fb1F3fE30, 60);\n', '    bitzToken.addWallet(0x3019B9ad002Ddec2F49e14FB591c8CcD81800847, 20);\n', '    bitzToken.addWallet(0x04eb6a716c814b0B4A12dC9964916D64C55179C1, 20);\n', '    bitzToken.init();\n', '    bitzToken.transferOwnership(manager);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract ReceivingContractCallback {\n', '\n', '  function tokenFallback(address _from, uint _value) public;\n', '\n', '}\n', '\n', 'contract WalletsPercents is Ownable {\n', '\n', '  address[] public wallets;\n', '\n', '  mapping (address => uint) public percents;\n', '\n', '  function addWallet(address wallet, uint percent) public onlyOwner {\n', '    wallets.push(wallet);\n', '    percents[wallet] = percent;\n', '  }\n', ' \n', '  function cleanWallets() public onlyOwner {\n', '    wallets.length = 0;\n', '  }\n', '\n', '}\n', '\n', 'contract CommonToken is StandardToken, WalletsPercents {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  uint public constant PERCENT_RATE = 100;\n', '\n', '  uint32 public constant decimals = 18;\n', '\n', '  address[] public tokenHolders;\n', '\n', '  bool public locked = false;\n', '\n', '  mapping (address => bool)  public registeredCallbacks;\n', '\n', '  mapping (address => bool) public unlockedAddresses;\n', '  \n', '  bool public initialized = false;\n', '\n', '  function init() public onlyOwner {\n', '    require(!initialized);\n', '    totalSupply = 500000000000000000000000000;\n', '    balances[this] = totalSupply;\n', '    tokenHolders.push(this);\n', '    Mint(this, totalSupply);\n', '    unlockedAddresses[this] = true;\n', '    unlockedAddresses[owner] = true;\n', '    for(uint i = 0; i < wallets.length; i++) {\n', '      address wallet = wallets[i];\n', '      uint amount = totalSupply.mul(percents[wallet]).div(PERCENT_RATE);\n', '      balances[this] = balances[this].sub(amount);\n', '      balances[wallet] = balances[wallet].add(amount);\n', '      tokenHolders.push(wallet);\n', '      Transfer(this, wallet, amount);\n', '    }\n', '    initialized = true;\n', '  }\n', '\n', '  modifier notLocked(address sender) {\n', '    require(!locked || unlockedAddresses[sender]);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address to) public {\n', '    unlockedAddresses[owner] = false;\n', '    super.transferOwnership(to);\n', '    unlockedAddresses[owner] = true;\n', '  }\n', '\n', '  function addUnlockedAddress(address addressToUnlock) public onlyOwner {\n', '    unlockedAddresses[addressToUnlock] = true;\n', '  }\n', '\n', '  function removeUnlockedAddress(address addressToUnlock) public onlyOwner {\n', '    unlockedAddresses[addressToUnlock] = false;\n', '  }\n', '\n', '  function unlockBatchOfAddresses(address[] addressesToUnlock) public onlyOwner {\n', '    for(uint i = 0; i < addressesToUnlock.length; i++) unlockedAddresses[addressesToUnlock[i]] = true;\n', '  }\n', '\n', '  function setLocked(bool newLock) public onlyOwner {\n', '    locked = newLock;\n', '  }\n', '\n', '  function transfer(address to, uint256 value) public notLocked(msg.sender) returns (bool) {\n', '    tokenHolders.push(to);\n', '    return processCallback(super.transfer(to, value), msg.sender, to, value);\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {\n', '    tokenHolders.push(to);\n', '    return processCallback(super.transferFrom(from, to, value), from, to, value);\n', '  }\n', '\n', '  function registerCallback(address callback) public onlyOwner {\n', '    registeredCallbacks[callback] = true;\n', '  }\n', '\n', '  function deregisterCallback(address callback) public onlyOwner {\n', '    registeredCallbacks[callback] = false;\n', '  }\n', '\n', '  function processCallback(bool result, address from, address to, uint value) internal returns(bool) {\n', '    if (result && registeredCallbacks[to]) {\n', '      ReceivingContractCallback targetCallback = ReceivingContractCallback(to);\n', '      targetCallback.tokenFallback(from, value);\n', '    }\n', '    return result;\n', '  }\n', '\n', '}\n', '\n', 'contract BITTToken is CommonToken {\n', '\n', '  string public constant name = "BITT";\n', '\n', '  string public constant symbol = "BITT";\n', '\n', '}\n', '\n', '\n', 'contract BITZToken is CommonToken {\n', '\n', '  string public constant name = "BITZ";\n', '\n', '  string public constant symbol = "BITZ";\n', '\n', '}\n', '\n', 'contract Configurator is Ownable {\n', '\n', '  CommonToken public bittToken;\n', '\n', '  CommonToken public bitzToken;\n', '\n', '  function Configurator() public onlyOwner {\n', '    address manager = 0xe99c8d442a5484bE05E3A5AB1AeA967caFf07133;\n', '\n', '    bittToken = new BITTToken();\n', '    bittToken.addWallet(0x08C32a099E59c7e913B16cAd4a6C988f1a5A7216, 60);\n', '    bittToken.addWallet(0x5b2A9b86113632d086CcD8c9dAf67294eda78105, 20);\n', '    bittToken.addWallet(0x3019B9ad002Ddec2F49e14FB591c8CcD81800847, 10);\n', '    bittToken.addWallet(0x18fd87AAB645fd4c0cEBc21fb0a271E1E2bA5363, 5);\n', '    bittToken.addWallet(0x1eC03A084Cc02754776a9fEffC4b47dAE4800620, 3);\n', '    bittToken.addWallet(0xb119f842E6A10Dc545Af3c53ff28250B5F45F9b2, 2);\n', '    bittToken.init();\n', '    bittToken.transferOwnership(manager);\n', '\n', '    bitzToken = new BITZToken();\n', '    bitzToken.addWallet(0xc0f1a3E91C2D0Bcc5CD398D05F851C2Fb1F3fE30, 60);\n', '    bitzToken.addWallet(0x3019B9ad002Ddec2F49e14FB591c8CcD81800847, 20);\n', '    bitzToken.addWallet(0x04eb6a716c814b0B4A12dC9964916D64C55179C1, 20);\n', '    bitzToken.init();\n', '    bitzToken.transferOwnership(manager);\n', '  }\n', '\n', '}']