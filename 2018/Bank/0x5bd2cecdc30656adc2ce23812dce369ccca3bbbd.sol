['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '\n', '\n', 'contract EtherMorty {\n', '    \n', '    address public superPowerFulDragonOwner;\n', '    uint256 lastPrice = 200000000000000000;\n', '    uint public hatchingSpeed = 100;\n', '    uint256 public snatchedOn;\n', '    bool public isEnabled = false;\n', '    \n', '    \n', '    function withDrawMoney() public {\n', '        require(msg.sender == ceoAddress);\n', '        uint256 myBalance = ceoEtherBalance;\n', '        ceoEtherBalance = 0;\n', '        ceoAddress.transfer(myBalance);\n', '    }\n', '    \n', '    function buySuperDragon() public payable {\n', '        require(isEnabled);\n', '        require(initialized);\n', '        uint currenPrice = SafeMath.add(SafeMath.div(SafeMath.mul(lastPrice, 4),100),lastPrice);\n', '        require(msg.value > currenPrice);\n', '        \n', '        uint256 timeSpent = SafeMath.sub(now, snatchedOn);\n', '        userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);\n', '        \n', '        hatchingSpeed += SafeMath.div(SafeMath.sub(now, contractStarted), 60*60*24);\n', '        ceoEtherBalance += calculatePercentage(msg.value, 20);\n', '        superPowerFulDragonOwner.transfer(msg.value - calculatePercentage(msg.value, 2));\n', '        lastPrice = currenPrice;\n', '        superPowerFulDragonOwner = msg.sender;\n', '        snatchedOn = now;\n', '    }\n', '    \n', '    function claimSuperDragonEggs() public {\n', '        require(isEnabled);\n', '        require (msg.sender == superPowerFulDragonOwner);\n', '        uint256 timeSpent = SafeMath.sub(now, snatchedOn);\n', '        userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);\n', '        snatchedOn = now;\n', '    }\n', '    \n', '    uint256 public EGGS_TO_HATCH_1Dragon=86400;//for final version should be seconds in a day\n', '    uint256 public STARTING_Dragon=100;\n', '    \n', '    uint256 PSN=10000;\n', '    uint256 PSNH=5000;\n', '    \n', '    bool public initialized=false;\n', '    address public ceoAddress = 0xdf4703369ecE603a01e049e34e438ff74Cd96D66;\n', '    uint public ceoEtherBalance;\n', '    \n', '    mapping (address => uint256) public iceDragons;\n', '    mapping (address => uint256) public premiumDragons;\n', '    mapping (address => uint256) public normalDragon;\n', '    mapping (address => uint256) public userHatchRate;\n', '    \n', '    mapping (address => uint256) public userReferralEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => address) public referrals;\n', '    \n', '    uint256 public marketEggs;\n', '    uint256 public contractStarted;\n', '        \n', '    function seedMarket(uint256 eggs) public payable {\n', '        require(marketEggs==0);\n', '        initialized=true;\n', '        marketEggs=eggs;\n', '        contractStarted = now;\n', '    }\n', '    \n', '    function getMyEggs() public view returns(uint256){\n', '        return SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender));\n', '    }\n', '    \n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256){\n', '        uint256 secondsPassed = SafeMath.sub(now,lastHatch[adr]);\n', '        uint256 dragonCount = SafeMath.mul(iceDragons[adr], 12);\n', '        dragonCount = SafeMath.add(dragonCount, premiumDragons[adr]);\n', '        dragonCount = SafeMath.add(dragonCount, normalDragon[adr]);\n', '        return SafeMath.mul(secondsPassed, dragonCount);\n', '    }\n', '    \n', '    function getEggsToHatchDragon() public view returns (uint) {\n', '        uint256 timeSpent = SafeMath.sub(now,contractStarted); \n', '        timeSpent = SafeMath.div(timeSpent, 3600);\n', '        return SafeMath.mul(timeSpent, 10);\n', '    }\n', '    \n', '    function getBalance() public view returns(uint256){\n', '        return address(this).balance;\n', '    }\n', '    \n', '    function getMyNormalDragons() public view returns(uint256) {\n', '        return SafeMath.add(normalDragon[msg.sender], premiumDragons[msg.sender]);\n', '    }\n', '    \n', '    function getMyIceDragon() public view returns(uint256) {\n', '        return iceDragons[msg.sender];\n', '    }\n', '    \n', '    function setUserHatchRate() internal {\n', '        if (userHatchRate[msg.sender] == 0) \n', '            userHatchRate[msg.sender] = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());\n', '    }\n', '    \n', '    function calculatePercentage(uint256 amount, uint percentage) public pure returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,percentage),100);\n', '    }\n', '    \n', '    function getFreeDragon() public {\n', '        require(initialized);\n', '        require(normalDragon[msg.sender] == 0);\n', '        \n', '        lastHatch[msg.sender]=now;\n', '        normalDragon[msg.sender]=STARTING_Dragon;\n', '        setUserHatchRate();\n', '    }\n', '    \n', '    function buyDrangon() public payable {\n', '        require(initialized);\n', '        require(userHatchRate[msg.sender] != 0);\n', '        uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance);\n', '        uint dragonAmount = SafeMath.div(msg.value, dragonPrice);\n', '        require(dragonAmount > 0);\n', '        \n', '        ceoEtherBalance += calculatePercentage(msg.value, 40);\n', '        premiumDragons[msg.sender] += dragonAmount;\n', '    }\n', '    \n', '    function buyIceDrangon() public payable {\n', '        require(initialized);\n', '        require(userHatchRate[msg.sender] != 0);\n', '        uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance) * 8;\n', '        uint dragonAmount = SafeMath.div(msg.value, dragonPrice);\n', '        require(dragonAmount > 0);\n', '        \n', '        ceoEtherBalance += calculatePercentage(msg.value, 40);\n', '        iceDragons[msg.sender] += dragonAmount;\n', '    }\n', '    \n', '    function hatchEggs(address ref) public {\n', '        require(initialized);\n', '        \n', '        if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {\n', '            referrals[msg.sender] = ref;\n', '        }\n', '        \n', '        uint256 eggsProduced = getMyEggs();\n', '        \n', '        uint256 newDragon = SafeMath.div(eggsProduced,userHatchRate[msg.sender]);\n', '        \n', '        uint256 eggsConsumed = SafeMath.mul(newDragon, userHatchRate[msg.sender]);\n', '        \n', '        normalDragon[msg.sender] = SafeMath.add(normalDragon[msg.sender],newDragon);\n', '        userReferralEggs[msg.sender] = SafeMath.sub(eggsProduced, eggsConsumed); \n', '        lastHatch[msg.sender]=now;\n', '        \n', '        //send referral eggs\n', '        userReferralEggs[referrals[msg.sender]]=SafeMath.add(userReferralEggs[referrals[msg.sender]],SafeMath.div(eggsConsumed,10));\n', '        \n', '        //boost market to nerf Dragon hoarding\n', '        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsProduced,10));\n', '    }\n', '    \n', '    function sellEggs() public {\n', '        require(initialized);\n', '        uint256 hasEggs = getMyEggs();\n', '        uint256 eggValue = calculateEggSell(hasEggs);\n', '        uint256 fee = calculatePercentage(eggValue, 20);\n', '        userReferralEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender]=now;\n', '        marketEggs=SafeMath.add(marketEggs,hasEggs);\n', '        ceoEtherBalance += fee;\n', '        msg.sender.transfer(SafeMath.sub(eggValue,fee));\n', '    }\n', '    \n', '    function getDragonPrice(uint eggs, uint256 eth) internal view returns (uint) {\n', '        uint dragonPrice = calculateEggSell(eggs, eth);\n', '        return calculatePercentage(dragonPrice, 140);\n', '    }\n', '    \n', '    function getDragonPriceNo() public view returns (uint) {\n', '        uint256 d = userHatchRate[msg.sender];\n', '        if (d == 0) \n', '            d = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());\n', '        return getDragonPrice(d, address(this).balance);\n', '    }\n', '    \n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));\n', '    }\n', '    \n', '    function calculateEggSell(uint256 eggs) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs,address(this).balance);\n', '    }\n', '    \n', '    function calculateEggSell(uint256 eggs, uint256 eth) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs,eth);\n', '    }\n', '    \n', '    \n', '    function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256){\n', '        return calculateTrade(eth,contractBalance,marketEggs);\n', '    }\n', '    \n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256) {\n', '        return calculateEggBuy(eth, address(this).balance);\n', '    }\n', '    \n', '    \n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '\n', '\n', 'contract EtherMorty {\n', '    \n', '    address public superPowerFulDragonOwner;\n', '    uint256 lastPrice = 200000000000000000;\n', '    uint public hatchingSpeed = 100;\n', '    uint256 public snatchedOn;\n', '    bool public isEnabled = false;\n', '    \n', '    \n', '    function withDrawMoney() public {\n', '        require(msg.sender == ceoAddress);\n', '        uint256 myBalance = ceoEtherBalance;\n', '        ceoEtherBalance = 0;\n', '        ceoAddress.transfer(myBalance);\n', '    }\n', '    \n', '    function buySuperDragon() public payable {\n', '        require(isEnabled);\n', '        require(initialized);\n', '        uint currenPrice = SafeMath.add(SafeMath.div(SafeMath.mul(lastPrice, 4),100),lastPrice);\n', '        require(msg.value > currenPrice);\n', '        \n', '        uint256 timeSpent = SafeMath.sub(now, snatchedOn);\n', '        userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);\n', '        \n', '        hatchingSpeed += SafeMath.div(SafeMath.sub(now, contractStarted), 60*60*24);\n', '        ceoEtherBalance += calculatePercentage(msg.value, 20);\n', '        superPowerFulDragonOwner.transfer(msg.value - calculatePercentage(msg.value, 2));\n', '        lastPrice = currenPrice;\n', '        superPowerFulDragonOwner = msg.sender;\n', '        snatchedOn = now;\n', '    }\n', '    \n', '    function claimSuperDragonEggs() public {\n', '        require(isEnabled);\n', '        require (msg.sender == superPowerFulDragonOwner);\n', '        uint256 timeSpent = SafeMath.sub(now, snatchedOn);\n', '        userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);\n', '        snatchedOn = now;\n', '    }\n', '    \n', '    uint256 public EGGS_TO_HATCH_1Dragon=86400;//for final version should be seconds in a day\n', '    uint256 public STARTING_Dragon=100;\n', '    \n', '    uint256 PSN=10000;\n', '    uint256 PSNH=5000;\n', '    \n', '    bool public initialized=false;\n', '    address public ceoAddress = 0xdf4703369ecE603a01e049e34e438ff74Cd96D66;\n', '    uint public ceoEtherBalance;\n', '    \n', '    mapping (address => uint256) public iceDragons;\n', '    mapping (address => uint256) public premiumDragons;\n', '    mapping (address => uint256) public normalDragon;\n', '    mapping (address => uint256) public userHatchRate;\n', '    \n', '    mapping (address => uint256) public userReferralEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => address) public referrals;\n', '    \n', '    uint256 public marketEggs;\n', '    uint256 public contractStarted;\n', '        \n', '    function seedMarket(uint256 eggs) public payable {\n', '        require(marketEggs==0);\n', '        initialized=true;\n', '        marketEggs=eggs;\n', '        contractStarted = now;\n', '    }\n', '    \n', '    function getMyEggs() public view returns(uint256){\n', '        return SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender));\n', '    }\n', '    \n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256){\n', '        uint256 secondsPassed = SafeMath.sub(now,lastHatch[adr]);\n', '        uint256 dragonCount = SafeMath.mul(iceDragons[adr], 12);\n', '        dragonCount = SafeMath.add(dragonCount, premiumDragons[adr]);\n', '        dragonCount = SafeMath.add(dragonCount, normalDragon[adr]);\n', '        return SafeMath.mul(secondsPassed, dragonCount);\n', '    }\n', '    \n', '    function getEggsToHatchDragon() public view returns (uint) {\n', '        uint256 timeSpent = SafeMath.sub(now,contractStarted); \n', '        timeSpent = SafeMath.div(timeSpent, 3600);\n', '        return SafeMath.mul(timeSpent, 10);\n', '    }\n', '    \n', '    function getBalance() public view returns(uint256){\n', '        return address(this).balance;\n', '    }\n', '    \n', '    function getMyNormalDragons() public view returns(uint256) {\n', '        return SafeMath.add(normalDragon[msg.sender], premiumDragons[msg.sender]);\n', '    }\n', '    \n', '    function getMyIceDragon() public view returns(uint256) {\n', '        return iceDragons[msg.sender];\n', '    }\n', '    \n', '    function setUserHatchRate() internal {\n', '        if (userHatchRate[msg.sender] == 0) \n', '            userHatchRate[msg.sender] = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());\n', '    }\n', '    \n', '    function calculatePercentage(uint256 amount, uint percentage) public pure returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,percentage),100);\n', '    }\n', '    \n', '    function getFreeDragon() public {\n', '        require(initialized);\n', '        require(normalDragon[msg.sender] == 0);\n', '        \n', '        lastHatch[msg.sender]=now;\n', '        normalDragon[msg.sender]=STARTING_Dragon;\n', '        setUserHatchRate();\n', '    }\n', '    \n', '    function buyDrangon() public payable {\n', '        require(initialized);\n', '        require(userHatchRate[msg.sender] != 0);\n', '        uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance);\n', '        uint dragonAmount = SafeMath.div(msg.value, dragonPrice);\n', '        require(dragonAmount > 0);\n', '        \n', '        ceoEtherBalance += calculatePercentage(msg.value, 40);\n', '        premiumDragons[msg.sender] += dragonAmount;\n', '    }\n', '    \n', '    function buyIceDrangon() public payable {\n', '        require(initialized);\n', '        require(userHatchRate[msg.sender] != 0);\n', '        uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance) * 8;\n', '        uint dragonAmount = SafeMath.div(msg.value, dragonPrice);\n', '        require(dragonAmount > 0);\n', '        \n', '        ceoEtherBalance += calculatePercentage(msg.value, 40);\n', '        iceDragons[msg.sender] += dragonAmount;\n', '    }\n', '    \n', '    function hatchEggs(address ref) public {\n', '        require(initialized);\n', '        \n', '        if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {\n', '            referrals[msg.sender] = ref;\n', '        }\n', '        \n', '        uint256 eggsProduced = getMyEggs();\n', '        \n', '        uint256 newDragon = SafeMath.div(eggsProduced,userHatchRate[msg.sender]);\n', '        \n', '        uint256 eggsConsumed = SafeMath.mul(newDragon, userHatchRate[msg.sender]);\n', '        \n', '        normalDragon[msg.sender] = SafeMath.add(normalDragon[msg.sender],newDragon);\n', '        userReferralEggs[msg.sender] = SafeMath.sub(eggsProduced, eggsConsumed); \n', '        lastHatch[msg.sender]=now;\n', '        \n', '        //send referral eggs\n', '        userReferralEggs[referrals[msg.sender]]=SafeMath.add(userReferralEggs[referrals[msg.sender]],SafeMath.div(eggsConsumed,10));\n', '        \n', '        //boost market to nerf Dragon hoarding\n', '        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsProduced,10));\n', '    }\n', '    \n', '    function sellEggs() public {\n', '        require(initialized);\n', '        uint256 hasEggs = getMyEggs();\n', '        uint256 eggValue = calculateEggSell(hasEggs);\n', '        uint256 fee = calculatePercentage(eggValue, 20);\n', '        userReferralEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender]=now;\n', '        marketEggs=SafeMath.add(marketEggs,hasEggs);\n', '        ceoEtherBalance += fee;\n', '        msg.sender.transfer(SafeMath.sub(eggValue,fee));\n', '    }\n', '    \n', '    function getDragonPrice(uint eggs, uint256 eth) internal view returns (uint) {\n', '        uint dragonPrice = calculateEggSell(eggs, eth);\n', '        return calculatePercentage(dragonPrice, 140);\n', '    }\n', '    \n', '    function getDragonPriceNo() public view returns (uint) {\n', '        uint256 d = userHatchRate[msg.sender];\n', '        if (d == 0) \n', '            d = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());\n', '        return getDragonPrice(d, address(this).balance);\n', '    }\n', '    \n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));\n', '    }\n', '    \n', '    function calculateEggSell(uint256 eggs) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs,address(this).balance);\n', '    }\n', '    \n', '    function calculateEggSell(uint256 eggs, uint256 eth) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs,eth);\n', '    }\n', '    \n', '    \n', '    function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256){\n', '        return calculateTrade(eth,contractBalance,marketEggs);\n', '    }\n', '    \n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256) {\n', '        return calculateEggBuy(eth, address(this).balance);\n', '    }\n', '    \n', '    \n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
