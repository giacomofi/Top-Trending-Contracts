['pragma solidity 0.4.17;\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address internal owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '/**\n', ' * @title AutoCoinICO\n', ' * @dev AutoCoinCrowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them ATC tokens based\n', ' * on a ATC token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  bool public mintingFinished = false;\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    //totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '  function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {\n', '    totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);\n', '  }\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  bool public paused = false;\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '/**\n', ' * @title AutoCoin Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.0\n', ' */\n', 'contract Crowdsale is Ownable, Pausable {\n', '  using SafeMath for uint256;\n', '  /**\n', '   *  @MintableToken token - Token Object\n', '   *  @address wallet - Wallet Address\n', '   *  @uint8 rate - Tokens per Ether\n', '   *  @uint256 weiRaised - Total funds raised in Ethers\n', '  */\n', '  MintableToken internal token;\n', '  address internal wallet;\n', '  uint256 public rate;\n', '  uint256 internal weiRaised;\n', '  /**\n', '   *  @uint256 privateSaleStartTime - Private-Sale Start Time\n', '   *  @uint256 privateSaleEndTime - Private-Sale End Time\n', '  */\n', '  uint256 public privateSaleStartTime;\n', '  uint256 public privateSaleEndTime;\n', '  \n', '  /**\n', '   *  @uint privateBonus - Private Bonus\n', '  */\n', '  uint internal privateSaleBonus;\n', '  /**\n', '   *  @uint256 totalSupply - Total supply of tokens \n', '   *  @uint256 privateSupply - Total Private Supply from Public Supply\n', '  */\n', '  uint256 public totalSupply = SafeMath.mul(400000000, 1 ether);\n', '  uint256 internal privateSaleSupply = SafeMath.mul(SafeMath.div(totalSupply,100),20);\n', '  /**\n', '   *  @bool checkUnsoldTokens - \n', '  */\n', '  bool internal checkUnsoldTokens;\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value Wei&#39;s paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  /**\n', '   * function Crowdsale - Parameterized Constructor\n', '   * @param _startTime - StartTime of Crowdsale\n', '   * @param _endTime - EndTime of Crowdsale\n', '   * @param _rate - Tokens against Ether\n', '   * @param _wallet - MultiSignature Wallet Address\n', '   */\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) internal {\n', '    \n', '    require(_wallet != 0x0);\n', '    token = createTokenContract();\n', '    privateSaleStartTime = _startTime;\n', '    privateSaleEndTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    privateSaleBonus = SafeMath.div(SafeMath.mul(rate,50),100);\n', '    \n', '  }\n', '  /**\n', '   * function createTokenContract - Mintable Token Created\n', '   */\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '  \n', '  /**\n', '   * function Fallback - Receives Ethers\n', '   */\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '    /**\n', '   * function preSaleTokens - Calculate Tokens in PreSale\n', '   */\n', '  function privateSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {\n', '        \n', '    require(privateSaleSupply > 0);\n', '    tokens = SafeMath.add(tokens, weiAmount.mul(privateSaleBonus));\n', '    tokens = SafeMath.add(tokens, weiAmount.mul(rate));\n', '    require(privateSaleSupply >= tokens);\n', '    privateSaleSupply = privateSaleSupply.sub(tokens);        \n', '    return tokens;\n', '  }\n', '  /**\n', '  * function buyTokens - Collect Ethers and transfer tokens\n', '  */\n', '  function buyTokens(address beneficiary) whenNotPaused public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '    uint256 accessTime = now;\n', '    uint256 tokens = 0;\n', '    uint256 weiAmount = msg.value;\n', '    require((weiAmount >= (100000000000000000)) && (weiAmount <= (20000000000000000000)));\n', '    if ((accessTime >= privateSaleStartTime) && (accessTime < privateSaleEndTime)) {\n', '      tokens = privateSaleTokens(weiAmount, tokens);\n', '    } else {\n', '      revert();\n', '    }\n', '    \n', '    privateSaleSupply = privateSaleSupply.sub(tokens);\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '  /**\n', '   * function forwardFunds - Transfer funds to wallet\n', '   */\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '  /**\n', '   * function validPurchase - Checks the purchase is valid or not\n', '   * @return true - Purchase is withPeriod and nonZero\n', '   */\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= privateSaleStartTime && now <= privateSaleEndTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '  /**\n', '   * function hasEnded - Checks the ICO ends or not\n', '   * @return true - ICO Ends\n', '   */\n', '  \n', '  function hasEnded() public constant returns (bool) {\n', '    return now > privateSaleEndTime;\n', '  }\n', '  /** \n', '   * function getTokenAddress - Get Token Address \n', '   */\n', '  function getTokenAddress() onlyOwner public returns (address) {\n', '    return token;\n', '  }\n', '}\n', '/**\n', ' * @title AutoCoin \n', ' */\n', ' \n', 'contract AutoCoinToken is MintableToken {\n', '  /**\n', '   *  @string name - Token Name\n', '   *  @string symbol - Token Symbol\n', '   *  @uint8 decimals - Token Decimals\n', '   *  @uint256 _totalSupply - Token Total Supply\n', '  */\n', '  string public constant name = "Auto Coin";\n', '  string public constant symbol = "Auto Coin";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant _totalSupply = 400000000 * 1 ether;\n', '  \n', '/** Constructor AutoCoinToken */\n', '  function AutoCoinToken() {\n', '    totalSupply = _totalSupply;\n', '  }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract CrowdsaleFunctions is Crowdsale {\n', ' /** \n', '  * function transferAirdropTokens - Transfer private tokens via AirDrop\n', '  * @param beneficiary address where owner wants to transfer tokens\n', '  * @param tokens value of token\n', '  */\n', '  function transferAirdropTokens(address[] beneficiary, uint256[] tokens) onlyOwner public {\n', '    for (uint256 i = 0; i < beneficiary.length; i++) {\n', '      tokens[i] = SafeMath.mul(tokens[i], 1 ether); \n', '      require(privateSaleSupply >= tokens[i]);\n', '      privateSaleSupply = SafeMath.sub(privateSaleSupply, tokens[i]);\n', '      token.mint(beneficiary[i], tokens[i]);\n', '    }\n', '  }\n', '/** \n', ' *.function transferTokens - Used to transfer tokens to investors who pays us other than Ethers\n', ' * @param beneficiary - Address where owner wants to transfer tokens\n', ' * @param tokens -  Number of tokens\n', ' */\n', '  function transferTokens(address beneficiary, uint256 tokens) onlyOwner public {\n', '    require(privateSaleSupply > 0);\n', '    tokens = SafeMath.mul(tokens,1 ether);\n', '    require(privateSaleSupply >= tokens);\n', '    privateSaleSupply = SafeMath.sub(privateSaleSupply, tokens);\n', '    token.mint(beneficiary, tokens);\n', '  }\n', '}\n', 'contract AutoCoinICO is Crowdsale, CrowdsaleFunctions {\n', '  \n', '    /** Constructor AutoCoinICO */\n', '    function AutoCoinICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) \n', '    Crowdsale(_startTime,_endTime,_rate,_wallet) \n', '    {\n', '        \n', '    }\n', '    \n', '    /** AutoCoinToken Contract */\n', '    function createTokenContract() internal returns (MintableToken) {\n', '        return new AutoCoinToken();\n', '    }\n', '}']
['pragma solidity 0.4.17;\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address internal owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '/**\n', ' * @title AutoCoinICO\n', ' * @dev AutoCoinCrowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them ATC tokens based\n', ' * on a ATC token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  bool public mintingFinished = false;\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    //totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '  function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {\n', '    totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);\n', '  }\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  bool public paused = false;\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '/**\n', ' * @title AutoCoin Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.0\n', ' */\n', 'contract Crowdsale is Ownable, Pausable {\n', '  using SafeMath for uint256;\n', '  /**\n', '   *  @MintableToken token - Token Object\n', '   *  @address wallet - Wallet Address\n', '   *  @uint8 rate - Tokens per Ether\n', '   *  @uint256 weiRaised - Total funds raised in Ethers\n', '  */\n', '  MintableToken internal token;\n', '  address internal wallet;\n', '  uint256 public rate;\n', '  uint256 internal weiRaised;\n', '  /**\n', '   *  @uint256 privateSaleStartTime - Private-Sale Start Time\n', '   *  @uint256 privateSaleEndTime - Private-Sale End Time\n', '  */\n', '  uint256 public privateSaleStartTime;\n', '  uint256 public privateSaleEndTime;\n', '  \n', '  /**\n', '   *  @uint privateBonus - Private Bonus\n', '  */\n', '  uint internal privateSaleBonus;\n', '  /**\n', '   *  @uint256 totalSupply - Total supply of tokens \n', '   *  @uint256 privateSupply - Total Private Supply from Public Supply\n', '  */\n', '  uint256 public totalSupply = SafeMath.mul(400000000, 1 ether);\n', '  uint256 internal privateSaleSupply = SafeMath.mul(SafeMath.div(totalSupply,100),20);\n', '  /**\n', '   *  @bool checkUnsoldTokens - \n', '  */\n', '  bool internal checkUnsoldTokens;\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', "   * @param value Wei's paid for purchase\n", '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  /**\n', '   * function Crowdsale - Parameterized Constructor\n', '   * @param _startTime - StartTime of Crowdsale\n', '   * @param _endTime - EndTime of Crowdsale\n', '   * @param _rate - Tokens against Ether\n', '   * @param _wallet - MultiSignature Wallet Address\n', '   */\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) internal {\n', '    \n', '    require(_wallet != 0x0);\n', '    token = createTokenContract();\n', '    privateSaleStartTime = _startTime;\n', '    privateSaleEndTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    privateSaleBonus = SafeMath.div(SafeMath.mul(rate,50),100);\n', '    \n', '  }\n', '  /**\n', '   * function createTokenContract - Mintable Token Created\n', '   */\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '  \n', '  /**\n', '   * function Fallback - Receives Ethers\n', '   */\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '    /**\n', '   * function preSaleTokens - Calculate Tokens in PreSale\n', '   */\n', '  function privateSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {\n', '        \n', '    require(privateSaleSupply > 0);\n', '    tokens = SafeMath.add(tokens, weiAmount.mul(privateSaleBonus));\n', '    tokens = SafeMath.add(tokens, weiAmount.mul(rate));\n', '    require(privateSaleSupply >= tokens);\n', '    privateSaleSupply = privateSaleSupply.sub(tokens);        \n', '    return tokens;\n', '  }\n', '  /**\n', '  * function buyTokens - Collect Ethers and transfer tokens\n', '  */\n', '  function buyTokens(address beneficiary) whenNotPaused public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '    uint256 accessTime = now;\n', '    uint256 tokens = 0;\n', '    uint256 weiAmount = msg.value;\n', '    require((weiAmount >= (100000000000000000)) && (weiAmount <= (20000000000000000000)));\n', '    if ((accessTime >= privateSaleStartTime) && (accessTime < privateSaleEndTime)) {\n', '      tokens = privateSaleTokens(weiAmount, tokens);\n', '    } else {\n', '      revert();\n', '    }\n', '    \n', '    privateSaleSupply = privateSaleSupply.sub(tokens);\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    forwardFunds();\n', '  }\n', '  /**\n', '   * function forwardFunds - Transfer funds to wallet\n', '   */\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '  /**\n', '   * function validPurchase - Checks the purchase is valid or not\n', '   * @return true - Purchase is withPeriod and nonZero\n', '   */\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= privateSaleStartTime && now <= privateSaleEndTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '  /**\n', '   * function hasEnded - Checks the ICO ends or not\n', '   * @return true - ICO Ends\n', '   */\n', '  \n', '  function hasEnded() public constant returns (bool) {\n', '    return now > privateSaleEndTime;\n', '  }\n', '  /** \n', '   * function getTokenAddress - Get Token Address \n', '   */\n', '  function getTokenAddress() onlyOwner public returns (address) {\n', '    return token;\n', '  }\n', '}\n', '/**\n', ' * @title AutoCoin \n', ' */\n', ' \n', 'contract AutoCoinToken is MintableToken {\n', '  /**\n', '   *  @string name - Token Name\n', '   *  @string symbol - Token Symbol\n', '   *  @uint8 decimals - Token Decimals\n', '   *  @uint256 _totalSupply - Token Total Supply\n', '  */\n', '  string public constant name = "Auto Coin";\n', '  string public constant symbol = "Auto Coin";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant _totalSupply = 400000000 * 1 ether;\n', '  \n', '/** Constructor AutoCoinToken */\n', '  function AutoCoinToken() {\n', '    totalSupply = _totalSupply;\n', '  }\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract CrowdsaleFunctions is Crowdsale {\n', ' /** \n', '  * function transferAirdropTokens - Transfer private tokens via AirDrop\n', '  * @param beneficiary address where owner wants to transfer tokens\n', '  * @param tokens value of token\n', '  */\n', '  function transferAirdropTokens(address[] beneficiary, uint256[] tokens) onlyOwner public {\n', '    for (uint256 i = 0; i < beneficiary.length; i++) {\n', '      tokens[i] = SafeMath.mul(tokens[i], 1 ether); \n', '      require(privateSaleSupply >= tokens[i]);\n', '      privateSaleSupply = SafeMath.sub(privateSaleSupply, tokens[i]);\n', '      token.mint(beneficiary[i], tokens[i]);\n', '    }\n', '  }\n', '/** \n', ' *.function transferTokens - Used to transfer tokens to investors who pays us other than Ethers\n', ' * @param beneficiary - Address where owner wants to transfer tokens\n', ' * @param tokens -  Number of tokens\n', ' */\n', '  function transferTokens(address beneficiary, uint256 tokens) onlyOwner public {\n', '    require(privateSaleSupply > 0);\n', '    tokens = SafeMath.mul(tokens,1 ether);\n', '    require(privateSaleSupply >= tokens);\n', '    privateSaleSupply = SafeMath.sub(privateSaleSupply, tokens);\n', '    token.mint(beneficiary, tokens);\n', '  }\n', '}\n', 'contract AutoCoinICO is Crowdsale, CrowdsaleFunctions {\n', '  \n', '    /** Constructor AutoCoinICO */\n', '    function AutoCoinICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) \n', '    Crowdsale(_startTime,_endTime,_rate,_wallet) \n', '    {\n', '        \n', '    }\n', '    \n', '    /** AutoCoinToken Contract */\n', '    function createTokenContract() internal returns (MintableToken) {\n', '        return new AutoCoinToken();\n', '    }\n', '}']