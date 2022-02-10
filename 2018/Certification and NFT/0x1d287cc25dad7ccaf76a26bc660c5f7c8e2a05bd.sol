['/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract Recoverable is Ownable {\n', '\n', '  /// @dev Empty constructor (for now)\n', '  function Recoverable() {\n', '  }\n', '\n', '  /// @dev This will be invoked by the owner, when owner wants to rescue tokens\n', '  /// @param token Token which will we rescue to the owner from the contract\n', '  function recoverTokens(ERC20Basic token) onlyOwner public {\n', '    token.transfer(owner, tokensToBeReturned(token));\n', '  }\n', '\n', '  /// @dev Interface function, can be overwritten by the superclass\n', '  /// @param token Token which balance we will check and return\n', '  /// @return The amount of tokens (in smallest denominator) the contract owns\n', '  function tokensToBeReturned(ERC20Basic token) public returns (uint) {\n', '    return token.balanceOf(this);\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard EIP-20 token with an interface marker.\n', ' *\n', ' * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.\n', ' *\n', ' */\n', 'contract StandardTokenExt is StandardToken, Recoverable {\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', 'contract BurnableToken is StandardTokenExt {\n', '\n', '  // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event\n', '  address public constant BURN_ADDRESS = 0;\n', '\n', '  /** How many tokens we burned */\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '  /**\n', '   * Burn extra tokens from a balance.\n', '   *\n', '   */\n', '  function burn(uint burnAmount) {\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(burnAmount);\n', '    totalSupply_ = totalSupply_.sub(burnAmount);\n', '    Burned(burner, burnAmount);\n', '\n', '    // Inform the blockchain explores that track the\n', '    // balances only by a transfer event that the balance in this\n', '    // address has decreased\n', '    Transfer(burner, BURN_ADDRESS, burnAmount);\n', '  }\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' *\n', ' * Upgrade agent transfers tokens to a new contract.\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' *\n', ' * First envisioned by Golem and Lunyr projects.\n', ' */\n', 'contract UpgradeableToken is StandardTokenExt {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', '   * - WaitingForAgent: Token allows upgrade, but we don&#39;t have a new agent yet\n', '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  function UpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {\n', '        // Called in a bad state\n', '        throw;\n', '      }\n', '\n', '      // Validate input value.\n', '      if (value == 0) throw;\n', '\n', '      balances[msg.sender] = balances[msg.sender].sub(value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply_ = totalSupply_.sub(value);\n', '      totalUpgraded = totalUpgraded.add(value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '      if(!canUpgrade()) {\n', '        // The token is not yet in a state that we could think upgrading\n', '        throw;\n', '      }\n', '\n', '      if (agent == 0x0) throw;\n', '      // Only a master can designate the next agent\n', '      if (msg.sender != upgradeMaster) throw;\n', '      // Upgrade has already begun for an agent\n', '      if (getUpgradeState() == UpgradeState.Upgrading) throw;\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      if(!upgradeAgent.isUpgradeAgent()) throw;\n', '      // Make sure that token supplies match in source and target\n', '      if (upgradeAgent.originalSupply() != totalSupply_) throw;\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      if (master == 0x0) throw;\n', '      if (msg.sender != upgradeMaster) throw;\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' */\n', 'contract ReleasableToken is StandardTokenExt {\n', '\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '\n', '    if(!released) {\n', '        if(!transferAgents[_sender]) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   *\n', '   * Design choice. Allow reset the release agent to fix fat finger mistakes.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', '    // We don&#39;t do interface check here as we might want to a normal wallet address to act as a release agent\n', '    releaseAgent = addr;\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    if(releaseState != released) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    if(msg.sender != releaseAgent) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * Safe unsigned safe math.\n', ' *\n', ' * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli\n', ' *\n', ' * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol\n', ' *\n', ' * Maintained here until merged to mainline zeppelin-solidity.\n', ' *\n', ' */\n', 'library SafeMathLib {\n', '\n', '  function times(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function minus(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function plus(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * A token that can increase its supply by another contract.\n', ' *\n', ' * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.\n', ' * Only mint agents, contracts whitelisted by owner, can mint new tokens.\n', ' *\n', ' */\n', 'contract MintableToken is StandardTokenExt {\n', '\n', '  using SafeMathLib for uint;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  /** List of agents that are allowed to create new tokens */\n', '  mapping (address => bool) public mintAgents;\n', '\n', '  event MintingAgentChanged(address addr, bool state);\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /**\n', '   * Create new tokens and allocate them to an address..\n', '   *\n', '   * Only callably by a crowdsale contract (mint agent).\n', '   */\n', '  function mint(address receiver, uint amount) onlyMintAgent canMint public {\n', '    totalSupply_ = totalSupply_.plus(amount);\n', '    balances[receiver] = balances[receiver].plus(amount);\n', '\n', '    // This will make the mint transaction apper in EtherScan.io\n', '    // We can remove this after there is a standardized minting event\n', '    Transfer(0, receiver, amount);\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a crowdsale contract to mint new tokens.\n', '   */\n', '  function setMintAgent(address addr, bool state) onlyOwner canMint public {\n', '    mintAgents[addr] = state;\n', '    MintingAgentChanged(addr, state);\n', '  }\n', '\n', '  modifier onlyMintAgent() {\n', '    // Only crowdsale contracts are allowed to mint new tokens\n', '    if(!mintAgents[msg.sender]) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /** Make sure we are not done yet. */\n', '  modifier canMint() {\n', '    if(mintingFinished) throw;\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * A crowdsaled token.\n', ' *\n', ' * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.\n', ' *\n', ' * - The token transfer() is disabled until the crowdsale is over\n', ' * - The token contract gives an opt-in upgrade path to a new contract\n', ' * - The same token can be part of several crowdsales through approve() mechanism\n', ' * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)\n', ' *\n', ' */\n', 'contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {\n', '\n', '  /** Name and symbol were updated. */\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  string public name;\n', '\n', '  string public symbol;\n', '\n', '  uint public decimals;\n', '\n', '  /**\n', '   * Construct the token.\n', '   *\n', '   * This token must be created through a team multisig wallet, so that it is owned by that wallet.\n', '   *\n', '   * @param _name Token name\n', '   * @param _symbol Token symbol - should be all caps\n', '   * @param _initialSupply How many tokens we start with\n', '   * @param _decimals Number of decimal places\n', '   * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.\n', '   */\n', '  function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)\n', '    UpgradeableToken(msg.sender) {\n', '\n', '    // Create any address, can be transferred\n', '    // to team multisig via changeOwner(),\n', '    // also remember to call setUpgradeMaster()\n', '    owner = msg.sender;\n', '\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    totalSupply_ = _initialSupply;\n', '\n', '    decimals = _decimals;\n', '\n', '    // Create initially all balance on the team multisig\n', '    balances[owner] = totalSupply_;\n', '\n', '    if(totalSupply_ > 0) {\n', '      Minted(owner, totalSupply_);\n', '    }\n', '\n', '    // No more new supply allowed after the token creation\n', '    if(!_mintable) {\n', '      mintingFinished = true;\n', '      if(totalSupply_ == 0) {\n', '        throw; // Cannot create a token without supply and no minting\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * When token is released to be transferable, enforce no new tokens can be created.\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    mintingFinished = true;\n', '    super.releaseTokenTransfer();\n', '  }\n', '\n', '  /**\n', '   * Allow upgrade agent functionality kick in only if the crowdsale was success.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '    return released && super.canUpgrade();\n', '  }\n', '\n', '  /**\n', '   * Owner can update token information here.\n', '   *\n', '   * It is often useful to conceal the actual token association, until\n', '   * the token operations, like central issuance or reissuance have been completed.\n', '   *\n', '   * This function allows the token owner to rename the token after the operations\n', '   * have been completed and then point the audience to use the token contract.\n', '   */\n', '  function setTokenInformation(string _name, string _symbol) onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A crowdsaled token that you can also burn.\n', ' *\n', ' */\n', 'contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {\n', '\n', '  function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)\n', '    CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {\n', '\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * The AML Token\n', ' *\n', ' * This subset of BurnableCrowdsaleToken gives the Owner a possibility to\n', ' * reclaim tokens from a participant before the token is released\n', ' * after a participant has failed a prolonged AML process.\n', ' *\n', ' * It is assumed that the anti-money laundering process depends on blockchain data.\n', ' * The data is not available before the transaction and not for the smart contract.\n', ' * Thus, we need to implement logic to handle AML failure cases post payment.\n', ' * We give a time window before the token release for the token sale owners to\n', ' * complete the AML and claw back all token transactions that were\n', ' * caused by rejected purchases.\n', ' */\n', 'contract AMLToken is BurnableCrowdsaleToken {\n', '\n', '  // An event when the owner has reclaimed non-released tokens\n', '  event OwnerReclaim(address fromWhom, uint amount);\n', '\n', '  function AMLToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) BurnableCrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {\n', '\n', '  }\n', '\n', '  /// @dev Here the owner can reclaim the tokens from a participant if\n', '  ///      the token is not released yet. Refund will be handled offband.\n', '  /// @param fromWhom address of the participant whose tokens we want to claim\n', '  function transferToOwner(address fromWhom) onlyOwner {\n', '    if (released) revert();\n', '\n', '    uint amount = balanceOf(fromWhom);\n', '    balances[fromWhom] = balances[fromWhom].sub(amount);\n', '    balances[owner] = balances[owner].add(amount);\n', '    Transfer(fromWhom, owner, amount);\n', '    OwnerReclaim(fromWhom, amount);\n', '  }\n', '}']