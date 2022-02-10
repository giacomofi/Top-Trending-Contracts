['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev API interface for interacting with the WILD Token contract \n', ' */\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value) returns (bool);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', 'contract UVDICO is Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  Token token;\n', '\n', '  uint256 public constant RATE = 192000; // Number of tokens per Ether with 20% bonus\n', '  uint256 public constant CAP = 9375; // Cap in Ether\n', '  uint256 public constant BONUS = 20; // 20% bonus \n', '  uint256 public constant START = 1525694400; // start date in epoch timestamp 7 may 2018 12:00:00 utc\n', '  uint256 public constant DAYS = 7; // 7 days for round 1 with 20% bonus\n', '  uint256 public constant initialTokens =  1800000000 * 10**18; // Initial number of tokens available\n', '  bool public initialized = false;\n', '  uint256 public raisedAmount = 0;\n', '  \n', '  mapping (address => uint256) buyers;\n', '\n', '  event BoughtTokens(address indexed to, uint256 value);\n', '\n', '  modifier whenSaleIsActive() {\n', '    // Check if sale is active\n', '    assert(isActive());\n', '\n', '    _;\n', '  }\n', '\n', '  function UVDICO() {\n', '      \n', '      \n', '      token = Token(0x81401e46e82c2e1da6ba0bc446fc710a147d374f);\n', '  }\n', '  \n', '  function initialize() onlyOwner {\n', '      require(initialized == false); // Can only be initialized once\n', '      require(tokensAvailable() == initialTokens); // Must have enough tokens allocated\n', '      initialized = true;\n', '  }\n', '\n', '  function isActive() constant returns (bool) {\n', '    return (\n', '        initialized == true &&\n', '        now >= START && // Must be after the START date\n', '        now <= START.add(DAYS * 1 days) && // Must be before the end date\n', '        goalReached() == false // Goal must not already be reached\n', '    );\n', '  }\n', '\n', '  function goalReached() constant returns (bool) {\n', '    return (raisedAmount >= CAP * 1 ether);\n', '  }\n', '\n', '  function () payable {\n', '    buyTokens();\n', '  }\n', '\n', '  /**\n', '  * @dev function that sells available tokens\n', '  */\n', '  function buyTokens() payable whenSaleIsActive {\n', '    // Calculate tokens to sell\n', '    uint256 weiAmount = msg.value;\n', '    uint256 tokens = weiAmount.mul(RATE);\n', '\n', '    BoughtTokens(msg.sender, tokens);\n', '\n', '    // Increment raised amount\n', '    raisedAmount = raisedAmount.add(msg.value);\n', '    \n', '    // Send tokens to buyer\n', '    token.transfer(msg.sender, tokens);\n', '    \n', '    // Send money to owner\n', '    owner.transfer(msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev returns the number of tokens allocated to this contract\n', '   */\n', '  function tokensAvailable() constant returns (uint256) {\n', '    return token.balanceOf(this);\n', '  }\n', '\n', '  /**\n', '   * @notice Terminate contract and refund to owner\n', '   */\n', '  function destroy() onlyOwner {\n', '    // Transfer tokens back to owner\n', '    uint256 balance = token.balanceOf(this);\n', '    assert(balance > 0);\n', '    token.transfer(owner, balance);\n', '\n', '    // There should be no ether in the contract but just in case\n', '    selfdestruct(owner);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev API interface for interacting with the WILD Token contract \n', ' */\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value) returns (bool);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', 'contract UVDICO is Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  Token token;\n', '\n', '  uint256 public constant RATE = 192000; // Number of tokens per Ether with 20% bonus\n', '  uint256 public constant CAP = 9375; // Cap in Ether\n', '  uint256 public constant BONUS = 20; // 20% bonus \n', '  uint256 public constant START = 1525694400; // start date in epoch timestamp 7 may 2018 12:00:00 utc\n', '  uint256 public constant DAYS = 7; // 7 days for round 1 with 20% bonus\n', '  uint256 public constant initialTokens =  1800000000 * 10**18; // Initial number of tokens available\n', '  bool public initialized = false;\n', '  uint256 public raisedAmount = 0;\n', '  \n', '  mapping (address => uint256) buyers;\n', '\n', '  event BoughtTokens(address indexed to, uint256 value);\n', '\n', '  modifier whenSaleIsActive() {\n', '    // Check if sale is active\n', '    assert(isActive());\n', '\n', '    _;\n', '  }\n', '\n', '  function UVDICO() {\n', '      \n', '      \n', '      token = Token(0x81401e46e82c2e1da6ba0bc446fc710a147d374f);\n', '  }\n', '  \n', '  function initialize() onlyOwner {\n', '      require(initialized == false); // Can only be initialized once\n', '      require(tokensAvailable() == initialTokens); // Must have enough tokens allocated\n', '      initialized = true;\n', '  }\n', '\n', '  function isActive() constant returns (bool) {\n', '    return (\n', '        initialized == true &&\n', '        now >= START && // Must be after the START date\n', '        now <= START.add(DAYS * 1 days) && // Must be before the end date\n', '        goalReached() == false // Goal must not already be reached\n', '    );\n', '  }\n', '\n', '  function goalReached() constant returns (bool) {\n', '    return (raisedAmount >= CAP * 1 ether);\n', '  }\n', '\n', '  function () payable {\n', '    buyTokens();\n', '  }\n', '\n', '  /**\n', '  * @dev function that sells available tokens\n', '  */\n', '  function buyTokens() payable whenSaleIsActive {\n', '    // Calculate tokens to sell\n', '    uint256 weiAmount = msg.value;\n', '    uint256 tokens = weiAmount.mul(RATE);\n', '\n', '    BoughtTokens(msg.sender, tokens);\n', '\n', '    // Increment raised amount\n', '    raisedAmount = raisedAmount.add(msg.value);\n', '    \n', '    // Send tokens to buyer\n', '    token.transfer(msg.sender, tokens);\n', '    \n', '    // Send money to owner\n', '    owner.transfer(msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev returns the number of tokens allocated to this contract\n', '   */\n', '  function tokensAvailable() constant returns (uint256) {\n', '    return token.balanceOf(this);\n', '  }\n', '\n', '  /**\n', '   * @notice Terminate contract and refund to owner\n', '   */\n', '  function destroy() onlyOwner {\n', '    // Transfer tokens back to owner\n', '    uint256 balance = token.balanceOf(this);\n', '    assert(balance > 0);\n', '    token.transfer(owner, balance);\n', '\n', '    // There should be no ether in the contract but just in case\n', '    selfdestruct(owner);\n', '  }\n', '\n', '}']
