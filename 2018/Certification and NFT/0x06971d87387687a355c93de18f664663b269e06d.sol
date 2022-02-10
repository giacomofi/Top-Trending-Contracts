['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'interface TokenInterface {\n', '     function totalSupply() external constant returns (uint);\n', '     function balanceOf(address tokenOwner) external constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) external returns (bool success);\n', '     function approve(address spender, uint tokens) external returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '     function burn(uint256 _value) external; \n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '     event Burn(address indexed burner, uint256 value);\n', '}\n', '\n', ' contract EzeCrowdsale is Ownable{\n', '  using SafeMath for uint256;\n', ' \n', '  // The token being sold\n', '  TokenInterface public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public ratePerWeiInSelfDrop = 60000;\n', '  uint256 public ratePerWeiInPrivateSale = 30000;\n', '  uint256 public ratePerWeiInPreICO = 20000;\n', '  uint256 public ratePerWeiInMainICO = 15000;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  uint256 public TOKENS_SOLD;\n', '  \n', '  uint256 maxTokensToSale;\n', '  \n', '  uint256 bonusInSelfDrop = 20;\n', '  uint256 bonusInPrivateSale = 10;\n', '  uint256 bonusInPreICO = 5;\n', '  uint256 bonusInMainICO = 2;\n', '  \n', '  bool isCrowdsalePaused = false;\n', '  \n', '  uint256 totalDurationInDays = 213 days;\n', '  \n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  constructor(uint256 _startTime, address _wallet, address _tokenAddress) public \n', '  {\n', '    require(_startTime >=now);\n', '    require(_wallet != 0x0);\n', '\n', '    startTime = _startTime;  \n', '    endTime = startTime + totalDurationInDays;\n', '    require(endTime >= startTime);\n', '   \n', '    owner = _wallet;\n', '    \n', '    maxTokensToSale = uint(15000000000).mul( 10 ** uint256(18));\n', '   \n', '    token = TokenInterface(_tokenAddress);\n', '  }\n', '  \n', '  \n', '   // fallback function can be used to buy tokens\n', '   function () public  payable {\n', '     buyTokens(msg.sender);\n', '    }\n', '    \n', '    function calculateTokens(uint value) internal view returns (uint256 tokens) \n', '    {\n', '        uint256 timeElapsed = now - startTime;\n', '        uint256 timeElapsedInDays = timeElapsed.div(1 days);\n', '        uint256 bonus = 0;\n', '        //Phase 1 (30 days)\n', '        if (timeElapsedInDays <30)\n', '        {\n', '            tokens = value.mul(ratePerWeiInSelfDrop);\n', '            bonus = tokens.mul(bonusInSelfDrop); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        //Phase 2 (31 days)\n', '        else if (timeElapsedInDays >=30 && timeElapsedInDays <61)\n', '        {\n', '            tokens = value.mul(ratePerWeiInPrivateSale);\n', '            bonus = tokens.mul(bonusInPrivateSale); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '       \n', '        //Phase 3 (30 days)\n', '        else if (timeElapsedInDays >=61 && timeElapsedInDays <91)\n', '        {\n', '            tokens = value.mul(ratePerWeiInPreICO);\n', '            bonus = tokens.mul(bonusInPreICO); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        \n', '        //Phase 4 (122 days)\n', '        else if (timeElapsedInDays >=91 && timeElapsedInDays <213)\n', '        {\n', '            tokens = value.mul(ratePerWeiInMainICO);\n', '            bonus = tokens.mul(bonusInMainICO); \n', '            bonus = bonus.div(100);\n', '            tokens = tokens.add(bonus);\n', '            require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);\n', '        }\n', '        else \n', '        {\n', '            bonus = 0;\n', '        }\n', '    }\n', '\n', '  // low level token purchase function\n', '  \n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(isCrowdsalePaused == false);\n', '    require(validPurchase());\n', '\n', '    \n', '    require(TOKENS_SOLD<maxTokensToSale);\n', '   \n', '    uint256 weiAmount = msg.value;\n', '    \n', '    uint256 tokens = calculateTokens(weiAmount);\n', '    \n', '    // update state\n', '    weiRaised = weiRaised.add(msg.value);\n', '    \n', '    token.transfer(beneficiary,tokens);\n', '    emit TokenPurchase(owner, beneficiary, msg.value, tokens);\n', '    TOKENS_SOLD = TOKENS_SOLD.add(tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  function forwardFunds() internal {\n', '    owner.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '  \n', '   /**\n', '    * function to change the end timestamp of the ico\n', '    * can only be called by owner wallet\n', '    **/\n', '    function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{\n', '        endTime = endTimeUnixTimestamp;\n', '    }\n', '    \n', '    /**\n', '    * function to change the start timestamp of the ico\n', '    * can only be called by owner wallet\n', '    **/\n', '    \n', '    function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{\n', '        startTime = startTimeUnixTimestamp;\n', '    }\n', '    \n', '     /**\n', '     * function to pause the crowdsale \n', '     * can only be called from owner wallet\n', '     **/\n', '     \n', '    function pauseCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = true;\n', '    }\n', '\n', '    /**\n', '     * function to resume the crowdsale if it is paused\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function resumeCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = false;\n', '    }\n', '     \n', '     function takeTokensBack() public onlyOwner\n', '     {\n', '         uint remainingTokensInTheContract = token.balanceOf(address(this));\n', '         token.transfer(owner,remainingTokensInTheContract);\n', '     }\n', '}']