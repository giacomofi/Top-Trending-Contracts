['pragma solidity ^0.4.18;\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract TwoXMachine is Ownable, Pausable {\n', '\n', '  // Address of the contract creator\n', '  address public contractOwner;\n', '\n', '  // FIFO queue\n', '  BuyIn[] public buyIns;\n', '\n', '  // The current BuyIn queue index\n', '  uint256 public index;\n', '\n', '  // Total invested for entire contract\n', '  uint256 public contractTotalInvested;\n', '\n', '  // Total invested for a given address\n', '  mapping (address => uint256) public totalInvested;\n', '\n', '  // Total value for a given address\n', '  mapping (address => uint256) public totalValue;\n', '\n', '  // Total paid out for a given address\n', '  mapping (address => uint256) public totalPaidOut;\n', '\n', '  struct BuyIn {\n', '    uint256 value;\n', '    address owner;\n', '  }\n', '\n', '  /**\n', '   * Fallback function to handle ethereum that was send straight to the contract\n', '   */\n', '  function() whenNotPaused() public payable {\n', '    purchase();\n', '  }\n', '\n', '  function purchase() whenNotPaused() public payable {\n', '    // I don&#39;t want no scrub\n', '    require(msg.value >= 0.01 ether);\n', '\n', '    // Take a 2% fee\n', '    uint256 value = SafeMath.div(SafeMath.mul(msg.value, 98), 100);\n', '\n', '    // HNNNNNNGGGGGG\n', '    uint256 valueMultiplied = SafeMath.div(SafeMath.mul(msg.value, 150), 100);\n', '\n', '    contractTotalInvested += msg.value;\n', '    totalInvested[msg.sender] += msg.value;\n', '\n', '    while (index < buyIns.length && value > 0) {\n', '      BuyIn storage buyIn = buyIns[index];\n', '\n', '      if (value < buyIn.value) {\n', '        buyIn.owner.transfer(value);\n', '        totalPaidOut[buyIn.owner] += value;\n', '        totalValue[buyIn.owner] -= value;\n', '        buyIn.value -= value;\n', '        value = 0;\n', '      } else {\n', '        buyIn.owner.transfer(buyIn.value);\n', '        totalPaidOut[buyIn.owner] += buyIn.value;\n', '        totalValue[buyIn.owner] -= buyIn.value;\n', '        value -= buyIn.value;\n', '        buyIn.value = 0;\n', '        index++;\n', '      }\n', '    }\n', '\n', '    // if buyins have been exhausted, return the remaining\n', '    // funds back to the investor\n', '    if (value > 0) {\n', '      msg.sender.transfer(value);\n', '      valueMultiplied -= value;\n', '      totalPaidOut[msg.sender] += value;\n', '    }\n', '\n', '    totalValue[msg.sender] += valueMultiplied;\n', '\n', '    buyIns.push(BuyIn({\n', '      value: valueMultiplied,\n', '      owner: msg.sender\n', '    }));\n', '  }\n', '\n', '  function payout() onlyOwner() public {\n', '    owner.transfer(this.balance);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract TwoXMachine is Ownable, Pausable {\n', '\n', '  // Address of the contract creator\n', '  address public contractOwner;\n', '\n', '  // FIFO queue\n', '  BuyIn[] public buyIns;\n', '\n', '  // The current BuyIn queue index\n', '  uint256 public index;\n', '\n', '  // Total invested for entire contract\n', '  uint256 public contractTotalInvested;\n', '\n', '  // Total invested for a given address\n', '  mapping (address => uint256) public totalInvested;\n', '\n', '  // Total value for a given address\n', '  mapping (address => uint256) public totalValue;\n', '\n', '  // Total paid out for a given address\n', '  mapping (address => uint256) public totalPaidOut;\n', '\n', '  struct BuyIn {\n', '    uint256 value;\n', '    address owner;\n', '  }\n', '\n', '  /**\n', '   * Fallback function to handle ethereum that was send straight to the contract\n', '   */\n', '  function() whenNotPaused() public payable {\n', '    purchase();\n', '  }\n', '\n', '  function purchase() whenNotPaused() public payable {\n', "    // I don't want no scrub\n", '    require(msg.value >= 0.01 ether);\n', '\n', '    // Take a 2% fee\n', '    uint256 value = SafeMath.div(SafeMath.mul(msg.value, 98), 100);\n', '\n', '    // HNNNNNNGGGGGG\n', '    uint256 valueMultiplied = SafeMath.div(SafeMath.mul(msg.value, 150), 100);\n', '\n', '    contractTotalInvested += msg.value;\n', '    totalInvested[msg.sender] += msg.value;\n', '\n', '    while (index < buyIns.length && value > 0) {\n', '      BuyIn storage buyIn = buyIns[index];\n', '\n', '      if (value < buyIn.value) {\n', '        buyIn.owner.transfer(value);\n', '        totalPaidOut[buyIn.owner] += value;\n', '        totalValue[buyIn.owner] -= value;\n', '        buyIn.value -= value;\n', '        value = 0;\n', '      } else {\n', '        buyIn.owner.transfer(buyIn.value);\n', '        totalPaidOut[buyIn.owner] += buyIn.value;\n', '        totalValue[buyIn.owner] -= buyIn.value;\n', '        value -= buyIn.value;\n', '        buyIn.value = 0;\n', '        index++;\n', '      }\n', '    }\n', '\n', '    // if buyins have been exhausted, return the remaining\n', '    // funds back to the investor\n', '    if (value > 0) {\n', '      msg.sender.transfer(value);\n', '      valueMultiplied -= value;\n', '      totalPaidOut[msg.sender] += value;\n', '    }\n', '\n', '    totalValue[msg.sender] += valueMultiplied;\n', '\n', '    buyIns.push(BuyIn({\n', '      value: valueMultiplied,\n', '      owner: msg.sender\n', '    }));\n', '  }\n', '\n', '  function payout() onlyOwner() public {\n', '    owner.transfer(this.balance);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
