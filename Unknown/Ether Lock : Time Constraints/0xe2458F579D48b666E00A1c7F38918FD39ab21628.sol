['pragma solidity 0.4.14;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev revert()s if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  \n', '  \n', '  function mul256(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div256(uint256 a, uint256 b) internal returns (uint256) {\n', '    require(b > 0); // Solidity automatically revert()s when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub256(uint256 a, uint256 b) internal returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add256(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }  \n', '  \n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev ERC20 interface with allowances. \n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value);\n', '  function approve(address spender, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       revert();\n', '     }\n', '     _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub256(_value);\n', '    balances[_to] = balances[_to].add256(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implemantation of the basic standart token.\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met\n', '    // if (_value > _allowance) revert();\n', '\n', '    balances[_to] = balances[_to].add256(_value);\n', '    balances[_from] = balances[_from].sub256(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub256(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) {\n', '\n', '    //  To change the approve amount you first have to reduce the addresses\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title LuckyToken\n', ' * @dev The main Lucky token contract\n', ' * \n', ' */\n', ' \n', 'contract LuckyToken is StandardToken, Ownable{\n', '  string public name = "Lucky888Coin";\n', '  string public symbol = "LKY";\n', '  uint public decimals = 18;\n', '\n', '  event TokenBurned(uint256 value);\n', '  \n', '  function LuckyToken() {\n', '    totalSupply = (10 ** 8) * (10 ** decimals);\n', '    balances[msg.sender] = totalSupply;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to burn the token\n', '   * @param _value number of tokens to be burned.\n', '   */\n', '  function burn(uint _value) onlyOwner {\n', '    require(balances[msg.sender] >= _value);\n', '    balances[msg.sender] = balances[msg.sender].sub256(_value);\n', '    totalSupply = totalSupply.sub256(_value);\n', '    TokenBurned(_value);\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title InitialTeuTokenSale\n', ' * @dev The Initial TEU token sale contract\n', ' * \n', ' */\n', 'contract initialTeuTokenSale is Ownable {\n', '  using SafeMath for uint256;\n', '  event LogPeriodStart(uint period);\n', '  event LogCollectionStart(uint period);\n', '  event LogContribution(address indexed contributorAddress, uint256 weiAmount, uint period);\n', '  event LogCollect(address indexed contributorAddress, uint256 tokenAmount, uint period); \n', '\n', '  LuckyToken                                       private  token; \n', '  mapping(uint => address)                       private  walletOfPeriod;\n', '  uint256                                        private  minContribution = 0.1 ether;\n', '  uint                                           private  saleStart;\n', '  bool                                           private  isTokenCollectable = false;\n', '  mapping(uint => uint)                          private  periodStart;\n', '  mapping(uint => uint)                          private  periodDeadline;\n', '  mapping(uint => uint256)                       private  periodTokenPool;\n', '\n', '  mapping(uint => mapping (address => uint256))  private  contribution;  \n', '  mapping(uint => uint256)                       private  periodContribution;  \n', '  mapping(uint => mapping (address => bool))     private  collected;  \n', '  mapping(uint => mapping (address => uint256))  private  tokenCollected;  \n', '  \n', '  uint public totalPeriod = 0;\n', '  uint public currentPeriod = 0;\n', '\n', '\n', '  /**\n', '   * @dev Initialise the contract\n', '   * @param _tokenAddress address of TEU token\n', '   * @param _walletPeriod1 address of period 1 wallet\n', '   * @param _walletPeriod2 address of period 2 wallet\n', '   * @param _tokenPoolPeriod1 amount of pool of token in period 1\n', '   * @param _tokenPoolPeriod2 amount of pool of token in period 2\n', '   * @param _saleStartDate start date / time of the token sale\n', '   */\n', '  function initTokenSale (address _tokenAddress\n', '  , address _walletPeriod1, address _walletPeriod2\n', '  , uint256 _tokenPoolPeriod1, uint256 _tokenPoolPeriod2\n', '  , uint _saleStartDate) onlyOwner {\n', '    assert(totalPeriod == 0);\n', '    assert(_tokenAddress != address(0));\n', '    assert(_walletPeriod1 != address(0));\n', '    assert(_walletPeriod2 != address(0));\n', '    walletOfPeriod[1] = _walletPeriod1;\n', '    walletOfPeriod[2] = _walletPeriod2;\n', '    periodTokenPool[1] = _tokenPoolPeriod1;\n', '    periodTokenPool[2] = _tokenPoolPeriod2;\n', '    token = LuckyToken(_tokenAddress);\n', '    assert(token.owner() == owner);\n', '    setPeriodStart(_saleStartDate);\n', ' \n', '  }\n', '  \n', '  \n', '  /**\n', '   * @dev Allows the owner to set the starting time.\n', '   * @param _saleStartDate the new sales start date / time\n', '   */  \n', '  function setPeriodStart(uint _saleStartDate) onlyOwner beforeSaleStart private {\n', '    totalPeriod = 0;\n', '    saleStart = _saleStartDate;\n', '    \n', '    uint period1_contributionInterval = 14 days;\n', '    uint period1_collectionInterval = 14 days;\n', '    uint period2_contributionInterval = 7 days;\n', '    \n', '    addPeriod(saleStart, saleStart + period1_contributionInterval);\n', '    addPeriod(saleStart + period1_contributionInterval + period1_collectionInterval, saleStart + period1_contributionInterval + period1_collectionInterval + period2_contributionInterval);\n', '\n', '    currentPeriod = 1;    \n', '  } \n', '  \n', '  function addPeriod(uint _periodStart, uint _periodDeadline) onlyOwner beforeSaleEnd private {\n', '    require(_periodStart >= now && _periodDeadline > _periodStart && (totalPeriod == 0 || _periodStart > periodDeadline[totalPeriod]));\n', '    totalPeriod = totalPeriod + 1;\n', '    periodStart[totalPeriod] = _periodStart;\n', '    periodDeadline[totalPeriod] = _periodDeadline;\n', '    periodContribution[totalPeriod] = 0;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Call this method to let the contract to go into next period of sales\n', '   */\n', '  function goNextPeriod() onlyOwner public {\n', '    for (uint i = 1; i <= totalPeriod; i++) {\n', '        if (currentPeriod < totalPeriod && now >= periodStart[currentPeriod + 1]) {\n', '            currentPeriod = currentPeriod + 1;\n', '            isTokenCollectable = false;\n', '            LogPeriodStart(currentPeriod);\n', '        }\n', '    }\n', '    \n', '  }\n', '\n', '  /**\n', '   * @dev Call this method to let the contract to allow token collection after the contribution period\n', '   */  \n', '  function goTokenCollection() onlyOwner public {\n', '    require(currentPeriod > 0 && now > periodDeadline[currentPeriod] && !isTokenCollectable);\n', '    isTokenCollectable = true;\n', '    LogCollectionStart(currentPeriod);\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow contribution only when the sale is ON\n', '   */\n', '  modifier saleIsOn() {\n', '    require(currentPeriod > 0 && now >= periodStart[currentPeriod] && now < periodDeadline[currentPeriod]);\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * @dev modifier to allow collection only when the collection is ON\n', '   */\n', '  modifier collectIsOn() {\n', '    require(isTokenCollectable && currentPeriod > 0 && now > periodDeadline[currentPeriod] && (currentPeriod == totalPeriod || now < periodStart[currentPeriod + 1]));\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * @dev modifier to ensure it is before start of first period of sale\n', '   */  \n', '  modifier beforeSaleStart() {\n', '    require(totalPeriod == 0 || now < periodStart[1]);\n', '    _;  \n', '  }\n', '  /**\n', '   * @dev modifier to ensure it is before the deadline of last sale period\n', '   */  \n', '   \n', '  modifier beforeSaleEnd() {\n', '    require(currentPeriod == 0 || now < periodDeadline[totalPeriod]);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev modifier to ensure it is after the deadline of last sale period\n', '   */ \n', '  modifier afterSaleEnd() {\n', '    require(currentPeriod > 0 && now > periodDeadline[totalPeriod]);\n', '    _;\n', '  }\n', '  \n', '  modifier overMinContribution() {\n', '    require(msg.value >= minContribution);\n', '    _;\n', '  }\n', '  \n', '  \n', '  /**\n', '   * @dev record the contribution of a contribution \n', '   */\n', '  function contribute() private saleIsOn overMinContribution {\n', '    contribution[currentPeriod][msg.sender] = contribution[currentPeriod][msg.sender].add256(msg.value);\n', '    periodContribution[currentPeriod] = periodContribution[currentPeriod].add256(msg.value);\n', '    assert(walletOfPeriod[currentPeriod].send(msg.value));\n', '    LogContribution(msg.sender, msg.value, currentPeriod);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows contributor to collect all token alloted for all period after preiod deadline\n', '   */\n', '  function collectToken() public collectIsOn {\n', '    uint256 _tokenCollected = 0;\n', '    for (uint i = 1; i <= totalPeriod; i++) {\n', '        if (!collected[i][msg.sender] && contribution[i][msg.sender] > 0)\n', '        {\n', '            _tokenCollected = contribution[i][msg.sender].mul256(periodTokenPool[i]).div256(periodContribution[i]);\n', '\n', '            collected[i][msg.sender] = true;\n', '            token.transfer(msg.sender, _tokenCollected);\n', '\n', '            tokenCollected[i][msg.sender] = _tokenCollected;\n', '            LogCollect(msg.sender, _tokenCollected, i);\n', '        }\n', '    }\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allow owner to transfer out the token in the contract\n', '   * @param _to address to transfer to\n', '   * @param _amount amount to transfer\n', '   */  \n', '  function transferTokenOut(address _to, uint256 _amount) public onlyOwner {\n', '    token.transfer(_to, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Allow owner to transfer out the ether in the contract\n', '   * @param _to address to transfer to\n', '   * @param _amount amount to transfer\n', '   */  \n', '  function transferEtherOut(address _to, uint256 _amount) public onlyOwner {\n', '    assert(_to.send(_amount));\n', '  }  \n', '\n', '  /**\n', '   * @dev to get the contribution amount of any contributor under different period\n', '   * @param _period period to get the contribution amount\n', '   * @param _contributor contributor to get the conribution amount\n', '   */  \n', '  function contributionOf(uint _period, address _contributor) public constant returns (uint256) {\n', '    return contribution[_period][_contributor] ;\n', '  }\n', '\n', '  /**\n', '   * @dev to get the total contribution amount of a given period\n', '   * @param _period period to get the contribution amount\n', '   */  \n', '  function periodContributionOf(uint _period) public constant returns (uint256) {\n', '    return periodContribution[_period];\n', '  }\n', '\n', '  /**\n', '   * @dev to check if token is collected by any contributor under different period\n', '   * @param _period period to get the collected status\n', '   * @param _contributor contributor to get collected status\n', '   */  \n', '  function isTokenCollected(uint _period, address _contributor) public constant returns (bool) {\n', '    return collected[_period][_contributor] ;\n', '  }\n', '  \n', '  /**\n', '   * @dev to get the amount of token collected by any contributor under different period\n', '   * @param _period period to get the amount\n', '   * @param _contributor contributor to get amont\n', '   */  \n', '  function tokenCollectedOf(uint _period, address _contributor) public constant returns (uint256) {\n', '    return tokenCollected[_period][_contributor] ;\n', '  }\n', '\n', '  /**\n', '   * @dev Fallback function which receives ether and create the appropriate number of tokens for the \n', '   * msg.sender.\n', '   */\n', '  function() external payable {\n', '    contribute();\n', '  }\n', '\n', '}']