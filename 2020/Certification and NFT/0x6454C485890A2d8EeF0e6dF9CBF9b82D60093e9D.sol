['// File: @openzeppelin/upgrades/contracts/Initializable.sol\n', '\n', 'pragma solidity >=0.4.24 <0.7.0;\n', '\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    address self = address(this);\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(self) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', '// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context is Initializable {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Initializable, Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    function initialize(address sender) public initializer {\n', '        _owner = sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '\n', '    uint256[50] private ______gap;\n', '}\n', '\n', '// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/InitializableV2.sol\n', '\n', 'pragma solidity >=0.4.24 <0.7.0;\n', '\n', '\n', '\n', '/**\n', " * Wrapper around OpenZeppelin's Initializable contract.\n", ' * Exposes initialized state management to ensure logic contract functions cannot be called before initialization.\n', " * This is needed because OZ's Initializable contract no longer exposes initialized state variable.\n", ' * https://github.com/OpenZeppelin/openzeppelin-sdk/blob/v2.8.0/packages/lib/contracts/Initializable.sol\n', ' */\n', 'contract InitializableV2 is Initializable {\n', '    bool private isInitialized;\n', '\n', '    string private constant ERROR_NOT_INITIALIZED = "InitializableV2: Not initialized";\n', '\n', '    /**\n', "     * @notice wrapper function around parent contract Initializable's `initializable` modifier\n", '     *      initializable modifier ensures this function can only be called once by each deployed child contract\n', '     *      sets isInitialized flag to true to which is used by _requireIsInitialized()\n', '     */\n', '    function initialize() public initializer {\n', '        isInitialized = true;\n', '    }\n', '\n', '    /**\n', '     * @notice Reverts transaction if isInitialized is false. Used by child contracts to ensure\n', '     *      contract is initialized before functions can be called.\n', '     */\n', '    function _requireIsInitialized() internal view {\n', '        require(isInitialized == true, ERROR_NOT_INITIALIZED);\n', '    }\n', '\n', '    /**\n', '     * @notice Exposes isInitialized bool var to child contracts with read-only access\n', '     */\n', '    function _isInitialized() internal view returns (bool) {\n', '        return isInitialized;\n', '    }\n', '}\n', '\n', '// File: contracts/registry/Registry.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', '* @title Central hub for Audius protocol. It stores all contract addresses to facilitate\n', '*   external access and enable version management.\n', '*/\n', 'contract Registry is InitializableV2, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev addressStorage mapping allows efficient lookup of current contract version\n', '     *      addressStorageHistory maintains record of all contract versions\n', '     */\n', '    mapping(bytes32 => address) private addressStorage;\n', '    mapping(bytes32 => address[]) private addressStorageHistory;\n', '\n', '    event ContractAdded(\n', '        bytes32 indexed _name,\n', '        address indexed _address\n', '    );\n', '\n', '    event ContractRemoved(\n', '        bytes32 indexed _name,\n', '        address indexed _address\n', '    );\n', '\n', '    event ContractUpgraded(\n', '        bytes32 indexed _name,\n', '        address indexed _oldAddress,\n', '        address indexed _newAddress\n', '    );\n', '\n', '    function initialize() public initializer {\n', '        /// @notice Ownable.initialize(address _sender) sets contract owner to _sender.\n', '        Ownable.initialize(msg.sender);\n', '        InitializableV2.initialize();\n', '    }\n', '\n', '    // ========================================= Setters =========================================\n', '\n', '    /**\n', '     * @notice addContract registers contract name to address mapping under given registry key\n', '     * @param _name - registry key that will be used for lookups\n', '     * @param _address - address of contract\n', '     */\n', '    function addContract(bytes32 _name, address _address) external onlyOwner {\n', '        _requireIsInitialized();\n', '\n', '        require(\n', '            addressStorage[_name] == address(0x00),\n', '            "Registry: Contract already registered with given name."\n', '        );\n', '        require(\n', '            _address != address(0x00),\n', '            "Registry: Cannot register zero address."\n', '        );\n', '\n', '        setAddress(_name, _address);\n', '\n', '        emit ContractAdded(_name, _address);\n', '    }\n', '\n', '    /**\n', '     * @notice removes contract address registered under given registry key\n', '     * @param _name - registry key for lookup\n', '     */\n', '    function removeContract(bytes32 _name) external onlyOwner {\n', '        _requireIsInitialized();\n', '\n', '        address contractAddress = addressStorage[_name];\n', '        require(\n', '            contractAddress != address(0x00),\n', '            "Registry: Cannot remove - no contract registered with given _name."\n', '        );\n', '\n', '        setAddress(_name, address(0x00));\n', '\n', '        emit ContractRemoved(_name, contractAddress);\n', '    }\n', '\n', '    /**\n', '     * @notice replaces contract address registered under given key with provided address\n', '     * @param _name - registry key for lookup\n', '     * @param _newAddress - new contract address to register under given key\n', '     */\n', '    function upgradeContract(bytes32 _name, address _newAddress) external onlyOwner {\n', '        _requireIsInitialized();\n', '\n', '        address oldAddress = addressStorage[_name];\n', '        require(\n', '            oldAddress != address(0x00),\n', '            "Registry: Cannot upgrade - no contract registered with given _name."\n', '        );\n', '        require(\n', '            _newAddress != address(0x00),\n', '            "Registry: Cannot upgrade - cannot register zero address."\n', '        );\n', '\n', '        setAddress(_name, _newAddress);\n', '\n', '        emit ContractUpgraded(_name, oldAddress, _newAddress);\n', '    }\n', '\n', '    // ========================================= Getters =========================================\n', '\n', '    /**\n', '     * @notice returns contract address registered under given registry key\n', '     * @param _name - registry key for lookup\n', '     * @return contractAddr - address of contract registered under given registry key\n', '     */\n', '    function getContract(bytes32 _name) external view returns (address contractAddr) {\n', '        _requireIsInitialized();\n', '\n', '        return addressStorage[_name];\n', '    }\n', '\n', '    /// @notice overloaded getContract to return explicit version of contract\n', '    function getContract(bytes32 _name, uint256 _version) external view\n', '    returns (address contractAddr)\n', '    {\n', '        _requireIsInitialized();\n', '\n', '        // array length for key implies version number\n', '        require(\n', '            _version <= addressStorageHistory[_name].length,\n', '            "Registry: Index out of range _version."\n', '        );\n', '        return addressStorageHistory[_name][_version.sub(1)];\n', '    }\n', '\n', '    /**\n', '     * @notice Returns the number of versions for a contract key\n', '     * @param _name - registry key for lookup\n', '     * @return number of contract versions\n', '     */\n', '    function getContractVersionCount(bytes32 _name) external view returns (uint256) {\n', '        _requireIsInitialized();\n', '\n', '        return addressStorageHistory[_name].length;\n', '    }\n', '\n', '    // ========================================= Private functions =========================================\n', '\n', '    /**\n', '     * @param _key the key for the contract address\n', '     * @param _value the contract address\n', '     */\n', '    function setAddress(bytes32 _key, address _value) private {\n', '        // main map for cheap lookup\n', '        addressStorage[_key] = _value;\n', '        // keep track of contract address history\n', '        addressStorageHistory[_key].push(_value);\n', '    }\n', '\n', '}']