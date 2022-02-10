['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev cutdown simply to allow removal of tokens sent to contract\n', ' */\n', 'contract ERC20 {\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '// 200 000 000 ether = A56FA5B99019A5C8000000 = 88 bits. We have 256.\n', '// we do NOT need safemath.\n', '\n', 'contract SimpleSale is Ownable,Pausable {\n', '\n', '    address public multisig = 0xc862705dDA23A2BAB54a6444B08a397CD4DfCD1c;\n', '    address public cs;\n', '    uint256 public totalCollected;\n', '    bool    public saleFinished;\n', '    bool    public freeForAll = true;\n', '    uint256 public startTime = 1505998800;\n', '    uint256 public stopTime = 1508590800;\n', '\n', '    mapping (address => uint256) public deposits;\n', '    mapping (address => bool) public authorised; // just to annoy the heck out of americans\n', '\n', '    /**\n', '     * @dev throws if person sending is not contract owner or cs role\n', '     */\n', '    modifier onlyCSorOwner() {\n', '        require((msg.sender == owner) || (msg.sender==cs));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev throws if person sending is not authorised or sends nothing\n', '     */\n', '    modifier onlyAuthorised() {\n', '        require (authorised[msg.sender] || freeForAll);\n', '        require (msg.value > 0);\n', '        require (now >= startTime);\n', '        require (now <= stopTime);\n', '        require (!saleFinished);\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev set start and stop times\n', '     */\n', '    function setPeriod(uint256 start, uint256 stop) onlyOwner {\n', '        startTime = start;\n', '        stopTime = stop;\n', '    }\n', '    \n', '    /**\n', '     * @dev authorise an account to participate\n', '     */\n', '    function authoriseAccount(address whom) onlyCSorOwner {\n', '        authorised[whom] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev authorise a lot of accounts in one go\n', '     */\n', '    function authoriseManyAccounts(address[] many) onlyCSorOwner {\n', '        for (uint256 i = 0; i < many.length; i++) {\n', '            authorised[many[i]] = true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev ban an account from participation (default)\n', '     */\n', '    function blockAccount(address whom) onlyCSorOwner {\n', '        authorised[whom] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev set a new CS representative\n', '     */\n', '    function setCS(address newCS) onlyOwner {\n', '        cs = newCS;\n', '    }\n', '    \n', '    function requireAuthorisation(bool state) {\n', '        freeForAll = !state;\n', '    }\n', '\n', '    /**\n', '     * @dev call an end (e.g. because cap reached)\n', '     */\n', '    function stopSale() onlyOwner {\n', '        saleFinished = true;\n', '    }\n', '    \n', '\n', '    /**\n', '     * @dev fallback function received ether, sends it to the multisig, notes indivdual and group contributions\n', '     */\n', '    function () payable onlyAuthorised {\n', '        multisig.transfer(msg.value);\n', '        deposits[msg.sender] += msg.value;\n', '        totalCollected += msg.value;\n', '    }\n', '\n', '    /**\n', '     * @dev in case somebody sends ERC2o tokens...\n', '     */\n', '    function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {\n', '        token.transfer(owner, amount);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev cutdown simply to allow removal of tokens sent to contract\n', ' */\n', 'contract ERC20 {\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '// 200 000 000 ether = A56FA5B99019A5C8000000 = 88 bits. We have 256.\n', '// we do NOT need safemath.\n', '\n', 'contract SimpleSale is Ownable,Pausable {\n', '\n', '    address public multisig = 0xc862705dDA23A2BAB54a6444B08a397CD4DfCD1c;\n', '    address public cs;\n', '    uint256 public totalCollected;\n', '    bool    public saleFinished;\n', '    bool    public freeForAll = true;\n', '    uint256 public startTime = 1505998800;\n', '    uint256 public stopTime = 1508590800;\n', '\n', '    mapping (address => uint256) public deposits;\n', '    mapping (address => bool) public authorised; // just to annoy the heck out of americans\n', '\n', '    /**\n', '     * @dev throws if person sending is not contract owner or cs role\n', '     */\n', '    modifier onlyCSorOwner() {\n', '        require((msg.sender == owner) || (msg.sender==cs));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev throws if person sending is not authorised or sends nothing\n', '     */\n', '    modifier onlyAuthorised() {\n', '        require (authorised[msg.sender] || freeForAll);\n', '        require (msg.value > 0);\n', '        require (now >= startTime);\n', '        require (now <= stopTime);\n', '        require (!saleFinished);\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev set start and stop times\n', '     */\n', '    function setPeriod(uint256 start, uint256 stop) onlyOwner {\n', '        startTime = start;\n', '        stopTime = stop;\n', '    }\n', '    \n', '    /**\n', '     * @dev authorise an account to participate\n', '     */\n', '    function authoriseAccount(address whom) onlyCSorOwner {\n', '        authorised[whom] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev authorise a lot of accounts in one go\n', '     */\n', '    function authoriseManyAccounts(address[] many) onlyCSorOwner {\n', '        for (uint256 i = 0; i < many.length; i++) {\n', '            authorised[many[i]] = true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev ban an account from participation (default)\n', '     */\n', '    function blockAccount(address whom) onlyCSorOwner {\n', '        authorised[whom] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev set a new CS representative\n', '     */\n', '    function setCS(address newCS) onlyOwner {\n', '        cs = newCS;\n', '    }\n', '    \n', '    function requireAuthorisation(bool state) {\n', '        freeForAll = !state;\n', '    }\n', '\n', '    /**\n', '     * @dev call an end (e.g. because cap reached)\n', '     */\n', '    function stopSale() onlyOwner {\n', '        saleFinished = true;\n', '    }\n', '    \n', '\n', '    /**\n', '     * @dev fallback function received ether, sends it to the multisig, notes indivdual and group contributions\n', '     */\n', '    function () payable onlyAuthorised {\n', '        multisig.transfer(msg.value);\n', '        deposits[msg.sender] += msg.value;\n', '        totalCollected += msg.value;\n', '    }\n', '\n', '    /**\n', '     * @dev in case somebody sends ERC2o tokens...\n', '     */\n', '    function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {\n', '        token.transfer(owner, amount);\n', '    }\n', '\n', '}']
