['// v7\n', '\n', '/**\n', ' * Presale.sol\n', ' */\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '   * @dev Multiplies two numbers, throws on overflow.\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient.\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '// interface to the crowdsale contract\n', 'interface CrowdSale {\n', '  function crowdSaleCheck() external view returns (bool);\n', '}\n', '\n', '/**\n', ' * @title InvestorsStorage\n', ' * @dev InvestorStorage contract interface with newInvestment and getInvestedAmount functions which need to be implemented\n', ' */\n', 'interface InvestorsStorage {\n', '  function newInvestment(address _investor, uint256 _amount) external;\n', '  function getInvestedAmount(address _investor) external view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title TokenContract\n', ' * @dev Token contract interface with transfer and balanceOf functions which need to be implemented\n', ' */\n', 'interface TokenContract {\n', '\n', '  /**\n', '  * @dev Transfer funds to recipient address\n', '  * @param _recipient Recipients address\n', '  * @param _amount Amount to transfer\n', '  */\n', '  function transfer(address _recipient, uint256 _amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Return balance of holders address\n', '   * @param _holder Holders address\n', '   */\n', '  function balanceOf(address _holder) external view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title PreSale\n', ' * @dev PreSale Contract which executes and handles presale of the tokens\n', ' */\n', 'contract PreSale  is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // variables\n', '\n', '  TokenContract public tkn;\n', '  CrowdSale public cSale;\n', '  InvestorsStorage public investorsStorage;\n', '  uint256 public levelEndDate;\n', '  uint256 public currentLevel;\n', '  uint256 public levelTokens = 375000;\n', '  uint256 public tokensSold;\n', '  uint256 public weiRised;\n', '  uint256 public ethPrice;\n', '  address[] public investorsList;\n', '  bool public presalePaused;\n', '  bool public presaleEnded;\n', '  uint256[12] private tokenPrice = [4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48];\n', '  uint256 private baseTokens = 375000;\n', '  uint256 private usdCentValue;\n', '  uint256 private minInvestment;\n', '\n', '  /**\n', '   * @dev Constructor of Presale contract\n', '   */\n', '  constructor() public {\n', '    tkn = TokenContract(0x95c5bf2e68b76F2276221A8FFc9c47a49E9405Ec);                    // address of the token contract\n', '    investorsStorage = InvestorsStorage(0x15c7c30B980ef442d3C811A30346bF9Dd8906137);      // address of the storage contract\n', '    minInvestment = 100 finney;\n', '    updatePrice(5000);\n', '  }\n', '\n', '  /**\n', '   * @dev Fallback payable function which executes additional checks and functionality when tokens need to be sent to the investor\n', '   */\n', '  function() payable public {\n', '    require(msg.value >= minInvestment);   // check for minimum investment amount\n', '    require(!presalePaused);\n', '    require(!presaleEnded);\n', '    prepareSell(msg.sender, msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev Prepare sell of the tokens\n', '   * @param _investor Investors address\n', '   * @param _amount Amount invested\n', '   */\n', '  function prepareSell(address _investor, uint256 _amount) private {\n', '    uint256 remaining;\n', '    uint256 pricePerCent;\n', '    uint256 pricePerToken;\n', '    uint256 toSell;\n', '    uint256 amount = _amount;\n', '    uint256 sellInWei;\n', '    address investor = _investor;\n', '\n', '    pricePerCent = getUSDPrice();\n', '    pricePerToken = pricePerCent.mul(tokenPrice[currentLevel]); // calculate the price for each token in the current level\n', '    toSell = _amount.div(pricePerToken); // calculate the amount to sell\n', '\n', '    if (toSell < levelTokens) { // if there is enough tokens left in the current level, sell from it\n', '      levelTokens = levelTokens.sub(toSell);\n', '      weiRised = weiRised.add(_amount);\n', '      executeSell(investor, toSell, _amount);\n', '      owner.transfer(_amount);\n', '    } else { // if not, sell from 2 or more different levels\n', '      while (amount > 0) {\n', '        if (toSell > levelTokens) {\n', '          toSell = levelTokens; // sell all the remaining in the level\n', '          sellInWei = toSell.mul(pricePerToken);\n', '          amount = amount.sub(sellInWei);\n', '          if (currentLevel < 11) { // if is the last level, sell only the tokens left,\n', '            currentLevel += 1;\n', '            levelTokens = baseTokens;\n', '          } else {\n', '            remaining = amount;\n', '            amount = 0;\n', '          }\n', '        } else {\n', '          sellInWei = amount;\n', '          amount = 0;\n', '        }\n', '        \n', '        executeSell(investor, toSell, sellInWei); \n', '        weiRised = weiRised.add(sellInWei);\n', '        owner.transfer(amount);\n', '        if (amount > 0) {\n', '          toSell = amount.div(pricePerToken);\n', '        }\n', '        if (remaining > 0) { // if there is any mount left, it means that is the the last level an there is no more tokens to sell\n', '          investor.transfer(remaining);\n', '          owner.transfer(address(this).balance);\n', '          presaleEnded = true;\n', '        }\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Execute sell of the tokens - send investor to investors storage and transfer tokens\n', '   * @param _investor Investors address\n', '   * @param _tokens Amount of tokens to be sent\n', '   * @param _weiAmount Amount invested in wei\n', '   */\n', '  function executeSell(address _investor, uint256 _tokens, uint256 _weiAmount) private {\n', '    uint256 totalTokens = _tokens * (10 ** 18);\n', '    tokensSold += _tokens; // update tokens sold\n', '    investorsStorage.newInvestment(_investor, _weiAmount); // register the invested amount in the storage\n', '\n', '    require(tkn.transfer(_investor, totalTokens)); // transfer the tokens to the investor\n', '    emit NewInvestment(_investor, totalTokens);   \n', '  }\n', '\n', '  /**\n', '   * @dev Getter for USD price of tokens\n', '   */\n', '  function getUSDPrice() private view returns (uint256) {\n', '    return usdCentValue;\n', '  }\n', '\n', '  /**\n', '   * @dev Change USD price of tokens\n', '   * @param _ethPrice New Ether price\n', '   */\n', '  function updatePrice(uint256 _ethPrice) private {\n', '    uint256 centBase = 1 * 10 ** 16;\n', '    require(_ethPrice > 0);\n', '    ethPrice = _ethPrice;\n', '    usdCentValue = centBase.div(_ethPrice);\n', '  }\n', '\n', '  /**\n', '   * @dev Set USD to ETH value\n', '   * @param _ethPrice New Ether price\n', '   */\n', '  function setUsdEthValue(uint256 _ethPrice) onlyOwner external { // set the ETH value in USD\n', '    updatePrice(_ethPrice);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the crowdsale contract address\n', '   * @param _crowdSale Crowdsale contract address\n', '   */\n', '  function setCrowdSaleAddress(address _crowdSale) onlyOwner public { // set the crowdsale contract address\n', '    cSale = CrowdSale(_crowdSale);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the storage contract address\n', '   * @param _investorsStorage Investors storage contract address\n', '   */\n', '  function setStorageAddress(address _investorsStorage) onlyOwner public { // set the storage contract address\n', '    investorsStorage = InvestorsStorage(_investorsStorage);\n', '  }\n', '\n', '  /**\n', '   * @dev Pause the presale\n', '   * @param _paused Paused state - true/false\n', '   */\n', '  function pausePresale(bool _paused) onlyOwner public { // pause the presale\n', '    presalePaused = _paused;\n', '  }\n', '\n', '  /**\n', '   * @dev Get funds\n', '   */\n', '  function getFunds() onlyOwner public { // request the funds\n', '    owner.transfer(address(this).balance);\n', '  }\n', '\n', '  event NewInvestment(address _investor, uint256 tokens);\n', '}']
['// v7\n', '\n', '/**\n', ' * Presale.sol\n', ' */\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '   * @dev Multiplies two numbers, throws on overflow.\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient.\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   * @param a First number\n', '   * @param b Second number\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '// interface to the crowdsale contract\n', 'interface CrowdSale {\n', '  function crowdSaleCheck() external view returns (bool);\n', '}\n', '\n', '/**\n', ' * @title InvestorsStorage\n', ' * @dev InvestorStorage contract interface with newInvestment and getInvestedAmount functions which need to be implemented\n', ' */\n', 'interface InvestorsStorage {\n', '  function newInvestment(address _investor, uint256 _amount) external;\n', '  function getInvestedAmount(address _investor) external view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title TokenContract\n', ' * @dev Token contract interface with transfer and balanceOf functions which need to be implemented\n', ' */\n', 'interface TokenContract {\n', '\n', '  /**\n', '  * @dev Transfer funds to recipient address\n', '  * @param _recipient Recipients address\n', '  * @param _amount Amount to transfer\n', '  */\n', '  function transfer(address _recipient, uint256 _amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Return balance of holders address\n', '   * @param _holder Holders address\n', '   */\n', '  function balanceOf(address _holder) external view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title PreSale\n', ' * @dev PreSale Contract which executes and handles presale of the tokens\n', ' */\n', 'contract PreSale  is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // variables\n', '\n', '  TokenContract public tkn;\n', '  CrowdSale public cSale;\n', '  InvestorsStorage public investorsStorage;\n', '  uint256 public levelEndDate;\n', '  uint256 public currentLevel;\n', '  uint256 public levelTokens = 375000;\n', '  uint256 public tokensSold;\n', '  uint256 public weiRised;\n', '  uint256 public ethPrice;\n', '  address[] public investorsList;\n', '  bool public presalePaused;\n', '  bool public presaleEnded;\n', '  uint256[12] private tokenPrice = [4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48];\n', '  uint256 private baseTokens = 375000;\n', '  uint256 private usdCentValue;\n', '  uint256 private minInvestment;\n', '\n', '  /**\n', '   * @dev Constructor of Presale contract\n', '   */\n', '  constructor() public {\n', '    tkn = TokenContract(0x95c5bf2e68b76F2276221A8FFc9c47a49E9405Ec);                    // address of the token contract\n', '    investorsStorage = InvestorsStorage(0x15c7c30B980ef442d3C811A30346bF9Dd8906137);      // address of the storage contract\n', '    minInvestment = 100 finney;\n', '    updatePrice(5000);\n', '  }\n', '\n', '  /**\n', '   * @dev Fallback payable function which executes additional checks and functionality when tokens need to be sent to the investor\n', '   */\n', '  function() payable public {\n', '    require(msg.value >= minInvestment);   // check for minimum investment amount\n', '    require(!presalePaused);\n', '    require(!presaleEnded);\n', '    prepareSell(msg.sender, msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev Prepare sell of the tokens\n', '   * @param _investor Investors address\n', '   * @param _amount Amount invested\n', '   */\n', '  function prepareSell(address _investor, uint256 _amount) private {\n', '    uint256 remaining;\n', '    uint256 pricePerCent;\n', '    uint256 pricePerToken;\n', '    uint256 toSell;\n', '    uint256 amount = _amount;\n', '    uint256 sellInWei;\n', '    address investor = _investor;\n', '\n', '    pricePerCent = getUSDPrice();\n', '    pricePerToken = pricePerCent.mul(tokenPrice[currentLevel]); // calculate the price for each token in the current level\n', '    toSell = _amount.div(pricePerToken); // calculate the amount to sell\n', '\n', '    if (toSell < levelTokens) { // if there is enough tokens left in the current level, sell from it\n', '      levelTokens = levelTokens.sub(toSell);\n', '      weiRised = weiRised.add(_amount);\n', '      executeSell(investor, toSell, _amount);\n', '      owner.transfer(_amount);\n', '    } else { // if not, sell from 2 or more different levels\n', '      while (amount > 0) {\n', '        if (toSell > levelTokens) {\n', '          toSell = levelTokens; // sell all the remaining in the level\n', '          sellInWei = toSell.mul(pricePerToken);\n', '          amount = amount.sub(sellInWei);\n', '          if (currentLevel < 11) { // if is the last level, sell only the tokens left,\n', '            currentLevel += 1;\n', '            levelTokens = baseTokens;\n', '          } else {\n', '            remaining = amount;\n', '            amount = 0;\n', '          }\n', '        } else {\n', '          sellInWei = amount;\n', '          amount = 0;\n', '        }\n', '        \n', '        executeSell(investor, toSell, sellInWei); \n', '        weiRised = weiRised.add(sellInWei);\n', '        owner.transfer(amount);\n', '        if (amount > 0) {\n', '          toSell = amount.div(pricePerToken);\n', '        }\n', '        if (remaining > 0) { // if there is any mount left, it means that is the the last level an there is no more tokens to sell\n', '          investor.transfer(remaining);\n', '          owner.transfer(address(this).balance);\n', '          presaleEnded = true;\n', '        }\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Execute sell of the tokens - send investor to investors storage and transfer tokens\n', '   * @param _investor Investors address\n', '   * @param _tokens Amount of tokens to be sent\n', '   * @param _weiAmount Amount invested in wei\n', '   */\n', '  function executeSell(address _investor, uint256 _tokens, uint256 _weiAmount) private {\n', '    uint256 totalTokens = _tokens * (10 ** 18);\n', '    tokensSold += _tokens; // update tokens sold\n', '    investorsStorage.newInvestment(_investor, _weiAmount); // register the invested amount in the storage\n', '\n', '    require(tkn.transfer(_investor, totalTokens)); // transfer the tokens to the investor\n', '    emit NewInvestment(_investor, totalTokens);   \n', '  }\n', '\n', '  /**\n', '   * @dev Getter for USD price of tokens\n', '   */\n', '  function getUSDPrice() private view returns (uint256) {\n', '    return usdCentValue;\n', '  }\n', '\n', '  /**\n', '   * @dev Change USD price of tokens\n', '   * @param _ethPrice New Ether price\n', '   */\n', '  function updatePrice(uint256 _ethPrice) private {\n', '    uint256 centBase = 1 * 10 ** 16;\n', '    require(_ethPrice > 0);\n', '    ethPrice = _ethPrice;\n', '    usdCentValue = centBase.div(_ethPrice);\n', '  }\n', '\n', '  /**\n', '   * @dev Set USD to ETH value\n', '   * @param _ethPrice New Ether price\n', '   */\n', '  function setUsdEthValue(uint256 _ethPrice) onlyOwner external { // set the ETH value in USD\n', '    updatePrice(_ethPrice);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the crowdsale contract address\n', '   * @param _crowdSale Crowdsale contract address\n', '   */\n', '  function setCrowdSaleAddress(address _crowdSale) onlyOwner public { // set the crowdsale contract address\n', '    cSale = CrowdSale(_crowdSale);\n', '  }\n', '\n', '  /**\n', '   * @dev Set the storage contract address\n', '   * @param _investorsStorage Investors storage contract address\n', '   */\n', '  function setStorageAddress(address _investorsStorage) onlyOwner public { // set the storage contract address\n', '    investorsStorage = InvestorsStorage(_investorsStorage);\n', '  }\n', '\n', '  /**\n', '   * @dev Pause the presale\n', '   * @param _paused Paused state - true/false\n', '   */\n', '  function pausePresale(bool _paused) onlyOwner public { // pause the presale\n', '    presalePaused = _paused;\n', '  }\n', '\n', '  /**\n', '   * @dev Get funds\n', '   */\n', '  function getFunds() onlyOwner public { // request the funds\n', '    owner.transfer(address(this).balance);\n', '  }\n', '\n', '  event NewInvestment(address _investor, uint256 tokens);\n', '}']
