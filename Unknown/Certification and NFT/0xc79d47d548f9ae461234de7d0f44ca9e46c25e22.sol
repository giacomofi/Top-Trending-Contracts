['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    \n', '  event Mint(address indexed to, uint256 amount);\n', '  \n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '  \n', '}\n', '\n', 'contract EstateCoin is MintableToken {\n', '    \n', '    string public constant name = "EstateCoin";\n', '    \n', '    string public constant symbol = "ESC";\n', '    \n', '    uint32 public constant decimals = 2;\n', '    \n', '}\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  function RefundVault(address _wallet) {\n', '    require(_wallet != 0x0);\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Closed;\n', '    Closed();\n', '    wallet.transfer(this.balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    RefundsEnabled();\n', '  }\n', '\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ESCCrowdsale\n', ' */\n', 'contract ESCCrowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  \n', '  //amount of sold money in wei\n', '  uint256 public tokenSold = 0;\n', '  \n', '  uint256 public cap;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  /**\n', '   * event for bonuses logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the bonus\n', '   * @param amount amount of bonuses\n', '   */\n', '  event TokenBonus(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  // minimum amount of funds to be raised in weis\n', '  uint256 public goal;\n', '\n', '  // refund vault used to hold funds while crowdsale is running\n', '  RefundVault public vault;\n', '\n', '  function ESCCrowdsale() {\n', '    startTime = 1506118400;//1506118400\n', '    endTime = 1507896000;\n', '    rate = 250;\n', '    wallet = msg.sender;\n', '    cap = 42550000000000000000000;\n', '    vault = new RefundVault(wallet);\n', '    goal = 2950000000000000000000;\n', '\n', '    //startTime = 1506118400; //4rd October 2017 12:00:00 GMT //1507118400\n', '    //endTime = 1507896000; //13th October 2017 12:00:00 GMT\n', '    //rate = 250; //250ESC = 1ETH\n', '    //wallet = msg.sender;\n', '    //uint256 _cap = 42550000000000000000000;\n', '    //uint256 _goal = 2950000000000000000000; // Minimal goal is 2950ETH = 4400ETH - 1450ETH(funding on Waves Platform)\n', '\n', '    require(startTime <= now);\n', '    require(endTime >= startTime);\n', '    require(rate > 0);\n', '    require(wallet != 0x0);\n', '    require(cap > 0);\n', '    require(goal > 0);\n', '\n', '    token = createTokenContract();\n', '  }\n', '\n', '  // creates the token to be sold.\n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return EstateCoin(0xE554056146fad6f2A7B5D5dbBb6f6763d58926c5);\n', '    //return new EstateCoin();\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '\n', '    tokenSold += msg.value.mul(rate);\n', '    uint256 bonus = 0;\n', '    if (now < 1507204800) {\n', '        bonus = tokenSold.div(20); //5%\n', '    } else if (now < 1507291200) {\n', '        bonus = tokenSold.div(25); //4%\n', '    } else if (now < 1507377600) {\n', '        bonus = tokenSold.div(33); //3%\n', '    } else if (now < 1507464000) {\n', '        bonus = tokenSold.div(50); //2%\n', '    } else if (now < 1507550400) {\n', '        bonus = tokenSold.div(100); //1%\n', '    }\n', '    \n', '    if (bonus > 0) {\n', '        token.mint(beneficiary, bonus);\n', '        TokenBonus(msg.sender, beneficiary, bonus);\n', '    }\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms...\n', '  // We&#39;re overriding the fund forwarding from Crowdsale.\n', '  // In addition to sending the funds, we want to call\n', '  // the RefundVault deposit function\n', '  function forwardFunds() internal {\n', '    //wallet.transfer(msg.value);\n', '    vault.deposit.value(msg.value)(msg.sender);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return withinPeriod && nonZeroPurchase && withinCap;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return (now > endTime) || capReached;\n', '  }\n', '    \n', '  /**\n', '   * @dev Must be called after crowdsale ends, to do some extra finalization\n', '   * work. Calls the contract&#39;s finalization function.\n', '   */\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '\n', '    finalization();\n', '    Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '  \n', '  // if crowdsale is unsuccessful, investors can claim refunds here\n', '  function claimRefund() public {\n', '    require(isFinalized);\n', '    require(!goalReached());\n', '\n', '    vault.refund(msg.sender);\n', '  }\n', '\n', '  // vault finalization task, called when owner calls finalize()\n', '  function finalization() internal {\n', '    if (goalReached()) {\n', '      token.mint(wallet, tokenSold.div(10)); //10% for owners, bounty, promo...\n', '      vault.close();\n', '    } else {\n', '      vault.enableRefunds();\n', '    }\n', '  }\n', '\n', '  function goalReached() public constant returns (bool) {\n', '    return weiRaised >= goal;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    \n', '  event Mint(address indexed to, uint256 amount);\n', '  \n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '  \n', '}\n', '\n', 'contract EstateCoin is MintableToken {\n', '    \n', '    string public constant name = "EstateCoin";\n', '    \n', '    string public constant symbol = "ESC";\n', '    \n', '    uint32 public constant decimals = 2;\n', '    \n', '}\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  function RefundVault(address _wallet) {\n', '    require(_wallet != 0x0);\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Closed;\n', '    Closed();\n', '    wallet.transfer(this.balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    RefundsEnabled();\n', '  }\n', '\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ESCCrowdsale\n', ' */\n', 'contract ESCCrowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  \n', '  //amount of sold money in wei\n', '  uint256 public tokenSold = 0;\n', '  \n', '  uint256 public cap;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  /**\n', '   * event for bonuses logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the bonus\n', '   * @param amount amount of bonuses\n', '   */\n', '  event TokenBonus(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  // minimum amount of funds to be raised in weis\n', '  uint256 public goal;\n', '\n', '  // refund vault used to hold funds while crowdsale is running\n', '  RefundVault public vault;\n', '\n', '  function ESCCrowdsale() {\n', '    startTime = 1506118400;//1506118400\n', '    endTime = 1507896000;\n', '    rate = 250;\n', '    wallet = msg.sender;\n', '    cap = 42550000000000000000000;\n', '    vault = new RefundVault(wallet);\n', '    goal = 2950000000000000000000;\n', '\n', '    //startTime = 1506118400; //4rd October 2017 12:00:00 GMT //1507118400\n', '    //endTime = 1507896000; //13th October 2017 12:00:00 GMT\n', '    //rate = 250; //250ESC = 1ETH\n', '    //wallet = msg.sender;\n', '    //uint256 _cap = 42550000000000000000000;\n', '    //uint256 _goal = 2950000000000000000000; // Minimal goal is 2950ETH = 4400ETH - 1450ETH(funding on Waves Platform)\n', '\n', '    require(startTime <= now);\n', '    require(endTime >= startTime);\n', '    require(rate > 0);\n', '    require(wallet != 0x0);\n', '    require(cap > 0);\n', '    require(goal > 0);\n', '\n', '    token = createTokenContract();\n', '  }\n', '\n', '  // creates the token to be sold.\n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return EstateCoin(0xE554056146fad6f2A7B5D5dbBb6f6763d58926c5);\n', '    //return new EstateCoin();\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '\n', '    tokenSold += msg.value.mul(rate);\n', '    uint256 bonus = 0;\n', '    if (now < 1507204800) {\n', '        bonus = tokenSold.div(20); //5%\n', '    } else if (now < 1507291200) {\n', '        bonus = tokenSold.div(25); //4%\n', '    } else if (now < 1507377600) {\n', '        bonus = tokenSold.div(33); //3%\n', '    } else if (now < 1507464000) {\n', '        bonus = tokenSold.div(50); //2%\n', '    } else if (now < 1507550400) {\n', '        bonus = tokenSold.div(100); //1%\n', '    }\n', '    \n', '    if (bonus > 0) {\n', '        token.mint(beneficiary, bonus);\n', '        TokenBonus(msg.sender, beneficiary, bonus);\n', '    }\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms...\n', "  // We're overriding the fund forwarding from Crowdsale.\n", '  // In addition to sending the funds, we want to call\n', '  // the RefundVault deposit function\n', '  function forwardFunds() internal {\n', '    //wallet.transfer(msg.value);\n', '    vault.deposit.value(msg.value)(msg.sender);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return withinPeriod && nonZeroPurchase && withinCap;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return (now > endTime) || capReached;\n', '  }\n', '    \n', '  /**\n', '   * @dev Must be called after crowdsale ends, to do some extra finalization\n', "   * work. Calls the contract's finalization function.\n", '   */\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '\n', '    finalization();\n', '    Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '  \n', '  // if crowdsale is unsuccessful, investors can claim refunds here\n', '  function claimRefund() public {\n', '    require(isFinalized);\n', '    require(!goalReached());\n', '\n', '    vault.refund(msg.sender);\n', '  }\n', '\n', '  // vault finalization task, called when owner calls finalize()\n', '  function finalization() internal {\n', '    if (goalReached()) {\n', '      token.mint(wallet, tokenSold.div(10)); //10% for owners, bounty, promo...\n', '      vault.close();\n', '    } else {\n', '      vault.enableRefunds();\n', '    }\n', '  }\n', '\n', '  function goalReached() public constant returns (bool) {\n', '    return weiRaised >= goal;\n', '  }\n', '\n', '}']
