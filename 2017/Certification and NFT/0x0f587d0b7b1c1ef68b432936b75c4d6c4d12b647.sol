['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  bool transferAllowed = false;\n', '\n', '  function setTransferAllowed(bool _transferAllowed) public onlyOwner {\n', '    transferAllowed = _transferAllowed;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    require(transferAllowed);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '//StandardToken.sol\n', 'contract StandardToken is ERC20, BasicToken {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(transferAllowed);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract MatToken is Ownable, StandardToken {\n', '  string public constant name = "MiniApps Token";\n', '  string public constant symbol = "MAT";\n', '  uint   public constant decimals = 18;\n', '  \n', '  // token units\n', '  uint256 public constant MAT_UNIT = 10**uint256(decimals);\n', '  uint256 constant MILLION_MAT = 10**6 * MAT_UNIT;\n', '  uint256 constant THOUSAND_MAT = 10**3 * MAT_UNIT;\n', '\n', '  // Token distribution: crowdsale - 50%, partners - 35%, team - 15%, total 20M  \n', '  uint256 public constant MAT_CROWDSALE_SUPPLY_LIMIT = 10 * MILLION_MAT;\n', '  uint256 public constant MAT_TEAM_SUPPLY_LIMIT = 7 * MILLION_MAT;\n', '  uint256 public constant MAT_PARTNERS_SUPPLY_LIMIT = 3 * MILLION_MAT;\n', '  uint256 public constant MAT_TOTAL_SUPPLY_LIMIT = MAT_CROWDSALE_SUPPLY_LIMIT + MAT_TEAM_SUPPLY_LIMIT + MAT_PARTNERS_SUPPLY_LIMIT;\n', '}\n', '\n', 'contract MatBonus is MatToken {\n', '  uint256 public constant TOTAL_SUPPLY_UPPER_BOUND = 14000 * THOUSAND_MAT;\n', '  uint256 public constant TOTAL_SUPPLY_BOTTOM_BOUND = 11600 * THOUSAND_MAT;\n', '\n', '  function calcBonus(uint256 tokens) internal returns (uint256){\n', '    if (totalSupply <= TOTAL_SUPPLY_BOTTOM_BOUND)\n', '      return tokens.mul(8).div(100);\n', '    else if (totalSupply > TOTAL_SUPPLY_BOTTOM_BOUND && totalSupply <= TOTAL_SUPPLY_UPPER_BOUND)\n', '      return tokens.mul(5).div(100);\n', '    else\n', '      return 0;\n', '  }\n', '}\n', '\n', 'contract MatBase is Ownable, MatToken, MatBonus {\n', ' using SafeMath for uint256;\n', '  \n', '  uint256 public constant _START_DATE = 1508284800; //  Wednesday, 18-Oct-17 00:00:00 UTC in RFC 2822\n', '  uint256 public constant _END_DATE = 1513641600; // Tuesday, 19-Dec-17 00:00:00 UTC in RFC 2822\n', '  uint256 public constant CROWDSALE_PRICE = 100; // 100 MAT per ETH\n', '  address public constant ICO_ADDRESS = 0x6075a5A0620861cfeF593a51A01aF0fF179168C7;\n', '  address public constant PARTNERS_WALLET =  0x39467d5B39F1d24BC8479212CEd151ad469B0D7E;\n', '  address public constant TEAM_WALLET = 0xe1d32147b08b2a7808026D4A94707E321ccc7150;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '  function setStartTime(uint256 _startTime) onlyOwner\n', '  {\n', '    startTime = _startTime;\n', '  }\n', '  function setEndTime(uint256 _endTime) onlyOwner\n', '  {\n', '    endTime = _endTime;\n', '  }\n', '\n', '  // address  where funds are collected\n', '  address public wallet;\n', '  address public p_wallet;\n', '  address public t_wallet;\n', '\n', '  // total amount of raised money in wei\n', '  uint256 public totalCollected;\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '  event Mint(address indexed purchaser, uint256 amount);\n', '  event Bonus(address indexed purchaser,uint256 amount);\n', '  function mint(address _to, uint256 _tokens) internal returns (bool) {\n', '    totalSupply = totalSupply.add(_tokens);\n', '    require(totalSupply <= whiteListLimit);\n', '    require(totalSupply <= MAT_TOTAL_SUPPLY_LIMIT);\n', '\n', '    balances[_to] = balances[_to].add(_tokens);\n', '    Mint(_to, _tokens);\n', '    Transfer(0x0, _to, _tokens);\n', '    return true;\n', '  }\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amountTokens amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amountTokens,\n', '    string referral);\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    buyTokensReferral(beneficiary, "");\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokensReferral(address beneficiary, string referral) public payable {\n', '    require(msg.value > 0);\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '    uint256 bonus = calcBonus(tokens);\n', '\n', '    // update state\n', '    totalCollected = totalCollected.add(weiAmount);\n', '\n', '    if (!buyTokenWL(tokens)) mint(beneficiary, bonus);\n', '    mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, referral);\n', '    forwardFunds();\n', '  }\n', '\n', '//whitelist\n', '  bool isWhitelistOn;\n', '  uint256 public whiteListLimit;\n', '\n', '  enum WLS {notlisted,listed,fulfilled}\n', '  struct FundReservation {\n', '    WLS status;\n', '    uint256  reserved;\n', '  }\n', '  mapping ( address => FundReservation ) whitelist;\n', '\n', '  function stopWhitelistReservetion() onlyOwner public { \n', '    whiteListLimit = MAT_TOTAL_SUPPLY_LIMIT; \n', '  }\n', '\n', '  function setWhiteListStatus(bool _isWhitelistOn) onlyOwner public {\n', '    isWhitelistOn = _isWhitelistOn;\n', '  }\n', '\n', '  function buyTokenWL(uint256 tokens) internal returns (bool)\n', '  { \n', '    require(isWhitelistOn);\n', '    require(now >= startTime);\n', '    if (whitelist[msg.sender].status == WLS.listed) {\n', '      uint256 reservation = whitelist[msg.sender].reserved;\n', '      uint256 low = reservation.mul(9).div(10);\n', '      uint256 upper = reservation.mul(11).div(10);\n', '      \n', '      if( low <= msg.value && msg.value <= upper) {\n', '        whitelist[msg.sender].status == WLS.fulfilled;\n', '        uint256 bonus = tokens / 10;\n', '        mint(msg.sender, bonus);\n', '        Bonus(msg.sender,bonus);\n', '        return true;\n', '      }\n', '    }\n', '    return false;\n', '  }\n', '  event White(address indexed to, uint256 reservation);\n', '  function regWL(address wlmember, uint256 reservation) onlyOwner public returns (bool status)\n', '  {\n', '    require(now < endTime);\n', '    require(whitelist[wlmember].status == WLS.notlisted);\n', '    \n', '    whitelist[wlmember].status = WLS.listed;\n', '    whitelist[wlmember].reserved = reservation;\n', '    \n', '    whiteListLimit = whiteListLimit.sub(reservation.mul(CROWDSALE_PRICE).mul(11).div(10));\n', '    White(wlmember,reservation);\n', '    return true;\n', '  }\n', '  address public constant PRESALE_CONTRACT = 0x503FE694CE047eCB51952b79eCAB2A907Afe8ACd;\n', '    /**\n', '   * @dev presale token conversion \n', '   *\n', '   * @param _to holder of presale tokens\n', '   * @param _pretokens The amount of presale tokens to be spent.\n', '   * @param _tokens The amount of presale tokens to be minted on crowdsale, the rest transfer from partners pool\n', '   */\n', '  function convert(address _to, uint256 _pretokens, uint256 _tokens) onlyOwner public returns (bool){\n', '    require(now <= endTime);\n', '    require(_to != address(0));\n', '    require(_pretokens >=  _tokens);\n', '    \n', '    mint(_to, _tokens); //implicit transfer event\n', '    \n', '    uint256 theRest = _pretokens.sub(_tokens);\n', '    require(balances[PARTNERS_WALLET] >= theRest);\n', '    \n', '    if (theRest > 0) {\n', '      balances[PARTNERS_WALLET] = balances[PARTNERS_WALLET].sub(theRest);\n', '      balances[_to] = balances[_to].add(theRest);\n', '      Transfer(PARTNERS_WALLET, _to, theRest); //explicit transfer event\n', '    }\n', '    uint256 amount = _pretokens.div(rate);\n', '    totalCollected = totalCollected.add(amount);\n', '    return true;\n', '  }\n', '  function MatBase() {\n', '    startTime = _START_DATE;\n', '    endTime = _END_DATE;\n', '    wallet = ICO_ADDRESS;\n', '    rate = CROWDSALE_PRICE;\n', '    p_wallet = PARTNERS_WALLET;\n', '    t_wallet = TEAM_WALLET;\n', '    balances[p_wallet] =  MAT_PARTNERS_SUPPLY_LIMIT;\n', '    balances[t_wallet] = MAT_TEAM_SUPPLY_LIMIT;\n', '    totalSupply = MAT_PARTNERS_SUPPLY_LIMIT + MAT_TEAM_SUPPLY_LIMIT;\n', '    whiteListLimit = MAT_TOTAL_SUPPLY_LIMIT;\n', '  }\n', '}']