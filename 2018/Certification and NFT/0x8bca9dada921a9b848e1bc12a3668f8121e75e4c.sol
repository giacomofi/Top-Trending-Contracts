['pragma solidity ^0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', '// input  D:\\Repositories\\GitHub\\Cronos\\src\\CRS.Presale.Contract\\contracts\\Presale.sol\n', '// flattened :  Friday, 28-Dec-18 10:47:36 UTC\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract ReentrancyGuard {\n', '\n', '  /// @dev counter to allow mutex lock with only one SSTORE operation\n', '  uint256 private _guardCounter;\n', '\n', '  constructor() internal {\n', '    // The counter starts at one to prevent changing it from zero to a non-zero\n', '    // value, which is a more expensive operation.\n', '    _guardCounter = 1;\n', '  }\n', '\n', '  /**\n', '   * @dev Prevents a contract from calling itself, directly or indirectly.\n', '   * Calling a `nonReentrant` function from another `nonReentrant`\n', '   * function is not supported. It is possible to prevent this from happening\n', '   * by making the `nonReentrant` function external, and make it call a\n', '   * `private` function that does the actual work.\n', '   */\n', '  modifier nonReentrant() {\n', '    _guardCounter += 1;\n', '    uint256 localCounter = _guardCounter;\n', '    _;\n', '    require(localCounter == _guardCounter);\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Presale is Ownable, ReentrancyGuard {\n', '  using SafeMath for uint256;\n', '\n', '  struct ReferralData {\n', '    uint256 referrals; // number of referrals\n', '    uint256 bonusSum;  // sum of all bonuses - this is just for showing the total amount - for payouts the referralBonuses mapping will be used\n', '    address[] children; // child referrals\n', '  }\n', '\n', '  uint256 public currentPrice = 0;\n', '\n', '  bool public isActive = false;\n', '\n', '  uint256 public currentDiscountSum = 0;                       // current sum of all discounts (have to stay in the contract for payout)\n', '  uint256 public overallDiscountSum = 0;                       // sum of all discounts given since beginning\n', '\n', '  bool public referralsEnabled = true;                      // are referrals enabled in general\n', '\n', '  mapping(address => uint) private referralBonuses;\n', '\n', '  uint256 public referralBonusMaxDepth = 3;                                  // used to ensure the max depth\n', '  mapping(uint256 => uint) public currentReferralCommissionPercentages;      // commission levels\n', '  uint256 public currentReferralBuyerDiscountPercentage = 5;                 // discount percentage if a buyer uses a valid affiliate link\n', '\n', '  mapping(address => address) private parentReferrals;    // parent relationship\n', '  mapping(address => ReferralData) private referralData;  // referral data for this address\n', '  mapping(address => uint) private nodesBought;           // number of bought nodes\n', '\n', '  mapping(address => bool) private manuallyAddedReferrals; // we need a chance to add referrals manually since this is needed for promotion\n', '\n', '  event MasternodeSold(address buyer, uint256 price, string coinsTargetAddress, bool referral);\n', '  event MasternodePriceChanged(uint256 price);\n', '  event ReferralAdded(address buyer, address parent);\n', '\n', '  constructor() public {\n', '    currentReferralCommissionPercentages[0] = 10;\n', '    currentReferralCommissionPercentages[1] = 5;\n', '    currentReferralCommissionPercentages[2] = 3;\n', '  }\n', '\n', '  function () external payable {\n', '      // nothing to do\n', '  }\n', '\n', '  function buyMasternode(string memory coinsTargetAddress) public nonReentrant payable {\n', '    _buyMasternode(coinsTargetAddress, false, owner());\n', '  }\n', '\n', '  function buyMasternodeReferral(string memory coinsTargetAddress, address referral) public nonReentrant payable {\n', '    _buyMasternode(coinsTargetAddress, referralsEnabled, referral);\n', '  }\n', '\n', '  function _buyMasternode(string memory coinsTargetAddress, bool useReferral, address referral) internal {\n', '    require(isActive, "Buying is currently deactivated.");\n', '    require(currentPrice > 0, "There was no MN price set so far.");\n', '\n', '    uint256 nodePrice = currentPrice;\n', '\n', '    // nodes can be bought cheaper if the user uses a valid referral address\n', '    if (useReferral && isValidReferralAddress(referral)) {\n', '      nodePrice = getDiscountedNodePrice();\n', '    }\n', '\n', '    require(msg.value >= nodePrice, "Sent amount of ETH was too low.");\n', '\n', '    // check target address\n', '    uint256 length = bytes(coinsTargetAddress).length;\n', '    require(length >= 30 && length <= 42 , "Coins target address invalid");\n', '\n', '    if (useReferral && isValidReferralAddress(referral)) {\n', '\n', '      require(msg.sender != referral, "You can\'t be your own referral.");\n', '\n', '      // set parent/child relations (only if there is no connection/parent yet available)\n', "      // --> this also means that a referral structure can't be changed\n", '      address parent = parentReferrals[msg.sender];\n', '      if (referralData[parent].referrals == 0) {\n', '        referralData[referral].referrals = referralData[referral].referrals.add(1);\n', '        referralData[referral].children.push(msg.sender);\n', '        parentReferrals[msg.sender] = referral;\n', '      }\n', '\n', '      // iterate over commissionLevels and calculate commissions\n', '      uint256 discountSumForThisPayment = 0;\n', '      address currentReferral = referral;\n', '\n', '      for (uint256 level=0; level < referralBonusMaxDepth; level++) {\n', '        // only apply discount if referral address is valid (or as long we can step up the hierarchy)\n', '        if(isValidReferralAddress(currentReferral)) {\n', '\n', '          require(msg.sender != currentReferral, "Invalid referral structure (you can\'t be in your own tree)");\n', '\n', '          // do not take node price here since it could be already dicounted\n', '          uint256 referralBonus = currentPrice.div(100).mul(currentReferralCommissionPercentages[level]);\n', '\n', '          // set payout bonus\n', '          referralBonuses[currentReferral] = referralBonuses[currentReferral].add(referralBonus);\n', '\n', '          // set stats/counters\n', '          referralData[currentReferral].bonusSum = referralData[currentReferral].bonusSum.add(referralBonus);\n', '          discountSumForThisPayment = discountSumForThisPayment.add(referralBonus);\n', '\n', '          // step up one hierarchy level\n', '          currentReferral = parentReferrals[currentReferral];\n', '        } else {\n', "          // we can't find any parent - stop hierarchy calculation\n", '          break;\n', '        }\n', '      }\n', '\n', '      require(discountSumForThisPayment < nodePrice, "Wrong calculation of bonuses/discounts - would be higher than the price itself");\n', '\n', '      currentDiscountSum = currentDiscountSum.add(discountSumForThisPayment);\n', '      overallDiscountSum = overallDiscountSum.add(discountSumForThisPayment);\n', '    }\n', '\n', '    // set the node bought counter\n', '    nodesBought[msg.sender] = nodesBought[msg.sender].add(1);\n', '\n', '    emit MasternodeSold(msg.sender, currentPrice, coinsTargetAddress, useReferral);\n', '  }\n', '\n', '  function setActiveState(bool active) public onlyOwner {\n', '    isActive = active;\n', '  }\n', '\n', '  function setPrice(uint256 price) public onlyOwner {\n', '    require(price > 0, "Price has to be greater than zero.");\n', '\n', '    currentPrice = price;\n', '\n', '    emit MasternodePriceChanged(price);\n', '  }\n', '\n', '  function setReferralsEnabledState(bool _referralsEnabled) public onlyOwner {\n', '    referralsEnabled = _referralsEnabled;\n', '  }\n', '\n', '  function setReferralCommissionPercentageLevel(uint256 level, uint256 percentage) public onlyOwner {\n', '    require(percentage >= 0 && percentage <= 20, "Percentage has to be between 0 and 20.");\n', '    require(level >= 0 && level < referralBonusMaxDepth, "Invalid depth level");\n', '\n', '    currentReferralCommissionPercentages[level] = percentage;\n', '  }\n', '\n', '  function setReferralBonusMaxDepth(uint256 depth) public onlyOwner {\n', '    require(depth >= 0 && depth <= 10, "Referral bonus depth too high.");\n', '\n', '    referralBonusMaxDepth = depth;\n', '  }\n', '\n', '  function setReferralBuyerDiscountPercentage(uint256 percentage) public onlyOwner {\n', '    require(percentage >= 0 && percentage <= 20, "Percentage has to be between 0 and 20.");\n', '\n', '    currentReferralBuyerDiscountPercentage = percentage;\n', '  }\n', '\n', '  function addReferralAddress(address addr) public onlyOwner {\n', '    manuallyAddedReferrals[addr] = true;\n', '  }\n', '\n', '  function removeReferralAddress(address addr) public onlyOwner {\n', '    manuallyAddedReferrals[addr] = false;\n', '  }\n', '\n', '  function withdraw(uint256 amount) public onlyOwner {\n', '    owner().transfer(amount);\n', '  }\n', '\n', '  function withdrawReferralBonus() public nonReentrant returns (bool) {\n', '    uint256 amount = referralBonuses[msg.sender];\n', '\n', '    if (amount > 0) {\n', '        referralBonuses[msg.sender] = 0;\n', '        currentDiscountSum = currentDiscountSum.sub(amount);\n', '\n', '        if (!msg.sender.send(amount)) {\n', '            referralBonuses[msg.sender] = amount;\n', '            currentDiscountSum = currentDiscountSum.add(amount);\n', '\n', '            return false;\n', '        }\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  function checkReferralBonusHeight(address addr) public view returns (uint) {\n', '      return referralBonuses[addr];\n', '  }\n', '\n', '  function getNrOfReferrals(address addr) public view returns (uint) {\n', '      return referralData[addr].referrals;\n', '  }\n', '\n', '  function getReferralBonusSum(address addr) public view returns (uint) {\n', '      return referralData[addr].bonusSum;\n', '  }\n', '\n', '  function getReferralChildren(address addr) public view returns (address[] memory) {\n', '      return referralData[addr].children;\n', '  }\n', '\n', '  function getReferralChild(address addr, uint256 idx) public view returns (address) {\n', '      return referralData[addr].children[idx];\n', '  }\n', '\n', '  function isValidReferralAddress(address addr) public view returns (bool) {\n', '      return nodesBought[addr] > 0 || manuallyAddedReferrals[addr] == true;\n', '  }\n', '\n', '  function getNodesBoughtCountForAddress(address addr) public view returns (uint256) {\n', '      return nodesBought[addr];\n', '  }\n', '\n', '  function getDiscountedNodePrice() public view returns (uint256) {\n', '      return currentPrice.sub(currentPrice.div(100).mul(currentReferralBuyerDiscountPercentage));\n', '  }\n', '}']