['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "@openzeppelin/contracts/utils/Address.sol";\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import "@openzeppelin/contracts/utils/EnumerableSet.sol";\n', 'import "./IOptIn.sol";\n', '\n', 'contract OptIn is IOptIn, Ownable {\n', '    using Address for address;\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '\n', '    event OptedIn(address account, address to);\n', '    event OptedOut(address account, address to);\n', '\n', '    // Indicates whether the contract is in boost-mode or not. Upon first deploy,\n', '    // it has to be activated by the owner of the contract. Once activated,\n', '    // it cannot be deactivated again and the owner automatically renounces ownership\n', '    // leaving the contract without an owner.\n', '    //\n', '    // Boost mode means that contracts who leverage opt-in functionality can impose more constraints on\n', '    // how users perform state changes in order to e.g. provide better services off-chain.\n', '    bool private _permaBoostActive;\n', '\n', '    // The opt-out period is 1 day (in seconds).\n', '    uint32 private constant _OPT_OUT_PERIOD = 86400;\n', '\n', '    // The address every account is opted-in to by default\n', '    address private immutable _defaultOptInAddress;\n', '\n', '    // For each account, a mapping to a boolean indicating whether they\n', '    // did anything that deviates from the default state or not. Used to\n', '    // minimize reads when nothing changed.\n', '    mapping(address => bool) private _dirty;\n', '\n', '    // For each account, a mapping to the address it is opted-in.\n', '    // By default every account is opted-in to `defaultOptInAddress`. Any account can opt-out\n', '    // at any time and opt-in to a different address.\n', '    // These non-default addresses are tracked in this mapping.\n', '    mapping(address => address) private _optedIn;\n', '\n', '    // A map containing all opted-in addresses that are\n', '    // waiting to be opted-out. They are still considered opted-in\n', '    // until the time period passed.\n', '    // We store the timestamp of when the opt-out was initiated. An address\n', '    // is considered opted-out when `optOutTimestamp + _optOutPeriod < block.timestamp` yields true.\n', '    mapping(address => uint256) private _optOutPending;\n', '\n', '    constructor(address defaultOptInAddress) public Ownable() {\n', '        _defaultOptInAddress = defaultOptInAddress;\n', '    }\n', '\n', '    function getPermaBoostActive() public view returns (bool) {\n', '        return _permaBoostActive;\n', '    }\n', '\n', '    /**\n', '     * @dev Activate the perma-boost and renounce ownership leaving the contract\n', '     * without an owner. This will irrevocably change the behavior of dependent-contracts.\n', '     */\n', '    function activateAndRenounceOwnership() external onlyOwner {\n', '        _permaBoostActive = true;\n', '        renounceOwnership();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the opt-out period.\n', '     */\n', '    function getOptOutPeriod() external pure returns (uint32) {\n', '        return _OPT_OUT_PERIOD;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address `account` opted-in to if any.\n', '     */\n', '    function getOptedInAddressOf(address account)\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        (, address optedInTo, ) = _getOptInStatus(account);\n', '        return optedInTo;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the OptInStatus for two accounts at once.\n', '     */\n', '    function getOptInStatusPair(address accountA, address accountB)\n', '        external\n', '        override\n', '        view\n', '        returns (OptInStatus memory, OptInStatus memory)\n', '    {\n', '        (bool isOptedInA, address optedInToA, ) = _getOptInStatus(accountA);\n', '        (bool isOptedInB, address optedInToB, ) = _getOptInStatus(accountB);\n', '\n', '        bool permaBoostActive = _permaBoostActive;\n', '\n', '        return (\n', '            OptInStatus({\n', '                isOptedIn: isOptedInA,\n', '                optedInTo: optedInToA,\n', '                permaBoostActive: permaBoostActive,\n', '                optOutPeriod: _OPT_OUT_PERIOD\n', '            }),\n', '            OptInStatus({\n', '                isOptedIn: isOptedInB,\n', '                optedInTo: optedInToB,\n', '                permaBoostActive: permaBoostActive,\n', '                optOutPeriod: _OPT_OUT_PERIOD\n', '            })\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Use this function to get the opt-in status of a given address.\n', '     * Returns to the caller an `OptInStatus` object that also contains whether\n', '     * the permaboost is active or not (e.g. to create pending ops).\n', '     */\n', '    function getOptInStatus(address account)\n', '        external\n', '        override\n', '        view\n', '        returns (OptInStatus memory)\n', '    {\n', '        (bool optedIn, address optedInTo, ) = _getOptInStatus(account);\n', '\n', '        return\n', '            OptInStatus({\n', '                isOptedIn: optedIn,\n', '                optedInTo: optedInTo,\n', '                permaBoostActive: _permaBoostActive,\n', '                optOutPeriod: _OPT_OUT_PERIOD\n', '            });\n', '    }\n', '\n', '    /**\n', '     * @dev Opts in the caller.\n', '     * @param to the address to opt-in to\n', '     */\n', '    function optIn(address to) external {\n', '        require(to != address(0), "OptIn: address cannot be zero");\n', '        require(to != msg.sender, "OptIn: cannot opt-in to self");\n', '        require(\n', '            !address(msg.sender).isContract(),\n', '            "OptIn: sender is a contract"\n', '        );\n', '        require(\n', '            msg.sender != _defaultOptInAddress,\n', '            "OptIn: default address cannot opt-in"\n', '        );\n', '        (bool optedIn, , ) = _getOptInStatus(msg.sender);\n', '        require(!optedIn, "OptIn: sender already opted-in");\n', '\n', '        _optedIn[msg.sender] = to;\n', '\n', '        // Always > 0 since by default anyone is opted-in\n', '        _optOutPending[msg.sender] = 0;\n', '\n', '        emit OptedIn(msg.sender, to);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remaining opt-out period (in seconds, if any) for the given `account`.\n', '     * A return value > 0 means that `account` opted-in, then opted-out and is\n', '     * still considered opted-in for the remaining period. If the return value is 0, then `account`\n', '     * could be either: opted-in or not, but guaranteed to not be pending.\n', '     */\n', '    function getPendingOptOutRemaining(address account)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        bool dirty = _dirty[account];\n', '\n', '        uint256 optOutPeriodRemaining = _getOptOutPeriodRemaining(\n', '            account,\n', '            dirty\n', '        );\n', '        return optOutPeriodRemaining;\n', '    }\n', '\n', '    function _getOptInStatus(address account)\n', '        internal\n', '        view\n', '        returns (\n', '            bool, // isOptedIn\n', '            address, // optedInTo\n', '            bool // dirty\n', '        )\n', '    {\n', '        bool dirty = _dirty[account];\n', '        // Take a shortcut if `account` never changed anything\n', '        if (!dirty) {\n', '            return (\n', '                true, /* isOptedIn */\n', '                _defaultOptInAddress,\n', '                dirty\n', '            );\n', '        }\n', '\n', '        address optedInTo = _getOptedInTo(account, dirty);\n', '\n', '        // Returns 0 if `account` never opted-out or opted-in again (which resets `optOutPending`).\n', '        uint256 optOutStartedAt = _optOutPending[account];\n', '        bool optOutPeriodActive = block.timestamp <\n', '            optOutStartedAt + _OPT_OUT_PERIOD;\n', '\n', '        if (optOutStartedAt == 0 || optOutPeriodActive) {\n', '            return (true, optedInTo, dirty);\n', '        }\n', '\n', '        return (false, address(0), dirty);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remaining opt-out period of `account` relative to the given\n', '     * `optedInTo` address.\n', '     */\n', '    function _getOptOutPeriodRemaining(address account, bool dirty)\n', '        private\n', '        view\n', '        returns (uint256)\n', '    {\n', '        if (!dirty) {\n', '            // never interacted with opt-in contract\n', '            return 0;\n', '        }\n', '\n', '        uint256 optOutPending = _optOutPending[account];\n', '        if (optOutPending == 0) {\n', '            // Opted-out and/or opted-in again to someone else\n', '            return 0;\n', '        }\n', '\n', '        uint256 optOutPeriodEnd = optOutPending + _OPT_OUT_PERIOD;\n', '        if (block.timestamp >= optOutPeriodEnd) {\n', '            // Period is over\n', '            return 0;\n', '        }\n', '\n', '        // End is still in the future, so the difference to block.timestamp is the remaining\n', '        // duration in seconds.\n', '        return optOutPeriodEnd - block.timestamp;\n', '    }\n', '\n', '    function _getOptedInTo(address account, bool dirty)\n', '        internal\n', '        view\n', '        returns (address)\n', '    {\n', '        if (!dirty) {\n', '            return _defaultOptInAddress;\n', '        }\n', '\n', '        // Might be dirty, but never opted-in to someone else and/or simply pending.\n', '        // We need to return the default address if the mapping is zero.\n', '        address optedInTo = _optedIn[account];\n', '        if (optedInTo == address(0)) {\n', '            return _defaultOptInAddress;\n', '        }\n', '\n', '        return optedInTo;\n', '    }\n', '\n', '    /**\n', '     * @dev Opts out the caller. The opt-out does not immediately take effect.\n', '     * Instead, the caller is marked pending and only after a 30-day period ended since\n', '     * the call to this function he is no longer considered opted-in.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller is opted-in\n', '     */\n', '    function optOut() external {\n', '        (bool isOptedIn, address optedInTo, ) = _getOptInStatus(msg.sender);\n', '\n', '        require(isOptedIn, "OptIn: sender not opted-in");\n', '        require(\n', '            _optOutPending[msg.sender] == 0,\n', '            "OptIn: sender not opted-in or opt-out pending"\n', '        );\n', '\n', '        _optOutPending[msg.sender] = block.timestamp;\n', '\n', '        // NOTE: we do not delete the `optedInTo` address yet, because we still need it\n', '        // for e.g. checking `isOptedInBy` while the opt-out period is not over yet.\n', '\n', '        emit OptedOut(msg.sender, optedInTo);\n', '\n', '        _dirty[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev An opted-in address can opt-out an `account` instantly, so that the opt-out period\n', '     * is skipped.\n', '     */\n', '    function instantOptOut(address account) external {\n', '        (bool isOptedIn, address optedInTo, bool dirty) = _getOptInStatus(\n', '            account\n', '        );\n', '\n', '        require(\n', '            isOptedIn,\n', '            "OptIn: cannot instant opt-out not opted-in account"\n', '        );\n', '        require(\n', '            optedInTo == msg.sender,\n', '            "OptIn: account must be opted-in to msg.sender"\n', '        );\n', '\n', '        emit OptedOut(account, msg.sender);\n', '\n', '        // To make the opt-out happen instantly, subtract the waiting period of `msg.sender` from `block.timestamp` -\n', '        // effectively making `account` having waited for the opt-out period time.\n', '        _optOutPending[account] = block.timestamp - _OPT_OUT_PERIOD - 1;\n', '\n', '        if (!dirty) {\n', '            _dirty[account] = true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Check if the given `_sender` has been opted-in by `_account` and that `_account`\n', '     * is still opted-in.\n', '     *\n', '     * Returns a tuple (bool,uint256) where the latter is the optOutPeriod of the address\n', '     * `account` is opted-in to.\n', '     */\n', '    function isOptedInBy(address _sender, address _account)\n', '        external\n', '        override\n', '        view\n', '        returns (bool, uint256)\n', '    {\n', '        require(_sender != address(0), "OptIn: sender cannot be zero address");\n', '        require(\n', '            _account != address(0),\n', '            "OptIn: account cannot be zero address"\n', '        );\n', '\n', '        (bool isOptedIn, address optedInTo, ) = _getOptInStatus(_account);\n', '        if (!isOptedIn || _sender != optedInTo) {\n', '            return (false, 0);\n', '        }\n', '\n', '        return (true, _OPT_OUT_PERIOD);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'import "../GSN/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Library for managing\n', ' * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive\n', ' * types.\n', ' *\n', ' * Sets have the following properties:\n', ' *\n', ' * - Elements are added, removed, and checked for existence in constant time\n', ' * (O(1)).\n', ' * - Elements are enumerated in O(n). No guarantees are made on the ordering.\n', ' *\n', ' * ```\n', ' * contract Example {\n', ' *     // Add the library methods\n', ' *     using EnumerableSet for EnumerableSet.AddressSet;\n', ' *\n', ' *     // Declare a set state variable\n', ' *     EnumerableSet.AddressSet private mySet;\n', ' * }\n', ' * ```\n', ' *\n', ' * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`\n', ' * (`UintSet`) are supported.\n', ' */\n', 'library EnumerableSet {\n', '    // To implement this library for multiple types with as little code\n', '    // repetition as possible, we write it in terms of a generic Set type with\n', '    // bytes32 values.\n', '    // The Set implementation uses private functions, and user-facing\n', '    // implementations (such as AddressSet) are just wrappers around the\n', '    // underlying Set.\n', '    // This means that we can only create new EnumerableSets for types that fit\n', '    // in bytes32.\n', '\n', '    struct Set {\n', '        // Storage of set values\n', '        bytes32[] _values;\n', '\n', '        // Position of the value in the `values` array, plus 1 because index 0\n', '        // means a value is not in the set.\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            // The value is stored at length-1, but we add 1 to all indexes\n', '            // and use 0 as a sentinel value\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', "        // We read and store the value's index to prevent multiple reads from the same storage slot\n", '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) { // Equivalent to contains(set, value)\n', '            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in\n', "            // the array, and then remove the last element (sometimes called as 'swap and pop').\n", '            // This modifies the order of the array, as noted in {at}.\n', '\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs\n', "            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.\n", '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            // Move the last value to the index where the value to delete is\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            // Update the index for the moved value\n', '            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based\n', '\n', '            // Delete the slot where the moved value was stored\n', '            set._values.pop();\n', '\n', '            // Delete the index for the deleted slot\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    // AddressSet\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '\n', '    // UintSet\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'struct Signature {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '}\n', '\n', 'interface IOptIn {\n', '    struct OptInStatus {\n', '        bool isOptedIn;\n', '        bool permaBoostActive;\n', '        address optedInTo;\n', '        uint32 optOutPeriod;\n', '    }\n', '\n', '    function getOptInStatusPair(address accountA, address accountB)\n', '        external\n', '        view\n', '        returns (OptInStatus memory, OptInStatus memory);\n', '\n', '    function getOptInStatus(address account)\n', '        external\n', '        view\n', '        returns (OptInStatus memory);\n', '\n', '    function isOptedInBy(address _sender, address _account)\n', '        external\n', '        view\n', '        returns (bool, uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']