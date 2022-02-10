['pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    \n', '  uint public constant startPreICO = 1521072000; // 15&#39;th March\n', '  uint public constant endPreICO = startPreICO + 31 days;\n', '\n', '  uint public constant startICOStage1 = 1526342400; // 15&#39;th May\n', '  uint public constant endICOStage1 = startICOStage1 + 3 days;\n', '\n', '  uint public constant startICOStage2 = 1526688000; // 19&#39;th May\n', '  uint public constant endICOStage2 = startICOStage2 + 5 days;\n', '\n', '  uint public constant startICOStage3 = 1527206400; // 25&#39;th May\n', '  uint public constant endICOStage3 = endICOStage2 + 6 days;\n', '\n', '  uint public constant startICOStage4 = 1527811200; // 1&#39;st June\n', '  uint public constant endICOStage4 = startICOStage4 + 7 days;\n', '\n', '  uint public constant startICOStage5 = 1528502400;\n', '  uint public endICOStage5 = startICOStage5 + 11 days;\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS not paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(now < startPreICO || now > endICOStage5);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is Token, Pausable {\n', '  using SafeMath for uint256;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    require(_to != address(0));\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '  function burn(uint256 _value) public {\n', '      require(_value > 0);\n', '      require(_value <= balances[msg.sender]);\n', '\n', '      address burner = msg.sender;\n', '      balances[burner] = balances[burner].sub(_value);\n', '      totalSupply = totalSupply.sub(_value);\n', '      Burn(burner, _value);\n', '  }\n', '}\n', '\n', 'contract MBEToken is BurnableToken {\n', '  string public constant name = "MoBee";\n', '  string public constant symbol = "MBE";\n', '  uint8 public constant decimals = 18;\n', '  address public tokenWallet;\n', '  address public founderWallet;\n', '  address public bountyWallet;\n', '  address public multisig = 0xA74246dC71c0849acCd564976b3093B0B2a522C3;\n', '  uint public currentFundrise = 0;\n', '  uint public raisedEthers = 0;\n', '\n', '  uint public constant INITIAL_SUPPLY = 20000000 ether;\n', '  \n', '  uint256 constant THOUSAND = 1000;\n', '  uint256 constant TEN_THOUSAND = 10000;\n', '  uint public tokenRate = THOUSAND.div(9); // tokens per 1 ether ( 1 ETH / 0.009 ETH = 111.11 MBE )\n', '  uint public tokenRate30 = tokenRate.mul(100).div(70); // tokens per 1 ether with 30% discount\n', '  uint public tokenRate20 = tokenRate.mul(100).div(80); // tokens per 1 ether with 20% discount\n', '  uint public tokenRate15 = tokenRate.mul(100).div(85); // tokens per 1 ether with 15% discount\n', '  uint public tokenRate10 = tokenRate.mul(100).div(90); // tokens per 1 ether with 10% discount\n', '  uint public tokenRate5 = tokenRate.mul(100).div(95); // tokens per 1 ether with 5% discount\n', '\n', '  /**\n', '    * @dev Constructor that gives msg.sender all of existing tokens.\n', '    */\n', '  function MBEToken(address tokenOwner, address founder, address bounty) public {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[tokenOwner] += INITIAL_SUPPLY / 100 * 85;\n', '    balances[founder] += INITIAL_SUPPLY / 100 * 10;\n', '    balances[bounty] += INITIAL_SUPPLY / 100 * 5;\n', '    tokenWallet = tokenOwner;\n', '    founderWallet = founder;\n', '    bountyWallet = bounty;\n', '    Transfer(0x0, tokenOwner, balances[tokenOwner]);\n', '    Transfer(0x0, founder, balances[founder]);\n', '    Transfer(0x0, bounty, balances[bounty]);\n', '  }\n', '  \n', '  function setupTokenRate(uint newTokenRate) public onlyOwner {\n', '    tokenRate = newTokenRate;\n', '    tokenRate30 = tokenRate.mul(100).div(70); // tokens per 1 ether with 30% discount\n', '    tokenRate20 = tokenRate.mul(100).div(80); // tokens per 1 ether with 20% discount\n', '    tokenRate15 = tokenRate.mul(100).div(85); // tokens per 1 ether with 15% discount\n', '    tokenRate10 = tokenRate.mul(100).div(90); // tokens per 1 ether with 10% discount\n', '    tokenRate5 = tokenRate.mul(100).div(95); // tokens per 1 ether with 5% discount\n', '  }\n', '  \n', '  function setupFinal(uint finalDate) public onlyOwner returns(bool) {\n', '    endICOStage5 = finalDate;\n', '    return true;\n', '  }\n', '\n', '  function sellManually(address _to, uint amount) public onlyOwner returns(bool) {\n', '    uint tokens = calcTokens(amount);\n', '    uint256 balance = balanceOf(tokenWallet);\n', '    if (balance < tokens) {\n', '      sendTokens(_to, balance);\n', '    } else {\n', '      sendTokens(_to, tokens);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function () payable public {\n', '    if (!isTokenSale()) revert();\n', '    buyTokens(msg.value);\n', '  }\n', '  \n', '  function isTokenSale() public view returns (bool) {\n', '    if (now >= startPreICO && now < endICOStage5) {\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function buyTokens(uint amount) internal {\n', '    uint tokens = calcTokens(amount);  \n', '    safeSend(tokens);\n', '  }\n', '  \n', '  function calcTokens(uint amount) public view returns(uint) {\n', '    uint rate = extraRate(amount, tokenRate);\n', '    uint tokens = amount.mul(rate);\n', '    if (now >= startPreICO && now < endPreICO) {\n', '      rate = extraRate(amount, tokenRate30);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage1 && now < endICOStage1) {\n', '      rate = extraRate(amount, tokenRate20);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage2 && now < endICOStage2) {\n', '      rate = extraRate(amount, tokenRate15);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage3 && now < endICOStage3) {\n', '      rate = extraRate(amount, tokenRate10);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage4 && now < endICOStage4) {\n', '      rate = extraRate(amount, tokenRate5);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage5 && now < endICOStage5) {\n', '      return tokens;\n', '    }\n', '  }\n', '\n', '  function extraRate(uint amount, uint rate) public pure returns (uint) {\n', '    return ( ( rate * 10 ** 20 ) / ( 100 - extraDiscount(amount) ) ) / ( 10 ** 18 );\n', '  }\n', '\n', '  function extraDiscount(uint amount) public pure returns(uint) {\n', '    if ( 3 ether <= amount && amount <= 5 ether ) {\n', '      return 5;\n', '    } else if ( 5 ether < amount && amount <= 10 ether ) {\n', '      return 7;\n', '    } else if ( 10 ether < amount && amount <= 20 ether ) {\n', '      return 10;\n', '    } else if ( 20 ether < amount ) {\n', '      return 15;\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  function safeSend(uint tokens) private {\n', '    uint256 balance = balanceOf(tokenWallet);\n', '    if (balance < tokens) {\n', '      uint toReturn = tokenRate.mul(tokens.sub(balance));\n', '      sendTokens(msg.sender, balance);\n', '      msg.sender.transfer(toReturn);\n', '      multisig.transfer(msg.value.sub(toReturn));\n', '      raisedEthers += msg.value.sub(toReturn);\n', '    } else {\n', '      sendTokens(msg.sender, tokens);\n', '      multisig.transfer(msg.value);\n', '      raisedEthers += msg.value;\n', '    }\n', '  }\n', '\n', '  function sendTokens(address _to, uint tokens) private {\n', '    balances[tokenWallet] = balances[tokenWallet].sub(tokens);\n', '    balances[_to] += tokens;\n', '    Transfer(tokenWallet, _to, tokens);\n', '    currentFundrise += tokens;\n', '  }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    \n', "  uint public constant startPreICO = 1521072000; // 15'th March\n", '  uint public constant endPreICO = startPreICO + 31 days;\n', '\n', "  uint public constant startICOStage1 = 1526342400; // 15'th May\n", '  uint public constant endICOStage1 = startICOStage1 + 3 days;\n', '\n', "  uint public constant startICOStage2 = 1526688000; // 19'th May\n", '  uint public constant endICOStage2 = startICOStage2 + 5 days;\n', '\n', "  uint public constant startICOStage3 = 1527206400; // 25'th May\n", '  uint public constant endICOStage3 = endICOStage2 + 6 days;\n', '\n', "  uint public constant startICOStage4 = 1527811200; // 1'st June\n", '  uint public constant endICOStage4 = startICOStage4 + 7 days;\n', '\n', '  uint public constant startICOStage5 = 1528502400;\n', '  uint public endICOStage5 = startICOStage5 + 11 days;\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS not paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(now < startPreICO || now > endICOStage5);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is Token, Pausable {\n', '  using SafeMath for uint256;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    require(_to != address(0));\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '  function burn(uint256 _value) public {\n', '      require(_value > 0);\n', '      require(_value <= balances[msg.sender]);\n', '\n', '      address burner = msg.sender;\n', '      balances[burner] = balances[burner].sub(_value);\n', '      totalSupply = totalSupply.sub(_value);\n', '      Burn(burner, _value);\n', '  }\n', '}\n', '\n', 'contract MBEToken is BurnableToken {\n', '  string public constant name = "MoBee";\n', '  string public constant symbol = "MBE";\n', '  uint8 public constant decimals = 18;\n', '  address public tokenWallet;\n', '  address public founderWallet;\n', '  address public bountyWallet;\n', '  address public multisig = 0xA74246dC71c0849acCd564976b3093B0B2a522C3;\n', '  uint public currentFundrise = 0;\n', '  uint public raisedEthers = 0;\n', '\n', '  uint public constant INITIAL_SUPPLY = 20000000 ether;\n', '  \n', '  uint256 constant THOUSAND = 1000;\n', '  uint256 constant TEN_THOUSAND = 10000;\n', '  uint public tokenRate = THOUSAND.div(9); // tokens per 1 ether ( 1 ETH / 0.009 ETH = 111.11 MBE )\n', '  uint public tokenRate30 = tokenRate.mul(100).div(70); // tokens per 1 ether with 30% discount\n', '  uint public tokenRate20 = tokenRate.mul(100).div(80); // tokens per 1 ether with 20% discount\n', '  uint public tokenRate15 = tokenRate.mul(100).div(85); // tokens per 1 ether with 15% discount\n', '  uint public tokenRate10 = tokenRate.mul(100).div(90); // tokens per 1 ether with 10% discount\n', '  uint public tokenRate5 = tokenRate.mul(100).div(95); // tokens per 1 ether with 5% discount\n', '\n', '  /**\n', '    * @dev Constructor that gives msg.sender all of existing tokens.\n', '    */\n', '  function MBEToken(address tokenOwner, address founder, address bounty) public {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[tokenOwner] += INITIAL_SUPPLY / 100 * 85;\n', '    balances[founder] += INITIAL_SUPPLY / 100 * 10;\n', '    balances[bounty] += INITIAL_SUPPLY / 100 * 5;\n', '    tokenWallet = tokenOwner;\n', '    founderWallet = founder;\n', '    bountyWallet = bounty;\n', '    Transfer(0x0, tokenOwner, balances[tokenOwner]);\n', '    Transfer(0x0, founder, balances[founder]);\n', '    Transfer(0x0, bounty, balances[bounty]);\n', '  }\n', '  \n', '  function setupTokenRate(uint newTokenRate) public onlyOwner {\n', '    tokenRate = newTokenRate;\n', '    tokenRate30 = tokenRate.mul(100).div(70); // tokens per 1 ether with 30% discount\n', '    tokenRate20 = tokenRate.mul(100).div(80); // tokens per 1 ether with 20% discount\n', '    tokenRate15 = tokenRate.mul(100).div(85); // tokens per 1 ether with 15% discount\n', '    tokenRate10 = tokenRate.mul(100).div(90); // tokens per 1 ether with 10% discount\n', '    tokenRate5 = tokenRate.mul(100).div(95); // tokens per 1 ether with 5% discount\n', '  }\n', '  \n', '  function setupFinal(uint finalDate) public onlyOwner returns(bool) {\n', '    endICOStage5 = finalDate;\n', '    return true;\n', '  }\n', '\n', '  function sellManually(address _to, uint amount) public onlyOwner returns(bool) {\n', '    uint tokens = calcTokens(amount);\n', '    uint256 balance = balanceOf(tokenWallet);\n', '    if (balance < tokens) {\n', '      sendTokens(_to, balance);\n', '    } else {\n', '      sendTokens(_to, tokens);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function () payable public {\n', '    if (!isTokenSale()) revert();\n', '    buyTokens(msg.value);\n', '  }\n', '  \n', '  function isTokenSale() public view returns (bool) {\n', '    if (now >= startPreICO && now < endICOStage5) {\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function buyTokens(uint amount) internal {\n', '    uint tokens = calcTokens(amount);  \n', '    safeSend(tokens);\n', '  }\n', '  \n', '  function calcTokens(uint amount) public view returns(uint) {\n', '    uint rate = extraRate(amount, tokenRate);\n', '    uint tokens = amount.mul(rate);\n', '    if (now >= startPreICO && now < endPreICO) {\n', '      rate = extraRate(amount, tokenRate30);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage1 && now < endICOStage1) {\n', '      rate = extraRate(amount, tokenRate20);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage2 && now < endICOStage2) {\n', '      rate = extraRate(amount, tokenRate15);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage3 && now < endICOStage3) {\n', '      rate = extraRate(amount, tokenRate10);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage4 && now < endICOStage4) {\n', '      rate = extraRate(amount, tokenRate5);\n', '      tokens = amount.mul(rate);\n', '      return tokens;\n', '    } else if (now >= startICOStage5 && now < endICOStage5) {\n', '      return tokens;\n', '    }\n', '  }\n', '\n', '  function extraRate(uint amount, uint rate) public pure returns (uint) {\n', '    return ( ( rate * 10 ** 20 ) / ( 100 - extraDiscount(amount) ) ) / ( 10 ** 18 );\n', '  }\n', '\n', '  function extraDiscount(uint amount) public pure returns(uint) {\n', '    if ( 3 ether <= amount && amount <= 5 ether ) {\n', '      return 5;\n', '    } else if ( 5 ether < amount && amount <= 10 ether ) {\n', '      return 7;\n', '    } else if ( 10 ether < amount && amount <= 20 ether ) {\n', '      return 10;\n', '    } else if ( 20 ether < amount ) {\n', '      return 15;\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  function safeSend(uint tokens) private {\n', '    uint256 balance = balanceOf(tokenWallet);\n', '    if (balance < tokens) {\n', '      uint toReturn = tokenRate.mul(tokens.sub(balance));\n', '      sendTokens(msg.sender, balance);\n', '      msg.sender.transfer(toReturn);\n', '      multisig.transfer(msg.value.sub(toReturn));\n', '      raisedEthers += msg.value.sub(toReturn);\n', '    } else {\n', '      sendTokens(msg.sender, tokens);\n', '      multisig.transfer(msg.value);\n', '      raisedEthers += msg.value;\n', '    }\n', '  }\n', '\n', '  function sendTokens(address _to, uint tokens) private {\n', '    balances[tokenWallet] = balances[tokenWallet].sub(tokens);\n', '    balances[_to] += tokens;\n', '    Transfer(tokenWallet, _to, tokens);\n', '    currentFundrise += tokens;\n', '  }\n', '}']