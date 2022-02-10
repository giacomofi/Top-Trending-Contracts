['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * SafeMath Library\n', ' * Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * ERC20Basic Contract\n', ' * Simpler version of ERC20 interface\n', ' * Reference: https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * Basic Token Contract\n', ' * Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * Transfer token for a specified address\n', '  *\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  * @return bool\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * Gets the balance of the specified address.\n', '  *\n', '  * @param _owner The address to query the the balance of.\n', '  * @return uint256\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '/**\n', ' * ERC20 Interface\n', ' * Reference: https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * Standard ERC20 token\n', ' *\n', ' * Implementation of the basic standard token.\n', ' * Reference: https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * Transfer tokens from one address to another\n', '   *\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   * @return bool\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   * @return bool\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    // allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    // already 0 to mitigate the race condition described here:\n', '    // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Function to check the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return uint256\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * Token Contract\n', ' *\n', ' * Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `StandardToken` functions.\n', ' */\n', 'contract Token is StandardToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public initialSupply;\n', '  uint256 public decimals = 18;\n', '\n', '  /**\n', '   * Contructor that gives msg.sender all of existing tokens.\n', '   */\n', '  function Token(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {\n', '    totalSupply = _initialSupply * 10**18;\n', '    balances[msg.sender] = _initialSupply * 10**18;\n', '    initialSupply = _initialSupply * 10**18;\n', '\n', '    name = _tokenName;\n', '    symbol = _tokenSymbol;\n', '  }\n', '}']