['pragma solidity ^0.4.11;\n', '\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address _to, uint _value) returns (bool success);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '  function approve(address _spender, uint _value) returns (bool success);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract FractionalERC20 is ERC20 {\n', '\n', '  uint public decimals;\n', '\n', '}\n', '\n', 'contract FinalizeAgent {\n', '\n', '  function isFinalizeAgent() public constant returns(bool) {\n', '    return true;\n', '  }\n', '\n', '\n', '  function isSane() public constant returns (bool);\n', '\n', '  function finalizeCrowdsale();\n', '\n', '}\n', '\n', 'contract PricingStrategy {\n', '\n', '  function isPricingStrategy() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  \n', '  function isSane(address crowdsale) public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', ' \n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);\n', '}\n', '\n', '\n', 'contract SafeMathLib {\n', '\n', '  function safeMul(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) private {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    if (halted) throw;\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    if (!halted) throw;\n', '    _;\n', '  }\n', '\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', 'contract Crowdsale is Haltable, SafeMathLib {\n', '\n', ' \n', '  FractionalERC20 public token;\n', '\n', '  PricingStrategy public pricingStrategy;\n', '\n', '  FinalizeAgent public finalizeAgent;\n', '\n', '  address public multisigWallet;\n', '\n', '  uint public minimumFundingGoal;\n', '\n', '  uint public startsAt;\n', '\n', '  uint public endsAt;\n', '\n', '  uint public tokensSold = 0;\n', '\n', '  uint public weiRaised = 0;\n', '\n', '  uint public investorCount = 0;\n', '  uint public loadedRefund = 0;\n', '  uint public weiRefunded = 0;\n', '  bool public finalized;\n', '  bool public requireCustomerId;\n', '  bool public requiredSignedAddress;\n', '  address public signerAddress;\n', '  mapping (address => uint256) public investedAmountOf;\n', '  mapping (address => uint256) public tokenAmountOf;\n', '  mapping (address => bool) public earlyParticipantWhitelist;\n', '  uint public ownerTestValue;\n', '  enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}\n', '  event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);\n', '  event Refund(address investor, uint weiAmount);\n', '  event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);\n', '  event Whitelisted(address addr, bool status);\n', '  event EndsAtChanged(uint endsAt);\n', '\n', '  function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {\n', '\n', '    owner = msg.sender;\n', '\n', '    token = FractionalERC20(_token);\n', '\n', '    setPricingStrategy(_pricingStrategy);\n', '\n', '    multisigWallet = _multisigWallet;\n', '    if(multisigWallet == 0) {\n', '        throw;\n', '    }\n', '\n', '    if(_start == 0) {\n', '        throw;\n', '    }\n', '\n', '    startsAt = _start;\n', '\n', '    if(_end == 0) {\n', '        throw;\n', '    }\n', '\n', '    endsAt = _end;\n', '    if(startsAt >= endsAt) {\n', '        throw;\n', '    }\n', '    minimumFundingGoal = _minimumFundingGoal;\n', '  }\n', '  function() payable {\n', '    throw;\n', '  }\n', '  function investInternal(address receiver, uint128 customerId) stopInEmergency private {\n', '    if(getState() == State.PreFunding) {\n', '      if(!earlyParticipantWhitelist[receiver]) {\n', '        throw;\n', '      }\n', '    } else if(getState() == State.Funding) {\n', '    } else {\n', '      throw;\n', '    }\n', '\n', '    uint weiAmount = msg.value;\n', '    uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());\n', '\n', '    if(tokenAmount == 0) {\n', '      throw;\n', '    }\n', '\n', '    if(investedAmountOf[receiver] == 0) {\n', '       investorCount++;\n', '    }\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);\n', '    tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);\n', '    weiRaised = safeAdd(weiRaised,weiAmount);\n', '    tokensSold = safeAdd(tokensSold,tokenAmount);\n', '    if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {\n', '      throw;\n', '    }\n', '\n', '    assignTokens(receiver, tokenAmount);\n', '    if(!multisigWallet.send(weiAmount)) throw;\n', '    Invested(receiver, weiAmount, tokenAmount, customerId);\n', '  }\n', '  function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {\n', '\n', '    uint tokenAmount = fullTokens * 10**token.decimals();\n', '    uint weiAmount = weiPrice * fullTokens;\n', '\n', '    weiRaised = safeAdd(weiRaised,weiAmount);\n', '    tokensSold = safeAdd(tokensSold,tokenAmount);\n', '\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);\n', '    tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);\n', '\n', '    assignTokens(receiver, tokenAmount);\n', '    Invested(receiver, weiAmount, tokenAmount, 0);\n', '  }\n', '  function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '     bytes32 hash = sha256(addr);\n', '     if (ecrecover(hash, v, r, s) != signerAddress) throw;\n', '     if(customerId == 0) throw;\n', '     investInternal(addr, customerId);\n', '  }\n', '  function investWithCustomerId(address addr, uint128 customerId) public payable {\n', '    if(requiredSignedAddress) throw;\n', '    if(customerId == 0) throw;\n', '    investInternal(addr, customerId);\n', '  }\n', '  function invest(address addr) public payable {\n', '    if(requireCustomerId) throw;\n', '    if(requiredSignedAddress) throw;\n', '    investInternal(addr, 0);\n', '  }\n', '  function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '    investWithSignedAddress(msg.sender, customerId, v, r, s);\n', '  }\n', '  function buyWithCustomerId(uint128 customerId) public payable {\n', '    investWithCustomerId(msg.sender, customerId);\n', '  }\n', '  function buy() public payable {\n', '    invest(msg.sender);\n', '  }\n', '  function finalize() public inState(State.Success) onlyOwner stopInEmergency {\n', '    if(finalized) {\n', '      throw;\n', '    }\n', '    if(address(finalizeAgent) != 0) {\n', '      finalizeAgent.finalizeCrowdsale();\n', '    }\n', '\n', '    finalized = true;\n', '  }\n', '  function setFinalizeAgent(FinalizeAgent addr) onlyOwner {\n', '    finalizeAgent = addr;\n', '    if(!finalizeAgent.isFinalizeAgent()) {\n', '      throw;\n', '    }\n', '  }\n', '  function setRequireCustomerId(bool value) onlyOwner {\n', '    requireCustomerId = value;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {\n', '    requiredSignedAddress = value;\n', '    signerAddress = _signerAddress;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {\n', '    earlyParticipantWhitelist[addr] = status;\n', '    Whitelisted(addr, status);\n', '  }\n', '  function setEndsAt(uint time) onlyOwner {\n', '\n', '    if(now > time) {\n', '      throw;\n', '    }\n', '\n', '    endsAt = time;\n', '    EndsAtChanged(endsAt);\n', '  }\n', '  function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {\n', '    pricingStrategy = _pricingStrategy;\n', '    if(!pricingStrategy.isPricingStrategy()) {\n', '      throw;\n', '    }\n', '  }\n', '  function loadRefund() public payable inState(State.Failure) {\n', '    if(msg.value == 0) throw;\n', '    loadedRefund = safeAdd(loadedRefund,msg.value);\n', '  }\n', '  function refund() public inState(State.Refunding) {\n', '    uint256 weiValue = investedAmountOf[msg.sender];\n', '    if (weiValue == 0) throw;\n', '    investedAmountOf[msg.sender] = 0;\n', '    weiRefunded = safeAdd(weiRefunded,weiValue);\n', '    Refund(msg.sender, weiValue);\n', '    if (!msg.sender.send(weiValue)) throw;\n', '  }\n', '  function isMinimumGoalReached() public constant returns (bool reached) {\n', '    return weiRaised >= minimumFundingGoal;\n', '  }\n', '  function isFinalizerSane() public constant returns (bool sane) {\n', '    return finalizeAgent.isSane();\n', '  }\n', '  function isPricingSane() public constant returns (bool sane) {\n', '    return pricingStrategy.isSane(address(this));\n', '  }\n', '  function getState() public constant returns (State) {\n', '    if(finalized) return State.Finalized;\n', '    else if (address(finalizeAgent) == 0) return State.Preparing;\n', '    else if (!finalizeAgent.isSane()) return State.Preparing;\n', '    else if (!pricingStrategy.isSane(address(this))) return State.Preparing;\n', '    else if (block.timestamp < startsAt) return State.PreFunding;\n', '    else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;\n', '    else if (isMinimumGoalReached()) return State.Success;\n', '    else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;\n', '    else return State.Failure;\n', '  }\n', '  function setOwnerTestValue(uint val) onlyOwner {\n', '    ownerTestValue = val;\n', '  }\n', '  function isCrowdsale() public constant returns (bool) {\n', '    return true;\n', '  }\n', '  modifier inState(State state) {\n', '    if(getState() != state) throw;\n', '    _;\n', '  }\n', '  function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);\n', '  function isCrowdsaleFull() public constant returns (bool);\n', '  function assignTokens(address receiver, uint tokenAmount) private;\n', '}\n', '\n', '\n', '\n', 'contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {\n', '\n', '  uint public constant MAX_TRANCHES = 10;\n', '  mapping (address => uint) public preicoAddresses;\n', '\n', '  struct Tranche {\n', '      uint amount;\n', '      uint price;\n', '  }\n', '  Tranche[10] public tranches;\n', '  uint public trancheCount;\n', '  function EthTranchePricing(uint[] _tranches) {\n', '    if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {\n', '      throw;\n', '    }\n', '\n', '    trancheCount = _tranches.length / 2;\n', '\n', '    uint highestAmount = 0;\n', '\n', '    for(uint i=0; i<_tranches.length/2; i++) {\n', '      tranches[i].amount = _tranches[i*2];\n', '      tranches[i].price = _tranches[i*2+1];\n', '      if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {\n', '        throw;\n', '      }\n', '\n', '      highestAmount = tranches[i].amount;\n', '    }\n', '    if(tranches[0].amount != 0) {\n', '      throw;\n', '    }\n', '    if(tranches[trancheCount-1].price != 0) {\n', '      throw;\n', '    }\n', '  }\n', '  function setPreicoAddress(address preicoAddress, uint pricePerToken)\n', '    public\n', '    onlyOwner\n', '  {\n', '    preicoAddresses[preicoAddress] = pricePerToken;\n', '  }\n', '  function getTranche(uint n) public constant returns (uint, uint) {\n', '    return (tranches[n].amount, tranches[n].price);\n', '  }\n', '\n', '  function getFirstTranche() private constant returns (Tranche) {\n', '    return tranches[0];\n', '  }\n', '\n', '  function getLastTranche() private constant returns (Tranche) {\n', '    return tranches[trancheCount-1];\n', '  }\n', '\n', '  function getPricingStartsAt() public constant returns (uint) {\n', '    return getFirstTranche().amount;\n', '  }\n', '\n', '  function getPricingEndsAt() public constant returns (uint) {\n', '    return getLastTranche().amount;\n', '  }\n', '\n', '  function isSane(address _crowdsale) public constant returns(bool) {\n', '    return true;\n', '  }\n', '  function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {\n', '    uint i;\n', '\n', '    for(i=0; i < tranches.length; i++) {\n', '      if(weiRaised < tranches[i].amount) {\n', '        return tranches[i-1];\n', '      }\n', '    }\n', '  }\n', '  function getCurrentPrice(uint weiRaised) public constant returns (uint result) {\n', '    return getCurrentTranche(weiRaised).price;\n', '  }\n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {\n', '\n', '    uint multiplier = 10 ** decimals;\n', '    if(preicoAddresses[msgSender] > 0) {\n', '      return safeMul(value,multiplier) / preicoAddresses[msgSender];\n', '    }\n', '\n', '    uint price = getCurrentPrice(weiRaised);\n', '    return safeMul(value,multiplier) / price;\n', '  }\n', '\n', '  function() payable {\n', '    throw;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address _to, uint _value) returns (bool success);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '  function approve(address _spender, uint _value) returns (bool success);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract FractionalERC20 is ERC20 {\n', '\n', '  uint public decimals;\n', '\n', '}\n', '\n', 'contract FinalizeAgent {\n', '\n', '  function isFinalizeAgent() public constant returns(bool) {\n', '    return true;\n', '  }\n', '\n', '\n', '  function isSane() public constant returns (bool);\n', '\n', '  function finalizeCrowdsale();\n', '\n', '}\n', '\n', 'contract PricingStrategy {\n', '\n', '  function isPricingStrategy() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  \n', '  function isSane(address crowdsale) public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', ' \n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);\n', '}\n', '\n', '\n', 'contract SafeMathLib {\n', '\n', '  function safeMul(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) private {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    if (halted) throw;\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    if (!halted) throw;\n', '    _;\n', '  }\n', '\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', 'contract Crowdsale is Haltable, SafeMathLib {\n', '\n', ' \n', '  FractionalERC20 public token;\n', '\n', '  PricingStrategy public pricingStrategy;\n', '\n', '  FinalizeAgent public finalizeAgent;\n', '\n', '  address public multisigWallet;\n', '\n', '  uint public minimumFundingGoal;\n', '\n', '  uint public startsAt;\n', '\n', '  uint public endsAt;\n', '\n', '  uint public tokensSold = 0;\n', '\n', '  uint public weiRaised = 0;\n', '\n', '  uint public investorCount = 0;\n', '  uint public loadedRefund = 0;\n', '  uint public weiRefunded = 0;\n', '  bool public finalized;\n', '  bool public requireCustomerId;\n', '  bool public requiredSignedAddress;\n', '  address public signerAddress;\n', '  mapping (address => uint256) public investedAmountOf;\n', '  mapping (address => uint256) public tokenAmountOf;\n', '  mapping (address => bool) public earlyParticipantWhitelist;\n', '  uint public ownerTestValue;\n', '  enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}\n', '  event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);\n', '  event Refund(address investor, uint weiAmount);\n', '  event InvestmentPolicyChanged(bool requireCustomerId, bool requiredSignedAddress, address signerAddress);\n', '  event Whitelisted(address addr, bool status);\n', '  event EndsAtChanged(uint endsAt);\n', '\n', '  function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) {\n', '\n', '    owner = msg.sender;\n', '\n', '    token = FractionalERC20(_token);\n', '\n', '    setPricingStrategy(_pricingStrategy);\n', '\n', '    multisigWallet = _multisigWallet;\n', '    if(multisigWallet == 0) {\n', '        throw;\n', '    }\n', '\n', '    if(_start == 0) {\n', '        throw;\n', '    }\n', '\n', '    startsAt = _start;\n', '\n', '    if(_end == 0) {\n', '        throw;\n', '    }\n', '\n', '    endsAt = _end;\n', '    if(startsAt >= endsAt) {\n', '        throw;\n', '    }\n', '    minimumFundingGoal = _minimumFundingGoal;\n', '  }\n', '  function() payable {\n', '    throw;\n', '  }\n', '  function investInternal(address receiver, uint128 customerId) stopInEmergency private {\n', '    if(getState() == State.PreFunding) {\n', '      if(!earlyParticipantWhitelist[receiver]) {\n', '        throw;\n', '      }\n', '    } else if(getState() == State.Funding) {\n', '    } else {\n', '      throw;\n', '    }\n', '\n', '    uint weiAmount = msg.value;\n', '    uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());\n', '\n', '    if(tokenAmount == 0) {\n', '      throw;\n', '    }\n', '\n', '    if(investedAmountOf[receiver] == 0) {\n', '       investorCount++;\n', '    }\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);\n', '    tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);\n', '    weiRaised = safeAdd(weiRaised,weiAmount);\n', '    tokensSold = safeAdd(tokensSold,tokenAmount);\n', '    if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {\n', '      throw;\n', '    }\n', '\n', '    assignTokens(receiver, tokenAmount);\n', '    if(!multisigWallet.send(weiAmount)) throw;\n', '    Invested(receiver, weiAmount, tokenAmount, customerId);\n', '  }\n', '  function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {\n', '\n', '    uint tokenAmount = fullTokens * 10**token.decimals();\n', '    uint weiAmount = weiPrice * fullTokens;\n', '\n', '    weiRaised = safeAdd(weiRaised,weiAmount);\n', '    tokensSold = safeAdd(tokensSold,tokenAmount);\n', '\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);\n', '    tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);\n', '\n', '    assignTokens(receiver, tokenAmount);\n', '    Invested(receiver, weiAmount, tokenAmount, 0);\n', '  }\n', '  function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '     bytes32 hash = sha256(addr);\n', '     if (ecrecover(hash, v, r, s) != signerAddress) throw;\n', '     if(customerId == 0) throw;\n', '     investInternal(addr, customerId);\n', '  }\n', '  function investWithCustomerId(address addr, uint128 customerId) public payable {\n', '    if(requiredSignedAddress) throw;\n', '    if(customerId == 0) throw;\n', '    investInternal(addr, customerId);\n', '  }\n', '  function invest(address addr) public payable {\n', '    if(requireCustomerId) throw;\n', '    if(requiredSignedAddress) throw;\n', '    investInternal(addr, 0);\n', '  }\n', '  function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '    investWithSignedAddress(msg.sender, customerId, v, r, s);\n', '  }\n', '  function buyWithCustomerId(uint128 customerId) public payable {\n', '    investWithCustomerId(msg.sender, customerId);\n', '  }\n', '  function buy() public payable {\n', '    invest(msg.sender);\n', '  }\n', '  function finalize() public inState(State.Success) onlyOwner stopInEmergency {\n', '    if(finalized) {\n', '      throw;\n', '    }\n', '    if(address(finalizeAgent) != 0) {\n', '      finalizeAgent.finalizeCrowdsale();\n', '    }\n', '\n', '    finalized = true;\n', '  }\n', '  function setFinalizeAgent(FinalizeAgent addr) onlyOwner {\n', '    finalizeAgent = addr;\n', '    if(!finalizeAgent.isFinalizeAgent()) {\n', '      throw;\n', '    }\n', '  }\n', '  function setRequireCustomerId(bool value) onlyOwner {\n', '    requireCustomerId = value;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {\n', '    requiredSignedAddress = value;\n', '    signerAddress = _signerAddress;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  function setEarlyParicipantWhitelist(address addr, bool status) onlyOwner {\n', '    earlyParticipantWhitelist[addr] = status;\n', '    Whitelisted(addr, status);\n', '  }\n', '  function setEndsAt(uint time) onlyOwner {\n', '\n', '    if(now > time) {\n', '      throw;\n', '    }\n', '\n', '    endsAt = time;\n', '    EndsAtChanged(endsAt);\n', '  }\n', '  function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {\n', '    pricingStrategy = _pricingStrategy;\n', '    if(!pricingStrategy.isPricingStrategy()) {\n', '      throw;\n', '    }\n', '  }\n', '  function loadRefund() public payable inState(State.Failure) {\n', '    if(msg.value == 0) throw;\n', '    loadedRefund = safeAdd(loadedRefund,msg.value);\n', '  }\n', '  function refund() public inState(State.Refunding) {\n', '    uint256 weiValue = investedAmountOf[msg.sender];\n', '    if (weiValue == 0) throw;\n', '    investedAmountOf[msg.sender] = 0;\n', '    weiRefunded = safeAdd(weiRefunded,weiValue);\n', '    Refund(msg.sender, weiValue);\n', '    if (!msg.sender.send(weiValue)) throw;\n', '  }\n', '  function isMinimumGoalReached() public constant returns (bool reached) {\n', '    return weiRaised >= minimumFundingGoal;\n', '  }\n', '  function isFinalizerSane() public constant returns (bool sane) {\n', '    return finalizeAgent.isSane();\n', '  }\n', '  function isPricingSane() public constant returns (bool sane) {\n', '    return pricingStrategy.isSane(address(this));\n', '  }\n', '  function getState() public constant returns (State) {\n', '    if(finalized) return State.Finalized;\n', '    else if (address(finalizeAgent) == 0) return State.Preparing;\n', '    else if (!finalizeAgent.isSane()) return State.Preparing;\n', '    else if (!pricingStrategy.isSane(address(this))) return State.Preparing;\n', '    else if (block.timestamp < startsAt) return State.PreFunding;\n', '    else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;\n', '    else if (isMinimumGoalReached()) return State.Success;\n', '    else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;\n', '    else return State.Failure;\n', '  }\n', '  function setOwnerTestValue(uint val) onlyOwner {\n', '    ownerTestValue = val;\n', '  }\n', '  function isCrowdsale() public constant returns (bool) {\n', '    return true;\n', '  }\n', '  modifier inState(State state) {\n', '    if(getState() != state) throw;\n', '    _;\n', '  }\n', '  function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);\n', '  function isCrowdsaleFull() public constant returns (bool);\n', '  function assignTokens(address receiver, uint tokenAmount) private;\n', '}\n', '\n', '\n', '\n', 'contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {\n', '\n', '  uint public constant MAX_TRANCHES = 10;\n', '  mapping (address => uint) public preicoAddresses;\n', '\n', '  struct Tranche {\n', '      uint amount;\n', '      uint price;\n', '  }\n', '  Tranche[10] public tranches;\n', '  uint public trancheCount;\n', '  function EthTranchePricing(uint[] _tranches) {\n', '    if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {\n', '      throw;\n', '    }\n', '\n', '    trancheCount = _tranches.length / 2;\n', '\n', '    uint highestAmount = 0;\n', '\n', '    for(uint i=0; i<_tranches.length/2; i++) {\n', '      tranches[i].amount = _tranches[i*2];\n', '      tranches[i].price = _tranches[i*2+1];\n', '      if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {\n', '        throw;\n', '      }\n', '\n', '      highestAmount = tranches[i].amount;\n', '    }\n', '    if(tranches[0].amount != 0) {\n', '      throw;\n', '    }\n', '    if(tranches[trancheCount-1].price != 0) {\n', '      throw;\n', '    }\n', '  }\n', '  function setPreicoAddress(address preicoAddress, uint pricePerToken)\n', '    public\n', '    onlyOwner\n', '  {\n', '    preicoAddresses[preicoAddress] = pricePerToken;\n', '  }\n', '  function getTranche(uint n) public constant returns (uint, uint) {\n', '    return (tranches[n].amount, tranches[n].price);\n', '  }\n', '\n', '  function getFirstTranche() private constant returns (Tranche) {\n', '    return tranches[0];\n', '  }\n', '\n', '  function getLastTranche() private constant returns (Tranche) {\n', '    return tranches[trancheCount-1];\n', '  }\n', '\n', '  function getPricingStartsAt() public constant returns (uint) {\n', '    return getFirstTranche().amount;\n', '  }\n', '\n', '  function getPricingEndsAt() public constant returns (uint) {\n', '    return getLastTranche().amount;\n', '  }\n', '\n', '  function isSane(address _crowdsale) public constant returns(bool) {\n', '    return true;\n', '  }\n', '  function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {\n', '    uint i;\n', '\n', '    for(i=0; i < tranches.length; i++) {\n', '      if(weiRaised < tranches[i].amount) {\n', '        return tranches[i-1];\n', '      }\n', '    }\n', '  }\n', '  function getCurrentPrice(uint weiRaised) public constant returns (uint result) {\n', '    return getCurrentTranche(weiRaised).price;\n', '  }\n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {\n', '\n', '    uint multiplier = 10 ** decimals;\n', '    if(preicoAddresses[msgSender] > 0) {\n', '      return safeMul(value,multiplier) / preicoAddresses[msgSender];\n', '    }\n', '\n', '    uint price = getCurrentPrice(weiRaised);\n', '    return safeMul(value,multiplier) / price;\n', '  }\n', '\n', '  function() payable {\n', '    throw;\n', '  }\n', '\n', '}']
