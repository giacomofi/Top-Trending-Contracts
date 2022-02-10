['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded \n', ' to a wallet\n', ' * as they arrive.\n', ' */\n', 'interface token { function transfer(address, uint) external; }\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // uint256 durationInMinutes;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // token address\n', '  address public addressOfTokenUsedAsReward;\n', '\n', '  uint256 public price = 25000;\n', '\n', '  token tokenReward;\n', '\n', '  \n', '\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  constructor () public {\n', '    //You will change this to your wallet where you need the ETH \n', '    wallet = 0x6F3D70BAe7Cb77F064B7bD1773D5c1fB38F67cbE;\n', '    // this the token contract address\n', '    addressOfTokenUsedAsReward = 0x85C77C93B730Bc4F568aff15F98Cea8Bd7230E1c  ;\n', '\n', '\n', '    tokenReward = token(addressOfTokenUsedAsReward);\n', '  }\n', '\n', '  bool public started = true;\n', '\n', '\n', '  function stopSale() public {\n', '    require (msg.sender == wallet);\n', '    started = false;\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable public {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable public {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    require (weiAmount >= 5**16);\n', '\n', '    // calculate token amount to be sent\n', '    uint256 tokens = (weiAmount/10**10) * price;// weiamount/(10**(18-decimals)) * price \n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    \n', '\n', '    tokenReward.transfer(beneficiary, tokens);\n', '    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = started;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  function withdrawTokens(uint256 _amount) public {\n', '    require (msg.sender==wallet);\n', '    tokenReward.transfer(wallet,_amount);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded \n', ' to a wallet\n', ' * as they arrive.\n', ' */\n', 'interface token { function transfer(address, uint) external; }\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // uint256 durationInMinutes;\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // token address\n', '  address public addressOfTokenUsedAsReward;\n', '\n', '  uint256 public price = 25000;\n', '\n', '  token tokenReward;\n', '\n', '  \n', '\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  constructor () public {\n', '    //You will change this to your wallet where you need the ETH \n', '    wallet = 0x6F3D70BAe7Cb77F064B7bD1773D5c1fB38F67cbE;\n', '    // this the token contract address\n', '    addressOfTokenUsedAsReward = 0x85C77C93B730Bc4F568aff15F98Cea8Bd7230E1c  ;\n', '\n', '\n', '    tokenReward = token(addressOfTokenUsedAsReward);\n', '  }\n', '\n', '  bool public started = true;\n', '\n', '\n', '  function stopSale() public {\n', '    require (msg.sender == wallet);\n', '    started = false;\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable public {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable public {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    require (weiAmount >= 5**16);\n', '\n', '    // calculate token amount to be sent\n', '    uint256 tokens = (weiAmount/10**10) * price;// weiamount/(10**(18-decimals)) * price \n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    \n', '\n', '    tokenReward.transfer(beneficiary, tokens);\n', '    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = started;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  function withdrawTokens(uint256 _amount) public {\n', '    require (msg.sender==wallet);\n', '    tokenReward.transfer(wallet,_amount);\n', '  }\n', '}']
