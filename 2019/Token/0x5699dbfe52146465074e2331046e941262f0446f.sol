['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    _transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', '    emit Transfer(address(0), account, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    require(value <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(value);\n', '    _balances[account] = _balances[account].sub(value);\n', '    emit Transfer(account, address(0), value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 value) internal {\n', '    require(value <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      value);\n', '    _burn(account, value);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an account access to this role\n', '   */\n', '  function add(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(!has(role, account));\n', '\n', '    role.bearer[account] = true;\n', '  }\n', '\n', '  /**\n', "   * @dev remove an account's access to this role\n", '   */\n', '  function remove(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(has(role, account));\n', '\n', '    role.bearer[account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address account)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    require(account != address(0));\n', '    return role.bearer[account];\n', '  }\n', '}\n', '\n', 'contract PauserRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event PauserAdded(address indexed account);\n', '  event PauserRemoved(address indexed account);\n', '\n', '  Roles.Role private pausers;\n', '\n', '  constructor() internal {\n', '    _addPauser(msg.sender);\n', '  }\n', '\n', '  modifier onlyPauser() {\n', '    require(isPauser(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isPauser(address account) public view returns (bool) {\n', '    return pausers.has(account);\n', '  }\n', '\n', '  function addPauser(address account) public onlyPauser {\n', '    _addPauser(account);\n', '  }\n', '\n', '  function renouncePauser() public {\n', '    _removePauser(msg.sender);\n', '  }\n', '\n', '  function _addPauser(address account) internal {\n', '    pausers.add(account);\n', '    emit PauserAdded(account);\n', '  }\n', '\n', '  function _removePauser(address account) internal {\n', '    pausers.remove(account);\n', '    emit PauserRemoved(account);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '  event Paused(address account);\n', '  event Unpaused(address account);\n', '\n', '  bool private _paused;\n', '\n', '  constructor() internal {\n', '    _paused = false;\n', '  }\n', '\n', '  /**\n', '   * @return true if the contract is paused, false otherwise.\n', '   */\n', '  function paused() public view returns(bool) {\n', '    return _paused;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyPauser whenNotPaused {\n', '    _paused = true;\n', '    emit Paused(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyPauser whenPaused {\n', '    _paused = false;\n', '    emit Unpaused(msg.sender);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev ERC20 modified with pausable transfers.\n', ' **/\n', 'contract ERC20Pausable is ERC20, Pausable {\n', '\n', '  function transfer(\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transfer(to, value);\n', '  }\n', '\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(from, to, value);\n', '  }\n', '\n', '  function approve(\n', '    address spender,\n', '    uint256 value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(spender, value);\n', '  }\n', '\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseAllowance(spender, addedValue);\n', '  }\n', '\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseAllowance(spender, subtractedValue);\n', '  }\n', '}\n', '\n', 'contract ReserveRightsToken is ERC20Pausable {\n', '  string public name = "Reserve Rights";\n', '  string public symbol = "RSR";\n', '  uint8 public decimals = 18;\n', '\n', '  // Tokens belonging to Reserve team members and early investors are locked until network launch.\n', '  mapping (address => bool) public reserveTeamMemberOrEarlyInvestor;\n', '  event AccountLocked(address indexed lockedAccount);\n', '\n', '  // Hard-coded addresses from the previous deployment, which should be locked and contain token allocations. \n', '  address[] previousAddresses = [\n', '    0x8ad9c8ebe26eadab9251b8fc36cd06a1ec399a7f,\n', '    0xb268c230720d16c69a61cbee24731e3b2a3330a1,\n', '    0x082705fabf49bd30de8f0222821f6d940713b89d,\n', '    0xc3aa4ced5dea58a3d1ca76e507515c79ca1e4436,\n', '    0x66f25f036eb4463d8a45c6594a325f9e89baa6db,\n', '    0x9e454fe7d8e087fcac4ec8c40562de781004477e,\n', '    0x4fcc7ca22680aed155f981eeb13089383d624aa9,\n', '    0x5a66650e5345d76eb8136ea1490cbcce1c08072e,\n', '    0x698a10b5d0972bffea306ba5950bd74d2af3c7ca,\n', '    0xdf437625216cca3d7148e18d09f4aab0d47c763b,\n', '    0x24b4a6847ccb32972de40170c02fda121ddc6a30,\n', '    0x8d29a24f91df381feb4ee7f05405d3fb888c643e,\n', '    0x5a7350d95b9e644dcab4bc642707f43a361bf628,\n', '    0xfc2e9a5cd1bb9b3953ffa7e6ddf0c0447eb95f11,\n', '    0x3ac7a6c3a2ff08613b611485f795d07e785cbb95,\n', '    0x47fc47cbcc5217740905e16c4c953b2f247369d2,\n', '    0xd282337950ac6e936d0f0ebaaff1ffc3de79f3d5,\n', '    0xde59cd3aa43a2bf863723662b31906660c7d12b6,\n', '    0x5f84660cabb98f7b7764cd1ae2553442da91984e,\n', '    0xefbaaf73fc22f70785515c1e2be3d5ba2fb8e9b0,\n', '    0x63c5ffb388d83477a15eb940cfa23991ca0b30f0,\n', '    0x14f018cce044f9d3fb1e1644db6f2fab70f6e3cb,\n', '    0xbe30069d27a250f90c2ee5507bcaca5f868265f7,\n', '    0xcfef27288bedcd587a1ed6e86a996c8c5b01d7c1,\n', '    0x5f57bbccc7ffa4c46864b5ed999a271bc36bb0ce,\n', '    0xbae85de9858375706dde5907c8c9c6ee22b19212,\n', '    0x5cf4bbb0ff093f3c725abec32fba8f34e4e98af1,\n', '    0xcb2d434bf72d3cd43d0c368493971183640ffe99,\n', '    0x02fc8e99401b970c265480140721b28bb3af85ab,\n', '    0xe7ad11517d7254f6a0758cee932bffa328002dd0,\n', '    0x6b39195c164d693d3b6518b70d99877d4f7c87ef,\n', '    0xc59119d8e4d129890036a108aed9d9fe94db1ba9,\n', '    0xd28661e4c75d177d9c1f3c8b821902c1abd103a6,\n', '    0xba385610025b1ea8091ae3e4a2e98913e2691ff7,\n', '    0xcd74834b8f3f71d2e82c6240ae0291c563785356,\n', '    0x657a127639b9e0ccccfbe795a8e394d5ca158526\n', '  ];\n', '\n', '  constructor() public {\n', '    IERC20 previousToken = IERC20(0xc2646eda7c2d4bf131561141c1d5696c4f01eb53);\n', '\n', '    address reservePrimaryWallet = 0xfa3bd0b2ac6e63f16d16d7e449418837a8a3ae27;\n', '    _mint(reservePrimaryWallet, previousToken.balanceOf(reservePrimaryWallet));\n', '\n', '    for (uint i = 0; i < previousAddresses.length; i++) {\n', '      reserveTeamMemberOrEarlyInvestor[previousAddresses[i]] = true;\n', '      _mint(previousAddresses[i], previousToken.balanceOf(previousAddresses[i]));\n', '      emit AccountLocked(previousAddresses[i]);\n', '    }\n', '  }\n', '\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    // Tokens belonging to Reserve team members and early investors are locked until network launch.\n', '    require(!reserveTeamMemberOrEarlyInvestor[msg.sender]);\n', '    super.transfer(to, value);\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    // Tokens belonging to Reserve team members and early investors are locked until network launch.\n', '    require(!reserveTeamMemberOrEarlyInvestor[from]);\n', '    super.transferFrom(from, to, value);\n', '  }\n', '\n', '  /// This function is intended to be used only by Reserve team members and investors.\n', '  /// You can call it yourself, but you almost certainly don’t want to.\n', '  /// Anyone who calls this function will cause their own tokens to be subject to\n', '  /// a long lockup. Reserve team members and some investors do this to commit\n', '  /// ourselves to not dumping tokens early. If you are not a Reserve team member\n', '  /// or investor, you don’t need to limit yourself in this way.\n', '  ///\n', '  /// THIS FUNCTION LOCKS YOUR TOKENS. ONLY USE IT IF YOU KNOW WHAT YOU ARE DOING.\n', '  function lockMyTokensForever(string consent) public returns (bool) {\n', '    require(keccak256(abi.encodePacked(consent)) == keccak256(abi.encodePacked(\n', '      "I understand that I am locking my account forever, or at least until the next token upgrade."\n', '    )));\n', '    reserveTeamMemberOrEarlyInvestor[msg.sender] = true;\n', '    emit AccountLocked(msg.sender);\n', '  }\n', '}']