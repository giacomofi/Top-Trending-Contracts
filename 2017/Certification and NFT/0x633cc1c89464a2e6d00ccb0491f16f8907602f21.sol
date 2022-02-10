['/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard EIP-20 token with an interface marker.\n', ' *\n', ' * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.\n', ' *\n', ' */\n', 'contract StandardTokenExt is StandardToken {\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' *\n', ' * Upgrade agent transfers tokens to a new contract.\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' *\n', ' * First envisioned by Golem and Lunyr projects.\n', ' */\n', 'contract UpgradeableToken is StandardTokenExt {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', "   * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet\n", '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  function UpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {\n', '        // Called in a bad state\n', '        throw;\n', '      }\n', '\n', '      // Validate input value.\n', '      if (value == 0) throw;\n', '\n', '      balances[msg.sender] = balances[msg.sender].sub(value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply = totalSupply.sub(value);\n', '      totalUpgraded = totalUpgraded.add(value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '      if(!canUpgrade()) {\n', '        // The token is not yet in a state that we could think upgrading\n', '        throw;\n', '      }\n', '\n', '      if (agent == 0x0) throw;\n', '      // Only a master can designate the next agent\n', '      if (msg.sender != upgradeMaster) throw;\n', '      // Upgrade has already begun for an agent\n', '      if (getUpgradeState() == UpgradeState.Upgrading) throw;\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      if(!upgradeAgent.isUpgradeAgent()) throw;\n', '      // Make sure that token supplies match in source and target\n', '      if (upgradeAgent.originalSupply() != totalSupply) throw;\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      if (master == 0x0) throw;\n', '      if (msg.sender != upgradeMaster) throw;\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' */\n', 'contract ReleasableToken is ERC20, Ownable {\n', '\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '\n', '    if(!released) {\n', '        if(!transferAgents[_sender]) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   *\n', '   * Design choice. Allow reset the release agent to fix fat finger mistakes.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', "    // We don't do interface check here as we might want to a normal wallet address to act as a release agent\n", '    releaseAgent = addr;\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    if(releaseState != released) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    if(msg.sender != releaseAgent) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * Safe unsigned safe math.\n', ' *\n', ' * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli\n', ' *\n', ' * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol\n', ' *\n', ' * Maintained here until merged to mainline zeppelin-solidity.\n', ' *\n', ' */\n', 'library SafeMathLib {\n', '\n', '  function times(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function minus(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function plus(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * A token that can increase its supply by another contract.\n', ' *\n', ' * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.\n', ' * Only mint agents, contracts whitelisted by owner, can mint new tokens.\n', ' *\n', ' */\n', 'contract MintableToken is StandardTokenExt, Ownable {\n', '\n', '  using SafeMathLib for uint;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  /** List of agents that are allowed to create new tokens */\n', '  mapping (address => bool) public mintAgents;\n', '\n', '  event MintingAgentChanged(address addr, bool state);\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /**\n', '   * Create new tokens and allocate them to an address..\n', '   *\n', '   * Only callably by a crowdsale contract (mint agent).\n', '   */\n', '  function mint(address receiver, uint amount) onlyMintAgent canMint public {\n', '    totalSupply = totalSupply.plus(amount);\n', '    balances[receiver] = balances[receiver].plus(amount);\n', '\n', '    // This will make the mint transaction apper in EtherScan.io\n', '    // We can remove this after there is a standardized minting event\n', '    Transfer(0, receiver, amount);\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a crowdsale contract to mint new tokens.\n', '   */\n', '  function setMintAgent(address addr, bool state) onlyOwner canMint public {\n', '    mintAgents[addr] = state;\n', '    MintingAgentChanged(addr, state);\n', '  }\n', '\n', '  modifier onlyMintAgent() {\n', '    // Only crowdsale contracts are allowed to mint new tokens\n', '    if(!mintAgents[msg.sender]) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /** Make sure we are not done yet. */\n', '  modifier canMint() {\n', '    if(mintingFinished) throw;\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * A crowdsaled token.\n', ' *\n', ' * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.\n', ' *\n', ' * - The token transfer() is disabled until the crowdsale is over\n', ' * - The token contract gives an opt-in upgrade path to a new contract\n', ' * - The same token can be part of several crowdsales through approve() mechanism\n', ' * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)\n', ' *\n', ' */\n', 'contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {\n', '\n', '  /** Name and symbol were updated. */\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  string public name;\n', '\n', '  string public symbol;\n', '\n', '  uint public decimals;\n', '\n', '  /**\n', '   * Construct the token.\n', '   *\n', '   * This token must be created through a team multisig wallet, so that it is owned by that wallet.\n', '   *\n', '   * @param _name Token name\n', '   * @param _symbol Token symbol - should be all caps\n', '   * @param _initialSupply How many tokens we start with\n', '   * @param _decimals Number of decimal places\n', '   * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.\n', '   */\n', '  function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)\n', '    UpgradeableToken(msg.sender) {\n', '\n', '    // Create any address, can be transferred\n', '    // to team multisig via changeOwner(),\n', '    // also remember to call setUpgradeMaster()\n', '    owner = msg.sender;\n', '\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    totalSupply = _initialSupply;\n', '\n', '    decimals = _decimals;\n', '\n', '    // Create initially all balance on the team multisig\n', '    balances[owner] = totalSupply;\n', '\n', '    if(totalSupply > 0) {\n', '      Minted(owner, totalSupply);\n', '    }\n', '\n', '    // No more new supply allowed after the token creation\n', '    if(!_mintable) {\n', '      mintingFinished = true;\n', '      if(totalSupply == 0) {\n', '        throw; // Cannot create a token without supply and no minting\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * When token is released to be transferable, enforce no new tokens can be created.\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    mintingFinished = true;\n', '    super.releaseTokenTransfer();\n', '  }\n', '\n', '  /**\n', '   * Allow upgrade agent functionality kick in only if the crowdsale was success.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '    return released && super.canUpgrade();\n', '  }\n', '\n', '  /**\n', '   * Owner can update token information here.\n', '   *\n', '   * It is often useful to conceal the actual token association, until\n', '   * the token operations, like central issuance or reissuance have been completed.\n', '   *\n', '   * This function allows the token owner to rename the token after the operations\n', '   * have been completed and then point the audience to use the token contract.\n', '   */\n', '  function setTokenInformation(string _name, string _symbol) onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Hold tokens for a group investor of investors until the unlock date.\n', ' *\n', ' * After the unlock date the investor can claim their tokens.\n', ' *\n', ' * Steps\n', ' *\n', ' * - Prepare a spreadsheet for token allocation\n', ' * - Deploy this contract, with the sum to tokens to be distributed, from the owner account\n', ' * - Call setInvestor for all investors from the owner account using a local script and CSV input\n', ' * - Move tokensToBeAllocated in this contract using StandardToken.transfer()\n', ' * - Call lock from the owner account\n', ' * - Wait until the freeze period is over\n', ' * - After the freeze time is over investors can call claim() from their address to get their tokens\n', ' *\n', ' */\n', 'contract TokenVault is Ownable {\n', '\n', '  /** How many investors we have now */\n', '  uint public investorCount;\n', '\n', '  /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/\n', '  uint public tokensToBeAllocated;\n', '\n', '  /** How many tokens investors have claimed so far */\n', '  uint public totalClaimed;\n', '\n', '  /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */\n', '  uint public tokensAllocatedTotal;\n', '\n', '  /** How much we have allocated to the investors invested */\n', '  mapping(address => uint) public balances;\n', '\n', '  /** How many tokens investors have claimed */\n', '  mapping(address => uint) public claimed;\n', '\n', '  /** When our claim freeze is over (UNIX timestamp) */\n', '  uint public freezeEndsAt;\n', '\n', '  /** When this vault was locked (UNIX timestamp) */\n', '  uint public lockedAt;\n', '\n', '  /** We can also define our own token, which will override the ICO one ***/\n', '  CrowdsaleToken public token;\n', '\n', '  /** What is our current state.\n', '   *\n', '   * Loading: Investor data is being loaded and contract not yet locked\n', '   * Holding: Holding tokens for investors\n', '   * Distributing: Freeze time is over, investors can claim their tokens\n', '   */\n', '  enum State{Unknown, Loading, Holding, Distributing}\n', '\n', '  /** We allocated tokens for investor */\n', '  event Allocated(address investor, uint value);\n', '\n', '  /** We distributed tokens to an investor */\n', '  event Distributed(address investors, uint count);\n', '\n', '  event Locked();\n', '\n', '  /**\n', '   * Create presale contract where lock up period is given days\n', '   *\n', '   * @param _owner Who can load investor data and lock\n', '   * @param _freezeEndsAt UNIX timestamp when the vault unlocks\n', '   * @param _token Token contract address we are distributing\n', '   * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation\n', '   *\n', '   */\n', '  function TokenVault(address _owner, uint _freezeEndsAt, CrowdsaleToken _token, uint _tokensToBeAllocated) {\n', '\n', '    owner = _owner;\n', '\n', '    // Invalid owenr\n', '    if(owner == 0) {\n', '      throw;\n', '    }\n', '\n', '    token = _token;\n', '\n', '    // Check the address looks like a token contract\n', '    if(!token.isToken()) {\n', '      throw;\n', '    }\n', '\n', '    // Give argument\n', '    if(_freezeEndsAt == 0) {\n', '      throw;\n', '    }\n', '\n', '    // Sanity check on _tokensToBeAllocated\n', '    if(_tokensToBeAllocated == 0) {\n', '      throw;\n', '    }\n', '\n', '    freezeEndsAt = _freezeEndsAt;\n', '    tokensToBeAllocated = _tokensToBeAllocated;\n', '  }\n', '\n', '  /// @dev Add a presale participating allocation\n', '  function setInvestor(address investor, uint amount) public onlyOwner {\n', '\n', '    if(lockedAt > 0) {\n', '      // Cannot add new investors after the vault is locked\n', '      throw;\n', '    }\n', '\n', '    if(amount == 0) throw; // No empty buys\n', '\n', "    // Don't allow reset\n", '    if(balances[investor] > 0) {\n', '      throw;\n', '    }\n', '\n', '    balances[investor] = amount;\n', '\n', '    investorCount++;\n', '\n', '    tokensAllocatedTotal += amount;\n', '\n', '    Allocated(investor, amount);\n', '  }\n', '\n', '  /// @dev Lock the vault\n', '  ///      - All balances have been loaded in correctly\n', '  ///      - Tokens are transferred on this vault correctly\n', '  ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.\n', '  function lock() onlyOwner {\n', '\n', '    if(lockedAt > 0) {\n', '      throw; // Already locked\n', '    }\n', '\n', '    // Spreadsheet sum does not match to what we have loaded to the investor data\n', '    if(tokensAllocatedTotal != tokensToBeAllocated) {\n', '      throw;\n', '    }\n', '\n', '    // Do not lock the vault if the given tokens are not on this contract\n', '    if(token.balanceOf(address(this)) != tokensAllocatedTotal) {\n', '      throw;\n', '    }\n', '\n', '    lockedAt = now;\n', '\n', '    Locked();\n', '  }\n', '\n', '  /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.\n', '  function recoverFailedLock() onlyOwner {\n', '    if(lockedAt > 0) {\n', '      throw;\n', '    }\n', '\n', '    // Transfer all tokens on this contract back to the owner\n', '    token.transfer(owner, token.balanceOf(address(this)));\n', '  }\n', '\n', '  /// @dev Get the current balance of tokens in the vault\n', '  /// @return uint How many tokens there are currently in vault\n', '  function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {\n', '    return token.balanceOf(address(this));\n', '  }\n', '\n', '  /// @dev Claim N bought tokens to the investor as the msg sender\n', '  function claim() {\n', '\n', '    address investor = msg.sender;\n', '\n', '    if(lockedAt == 0) {\n', '      throw; // We were never locked\n', '    }\n', '\n', '    if(now < freezeEndsAt) {\n', '      throw; // Trying to claim early\n', '    }\n', '\n', '    if(balances[investor] == 0) {\n', '      // Not our investor\n', '      throw;\n', '    }\n', '\n', '    if(claimed[investor] > 0) {\n', '      throw; // Already claimed\n', '    }\n', '\n', '    uint amount = balances[investor];\n', '\n', '    claimed[investor] = amount;\n', '\n', '    totalClaimed += amount;\n', '\n', '    token.transfer(investor, amount);\n', '\n', '    Distributed(investor, amount);\n', '  }\n', '\n', '  /// @dev Resolve the contract umambigious state\n', '  function getState() public constant returns(State) {\n', '    if(lockedAt == 0) {\n', '      return State.Loading;\n', '    } else if(now > freezeEndsAt) {\n', '      return State.Distributing;\n', '    } else {\n', '      return State.Holding;\n', '    }\n', '  }\n', '\n', '}']