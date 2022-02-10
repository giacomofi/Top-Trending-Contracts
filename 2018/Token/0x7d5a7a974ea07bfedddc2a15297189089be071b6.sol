['pragma solidity 0.4.18;\n', '\n', '// File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol\n', '\n', '/**\n', ' * @title Roles\n', ' * @author Francisco Giordano (@frangio)\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' *      See RBAC.sol for example usage.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an address access to this role\n', '     */\n', '    function add(Role storage role, address addr)\n', '        internal\n', '    {\n', '        role.bearer[addr] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an address' access to this role\n", '     */\n', '    function remove(Role storage role, address addr)\n', '        internal\n', '    {\n', '        role.bearer[addr] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an address has this role\n', '     * // reverts\n', '     */\n', '    function check(Role storage role, address addr)\n', '        view\n', '        internal\n', '    {\n', '        require(has(role, addr));\n', '    }\n', '\n', '    /**\n', '     * @dev check if an address has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address addr)\n', '        view\n', '        internal\n', '        returns (bool)\n', '    {\n', '        return role.bearer[addr];\n', '    }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol\n', '\n', '/**\n', ' * @title RBAC (Role-Based Access Control)\n', ' * @author Matt Condon (@Shrugs)\n', ' * @dev Stores and provides setters and getters for roles and addresses.\n', ' *      Supports unlimited numbers of roles and addresses.\n', ' *      See //contracts/examples/RBACExample.sol for an example of usage.\n', ' * This RBAC method uses strings to key roles. It may be beneficial\n', ' *  for you to write your own implementation of this interface using Enums or similar.\n', " * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,\n", ' *  to avoid typos.\n', ' */\n', 'contract RBAC {\n', '    using Roles for Roles.Role;\n', '\n', '    mapping (string => Roles.Role) private roles;\n', '\n', '    event RoleAdded(address addr, string roleName);\n', '    event RoleRemoved(address addr, string roleName);\n', '\n', '    /**\n', '     * A constant role name for indicating admins.\n', '     */\n', '    string public constant ROLE_ADMIN = "admin";\n', '\n', '    /**\n', '     * @dev constructor. Sets msg.sender as admin by default\n', '     */\n', '    function RBAC()\n', '        public\n', '    {\n', '        addRole(msg.sender, ROLE_ADMIN);\n', '    }\n', '\n', '    /**\n', '     * @dev add a role to an address\n', '     * @param addr address\n', '     * @param roleName the name of the role\n', '     */\n', '    function addRole(address addr, string roleName)\n', '        internal\n', '    {\n', '        roles[roleName].add(addr);\n', '        RoleAdded(addr, roleName);\n', '    }\n', '\n', '    /**\n', '     * @dev remove a role from an address\n', '     * @param addr address\n', '     * @param roleName the name of the role\n', '     */\n', '    function removeRole(address addr, string roleName)\n', '        internal\n', '    {\n', '        roles[roleName].remove(addr);\n', '        RoleRemoved(addr, roleName);\n', '    }\n', '\n', '    /**\n', '     * @dev reverts if addr does not have role\n', '     * @param addr address\n', '     * @param roleName the name of the role\n', '     * // reverts\n', '     */\n', '    function checkRole(address addr, string roleName)\n', '        view\n', '        public\n', '    {\n', '        roles[roleName].check(addr);\n', '    }\n', '\n', '    /**\n', '     * @dev determine if addr has role\n', '     * @param addr address\n', '     * @param roleName the name of the role\n', '     * @return bool\n', '     */\n', '    function hasRole(address addr, string roleName)\n', '        view\n', '        public\n', '        returns (bool)\n', '    {\n', '        return roles[roleName].has(addr);\n', '    }\n', '\n', '    /**\n', '     * @dev add a role to an address\n', '     * @param addr address\n', '     * @param roleName the name of the role\n', '     */\n', '    function adminAddRole(address addr, string roleName)\n', '        onlyAdmin\n', '        public\n', '    {\n', '        addRole(addr, roleName);\n', '    }\n', '\n', '    /**\n', '     * @dev remove a role from an address\n', '     * @param addr address\n', '     * @param roleName the name of the role\n', '     */\n', '    function adminRemoveRole(address addr, string roleName)\n', '        onlyAdmin\n', '        public\n', '    {\n', '        removeRole(addr, roleName);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev modifier to scope access to a single role (uses msg.sender as addr)\n', '     * @param roleName the name of the role\n', '     * // reverts\n', '     */\n', '    modifier onlyRole(string roleName)\n', '    {\n', '        checkRole(msg.sender, roleName);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev modifier to scope access to admins\n', '     * // reverts\n', '     */\n', '    modifier onlyAdmin()\n', '    {\n', '        checkRole(msg.sender, ROLE_ADMIN);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev modifier to scope access to a set of roles (uses msg.sender as addr)\n', '     * @param roleNames the names of the roles to scope access to\n', '     * // reverts\n', '     *\n', '     * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this\n', '     *  see: https://github.com/ethereum/solidity/issues/2467\n', '     */\n', '    // modifier onlyRoles(string[] roleNames) {\n', '    //     bool hasAnyRole = false;\n', '    //     for (uint8 i = 0; i < roleNames.length; i++) {\n', '    //         if (hasRole(msg.sender, roleNames[i])) {\n', '    //             hasAnyRole = true;\n', '    //             break;\n', '    //         }\n', '    //     }\n', '\n', '    //     require(hasAnyRole);\n', '\n', '    //     _;\n', '    // }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BurnableToken.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Purpose.sol\n', '\n', 'contract Purpose is StandardToken, BurnableToken, RBAC {\n', '  string public constant name = "Purpose";\n', '  string public constant symbol = "PRPS";\n', '  uint8 public constant decimals = 18;\n', '  string constant public ROLE_BURN = "burn";\n', '  string constant public ROLE_TRANSFER = "transfer";\n', '  address public supplier;\n', '\n', '  function Purpose(address _supplier) public {\n', '    supplier = _supplier;\n', '    totalSupply = 1000000000 ether;\n', '    balances[supplier] = totalSupply;\n', '  }\n', '  \n', '  // used by burner contract to burn athenes tokens\n', '  function supplyBurn(uint256 _value) external onlyRole(ROLE_BURN) returns (bool) {\n', '    require(_value > 0);\n', '\n', '    // update state\n', '    balances[supplier] = balances[supplier].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '\n', '    // logs\n', '    Burn(supplier, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  // used by hodler contract to transfer users tokens to it\n', '  function hodlerTransfer(address _from, uint256 _value) external onlyRole(ROLE_TRANSFER) returns (bool) {\n', '    require(_from != address(0));\n', '    require(_value > 0);\n', '\n', '    // hodler\n', '    address _hodler = msg.sender;\n', '\n', '    // update state\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_hodler] = balances[_hodler].add(_value);\n', '\n', '    // logs\n', '    Transfer(_from, _hodler, _value);\n', '\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: contracts/Burner.sol\n', '\n', 'contract Burner {\n', '  using SafeMath for uint256;\n', '\n', '  Purpose public purpose;\n', '  address public supplier;\n', '  uint256 public start;\n', '  uint256 public lastBurn;\n', '  uint256 public burnPerweiYearly;\n', '  uint256 constant public MAXPERWEI = 1 ether;\n', '\n', '  function Burner (address _purpose, address _supplier, uint256 _start, uint256 _burnPerweiYearly) public {\n', '    require(_purpose != address(0));\n', '    require(_supplier != address(0));\n', '    require(_start > 0 && _start < now.add(1 days));\n', '    require(_burnPerweiYearly > 0 && _burnPerweiYearly <= MAXPERWEI);\n', '\n', '    purpose = Purpose(_purpose);\n', '    supplier = _supplier;\n', '    start = _start;\n', '    lastBurn = _start;\n', '    burnPerweiYearly = _burnPerweiYearly;\n', '  }\n', '  \n', '  function burn () external {\n', '    // get how much purpose will be burned\n', '    uint256 amount = burnable();\n', '    require(amount > 0);\n', '\n', '    // update state\n', '    lastBurn = now;\n', '\n', '    // burn purpose\n', '    assert(purpose.supplyBurn(amount));\n', '  }\n', '\n', '  function burnable () public view returns (uint256) {\n', '    // seconds since last burn\n', '    uint256 secsPassed = now.sub(lastBurn);\n', '    // how much percent to burn\n', '    uint256 perweiToBurn = secsPassed.mul(burnPerweiYearly).div(1 years);\n', '\n', '    // balance of supplier\n', '    uint256 balance = purpose.balanceOf(supplier);\n', '    // how much purpose to burn\n', '    uint256 amount = balance.mul(perweiToBurn).div(MAXPERWEI);\n', '\n', '    // return how much would be burned\n', '    if (amount > balance) return balance;\n', '    return amount;\n', '  }\n', '}']