['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '/**\n', ' * Safe unsigned safe math.\n', ' */\n', 'library SafeMathLib {\n', '\n', '  function times(uint a, uint b) public pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function minus(uint a, uint b) public pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function plus(uint a, uint b) public pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', '\n', 'contract Recoverable is Ownable {\n', '\n', '  /// @dev Empty constructor (for now)\n', '  constructor() public {\n', '  }\n', '\n', '  /// @dev This will be invoked by the owner, when owner wants to rescue tokens\n', '  /// @param token Token which will we rescue to the owner from the contract\n', '  function recoverTokens(ERC20Basic token) onlyOwner public {\n', '    token.transfer(owner, tokensToBeReturned(token));\n', '  }\n', '\n', '  /// @dev Interface function, can be overwritten by the superclass\n', '  /// @param token Token which balance we will check and return\n', '  /// @return The amount of tokens (in smallest denominator) the contract owns\n', '  function tokensToBeReturned(ERC20Basic token) public view returns (uint) {\n', '    return token.balanceOf(this);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * Standard EIP-20 token with an interface marker.\n', ' *\n', ' * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.\n', ' *\n', ' */\n', 'contract StandardTokenExt is StandardToken, Recoverable {\n', '\n', '  /* Interface declaration */\n', '  function isToken() public pure returns (bool weAre) {\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * A token that can increase its supply by another contract.\n', ' *\n', ' * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.\n', ' * Only mint agents, contracts whitelisted by owner, can mint new tokens.\n', ' *\n', ' */\n', 'contract MintableToken is StandardTokenExt {\n', '\n', '  using SafeMathLib for uint;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  /** List of agents that are allowed to create new tokens */\n', '  mapping (address => bool) public mintAgents;\n', '\n', '  event MintingAgentChanged(address addr, bool state);\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /**\n', '   * Create new tokens and allocate them to an address..\n', '   *\n', '   * Only callably by a crowdsale contract (mint agent).\n', '   */\n', '  function mint(address receiver, uint amount) onlyMintAgent canMint public {\n', '    totalSupply_ = totalSupply_.plus(amount);\n', '    balances[receiver] = balances[receiver].plus(amount);\n', '\n', '    // This will make the mint transaction apper in EtherScan.io\n', '    // We can remove this after there is a standardized minting event\n', '    emit Transfer(0, receiver, amount);\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a crowdsale contract to mint new tokens.\n', '   */\n', '  function setMintAgent(address addr, bool state) onlyOwner canMint public {\n', '    mintAgents[addr] = state;\n', '    emit MintingAgentChanged(addr, state);\n', '  }\n', '\n', '  modifier onlyMintAgent() {\n', '    // Only crowdsale contracts are allowed to mint new tokens\n', '    require(mintAgents[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  /** Make sure we are not done yet. */\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' */\n', 'contract ReleasableToken is StandardTokenExt {\n', '\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '\n', '    require(released || transferAgents[_sender]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   *\n', '   * Design choice. Allow reset the release agent to fix fat finger mistakes.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', "    // We don't do interface check here as we might want to a normal wallet address to act as a release agent\n", '    releaseAgent = addr;\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    require(releaseState == released);\n', '    _;\n', '  }\n', '\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    require(msg.sender == releaseAgent);\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' *\n', ' * Upgrade agent transfers tokens to a new contract.\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' *\n', ' * First envisioned by Golem and Lunyr projects.\n', ' */\n', 'contract UpgradeableToken is StandardTokenExt {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', "   * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet\n", '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  constructor(address _upgradeMaster) public {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);\n', '\n', '      // Validate input value.\n', '      require(value > 0);\n', '\n', '      balances[msg.sender] = balances[msg.sender].sub(value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply_ = totalSupply_.sub(value);\n', '      totalUpgraded = totalUpgraded.add(value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      emit Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '      require(canUpgrade());\n', '\n', '      require(agent != 0x0);\n', '      // Only a master can designate the next agent\n', '      require(msg.sender == upgradeMaster);\n', '      // Upgrade has already begun for an agent\n', '      require(getUpgradeState() != UpgradeState.Upgrading);\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      require(upgradeAgent.isUpgradeAgent());\n', '      // Make sure that token supplies match in source and target\n', '      require(upgradeAgent.originalSupply() == totalSupply_);\n', '\n', '      emit UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public view returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      require(master != 0x0);\n', '      require(msg.sender == upgradeMaster);\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public view returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * BOLTT ERC20 Token\n', ' *\n', ' * An ERC-20 token designed specifically for multiple crowdsales with investor protection and further development path.\n', ' *\n', ' * - The token transfer() is disabled until the crowdsale is over\n', ' * - The token contract gives an opt-in upgrade path to a new contract\n', ' * - The same token can be part of several crowdsales through approve() mechanism\n', ' *\n', ' * BOLTT Sports Technology\n', ' */\n', 'contract BolttCoin is ReleasableToken, MintableToken, UpgradeableToken {\n', '\n', '  /** Name and symbol were updated. */\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  /** Transfer to Waves chain */\n', '  event WavesTransfer(address indexed _from, string wavesAddress, uint256 amount);\n', '\n', '  string public name;\n', '\n', '  string public symbol;\n', '\n', '  uint public decimals;\n', '\n', '  address public wavesReserve;\n', '\n', '  /**\n', '   * Construct BolttCoin\n', '   *\n', '   * @param _name Token name\n', '   * @param _symbol Token symbol - should be all caps\n', '   * @param _initialSupply How many tokens we start with\n', '   * @param _decimals Number of decimal places\n', '   * @param _wavesReserve The waves reserve address\n', '   */\n', '  constructor(string memory _name, string memory _symbol, uint _initialSupply, uint _decimals, address _wavesReserve)\n', '    UpgradeableToken(msg.sender) public {\n', '    require(_wavesReserve != address(0));\n', '\n', '    owner = msg.sender;\n', '\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    totalSupply_ = _initialSupply;\n', '\n', '    decimals = _decimals;\n', '\n', '    wavesReserve = _wavesReserve;\n', '\n', '    // Create initially all balance on the team multisig\n', '    balances[owner] = totalSupply_;\n', '\n', '    if(totalSupply_ > 0) {\n', '      emit Minted(owner, totalSupply_);\n', '      mintingFinished = true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Allow releasing token transfer\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    super.releaseTokenTransfer();\n', '  }\n', '\n', '  /**\n', '   * Allow upgrade agent functionality kick in only if the crowdsale was success.\n', '   */\n', '  function canUpgrade() public view returns(bool) {\n', '    return released && super.canUpgrade();\n', '  }\n', '\n', '  /**\n', '   * Get token chain type information\n', '   */\n', '  function getTokenChainType() public pure returns(string) {\n', "    return 'erc20-waves-dual';\n", '  }\n', '\n', '  /**\n', '   * Update token information\n', '   */\n', '  function setTokenInformation(string memory _name, string memory _symbol) public onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    emit UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '  function moveToWaves(string memory wavesAddress, uint256 amount) public {\n', '      require(transfer(wavesReserve, amount));\n', '      emit WavesTransfer(msg.sender, wavesAddress, amount);\n', '  }\n', '\n', '}']