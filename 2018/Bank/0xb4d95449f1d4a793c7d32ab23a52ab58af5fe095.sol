['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '\n', '\n', 'contract VerifyToken {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    bool public activated;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', 'contract EthVerifyCore{\n', '  mapping (address => bool) public verifiedUsers;\n', '}\n', 'contract ShrimpFarmer is ApproveAndCallFallBack{\n', '    using SafeMath for uint;\n', '    address vrfAddress=0x5BD574410F3A2dA202bABBa1609330Db02aD64C2;\n', '    VerifyToken vrfcontract=VerifyToken(vrfAddress);\n', '\n', '    //257977574257854071311765966\n', '    //                10000000000\n', '    //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;\n', '    uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//86400\n', '    uint public VRF_EGG_COST=(1000000000000000000*300)/EGGS_TO_HATCH_1SHRIMP;\n', '    uint256 public STARTING_SHRIMP=300;\n', '    uint256 PSN=100000000000000;\n', '    uint256 PSNH=50000000000000;\n', '    uint public potDrainTime=2 hours;//\n', '    uint public POT_DRAIN_INCREMENT=1 hours;\n', '    uint public POT_DRAIN_MAX=3 days;\n', '    uint public HATCH_COOLDOWN_MAX=6 hours;//6 hours;\n', '    bool public initialized=false;\n', '    //bool public completed=false;\n', '\n', '    address public ceoAddress;\n', '    address public dev2;\n', '    mapping (address => uint256) public hatchCooldown;//the amount of time you must wait now varies per user\n', '    mapping (address => uint256) public hatcheryShrimp;\n', '    mapping (address => uint256) public claimedEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => bool) public hasClaimedFree;\n', '    uint256 public marketEggs;\n', '    EthVerifyCore public ethVerify=EthVerifyCore(0x1c307A39511C16F74783fCd0091a921ec29A0b51);\n', '\n', '    uint public lastBidTime;//last time someone bid for the pot\n', '    address public currentWinner;\n', '    uint public potEth=0;//eth specifically set aside for the pot\n', '    uint public totalHatcheryShrimp=0;\n', '    uint public prizeEth=0;\n', '\n', '    function ShrimpFarmer() public{\n', '        ceoAddress=msg.sender;\n', '        dev2=address(0x95096780Efd48FA66483Bc197677e89f37Ca0CB5);\n', '        lastBidTime=now;\n', '        currentWinner=msg.sender;\n', '    }\n', '    function finalizeIfNecessary() public{\n', '      if(lastBidTime.add(potDrainTime)<now){\n', '        currentWinner.transfer(this.balance);//winner gets everything\n', '        initialized=false;\n', '        //completed=true;\n', '      }\n', '    }\n', '    function getPotCost() public view returns(uint){\n', '        return totalHatcheryShrimp.div(100);\n', '    }\n', '    function stealPot() public {\n', '\n', '      if(initialized){\n', '          _hatchEggs(0);\n', '          uint cost=getPotCost();\n', '          hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].sub(cost);//cost is 1% of total shrimp\n', '          totalHatcheryShrimp=totalHatcheryShrimp.sub(cost);\n', '          setNewPotWinner();\n', '          hatchCooldown[msg.sender]=0;\n', '      }\n', '    }\n', '    function setNewPotWinner() private {\n', '      finalizeIfNecessary();\n', '      if(initialized && msg.sender!=currentWinner){\n', '        potDrainTime=lastBidTime.add(potDrainTime).sub(now).add(POT_DRAIN_INCREMENT);//time left plus one hour\n', '        if(potDrainTime>POT_DRAIN_MAX){\n', '          potDrainTime=POT_DRAIN_MAX;\n', '        }\n', '        lastBidTime=now;\n', '        currentWinner=msg.sender;\n', '      }\n', '    }\n', '    function isHatchOnCooldown() public view returns(bool){\n', '      return lastHatch[msg.sender].add(hatchCooldown[msg.sender])<now;\n', '    }\n', '    function hatchEggs(address ref) public{\n', '      require(isHatchOnCooldown());\n', '      _hatchEggs(ref);\n', '    }\n', '    function _hatchEggs(address ref) private{\n', '        require(initialized);\n', '\n', '        uint256 eggsUsed=getMyEggs();\n', '        uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);\n', '        hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);\n', '        totalHatcheryShrimp=totalHatcheryShrimp.add(newShrimp);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        hatchCooldown[msg.sender]=HATCH_COOLDOWN_MAX;\n', '        //send referral eggs\n', '        require(ref!=msg.sender);\n', '        if(ref!=0){\n', '          claimedEggs[ref]=claimedEggs[ref].add(eggsUsed.div(7));\n', '        }\n', '        //boost market to nerf shrimp hoarding\n', '        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,7));\n', '    }\n', '    function getHatchCooldown(uint eggs) public view returns(uint){\n', '      uint targetEggs=marketEggs.div(50);\n', '      if(eggs>=targetEggs){\n', '        return HATCH_COOLDOWN_MAX;\n', '      }\n', '      return (HATCH_COOLDOWN_MAX.mul(eggs)).div(targetEggs);\n', '    }\n', '    function reduceHatchCooldown(address addr,uint eggs) private{\n', '      uint reduction=getHatchCooldown(eggs);\n', '      if(reduction>=hatchCooldown[addr]){\n', '        hatchCooldown[addr]=0;\n', '      }\n', '      else{\n', '        hatchCooldown[addr]=hatchCooldown[addr].sub(reduction);\n', '      }\n', '    }\n', '    function sellEggs() public{\n', '        require(initialized);\n', '        finalizeIfNecessary();\n', '        uint256 hasEggs=getMyEggs();\n', '        uint256 eggValue=calculateEggSell(hasEggs);\n', '        //uint256 fee=devFee(eggValue);\n', '        uint potfee=potFee(eggValue);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        marketEggs=SafeMath.add(marketEggs,hasEggs);\n', '        //ceoAddress.transfer(fee);\n', '        prizeEth=prizeEth.add(potfee);\n', '        msg.sender.transfer(eggValue.sub(potfee));\n', '    }\n', '    function buyEggs() public payable{\n', '        require(initialized);\n', '        uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));\n', '        eggsBought=eggsBought.sub(devFee(eggsBought));\n', '        eggsBought=eggsBought.sub(devFee2(eggsBought));\n', '        ceoAddress.transfer(devFee(msg.value));\n', '        dev2.transfer(devFee2(msg.value));\n', '        claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);\n', '        reduceHatchCooldown(msg.sender,eggsBought); //reduce the hatching cooldown based on eggs bought\n', '\n', '        //steal the pot if bought enough\n', '        uint potEggCost=getPotCost().mul(EGGS_TO_HATCH_1SHRIMP);//the equivalent number of eggs to the pot cost in shrimp\n', '        if(eggsBought>potEggCost){\n', '          //hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].add(getPotCost());//to compensate for the shrimp that will be lost when calling the following\n', '          //stealPot();\n', '          setNewPotWinner();\n', '        }\n', '    }\n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));\n', '    }\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs,this.balance.sub(prizeEth));\n', '    }\n', '    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){\n', '        return calculateTrade(eth,contractBalance.sub(prizeEth),marketEggs);\n', '    }\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256){\n', '        return calculateEggBuy(eth,this.balance);\n', '    }\n', '    function potFee(uint amount) public view returns(uint){\n', '        return SafeMath.div(SafeMath.mul(amount,20),100);\n', '    }\n', '    function devFee(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,4),100);\n', '    }\n', '    function devFee2(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(amount,100);\n', '    }\n', '    function seedMarket(uint256 eggs) public payable{\n', '        require(msg.sender==ceoAddress);\n', '        require(!initialized);\n', '        //require(marketEggs==0);\n', '        initialized=true;\n', '        marketEggs=eggs;\n', '        lastBidTime=now;\n', '    }\n', '    //Tokens are exchanged for shrimp by sending them to this contract with ApproveAndCall\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public{\n', '        require(!initialized);\n', '        require(msg.sender==vrfAddress);\n', '        require(ethVerify.verifiedUsers(from));//you must now be verified for this\n', '        require(claimedEggs[from].add(tokens.div(VRF_EGG_COST))<=1001*EGGS_TO_HATCH_1SHRIMP);//you may now trade for a max of 1000 eggs\n', '        vrfcontract.transferFrom(from,this,tokens);\n', '        claimedEggs[from]=claimedEggs[from].add(tokens.div(VRF_EGG_COST));\n', '    }\n', '    //allow sending eth to the contract\n', '    function () public payable {}\n', '\n', '    function claimFreeEggs() public{\n', '//  RE ENABLE THIS BEFORE DEPLOYING MAINNET\n', '        require(ethVerify.verifiedUsers(msg.sender));\n', '        require(initialized);\n', '        require(!hasClaimedFree[msg.sender]);\n', '        claimedEggs[msg.sender]=claimedEggs[msg.sender].add(getFreeEggs());\n', '        _hatchEggs(0);\n', '        hatchCooldown[msg.sender]=0;\n', '        hasClaimedFree[msg.sender]=true;\n', '        //require(hatcheryShrimp[msg.sender]==0);\n', '        //lastHatch[msg.sender]=now;\n', '        //hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].add(STARTING_SHRIMP);\n', '    }\n', '    function getFreeEggs() public view returns(uint){\n', '        return min(calculateEggBuySimple(this.balance.div(400)),calculateEggBuySimple(0.01 ether));\n', '    }\n', '    function getBalance() public view returns(uint256){\n', '        return this.balance;\n', '    }\n', '    function getMyShrimp() public view returns(uint256){\n', '        return hatcheryShrimp[msg.sender];\n', '    }\n', '    function getMyEggs() public view returns(uint256){\n', '        return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));\n', '    }\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256){\n', '        uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);\n', '    }\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '\n', '\n', 'contract VerifyToken {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    bool public activated;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', 'contract EthVerifyCore{\n', '  mapping (address => bool) public verifiedUsers;\n', '}\n', 'contract ShrimpFarmer is ApproveAndCallFallBack{\n', '    using SafeMath for uint;\n', '    address vrfAddress=0x5BD574410F3A2dA202bABBa1609330Db02aD64C2;\n', '    VerifyToken vrfcontract=VerifyToken(vrfAddress);\n', '\n', '    //257977574257854071311765966\n', '    //                10000000000\n', '    //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;\n', '    uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//86400\n', '    uint public VRF_EGG_COST=(1000000000000000000*300)/EGGS_TO_HATCH_1SHRIMP;\n', '    uint256 public STARTING_SHRIMP=300;\n', '    uint256 PSN=100000000000000;\n', '    uint256 PSNH=50000000000000;\n', '    uint public potDrainTime=2 hours;//\n', '    uint public POT_DRAIN_INCREMENT=1 hours;\n', '    uint public POT_DRAIN_MAX=3 days;\n', '    uint public HATCH_COOLDOWN_MAX=6 hours;//6 hours;\n', '    bool public initialized=false;\n', '    //bool public completed=false;\n', '\n', '    address public ceoAddress;\n', '    address public dev2;\n', '    mapping (address => uint256) public hatchCooldown;//the amount of time you must wait now varies per user\n', '    mapping (address => uint256) public hatcheryShrimp;\n', '    mapping (address => uint256) public claimedEggs;\n', '    mapping (address => uint256) public lastHatch;\n', '    mapping (address => bool) public hasClaimedFree;\n', '    uint256 public marketEggs;\n', '    EthVerifyCore public ethVerify=EthVerifyCore(0x1c307A39511C16F74783fCd0091a921ec29A0b51);\n', '\n', '    uint public lastBidTime;//last time someone bid for the pot\n', '    address public currentWinner;\n', '    uint public potEth=0;//eth specifically set aside for the pot\n', '    uint public totalHatcheryShrimp=0;\n', '    uint public prizeEth=0;\n', '\n', '    function ShrimpFarmer() public{\n', '        ceoAddress=msg.sender;\n', '        dev2=address(0x95096780Efd48FA66483Bc197677e89f37Ca0CB5);\n', '        lastBidTime=now;\n', '        currentWinner=msg.sender;\n', '    }\n', '    function finalizeIfNecessary() public{\n', '      if(lastBidTime.add(potDrainTime)<now){\n', '        currentWinner.transfer(this.balance);//winner gets everything\n', '        initialized=false;\n', '        //completed=true;\n', '      }\n', '    }\n', '    function getPotCost() public view returns(uint){\n', '        return totalHatcheryShrimp.div(100);\n', '    }\n', '    function stealPot() public {\n', '\n', '      if(initialized){\n', '          _hatchEggs(0);\n', '          uint cost=getPotCost();\n', '          hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].sub(cost);//cost is 1% of total shrimp\n', '          totalHatcheryShrimp=totalHatcheryShrimp.sub(cost);\n', '          setNewPotWinner();\n', '          hatchCooldown[msg.sender]=0;\n', '      }\n', '    }\n', '    function setNewPotWinner() private {\n', '      finalizeIfNecessary();\n', '      if(initialized && msg.sender!=currentWinner){\n', '        potDrainTime=lastBidTime.add(potDrainTime).sub(now).add(POT_DRAIN_INCREMENT);//time left plus one hour\n', '        if(potDrainTime>POT_DRAIN_MAX){\n', '          potDrainTime=POT_DRAIN_MAX;\n', '        }\n', '        lastBidTime=now;\n', '        currentWinner=msg.sender;\n', '      }\n', '    }\n', '    function isHatchOnCooldown() public view returns(bool){\n', '      return lastHatch[msg.sender].add(hatchCooldown[msg.sender])<now;\n', '    }\n', '    function hatchEggs(address ref) public{\n', '      require(isHatchOnCooldown());\n', '      _hatchEggs(ref);\n', '    }\n', '    function _hatchEggs(address ref) private{\n', '        require(initialized);\n', '\n', '        uint256 eggsUsed=getMyEggs();\n', '        uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);\n', '        hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);\n', '        totalHatcheryShrimp=totalHatcheryShrimp.add(newShrimp);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        hatchCooldown[msg.sender]=HATCH_COOLDOWN_MAX;\n', '        //send referral eggs\n', '        require(ref!=msg.sender);\n', '        if(ref!=0){\n', '          claimedEggs[ref]=claimedEggs[ref].add(eggsUsed.div(7));\n', '        }\n', '        //boost market to nerf shrimp hoarding\n', '        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,7));\n', '    }\n', '    function getHatchCooldown(uint eggs) public view returns(uint){\n', '      uint targetEggs=marketEggs.div(50);\n', '      if(eggs>=targetEggs){\n', '        return HATCH_COOLDOWN_MAX;\n', '      }\n', '      return (HATCH_COOLDOWN_MAX.mul(eggs)).div(targetEggs);\n', '    }\n', '    function reduceHatchCooldown(address addr,uint eggs) private{\n', '      uint reduction=getHatchCooldown(eggs);\n', '      if(reduction>=hatchCooldown[addr]){\n', '        hatchCooldown[addr]=0;\n', '      }\n', '      else{\n', '        hatchCooldown[addr]=hatchCooldown[addr].sub(reduction);\n', '      }\n', '    }\n', '    function sellEggs() public{\n', '        require(initialized);\n', '        finalizeIfNecessary();\n', '        uint256 hasEggs=getMyEggs();\n', '        uint256 eggValue=calculateEggSell(hasEggs);\n', '        //uint256 fee=devFee(eggValue);\n', '        uint potfee=potFee(eggValue);\n', '        claimedEggs[msg.sender]=0;\n', '        lastHatch[msg.sender]=now;\n', '        marketEggs=SafeMath.add(marketEggs,hasEggs);\n', '        //ceoAddress.transfer(fee);\n', '        prizeEth=prizeEth.add(potfee);\n', '        msg.sender.transfer(eggValue.sub(potfee));\n', '    }\n', '    function buyEggs() public payable{\n', '        require(initialized);\n', '        uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));\n', '        eggsBought=eggsBought.sub(devFee(eggsBought));\n', '        eggsBought=eggsBought.sub(devFee2(eggsBought));\n', '        ceoAddress.transfer(devFee(msg.value));\n', '        dev2.transfer(devFee2(msg.value));\n', '        claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);\n', '        reduceHatchCooldown(msg.sender,eggsBought); //reduce the hatching cooldown based on eggs bought\n', '\n', '        //steal the pot if bought enough\n', '        uint potEggCost=getPotCost().mul(EGGS_TO_HATCH_1SHRIMP);//the equivalent number of eggs to the pot cost in shrimp\n', '        if(eggsBought>potEggCost){\n', '          //hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].add(getPotCost());//to compensate for the shrimp that will be lost when calling the following\n', '          //stealPot();\n', '          setNewPotWinner();\n', '        }\n', '    }\n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));\n', '    }\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256){\n', '        return calculateTrade(eggs,marketEggs,this.balance.sub(prizeEth));\n', '    }\n', '    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){\n', '        return calculateTrade(eth,contractBalance.sub(prizeEth),marketEggs);\n', '    }\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256){\n', '        return calculateEggBuy(eth,this.balance);\n', '    }\n', '    function potFee(uint amount) public view returns(uint){\n', '        return SafeMath.div(SafeMath.mul(amount,20),100);\n', '    }\n', '    function devFee(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount,4),100);\n', '    }\n', '    function devFee2(uint256 amount) public view returns(uint256){\n', '        return SafeMath.div(amount,100);\n', '    }\n', '    function seedMarket(uint256 eggs) public payable{\n', '        require(msg.sender==ceoAddress);\n', '        require(!initialized);\n', '        //require(marketEggs==0);\n', '        initialized=true;\n', '        marketEggs=eggs;\n', '        lastBidTime=now;\n', '    }\n', '    //Tokens are exchanged for shrimp by sending them to this contract with ApproveAndCall\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public{\n', '        require(!initialized);\n', '        require(msg.sender==vrfAddress);\n', '        require(ethVerify.verifiedUsers(from));//you must now be verified for this\n', '        require(claimedEggs[from].add(tokens.div(VRF_EGG_COST))<=1001*EGGS_TO_HATCH_1SHRIMP);//you may now trade for a max of 1000 eggs\n', '        vrfcontract.transferFrom(from,this,tokens);\n', '        claimedEggs[from]=claimedEggs[from].add(tokens.div(VRF_EGG_COST));\n', '    }\n', '    //allow sending eth to the contract\n', '    function () public payable {}\n', '\n', '    function claimFreeEggs() public{\n', '//  RE ENABLE THIS BEFORE DEPLOYING MAINNET\n', '        require(ethVerify.verifiedUsers(msg.sender));\n', '        require(initialized);\n', '        require(!hasClaimedFree[msg.sender]);\n', '        claimedEggs[msg.sender]=claimedEggs[msg.sender].add(getFreeEggs());\n', '        _hatchEggs(0);\n', '        hatchCooldown[msg.sender]=0;\n', '        hasClaimedFree[msg.sender]=true;\n', '        //require(hatcheryShrimp[msg.sender]==0);\n', '        //lastHatch[msg.sender]=now;\n', '        //hatcheryShrimp[msg.sender]=hatcheryShrimp[msg.sender].add(STARTING_SHRIMP);\n', '    }\n', '    function getFreeEggs() public view returns(uint){\n', '        return min(calculateEggBuySimple(this.balance.div(400)),calculateEggBuySimple(0.01 ether));\n', '    }\n', '    function getBalance() public view returns(uint256){\n', '        return this.balance;\n', '    }\n', '    function getMyShrimp() public view returns(uint256){\n', '        return hatcheryShrimp[msg.sender];\n', '    }\n', '    function getMyEggs() public view returns(uint256){\n', '        return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));\n', '    }\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256){\n', '        uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);\n', '    }\n', '    function min(uint256 a, uint256 b) private pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
