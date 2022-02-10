['/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   *\n', '   * Fix for the ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' *\n', ' * Upgrade agent transfers tokens to a new contract.\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' *\n', ' * First envisioned by Golem and Lunyr projects.\n', ' */\n', 'contract UpgradeableToken is StandardToken {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', '   * - WaitingForAgent: Token allows upgrade, but we don&#39;t have a new agent yet\n', '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  function UpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {\n', '        // Called in a bad state\n', '        throw;\n', '      }\n', '\n', '      // Validate input value.\n', '      if (value == 0) throw;\n', '\n', '      balances[msg.sender] = safeSub(balances[msg.sender], value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply = safeSub(totalSupply, value);\n', '      totalUpgraded = safeAdd(totalUpgraded, value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '      if(!canUpgrade()) {\n', '        // The token is not yet in a state that we could think upgrading\n', '        throw;\n', '      }\n', '\n', '      if (agent == 0x0) throw;\n', '      // Only a master can designate the next agent\n', '      if (msg.sender != upgradeMaster) throw;\n', '      // Upgrade has already begun for an agent\n', '      if (getUpgradeState() == UpgradeState.Upgrading) throw;\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      if(!upgradeAgent.isUpgradeAgent()) throw;\n', '      // Make sure that token supplies match in source and target\n', '      if (upgradeAgent.originalSupply() != totalSupply) throw;\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      if (master == 0x0) throw;\n', '      if (msg.sender != upgradeMaster) throw;\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' */\n', 'contract ReleasableToken is ERC20, Ownable {\n', '\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '\n', '    if(!released) {\n', '        if(!transferAgents[_sender]) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   *\n', '   * Design choice. Allow reset the release agent to fix fat finger mistakes.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', '    // We don&#39;t do interface check here as we might want to a normal wallet address to act as a release agent\n', '    releaseAgent = addr;\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    if(releaseState != released) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    if(msg.sender != releaseAgent) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * Safe unsigned safe math.\n', ' *\n', ' * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli\n', ' *\n', ' * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol\n', ' *\n', ' * Maintained here until merged to mainline zeppelin-solidity.\n', ' *\n', ' */\n', 'library SafeMathLib {\n', '\n', '  function times(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function minus(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function plus(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) private {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * A token that can increase its supply by another contract.\n', ' *\n', ' * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.\n', ' * Only mint agents, contracts whitelisted by owner, can mint new tokens.\n', ' *\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '\n', '  using SafeMathLib for uint;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  /** List of agents that are allowed to create new tokens */\n', '  mapping (address => bool) public mintAgents;\n', '\n', '  event MintingAgentChanged(address addr, bool state  );\n', '\n', '  /**\n', '   * Create new tokens and allocate them to an address..\n', '   *\n', '   * Only callably by a crowdsale contract (mint agent).\n', '   */\n', '  function mint(address receiver, uint amount) onlyMintAgent canMint public {\n', '    totalSupply = totalSupply.plus(amount);\n', '    balances[receiver] = balances[receiver].plus(amount);\n', '\n', '    // This will make the mint transaction apper in EtherScan.io\n', '    // We can remove this after there is a standardized minting event\n', '    Transfer(0, receiver, amount);\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a crowdsale contract to mint new tokens.\n', '   */\n', '  function setMintAgent(address addr, bool state) onlyOwner canMint public {\n', '    mintAgents[addr] = state;\n', '    MintingAgentChanged(addr, state);\n', '  }\n', '\n', '  modifier onlyMintAgent() {\n', '    // Only crowdsale contracts are allowed to mint new tokens\n', '    if(!mintAgents[msg.sender]) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /** Make sure we are not done yet. */\n', '  modifier canMint() {\n', '    if(mintingFinished) throw;\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * A crowdsaled token.\n', ' *\n', ' * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.\n', ' *\n', ' * - The token transfer() is disabled until the crowdsale is over\n', ' * - The token contract gives an opt-in upgrade path to a new contract\n', ' * - The same token can be part of several crowdsales through approve() mechanism\n', ' * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)\n', ' *\n', ' */\n', 'contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {\n', '\n', '  /** Name and symbol were updated. */\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  string public name;\n', '\n', '  string public symbol;\n', '\n', '  uint public decimals;\n', '\n', '  /**\n', '   * Construct the token.\n', '   *\n', '   * This token must be created through a team multisig wallet, so that it is owned by that wallet.\n', '   *\n', '   * @param _name Token name\n', '   * @param _symbol Token symbol - should be all caps\n', '   * @param _initialSupply How many tokens we start with\n', '   * @param _decimals Number of decimal places\n', '   * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.\n', '   */\n', '  function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)\n', '    UpgradeableToken(msg.sender) {\n', '\n', '    // Create any address, can be transferred\n', '    // to team multisig via changeOwner(),\n', '    // also remember to call setUpgradeMaster()\n', '    owner = msg.sender;\n', '\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    totalSupply = _initialSupply;\n', '\n', '    decimals = _decimals;\n', '\n', '    // Create initially all balance on the team multisig\n', '    balances[owner] = totalSupply;\n', '\n', '    if(totalSupply > 0) {\n', '      Minted(owner, totalSupply);\n', '    }\n', '\n', '    // No more new supply allowed after the token creation\n', '    if(!_mintable) {\n', '      mintingFinished = true;\n', '      if(totalSupply == 0) {\n', '        throw; // Cannot create a token without supply and no minting\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * When token is released to be transferable, enforce no new tokens can be created.\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    mintingFinished = true;\n', '    super.releaseTokenTransfer();\n', '  }\n', '\n', '  /**\n', '   * Allow upgrade agent functionality kick in only if the crowdsale was success.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '    return released && super.canUpgrade();\n', '  }\n', '\n', '  /**\n', '   * Owner can update token information here.\n', '   *\n', '   * It is often useful to conceal the actual token association, until\n', '   * the token operations, like central issuance or reissuance have been completed.\n', '   *\n', '   * This function allows the token owner to rename the token after the operations\n', '   * have been completed and then point the audience to use the token contract.\n', '   */\n', '  function setTokenInformation(string _name, string _symbol) onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '}']