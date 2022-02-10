['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'interface TokenInterface {\n', '     function totalSupply() external constant returns (uint);\n', '     function balanceOf(address tokenOwner) external constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) external returns (bool success);\n', '     function approve(address spender, uint tokens) external returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '     function burn(uint256 _value) external; \n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '     event Burn(address indexed burner, uint256 value);\n', '}\n', '\n', ' contract KRCICOContract is Ownable{\n', '  using SafeMath for uint256;\n', ' \n', '  // The token being sold\n', '  TokenInterface public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public ratePerWei; \n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  uint256 public TOKENS_SOLD;\n', '  \n', '  uint256 maxTokensToSale;\n', '  \n', '  uint256 bonusInPhase1;\n', '  uint256 bonusInPhase2;\n', '  uint256 bonusInPhase3;\n', '  \n', '  uint256 minimumContribution;\n', '  uint256 maximumContribution;\n', '  \n', '  bool isCrowdsalePaused = false;\n', '  \n', '  uint256 totalDurationInDays = 56 days;\n', '  \n', '  uint256 LongTermFoundationBudgetAccumulated;\n', '  uint256 LegalContingencyFundsAccumulated;\n', '  uint256 MarketingAndCommunityOutreachAccumulated;\n', '  uint256 CashReserveFundAccumulated;\n', '  uint256 OperationalExpensesAccumulated;\n', '  uint256 SoftwareProductDevelopmentAccumulated;\n', '  uint256 FoundersTeamAndAdvisorsAccumulated;\n', '  \n', '  uint256 LongTermFoundationBudgetPercentage;\n', '  uint256 LegalContingencyFundsPercentage;\n', '  uint256 MarketingAndCommunityOutreachPercentage;\n', '  uint256 CashReserveFundPercentage;\n', '  uint256 OperationalExpensesPercentage;\n', '  uint256 SoftwareProductDevelopmentPercentage;\n', '  uint256 FoundersTeamAndAdvisorsPercentage;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  constructor(uint256 _startTime, address _wallet, address _tokenAddress) public \n', '  {\n', '    require(_startTime >=now);\n', '    require(_wallet != 0x0);\n', '\n', '    startTime = _startTime;  \n', '    endTime = startTime + totalDurationInDays;\n', '    require(endTime >= startTime);\n', '   \n', '    owner = _wallet;\n', '    \n', '    maxTokensToSale = 157500000e18;\n', '    bonusInPhase1 = 20;\n', '    bonusInPhase2 = 15;\n', '    bonusInPhase3 = 10;\n', '    minimumContribution = 5e17;\n', '    maximumContribution = 150e18;\n', '    ratePerWei = 40e18;\n', '    token = TokenInterface(_tokenAddress);\n', '    \n', '    LongTermFoundationBudgetAccumulated = 0;\n', '    LegalContingencyFundsAccumulated = 0;\n', '    MarketingAndCommunityOutreachAccumulated = 0;\n', '    CashReserveFundAccumulated = 0;\n', '    OperationalExpensesAccumulated = 0;\n', '    SoftwareProductDevelopmentAccumulated = 0;\n', '    FoundersTeamAndAdvisorsAccumulated = 0;\n', '  \n', '    LongTermFoundationBudgetPercentage = 15;\n', '    LegalContingencyFundsPercentage = 10;\n', '    MarketingAndCommunityOutreachPercentage = 10;\n', '    CashReserveFundPercentage = 20;\n', '    OperationalExpensesPercentage = 10;\n', '    SoftwareProductDevelopmentPercentage = 15;\n', '    FoundersTeamAndAdvisorsPercentage = 20;\n', '  }\n', '  \n', '  \n', '   // fallback function can be used to buy tokens\n', '   function () public  payable {\n', '    buyTokens(msg.sender);\n', '    }\n', '    \n', '    function calculateTokens(uint value) internal view returns (uint256 tokens) \n', '    {\n', '        uint256 timeElapsed = now - startTime;\n', '        uint256 timeElapsedInDays = timeElapsed.div(1 days);\n', '        uint256 bonus = 0;\n', '        //Phase 1 (15 days)\n', '        if (timeElapsedInDays <15)\n', '        {\n', '            tokens = value.mul(ratePerWei);\n', '            bonus = tokens.mul(bonusInPhase1); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        //Phase 2 (15 days)\n', '        else if (timeElapsedInDays >=15 && timeElapsedInDays <30)\n', '        {\n', '            tokens = value.mul(ratePerWei);\n', '            bonus = tokens.mul(bonusInPhase2); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        //Phase 3 (15 days)\n', '        else if (timeElapsedInDays >=30 && timeElapsedInDays <45)\n', '        {\n', '            tokens = value.mul(ratePerWei);\n', '            bonus = tokens.mul(bonusInPhase3); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        else \n', '        {\n', '            bonus = 0;\n', '        }\n', '    }\n', '\n', '  // low level token purchase function\n', '  \n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(isCrowdsalePaused == false);\n', '    require(validPurchase());\n', '\n', '    \n', '    require(TOKENS_SOLD<maxTokensToSale);\n', '   \n', '    uint256 weiAmount = msg.value.div(10**16);\n', '    \n', '    uint256 tokens = calculateTokens(weiAmount);\n', '    require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);\n', '    // update state\n', '    weiRaised = weiRaised.add(msg.value);\n', '    \n', '    token.transfer(beneficiary,tokens);\n', '    emit TokenPurchase(owner, beneficiary, msg.value, tokens);\n', '    TOKENS_SOLD = TOKENS_SOLD.add(tokens);\n', '    distributeFunds();\n', '  }\n', '  \n', '  function distributeFunds() internal {\n', '      uint received = msg.value;\n', '      \n', '      LongTermFoundationBudgetAccumulated = LongTermFoundationBudgetAccumulated\n', '                                            .add(received.mul(LongTermFoundationBudgetPercentage)\n', '                                            .div(100));\n', '      \n', '      LegalContingencyFundsAccumulated = LegalContingencyFundsAccumulated\n', '                                         .add(received.mul(LegalContingencyFundsPercentage)\n', '                                         .div(100));\n', '      \n', '      MarketingAndCommunityOutreachAccumulated = MarketingAndCommunityOutreachAccumulated\n', '                                                 .add(received.mul(MarketingAndCommunityOutreachPercentage)\n', '                                                 .div(100));\n', '      \n', '      CashReserveFundAccumulated = CashReserveFundAccumulated\n', '                                   .add(received.mul(CashReserveFundPercentage)\n', '                                   .div(100));\n', '      \n', '      OperationalExpensesAccumulated = OperationalExpensesAccumulated\n', '                                       .add(received.mul(OperationalExpensesPercentage)\n', '                                       .div(100));\n', '      \n', '      SoftwareProductDevelopmentAccumulated = SoftwareProductDevelopmentAccumulated\n', '                                              .add(received.mul(SoftwareProductDevelopmentPercentage)\n', '                                              .div(100));\n', '      \n', '      FoundersTeamAndAdvisorsAccumulated = FoundersTeamAndAdvisorsAccumulated\n', '                                            .add(received.mul(FoundersTeamAndAdvisorsPercentage)\n', '                                            .div(100));\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    bool withinContributionLimit = msg.value >= minimumContribution && msg.value <= maximumContribution;\n', '    return withinPeriod && nonZeroPurchase && withinContributionLimit;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '  \n', '   /**\n', '    * function to change the end timestamp of the ico\n', '    * can only be called by owner wallet\n', '    **/\n', '    function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{\n', '        endTime = endTimeUnixTimestamp;\n', '    }\n', '    \n', '    /**\n', '    * function to change the start timestamp of the ico\n', '    * can only be called by owner wallet\n', '    **/\n', '    \n', '    function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{\n', '        startTime = startTimeUnixTimestamp;\n', '    }\n', '    \n', '     /**\n', '     * function to pause the crowdsale \n', '     * can only be called from owner wallet\n', '     **/\n', '     \n', '    function pauseCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = true;\n', '    }\n', '\n', '    /**\n', '     * function to resume the crowdsale if it is paused\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function resumeCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = false;\n', '    }\n', '     \n', '     function takeTokensBack() public onlyOwner\n', '     {\n', '         uint remainingTokensInTheContract = token.balanceOf(address(this));\n', '         token.transfer(owner,remainingTokensInTheContract);\n', '     }\n', '     \n', '    /**\n', '     * function to change the minimum contribution\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function changeMinimumContribution(uint256 minContribution) public onlyOwner {\n', '        minimumContribution = minContribution;\n', '    }\n', '    \n', '    /**\n', '     * function to change the maximum contribution\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function changeMaximumContribution(uint256 maxContribution) public onlyOwner {\n', '        maximumContribution = maxContribution;\n', '    }\n', '    \n', '    /**\n', '     * function to withdraw LongTermFoundationBudget funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/  \n', '    function withdrawLongTermFoundationBudget() public onlyOwner {\n', '        require(LongTermFoundationBudgetAccumulated > 0);\n', '        owner.transfer(LongTermFoundationBudgetAccumulated);\n', '        LongTermFoundationBudgetAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw LegalContingencyFunds funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '     \n', '    function withdrawLegalContingencyFunds() public onlyOwner {\n', '        require(LegalContingencyFundsAccumulated > 0);\n', '        owner.transfer(LegalContingencyFundsAccumulated);\n', '        LegalContingencyFundsAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw MarketingAndCommunityOutreach funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawMarketingAndCommunityOutreach() public onlyOwner {\n', '        require (MarketingAndCommunityOutreachAccumulated > 0);\n', '        owner.transfer(MarketingAndCommunityOutreachAccumulated);\n', '        MarketingAndCommunityOutreachAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw CashReserveFund funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawCashReserveFund() public onlyOwner {\n', '        require(CashReserveFundAccumulated > 0);\n', '        owner.transfer(CashReserveFundAccumulated);\n', '        CashReserveFundAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw OperationalExpenses funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawOperationalExpenses() public onlyOwner {\n', '        require(OperationalExpensesAccumulated > 0);\n', '        owner.transfer(OperationalExpensesAccumulated);\n', '        OperationalExpensesAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw SoftwareProductDevelopment funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawSoftwareProductDevelopment() public onlyOwner {\n', '        require (SoftwareProductDevelopmentAccumulated > 0);\n', '        owner.transfer(SoftwareProductDevelopmentAccumulated);\n', '        SoftwareProductDevelopmentAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw FoundersTeamAndAdvisors funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawFoundersTeamAndAdvisors() public onlyOwner {\n', '        require (FoundersTeamAndAdvisorsAccumulated > 0);\n', '        owner.transfer(FoundersTeamAndAdvisorsAccumulated);\n', '        FoundersTeamAndAdvisorsAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw all funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawAllFunds() public onlyOwner {\n', '        require (address(this).balance > 0);\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'interface TokenInterface {\n', '     function totalSupply() external constant returns (uint);\n', '     function balanceOf(address tokenOwner) external constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) external returns (bool success);\n', '     function approve(address spender, uint tokens) external returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '     function burn(uint256 _value) external; \n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '     event Burn(address indexed burner, uint256 value);\n', '}\n', '\n', ' contract KRCICOContract is Ownable{\n', '  using SafeMath for uint256;\n', ' \n', '  // The token being sold\n', '  TokenInterface public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public ratePerWei; \n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  uint256 public TOKENS_SOLD;\n', '  \n', '  uint256 maxTokensToSale;\n', '  \n', '  uint256 bonusInPhase1;\n', '  uint256 bonusInPhase2;\n', '  uint256 bonusInPhase3;\n', '  \n', '  uint256 minimumContribution;\n', '  uint256 maximumContribution;\n', '  \n', '  bool isCrowdsalePaused = false;\n', '  \n', '  uint256 totalDurationInDays = 56 days;\n', '  \n', '  uint256 LongTermFoundationBudgetAccumulated;\n', '  uint256 LegalContingencyFundsAccumulated;\n', '  uint256 MarketingAndCommunityOutreachAccumulated;\n', '  uint256 CashReserveFundAccumulated;\n', '  uint256 OperationalExpensesAccumulated;\n', '  uint256 SoftwareProductDevelopmentAccumulated;\n', '  uint256 FoundersTeamAndAdvisorsAccumulated;\n', '  \n', '  uint256 LongTermFoundationBudgetPercentage;\n', '  uint256 LegalContingencyFundsPercentage;\n', '  uint256 MarketingAndCommunityOutreachPercentage;\n', '  uint256 CashReserveFundPercentage;\n', '  uint256 OperationalExpensesPercentage;\n', '  uint256 SoftwareProductDevelopmentPercentage;\n', '  uint256 FoundersTeamAndAdvisorsPercentage;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  constructor(uint256 _startTime, address _wallet, address _tokenAddress) public \n', '  {\n', '    require(_startTime >=now);\n', '    require(_wallet != 0x0);\n', '\n', '    startTime = _startTime;  \n', '    endTime = startTime + totalDurationInDays;\n', '    require(endTime >= startTime);\n', '   \n', '    owner = _wallet;\n', '    \n', '    maxTokensToSale = 157500000e18;\n', '    bonusInPhase1 = 20;\n', '    bonusInPhase2 = 15;\n', '    bonusInPhase3 = 10;\n', '    minimumContribution = 5e17;\n', '    maximumContribution = 150e18;\n', '    ratePerWei = 40e18;\n', '    token = TokenInterface(_tokenAddress);\n', '    \n', '    LongTermFoundationBudgetAccumulated = 0;\n', '    LegalContingencyFundsAccumulated = 0;\n', '    MarketingAndCommunityOutreachAccumulated = 0;\n', '    CashReserveFundAccumulated = 0;\n', '    OperationalExpensesAccumulated = 0;\n', '    SoftwareProductDevelopmentAccumulated = 0;\n', '    FoundersTeamAndAdvisorsAccumulated = 0;\n', '  \n', '    LongTermFoundationBudgetPercentage = 15;\n', '    LegalContingencyFundsPercentage = 10;\n', '    MarketingAndCommunityOutreachPercentage = 10;\n', '    CashReserveFundPercentage = 20;\n', '    OperationalExpensesPercentage = 10;\n', '    SoftwareProductDevelopmentPercentage = 15;\n', '    FoundersTeamAndAdvisorsPercentage = 20;\n', '  }\n', '  \n', '  \n', '   // fallback function can be used to buy tokens\n', '   function () public  payable {\n', '    buyTokens(msg.sender);\n', '    }\n', '    \n', '    function calculateTokens(uint value) internal view returns (uint256 tokens) \n', '    {\n', '        uint256 timeElapsed = now - startTime;\n', '        uint256 timeElapsedInDays = timeElapsed.div(1 days);\n', '        uint256 bonus = 0;\n', '        //Phase 1 (15 days)\n', '        if (timeElapsedInDays <15)\n', '        {\n', '            tokens = value.mul(ratePerWei);\n', '            bonus = tokens.mul(bonusInPhase1); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        //Phase 2 (15 days)\n', '        else if (timeElapsedInDays >=15 && timeElapsedInDays <30)\n', '        {\n', '            tokens = value.mul(ratePerWei);\n', '            bonus = tokens.mul(bonusInPhase2); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        //Phase 3 (15 days)\n', '        else if (timeElapsedInDays >=30 && timeElapsedInDays <45)\n', '        {\n', '            tokens = value.mul(ratePerWei);\n', '            bonus = tokens.mul(bonusInPhase3); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        else \n', '        {\n', '            bonus = 0;\n', '        }\n', '    }\n', '\n', '  // low level token purchase function\n', '  \n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(isCrowdsalePaused == false);\n', '    require(validPurchase());\n', '\n', '    \n', '    require(TOKENS_SOLD<maxTokensToSale);\n', '   \n', '    uint256 weiAmount = msg.value.div(10**16);\n', '    \n', '    uint256 tokens = calculateTokens(weiAmount);\n', '    require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);\n', '    // update state\n', '    weiRaised = weiRaised.add(msg.value);\n', '    \n', '    token.transfer(beneficiary,tokens);\n', '    emit TokenPurchase(owner, beneficiary, msg.value, tokens);\n', '    TOKENS_SOLD = TOKENS_SOLD.add(tokens);\n', '    distributeFunds();\n', '  }\n', '  \n', '  function distributeFunds() internal {\n', '      uint received = msg.value;\n', '      \n', '      LongTermFoundationBudgetAccumulated = LongTermFoundationBudgetAccumulated\n', '                                            .add(received.mul(LongTermFoundationBudgetPercentage)\n', '                                            .div(100));\n', '      \n', '      LegalContingencyFundsAccumulated = LegalContingencyFundsAccumulated\n', '                                         .add(received.mul(LegalContingencyFundsPercentage)\n', '                                         .div(100));\n', '      \n', '      MarketingAndCommunityOutreachAccumulated = MarketingAndCommunityOutreachAccumulated\n', '                                                 .add(received.mul(MarketingAndCommunityOutreachPercentage)\n', '                                                 .div(100));\n', '      \n', '      CashReserveFundAccumulated = CashReserveFundAccumulated\n', '                                   .add(received.mul(CashReserveFundPercentage)\n', '                                   .div(100));\n', '      \n', '      OperationalExpensesAccumulated = OperationalExpensesAccumulated\n', '                                       .add(received.mul(OperationalExpensesPercentage)\n', '                                       .div(100));\n', '      \n', '      SoftwareProductDevelopmentAccumulated = SoftwareProductDevelopmentAccumulated\n', '                                              .add(received.mul(SoftwareProductDevelopmentPercentage)\n', '                                              .div(100));\n', '      \n', '      FoundersTeamAndAdvisorsAccumulated = FoundersTeamAndAdvisorsAccumulated\n', '                                            .add(received.mul(FoundersTeamAndAdvisorsPercentage)\n', '                                            .div(100));\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    bool withinContributionLimit = msg.value >= minimumContribution && msg.value <= maximumContribution;\n', '    return withinPeriod && nonZeroPurchase && withinContributionLimit;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '  \n', '   /**\n', '    * function to change the end timestamp of the ico\n', '    * can only be called by owner wallet\n', '    **/\n', '    function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{\n', '        endTime = endTimeUnixTimestamp;\n', '    }\n', '    \n', '    /**\n', '    * function to change the start timestamp of the ico\n', '    * can only be called by owner wallet\n', '    **/\n', '    \n', '    function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{\n', '        startTime = startTimeUnixTimestamp;\n', '    }\n', '    \n', '     /**\n', '     * function to pause the crowdsale \n', '     * can only be called from owner wallet\n', '     **/\n', '     \n', '    function pauseCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = true;\n', '    }\n', '\n', '    /**\n', '     * function to resume the crowdsale if it is paused\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function resumeCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = false;\n', '    }\n', '     \n', '     function takeTokensBack() public onlyOwner\n', '     {\n', '         uint remainingTokensInTheContract = token.balanceOf(address(this));\n', '         token.transfer(owner,remainingTokensInTheContract);\n', '     }\n', '     \n', '    /**\n', '     * function to change the minimum contribution\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function changeMinimumContribution(uint256 minContribution) public onlyOwner {\n', '        minimumContribution = minContribution;\n', '    }\n', '    \n', '    /**\n', '     * function to change the maximum contribution\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function changeMaximumContribution(uint256 maxContribution) public onlyOwner {\n', '        maximumContribution = maxContribution;\n', '    }\n', '    \n', '    /**\n', '     * function to withdraw LongTermFoundationBudget funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/  \n', '    function withdrawLongTermFoundationBudget() public onlyOwner {\n', '        require(LongTermFoundationBudgetAccumulated > 0);\n', '        owner.transfer(LongTermFoundationBudgetAccumulated);\n', '        LongTermFoundationBudgetAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw LegalContingencyFunds funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '     \n', '    function withdrawLegalContingencyFunds() public onlyOwner {\n', '        require(LegalContingencyFundsAccumulated > 0);\n', '        owner.transfer(LegalContingencyFundsAccumulated);\n', '        LegalContingencyFundsAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw MarketingAndCommunityOutreach funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawMarketingAndCommunityOutreach() public onlyOwner {\n', '        require (MarketingAndCommunityOutreachAccumulated > 0);\n', '        owner.transfer(MarketingAndCommunityOutreachAccumulated);\n', '        MarketingAndCommunityOutreachAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw CashReserveFund funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawCashReserveFund() public onlyOwner {\n', '        require(CashReserveFundAccumulated > 0);\n', '        owner.transfer(CashReserveFundAccumulated);\n', '        CashReserveFundAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw OperationalExpenses funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawOperationalExpenses() public onlyOwner {\n', '        require(OperationalExpensesAccumulated > 0);\n', '        owner.transfer(OperationalExpensesAccumulated);\n', '        OperationalExpensesAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw SoftwareProductDevelopment funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawSoftwareProductDevelopment() public onlyOwner {\n', '        require (SoftwareProductDevelopmentAccumulated > 0);\n', '        owner.transfer(SoftwareProductDevelopmentAccumulated);\n', '        SoftwareProductDevelopmentAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw FoundersTeamAndAdvisors funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawFoundersTeamAndAdvisors() public onlyOwner {\n', '        require (FoundersTeamAndAdvisorsAccumulated > 0);\n', '        owner.transfer(FoundersTeamAndAdvisorsAccumulated);\n', '        FoundersTeamAndAdvisorsAccumulated = 0;\n', '    }\n', '    \n', '     /**\n', '     * function to withdraw all funds to the owner wallet\n', '     * can only be called from owner wallet\n', '     **/\n', '    function withdrawAllFunds() public onlyOwner {\n', '        require (address(this).balance > 0);\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']
