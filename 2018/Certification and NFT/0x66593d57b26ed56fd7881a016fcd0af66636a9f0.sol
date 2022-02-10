['pragma solidity ^0.4.18;\n', '\n', 'contract Vineyard{\n', '\n', '    // All grape units are in grape-secs/day\n', '    uint256 constant public GRAPE_SECS_TO_GROW_VINE = 86400; // 1 grape\n', '    uint256 constant public STARTING_VINES = 300;\n', '    uint256 constant public VINE_CAPACITY_PER_LAND = 1000;\n', '\n', '    bool public initialized=false;\n', '    address public ceoAddress;\n', '    address public ceoWallet;\n', '\n', '    mapping (address => uint256) public vineyardVines;\n', '    mapping (address => uint256) public purchasedGrapes;\n', '    mapping (address => uint256) public lastHarvest;\n', '    mapping (address => address) public referrals;\n', '\n', '    uint256 public marketGrapes;\n', '\n', '    mapping (address => uint256) public landMultiplier;\n', '    mapping (address => uint256) public totalVineCapacity;\n', '    mapping (address => uint256) public wineInCellar;\n', '    mapping (address => uint256) public wineProductionRate;\n', '    uint256 public grapesToBuildWinery = 43200000000; // 500000 grapes\n', '    uint256 public grapesToProduceBottle = 3456000000; //40000 grapes\n', '\n', '    address constant public LAND_ADDRESS = 0x2C1E693cCC537c8c98C73FaC0262CD7E18a3Ad60;\n', '    LandInterface landContract;\n', '\n', '    function Vineyard(address _wallet) public{\n', '        require(_wallet != address(0));\n', '        ceoAddress = msg.sender;\n', '        ceoWallet = _wallet;\n', '        landContract = LandInterface(LAND_ADDRESS);\n', '    }\n', '\n', '    function transferWalletOwnership(address newWalletAddress) public {\n', '      require(msg.sender == ceoAddress);\n', '      require(newWalletAddress != address(0));\n', '      ceoWallet = newWalletAddress;\n', '    }\n', '\n', '    modifier initializedMarket {\n', '        require(initialized);\n', '        _;\n', '    }\n', '\n', '    function harvest(address ref) initializedMarket public {\n', '        if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){\n', '            referrals[msg.sender]=ref;\n', '        }\n', '        uint256 grapesUsed = getMyGrapes();\n', '        uint256 newVines = SafeMath.div(grapesUsed, GRAPE_SECS_TO_GROW_VINE);\n', '        if (SafeMath.add(vineyardVines[msg.sender], newVines) > totalVineCapacity[msg.sender]) {\n', '            purchasedGrapes[msg.sender] = SafeMath.mul(SafeMath.sub(SafeMath.add(vineyardVines[msg.sender], newVines), totalVineCapacity[msg.sender]), GRAPE_SECS_TO_GROW_VINE);\n', '            vineyardVines[msg.sender] = totalVineCapacity[msg.sender];\n', '            grapesUsed = grapesUsed - purchasedGrapes[msg.sender];\n', '        }\n', '        else\n', '        {\n', '            vineyardVines[msg.sender] = SafeMath.add(vineyardVines[msg.sender], newVines);\n', '            purchasedGrapes[msg.sender] = 0;\n', '        }\n', '        lastHarvest[msg.sender] = now;\n', '\n', '        //send referral grapes (add to purchase talley)\n', '        purchasedGrapes[referrals[msg.sender]]=SafeMath.add(purchasedGrapes[referrals[msg.sender]],SafeMath.div(grapesUsed,5));\n', '    }\n', '\n', '    function produceWine() initializedMarket public {\n', '        uint256 hasGrapes = getMyGrapes();\n', '        uint256 wineBottles = SafeMath.div(SafeMath.mul(hasGrapes, wineProductionRate[msg.sender]), grapesToProduceBottle);\n', '        purchasedGrapes[msg.sender] = 0; //Remainder of grapes are lost in wine production process\n', '        lastHarvest[msg.sender] = now;\n', '        //Every bottle of wine increases the grapes to make next by 10\n', '        grapesToProduceBottle = SafeMath.add(SafeMath.mul(864000, wineBottles), grapesToProduceBottle);\n', '        wineInCellar[msg.sender] = SafeMath.add(wineInCellar[msg.sender],wineBottles);\n', '    }\n', '\n', '    function buildWinery() initializedMarket public {\n', '        require(wineProductionRate[msg.sender] <= landMultiplier[msg.sender]);\n', '        uint256 hasGrapes = getMyGrapes();\n', '        require(hasGrapes >= grapesToBuildWinery);\n', '\n', '        uint256 grapesLeft = SafeMath.sub(hasGrapes, grapesToBuildWinery);\n', '        purchasedGrapes[msg.sender] = grapesLeft;\n', '        lastHarvest[msg.sender] = now;\n', '        wineProductionRate[msg.sender] = wineProductionRate[msg.sender] + 1;\n', '        grapesToBuildWinery = SafeMath.add(grapesToBuildWinery, 21600000000);\n', '        // winery uses some portion of land, so must remove some vines\n', '        vineyardVines[msg.sender] = SafeMath.sub(vineyardVines[msg.sender],1000);\n', '    }\n', '\n', '    function sellGrapes() initializedMarket public {\n', '        uint256 hasGrapes = getMyGrapes();\n', '        uint256 grapesToSell = hasGrapes;\n', '        if (grapesToSell > marketGrapes) {\n', '          // don&#39;t allow sell larger than the current market holdings\n', '          grapesToSell = marketGrapes;\n', '        }\n', '        uint256 grapeValue = calculateGrapeSell(grapesToSell);\n', '        uint256 fee = devFee(grapeValue);\n', '        purchasedGrapes[msg.sender] = SafeMath.sub(hasGrapes,grapesToSell);\n', '        lastHarvest[msg.sender] = now;\n', '        marketGrapes = SafeMath.add(marketGrapes,grapesToSell);\n', '        ceoWallet.transfer(fee);\n', '        msg.sender.transfer(SafeMath.sub(grapeValue, fee));\n', '    }\n', '\n', '    function buyGrapes() initializedMarket public payable{\n', '        require(msg.value <= SafeMath.sub(this.balance,msg.value));\n', '        require(vineyardVines[msg.sender] > 0);\n', '\n', '        uint256 grapesBought = calculateGrapeBuy(msg.value, SafeMath.sub(this.balance, msg.value));\n', '        grapesBought = SafeMath.sub(grapesBought, devFee(grapesBought));\n', '        marketGrapes = SafeMath.sub(marketGrapes, grapesBought);\n', '        ceoWallet.transfer(devFee(msg.value));\n', '        purchasedGrapes[msg.sender] = SafeMath.add(purchasedGrapes[msg.sender],grapesBought);\n', '    }\n', '\n', '    function calculateTrade(uint256 valueIn, uint256 marketInv, uint256 Balance) public view returns(uint256) {\n', '        return SafeMath.div(SafeMath.mul(Balance, 10000), SafeMath.add(SafeMath.div(SafeMath.add(SafeMath.mul(marketInv,10000), SafeMath.mul(valueIn, 5000)), valueIn), 5000));\n', '    }\n', '\n', '    function calculateGrapeSell(uint256 grapes) public view returns(uint256) {\n', '        return calculateTrade(grapes, marketGrapes, this.balance);\n', '    }\n', '\n', '    function calculateGrapeBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {\n', '        return calculateTrade(eth,contractBalance,marketGrapes);\n', '    }\n', '\n', '    function calculateGrapeBuySimple(uint256 eth) public view returns(uint256) {\n', '        return calculateGrapeBuy(eth,this.balance);\n', '    }\n', '\n', '    function devFee(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,3), 100);\n', '    }\n', '\n', '    function seedMarket(uint256 grapes) public payable{\n', '        require(marketGrapes == 0);\n', '        initialized = true;\n', '        marketGrapes = grapes;\n', '    }\n', '\n', '    function getFreeVines() initializedMarket public {\n', '        require(vineyardVines[msg.sender] == 0);\n', '        createPlotVineyard(msg.sender);\n', '    }\n', '\n', '    // For existing plot holders to get added to Mini-game\n', '    function addFreeVineyard(address adr) initializedMarket public {\n', '        require(msg.sender == ceoAddress);\n', '        require(vineyardVines[adr] == 0);\n', '        createPlotVineyard(adr);\n', '    }\n', '\n', '    function createPlotVineyard(address player) private {\n', '        lastHarvest[player] = now;\n', '        vineyardVines[player] = STARTING_VINES;\n', '        wineProductionRate[player] = 1;\n', '        landMultiplier[player] = 1;\n', '        totalVineCapacity[player] = VINE_CAPACITY_PER_LAND;\n', '    }\n', '\n', '    function setLandProductionMultiplier(address adr) public {\n', '        landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.addressToNumVillages(adr),SafeMath.add(SafeMath.mul(landContract.addressToNumTowns(adr),3),SafeMath.mul(landContract.addressToNumCities(adr),9))));\n', '        totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);\n', '    }\n', '\n', '    function setLandProductionMultiplierCCUser(bytes32 user, address adr) public {\n', '        require(msg.sender == ceoAddress);\n', '        landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.userToNumVillages(user), SafeMath.add(SafeMath.mul(landContract.userToNumTowns(user), 3), SafeMath.mul(landContract.userToNumCities(user), 9))));\n', '        totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);\n', '    }\n', '\n', '    function getBalance() public view returns(uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function getMyVines() public view returns(uint256) {\n', '        return vineyardVines[msg.sender];\n', '    }\n', '\n', '    function getMyGrapes() public view returns(uint256) {\n', '        return SafeMath.add(purchasedGrapes[msg.sender],getGrapesSinceLastHarvest(msg.sender));\n', '    }\n', '\n', '    function getMyWine() public view returns(uint256) {\n', '        return wineInCellar[msg.sender];\n', '    }\n', '\n', '    function getWineProductionRate() public view returns(uint256) {\n', '        return wineProductionRate[msg.sender];\n', '    }\n', '\n', '    function getGrapesSinceLastHarvest(address adr) public view returns(uint256) {\n', '        uint256 secondsPassed = SafeMath.sub(now, lastHarvest[adr]);\n', '        return SafeMath.mul(secondsPassed, SafeMath.mul(vineyardVines[adr], SafeMath.add(1,SafeMath.div(SafeMath.sub(landMultiplier[adr],1),5))));\n', '    }\n', '\n', '    function getMyLandMultiplier() public view returns(uint256) {\n', '        return landMultiplier[msg.sender];\n', '    }\n', '\n', '    function getGrapesToBuildWinery() public view returns(uint256) {\n', '        return grapesToBuildWinery;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '}\n', '\n', 'contract LandInterface {\n', '    function addressToNumVillages(address adr) public returns (uint256);\n', '    function addressToNumTowns(address adr) public returns (uint256);\n', '    function addressToNumCities(address adr) public returns (uint256);\n', '\n', '    function userToNumVillages(bytes32 userId) public returns (uint256);\n', '    function userToNumTowns(bytes32 userId) public returns (uint256);\n', '    function userToNumCities(bytes32 userId) public returns (uint256);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Vineyard{\n', '\n', '    // All grape units are in grape-secs/day\n', '    uint256 constant public GRAPE_SECS_TO_GROW_VINE = 86400; // 1 grape\n', '    uint256 constant public STARTING_VINES = 300;\n', '    uint256 constant public VINE_CAPACITY_PER_LAND = 1000;\n', '\n', '    bool public initialized=false;\n', '    address public ceoAddress;\n', '    address public ceoWallet;\n', '\n', '    mapping (address => uint256) public vineyardVines;\n', '    mapping (address => uint256) public purchasedGrapes;\n', '    mapping (address => uint256) public lastHarvest;\n', '    mapping (address => address) public referrals;\n', '\n', '    uint256 public marketGrapes;\n', '\n', '    mapping (address => uint256) public landMultiplier;\n', '    mapping (address => uint256) public totalVineCapacity;\n', '    mapping (address => uint256) public wineInCellar;\n', '    mapping (address => uint256) public wineProductionRate;\n', '    uint256 public grapesToBuildWinery = 43200000000; // 500000 grapes\n', '    uint256 public grapesToProduceBottle = 3456000000; //40000 grapes\n', '\n', '    address constant public LAND_ADDRESS = 0x2C1E693cCC537c8c98C73FaC0262CD7E18a3Ad60;\n', '    LandInterface landContract;\n', '\n', '    function Vineyard(address _wallet) public{\n', '        require(_wallet != address(0));\n', '        ceoAddress = msg.sender;\n', '        ceoWallet = _wallet;\n', '        landContract = LandInterface(LAND_ADDRESS);\n', '    }\n', '\n', '    function transferWalletOwnership(address newWalletAddress) public {\n', '      require(msg.sender == ceoAddress);\n', '      require(newWalletAddress != address(0));\n', '      ceoWallet = newWalletAddress;\n', '    }\n', '\n', '    modifier initializedMarket {\n', '        require(initialized);\n', '        _;\n', '    }\n', '\n', '    function harvest(address ref) initializedMarket public {\n', '        if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){\n', '            referrals[msg.sender]=ref;\n', '        }\n', '        uint256 grapesUsed = getMyGrapes();\n', '        uint256 newVines = SafeMath.div(grapesUsed, GRAPE_SECS_TO_GROW_VINE);\n', '        if (SafeMath.add(vineyardVines[msg.sender], newVines) > totalVineCapacity[msg.sender]) {\n', '            purchasedGrapes[msg.sender] = SafeMath.mul(SafeMath.sub(SafeMath.add(vineyardVines[msg.sender], newVines), totalVineCapacity[msg.sender]), GRAPE_SECS_TO_GROW_VINE);\n', '            vineyardVines[msg.sender] = totalVineCapacity[msg.sender];\n', '            grapesUsed = grapesUsed - purchasedGrapes[msg.sender];\n', '        }\n', '        else\n', '        {\n', '            vineyardVines[msg.sender] = SafeMath.add(vineyardVines[msg.sender], newVines);\n', '            purchasedGrapes[msg.sender] = 0;\n', '        }\n', '        lastHarvest[msg.sender] = now;\n', '\n', '        //send referral grapes (add to purchase talley)\n', '        purchasedGrapes[referrals[msg.sender]]=SafeMath.add(purchasedGrapes[referrals[msg.sender]],SafeMath.div(grapesUsed,5));\n', '    }\n', '\n', '    function produceWine() initializedMarket public {\n', '        uint256 hasGrapes = getMyGrapes();\n', '        uint256 wineBottles = SafeMath.div(SafeMath.mul(hasGrapes, wineProductionRate[msg.sender]), grapesToProduceBottle);\n', '        purchasedGrapes[msg.sender] = 0; //Remainder of grapes are lost in wine production process\n', '        lastHarvest[msg.sender] = now;\n', '        //Every bottle of wine increases the grapes to make next by 10\n', '        grapesToProduceBottle = SafeMath.add(SafeMath.mul(864000, wineBottles), grapesToProduceBottle);\n', '        wineInCellar[msg.sender] = SafeMath.add(wineInCellar[msg.sender],wineBottles);\n', '    }\n', '\n', '    function buildWinery() initializedMarket public {\n', '        require(wineProductionRate[msg.sender] <= landMultiplier[msg.sender]);\n', '        uint256 hasGrapes = getMyGrapes();\n', '        require(hasGrapes >= grapesToBuildWinery);\n', '\n', '        uint256 grapesLeft = SafeMath.sub(hasGrapes, grapesToBuildWinery);\n', '        purchasedGrapes[msg.sender] = grapesLeft;\n', '        lastHarvest[msg.sender] = now;\n', '        wineProductionRate[msg.sender] = wineProductionRate[msg.sender] + 1;\n', '        grapesToBuildWinery = SafeMath.add(grapesToBuildWinery, 21600000000);\n', '        // winery uses some portion of land, so must remove some vines\n', '        vineyardVines[msg.sender] = SafeMath.sub(vineyardVines[msg.sender],1000);\n', '    }\n', '\n', '    function sellGrapes() initializedMarket public {\n', '        uint256 hasGrapes = getMyGrapes();\n', '        uint256 grapesToSell = hasGrapes;\n', '        if (grapesToSell > marketGrapes) {\n', "          // don't allow sell larger than the current market holdings\n", '          grapesToSell = marketGrapes;\n', '        }\n', '        uint256 grapeValue = calculateGrapeSell(grapesToSell);\n', '        uint256 fee = devFee(grapeValue);\n', '        purchasedGrapes[msg.sender] = SafeMath.sub(hasGrapes,grapesToSell);\n', '        lastHarvest[msg.sender] = now;\n', '        marketGrapes = SafeMath.add(marketGrapes,grapesToSell);\n', '        ceoWallet.transfer(fee);\n', '        msg.sender.transfer(SafeMath.sub(grapeValue, fee));\n', '    }\n', '\n', '    function buyGrapes() initializedMarket public payable{\n', '        require(msg.value <= SafeMath.sub(this.balance,msg.value));\n', '        require(vineyardVines[msg.sender] > 0);\n', '\n', '        uint256 grapesBought = calculateGrapeBuy(msg.value, SafeMath.sub(this.balance, msg.value));\n', '        grapesBought = SafeMath.sub(grapesBought, devFee(grapesBought));\n', '        marketGrapes = SafeMath.sub(marketGrapes, grapesBought);\n', '        ceoWallet.transfer(devFee(msg.value));\n', '        purchasedGrapes[msg.sender] = SafeMath.add(purchasedGrapes[msg.sender],grapesBought);\n', '    }\n', '\n', '    function calculateTrade(uint256 valueIn, uint256 marketInv, uint256 Balance) public view returns(uint256) {\n', '        return SafeMath.div(SafeMath.mul(Balance, 10000), SafeMath.add(SafeMath.div(SafeMath.add(SafeMath.mul(marketInv,10000), SafeMath.mul(valueIn, 5000)), valueIn), 5000));\n', '    }\n', '\n', '    function calculateGrapeSell(uint256 grapes) public view returns(uint256) {\n', '        return calculateTrade(grapes, marketGrapes, this.balance);\n', '    }\n', '\n', '    function calculateGrapeBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {\n', '        return calculateTrade(eth,contractBalance,marketGrapes);\n', '    }\n', '\n', '    function calculateGrapeBuySimple(uint256 eth) public view returns(uint256) {\n', '        return calculateGrapeBuy(eth,this.balance);\n', '    }\n', '\n', '    function devFee(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,3), 100);\n', '    }\n', '\n', '    function seedMarket(uint256 grapes) public payable{\n', '        require(marketGrapes == 0);\n', '        initialized = true;\n', '        marketGrapes = grapes;\n', '    }\n', '\n', '    function getFreeVines() initializedMarket public {\n', '        require(vineyardVines[msg.sender] == 0);\n', '        createPlotVineyard(msg.sender);\n', '    }\n', '\n', '    // For existing plot holders to get added to Mini-game\n', '    function addFreeVineyard(address adr) initializedMarket public {\n', '        require(msg.sender == ceoAddress);\n', '        require(vineyardVines[adr] == 0);\n', '        createPlotVineyard(adr);\n', '    }\n', '\n', '    function createPlotVineyard(address player) private {\n', '        lastHarvest[player] = now;\n', '        vineyardVines[player] = STARTING_VINES;\n', '        wineProductionRate[player] = 1;\n', '        landMultiplier[player] = 1;\n', '        totalVineCapacity[player] = VINE_CAPACITY_PER_LAND;\n', '    }\n', '\n', '    function setLandProductionMultiplier(address adr) public {\n', '        landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.addressToNumVillages(adr),SafeMath.add(SafeMath.mul(landContract.addressToNumTowns(adr),3),SafeMath.mul(landContract.addressToNumCities(adr),9))));\n', '        totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);\n', '    }\n', '\n', '    function setLandProductionMultiplierCCUser(bytes32 user, address adr) public {\n', '        require(msg.sender == ceoAddress);\n', '        landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.userToNumVillages(user), SafeMath.add(SafeMath.mul(landContract.userToNumTowns(user), 3), SafeMath.mul(landContract.userToNumCities(user), 9))));\n', '        totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);\n', '    }\n', '\n', '    function getBalance() public view returns(uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function getMyVines() public view returns(uint256) {\n', '        return vineyardVines[msg.sender];\n', '    }\n', '\n', '    function getMyGrapes() public view returns(uint256) {\n', '        return SafeMath.add(purchasedGrapes[msg.sender],getGrapesSinceLastHarvest(msg.sender));\n', '    }\n', '\n', '    function getMyWine() public view returns(uint256) {\n', '        return wineInCellar[msg.sender];\n', '    }\n', '\n', '    function getWineProductionRate() public view returns(uint256) {\n', '        return wineProductionRate[msg.sender];\n', '    }\n', '\n', '    function getGrapesSinceLastHarvest(address adr) public view returns(uint256) {\n', '        uint256 secondsPassed = SafeMath.sub(now, lastHarvest[adr]);\n', '        return SafeMath.mul(secondsPassed, SafeMath.mul(vineyardVines[adr], SafeMath.add(1,SafeMath.div(SafeMath.sub(landMultiplier[adr],1),5))));\n', '    }\n', '\n', '    function getMyLandMultiplier() public view returns(uint256) {\n', '        return landMultiplier[msg.sender];\n', '    }\n', '\n', '    function getGrapesToBuildWinery() public view returns(uint256) {\n', '        return grapesToBuildWinery;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '}\n', '\n', 'contract LandInterface {\n', '    function addressToNumVillages(address adr) public returns (uint256);\n', '    function addressToNumTowns(address adr) public returns (uint256);\n', '    function addressToNumCities(address adr) public returns (uint256);\n', '\n', '    function userToNumVillages(bytes32 userId) public returns (uint256);\n', '    function userToNumTowns(bytes32 userId) public returns (uint256);\n', '    function userToNumCities(bytes32 userId) public returns (uint256);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
