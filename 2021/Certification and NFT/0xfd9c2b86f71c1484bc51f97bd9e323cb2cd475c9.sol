['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-25\n', '*/\n', '\n', '// Verified by Darwinia Network\n', '\n', '// hevm: flattened sources of src/ItemBaseProxy.sol\n', 'pragma solidity >=0.6.0 <0.7.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;\n', '\n', '////// lib/zeppelin-solidity/src/proxy/Proxy.sol\n', '// SPDX-License-Identifier: MIT\n', '\n', '/* pragma solidity ^0.6.0; */\n', '\n', '/**\n', ' * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM\n', ' * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to\n', ' * be specified by overriding the virtual {_implementation} function.\n', ' * \n', ' * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a\n', ' * different contract through the {_delegate} function.\n', ' * \n', ' * The success and return data of the delegated call will be returned back to the caller of the proxy.\n', ' */\n', 'abstract contract Proxy {\n', '    /**\n', '     * @dev Delegates the current call to `implementation`.\n', '     * \n', '     * This function does not return to its internall call site, it will return directly to the external caller.\n', '     */\n', '    function _delegate(address implementation) internal {\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            // Copy msg.data. We take full control of memory in this inline assembly\n', '            // block because it will not return to Solidity code. We overwrite the\n', '            // Solidity scratch pad at memory position 0.\n', '            calldatacopy(0, 0, calldatasize())\n', '\n', '            // Call the implementation.\n', "            // out and outsize are 0 because we don't know the size yet.\n", '            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)\n', '\n', '            // Copy the returned data.\n', '            returndatacopy(0, 0, returndatasize())\n', '\n', '            switch result\n', '            // delegatecall returns 0 on error.\n', '            case 0 { revert(0, returndatasize()) }\n', '            default { return(0, returndatasize()) }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function\n', '     * and {_fallback} should delegate.\n', '     */\n', '    function _implementation() internal virtual view returns (address);\n', '\n', '    /**\n', '     * @dev Delegates the current call to the address returned by `_implementation()`.\n', '     * \n', '     * This function does not return to its internall call site, it will return directly to the external caller.\n', '     */\n', '    function _fallback() internal {\n', '        _beforeFallback();\n', '        _delegate(_implementation());\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other\n', '     * function in the contract matches the call data.\n', '     */\n', '    fallback () payable external {\n', '        _fallback();\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data\n', '     * is empty.\n', '     */\n', '    receive () payable external {\n', '        _fallback();\n', '    }\n', '\n', '    /**\n', '     * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`\n', '     * call, or as part of the Solidity `fallback` or `receive` functions.\n', '     * \n', '     * If overriden should call `super._beforeFallback()`.\n', '     */\n', '    function _beforeFallback() internal virtual {\n', '    }\n', '}\n', '\n', '////// lib/zeppelin-solidity/src/utils/Address.sol\n', '// SPDX-License-Identifier: MIT\n', '\n', '/* pragma solidity ^0.6.2; */\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '////// lib/zeppelin-solidity/src/proxy/UpgradeableProxy.sol\n', '// SPDX-License-Identifier: MIT\n', '\n', '/* pragma solidity ^0.6.0; */\n', '\n', '/* import "./Proxy.sol"; */\n', '/* import "../utils/Address.sol"; */\n', '\n', '/**\n', ' * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an\n', ' * implementation address that can be changed. This address is stored in storage in the location specified by\n', " * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the\n", ' * implementation behind the proxy.\n', ' * \n', ' * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see\n', ' * {TransparentUpgradeableProxy}.\n', ' */\n', 'contract UpgradeableProxy is Proxy {\n', '    /**\n', '     * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.\n', '     * \n', "     * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded\n", '     * function call, and allows initializating the storage of the proxy like a Solidity constructor.\n', '     */\n', '    constructor(address _logic, bytes memory _data) public payable {\n', '        assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));\n', '        _setImplementation(_logic);\n', '        if(_data.length > 0) {\n', '            // solhint-disable-next-line avoid-low-level-calls\n', '            (bool success,) = _logic.delegatecall(_data);\n', '            require(success);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Emitted when the implementation is upgraded.\n', '     */\n', '    event Upgraded(address indexed implementation);\n', '\n', '    /**\n', '     * @dev Storage slot with the address of the current implementation.\n', '     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is\n', '     * validated in the constructor.\n', '     */\n', '    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n', '\n', '    /**\n', '     * @dev Returns the current implementation address.\n', '     */\n', '    function _implementation() internal override view returns (address impl) {\n', '        bytes32 slot = _IMPLEMENTATION_SLOT;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            impl := sload(slot)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Upgrades the proxy to a new implementation.\n', '     * \n', '     * Emits an {Upgraded} event.\n', '     */\n', '    function _upgradeTo(address newImplementation) internal {\n', '        _setImplementation(newImplementation);\n', '        emit Upgraded(newImplementation);\n', '    }\n', '\n', '    /**\n', '     * @dev Stores a new address in the EIP1967 implementation slot.\n', '     */\n', '    function _setImplementation(address newImplementation) private {\n', '        require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");\n', '\n', '        bytes32 slot = _IMPLEMENTATION_SLOT;\n', '\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            sstore(slot, newImplementation)\n', '        }\n', '    }\n', '}\n', '\n', '////// lib/zeppelin-solidity/src/proxy/TransparentUpgradeableProxy.sol\n', '// SPDX-License-Identifier: MIT\n', '\n', '/* pragma solidity ^0.6.0; */\n', '\n', '/* import "./UpgradeableProxy.sol"; */\n', '\n', '/**\n', ' * @dev This contract implements a proxy that is upgradeable by an admin.\n', ' * \n', ' * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector\n', ' * clashing], which can potentially be used in an attack, this contract uses the\n', ' * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two\n', ' * things that go hand in hand:\n', ' * \n', ' * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if\n', ' * that call matches one of the admin functions exposed by the proxy itself.\n', ' * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the\n', ' * implementation. If the admin tries to call a function on the implementation it will fail with an error that says\n', ' * "admin cannot fallback to proxy target".\n', ' * \n', ' * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing\n', " * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due\n", ' * to sudden errors when trying to call a function from the proxy implementation.\n', ' * \n', ' * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,\n', ' * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.\n', ' */\n', 'contract TransparentUpgradeableProxy is UpgradeableProxy {\n', '    /**\n', '     * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and\n', '     * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.\n', '     */\n', '    constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {\n', '        assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));\n', '        _setAdmin(_admin);\n', '    }\n', '\n', '    /**\n', '     * @dev Emitted when the admin account has changed.\n', '     */\n', '    event AdminChanged(address previousAdmin, address newAdmin);\n', '\n', '    /**\n', '     * @dev Storage slot with the admin of the contract.\n', '     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is\n', '     * validated in the constructor.\n', '     */\n', '    bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;\n', '\n', '    /**\n', '     * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.\n', '     */\n', '    modifier ifAdmin() {\n', '        if (msg.sender == _admin()) {\n', '            _;\n', '        } else {\n', '            _fallback();\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current admin.\n', '     * \n', '     * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.\n', '     * \n', '     * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the\n', '     * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.\n', '     * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`\n', '     */\n', '    function admin() external ifAdmin returns (address) {\n', '        return _admin();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current implementation.\n', '     * \n', '     * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.\n', '     * \n', '     * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the\n', '     * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.\n', '     * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`\n', '     */\n', '    function implementation() external ifAdmin returns (address) {\n', '        return _implementation();\n', '    }\n', '\n', '    /**\n', '     * @dev Changes the admin of the proxy.\n', '     * \n', '     * Emits an {AdminChanged} event.\n', '     * \n', '     * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.\n', '     */\n', '    function changeAdmin(address newAdmin) external ifAdmin {\n', '        require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");\n', '        emit AdminChanged(_admin(), newAdmin);\n', '        _setAdmin(newAdmin);\n', '    }\n', '\n', '    /**\n', '     * @dev Upgrade the implementation of the proxy.\n', '     * \n', '     * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.\n', '     */\n', '    function upgradeTo(address newImplementation) external ifAdmin {\n', '        _upgradeTo(newImplementation);\n', '    }\n', '\n', '    /**\n', '     * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified\n', '     * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the\n', '     * proxied contract.\n', '     * \n', '     * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.\n', '     */\n', '    function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {\n', '        _upgradeTo(newImplementation);\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success,) = newImplementation.delegatecall(data);\n', '        require(success);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current admin.\n', '     */\n', '    function _admin() internal view returns (address adm) {\n', '        bytes32 slot = _ADMIN_SLOT;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            adm := sload(slot)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Stores a new address in the EIP1967 admin slot.\n', '     */\n', '    function _setAdmin(address newAdmin) private {\n', '        bytes32 slot = _ADMIN_SLOT;\n', '\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            sstore(slot, newAdmin)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.\n', '     */\n', '    function _beforeFallback() internal override virtual {\n', '        require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");\n', '        super._beforeFallback();\n', '    }\n', '}\n', '\n', '////// src/ItemBaseProxy.sol\n', '/* pragma solidity ^0.6.7; */\n', '\n', '/* import "zeppelin-solidity/proxy/TransparentUpgradeableProxy.sol"; */\n', '\n', 'contract ItemBaseProxy is TransparentUpgradeableProxy {\n', '\tconstructor(\n', '\t\taddress _logic,\n', '\t\taddress _admin,\n', '\t\tbytes memory _data\n', '\t) public payable TransparentUpgradeableProxy(_logic, _admin, _data) {}\n', '}']