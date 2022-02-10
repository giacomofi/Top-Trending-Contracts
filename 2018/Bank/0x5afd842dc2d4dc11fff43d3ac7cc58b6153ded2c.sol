['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '\n', '\n', 'contract TrumpFarmer{\n', '    //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;\n', '    uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day\n', '    uint256 public STARTING_SHRIMP=300;\n', '    uint256 PSN=10000;\n', '    uint256 PSNH=5000;\n', '    bool public initialized=false;\n', '    address public ceoAddress;\n', '    mapping (address => uint256) public hatcheryShrimp;\n', '    mapping (address => uint256) public claimedEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => address) public referrals;\n', '    uint256 public marketEggs;\n', '    function TrumpFarmer() public{\n', '        ceoAddress=msg.sender;\n', '    }\n', '    function hatchEggs(address ref) public{\n', '        require(initialized);\n', '        if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){\n', '            referrals[msg.sender]=ref;\n', '        }\n', '        uint256 eggsUsed=getMyEggs();\n', '        uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);\n', '        hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        \n', '        //send referral eggs\n', '        claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));\n', '        \n', '        //boost market to nerf shrimp hoarding\n', '        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));\n', '    }\n', '    function sellEggs() public{\n', '        require(initialized);\n', '        uint256 hasEggs=getMyEggs();\n', '        uint256 eggValue=calculateEggSell(hasEggs);\n', '        uint256 fee=devFee(eggValue);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        marketEggs=SafeMath.add(marketEggs,hasEggs);\n', '        ceoAddress.transfer(fee);\n', '        msg.sender.transfer(SafeMath.sub(eggValue,fee));\n', '    }\n', '    function buyEggs() public payable{\n', '        require(initialized);\n', '        uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));\n', '        eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));\n', '        ceoAddress.transfer(devFee(msg.value));\n', '        claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);\n', '    }\n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));\n', '    }\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs,this.balance);\n', '    }\n', '    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){\n', '        return calculateTrade(eth,contractBalance,marketEggs);\n', '    }\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256){\n', '        return calculateEggBuy(eth,this.balance);\n', '    }\n', '    function devFee(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,4),100);\n', '    }\n', '    function seedMarket(uint256 eggs) public payable{\n', '        require(marketEggs==0);\n', '        initialized=true;\n', '        marketEggs=eggs;\n', '    }\n', '    function getFreeShrimp() public{\n', '        require(initialized);\n', '        require(hatcheryShrimp[msg.sender]==0);\n', '        lastHatch[msg.sender]=now;\n', '        hatcheryShrimp[msg.sender]=STARTING_SHRIMP;\n', '    }\n', '    function getBalance() public view returns(uint256){\n', '        return this.balance;\n', '    }\n', '    function getMyShrimp() public view returns(uint256){\n', '        return hatcheryShrimp[msg.sender];\n', '    }\n', '    function getMyEggs() public view returns(uint256){\n', '        return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));\n', '    }\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256){\n', '        uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);\n', '    }\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']