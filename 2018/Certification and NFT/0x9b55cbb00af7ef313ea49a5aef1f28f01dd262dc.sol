['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', 'contract BonumPreICO is Pausable{\n', '    using SafeMath for uint;\n', '\n', '    string public constant name = "Bonum PreICO";\n', '\n', '    uint public fiatValueMultiplier = 10**6;\n', '    uint public tokenDecimals = 10**18;\n', '\n', '    address public beneficiary;\n', '\n', '    uint public ethUsdRate;\n', '    uint public collected = 0;\n', '    uint public tokensSold = 0;\n', '    uint public tokensSoldWithBonus = 0;\n', '\n', '\n', '    event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);\n', '\n', '    function BonumPreICO(\n', '        address _beneficiary,\n', '        uint _baseEthUsdRate\n', '    ) public {\n', '        beneficiary = _beneficiary;\n', '\n', '        ethUsdRate = _baseEthUsdRate;\n', '    }\n', '\n', '\n', '    function setNewBeneficiary(address newBeneficiary) external onlyOwner {\n', '        require(newBeneficiary != 0x0);\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '    function setEthUsdRate(uint rate) external onlyOwner {\n', '        require(rate > 0);\n', '        ethUsdRate = rate;\n', '    }\n', '\n', '    modifier underCap(){\n', '        require(tokensSold < uint(750000).mul(tokenDecimals));\n', '        _;\n', '    }\n', '\n', '    modifier minimumAmount(){\n', '        require(msg.value.mul(ethUsdRate).div(fiatValueMultiplier.mul(1 ether)) >= 100);\n', '        _;\n', '    }\n', '\n', '    mapping (address => uint) public investors;\n', '\n', '    function() payable public whenNotPaused minimumAmount underCap{\n', '        uint tokens = msg.value.mul(ethUsdRate).div(fiatValueMultiplier);\n', '        tokensSold = tokensSold.add(tokens);\n', '        \n', '        tokens = tokens.add(tokens.mul(25).div(100));\n', '        tokensSoldWithBonus =  tokensSoldWithBonus.add(tokens);\n', '        \n', '        investors[msg.sender] = investors[msg.sender].add(tokens);\n', '        NewContribution(msg.sender, tokens, msg.value);\n', '\n', '        collected = collected.add(msg.value);\n', '\n', '        beneficiary.transfer(msg.value);\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', 'contract BonumPreICO is Pausable{\n', '    using SafeMath for uint;\n', '\n', '    string public constant name = "Bonum PreICO";\n', '\n', '    uint public fiatValueMultiplier = 10**6;\n', '    uint public tokenDecimals = 10**18;\n', '\n', '    address public beneficiary;\n', '\n', '    uint public ethUsdRate;\n', '    uint public collected = 0;\n', '    uint public tokensSold = 0;\n', '    uint public tokensSoldWithBonus = 0;\n', '\n', '\n', '    event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);\n', '\n', '    function BonumPreICO(\n', '        address _beneficiary,\n', '        uint _baseEthUsdRate\n', '    ) public {\n', '        beneficiary = _beneficiary;\n', '\n', '        ethUsdRate = _baseEthUsdRate;\n', '    }\n', '\n', '\n', '    function setNewBeneficiary(address newBeneficiary) external onlyOwner {\n', '        require(newBeneficiary != 0x0);\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '    function setEthUsdRate(uint rate) external onlyOwner {\n', '        require(rate > 0);\n', '        ethUsdRate = rate;\n', '    }\n', '\n', '    modifier underCap(){\n', '        require(tokensSold < uint(750000).mul(tokenDecimals));\n', '        _;\n', '    }\n', '\n', '    modifier minimumAmount(){\n', '        require(msg.value.mul(ethUsdRate).div(fiatValueMultiplier.mul(1 ether)) >= 100);\n', '        _;\n', '    }\n', '\n', '    mapping (address => uint) public investors;\n', '\n', '    function() payable public whenNotPaused minimumAmount underCap{\n', '        uint tokens = msg.value.mul(ethUsdRate).div(fiatValueMultiplier);\n', '        tokensSold = tokensSold.add(tokens);\n', '        \n', '        tokens = tokens.add(tokens.mul(25).div(100));\n', '        tokensSoldWithBonus =  tokensSoldWithBonus.add(tokens);\n', '        \n', '        investors[msg.sender] = investors[msg.sender].add(tokens);\n', '        NewContribution(msg.sender, tokens, msg.value);\n', '\n', '        collected = collected.add(msg.value);\n', '\n', '        beneficiary.transfer(msg.value);\n', '    }\n', '}']
