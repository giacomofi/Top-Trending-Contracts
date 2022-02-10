['pragma solidity ^0.4.19;\n', '\n', '\n', '// "Proof of Commitment" fun pre-launch competition for NBAOnline!\n', '\n', '//  Full details and game smart contract will shortly be able:\n', '//  ~~ https://nbaonline.io ~~\n', '\n', '//  This contest will award some of the keen NBAOnline players\n', '\n', '//  ALL ETHER DEPOSITED INTO THIS PROMO CAN BE WITHDRAWN BY PLAYER AT ANY\n', '//  TIME BUT PRIZES WILL BE DRAWN: SATURDAY 14TH APRIL (LAUNCH)\n', '//  AT WHICH POINT ALL ETHER WILL ALSO BE REFUNDED TO PLAYERS\n', '\n', '\n', '//  PRIZES:\n', '//  0.5 ether (top eth deposit)\n', '//  0.35 ether (1 random deposit)\n', '//  0.15 ether (1 random deposit)\n', '\n', 'contract NBAOnlineLaunchPromotion {\n', '    \n', '    // First Goo Players!\n', '    mapping(address => uint256) public deposits;\n', '    mapping(address => bool) depositorAlreadyStored;\n', '    address[] public depositors;\n', '\n', '    // To trigger contest end only\n', '    address public ownerAddress;\n', '    \n', '    // Flag so can only be awarded once\n', '    bool public prizesAwarded = false;\n', '    \n', '    // Ether to be returned to depositor on launch\n', '\t// 1day = 86400\n', '    uint256 public constant LAUNCH_DATE = 1523678400; // Saturday, 14 April 2018 00:00:00 (seconds) ET\n', '    \n', '    // Proof of Commitment contest prizes\n', '    uint256 private constant TOP_DEPOSIT_PRIZE = 0.5 ether;\n', '    uint256 private constant RANDOM_DEPOSIT_PRIZE1 = 0.35 ether;\n', '    uint256 private constant RANDOM_DEPOSIT_PRIZE2 = 0.15 ether;\n', '    \n', '    function NBAOnlineLaunchPromotion() public payable {\n', '        require(msg.value == 1 ether); // Owner must provide enough for prizes\n', '        ownerAddress = msg.sender;\n', '    }\n', '    \n', '    \n', '    function deposit() external payable {\n', '        uint256 existing = deposits[msg.sender];\n', '        \n', '        // Safely store the ether sent\n', '        deposits[msg.sender] = SafeMath.add(msg.value, existing);\n', '        \n', '        // Finally store contest details\n', '        if (msg.value >= 0.01 ether && !depositorAlreadyStored[msg.sender]) {\n', '            depositors.push(msg.sender);\n', '            depositorAlreadyStored[msg.sender] = true;\n', '        }\n', '    }\n', '    \n', '    function refund() external {\n', '        // Safely transfer players deposit back\n', '        uint256 depositAmount = deposits[msg.sender];\n', '        deposits[msg.sender] = 0; // Can&#39;t withdraw twice obviously\n', '        msg.sender.transfer(depositAmount);\n', '    }\n', '    \n', '    \n', '    function refundPlayer(address depositor) external {\n', '        require(msg.sender == ownerAddress);\n', '        \n', '        // Safely transfer back to player\n', '        uint256 depositAmount = deposits[depositor];\n', '        deposits[depositor] = 0; // Can&#39;t withdraw twice obviously\n', '        \n', '        // Sends back to correct depositor\n', '        depositor.transfer(depositAmount);\n', '    }\n', '    \n', '    \n', '    function awardPrizes() external {\n', '        require(msg.sender == ownerAddress);\n', '        require(now >= LAUNCH_DATE);\n', '        require(!prizesAwarded);\n', '        \n', '        // Ensure only ran once\n', '        prizesAwarded = true;\n', '        \n', '        uint256 highestDeposit;\n', '        address highestDepositWinner;\n', '        \n', '        for (uint256 i = 0; i < depositors.length; i++) {\n', '            address depositor = depositors[i];\n', '            \n', '            // No tie allowed!\n', '            if (deposits[depositor] > highestDeposit) {\n', '                highestDeposit = deposits[depositor];\n', '                highestDepositWinner = depositor;\n', '            }\n', '        }\n', '        \n', '        uint256 numContestants = depositors.length;\n', '        uint256 seed1 = numContestants + block.timestamp;\n', '        uint256 seed2 = seed1 + (numContestants*2);\n', '        \n', '        address randomDepositWinner1 = depositors[randomContestant(numContestants, seed1)];\n', '        address randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];\n', '        \n', '        // Just incase\n', '        while(randomDepositWinner2 == randomDepositWinner1) {\n', '            seed2++;\n', '            randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];\n', '        }\n', '        \n', '        highestDepositWinner.transfer(TOP_DEPOSIT_PRIZE);\n', '        randomDepositWinner1.transfer(RANDOM_DEPOSIT_PRIZE1);\n', '        randomDepositWinner2.transfer(RANDOM_DEPOSIT_PRIZE2);\n', '    }\n', '    \n', '    \n', '    // Random enough for small contest\n', '    function randomContestant(uint256 contestants, uint256 seed) constant internal returns (uint256 result){\n', '        return addmod(uint256(block.blockhash(block.number-1)), seed, contestants);   \n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '\n', '// "Proof of Commitment" fun pre-launch competition for NBAOnline!\n', '\n', '//  Full details and game smart contract will shortly be able:\n', '//  ~~ https://nbaonline.io ~~\n', '\n', '//  This contest will award some of the keen NBAOnline players\n', '\n', '//  ALL ETHER DEPOSITED INTO THIS PROMO CAN BE WITHDRAWN BY PLAYER AT ANY\n', '//  TIME BUT PRIZES WILL BE DRAWN: SATURDAY 14TH APRIL (LAUNCH)\n', '//  AT WHICH POINT ALL ETHER WILL ALSO BE REFUNDED TO PLAYERS\n', '\n', '\n', '//  PRIZES:\n', '//  0.5 ether (top eth deposit)\n', '//  0.35 ether (1 random deposit)\n', '//  0.15 ether (1 random deposit)\n', '\n', 'contract NBAOnlineLaunchPromotion {\n', '    \n', '    // First Goo Players!\n', '    mapping(address => uint256) public deposits;\n', '    mapping(address => bool) depositorAlreadyStored;\n', '    address[] public depositors;\n', '\n', '    // To trigger contest end only\n', '    address public ownerAddress;\n', '    \n', '    // Flag so can only be awarded once\n', '    bool public prizesAwarded = false;\n', '    \n', '    // Ether to be returned to depositor on launch\n', '\t// 1day = 86400\n', '    uint256 public constant LAUNCH_DATE = 1523678400; // Saturday, 14 April 2018 00:00:00 (seconds) ET\n', '    \n', '    // Proof of Commitment contest prizes\n', '    uint256 private constant TOP_DEPOSIT_PRIZE = 0.5 ether;\n', '    uint256 private constant RANDOM_DEPOSIT_PRIZE1 = 0.35 ether;\n', '    uint256 private constant RANDOM_DEPOSIT_PRIZE2 = 0.15 ether;\n', '    \n', '    function NBAOnlineLaunchPromotion() public payable {\n', '        require(msg.value == 1 ether); // Owner must provide enough for prizes\n', '        ownerAddress = msg.sender;\n', '    }\n', '    \n', '    \n', '    function deposit() external payable {\n', '        uint256 existing = deposits[msg.sender];\n', '        \n', '        // Safely store the ether sent\n', '        deposits[msg.sender] = SafeMath.add(msg.value, existing);\n', '        \n', '        // Finally store contest details\n', '        if (msg.value >= 0.01 ether && !depositorAlreadyStored[msg.sender]) {\n', '            depositors.push(msg.sender);\n', '            depositorAlreadyStored[msg.sender] = true;\n', '        }\n', '    }\n', '    \n', '    function refund() external {\n', '        // Safely transfer players deposit back\n', '        uint256 depositAmount = deposits[msg.sender];\n', "        deposits[msg.sender] = 0; // Can't withdraw twice obviously\n", '        msg.sender.transfer(depositAmount);\n', '    }\n', '    \n', '    \n', '    function refundPlayer(address depositor) external {\n', '        require(msg.sender == ownerAddress);\n', '        \n', '        // Safely transfer back to player\n', '        uint256 depositAmount = deposits[depositor];\n', "        deposits[depositor] = 0; // Can't withdraw twice obviously\n", '        \n', '        // Sends back to correct depositor\n', '        depositor.transfer(depositAmount);\n', '    }\n', '    \n', '    \n', '    function awardPrizes() external {\n', '        require(msg.sender == ownerAddress);\n', '        require(now >= LAUNCH_DATE);\n', '        require(!prizesAwarded);\n', '        \n', '        // Ensure only ran once\n', '        prizesAwarded = true;\n', '        \n', '        uint256 highestDeposit;\n', '        address highestDepositWinner;\n', '        \n', '        for (uint256 i = 0; i < depositors.length; i++) {\n', '            address depositor = depositors[i];\n', '            \n', '            // No tie allowed!\n', '            if (deposits[depositor] > highestDeposit) {\n', '                highestDeposit = deposits[depositor];\n', '                highestDepositWinner = depositor;\n', '            }\n', '        }\n', '        \n', '        uint256 numContestants = depositors.length;\n', '        uint256 seed1 = numContestants + block.timestamp;\n', '        uint256 seed2 = seed1 + (numContestants*2);\n', '        \n', '        address randomDepositWinner1 = depositors[randomContestant(numContestants, seed1)];\n', '        address randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];\n', '        \n', '        // Just incase\n', '        while(randomDepositWinner2 == randomDepositWinner1) {\n', '            seed2++;\n', '            randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];\n', '        }\n', '        \n', '        highestDepositWinner.transfer(TOP_DEPOSIT_PRIZE);\n', '        randomDepositWinner1.transfer(RANDOM_DEPOSIT_PRIZE1);\n', '        randomDepositWinner2.transfer(RANDOM_DEPOSIT_PRIZE2);\n', '    }\n', '    \n', '    \n', '    // Random enough for small contest\n', '    function randomContestant(uint256 contestants, uint256 seed) constant internal returns (uint256 result){\n', '        return addmod(uint256(block.blockhash(block.number-1)), seed, contestants);   \n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
