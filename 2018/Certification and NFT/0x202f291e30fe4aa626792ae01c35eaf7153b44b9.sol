['// Ethertote - Official Token Sale Contract\n', '// 28.07.18\n', '//\n', '// Any unsold tokens can be sent directly to the TokenBurn Contract\n', '// by anyone once the Token Sale is complete - \n', '// this is a PUBLIC function that anyone can call!!\n', '//\n', '// All Eth raised during the token sale is automatically sent to the \n', '// EthRaised smart contract for distribution\n', '\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '///////////////////////////////////////////////////////////////////////////////\n', '// SafeMath Library \n', '///////////////////////////////////////////////////////////////////////////////\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Imported Token Contract functions\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract EthertoteToken {\n', '    function thisContractAddress() public pure returns (address) {}\n', '    function balanceOf(address) public pure returns (uint256) {}\n', '    function transfer(address, uint) public {}\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Main Contract\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract TokenSale {\n', '  using SafeMath for uint256;\n', '  \n', '  EthertoteToken public token;\n', '\n', '  address public admin;\n', '  address public thisContractAddress;\n', '\n', '  // address of the TOTE token original smart contract\n', '  address public tokenContractAddress = 0x42be9831FFF77972c1D0E1eC0aA9bdb3CaA04D47;\n', '  \n', '  // address of TokenBurn contract to "burn" unsold tokens\n', '  // for further details, review the TokenBurn contract and verify code on Etherscan\n', '  address public tokenBurnAddress = 0xadCa18DC9489C5FE5BdDf1A8a8C2623B66029198;\n', '  \n', '  // address of EthRaised contract, that will be used to distribute funds \n', '  // raised by the token sale. Added as "wallet address"\n', '  address public ethRaisedAddress = 0x9F73D808807c71Af185FEA0c1cE205002c74123C;\n', '  \n', '  uint public preIcoPhaseCountdown;       // used for website tokensale\n', '  uint public icoPhaseCountdown;          // used for website tokensale\n', '  uint public postIcoPhaseCountdown;      // used for website tokensale\n', '  \n', '  // pause token sale in an emergency [true/false]\n', '  bool public tokenSaleIsPaused;\n', '  \n', '  // note the pause time to allow special function to extend closingTime\n', '  uint public tokenSalePausedTime;\n', '  \n', '  // note the resume time \n', '  uint public tokenSaleResumedTime;\n', '  \n', '  // The time (in seconds) that needs to be added on to the closing time \n', '  // in the event of an emergency pause of the token sale\n', '  uint public tokenSalePausedDuration;\n', '  \n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '  \n', '  // 1000 tokens per Eth - 9,000,000 tokens for sale\n', '  uint public maxEthRaised = 9000;\n', '  \n', '  // Maximum amount of Wei that can be raised\n', '  // e.g. 9,000,000 tokens for sale with 1000 tokens per 1 eth\n', '  // means maximum Wei raised would be maxEthRaised * 1000000000000000000\n', '  uint public maxWeiRaised = maxEthRaised.mul(1000000000000000000);\n', '\n', '  // starting time and closing time of Crowdsale\n', '  // scheduled start on Monday, August 27th 2018 at 5:00pm GMT+1\n', '  uint public openingTime = 1535385600;\n', '  uint public closingTime = openingTime.add(7 days);\n', '  \n', '  // used as a divider so that 1 eth will buy 1000 tokens\n', '  // set rate to 1,000,000,000,000,000\n', '  uint public rate = 1000000000000000;\n', '  \n', '  // minimum and maximum spend of eth per transaction\n', '  uint public minSpend = 100000000000000000;    // 0.1 Eth\n', '  uint public maxSpend = 100000000000000000000; // 100 Eth \n', '\n', '  \n', '  // MODIFIERS\n', '  modifier onlyAdmin { \n', '        require(msg.sender == admin\n', '        ); \n', '        _; \n', '  }\n', '  \n', '  // EVENTS\n', '  event Deployed(string, uint);\n', '  event SalePaused(string, uint);\n', '  event SaleResumed(string, uint);\n', '  event TokensBurned(string, uint);\n', '  \n', ' // ---------------------------------------------------------------------------\n', ' // Constructor function\n', ' // _ethRaisedContract = Address where collected funds will be forwarded to\n', ' // _tokenContractAddress = Address of the original token contract being sold\n', ' // ---------------------------------------------------------------------------\n', ' \n', '  constructor() public {\n', '    \n', '    admin = msg.sender;\n', '    thisContractAddress = address(this);\n', '\n', '    token = EthertoteToken(tokenContractAddress);\n', '    \n', '\n', '    require(ethRaisedAddress != address(0));\n', '    require(tokenContractAddress != address(0));\n', '    require(tokenBurnAddress != address(0));\n', '\n', '    preIcoPhaseCountdown = openingTime;\n', '    icoPhaseCountdown = closingTime;\n', '    \n', '    // after 14 days the "post-tokensale" header section of the homepage \n', '    // on the website will be removed based on this time\n', '    postIcoPhaseCountdown = closingTime.add(14 days);\n', '    \n', '    emit Deployed("Ethertote Token Sale contract deployed", now);\n', '  }\n', '  \n', '  \n', '  \n', '  // check balance of this smart contract\n', '  function tokenSaleTokenBalance() public view returns(uint) {\n', '      return token.balanceOf(thisContractAddress);\n', '  }\n', '  \n', '  // check the token balance of any ethereum address  \n', '  function getAnyAddressTokenBalance(address _address) public view returns(uint) {\n', '      return token.balanceOf(_address);\n', '  }\n', '  \n', '  // confirm if The Token Sale has finished\n', '  function tokenSaleHasFinished() public view returns (bool) {\n', '    return now > closingTime;\n', '  }\n', '  \n', '  // this function will send any unsold tokens to the null TokenBurn contract address\n', '  // once the crowdsale is finished, anyone can publicly call this function!\n', '  function burnUnsoldTokens() public {\n', '      require(tokenSaleIsPaused == false);\n', '      require(tokenSaleHasFinished() == true);\n', '      token.transfer(tokenBurnAddress, tokenSaleTokenBalance());\n', '      emit TokensBurned("tokens sent to TokenBurn contract", now);\n', '  }\n', '\n', '\n', '\n', '  // function to temporarily pause token sale if needed\n', '  function pauseTokenSale() onlyAdmin public {\n', '      // confirm the token sale hasn&#39;t already completed\n', '      require(tokenSaleHasFinished() == false);\n', '      \n', '      // confirm the token sale isn&#39;t already paused\n', '      require(tokenSaleIsPaused == false);\n', '      \n', '      // pause the sale and note the time of the pause\n', '      tokenSaleIsPaused = true;\n', '      tokenSalePausedTime = now;\n', '      emit SalePaused("token sale has been paused", now);\n', '  }\n', '  \n', '    // function to resume token sale\n', '  function resumeTokenSale() onlyAdmin public {\n', '      \n', '      // confirm the token sale is currently paused\n', '      require(tokenSaleIsPaused == true);\n', '      \n', '      tokenSaleResumedTime = now;\n', '      \n', '      // now calculate the difference in time between the pause time\n', '      // and the resume time, to establish how long the sale was\n', '      // paused for. This time now needs to be added to the closingTime.\n', '      \n', '      // Note: if the token sale was paused whilst the sale was live and was\n', '      // paused before the sale ended, then the value of tokenSalePausedTime\n', '      // will always be less than the value of tokenSaleResumedTime\n', '      \n', '      tokenSalePausedDuration = tokenSaleResumedTime.sub(tokenSalePausedTime);\n', '      \n', '      // add the total pause time to the closing time.\n', '      \n', '      closingTime = closingTime.add(tokenSalePausedDuration);\n', '      \n', '      // extend post ICO countdown for the web-site\n', '      postIcoPhaseCountdown = closingTime.add(14 days);\n', '      // now resume the token sale\n', '      tokenSaleIsPaused = false;\n', '      emit SaleResumed("token sale has now resumed", now);\n', '  }\n', '  \n', '\n', '// ----------------------------------------------------------------------------\n', '// Event for token purchase logging\n', '// purchaser = the contract address that paid for the tokens\n', '// beneficiary = the address who got the tokens\n', '// value = the amount (in Wei) paid for purchase\n', '// amount = the amount of tokens purchased\n', '// ----------------------------------------------------------------------------\n', '  event TokenPurchase(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '\n', '\n', '// -----------------------------------------\n', '// Crowdsale external interface\n', '// -----------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// fallback function ***DO NOT OVERRIDE***\n', '// allows purchase of tokens directly from MEW and other wallets\n', '// will conform to require statements set out in buyTokens() function\n', '// ----------------------------------------------------------------------------\n', '   \n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// function for front-end token purchase on our website ***DO NOT OVERRIDE***\n', '// buyer = Address of the wallet performing the token purchase\n', '// ----------------------------------------------------------------------------\n', '  function buyTokens(address buyer) public payable {\n', '    \n', '    // check Crowdsale is open (can disable for testing)\n', '    require(openingTime <= block.timestamp);\n', '    require(block.timestamp < closingTime);\n', '    \n', '    // minimum purchase of 100 tokens (0.1 eth)\n', '    require(msg.value >= minSpend);\n', '    \n', '    // maximum purchase per transaction to allow broader\n', '    // token distribution during tokensale\n', '    require(msg.value <= maxSpend);\n', '    \n', '    // stop sales of tokens if token balance is 0\n', '    require(tokenSaleTokenBalance() > 0);\n', '    \n', '    // stop sales of tokens if Token sale is paused\n', '    require(tokenSaleIsPaused == false);\n', '    \n', '    // log the amount being sent\n', '    uint256 weiAmount = msg.value;\n', '    preValidatePurchase(buyer, weiAmount);\n', '\n', '    // calculate token amount to be sold\n', '    uint256 tokens = getTokenAmount(weiAmount);\n', '    \n', '    // check that the amount of eth being sent by the buyer \n', '    // does not exceed the equivalent number of tokens remaining\n', '    require(tokens <= tokenSaleTokenBalance());\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    processPurchase(buyer, tokens);\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      buyer,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    updatePurchasingState(buyer, weiAmount);\n', '\n', '    forwardFunds();\n', '    postValidatePurchase(buyer, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// Validation of an incoming purchase\n', '// ----------------------------------------------------------------------------\n', '  function preValidatePurchase(\n', '    address buyer,\n', '    uint256 weiAmount\n', '  )\n', '    internal pure\n', '  {\n', '    require(buyer != address(0));\n', '    require(weiAmount != 0);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Validation of an executed purchase\n', '// ----------------------------------------------------------------------------\n', '  function postValidatePurchase(\n', '    address,\n', '    uint256\n', '  )\n', '    internal pure\n', '  {\n', '    // optional override\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Source of tokens\n', '// ----------------------------------------------------------------------------\n', '  function deliverTokens(\n', '    address buyer,\n', '    uint256 tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    token.transfer(buyer, tokenAmount);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// The following function is executed when a purchase has been validated \n', '// and is ready to be executed\n', '// ----------------------------------------------------------------------------\n', '  function processPurchase(\n', '    address buyer,\n', '    uint256 tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    deliverTokens(buyer, tokenAmount);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Override for extensions that require an internal state to check for \n', '// validity (current user contributions, etc.)\n', '// ----------------------------------------------------------------------------\n', '  function updatePurchasingState(\n', '    address,\n', '    uint256\n', '  )\n', '    internal pure\n', '  {\n', '    // optional override\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Override to extend the way in which ether is converted to tokens.\n', '// _weiAmount Value in wei to be converted into tokens\n', '// return Number of tokens that can be purchased with the specified _weiAmount\n', '// ----------------------------------------------------------------------------\n', '  function getTokenAmount(uint256 weiAmount)\n', '    internal view returns (uint256)\n', '  {\n', '    return weiAmount.div(rate);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// how ETH is stored/forwarded on purchases.\n', '// Sent to the EthRaised Contract\n', '// ----------------------------------------------------------------------------\n', '  function forwardFunds() internal {\n', '    ethRaisedAddress.transfer(msg.value);\n', '  }\n', '  \n', '\n', '// functions for tokensale information on the website \n', '\n', '    function maximumRaised() public view returns(uint) {\n', '        return maxWeiRaised;\n', '    }\n', '    \n', '    function amountRaised() public view returns(uint) {\n', '        return weiRaised;\n', '    }\n', '  \n', '    function timeComplete() public view returns(uint) {\n', '        return closingTime;\n', '    }\n', '    \n', '    // special function to delay the token sale if necessary\n', '    function delayOpeningTime(uint256 _openingTime) onlyAdmin public {  \n', '    openingTime = _openingTime;\n', '    closingTime = openingTime.add(7 days);\n', '    preIcoPhaseCountdown = openingTime;\n', '    icoPhaseCountdown = closingTime;\n', '    postIcoPhaseCountdown = closingTime.add(14 days);\n', '    }\n', '    \n', '  \n', '}']
['// Ethertote - Official Token Sale Contract\n', '// 28.07.18\n', '//\n', '// Any unsold tokens can be sent directly to the TokenBurn Contract\n', '// by anyone once the Token Sale is complete - \n', '// this is a PUBLIC function that anyone can call!!\n', '//\n', '// All Eth raised during the token sale is automatically sent to the \n', '// EthRaised smart contract for distribution\n', '\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '///////////////////////////////////////////////////////////////////////////////\n', '// SafeMath Library \n', '///////////////////////////////////////////////////////////////////////////////\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Imported Token Contract functions\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract EthertoteToken {\n', '    function thisContractAddress() public pure returns (address) {}\n', '    function balanceOf(address) public pure returns (uint256) {}\n', '    function transfer(address, uint) public {}\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Main Contract\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract TokenSale {\n', '  using SafeMath for uint256;\n', '  \n', '  EthertoteToken public token;\n', '\n', '  address public admin;\n', '  address public thisContractAddress;\n', '\n', '  // address of the TOTE token original smart contract\n', '  address public tokenContractAddress = 0x42be9831FFF77972c1D0E1eC0aA9bdb3CaA04D47;\n', '  \n', '  // address of TokenBurn contract to "burn" unsold tokens\n', '  // for further details, review the TokenBurn contract and verify code on Etherscan\n', '  address public tokenBurnAddress = 0xadCa18DC9489C5FE5BdDf1A8a8C2623B66029198;\n', '  \n', '  // address of EthRaised contract, that will be used to distribute funds \n', '  // raised by the token sale. Added as "wallet address"\n', '  address public ethRaisedAddress = 0x9F73D808807c71Af185FEA0c1cE205002c74123C;\n', '  \n', '  uint public preIcoPhaseCountdown;       // used for website tokensale\n', '  uint public icoPhaseCountdown;          // used for website tokensale\n', '  uint public postIcoPhaseCountdown;      // used for website tokensale\n', '  \n', '  // pause token sale in an emergency [true/false]\n', '  bool public tokenSaleIsPaused;\n', '  \n', '  // note the pause time to allow special function to extend closingTime\n', '  uint public tokenSalePausedTime;\n', '  \n', '  // note the resume time \n', '  uint public tokenSaleResumedTime;\n', '  \n', '  // The time (in seconds) that needs to be added on to the closing time \n', '  // in the event of an emergency pause of the token sale\n', '  uint public tokenSalePausedDuration;\n', '  \n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '  \n', '  // 1000 tokens per Eth - 9,000,000 tokens for sale\n', '  uint public maxEthRaised = 9000;\n', '  \n', '  // Maximum amount of Wei that can be raised\n', '  // e.g. 9,000,000 tokens for sale with 1000 tokens per 1 eth\n', '  // means maximum Wei raised would be maxEthRaised * 1000000000000000000\n', '  uint public maxWeiRaised = maxEthRaised.mul(1000000000000000000);\n', '\n', '  // starting time and closing time of Crowdsale\n', '  // scheduled start on Monday, August 27th 2018 at 5:00pm GMT+1\n', '  uint public openingTime = 1535385600;\n', '  uint public closingTime = openingTime.add(7 days);\n', '  \n', '  // used as a divider so that 1 eth will buy 1000 tokens\n', '  // set rate to 1,000,000,000,000,000\n', '  uint public rate = 1000000000000000;\n', '  \n', '  // minimum and maximum spend of eth per transaction\n', '  uint public minSpend = 100000000000000000;    // 0.1 Eth\n', '  uint public maxSpend = 100000000000000000000; // 100 Eth \n', '\n', '  \n', '  // MODIFIERS\n', '  modifier onlyAdmin { \n', '        require(msg.sender == admin\n', '        ); \n', '        _; \n', '  }\n', '  \n', '  // EVENTS\n', '  event Deployed(string, uint);\n', '  event SalePaused(string, uint);\n', '  event SaleResumed(string, uint);\n', '  event TokensBurned(string, uint);\n', '  \n', ' // ---------------------------------------------------------------------------\n', ' // Constructor function\n', ' // _ethRaisedContract = Address where collected funds will be forwarded to\n', ' // _tokenContractAddress = Address of the original token contract being sold\n', ' // ---------------------------------------------------------------------------\n', ' \n', '  constructor() public {\n', '    \n', '    admin = msg.sender;\n', '    thisContractAddress = address(this);\n', '\n', '    token = EthertoteToken(tokenContractAddress);\n', '    \n', '\n', '    require(ethRaisedAddress != address(0));\n', '    require(tokenContractAddress != address(0));\n', '    require(tokenBurnAddress != address(0));\n', '\n', '    preIcoPhaseCountdown = openingTime;\n', '    icoPhaseCountdown = closingTime;\n', '    \n', '    // after 14 days the "post-tokensale" header section of the homepage \n', '    // on the website will be removed based on this time\n', '    postIcoPhaseCountdown = closingTime.add(14 days);\n', '    \n', '    emit Deployed("Ethertote Token Sale contract deployed", now);\n', '  }\n', '  \n', '  \n', '  \n', '  // check balance of this smart contract\n', '  function tokenSaleTokenBalance() public view returns(uint) {\n', '      return token.balanceOf(thisContractAddress);\n', '  }\n', '  \n', '  // check the token balance of any ethereum address  \n', '  function getAnyAddressTokenBalance(address _address) public view returns(uint) {\n', '      return token.balanceOf(_address);\n', '  }\n', '  \n', '  // confirm if The Token Sale has finished\n', '  function tokenSaleHasFinished() public view returns (bool) {\n', '    return now > closingTime;\n', '  }\n', '  \n', '  // this function will send any unsold tokens to the null TokenBurn contract address\n', '  // once the crowdsale is finished, anyone can publicly call this function!\n', '  function burnUnsoldTokens() public {\n', '      require(tokenSaleIsPaused == false);\n', '      require(tokenSaleHasFinished() == true);\n', '      token.transfer(tokenBurnAddress, tokenSaleTokenBalance());\n', '      emit TokensBurned("tokens sent to TokenBurn contract", now);\n', '  }\n', '\n', '\n', '\n', '  // function to temporarily pause token sale if needed\n', '  function pauseTokenSale() onlyAdmin public {\n', "      // confirm the token sale hasn't already completed\n", '      require(tokenSaleHasFinished() == false);\n', '      \n', "      // confirm the token sale isn't already paused\n", '      require(tokenSaleIsPaused == false);\n', '      \n', '      // pause the sale and note the time of the pause\n', '      tokenSaleIsPaused = true;\n', '      tokenSalePausedTime = now;\n', '      emit SalePaused("token sale has been paused", now);\n', '  }\n', '  \n', '    // function to resume token sale\n', '  function resumeTokenSale() onlyAdmin public {\n', '      \n', '      // confirm the token sale is currently paused\n', '      require(tokenSaleIsPaused == true);\n', '      \n', '      tokenSaleResumedTime = now;\n', '      \n', '      // now calculate the difference in time between the pause time\n', '      // and the resume time, to establish how long the sale was\n', '      // paused for. This time now needs to be added to the closingTime.\n', '      \n', '      // Note: if the token sale was paused whilst the sale was live and was\n', '      // paused before the sale ended, then the value of tokenSalePausedTime\n', '      // will always be less than the value of tokenSaleResumedTime\n', '      \n', '      tokenSalePausedDuration = tokenSaleResumedTime.sub(tokenSalePausedTime);\n', '      \n', '      // add the total pause time to the closing time.\n', '      \n', '      closingTime = closingTime.add(tokenSalePausedDuration);\n', '      \n', '      // extend post ICO countdown for the web-site\n', '      postIcoPhaseCountdown = closingTime.add(14 days);\n', '      // now resume the token sale\n', '      tokenSaleIsPaused = false;\n', '      emit SaleResumed("token sale has now resumed", now);\n', '  }\n', '  \n', '\n', '// ----------------------------------------------------------------------------\n', '// Event for token purchase logging\n', '// purchaser = the contract address that paid for the tokens\n', '// beneficiary = the address who got the tokens\n', '// value = the amount (in Wei) paid for purchase\n', '// amount = the amount of tokens purchased\n', '// ----------------------------------------------------------------------------\n', '  event TokenPurchase(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '\n', '\n', '// -----------------------------------------\n', '// Crowdsale external interface\n', '// -----------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// fallback function ***DO NOT OVERRIDE***\n', '// allows purchase of tokens directly from MEW and other wallets\n', '// will conform to require statements set out in buyTokens() function\n', '// ----------------------------------------------------------------------------\n', '   \n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// function for front-end token purchase on our website ***DO NOT OVERRIDE***\n', '// buyer = Address of the wallet performing the token purchase\n', '// ----------------------------------------------------------------------------\n', '  function buyTokens(address buyer) public payable {\n', '    \n', '    // check Crowdsale is open (can disable for testing)\n', '    require(openingTime <= block.timestamp);\n', '    require(block.timestamp < closingTime);\n', '    \n', '    // minimum purchase of 100 tokens (0.1 eth)\n', '    require(msg.value >= minSpend);\n', '    \n', '    // maximum purchase per transaction to allow broader\n', '    // token distribution during tokensale\n', '    require(msg.value <= maxSpend);\n', '    \n', '    // stop sales of tokens if token balance is 0\n', '    require(tokenSaleTokenBalance() > 0);\n', '    \n', '    // stop sales of tokens if Token sale is paused\n', '    require(tokenSaleIsPaused == false);\n', '    \n', '    // log the amount being sent\n', '    uint256 weiAmount = msg.value;\n', '    preValidatePurchase(buyer, weiAmount);\n', '\n', '    // calculate token amount to be sold\n', '    uint256 tokens = getTokenAmount(weiAmount);\n', '    \n', '    // check that the amount of eth being sent by the buyer \n', '    // does not exceed the equivalent number of tokens remaining\n', '    require(tokens <= tokenSaleTokenBalance());\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    processPurchase(buyer, tokens);\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      buyer,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    updatePurchasingState(buyer, weiAmount);\n', '\n', '    forwardFunds();\n', '    postValidatePurchase(buyer, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// Validation of an incoming purchase\n', '// ----------------------------------------------------------------------------\n', '  function preValidatePurchase(\n', '    address buyer,\n', '    uint256 weiAmount\n', '  )\n', '    internal pure\n', '  {\n', '    require(buyer != address(0));\n', '    require(weiAmount != 0);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Validation of an executed purchase\n', '// ----------------------------------------------------------------------------\n', '  function postValidatePurchase(\n', '    address,\n', '    uint256\n', '  )\n', '    internal pure\n', '  {\n', '    // optional override\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Source of tokens\n', '// ----------------------------------------------------------------------------\n', '  function deliverTokens(\n', '    address buyer,\n', '    uint256 tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    token.transfer(buyer, tokenAmount);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// The following function is executed when a purchase has been validated \n', '// and is ready to be executed\n', '// ----------------------------------------------------------------------------\n', '  function processPurchase(\n', '    address buyer,\n', '    uint256 tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    deliverTokens(buyer, tokenAmount);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Override for extensions that require an internal state to check for \n', '// validity (current user contributions, etc.)\n', '// ----------------------------------------------------------------------------\n', '  function updatePurchasingState(\n', '    address,\n', '    uint256\n', '  )\n', '    internal pure\n', '  {\n', '    // optional override\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// Override to extend the way in which ether is converted to tokens.\n', '// _weiAmount Value in wei to be converted into tokens\n', '// return Number of tokens that can be purchased with the specified _weiAmount\n', '// ----------------------------------------------------------------------------\n', '  function getTokenAmount(uint256 weiAmount)\n', '    internal view returns (uint256)\n', '  {\n', '    return weiAmount.div(rate);\n', '  }\n', '\n', '// ----------------------------------------------------------------------------\n', '// how ETH is stored/forwarded on purchases.\n', '// Sent to the EthRaised Contract\n', '// ----------------------------------------------------------------------------\n', '  function forwardFunds() internal {\n', '    ethRaisedAddress.transfer(msg.value);\n', '  }\n', '  \n', '\n', '// functions for tokensale information on the website \n', '\n', '    function maximumRaised() public view returns(uint) {\n', '        return maxWeiRaised;\n', '    }\n', '    \n', '    function amountRaised() public view returns(uint) {\n', '        return weiRaised;\n', '    }\n', '  \n', '    function timeComplete() public view returns(uint) {\n', '        return closingTime;\n', '    }\n', '    \n', '    // special function to delay the token sale if necessary\n', '    function delayOpeningTime(uint256 _openingTime) onlyAdmin public {  \n', '    openingTime = _openingTime;\n', '    closingTime = openingTime.add(7 days);\n', '    preIcoPhaseCountdown = openingTime;\n', '    icoPhaseCountdown = closingTime;\n', '    postIcoPhaseCountdown = closingTime.add(14 days);\n', '    }\n', '    \n', '  \n', '}']
