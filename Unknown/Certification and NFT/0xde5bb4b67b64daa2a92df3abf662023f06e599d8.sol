['pragma solidity ^0.4.11;\n', '\n', ' contract SafeMathLib {\n', '\n', '  function safeMul(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) private {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address _to, uint _value) returns (bool success);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '  function approve(address _spender, uint _value) returns (bool success);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract FractionalERC20 is ERC20 {\n', '\n', '  uint public decimals;\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, SafeMathLib{\n', '  \n', '  event Minted(address receiver, uint amount);\n', '\n', '  \n', '  mapping(address => uint) balances;\n', '\n', '  \n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length != size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '   \n', '   \n', '    balances[msg.sender] = safeSub(balances[msg.sender],_value);\n', '    balances[_to] = safeAdd(balances[_to],_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to],_value);\n', '    balances[_from] = safeSub(balances[_from],_value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance,_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', ' function addApproval(address _spender, uint _addedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '      uint oldValue = allowed[msg.sender][_spender];\n', '      allowed[msg.sender][_spender] = safeAdd(oldValue,_addedValue);\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '  function subApproval(address _spender, uint _subtractedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '\n', '      uint oldVal = allowed[msg.sender][_spender];\n', '\n', '      if (_subtractedValue > oldVal) {\n', '          allowed[msg.sender][_spender] = 0;\n', '      } else {\n', '          allowed[msg.sender][_spender] = safeSub(oldVal,_subtractedValue);\n', '      }\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  \n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '\n', ' contract UpgradeableToken is StandardToken {\n', '\n', '  \n', '  address public upgradeMaster;\n', '\n', '  \n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  \n', '  uint256 public totalUpgraded;\n', '\n', '  \n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  \n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  \n', '  event UpgradeAgentSet(address agent);\n', '\n', '  \n', '  function UpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  \n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {\n', '        \n', '        throw;\n', '      }\n', '\n', '      \n', '      if (value == 0) throw;\n', '\n', '      balances[msg.sender] = safeSub(balances[msg.sender],value);\n', '\n', '      \n', '      totalSupply = safeSub(totalSupply,value);\n', '      totalUpgraded = safeAdd(totalUpgraded,value);\n', '\n', '      \n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', ' \n', '  function setUpgradeAgent(address agent) external {\n', '\n', '      if(!canUpgrade()) {\n', '        \n', '        throw;\n', '      }\n', '\n', '      if (agent == 0x0) throw;\n', '      \n', '      if (msg.sender != upgradeMaster) throw;\n', '      \n', '      if (getUpgradeState() == UpgradeState.Upgrading) throw;\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      \n', '      if(!upgradeAgent.isUpgradeAgent()) throw;\n', '      \n', '      if (upgradeAgent.originalSupply() != totalSupply) throw;\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  \n', '  function setUpgradeMaster(address master) public {\n', '      if (master == 0x0) throw;\n', '      if (msg.sender != upgradeMaster) throw;\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  \n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ReleasableToken is ERC20, Ownable {\n', '\n', '  \n', '  address public releaseAgent;\n', '\n', '  \n', '  bool public released = false;\n', '\n', '  \n', '  mapping (address => bool) public transferAgents;\n', '\n', '\n', '  modifier canTransfer(address _sender) {\n', '\n', '    if(!released) {\n', '        if(!transferAgents[_sender]) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '    releaseAgent = addr;\n', '  }\n', '\n', '\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  \n', '  modifier inReleaseState(bool releaseState) {\n', '    if(releaseState != released) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  \n', '  modifier onlyReleaseAgent() {\n', '    if(msg.sender != releaseAgent) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    \n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    \n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  \n', '  mapping (address => bool) public mintAgents;\n', '\n', '  event MintingAgentChanged(address addr, bool state  );\n', '\n', '\n', '  function mint(address receiver, uint amount) onlyMintAgent canMint public {\n', '    totalSupply = safeAdd(totalSupply,amount);\n', '    balances[receiver] = safeAdd(balances[receiver],amount);\n', '\n', '\n', '    Transfer(0, receiver, amount);\n', '  }\n', '\n', '\n', '  function setMintAgent(address addr, bool state) onlyOwner canMint public {\n', '    mintAgents[addr] = state;\n', '    MintingAgentChanged(addr, state);\n', '  }\n', '\n', '  modifier onlyMintAgent() {\n', '    \n', '    if(!mintAgents[msg.sender]) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  \n', '  modifier canMint() {\n', '    if(mintingFinished) throw;\n', '    _;\n', '  }\n', '}\n', '\n', '\n', 'contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {\n', '\n', '  event UpdatedTokenInformation(string newName, string newSymbol);\n', '\n', '  string public name;\n', '\n', '  string public symbol;\n', '\n', '  uint public decimals;\n', '\n', '  function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)\n', '    UpgradeableToken(msg.sender) {\n', '\n', '    owner = msg.sender;\n', '\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    totalSupply = _initialSupply;\n', '\n', '    decimals = _decimals;\n', '\n', '    \n', '    balances[owner] = totalSupply;\n', '\n', '    if(totalSupply > 0) {\n', '      Minted(owner, totalSupply);\n', '    }\n', '\n', '    \n', '    if(!_mintable) {\n', '      mintingFinished = true;\n', '      if(totalSupply == 0) {\n', '        throw; \n', '      }\n', '    }\n', '  }\n', '\n', '\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    mintingFinished = true;\n', '    super.releaseTokenTransfer();\n', '  }\n', '\n', '\n', '  function canUpgrade() public constant returns(bool) {\n', '    return released && super.canUpgrade();\n', '  }\n', '\n', '\n', '  function setTokenInformation(string _name, string _symbol) onlyOwner {\n', '    name = _name;\n', '    symbol = _symbol;\n', '\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract FinalizeAgent {\n', '\n', '  function isFinalizeAgent() public constant returns(bool) {\n', '    return true;\n', '  }\n', '  function isSane() public constant returns (bool);\n', '  function finalizeCrowdsale();\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', ' contract PricingStrategy {\n', '  function isPricingStrategy() public constant returns (bool) {\n', '    return true;\n', '  }\n', '  function isSane(address crowdsale) public constant returns (bool) {\n', '    return true;\n', '  }\n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);\n', '}\n', '\n', '\n', '\n', '\n', '\n', ' contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    if (halted) throw;\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    if (!halted) throw;\n', '    _;\n', '  }\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract Crowdsale is Haltable, SafeMathLib {\n', '  FractionalERC20 public token;\n', '  PricingStrategy public pricingStrategy;\n', '  FinalizeAgent public finalizeAgent;\n', '  address public multisigWallet;\n', '  uint public minimumFundingGoal;\n', '  uint public startsAt;\n', '  uint public endsAt;\n', '  uint public tokensSold = 0;\n', '  uint public weiRaised = 0;\n', '  uint public investorCount = 0;\n', '  uint public loadedRefund = 0;\n', '  uint public weiRefunded = 0;\n', '  bool public finalized;\n', '  bool public requireCustomerId;\n', '  bool public requiredSignedAddress;\n', '  address public signerAddress;\n', '  mapping (address => uint256) public investedAmountOf;\n', '  mapping (address => uint256) public tokenAmountOf;\n', '  mapping (address => bool) public earlyParticipantWhitelist;\n', '  uint public ownerTestValue;\n', '  enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}\n', '  event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);\n', '  event Refund(address investor, uint weiAmount);\n', '  event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);\n', '  event Whitelisted(address addr, bool status);\n', '  event EndsAtChanged(uint endsAt);\n', '\n', '  function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {\n', '\n', '    owner = msg.sender;\n', '\n', '    token = FractionalERC20(_token);\n', '\n', '    setPricingStrategy(_pricingStrategy);\n', '\n', '    multisigWallet = _multisigWallet;\n', '    if(multisigWallet == 0) {\n', '        throw;\n', '    }\n', '\n', '    if(_start == 0) {\n', '        throw;\n', '    }\n', '\n', '    startsAt = _start;\n', '\n', '    if(_end == 0) {\n', '        throw;\n', '    }\n', '\n', '    endsAt = _end;\n', '    if(startsAt >= endsAt) {\n', '        throw;\n', '    }\n', '    minimumFundingGoal = _minimumFundingGoal;\n', '  }\n', '  function() payable {\n', '    throw;\n', '  }\n', '  function investInternal(address receiver, uint128 customerId) stopInEmergency private {\n', '    if(getState() == State.PreFunding) {\n', '      if(!earlyParticipantWhitelist[receiver]) {\n', '        throw;\n', '      }\n', '    } else if(getState() == State.Funding) {\n', '    } else {\n', '      throw;\n', '    }\n', '\n', '    uint weiAmount = msg.value;\n', '    uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());\n', '\n', '    if(tokenAmount == 0) {\n', '      throw;\n', '    }\n', '\n', '    if(investedAmountOf[receiver] == 0) {\n', '       investorCount++;\n', '    }\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);\n', '    tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);\n', '    weiRaised = safeAdd(weiRaised,weiAmount);\n', '    tokensSold = safeAdd(tokensSold,tokenAmount);\n', '    if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {\n', '      throw;\n', '    }\n', '\n', '    assignTokens(receiver, tokenAmount);\n', '    if(!multisigWallet.send(weiAmount)) throw;\n', '    Invested(receiver, weiAmount, tokenAmount, customerId);\n', '  }\n', '  function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {\n', '\n', '    uint tokenAmount = fullTokens * 10**token.decimals();\n', '    uint weiAmount = weiPrice * fullTokens;\n', '\n', '    weiRaised = safeAdd(weiRaised,weiAmount);\n', '    tokensSold = safeAdd(tokensSold,tokenAmount);\n', '\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);\n', '    tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);\n', '\n', '    assignTokens(receiver, tokenAmount);\n', '    Invested(receiver, weiAmount, tokenAmount, 0);\n', '  }\n', '  function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '     bytes32 hash = sha256(addr);\n', '     if (ecrecover(hash, v, r, s) != signerAddress) throw;\n', '     if(customerId == 0) throw;\n', '     investInternal(addr, customerId);\n', '  }\n', '  function investWithCustomerId(address addr, uint128 customerId) public payable {\n', '    if(requiredSignedAddress) throw;\n', '    if(customerId == 0) throw;\n', '    investInternal(addr, customerId);\n', '  }\n', '  function invest(address addr) public payable {\n', '    if(requireCustomerId) throw;\n', '    if(requiredSignedAddress) throw;\n', '    investInternal(addr, 0);\n', '  }\n', '  function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '    investWithSignedAddress(msg.sender, customerId, v, r, s);\n', '  }\n', '  function buyWithCustomerId(uint128 customerId) public payable {\n', '    investWithCustomerId(msg.sender, customerId);\n', '  }\n', '  function buy() public payable {\n', '    invest(msg.sender);\n', '  }\n', '  function finalize() public inState(State.Success) onlyOwner stopInEmergency {\n', '    if(finalized) {\n', '      throw;\n', '    }\n', '    if(address(finalizeAgent) != 0) {\n', '      finalizeAgent.finalizeCrowdsale();\n', '    }\n', '\n', '    finalized = true;\n', '  }\n', '  function setFinalizeAgent(FinalizeAgent addr) onlyOwner {\n', '    finalizeAgent = addr;\n', '    if(!finalizeAgent.isFinalizeAgent()) {\n', '      throw;\n', '    }\n', '  }\n', '  function setRequireCustomerId(bool value) onlyOwner {\n', '    requireCustomerId = value;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {\n', '    requiredSignedAddress = value;\n', '    signerAddress = _signerAddress;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {\n', '    earlyParticipantWhitelist[addr] = status;\n', '    Whitelisted(addr, status);\n', '  }\n', '  function setEndsAt(uint time) onlyOwner {\n', '\n', '    if(now > time) {\n', '      throw;\n', '    }\n', '\n', '    endsAt = time;\n', '    EndsAtChanged(endsAt);\n', '  }\n', '  function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {\n', '    pricingStrategy = _pricingStrategy;\n', '    if(!pricingStrategy.isPricingStrategy()) {\n', '      throw;\n', '    }\n', '  }\n', '  function loadRefund() public payable inState(State.Failure) {\n', '    if(msg.value == 0) throw;\n', '    loadedRefund = safeAdd(loadedRefund,msg.value);\n', '  }\n', '  function refund() public inState(State.Refunding) {\n', '    uint256 weiValue = investedAmountOf[msg.sender];\n', '    if (weiValue == 0) throw;\n', '    investedAmountOf[msg.sender] = 0;\n', '    weiRefunded = safeAdd(weiRefunded,weiValue);\n', '    Refund(msg.sender, weiValue);\n', '    if (!msg.sender.send(weiValue)) throw;\n', '  }\n', '  function isMinimumGoalReached() public constant returns (bool reached) {\n', '    return weiRaised >= minimumFundingGoal;\n', '  }\n', '  function isFinalizerSane() public constant returns (bool sane) {\n', '    return finalizeAgent.isSane();\n', '  }\n', '  function isPricingSane() public constant returns (bool sane) {\n', '    return pricingStrategy.isSane(address(this));\n', '  }\n', '  function getState() public constant returns (State) {\n', '    if(finalized) return State.Finalized;\n', '    else if (address(finalizeAgent) == 0) return State.Preparing;\n', '    else if (!finalizeAgent.isSane()) return State.Preparing;\n', '    else if (!pricingStrategy.isSane(address(this))) return State.Preparing;\n', '    else if (block.timestamp < startsAt) return State.PreFunding;\n', '    else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;\n', '    else if (isMinimumGoalReached()) return State.Success;\n', '    else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;\n', '    else return State.Failure;\n', '  }\n', '  function setOwnerTestValue(uint val) onlyOwner {\n', '    ownerTestValue = val;\n', '  }\n', '  function isCrowdsale() public constant returns (bool) {\n', '    return true;\n', '  }\n', '  modifier inState(State state) {\n', '    if(getState() != state) throw;\n', '    _;\n', '  }\n', '  function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);\n', '  function isCrowdsaleFull() public constant returns (bool);\n', '  function assignTokens(address receiver, uint tokenAmount) private;\n', '}\n', '\n', '\n', 'contract BonusFinalizeAgent is FinalizeAgent,SafeMathLib {\n', '\n', '  CrowdsaleToken public token;\n', '  Crowdsale public crowdsale;\n', '  uint public totalMembers;\n', '  uint public allocatedBonus;\n', '  mapping (address=>uint) bonusOf;\n', '  address[] public teamAddresses;\n', '\n', '\n', '  function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint[] _bonusBasePoints, address[] _teamAddresses) {\n', '    token = _token;\n', '    crowdsale = _crowdsale;\n', '    if(address(crowdsale) == 0) {\n', '      throw;\n', '    }\n', '    if(_bonusBasePoints.length != _teamAddresses.length){\n', '      throw;\n', '    }\n', '\n', '    totalMembers = _teamAddresses.length;\n', '    teamAddresses = _teamAddresses;\n', '    for (uint i=0;i<totalMembers;i++){\n', '      if(_bonusBasePoints[i] == 0) throw;\n', '    }\n', '    for (uint j=0;j<totalMembers;j++){\n', '      if(_teamAddresses[j] == 0) throw;\n', '      bonusOf[_teamAddresses[j]] = _bonusBasePoints[j];\n', '    }\n', '  }\n', '  function isSane() public constant returns (bool) {\n', '    return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));\n', '  }\n', '  function finalizeCrowdsale() {\n', '    if(msg.sender != address(crowdsale)) {\n', '      throw;\n', '    }\n', '    uint tokensSold = crowdsale.tokensSold();\n', '\n', '    for (uint i=0;i<totalMembers;i++){\n', '      allocatedBonus = safeMul(tokensSold,bonusOf[teamAddresses[i]]) / 10000;\n', '      token.mint(teamAddresses[i], allocatedBonus);\n', '    }\n', '    token.releaseTokenTransfer();\n', '  }\n', '\n', '}']