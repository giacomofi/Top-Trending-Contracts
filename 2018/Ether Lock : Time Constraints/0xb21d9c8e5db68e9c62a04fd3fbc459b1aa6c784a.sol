['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function balanceOf(address who) public view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overridden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', " * the methods to add functionality. Consider using 'super' where appropriate to concatenate\n", ' * behavior.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  Token public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // How many usd per 10000 tokens.\n', '  uint256 public rate = 7142;\n', '\n', '  // usd cents per 1 ETH\n', '  uint256 public ethRate = 27500;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  // Seconds in a week\n', '  uint256 public week = 604800;\n', '\n', '  // ICO start time\n', '  uint256 public icoStartTime;\n', '\n', '  // bonuses in %\n', '  uint256 public privateIcoBonus = 50;\n', '  uint256 public preIcoBonus = 30;\n', '  uint256 public ico1Bonus = 15;\n', '  uint256 public ico2Bonus = 10;\n', '  uint256 public ico3Bonus = 5;\n', '  uint256 public ico4Bonus = 0;\n', '\n', '  // min contribution in wei\n', '  uint256 public privateIcoMin = 1 ether;\n', '  uint256 public preIcoMin = 1 ether;\n', '  uint256 public ico1Min = 1 ether;\n', '  uint256 public ico2Min = 1 ether;\n', '  uint256 public ico3Min = 1 ether;\n', '  uint256 public ico4Min = 1 ether; \n', '\n', '  // max contribution in wei\n', '  uint256 public privateIcoMax = 350 ether;\n', '  uint256 public preIcoMax = 10000 ether;\n', '  uint256 public ico1Max = 10000 ether;\n', '  uint256 public ico2Max = 10000 ether;\n', '  uint256 public ico3Max = 10000 ether;\n', '  uint256 public ico4Max = 10000 ether;\n', '\n', '\n', '  // hardcaps in tokens\n', '  uint256 public privateIcoCap = uint256(322532).mul(1e8);\n', '  uint256 public preIcoCap = uint256(8094791).mul(1e8);\n', '  uint256 public ico1Cap = uint256(28643106).mul(1e8);\n', '  uint256 public ico2Cap = uint256(17123596).mul(1e8);\n', '  uint256 public ico3Cap = uint256(9807150).mul(1e8);\n', '  uint256 public ico4Cap = uint256(6008825).mul(1e8);\n', '\n', '  // tokens sold\n', '  uint256 public privateIcoSold;\n', '  uint256 public preIcoSold;\n', '  uint256 public ico1Sold;\n', '  uint256 public ico2Sold;\n', '  uint256 public ico3Sold;\n', '  uint256 public ico4Sold;\n', '\n', '  //whitelist\n', '  mapping(address => bool) public whitelist; \n', '  //whitelisters addresses\n', '  mapping(address => bool) public whitelisters;\n', '\n', '  modifier isWhitelister() {\n', '    require(whitelisters[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  modifier isWhitelisted() {\n', '    require(whitelist[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  // Sale stages\n', '  enum Stages {Pause, PrivateIco, PrivateIcoEnd, PreIco, PreIcoEnd, Ico1, Ico2, Ico3, Ico4, IcoEnd}\n', '\n', '  Stages currentStage;\n', '\n', '  /**\n', '   * Event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(\n', '    address indexed purchaser,\n', '    address indexed beneficiary,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  /** Event emitted when _account is Whitelisted / UnWhitelisted */\n', '  event WhitelistUpdated(address indexed _account, uint8 _phase);\n', '\n', '  /**\n', '   * @param _wallet Address where collected funds will be forwarded to\n', '   * @param _token Address of the token being sold\n', '   */\n', '  constructor(address _newOwner, address _wallet, Token _token) public {\n', '    require(_newOwner != address(0));\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    owner = _newOwner;\n', '    wallet = _wallet;\n', '    token = _token;\n', '\n', '    currentStage = Stages.Pause;\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev sale stage start\n', '   */\n', '\n', '  function startPrivateIco() public onlyOwner returns (bool) {\n', '    require(currentStage == Stages.Pause);\n', '    currentStage = Stages.PrivateIco;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev sale stage end\n', '   */\n', '\n', '  function endPrivateIco() public onlyOwner returns (bool) {\n', '    require(currentStage == Stages.PrivateIco);\n', '    currentStage = Stages.PrivateIcoEnd;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev sale stage start\n', '   */\n', '\n', '  function startPreIco() public onlyOwner returns (bool) {\n', '    require(currentStage == Stages.PrivateIcoEnd);\n', '    currentStage = Stages.PreIco;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev sale stage end\n', '   */\n', '\n', '  function endPreIco() public onlyOwner returns (bool) {\n', '    require(currentStage == Stages.PreIco);\n', '    currentStage = Stages.PreIcoEnd;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev sale stage start\n', '   */\n', '\n', '  function startIco() public onlyOwner returns (bool) {\n', '    require(currentStage == Stages.PreIcoEnd);\n', '    currentStage = Stages.Ico1;\n', '    icoStartTime = now;\n', '    return true;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev getting stage index (private ICO = 1, pre ICO = 2, ICO = 3, pause = 0, end = 9)\n', '   */\n', '\n', '  function getStageName () public view returns (string) {\n', "    if (currentStage == Stages.Pause) return 'Pause';\n", "    if (currentStage == Stages.PrivateIco) return 'Private ICO';\n", "    if (currentStage == Stages.PrivateIcoEnd) return 'Private ICO end';\n", "    if (currentStage == Stages.PreIco) return 'Prte ICO';\n", "    if (currentStage == Stages.PreIcoEnd) return 'Pre ICO end';\n", "    if (currentStage == Stages.Ico1) return 'ICO 1-st week';\n", "    if (currentStage == Stages.Ico2) return 'ICO 2-d week';\n", "    if (currentStage == Stages.Ico3) return 'ICO 3-d week';\n", "    if (currentStage == Stages.Ico4) return 'ICO 4-th week';\n", "    return 'ICO is over';\n", '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable isWhitelisted {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    uint256 time;\n', '    uint256 weeksPassed;\n', '\n', '    require(currentStage != Stages.Pause);\n', '    require(currentStage != Stages.PrivateIcoEnd);\n', '    require(currentStage != Stages.PreIcoEnd);\n', '    require(currentStage != Stages.IcoEnd);\n', '\n', '    if (currentStage == Stages.Ico1 || currentStage == Stages.Ico2 || currentStage == Stages.Ico3 || currentStage == Stages.Ico4) {\n', '      time = now.sub(icoStartTime);\n', '      weeksPassed = time.div(week);\n', '\n', '      if (currentStage == Stages.Ico1) {\n', '        if (weeksPassed == 1) currentStage = Stages.Ico2;\n', '        else if (weeksPassed == 2) currentStage = Stages.Ico3;\n', '        else if (weeksPassed == 3) currentStage = Stages.Ico4;\n', '        else if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      } else if (currentStage == Stages.Ico2) {\n', '        if (weeksPassed == 2) currentStage = Stages.Ico3;\n', '        else if (weeksPassed == 3) currentStage = Stages.Ico4;\n', '        else if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      } else if (currentStage == Stages.Ico3) {\n', '        if (weeksPassed == 3) currentStage = Stages.Ico4;\n', '        else if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      } else if (currentStage == Stages.Ico4) {\n', '        if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      }\n', '    }\n', '\n', '    if (currentStage != Stages.IcoEnd) {\n', '      _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '      // calculate token amount to be created\n', '      uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '      // update state\n', '      weiRaised = weiRaised.add(weiAmount);\n', '\n', '      if (currentStage == Stages.PrivateIco) privateIcoSold = privateIcoSold.add(tokens);\n', '      if (currentStage == Stages.PreIco) preIcoSold = preIcoSold.add(tokens);\n', '      if (currentStage == Stages.Ico1) ico1Sold = ico1Sold.add(tokens);\n', '      if (currentStage == Stages.Ico2) ico2Sold = ico2Sold.add(tokens);\n', '      if (currentStage == Stages.Ico3) ico3Sold = ico3Sold.add(tokens);\n', '      if (currentStage == Stages.Ico4) ico4Sold = ico4Sold.add(tokens);\n', '\n', '      _processPurchase(_beneficiary, tokens);\n', '      emit TokenPurchase(\n', '        msg.sender,\n', '        _beneficiary,\n', '        weiAmount,\n', '        tokens\n', '      );\n', '\n', '      _forwardFunds();\n', '    } else {\n', '      msg.sender.transfer(msg.value);\n', '    }\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.\n', "   * Example from CappedCrowdsale.sol's _preValidatePurchase method: \n", '   *   super._preValidatePurchase(_beneficiary, _weiAmount);\n', '   *   require(weiRaised.add(_weiAmount) <= cap);\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal view\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '\n', '    if (currentStage == Stages.PrivateIco) {\n', '      require(_weiAmount >= privateIcoMin);\n', '      require(_weiAmount <= privateIcoMax);\n', '    } else if (currentStage == Stages.PreIco) {\n', '      require(_weiAmount >= preIcoMin);\n', '      require(_weiAmount <= preIcoMax);\n', '    } else if (currentStage == Stages.Ico1) {\n', '      require(_weiAmount >= ico1Min);\n', '      require(_weiAmount <= ico1Max);\n', '    } else if (currentStage == Stages.Ico2) {\n', '      require(_weiAmount >= ico2Min);\n', '      require(_weiAmount <= ico2Max);\n', '    } else if (currentStage == Stages.Ico3) {\n', '      require(_weiAmount >= ico3Min);\n', '      require(_weiAmount <= ico3Max);\n', '    } else if (currentStage == Stages.Ico4) {\n', '      require(_weiAmount >= ico4Min);\n', '      require(_weiAmount <= ico4Max);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    require(token.transfer(_beneficiary, _tokenAmount));\n', '  }\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount)\n', '    internal view returns (uint256)\n', '  {\n', '    uint256 bonus;\n', '    uint256 cap;\n', '\n', '    if (currentStage == Stages.PrivateIco) {\n', '      bonus = privateIcoBonus;\n', '      cap = privateIcoCap.sub(privateIcoSold);\n', '    } else if (currentStage == Stages.PreIco) {\n', '      bonus = preIcoBonus;\n', '      cap = preIcoCap.sub(preIcoSold);\n', '    } else if (currentStage == Stages.Ico1) {\n', '      bonus = ico1Bonus;\n', '      cap = ico1Cap.sub(ico1Sold);\n', '    } else if (currentStage == Stages.Ico2) {\n', '      bonus = ico2Bonus;\n', '      cap = ico2Cap.sub(ico2Sold);\n', '    } else if (currentStage == Stages.Ico3) {\n', '      bonus = ico3Bonus;\n', '      cap = ico3Cap.sub(ico3Sold);\n', '    } else if (currentStage == Stages.Ico4) {\n', '      bonus = ico4Bonus;\n', '      cap = ico4Cap.sub(ico4Sold);\n', '    }\n', '    uint256 tokenAmount = _weiAmount.mul(ethRate).div(rate).div(1e8);\n', '    uint256 bonusTokens = tokenAmount.mul(bonus).div(100);\n', '    tokenAmount = tokenAmount.add(bonusTokens);\n', '\n', '    require(tokenAmount <= cap);\n', '    return tokenAmount;\n', '  }\n', '\n', '  /**\n', '   * @dev Determines how ETH is stored/forwarded on purchases.\n', '   */\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  function withdrawTokens() public onlyOwner returns (bool) {\n', '    uint256 time;\n', '    uint256 weeksPassed;\n', '\n', '    if (currentStage == Stages.Ico1 || currentStage == Stages.Ico2 || currentStage == Stages.Ico3 || currentStage == Stages.Ico4) {\n', '      time = now.sub(icoStartTime);\n', '      weeksPassed = time.div(week);\n', '\n', '      if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '    }\n', '    require(currentStage == Stages.IcoEnd);\n', '\n', '    uint256 balance = token.balanceOf(address(this));\n', '    if (balance > 0) {\n', '      require(token.transfer(owner, balance));\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Direct tokens sending\n', '   * @param _to address\n', '   * @param _amount tokens amount\n', '   */\n', '  function SendTokens(address _to, uint256 _amount) public onlyOwner returns (bool) {\n', '    uint256 time;\n', '    uint256 weeksPassed;\n', '\n', '    require(_to != address(0));\n', '    require(currentStage != Stages.Pause);\n', '    require(currentStage != Stages.PrivateIcoEnd);\n', '    require(currentStage != Stages.PreIcoEnd);\n', '    require(currentStage != Stages.IcoEnd);\n', '\n', '    if (currentStage == Stages.Ico1 || currentStage == Stages.Ico2 || currentStage == Stages.Ico3 || currentStage == Stages.Ico4) {\n', '      time = now.sub(icoStartTime);\n', '      weeksPassed = time.div(week);\n', '\n', '      if (currentStage == Stages.Ico1) {\n', '        if (weeksPassed == 1) currentStage = Stages.Ico2;\n', '        else if (weeksPassed == 2) currentStage = Stages.Ico3;\n', '        else if (weeksPassed == 3) currentStage = Stages.Ico4;\n', '        else if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      } else if (currentStage == Stages.Ico2) {\n', '        if (weeksPassed == 2) currentStage = Stages.Ico3;\n', '        else if (weeksPassed == 3) currentStage = Stages.Ico4;\n', '        else if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      } else if (currentStage == Stages.Ico3) {\n', '        if (weeksPassed == 3) currentStage = Stages.Ico4;\n', '        else if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      } else if (currentStage == Stages.Ico4) {\n', '        if (weeksPassed > 3) currentStage = Stages.IcoEnd;\n', '      }\n', '    }\n', '\n', '    if (currentStage != Stages.IcoEnd) {\n', '      uint256 cap;\n', '      if (currentStage == Stages.PrivateIco) {\n', '        cap = privateIcoCap.sub(privateIcoSold);\n', '      } else if (currentStage == Stages.PreIco) {\n', '        cap = preIcoCap.sub(preIcoSold);\n', '      } else if (currentStage == Stages.Ico1) {\n', '        cap = ico1Cap.sub(ico1Sold);\n', '      } else if (currentStage == Stages.Ico2) {\n', '        cap = ico2Cap.sub(ico2Sold);\n', '      } else if (currentStage == Stages.Ico3) {\n', '        cap = ico3Cap.sub(ico3Sold);\n', '      } else if (currentStage == Stages.Ico4) {\n', '        cap = ico4Cap.sub(ico4Sold);\n', '      }\n', '\n', '      require(_amount <= cap);\n', '\n', '      if (currentStage == Stages.PrivateIco) privateIcoSold = privateIcoSold.add(_amount);\n', '      if (currentStage == Stages.PreIco) preIcoSold = preIcoSold.add(_amount);\n', '      if (currentStage == Stages.Ico1) ico1Sold = ico1Sold.add(_amount);\n', '      if (currentStage == Stages.Ico2) ico2Sold = ico2Sold.add(_amount);\n', '      if (currentStage == Stages.Ico3) ico3Sold = ico3Sold.add(_amount);\n', '      if (currentStage == Stages.Ico4) ico4Sold = ico4Sold.add(_amount);\n', '    } else {\n', '      return false;\n', '    }\n', '    require(token.transfer(_to, _amount));\n', '  }\n', '\n', '    /// @dev Adds account addresses to whitelist.\n', '    /// @param _account address.\n', '    /// @param _phase 1 to add, 0 to remove.\n', '    function updateWhitelist (address _account, uint8 _phase) external isWhitelister returns (bool) {\n', '      require(_account != address(0));\n', '      require(_phase <= 1);\n', '      if (_phase == 1) whitelist[_account] = true;\n', '      else whitelist[_account] = false;\n', '      emit WhitelistUpdated(_account, _phase);\n', '      return true;\n', '    }\n', '\n', '    /// @dev Adds new whitelister\n', '    /// @param _address new whitelister address.\n', '    function addWhitelister (address _address) public onlyOwner returns (bool) {\n', '      whitelisters[_address] = true;\n', '      return true;\n', '    }\n', '\n', '    /// @dev Removes whitelister\n', '    /// @param _address address to remove.\n', '    function removeWhitelister (address _address) public onlyOwner returns (bool) {\n', '      whitelisters[_address] = false;\n', '      return true;\n', '    }\n', '\n', '    function setUsdRate (uint256 _usdCents) public onlyOwner returns (bool) {\n', '      ethRate = _usdCents;\n', '      return true;\n', '    }\n', '}']