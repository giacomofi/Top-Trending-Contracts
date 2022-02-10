['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'interface TokenInterface {\n', '     function totalSupply() external constant returns (uint);\n', '     function balanceOf(address tokenOwner) external constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) external returns (bool success);\n', '     function approve(address spender, uint tokens) external returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '     function burn(uint256 _value) external;\n', '     function addPrivateSaleBuyer(address buyer,uint value) external;\n', '     function addPreSaleBuyer(address buyer,uint value) external;\n', '     function addPrivateSaleEndDate(uint256 endDate) external;\n', '     function addPreSaleEndDate(uint256 endDate) external;\n', '     function addICOEndDate(uint256 endDate) external;\n', '     function addTeamAndAdvisoryMembers(address[] members) external;\n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '     event Burn(address indexed burner, uint256 value);\n', '}\n', '\n', ' contract FeedCrowdsale is Ownable{\n', '  using SafeMath for uint256;\n', ' \n', '  // The token being sold\n', '  TokenInterface public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public ratePerWei = 11905;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  \n', '  uint256 public weiRaisedInPreICO;\n', '\n', '  uint256 TOKENS_SOLD;\n', '\n', '  uint256 maxTokensToSaleInPrivateSale;\n', '  uint256 maxTokensToSaleInPreICO;\n', '  uint256 maxTokensToSale;\n', '  \n', '  uint256 bonusInPrivateSale;\n', '\n', '  bool isCrowdsalePaused = false;\n', '  \n', '  uint256 minimumContributionInPrivatePhase;\n', '  uint256 minimumContributionInPreICO;\n', '  uint256 maximumContributionInPreICO;\n', '  uint256 maximumContributionInMainICO;\n', '  \n', '  uint256 totalDurationInDays = 112 days;\n', '  uint256 decimals = 18;\n', '  \n', '  uint256 hardCap = 46200 ether;\n', '  uint256 softCapForPreICO = 1680 ether;\n', '  \n', '  address[] tokenBuyers;\n', '  \n', '  mapping(address=>uint256) EthersSentByBuyers; \n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  constructor(uint256 _startTime, address _wallet, address _tokenAddress) public \n', '  {\n', '    require(_startTime >=now);\n', '    require(_wallet != 0x0);\n', '    startTime = _startTime;  \n', '    endTime = startTime + totalDurationInDays;\n', '    require(endTime >= startTime);\n', '    owner = _wallet;\n', '    maxTokensToSaleInPrivateSale = 100000000 * 10 ** uint256(decimals);\n', '    maxTokensToSaleInPreICO = 200000000 * 10 ** uint256(decimals);\n', '    maxTokensToSale = 550000000 * 10 ** uint256(decimals);\n', '    bonusInPrivateSale = 100;\n', '    \n', '    minimumContributionInPrivatePhase = 168 ether;\n', '    minimumContributionInPreICO = 1.68 ether;\n', '    maximumContributionInPreICO = 1680 ether;\n', '    maximumContributionInMainICO = 168 ether;\n', '    token = TokenInterface(_tokenAddress);\n', '  }\n', '  \n', '  \n', '   // fallback function can be used to buy tokens\n', '   function () public  payable {\n', '     buyTokens(msg.sender);\n', '    }\n', '    \n', '    function determineBonus(uint tokens, uint amountSent, address sender) internal returns (uint256 bonus) \n', '    {\n', '        uint256 timeElapsed = now - startTime;\n', '        uint256 timeElapsedInDays = timeElapsed.div(1 days);\n', '        \n', '        //private sale (30 days)\n', '        if (timeElapsedInDays <30)\n', '        {\n', '            require(amountSent>=minimumContributionInPrivatePhase);\n', '            bonus = tokens.mul(bonusInPrivateSale);\n', '            bonus = bonus.div(100);\n', '            require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInPrivateSale);  \n', '            token.addPrivateSaleBuyer(sender,tokens.add(bonus));\n', '        }\n', '        //break\n', '        else if (timeElapsedInDays >=30 && timeElapsedInDays <51)\n', '        {\n', '            revert();\n', '        }\n', '        //pre-ico/presale\n', '        else if (timeElapsedInDays>=51 && timeElapsedInDays<72)\n', '        {\n', '            require(amountSent>=minimumContributionInPreICO && amountSent<=maximumContributionInPreICO);\n', '            if (amountSent>=1.68 ether && amountSent < 17 ether)\n', '            {\n', '                bonus = tokens.mul(5);\n', '                bonus = bonus.div(100);\n', '                require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInPreICO); \n', '            }\n', '            else if (amountSent>=17 ether && amountSent < 169 ether)\n', '            {\n', '                bonus = tokens.mul(10);\n', '                bonus = bonus.div(100);\n', '                require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInPreICO); \n', '            }\n', '            else if (amountSent>=169 ether && amountSent < 841 ether)\n', '            {\n', '                bonus = tokens.mul(15);\n', '                bonus = bonus.div(100);\n', '                require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInPreICO); \n', '            }\n', '            else if (amountSent>=841 ether && amountSent < 1680 ether)\n', '            {\n', '                bonus = tokens.mul(20);\n', '                bonus = bonus.div(100);\n', '                require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInPreICO); \n', '            }\n', '            //adding to pre ico sale for soft cap refunding\n', '            if (EthersSentByBuyers[sender] == 0)\n', '            {\n', '                EthersSentByBuyers[sender] = amountSent;\n', '                tokenBuyers.push(sender);\n', '            }\n', '            else \n', '            {\n', '                EthersSentByBuyers[sender] = EthersSentByBuyers[sender].add(amountSent);\n', '            }\n', '            weiRaisedInPreICO = weiRaisedInPreICO.add(amountSent);\n', '            token.addPreSaleBuyer(sender,tokens.add(bonus));\n', '        }\n', '        //break\n', '        else if (timeElapsedInDays>=72 && timeElapsedInDays<83)\n', '        {\n', '            revert();\n', '        }\n', '        //main ico\n', '        else if(timeElapsedInDays>=83)\n', '        {\n', '            require(amountSent<=maximumContributionInMainICO);\n', '            bonus = 0;\n', '        }\n', '    }\n', '\n', '  // low level token purchase function\n', '  \n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(isCrowdsalePaused == false);\n', '    require(validPurchase());\n', '    require(TOKENS_SOLD<maxTokensToSale && weiRaised<hardCap);\n', '   \n', '    uint256 weiAmount = msg.value;\n', '    \n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(ratePerWei);\n', '    uint256 bonus = determineBonus(tokens,weiAmount,beneficiary);\n', '    tokens = tokens.add(bonus);\n', '    require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);\n', '    \n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    token.transfer(beneficiary,tokens);\n', '    \n', '    emit TokenPurchase(owner, beneficiary, weiAmount, tokens);\n', '    TOKENS_SOLD = TOKENS_SOLD.add(tokens);\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  function forwardFunds() internal {\n', '    owner.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '    \n', '    /**\n', '    * function to change the rate of tokens\n', '    * can only be called by owner wallet\n', '    **/\n', '    function setPriceRate(uint256 newPrice) public onlyOwner {\n', '        ratePerWei = newPrice;\n', '    }\n', '    \n', '     /**\n', '     * function to pause the crowdsale \n', '     * can only be called from owner wallet\n', '     **/\n', '     \n', '    function pauseCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = true;\n', '    }\n', '\n', '    /**\n', '     * function to resume the crowdsale if it is paused\n', '     * can only be called from owner wallet\n', '     **/ \n', '    function resumeCrowdsale() public onlyOwner {\n', '        isCrowdsalePaused = false;\n', '    }\n', '    \n', '    /**\n', '     * Remaining tokens for sale\n', '    **/ \n', '      \n', '     function remainingTokensForSale() public constant returns (uint) {\n', '         return maxTokensToSale.sub(TOKENS_SOLD);\n', '     }\n', '     \n', '     function getUnsoldTokensBack() public onlyOwner\n', '     {\n', '        uint contractTokenBalance = token.balanceOf(address(this));\n', '        require(contractTokenBalance>0);\n', '        token.transfer(owner,contractTokenBalance);\n', '     }\n', '     \n', '     /**\n', '      * Refund the tokens to buyers of presale if soft cap not reached\n', '      **/ \n', '     function RefundToBuyers() public payable onlyOwner {\n', '         //require(now > startTime.add(72 days) );\n', '         require(weiRaised<softCapForPreICO);\n', '         require(msg.value>=weiRaisedInPreICO);\n', '         for (uint i=0;i<tokenBuyers.length;i++)\n', '         {\n', '             uint etherAmount = EthersSentByBuyers[tokenBuyers[i]];\n', '             if (etherAmount>0)\n', '             {\n', '                tokenBuyers[i].transfer(etherAmount);\n', '                EthersSentByBuyers[tokenBuyers[i]] = 0;\n', '             }\n', '         }\n', '     }\n', '     /**\n', '      * Add the team and advisory members\n', '      **/ \n', '     function addTeamAndAdvisoryMembers(address[] members) public onlyOwner {\n', '         token.addTeamAndAdvisoryMembers(members);\n', '     }\n', '     \n', '     /**\n', '      * view the private sale end date and time\n', '      **/\n', '     function getPrivateSaleEndDate() public view onlyOwner returns (uint) {\n', '         return startTime.add(30 days);\n', '     }\n', '     \n', '     /**\n', '      * view the presale end date and time\n', '      **/\n', '     function getPreSaleEndDate() public view onlyOwner returns (uint) {\n', '          return startTime.add(72 days);\n', '     }\n', '     \n', '     /**\n', '      * view the ICO end date and time\n', '      **/\n', '     function getICOEndDate() public view onlyOwner returns (uint) {\n', '          return startTime.add(112 days);\n', '     }\n', '     \n', '     /**\n', '      * set the private sale end date and time\n', '      **/\n', '      function setPrivateSaleEndDate(uint256 timestamp) public onlyOwner  {\n', '          token.addPrivateSaleEndDate(timestamp);\n', '      }\n', '      \n', '     /**\n', '      * set the pre sale end date and time\n', '      **/\n', '       function setPreSaleEndDate(uint256 timestamp) public onlyOwner {\n', '           token.addPreSaleEndDate(timestamp);\n', '       }\n', '       \n', '     /**\n', '      * set the ICO end date and time\n', '      **/\n', '        function setICOEndDate(uint timestamp) public onlyOwner {\n', '           token.addICOEndDate(timestamp);\n', '       }\n', '}']