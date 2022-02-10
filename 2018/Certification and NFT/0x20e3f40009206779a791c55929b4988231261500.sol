['pragma solidity ^0.4.4;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', '\n', 'contract ERC20 {\n', '\n', '  uint public totalSupply;\n', '  uint public decimals;\n', '\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  /* Current Owner */\n', '  address public owner;\n', '\n', '  /* New owner which can be set in future */\n', '  address public newOwner;\n', '\n', '  /* event to indicate finally ownership has been succesfully transferred and accepted */\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  /**\n', '   * The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) onlyOwner {\n', '    require(_newOwner != address(0));\n', '    newOwner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Allows the new owner toaccept ownership\n', '   */\n', '  function acceptOwnership() {\n', '    require(msg.sender == newOwner);\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', '*This library is used to do mathematics safely\n', '*/\n', 'contract SafeMathLib {\n', '  function safeMul(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' * Taken and inspired from https://tokenmarket.net\n', ' *\n', ' * Upgrade agent transfers tokens to a new version of a token contract.\n', ' * Upgrade agent can be set on a token by the upgrade master.\n', ' *\n', ' * Steps are\n', ' * - Upgradeabletoken.upgradeMaster calls UpgradeableToken.setUpgradeAgent()\n', ' * - Individual token holders can now call UpgradeableToken.upgrade()\n', ' *   -> This results to call UpgradeAgent.upgradeFrom() that issues new tokens\n', ' *   -> UpgradeableToken.upgrade() reduces the original total supply based on amount of upgraded tokens\n', ' *\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Upgrade amount of tokens to a new version.\n', '   *\n', '   * Only callable by UpgradeableToken.\n', '   *\n', '   * @param _tokenHolder Address that wants to upgrade its tokens\n', '   * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.\n', '   */\n', '  function upgradeFrom(address _tokenHolder, uint256 _amount) external;\n', '}\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMathLib {\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '\n', '      // SafMaths will automatically handle the overflow checks\n', '      balances[msg.sender] = safeSub(balances[msg.sender],_value);\n', '      balances[_to] = safeAdd(balances[_to],_value);\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    balances[_to] = safeAdd(balances[_to],_value);\n', '    balances[_from] = safeSub(balances[_from],_value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance,_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' * First envisioned by Golem and Lunyr projects.\n', ' * Taken and inspired from https://tokenmarket.net\n', ' */\n', 'contract CMBUpgradeableToken is StandardToken {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', '   * - WaitingForAgent: Token allows upgrade, but we don&#39;t have a new agent yet\n', '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  function CMBUpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);\n', '\n', '      // Validate input value.\n', '      require(value != 0);\n', '\n', '      balances[msg.sender] = safeSub(balances[msg.sender], value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply = safeSub(totalSupply, value);\n', '      totalUpgraded = safeAdd(totalUpgraded, value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '\n', '      // The token is not yet in a state that we could think upgrading\n', '      require(canUpgrade());\n', '\n', '      require(agent != 0x0);\n', '      // Only a master can designate the next agent\n', '      require(msg.sender == upgradeMaster);\n', '      // Upgrade has already begun for an agent\n', '      require(getUpgradeState() != UpgradeState.Upgrading);\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      require(upgradeAgent.isUpgradeAgent());\n', '      // Make sure that token supplies match in source and target\n', '      require(upgradeAgent.originalSupply() == totalSupply);\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      require(master != 0x0);\n', '      require(msg.sender == upgradeMaster);\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' * Taken and inspired from https://tokenmarket.net\n', ' */\n', 'contract ReleasableToken is ERC20, Ownable {\n', '\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '\n', '    if(!released) {\n', '        require(transferAgents[_sender]);\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', '    // We don&#39;t do interface check here as we might want to a normal wallet address to act as a release agent\n', '    releaseAgent = addr;\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    require(releaseState == released);\n', '    _;\n', '  }\n', '\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    require(msg.sender == releaseAgent);\n', '    _;\n', '  }\n', '\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    // Call StandardToken.transferFrom()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Coin is CMBUpgradeableToken, ReleasableToken {\n', '\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  /* name of the token */\n', '  string public name = "Creatanium";\n', '\n', '  /* symbol of the token */\n', '  string public symbol = "CMB";\n', '\n', '  /* token decimals to handle fractions */\n', '  uint public decimals = 18;\n', '\n', '/* initial token supply */\n', '  uint public totalSupply = 2000000000 * (10 ** decimals);\n', '  uint public onSaleTokens = 30000000 * (10 ** decimals);\n', '\n', '  uint256 pricePerToken = 295898260100000; //1 Eth = 276014352700000 CMB (0.2 USD = 1 CMB)\n', '\n', '\n', '  uint minETH = 0 * 10**decimals;\n', '  uint maxETH = 500 * 10**decimals; \n', '\n', '\n', '  //Crowdsale running\n', '  bool public isCrowdsaleOpen=false;\n', '  \n', '\n', '  uint tokensForPublicSale = 0;\n', '\n', '  address contractAddress;\n', '\n', '  \n', '\n', '  function Coin() CMBUpgradeableToken(msg.sender) {\n', '\n', '    owner = msg.sender;\n', '    contractAddress = address(this);\n', '    //tokens are kept in contract address rather than owner\n', '    balances[contractAddress] = totalSupply;\n', '  }\n', '\n', '  /* function to update token name and symbol */\n', '  function updateTokenInformation(string _name, string _symbol) onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '\n', '  function sendTokensToOwner(uint _tokens) onlyOwner returns (bool ok){\n', '      require(balances[contractAddress] >= _tokens);\n', '      balances[contractAddress] = safeSub(balances[contractAddress],_tokens);\n', '      balances[owner] = safeAdd(balances[owner],_tokens);\n', '      return true;\n', '  }\n', '\n', '\n', '  /* single address */\n', '  function sendTokensToInvestors(address _investor, uint _tokens) onlyOwner returns (bool ok){\n', '      require(balances[contractAddress] >= _tokens);\n', '      onSaleTokens = safeSub(onSaleTokens, _tokens);\n', '      balances[contractAddress] = safeSub(balances[contractAddress],_tokens);\n', '      balances[_investor] = safeAdd(balances[_investor],_tokens);\n', '      return true;\n', '  }\n', '\n', '\n', '\n', '  /* A dispense feature to allocate some addresses with CMB tokens\n', '  * calculation done using token count\n', '  *  Can be called only by owner\n', '  */\n', '  function dispenseTokensToInvestorAddressesByValue(address[] _addresses, uint[] _value) onlyOwner returns (bool ok){\n', '     require(_addresses.length == _value.length);\n', '     for(uint256 i=0; i<_addresses.length; i++){\n', '        onSaleTokens = safeSub(onSaleTokens, _value[i]);\n', '        balances[_addresses[i]] = safeAdd(balances[_addresses[i]], _value[i]);\n', '        balances[contractAddress] = safeSub(balances[contractAddress], _value[i]);\n', '     }\n', '     return true;\n', '  }\n', '\n', '\n', '  function startCrowdSale() onlyOwner {\n', '     isCrowdsaleOpen=true;\n', '  }\n', '\n', '   function stopCrowdSale() onlyOwner {\n', '     isCrowdsaleOpen=false;\n', '  }\n', '\n', '\n', ' function setPublicSaleParams(uint _tokensForPublicSale, uint _min, uint _max, bool _crowdsaleStatus ) onlyOwner {\n', '    require(_tokensForPublicSale != 0);\n', '    require(_tokensForPublicSale <= onSaleTokens);\n', '    tokensForPublicSale = _tokensForPublicSale;\n', '    isCrowdsaleOpen=_crowdsaleStatus;\n', '    require(_min >= 0);\n', '    require(_max > _min+1);\n', '    minETH = _min;\n', '    maxETH = _max;\n', ' }\n', '\n', '\n', ' function setTotalTokensForPublicSale(uint _value) onlyOwner{\n', '      require(_value != 0);\n', '      tokensForPublicSale = _value;\n', '  }\n', '\n', '  function setMinAndMaxEthersForPublicSale(uint _min, uint _max) onlyOwner{\n', '      require(_min >= 0);\n', '      require(_max > _min+1);\n', '      minETH = _min;\n', '      maxETH = _max;\n', '  }\n', '\n', '  function updateTokenPrice(uint _value) onlyOwner{\n', '      require(_value != 0);\n', '      pricePerToken = _value;\n', '  }\n', '\n', '\n', '  function updateOnSaleSupply(uint _newSupply) onlyOwner{\n', '      require(_newSupply != 0);\n', '      onSaleTokens = _newSupply;\n', '  }\n', '\n', '\n', '  function buyTokens() public payable returns(uint tokenAmount) {\n', '\n', '    uint _tokenAmount;\n', '    uint multiplier = (10 ** decimals);\n', '    uint weiAmount = msg.value;\n', '\n', '    require(isCrowdsaleOpen);\n', '    //require(whitelistedAddress[msg.sender]);\n', '\n', '    require(weiAmount >= minETH);\n', '    require(weiAmount <= maxETH);\n', '\n', '    _tokenAmount =  safeMul(weiAmount,multiplier) / pricePerToken;\n', '\n', '    require(_tokenAmount > 0);\n', '\n', '    //safe sub will automatically handle overflows\n', '    tokensForPublicSale = safeSub(tokensForPublicSale, _tokenAmount);\n', '    onSaleTokens = safeSub(onSaleTokens, _tokenAmount);\n', '    balances[contractAddress] = safeSub(balances[contractAddress],_tokenAmount);\n', '    //assign tokens\n', '    balances[msg.sender] = safeAdd(balances[msg.sender], _tokenAmount);\n', '\n', '    //send money to the owner\n', '    require(owner.send(weiAmount));\n', '\n', '    return _tokenAmount;\n', '\n', '  }\n', '\n', '  // There is no need for vesting. It will be done manually by manually releasing tokens to certain addresses\n', '\n', '  function() payable {\n', '      buyTokens();\n', '  }\n', '\n', '  function destroyToken() public onlyOwner {\n', '      selfdestruct(msg.sender);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.4;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', '\n', 'contract ERC20 {\n', '\n', '  uint public totalSupply;\n', '  uint public decimals;\n', '\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  /* Current Owner */\n', '  address public owner;\n', '\n', '  /* New owner which can be set in future */\n', '  address public newOwner;\n', '\n', '  /* event to indicate finally ownership has been succesfully transferred and accepted */\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  /**\n', '   * The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) onlyOwner {\n', '    require(_newOwner != address(0));\n', '    newOwner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Allows the new owner toaccept ownership\n', '   */\n', '  function acceptOwnership() {\n', '    require(msg.sender == newOwner);\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', '*This library is used to do mathematics safely\n', '*/\n', 'contract SafeMathLib {\n', '  function safeMul(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' * Taken and inspired from https://tokenmarket.net\n', ' *\n', ' * Upgrade agent transfers tokens to a new version of a token contract.\n', ' * Upgrade agent can be set on a token by the upgrade master.\n', ' *\n', ' * Steps are\n', ' * - Upgradeabletoken.upgradeMaster calls UpgradeableToken.setUpgradeAgent()\n', ' * - Individual token holders can now call UpgradeableToken.upgrade()\n', ' *   -> This results to call UpgradeAgent.upgradeFrom() that issues new tokens\n', ' *   -> UpgradeableToken.upgrade() reduces the original total supply based on amount of upgraded tokens\n', ' *\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Upgrade amount of tokens to a new version.\n', '   *\n', '   * Only callable by UpgradeableToken.\n', '   *\n', '   * @param _tokenHolder Address that wants to upgrade its tokens\n', '   * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.\n', '   */\n', '  function upgradeFrom(address _tokenHolder, uint256 _amount) external;\n', '}\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMathLib {\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '\n', '      // SafMaths will automatically handle the overflow checks\n', '      balances[msg.sender] = safeSub(balances[msg.sender],_value);\n', '      balances[_to] = safeAdd(balances[_to],_value);\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    balances[_to] = safeAdd(balances[_to],_value);\n', '    balances[_from] = safeSub(balances[_from],_value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance,_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' * First envisioned by Golem and Lunyr projects.\n', ' * Taken and inspired from https://tokenmarket.net\n', ' */\n', 'contract CMBUpgradeableToken is StandardToken {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', "   * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet\n", '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  function CMBUpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);\n', '\n', '      // Validate input value.\n', '      require(value != 0);\n', '\n', '      balances[msg.sender] = safeSub(balances[msg.sender], value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply = safeSub(totalSupply, value);\n', '      totalUpgraded = safeAdd(totalUpgraded, value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '\n', '      // The token is not yet in a state that we could think upgrading\n', '      require(canUpgrade());\n', '\n', '      require(agent != 0x0);\n', '      // Only a master can designate the next agent\n', '      require(msg.sender == upgradeMaster);\n', '      // Upgrade has already begun for an agent\n', '      require(getUpgradeState() != UpgradeState.Upgrading);\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      require(upgradeAgent.isUpgradeAgent());\n', '      // Make sure that token supplies match in source and target\n', '      require(upgradeAgent.originalSupply() == totalSupply);\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      require(master != 0x0);\n', '      require(msg.sender == upgradeMaster);\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' * Taken and inspired from https://tokenmarket.net\n', ' */\n', 'contract ReleasableToken is ERC20, Ownable {\n', '\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '\n', '    if(!released) {\n', '        require(transferAgents[_sender]);\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', "    // We don't do interface check here as we might want to a normal wallet address to act as a release agent\n", '    releaseAgent = addr;\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    require(releaseState == released);\n', '    _;\n', '  }\n', '\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    require(msg.sender == releaseAgent);\n', '    _;\n', '  }\n', '\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    // Call StandardToken.transferFrom()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Coin is CMBUpgradeableToken, ReleasableToken {\n', '\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  /* name of the token */\n', '  string public name = "Creatanium";\n', '\n', '  /* symbol of the token */\n', '  string public symbol = "CMB";\n', '\n', '  /* token decimals to handle fractions */\n', '  uint public decimals = 18;\n', '\n', '/* initial token supply */\n', '  uint public totalSupply = 2000000000 * (10 ** decimals);\n', '  uint public onSaleTokens = 30000000 * (10 ** decimals);\n', '\n', '  uint256 pricePerToken = 295898260100000; //1 Eth = 276014352700000 CMB (0.2 USD = 1 CMB)\n', '\n', '\n', '  uint minETH = 0 * 10**decimals;\n', '  uint maxETH = 500 * 10**decimals; \n', '\n', '\n', '  //Crowdsale running\n', '  bool public isCrowdsaleOpen=false;\n', '  \n', '\n', '  uint tokensForPublicSale = 0;\n', '\n', '  address contractAddress;\n', '\n', '  \n', '\n', '  function Coin() CMBUpgradeableToken(msg.sender) {\n', '\n', '    owner = msg.sender;\n', '    contractAddress = address(this);\n', '    //tokens are kept in contract address rather than owner\n', '    balances[contractAddress] = totalSupply;\n', '  }\n', '\n', '  /* function to update token name and symbol */\n', '  function updateTokenInformation(string _name, string _symbol) onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '\n', '  function sendTokensToOwner(uint _tokens) onlyOwner returns (bool ok){\n', '      require(balances[contractAddress] >= _tokens);\n', '      balances[contractAddress] = safeSub(balances[contractAddress],_tokens);\n', '      balances[owner] = safeAdd(balances[owner],_tokens);\n', '      return true;\n', '  }\n', '\n', '\n', '  /* single address */\n', '  function sendTokensToInvestors(address _investor, uint _tokens) onlyOwner returns (bool ok){\n', '      require(balances[contractAddress] >= _tokens);\n', '      onSaleTokens = safeSub(onSaleTokens, _tokens);\n', '      balances[contractAddress] = safeSub(balances[contractAddress],_tokens);\n', '      balances[_investor] = safeAdd(balances[_investor],_tokens);\n', '      return true;\n', '  }\n', '\n', '\n', '\n', '  /* A dispense feature to allocate some addresses with CMB tokens\n', '  * calculation done using token count\n', '  *  Can be called only by owner\n', '  */\n', '  function dispenseTokensToInvestorAddressesByValue(address[] _addresses, uint[] _value) onlyOwner returns (bool ok){\n', '     require(_addresses.length == _value.length);\n', '     for(uint256 i=0; i<_addresses.length; i++){\n', '        onSaleTokens = safeSub(onSaleTokens, _value[i]);\n', '        balances[_addresses[i]] = safeAdd(balances[_addresses[i]], _value[i]);\n', '        balances[contractAddress] = safeSub(balances[contractAddress], _value[i]);\n', '     }\n', '     return true;\n', '  }\n', '\n', '\n', '  function startCrowdSale() onlyOwner {\n', '     isCrowdsaleOpen=true;\n', '  }\n', '\n', '   function stopCrowdSale() onlyOwner {\n', '     isCrowdsaleOpen=false;\n', '  }\n', '\n', '\n', ' function setPublicSaleParams(uint _tokensForPublicSale, uint _min, uint _max, bool _crowdsaleStatus ) onlyOwner {\n', '    require(_tokensForPublicSale != 0);\n', '    require(_tokensForPublicSale <= onSaleTokens);\n', '    tokensForPublicSale = _tokensForPublicSale;\n', '    isCrowdsaleOpen=_crowdsaleStatus;\n', '    require(_min >= 0);\n', '    require(_max > _min+1);\n', '    minETH = _min;\n', '    maxETH = _max;\n', ' }\n', '\n', '\n', ' function setTotalTokensForPublicSale(uint _value) onlyOwner{\n', '      require(_value != 0);\n', '      tokensForPublicSale = _value;\n', '  }\n', '\n', '  function setMinAndMaxEthersForPublicSale(uint _min, uint _max) onlyOwner{\n', '      require(_min >= 0);\n', '      require(_max > _min+1);\n', '      minETH = _min;\n', '      maxETH = _max;\n', '  }\n', '\n', '  function updateTokenPrice(uint _value) onlyOwner{\n', '      require(_value != 0);\n', '      pricePerToken = _value;\n', '  }\n', '\n', '\n', '  function updateOnSaleSupply(uint _newSupply) onlyOwner{\n', '      require(_newSupply != 0);\n', '      onSaleTokens = _newSupply;\n', '  }\n', '\n', '\n', '  function buyTokens() public payable returns(uint tokenAmount) {\n', '\n', '    uint _tokenAmount;\n', '    uint multiplier = (10 ** decimals);\n', '    uint weiAmount = msg.value;\n', '\n', '    require(isCrowdsaleOpen);\n', '    //require(whitelistedAddress[msg.sender]);\n', '\n', '    require(weiAmount >= minETH);\n', '    require(weiAmount <= maxETH);\n', '\n', '    _tokenAmount =  safeMul(weiAmount,multiplier) / pricePerToken;\n', '\n', '    require(_tokenAmount > 0);\n', '\n', '    //safe sub will automatically handle overflows\n', '    tokensForPublicSale = safeSub(tokensForPublicSale, _tokenAmount);\n', '    onSaleTokens = safeSub(onSaleTokens, _tokenAmount);\n', '    balances[contractAddress] = safeSub(balances[contractAddress],_tokenAmount);\n', '    //assign tokens\n', '    balances[msg.sender] = safeAdd(balances[msg.sender], _tokenAmount);\n', '\n', '    //send money to the owner\n', '    require(owner.send(weiAmount));\n', '\n', '    return _tokenAmount;\n', '\n', '  }\n', '\n', '  // There is no need for vesting. It will be done manually by manually releasing tokens to certain addresses\n', '\n', '  function() payable {\n', '      buyTokens();\n', '  }\n', '\n', '  function destroyToken() public onlyOwner {\n', '      selfdestruct(msg.sender);\n', '  }\n', '\n', '}']