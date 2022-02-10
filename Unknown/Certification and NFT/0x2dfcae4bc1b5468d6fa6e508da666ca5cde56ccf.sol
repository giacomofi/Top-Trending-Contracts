['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract token { function transfer(address receiver, uint amount){  } }\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // uint256 durationInMinutes;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // token address\n', '  address public addressOfTokenUsedAsReward;\n', '\n', '  token tokenReward;\n', '\n', '\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale() {\n', '    // wallet = 0x06e8e1c94a03bf157f04FA6528D67437Cb2EBA10;\n', '    wallet = 0x7f863e49e4F04851f28af6C6E77cE4E8bb7F9486;\n', '    // durationInMinutes = _durationInMinutes;\n', '    addressOfTokenUsedAsReward = 0xA35E4a5C0C228a342c197e3440dFF1A584cc479C;\n', '\n', '\n', '    tokenReward = token(addressOfTokenUsedAsReward);\n', '    startTime = now + 435 * 1 minutes;\n', '    endTime = startTime + 15*24*60 * 1 minutes;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  // mapping (address => uint) public BALANCE;\n', '\n', '  function buyTokens(address beneficiary) payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '    if(weiAmount <  10**18) throw;\n', '\n', '    // calculate token amount to be sent\n', '    uint _price;\n', '\n', '    if(now < startTime + 7*24*60 * 1 minutes)\n', '      _price = 1200;\n', '    else _price = 750;\n', '    uint256 tokens = (weiAmount / 100) * _price;\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    tokenReward.transfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    // wallet.transfer(msg.value);\n', '    if (!wallet.send(msg.value)) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '  function withdrawTokens(uint256 _amount) {\n', '    if(msg.sender!=wallet) throw;\n', '    tokenReward.transfer(wallet,_amount);\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract token { function transfer(address receiver, uint amount){  } }\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // uint256 durationInMinutes;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // token address\n', '  address public addressOfTokenUsedAsReward;\n', '\n', '  token tokenReward;\n', '\n', '\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale() {\n', '    // wallet = 0x06e8e1c94a03bf157f04FA6528D67437Cb2EBA10;\n', '    wallet = 0x7f863e49e4F04851f28af6C6E77cE4E8bb7F9486;\n', '    // durationInMinutes = _durationInMinutes;\n', '    addressOfTokenUsedAsReward = 0xA35E4a5C0C228a342c197e3440dFF1A584cc479C;\n', '\n', '\n', '    tokenReward = token(addressOfTokenUsedAsReward);\n', '    startTime = now + 435 * 1 minutes;\n', '    endTime = startTime + 15*24*60 * 1 minutes;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  // mapping (address => uint) public BALANCE;\n', '\n', '  function buyTokens(address beneficiary) payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '    if(weiAmount <  10**18) throw;\n', '\n', '    // calculate token amount to be sent\n', '    uint _price;\n', '\n', '    if(now < startTime + 7*24*60 * 1 minutes)\n', '      _price = 1200;\n', '    else _price = 750;\n', '    uint256 tokens = (weiAmount / 100) * _price;\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    tokenReward.transfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    // wallet.transfer(msg.value);\n', '    if (!wallet.send(msg.value)) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '  function withdrawTokens(uint256 _amount) {\n', '    if(msg.sender!=wallet) throw;\n', '    tokenReward.transfer(wallet,_amount);\n', '  }\n', '}']
