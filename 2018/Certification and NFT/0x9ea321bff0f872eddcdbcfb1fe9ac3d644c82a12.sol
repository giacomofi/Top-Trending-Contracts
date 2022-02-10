['pragma solidity 0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '  uint256 private transactionNum;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '  uint256 public discountRate = 3333;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {\n', '    require(_startTime >= now);\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '\n', '    token = ERC20(_token);\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '    uint256 tokens;\n', '    if(transactionNum < 100) {\n', '      tokens = weiAmount.mul(discountRate);\n', '    } else {\n', '      tokens = weiAmount.mul(rate);\n', '    }\n', '\n', '\n', '    uint256 tokenBalance = token.balanceOf(this);\n', '    require(tokenBalance >= tokens);\n', '\n', '    transactionNum = transactionNum + 1;\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.transfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  function finalization() internal {\n', '    token.transfer(owner, token.balanceOf(this));\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract PreICO is Crowdsale {\n', '  using SafeMath for uint256;\n', '  uint256 public cap;\n', '  bool public isFinalized;\n', '\n', '  uint256 public minContribution = 100000000000000000;\n', '  uint256 public maxContribution = 1000 ether;\n', '  function PreICO(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _token) public\n', '  Crowdsale(_startTime, _endTime, _rate, _wallet, _token)\n', '  {\n', '      cap = _cap;\n', '  }\n', '\n', '  function hasEnded() public view returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return capReached || super.hasEnded();\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal view returns (bool) {\n', '    //0.1 eth and 1000 eth\n', '    bool withinRange = msg.value >= minContribution && msg.value <= maxContribution;\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return withinRange && withinCap && super.validPurchase();\n', '  }\n', '\n', '  function changeMinContribution(uint256 _minContribution) public onlyOwner {\n', '    require(_minContribution > 0);\n', '    minContribution = _minContribution;\n', '  }\n', '\n', '  function changeMaxContribution(uint256 _maxContribution) public onlyOwner {\n', '    require(_maxContribution > 0);\n', '    maxContribution = _maxContribution;\n', '  }\n', '\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '    super.finalization();\n', '    isFinalized = true;\n', '  }\n', '\n', '  function setNewWallet(address _newWallet) onlyOwner public {\n', '    wallet = _newWallet;\n', '  }\n', '\n', '}']
['pragma solidity 0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '  uint256 private transactionNum;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '  uint256 public discountRate = 3333;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {\n', '    require(_startTime >= now);\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '\n', '    token = ERC20(_token);\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '    uint256 tokens;\n', '    if(transactionNum < 100) {\n', '      tokens = weiAmount.mul(discountRate);\n', '    } else {\n', '      tokens = weiAmount.mul(rate);\n', '    }\n', '\n', '\n', '    uint256 tokenBalance = token.balanceOf(this);\n', '    require(tokenBalance >= tokens);\n', '\n', '    transactionNum = transactionNum + 1;\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.transfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  function finalization() internal {\n', '    token.transfer(owner, token.balanceOf(this));\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract PreICO is Crowdsale {\n', '  using SafeMath for uint256;\n', '  uint256 public cap;\n', '  bool public isFinalized;\n', '\n', '  uint256 public minContribution = 100000000000000000;\n', '  uint256 public maxContribution = 1000 ether;\n', '  function PreICO(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _token) public\n', '  Crowdsale(_startTime, _endTime, _rate, _wallet, _token)\n', '  {\n', '      cap = _cap;\n', '  }\n', '\n', '  function hasEnded() public view returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return capReached || super.hasEnded();\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal view returns (bool) {\n', '    //0.1 eth and 1000 eth\n', '    bool withinRange = msg.value >= minContribution && msg.value <= maxContribution;\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return withinRange && withinCap && super.validPurchase();\n', '  }\n', '\n', '  function changeMinContribution(uint256 _minContribution) public onlyOwner {\n', '    require(_minContribution > 0);\n', '    minContribution = _minContribution;\n', '  }\n', '\n', '  function changeMaxContribution(uint256 _maxContribution) public onlyOwner {\n', '    require(_maxContribution > 0);\n', '    maxContribution = _maxContribution;\n', '  }\n', '\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '    super.finalization();\n', '    isFinalized = true;\n', '  }\n', '\n', '  function setNewWallet(address _newWallet) onlyOwner public {\n', '    wallet = _newWallet;\n', '  }\n', '\n', '}']
