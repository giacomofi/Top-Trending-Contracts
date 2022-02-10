['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override \n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropiate to concatenate\n', ' * behavior.\n', ' */\n', '\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // How many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  /**\n', '   * @param _rate Number of token units a buyer gets per wei\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(_beneficiary, tokens);\n', '    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(rate);\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol\n', '\n', '/**\n', ' * @title AllowanceCrowdsale\n', ' * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.\n', ' */\n', 'contract AllowanceCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  address public tokenWallet;\n', '\n', '  /**\n', '   * @dev Constructor, takes token wallet address. \n', '   * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale\n', '   */\n', '  function AllowanceCrowdsale(address _tokenWallet) public {\n', '    require(_tokenWallet != address(0));\n', '    tokenWallet = _tokenWallet;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks the amount of tokens left in the allowance.\n', '   * @return Amount of tokens left in the allowance\n', '   */\n', '  function remainingTokens() public view returns (uint256) {\n', '    return token.allowance(tokenWallet, this);\n', '  }\n', '\n', '  /**\n', '   * @dev Overrides parent behavior by transferring tokens from wallet.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _tokenAmount Amount of tokens purchased\n', '   */\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol\n', '\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Crowdsale with a limit for total contributions.\n', ' */\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  /**\n', '   * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.\n', '   * @param _cap Max amount of wei to be contributed\n', '   */\n', '  function CappedCrowdsale(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the cap has been reached. \n', '   * @return Whether the cap was reached\n', '   */\n', '  function capReached() public view returns (bool) {\n', '    return weiRaised >= cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring purchase to respect the funding cap.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(weiRaised.add(_weiAmount) <= cap);\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol\n', '\n', '/**\n', ' * @title IndividuallyCappedCrowdsale\n', ' * @dev Crowdsale with per-user caps.\n', ' */\n', 'contract IndividuallyCappedCrowdsale is Crowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public contributions;\n', '  mapping(address => uint256) public caps;\n', '\n', '  /**\n', '   * @dev Sets a specific user&#39;s maximum contribution.\n', '   * @param _beneficiary Address to be capped\n', '   * @param _cap Wei limit for individual contribution\n', '   */\n', '  function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {\n', '    caps[_beneficiary] = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets a group of users&#39; maximum contribution.\n', '   * @param _beneficiaries List of addresses to be capped\n', '   * @param _cap Wei limit for individual contribution\n', '   */\n', '  function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner {\n', '    for (uint256 i = 0; i < _beneficiaries.length; i++) {\n', '      caps[_beneficiaries[i]] = _cap;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the cap of a specific user.\n', '   * @param _beneficiary Address whose cap is to be checked\n', '   * @return Current cap for individual user\n', '   */\n', '  function getUserCap(address _beneficiary) public view returns (uint256) {\n', '    return caps[_beneficiary];\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the amount contributed so far by a sepecific user.\n', '   * @param _beneficiary Address of contributor\n', '   * @return User contribution so far\n', '   */\n', '  function getUserContribution(address _beneficiary) public view returns (uint256) {\n', '    return contributions[_beneficiary];\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior requiring purchase to respect the user&#39;s funding cap.\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior to update user contributions\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '    super._updatePurchasingState(_beneficiary, _weiAmount);\n', '    contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol\n', '\n', '/**\n', ' * @title TimedCrowdsale\n', ' * @dev Crowdsale accepting contributions only within a time frame.\n', ' */\n', 'contract TimedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public openingTime;\n', '  uint256 public closingTime;\n', '\n', '  /**\n', '   * @dev Reverts if not in crowdsale time range. \n', '   */\n', '  modifier onlyWhileOpen {\n', '    require(now >= openingTime && now <= closingTime);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Constructor, takes crowdsale opening and closing times.\n', '   * @param _openingTime Crowdsale opening time\n', '   * @param _closingTime Crowdsale closing time\n', '   */\n', '  function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {\n', '    require(_openingTime >= now);\n', '    require(_closingTime >= _openingTime);\n', '\n', '    openingTime = _openingTime;\n', '    closingTime = _closingTime;\n', '  }\n', '\n', '  /**\n', '   * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '   * @return Whether crowdsale period has elapsed\n', '   */\n', '  function hasClosed() public view returns (bool) {\n', '    return now > closingTime;\n', '  }\n', '  \n', '  /**\n', '   * @dev Extend parent behavior requiring to be within contributing period\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/CarboneumCrowdsale.sol\n', '\n', '/**\n', ' * @title CarboneumCrowdsale\n', ' * @dev This is Carboneum fully fledged crowdsale.\n', ' * CappedCrowdsale - sets a max boundary for raised funds.\n', ' * AllowanceCrowdsale - token held by a wallet.\n', ' * IndividuallyCappedCrowdsale - Crowdsale with per-user caps.\n', ' * TimedCrowdsale - Crowdsale accepting contributions only within a time frame.\n', ' */\n', 'contract CarboneumCrowdsale is CappedCrowdsale, AllowanceCrowdsale, IndividuallyCappedCrowdsale, TimedCrowdsale {\n', '\n', '  uint256 public pre_sale_end;\n', '\n', '  function CarboneumCrowdsale(\n', '    uint256 _openingTime,\n', '    uint256 _closingTime,\n', '    uint256 _rate,\n', '    address _tokenWallet,\n', '    address _fundWallet,\n', '    uint256 _cap,\n', '    ERC20 _token,\n', '    uint256 _preSaleEnd) public\n', '  AllowanceCrowdsale(_tokenWallet)\n', '  Crowdsale(_rate, _fundWallet, _token)\n', '  CappedCrowdsale(_cap)\n', '  TimedCrowdsale(_openingTime, _closingTime)\n', '  {\n', '    require(_preSaleEnd < _closingTime);\n', '    pre_sale_end = _preSaleEnd;\n', '  }\n', '\n', '  function setRate(uint256 _rate) external onlyOwner {\n', '    rate = _rate;\n', '  }\n', '\n', '  function getRate() public view returns (uint256) {\n', '    return rate;\n', '  }\n', '\n', '  /**\n', '   * @dev Add bonus to pre-sale period.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    uint256 newRate = rate;\n', '    if (now < pre_sale_end) {// solium-disable-line security/no-block-members\n', '      // Bonus 8%\n', '      newRate += rate * 8 / 100;\n', '    }\n', '    return _weiAmount.mul(newRate);\n', '  }\n', '\n', '}']