['/**\n', ' *  Crowdsale for 0+1 Tokens.\n', ' *\n', ' *  Based on OpenZeppelin framework.\n', ' *  https://openzeppelin.org\n', ' *\n', ' *  Author: Eversystem Inc.\n', ' **/\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * Safe Math library from OpenZeppelin framework\n', ' * https://openzeppelin.org\n', ' *\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title 0+1 Crowdsale phase 1\n', '1519056000\n', '1521129600\n', '1522512000\n', '1523808000\n', '\n', '1525104000\n', '1526400000\n', '1527782400\n', '1529078400\n', '\n', '1530374400\n', '1531670400\n', '1533052800\n', '1534348800\n', ' */\n', 'contract ZpoCrowdsaleA {\n', '    using SafeMath for uint256;\n', '\n', '    // Funding goal and soft cap\n', '    uint256 public constant HARD_CAP = 2000000000 * (10 ** 18);\n', '\n', '    // Cap for each term periods\n', '    uint256 public constant ICO_CAP = 7000;\n', '\n', '    // Number of stages\n', '    uint256 public constant NUM_STAGES = 4;\n', '\n', '    uint256 public constant ICO_START1 = 1518689400;\n', '    uint256 public constant ICO_START2 = ICO_START1 + 300 seconds;\n', '    uint256 public constant ICO_START3 = ICO_START2 + 300 seconds;\n', '    uint256 public constant ICO_START4 = ICO_START3 + 300 seconds;\n', '    uint256 public constant ICO_END = ICO_START4 + 300 seconds;\n', '\n', '    /*\n', '    // 2018/02/20 - 2018/03/15\n', '    uint256 public constant ICO_START1 = 1519056000;\n', '    // 2018/03/16 - 2018/03/31\n', '    uint256 public constant ICO_START2 = 1521129600;\n', '    // 2018/04/01 - 2018/04/15\n', '    uint256 public constant ICO_START3 = 1522512000;\n', '    // 2018/04/16 - 2018/04/30\n', '    uint256 public constant ICO_START4 = 1523808000;\n', '    // 2018/04/16 - 2018/04/30\n', '    uint256 public constant ICO_END = 152510399;\n', '    */\n', '\n', '    // Exchange rate for each term periods\n', '    uint256 public constant ICO_RATE1 = 20000 * (10 ** 18);\n', '    uint256 public constant ICO_RATE2 = 18000 * (10 ** 18);\n', '    uint256 public constant ICO_RATE3 = 17000 * (10 ** 18);\n', '    uint256 public constant ICO_RATE4 = 16000 * (10 ** 18);\n', '\n', '    // Exchange rate for each term periods\n', '    uint256 public constant ICO_CAP1 = 14000;\n', '    uint256 public constant ICO_CAP2 = 21000;\n', '    uint256 public constant ICO_CAP3 = 28000;\n', '    uint256 public constant ICO_CAP4 = 35000;\n', '\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // The token being sold\n', '    ERC20 public tokenReward;\n', '\n', '    // Tokens will be transfered from this address\n', '    address public tokenOwner;\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // Stage of ICO\n', '    uint256 public stage = 0;\n', '\n', '    // Amount of tokens sold\n', '    uint256 public tokensSold = 0;\n', '\n', '    // Amount of raised money in wei\n', '    uint256 public weiRaised = 0;\n', '\n', '    /**\n', '     * Event for token purchase logging\n', '     *\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    event IcoStageStarted(uint256 stage);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function ZpoCrowdsaleA(address _tokenAddress, address _wallet) public {\n', '        require(_tokenAddress != address(0));\n', '        require(_wallet != address(0));\n', '\n', '        owner = msg.sender;\n', '        tokenOwner = msg.sender;\n', '        wallet = _wallet;\n', '\n', '        tokenReward = ERC20(_tokenAddress);\n', '\n', '        stage = 0;\n', '    }\n', '\n', '    // Fallback function can be used to buy tokens\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // Low level token purchase function\n', '    function buyTokens(address _beneficiary) public payable {\n', '        require(_beneficiary != address(0));\n', '        require(stage <= NUM_STAGES);\n', '        require(validPurchase());\n', '        require(now <= ICO_END);\n', '        require(weiRaised < ICO_CAP4);\n', '        require(msg.value >= (10 ** 17));\n', '        require(msg.value <= (1000 ** 18));\n', '\n', '        determineCurrentStage();\n', '        require(stage >= 1 && stage <= NUM_STAGES);\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = getTokenAmount(weiAmount);\n', '        require(tokens > 0);\n', '\n', '        // Update totals\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokensSold = tokensSold.add(tokens);\n', '\n', '        assert(tokenReward.transferFrom(tokenOwner, _beneficiary, tokens));\n', '        TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '        forwardFunds();\n', '    }\n', '\n', '    // Send ether to the fund collection wallet\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    function determineCurrentStage() internal {\n', '        uint256 prevStage = stage;\n', '        checkCap();\n', '\n', '        if (stage < 4 && now >= ICO_START4) {\n', '            stage = 4;\n', '            checkNewPeriod(prevStage);\n', '            return;\n', '        }\n', '        if (stage < 3 && now >= ICO_START3) {\n', '            stage = 3;\n', '            checkNewPeriod(prevStage);\n', '            return;\n', '        }\n', '        if (stage < 2 && now >= ICO_START2) {\n', '            stage = 2;\n', '            checkNewPeriod(prevStage);\n', '            return;\n', '        }\n', '        if (stage < 1 && now >= ICO_START1) {\n', '            stage = 1;\n', '            checkNewPeriod(prevStage);\n', '            return;\n', '        }\n', '    }\n', '\n', '    function checkCap() internal {\n', '        if (weiRaised >= ICO_CAP3) {\n', '            stage = 4;\n', '        }\n', '        else if (weiRaised >= ICO_CAP2) {\n', '            stage = 3;\n', '        }\n', '        else if (weiRaised >= ICO_CAP1) {\n', '            stage = 2;\n', '        }\n', '    }\n', '\n', '    function checkNewPeriod(uint256 _prevStage) internal {\n', '        if (stage != _prevStage) {\n', '            IcoStageStarted(stage);\n', '        }\n', '    }\n', '\n', '    function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        uint256 rate = 0;\n', '\n', '        if (stage == 1) {\n', '            rate = ICO_RATE1;\n', '        } else if (stage == 2) {\n', '            rate = ICO_RATE2;\n', '        } else if (stage == 3) {\n', '            rate = ICO_RATE3;\n', '        } else if (stage == 4) {\n', '            rate = ICO_RATE4;\n', '        }\n', '\n', '        return rate.mul(_weiAmount);\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase() internal view returns (bool) {\n', '        bool withinPeriod = now >= ICO_START1 && now <= ICO_END;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '\n', '        return withinPeriod && nonZeroPurchase;\n', '    }\n', '}']