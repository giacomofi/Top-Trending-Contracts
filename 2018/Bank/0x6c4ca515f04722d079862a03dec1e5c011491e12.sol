['pragma solidity ^0.4.23;\n', '\n', 'contract ToadFarmer {\n', '    uint256 public EGGS_TO_HATCH_1TOAD = 43200; // Half a day&#39;s worth of seconds to hatch\n', '    uint256 TADPOLE = 10000;\n', '    uint256 PSNHTOAD = 5000;\n', '    bool public initialized = false;\n', '    address public ceoAddress;\n', '    mapping (address => uint256) public hatcheryToad;\n', '    mapping (address => uint256) public claimedEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => address) public referrals;\n', '    uint256 public marketEggs;\n', '\n', '    constructor() public {\n', '        ceoAddress = msg.sender;\n', '    }\n', '\n', '    function hatchEggs(address ref) public {\n', '        require(initialized);\n', '        if (referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {\n', '            referrals[msg.sender] = ref;\n', '        }\n', '        uint256 eggsUsed = getMyEggs();\n', '        uint256 newToad = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1TOAD);\n', '        hatcheryToad[msg.sender] = SafeMath.add(hatcheryToad[msg.sender], newToad);\n', '        claimedEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender] = now;\n', '        \n', '        // Send referral eggs\n', '        claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]], SafeMath.div(eggsUsed, 5));\n', '        \n', '        // Boost market to stop toad hoarding\n', '        marketEggs = SafeMath.add(marketEggs, SafeMath.div(eggsUsed, 10));\n', '    }\n', '\n', '    function sellEggs() public {\n', '        require(initialized);\n', '        uint256 hasEggs = getMyEggs();\n', '        uint256 eggValue = calculateEggSell(hasEggs);\n', '        uint256 fee = devFee(eggValue);\n', '        claimedEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender] = now;\n', '        marketEggs = SafeMath.add(marketEggs, hasEggs);\n', '        ceoAddress.transfer(fee);\n', '        msg.sender.transfer(SafeMath.sub(eggValue, fee));\n', '    }\n', '    \n', '    function buyEggs() public payable {\n', '        require(initialized);\n', '        uint256 eggsBought = calculateEggBuy(msg.value, SafeMath.sub(address(this).balance, msg.value));\n', '        eggsBought = SafeMath.sub(eggsBought, devFee(eggsBought));\n', '        claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggsBought);\n', '        ceoAddress.transfer(devFee(msg.value));\n', '    }\n', '\n', '    // Trade balancing algorithm\n', '    function calculateTrade(uint256 riggert, uint256 starboards, uint256 bigship) public view returns(uint256) {\n', '        // (TADPOLE*bigship) /\n', '        // (PSNHTOAD+((TADPOLE*starboards+PSNHTOAD*riggert)/riggert));\n', '        return SafeMath.div(SafeMath.mul(TADPOLE, bigship),\n', '        SafeMath.add(PSNHTOAD, SafeMath.div(SafeMath.add(SafeMath.mul(TADPOLE, starboards),SafeMath.mul(PSNHTOAD, riggert)), riggert)));\n', '    }\n', '\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256) {\n', '        return calculateTrade(eggs, marketEggs, address(this).balance);\n', '    }\n', '\n', '    function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {\n', '        return calculateTrade(eth, contractBalance, marketEggs);\n', '    }\n', '\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256) {\n', '        return calculateEggBuy(eth, address(this).balance);\n', '    }\n', '\n', '    function devFee(uint256 amount) public pure returns(uint256) {\n', '        return SafeMath.div(SafeMath.mul(amount, 4), 100);\n', '    }\n', '\n', '    function seedMarket(uint256 eggs) public payable {\n', '        require(marketEggs == 0);\n', '        initialized = true;\n', '        marketEggs = eggs;\n', '    }\n', '\n', '    function getFreeToad() public {\n', '        require(initialized);\n', '        require(hatcheryToad[msg.sender] == 0);\n', '        lastHatch[msg.sender] = now;\n', '        hatcheryToad[msg.sender] = uint(blockhash(block.number-1))%400 + 1; // &#39;Randomish&#39; 1-400 free eggs\n', '    }\n', '\n', '    function getBalance() public view returns(uint256) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getMyToad() public view returns(uint256) {\n', '        return hatcheryToad[msg.sender];\n', '    }\n', '\n', '    function getMyEggs() public view returns(uint256) {\n', '        return SafeMath.add(claimedEggs[msg.sender], getEggsSinceLastHatch(msg.sender));\n', '    }\n', '\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256) {\n', '        uint256 secondsPassed = min(EGGS_TO_HATCH_1TOAD, SafeMath.sub(now, lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed, hatcheryToad[adr]);\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract ToadFarmer {\n', "    uint256 public EGGS_TO_HATCH_1TOAD = 43200; // Half a day's worth of seconds to hatch\n", '    uint256 TADPOLE = 10000;\n', '    uint256 PSNHTOAD = 5000;\n', '    bool public initialized = false;\n', '    address public ceoAddress;\n', '    mapping (address => uint256) public hatcheryToad;\n', '    mapping (address => uint256) public claimedEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => address) public referrals;\n', '    uint256 public marketEggs;\n', '\n', '    constructor() public {\n', '        ceoAddress = msg.sender;\n', '    }\n', '\n', '    function hatchEggs(address ref) public {\n', '        require(initialized);\n', '        if (referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {\n', '            referrals[msg.sender] = ref;\n', '        }\n', '        uint256 eggsUsed = getMyEggs();\n', '        uint256 newToad = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1TOAD);\n', '        hatcheryToad[msg.sender] = SafeMath.add(hatcheryToad[msg.sender], newToad);\n', '        claimedEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender] = now;\n', '        \n', '        // Send referral eggs\n', '        claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]], SafeMath.div(eggsUsed, 5));\n', '        \n', '        // Boost market to stop toad hoarding\n', '        marketEggs = SafeMath.add(marketEggs, SafeMath.div(eggsUsed, 10));\n', '    }\n', '\n', '    function sellEggs() public {\n', '        require(initialized);\n', '        uint256 hasEggs = getMyEggs();\n', '        uint256 eggValue = calculateEggSell(hasEggs);\n', '        uint256 fee = devFee(eggValue);\n', '        claimedEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender] = now;\n', '        marketEggs = SafeMath.add(marketEggs, hasEggs);\n', '        ceoAddress.transfer(fee);\n', '        msg.sender.transfer(SafeMath.sub(eggValue, fee));\n', '    }\n', '    \n', '    function buyEggs() public payable {\n', '        require(initialized);\n', '        uint256 eggsBought = calculateEggBuy(msg.value, SafeMath.sub(address(this).balance, msg.value));\n', '        eggsBought = SafeMath.sub(eggsBought, devFee(eggsBought));\n', '        claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggsBought);\n', '        ceoAddress.transfer(devFee(msg.value));\n', '    }\n', '\n', '    // Trade balancing algorithm\n', '    function calculateTrade(uint256 riggert, uint256 starboards, uint256 bigship) public view returns(uint256) {\n', '        // (TADPOLE*bigship) /\n', '        // (PSNHTOAD+((TADPOLE*starboards+PSNHTOAD*riggert)/riggert));\n', '        return SafeMath.div(SafeMath.mul(TADPOLE, bigship),\n', '        SafeMath.add(PSNHTOAD, SafeMath.div(SafeMath.add(SafeMath.mul(TADPOLE, starboards),SafeMath.mul(PSNHTOAD, riggert)), riggert)));\n', '    }\n', '\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256) {\n', '        return calculateTrade(eggs, marketEggs, address(this).balance);\n', '    }\n', '\n', '    function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {\n', '        return calculateTrade(eth, contractBalance, marketEggs);\n', '    }\n', '\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256) {\n', '        return calculateEggBuy(eth, address(this).balance);\n', '    }\n', '\n', '    function devFee(uint256 amount) public pure returns(uint256) {\n', '        return SafeMath.div(SafeMath.mul(amount, 4), 100);\n', '    }\n', '\n', '    function seedMarket(uint256 eggs) public payable {\n', '        require(marketEggs == 0);\n', '        initialized = true;\n', '        marketEggs = eggs;\n', '    }\n', '\n', '    function getFreeToad() public {\n', '        require(initialized);\n', '        require(hatcheryToad[msg.sender] == 0);\n', '        lastHatch[msg.sender] = now;\n', "        hatcheryToad[msg.sender] = uint(blockhash(block.number-1))%400 + 1; // 'Randomish' 1-400 free eggs\n", '    }\n', '\n', '    function getBalance() public view returns(uint256) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getMyToad() public view returns(uint256) {\n', '        return hatcheryToad[msg.sender];\n', '    }\n', '\n', '    function getMyEggs() public view returns(uint256) {\n', '        return SafeMath.add(claimedEggs[msg.sender], getEggsSinceLastHatch(msg.sender));\n', '    }\n', '\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256) {\n', '        uint256 secondsPassed = min(EGGS_TO_HATCH_1TOAD, SafeMath.sub(now, lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed, hatcheryToad[adr]);\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']