['pragma solidity ^0.4.24;\n', '/***\n', ' * @title -Midnight Run v0.1.0\n', ' * \n', ' *\n', ' *    ███╗   ███╗██╗██████╗ ███╗   ██╗██╗ ██████╗ ██╗  ██╗████████╗    ██████╗ ██╗   ██╗███╗   ██╗\n', ' *    ████╗ ████║██║██╔══██╗████╗  ██║██║██╔════╝ ██║  ██║╚══██╔══╝    ██╔══██╗██║   ██║████╗  ██║\n', ' *    ██╔████╔██║██║██║  ██║██╔██╗ ██║██║██║  ███╗███████║   ██║       ██████╔╝██║   ██║██╔██╗ ██║\n', ' *    ██║╚██╔╝██║██║██║  ██║██║╚██╗██║██║██║   ██║██╔══██║   ██║       ██╔══██╗██║   ██║██║╚██╗██║\n', ' *    ██║ ╚═╝ ██║██║██████╔╝██║ ╚████║██║╚██████╔╝██║  ██║   ██║       ██║  ██║╚██████╔╝██║ ╚████║\n', ' *    ╚═╝     ╚═╝╚═╝╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝\n', ' *                                  ┌─────────────────────────┐  \n', ' *                                  │https://midnightrun.live │  \n', ' *                                  └─────────────────────────┘  \n', ' *\n', ' * This product is provided for public use without any guarantee or recourse to appeal\n', ' * \n', ' * Payouts are collectible daily after 00:00 UTC\n', ' * Referral rewards are distributed automatically.\n', ' * The last 5 in before 00:00 UTC win the midnight prize.\n', ' * \n', ' * By sending ETH to this contract you are agreeing to the terms set out in the logic listed below.\n', ' *\n', ' * WARNING1:  Do not invest more than you can afford. \n', ' * WARNING2:  You can earn. \n', ' */\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', '/***\n', ' *     __ __  __  _ __  _    ___ __  __  _ _____ ___  __   ________\n', ' *    |  V  |/  \\| |  \\| |  / _//__\\|  \\| |_   _| _ \\/  \\ / _/_   _|\n', ' *    | \\_/ | /\\ | | | &#39; | | \\_| \\/ | | &#39; | | | | v / /\\ | \\__ | |\n', ' *    |_| |_|_||_|_|_|\\__|  \\__/\\__/|_|\\__| |_| |_|_\\_||_|\\__/ |_|\n', ' */\n', 'contract MidnightRun is Ownable {\n', '  using SafeMath\n', '  for uint;\n', '\n', '  modifier isHuman() {\n', '    uint32 size;\n', '    address investor = msg.sender;\n', '    assembly {\n', '      size: = extcodesize(investor)\n', '    }\n', '    if (size > 0) {\n', '      revert("Inhuman");\n', '    }\n', '    _;\n', '  }\n', '\n', '  event DailyDividendPayout(address indexed _address, uint value, uint periodCount, uint percent, uint time);\n', '  event ReferralPayout(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time);\n', '  event MidnightRunPayout(address indexed _address, uint value, uint totalValue, uint userValue, uint time);\n', '\n', '  uint public period = 24 hours;\n', '  uint public startTime = 1537833600; //  Tue, 25 Sep 2018 00:00:00 +0000 UTC\n', '\n', '  uint public dailyDividendPercent = 300; //3%\n', '  uint public referredDividendPercent = 330; //3.3%\n', '\n', '  uint public referrerPercent = 250; //2.5%\n', '  uint public minBetLevel = 0.01 ether;\n', '\n', '  uint public referrerAndOwnerPercent = 2000; //20%\n', '  uint public currentStakeID = 1;\n', '\n', '  struct DepositInfo {\n', '    uint value;\n', '    uint firstBetTime;\n', '    uint lastBetTime;\n', '    uint lastPaymentTime;\n', '    uint nextPayAfterTime;\n', '    bool isExist;\n', '    uint id;\n', '    uint referrerID;\n', '  }\n', '\n', '  mapping(address => DepositInfo) public investorToDepostIndex;\n', '  mapping(uint => address) public idToAddressIndex;\n', '\n', '  // Jackpot\n', '  uint public midnightPrizePercent = 1000; //10%\n', '  uint public midnightPrize = 0;\n', '  uint public nextPrizeTime = startTime + period;\n', '\n', '  uint public currentPrizeStakeID = 0;\n', '\n', '  struct MidnightRunDeposit {\n', '    uint value;\n', '    address user;\n', '  }\n', '  mapping(uint => MidnightRunDeposit) public stakeIDToDepositIndex;\n', '\n', ' /**\n', '  * Constructor no need for unnecessary work in here.\n', '  */\n', '  constructor() public {\n', '  }\n', '\n', '  /**\n', '   * Fallback and entrypoint for deposits.\n', '   */\n', '  function() public payable isHuman {\n', '    if (msg.value == 0) {\n', '      collectPayoutForAddress(msg.sender);\n', '    } else {\n', '      uint refId = 1;\n', '      address referrer = bytesToAddress(msg.data);\n', '      if (investorToDepostIndex[referrer].isExist) {\n', '        refId = investorToDepostIndex[referrer].id;\n', '      }\n', '      deposit(refId);\n', '    }\n', '  }\n', '\n', '/**\n', ' * Reads the given bytes into an addtress\n', ' */\n', '  function bytesToAddress(bytes bys) private pure returns(address addr) {\n', '    assembly {\n', '      addr: = mload(add(bys, 20))\n', '    }\n', '  }\n', '\n', '/**\n', ' * Put some funds into the contract for the prize\n', ' */\n', '  function addToMidnightPrize() public payable onlyOwner {\n', '    midnightPrize += msg.value;\n', '  }\n', '\n', '/**\n', ' * Get the time of the next payout - calculated\n', ' */\n', '  function getNextPayoutTime() public view returns(uint) {\n', '    if (now<startTime) return startTime + period;\n', '    return startTime + ((now.sub(startTime)).div(period)).mul(period) + period;\n', '  }\n', '\n', '/**\n', ' * Make a deposit into the contract\n', ' */\n', '  function deposit(uint _referrerID) public payable isHuman {\n', '    require(_referrerID <= currentStakeID, "Who referred you?");\n', '    require(msg.value >= minBetLevel, "Doesn&#39;t meet minimum stake.");\n', '\n', '    // when is next midnight ?\n', '    uint nextPayAfterTime = getNextPayoutTime();\n', '\n', '    if (investorToDepostIndex[msg.sender].isExist) {\n', '      if (investorToDepostIndex[msg.sender].nextPayAfterTime < now) {\n', '        collectPayoutForAddress(msg.sender);\n', '      }\n', '      investorToDepostIndex[msg.sender].value += msg.value;\n', '      investorToDepostIndex[msg.sender].lastBetTime = now;\n', '    } else {\n', '      DepositInfo memory newDeposit;\n', '\n', '      newDeposit = DepositInfo({\n', '        value: msg.value,\n', '        firstBetTime: now,\n', '        lastBetTime: now,\n', '        lastPaymentTime: 0,\n', '        nextPayAfterTime: nextPayAfterTime,\n', '        isExist: true,\n', '        id: currentStakeID,\n', '        referrerID: _referrerID\n', '      });\n', '\n', '      investorToDepostIndex[msg.sender] = newDeposit;\n', '      idToAddressIndex[currentStakeID] = msg.sender;\n', '\n', '      currentStakeID++;\n', '    }\n', '\n', '    if (now > nextPrizeTime) {\n', '      doMidnightRun();\n', '    }\n', '\n', '    currentPrizeStakeID++;\n', '\n', '    MidnightRunDeposit memory midnitrunDeposit;\n', '    midnitrunDeposit.user = msg.sender;\n', '    midnitrunDeposit.value = msg.value;\n', '\n', '    stakeIDToDepositIndex[currentPrizeStakeID] = midnitrunDeposit;\n', '\n', '    // contribute to the Midnight Run Prize\n', '    midnightPrize += msg.value.mul(midnightPrizePercent).div(10000);\n', '    // Is there a referrer to be paid?\n', '    if (investorToDepostIndex[msg.sender].referrerID != 0) {\n', '\n', '      uint refToPay = msg.value.mul(referrerPercent).div(10000);\n', '      // Referral Fee\n', '      idToAddressIndex[investorToDepostIndex[msg.sender].referrerID].transfer(refToPay);\n', '      // Team and advertising fee\n', '      owner().transfer(msg.value.mul(referrerAndOwnerPercent - referrerPercent).div(10000));\n', '      emit ReferralPayout(msg.sender, idToAddressIndex[investorToDepostIndex[msg.sender].referrerID], refToPay, referrerPercent, now);\n', '    } else {\n', '      // Team and advertising fee\n', '      owner().transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));\n', '    }\n', '  }\n', '\n', '\n', '\n', '/**\n', ' * Collect payout for the msg.sender\n', ' */\n', '  function collectPayout() public isHuman {\n', '    collectPayoutForAddress(msg.sender);\n', '  }\n', '\n', '/**\n', ' * Collect payout for the given address\n', ' */\n', '  function getRewardForAddress(address _address) public onlyOwner {\n', '    collectPayoutForAddress(_address);\n', '  }\n', '\n', '/**\n', ' *\n', ' */\n', '  function collectPayoutForAddress(address _address) internal {\n', '    require(investorToDepostIndex[_address].isExist == true, "Who are you?");\n', '    require(investorToDepostIndex[_address].nextPayAfterTime < now, "Not yet.");\n', '\n', '    uint periodCount = now.sub(investorToDepostIndex[_address].nextPayAfterTime).div(period).add(1);\n', '    uint percent = dailyDividendPercent;\n', '\n', '    if (investorToDepostIndex[_address].referrerID > 0) {\n', '      percent = referredDividendPercent;\n', '    }\n', '\n', '    uint toPay = periodCount.mul(investorToDepostIndex[_address].value).div(10000).mul(percent);\n', '\n', '    investorToDepostIndex[_address].lastPaymentTime = now;\n', '    investorToDepostIndex[_address].nextPayAfterTime += periodCount.mul(period);\n', '\n', '    // protect contract - this could result in some bad luck - but not much\n', '    if (toPay.add(midnightPrize) < address(this).balance.sub(msg.value))\n', '    {\n', '      _address.transfer(toPay);\n', '      emit DailyDividendPayout(_address, toPay, periodCount, percent, now);\n', '    }\n', '  }\n', '\n', '/**\n', ' * Perform the Midnight Run\n', ' */\n', '  function doMidnightRun() public isHuman {\n', '    require(now>nextPrizeTime , "Not yet");\n', '\n', '    // set the next prize time to the next payout time (MidnightRun)\n', '    nextPrizeTime = getNextPayoutTime();\n', '\n', '    if (currentPrizeStakeID > 5) {\n', '      uint toPay = midnightPrize;\n', '      midnightPrize = 0;\n', '\n', '      if (toPay > address(this).balance){\n', '        toPay = address(this).balance;\n', '      }\n', '\n', '      uint totalValue = stakeIDToDepositIndex[currentPrizeStakeID].value + stakeIDToDepositIndex[currentPrizeStakeID - 1].value + stakeIDToDepositIndex[currentPrizeStakeID - 2].value + stakeIDToDepositIndex[currentPrizeStakeID - 3].value + stakeIDToDepositIndex[currentPrizeStakeID - 4].value;\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 1].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 1].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 1].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 2].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 2].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 2].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 3].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 3].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 3].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 4].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 4].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 4].value, now);\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '/***\n', ' * @title -Midnight Run v0.1.0\n', ' * \n', ' *\n', ' *    ███╗   ███╗██╗██████╗ ███╗   ██╗██╗ ██████╗ ██╗  ██╗████████╗    ██████╗ ██╗   ██╗███╗   ██╗\n', ' *    ████╗ ████║██║██╔══██╗████╗  ██║██║██╔════╝ ██║  ██║╚══██╔══╝    ██╔══██╗██║   ██║████╗  ██║\n', ' *    ██╔████╔██║██║██║  ██║██╔██╗ ██║██║██║  ███╗███████║   ██║       ██████╔╝██║   ██║██╔██╗ ██║\n', ' *    ██║╚██╔╝██║██║██║  ██║██║╚██╗██║██║██║   ██║██╔══██║   ██║       ██╔══██╗██║   ██║██║╚██╗██║\n', ' *    ██║ ╚═╝ ██║██║██████╔╝██║ ╚████║██║╚██████╔╝██║  ██║   ██║       ██║  ██║╚██████╔╝██║ ╚████║\n', ' *    ╚═╝     ╚═╝╚═╝╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝\n', ' *                                  ┌─────────────────────────┐  \n', ' *                                  │https://midnightrun.live │  \n', ' *                                  └─────────────────────────┘  \n', ' *\n', ' * This product is provided for public use without any guarantee or recourse to appeal\n', ' * \n', ' * Payouts are collectible daily after 00:00 UTC\n', ' * Referral rewards are distributed automatically.\n', ' * The last 5 in before 00:00 UTC win the midnight prize.\n', ' * \n', ' * By sending ETH to this contract you are agreeing to the terms set out in the logic listed below.\n', ' *\n', ' * WARNING1:  Do not invest more than you can afford. \n', ' * WARNING2:  You can earn. \n', ' */\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', '/***\n', ' *     __ __  __  _ __  _    ___ __  __  _ _____ ___  __   ________\n', ' *    |  V  |/  \\| |  \\| |  / _//__\\|  \\| |_   _| _ \\/  \\ / _/_   _|\n', " *    | \\_/ | /\\ | | | ' | | \\_| \\/ | | ' | | | | v / /\\ | \\__ | |\n", ' *    |_| |_|_||_|_|_|\\__|  \\__/\\__/|_|\\__| |_| |_|_\\_||_|\\__/ |_|\n', ' */\n', 'contract MidnightRun is Ownable {\n', '  using SafeMath\n', '  for uint;\n', '\n', '  modifier isHuman() {\n', '    uint32 size;\n', '    address investor = msg.sender;\n', '    assembly {\n', '      size: = extcodesize(investor)\n', '    }\n', '    if (size > 0) {\n', '      revert("Inhuman");\n', '    }\n', '    _;\n', '  }\n', '\n', '  event DailyDividendPayout(address indexed _address, uint value, uint periodCount, uint percent, uint time);\n', '  event ReferralPayout(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time);\n', '  event MidnightRunPayout(address indexed _address, uint value, uint totalValue, uint userValue, uint time);\n', '\n', '  uint public period = 24 hours;\n', '  uint public startTime = 1537833600; //  Tue, 25 Sep 2018 00:00:00 +0000 UTC\n', '\n', '  uint public dailyDividendPercent = 300; //3%\n', '  uint public referredDividendPercent = 330; //3.3%\n', '\n', '  uint public referrerPercent = 250; //2.5%\n', '  uint public minBetLevel = 0.01 ether;\n', '\n', '  uint public referrerAndOwnerPercent = 2000; //20%\n', '  uint public currentStakeID = 1;\n', '\n', '  struct DepositInfo {\n', '    uint value;\n', '    uint firstBetTime;\n', '    uint lastBetTime;\n', '    uint lastPaymentTime;\n', '    uint nextPayAfterTime;\n', '    bool isExist;\n', '    uint id;\n', '    uint referrerID;\n', '  }\n', '\n', '  mapping(address => DepositInfo) public investorToDepostIndex;\n', '  mapping(uint => address) public idToAddressIndex;\n', '\n', '  // Jackpot\n', '  uint public midnightPrizePercent = 1000; //10%\n', '  uint public midnightPrize = 0;\n', '  uint public nextPrizeTime = startTime + period;\n', '\n', '  uint public currentPrizeStakeID = 0;\n', '\n', '  struct MidnightRunDeposit {\n', '    uint value;\n', '    address user;\n', '  }\n', '  mapping(uint => MidnightRunDeposit) public stakeIDToDepositIndex;\n', '\n', ' /**\n', '  * Constructor no need for unnecessary work in here.\n', '  */\n', '  constructor() public {\n', '  }\n', '\n', '  /**\n', '   * Fallback and entrypoint for deposits.\n', '   */\n', '  function() public payable isHuman {\n', '    if (msg.value == 0) {\n', '      collectPayoutForAddress(msg.sender);\n', '    } else {\n', '      uint refId = 1;\n', '      address referrer = bytesToAddress(msg.data);\n', '      if (investorToDepostIndex[referrer].isExist) {\n', '        refId = investorToDepostIndex[referrer].id;\n', '      }\n', '      deposit(refId);\n', '    }\n', '  }\n', '\n', '/**\n', ' * Reads the given bytes into an addtress\n', ' */\n', '  function bytesToAddress(bytes bys) private pure returns(address addr) {\n', '    assembly {\n', '      addr: = mload(add(bys, 20))\n', '    }\n', '  }\n', '\n', '/**\n', ' * Put some funds into the contract for the prize\n', ' */\n', '  function addToMidnightPrize() public payable onlyOwner {\n', '    midnightPrize += msg.value;\n', '  }\n', '\n', '/**\n', ' * Get the time of the next payout - calculated\n', ' */\n', '  function getNextPayoutTime() public view returns(uint) {\n', '    if (now<startTime) return startTime + period;\n', '    return startTime + ((now.sub(startTime)).div(period)).mul(period) + period;\n', '  }\n', '\n', '/**\n', ' * Make a deposit into the contract\n', ' */\n', '  function deposit(uint _referrerID) public payable isHuman {\n', '    require(_referrerID <= currentStakeID, "Who referred you?");\n', '    require(msg.value >= minBetLevel, "Doesn\'t meet minimum stake.");\n', '\n', '    // when is next midnight ?\n', '    uint nextPayAfterTime = getNextPayoutTime();\n', '\n', '    if (investorToDepostIndex[msg.sender].isExist) {\n', '      if (investorToDepostIndex[msg.sender].nextPayAfterTime < now) {\n', '        collectPayoutForAddress(msg.sender);\n', '      }\n', '      investorToDepostIndex[msg.sender].value += msg.value;\n', '      investorToDepostIndex[msg.sender].lastBetTime = now;\n', '    } else {\n', '      DepositInfo memory newDeposit;\n', '\n', '      newDeposit = DepositInfo({\n', '        value: msg.value,\n', '        firstBetTime: now,\n', '        lastBetTime: now,\n', '        lastPaymentTime: 0,\n', '        nextPayAfterTime: nextPayAfterTime,\n', '        isExist: true,\n', '        id: currentStakeID,\n', '        referrerID: _referrerID\n', '      });\n', '\n', '      investorToDepostIndex[msg.sender] = newDeposit;\n', '      idToAddressIndex[currentStakeID] = msg.sender;\n', '\n', '      currentStakeID++;\n', '    }\n', '\n', '    if (now > nextPrizeTime) {\n', '      doMidnightRun();\n', '    }\n', '\n', '    currentPrizeStakeID++;\n', '\n', '    MidnightRunDeposit memory midnitrunDeposit;\n', '    midnitrunDeposit.user = msg.sender;\n', '    midnitrunDeposit.value = msg.value;\n', '\n', '    stakeIDToDepositIndex[currentPrizeStakeID] = midnitrunDeposit;\n', '\n', '    // contribute to the Midnight Run Prize\n', '    midnightPrize += msg.value.mul(midnightPrizePercent).div(10000);\n', '    // Is there a referrer to be paid?\n', '    if (investorToDepostIndex[msg.sender].referrerID != 0) {\n', '\n', '      uint refToPay = msg.value.mul(referrerPercent).div(10000);\n', '      // Referral Fee\n', '      idToAddressIndex[investorToDepostIndex[msg.sender].referrerID].transfer(refToPay);\n', '      // Team and advertising fee\n', '      owner().transfer(msg.value.mul(referrerAndOwnerPercent - referrerPercent).div(10000));\n', '      emit ReferralPayout(msg.sender, idToAddressIndex[investorToDepostIndex[msg.sender].referrerID], refToPay, referrerPercent, now);\n', '    } else {\n', '      // Team and advertising fee\n', '      owner().transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));\n', '    }\n', '  }\n', '\n', '\n', '\n', '/**\n', ' * Collect payout for the msg.sender\n', ' */\n', '  function collectPayout() public isHuman {\n', '    collectPayoutForAddress(msg.sender);\n', '  }\n', '\n', '/**\n', ' * Collect payout for the given address\n', ' */\n', '  function getRewardForAddress(address _address) public onlyOwner {\n', '    collectPayoutForAddress(_address);\n', '  }\n', '\n', '/**\n', ' *\n', ' */\n', '  function collectPayoutForAddress(address _address) internal {\n', '    require(investorToDepostIndex[_address].isExist == true, "Who are you?");\n', '    require(investorToDepostIndex[_address].nextPayAfterTime < now, "Not yet.");\n', '\n', '    uint periodCount = now.sub(investorToDepostIndex[_address].nextPayAfterTime).div(period).add(1);\n', '    uint percent = dailyDividendPercent;\n', '\n', '    if (investorToDepostIndex[_address].referrerID > 0) {\n', '      percent = referredDividendPercent;\n', '    }\n', '\n', '    uint toPay = periodCount.mul(investorToDepostIndex[_address].value).div(10000).mul(percent);\n', '\n', '    investorToDepostIndex[_address].lastPaymentTime = now;\n', '    investorToDepostIndex[_address].nextPayAfterTime += periodCount.mul(period);\n', '\n', '    // protect contract - this could result in some bad luck - but not much\n', '    if (toPay.add(midnightPrize) < address(this).balance.sub(msg.value))\n', '    {\n', '      _address.transfer(toPay);\n', '      emit DailyDividendPayout(_address, toPay, periodCount, percent, now);\n', '    }\n', '  }\n', '\n', '/**\n', ' * Perform the Midnight Run\n', ' */\n', '  function doMidnightRun() public isHuman {\n', '    require(now>nextPrizeTime , "Not yet");\n', '\n', '    // set the next prize time to the next payout time (MidnightRun)\n', '    nextPrizeTime = getNextPayoutTime();\n', '\n', '    if (currentPrizeStakeID > 5) {\n', '      uint toPay = midnightPrize;\n', '      midnightPrize = 0;\n', '\n', '      if (toPay > address(this).balance){\n', '        toPay = address(this).balance;\n', '      }\n', '\n', '      uint totalValue = stakeIDToDepositIndex[currentPrizeStakeID].value + stakeIDToDepositIndex[currentPrizeStakeID - 1].value + stakeIDToDepositIndex[currentPrizeStakeID - 2].value + stakeIDToDepositIndex[currentPrizeStakeID - 3].value + stakeIDToDepositIndex[currentPrizeStakeID - 4].value;\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 1].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 1].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 1].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 2].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 2].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 2].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 3].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 3].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 3].value, now);\n', '\n', '      stakeIDToDepositIndex[currentPrizeStakeID - 4].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue));\n', '      emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 4].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 4].value, now);\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}']
