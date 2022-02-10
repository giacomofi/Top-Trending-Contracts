['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract TempusToken {\n', '\n', '    function mint(address receiver, uint256 amount) public returns (bool success);\n', '\n', '}\n', '\n', 'contract TempusIco is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '//    uint public startTime = 1519894800; //1 March 2018 09:00:00 GMT\n', '    uint public startTime = 1519635600; //26 Feb 2018 09:00:00 GMT\n', '\n', '    //initial token price\n', '    uint public price0 = 0.005 ether / 1000;\n', '    uint public price1 = price0 * 2;\n', '    uint public price2 = price1 * 2;\n', '    uint public price3 = price2 * 2;\n', '    uint public price4 = price3 * 2;\n', '\n', '    //max tokens could be sold during ico\n', '    uint public hardCap = 1000000000 * 1000;\n', '    uint public tokensSold = 0;\n', '    uint[5] public tokensSoldInPeriod;\n', '\n', '    uint public periodDuration = 30 days;\n', '\n', '    uint public period0End = startTime + periodDuration;\n', '    uint public period1End = period0End + periodDuration;\n', '    uint public period2End = period1End + periodDuration;\n', '    uint public period3End = period2End + periodDuration;\n', '\n', '    bool public paused = false;\n', '\n', '    address withdrawAddress1;\n', '    address withdrawAddress2;\n', '\n', '    TempusToken token;\n', '\n', '    mapping(address => bool) public sellers;\n', '\n', '    modifier onlySellers() {\n', '        require(sellers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function TempusIco (address tokenAddress, address _withdrawAddress1,\n', '    address _withdrawAddress2) public {\n', '        token = TempusToken(tokenAddress);\n', '        withdrawAddress1 = _withdrawAddress1;\n', '        withdrawAddress2 = _withdrawAddress2;\n', '    }\n', '\n', '    function periodByDate() public view returns (uint periodNum) {\n', '        if(now < period0End) {\n', '            return 0;\n', '        }\n', '        if(now < period1End) {\n', '            return 1;\n', '        }\n', '        if(now < period2End) {\n', '            return 2;\n', '        }\n', '        if(now < period3End) {\n', '            return 3;\n', '        }\n', '        return 4;\n', '    }\n', '\n', '    function priceByPeriod() public view returns (uint price) {\n', '        uint periodNum = periodByDate();\n', '        if(periodNum == 0) {\n', '            return price0;\n', '        }\n', '        if(periodNum == 1) {\n', '            return price1;\n', '        }\n', '        if(periodNum == 2) {\n', '            return price2;\n', '        }\n', '        if(periodNum == 3) {\n', '            return price3;\n', '        }\n', '        return price4;\n', '    }\n', '\n', '    /**\n', '    * @dev Function that indicates whether pre ico is active or not\n', '    */\n', '    function isActive() public view returns (bool active) {\n', '        bool withinPeriod = now >= startTime;\n', '        bool capIsNotMet = tokensSold < hardCap;\n', '        return capIsNotMet && withinPeriod && !paused;\n', '    }\n', '\n', '    function() external payable {\n', '        buyFor(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev Low-level purchase function. Purchases tokens for specified address\n', '    * @param beneficiary Address that will get tokens\n', '    */\n', '    function buyFor(address beneficiary) public payable {\n', '        require(msg.value != 0);\n', '        uint amount = msg.value;\n', '        require(amount >= 0.1 ether);\n', '        uint price = priceByPeriod();\n', '        uint tokenAmount = amount.div(price);\n', '        makePurchase(beneficiary, tokenAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Function that is called by our robot to allow users\n', '    * to buy tonkens for various cryptos.\n', '    * @param beneficiary An address that will get tokens\n', '    * @param amount Amount of tokens that address will get\n', '    */\n', '    function externalPurchase(address beneficiary, uint amount) external onlySellers {\n', '        makePurchase(beneficiary, amount);\n', '    }\n', '\n', '    function makePurchase(address beneficiary, uint amount) private {\n', '        require(beneficiary != 0x0);\n', '        require(isActive());\n', '        uint minimumTokens = 1000;\n', '        if(tokensSold < hardCap.sub(minimumTokens)) {\n', '            require(amount >= minimumTokens);\n', '        }\n', '        require(amount.add(tokensSold) <= hardCap);\n', '        tokensSold = tokensSold.add(amount);\n', '        token.mint(beneficiary, amount);\n', '        updatePeriodStat(amount);\n', '    }\n', '\n', '    function updatePeriodStat(uint amount) private {\n', '        uint periodNum = periodByDate();\n', '        tokensSoldInPeriod[periodNum] = tokensSoldInPeriod[periodNum] + amount;\n', '        if(periodNum == 5) {\n', '            return;\n', '        }\n', '        uint amountOnStart = hardCap - tokensSold + tokensSoldInPeriod[periodNum];\n', '        uint percentSold = (tokensSoldInPeriod[periodNum] * 100) / amountOnStart;\n', '        if(percentSold >= 20) {\n', '            resetPeriodDates(periodNum);\n', '        }\n', '    }\n', '\n', '    function resetPeriodDates(uint periodNum) private {\n', '        if(periodNum == 0) {\n', '            period0End = now;\n', '            period1End = period0End + periodDuration;\n', '            period2End = period1End + periodDuration;\n', '            period3End = period2End + periodDuration;\n', '            return;\n', '        }\n', '        if(periodNum == 1) {\n', '            period1End = now;\n', '            period2End = period1End + periodDuration;\n', '            period3End = period2End + periodDuration;\n', '            return;\n', '        }\n', '        if(periodNum == 2) {\n', '            period2End = now;\n', '            period3End = period2End + periodDuration;\n', '            return;\n', '        }\n', '        if(periodNum == 3) {\n', '            period3End = now;\n', '            return;\n', '        }\n', '    }\n', '\n', '    function setPaused(bool isPaused) external onlyOwner {\n', '        paused = isPaused;\n', '    }\n', '\n', '    /**\n', '    * @dev Sets address of seller robot\n', '    * @param seller Address of seller robot to set\n', '    * @param isSeller Parameter whether set as seller or not\n', '    */\n', '    function setAsSeller(address seller, bool isSeller) external onlyOwner {\n', '        sellers[seller] = isSeller;\n', '    }\n', '\n', '    /**\n', '    * @dev Set start time of ICO\n', '    * @param _startTime Start of ICO (unix time)\n', '    */\n', '    function setStartTime(uint _startTime) external onlyOwner {\n', '        startTime = _startTime;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to get ether from contract\n', '    * @param amount Amount in wei to withdraw\n', '    */\n', '    function withdrawEther(uint amount) external onlyOwner {\n', '        withdrawAddress1.transfer(amount / 2);\n', '        withdrawAddress2.transfer(amount / 2);\n', '    }\n', '}']