['// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(string name, string symbol, uint8 decimals) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  /**\n', '   * @return the name of the token.\n', '   */\n', '  function name() public view returns(string) {\n', '    return _name;\n', '  }\n', '\n', '  /**\n', '   * @return the symbol of the token.\n', '   */\n', '  function symbol() public view returns(string) {\n', '    return _symbol;\n', '  }\n', '\n', '  /**\n', '   * @return the number of decimals of the token.\n', '   */\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    _transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', '    emit Transfer(address(0), account, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    require(value <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(value);\n', '    _balances[account] = _balances[account].sub(value);\n', '    emit Transfer(account, address(0), value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 value) internal {\n', '    require(value <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      value);\n', '    _burn(account, value);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/Roles.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an account access to this role\n', '   */\n', '  function add(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(!has(role, account));\n', '\n', '    role.bearer[account] = true;\n', '  }\n', '\n', '  /**\n', "   * @dev remove an account's access to this role\n", '   */\n', '  function remove(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(has(role, account));\n', '\n', '    role.bearer[account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address account)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    require(account != address(0));\n', '    return role.bearer[account];\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', 'contract PauserRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event PauserAdded(address indexed account);\n', '  event PauserRemoved(address indexed account);\n', '\n', '  Roles.Role private pausers;\n', '\n', '  constructor() internal {\n', '    _addPauser(msg.sender);\n', '  }\n', '\n', '  modifier onlyPauser() {\n', '    require(isPauser(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isPauser(address account) public view returns (bool) {\n', '    return pausers.has(account);\n', '  }\n', '\n', '  function addPauser(address account) public onlyPauser {\n', '    _addPauser(account);\n', '  }\n', '\n', '  function renouncePauser() public {\n', '    _removePauser(msg.sender);\n', '  }\n', '\n', '  function _addPauser(address account) internal {\n', '    pausers.add(account);\n', '    emit PauserAdded(account);\n', '  }\n', '\n', '  function _removePauser(address account) internal {\n', '    pausers.remove(account);\n', '    emit PauserRemoved(account);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '  event Paused(address account);\n', '  event Unpaused(address account);\n', '\n', '  bool private _paused;\n', '\n', '  constructor() internal {\n', '    _paused = false;\n', '  }\n', '\n', '  /**\n', '   * @return true if the contract is paused, false otherwise.\n', '   */\n', '  function paused() public view returns(bool) {\n', '    return _paused;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyPauser whenNotPaused {\n', '    _paused = true;\n', '    emit Paused(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyPauser whenPaused {\n', '    _paused = false;\n', '    emit Unpaused(msg.sender);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev ERC20 modified with pausable transfers.\n', ' **/\n', 'contract ERC20Pausable is ERC20, Pausable {\n', '\n', '  function transfer(\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transfer(to, value);\n', '  }\n', '\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(from, to, value);\n', '  }\n', '\n', '  function approve(\n', '    address spender,\n', '    uint256 value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(spender, value);\n', '  }\n', '\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseAllowance(spender, addedValue);\n', '  }\n', '\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseAllowance(spender, subtractedValue);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', 'contract MinterRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event MinterAdded(address indexed account);\n', '  event MinterRemoved(address indexed account);\n', '\n', '  Roles.Role private minters;\n', '\n', '  constructor() internal {\n', '    _addMinter(msg.sender);\n', '  }\n', '\n', '  modifier onlyMinter() {\n', '    require(isMinter(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isMinter(address account) public view returns (bool) {\n', '    return minters.has(account);\n', '  }\n', '\n', '  function addMinter(address account) public onlyMinter {\n', '    _addMinter(account);\n', '  }\n', '\n', '  function renounceMinter() public {\n', '    _removeMinter(msg.sender);\n', '  }\n', '\n', '  function _addMinter(address account) internal {\n', '    minters.add(account);\n', '    emit MinterAdded(account);\n', '  }\n', '\n', '  function _removeMinter(address account) internal {\n', '    minters.remove(account);\n', '    emit MinterRemoved(account);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Mintable\n', ' * @dev ERC20 minting logic\n', ' */\n', 'contract ERC20Mintable is ERC20, MinterRole {\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param to The address that will receive the minted tokens.\n', '   * @param value The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    onlyMinter\n', '    returns (bool)\n', '  {\n', '    _mint(to, value);\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: contracts/InterpinesToken.sol\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', '\n', '\n', '\n', '\n', 'contract InterpinesToken is ERC20Detailed, ERC20Mintable, ERC20Pausable, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    constructor(\n', '        string _name,\n', '        string _symbol,\n', '        uint8 _decimals,\n', '        uint256 _amount\n', '    )\n', '    ERC20Detailed(_name, _symbol, _decimals)\n', '    public {\n', '        require(_amount > 0, "amount have to be greater than 0");\n', '        uint256 initialBalance = _amount.mul(10 ** uint256(_decimals));\n', '        _mint(msg.sender, initialBalance);\n', '    }\n', '\n', '    function burn(uint256 value) public onlyOwner {\n', '        _burn(msg.sender, value);\n', '    }\n', '}']