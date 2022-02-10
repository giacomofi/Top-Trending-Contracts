['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract LionCup is Pausable {\n', '    // total eggs one bat can produce per day\n', '    uint256 public EGGS_TO_HATCH_1BAT = 86400;\n', '    // how much bat for newbie user\n', '    uint256 public STARTING_BAT = 500;\n', '    uint256 PSN = 10000;\n', '    uint256 PSNH = 5000;\n', '    mapping(address => uint256) public hatcheryBat;\n', '    mapping(address => uint256) public claimedEggs;\n', '    mapping(address => uint256) public lastHatch;\n', '    mapping(address => address) public referrals;\n', '    uint256 public batlordReq = 500000; // starts at 500k bat\n', '    address public batlordAddress;\n', '    \n', '\n', '    // total eggs in market\n', '    uint256 public marketEggs;\n', '    \n', '    constructor() public{\n', '        paused = false;\n', '        batlordAddress = msg.sender;\n', '    }\n', '\n', '    function becomeBatlord() public whenNotPaused {\n', '        require(msg.sender != batlordAddress);\n', '        require(hatcheryBat[msg.sender] >= batlordReq);\n', '\n', '        hatcheryBat[msg.sender] = SafeMath.sub(hatcheryBat[msg.sender], batlordReq);\n', '        batlordReq = hatcheryBat[msg.sender]; // the requirement now becomes the balance at that time\n', '        batlordAddress = msg.sender;\n', '    }\n', '\n', '    function getBatlordReq() public view returns(uint256) {\n', '        return batlordReq;\n', '    } \n', '\n', '    function withdraw(uint256 _percent) public onlyOwner {\n', '        require(_percent>0&&_percent<=100);\n', '        uint256 val = SafeMath.div(SafeMath.mul(address(this).balance,_percent), 100);\n', '        if (val>0){\n', '          owner.transfer(val);\n', '        }\n', '    }\n', '\n', '    // hatch eggs into bats\n', '    function hatchEggs(address ref) public whenNotPaused {\n', "        // set user's referral only if which is empty\n", '        if (referrals[msg.sender] == address(0) && referrals[msg.sender] != msg.sender) {\n', '            referrals[msg.sender] = ref;\n', '        }\n', '        uint256 eggsUsed = getMyEggs();\n', '        uint256 newBat = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1BAT);\n', '        hatcheryBat[msg.sender] = SafeMath.add(hatcheryBat[msg.sender], newBat);\n', '        claimedEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender] = now;\n', '\n', '        //send referral eggs 20% of user\n', '        claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]], SafeMath.div(eggsUsed, 5));\n', '\n', '        //boost market to nerf bat hoarding\n', '        // add 10% of user into market\n', '        marketEggs = SafeMath.add(marketEggs, SafeMath.div(eggsUsed, 10));\n', '    }\n', '\n', '    // sell eggs for eth\n', '    function sellEggs() public whenNotPaused {\n', '        uint256 hasEggs = getMyEggs();\n', '        uint256 eggValue = calculateEggSell(hasEggs);\n', '        uint256 fee = devFee(eggValue);\n', "        // kill one third of the owner's snails on egg sale\n", '        hatcheryBat[msg.sender] = SafeMath.mul(SafeMath.div(hatcheryBat[msg.sender], 3), 2);\n', '        claimedEggs[msg.sender] = 0;\n', '        lastHatch[msg.sender] = now;\n', '        marketEggs = SafeMath.add(marketEggs, hasEggs);\n', '        batlordAddress.transfer(fee);\n', '        msg.sender.transfer(SafeMath.sub(eggValue, fee));\n', '    }\n', '\n', '    function buyEggs() public payable whenNotPaused {\n', '        uint256 eggsBought = calculateEggBuy(msg.value, SafeMath.sub(address(this).balance, msg.value));\n', '        eggsBought = SafeMath.sub(eggsBought, devFee(eggsBought));\n', '        batlordAddress.transfer(devFee(msg.value));\n', '        claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggsBought);\n', '    }\n', '    //magic trade balancing algorithm\n', '    function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns(uint256) {\n', '        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));\n', '        return SafeMath.div(SafeMath.mul(PSN, bs), SafeMath.add(PSNH, SafeMath.div(SafeMath.add(SafeMath.mul(PSN, rs), SafeMath.mul(PSNH, rt)), rt)));\n', '    }\n', '\n', '    // eggs to eth\n', '    function calculateEggSell(uint256 eggs) public view returns(uint256) {\n', '        return calculateTrade(eggs, marketEggs, address(this).balance);\n', '    }\n', '\n', '    function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {\n', '        return calculateTrade(eth, contractBalance, marketEggs);\n', '    }\n', '\n', '    function calculateEggBuySimple(uint256 eth) public view returns(uint256) {\n', '        return calculateEggBuy(eth, address(this).balance);\n', '    }\n', '\n', '    // eggs amount to eth for developers: eggs*4/100\n', '    function devFee(uint256 amount) public pure returns(uint256) {\n', '        return SafeMath.div(SafeMath.mul(amount, 4), 100);\n', '    }\n', '\n', "    // add eggs when there's no more eggs\n", '    // 864000000 with 0.02 Ether\n', '    function seedMarket(uint256 eggs) public payable {\n', '        require(marketEggs == 0);\n', '        marketEggs = eggs;\n', '    }\n', '\n', '    function getFreeBat() public payable whenNotPaused {\n', '        require(msg.value == 0.01 ether);\n', '        require(hatcheryBat[msg.sender] == 0);\n', '        lastHatch[msg.sender] = now;\n', '        hatcheryBat[msg.sender] = STARTING_BAT;\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    function getBalance() public view returns(uint256) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getMyBat() public view returns(uint256) {\n', '        return hatcheryBat[msg.sender];\n', '    }\n', '\n', '    function getMyEggs() public view returns(uint256) {\n', '        return SafeMath.add(claimedEggs[msg.sender], getEggsSinceLastHatch(msg.sender));\n', '    }\n', '\n', '    function getEggsSinceLastHatch(address adr) public view returns(uint256) {\n', '        uint256 secondsPassed = min(EGGS_TO_HATCH_1BAT, SafeMath.sub(now, lastHatch[adr]));\n', '        return SafeMath.mul(secondsPassed, hatcheryBat[adr]);\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) private pure returns(uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}']