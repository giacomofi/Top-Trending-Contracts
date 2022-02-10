['pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', 'contract FundRequestPrivateSeed is Pausable {\n', '  using SafeMath for uint;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // how many token units a buyer gets per wei\n', '  uint public rate;\n', '  // amount of raised money in wei\n', '  uint public weiRaised;\n', '\n', '  mapping(address => uint) public deposits;\n', '  mapping(address => uint) public balances;\n', '  address[] public investors;\n', '  uint public investorCount;\n', '  mapping(address => bool) public allowed;\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);\n', '\n', '  function FundRequestPrivateSeed(uint _rate, address _wallet) {\n', '    require(_rate > 0);\n', '    require(_wallet != 0x0);\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable whenNotPaused {\n', '    require(validBeneficiary(beneficiary));\n', '    require(validPurchase());\n', '    require(validPurchaseSize());\n', '    bool existing = deposits[beneficiary] > 0;\n', '    uint weiAmount = msg.value;\n', '    uint updatedWeiRaised = weiRaised.add(weiAmount);\n', '    // calculate token amount to be created\n', '    uint tokens = weiAmount.mul(rate);\n', '    weiRaised = updatedWeiRaised;\n', '    deposits[beneficiary] = deposits[beneficiary].add(msg.value);\n', '    balances[beneficiary] = balances[beneficiary].add(tokens);\n', '    if(!existing) {\n', '      investors.push(beneficiary);\n', '      investorCount++;\n', '    }\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '  function validBeneficiary(address beneficiary) internal constant returns (bool) {\n', '      return allowed[beneficiary] == true;\n', '  }\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    return msg.value != 0;\n', '  }\n', '  // @return true if the amount is higher then 25ETH\n', '  function validPurchaseSize() internal constant returns (bool) {\n', '    return msg.value >=25000000000000000000;\n', '  }\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  function depositsOf(address _owner) constant returns (uint deposit) {\n', '    return deposits[_owner];\n', '  }\n', '  function allow(address beneficiary) onlyOwner {\n', '    allowed[beneficiary] = true;\n', '  }\n', '  function updateRate(uint _rate) onlyOwner whenPaused {\n', '    rate = _rate;\n', '  }\n', '\n', '  function updateWallet(address _wallet) onlyOwner whenPaused {\n', '    require(_wallet != 0x0);\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', 'contract FundRequestPrivateSeed is Pausable {\n', '  using SafeMath for uint;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '  // how many token units a buyer gets per wei\n', '  uint public rate;\n', '  // amount of raised money in wei\n', '  uint public weiRaised;\n', '\n', '  mapping(address => uint) public deposits;\n', '  mapping(address => uint) public balances;\n', '  address[] public investors;\n', '  uint public investorCount;\n', '  mapping(address => bool) public allowed;\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);\n', '\n', '  function FundRequestPrivateSeed(uint _rate, address _wallet) {\n', '    require(_rate > 0);\n', '    require(_wallet != 0x0);\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable whenNotPaused {\n', '    require(validBeneficiary(beneficiary));\n', '    require(validPurchase());\n', '    require(validPurchaseSize());\n', '    bool existing = deposits[beneficiary] > 0;\n', '    uint weiAmount = msg.value;\n', '    uint updatedWeiRaised = weiRaised.add(weiAmount);\n', '    // calculate token amount to be created\n', '    uint tokens = weiAmount.mul(rate);\n', '    weiRaised = updatedWeiRaised;\n', '    deposits[beneficiary] = deposits[beneficiary].add(msg.value);\n', '    balances[beneficiary] = balances[beneficiary].add(tokens);\n', '    if(!existing) {\n', '      investors.push(beneficiary);\n', '      investorCount++;\n', '    }\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '  function validBeneficiary(address beneficiary) internal constant returns (bool) {\n', '      return allowed[beneficiary] == true;\n', '  }\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    return msg.value != 0;\n', '  }\n', '  // @return true if the amount is higher then 25ETH\n', '  function validPurchaseSize() internal constant returns (bool) {\n', '    return msg.value >=25000000000000000000;\n', '  }\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  function depositsOf(address _owner) constant returns (uint deposit) {\n', '    return deposits[_owner];\n', '  }\n', '  function allow(address beneficiary) onlyOwner {\n', '    allowed[beneficiary] = true;\n', '  }\n', '  function updateRate(uint _rate) onlyOwner whenPaused {\n', '    rate = _rate;\n', '  }\n', '\n', '  function updateWallet(address _wallet) onlyOwner whenPaused {\n', '    require(_wallet != 0x0);\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '}']