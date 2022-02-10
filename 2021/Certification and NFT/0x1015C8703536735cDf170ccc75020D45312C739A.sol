['// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";\n', '\n', 'import "./TokenListener.sol";\n', '\n', 'contract UnsafeTokenListenerDelegator is TokenListener, Initializable {\n', '\n', '  event Initialized(TokenListenerInterface unsafeTokenListener);\n', '\n', '  TokenListenerInterface public unsafeTokenListener;\n', '\n', '  function initialize (TokenListenerInterface _unsafeTokenListener) external initializer {\n', '    unsafeTokenListener = _unsafeTokenListener;\n', '\n', '    emit Initialized(unsafeTokenListener);\n', '  }\n', '\n', '  /// @notice Called when tokens are minted.\n', '  /// @param to The address of the receiver of the minted tokens.\n', '  /// @param amount The amount of tokens being minted\n', '  /// @param controlledToken The address of the token that is being minted\n', '  /// @param referrer The address that referred the minting.\n', '  function beforeTokenMint(address to, uint256 amount, address controlledToken, address referrer) external override {\n', '    unsafeTokenListener.beforeTokenMint(to, amount, controlledToken, referrer);\n', '  }\n', '\n', '  /// @notice Called when tokens are transferred or burned.\n', '  /// @param from The address of the sender of the token transfer\n', '  /// @param to The address of the receiver of the token transfer.  Will be the zero address if burning.\n', '  /// @param amount The amount of tokens transferred\n', '  /// @param controlledToken The address of the token that was transferred\n', '  function beforeTokenTransfer(address from, address to, uint256 amount, address controlledToken) external override {\n', '    unsafeTokenListener.beforeTokenTransfer(from, to, amount, controlledToken);\n', '  }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// solhint-disable-next-line compiler-version\n', 'pragma solidity >=0.4.24 <0.8.0;\n', '\n', 'import "../utils/AddressUpgradeable.sol";\n', '\n', '/**\n', ' * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed\n', " * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an\n", ' * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer\n', ' * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.\n', ' *\n', ' * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as\n', ' * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.\n', ' *\n', ' * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure\n', ' * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.\n', ' */\n', 'abstract contract Initializable {\n', '\n', '    /**\n', '     * @dev Indicates that the contract has been initialized.\n', '     */\n', '    bool private _initialized;\n', '\n', '    /**\n', '     * @dev Indicates that the contract is in the process of being initialized.\n', '     */\n', '    bool private _initializing;\n', '\n', '    /**\n', '     * @dev Modifier to protect an initializer function from being invoked twice.\n', '     */\n', '    modifier initializer() {\n', '        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");\n', '\n', '        bool isTopLevelCall = !_initializing;\n', '        if (isTopLevelCall) {\n', '            _initializing = true;\n', '            _initialized = true;\n', '        }\n', '\n', '        _;\n', '\n', '        if (isTopLevelCall) {\n', '            _initializing = false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns true if and only if the function is running in the constructor\n', '    function _isConstructor() private view returns (bool) {\n', '        return !AddressUpgradeable.isContract(address(this));\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.4;\n', '\n', 'import "./TokenListenerInterface.sol";\n', 'import "./TokenListenerLibrary.sol";\n', 'import "../Constants.sol";\n', '\n', 'abstract contract TokenListener is TokenListenerInterface {\n', '  function supportsInterface(bytes4 interfaceId) external override view returns (bool) {\n', '    return (\n', '      interfaceId == Constants.ERC165_INTERFACE_ID_ERC165 || \n', '      interfaceId == TokenListenerLibrary.ERC165_INTERFACE_ID_TOKEN_LISTENER\n', '    );\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library AddressUpgradeable {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', 'import "@openzeppelin/contracts-upgradeable/introspection/IERC165Upgradeable.sol";\n', '\n', '/// @title An interface that allows a contract to listen to token mint, transfer and burn events.\n', 'interface TokenListenerInterface is IERC165Upgradeable {\n', '  /// @notice Called when tokens are minted.\n', '  /// @param to The address of the receiver of the minted tokens.\n', '  /// @param amount The amount of tokens being minted\n', '  /// @param controlledToken The address of the token that is being minted\n', '  /// @param referrer The address that referred the minting.\n', '  function beforeTokenMint(address to, uint256 amount, address controlledToken, address referrer) external;\n', '\n', '  /// @notice Called when tokens are transferred or burned.\n', '  /// @param from The address of the sender of the token transfer\n', '  /// @param to The address of the receiver of the token transfer.  Will be the zero address if burning.\n', '  /// @param amount The amount of tokens transferred\n', '  /// @param controlledToken The address of the token that was transferred\n', '  function beforeTokenTransfer(address from, address to, uint256 amount, address controlledToken) external;\n', '}\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'library TokenListenerLibrary {\n', '  /*\n', "    *     bytes4(keccak256('beforeTokenMint(address,uint256,address,address)')) == 0x4d7f3db0\n", "    *     bytes4(keccak256('beforeTokenTransfer(address,address,uint256,address)')) == 0xb2210957\n", '    *\n', '    *     => 0x4d7f3db0 ^ 0xb2210957 == 0xff5e34e7\n', '    */\n', '  bytes4 public constant ERC165_INTERFACE_ID_TOKEN_LISTENER = 0xff5e34e7;\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity >=0.6.0 <0.7.0;\n', '\n', 'import "@openzeppelin/contracts-upgradeable/introspection/IERC1820RegistryUpgradeable.sol";\n', '\n', 'library Constants {\n', '  IERC1820RegistryUpgradeable public constant REGISTRY = IERC1820RegistryUpgradeable(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);\n', '\n', '  // keccak256("ERC777TokensSender")\n', '  bytes32 public constant TOKENS_SENDER_INTERFACE_HASH =\n', '  0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;\n', '\n', '  // keccak256("ERC777TokensRecipient")\n', '  bytes32 public constant TOKENS_RECIPIENT_INTERFACE_HASH =\n', '  0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;\n', '\n', '  // keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));\n', '  bytes32 public constant ACCEPT_MAGIC =\n', '  0xa2ef4600d742022d532d4747cb3547474667d6f13804902513b2ec01c848f4b4;\n', '\n', '  bytes4 public constant ERC165_INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '  bytes4 public constant ERC165_INTERFACE_ID_ERC721 = 0x80ac58cd;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165Upgradeable {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the global ERC1820 Registry, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register\n', ' * implementers for interfaces in this registry, as well as query support.\n', ' *\n', ' * Implementers may be shared by multiple accounts, and can also implement more\n', ' * than a single interface for each account. Contracts can implement interfaces\n', ' * for themselves, but externally-owned accounts (EOA) must delegate this to a\n', ' * contract.\n', ' *\n', ' * {IERC165} interfaces can also be queried via the registry.\n', ' *\n', ' * For an in-depth explanation and source code analysis, see the EIP text.\n', ' */\n', 'interface IERC1820RegistryUpgradeable {\n', '    /**\n', '     * @dev Sets `newManager` as the manager for `account`. A manager of an\n', '     * account is able to set interface implementers for it.\n', '     *\n', '     * By default, each account is its own manager. Passing a value of `0x0` in\n', '     * `newManager` will reset the manager to this initial state.\n', '     *\n', '     * Emits a {ManagerChanged} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must be the current manager for `account`.\n', '     */\n', '    function setManager(address account, address newManager) external;\n', '\n', '    /**\n', '     * @dev Returns the manager for `account`.\n', '     *\n', '     * See {setManager}.\n', '     */\n', '    function getManager(address account) external view returns (address);\n', '\n', '    /**\n', "     * @dev Sets the `implementer` contract as ``account``'s implementer for\n", '     * `interfaceHash`.\n', '     *\n', "     * `account` being the zero address is an alias for the caller's address.\n", '     * The zero address can also be used in `implementer` to remove an old one.\n', '     *\n', '     * See {interfaceHash} to learn how these are created.\n', '     *\n', '     * Emits an {InterfaceImplementerSet} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the caller must be the current manager for `account`.\n', '     * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not\n', '     * end in 28 zeroes).\n', '     * - `implementer` must implement {IERC1820Implementer} and return true when\n', '     * queried for support, unless `implementer` is the caller. See\n', '     * {IERC1820Implementer-canImplementInterfaceForAddress}.\n', '     */\n', '    function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;\n', '\n', '    /**\n', '     * @dev Returns the implementer of `interfaceHash` for `account`. If no such\n', '     * implementer is registered, returns the zero address.\n', '     *\n', '     * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28\n', '     * zeroes), `account` will be queried for support of it.\n', '     *\n', "     * `account` being the zero address is an alias for the caller's address.\n", '     */\n', '    function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);\n', '\n', '    /**\n', '     * @dev Returns the interface hash for an `interfaceName`, as defined in the\n', '     * corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].\n', '     */\n', '    function interfaceHash(string calldata interfaceName) external pure returns (bytes32);\n', '\n', '    /**\n', '     *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.\n', '     *  @param account Address of the contract for which to update the cache.\n', '     *  @param interfaceId ERC165 interface for which to update the cache.\n', '     */\n', '    function updateERC165Cache(address account, bytes4 interfaceId) external;\n', '\n', '    /**\n', '     *  @notice Checks whether a contract implements an ERC165 interface or not.\n', '     *  If the result is not cached a direct lookup on the contract address is performed.\n', '     *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling\n', '     *  {updateERC165Cache} with the contract address.\n', '     *  @param account Address of the contract to check.\n', '     *  @param interfaceId ERC165 interface to check.\n', '     *  @return True if `account` implements `interfaceId`, false otherwise.\n', '     */\n', '    function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);\n', '\n', '    /**\n', '     *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.\n', '     *  @param account Address of the contract to check.\n', '     *  @param interfaceId ERC165 interface to check.\n', '     *  @return True if `account` implements `interfaceId`, false otherwise.\n', '     */\n', '    function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);\n', '\n', '    event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);\n', '\n', '    event ManagerChanged(address indexed account, address indexed newManager);\n', '}']