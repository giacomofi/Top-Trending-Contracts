['/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '    function issue(address _recipient, uint256 _value) returns (bool success) {}\n', '    function issueAtIco(address _recipient, uint256 _value, uint256 _icoNumber) returns (bool success) {}\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function unlock() returns (bool success) {}\n', '}\n', '\n', 'contract RICHCrowdsale {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Crowdsale addresses\n', '    address public creator; // Creator (1% funding)\n', '    address public buyBackFund; // Fund for buying back and burning (48% funding)\n', '    address public humanityFund; // Humanity fund (51% funding)\n', '\n', '    // Withdrawal rules\n', '    uint256 public creatorWithdraw = 0; // Current withdrawed\n', '    uint256 public maxCreatorWithdraw = 5 * 10 ** 3 * 10**18; // First 5.000 ETH\n', '    uint256 public percentageHumanityFund = 51; // Percentage goes to Humanity fund\n', '    uint256 public percentageBuyBackFund = 49; // Percentage goes to Buy-back fund\n', '\n', '    // Eth to token rate\n', '    uint256 public currentMarketRate = 400; // Current market price RICH/ETH. Will be updated before each ico\n', '    uint256 public maximumIcoRate = 330; // Maximum rate at wich will be issued RICH token\n', '    uint256 public minAcceptedEthAmount = 4 finney; // 0.004 ether\n', '\n', '    // ICOs specification\n', '    uint256 public maxTotalSupply = 1000000000 * 10**8; // 1 mlrd. tokens\n', '\n', '    mapping (uint256 => uint256) icoTokenIssued; // Issued in each ICO\n', '    uint256 public totalTokenIssued; // Total of issued tokens\n', '\n', '    uint256 public icoPeriod = 10 days;\n', '    uint256 public noIcoPeriod = 10 days;\n', '    uint256 public maxIssuedTokensPerIco = 10**6 * 10**8; // 1 mil.\n', '    uint256 public preIcoPeriod = 30 days;\n', '\n', '    uint256 public bonusPreIco = 50;\n', '    uint256 public bonusFirstIco = 30;\n', '    uint256 public bonusSecondIco = 10;\n', '\n', '    uint256 public bonusSubscription = 5;\n', '    mapping (address => uint256) subsriptionBonusTokensIssued;\n', '\n', '    // Balances\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint256) tokenBalances;\n', '    mapping (address => mapping (uint256 => uint256)) tokenBalancesPerIco;\n', '\n', '    enum Stages {\n', '        Countdown,\n', '        PreIco,\n', '        PriorityIco,\n', '        OpenIco,\n', '        Ico, // [PreIco, PriorityIco, OpenIco]\n', '        NoIco,\n', '        Ended\n', '    }\n', '\n', '    Stages public stage = Stages.Countdown;\n', '\n', '    // Crowdsale times\n', '    uint public start;\n', '    uint public preIcoStart;\n', '\n', '    // Rich token\n', '    Token public richToken;\n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     *\n', '     * @param _stage expected stage to test for\n', '     */\n', '    modifier atStage(Stages _stage) {\n', '        updateState();\n', '\n', '        if (stage != _stage && _stage != Stages.Ico) {\n', '            throw;\n', '        }\n', '\n', '        if (stage != Stages.PriorityIco && stage != Stages.OpenIco && stage != Stages.PreIco) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender is not creator\n', '     */\n', '    modifier onlyCreator() {\n', '        if (creator != msg.sender) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Get bonus for provided ICO number\n', '     *\n', '     * @param _currentIco current ico number\n', '     * @return percentage\n', '     */\n', '    function getPercentageBonusForIco(uint256 _currentIco) returns (uint256 percentage) {\n', '        updateState();\n', '\n', '        if (stage == Stages.PreIco) {\n', '            return bonusPreIco;\n', '        }\n', '\n', '        if (_currentIco == 1) {\n', '            return bonusFirstIco;\n', '        }\n', '\n', '        if (_currentIco == 2) {\n', '            return bonusSecondIco;\n', '        }\n', '\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * Get ethereum balance of `_investor`\n', '     *\n', '     * @param _investor The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _investor) constant returns (uint256 balance) {\n', '        return balances[_investor];\n', '    }\n', '\n', '    /**\n', '     * Construct\n', '     *\n', '     * @param _tokenAddress The address of the Rich token contact\n', '     * @param _creator Contract creator\n', '     * @param _start Start of the first ICO\n', '     * @param _preIcoStart Start of pre-ICO\n', '     */\n', '    function RICHCrowdsale(address _tokenAddress, address _creator, uint256 _start, uint256 _preIcoStart) {\n', '        richToken = Token(_tokenAddress);\n', '        creator = _creator;\n', '        start = _start;\n', '        preIcoStart = _preIcoStart;\n', '    }\n', '\n', '    /**\n', '     * Set current market rate ETH/RICH. Will be caled by creator before each ICO\n', '     *\n', '     * @param _currentMarketRate current ETH/RICH rate at the market\n', '     */\n', '    function setCurrentMarketRate(uint256 _currentMarketRate) onlyCreator returns (uint256) {\n', '        currentMarketRate = _currentMarketRate;\n', '    }\n', '\n', '    /**\n', '     * Set humanity fund address\n', '     *\n', '     * @param _humanityFund Humanity fund address\n', '     */\n', '    function setHumanityFund(address _humanityFund) onlyCreator {\n', '        humanityFund = _humanityFund;\n', '    }\n', '\n', '    /**\n', '     * Set buy back fund address\n', '     *\n', '     * @param _buyBackFund Bay back fund address\n', '     */\n', '    function setBuyBackFund(address _buyBackFund) onlyCreator {\n', '        buyBackFund = _buyBackFund;\n', '    }\n', '\n', '    /**\n', '     * Get current rate at which will be issued tokens\n', '     *\n', '     * @return rate How many tokens will be issued for one ETH\n', '     */\n', '    function getRate() returns (uint256 rate) {\n', '        if (currentMarketRate * 8 / 10 > maximumIcoRate) {\n', '            return maximumIcoRate;\n', '        }\n', '\n', '        return currentMarketRate * 8 / 10;\n', '    }\n', '\n', '    /**\n', '     * Retrun pecentage of tokens owned by provided investor\n', '     *\n', '     * @param _investor address of investor\n', '     * @param exeptInIco ICO number that will be excluded from calculation (usually current ICO number)\n', '     * @return investor rate, 1000000 = 100%\n', '     */\n', '    function getInvestorTokenPercentage(address _investor, uint256 exeptInIco) returns (uint256 percentage) {\n', '        uint256 deductionInvestor = 0;\n', '        uint256 deductionIco = 0;\n', '\n', '        if (exeptInIco >= 0) {\n', '            deductionInvestor = tokenBalancesPerIco[_investor][exeptInIco];\n', '            deductionIco = icoTokenIssued[exeptInIco];\n', '        }\n', '\n', '        if (totalTokenIssued - deductionIco == 0) {\n', '            return 0;\n', '        }\n', '\n', '        return 1000000 * (tokenBalances[_investor] - deductionInvestor) / (totalTokenIssued - deductionIco);\n', '    }\n', '\n', '    /**\n', '     * Convert `_wei` to an amount in RICH using\n', '     * the current rate\n', '     *\n', '     * @param _wei amount of wei to convert\n', '     * @return The amount in RICH\n', '     */\n', '    function toRICH(uint256 _wei) returns (uint256 amount) {\n', '        uint256 rate = getRate();\n', '\n', '        return _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals\n', '    }\n', '\n', '    /**\n', '     * Return ICO number (PreIco has index 0)\n', '     *\n', '     * @return ICO number\n', '     */\n', '    function getCurrentIcoNumber() returns (uint256 amount) {\n', '        uint256 timeBehind = now - start;\n', '        if (now < start) {\n', '            return 0;\n', '        }\n', '\n', '        return 1 + ((timeBehind - (timeBehind % (icoPeriod + noIcoPeriod))) / (icoPeriod + noIcoPeriod));\n', '    }\n', '\n', '    /**\n', '     * Update crowd sale stage based on current time and ICO periods\n', '     */\n', '    function updateState() {\n', '        uint256 timeBehind = now - start;\n', '        uint256 currentIcoNumber = getCurrentIcoNumber();\n', '\n', '        if (icoTokenIssued[currentIcoNumber] >= maxIssuedTokensPerIco) {\n', '            stage = Stages.NoIco;\n', '            return;\n', '        }\n', '\n', '        if (totalTokenIssued >= maxTotalSupply) {\n', '            stage = Stages.Ended;\n', '            return;\n', '        }\n', '\n', '        if (now >= preIcoStart && now <= preIcoStart + preIcoPeriod) {\n', '            stage = Stages.PreIco;\n', '            return;\n', '        }\n', '\n', '        if (now < start) {\n', '            stage = Stages.Countdown;\n', '            return;\n', '        }\n', '\n', '        uint256 timeFromIcoStart = timeBehind - (currentIcoNumber - 1) * (icoPeriod + noIcoPeriod);\n', '\n', '        if (timeFromIcoStart > icoPeriod) {\n', '            stage = Stages.NoIco;\n', '            return;\n', '        }\n', '\n', '        if (timeFromIcoStart > icoPeriod / 2) {\n', '            stage = Stages.OpenIco;\n', '            return;\n', '        }\n', '\n', '        stage = Stages.PriorityIco;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer appropriate percentage of raised amount to the company address and humanity and buy back fund\n', '     */\n', '    function withdraw() onlyCreator {\n', '        uint256 ethBalance = this.balance;\n', '        uint256 amountToSend = ethBalance - 100000000;\n', '\n', '        if (creatorWithdraw < maxCreatorWithdraw) {\n', '            if (amountToSend > maxCreatorWithdraw - creatorWithdraw) {\n', '                amountToSend = maxCreatorWithdraw - creatorWithdraw;\n', '            }\n', '\n', '            if (!creator.send(amountToSend)) {\n', '                throw;\n', '            }\n', '\n', '            creatorWithdraw += amountToSend;\n', '            return;\n', '        }\n', '\n', '        uint256 ethForHumanityFund = amountToSend * percentageHumanityFund / 100;\n', '        uint256 ethForBuyBackFund = amountToSend * percentageBuyBackFund / 100;\n', '\n', '        if (!humanityFund.send(ethForHumanityFund)) {\n', '            throw;\n', '        }\n', '\n', '        if (!buyBackFund.send(ethForBuyBackFund)) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Add additional bonus tokens for subscribed investors\n', '     *\n', '     * @param investorAddress Address of investor\n', '     */\n', '    function sendSubscriptionBonus(address investorAddress) onlyCreator {\n', '        uint256 subscriptionBonus = tokenBalances[investorAddress] * bonusSubscription / 100;\n', '\n', '        if (subsriptionBonusTokensIssued[investorAddress] < subscriptionBonus) {\n', '            uint256 toBeIssued = subscriptionBonus - subsriptionBonusTokensIssued[investorAddress];\n', '            if (!richToken.issue(investorAddress, toBeIssued)) {\n', '                throw;\n', '            }\n', '\n', '            subsriptionBonusTokensIssued[investorAddress] += toBeIssued;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Receives Eth and issue RICH tokens to the sender\n', '     */\n', '    function () payable atStage(Stages.Ico) {\n', '        uint256 receivedEth = msg.value;\n', '\n', '        if (receivedEth < minAcceptedEthAmount) {\n', '            throw;\n', '        }\n', '\n', '        uint256 tokensToBeIssued = toRICH(receivedEth);\n', '        uint256 currentIco = getCurrentIcoNumber();\n', '\n', '        //add bonus\n', '        tokensToBeIssued = tokensToBeIssued + (tokensToBeIssued * getPercentageBonusForIco(currentIco) / 100);\n', '\n', '        if (tokensToBeIssued == 0 || icoTokenIssued[currentIco] + tokensToBeIssued > maxIssuedTokensPerIco) {\n', '            throw;\n', '        }\n', '\n', '        if (stage == Stages.PriorityIco) {\n', '            uint256 alreadyBoughtInIco = tokenBalancesPerIco[msg.sender][currentIco];\n', '            uint256 canBuyTokensInThisIco = maxIssuedTokensPerIco * getInvestorTokenPercentage(msg.sender, currentIco) / 1000000;\n', '\n', '            if (tokensToBeIssued > canBuyTokensInThisIco - alreadyBoughtInIco) {\n', '                throw;\n', '            }\n', '        }\n', '\n', '        if (!richToken.issue(msg.sender, tokensToBeIssued)) {\n', '            throw;\n', '        }\n', '\n', '        icoTokenIssued[currentIco] += tokensToBeIssued;\n', '        totalTokenIssued += tokensToBeIssued;\n', '        balances[msg.sender] += receivedEth;\n', '        tokenBalances[msg.sender] += tokensToBeIssued;\n', '        tokenBalancesPerIco[msg.sender][currentIco] += tokensToBeIssued;\n', '    }\n', '}']
['/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '    function issue(address _recipient, uint256 _value) returns (bool success) {}\n', '    function issueAtIco(address _recipient, uint256 _value, uint256 _icoNumber) returns (bool success) {}\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function unlock() returns (bool success) {}\n', '}\n', '\n', 'contract RICHCrowdsale {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Crowdsale addresses\n', '    address public creator; // Creator (1% funding)\n', '    address public buyBackFund; // Fund for buying back and burning (48% funding)\n', '    address public humanityFund; // Humanity fund (51% funding)\n', '\n', '    // Withdrawal rules\n', '    uint256 public creatorWithdraw = 0; // Current withdrawed\n', '    uint256 public maxCreatorWithdraw = 5 * 10 ** 3 * 10**18; // First 5.000 ETH\n', '    uint256 public percentageHumanityFund = 51; // Percentage goes to Humanity fund\n', '    uint256 public percentageBuyBackFund = 49; // Percentage goes to Buy-back fund\n', '\n', '    // Eth to token rate\n', '    uint256 public currentMarketRate = 400; // Current market price RICH/ETH. Will be updated before each ico\n', '    uint256 public maximumIcoRate = 330; // Maximum rate at wich will be issued RICH token\n', '    uint256 public minAcceptedEthAmount = 4 finney; // 0.004 ether\n', '\n', '    // ICOs specification\n', '    uint256 public maxTotalSupply = 1000000000 * 10**8; // 1 mlrd. tokens\n', '\n', '    mapping (uint256 => uint256) icoTokenIssued; // Issued in each ICO\n', '    uint256 public totalTokenIssued; // Total of issued tokens\n', '\n', '    uint256 public icoPeriod = 10 days;\n', '    uint256 public noIcoPeriod = 10 days;\n', '    uint256 public maxIssuedTokensPerIco = 10**6 * 10**8; // 1 mil.\n', '    uint256 public preIcoPeriod = 30 days;\n', '\n', '    uint256 public bonusPreIco = 50;\n', '    uint256 public bonusFirstIco = 30;\n', '    uint256 public bonusSecondIco = 10;\n', '\n', '    uint256 public bonusSubscription = 5;\n', '    mapping (address => uint256) subsriptionBonusTokensIssued;\n', '\n', '    // Balances\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint256) tokenBalances;\n', '    mapping (address => mapping (uint256 => uint256)) tokenBalancesPerIco;\n', '\n', '    enum Stages {\n', '        Countdown,\n', '        PreIco,\n', '        PriorityIco,\n', '        OpenIco,\n', '        Ico, // [PreIco, PriorityIco, OpenIco]\n', '        NoIco,\n', '        Ended\n', '    }\n', '\n', '    Stages public stage = Stages.Countdown;\n', '\n', '    // Crowdsale times\n', '    uint public start;\n', '    uint public preIcoStart;\n', '\n', '    // Rich token\n', '    Token public richToken;\n', '\n', '    /**\n', '     * Throw if at stage other than current stage\n', '     *\n', '     * @param _stage expected stage to test for\n', '     */\n', '    modifier atStage(Stages _stage) {\n', '        updateState();\n', '\n', '        if (stage != _stage && _stage != Stages.Ico) {\n', '            throw;\n', '        }\n', '\n', '        if (stage != Stages.PriorityIco && stage != Stages.OpenIco && stage != Stages.PreIco) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Throw if sender is not creator\n', '     */\n', '    modifier onlyCreator() {\n', '        if (creator != msg.sender) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Get bonus for provided ICO number\n', '     *\n', '     * @param _currentIco current ico number\n', '     * @return percentage\n', '     */\n', '    function getPercentageBonusForIco(uint256 _currentIco) returns (uint256 percentage) {\n', '        updateState();\n', '\n', '        if (stage == Stages.PreIco) {\n', '            return bonusPreIco;\n', '        }\n', '\n', '        if (_currentIco == 1) {\n', '            return bonusFirstIco;\n', '        }\n', '\n', '        if (_currentIco == 2) {\n', '            return bonusSecondIco;\n', '        }\n', '\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * Get ethereum balance of `_investor`\n', '     *\n', '     * @param _investor The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _investor) constant returns (uint256 balance) {\n', '        return balances[_investor];\n', '    }\n', '\n', '    /**\n', '     * Construct\n', '     *\n', '     * @param _tokenAddress The address of the Rich token contact\n', '     * @param _creator Contract creator\n', '     * @param _start Start of the first ICO\n', '     * @param _preIcoStart Start of pre-ICO\n', '     */\n', '    function RICHCrowdsale(address _tokenAddress, address _creator, uint256 _start, uint256 _preIcoStart) {\n', '        richToken = Token(_tokenAddress);\n', '        creator = _creator;\n', '        start = _start;\n', '        preIcoStart = _preIcoStart;\n', '    }\n', '\n', '    /**\n', '     * Set current market rate ETH/RICH. Will be caled by creator before each ICO\n', '     *\n', '     * @param _currentMarketRate current ETH/RICH rate at the market\n', '     */\n', '    function setCurrentMarketRate(uint256 _currentMarketRate) onlyCreator returns (uint256) {\n', '        currentMarketRate = _currentMarketRate;\n', '    }\n', '\n', '    /**\n', '     * Set humanity fund address\n', '     *\n', '     * @param _humanityFund Humanity fund address\n', '     */\n', '    function setHumanityFund(address _humanityFund) onlyCreator {\n', '        humanityFund = _humanityFund;\n', '    }\n', '\n', '    /**\n', '     * Set buy back fund address\n', '     *\n', '     * @param _buyBackFund Bay back fund address\n', '     */\n', '    function setBuyBackFund(address _buyBackFund) onlyCreator {\n', '        buyBackFund = _buyBackFund;\n', '    }\n', '\n', '    /**\n', '     * Get current rate at which will be issued tokens\n', '     *\n', '     * @return rate How many tokens will be issued for one ETH\n', '     */\n', '    function getRate() returns (uint256 rate) {\n', '        if (currentMarketRate * 8 / 10 > maximumIcoRate) {\n', '            return maximumIcoRate;\n', '        }\n', '\n', '        return currentMarketRate * 8 / 10;\n', '    }\n', '\n', '    /**\n', '     * Retrun pecentage of tokens owned by provided investor\n', '     *\n', '     * @param _investor address of investor\n', '     * @param exeptInIco ICO number that will be excluded from calculation (usually current ICO number)\n', '     * @return investor rate, 1000000 = 100%\n', '     */\n', '    function getInvestorTokenPercentage(address _investor, uint256 exeptInIco) returns (uint256 percentage) {\n', '        uint256 deductionInvestor = 0;\n', '        uint256 deductionIco = 0;\n', '\n', '        if (exeptInIco >= 0) {\n', '            deductionInvestor = tokenBalancesPerIco[_investor][exeptInIco];\n', '            deductionIco = icoTokenIssued[exeptInIco];\n', '        }\n', '\n', '        if (totalTokenIssued - deductionIco == 0) {\n', '            return 0;\n', '        }\n', '\n', '        return 1000000 * (tokenBalances[_investor] - deductionInvestor) / (totalTokenIssued - deductionIco);\n', '    }\n', '\n', '    /**\n', '     * Convert `_wei` to an amount in RICH using\n', '     * the current rate\n', '     *\n', '     * @param _wei amount of wei to convert\n', '     * @return The amount in RICH\n', '     */\n', '    function toRICH(uint256 _wei) returns (uint256 amount) {\n', '        uint256 rate = getRate();\n', '\n', '        return _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals\n', '    }\n', '\n', '    /**\n', '     * Return ICO number (PreIco has index 0)\n', '     *\n', '     * @return ICO number\n', '     */\n', '    function getCurrentIcoNumber() returns (uint256 amount) {\n', '        uint256 timeBehind = now - start;\n', '        if (now < start) {\n', '            return 0;\n', '        }\n', '\n', '        return 1 + ((timeBehind - (timeBehind % (icoPeriod + noIcoPeriod))) / (icoPeriod + noIcoPeriod));\n', '    }\n', '\n', '    /**\n', '     * Update crowd sale stage based on current time and ICO periods\n', '     */\n', '    function updateState() {\n', '        uint256 timeBehind = now - start;\n', '        uint256 currentIcoNumber = getCurrentIcoNumber();\n', '\n', '        if (icoTokenIssued[currentIcoNumber] >= maxIssuedTokensPerIco) {\n', '            stage = Stages.NoIco;\n', '            return;\n', '        }\n', '\n', '        if (totalTokenIssued >= maxTotalSupply) {\n', '            stage = Stages.Ended;\n', '            return;\n', '        }\n', '\n', '        if (now >= preIcoStart && now <= preIcoStart + preIcoPeriod) {\n', '            stage = Stages.PreIco;\n', '            return;\n', '        }\n', '\n', '        if (now < start) {\n', '            stage = Stages.Countdown;\n', '            return;\n', '        }\n', '\n', '        uint256 timeFromIcoStart = timeBehind - (currentIcoNumber - 1) * (icoPeriod + noIcoPeriod);\n', '\n', '        if (timeFromIcoStart > icoPeriod) {\n', '            stage = Stages.NoIco;\n', '            return;\n', '        }\n', '\n', '        if (timeFromIcoStart > icoPeriod / 2) {\n', '            stage = Stages.OpenIco;\n', '            return;\n', '        }\n', '\n', '        stage = Stages.PriorityIco;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer appropriate percentage of raised amount to the company address and humanity and buy back fund\n', '     */\n', '    function withdraw() onlyCreator {\n', '        uint256 ethBalance = this.balance;\n', '        uint256 amountToSend = ethBalance - 100000000;\n', '\n', '        if (creatorWithdraw < maxCreatorWithdraw) {\n', '            if (amountToSend > maxCreatorWithdraw - creatorWithdraw) {\n', '                amountToSend = maxCreatorWithdraw - creatorWithdraw;\n', '            }\n', '\n', '            if (!creator.send(amountToSend)) {\n', '                throw;\n', '            }\n', '\n', '            creatorWithdraw += amountToSend;\n', '            return;\n', '        }\n', '\n', '        uint256 ethForHumanityFund = amountToSend * percentageHumanityFund / 100;\n', '        uint256 ethForBuyBackFund = amountToSend * percentageBuyBackFund / 100;\n', '\n', '        if (!humanityFund.send(ethForHumanityFund)) {\n', '            throw;\n', '        }\n', '\n', '        if (!buyBackFund.send(ethForBuyBackFund)) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Add additional bonus tokens for subscribed investors\n', '     *\n', '     * @param investorAddress Address of investor\n', '     */\n', '    function sendSubscriptionBonus(address investorAddress) onlyCreator {\n', '        uint256 subscriptionBonus = tokenBalances[investorAddress] * bonusSubscription / 100;\n', '\n', '        if (subsriptionBonusTokensIssued[investorAddress] < subscriptionBonus) {\n', '            uint256 toBeIssued = subscriptionBonus - subsriptionBonusTokensIssued[investorAddress];\n', '            if (!richToken.issue(investorAddress, toBeIssued)) {\n', '                throw;\n', '            }\n', '\n', '            subsriptionBonusTokensIssued[investorAddress] += toBeIssued;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Receives Eth and issue RICH tokens to the sender\n', '     */\n', '    function () payable atStage(Stages.Ico) {\n', '        uint256 receivedEth = msg.value;\n', '\n', '        if (receivedEth < minAcceptedEthAmount) {\n', '            throw;\n', '        }\n', '\n', '        uint256 tokensToBeIssued = toRICH(receivedEth);\n', '        uint256 currentIco = getCurrentIcoNumber();\n', '\n', '        //add bonus\n', '        tokensToBeIssued = tokensToBeIssued + (tokensToBeIssued * getPercentageBonusForIco(currentIco) / 100);\n', '\n', '        if (tokensToBeIssued == 0 || icoTokenIssued[currentIco] + tokensToBeIssued > maxIssuedTokensPerIco) {\n', '            throw;\n', '        }\n', '\n', '        if (stage == Stages.PriorityIco) {\n', '            uint256 alreadyBoughtInIco = tokenBalancesPerIco[msg.sender][currentIco];\n', '            uint256 canBuyTokensInThisIco = maxIssuedTokensPerIco * getInvestorTokenPercentage(msg.sender, currentIco) / 1000000;\n', '\n', '            if (tokensToBeIssued > canBuyTokensInThisIco - alreadyBoughtInIco) {\n', '                throw;\n', '            }\n', '        }\n', '\n', '        if (!richToken.issue(msg.sender, tokensToBeIssued)) {\n', '            throw;\n', '        }\n', '\n', '        icoTokenIssued[currentIco] += tokensToBeIssued;\n', '        totalTokenIssued += tokensToBeIssued;\n', '        balances[msg.sender] += receivedEth;\n', '        tokenBalances[msg.sender] += tokensToBeIssued;\n', '        tokenBalancesPerIco[msg.sender][currentIco] += tokensToBeIssued;\n', '    }\n', '}']
