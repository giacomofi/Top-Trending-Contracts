['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";\n', 'import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";\n', 'import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";\n', '\n', 'interface ILosslessController {\n', '    function beforeTransfer(address sender, address recipient, uint256 amount) external;\n', '\n', '    function beforeTransferFrom(address msgSender, address sender, address recipient, uint256 amount) external;\n', '\n', '    function beforeApprove(address sender, address spender, uint256 amount) external;\n', '\n', '    function beforeIncreaseAllowance(address msgSender, address spender, uint256 addedValue) external;\n', '\n', '    function beforeDecreaseAllowance(address msgSender, address spender, uint256 subtractedValue) external;\n', '\n', '    function afterApprove(address sender, address spender, uint256 amount) external;\n', '\n', '    function afterTransfer(address sender, address recipient, uint256 amount) external;\n', '\n', '    function afterTransferFrom(address msgSender, address sender, address recipient, uint256 amount) external;\n', '\n', '    function afterIncreaseAllowance(address sender, address spender, uint256 addedValue) external;\n', '\n', '    function afterDecreaseAllowance(address sender, address spender, uint256 subtractedValue) external;\n', '\n', '    function getVersion() external pure returns (uint256);\n', '}\n', '\n', 'contract LosslessControllerV1 is Initializable, ContextUpgradeable, PausableUpgradeable, ILosslessController {\n', '    address public pauseAdmin;\n', '    address public admin;\n', '    address public recoveryAdmin;\n', '    address private recoveryAdminCanditate;\n', '    bytes32 private recoveryAdminKeyHash;\n', '\n', '    event AdminChanged(address indexed previousAdmin, address indexed newAdmin);\n', '    event RecoveryAdminChangeProposed(address indexed candidate);\n', '    event RecoveryAdminChanged(address indexed previousAdmin, address indexed newAdmin);\n', '    event PauseAdminChanged(address indexed previousAdmin, address indexed newAdmin);\n', '\n', '    function initialize(address _admin, address _recoveryAdmin, address _pauseAdmin) public initializer {\n', '        admin = _admin;\n', '        recoveryAdmin = _recoveryAdmin;\n', '        pauseAdmin = _pauseAdmin;\n', '    }\n', '\n', '    // --- MODIFIERS ---\n', '\n', '    modifier onlyLosslessRecoveryAdmin() {\n', '        require(_msgSender() == recoveryAdmin, "LOSSLESS: Must be recoveryAdmin");\n', '        _;\n', '    }\n', '\n', '    modifier onlyLosslessAdmin() {\n', '        require(admin == _msgSender(), "LOSSLESS: Must be admin");\n', '        _;\n', '    }\n', '\n', '    // --- SETTERS ---\n', '\n', '    function pause() public {\n', '        require(_msgSender() == pauseAdmin, "LOSSLESS: Must be pauseAdmin");\n', '        _pause();\n', '    }    \n', '    \n', '    function unpause() public {\n', '        require(_msgSender() == pauseAdmin, "LOSSLESS: Must be pauseAdmin");\n', '        _unpause();\n', '    }\n', '\n', '    function setAdmin(address newAdmin) public onlyLosslessRecoveryAdmin {\n', '        emit AdminChanged(admin, newAdmin);\n', '        admin = newAdmin;\n', '    }\n', '\n', '    function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash) public onlyLosslessRecoveryAdmin {\n', '        recoveryAdminCanditate = candidate;\n', '        recoveryAdminKeyHash = keyHash;\n', '        emit RecoveryAdminChangeProposed(candidate);\n', '    }\n', '\n', '    function acceptRecoveryAdminOwnership(bytes memory key) external {\n', '        require(_msgSender() == recoveryAdminCanditate, "LOSSLESS: Must be canditate");\n', '        require(keccak256(key) == recoveryAdminKeyHash, "LOSSLESS: Invalid key");\n', '        emit RecoveryAdminChanged(recoveryAdmin, recoveryAdminCanditate);\n', '        recoveryAdmin = recoveryAdminCanditate;\n', '    }\n', '\n', '    function setPauseAdmin(address newPauseAdmin) public onlyLosslessRecoveryAdmin {\n', '        emit PauseAdminChanged(pauseAdmin, newPauseAdmin);\n', '        pauseAdmin = newPauseAdmin;\n', '    }\n', '\n', '    // --- GETTERS ---\n', '\n', '    function getVersion() override external pure returns (uint256) {\n', '        return 1;\n', '    }\n', '\n', '    // --- BEFORE HOOKS ---\n', '\n', '    function beforeTransfer(address sender, address recipient, uint256 amount) override external {}\n', '\n', '    function beforeTransferFrom(address msgSender, address sender, address recipient, uint256 amount) override external {}\n', '\n', '    function beforeApprove(address sender, address spender, uint256 amount) override external {}\n', '\n', '    function beforeIncreaseAllowance(address msgSender, address spender, uint256 addedValue) override external {}\n', '\n', '    function beforeDecreaseAllowance(address msgSender, address spender, uint256 subtractedValue) override external {}\n', '\n', '    // --- AFTER HOOKS ---\n', '\n', '    function afterApprove(address sender, address spender, uint256 amount) override external {}\n', '\n', '    function afterTransfer(address sender, address recipient, uint256 amount) override external {}\n', '\n', '    function afterTransferFrom(address msgSender, address sender, address recipient, uint256 amount) override external {}\n', '\n', '    function afterIncreaseAllowance(address sender, address spender, uint256 addedValue) override external {}\n', '\n', '    function afterDecreaseAllowance(address sender, address spender, uint256 subtractedValue) override external {}\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', 'import "../proxy/utils/Initializable.sol";\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract ContextUpgradeable is Initializable {\n', '    function __Context_init() internal initializer {\n', '        __Context_init_unchained();\n', '    }\n', '\n', '    function __Context_init_unchained() internal initializer {\n', '    }\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '    uint256[50] private __gap;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/ContextUpgradeable.sol";\n', 'import "../proxy/utils/Initializable.sol";\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    function __Pausable_init() internal initializer {\n', '        __Context_init_unchained();\n', '        __Pausable_init_unchained();\n', '    }\n', '\n', '    function __Pausable_init_unchained() internal initializer {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view virtual returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused(), "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused(), "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '    uint256[49] private __gap;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// solhint-disable-next-line compiler-version\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../../utils/AddressUpgradeable.sol";\n', '\n', '/**\n', ' * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed\n', " * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an\n", ' * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer\n', ' * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.\n', ' *\n', ' * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as\n', ' * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.\n', ' *\n', ' * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure\n', ' * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.\n', ' */\n', 'abstract contract Initializable {\n', '\n', '    /**\n', '     * @dev Indicates that the contract has been initialized.\n', '     */\n', '    bool private _initialized;\n', '\n', '    /**\n', '     * @dev Indicates that the contract is in the process of being initialized.\n', '     */\n', '    bool private _initializing;\n', '\n', '    /**\n', '     * @dev Modifier to protect an initializer function from being invoked twice.\n', '     */\n', '    modifier initializer() {\n', '        require(_initializing || !_initialized, "Initializable: contract is already initialized");\n', '\n', '        bool isTopLevelCall = !_initializing;\n', '        if (isTopLevelCall) {\n', '            _initializing = true;\n', '            _initialized = true;\n', '        }\n', '\n', '        _;\n', '\n', '        if (isTopLevelCall) {\n', '            _initializing = false;\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library AddressUpgradeable {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']