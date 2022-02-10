['pragma solidity ^0.4.24;\n', '\n', '// File: contracts/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner(msg.sender));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if the account is the owner of the contract.\n', '   */\n', '  function isOwner(address account) public view returns(bool) {\n', '    return account == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner)\n', '    public\n', '    onlyOwner\n', '  {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner)\n', '    internal\n', '  {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Paused();\n', '  event Unpaused();\n', '\n', '  bool private _paused;\n', '\n', '  constructor() public {\n', '    _paused = false;\n', '  }\n', '\n', '  /**\n', '   * @return true if the contract is paused, false otherwise.\n', '   */\n', '  function paused() public view returns(bool) {\n', '    return _paused;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause()\n', '    public\n', '    onlyOwner\n', '    whenNotPaused\n', '  {\n', '    _paused = true;\n', '    emit Paused();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause()\n', '    public\n', '    onlyOwner\n', '    whenPaused\n', '  {\n', '    _paused = false;\n', '    emit Unpaused();\n', '  }\n', '}\n', '\n', '// File: contracts/Operable.sol\n', '\n', '/**\n', ' * @title Operable\n', ' * @dev Base contract that allows the owner to enforce access control over certain\n', ' * operations by adding or removing operator addresses.\n', ' */\n', 'contract Operable is Pausable {\n', '  event OperatorAdded(address indexed account);\n', '  event OperatorRemoved(address indexed account);\n', '\n', '  mapping (address => bool) private _operators;\n', '\n', '  constructor() public {\n', '    _addOperator(msg.sender);\n', '  }\n', '\n', '  modifier onlyOperator() {\n', '    require(isOperator(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isOperator(address account)\n', '    public\n', '    view\n', '    returns (bool) \n', '  {\n', '    require(account != address(0));\n', '    return _operators[account];\n', '  }\n', '\n', '  function addOperator(address account)\n', '    public\n', '    onlyOwner\n', '  {\n', '    _addOperator(account);\n', '  }\n', '\n', '  function removeOperator(address account)\n', '    public\n', '    onlyOwner\n', '  {\n', '    _removeOperator(account);\n', '  }\n', '\n', '  function _addOperator(address account)\n', '    internal\n', '  {\n', '    require(account != address(0));\n', '    _operators[account] = true;\n', '    emit OperatorAdded(account);\n', '  }\n', '\n', '  function _removeOperator(address account)\n', '    internal\n', '  {\n', '    require(account != address(0));\n', '    _operators[account] = false;\n', '    emit OperatorRemoved(account);\n', '  }\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: contracts/ManagedToken.sol\n', '\n', 'contract ManagedToken is Operable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '  uint256 private _totalSupply;\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param account The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address account) public view returns (uint256) {\n', '    return _balances[account];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public\n', '    onlyOperator\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', "   * @dev Specifically prohibits token transfers from msg.sender's address\n", '   * @param to address The address receiving the token transfer\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  // function transfer(address to, uint256 value)\n', '  //   public\n', '  //   whenNotPaused\n', '  //   returns (bool)\n', '  // {\n', '  //   revert();\n', '  // }\n', '\n', '  /**\n', '   * @dev Mints new tokens to the target address.\n', '   * @param to The address that will receive the minted tokens.\n', '   * @param value The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address to, uint256 value)\n', '    public\n', '    onlyOperator\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    _mint(to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '   * @param from address The address which you want to send tokens from\n', '   * @param value uint256 The amount of token to be burned\n', '   */\n', '  function burn(address from, uint256 value)\n', '    public\n', '    onlyOperator\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    _burn(from, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', '    emit Transfer(address(0), account, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    require(value <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(value);\n', '    _balances[account] = _balances[account].sub(value);\n', '    emit Transfer(account, address(0), value);\n', '  }\n', '}\n', '\n', '// File: contracts/XFTToken.sol\n', '\n', 'contract XFTToken is ManagedToken {\n', "  string public constant name = 'XFT Token';\n", "  string public constant symbol = 'XFT';\n", '  uint8 public constant decimals = 18;\n', "  string public constant version = '1.0';\n", '}']