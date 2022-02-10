['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20Token {\n', '  function balanceOf(address _who) constant returns (uint balance);\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '  function transferFrom(address _from, address _to, uint _value);\n', '  function transfer(address _to, uint _value);\n', '}\n', 'contract GroveAPI {\n', '  function insert(bytes32 indexName, bytes32 id, int value) public;\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract UnicornRanch {\n', '  using SafeMath for uint;\n', '\n', '  enum VisitType { Spa, Afternoon, Day, Overnight, Week, Extended }\n', '  enum VisitState { InProgress, Completed, Repossessed }\n', '  \n', '  struct Visit {\n', '    uint unicornCount;\n', '    VisitType t;\n', '    uint startBlock;\n', '    uint expiresBlock;\n', '    VisitState state;\n', '    uint completedBlock;\n', '    uint completedCount;\n', '  }\n', '  struct VisitMeta {\n', '    address owner;\n', '    uint index;\n', '  }\n', '  \n', '  address public cardboardUnicornTokenAddress;\n', '  address public groveAddress;\n', '  address public owner = msg.sender;\n', '  mapping (address => Visit[]) bookings;\n', '  mapping (bytes32 => VisitMeta) public bookingMetadataForKey;\n', '  mapping (uint8 => uint) public visitLength;\n', '  mapping (uint8 => uint) public visitCost;\n', '  uint public visitingUnicorns = 0;\n', '  uint public repossessionBlocks = 43200;\n', '  uint8 public repossessionBountyPerTen = 2;\n', '  uint8 public repossessionBountyPerHundred = 25;\n', '  uint public birthBlockThreshold = 43860;\n', '  uint8 public birthPerTen = 1;\n', '  uint8 public birthPerHundred = 15;\n', '\n', '  event NewBooking(address indexed _who, uint indexed _index, VisitType indexed _type, uint _unicornCount);\n', '  event BookingUpdate(address indexed _who, uint indexed _index, VisitState indexed _newState, uint _unicornCount);\n', '  event RepossessionBounty(address indexed _who, uint _unicornCount);\n', '  event DonationReceived(address indexed _who, uint _unicornCount);\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  function UnicornRanch() {\n', '    visitLength[uint8(VisitType.Spa)] = 720;\n', '    visitLength[uint8(VisitType.Afternoon)] = 1440;\n', '    visitLength[uint8(VisitType.Day)] = 2880;\n', '    visitLength[uint8(VisitType.Overnight)] = 8640;\n', '    visitLength[uint8(VisitType.Week)] = 60480;\n', '    visitLength[uint8(VisitType.Extended)] = 120960;\n', '    \n', '    visitCost[uint8(VisitType.Spa)] = 0;\n', '    visitCost[uint8(VisitType.Afternoon)] = 0;\n', '    visitCost[uint8(VisitType.Day)] = 10 szabo;\n', '    visitCost[uint8(VisitType.Overnight)] = 30 szabo;\n', '    visitCost[uint8(VisitType.Week)] = 50 szabo;\n', '    visitCost[uint8(VisitType.Extended)] = 70 szabo;\n', '  }\n', '\n', '\n', '  function getBookingCount(address _who) constant returns (uint count) {\n', '    return bookings[_who].length;\n', '  }\n', '  function getBooking(address _who, uint _index) constant returns (uint _unicornCount, VisitType _type, uint _startBlock, uint _expiresBlock, VisitState _state, uint _completedBlock, uint _completedCount) {\n', '    Visit storage v = bookings[_who][_index];\n', '    return (v.unicornCount, v.t, v.startBlock, v.expiresBlock, v.state, v.completedBlock, v.completedCount);\n', '  }\n', '\n', '  function bookSpaVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Spa, _unicornCount);\n', '  }\n', '  function bookAfternoonVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Afternoon, _unicornCount);\n', '  }\n', '  function bookDayVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Day, _unicornCount);\n', '  }\n', '  function bookOvernightVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Overnight, _unicornCount);\n', '  }\n', '  function bookWeekVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Week, _unicornCount);\n', '  }\n', '  function bookExtendedVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Extended, _unicornCount);\n', '  }\n', '  \n', '  function addBooking(VisitType _type, uint _unicornCount) payable {\n', '    if (_type == VisitType.Afternoon) {\n', '      return donateUnicorns(availableBalance(msg.sender));\n', '    }\n', '    require(msg.value >= visitCost[uint8(_type)].mul(_unicornCount)); // Must be paying proper amount\n', '\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount); // Transfer the actual asset\n', '    visitingUnicorns = visitingUnicorns.add(_unicornCount);\n', '    uint expiresBlock = block.number.add(visitLength[uint8(_type)]); // Calculate when this booking will be done\n', '    \n', '    // Add the booking to the ledger\n', '    bookings[msg.sender].push(Visit(\n', '      _unicornCount,\n', '      _type,\n', '      block.number,\n', '      expiresBlock,\n', '      VisitState.InProgress,\n', '      0,\n', '      0\n', '    ));\n', '    uint newIndex = bookings[msg.sender].length - 1;\n', '    bytes32 uniqueKey = keccak256(msg.sender, newIndex); // Create a unique key for this booking\n', '    \n', '    // Add a reference for that key, to find the metadata about it later\n', '    bookingMetadataForKey[uniqueKey] = VisitMeta(\n', '      msg.sender,\n', '      newIndex\n', '    );\n', '    \n', '    if (groveAddress > 0) {\n', '      // Insert into Grove index for applications to query\n', '      GroveAPI g = GroveAPI(groveAddress);\n', '      g.insert("bookingExpiration", uniqueKey, int(expiresBlock));\n', '    }\n', '    \n', '    // Send event about this new booking\n', '    NewBooking(msg.sender, newIndex, _type, _unicornCount);\n', '  }\n', '  \n', '  function completeBooking(uint _index) {\n', '    require(bookings[msg.sender].length > _index); // Sender must have at least this many bookings\n', '    Visit storage v = bookings[msg.sender][_index];\n', '    require(block.number >= v.expiresBlock); // Expired time must be past\n', '    require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed\n', '    \n', '    uint unicornsToReturn = v.unicornCount;\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '\n', '    // Determine if any births occurred\n', '    uint birthCount = 0;\n', '    if (SafeMath.sub(block.number, v.startBlock) >= birthBlockThreshold) {\n', '      if (v.unicornCount >= 100) {\n', '        birthCount = uint(birthPerHundred).mul(v.unicornCount / 100);\n', '      } else if (v.unicornCount >= 10) {\n', '        birthCount = uint(birthPerTen).mul(v.unicornCount / 10);\n', '      }\n', '    }\n', '    if (birthCount > 0) {\n', '      uint availableUnicorns = cardboardUnicorns.balanceOf(address(this)) - visitingUnicorns;\n', '      if (availableUnicorns < birthCount) {\n', '        birthCount = availableUnicorns;\n', '      }\n', '      unicornsToReturn = unicornsToReturn.add(birthCount);\n', '    }\n', '        \n', '    // Update the status of the Visit\n', '    v.state = VisitState.Completed;\n', '    v.completedBlock = block.number;\n', '    v.completedCount = unicornsToReturn;\n', '    bookings[msg.sender][_index] = v;\n', '    \n', '    // Transfer the asset back to the owner\n', '    visitingUnicorns = visitingUnicorns.sub(v.unicornCount);\n', '    cardboardUnicorns.transfer(msg.sender, unicornsToReturn);\n', '    \n', '    // Send event about this update\n', '    BookingUpdate(msg.sender, _index, VisitState.Completed, unicornsToReturn);\n', '  }\n', '  \n', '  function repossessBooking(address _who, uint _index) {\n', '    require(bookings[_who].length > _index); // Address in question must have at least this many bookings\n', '    Visit storage v = bookings[_who][_index];\n', '    require(block.number > v.expiresBlock.add(repossessionBlocks)); // Repossession time must be past\n', '    require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed\n', '    \n', '    visitingUnicorns = visitingUnicorns.sub(v.unicornCount);\n', '    \n', '    // Send event about this update\n', '    BookingUpdate(_who, _index, VisitState.Repossessed, v.unicornCount);\n', '    \n', '    // Calculate Bounty amount\n', '    uint bountyCount = 1;\n', '    if (v.unicornCount >= 100) {\n', '        bountyCount = uint(repossessionBountyPerHundred).mul(v.unicornCount / 100);\n', '    } else if (v.unicornCount >= 10) {\n', '      bountyCount = uint(repossessionBountyPerTen).mul(v.unicornCount / 10);\n', '    }\n', '    \n', '    // Send bounty to bounty hunter\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    cardboardUnicorns.transfer(msg.sender, bountyCount);\n', '    \n', '    // Send event about the bounty payout\n', '    RepossessionBounty(msg.sender, bountyCount);\n', '\n', '    // Update the status of the Visit\n', '    v.state = VisitState.Repossessed;\n', '    v.completedBlock = block.number;\n', '    v.completedCount = v.unicornCount - bountyCount;\n', '    bookings[_who][_index] = v;\n', '  }\n', '  \n', '  function availableBalance(address _who) internal returns (uint) {\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    uint count = cardboardUnicorns.allowance(_who, address(this));\n', '    if (count == 0) {\n', '      return 0;\n', '    }\n', '    uint balance = cardboardUnicorns.balanceOf(_who);\n', '    if (balance < count) {\n', '      return balance;\n', '    }\n', '    return count;\n', '  }\n', '  \n', '  function() payable {\n', '    if (cardboardUnicornTokenAddress == 0) {\n', '      return;\n', '    }\n', '    return donateUnicorns(availableBalance(msg.sender));\n', '  }\n', '  \n', '  function donateUnicorns(uint _unicornCount) payable {\n', '    if (_unicornCount == 0) {\n', '      return;\n', '    }\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount);\n', '    DonationReceived(msg.sender, _unicornCount);\n', '  }\n', '  \n', '  /**\n', '   * Change ownership of the Ranch\n', '   */\n', '  function changeOwner(address _newOwner) onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Change the outside contracts used by this contract\n', '   */\n', '  function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {\n', '    cardboardUnicornTokenAddress = _newTokenAddress;\n', '  }\n', '  function changeGroveAddress(address _newAddress) onlyOwner {\n', '    groveAddress = _newAddress;\n', '  }\n', '  \n', '  /**\n', '   * Update block durations for various types of visits\n', '   */\n', '  function changeVisitLengths(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {\n', '    visitLength[uint8(VisitType.Spa)] = _spa;\n', '    visitLength[uint8(VisitType.Afternoon)] = _afternoon;\n', '    visitLength[uint8(VisitType.Day)] = _day;\n', '    visitLength[uint8(VisitType.Overnight)] = _overnight;\n', '    visitLength[uint8(VisitType.Week)] = _week;\n', '    visitLength[uint8(VisitType.Extended)] = _extended;\n', '  }\n', '  \n', '  /**\n', '   * Update ether costs for various types of visits\n', '   */\n', '  function changeVisitCosts(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {\n', '    visitCost[uint8(VisitType.Spa)] = _spa;\n', '    visitCost[uint8(VisitType.Afternoon)] = _afternoon;\n', '    visitCost[uint8(VisitType.Day)] = _day;\n', '    visitCost[uint8(VisitType.Overnight)] = _overnight;\n', '    visitCost[uint8(VisitType.Week)] = _week;\n', '    visitCost[uint8(VisitType.Extended)] = _extended;\n', '  }\n', '  \n', '  /**\n', '   * Update bounty reward settings\n', '   */\n', '  function changeRepoSettings(uint _repoBlocks, uint8 _repoPerTen, uint8 _repoPerHundred) onlyOwner {\n', '    repossessionBlocks = _repoBlocks;\n', '    repossessionBountyPerTen = _repoPerTen;\n', '    repossessionBountyPerHundred = _repoPerHundred;\n', '  }\n', '  \n', '  /**\n', '   * Update birth event settings\n', '   */\n', '  function changeBirthSettings(uint _birthBlocks, uint8 _birthPerTen, uint8 _birthPerHundred) onlyOwner {\n', '    birthBlockThreshold = _birthBlocks;\n', '    birthPerTen = _birthPerTen;\n', '    birthPerHundred = _birthPerHundred;\n', '  }\n', '\n', '  function withdraw() onlyOwner {\n', '    owner.transfer(this.balance); // Send all ether in this contract to this contract&#39;s owner\n', '  }\n', '  function withdrawForeignTokens(address _tokenContract) onlyOwner {\n', '    ERC20Token token = ERC20Token(_tokenContract);\n', '    token.transfer(owner, token.balanceOf(address(this))); // Send all owned tokens to this contract&#39;s owner\n', '  }\n', '  \n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20Token {\n', '  function balanceOf(address _who) constant returns (uint balance);\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '  function transferFrom(address _from, address _to, uint _value);\n', '  function transfer(address _to, uint _value);\n', '}\n', 'contract GroveAPI {\n', '  function insert(bytes32 indexName, bytes32 id, int value) public;\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract UnicornRanch {\n', '  using SafeMath for uint;\n', '\n', '  enum VisitType { Spa, Afternoon, Day, Overnight, Week, Extended }\n', '  enum VisitState { InProgress, Completed, Repossessed }\n', '  \n', '  struct Visit {\n', '    uint unicornCount;\n', '    VisitType t;\n', '    uint startBlock;\n', '    uint expiresBlock;\n', '    VisitState state;\n', '    uint completedBlock;\n', '    uint completedCount;\n', '  }\n', '  struct VisitMeta {\n', '    address owner;\n', '    uint index;\n', '  }\n', '  \n', '  address public cardboardUnicornTokenAddress;\n', '  address public groveAddress;\n', '  address public owner = msg.sender;\n', '  mapping (address => Visit[]) bookings;\n', '  mapping (bytes32 => VisitMeta) public bookingMetadataForKey;\n', '  mapping (uint8 => uint) public visitLength;\n', '  mapping (uint8 => uint) public visitCost;\n', '  uint public visitingUnicorns = 0;\n', '  uint public repossessionBlocks = 43200;\n', '  uint8 public repossessionBountyPerTen = 2;\n', '  uint8 public repossessionBountyPerHundred = 25;\n', '  uint public birthBlockThreshold = 43860;\n', '  uint8 public birthPerTen = 1;\n', '  uint8 public birthPerHundred = 15;\n', '\n', '  event NewBooking(address indexed _who, uint indexed _index, VisitType indexed _type, uint _unicornCount);\n', '  event BookingUpdate(address indexed _who, uint indexed _index, VisitState indexed _newState, uint _unicornCount);\n', '  event RepossessionBounty(address indexed _who, uint _unicornCount);\n', '  event DonationReceived(address indexed _who, uint _unicornCount);\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  function UnicornRanch() {\n', '    visitLength[uint8(VisitType.Spa)] = 720;\n', '    visitLength[uint8(VisitType.Afternoon)] = 1440;\n', '    visitLength[uint8(VisitType.Day)] = 2880;\n', '    visitLength[uint8(VisitType.Overnight)] = 8640;\n', '    visitLength[uint8(VisitType.Week)] = 60480;\n', '    visitLength[uint8(VisitType.Extended)] = 120960;\n', '    \n', '    visitCost[uint8(VisitType.Spa)] = 0;\n', '    visitCost[uint8(VisitType.Afternoon)] = 0;\n', '    visitCost[uint8(VisitType.Day)] = 10 szabo;\n', '    visitCost[uint8(VisitType.Overnight)] = 30 szabo;\n', '    visitCost[uint8(VisitType.Week)] = 50 szabo;\n', '    visitCost[uint8(VisitType.Extended)] = 70 szabo;\n', '  }\n', '\n', '\n', '  function getBookingCount(address _who) constant returns (uint count) {\n', '    return bookings[_who].length;\n', '  }\n', '  function getBooking(address _who, uint _index) constant returns (uint _unicornCount, VisitType _type, uint _startBlock, uint _expiresBlock, VisitState _state, uint _completedBlock, uint _completedCount) {\n', '    Visit storage v = bookings[_who][_index];\n', '    return (v.unicornCount, v.t, v.startBlock, v.expiresBlock, v.state, v.completedBlock, v.completedCount);\n', '  }\n', '\n', '  function bookSpaVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Spa, _unicornCount);\n', '  }\n', '  function bookAfternoonVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Afternoon, _unicornCount);\n', '  }\n', '  function bookDayVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Day, _unicornCount);\n', '  }\n', '  function bookOvernightVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Overnight, _unicornCount);\n', '  }\n', '  function bookWeekVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Week, _unicornCount);\n', '  }\n', '  function bookExtendedVisit(uint _unicornCount) payable {\n', '    return addBooking(VisitType.Extended, _unicornCount);\n', '  }\n', '  \n', '  function addBooking(VisitType _type, uint _unicornCount) payable {\n', '    if (_type == VisitType.Afternoon) {\n', '      return donateUnicorns(availableBalance(msg.sender));\n', '    }\n', '    require(msg.value >= visitCost[uint8(_type)].mul(_unicornCount)); // Must be paying proper amount\n', '\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount); // Transfer the actual asset\n', '    visitingUnicorns = visitingUnicorns.add(_unicornCount);\n', '    uint expiresBlock = block.number.add(visitLength[uint8(_type)]); // Calculate when this booking will be done\n', '    \n', '    // Add the booking to the ledger\n', '    bookings[msg.sender].push(Visit(\n', '      _unicornCount,\n', '      _type,\n', '      block.number,\n', '      expiresBlock,\n', '      VisitState.InProgress,\n', '      0,\n', '      0\n', '    ));\n', '    uint newIndex = bookings[msg.sender].length - 1;\n', '    bytes32 uniqueKey = keccak256(msg.sender, newIndex); // Create a unique key for this booking\n', '    \n', '    // Add a reference for that key, to find the metadata about it later\n', '    bookingMetadataForKey[uniqueKey] = VisitMeta(\n', '      msg.sender,\n', '      newIndex\n', '    );\n', '    \n', '    if (groveAddress > 0) {\n', '      // Insert into Grove index for applications to query\n', '      GroveAPI g = GroveAPI(groveAddress);\n', '      g.insert("bookingExpiration", uniqueKey, int(expiresBlock));\n', '    }\n', '    \n', '    // Send event about this new booking\n', '    NewBooking(msg.sender, newIndex, _type, _unicornCount);\n', '  }\n', '  \n', '  function completeBooking(uint _index) {\n', '    require(bookings[msg.sender].length > _index); // Sender must have at least this many bookings\n', '    Visit storage v = bookings[msg.sender][_index];\n', '    require(block.number >= v.expiresBlock); // Expired time must be past\n', '    require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed\n', '    \n', '    uint unicornsToReturn = v.unicornCount;\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '\n', '    // Determine if any births occurred\n', '    uint birthCount = 0;\n', '    if (SafeMath.sub(block.number, v.startBlock) >= birthBlockThreshold) {\n', '      if (v.unicornCount >= 100) {\n', '        birthCount = uint(birthPerHundred).mul(v.unicornCount / 100);\n', '      } else if (v.unicornCount >= 10) {\n', '        birthCount = uint(birthPerTen).mul(v.unicornCount / 10);\n', '      }\n', '    }\n', '    if (birthCount > 0) {\n', '      uint availableUnicorns = cardboardUnicorns.balanceOf(address(this)) - visitingUnicorns;\n', '      if (availableUnicorns < birthCount) {\n', '        birthCount = availableUnicorns;\n', '      }\n', '      unicornsToReturn = unicornsToReturn.add(birthCount);\n', '    }\n', '        \n', '    // Update the status of the Visit\n', '    v.state = VisitState.Completed;\n', '    v.completedBlock = block.number;\n', '    v.completedCount = unicornsToReturn;\n', '    bookings[msg.sender][_index] = v;\n', '    \n', '    // Transfer the asset back to the owner\n', '    visitingUnicorns = visitingUnicorns.sub(v.unicornCount);\n', '    cardboardUnicorns.transfer(msg.sender, unicornsToReturn);\n', '    \n', '    // Send event about this update\n', '    BookingUpdate(msg.sender, _index, VisitState.Completed, unicornsToReturn);\n', '  }\n', '  \n', '  function repossessBooking(address _who, uint _index) {\n', '    require(bookings[_who].length > _index); // Address in question must have at least this many bookings\n', '    Visit storage v = bookings[_who][_index];\n', '    require(block.number > v.expiresBlock.add(repossessionBlocks)); // Repossession time must be past\n', '    require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed\n', '    \n', '    visitingUnicorns = visitingUnicorns.sub(v.unicornCount);\n', '    \n', '    // Send event about this update\n', '    BookingUpdate(_who, _index, VisitState.Repossessed, v.unicornCount);\n', '    \n', '    // Calculate Bounty amount\n', '    uint bountyCount = 1;\n', '    if (v.unicornCount >= 100) {\n', '        bountyCount = uint(repossessionBountyPerHundred).mul(v.unicornCount / 100);\n', '    } else if (v.unicornCount >= 10) {\n', '      bountyCount = uint(repossessionBountyPerTen).mul(v.unicornCount / 10);\n', '    }\n', '    \n', '    // Send bounty to bounty hunter\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    cardboardUnicorns.transfer(msg.sender, bountyCount);\n', '    \n', '    // Send event about the bounty payout\n', '    RepossessionBounty(msg.sender, bountyCount);\n', '\n', '    // Update the status of the Visit\n', '    v.state = VisitState.Repossessed;\n', '    v.completedBlock = block.number;\n', '    v.completedCount = v.unicornCount - bountyCount;\n', '    bookings[_who][_index] = v;\n', '  }\n', '  \n', '  function availableBalance(address _who) internal returns (uint) {\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    uint count = cardboardUnicorns.allowance(_who, address(this));\n', '    if (count == 0) {\n', '      return 0;\n', '    }\n', '    uint balance = cardboardUnicorns.balanceOf(_who);\n', '    if (balance < count) {\n', '      return balance;\n', '    }\n', '    return count;\n', '  }\n', '  \n', '  function() payable {\n', '    if (cardboardUnicornTokenAddress == 0) {\n', '      return;\n', '    }\n', '    return donateUnicorns(availableBalance(msg.sender));\n', '  }\n', '  \n', '  function donateUnicorns(uint _unicornCount) payable {\n', '    if (_unicornCount == 0) {\n', '      return;\n', '    }\n', '    ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);\n', '    cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount);\n', '    DonationReceived(msg.sender, _unicornCount);\n', '  }\n', '  \n', '  /**\n', '   * Change ownership of the Ranch\n', '   */\n', '  function changeOwner(address _newOwner) onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '\n', '  /**\n', '   * Change the outside contracts used by this contract\n', '   */\n', '  function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {\n', '    cardboardUnicornTokenAddress = _newTokenAddress;\n', '  }\n', '  function changeGroveAddress(address _newAddress) onlyOwner {\n', '    groveAddress = _newAddress;\n', '  }\n', '  \n', '  /**\n', '   * Update block durations for various types of visits\n', '   */\n', '  function changeVisitLengths(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {\n', '    visitLength[uint8(VisitType.Spa)] = _spa;\n', '    visitLength[uint8(VisitType.Afternoon)] = _afternoon;\n', '    visitLength[uint8(VisitType.Day)] = _day;\n', '    visitLength[uint8(VisitType.Overnight)] = _overnight;\n', '    visitLength[uint8(VisitType.Week)] = _week;\n', '    visitLength[uint8(VisitType.Extended)] = _extended;\n', '  }\n', '  \n', '  /**\n', '   * Update ether costs for various types of visits\n', '   */\n', '  function changeVisitCosts(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {\n', '    visitCost[uint8(VisitType.Spa)] = _spa;\n', '    visitCost[uint8(VisitType.Afternoon)] = _afternoon;\n', '    visitCost[uint8(VisitType.Day)] = _day;\n', '    visitCost[uint8(VisitType.Overnight)] = _overnight;\n', '    visitCost[uint8(VisitType.Week)] = _week;\n', '    visitCost[uint8(VisitType.Extended)] = _extended;\n', '  }\n', '  \n', '  /**\n', '   * Update bounty reward settings\n', '   */\n', '  function changeRepoSettings(uint _repoBlocks, uint8 _repoPerTen, uint8 _repoPerHundred) onlyOwner {\n', '    repossessionBlocks = _repoBlocks;\n', '    repossessionBountyPerTen = _repoPerTen;\n', '    repossessionBountyPerHundred = _repoPerHundred;\n', '  }\n', '  \n', '  /**\n', '   * Update birth event settings\n', '   */\n', '  function changeBirthSettings(uint _birthBlocks, uint8 _birthPerTen, uint8 _birthPerHundred) onlyOwner {\n', '    birthBlockThreshold = _birthBlocks;\n', '    birthPerTen = _birthPerTen;\n', '    birthPerHundred = _birthPerHundred;\n', '  }\n', '\n', '  function withdraw() onlyOwner {\n', "    owner.transfer(this.balance); // Send all ether in this contract to this contract's owner\n", '  }\n', '  function withdrawForeignTokens(address _tokenContract) onlyOwner {\n', '    ERC20Token token = ERC20Token(_tokenContract);\n', "    token.transfer(owner, token.balanceOf(address(this))); // Send all owned tokens to this contract's owner\n", '  }\n', '  \n', '}']
