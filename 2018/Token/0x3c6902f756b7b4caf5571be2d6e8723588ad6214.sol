['pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function divRemain(uint256 numerator, uint256 denominator) internal pure returns (uint256 quotient, uint256 remainder) {\n', '    quotient  = div(numerator, denominator);\n', '    remainder = sub(numerator, mul(denominator, quotient));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Roles\n', ' * @author Francisco Giordano (@frangio)\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' * See RBAC.sol for example usage.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an address access to this role\n', '   */\n', '  function add(Role storage role, address addr)\n', '    internal\n', '  {\n', '    role.bearer[addr] = true;\n', '  }\n', '\n', '  /**\n', '   * @dev remove an address&#39; access to this role\n', '   */\n', '  function remove(Role storage role, address addr)\n', '    internal\n', '  {\n', '    role.bearer[addr] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an address has this role\n', '   * // reverts\n', '   */\n', '  function check(Role storage role, address addr)\n', '    view\n', '    internal\n', '  {\n', '    require(has(role, addr));\n', '  }\n', '\n', '  /**\n', '   * @dev check if an address has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address addr)\n', '    view\n', '    internal\n', '    returns (bool)\n', '  {\n', '    return role.bearer[addr];\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title RBAC (Role-Based Access Control)\n', ' * @author Matt Condon (@Shrugs)\n', ' * @dev Stores and provides setters and getters for roles and addresses.\n', ' * Supports unlimited numbers of roles and addresses.\n', ' * See //contracts/mocks/RBACMock.sol for an example of usage.\n', ' * This RBAC method uses strings to key roles. It may be beneficial\n', ' * for you to write your own implementation of this interface using Enums or similar.\n', ' * It&#39;s also recommended that you define constants in the contract, like ROLE_ADMIN below,\n', ' * to avoid typos.\n', ' */\n', 'contract RBAC {\n', '  using Roles for Roles.Role;\n', '\n', '  mapping (string => Roles.Role) private roles;\n', '\n', '  event RoleAdded(address indexed operator, string role);\n', '  event RoleRemoved(address indexed operator, string role);\n', '  event RoleRemovedAll(string role);\n', '\n', '  /**\n', '   * @dev reverts if addr does not have role\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   * // reverts\n', '   */\n', '  function checkRole(address _operator, string _role)\n', '    view\n', '    public\n', '  {\n', '    roles[_role].check(_operator);\n', '  }\n', '\n', '  /**\n', '   * @dev determine if addr has role\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   * @return bool\n', '   */\n', '  function hasRole(address _operator, string _role)\n', '    view\n', '    public\n', '    returns (bool)\n', '  {\n', '    return roles[_role].has(_operator);\n', '  }\n', '\n', '  /**\n', '   * @dev add a role to an address\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   */\n', '  function addRole(address _operator, string _role)\n', '    internal\n', '  {\n', '    roles[_role].add(_operator);\n', '    emit RoleAdded(_operator, _role);\n', '  }\n', '\n', '  /**\n', '   * @dev remove a role from an address\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   */\n', '  function removeRole(address _operator, string _role)\n', '    internal\n', '  {\n', '    roles[_role].remove(_operator);\n', '    emit RoleRemoved(_operator, _role);\n', '  }\n', '\n', '  /**\n', '   * @dev remove a role from an address\n', '   * @param _role the name of the role\n', '   */\n', '  function removeRoleAll(string _role)\n', '    internal\n', '  {\n', '    delete roles[_role];\n', '    emit RoleRemovedAll(_role);\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to scope access to a single role (uses msg.sender as addr)\n', '   * @param _role the name of the role\n', '   * // reverts\n', '   */\n', '  modifier onlyRole(string _role)\n', '  {\n', '    checkRole(msg.sender, _role);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to scope access to a set of roles (uses msg.sender as addr)\n', '   * @param _roles the names of the roles to scope access to\n', '   * // reverts\n', '   *\n', '   * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this\n', '   *  see: https://github.com/ethereum/solidity/issues/2467\n', '   */\n', '  // modifier onlyRoles(string[] _roles) {\n', '  //     bool hasAnyRole = false;\n', '  //     for (uint8 i = 0; i < _roles.length; i++) {\n', '  //         if (hasRole(msg.sender, _roles[i])) {\n', '  //             hasAnyRole = true;\n', '  //             break;\n', '  //         }\n', '  //     }\n', '\n', '  //     require(hasAnyRole);\n', '\n', '  //     _;\n', '  // }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Administrable\n', ' * @dev The Admin contract defines a single Admin who can transfer the ownership \n', ' * of a contract to a new address, even if he is not the owner. \n', ' * A Admin can transfer his role to a new address. \n', ' */\n', 'contract Administrable is Ownable, RBAC {\n', '  string public constant ROLE_LOCKUP = "lockup";\n', '  string public constant ROLE_MINT = "mint";\n', '\n', '  constructor () public {\n', '    addRole(msg.sender, ROLE_LOCKUP);\n', '    addRole(msg.sender, ROLE_MINT);\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account that&#39;s not a Admin.\n', '   */\n', '  modifier onlyAdmin(string _role) {\n', '    checkRole(msg.sender, _role);\n', '    _;\n', '  }\n', '\n', '  modifier onlyOwnerOrAdmin(string _role) {\n', '    require(msg.sender == owner || isAdmin(msg.sender, _role));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev getter to determine if address has Admin role\n', '   */\n', '  function isAdmin(address _addr, string _role)\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return hasRole(_addr, _role);\n', '  }\n', '\n', '  /**\n', '   * @dev add a admin role to an address\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   */\n', '  function addAdmin(address _operator, string _role)\n', '    public\n', '    onlyOwner\n', '  {\n', '    addRole(_operator, _role);\n', '  }\n', '\n', '  /**\n', '   * @dev remove a admin role from an address\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   */\n', '  function removeAdmin(address _operator, string _role)\n', '    public\n', '    onlyOwner\n', '  {\n', '    removeRole(_operator, _role);\n', '  }\n', '\n', '  /**\n', '   * @dev claim a admin role from an address\n', '   * @param _role the name of the role\n', '   */\n', '  function claimAdmin(string _role)\n', '    public\n', '    onlyOwner\n', '  {\n', '    removeRoleAll(_role);\n', '\n', '    addRole(msg.sender, _role);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Lockable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Lockable is Administrable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  event Locked(address _granted, uint256 _amount, uint256 _expiresAt);\n', '  event UnlockedAll(address _granted);\n', '\n', '  /**\n', '  * @dev Lock defines a lock of token\n', '  */\n', '  struct Lock {\n', '    uint256 amount;\n', '    uint256 expiresAt;\n', '  }\n', '\n', '  // granted to locks;\n', '  mapping (address => Lock[]) public grantedLocks;\n', '  \n', '\n', '  /**\n', '   * @dev called by the owner to lock, triggers stopped state\n', '   */\n', '  function lock\n', '  (\n', '    address _granted, \n', '    uint256 _amount, \n', '    uint256 _expiresAt\n', '  ) \n', '    onlyOwnerOrAdmin(ROLE_LOCKUP) \n', '    public \n', '  {\n', '    require(_amount > 0);\n', '    require(_expiresAt > now);\n', '\n', '    grantedLocks[_granted].push(Lock(_amount, _expiresAt));\n', '\n', '    emit Locked(_granted, _amount, _expiresAt);\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unlock, returns to normal state\n', '   */\n', '  function unlock\n', '  (\n', '    address _granted\n', '  ) \n', '    onlyOwnerOrAdmin(ROLE_LOCKUP) \n', '    public \n', '  {\n', '    require(grantedLocks[_granted].length > 0);\n', '    \n', '    delete grantedLocks[_granted];\n', '    emit UnlockedAll(_granted);\n', '  }\n', '\n', '  function lockedAmountOf\n', '  (\n', '    address _granted\n', '  ) \n', '    public\n', '    view\n', '    returns(uint256)\n', '  {\n', '    require(_granted != address(0));\n', '    \n', '    uint256 lockedAmount = 0;\n', '    uint256 lockedCount = grantedLocks[_granted].length;\n', '    if (lockedCount > 0) {\n', '      Lock[] storage locks = grantedLocks[_granted];\n', '      for (uint i = 0; i < locks.length; i++) {\n', '        if (now < locks[i].expiresAt) {\n', '          lockedAmount = lockedAmount.add(locks[i].amount);\n', '        } \n', '      }\n', '    }\n', '\n', '    return lockedAmount;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable  {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in exsitence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function msgSender() \n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return msg.sender;\n', '    }\n', '\n', '    function transfer(\n', '        address _to, \n', '        uint256 _value\n', '    ) \n', '        public \n', '        returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '        require(_to != msg.sender);\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is StandardToken {\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) \n', '        public \n', '    {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) \n', '        internal \n', '    {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '        \n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract MintableToken is StandardToken, Administrable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintStarted();\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    modifier cantMint() {\n', '        require(mintingFinished);\n', '        _;\n', '    }\n', '   \n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint\n', '    * @return A boolean that indicated if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwnerOrAdmin(ROLE_MINT) canMint public returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to start minting new tokens.\n', '     * @return True if the operation was successful. \n', '     */\n', '    function startMinting() onlyOwner cantMint public returns (bool) {\n', '        mintingFinished = false;\n', '        emit MintStarted();\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful. \n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Lockable token\n', ' * @dev ReliableTokenToken modified with lockable transfers.\n', ' **/\n', 'contract ReliableToken is MintableToken, BurnableToken, Pausable, Lockable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotExceedLock(address _granted, uint256 _value) {\n', '    uint256 lockedAmount = lockedAmountOf(_granted);\n', '    uint256 balance = balanceOf(_granted);\n', '\n', '    require(balance > lockedAmount && balance.sub(lockedAmount) >= _value);\n', '    _;\n', '  }\n', '\n', '  function transfer\n', '  (\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    whenNotExceedLock(msg.sender, _value)\n', '    returns (bool)\n', '  {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferLocked\n', '  (\n', '    address _to, \n', '    uint256 _value,\n', '    uint256 _lockAmount,\n', '    uint256[] _expiresAtList\n', '  ) \n', '    public \n', '    whenNotPaused\n', '    whenNotExceedLock(msg.sender, _value)\n', '    onlyOwnerOrAdmin(ROLE_LOCKUP)\n', '    returns (bool) \n', '  {\n', '    require(_value >= _lockAmount);\n', '\n', '    uint256 lockCount = _expiresAtList.length;\n', '    if (lockCount > 0) {\n', '      (uint256 lockAmountEach, uint256 remainder) = _lockAmount.divRemain(lockCount);\n', '      if (lockAmountEach > 0) {\n', '        for (uint i = 0; i < lockCount; i++) {\n', '          if (i == (lockCount - 1) && remainder > 0)\n', '            lockAmountEach = lockAmountEach.add(remainder);\n', '\n', '          lock(_to, lockAmountEach, _expiresAtList[i]);  \n', '        }\n', '      }\n', '    }\n', '    \n', '    return transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom\n', '  (\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    whenNotExceedLock(_from, _value)\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function transferLockedFrom\n', '  (\n', '    address _from,\n', '    address _to, \n', '    uint256 _value,\n', '    uint256 _lockAmount,\n', '    uint256[] _expiresAtList\n', '  ) \n', '    public \n', '    whenNotPaused\n', '    whenNotExceedLock(_from, _value)\n', '    onlyOwnerOrAdmin(ROLE_LOCKUP)\n', '    returns (bool) \n', '  {\n', '    require(_value >= _lockAmount);\n', '\n', '    uint256 lockCount = _expiresAtList.length;\n', '    if (lockCount > 0) {\n', '      (uint256 lockAmountEach, uint256 remainder) = _lockAmount.divRemain(lockCount);\n', '      if (lockAmountEach > 0) {\n', '        for (uint i = 0; i < lockCount; i++) {\n', '          if (i == (lockCount - 1) && remainder > 0)\n', '            lockAmountEach = lockAmountEach.add(remainder);\n', '\n', '          lock(_to, lockAmountEach, _expiresAtList[i]);  \n', '        }\n', '      }\n', '    }\n', '\n', '    return transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve\n', '  (\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval\n', '  (\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval\n', '  (\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '\n', '  function () external payable \n', '  {\n', '    revert();\n', '  }\n', '}\n', '\n', '\n', 'contract BundableToken is ReliableToken {\n', '\n', '    /**\n', '    * @dev Transfers tokens to recipients multiply.\n', '    * @param _recipients address list of the recipients to whom received tokens \n', '    * @param _values the amount list of tokens to be transferred\n', '    */\n', '    function transferMultiply\n', '    (\n', '        address[] _recipients,\n', '        uint256[] _values\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint length = _recipients.length;\n', '        require(length > 0);\n', '        require(length == _values.length);\n', '\n', '        for (uint i = 0; i < length; i++) {\n', '            require(transfer(\n', '                _recipients[i], \n', '                _values[i]\n', '            ));\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfers tokens held by timelock to recipients multiply.\n', '    * @param _recipients address list of the recipients to whom received tokens \n', '    * @param _values the amount list of tokens to be transferred\n', '    * #param _defaultExpiresAtList default release times\n', '    */\n', '    function transferLockedMultiply\n', '    (\n', '        address[] _recipients,\n', '        uint256[] _values,\n', '        uint256[] _lockAmounts,\n', '        uint256[] _defaultExpiresAtList\n', '    )\n', '        public\n', '        onlyOwnerOrAdmin(ROLE_LOCKUP)\n', '        returns (bool)\n', '    {\n', '        uint length = _recipients.length;\n', '        require(length > 0);\n', '        require(length == _values.length && length == _lockAmounts.length);\n', '        require(_defaultExpiresAtList.length > 0);\n', '\n', '        for (uint i = 0; i < length; i++) {\n', '            require(transferLocked(\n', '                _recipients[i], \n', '                _values[i], \n', '                _lockAmounts[i], \n', '                _defaultExpiresAtList\n', '            ));\n', '        }\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract IOAtoken is BundableToken {\n', '\n', '  string public constant name = "IOcean";\n', '  string public constant symbol = "IOA";\n', '  uint32 public constant decimals = 18;\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 210000000 * (10 ** uint256(decimals));\n', '\n', '  /**\n', '  * @dev Constructor that gives msg.sender all of existing tokens.\n', '  */\n', '  constructor() public \n', '  {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '  }\n', '}']