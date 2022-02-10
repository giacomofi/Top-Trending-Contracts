['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * White Stone Coin\n', ' *\n', ' * When Art meets Blockchain, interesting things happen.\n', ' *\n', ' * This is a very simple token with the following properties:\n', ' *  - 10.000.000 coins max supply\n', ' *  - 5.000.000 coins mined for the company wallet\n', ' *  - Investor receives bonus coins from company wallet during bonus phases\n', ' * \n', ' * Visit https://whscoin.com for more information and tokenholder benefits. \n', ' */\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract WHSCoin is StandardToken, Ownable {\n', '  string public constant name = "White Stone Coin";\n', '  string public constant symbol = "WHS";\n', '  uint256 public constant decimals = 18;\n', '\n', '  uint256 public constant UNIT = 10 ** decimals;\n', '\n', '  address public companyWallet;\n', '  address public admin;\n', '\n', '  uint256 public tokenPrice = 0.01 ether;\n', '  uint256 public maxSupply = 10000000 * UNIT;\n', '  uint256 public totalSupply = 0;\n', '  uint256 public totalWeiReceived = 0;\n', '\n', '  uint256 startDate  = 1516856400; // 14:00 JST Jan 25 2018;\n', '  uint256 endDate    = 1522731600; // 14:00 JST Apr 3 2018;\n', '\n', '  uint256 bonus30end = 1518066000; // 14:00 JST Feb 8 2018;\n', '  uint256 bonus15end = 1519794000; // 14:00 JST Feb 28 2018;\n', '  uint256 bonus5end  = 1521003600; // 14:00 JST Mar 14 2018;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  event NewSale();\n', '\n', '  modifier onlyAdmin() {\n', '    require(msg.sender == admin);\n', '    _;\n', '  }\n', '\n', '  function WHSCoin(address _companyWallet, address _admin) public {\n', '    companyWallet = _companyWallet;\n', '    admin = _admin;\n', '    balances[companyWallet] = 5000000 * UNIT;\n', '    totalSupply = totalSupply.add(5000000 * UNIT);\n', '    Transfer(address(0x0), _companyWallet, 5000000 * UNIT);\n', '  }\n', '\n', '  function setAdmin(address _admin) public onlyOwner {\n', '    admin = _admin;\n', '  }\n', '\n', '  function calcBonus(uint256 _amount) internal view returns (uint256) {\n', '    uint256 bonusPercentage = 30;\n', '    if (now > bonus30end) bonusPercentage = 15;\n', '    if (now > bonus15end) bonusPercentage = 5;\n', '    if (now > bonus5end) bonusPercentage = 0;\n', '    return _amount * bonusPercentage / 100;\n', '  }\n', '\n', '  function buyTokens() public payable {\n', '    require(now < endDate);\n', '    require(now >= startDate);\n', '    require(msg.value > 0);\n', '\n', '    uint256 amount = msg.value * UNIT / tokenPrice;\n', '    uint256 bonus = calcBonus(msg.value) * UNIT / tokenPrice;\n', '    \n', '    totalSupply = totalSupply.add(amount);\n', '    \n', '    require(totalSupply <= maxSupply);\n', '\n', '    totalWeiReceived = totalWeiReceived.add(msg.value);\n', '\n', '    balances[msg.sender] = balances[msg.sender].add(amount);\n', '    \n', '    TokenPurchase(msg.sender, msg.sender, msg.value, amount);\n', '    \n', '    Transfer(address(0x0), msg.sender, amount);\n', '\n', '    if (bonus > 0) {\n', '      Transfer(companyWallet, msg.sender, bonus);\n', '      balances[companyWallet] -= bonus;\n', '      balances[msg.sender] = balances[msg.sender].add(bonus);\n', '    }\n', '\n', '    companyWallet.transfer(msg.value);\n', '  }\n', '\n', '  function() public payable {\n', '    buyTokens();\n', '  }\n', '\n', '  /***\n', '   * This function is used to transfer tokens that have been bought through other means (credit card, bitcoin, etc), and to burn tokens after the sale.\n', '   */\n', '  function sendTokens(address receiver, uint256 tokens) public onlyAdmin {\n', '    require(now < endDate);\n', '    require(now >= startDate);\n', '    require(totalSupply + tokens <= maxSupply);\n', '\n', '    balances[receiver] += tokens;\n', '    totalSupply += tokens;\n', '    Transfer(address(0x0), receiver, tokens);\n', '\n', '    uint256 bonus = calcBonus(tokens);\n', '    if (bonus > 0) {\n', '      sendBonus(receiver, bonus);\n', '    }\n', '  }\n', '\n', '  function sendBonus(address receiver, uint256 bonus) public onlyAdmin {\n', '    Transfer(companyWallet, receiver, bonus);\n', '    balances[companyWallet] = balances[companyWallet].sub(bonus);\n', '    balances[receiver] = balances[receiver].add(bonus);\n', '  }\n', '\n', '}']