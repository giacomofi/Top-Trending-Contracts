['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract RealEstateCryptoFund {\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function balanceOf(address who) public constant returns (uint256);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract RECFCO is Ownable {\n', '  \n', '  using SafeMath for uint256;\n', '\n', '  RealEstateCryptoFund public token;\n', '\n', '  mapping(address=>bool) public participated;\n', '   \n', '   \n', '   // address where funds are collected\n', '  address public wallet;\n', '  \n', '  //address public token_wallet;\n', '  \n', '  //date stop crodwsale\n', '  uint256 public  salesdeadline;\n', '\n', '  // how many token units a buyer gets per wei (for < 1ETH purchases)\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  \n', ' event sales_deadlineUpdated(uint256 sales_deadline );// volessimo allungare il contratto di sale \n', ' event WalletUpdated(address wallet);\n', ' event RateUpdate(uint256 rate);\n', ' //event tokenWalletUpdated(address token_wallet);\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function RECFCO(address _tokenAddress, address _wallet) public {\n', '    token = RealEstateCryptoFund(_tokenAddress);\n', '    wallet = _wallet;\n', '  }\n', '\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', ' \n', '\n', '  \n', '\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(now < salesdeadline);\n', '    require(beneficiary != address(0));\n', '    require(msg.value != 0);\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    uint256 tokens = getTokenAmount( weiAmount);\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.transfer(beneficiary, tokens);\n', '\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      beneficiary,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    participated[beneficiary] = true;\n', '\n', '    forwardFunds();\n', '  }\n', '\n', ' \n', '\n', 'function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {\n', '    uint256 tokenAmount;\n', '    tokenAmount = weiAmount.mul(rate);\n', '    return tokenAmount;\n', '  }\n', '\n', '  \n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '      \n', '  }\n', ' \n', 'function setRate(uint256 _rate) public onlyOwner {\n', '    require(_rate > 0);\n', '    rate = _rate;\n', '    emit RateUpdate(rate);\n', '}\n', '\n', '//wallet update\n', 'function setWallet (address _wallet) onlyOwner public {\n', 'wallet=_wallet;\n', 'emit WalletUpdated(wallet);\n', '}\n', '\n', '//SALES_DEADLINE update\n', 'function setsalesdeadline (uint256 _salesdeadline) onlyOwner public {\n', 'salesdeadline=_salesdeadline;\n', 'require(now < salesdeadline);\n', 'emit sales_deadlineUpdated(salesdeadline);\n', '}\n', '    \n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract RealEstateCryptoFund {\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function balanceOf(address who) public constant returns (uint256);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'contract RECFCO is Ownable {\n', '  \n', '  using SafeMath for uint256;\n', '\n', '  RealEstateCryptoFund public token;\n', '\n', '  mapping(address=>bool) public participated;\n', '   \n', '   \n', '   // address where funds are collected\n', '  address public wallet;\n', '  \n', '  //address public token_wallet;\n', '  \n', '  //date stop crodwsale\n', '  uint256 public  salesdeadline;\n', '\n', '  // how many token units a buyer gets per wei (for < 1ETH purchases)\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  \n', ' event sales_deadlineUpdated(uint256 sales_deadline );// volessimo allungare il contratto di sale \n', ' event WalletUpdated(address wallet);\n', ' event RateUpdate(uint256 rate);\n', ' //event tokenWalletUpdated(address token_wallet);\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function RECFCO(address _tokenAddress, address _wallet) public {\n', '    token = RealEstateCryptoFund(_tokenAddress);\n', '    wallet = _wallet;\n', '  }\n', '\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', ' \n', '\n', '  \n', '\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(now < salesdeadline);\n', '    require(beneficiary != address(0));\n', '    require(msg.value != 0);\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    uint256 tokens = getTokenAmount( weiAmount);\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.transfer(beneficiary, tokens);\n', '\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      beneficiary,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    participated[beneficiary] = true;\n', '\n', '    forwardFunds();\n', '  }\n', '\n', ' \n', '\n', 'function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {\n', '    uint256 tokenAmount;\n', '    tokenAmount = weiAmount.mul(rate);\n', '    return tokenAmount;\n', '  }\n', '\n', '  \n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '      \n', '  }\n', ' \n', 'function setRate(uint256 _rate) public onlyOwner {\n', '    require(_rate > 0);\n', '    rate = _rate;\n', '    emit RateUpdate(rate);\n', '}\n', '\n', '//wallet update\n', 'function setWallet (address _wallet) onlyOwner public {\n', 'wallet=_wallet;\n', 'emit WalletUpdated(wallet);\n', '}\n', '\n', '//SALES_DEADLINE update\n', 'function setsalesdeadline (uint256 _salesdeadline) onlyOwner public {\n', 'salesdeadline=_salesdeadline;\n', 'require(now < salesdeadline);\n', 'emit sales_deadlineUpdated(salesdeadline);\n', '}\n', '    \n', '\n', '}']
