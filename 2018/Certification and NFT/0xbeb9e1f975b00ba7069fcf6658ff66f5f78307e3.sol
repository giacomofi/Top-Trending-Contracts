['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', 'contract ShrimpFarmer{\n', '    function buyEggs() public payable;\n', '}\n', 'contract AdPotato{\n', '    address ceoAddress;\n', '    ShrimpFarmer fundsTarget;\n', '    Advertisement[] ads;\n', '    uint256 NUM_ADS=10;\n', '    uint256 BASE_PRICE=0.005 ether;\n', '    uint256 PERCENT_TAXED=30;\n', '    /***EVENTS***/\n', '    event BoughtAd(address sender, uint256 amount);\n', '    /*** ACCESS MODIFIERS ***/\n', '    modifier onlyCLevel() {\n', '    require(\n', '      msg.sender == ceoAddress\n', '    );\n', '    _;\n', '    }\n', '    /***CONSTRUCTOR***/\n', '    function AdPotato() public{\n', '        ceoAddress=msg.sender;\n', '        initialize(0x39dD0AC05016B2D4f82fdb3b70d011239abffA8B);\n', '    }\n', '    /*** DATATYPES ***/\n', '    struct Advertisement{\n', '        string text;\n', '        string url;\n', '        address owner;\n', '        uint256 startingLevel;\n', '        uint256 startingTime;\n', '        uint256 halfLife;\n', '    }\n', '    /*** PUBLIC FUNCTIONS ***/\n', '    function initialize(address fund) public onlyCLevel{\n', '        fundsTarget=ShrimpFarmer(fund);\n', '        for(uint i=0;i<NUM_ADS;i++){\n', '            ads.push(Advertisement({text:"Your Text Here",url:"",owner:ceoAddress,startingLevel:0,startingTime:now,halfLife:12 hours}));\n', '        }\n', '    }\n', '    function buyAd(uint256 index,string text,string url) public payable{\n', '        require(ads.length>index);\n', '        require(msg.sender==tx.origin);\n', '        Advertisement storage toBuy=ads[index];\n', '        uint256 currentLevel=getCurrentLevel(toBuy.startingLevel,toBuy.startingTime,toBuy.halfLife);\n', '        uint256 currentPrice=getCurrentPrice(currentLevel);\n', '        require(msg.value>=currentPrice);\n', '        uint256 purchaseExcess = SafeMath.sub(msg.value, currentPrice);\n', '        toBuy.text=text;\n', '        toBuy.url=url;\n', '        toBuy.startingLevel=currentLevel+1;\n', '        toBuy.startingTime=now;\n', '        fundsTarget.buyEggs.value(SafeMath.div(SafeMath.mul(currentPrice,PERCENT_TAXED),100))();//send to recipient of ad revenue\n', '        toBuy.owner.transfer(SafeMath.div(SafeMath.mul(currentPrice,100-PERCENT_TAXED),100));//send most of purchase price to previous owner\n', '        toBuy.owner=msg.sender;//change owner\n', '        msg.sender.transfer(purchaseExcess);\n', '        emit BoughtAd(msg.sender,purchaseExcess);\n', '    }\n', '    function getAdText(uint256 index)public view returns(string){\n', '        return ads[index].text;\n', '    }\n', '    function getAdUrl(uint256 index)public view returns(string){\n', '        return ads[index].url;\n', '    }\n', '    function getAdOwner(uint256 index) public view returns(address){\n', '        return ads[index].owner;\n', '    }\n', '    function getAdPrice(uint256 index) public view returns(uint256){\n', '        Advertisement ad=ads[index];\n', '        return getCurrentPrice(getCurrentLevel(ad.startingLevel,ad.startingTime,ad.halfLife));\n', '    }\n', '    function getCurrentPrice(uint256 currentLevel) public view returns(uint256){\n', '        return BASE_PRICE*2**currentLevel; //** is exponent, price doubles every level\n', '    }\n', '    function getCurrentLevel(uint256 startingLevel,uint256 startingTime,uint256 halfLife)public view returns(uint256){\n', '        uint256 timePassed=SafeMath.sub(now,startingTime);\n', '        uint256 levelsPassed=SafeMath.div(timePassed,halfLife);\n', '        if(startingLevel<levelsPassed){\n', '            return 0;\n', '        }\n', '        return SafeMath.sub(startingLevel,levelsPassed);\n', '    }\n', '    /*** PRIVATE FUNCTIONS ***/\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', 'contract ShrimpFarmer{\n', '    function buyEggs() public payable;\n', '}\n', 'contract AdPotato{\n', '    address ceoAddress;\n', '    ShrimpFarmer fundsTarget;\n', '    Advertisement[] ads;\n', '    uint256 NUM_ADS=10;\n', '    uint256 BASE_PRICE=0.005 ether;\n', '    uint256 PERCENT_TAXED=30;\n', '    /***EVENTS***/\n', '    event BoughtAd(address sender, uint256 amount);\n', '    /*** ACCESS MODIFIERS ***/\n', '    modifier onlyCLevel() {\n', '    require(\n', '      msg.sender == ceoAddress\n', '    );\n', '    _;\n', '    }\n', '    /***CONSTRUCTOR***/\n', '    function AdPotato() public{\n', '        ceoAddress=msg.sender;\n', '        initialize(0x39dD0AC05016B2D4f82fdb3b70d011239abffA8B);\n', '    }\n', '    /*** DATATYPES ***/\n', '    struct Advertisement{\n', '        string text;\n', '        string url;\n', '        address owner;\n', '        uint256 startingLevel;\n', '        uint256 startingTime;\n', '        uint256 halfLife;\n', '    }\n', '    /*** PUBLIC FUNCTIONS ***/\n', '    function initialize(address fund) public onlyCLevel{\n', '        fundsTarget=ShrimpFarmer(fund);\n', '        for(uint i=0;i<NUM_ADS;i++){\n', '            ads.push(Advertisement({text:"Your Text Here",url:"",owner:ceoAddress,startingLevel:0,startingTime:now,halfLife:12 hours}));\n', '        }\n', '    }\n', '    function buyAd(uint256 index,string text,string url) public payable{\n', '        require(ads.length>index);\n', '        require(msg.sender==tx.origin);\n', '        Advertisement storage toBuy=ads[index];\n', '        uint256 currentLevel=getCurrentLevel(toBuy.startingLevel,toBuy.startingTime,toBuy.halfLife);\n', '        uint256 currentPrice=getCurrentPrice(currentLevel);\n', '        require(msg.value>=currentPrice);\n', '        uint256 purchaseExcess = SafeMath.sub(msg.value, currentPrice);\n', '        toBuy.text=text;\n', '        toBuy.url=url;\n', '        toBuy.startingLevel=currentLevel+1;\n', '        toBuy.startingTime=now;\n', '        fundsTarget.buyEggs.value(SafeMath.div(SafeMath.mul(currentPrice,PERCENT_TAXED),100))();//send to recipient of ad revenue\n', '        toBuy.owner.transfer(SafeMath.div(SafeMath.mul(currentPrice,100-PERCENT_TAXED),100));//send most of purchase price to previous owner\n', '        toBuy.owner=msg.sender;//change owner\n', '        msg.sender.transfer(purchaseExcess);\n', '        emit BoughtAd(msg.sender,purchaseExcess);\n', '    }\n', '    function getAdText(uint256 index)public view returns(string){\n', '        return ads[index].text;\n', '    }\n', '    function getAdUrl(uint256 index)public view returns(string){\n', '        return ads[index].url;\n', '    }\n', '    function getAdOwner(uint256 index) public view returns(address){\n', '        return ads[index].owner;\n', '    }\n', '    function getAdPrice(uint256 index) public view returns(uint256){\n', '        Advertisement ad=ads[index];\n', '        return getCurrentPrice(getCurrentLevel(ad.startingLevel,ad.startingTime,ad.halfLife));\n', '    }\n', '    function getCurrentPrice(uint256 currentLevel) public view returns(uint256){\n', '        return BASE_PRICE*2**currentLevel; //** is exponent, price doubles every level\n', '    }\n', '    function getCurrentLevel(uint256 startingLevel,uint256 startingTime,uint256 halfLife)public view returns(uint256){\n', '        uint256 timePassed=SafeMath.sub(now,startingTime);\n', '        uint256 levelsPassed=SafeMath.div(timePassed,halfLife);\n', '        if(startingLevel<levelsPassed){\n', '            return 0;\n', '        }\n', '        return SafeMath.sub(startingLevel,levelsPassed);\n', '    }\n', '    /*** PRIVATE FUNCTIONS ***/\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
