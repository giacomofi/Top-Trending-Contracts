['pragma solidity ^0.4.11;\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/**\n', ' * Safe unsigned safe math.\n', ' *\n', ' * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli\n', ' *\n', ' * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol\n', ' *\n', ' * Maintained here until merged to mainline zeppelin-solidity.\n', ' *\n', ' */\n', 'library SafeMathLibExt {\n', '  function times(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function divides(uint a, uint b) returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function minus(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function plus(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '  modifier stopInEmergency {\n', '    if (halted) throw;\n', '    _;\n', '  }\n', '  modifier stopNonOwnersInEmergency {\n', '    if (halted && msg.sender != owner) throw;\n', '    _;\n', '  }\n', '  modifier onlyInEmergency {\n', '    if (!halted) throw;\n', '    _;\n', '  }\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/**\n', ' * Interface for defining crowdsale pricing.\n', ' */\n', 'contract PricingStrategy {\n', '  /** Interface declaration. */\n', '  function isPricingStrategy() public constant returns (bool) {\n', '    return true;\n', '  }\n', '  /** Self check if all references are correctly set.\n', '   *\n', '   * Checks that pricing strategy matches crowdsale parameters.\n', '   */\n', '  function isSane(address crowdsale) public constant returns (bool) {\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Pricing tells if this is a presale purchase or not.\n', '     @param purchaser Address of the purchaser\n', '     @return False by default, true if a presale purchaser\n', '   */\n', '  function isPresalePurchase(address purchaser) public constant returns (bool) {\n', '    return false;\n', '  }\n', '  /**\n', '   * When somebody tries to buy tokens for X eth, calculate how many tokens they get.\n', '   *\n', '   *\n', '   * @param value - What is the value of the transaction send in as wei\n', '   * @param tokensSold - how much tokens have been sold this far\n', '   * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale\n', '   * @param msgSender - who is the investor of this transaction\n', '   * @param decimals - how many decimal units the token has\n', '   * @return Amount of tokens the investor receives\n', '   */\n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/**\n', ' * Finalize agent defines what happens at the end of succeseful crowdsale.\n', ' *\n', ' * - Allocate tokens for founders, bounties and community\n', ' * - Make tokens transferable\n', ' * - etc.\n', ' */\n', 'contract FinalizeAgent {\n', '  function isFinalizeAgent() public constant returns(bool) {\n', '    return true;\n', '  }\n', '  /** Return true if we can run finalizeCrowdsale() properly.\n', '   *\n', '   * This is a safety check function that doesn&#39;t allow crowdsale to begin\n', '   * unless the finalizer has been set up properly.\n', '   */\n', '  function isSane() public constant returns (bool);\n', '  /** Called once by crowdsale finalize() if the sale was success. */\n', '  function finalizeCrowdsale();\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * A token that defines fractional units as decimals.\n', ' */\n', 'contract FractionalERC20Ext is ERC20 {\n', '  uint public decimals;\n', '  uint public minCap;\n', '}\n', '/**\n', ' * Abstract base contract for token sales.\n', ' *\n', ' * Handle\n', ' * - start and end dates\n', ' * - accepting investments\n', ' * - minimum funding goal and refund\n', ' * - various statistics during the crowdfund\n', ' * - different pricing strategies\n', ' * - different investment policies (require server side customer id, allow only whitelisted addresses)\n', ' *\n', ' */\n', 'contract CrowdsaleExt is Haltable {\n', '  /* Max investment count when we are still allowed to change the multisig address */\n', '  uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;\n', '  using SafeMathLibExt for uint;\n', '  /* The token we are selling */\n', '  FractionalERC20Ext public token;\n', '  /* How we are going to price our offering */\n', '  PricingStrategy public pricingStrategy;\n', '  /* Post-success callback */\n', '  FinalizeAgent public finalizeAgent;\n', '  /* tokens will be transfered from this address */\n', '  address public multisigWallet;\n', '  /* if the funding goal is not reached, investors may withdraw their funds */\n', '  uint public minimumFundingGoal;\n', '  /* the UNIX timestamp start date of the crowdsale */\n', '  uint public startsAt;\n', '  /* the UNIX timestamp end date of the crowdsale */\n', '  uint public endsAt;\n', '  /* the number of tokens already sold through this contract*/\n', '  uint public tokensSold = 0;\n', '  /* How many wei of funding we have raised */\n', '  uint public weiRaised = 0;\n', '  /* Calculate incoming funds from presale contracts and addresses */\n', '  uint public presaleWeiRaised = 0;\n', '  /* How many distinct addresses have invested */\n', '  uint public investorCount = 0;\n', '  /* How much wei we have returned back to the contract after a failed crowdfund. */\n', '  uint public loadedRefund = 0;\n', '  /* How much wei we have given back to investors.*/\n', '  uint public weiRefunded = 0;\n', '  /* Has this crowdsale been finalized */\n', '  bool public finalized;\n', '  /* Do we need to have unique contributor id for each customer */\n', '  bool public requireCustomerId;\n', '  bool public isWhiteListed;\n', '  address[] public joinedCrowdsales;\n', '  uint public joinedCrowdsalesLen = 0;\n', '  address public lastCrowdsale;\n', '  /**\n', '    * Do we verify that contributor has been cleared on the server side (accredited investors only).\n', '    * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).\n', '    */\n', '  bool public requiredSignedAddress;\n', '  /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */\n', '  address public signerAddress;\n', '  /** How much ETH each address has invested to this crowdsale */\n', '  mapping (address => uint256) public investedAmountOf;\n', '  /** How much tokens this crowdsale has credited for each investor address */\n', '  mapping (address => uint256) public tokenAmountOf;\n', '  struct WhiteListData {\n', '    bool status;\n', '    uint minCap;\n', '    uint maxCap;\n', '  }\n', '  //is crowdsale updatable\n', '  bool public isUpdatable;\n', '  /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */\n', '  mapping (address => WhiteListData) public earlyParticipantWhitelist;\n', '  /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */\n', '  uint public ownerTestValue;\n', '  /** State machine\n', '   *\n', '   * - Preparing: All contract initialization calls and variables have not been set yet\n', '   * - Prefunding: We have not passed start time yet\n', '   * - Funding: Active crowdsale\n', '   * - Success: Minimum funding goal reached\n', '   * - Failure: Minimum funding goal not reached before ending time\n', '   * - Finalized: The finalized has been called and succesfully executed\n', '   * - Refunding: Refunds are loaded on the contract for reclaim.\n', '   */\n', '  enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}\n', '  // A new investment was made\n', '  event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);\n', '  // Refund was processed for a contributor\n', '  event Refund(address investor, uint weiAmount);\n', '  // The rules were changed what kind of investments we accept\n', '  event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);\n', '  // Address early participation whitelist status changed\n', '  event Whitelisted(address addr, bool status);\n', '  // Crowdsale start time has been changed\n', '  event StartsAtChanged(uint newStartsAt);\n', '  // Crowdsale end time has been changed\n', '  event EndsAtChanged(uint newEndsAt);\n', '  function CrowdsaleExt(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {\n', '    owner = msg.sender;\n', '    token = FractionalERC20Ext(_token);\n', '    setPricingStrategy(_pricingStrategy);\n', '    multisigWallet = _multisigWallet;\n', '    if(multisigWallet == 0) {\n', '        throw;\n', '    }\n', '    if(_start == 0) {\n', '        throw;\n', '    }\n', '    startsAt = _start;\n', '    if(_end == 0) {\n', '        throw;\n', '    }\n', '    endsAt = _end;\n', '    // Don&#39;t mess the dates\n', '    if(startsAt >= endsAt) {\n', '        throw;\n', '    }\n', '    // Minimum funding goal can be zero\n', '    minimumFundingGoal = _minimumFundingGoal;\n', '    isUpdatable = _isUpdatable;\n', '    isWhiteListed = _isWhiteListed;\n', '  }\n', '  /**\n', '   * Don&#39;t expect to just send in money and get tokens.\n', '   */\n', '  function() payable {\n', '    throw;\n', '  }\n', '  /**\n', '   * Make an investment.\n', '   *\n', '   * Crowdsale must be running for one to invest.\n', '   * We must have not pressed the emergency brake.\n', '   *\n', '   * @param receiver The Ethereum address who receives the tokens\n', '   * @param customerId (optional) UUID v4 to track the successful payments on the server side\n', '   *\n', '   */\n', '  function investInternal(address receiver, uint128 customerId) stopInEmergency private {\n', '    // Determine if it&#39;s a good time to accept investment from this participant\n', '    if(getState() == State.PreFunding) {\n', '      // Are we whitelisted for early deposit\n', '      throw;\n', '    } else if(getState() == State.Funding) {\n', '      // Retail participants can only come in when the crowdsale is running\n', '      // pass\n', '      if(isWhiteListed) {\n', '        if(!earlyParticipantWhitelist[receiver].status) {\n', '          throw;\n', '        }\n', '      }\n', '    } else {\n', '      // Unwanted state\n', '      throw;\n', '    }\n', '    uint weiAmount = msg.value;\n', '    // Account presale sales separately, so that they do not count against pricing tranches\n', '    uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());\n', '    if(tokenAmount == 0) {\n', '      // Dust transaction\n', '      throw;\n', '    }\n', '    if(isWhiteListed) {\n', '      if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {\n', '        // tokenAmount < minCap for investor\n', '        throw;\n', '      }\n', '      if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {\n', '        // tokenAmount > maxCap for investor\n', '        throw;\n', '      }\n', '      // Check that we did not bust the investor&#39;s cap\n', '      if (isBreakingInvestorCap(receiver, tokenAmount)) {\n', '        throw;\n', '      }\n', '    } else {\n', '      if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {\n', '        throw;\n', '      }\n', '    }\n', '    // Check that we did not bust the cap\n', '    if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {\n', '      throw;\n', '    }\n', '    // Update investor\n', '    investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);\n', '    tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);\n', '    // Update totals\n', '    weiRaised = weiRaised.plus(weiAmount);\n', '    tokensSold = tokensSold.plus(tokenAmount);\n', '    if(pricingStrategy.isPresalePurchase(receiver)) {\n', '        presaleWeiRaised = presaleWeiRaised.plus(weiAmount);\n', '    }\n', '    if(investedAmountOf[receiver] == 0) {\n', '       // A new investor\n', '       investorCount++;\n', '    }\n', '    assignTokens(receiver, tokenAmount);\n', '    // Pocket the money\n', '    if(!multisigWallet.send(weiAmount)) throw;\n', '    if (isWhiteListed) {\n', '      uint num = 0;\n', '      for (var i = 0; i < joinedCrowdsalesLen; i++) {\n', '        if (this == joinedCrowdsales[i]) \n', '          num = i;\n', '      }\n', '      if (num + 1 < joinedCrowdsalesLen) {\n', '        for (var j = num + 1; j < joinedCrowdsalesLen; j++) {\n', '          CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);\n', '          crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);\n', '        }\n', '      }\n', '    }\n', '    // Tell us invest was success\n', '    Invested(receiver, weiAmount, tokenAmount, customerId);\n', '  }\n', '  /**\n', '   * Preallocate tokens for the early investors.\n', '   *\n', '   * Preallocated tokens have been sold before the actual crowdsale opens.\n', '   * This function mints the tokens and moves the crowdsale needle.\n', '   *\n', '   * Investor count is not handled; it is assumed this goes for multiple investors\n', '   * and the token distribution happens outside the smart contract flow.\n', '   *\n', '   * No money is exchanged, as the crowdsale team already have received the payment.\n', '   *\n', '   * @param fullTokens tokens as full tokens - decimal places added internally\n', '   * @param weiPrice Price of a single full token in wei\n', '   *\n', '   */\n', '  function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {\n', '    uint tokenAmount = fullTokens * 10**token.decimals();\n', '    uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free\n', '    weiRaised = weiRaised.plus(weiAmount);\n', '    tokensSold = tokensSold.plus(tokenAmount);\n', '    investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);\n', '    tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);\n', '    assignTokens(receiver, tokenAmount);\n', '    // Tell us invest was success\n', '    Invested(receiver, weiAmount, tokenAmount, 0);\n', '  }\n', '  /**\n', '   * Allow anonymous contributions to this crowdsale.\n', '   */\n', '  function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '     bytes32 hash = sha256(addr);\n', '     if (ecrecover(hash, v, r, s) != signerAddress) throw;\n', '     if(customerId == 0) throw;  // UUIDv4 sanity check\n', '     investInternal(addr, customerId);\n', '  }\n', '  /**\n', '   * Track who is the customer making the payment so we can send thank you email.\n', '   */\n', '  function investWithCustomerId(address addr, uint128 customerId) public payable {\n', '    if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants\n', '    if(customerId == 0) throw;  // UUIDv4 sanity check\n', '    investInternal(addr, customerId);\n', '  }\n', '  /**\n', '   * Allow anonymous contributions to this crowdsale.\n', '   */\n', '  function invest(address addr) public payable {\n', '    if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email\n', '    if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants\n', '    investInternal(addr, 0);\n', '  }\n', '  /**\n', '   * Invest to tokens, recognize the payer and clear his address.\n', '   *\n', '   */\n', '  function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {\n', '    investWithSignedAddress(msg.sender, customerId, v, r, s);\n', '  }\n', '  /**\n', '   * Invest to tokens, recognize the payer.\n', '   *\n', '   */\n', '  function buyWithCustomerId(uint128 customerId) public payable {\n', '    investWithCustomerId(msg.sender, customerId);\n', '  }\n', '  /**\n', '   * The basic entry point to participate the crowdsale process.\n', '   *\n', '   * Pay for funding, get invested tokens back in the sender address.\n', '   */\n', '  function buy() public payable {\n', '    invest(msg.sender);\n', '  }\n', '  /**\n', '   * Finalize a succcesful crowdsale.\n', '   *\n', '   * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.\n', '   */\n', '  function finalize() public inState(State.Success) onlyOwner stopInEmergency {\n', '    // Already finalized\n', '    if(finalized) {\n', '      throw;\n', '    }\n', '    // Finalizing is optional. We only call it if we are given a finalizing agent.\n', '    if(address(finalizeAgent) != 0) {\n', '      finalizeAgent.finalizeCrowdsale();\n', '    }\n', '    finalized = true;\n', '  }\n', '  /**\n', '   * Allow to (re)set finalize agent.\n', '   *\n', '   * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.\n', '   */\n', '  function setFinalizeAgent(FinalizeAgent addr) onlyOwner {\n', '    finalizeAgent = addr;\n', '    // Don&#39;t allow setting bad agent\n', '    if(!finalizeAgent.isFinalizeAgent()) {\n', '      throw;\n', '    }\n', '  }\n', '  /**\n', '   * Set policy do we need to have server-side customer ids for the investments.\n', '   *\n', '   */\n', '  function setRequireCustomerId(bool value) onlyOwner {\n', '    requireCustomerId = value;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  /**\n', '   * Set policy if all investors must be cleared on the server side first.\n', '   *\n', '   * This is e.g. for the accredited investor clearing.\n', '   *\n', '   */\n', '  function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {\n', '    requiredSignedAddress = value;\n', '    signerAddress = _signerAddress;\n', '    InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);\n', '  }\n', '  /**\n', '   * Allow addresses to do early participation.\n', '   *\n', '   * TODO: Fix spelling error in the name\n', '   */\n', '  function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {\n', '    if (!isWhiteListed) throw;\n', '    earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});\n', '    Whitelisted(addr, status);\n', '  }\n', '  function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {\n', '    if (!isWhiteListed) throw;\n', '    for (uint iterator = 0; iterator < addrs.length; iterator++) {\n', '      setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);\n', '    }\n', '  }\n', '  function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {\n', '    if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;\n', '    if (!isWhiteListed) throw;\n', '    if (addr != msg.sender && contractAddr != msg.sender) throw;\n', '    uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;\n', '    newMaxCap = newMaxCap.minus(tokensBought);\n', '    earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});\n', '  }\n', '  function updateJoinedCrowdsales(address addr) onlyOwner {\n', '    joinedCrowdsales[joinedCrowdsalesLen++] = addr;\n', '  }\n', '  function setLastCrowdsale(address addr) onlyOwner {\n', '    lastCrowdsale = addr;\n', '  }\n', '  function clearJoinedCrowdsales() onlyOwner {\n', '    joinedCrowdsalesLen = 0;\n', '  }\n', '  function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {\n', '    clearJoinedCrowdsales();\n', '    for (uint iter = 0; iter < addrs.length; iter++) {\n', '      if(joinedCrowdsalesLen == joinedCrowdsales.length) {\n', '          joinedCrowdsales.length += 1;\n', '      }\n', '      joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];\n', '      if (iter == addrs.length - 1)\n', '        setLastCrowdsale(addrs[iter]);\n', '    }\n', '  }\n', '  function setStartsAt(uint time) onlyOwner {\n', '    if (finalized) throw;\n', '    if (!isUpdatable) throw;\n', '    if(now > time) {\n', '      throw; // Don&#39;t change past\n', '    }\n', '    if(time > endsAt) {\n', '      throw;\n', '    }\n', '    CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);\n', '    if (lastCrowdsaleCntrct.finalized()) throw;\n', '    startsAt = time;\n', '    StartsAtChanged(startsAt);\n', '  }\n', '  /**\n', '   * Allow crowdsale owner to close early or extend the crowdsale.\n', '   *\n', '   * This is useful e.g. for a manual soft cap implementation:\n', '   * - after X amount is reached determine manual closing\n', '   *\n', '   * This may put the crowdsale to an invalid state,\n', '   * but we trust owners know what they are doing.\n', '   *\n', '   */\n', '  function setEndsAt(uint time) onlyOwner {\n', '    if (finalized) throw;\n', '    if (!isUpdatable) throw;\n', '    if(now > time) {\n', '      throw; // Don&#39;t change past\n', '    }\n', '    if(startsAt > time) {\n', '      throw;\n', '    }\n', '    CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);\n', '    if (lastCrowdsaleCntrct.finalized()) throw;\n', '    uint num = 0;\n', '    for (var i = 0; i < joinedCrowdsalesLen; i++) {\n', '      if (this == joinedCrowdsales[i]) \n', '        num = i;\n', '    }\n', '    if (num + 1 < joinedCrowdsalesLen) {\n', '      for (var j = num + 1; j < joinedCrowdsalesLen; j++) {\n', '        CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);\n', '        if (time > crowdsale.startsAt()) throw;\n', '      }\n', '    }\n', '    endsAt = time;\n', '    EndsAtChanged(endsAt);\n', '  }\n', '  /**\n', '   * Allow to (re)set pricing strategy.\n', '   *\n', '   * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.\n', '   */\n', '  function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {\n', '    pricingStrategy = _pricingStrategy;\n', '    // Don&#39;t allow setting bad agent\n', '    if(!pricingStrategy.isPricingStrategy()) {\n', '      throw;\n', '    }\n', '  }\n', '  /**\n', '   * Allow to change the team multisig address in the case of emergency.\n', '   *\n', '   * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun\n', '   * (we have done only few test transactions). After the crowdsale is going\n', '   * then multisig address stays locked for the safety reasons.\n', '   */\n', '  function setMultisig(address addr) public onlyOwner {\n', '    // Change\n', '    if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {\n', '      throw;\n', '    }\n', '    multisigWallet = addr;\n', '  }\n', '  /**\n', '   * Allow load refunds back on the contract for the refunding.\n', '   *\n', '   * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..\n', '   */\n', '  function loadRefund() public payable inState(State.Failure) {\n', '    if(msg.value == 0) throw;\n', '    loadedRefund = loadedRefund.plus(msg.value);\n', '  }\n', '  /**\n', '   * Investors can claim refund.\n', '   *\n', '   * Note that any refunds from proxy buyers should be handled separately,\n', '   * and not through this contract.\n', '   */\n', '  function refund() public inState(State.Refunding) {\n', '    uint256 weiValue = investedAmountOf[msg.sender];\n', '    if (weiValue == 0) throw;\n', '    investedAmountOf[msg.sender] = 0;\n', '    weiRefunded = weiRefunded.plus(weiValue);\n', '    Refund(msg.sender, weiValue);\n', '    if (!msg.sender.send(weiValue)) throw;\n', '  }\n', '  /**\n', '   * @return true if the crowdsale has raised enough money to be a successful.\n', '   */\n', '  function isMinimumGoalReached() public constant returns (bool reached) {\n', '    return weiRaised >= minimumFundingGoal;\n', '  }\n', '  /**\n', '   * Check if the contract relationship looks good.\n', '   */\n', '  function isFinalizerSane() public constant returns (bool sane) {\n', '    return finalizeAgent.isSane();\n', '  }\n', '  /**\n', '   * Check if the contract relationship looks good.\n', '   */\n', '  function isPricingSane() public constant returns (bool sane) {\n', '    return pricingStrategy.isSane(address(this));\n', '  }\n', '  /**\n', '   * Crowdfund state machine management.\n', '   *\n', '   * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.\n', '   */\n', '  function getState() public constant returns (State) {\n', '    if(finalized) return State.Finalized;\n', '    else if (address(finalizeAgent) == 0) return State.Preparing;\n', '    else if (!finalizeAgent.isSane()) return State.Preparing;\n', '    else if (!pricingStrategy.isSane(address(this))) return State.Preparing;\n', '    else if (block.timestamp < startsAt) return State.PreFunding;\n', '    else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;\n', '    else if (isMinimumGoalReached()) return State.Success;\n', '    else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;\n', '    else return State.Failure;\n', '  }\n', '  /** This is for manual testing of multisig wallet interaction */\n', '  function setOwnerTestValue(uint val) onlyOwner {\n', '    ownerTestValue = val;\n', '  }\n', '  /** Interface marker. */\n', '  function isCrowdsale() public constant returns (bool) {\n', '    return true;\n', '  }\n', '  //\n', '  // Modifiers\n', '  //\n', '  /** Modified allowing execution only if the crowdsale is currently running.  */\n', '  modifier inState(State state) {\n', '    if(getState() != state) throw;\n', '    _;\n', '  }\n', '  //\n', '  // Abstract functions\n', '  //\n', '  /**\n', '   * Check if the current invested breaks our cap rules.\n', '   *\n', '   *\n', '   * The child contract must define their own cap setting rules.\n', '   * We allow a lot of flexibility through different capping strategies (ETH, token count)\n', '   * Called from invest().\n', '   *\n', '   * @param weiAmount The amount of wei the investor tries to invest in the current transaction\n', '   * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction\n', '   * @param weiRaisedTotal What would be our total raised balance after this transaction\n', '   * @param tokensSoldTotal What would be our total sold tokens count after this transaction\n', '   *\n', '   * @return true if taking this investment would break our cap rules\n', '   */\n', '  function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);\n', '  function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);\n', '  /**\n', '   * Check if the current crowdsale is full and we can no longer sell any tokens.\n', '   */\n', '  function isCrowdsaleFull() public constant returns (bool);\n', '  /**\n', '   * Create new tokens or transfer issued tokens to the investor depending on the cap model.\n', '   */\n', '  function assignTokens(address receiver, uint tokenAmount) private;\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' */\n', 'contract ReleasableToken is ERC20, Ownable {\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '    if(!released) {\n', '        if(!transferAgents[_sender]) {\n', '            throw;\n', '        }\n', '    }\n', '    _;\n', '  }\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   *\n', '   * Design choice. Allow reset the release agent to fix fat finger mistakes.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '    // We don&#39;t do interface check here as we might want to a normal wallet address to act as a release agent\n', '    releaseAgent = addr;\n', '  }\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    if(releaseState != released) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    if(msg.sender != releaseAgent) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '}\n', '/**\n', ' * A finalize agent that does nothing.\n', ' *\n', ' * - Token transfer must be manually released by the owner\n', ' */\n', 'contract NullFinalizeAgentExt is FinalizeAgent {\n', '  CrowdsaleExt public crowdsale;\n', '  function NullFinalizeAgentExt(CrowdsaleExt _crowdsale) {\n', '    crowdsale = _crowdsale;\n', '  }\n', '  /** Check that we can release the token */\n', '  function isSane() public constant returns (bool) {\n', '    return true;\n', '  }\n', '  /** Called once by crowdsale finalize() if the sale was success. */\n', '  function finalizeCrowdsale() public {\n', '  }\n', '}']