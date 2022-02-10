['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BountyHunter {\n', '\n', '  function() public payable { }\n', '\n', '  string public constant NAME = "BountyHunter";\n', '  string public constant SYMBOL = "BountyHunter";\n', '  address ceoAddress = 0xc10A6AedE9564efcDC5E842772313f0669D79497;\n', '  address hunter;\n', '  address hunted;\n', '\n', '  struct ContractData {\n', '    address user;\n', '    uint256 hunterPrice;\n', '    uint256 last_transaction;\n', '   \n', '  }\n', '\n', '  ContractData[8] data;\n', '  \n', '\n', '  \n', '  function BountyHunter() public {\n', '    for (uint i = 0; i < 8; i++) {\n', '     \n', '      data[i].hunterPrice = 5000000000000000;\n', '      data[i].user = msg.sender;\n', '      data[i].last_transaction = block.timestamp;\n', '    }\n', '  }\n', '\n', '\n', '  function payoutOnPurchase(address previousHunterOwner, uint256 hunterPrice) private {\n', '    previousHunterOwner.transfer(hunterPrice);\n', '  }\n', '  function transactionFee(address, uint256 hunterPrice) private {\n', '    ceoAddress.transfer(hunterPrice);\n', '  }\n', '  function createBounty(uint256 hunterPrice) private {\n', '    this.transfer(hunterPrice);\n', '  }\n', '\n', '\n', '  \n', '  function hireBountyHunter(uint bountyHunterID) public payable returns (uint, uint) {\n', '    require(bountyHunterID >= 0 && bountyHunterID <= 8);\n', '    \n', '    if ( data[bountyHunterID].hunterPrice == 5000000000000000 ) {\n', '      data[bountyHunterID].hunterPrice = 10000000000000000;\n', '    }\n', '    else { \n', '      data[bountyHunterID].hunterPrice = data[bountyHunterID].hunterPrice * 2;\n', '    }\n', '    \n', '    require(msg.value >= data[bountyHunterID].hunterPrice * uint256(1));\n', '\n', '    createBounty((data[bountyHunterID].hunterPrice / 10) * (3));\n', '    \n', '    payoutOnPurchase(data[bountyHunterID].user,  (data[bountyHunterID].hunterPrice / 10) * (6));\n', '    \n', '    transactionFee(ceoAddress, (data[bountyHunterID].hunterPrice / 10) * (1));\n', '\n', '    \n', '    data[bountyHunterID].user = msg.sender;\n', '    \n', '    playerKiller();\n', '    \n', '    return (bountyHunterID, data[bountyHunterID].hunterPrice);\n', '\n', '  }\n', '\n', '\n', '  function getUsers() public view returns (address[], uint256[]) {\n', '    address[] memory users = new address[](8);\n', '    uint256[] memory hunterPrices =  new uint256[](8);\n', '    for (uint i=0; i<8; i++) {\n', '      if (data[i].user != ceoAddress){\n', '        users[i] = (data[i].user);\n', '      }\n', '      else{\n', '        users[i] = address(0);\n', '      }\n', '      \n', '      hunterPrices[i] = (data[i].hunterPrice);\n', '    }\n', '    return (users,hunterPrices);\n', '  }\n', '\n', '  function rand(uint max) public returns (uint256){\n', '        \n', '    uint256 lastBlockNumber = block.number - 1;\n', '    uint256 hashVal = uint256(block.blockhash(lastBlockNumber));\n', '\n', '    uint256 FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;\n', '    return uint256(uint256( (hashVal) / FACTOR) + 1) % max;\n', '  }\n', '  \n', '  \n', '  function playerKiller() private {\n', '    uint256 killshot = rand(31);\n', '\n', '    if( (killshot < 8) &&  (msg.sender != data[killshot].user) ){\n', '      hunter = msg.sender;\n', '      if( ceoAddress != data[killshot].user){\n', '        hunted = data[killshot].user;\n', '      }\n', '      else{\n', '        hunted = address(0);\n', '      }\n', '      \n', '      data[killshot].hunterPrice  = 5000000000000000;\n', '      data[killshot].user  = 5000000000000000;\n', '\n', '      msg.sender.transfer((this.balance / 10) * (9));\n', '      ceoAddress.transfer((this.balance / 10) * (1));\n', '\n', '    }\n', '    \n', '  }\n', '\n', '  function killFeed() public view returns(address, address){\n', '    return(hunter, hunted);\n', '  }\n', '  \n', '}']
['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BountyHunter {\n', '\n', '  function() public payable { }\n', '\n', '  string public constant NAME = "BountyHunter";\n', '  string public constant SYMBOL = "BountyHunter";\n', '  address ceoAddress = 0xc10A6AedE9564efcDC5E842772313f0669D79497;\n', '  address hunter;\n', '  address hunted;\n', '\n', '  struct ContractData {\n', '    address user;\n', '    uint256 hunterPrice;\n', '    uint256 last_transaction;\n', '   \n', '  }\n', '\n', '  ContractData[8] data;\n', '  \n', '\n', '  \n', '  function BountyHunter() public {\n', '    for (uint i = 0; i < 8; i++) {\n', '     \n', '      data[i].hunterPrice = 5000000000000000;\n', '      data[i].user = msg.sender;\n', '      data[i].last_transaction = block.timestamp;\n', '    }\n', '  }\n', '\n', '\n', '  function payoutOnPurchase(address previousHunterOwner, uint256 hunterPrice) private {\n', '    previousHunterOwner.transfer(hunterPrice);\n', '  }\n', '  function transactionFee(address, uint256 hunterPrice) private {\n', '    ceoAddress.transfer(hunterPrice);\n', '  }\n', '  function createBounty(uint256 hunterPrice) private {\n', '    this.transfer(hunterPrice);\n', '  }\n', '\n', '\n', '  \n', '  function hireBountyHunter(uint bountyHunterID) public payable returns (uint, uint) {\n', '    require(bountyHunterID >= 0 && bountyHunterID <= 8);\n', '    \n', '    if ( data[bountyHunterID].hunterPrice == 5000000000000000 ) {\n', '      data[bountyHunterID].hunterPrice = 10000000000000000;\n', '    }\n', '    else { \n', '      data[bountyHunterID].hunterPrice = data[bountyHunterID].hunterPrice * 2;\n', '    }\n', '    \n', '    require(msg.value >= data[bountyHunterID].hunterPrice * uint256(1));\n', '\n', '    createBounty((data[bountyHunterID].hunterPrice / 10) * (3));\n', '    \n', '    payoutOnPurchase(data[bountyHunterID].user,  (data[bountyHunterID].hunterPrice / 10) * (6));\n', '    \n', '    transactionFee(ceoAddress, (data[bountyHunterID].hunterPrice / 10) * (1));\n', '\n', '    \n', '    data[bountyHunterID].user = msg.sender;\n', '    \n', '    playerKiller();\n', '    \n', '    return (bountyHunterID, data[bountyHunterID].hunterPrice);\n', '\n', '  }\n', '\n', '\n', '  function getUsers() public view returns (address[], uint256[]) {\n', '    address[] memory users = new address[](8);\n', '    uint256[] memory hunterPrices =  new uint256[](8);\n', '    for (uint i=0; i<8; i++) {\n', '      if (data[i].user != ceoAddress){\n', '        users[i] = (data[i].user);\n', '      }\n', '      else{\n', '        users[i] = address(0);\n', '      }\n', '      \n', '      hunterPrices[i] = (data[i].hunterPrice);\n', '    }\n', '    return (users,hunterPrices);\n', '  }\n', '\n', '  function rand(uint max) public returns (uint256){\n', '        \n', '    uint256 lastBlockNumber = block.number - 1;\n', '    uint256 hashVal = uint256(block.blockhash(lastBlockNumber));\n', '\n', '    uint256 FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;\n', '    return uint256(uint256( (hashVal) / FACTOR) + 1) % max;\n', '  }\n', '  \n', '  \n', '  function playerKiller() private {\n', '    uint256 killshot = rand(31);\n', '\n', '    if( (killshot < 8) &&  (msg.sender != data[killshot].user) ){\n', '      hunter = msg.sender;\n', '      if( ceoAddress != data[killshot].user){\n', '        hunted = data[killshot].user;\n', '      }\n', '      else{\n', '        hunted = address(0);\n', '      }\n', '      \n', '      data[killshot].hunterPrice  = 5000000000000000;\n', '      data[killshot].user  = 5000000000000000;\n', '\n', '      msg.sender.transfer((this.balance / 10) * (9));\n', '      ceoAddress.transfer((this.balance / 10) * (1));\n', '\n', '    }\n', '    \n', '  }\n', '\n', '  function killFeed() public view returns(address, address){\n', '    return(hunter, hunted);\n', '  }\n', '  \n', '}']
