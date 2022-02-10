['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  /**\n', '   * @param _wallet Vault address\n', '   */\n', '  function RefundVault(address _wallet) public {\n', '    require(_wallet != address(0));\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  /**\n', '   * @param investor Investor address\n', '   */\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Closed;\n', '    Closed();\n', '    wallet.transfer(address(this).balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    RefundsEnabled();\n', '  }\n', '\n', '  /**\n', '   * @param investor Investor address\n', '   */\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title LandSale\n', ' * @dev Landsale contract is a timed, refundable crowdsale for land. It has\n', ' * a tiered increasing price element based on number of land sold per type.\n', ' * @notice We omit a fallback function to prevent accidental sends to this contract.\n', ' */\n', 'contract LandSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public openingTime;\n', '    uint256 public closingTime;\n', '\n', '    uint256 constant public VILLAGE_START_PRICE = 1200000000000000; // 0.0012 ETH\n', '    uint256 constant public TOWN_START_PRICE = 5000000000000000; // 0.005 ETH\n', '    uint256 constant public CITY_START_PRICE = 20000000000000000; // 0.02 ETH\n', '\n', '    uint256 constant public VILLAGE_INCREASE_RATE = 500000000000000; // 0.0005 ETH\n', '    uint256 constant public TOWN_INCREASE_RATE = 2500000000000000; // 0.0025 ETH\n', '    uint256 constant public CITY_INCREASE_RATE = 12500000000000000; // 0.0125 ETH\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    // minimum amount of funds to be raised in wei\n', '    uint256 public goal;\n', '\n', '    // refund vault used to hold funds while crowdsale is running\n', '    RefundVault public vault;\n', '\n', '    // Array of addresses who purchased land via their ethereum address\n', '    address[] public walletUsers;\n', '    uint256 public walletUserCount;\n', '\n', '    // Array of users who purchased land via other method (ex. CC)\n', '    bytes32[] public ccUsers;\n', '    uint256 public ccUserCount;\n', '\n', '    // Number of each landType sold\n', '    uint256 public villagesSold;\n', '    uint256 public townsSold;\n', '    uint256 public citiesSold;\n', '\n', '\n', '    // 0 - Plot\n', '    // 1 - Village\n', '    // 2 - Town\n', '    // 3 - City\n', '\n', '    // user wallet address -> # of land\n', '    mapping (address => uint256) public addressToNumVillages;\n', '    mapping (address => uint256) public addressToNumTowns;\n', '    mapping (address => uint256) public addressToNumCities;\n', '\n', '    // user id hash -> # of land\n', '    mapping (bytes32 => uint256) public userToNumVillages;\n', '    mapping (bytes32 => uint256) public userToNumTowns;\n', '    mapping (bytes32 => uint256) public userToNumCities;\n', '\n', '    bool private paused = false;\n', '    bool public isFinalized = false;\n', '\n', '    /**\n', '     * @dev Send events for every purchase. Also send an event when LandSale is complete\n', '     */\n', '    event LandPurchased(address indexed purchaser, uint256 value, uint8 landType, uint256 quantity);\n', '    event LandPurchasedCC(bytes32 indexed userId, address indexed purchaser, uint8 landType, uint256 quantity);\n', '    event Finalized();\n', '\n', '    /**\n', '     * @dev Reverts if not in crowdsale time range.\n', '     */\n', '    modifier onlyWhileOpen {\n', '        require(block.timestamp >= openingTime && block.timestamp <= closingTime && !paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Constructor. One-time set up of goal and opening/closing times of landsale\n', '     */\n', '    function LandSale(address _wallet, uint256 _goal,\n', '                        uint256 _openingTime, uint256 _closingTime) public {\n', '        require(_wallet != address(0));\n', '        require(_goal > 0);\n', '        require(_openingTime >= block.timestamp);\n', '        require(_closingTime >= _openingTime);\n', '\n', '        wallet = _wallet;\n', '        vault = new RefundVault(wallet);\n', '        goal = _goal;\n', '        openingTime = _openingTime;\n', '        closingTime = _closingTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Add new ethereum wallet users to array\n', '     */\n', '    function addWalletAddress(address walletAddress) private {\n', '        if ((addressToNumVillages[walletAddress] == 0) &&\n', '            (addressToNumTowns[walletAddress] == 0) &&\n', '            (addressToNumCities[walletAddress] == 0)) {\n', '            // only add address to array during first land purchase\n', '            walletUsers.push(msg.sender);\n', '            walletUserCount++;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Add new CC users to array\n', '     */\n', '    function addCCUser(bytes32 user) private {\n', '        if ((userToNumVillages[user] == 0) &&\n', '            (userToNumTowns[user] == 0) &&\n', '            (userToNumCities[user] == 0)) {\n', '            // only add user to array during first land purchase\n', '            ccUsers.push(user);\n', '            ccUserCount++;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Purchase a village. For bulk purchase, current price honored for all\n', '     * villages purchased.\n', '     */\n', '    function purchaseVillage(uint256 numVillages) payable public onlyWhileOpen {\n', '        require(msg.value >= (villagePrice()*numVillages));\n', '        require(numVillages > 0);\n', '\n', '        weiRaised = weiRaised.add(msg.value);\n', '\n', '        villagesSold = villagesSold.add(numVillages);\n', '        addWalletAddress(msg.sender);\n', '        addressToNumVillages[msg.sender] = addressToNumVillages[msg.sender].add(numVillages);\n', '\n', '        _forwardFunds();\n', '        LandPurchased(msg.sender, msg.value, 1, numVillages);\n', '    }\n', '\n', '    /**\n', '     * @dev Purchase a town. For bulk purchase, current price honored for all\n', '     * towns purchased.\n', '     */\n', '    function purchaseTown(uint256 numTowns) payable public onlyWhileOpen {\n', '        require(msg.value >= (townPrice()*numTowns));\n', '        require(numTowns > 0);\n', '\n', '        weiRaised = weiRaised.add(msg.value);\n', '\n', '        townsSold = townsSold.add(numTowns);\n', '        addWalletAddress(msg.sender);\n', '        addressToNumTowns[msg.sender] = addressToNumTowns[msg.sender].add(numTowns);\n', '\n', '        _forwardFunds();\n', '        LandPurchased(msg.sender, msg.value, 2, numTowns);\n', '    }\n', '\n', '    /**\n', '     * @dev Purchase a city. For bulk purchase, current price honored for all\n', '     * cities purchased.\n', '     */\n', '    function purchaseCity(uint256 numCities) payable public onlyWhileOpen {\n', '        require(msg.value >= (cityPrice()*numCities));\n', '        require(numCities > 0);\n', '\n', '        weiRaised = weiRaised.add(msg.value);\n', '\n', '        citiesSold = citiesSold.add(numCities);\n', '        addWalletAddress(msg.sender);\n', '        addressToNumCities[msg.sender] = addressToNumCities[msg.sender].add(numCities);\n', '\n', '        _forwardFunds();\n', '        LandPurchased(msg.sender, msg.value, 3, numCities);\n', '    }\n', '\n', '    /**\n', '     * @dev Accounting for the CC purchases for audit purposes (no actual ETH transfer here)\n', '     */\n', '    function purchaseLandWithCC(uint8 landType, bytes32 userId, uint256 num) public onlyOwner onlyWhileOpen {\n', '        require(landType <= 3);\n', '        require(num > 0);\n', '\n', '        addCCUser(userId);\n', '\n', '        if (landType == 3) {\n', '            weiRaised = weiRaised.add(cityPrice()*num);\n', '            citiesSold = citiesSold.add(num);\n', '            userToNumCities[userId] = userToNumCities[userId].add(num);\n', '        } else if (landType == 2) {\n', '            weiRaised = weiRaised.add(townPrice()*num);\n', '            townsSold = townsSold.add(num);\n', '            userToNumTowns[userId] = userToNumTowns[userId].add(num);\n', '        } else if (landType == 1) {\n', '            weiRaised = weiRaised.add(villagePrice()*num);\n', '            villagesSold = villagesSold.add(num);\n', '            userToNumVillages[userId] = userToNumVillages[userId].add(num);\n', '        }\n', '\n', '        LandPurchasedCC(userId, msg.sender, landType, num);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current price of a village. Price raises every 10 purchases.\n', '     */\n', '    function villagePrice() view public returns(uint256) {\n', '        return VILLAGE_START_PRICE.add((villagesSold.div(10).mul(VILLAGE_INCREASE_RATE)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current price of a town. Price raises every 10 purchases\n', '     */\n', '    function townPrice() view public returns(uint256) {\n', '        return TOWN_START_PRICE.add((townsSold.div(10).mul(TOWN_INCREASE_RATE)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current price of a city. Price raises every 10 purchases\n', '     */\n', '    function cityPrice() view public returns(uint256) {\n', '        return CITY_START_PRICE.add((citiesSold.div(10).mul(CITY_INCREASE_RATE)));\n', '    }\n', '\n', '    /**\n', '     * @dev Allows owner to pause puchases during the landsale\n', '     */\n', '    function pause() onlyOwner public {\n', '        paused = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows owner to resume puchases during the landsale\n', '     */\n', '    function resume() onlyOwner public {\n', '        paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows owner to check the paused status\n', '     * @return Whether landsale is paused\n', '     */\n', '    function isPaused () onlyOwner public view returns(bool) {\n', '        return paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '     * @return Whether crowdsale period has elapsed\n', '     */\n', '    function hasClosed() public view returns (bool) {\n', '        return block.timestamp > closingTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Investors can claim refunds here if crowdsale is unsuccessful\n', '     */\n', '    function claimRefund() public {\n', '        require(isFinalized);\n', '        require(!goalReached());\n', '\n', '        vault.refund(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether funding goal was reached.\n', '     * @return Whether funding goal was reached\n', '     */\n', '    function goalReached() public view returns (bool) {\n', '        return weiRaised >= goal;\n', '    }\n', '\n', '    /**\n', '     * @dev vault finalization task, called when owner calls finalize()\n', '     */\n', '    function finalize() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(hasClosed());\n', '\n', '        if (goalReached()) {\n', '          vault.close();\n', '        } else {\n', '          vault.enableRefunds();\n', '        }\n', '\n', '        Finalized();\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Overrides Crowdsale fund forwarding, sending funds to vault.\n', '     */\n', '    function _forwardFunds() internal {\n', '        vault.deposit.value(msg.value)(msg.sender);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  /**\n', '   * @param _wallet Vault address\n', '   */\n', '  function RefundVault(address _wallet) public {\n', '    require(_wallet != address(0));\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  /**\n', '   * @param investor Investor address\n', '   */\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Closed;\n', '    Closed();\n', '    wallet.transfer(address(this).balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    RefundsEnabled();\n', '  }\n', '\n', '  /**\n', '   * @param investor Investor address\n', '   */\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title LandSale\n', ' * @dev Landsale contract is a timed, refundable crowdsale for land. It has\n', ' * a tiered increasing price element based on number of land sold per type.\n', ' * @notice We omit a fallback function to prevent accidental sends to this contract.\n', ' */\n', 'contract LandSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public openingTime;\n', '    uint256 public closingTime;\n', '\n', '    uint256 constant public VILLAGE_START_PRICE = 1200000000000000; // 0.0012 ETH\n', '    uint256 constant public TOWN_START_PRICE = 5000000000000000; // 0.005 ETH\n', '    uint256 constant public CITY_START_PRICE = 20000000000000000; // 0.02 ETH\n', '\n', '    uint256 constant public VILLAGE_INCREASE_RATE = 500000000000000; // 0.0005 ETH\n', '    uint256 constant public TOWN_INCREASE_RATE = 2500000000000000; // 0.0025 ETH\n', '    uint256 constant public CITY_INCREASE_RATE = 12500000000000000; // 0.0125 ETH\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    // minimum amount of funds to be raised in wei\n', '    uint256 public goal;\n', '\n', '    // refund vault used to hold funds while crowdsale is running\n', '    RefundVault public vault;\n', '\n', '    // Array of addresses who purchased land via their ethereum address\n', '    address[] public walletUsers;\n', '    uint256 public walletUserCount;\n', '\n', '    // Array of users who purchased land via other method (ex. CC)\n', '    bytes32[] public ccUsers;\n', '    uint256 public ccUserCount;\n', '\n', '    // Number of each landType sold\n', '    uint256 public villagesSold;\n', '    uint256 public townsSold;\n', '    uint256 public citiesSold;\n', '\n', '\n', '    // 0 - Plot\n', '    // 1 - Village\n', '    // 2 - Town\n', '    // 3 - City\n', '\n', '    // user wallet address -> # of land\n', '    mapping (address => uint256) public addressToNumVillages;\n', '    mapping (address => uint256) public addressToNumTowns;\n', '    mapping (address => uint256) public addressToNumCities;\n', '\n', '    // user id hash -> # of land\n', '    mapping (bytes32 => uint256) public userToNumVillages;\n', '    mapping (bytes32 => uint256) public userToNumTowns;\n', '    mapping (bytes32 => uint256) public userToNumCities;\n', '\n', '    bool private paused = false;\n', '    bool public isFinalized = false;\n', '\n', '    /**\n', '     * @dev Send events for every purchase. Also send an event when LandSale is complete\n', '     */\n', '    event LandPurchased(address indexed purchaser, uint256 value, uint8 landType, uint256 quantity);\n', '    event LandPurchasedCC(bytes32 indexed userId, address indexed purchaser, uint8 landType, uint256 quantity);\n', '    event Finalized();\n', '\n', '    /**\n', '     * @dev Reverts if not in crowdsale time range.\n', '     */\n', '    modifier onlyWhileOpen {\n', '        require(block.timestamp >= openingTime && block.timestamp <= closingTime && !paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Constructor. One-time set up of goal and opening/closing times of landsale\n', '     */\n', '    function LandSale(address _wallet, uint256 _goal,\n', '                        uint256 _openingTime, uint256 _closingTime) public {\n', '        require(_wallet != address(0));\n', '        require(_goal > 0);\n', '        require(_openingTime >= block.timestamp);\n', '        require(_closingTime >= _openingTime);\n', '\n', '        wallet = _wallet;\n', '        vault = new RefundVault(wallet);\n', '        goal = _goal;\n', '        openingTime = _openingTime;\n', '        closingTime = _closingTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Add new ethereum wallet users to array\n', '     */\n', '    function addWalletAddress(address walletAddress) private {\n', '        if ((addressToNumVillages[walletAddress] == 0) &&\n', '            (addressToNumTowns[walletAddress] == 0) &&\n', '            (addressToNumCities[walletAddress] == 0)) {\n', '            // only add address to array during first land purchase\n', '            walletUsers.push(msg.sender);\n', '            walletUserCount++;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Add new CC users to array\n', '     */\n', '    function addCCUser(bytes32 user) private {\n', '        if ((userToNumVillages[user] == 0) &&\n', '            (userToNumTowns[user] == 0) &&\n', '            (userToNumCities[user] == 0)) {\n', '            // only add user to array during first land purchase\n', '            ccUsers.push(user);\n', '            ccUserCount++;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Purchase a village. For bulk purchase, current price honored for all\n', '     * villages purchased.\n', '     */\n', '    function purchaseVillage(uint256 numVillages) payable public onlyWhileOpen {\n', '        require(msg.value >= (villagePrice()*numVillages));\n', '        require(numVillages > 0);\n', '\n', '        weiRaised = weiRaised.add(msg.value);\n', '\n', '        villagesSold = villagesSold.add(numVillages);\n', '        addWalletAddress(msg.sender);\n', '        addressToNumVillages[msg.sender] = addressToNumVillages[msg.sender].add(numVillages);\n', '\n', '        _forwardFunds();\n', '        LandPurchased(msg.sender, msg.value, 1, numVillages);\n', '    }\n', '\n', '    /**\n', '     * @dev Purchase a town. For bulk purchase, current price honored for all\n', '     * towns purchased.\n', '     */\n', '    function purchaseTown(uint256 numTowns) payable public onlyWhileOpen {\n', '        require(msg.value >= (townPrice()*numTowns));\n', '        require(numTowns > 0);\n', '\n', '        weiRaised = weiRaised.add(msg.value);\n', '\n', '        townsSold = townsSold.add(numTowns);\n', '        addWalletAddress(msg.sender);\n', '        addressToNumTowns[msg.sender] = addressToNumTowns[msg.sender].add(numTowns);\n', '\n', '        _forwardFunds();\n', '        LandPurchased(msg.sender, msg.value, 2, numTowns);\n', '    }\n', '\n', '    /**\n', '     * @dev Purchase a city. For bulk purchase, current price honored for all\n', '     * cities purchased.\n', '     */\n', '    function purchaseCity(uint256 numCities) payable public onlyWhileOpen {\n', '        require(msg.value >= (cityPrice()*numCities));\n', '        require(numCities > 0);\n', '\n', '        weiRaised = weiRaised.add(msg.value);\n', '\n', '        citiesSold = citiesSold.add(numCities);\n', '        addWalletAddress(msg.sender);\n', '        addressToNumCities[msg.sender] = addressToNumCities[msg.sender].add(numCities);\n', '\n', '        _forwardFunds();\n', '        LandPurchased(msg.sender, msg.value, 3, numCities);\n', '    }\n', '\n', '    /**\n', '     * @dev Accounting for the CC purchases for audit purposes (no actual ETH transfer here)\n', '     */\n', '    function purchaseLandWithCC(uint8 landType, bytes32 userId, uint256 num) public onlyOwner onlyWhileOpen {\n', '        require(landType <= 3);\n', '        require(num > 0);\n', '\n', '        addCCUser(userId);\n', '\n', '        if (landType == 3) {\n', '            weiRaised = weiRaised.add(cityPrice()*num);\n', '            citiesSold = citiesSold.add(num);\n', '            userToNumCities[userId] = userToNumCities[userId].add(num);\n', '        } else if (landType == 2) {\n', '            weiRaised = weiRaised.add(townPrice()*num);\n', '            townsSold = townsSold.add(num);\n', '            userToNumTowns[userId] = userToNumTowns[userId].add(num);\n', '        } else if (landType == 1) {\n', '            weiRaised = weiRaised.add(villagePrice()*num);\n', '            villagesSold = villagesSold.add(num);\n', '            userToNumVillages[userId] = userToNumVillages[userId].add(num);\n', '        }\n', '\n', '        LandPurchasedCC(userId, msg.sender, landType, num);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current price of a village. Price raises every 10 purchases.\n', '     */\n', '    function villagePrice() view public returns(uint256) {\n', '        return VILLAGE_START_PRICE.add((villagesSold.div(10).mul(VILLAGE_INCREASE_RATE)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current price of a town. Price raises every 10 purchases\n', '     */\n', '    function townPrice() view public returns(uint256) {\n', '        return TOWN_START_PRICE.add((townsSold.div(10).mul(TOWN_INCREASE_RATE)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current price of a city. Price raises every 10 purchases\n', '     */\n', '    function cityPrice() view public returns(uint256) {\n', '        return CITY_START_PRICE.add((citiesSold.div(10).mul(CITY_INCREASE_RATE)));\n', '    }\n', '\n', '    /**\n', '     * @dev Allows owner to pause puchases during the landsale\n', '     */\n', '    function pause() onlyOwner public {\n', '        paused = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows owner to resume puchases during the landsale\n', '     */\n', '    function resume() onlyOwner public {\n', '        paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows owner to check the paused status\n', '     * @return Whether landsale is paused\n', '     */\n', '    function isPaused () onlyOwner public view returns(bool) {\n', '        return paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether the period in which the crowdsale is open has already elapsed.\n', '     * @return Whether crowdsale period has elapsed\n', '     */\n', '    function hasClosed() public view returns (bool) {\n', '        return block.timestamp > closingTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Investors can claim refunds here if crowdsale is unsuccessful\n', '     */\n', '    function claimRefund() public {\n', '        require(isFinalized);\n', '        require(!goalReached());\n', '\n', '        vault.refund(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether funding goal was reached.\n', '     * @return Whether funding goal was reached\n', '     */\n', '    function goalReached() public view returns (bool) {\n', '        return weiRaised >= goal;\n', '    }\n', '\n', '    /**\n', '     * @dev vault finalization task, called when owner calls finalize()\n', '     */\n', '    function finalize() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(hasClosed());\n', '\n', '        if (goalReached()) {\n', '          vault.close();\n', '        } else {\n', '          vault.enableRefunds();\n', '        }\n', '\n', '        Finalized();\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Overrides Crowdsale fund forwarding, sending funds to vault.\n', '     */\n', '    function _forwardFunds() internal {\n', '        vault.deposit.value(msg.value)(msg.sender);\n', '    }\n', '}']
