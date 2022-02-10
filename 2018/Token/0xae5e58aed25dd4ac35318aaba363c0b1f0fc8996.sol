['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract PreSale is Pausable {\n', '    uint256 constant public INCREASE_RATE = 350000000000000; // 50c if ethereum is $700\n', '\n', '    uint256 public eggsSold = 1987;\n', '    mapping (address => uint32) public eggs;\n', '\n', '    function PreSale() payable public {\n', '    }\n', '\n', '    event EggsPurchased(address indexed purchaser, uint256 value, uint32 quantity);\n', '    \n', '    event EggsRedeemed(address indexed sender, uint256 eggs);\n', '\n', '    function bulkPurchageEgg() whenNotPaused payable public {\n', '        require(msg.value >= (eggPrice() * 5 + INCREASE_RATE * 10));\n', '        eggs[msg.sender] = eggs[msg.sender] + 5;\n', '        eggsSold = eggsSold + 5;\n', '        EggsPurchased(msg.sender, msg.value, 5);\n', '    }\n', '    \n', '    function purchaseEgg() whenNotPaused payable public {\n', '        require(msg.value >= eggPrice());\n', '\n', '        eggs[msg.sender] = eggs[msg.sender] + 1;\n', '        eggsSold = eggsSold + 1;\n', '        \n', '        EggsPurchased(msg.sender, msg.value, 1);\n', '    }\n', '    \n', '    function redeemEgg(address targetUser) onlyOwner public returns(uint256) {\n', '        require(eggs[targetUser] > 0);\n', '\n', '        EggsRedeemed(targetUser, eggs[targetUser]);\n', '\n', '        var userEggs = eggs[targetUser];\n', '        eggs[targetUser] = 0;\n', '        return userEggs;\n', '    }\n', '\n', '    function eggPrice() view public returns(uint256) {\n', '        return (eggsSold + 1) * INCREASE_RATE;\n', '    }\n', '\n', '    function withdrawal() onlyOwner public {\n', '        owner.transfer(this.balance);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract PreSale is Pausable {\n', '    uint256 constant public INCREASE_RATE = 350000000000000; // 50c if ethereum is $700\n', '\n', '    uint256 public eggsSold = 1987;\n', '    mapping (address => uint32) public eggs;\n', '\n', '    function PreSale() payable public {\n', '    }\n', '\n', '    event EggsPurchased(address indexed purchaser, uint256 value, uint32 quantity);\n', '    \n', '    event EggsRedeemed(address indexed sender, uint256 eggs);\n', '\n', '    function bulkPurchageEgg() whenNotPaused payable public {\n', '        require(msg.value >= (eggPrice() * 5 + INCREASE_RATE * 10));\n', '        eggs[msg.sender] = eggs[msg.sender] + 5;\n', '        eggsSold = eggsSold + 5;\n', '        EggsPurchased(msg.sender, msg.value, 5);\n', '    }\n', '    \n', '    function purchaseEgg() whenNotPaused payable public {\n', '        require(msg.value >= eggPrice());\n', '\n', '        eggs[msg.sender] = eggs[msg.sender] + 1;\n', '        eggsSold = eggsSold + 1;\n', '        \n', '        EggsPurchased(msg.sender, msg.value, 1);\n', '    }\n', '    \n', '    function redeemEgg(address targetUser) onlyOwner public returns(uint256) {\n', '        require(eggs[targetUser] > 0);\n', '\n', '        EggsRedeemed(targetUser, eggs[targetUser]);\n', '\n', '        var userEggs = eggs[targetUser];\n', '        eggs[targetUser] = 0;\n', '        return userEggs;\n', '    }\n', '\n', '    function eggPrice() view public returns(uint256) {\n', '        return (eggsSold + 1) * INCREASE_RATE;\n', '    }\n', '\n', '    function withdrawal() onlyOwner public {\n', '        owner.transfer(this.balance);\n', '    }\n', '}']
