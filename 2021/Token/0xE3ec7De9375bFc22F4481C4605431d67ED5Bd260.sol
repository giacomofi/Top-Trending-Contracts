['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "@openzeppelin/contracts-upgradeable/utils/EnumerableSetUpgradeable.sol";\n', '\n', 'import "../library/Initializable.sol";\n', 'import "../library/Ownable.sol";\n', 'import "../library/ERC20.sol";\n', '\n', '/**\n', " * @title dForce's Multi-currency Stable Debt Token\n", ' * @author dForce\n', ' */\n', 'contract MSD is Initializable, Ownable, ERC20 {\n', '    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;\n', '\n', '    bytes32 public DOMAIN_SEPARATOR;\n', '    // keccak256("Permit(address owner,address spender,uint256 chainId, uint256 value,uint256 nonce,uint256 deadline)");\n', '    bytes32 public constant PERMIT_TYPEHASH =\n', '        0x576144ed657c8304561e56ca632e17751956250114636e8c01f64a7f2c6d98cf;\n', '    mapping(address => uint256) public nonces;\n', '\n', '    /// @dev EnumerableSet of minters\n', '    EnumerableSetUpgradeable.AddressSet internal minters;\n', '\n', '    /**\n', '     * @dev Emitted when `minter` is added as `minter`.\n', '     */\n', '    event MinterAdded(address minter);\n', '\n', '    /**\n', '     * @dev Emitted when `minter` is removed from `minters`.\n', '     */\n', '    event MinterRemoved(address minter);\n', '\n', '    /**\n', '     * @notice Expects to call only once to initialize the MSD token.\n', '     * @param _name Token name.\n', '     * @param _symbol Token symbol.\n', '     */\n', '    function initialize(\n', '        string memory _name,\n', '        string memory _symbol,\n', '        uint8 _decimals\n', '    ) external initializer {\n', '        __Ownable_init();\n', '        __ERC20_init(_name, _symbol, _decimals);\n', '\n', '        DOMAIN_SEPARATOR = keccak256(\n', '            abi.encode(\n', '                keccak256(\n', '                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"\n', '                ),\n', '                keccak256(bytes(_name)),\n', '                keccak256(bytes("1")),\n', '                _getChainId(),\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the minters.\n', '     */\n', '    modifier onlyMinter() {\n', '        require(\n', '            minters.contains(msg.sender),\n', '            "onlyMinter: caller is not minter"\n', '        );\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @notice Add `minter` into minters.\n', '     * If `minter` have not been a minter, emits a `MinterAdded` event.\n', '     *\n', '     * @param _minter The minter to add\n', '     *\n', '     * Requirements:\n', '     * - the caller must be `owner`.\n', '     */\n', '    function _addMinter(address _minter) external onlyOwner {\n', '        require(_minter != address(0), "_addMinter: _minter the zero address");\n', '        if (minters.add(_minter)) {\n', '            emit MinterAdded(_minter);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Remove `minter` from minters.\n', '     * If `minter` is a minter, emits a `MinterRemoved` event.\n', '     *\n', '     * @param _minter The minter to remove\n', '     *\n', '     * Requirements:\n', '     * - the caller must be `owner`.\n', '     */\n', '    function _removeMinter(address _minter) external onlyOwner {\n', '        require(\n', '            _minter != address(0),\n', '            "_removeMinter: _minter the zero address"\n', '        );\n', '        if (minters.remove(_minter)) {\n', '            emit MinterRemoved(_minter);\n', '        }\n', '    }\n', '\n', '    function mint(address to, uint256 amount) external onlyMinter {\n', '        _mint(to, amount);\n', '    }\n', '\n', '    function burn(address from, uint256 amount) external {\n', '        _burnFrom(from, amount);\n', '    }\n', '\n', '    function _getChainId() internal pure returns (uint256) {\n', '        uint256 chainId;\n', '        assembly {\n', '            chainId := chainid()\n', '        }\n', '        return chainId;\n', '    }\n', '\n', '    /**\n', '     * @dev EIP2612 permit function. For more details, please look at here:\n', '     * https://eips.ethereum.org/EIPS/eip-2612\n', '     * @param _owner The owner of the funds.\n', '     * @param _spender The spender.\n', '     * @param _value The amount.\n', '     * @param _deadline The deadline timestamp, type(uint256).max for max deadline.\n', '     * @param _v Signature param.\n', '     * @param _s Signature param.\n', '     * @param _r Signature param.\n', '     */\n', '    function permit(\n', '        address _owner,\n', '        address _spender,\n', '        uint256 _value,\n', '        uint256 _deadline,\n', '        uint8 _v,\n', '        bytes32 _r,\n', '        bytes32 _s\n', '    ) external {\n', '        require(_deadline >= block.timestamp, "permit: EXPIRED!");\n', '        uint256 _currentNonce = nonces[_owner];\n', '        bytes32 _digest =\n', '            keccak256(\n', '                abi.encodePacked(\n', '                    "\\x19\\x01",\n', '                    DOMAIN_SEPARATOR,\n', '                    keccak256(\n', '                        abi.encode(\n', '                            PERMIT_TYPEHASH,\n', '                            _owner,\n', '                            _spender,\n', '                            _getChainId(),\n', '                            _value,\n', '                            _currentNonce,\n', '                            _deadline\n', '                        )\n', '                    )\n', '                )\n', '            );\n', '        address _recoveredAddress = ecrecover(_digest, _v, _r, _s);\n', '        require(\n', '            _recoveredAddress != address(0) && _recoveredAddress == _owner,\n', '            "permit: INVALID_SIGNATURE!"\n', '        );\n', '        nonces[_owner] = _currentNonce.add(1);\n', '        _approve(_owner, _spender, _value);\n', '    }\n', '\n', '    /**\n', '     * @notice Return all minters of this MSD token\n', '     * @return _minters The list of minter addresses\n', '     */\n', '    function getMinters() public view returns (address[] memory _minters) {\n', '        uint256 _len = minters.length();\n', '        _minters = new address[](_len);\n', '        for (uint256 i = 0; i < _len; i++) {\n', '            _minters[i] = minters.at(i);\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Library for managing\n', ' * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive\n', ' * types.\n', ' *\n', ' * Sets have the following properties:\n', ' *\n', ' * - Elements are added, removed, and checked for existence in constant time\n', ' * (O(1)).\n', ' * - Elements are enumerated in O(n). No guarantees are made on the ordering.\n', ' *\n', ' * ```\n', ' * contract Example {\n', ' *     // Add the library methods\n', ' *     using EnumerableSet for EnumerableSet.AddressSet;\n', ' *\n', ' *     // Declare a set state variable\n', ' *     EnumerableSet.AddressSet private mySet;\n', ' * }\n', ' * ```\n', ' *\n', ' * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)\n', ' * and `uint256` (`UintSet`) are supported.\n', ' */\n', 'library EnumerableSetUpgradeable {\n', '    // To implement this library for multiple types with as little code\n', '    // repetition as possible, we write it in terms of a generic Set type with\n', '    // bytes32 values.\n', '    // The Set implementation uses private functions, and user-facing\n', '    // implementations (such as AddressSet) are just wrappers around the\n', '    // underlying Set.\n', '    // This means that we can only create new EnumerableSets for types that fit\n', '    // in bytes32.\n', '\n', '    struct Set {\n', '        // Storage of set values\n', '        bytes32[] _values;\n', '\n', '        // Position of the value in the `values` array, plus 1 because index 0\n', '        // means a value is not in the set.\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            // The value is stored at length-1, but we add 1 to all indexes\n', '            // and use 0 as a sentinel value\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', "        // We read and store the value's index to prevent multiple reads from the same storage slot\n", '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) { // Equivalent to contains(set, value)\n', '            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in\n', "            // the array, and then remove the last element (sometimes called as 'swap and pop').\n", '            // This modifies the order of the array, as noted in {at}.\n', '\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs\n', "            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.\n", '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            // Move the last value to the index where the value to delete is\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            // Update the index for the moved value\n', '            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based\n', '\n', '            // Delete the slot where the moved value was stored\n', '            set._values.pop();\n', '\n', '            // Delete the index for the deleted slot\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    // Bytes32Set\n', '\n', '    struct Bytes32Set {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {\n', '        return _add(set._inner, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {\n', '        return _remove(set._inner, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {\n', '        return _contains(set._inner, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(Bytes32Set storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {\n', '        return _at(set._inner, index);\n', '    }\n', '\n', '    // AddressSet\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '\n', '    // UintSet\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', '/**\n', ' * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed\n', " * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an\n", ' * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer\n', ' * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.\n', ' *\n', ' * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as\n', ' * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.\n', ' *\n', ' * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure\n', ' * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.\n', ' */\n', 'abstract contract Initializable {\n', '    /**\n', '     * @dev Indicates that the contract has been initialized.\n', '     */\n', '    bool private _initialized;\n', '\n', '    /**\n', '     * @dev Modifier to protect an initializer function from being invoked twice.\n', '     */\n', '    modifier initializer() {\n', '        require(\n', '            !_initialized,\n', '            "Initializable: contract is already initialized"\n', '        );\n', '\n', '        _;\n', '\n', '        _initialized = true;\n', '    }\n', '}\n', '\n', '//SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {_setPendingOwner} and {_acceptOwner}.\n', ' */\n', 'contract Ownable {\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    address payable public owner;\n', '\n', '    /**\n', '     * @dev Returns the address of the current pending owner.\n', '     */\n', '    address payable public pendingOwner;\n', '\n', '    event NewOwner(address indexed previousOwner, address indexed newOwner);\n', '    event NewPendingOwner(\n', '        address indexed oldPendingOwner,\n', '        address indexed newPendingOwner\n', '    );\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender, "onlyOwner: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    function __Ownable_init() internal {\n', '        owner = msg.sender;\n', '        emit NewOwner(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice Base on the inputing parameter `newPendingOwner` to check the exact error reason.\n', '     * @dev Transfer contract control to a new owner. The newPendingOwner must call `_acceptOwner` to finish the transfer.\n', '     * @param newPendingOwner New pending owner.\n', '     */\n', '    function _setPendingOwner(address payable newPendingOwner)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(\n', '            newPendingOwner != address(0) && newPendingOwner != pendingOwner,\n', '            "_setPendingOwner: New owenr can not be zero address and owner has been set!"\n', '        );\n', '\n', '        // Gets current owner.\n', '        address oldPendingOwner = pendingOwner;\n', '\n', '        // Sets new pending owner.\n', '        pendingOwner = newPendingOwner;\n', '\n', '        emit NewPendingOwner(oldPendingOwner, newPendingOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Accepts the admin rights, but only for pendingOwenr.\n', '     */\n', '    function _acceptOwner() external {\n', '        require(\n', '            msg.sender == pendingOwner,\n', '            "_acceptOwner: Only for pending owner!"\n', '        );\n', '\n', '        // Gets current values for events.\n', '        address oldOwner = owner;\n', '        address oldPendingOwner = pendingOwner;\n', '\n', '        // Set the new contract owner.\n', '        owner = pendingOwner;\n', '\n', '        // Clear the pendingOwner.\n', '        pendingOwner = address(0);\n', '\n', '        emit NewOwner(oldOwner, owner);\n', '        emit NewPendingOwner(oldPendingOwner, pendingOwner);\n', '    }\n', '\n', '    uint256[50] private __gap;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";\n', '\n', '/**\n', ' * @dev Implementation of the {IERC20} interface.\n', ' *\n', ' * This implementation is agnostic to the way tokens are created. This means\n', ' * that a supply mechanism has to be added in a derived contract using {_mint}.\n', ' * For a generic mechanism see {ERC20PresetMinterPauser}.\n', ' *\n', ' * TIP: For a detailed writeup see our guide\n', ' * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How\n', ' * to implement supply mechanisms].\n', ' *\n', ' * We have followed general OpenZeppelin guidelines: functions revert instead\n', ' * of returning `false` on failure. This behavior is nonetheless conventional\n', ' * and does not conflict with the expectations of ERC20 applications.\n', ' *\n', ' * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n', ' * This allows applications to reconstruct the allowance for all accounts just\n', ' * by listening to said events. Other implementations of the EIP may not emit\n', " * these events, as it isn't required by the specification.\n", ' *\n', ' * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n', ' * functions have been added to mitigate the well-known issues around setting\n', ' * allowances. See {IERC20-approve}.\n', ' */\n', 'contract ERC20 {\n', '    using SafeMathUpgradeable for uint256;\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    uint256 public totalSupply;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    /**\n', '     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with\n', '     * a default value of 18.\n', '     *\n', '     * To select a different value for {decimals}, use {_setupDecimals}.\n', '     *\n', '     * All three of these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    function __ERC20_init(\n', '        string memory name_,\n', '        string memory symbol_,\n', '        uint8 decimals_\n', '    ) internal {\n', '        name = name_;\n', '        symbol = symbol_;\n', '        decimals = decimals_;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(address spender, uint256 amount)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for ``sender``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public virtual returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, allowance[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            msg.sender,\n', '            spender,\n', '            allowance[msg.sender][spender].add(addedValue)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            msg.sender,\n', '            spender,\n', '            allowance[msg.sender][spender].sub(subtractedValue)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        balanceOf[sender] = balanceOf[sender].sub(amount);\n', '        balanceOf[recipient] = balanceOf[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        totalSupply = totalSupply.add(amount);\n', '        balanceOf[account] = balanceOf[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        balanceOf[account] = balanceOf[account].sub(amount);\n', '        totalSupply = totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', "     * @dev Destroys `amount` tokens from `account`, deducting from the caller's\n", '     * allowance if caller is not the `account`.\n', '     *\n', '     * See {ERC20-_burn} and {ERC20-allowance}.\n', '     *\n', '     * Requirements:\n', '     *\n', "     * - the caller other than `msg.sender` must have allowance for ``accounts``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function _burnFrom(address account, uint256 amount) internal virtual {\n', '        if (msg.sender != account)\n', '            _approve(\n', '                account,\n', '                msg.sender,\n', '                allowance[account][msg.sender].sub(amount)\n', '            );\n', '\n', '        _burn(account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n', '     *\n', '     * This internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        allowance[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    uint256[50] private __gap;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMathUpgradeable {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']