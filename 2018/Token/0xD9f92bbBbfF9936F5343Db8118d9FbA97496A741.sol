['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '  /**\n', '   * SafeMath mul function\n', '   * @dev function for safe multiply\n', '   **/\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  \n', '  /**\n', '   * SafeMath div function\n', '   **/\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  \n', '  /**\n', '   * SafeMath sub function\n', '   **/\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  \n', '  /**\n', '   * SafeMath add function \n', '   **/\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simple version of ERC20 interface\n', ' * @notice https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public  returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title BasicToken\n', ' * @dev Basic version of Token, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '   * BasicToken transfer function\n', '   * @dev transfer token for a specified address\n', '   * @param _to address to transfer to.\n', '   * @param _value amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    //Safemath functions will throw if value is invalid\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * BasicToken balanceOf function \n', '   * @dev Gets the balance of the specified address.\n', '   * @param _owner address to get balance of.\n', '   * @return uint256 amount owned by the address.\n', '   */\n', '  function balanceOf(address _owner) public constant returns (uint256 bal) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '/**\n', ' *  @title ERC20 interface\n', ' *  @notice https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev Token to meet the ERC20 standard\n', ' * @notice https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract Token is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  \n', '  /**\n', '   * Token transferFrom function\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address to send tokens from\n', '   * @param _to address to transfer to\n', '   * @param _value amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '    // Safe math functions will throw if value invalid\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Token approve function\n', '   * @dev Approve address to spend amount of tokens\n', '   * @param _spender address to spend the funds.\n', '   * @param _value amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    // allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    // already 0 to mitigate the race condition described here:\n', '    // @notice https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    assert((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Token allowance method\n', '   * @dev Check that owners tokens is allowed to send to spender\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '/**\n', ' * @title IDEC Token\n', ' * @dev ERC20 Token with standard token functions.\n', ' */\n', 'contract IDECToken is Token {\n', '  string public constant NAME = "IDEC Token";\n', '  string public constant SYMBOL = "IDEC";\n', '  uint256 public constant DECIMALS = 2;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 500000000 * 10**2;\n', '\n', '  /**\n', '   * IDEC Token Constructor\n', '   * @dev Create and issue tokens to msg.sender.\n', '   */\n', '  constructor() public {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '}']