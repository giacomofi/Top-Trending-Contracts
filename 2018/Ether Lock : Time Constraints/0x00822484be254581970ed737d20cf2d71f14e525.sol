['pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title SafeMath\n', '\n', ' * @dev Math operations with safety checks that throw on error\n', '\n', ' */\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    uint256 c = a * b;\n', '\n', '    assert(a == 0 || c / a == b);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\n', '    uint256 c = a / b;\n', '\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    assert(b <= a);\n', '\n', '    return a - b;\n', '\n', '  }\n', '\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    uint256 c = a + b;\n', '\n', '    assert(c >= a);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Crowdsale\n', '\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', '\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', '\n', ' * token purchases and the crowdsale will assign them tokens based\n', '\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', '\n', ' * as they arrive.\n', '\n', ' */\n', '\n', 'contract token { function transfer(address receiver, uint amount){  } }\n', '\n', 'contract Crowdsale {\n', '\n', '  using SafeMath for uint256;\n', '\n', '\n', '\n', '  // uint256 durationInMinutes;\n', '\n', '  // address where funds are collected\n', '\n', '  address public wallet;\n', '\n', '  // token address\n', '\n', '  address addressOfTokenUsedAsReward;\n', '\n', '\n', '\n', '  token tokenReward;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '\n', '  uint256 public startTime;\n', '\n', '  uint256 public endTime;\n', '\n', '  // amount of raised money in wei\n', '\n', '  uint256 public weiRaised;\n', '\n', '\n', '\n', '  /**\n', '\n', '   * event for token purchase logging\n', '\n', '   * @param purchaser who paid for the tokens\n', '\n', '   * @param beneficiary who got the tokens\n', '\n', '   * @param value weis paid for purchase\n', '\n', '   * @param amount amount of tokens purchased\n', '\n', '   */\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '\n', '\n', '\n', '  function Crowdsale() {\n', '\n', '    wallet = 0x205E2ACd291E235425b5c10feC8F62FE7Ec26063;\n', '\n', '    // durationInMinutes = _durationInMinutes;\n', '\n', '    addressOfTokenUsedAsReward = 0x82B99C8a12B6Ee50191B9B2a03B9c7AEF663D527;\n', '\n', '\n', '\n', '\n', '\n', '    tokenReward = token(addressOfTokenUsedAsReward);\n', '\n', '  }\n', '\n', '\n', '\n', '  bool started = false;\n', '\n', '\n', '\n', '  function startSale(uint256 delay){\n', '\n', '    if (msg.sender != wallet || started) throw;\n', '\n', '    startTime = now + delay * 1 minutes;\n', '\n', '    endTime = startTime + 30 * 24 * 60 * 1 minutes;\n', '\n', '    started = true;\n', '\n', '  }\n', '\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '\n', '  function () payable {\n', '\n', '    buyTokens(msg.sender);\n', '\n', '  }\n', '\n', '\n', '\n', '  // low level token purchase function\n', '\n', '  function buyTokens(address beneficiary) payable {\n', '\n', '    require(beneficiary != 0x0);\n', '\n', '    require(validPurchase());\n', '\n', '\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '\n', '\n', '    // calculate token amount to be sent\n', '\n', '    uint256 tokens = (weiAmount/10**10) * 3000;\n', '\n', '\n', '\n', '    if(now < startTime + 1*7*24*60* 1 minutes){\n', '\n', '      tokens += (tokens * 20) / 100;\n', '\n', '    }else if(now < startTime + 2*7*24*60* 1 minutes){\n', '\n', '      tokens += (tokens * 10) / 100;\n', '\n', '    }else{\n', '\n', '      tokens += (tokens * 5) / 100;\n', '\n', '    }\n', '\n', '\n', '\n', '    // update state\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '\n', '\n', '    tokenReward.transfer(beneficiary, tokens);\n', '\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '\n', '  }\n', '\n', '\n', '\n', '  // send ether to the fund collection wallet\n', '\n', '  // override to create custom fund forwarding mechanisms\n', '\n', '  function forwardFunds() internal {\n', '\n', '    // wallet.transfer(msg.value);\n', '\n', '    if (!wallet.send(msg.value)) {\n', '\n', '      throw;\n', '\n', '    }\n', '\n', '  }\n', '\n', '\n', '\n', '  // @return true if the transaction can buy tokens\n', '\n', '  function validPurchase() internal constant returns (bool) {\n', '\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '\n', '    bool nonZeroPurchase = msg.value != 0;\n', '\n', '    return withinPeriod && nonZeroPurchase;\n', '\n', '  }\n', '\n', '\n', '\n', '  // @return true if crowdsale event has ended\n', '\n', '  function hasEnded() public constant returns (bool) {\n', '\n', '    return now > endTime;\n', '\n', '  }\n', '\n', '\n', '\n', '  function withdrawTokens(uint256 _amount) {\n', '\n', '    if(msg.sender!=wallet) throw;\n', '\n', '    tokenReward.transfer(wallet,_amount);\n', '\n', '  }\n', '\n', '}']