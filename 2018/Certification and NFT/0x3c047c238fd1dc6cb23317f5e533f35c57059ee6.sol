['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded \n', ' to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract token { function transfer(address receiver, uint amount){  } }\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // uint256 durationInMinutes;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // token address\n', '  address public addressOfTokenUsedAsReward;\n', '\n', '  uint256 public price = 1818;\n', '\n', '  token tokenReward;\n', '\n', '  // mapping (address => uint) public contributions;\n', '  \n', '\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  // uint256 public startTime;\n', '  // uint256 public endTime;\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale() {\n', '    //You will change this to your wallet where you need the ETH \n', '    wallet = 0x5d467Dfc5e3FcA3ea4bd6C312275ca930d2f3E19;\n', '    // durationInMinutes = _durationInMinutes;\n', '    //Here will come the checksum address we got\n', '    addressOfTokenUsedAsReward = 0xB6eC8C3a347f66a3d7C4F39D6DD68A422E69E81d  ;\n', '\n', '\n', '    tokenReward = token(addressOfTokenUsedAsReward);\n', '  }\n', '\n', '  bool public started = true;\n', '\n', '  function startSale(){\n', '    if (msg.sender != wallet) throw;\n', '    started = true;\n', '  }\n', '\n', '  function stopSale(){\n', '    if(msg.sender != wallet) throw;\n', '    started = false;\n', '  }\n', '\n', '  function setPrice(uint256 _price){\n', '    if(msg.sender != wallet) throw;\n', '    price = _price;\n', '  }\n', '  function changeWallet(address _wallet){\n', '  \tif(msg.sender != wallet) throw;\n', '  \twallet = _wallet;\n', '  }\n', '\n', '  function changeTokenReward(address _token){\n', '    if(msg.sender!=wallet) throw;\n', '    tokenReward = token(_token);\n', '    addressOfTokenUsedAsReward = _token;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender,"");\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary, bytes32 promoCode) payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // if(weiAmount < 10**16) throw;\n', '    // if(weiAmount > 50*10**18) throw;\n', '\n', '    // calculate token amount to be sent\n', '    uint256 tokens = (weiAmount) * price;//weiamount * price \n', '    \n', '    if (promoCode == "ILOVEICOBUFFER")\n', '        tokens = weiAmount * 2015;\n', '    // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price \n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    \n', '    // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;\n', '    // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);\n', '\n', '    tokenReward.transfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    // wallet.transfer(msg.value);\n', '    if (!wallet.send(msg.value)) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = started;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  function withdrawTokens(uint256 _amount) {\n', '    if(msg.sender!=wallet) throw;\n', '    tokenReward.transfer(wallet,_amount);\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded \n', ' to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract token { function transfer(address receiver, uint amount){  } }\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // uint256 durationInMinutes;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // token address\n', '  address public addressOfTokenUsedAsReward;\n', '\n', '  uint256 public price = 1818;\n', '\n', '  token tokenReward;\n', '\n', '  // mapping (address => uint) public contributions;\n', '  \n', '\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  // uint256 public startTime;\n', '  // uint256 public endTime;\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale() {\n', '    //You will change this to your wallet where you need the ETH \n', '    wallet = 0x5d467Dfc5e3FcA3ea4bd6C312275ca930d2f3E19;\n', '    // durationInMinutes = _durationInMinutes;\n', '    //Here will come the checksum address we got\n', '    addressOfTokenUsedAsReward = 0xB6eC8C3a347f66a3d7C4F39D6DD68A422E69E81d  ;\n', '\n', '\n', '    tokenReward = token(addressOfTokenUsedAsReward);\n', '  }\n', '\n', '  bool public started = true;\n', '\n', '  function startSale(){\n', '    if (msg.sender != wallet) throw;\n', '    started = true;\n', '  }\n', '\n', '  function stopSale(){\n', '    if(msg.sender != wallet) throw;\n', '    started = false;\n', '  }\n', '\n', '  function setPrice(uint256 _price){\n', '    if(msg.sender != wallet) throw;\n', '    price = _price;\n', '  }\n', '  function changeWallet(address _wallet){\n', '  \tif(msg.sender != wallet) throw;\n', '  \twallet = _wallet;\n', '  }\n', '\n', '  function changeTokenReward(address _token){\n', '    if(msg.sender!=wallet) throw;\n', '    tokenReward = token(_token);\n', '    addressOfTokenUsedAsReward = _token;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender,"");\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary, bytes32 promoCode) payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // if(weiAmount < 10**16) throw;\n', '    // if(weiAmount > 50*10**18) throw;\n', '\n', '    // calculate token amount to be sent\n', '    uint256 tokens = (weiAmount) * price;//weiamount * price \n', '    \n', '    if (promoCode == "ILOVEICOBUFFER")\n', '        tokens = weiAmount * 2015;\n', '    // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price \n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    \n', '    // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;\n', '    // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);\n', '\n', '    tokenReward.transfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    // wallet.transfer(msg.value);\n', '    if (!wallet.send(msg.value)) {\n', '      throw;\n', '    }\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = started;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  function withdrawTokens(uint256 _amount) {\n', '    if(msg.sender!=wallet) throw;\n', '    tokenReward.transfer(wallet,_amount);\n', '  }\n', '}']