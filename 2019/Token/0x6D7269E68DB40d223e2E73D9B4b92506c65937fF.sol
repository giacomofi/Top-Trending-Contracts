['pragma solidity >=0.4.21 <0.6.0;\n', '\n', '/* openzeppelin-solidity - safemath */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'library AddressValidation {\n', '    function okAddress(address _address) internal pure returns (bool) {\n', '        if (_address == address(0)) return false;\n', '        //if (_address == address(1)) return false;\n', '        return true;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  //function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '/* openzeppelin-solidity ERC20 */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '  using AddressValidation for address;\n', '\n', '  mapping (address => uint256) public _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function setTotalSupply(uint256 amount) internal {\n', '      _totalSupply = amount;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    _transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender.okAddress(), "Address not valid on approve");\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender], "Transfer amount too high for what is allowed");\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender.okAddress(), "Address not valid on increase allowance");\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender.okAddress(), "Address not valid on decrease allowance");\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from], "Value too high to transfer from address");\n', '    require(to.okAddress(), "Address not valid to transfer to");\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account.okAddress(), "Address not valid for mint");\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', '    emit Transfer(address(0), account, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 value) internal {\n', '    require(account.okAddress(), "Address not valid for burn");\n', '    require(value <= _balances[account], "Value is more that balance for address for burn");\n', '\n', '    _totalSupply = _totalSupply.sub(value);\n', '    _balances[account] = _balances[account].sub(value);\n', '    emit Transfer(account, address(0), value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account, deducting from the sender&#39;s allowance for said account. Uses the\n', '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 value) internal {\n', '    require(value <= _allowed[account][msg.sender], "Value is higher than allowed to burn");\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      value);\n', '    _burn(account, value);\n', '  }\n', '}\n', '\n', '/* RLP token contract */\n', 'contract RLPToken is ERC20 {\n', '    string public name = "rLoop";\n', '    string public symbol = "RLP";\n', '    uint256 public decimals = 18;\n', '\n', '    constructor() public {\n', '    \n', '        setTotalSupply(1000000000000000000000000000);\n', '        _balances[address(0)] = totalSupply();\n', '\n', '        _transfer(address(0), msg.sender, totalSupply());\n', '        //emit Transfer(address(0), msg.sender, totalSupply());\n', '    }\n', '}']