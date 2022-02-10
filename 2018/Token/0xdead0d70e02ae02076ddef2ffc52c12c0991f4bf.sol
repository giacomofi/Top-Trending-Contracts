['pragma solidity ^0.4.12;\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title SafeMath\n', '\n', ' * @dev Math operations with safety checks that throw on error\n', '\n', ' */\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    uint256 c = a * b;\n', '\n', '    assert(a == 0 || c / a == b);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\n', '    uint256 c = a / b;\n', '\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '\n', '  }\n', '\n', '\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    assert(b <= a);\n', '\n', '    return a - b;\n', '\n', '  }\n', '\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\n', '    uint256 c = a + b;\n', '\n', '    assert(c >= a);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Ownable\n', '\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', '\n', ' * functions, this simplifies the implementation of "user permissions".\n', '\n', ' */\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '\n', '\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '\n', '   * account.\n', '\n', '   */\n', '\n', '  function Ownable() {\n', '\n', '    owner = msg.sender;\n', '\n', '  }\n', '\n', '\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Throws if called by any account other than the owner.\n', '\n', '   */\n', '\n', '  modifier onlyOwner() {\n', '\n', '    require(msg.sender == owner);\n', '\n', '    _;\n', '\n', '  }\n', '\n', '\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '\n', '   * @param newOwner The address to transfer ownership to.\n', '\n', '   */\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '\n', '    require(newOwner != address(0));\n', '\n', '    OwnershipTransferred(owner, newOwner);\n', '\n', '    owner = newOwner;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title ERC20Basic\n', '\n', ' * @dev Simpler version of ERC20 interface\n', '\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', '\n', ' */\n', '\n', 'contract ERC20Basic {\n', '\n', '  uint256 public totalSupply;\n', '\n', '  function balanceOf(address who) public constant returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Basic token\n', '\n', ' * @dev Basic version of StandardToken, with no allowances.\n', '\n', ' */\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '  using SafeMath for uint256;\n', '\n', '\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev transfer token for a specified address\n', '\n', '  * @param _to The address to transfer to.\n', '\n', '  * @param _value The amount to be transferred.\n', '\n', '  */\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '\n', '    require(_to != address(0));\n', '\n', '\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '  * @dev Gets the balance of the specified address.\n', '\n', '  * @param _owner The address to query the the balance of.\n', '\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '\n', '  */\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '\n', '    return balances[_owner];\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title ERC20 interface\n', '\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', '\n', ' */\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', '\n', ' * @title Standard ERC20 token\n', '\n', ' *\n', '\n', ' * @dev Implementation of the basic standard token.\n', '\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', '\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '\n', ' */\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Transfer tokens from one address to another\n', '\n', '   * @param _from address The address which you want to send tokens from\n', '\n', '   * @param _to address The address which you want to transfer to\n', '\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '\n', '   */\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '\n', '    require(_to != address(0));\n', '\n', '\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '\n', '    // require (_value <= _allowance);\n', '\n', '\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '\n', '    Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\n', '   *\n', '\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\n', '   * @param _spender The address which will spend the funds.\n', '\n', '   * @param _value The amount of tokens to be spent.\n', '\n', '   */\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '\n', '    Approval(msg.sender, _spender, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\n', '   * @param _owner address The address which owns the funds.\n', '\n', '   * @param _spender address The address which will spend the funds.\n', '\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '\n', '   */\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '\n', '    return allowed[_owner][_spender];\n', '\n', '  }\n', '\n', '\n', '\n', '  /**\n', '\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '\n', '   * the first transaction is mined)\n', '\n', '   * From MonolithDAO Token.sol\n', '\n', '   */\n', '\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '\n', '    returns (bool success) {\n', '\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '\n', '    returns (bool success) {\n', '\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '\n', '    if (_subtractedValue > oldValue) {\n', '\n', '      allowed[msg.sender][_spender] = 0;\n', '\n', '    } else {\n', '\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\n', '    }\n', '\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract KachingCoin is StandardToken, Ownable {\n', '\n', '\n', '\n', '    string public constant name = "KachingCoin";\n', '\n', '    string public constant symbol = "KAC";\n', '\n', '    uint public constant decimals = 18;\n', '\n', '    // there is no problem in using * here instead of .mul()\n', '\n', '    uint256 public constant initialSupply = 247000000 * (10 ** uint256(decimals));\n', '\n', '\n', '\n', '    // Constructors\n', '\n', '    function KachingCoin () {\n', '\n', '        totalSupply = initialSupply;\n', '\n', '        balances[msg.sender] = initialSupply; // Send all tokens to owner\n', '\n', '    }\n', '\n', '\n', '\n', '}']