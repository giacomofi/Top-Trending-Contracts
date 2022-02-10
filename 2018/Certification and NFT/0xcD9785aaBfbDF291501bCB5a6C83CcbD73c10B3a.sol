['// MeNet.IO \n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * Safe unsigned safe math.\n', ' *\n', ' * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli\n', ' *\n', ' * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol\n', ' *\n', ' * Maintained here until merged to mainline zeppelin-solidity.\n', ' *\n', ' */\n', 'library SafeMathLibExt {\n', '\n', '  function times(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function divides(uint a, uint b) returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function minus(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function plus(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    if (halted) throw;\n', '    _;\n', '  }\n', '\n', '  modifier stopNonOwnersInEmergency {\n', '    if (halted && msg.sender != owner) throw;\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    if (!halted) throw;\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * Interface for defining crowdsale pricing.\n', ' */\n', 'contract PricingStrategy {\n', '\n', '  address public tier;\n', '\n', '  /** Interface declaration. */\n', '  function isPricingStrategy() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /** Self check if all references are correctly set.\n', '   *\n', '   * Checks that pricing strategy matches crowdsale parameters.\n', '   */\n', '  function isSane(address crowdsale) public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Pricing tells if this is a presale purchase or not.\n', '     @param purchaser Address of the purchaser\n', '     @return False by default, true if a presale purchaser\n', '   */\n', '  function isPresalePurchase(address purchaser) public constant returns (bool) {\n', '    return false;\n', '  }\n', '\n', '  /* How many weis one token costs */\n', '  function updateRate(uint newOneTokenInWei) public;\n', '\n', '  /**\n', '   * When somebody tries to buy tokens for X eth, calculate how many tokens they get.\n', '   *\n', '   *\n', '   * @param value - What is the value of the transaction send in as wei\n', '   * @param tokensSold - how much tokens have been sold this far\n', '   * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale\n', '   * @param msgSender - who is the investor of this transaction\n', '   * @param decimals - how many decimal units the token has\n', '   * @return Amount of tokens the investor receives\n', '   */\n', '  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * Finalize agent defines what happens at the end of succeseful crowdsale.\n', ' *\n', ' * - Allocate tokens for founders, bounties and community\n', ' * - Make tokens transferable\n', ' * - etc.\n', ' */\n', 'contract FinalizeAgent {\n', '\n', '  bool public reservedTokensAreDistributed = false;\n', '\n', '  function isFinalizeAgent() public constant returns(bool) {\n', '    return true;\n', '  }\n', '\n', '  /** Return true if we can run finalizeCrowdsale() properly.\n', '   *\n', '   * This is a safety check function that doesn&#39;t allow crowdsale to begin\n', '   * unless the finalizer has been set up properly.\n', '   */\n', '  function isSane() public constant returns (bool);\n', '\n', '  function distributeReservedTokens(uint reservedTokensDistributionBatch);\n', '\n', '  /** Called once by crowdsale finalize() if the sale was success. */\n', '  function finalizeCrowdsale();\n', '\n', '}\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * A token that defines fractional units as decimals.\n', ' */\n', 'contract FractionalERC20Ext is ERC20 {\n', '\n', '  uint public decimals;\n', '  uint public minCap;\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Abstract base contract for token sales.\n', ' *\n', ' * Handle\n', ' * - start and end dates\n', ' * - accepting investments\n', ' * - minimum funding goal and refund\n', ' * - various statistics during the crowdfund\n', ' * - different pricing strategies\n', ' * - different investment policies (require server side customer id, allow only whitelisted addresses)\n', ' *\n', ' */\n', 'contract CrowdsaleExt is Haltable {\n', '\n', '  /* Max investment count when we are still allowed to change the multisig address */\n', '  uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;\n', '\n', '  using SafeMathLibExt for uint;\n', '\n', '  /* The token we are selling */\n', '  FractionalERC20Ext public token;\n', '\n', '  /* How we are going to price our offering */\n', '  PricingStrategy public pricingStrategy;\n', '\n', '  /* Post-success callback */\n', '  FinalizeAgent public finalizeAgent;\n', '\n', '  /* name of the crowdsale tier */\n', '  string public name;\n', '\n', '  /* tokens will be transfered from this address */\n', '  address public multisigWallet;\n', '\n', '  /* if the funding goal is not reached, investors may withdraw their funds */\n', '  uint public minimumFundingGoal;\n', '\n', '  /* the UNIX timestamp start date of the crowdsale */\n', '  uint public startsAt;\n', '\n', '  /* the UNIX timestamp end date of the crowdsale */\n', '  uint public endsAt;\n', '\n', '  /* the number of tokens already sold through this contract*/\n', '  uint public tokensSold = 0;\n', '\n', '  /* How many wei of funding we have raised */\n', '  uint public weiRaised = 0;\n', '\n', '  /* How many distinct addresses have invested */\n', '  uint public investorCount = 0;\n', '\n', '  /* Has this crowdsale been finalized */\n', '  bool public finalized;\n', '\n', '  bool public isWhiteListed;\n', '\n', '  address[] public joinedCrowdsales;\n', '  uint8 public joinedCrowdsalesLen = 0;\n', '  uint8 public joinedCrowdsalesLenMax = 50;\n', '  struct JoinedCrowdsaleStatus {\n', '    bool isJoined;\n', '    uint8 position;\n', '  }\n', '  mapping (address => JoinedCrowdsaleStatus) joinedCrowdsaleState;\n', '\n', '  /** How much ETH each address has invested to this crowdsale */\n', '  mapping (address => uint256) public investedAmountOf;\n', '\n', '  /** How much tokens this crowdsale has credited for each investor address */\n', '  mapping (address => uint256) public tokenAmountOf;\n', '\n', '  struct WhiteListData {\n', '    bool status;\n', '    uint minCap;\n', '    uint maxCap;\n', '  }\n', '\n', '  //is crowdsale updatable\n', '  bool public isUpdatable;\n', '\n', '  /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */\n', '  mapping (address => WhiteListData) public earlyParticipantWhitelist;\n', '\n', '  /** List of whitelisted addresses */\n', '  address[] public whitelistedParticipants;\n', '\n', '  /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */\n', '  uint public ownerTestValue;\n', '\n', '  /** State machine\n', '   *\n', '   * - Preparing: All contract initialization calls and variables have not been set yet\n', '   * - Prefunding: We have not passed start time yet\n', '   * - Funding: Active crowdsale\n', '   * - Success: Minimum funding goal reached\n', '   * - Failure: Minimum funding goal not reached before ending time\n', '   * - Finalized: The finalized has been called and succesfully executed\n', '   */\n', '  enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized}\n', '\n', '  // A new investment was made\n', '  event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);\n', '\n', '  // Address early participation whitelist status changed\n', '  event Whitelisted(address addr, bool status, uint minCap, uint maxCap);\n', '  event WhitelistItemChanged(address addr, bool status, uint minCap, uint maxCap);\n', '\n', '  // Crowdsale start time has been changed\n', '  event StartsAtChanged(uint newStartsAt);\n', '\n', '  // Crowdsale end time has been changed\n', '  event EndsAtChanged(uint newEndsAt);\n', '\n', '  function CrowdsaleExt(string _name, address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {\n', '\n', '    owner = msg.sender;\n', '\n', '    name = _name;\n', '\n', '    token = FractionalERC20Ext(_token);\n', '\n', '    setPricingStrategy(_pricingStrategy);\n', '\n', '    multisigWallet = _multisigWallet;\n', '    if(multisigWallet == 0) {\n', '        throw;\n', '    }\n', '\n', '    if(_start == 0) {\n', '        throw;\n', '    }\n', '\n', '    startsAt = _start;\n', '\n', '    if(_end == 0) {\n', '        throw;\n', '    }\n', '\n', '    endsAt = _end;\n', '\n', '    // Don&#39;t mess the dates\n', '    if(startsAt >= endsAt) {\n', '        throw;\n', '    }\n', '\n', '    // Minimum funding goal can be zero\n', '    minimumFundingGoal = _minimumFundingGoal;\n', '\n', '    isUpdatable = _isUpdatable;\n', '\n', '    isWhiteListed = _isWhiteListed;\n', '  }\n', '\n', '  /**\n', '   * Don&#39;t expect to just send in money and get tokens.\n', '   */\n', '  function() payable {\n', '    throw;\n', '  }\n', '\n', '  /**\n', '   * Make an investment.\n', '   *\n', '   * Crowdsale must be running for one to invest.\n', '   * We must have not pressed the emergency brake.\n', '   *\n', '   * @param receiver The Ethereum address who receives the tokens\n', '   * @param customerId (optional) UUID v4 to track the successful payments on the server side\n', '   *\n', '   */\n', '  function investInternal(address receiver, uint128 customerId) stopInEmergency private {\n', '\n', '    // Determine if it&#39;s a good time to accept investment from this participant\n', '    if(getState() == State.PreFunding) {\n', '      // Are we whitelisted for early deposit\n', '      throw;\n', '    } else if(getState() == State.Funding) {\n', '      // Retail participants can only come in when the crowdsale is running\n', '      // pass\n', '      if(isWhiteListed) {\n', '        if(!earlyParticipantWhitelist[receiver].status) {\n', '          throw;\n', '        }\n', '      }\n', '    } else {\n', '      // Unwanted state\n', '      throw;\n', '    }\n', '\n', '    uint weiAmount = msg.value;\n', '\n', '    // Account presale sales separately, so that they do not count against pricing tranches\n', '    uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());\n', '\n', '    if(tokenAmount == 0) {\n', '      // Dust transaction\n', '      throw;\n', '    }\n', '\n', '    if(isWhiteListed) {\n', '      if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {\n', '        // tokenAmount < minCap for investor\n', '        throw;\n', '      }\n', '\n', '      // Check that we did not bust the investor&#39;s cap\n', '      if (isBreakingInvestorCap(receiver, tokenAmount)) {\n', '        throw;\n', '      }\n', '\n', '      updateInheritedEarlyParticipantWhitelist(receiver, tokenAmount);\n', '    } else {\n', '      if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {\n', '        throw;\n', '      }\n', '    }\n', '\n', '    if(investedAmountOf[receiver] == 0) {\n', '       // A new investor\n', '       investorCount++;\n', '    }\n', '\n', '    // Update investor\n', '    investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);\n', '    tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);\n', '\n', '    // Update totals\n', '    weiRaised = weiRaised.plus(weiAmount);\n', '    tokensSold = tokensSold.plus(tokenAmount);\n', '\n', '    // Check that we did not bust the cap\n', '    if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {\n', '      throw;\n', '    }\n', '\n', '    assignTokens(receiver, tokenAmount);\n', '\n', '    // Pocket the money\n', '    if(!multisigWallet.send(weiAmount)) throw;\n', '\n', '    // Tell us invest was success\n', '    Invested(receiver, weiAmount, tokenAmount, customerId);\n', '  }\n', '\n', '  /**\n', '   * Allow anonymous contributions to this crowdsale.\n', '   */\n', '  function invest(address addr) public payable {\n', '    investInternal(addr, 0);\n', '  }\n', '\n', '  /**\n', '   * The basic entry point to participate the crowdsale process.\n', '   *\n', '   * Pay for funding, get invested tokens back in the sender address.\n', '   */\n', '  function buy() public payable {\n', '    invest(msg.sender);\n', '  }\n', '\n', '  function distributeReservedTokens(uint reservedTokensDistributionBatch) public inState(State.Success) onlyOwner stopInEmergency {\n', '    // Already finalized\n', '    if(finalized) {\n', '      throw;\n', '    }\n', '\n', '    // Finalizing is optional. We only call it if we are given a finalizing agent.\n', '    if(address(finalizeAgent) != address(0)) {\n', '      finalizeAgent.distributeReservedTokens(reservedTokensDistributionBatch);\n', '    }\n', '  }\n', '\n', '  function areReservedTokensDistributed() public constant returns (bool) {\n', '    return finalizeAgent.reservedTokensAreDistributed();\n', '  }\n', '\n', '  function canDistributeReservedTokens() public constant returns(bool) {\n', '    CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());\n', '    if ((lastTierCntrct.getState() == State.Success) && !lastTierCntrct.halted() && !lastTierCntrct.finalized() && !lastTierCntrct.areReservedTokensDistributed()) return true;\n', '    return false;\n', '  }\n', '\n', '  /**\n', '   * Finalize a succcesful crowdsale.\n', '   *\n', '   * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.\n', '   */\n', '  function finalize() public inState(State.Success) onlyOwner stopInEmergency {\n', '\n', '    // Already finalized\n', '    if(finalized) {\n', '      throw;\n', '    }\n', '\n', '    // Finalizing is optional. We only call it if we are given a finalizing agent.\n', '    if(address(finalizeAgent) != address(0)) {\n', '      finalizeAgent.finalizeCrowdsale();\n', '    }\n', '\n', '    finalized = true;\n', '  }\n', '\n', '  /**\n', '   * Allow to (re)set finalize agent.\n', '   *\n', '   * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.\n', '   */\n', '  function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {\n', '    assert(address(addr) != address(0));\n', '    assert(address(finalizeAgent) == address(0));\n', '    finalizeAgent = addr;\n', '\n', '    // Don&#39;t allow setting bad agent\n', '    if(!finalizeAgent.isFinalizeAgent()) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Allow addresses to do early participation.\n', '   */\n', '  function setEarlyParticipantWhitelist(address addr, bool status, uint minCap, uint maxCap) public onlyOwner {\n', '    if (!isWhiteListed) throw;\n', '    assert(addr != address(0));\n', '    assert(maxCap > 0);\n', '    assert(minCap <= maxCap);\n', '    assert(now <= endsAt);\n', '\n', '    if (!isAddressWhitelisted(addr)) {\n', '      whitelistedParticipants.push(addr);\n', '      Whitelisted(addr, status, minCap, maxCap);\n', '    } else {\n', '      WhitelistItemChanged(addr, status, minCap, maxCap);\n', '    }\n', '\n', '    earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});\n', '  }\n', '\n', '  function setEarlyParticipantWhitelistMultiple(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) public onlyOwner {\n', '    if (!isWhiteListed) throw;\n', '    assert(now <= endsAt);\n', '    assert(addrs.length == statuses.length);\n', '    assert(statuses.length == minCaps.length);\n', '    assert(minCaps.length == maxCaps.length);\n', '    for (uint iterator = 0; iterator < addrs.length; iterator++) {\n', '      setEarlyParticipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);\n', '    }\n', '  }\n', '\n', '  function updateInheritedEarlyParticipantWhitelist(address reciever, uint tokensBought) private {\n', '    if (!isWhiteListed) throw;\n', '    if (tokensBought < earlyParticipantWhitelist[reciever].minCap && tokenAmountOf[reciever] == 0) throw;\n', '\n', '    uint8 tierPosition = getTierPosition(this);\n', '\n', '    for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {\n', '      CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);\n', '      crowdsale.updateEarlyParticipantWhitelist(reciever, tokensBought);\n', '    }\n', '  }\n', '\n', '  function updateEarlyParticipantWhitelist(address addr, uint tokensBought) public {\n', '    if (!isWhiteListed) throw;\n', '    assert(addr != address(0));\n', '    assert(now <= endsAt);\n', '    assert(isTierJoined(msg.sender));\n', '    if (tokensBought < earlyParticipantWhitelist[addr].minCap && tokenAmountOf[addr] == 0) throw;\n', '    //if (addr != msg.sender && contractAddr != msg.sender) throw;\n', '    uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;\n', '    newMaxCap = newMaxCap.minus(tokensBought);\n', '    earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});\n', '  }\n', '\n', '  function isAddressWhitelisted(address addr) public constant returns(bool) {\n', '    for (uint i = 0; i < whitelistedParticipants.length; i++) {\n', '      if (whitelistedParticipants[i] == addr) {\n', '        return true;\n', '        break;\n', '      }\n', '    }\n', '\n', '    return false;\n', '  }\n', '\n', '  function whitelistedParticipantsLength() public constant returns (uint) {\n', '    return whitelistedParticipants.length;\n', '  }\n', '\n', '  function isTierJoined(address addr) public constant returns(bool) {\n', '    return joinedCrowdsaleState[addr].isJoined;\n', '  }\n', '\n', '  function getTierPosition(address addr) public constant returns(uint8) {\n', '    return joinedCrowdsaleState[addr].position;\n', '  }\n', '\n', '  function getLastTier() public constant returns(address) {\n', '    if (joinedCrowdsalesLen > 0)\n', '      return joinedCrowdsales[joinedCrowdsalesLen - 1];\n', '    else\n', '      return address(0);\n', '  }\n', '\n', '  function setJoinedCrowdsales(address addr) private onlyOwner {\n', '    assert(addr != address(0));\n', '    assert(joinedCrowdsalesLen <= joinedCrowdsalesLenMax);\n', '    assert(!isTierJoined(addr));\n', '    joinedCrowdsales.push(addr);\n', '    joinedCrowdsaleState[addr] = JoinedCrowdsaleStatus({\n', '      isJoined: true,\n', '      position: joinedCrowdsalesLen\n', '    });\n', '    joinedCrowdsalesLen++;\n', '  }\n', '\n', '  function updateJoinedCrowdsalesMultiple(address[] addrs) public onlyOwner {\n', '    assert(addrs.length > 0);\n', '    assert(joinedCrowdsalesLen == 0);\n', '    assert(addrs.length <= joinedCrowdsalesLenMax);\n', '    for (uint8 iter = 0; iter < addrs.length; iter++) {\n', '      setJoinedCrowdsales(addrs[iter]);\n', '    }\n', '  }\n', '\n', '  function setStartsAt(uint time) onlyOwner {\n', '    assert(!finalized);\n', '    assert(isUpdatable);\n', '    assert(now <= time); // Don&#39;t change past\n', '    assert(time <= endsAt);\n', '    assert(now <= startsAt);\n', '\n', '    CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());\n', '    if (lastTierCntrct.finalized()) throw;\n', '\n', '    uint8 tierPosition = getTierPosition(this);\n', '\n', '    //start time should be greater then end time of previous tiers\n', '    for (uint8 j = 0; j < tierPosition; j++) {\n', '      CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);\n', '      assert(time >= crowdsale.endsAt());\n', '    }\n', '\n', '    startsAt = time;\n', '    StartsAtChanged(startsAt);\n', '  }\n', '\n', '  /**\n', '   * Allow crowdsale owner to close early or extend the crowdsale.\n', '   *\n', '   * This is useful e.g. for a manual soft cap implementation:\n', '   * - after X amount is reached determine manual closing\n', '   *\n', '   * This may put the crowdsale to an invalid state,\n', '   * but we trust owners know what they are doing.\n', '   *\n', '   */\n', '  function setEndsAt(uint time) public onlyOwner {\n', '    assert(!finalized);\n', '    assert(isUpdatable);\n', '    assert(now <= time);// Don&#39;t change past\n', '    assert(startsAt <= time);\n', '    assert(now <= endsAt);\n', '\n', '    CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());\n', '    if (lastTierCntrct.finalized()) throw;\n', '\n', '\n', '    uint8 tierPosition = getTierPosition(this);\n', '\n', '    for (uint8 j = tierPosition + 1; j < joinedCrowdsalesLen; j++) {\n', '      CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);\n', '      assert(time <= crowdsale.startsAt());\n', '    }\n', '\n', '    endsAt = time;\n', '    EndsAtChanged(endsAt);\n', '  }\n', '\n', '  /**\n', '   * Allow to (re)set pricing strategy.\n', '   *\n', '   * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.\n', '   */\n', '  function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {\n', '    assert(address(_pricingStrategy) != address(0));\n', '    assert(address(pricingStrategy) == address(0));\n', '    pricingStrategy = _pricingStrategy;\n', '\n', '    // Don&#39;t allow setting bad agent\n', '    if(!pricingStrategy.isPricingStrategy()) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Allow to change the team multisig address in the case of emergency.\n', '   *\n', '   * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun\n', '   * (we have done only few test transactions). After the crowdsale is going\n', '   * then multisig address stays locked for the safety reasons.\n', '   */\n', '  function setMultisig(address addr) public onlyOwner {\n', '\n', '    // Change\n', '    if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {\n', '      throw;\n', '    }\n', '\n', '    multisigWallet = addr;\n', '  }\n', '\n', '  /**\n', '   * @return true if the crowdsale has raised enough money to be a successful.\n', '   */\n', '  function isMinimumGoalReached() public constant returns (bool reached) {\n', '    return weiRaised >= minimumFundingGoal;\n', '  }\n', '\n', '  /**\n', '   * Check if the contract relationship looks good.\n', '   */\n', '  function isFinalizerSane() public constant returns (bool sane) {\n', '    return finalizeAgent.isSane();\n', '  }\n', '\n', '  /**\n', '   * Check if the contract relationship looks good.\n', '   */\n', '  function isPricingSane() public constant returns (bool sane) {\n', '    return pricingStrategy.isSane(address(this));\n', '  }\n', '\n', '  /**\n', '   * Crowdfund state machine management.\n', '   *\n', '   * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.\n', '   */\n', '  function getState() public constant returns (State) {\n', '    if(finalized) return State.Finalized;\n', '    else if (address(finalizeAgent) == 0) return State.Preparing;\n', '    else if (!finalizeAgent.isSane()) return State.Preparing;\n', '    else if (!pricingStrategy.isSane(address(this))) return State.Preparing;\n', '    else if (block.timestamp < startsAt) return State.PreFunding;\n', '    else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;\n', '    else if (isMinimumGoalReached()) return State.Success;\n', '    else return State.Failure;\n', '  }\n', '\n', '  /** Interface marker. */\n', '  function isCrowdsale() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  //\n', '  // Modifiers\n', '  //\n', '\n', '  /** Modified allowing execution only if the crowdsale is currently running.  */\n', '  modifier inState(State state) {\n', '    if(getState() != state) throw;\n', '    _;\n', '  }\n', '\n', '\n', '  //\n', '  // Abstract functions\n', '  //\n', '\n', '  /**\n', '   * Check if the current invested breaks our cap rules.\n', '   *\n', '   *\n', '   * The child contract must define their own cap setting rules.\n', '   * We allow a lot of flexibility through different capping strategies (ETH, token count)\n', '   * Called from invest().\n', '   *\n', '   * @param weiAmount The amount of wei the investor tries to invest in the current transaction\n', '   * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction\n', '   * @param weiRaisedTotal What would be our total raised balance after this transaction\n', '   * @param tokensSoldTotal What would be our total sold tokens count after this transaction\n', '   *\n', '   * @return true if taking this investment would break our cap rules\n', '   */\n', '  function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);\n', '\n', '  function isBreakingInvestorCap(address receiver, uint tokenAmount) public constant returns (bool limitBroken);\n', '\n', '  /**\n', '   * Check if the current crowdsale is full and we can no longer sell any tokens.\n', '   */\n', '  function isCrowdsaleFull() public constant returns (bool);\n', '\n', '  /**\n', '   * Create new tokens or transfer issued tokens to the investor depending on the cap model.\n', '   */\n', '  function assignTokens(address receiver, uint tokenAmount) private;\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * Define interface for releasing the token transfer after a successful crowdsale.\n', ' */\n', 'contract ReleasableToken is ERC20, Ownable {\n', '\n', '  /* The finalizer contract that allows unlift the transfer limits on this token */\n', '  address public releaseAgent;\n', '\n', '  /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/\n', '  bool public released = false;\n', '\n', '  /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */\n', '  mapping (address => bool) public transferAgents;\n', '\n', '  /**\n', '   * Limit token transfer until the crowdsale is over.\n', '   *\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '\n', '    if(!released) {\n', '        if(!transferAgents[_sender]) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Set the contract that can call release and make the token transferable.\n', '   *\n', '   * Design choice. Allow reset the release agent to fix fat finger mistakes.\n', '   */\n', '  function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {\n', '\n', '    // We don&#39;t do interface check here as we might want to a normal wallet address to act as a release agent\n', '    releaseAgent = addr;\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.\n', '   */\n', '  function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {\n', '    transferAgents[addr] = state;\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild.\n', '   *\n', '   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', '   */\n', '  function releaseTokenTransfer() public onlyReleaseAgent {\n', '    released = true;\n', '  }\n', '\n', '  /** The function can be called only before or after the tokens have been releasesd */\n', '  modifier inReleaseState(bool releaseState) {\n', '    if(releaseState != released) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /** The function can be called only by a whitelisted release agent. */\n', '  modifier onlyReleaseAgent() {\n', '    if(msg.sender != releaseAgent) {\n', '        throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A finalize agent that does nothing.\n', ' *\n', ' * - Token transfer must be manually released by the owner\n', ' */\n', 'contract NullFinalizeAgentExt is FinalizeAgent {\n', '\n', '  CrowdsaleExt public crowdsale;\n', '\n', '  function NullFinalizeAgentExt(CrowdsaleExt _crowdsale) {\n', '    crowdsale = _crowdsale;\n', '  }\n', '\n', '  /** Check that we can release the token */\n', '  function isSane() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function distributeReservedTokens(uint reservedTokensDistributionBatch) public {\n', '  }\n', '\n', '  /** Called once by crowdsale finalize() if the sale was success. */\n', '  function finalizeCrowdsale() public {\n', '  }\n', '\n', '}']