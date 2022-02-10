['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '\n', 'contract ERC20Interface {\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '}\n', '\n', 'contract Elyxr {\n', '\n', '    function buy(address) public payable returns(uint256);\n', '    function transfer(address, uint256) public returns(bool);\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '    function reinvest() public;\n', '}\n', '\n', '/**\n', ' * Definition of contract accepting Elyxr tokens\n', ' * Games, casinos, anything can reuse this contract to support Elyxr tokens\n', ' */\n', 'contract AcceptsElyxr {\n', '    Elyxr public tokenContract;\n', '\n', '    function AcceptsElyxr(address _tokenContract) public {\n', '        tokenContract = Elyxr(_tokenContract);\n', '    }\n', '\n', '    modifier onlyTokenContract {\n', '        require(msg.sender == address(tokenContract));\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Standard ERC677 function that will handle incoming token transfers.\n', '    *\n', '    * @param _from  Token sender address.\n', '    * @param _value Amount of tokens.\n', '    * @param _data  Transaction metadata.\n', '    */\n', '    function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);\n', '}\n', '\n', '// 50 Tokens, seeded market of 8640000000 Eggs\n', 'contract ElyxrShrimpFarmer is AcceptsElyxr {\n', '    //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;\n', '    uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day\n', '    uint256 public STARTING_SHRIMP=300;\n', '    uint256 PSN=10000;\n', '    uint256 PSNH=5000;\n', '    bool public initialized=false;\n', '    address public ceoAddress;\n', '    mapping (address => uint256) public hatcheryShrimp;\n', '    mapping (address => uint256) public claimedEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => address) public referrals;\n', '    uint256 public marketEggs;\n', '\n', '    function ElyxrShrimpFarmer(address _baseContract)\n', '      AcceptsElyxr(_baseContract)\n', '      public{\n', '        ceoAddress=msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Fallback function for the contract, protect investors\n', '     */\n', '    function() payable public {\n', '      /* revert(); */\n', '    }\n', '\n', '    /**\n', '    * Deposit Elyxr tokens to buy eggs in farm\n', '    *\n', '    * @dev Standard ERC677 function that will handle incoming token transfers.\n', '    * @param _from  Token sender address.\n', '    * @param _value Amount of tokens.\n', '    * @param _data  Transaction metadata.\n', '    */\n', '    function tokenFallback(address _from, uint256 _value, bytes _data)\n', '      external\n', '      onlyTokenContract\n', '      returns (bool) {\n', '        require(initialized);\n', '        require(!_isContract(_from));\n', '        require(_value >= 1 finney); // 0.001 ELXR token\n', '\n', '        uint256 ElyxrBalance = tokenContract.myTokens();\n', '\n', '        uint256 eggsBought=calculateEggBuy(_value, SafeMath.sub(ElyxrBalance, _value));\n', '        eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));\n', '        reinvest();\n', '        tokenContract.transfer(ceoAddress, devFee(_value));\n', '        claimedEggs[_from]=SafeMath.add(claimedEggs[_from],eggsBought);\n', '\n', '        return true;\n', '    }\n', '\n', '    function hatchEggs(address ref) public{\n', '        require(initialized);\n', '        if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){\n', '            referrals[msg.sender]=ref;\n', '        }\n', '        uint256 eggsUsed=getMyEggs();\n', '        uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);\n', '        hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '\n', '        //send referral eggs\n', '        claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));\n', '\n', '        //boost market to nerf shrimp hoarding\n', '        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));\n', '    }\n', '\n', '    function sellEggs() public{\n', '        require(initialized);\n', '        uint256 hasEggs=getMyEggs();\n', '        uint256 eggValue=calculateEggSell(hasEggs);\n', '        uint256 fee=devFee(eggValue);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        marketEggs=SafeMath.add(marketEggs,hasEggs);\n', '        reinvest();\n', '        tokenContract.transfer(ceoAddress, fee);\n', '        tokenContract.transfer(msg.sender, SafeMath.sub(eggValue,fee));\n', '    }\n', '\n', '    // Dev should initially seed the game before start\n', '    function seedMarket(uint256 eggs) public {\n', '        require(marketEggs==0);\n', '        require(msg.sender==ceoAddress); // only CEO can seed the market\n', '        initialized=true;\n', '        marketEggs=eggs;\n', '    }\n', '\n', '    // Reinvest Elyxr Shrimp Farm dividends\n', '    // All the dividends this contract makes will be used to grow token fund for players\n', '    // of the Elyxr Schrimp Farm\n', '    function reinvest() public {\n', '       if(tokenContract.myDividends(true) > 1) {\n', '         tokenContract.reinvest();\n', '       }\n', '    }\n', '\n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));\n', '    }\n', '\n', '    // Calculate trade to sell eggs\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs, tokenContract.myTokens());\n', '    }\n', '\n', '    // Calculate trade to buy eggs\n', '    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){\n', '        return calculateTrade(eth, contractBalance, marketEggs);\n', '    }\n', '\n', '    // Calculate eggs to buy simple\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256){\n', '        return calculateEggBuy(eth, tokenContract.myTokens());\n', '    }\n', '\n', '    // Calculate dev fee in game\n', '    function devFee(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,4),100);\n', '    }\n', '\n', '    // Get amount of Shrimps user has\n', '    function getMyShrimp() public view returns(uint256){\n', '        return hatcheryShrimp[msg.sender];\n', '    }\n', '\n', '    // Get amount of eggs of current user\n', '    function getMyEggs() public view returns(uint256){\n', '        return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));\n', '    }\n', '\n', '    // Get number of doges since last hatch\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256){\n', '        uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);\n', '    }\n', '\n', '    // Collect information about doge farm dividents amount\n', '    function getContractDividends() public view returns(uint256) {\n', '      return tokenContract.myDividends(true); // + this.balance;\n', '    }\n', '\n', '    // Get tokens balance of the doge farm\n', '    function getBalance() public view returns(uint256){\n', '        return tokenContract.myTokens();\n', '    }\n', '\n', '    // Check transaction coming from the contract or not\n', '    function _isContract(address _user) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(_user) }\n', '        return size > 0;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '\n', 'contract ERC20Interface {\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '}\n', '\n', 'contract Elyxr {\n', '\n', '    function buy(address) public payable returns(uint256);\n', '    function transfer(address, uint256) public returns(bool);\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '    function reinvest() public;\n', '}\n', '\n', '/**\n', ' * Definition of contract accepting Elyxr tokens\n', ' * Games, casinos, anything can reuse this contract to support Elyxr tokens\n', ' */\n', 'contract AcceptsElyxr {\n', '    Elyxr public tokenContract;\n', '\n', '    function AcceptsElyxr(address _tokenContract) public {\n', '        tokenContract = Elyxr(_tokenContract);\n', '    }\n', '\n', '    modifier onlyTokenContract {\n', '        require(msg.sender == address(tokenContract));\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Standard ERC677 function that will handle incoming token transfers.\n', '    *\n', '    * @param _from  Token sender address.\n', '    * @param _value Amount of tokens.\n', '    * @param _data  Transaction metadata.\n', '    */\n', '    function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);\n', '}\n', '\n', '// 50 Tokens, seeded market of 8640000000 Eggs\n', 'contract ElyxrShrimpFarmer is AcceptsElyxr {\n', '    //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;\n', '    uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day\n', '    uint256 public STARTING_SHRIMP=300;\n', '    uint256 PSN=10000;\n', '    uint256 PSNH=5000;\n', '    bool public initialized=false;\n', '    address public ceoAddress;\n', '    mapping (address => uint256) public hatcheryShrimp;\n', '    mapping (address => uint256) public claimedEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => address) public referrals;\n', '    uint256 public marketEggs;\n', '\n', '    function ElyxrShrimpFarmer(address _baseContract)\n', '      AcceptsElyxr(_baseContract)\n', '      public{\n', '        ceoAddress=msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Fallback function for the contract, protect investors\n', '     */\n', '    function() payable public {\n', '      /* revert(); */\n', '    }\n', '\n', '    /**\n', '    * Deposit Elyxr tokens to buy eggs in farm\n', '    *\n', '    * @dev Standard ERC677 function that will handle incoming token transfers.\n', '    * @param _from  Token sender address.\n', '    * @param _value Amount of tokens.\n', '    * @param _data  Transaction metadata.\n', '    */\n', '    function tokenFallback(address _from, uint256 _value, bytes _data)\n', '      external\n', '      onlyTokenContract\n', '      returns (bool) {\n', '        require(initialized);\n', '        require(!_isContract(_from));\n', '        require(_value >= 1 finney); // 0.001 ELXR token\n', '\n', '        uint256 ElyxrBalance = tokenContract.myTokens();\n', '\n', '        uint256 eggsBought=calculateEggBuy(_value, SafeMath.sub(ElyxrBalance, _value));\n', '        eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));\n', '        reinvest();\n', '        tokenContract.transfer(ceoAddress, devFee(_value));\n', '        claimedEggs[_from]=SafeMath.add(claimedEggs[_from],eggsBought);\n', '\n', '        return true;\n', '    }\n', '\n', '    function hatchEggs(address ref) public{\n', '        require(initialized);\n', '        if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){\n', '            referrals[msg.sender]=ref;\n', '        }\n', '        uint256 eggsUsed=getMyEggs();\n', '        uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);\n', '        hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '\n', '        //send referral eggs\n', '        claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));\n', '\n', '        //boost market to nerf shrimp hoarding\n', '        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));\n', '    }\n', '\n', '    function sellEggs() public{\n', '        require(initialized);\n', '        uint256 hasEggs=getMyEggs();\n', '        uint256 eggValue=calculateEggSell(hasEggs);\n', '        uint256 fee=devFee(eggValue);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        marketEggs=SafeMath.add(marketEggs,hasEggs);\n', '        reinvest();\n', '        tokenContract.transfer(ceoAddress, fee);\n', '        tokenContract.transfer(msg.sender, SafeMath.sub(eggValue,fee));\n', '    }\n', '\n', '    // Dev should initially seed the game before start\n', '    function seedMarket(uint256 eggs) public {\n', '        require(marketEggs==0);\n', '        require(msg.sender==ceoAddress); // only CEO can seed the market\n', '        initialized=true;\n', '        marketEggs=eggs;\n', '    }\n', '\n', '    // Reinvest Elyxr Shrimp Farm dividends\n', '    // All the dividends this contract makes will be used to grow token fund for players\n', '    // of the Elyxr Schrimp Farm\n', '    function reinvest() public {\n', '       if(tokenContract.myDividends(true) > 1) {\n', '         tokenContract.reinvest();\n', '       }\n', '    }\n', '\n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));\n', '    }\n', '\n', '    // Calculate trade to sell eggs\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs, tokenContract.myTokens());\n', '    }\n', '\n', '    // Calculate trade to buy eggs\n', '    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){\n', '        return calculateTrade(eth, contractBalance, marketEggs);\n', '    }\n', '\n', '    // Calculate eggs to buy simple\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256){\n', '        return calculateEggBuy(eth, tokenContract.myTokens());\n', '    }\n', '\n', '    // Calculate dev fee in game\n', '    function devFee(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,4),100);\n', '    }\n', '\n', '    // Get amount of Shrimps user has\n', '    function getMyShrimp() public view returns(uint256){\n', '        return hatcheryShrimp[msg.sender];\n', '    }\n', '\n', '    // Get amount of eggs of current user\n', '    function getMyEggs() public view returns(uint256){\n', '        return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));\n', '    }\n', '\n', '    // Get number of doges since last hatch\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256){\n', '        uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);\n', '    }\n', '\n', '    // Collect information about doge farm dividents amount\n', '    function getContractDividends() public view returns(uint256) {\n', '      return tokenContract.myDividends(true); // + this.balance;\n', '    }\n', '\n', '    // Get tokens balance of the doge farm\n', '    function getBalance() public view returns(uint256){\n', '        return tokenContract.myTokens();\n', '    }\n', '\n', '    // Check transaction coming from the contract or not\n', '    function _isContract(address _user) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(_user) }\n', '        return size > 0;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
