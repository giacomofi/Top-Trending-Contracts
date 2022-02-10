['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', ' \n', ' \n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', ' function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant public returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) tokenBalances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(tokenBalances[msg.sender]>=_value);\n', '    tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);\n', '    tokenBalances[_to] = tokenBalances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '    return tokenBalances[_owner];\n', '  }\n', '\n', '}\n', '//TODO: Change the name of the token\n', 'contract XrpcToken is BasicToken,Ownable {\n', '\n', '   using SafeMath for uint256;\n', '   \n', '   //TODO: Change the name and the symbol\n', '   string public constant name = "XRPConnect";\n', '   string public constant symbol = "XRPC";\n', '   uint256 public constant decimals = 18;\n', '\n', '   uint256 public constant INITIAL_SUPPLY = 10000000;\n', '   event Debug(string message, address addr, uint256 number);\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens.\n', '   */\n', '   //TODO: Change the name of the constructor\n', '    function XrpcToken(address wallet) public {\n', '        owner = msg.sender;\n', '        totalSupply = INITIAL_SUPPLY;\n', '        tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts\n', '    }\n', '\n', '    function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {\n', '      require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell\n', "      tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance\n", "      tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance\n", '      Transfer(wallet, buyer, tokenAmount); \n', '    }\n', '  function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {\n', '        tokenBalance = tokenBalances[addr];\n', '    }\n', '}\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', ' \n', '  // The token being sold\n', '  XrpcToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  // address where tokens are deposited and from where we send tokens to buyers\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '\n', '  // rates corresponding to each week in WEI not ETH (conversion is 1 ETH == 10^18 WEI)\n', '\n', '  uint256 public week1Price = 2117;   \n', '  uint256 public week2Price = 1466;\n', '  uint256 public week3Price = 1121;\n', '  uint256 public week4Price = 907;\n', '  \n', '  bool ownerAmountPaid = false; \n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, address _wallet) public {\n', '    //TODO: Uncomment these before final deployment\n', '    require(_startTime >= now);\n', '    startTime = _startTime;\n', '    \n', '    //TODO: Comment this "startTime = now" before deployment -- this was for testing purposes only\n', '    //startTime = now;   \n', '    endTime = startTime + 30 days;\n', '    \n', '    require(endTime >= startTime);\n', '    require(_wallet != 0x0);\n', '\n', '    wallet = _wallet;\n', '    token = createTokenContract(wallet);\n', '    \n', '  }\n', '\n', '    function sendOwnerShares(address wal) public\n', '    {\n', '        require(msg.sender == wallet);\n', '        require(ownerAmountPaid == false);\n', '        uint256 ownerAmount = 350000*10**18;\n', '        token.mint(wallet, wal,ownerAmount);\n', '        ownerAmountPaid = true;\n', '    }\n', '  // creates the token to be sold.\n', '  // TODO: Change the name of the token\n', '  function createTokenContract(address wall) internal returns (XrpcToken) {\n', '    return new XrpcToken(wall);\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () public payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  //determine the rate of the token w.r.t. time elapsed\n', '  function determineRate() internal view returns (uint256 weekRate) {\n', '    uint256 timeElapsed = now - startTime;\n', '    uint256 timeElapsedInWeeks = timeElapsed.div(7 days);\n', '\n', '    if (timeElapsedInWeeks == 0)\n', '      weekRate = week1Price;        //e.g. 3 days/7 days will be 0.4-- after truncation will be 0\n', '\n', '    else if (timeElapsedInWeeks == 1)\n', '      weekRate = week2Price;        //e.g. 10 days/7 days will be 1.3 -- after truncation will be 1\n', '\n', '    else if (timeElapsedInWeeks == 2)\n', '      weekRate = week3Price;        //e.g. 20 days/7 days will be 2.4 -- after truncation will be 2\n', '\n', '    else if (timeElapsedInWeeks == 3)\n', '      weekRate = week4Price;        //e.g. 24 days/7 days will be 3.4 -- after truncation will be 3\n', '\n', '    else\n', '    {\n', '        weekRate = 0;   //No tokens to be transferred - ICO time is over\n', '    }\n', '  }\n', '\n', '  // low level token purchase function\n', '  // Minimum purchase can be of 1 ETH\n', '  \n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '    //uint256 ethAmount = weiAmount.div(10 ** 18);\n', '\n', '    // calculate token amount to be created\n', '    rate = determineRate();\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(wallet, beneficiary, tokens); \n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '    \n', '}']