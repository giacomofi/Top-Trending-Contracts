['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', ' \n', ' \n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', ' function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant public returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) tokenBalances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(tokenBalances[msg.sender]>=_value);\n', '    tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);\n', '    tokenBalances[_to] = tokenBalances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '    return tokenBalances[_owner];\n', '  }\n', '\n', '}\n', 'contract EtheeraToken is BasicToken,Ownable {\n', '\n', '   using SafeMath for uint256;\n', '   \n', '   string public constant name = "ETHEERA";\n', '   string public constant symbol = "ETA";\n', '   uint256 public constant decimals = 18;\n', '\n', '   uint256 public constant INITIAL_SUPPLY = 300000000;\n', '   event Debug(string message, address addr, uint256 number);\n', '   /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens.\n', '   */\n', '    function EtheeraToken(address wallet) public {\n', '        owner = msg.sender;\n', '        totalSupply = INITIAL_SUPPLY * 10 ** 18;\n', '        tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts\n', '    }\n', '\n', '    function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {\n', '      require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell\n', "      tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance\n", "      tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance\n", '      Transfer(wallet, buyer, tokenAmount);\n', '      totalSupply = totalSupply.sub(tokenAmount);\n', '    }\n', '    \n', '    function showMyTokenBalance(address addr) public view onlyOwner returns (uint tokenBalance) {\n', '        tokenBalance = tokenBalances[addr];\n', '        return tokenBalance;\n', '    }\n', '    \n', '}\n', 'contract EtheeraCrowdsale {\n', '  using SafeMath for uint256;\n', ' \n', '  // The token being sold\n', '  EtheeraToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  // address where tokens are deposited and from where we send tokens to buyers\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public ratePerWei = 2000;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  // flags to show whether soft cap / hard cap is reached\n', '  bool public isSoftCapReached = false;\n', '  bool public isHardCapReached = false;\n', '    \n', '  //this flag is set to true when ICO duration is over and soft cap is not reached  \n', '  bool public refundToBuyers = false;\n', '    \n', '  // Soft cap of the ICO in ethers  \n', '  uint256 public softCap = 6000;\n', '    \n', '  //Hard cap of the ICO in ethers\n', '  uint256 public hardCap = 105000;\n', '  \n', '  //total tokens that have been sold  \n', '  uint256 public tokens_sold = 0;\n', '\n', '  //total tokens that are to be sold - this is 70% of the total supply i.e. 300000000\n', '  uint maxTokensForSale = 210000000;\n', '  \n', '  //tokens that are reserved for the etheera team - this is 30% of the total supply  \n', '  uint256 public tokensForReservedFund = 0;\n', '  uint256 public tokensForAdvisors = 0;\n', '  uint256 public tokensForFoundersAndTeam = 0;\n', '  uint256 public tokensForMarketing = 0;\n', '  uint256 public tokensForTournament = 0;\n', '\n', '  bool ethersSentForRefund = false;\n', '\n', '  // the buyers of tokens and the amount of ethers they sent in\n', '  mapping(address=>uint256) usersThatBoughtETA;\n', ' \n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function EtheeraCrowdsale(uint256 _startTime, address _wallet) public {\n', '\n', '    startTime = _startTime;\n', '    endTime = startTime + 60 days;\n', '    \n', '    require(endTime >= startTime);\n', '    require(_wallet != 0x0);\n', '\n', '    wallet = _wallet;\n', '    token = createTokenContract(wallet);\n', '  }\n', '\n', '  function createTokenContract(address wall) internal returns (EtheeraToken) {\n', '    return new EtheeraToken(wall);\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () public payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  //determine the bonus with respect to time elapsed\n', '  function determineBonus(uint tokens) internal view returns (uint256 bonus) {\n', '    \n', '    uint256 timeElapsed = now - startTime;\n', '    uint256 timeElapsedInDays = timeElapsed.div(1 days);\n', '    \n', '    if (timeElapsedInDays <=29)\n', '    {\n', '        //early sale\n', '        //valid for 7 days (1st week)\n', '        //30000+ TOKEN PURCHASE AMOUNT / 33% BONUS\n', '        if (tokens>30000 * 10 ** 18)\n', '        {\n', '            //33% bonus\n', '            bonus = tokens.mul(33);\n', '            bonus = bonus.div(100);\n', '        }\n', '        //10000+ TOKEN PURCHASE AMOUNT / 26% BONUS\n', '        else if (tokens>10000 *10 ** 18 && tokens<= 30000 * 10 ** 18)\n', '        {\n', '            //26% bonus\n', '            bonus = tokens.mul(26);\n', '            bonus = bonus.div(100);\n', '        }\n', '        //3000+ TOKEN PURCHASE AMOUNT / 23% BONUS\n', '        else if (tokens>3000 *10 ** 18 && tokens<= 10000 * 10 ** 18)\n', '        {\n', '            //23% bonus\n', '            bonus = tokens.mul(23);\n', '            bonus = bonus.div(100);\n', '        }\n', '        \n', '        //75+ TOKEN PURCHASE AMOUNT / 20% BONUS\n', '        else if (tokens>=75 *10 ** 18 && tokens<= 3000 * 10 ** 18)\n', '        {\n', '            //20% bonus\n', '            bonus = tokens.mul(20);\n', '            bonus = bonus.div(100);\n', '        }\n', '        else \n', '        {\n', '            bonus = 0;\n', '        }\n', '    }\n', '    else if (timeElapsedInDays>29 && timeElapsedInDays <=49)\n', '    {\n', '        //sale\n', '        //from 7th day till 49th day (total 42 days or 6 weeks)\n', '        //30000+ TOKEN PURCHASE AMOUNT / 15% BONUS\n', '        if (tokens>30000 * 10 ** 18)\n', '        {\n', '            //15% bonus\n', '            bonus = tokens.mul(15);\n', '            bonus = bonus.div(100);\n', '        }\n', '        //10000+ TOKEN PURCHASE AMOUNT / 10% BONUS\n', '        else if (tokens>10000 *10 ** 18 && tokens<= 30000 * 10 ** 18)\n', '        {\n', '            //10% bonus\n', '            bonus = tokens.mul(10);\n', '            bonus = bonus.div(100);\n', '        }\n', '        //3000+ TOKEN PURCHASE AMOUNT / 5% BONUS\n', '        else if (tokens>3000 *10 ** 18 && tokens<= 10000 * 10 ** 18)\n', '        {\n', '            //5% bonus\n', '            bonus = tokens.mul(5);\n', '            bonus = bonus.div(100);\n', '        }\n', '        \n', '        //75+ TOKEN PURCHASE AMOUNT / 3% BONUS\n', '        else if (tokens>=75 *10 ** 18 && tokens<= 3000 * 10 ** 18)\n', '        {\n', '            //3% bonus\n', '            bonus = tokens.mul(3);\n', '            bonus = bonus.div(100);\n', '        }\n', '        else \n', '        {\n', '            bonus = 0;\n', '        }\n', '    }\n', '    else\n', '    {\n', '        //no bonuses after 7th week i.e. 49 days\n', '        bonus = 0;\n', '    }\n', '  }\n', '\n', '  // low level token purchase function\n', '  // Minimum purchase can be of 75 ETA tokens\n', '  \n', '  function buyTokens(address beneficiary) public payable {\n', '    \n', '  //tokens not to be sent to 0x0\n', '  require(beneficiary != 0x0);\n', '\n', '  if(hasEnded() && !isHardCapReached)\n', '  {\n', '      if (!isSoftCapReached)\n', '        refundToBuyers = true;\n', '      burnRemainingTokens();\n', '      beneficiary.transfer(msg.value);\n', '  }\n', '  \n', '  else\n', '  {\n', '    //the purchase should be within duration and non zero\n', '    require(validPurchase());\n', '    \n', '    // amount sent by the user\n', '    uint256 weiAmount = msg.value;\n', '    \n', '    // calculate token amount to be sold\n', '    uint256 tokens = weiAmount.mul(ratePerWei);\n', '  \n', '    require (tokens>=75 * 10 ** 18);\n', '    \n', '    //Determine bonus\n', '    uint bonus = determineBonus(tokens);\n', '    tokens = tokens.add(bonus);\n', '  \n', "    //can't sale tokens more than 21000000000\n", '    require(tokens_sold + tokens <= maxTokensForSale * 10 ** 18);\n', '  \n', '    //30% of the tokens being sold are being accumulated for the etheera team\n', '    updateTokensForEtheeraTeam(tokens);\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    \n', '    \n', '    if (weiRaised >= softCap * 10 ** 18 && !isSoftCapReached)\n', '    {\n', '      isSoftCapReached = true;\n', '    }\n', '  \n', '    if (weiRaised >= hardCap * 10 ** 18 && !isHardCapReached)\n', '      isHardCapReached = true;\n', '    \n', '    token.mint(wallet, beneficiary, tokens);\n', '    \n', '    uint olderAmount = usersThatBoughtETA[beneficiary];\n', '    usersThatBoughtETA[beneficiary] = weiAmount + olderAmount;\n', '    \n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    \n', '    tokens_sold = tokens_sold.add(tokens);\n', '    forwardFunds();\n', '  }\n', ' }\n', '\n', '  // send ether to the fund collection wallet\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '    \n', '    function burnRemainingTokens() internal\n', '    {\n', '        //burn all the unsold tokens as soon as the ICO is ended\n', '        uint balance = token.showMyTokenBalance(wallet);\n', '        require(balance>0);\n', '        uint tokensForTeam = tokensForReservedFund + tokensForFoundersAndTeam + tokensForAdvisors +tokensForMarketing + tokensForTournament;\n', '        uint tokensToBurn = balance.sub(tokensForTeam);\n', '        require (balance >=tokensToBurn);\n', '        address burnAddress = 0x0;\n', '        token.mint(wallet,burnAddress,tokensToBurn);\n', '    }\n', '    \n', '    function getRefund() public \n', '    {\n', '        require(ethersSentForRefund && usersThatBoughtETA[msg.sender]>0);\n', '        uint256 ethersSent = usersThatBoughtETA[msg.sender];\n', '        require (wallet.balance >= ethersSent);\n', '        msg.sender.transfer(ethersSent);\n', '        uint256 tokensIHave = token.showMyTokenBalance(msg.sender);\n', '        token.mint(msg.sender,0x0,tokensIHave);\n', '    }\n', '    \n', '    function debitAmountToRefund() public payable \n', '    {\n', '        require(hasEnded() && msg.sender == wallet && !isSoftCapReached && !ethersSentForRefund);\n', '        require(msg.value >=weiRaised);\n', '        ethersSentForRefund = true;\n', '    }\n', '    \n', '    function updateTokensForEtheeraTeam(uint256 tokens) internal \n', '    {\n', '        uint256 reservedFundTokens;\n', '        uint256 foundersAndTeamTokens;\n', '        uint256 advisorsTokens;\n', '        uint256 marketingTokens;\n', '        uint256 tournamentTokens;\n', '        \n', '        //10% of tokens for reserved fund\n', '        reservedFundTokens = tokens.mul(10);\n', '        reservedFundTokens = reservedFundTokens.div(100);\n', '        tokensForReservedFund = tokensForReservedFund.add(reservedFundTokens);\n', '    \n', '        //15% of tokens for founders and team    \n', '        foundersAndTeamTokens=tokens.mul(15);\n', '        foundersAndTeamTokens= foundersAndTeamTokens.div(100);\n', '        tokensForFoundersAndTeam = tokensForFoundersAndTeam.add(foundersAndTeamTokens);\n', '    \n', '        //3% of tokens for advisors\n', '        advisorsTokens=tokens.mul(3);\n', '        advisorsTokens= advisorsTokens.div(100);\n', '        tokensForAdvisors= tokensForAdvisors.add(advisorsTokens);\n', '    \n', '        //1% of tokens for marketing\n', '        marketingTokens = tokens.mul(1);\n', '        marketingTokens= marketingTokens.div(100);\n', '        tokensForMarketing= tokensForMarketing.add(marketingTokens);\n', '        \n', '        //1% of tokens for tournament \n', '        tournamentTokens=tokens.mul(1);\n', '        tournamentTokens= tournamentTokens.div(100);\n', '        tokensForTournament= tokensForTournament.add(tournamentTokens);\n', '    }\n', '    \n', '    function withdrawTokensForEtheeraTeam(uint256 whoseTokensToWithdraw,address[] whereToSendTokens) public {\n', '        //1 reserved fund, 2 for founders and team, 3 for advisors, 4 for marketing, 5 for tournament\n', '        require(msg.sender == wallet && now>=endTime);\n', '        uint256 lockPeriod = 0;\n', '        uint256 timePassed = now - endTime;\n', '        uint256 tokensToSend = 0;\n', '        uint256 i = 0;\n', '        if (whoseTokensToWithdraw == 1)\n', '        {\n', '          //15 months lockup period\n', '          lockPeriod = 15 days * 30;\n', '          require(timePassed >= lockPeriod);\n', '          require (tokensForReservedFund >0);\n', '          //allow withdrawal\n', '          tokensToSend = tokensForReservedFund.div(whereToSendTokens.length);\n', '                \n', '          for (i=0;i<whereToSendTokens.length;i++)\n', '          {\n', '            token.mint(wallet,whereToSendTokens[i],tokensToSend);\n', '          }\n', '          tokensForReservedFund = 0;\n', '        }\n', '        else if (whoseTokensToWithdraw == 2)\n', '        {\n', '          //10 months lockup period\n', '          lockPeriod = 10 days * 30;\n', '          require(timePassed >= lockPeriod);\n', '          require(tokensForFoundersAndTeam > 0);\n', '          //allow withdrawal\n', '          tokensToSend = tokensForFoundersAndTeam.div(whereToSendTokens.length);\n', '                \n', '          for (i=0;i<whereToSendTokens.length;i++)\n', '          {\n', '            token.mint(wallet,whereToSendTokens[i],tokensToSend);\n', '          }            \n', '          tokensForFoundersAndTeam = 0;\n', '        }\n', '        else if (whoseTokensToWithdraw == 3)\n', '        {\n', '            require (tokensForAdvisors > 0);\n', '          //allow withdrawal\n', '          tokensToSend = tokensForAdvisors.div(whereToSendTokens.length);        \n', '          for (i=0;i<whereToSendTokens.length;i++)\n', '          {\n', '            token.mint(wallet,whereToSendTokens[i],tokensToSend);\n', '          }\n', '          tokensForAdvisors = 0;\n', '        }\n', '        else if (whoseTokensToWithdraw == 4)\n', '        {\n', '            require (tokensForMarketing > 0);\n', '          //allow withdrawal\n', '          tokensToSend = tokensForMarketing.div(whereToSendTokens.length);\n', '                \n', '          for (i=0;i<whereToSendTokens.length;i++)\n', '          {\n', '            token.mint(wallet,whereToSendTokens[i],tokensToSend);\n', '          }\n', '          tokensForMarketing = 0;\n', '        }\n', '        else if (whoseTokensToWithdraw == 5)\n', '        {\n', '            require (tokensForTournament > 0);\n', '          //allow withdrawal\n', '          tokensToSend = tokensForTournament.div(whereToSendTokens.length);\n', '                \n', '          for (i=0;i<whereToSendTokens.length;i++)\n', '          {\n', '            token.mint(wallet,whereToSendTokens[i],tokensToSend);\n', '          }\n', '          tokensForTournament = 0;\n', '        }\n', '        else \n', '        {\n', '          //wrong input\n', '          require (1!=1);\n', '        }\n', '    }\n', '}']