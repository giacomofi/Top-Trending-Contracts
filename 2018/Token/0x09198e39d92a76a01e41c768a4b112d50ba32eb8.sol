['pragma solidity ^0.4.18;\n', '\n', ' \n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '//Token parameters\n', '\n', 'contract AxtrustICOToken is MintableToken{\n', '\tstring public constant name = "AXTRUST";\n', '\tstring public constant symbol = "TRU";\n', '\tuint public constant decimals = 18;\n', '}\n', '\n', '/**\n', ' * @title AxtrustICO\n', ' * @dev AxtrustICO is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to an owner\n', ' * as they arrive.\n', ' */\n', 'contract AxtrustICO is Ownable {\n', '  string public constant name = "AxtrustICO";\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  uint256 public startTime = 0;\n', '  uint256 public endTime;\n', '  bool public isFinished = false;\n', '\n', '  // how many ETH cost 1000000 TRU. rate = 1000000 TRU/ETH. It&#39;s always an integer!\n', '  //formula for rate: rate = 1000000 * (TRU in USD) / (ETH in USD)\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  \n', '  string public saleStatus = "Not started";\n', '  \n', '  uint public tokensMinted = 0;\n', '  \n', '  uint public minimumSupply = 1; //minimum token amount to sale at one transaction\n', '\n', '  uint public constant HARD_CAP_TOKENS = 800000000 * 10**18;\n', '\n', '  event TokenPurchase(address indexed purchaser, uint256 value, uint integer_value, uint256 amount, uint integer_amount, uint256 tokensMinted);\n', '  event TokenIssue(address indexed purchaser, uint256 amount, uint integer_amount, uint256 tokensMinted);\n', '\n', '\n', '  function AxtrustICO(uint256 _rate) public {\n', '    require(_rate > 0);\n', '\trequire (_rate < 2000);\n', '\n', '    token = createTokenContract();\n', '    startTime = now;\n', '    rate = _rate;\n', '\tsaleStatus = "AxTrust ICO is running";\n', '  }\n', '  \n', '  \n', '  function stopICO() public onlyOwner {\n', '\tisFinished = true;\n', '\tendTime = now;\n', '\tsaleStatus = "AxTrust ICO is finished";\n', '  }\n', '  \n', '  function setRate(uint _rate) public onlyOwner {\n', '\trequire (_rate > 0);\n', '\trequire (_rate < 2000);\n', '\trate = _rate;\n', '  }\n', '\n', '  function createTokenContract() internal returns (AxtrustICOToken) {\n', '    return new AxtrustICOToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens();\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens() public payable {\n', '\trequire(!isFinished);\n', '    require(startTime > 0);\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(1000000).div(rate);\n', '    \n', '\trequire(tokens >= minimumSupply * 10**18);\n', '    require(tokensMinted.add(tokens) <= HARD_CAP_TOKENS);\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(msg.sender, tokens);\n', '\ttokensMinted = tokensMinted.add(tokens);\n', '    TokenPurchase(msg.sender, weiAmount, weiAmount.div(10**18), tokens, tokens.div(10**18), tokensMinted.div(10**18));\n', '\n', '    owner.transfer(msg.value);\n', '\t\n', '\tif (tokensMinted == HARD_CAP_TOKENS) {\n', '\t\tisFinished = true;\n', '\t\tendTime = now;\n', '\t\tsaleStatus = "Hardcap reached!";\n', '\t}\n', '\t\n', '\t\n', '  }\n', '  \n', '  //Owner can issue tokens for investors, who made fiat contribution\n', '  function issueTokens(address _to, uint _amount) public onlyOwner{\n', '  \trequire(!isFinished);\n', '\n', '\tuint amount = _amount * 10**18;\n', '\trequire(tokensMinted.add(amount) <= HARD_CAP_TOKENS);\n', '\n', '\ttoken.mint(_to, amount);\n', '\ttokensMinted = tokensMinted.add(amount);\n', '\tTokenIssue(_to, amount, amount.div( 10**18), tokensMinted.div(10**18));\n', '\n', '\t\n', '\tif (tokensMinted == HARD_CAP_TOKENS) {\n', '\t\tisFinished = true;\n', '\t\tendTime = now;\n', '\t\tsaleStatus = "Hardcap reached!";\n', '\t}\n', '\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', ' \n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '//Token parameters\n', '\n', 'contract AxtrustICOToken is MintableToken{\n', '\tstring public constant name = "AXTRUST";\n', '\tstring public constant symbol = "TRU";\n', '\tuint public constant decimals = 18;\n', '}\n', '\n', '/**\n', ' * @title AxtrustICO\n', ' * @dev AxtrustICO is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to an owner\n', ' * as they arrive.\n', ' */\n', 'contract AxtrustICO is Ownable {\n', '  string public constant name = "AxtrustICO";\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  uint256 public startTime = 0;\n', '  uint256 public endTime;\n', '  bool public isFinished = false;\n', '\n', "  // how many ETH cost 1000000 TRU. rate = 1000000 TRU/ETH. It's always an integer!\n", '  //formula for rate: rate = 1000000 * (TRU in USD) / (ETH in USD)\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  \n', '  string public saleStatus = "Not started";\n', '  \n', '  uint public tokensMinted = 0;\n', '  \n', '  uint public minimumSupply = 1; //minimum token amount to sale at one transaction\n', '\n', '  uint public constant HARD_CAP_TOKENS = 800000000 * 10**18;\n', '\n', '  event TokenPurchase(address indexed purchaser, uint256 value, uint integer_value, uint256 amount, uint integer_amount, uint256 tokensMinted);\n', '  event TokenIssue(address indexed purchaser, uint256 amount, uint integer_amount, uint256 tokensMinted);\n', '\n', '\n', '  function AxtrustICO(uint256 _rate) public {\n', '    require(_rate > 0);\n', '\trequire (_rate < 2000);\n', '\n', '    token = createTokenContract();\n', '    startTime = now;\n', '    rate = _rate;\n', '\tsaleStatus = "AxTrust ICO is running";\n', '  }\n', '  \n', '  \n', '  function stopICO() public onlyOwner {\n', '\tisFinished = true;\n', '\tendTime = now;\n', '\tsaleStatus = "AxTrust ICO is finished";\n', '  }\n', '  \n', '  function setRate(uint _rate) public onlyOwner {\n', '\trequire (_rate > 0);\n', '\trequire (_rate < 2000);\n', '\trate = _rate;\n', '  }\n', '\n', '  function createTokenContract() internal returns (AxtrustICOToken) {\n', '    return new AxtrustICOToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens();\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens() public payable {\n', '\trequire(!isFinished);\n', '    require(startTime > 0);\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(1000000).div(rate);\n', '    \n', '\trequire(tokens >= minimumSupply * 10**18);\n', '    require(tokensMinted.add(tokens) <= HARD_CAP_TOKENS);\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(msg.sender, tokens);\n', '\ttokensMinted = tokensMinted.add(tokens);\n', '    TokenPurchase(msg.sender, weiAmount, weiAmount.div(10**18), tokens, tokens.div(10**18), tokensMinted.div(10**18));\n', '\n', '    owner.transfer(msg.value);\n', '\t\n', '\tif (tokensMinted == HARD_CAP_TOKENS) {\n', '\t\tisFinished = true;\n', '\t\tendTime = now;\n', '\t\tsaleStatus = "Hardcap reached!";\n', '\t}\n', '\t\n', '\t\n', '  }\n', '  \n', '  //Owner can issue tokens for investors, who made fiat contribution\n', '  function issueTokens(address _to, uint _amount) public onlyOwner{\n', '  \trequire(!isFinished);\n', '\n', '\tuint amount = _amount * 10**18;\n', '\trequire(tokensMinted.add(amount) <= HARD_CAP_TOKENS);\n', '\n', '\ttoken.mint(_to, amount);\n', '\ttokensMinted = tokensMinted.add(amount);\n', '\tTokenIssue(_to, amount, amount.div( 10**18), tokensMinted.div(10**18));\n', '\n', '\t\n', '\tif (tokensMinted == HARD_CAP_TOKENS) {\n', '\t\tisFinished = true;\n', '\t\tendTime = now;\n', '\t\tsaleStatus = "Hardcap reached!";\n', '\t}\n', '\n', '  }\n', '\n', '}']
