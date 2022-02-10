['pragma solidity ^0.4.18;\n', '\n', 'contract AccessControl {\n', '  /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '\n', '  /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked\n', '  bool public paused = false;\n', '\n', '  /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account\n', '  function AccessControl() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '  }\n', '\n', '  /// @dev Access modifier for CEO-only functionality\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for COO-only functionality\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for any CLevel functionality\n', '  modifier onlyCLevel() {\n', '    require(msg.sender == ceoAddress || msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO\n', '  /// @param _newCEO The address of the new CEO\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '    ceoAddress = _newCEO;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the COO. Only available to the current CEO\n', '  /// @param _newCOO The address of the new COO\n', '  function setCOO(address _newCOO) public onlyCEO {\n', '    require(_newCOO != address(0));\n', '    cooAddress = _newCOO;\n', '  }\n', '\n', '  /// @dev Modifier to allow actions only when the contract IS NOT paused\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /// @dev Modifier to allow actions only when the contract IS paused\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /// @dev Pause the smart contract. Only can be called by the CEO\n', '  function pause() public onlyCEO whenNotPaused {\n', '     paused = true;\n', '  }\n', '\n', '  /// @dev Unpauses the smart contract. Only can be called by the CEO\n', '  function unpause() public onlyCEO whenPaused {\n', '    paused = false;\n', '  }\n', '}\n', '\n', '\n', 'contract RacingClubPresale is AccessControl {\n', '  using SafeMath for uint256;\n', '\n', '  // Max number of cars (includes sales and gifts)\n', '  uint256 public constant MAX_CARS = 999;\n', '\n', '  // Max number of cars to gift (includes unicorns)\n', '  uint256 public constant MAX_CARS_TO_GIFT = 99;\n', '\n', '  // Max number of unicorn cars to gift\n', '  uint256 public constant MAX_UNICORNS_TO_GIFT = 9;\n', '\n', '  // End date for the presale. No purchases can be made after this date.\n', '  // Thursday, May 10, 2018 11:59:59 PM\n', '  uint256 public constant PRESALE_END_TIMESTAMP = 1525996799;\n', '\n', '  // Price limits to decrease the appreciation rate\n', '  uint256 private constant PRICE_LIMIT_1 = 0.1 ether;\n', '\n', '  // Appreciation steps for each price limit\n', '  uint256 private constant APPRECIATION_STEP_1 = 0.0005 ether;\n', '  uint256 private constant APPRECIATION_STEP_2 = 0.0001 ether;\n', '\n', '  // Max count which can be bought with one transaction\n', '  uint256 private constant MAX_ORDER = 5;\n', '\n', '  // 0 - 9 valid Id&#39;s for cars\n', '  uint256 private constant CAR_MODELS = 10;\n', '\n', '  // The special car (the most rarest one) which can&#39;t be picked even with MAX_ORDER\n', '  uint256 public constant UNICORN_ID = 0;\n', '\n', '  // Maps any number from 0 - 255 to 0 - 9 car Id\n', '  uint256[] private PROBABILITY_MAP = [4, 18, 32, 46, 81, 116, 151, 186, 221, 256];\n', '\n', '  // Step by which the price should be changed\n', '  uint256 public appreciationStep = APPRECIATION_STEP_1;\n', '\n', '  // Current price of the car. The price appreciation is happening with each new sale.\n', '  uint256 public currentPrice = 0.001 ether;\n', '\n', '  // Overall cars count\n', '  uint256 public carsCount;\n', '\n', '  // Overall gifted cars count\n', '  uint256 public carsGifted;\n', '\n', '  // Gifted unicorn cars count\n', '  uint256 public unicornsGifted;\n', '\n', '  // A mapping from addresses to the carIds\n', '  mapping (address => uint256[]) private ownerToCars;\n', '\n', '  // A mapping from addresses to the upgrade packages\n', '  mapping (address => uint256) private ownerToUpgradePackages;\n', '\n', '  // Events\n', '  event CarsPurchased(address indexed _owner, uint256[] _carIds, bool _upgradePackage, uint256 _pricePayed);\n', '  event CarGifted(address indexed _receiver, uint256 _carId, bool _upgradePackage);\n', '\n', '  // Buy a car. The cars are unique within the order.\n', '  // If order count is 5 then one car can be preselected.\n', '  function purchaseCars(uint256 _carsToBuy, uint256 _pickedId, bool _upgradePackage) public payable whenNotPaused {\n', '    require(now < PRESALE_END_TIMESTAMP);\n', '    require(_carsToBuy > 0 && _carsToBuy <= MAX_ORDER);\n', '    require(carsCount + _carsToBuy <= MAX_CARS);\n', '\n', '    uint256 priceToPay = calculatePrice(_carsToBuy, _upgradePackage);\n', '    require(msg.value >= priceToPay);\n', '\n', '    // return excess ether\n', '    uint256 excess = msg.value.sub(priceToPay);\n', '    if (excess > 0) {\n', '      msg.sender.transfer(excess);\n', '    }\n', '\n', '    // initialize an array for the new cars\n', '    uint256[] memory randomCars = new uint256[](_carsToBuy);\n', '    // shows from which point the randomCars array should be filled\n', '    uint256 startFrom = 0;\n', '\n', '    // for MAX_ORDERs the first item is user picked\n', '    if (_carsToBuy == MAX_ORDER) {\n', '      require(_pickedId < CAR_MODELS);\n', '      require(_pickedId != UNICORN_ID);\n', '\n', '      randomCars[0] = _pickedId;\n', '      startFrom = 1;\n', '    }\n', '    fillRandomCars(randomCars, startFrom);\n', '\n', '    // add new cars to the owner&#39;s list\n', '    for (uint256 i = 0; i < randomCars.length; i++) {\n', '      ownerToCars[msg.sender].push(randomCars[i]);\n', '    }\n', '\n', '    // increment upgrade packages\n', '    if (_upgradePackage) {\n', '      ownerToUpgradePackages[msg.sender] += _carsToBuy;\n', '    }\n', '\n', '    CarsPurchased(msg.sender, randomCars, _upgradePackage, priceToPay);\n', '\n', '    carsCount += _carsToBuy;\n', '    currentPrice += _carsToBuy * appreciationStep;\n', '\n', '    // update this once per purchase\n', '    // to save the gas and to simplify the calculations\n', '    updateAppreciationStep();\n', '  }\n', '\n', '  // MAX_CARS_TO_GIFT amout of cars are dedicated for gifts\n', '  function giftCar(address _receiver, uint256 _carId, bool _upgradePackage) public onlyCLevel {\n', '    // NOTE\n', '    // Some promo results will be calculated after the presale,\n', '    // so there is no need to check for the PRESALE_END_TIMESTAMP.\n', '\n', '    require(_carId < CAR_MODELS);\n', '    require(_receiver != address(0));\n', '\n', '    // check limits\n', '    require(carsCount < MAX_CARS);\n', '    require(carsGifted < MAX_CARS_TO_GIFT);\n', '    if (_carId == UNICORN_ID) {\n', '      require(unicornsGifted < MAX_UNICORNS_TO_GIFT);\n', '    }\n', '\n', '    ownerToCars[_receiver].push(_carId);\n', '    if (_upgradePackage) {\n', '      ownerToUpgradePackages[_receiver] += 1;\n', '    }\n', '\n', '    CarGifted(_receiver, _carId, _upgradePackage);\n', '\n', '    carsCount += 1;\n', '    carsGifted += 1;\n', '    if (_carId == UNICORN_ID) {\n', '      unicornsGifted += 1;\n', '    }\n', '\n', '    currentPrice += appreciationStep;\n', '    updateAppreciationStep();\n', '  }\n', '\n', '  function calculatePrice(uint256 _carsToBuy, bool _upgradePackage) private view returns (uint256) {\n', '    // Arithmetic Sequence\n', '    // A(n) = A(0) + (n - 1) * D\n', '    uint256 lastPrice = currentPrice + (_carsToBuy - 1) * appreciationStep;\n', '\n', '    // Sum of the First n Terms of an Arithmetic Sequence\n', '    // S(n) = n * (a(1) + a(n)) / 2\n', '    uint256 priceToPay = _carsToBuy * (currentPrice + lastPrice) / 2;\n', '\n', '    // add an extra amount for the upgrade package\n', '    if (_upgradePackage) {\n', '      if (_carsToBuy < 3) {\n', '        priceToPay = priceToPay * 120 / 100; // 20% extra\n', '      } else if (_carsToBuy < 5) {\n', '        priceToPay = priceToPay * 115 / 100; // 15% extra\n', '      } else {\n', '        priceToPay = priceToPay * 110 / 100; // 10% extra\n', '      }\n', '    }\n', '\n', '    return priceToPay;\n', '  }\n', '\n', '  // Fill unique random cars into _randomCars starting from _startFrom\n', '  // as some slots may be already filled\n', '  function fillRandomCars(uint256[] _randomCars, uint256 _startFrom) private view {\n', '    // All random cars for the current purchase are generated from this 32 bytes.\n', '    // All purchases within a same block will get different car combinations\n', '    // as current price is changed at the end of the purchase.\n', '    //\n', '    // We don&#39;t need super secure random algorithm as it&#39;s just presale\n', '    // and if someone can time the block and grab the desired car we are just happy for him / her\n', '    bytes32 rand32 = keccak256(currentPrice, now);\n', '    uint256 randIndex = 0;\n', '    uint256 carId;\n', '\n', '    for (uint256 i = _startFrom; i < _randomCars.length; i++) {\n', '      do {\n', '        // the max number for one purchase is limited to 5\n', '        // 32 tries are more than enough to generate 5 unique numbers\n', '        require(randIndex < 32);\n', '        carId = generateCarId(uint8(rand32[randIndex]));\n', '        randIndex++;\n', '      } while(alreadyContains(_randomCars, carId, i));\n', '      _randomCars[i] = carId;\n', '    }\n', '  }\n', '\n', '  // Generate a car ID from the given serial number (0 - 255)\n', '  function generateCarId(uint256 _serialNumber) private view returns (uint256) {\n', '    for (uint256 i = 0; i < PROBABILITY_MAP.length; i++) {\n', '      if (_serialNumber < PROBABILITY_MAP[i]) {\n', '        return i;\n', '      }\n', '    }\n', '    // we should not reach to this point\n', '    assert(false);\n', '  }\n', '\n', '  // Check if the given value is already in the list.\n', '  // By default all items are 0 so _to is used explicitly to validate 0 values.\n', '  function alreadyContains(uint256[] _list, uint256 _value, uint256 _to) private pure returns (bool) {\n', '    for (uint256 i = 0; i < _to; i++) {\n', '      if (_list[i] == _value) {\n', '        return true;\n', '      }\n', '    }\n', '    return false;\n', '  }\n', '\n', '  function updateAppreciationStep() private {\n', '    // this method is called once per purcahse\n', '    // so use &#39;greater than&#39; not to miss the limit\n', '    if (currentPrice > PRICE_LIMIT_1) {\n', '      // don&#39;t update if there is no change\n', '      if (appreciationStep != APPRECIATION_STEP_2) {\n', '        appreciationStep = APPRECIATION_STEP_2;\n', '      }\n', '    }\n', '  }\n', '\n', '  function carCountOf(address _owner) public view returns (uint256 _carCount) {\n', '    return ownerToCars[_owner].length;\n', '  }\n', '\n', '  function carOfByIndex(address _owner, uint256 _index) public view returns (uint256 _carId) {\n', '    return ownerToCars[_owner][_index];\n', '  }\n', '\n', '  function carsOf(address _owner) public view returns (uint256[] _carIds) {\n', '    return ownerToCars[_owner];\n', '  }\n', '\n', '  function upgradePackageCountOf(address _owner) public view returns (uint256 _upgradePackageCount) {\n', '    return ownerToUpgradePackages[_owner];\n', '  }\n', '\n', '  function allOf(address _owner) public view returns (uint256[] _carIds, uint256 _upgradePackageCount) {\n', '    return (ownerToCars[_owner], ownerToUpgradePackages[_owner]);\n', '  }\n', '\n', '  function getStats() public view returns (uint256 _carsCount, uint256 _carsGifted, uint256 _unicornsGifted, uint256 _currentPrice, uint256 _appreciationStep) {\n', '    return (carsCount, carsGifted, unicornsGifted, currentPrice, appreciationStep);\n', '  }\n', '\n', '  function withdrawBalance(address _to, uint256 _amount) public onlyCEO {\n', '    if (_amount == 0) {\n', '      _amount = address(this).balance;\n', '    }\n', '\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(_amount);\n', '    } else {\n', '      _to.transfer(_amount);\n', '    }\n', '  }\n', '\n', '\n', '  // Raffle\n', '  // max count of raffle participants\n', '  uint256 public raffleLimit = 50;\n', '\n', '  // list of raffle participants\n', '  address[] private raffleList;\n', '\n', '  // Events\n', '  event Raffle2Registered(address indexed _iuser, address _user);\n', '  event Raffle3Registered(address _user);\n', '\n', '  function isInRaffle(address _address) public view returns (bool) {\n', '    for (uint256 i = 0; i < raffleList.length; i++) {\n', '      if (raffleList[i] == _address) {\n', '        return true;\n', '      }\n', '    }\n', '    return false;\n', '  }\n', '\n', '  function getRaffleStats() public view returns (address[], uint256) {\n', '    return (raffleList, raffleLimit);\n', '  }\n', '\n', '  function drawRaffle(uint256 _carId) public onlyCLevel {\n', '    bytes32 rand32 = keccak256(now, raffleList.length);\n', '    uint256 winner = uint(rand32) % raffleList.length;\n', '\n', '    giftCar(raffleList[winner], _carId, true);\n', '  }\n', '\n', '  function resetRaffle() public onlyCLevel {\n', '    delete raffleList;\n', '  }\n', '\n', '  function setRaffleLimit(uint256 _limit) public onlyCLevel {\n', '    raffleLimit = _limit;\n', '  }\n', '\n', '  // Raffle v1\n', '  function registerForRaffle() public {\n', '    require(raffleList.length < raffleLimit);\n', '    require(!isInRaffle(msg.sender));\n', '    raffleList.push(msg.sender);\n', '  }\n', '\n', '  // Raffle v2\n', '  function registerForRaffle2() public {\n', '    Raffle2Registered(msg.sender, msg.sender);\n', '  }\n', '\n', '  // Raffle v3\n', '  function registerForRaffle3() public payable {\n', '    Raffle3Registered(msg.sender);\n', '  }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract AccessControl {\n', '  /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '\n', '  /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked\n', '  bool public paused = false;\n', '\n', '  /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account\n', '  function AccessControl() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '  }\n', '\n', '  /// @dev Access modifier for CEO-only functionality\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for COO-only functionality\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for any CLevel functionality\n', '  modifier onlyCLevel() {\n', '    require(msg.sender == ceoAddress || msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO\n', '  /// @param _newCEO The address of the new CEO\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '    ceoAddress = _newCEO;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the COO. Only available to the current CEO\n', '  /// @param _newCOO The address of the new COO\n', '  function setCOO(address _newCOO) public onlyCEO {\n', '    require(_newCOO != address(0));\n', '    cooAddress = _newCOO;\n', '  }\n', '\n', '  /// @dev Modifier to allow actions only when the contract IS NOT paused\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /// @dev Modifier to allow actions only when the contract IS paused\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /// @dev Pause the smart contract. Only can be called by the CEO\n', '  function pause() public onlyCEO whenNotPaused {\n', '     paused = true;\n', '  }\n', '\n', '  /// @dev Unpauses the smart contract. Only can be called by the CEO\n', '  function unpause() public onlyCEO whenPaused {\n', '    paused = false;\n', '  }\n', '}\n', '\n', '\n', 'contract RacingClubPresale is AccessControl {\n', '  using SafeMath for uint256;\n', '\n', '  // Max number of cars (includes sales and gifts)\n', '  uint256 public constant MAX_CARS = 999;\n', '\n', '  // Max number of cars to gift (includes unicorns)\n', '  uint256 public constant MAX_CARS_TO_GIFT = 99;\n', '\n', '  // Max number of unicorn cars to gift\n', '  uint256 public constant MAX_UNICORNS_TO_GIFT = 9;\n', '\n', '  // End date for the presale. No purchases can be made after this date.\n', '  // Thursday, May 10, 2018 11:59:59 PM\n', '  uint256 public constant PRESALE_END_TIMESTAMP = 1525996799;\n', '\n', '  // Price limits to decrease the appreciation rate\n', '  uint256 private constant PRICE_LIMIT_1 = 0.1 ether;\n', '\n', '  // Appreciation steps for each price limit\n', '  uint256 private constant APPRECIATION_STEP_1 = 0.0005 ether;\n', '  uint256 private constant APPRECIATION_STEP_2 = 0.0001 ether;\n', '\n', '  // Max count which can be bought with one transaction\n', '  uint256 private constant MAX_ORDER = 5;\n', '\n', "  // 0 - 9 valid Id's for cars\n", '  uint256 private constant CAR_MODELS = 10;\n', '\n', "  // The special car (the most rarest one) which can't be picked even with MAX_ORDER\n", '  uint256 public constant UNICORN_ID = 0;\n', '\n', '  // Maps any number from 0 - 255 to 0 - 9 car Id\n', '  uint256[] private PROBABILITY_MAP = [4, 18, 32, 46, 81, 116, 151, 186, 221, 256];\n', '\n', '  // Step by which the price should be changed\n', '  uint256 public appreciationStep = APPRECIATION_STEP_1;\n', '\n', '  // Current price of the car. The price appreciation is happening with each new sale.\n', '  uint256 public currentPrice = 0.001 ether;\n', '\n', '  // Overall cars count\n', '  uint256 public carsCount;\n', '\n', '  // Overall gifted cars count\n', '  uint256 public carsGifted;\n', '\n', '  // Gifted unicorn cars count\n', '  uint256 public unicornsGifted;\n', '\n', '  // A mapping from addresses to the carIds\n', '  mapping (address => uint256[]) private ownerToCars;\n', '\n', '  // A mapping from addresses to the upgrade packages\n', '  mapping (address => uint256) private ownerToUpgradePackages;\n', '\n', '  // Events\n', '  event CarsPurchased(address indexed _owner, uint256[] _carIds, bool _upgradePackage, uint256 _pricePayed);\n', '  event CarGifted(address indexed _receiver, uint256 _carId, bool _upgradePackage);\n', '\n', '  // Buy a car. The cars are unique within the order.\n', '  // If order count is 5 then one car can be preselected.\n', '  function purchaseCars(uint256 _carsToBuy, uint256 _pickedId, bool _upgradePackage) public payable whenNotPaused {\n', '    require(now < PRESALE_END_TIMESTAMP);\n', '    require(_carsToBuy > 0 && _carsToBuy <= MAX_ORDER);\n', '    require(carsCount + _carsToBuy <= MAX_CARS);\n', '\n', '    uint256 priceToPay = calculatePrice(_carsToBuy, _upgradePackage);\n', '    require(msg.value >= priceToPay);\n', '\n', '    // return excess ether\n', '    uint256 excess = msg.value.sub(priceToPay);\n', '    if (excess > 0) {\n', '      msg.sender.transfer(excess);\n', '    }\n', '\n', '    // initialize an array for the new cars\n', '    uint256[] memory randomCars = new uint256[](_carsToBuy);\n', '    // shows from which point the randomCars array should be filled\n', '    uint256 startFrom = 0;\n', '\n', '    // for MAX_ORDERs the first item is user picked\n', '    if (_carsToBuy == MAX_ORDER) {\n', '      require(_pickedId < CAR_MODELS);\n', '      require(_pickedId != UNICORN_ID);\n', '\n', '      randomCars[0] = _pickedId;\n', '      startFrom = 1;\n', '    }\n', '    fillRandomCars(randomCars, startFrom);\n', '\n', "    // add new cars to the owner's list\n", '    for (uint256 i = 0; i < randomCars.length; i++) {\n', '      ownerToCars[msg.sender].push(randomCars[i]);\n', '    }\n', '\n', '    // increment upgrade packages\n', '    if (_upgradePackage) {\n', '      ownerToUpgradePackages[msg.sender] += _carsToBuy;\n', '    }\n', '\n', '    CarsPurchased(msg.sender, randomCars, _upgradePackage, priceToPay);\n', '\n', '    carsCount += _carsToBuy;\n', '    currentPrice += _carsToBuy * appreciationStep;\n', '\n', '    // update this once per purchase\n', '    // to save the gas and to simplify the calculations\n', '    updateAppreciationStep();\n', '  }\n', '\n', '  // MAX_CARS_TO_GIFT amout of cars are dedicated for gifts\n', '  function giftCar(address _receiver, uint256 _carId, bool _upgradePackage) public onlyCLevel {\n', '    // NOTE\n', '    // Some promo results will be calculated after the presale,\n', '    // so there is no need to check for the PRESALE_END_TIMESTAMP.\n', '\n', '    require(_carId < CAR_MODELS);\n', '    require(_receiver != address(0));\n', '\n', '    // check limits\n', '    require(carsCount < MAX_CARS);\n', '    require(carsGifted < MAX_CARS_TO_GIFT);\n', '    if (_carId == UNICORN_ID) {\n', '      require(unicornsGifted < MAX_UNICORNS_TO_GIFT);\n', '    }\n', '\n', '    ownerToCars[_receiver].push(_carId);\n', '    if (_upgradePackage) {\n', '      ownerToUpgradePackages[_receiver] += 1;\n', '    }\n', '\n', '    CarGifted(_receiver, _carId, _upgradePackage);\n', '\n', '    carsCount += 1;\n', '    carsGifted += 1;\n', '    if (_carId == UNICORN_ID) {\n', '      unicornsGifted += 1;\n', '    }\n', '\n', '    currentPrice += appreciationStep;\n', '    updateAppreciationStep();\n', '  }\n', '\n', '  function calculatePrice(uint256 _carsToBuy, bool _upgradePackage) private view returns (uint256) {\n', '    // Arithmetic Sequence\n', '    // A(n) = A(0) + (n - 1) * D\n', '    uint256 lastPrice = currentPrice + (_carsToBuy - 1) * appreciationStep;\n', '\n', '    // Sum of the First n Terms of an Arithmetic Sequence\n', '    // S(n) = n * (a(1) + a(n)) / 2\n', '    uint256 priceToPay = _carsToBuy * (currentPrice + lastPrice) / 2;\n', '\n', '    // add an extra amount for the upgrade package\n', '    if (_upgradePackage) {\n', '      if (_carsToBuy < 3) {\n', '        priceToPay = priceToPay * 120 / 100; // 20% extra\n', '      } else if (_carsToBuy < 5) {\n', '        priceToPay = priceToPay * 115 / 100; // 15% extra\n', '      } else {\n', '        priceToPay = priceToPay * 110 / 100; // 10% extra\n', '      }\n', '    }\n', '\n', '    return priceToPay;\n', '  }\n', '\n', '  // Fill unique random cars into _randomCars starting from _startFrom\n', '  // as some slots may be already filled\n', '  function fillRandomCars(uint256[] _randomCars, uint256 _startFrom) private view {\n', '    // All random cars for the current purchase are generated from this 32 bytes.\n', '    // All purchases within a same block will get different car combinations\n', '    // as current price is changed at the end of the purchase.\n', '    //\n', "    // We don't need super secure random algorithm as it's just presale\n", '    // and if someone can time the block and grab the desired car we are just happy for him / her\n', '    bytes32 rand32 = keccak256(currentPrice, now);\n', '    uint256 randIndex = 0;\n', '    uint256 carId;\n', '\n', '    for (uint256 i = _startFrom; i < _randomCars.length; i++) {\n', '      do {\n', '        // the max number for one purchase is limited to 5\n', '        // 32 tries are more than enough to generate 5 unique numbers\n', '        require(randIndex < 32);\n', '        carId = generateCarId(uint8(rand32[randIndex]));\n', '        randIndex++;\n', '      } while(alreadyContains(_randomCars, carId, i));\n', '      _randomCars[i] = carId;\n', '    }\n', '  }\n', '\n', '  // Generate a car ID from the given serial number (0 - 255)\n', '  function generateCarId(uint256 _serialNumber) private view returns (uint256) {\n', '    for (uint256 i = 0; i < PROBABILITY_MAP.length; i++) {\n', '      if (_serialNumber < PROBABILITY_MAP[i]) {\n', '        return i;\n', '      }\n', '    }\n', '    // we should not reach to this point\n', '    assert(false);\n', '  }\n', '\n', '  // Check if the given value is already in the list.\n', '  // By default all items are 0 so _to is used explicitly to validate 0 values.\n', '  function alreadyContains(uint256[] _list, uint256 _value, uint256 _to) private pure returns (bool) {\n', '    for (uint256 i = 0; i < _to; i++) {\n', '      if (_list[i] == _value) {\n', '        return true;\n', '      }\n', '    }\n', '    return false;\n', '  }\n', '\n', '  function updateAppreciationStep() private {\n', '    // this method is called once per purcahse\n', "    // so use 'greater than' not to miss the limit\n", '    if (currentPrice > PRICE_LIMIT_1) {\n', "      // don't update if there is no change\n", '      if (appreciationStep != APPRECIATION_STEP_2) {\n', '        appreciationStep = APPRECIATION_STEP_2;\n', '      }\n', '    }\n', '  }\n', '\n', '  function carCountOf(address _owner) public view returns (uint256 _carCount) {\n', '    return ownerToCars[_owner].length;\n', '  }\n', '\n', '  function carOfByIndex(address _owner, uint256 _index) public view returns (uint256 _carId) {\n', '    return ownerToCars[_owner][_index];\n', '  }\n', '\n', '  function carsOf(address _owner) public view returns (uint256[] _carIds) {\n', '    return ownerToCars[_owner];\n', '  }\n', '\n', '  function upgradePackageCountOf(address _owner) public view returns (uint256 _upgradePackageCount) {\n', '    return ownerToUpgradePackages[_owner];\n', '  }\n', '\n', '  function allOf(address _owner) public view returns (uint256[] _carIds, uint256 _upgradePackageCount) {\n', '    return (ownerToCars[_owner], ownerToUpgradePackages[_owner]);\n', '  }\n', '\n', '  function getStats() public view returns (uint256 _carsCount, uint256 _carsGifted, uint256 _unicornsGifted, uint256 _currentPrice, uint256 _appreciationStep) {\n', '    return (carsCount, carsGifted, unicornsGifted, currentPrice, appreciationStep);\n', '  }\n', '\n', '  function withdrawBalance(address _to, uint256 _amount) public onlyCEO {\n', '    if (_amount == 0) {\n', '      _amount = address(this).balance;\n', '    }\n', '\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(_amount);\n', '    } else {\n', '      _to.transfer(_amount);\n', '    }\n', '  }\n', '\n', '\n', '  // Raffle\n', '  // max count of raffle participants\n', '  uint256 public raffleLimit = 50;\n', '\n', '  // list of raffle participants\n', '  address[] private raffleList;\n', '\n', '  // Events\n', '  event Raffle2Registered(address indexed _iuser, address _user);\n', '  event Raffle3Registered(address _user);\n', '\n', '  function isInRaffle(address _address) public view returns (bool) {\n', '    for (uint256 i = 0; i < raffleList.length; i++) {\n', '      if (raffleList[i] == _address) {\n', '        return true;\n', '      }\n', '    }\n', '    return false;\n', '  }\n', '\n', '  function getRaffleStats() public view returns (address[], uint256) {\n', '    return (raffleList, raffleLimit);\n', '  }\n', '\n', '  function drawRaffle(uint256 _carId) public onlyCLevel {\n', '    bytes32 rand32 = keccak256(now, raffleList.length);\n', '    uint256 winner = uint(rand32) % raffleList.length;\n', '\n', '    giftCar(raffleList[winner], _carId, true);\n', '  }\n', '\n', '  function resetRaffle() public onlyCLevel {\n', '    delete raffleList;\n', '  }\n', '\n', '  function setRaffleLimit(uint256 _limit) public onlyCLevel {\n', '    raffleLimit = _limit;\n', '  }\n', '\n', '  // Raffle v1\n', '  function registerForRaffle() public {\n', '    require(raffleList.length < raffleLimit);\n', '    require(!isInRaffle(msg.sender));\n', '    raffleList.push(msg.sender);\n', '  }\n', '\n', '  // Raffle v2\n', '  function registerForRaffle2() public {\n', '    Raffle2Registered(msg.sender, msg.sender);\n', '  }\n', '\n', '  // Raffle v3\n', '  function registerForRaffle3() public payable {\n', '    Raffle3Registered(msg.sender);\n', '  }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']