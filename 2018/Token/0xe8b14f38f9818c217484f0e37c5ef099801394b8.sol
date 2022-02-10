['// Sources flattened with buidler v0.1.5\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '// File openzeppelin-solidity/contracts/token/ERC20/IERC20.sol@v1.12.0\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address _who) external view returns (uint256);\n', '\n', '  function allowance(address _owner, address _spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/math/SafeMath.sol@v1.12.0\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = _a * _b;\n', '    require(c / _a == _b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    require(_b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    require(_b <= _a);\n', '    uint256 c = _a - _b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    uint256 c = _a + _b;\n', '    require(c >= _a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/token/ERC20/ERC20.sol@v1.12.0\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private balances_;\n', '\n', '  mapping (address => mapping (address => uint256)) private allowed_;\n', '\n', '  uint256 private totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances_[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed_[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances_[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances_[msg.sender] = balances_[msg.sender].sub(_value);\n', '    balances_[_to] = balances_[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed_[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances_[_from]);\n', '    require(_value <= allowed_[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances_[_from] = balances_[_from].sub(_value);\n', '    balances_[_to] = balances_[_to].add(_value);\n', '    allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed_[msg.sender][_spender] = (\n', '      allowed_[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed_[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed_[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param _account The account that will receive the created tokens.\n', '   * @param _amount The amount that will be created.\n', '   */\n', '  function _mint(address _account, uint256 _amount) internal {\n', '    require(_account != 0);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances_[_account] = balances_[_account].add(_amount);\n', '    emit Transfer(address(0), _account, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param _account The account whose tokens will be burnt.\n', '   * @param _amount The amount that will be burnt.\n', '   */\n', '  function _burn(address _account, uint256 _amount) internal {\n', '    require(_account != 0);\n', '    require(_amount <= balances_[_account]);\n', '\n', '    totalSupply_ = totalSupply_.sub(_amount);\n', '    balances_[_account] = balances_[_account].sub(_amount);\n', '    emit Transfer(_account, address(0), _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal _burn function.\n', '   * @param _account The account whose tokens will be burnt.\n', '   * @param _amount The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address _account, uint256 _amount) internal {\n', '    require(_amount <= allowed_[_account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(\n', '      _amount);\n', '    _burn(_account, _amount);\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol@v1.12.0\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    IERC20 _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    IERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    IERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/ownership/Ownable.sol@v1.12.0\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/access/rbac/Roles.sol@v1.12.0\n', '\n', '/**\n', ' * @title Roles\n', ' * @author Francisco Giordano (@frangio)\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' * See RBAC.sol for example usage.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an account access to this role\n', '   */\n', '  function add(Role storage _role, address _account)\n', '    internal\n', '  {\n', '    _role.bearer[_account] = true;\n', '  }\n', '\n', '  /**\n', "   * @dev remove an account's access to this role\n", '   */\n', '  function remove(Role storage _role, address _account)\n', '    internal\n', '  {\n', '    _role.bearer[_account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * // reverts\n', '   */\n', '  function check(Role storage _role, address _account)\n', '    internal\n', '    view\n', '  {\n', '    require(has(_role, _account));\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage _role, address _account)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    return _role.bearer[_account];\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/access/rbac/RBAC.sol@v1.12.0\n', '\n', '/**\n', ' * @title RBAC (Role-Based Access Control)\n', ' * @author Matt Condon (@Shrugs)\n', ' * @dev Stores and provides setters and getters for roles and addresses.\n', ' * Supports unlimited numbers of roles and addresses.\n', ' * See //contracts/mocks/RBACMock.sol for an example of usage.\n', ' * This RBAC method uses strings to key roles. It may be beneficial\n', ' * for you to write your own implementation of this interface using Enums or similar.\n', ' */\n', 'contract RBAC {\n', '  using Roles for Roles.Role;\n', '\n', '  mapping (string => Roles.Role) private roles;\n', '\n', '  event RoleAdded(address indexed operator, string role);\n', '  event RoleRemoved(address indexed operator, string role);\n', '\n', '  /**\n', '   * @dev reverts if addr does not have role\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   * // reverts\n', '   */\n', '  function checkRole(address _operator, string _role)\n', '    public\n', '    view\n', '  {\n', '    roles[_role].check(_operator);\n', '  }\n', '\n', '  /**\n', '   * @dev determine if addr has role\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   * @return bool\n', '   */\n', '  function hasRole(address _operator, string _role)\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return roles[_role].has(_operator);\n', '  }\n', '\n', '  /**\n', '   * @dev add a role to an address\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   */\n', '  function _addRole(address _operator, string _role)\n', '    internal\n', '  {\n', '    roles[_role].add(_operator);\n', '    emit RoleAdded(_operator, _role);\n', '  }\n', '\n', '  /**\n', '   * @dev remove a role from an address\n', '   * @param _operator address\n', '   * @param _role the name of the role\n', '   */\n', '  function _removeRole(address _operator, string _role)\n', '    internal\n', '  {\n', '    roles[_role].remove(_operator);\n', '    emit RoleRemoved(_operator, _role);\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to scope access to a single role (uses msg.sender as addr)\n', '   * @param _role the name of the role\n', '   * // reverts\n', '   */\n', '  modifier onlyRole(string _role)\n', '  {\n', '    checkRole(msg.sender, _role);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to scope access to a set of roles (uses msg.sender as addr)\n', '   * @param _roles the names of the roles to scope access to\n', '   * // reverts\n', '   *\n', '   * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this\n', '   *  see: https://github.com/ethereum/solidity/issues/2467\n', '   */\n', '  // modifier onlyRoles(string[] _roles) {\n', '  //     bool hasAnyRole = false;\n', '  //     for (uint8 i = 0; i < _roles.length; i++) {\n', '  //         if (hasRole(msg.sender, _roles[i])) {\n', '  //             hasAnyRole = true;\n', '  //             break;\n', '  //         }\n', '  //     }\n', '\n', '  //     require(hasAnyRole);\n', '\n', '  //     _;\n', '  // }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/cryptography/ECDSA.sol@v1.12.0\n', '\n', '/**\n', ' * @title Elliptic curve signature operations\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' */\n', '\n', 'library ECDSA {\n', '\n', '  /**\n', '   * @dev Recover signer address from a message by using their signature\n', '   * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '   * @param _signature bytes signature, the signature is generated using web3.eth.sign()\n', '   */\n', '  function recover(bytes32 _hash, bytes _signature)\n', '    internal\n', '    pure\n', '    returns (address)\n', '  {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '\n', '    // Check the signature length\n', '    if (_signature.length != 65) {\n', '      return (address(0));\n', '    }\n', '\n', '    // Divide the signature in r, s and v variables\n', '    // ecrecover takes the signature parameters, and the only way to get them\n', '    // currently is to use assembly.\n', '    // solium-disable-next-line security/no-inline-assembly\n', '    assembly {\n', '      r := mload(add(_signature, 32))\n', '      s := mload(add(_signature, 64))\n', '      v := byte(0, mload(add(_signature, 96)))\n', '    }\n', '\n', '    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '    if (v < 27) {\n', '      v += 27;\n', '    }\n', '\n', '    // If the version is correct return the signer address\n', '    if (v != 27 && v != 28) {\n', '      return (address(0));\n', '    } else {\n', '      // solium-disable-next-line arg-overflow\n', '      return ecrecover(_hash, v, r, s);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * toEthSignedMessageHash\n', '   * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '   * and hash the result\n', '   */\n', '  function toEthSignedMessageHash(bytes32 _hash)\n', '    internal\n', '    pure\n', '    returns (bytes32)\n', '  {\n', '    // 32 is the length in bytes of hash,\n', '    // enforced by the type signature above\n', '    return keccak256(\n', '      abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)\n', '    );\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/access/SignatureBouncer.sol@v1.12.0\n', '\n', '/**\n', ' * @title SignatureBouncer\n', ' * @author PhABC, Shrugs and aflesher\n', ' * @dev Bouncer allows users to submit a signature as a permission to do an action.\n', ' * If the signature is from one of the authorized bouncer addresses, the signature\n', ' * is valid. The owner of the contract adds/removes bouncers.\n', ' * Bouncer addresses can be individual servers signing grants or different\n', ' * users within a decentralized club that have permission to invite other members.\n', ' * This technique is useful for whitelists and airdrops; instead of putting all\n', ' * valid addresses on-chain, simply sign a grant of the form\n', ' * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a valid bouncer address.\n', ' * Then restrict access to your crowdsale/whitelist/airdrop using the\n', ' * `onlyValidSignature` modifier (or implement your own using _isValidSignature).\n', ' * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and\n', ' * `onlyValidSignatureAndData` can be used to restrict access to only a given method\n', ' * or a given method with given parameters respectively.\n', ' * See the tests Bouncer.test.js for specific usage examples.\n', ' * @notice A method that uses the `onlyValidSignatureAndData` modifier must make the _signature\n', ' * parameter the "last" parameter. You cannot sign a message that has its own\n', ' * signature in it so the last 128 bytes of msg.data (which represents the\n', ' * length of the _signature data and the _signaature data itself) is ignored when validating.\n', ' * Also non fixed sized parameters make constructing the data in the signature\n', ' * much more complex. See https://ethereum.stackexchange.com/a/50616 for more details.\n', ' */\n', 'contract SignatureBouncer is Ownable, RBAC {\n', '  using ECDSA for bytes32;\n', '\n', '  // Name of the bouncer role.\n', '  string private constant ROLE_BOUNCER = "bouncer";\n', '  // Function selectors are 4 bytes long, as documented in\n', '  // https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector\n', '  uint256 private constant METHOD_ID_SIZE = 4;\n', '  // Signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes\n', '  uint256 private constant SIGNATURE_SIZE = 96;\n', '\n', '  /**\n', '   * @dev requires that a valid signature of a bouncer was provided\n', '   */\n', '  modifier onlyValidSignature(bytes _signature)\n', '  {\n', '    require(_isValidSignature(msg.sender, _signature));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev requires that a valid signature with a specifed method of a bouncer was provided\n', '   */\n', '  modifier onlyValidSignatureAndMethod(bytes _signature)\n', '  {\n', '    require(_isValidSignatureAndMethod(msg.sender, _signature));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev requires that a valid signature with a specifed method and params of a bouncer was provided\n', '   */\n', '  modifier onlyValidSignatureAndData(bytes _signature)\n', '  {\n', '    require(_isValidSignatureAndData(msg.sender, _signature));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Determine if an account has the bouncer role.\n', '   * @return true if the account is a bouncer, false otherwise.\n', '   */\n', '  function isBouncer(address _account) public view returns(bool) {\n', '    return hasRole(_account, ROLE_BOUNCER);\n', '  }\n', '\n', '  /**\n', '   * @dev allows the owner to add additional bouncer addresses\n', '   */\n', '  function addBouncer(address _bouncer)\n', '    public\n', '    onlyOwner\n', '  {\n', '    require(_bouncer != address(0));\n', '    _addRole(_bouncer, ROLE_BOUNCER);\n', '  }\n', '\n', '  /**\n', '   * @dev allows the owner to remove bouncer addresses\n', '   */\n', '  function removeBouncer(address _bouncer)\n', '    public\n', '    onlyOwner\n', '  {\n', '    _removeRole(_bouncer, ROLE_BOUNCER);\n', '  }\n', '\n', '  /**\n', '   * @dev is the signature of `this + sender` from a bouncer?\n', '   * @return bool\n', '   */\n', '  function _isValidSignature(address _address, bytes _signature)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    return _isValidDataHash(\n', '      keccak256(abi.encodePacked(address(this), _address)),\n', '      _signature\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev is the signature of `this + sender + methodId` from a bouncer?\n', '   * @return bool\n', '   */\n', '  function _isValidSignatureAndMethod(address _address, bytes _signature)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    bytes memory data = new bytes(METHOD_ID_SIZE);\n', '    for (uint i = 0; i < data.length; i++) {\n', '      data[i] = msg.data[i];\n', '    }\n', '    return _isValidDataHash(\n', '      keccak256(abi.encodePacked(address(this), _address, data)),\n', '      _signature\n', '    );\n', '  }\n', '\n', '  /**\n', '    * @dev is the signature of `this + sender + methodId + params(s)` from a bouncer?\n', '    * @notice the _signature parameter of the method being validated must be the "last" parameter\n', '    * @return bool\n', '    */\n', '  function _isValidSignatureAndData(address _address, bytes _signature)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    require(msg.data.length > SIGNATURE_SIZE);\n', '    bytes memory data = new bytes(msg.data.length - SIGNATURE_SIZE);\n', '    for (uint i = 0; i < data.length; i++) {\n', '      data[i] = msg.data[i];\n', '    }\n', '    return _isValidDataHash(\n', '      keccak256(abi.encodePacked(address(this), _address, data)),\n', '      _signature\n', '    );\n', '  }\n', '\n', '  /**\n', '   * @dev internal function to convert a hash to an eth signed message\n', '   * and then recover the signature and check it against the bouncer role\n', '   * @return bool\n', '   */\n', '  function _isValidDataHash(bytes32 _hash, bytes _signature)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    address signer = _hash\n', '      .toEthSignedMessageHash()\n', '      .recover(_signature);\n', '    return isBouncer(signer);\n', '  }\n', '}\n', '\n', '\n', '// File contracts/bouncers/EscrowedERC20Bouncer.sol\n', '\n', 'contract EscrowedERC20Bouncer is SignatureBouncer {\n', '  using SafeERC20 for IERC20;\n', '\n', '  uint256 public nonce;\n', '\n', '  modifier onlyBouncer()\n', '  {\n', '    require(isBouncer(msg.sender), "DOES_NOT_HAVE_BOUNCER_ROLE");\n', '    _;\n', '  }\n', '\n', '  modifier validDataWithoutSender(bytes _signature)\n', '  {\n', '    require(_isValidSignatureAndData(address(this), _signature), "INVALID_SIGNATURE");\n', '    _;\n', '  }\n', '\n', '  constructor(address _bouncer)\n', '    public\n', '  {\n', '    addBouncer(_bouncer);\n', '  }\n', '\n', '  /**\n', '   * allow anyone with a valid bouncer signature for the msg data to send `_amount` of `_token` to `_to`\n', '   */\n', '  function withdraw(uint256 _nonce, IERC20 _token, address _to, uint256 _amount, bytes _signature)\n', '    public\n', '    validDataWithoutSender(_signature)\n', '  {\n', '    require(_nonce > nonce, "NONCE_GT_NONCE_REQUIRED");\n', '    nonce = _nonce;\n', '    _token.safeTransfer(_to, _amount);\n', '  }\n', '\n', '  /**\n', '   * Allow the bouncer to withdraw all of the ERC20 tokens in the contract\n', '   */\n', '  function withdrawAll(IERC20 _token, address _to)\n', '    public\n', '    onlyBouncer\n', '  {\n', '    _token.safeTransfer(_to, _token.balanceOf(address(this)));\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol@v1.12.0\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract ERC20Mintable is ERC20, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier hasMintPermission() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(\n', '    address _to,\n', '    uint256 _amount\n', '  )\n', '    public\n', '    hasMintPermission\n', '    canMint\n', '    returns (bool)\n', '  {\n', '    _mint(_to, _amount);\n', '    emit Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() public onlyOwner canMint returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '// File contracts/bouncers/MintableERC20Bouncer.sol\n', '\n', 'contract MintableERC20Bouncer is SignatureBouncer {\n', '\n', '  uint256 public nonce;\n', '\n', '  modifier validDataWithoutSender(bytes _signature)\n', '  {\n', '    require(_isValidSignatureAndData(address(this), _signature), "INVALID_SIGNATURE");\n', '    _;\n', '  }\n', '\n', '  constructor(address _bouncer)\n', '    public\n', '  {\n', '    addBouncer(_bouncer);\n', '  }\n', '\n', '  /**\n', '   * allow anyone with a valid bouncer signature for the msg data to mint `_amount` of `_token` to `_to`\n', '   */\n', '  function mint(uint256 _nonce, ERC20Mintable _token, address _to, uint256 _amount, bytes _signature)\n', '    public\n', '    validDataWithoutSender(_signature)\n', '  {\n', '    require(_nonce > nonce, "NONCE_GT_NONCE_REQUIRED");\n', '    nonce = _nonce;\n', '    _token.mint(_to, _amount);\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol@v1.12.0\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'contract ERC20Detailed is IERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '\n', '// File openzeppelin-solidity/contracts/proposals/ERC1046/TokenMetadata.sol@v1.12.0\n', '\n', '/**\n', ' * @title ERC-1047 Token Metadata\n', ' * @dev See https://eips.ethereum.org/EIPS/eip-1046\n', ' * @dev tokenURI must respond with a URI that implements https://eips.ethereum.org/EIPS/eip-1047\n', ' * @dev TODO - update https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/IERC721.sol#L17 when 1046 is finalized\n', ' */\n', 'contract ERC20TokenMetadata is IERC20 {\n', '  function tokenURI() external view returns (string);\n', '}\n', '\n', '\n', 'contract ERC20WithMetadata is ERC20TokenMetadata {\n', '  string private tokenURI_ = "";\n', '\n', '  constructor(string _tokenURI)\n', '    public\n', '  {\n', '    tokenURI_ = _tokenURI;\n', '  }\n', '\n', '  function tokenURI() external view returns (string) {\n', '    return tokenURI_;\n', '  }\n', '}\n', '\n', '\n', '// File contracts/tokens/KataToken.sol\n', '\n', 'contract KataToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20WithMetadata {\n', '  constructor(\n', '    string _name,\n', '    string _symbol,\n', '    uint8 _decimals,\n', '    string _tokenURI\n', '  )\n', '    ERC20WithMetadata(_tokenURI)\n', '    ERC20Detailed(_name, _symbol, _decimals)\n', '    public\n', '  {}\n', '}\n', '\n', '\n', '// File contracts/deploy/TokenAndBouncerDeployer.sol\n', '\n', 'contract TokenAndBouncerDeployer is Ownable {\n', '  event Deployed(address indexed token, address indexed bouncer);\n', '\n', '  function deploy(\n', '    string _name,\n', '    string _symbol,\n', '    uint8 _decimals,\n', '    string _tokenURI,\n', '    address _signer\n', '  )\n', '    public\n', '    onlyOwner\n', '  {\n', '    MintableERC20Bouncer bouncer = new MintableERC20Bouncer(_signer);\n', '    KataToken token = new KataToken(_name, _symbol, _decimals, _tokenURI);\n', '    token.transferOwnership(address(bouncer));\n', '\n', '    emit Deployed(address(token), address(bouncer));\n', '\n', '    selfdestruct(msg.sender);\n', '  }\n', '}\n', '\n', '\n', '// File contracts/mocks/MockToken.sol\n', '\n', 'contract MockToken is ERC20Detailed, ERC20Mintable {\n', '  constructor(string _name, string _symbol, uint8 _decimals)\n', '    ERC20Detailed(_name, _symbol, _decimals)\n', '    ERC20Mintable()\n', '    ERC20()\n', '    public\n', '  {\n', '\n', '  }\n', '}\n', '\n', '\n', '// File contracts/old/ClaimableToken.sol\n', '\n', '// import "./MintableERC721Token.sol";\n', '// import "openzeppelin-solidity/contracts/token/ERC721/DefaultTokenURI.sol";\n', '\n', '\n', '// contract ClaimableToken is DefaultTokenURI, MintableERC721Token {\n', '\n', '//   constructor(string _name, string _symbol, string _tokenURI)\n', '//     MintableERC721Token(_name, _symbol)\n', '//     DefaultTokenURI(_tokenURI)\n', '//     public\n', '//   {\n', '\n', '//   }\n', '// }\n', '\n', '\n', '// File contracts/old/ClaimableTokenDeployer.sol\n', '\n', '// import "./ClaimableTokenMinter.sol";\n', '// import "./ClaimableToken.sol";\n', '\n', '\n', '// contract ClaimableTokenDeployer {\n', '//   ClaimableToken public token;\n', '//   ClaimableTokenMinter public minter;\n', '\n', '//   constructor(\n', '//     string _name,\n', '//     string _symbol,\n', '//     string _tokenURI,\n', '//     address _bouncer\n', '//   )\n', '//     public\n', '//   {\n', '//     token = new ClaimableToken(_name, _symbol, _tokenURI);\n', '//     minter = new ClaimableTokenMinter(token);\n', '//     token.addOwner(msg.sender);\n', '//     token.addMinter(address(minter));\n', '//     minter.addOwner(msg.sender);\n', '//     minter.addBouncer(_bouncer);\n', '//   }\n', '// }\n', '\n', '\n', '// File contracts/old/ClaimableTokenMinter.sol\n', '\n', '// import "./ClaimableToken.sol";\n', '// import "openzeppelin-solidity/contracts/access/ERC721Minter.sol";\n', '// import "openzeppelin-solidity/contracts/access/NonceTracker.sol";\n', '\n', '\n', '// contract ClaimableTokenMinter is NonceTracker, ERC721Minter {\n', '\n', '//   constructor(ClaimableToken _token)\n', '//     ERC721Minter(_token)\n', '//     public\n', '//   {\n', '\n', '//   }\n', '\n', '//   function mint(bytes _sig)\n', '//     withAccess(msg.sender, 1)\n', '//     public\n', '//     returns (uint256)\n', '//   {\n', '//     return super.mint(_sig);\n', '//   }\n', '// }']