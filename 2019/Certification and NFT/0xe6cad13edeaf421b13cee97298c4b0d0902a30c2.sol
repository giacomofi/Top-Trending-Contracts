['/**\n', ' * Copyright (c) 2018-present, Leap DAO (leapdao.org)\n', ' *\n', ' * This source code is licensed under the Mozilla Public License, version 2,\n', ' * found in the LICENSE file in the root directory of this source tree.\n', ' */\n', '\n', 'pragma solidity 0.5.2;\n', '\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Implements delegation of calls to other contracts, with proper\n', ' * forwarding of return values and bubbling of failures.\n', ' * It defines a fallback function that delegates all calls to the address\n', ' * returned by the abstract _implementation() internal function.\n', ' */\n', 'contract Proxy {\n', '  /**\n', '   * @dev Fallback function.\n', '   * Implemented entirely in `_fallback`.\n', '   */\n', '  function () external payable {\n', '    _fallback();\n', '  }\n', '\n', '  /**\n', '   * @return The Address of the implementation.\n', '   */\n', '  function _implementation() internal view returns (address);\n', '\n', '  /**\n', '   * @dev Delegates execution to an implementation contract.\n', "   * This is a low level function that doesn't return to its internal call site.\n", '   * It will return to the external caller whatever the implementation returns.\n', '   * @param implementation Address to delegate.\n', '   */\n', '  function _delegate(address implementation) internal {\n', '    assembly {\n', '      // Copy msg.data. We take full control of memory in this inline assembly\n', '      // block because it will not return to Solidity code. We overwrite the\n', '      // Solidity scratch pad at memory position 0.\n', '      calldatacopy(0, 0, calldatasize)\n', '\n', '      // Call the implementation.\n', "      // out and outsize are 0 because we don't know the size yet.\n", '      let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)\n', '\n', '      // Copy the returned data.\n', '      returndatacopy(0, 0, returndatasize)\n', '\n', '      switch result\n', '      // delegatecall returns 0 on error.\n', '      case 0 { revert(0, returndatasize) }\n', '      default { return(0, returndatasize) }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Function that is run as the first thing in the fallback function.\n', '   * Can be redefined in derived contracts to add functionality.\n', '   * Redefinitions must call super._willFallback().\n', '   */\n', '  function _willFallback() internal {\n', '  }\n', '\n', '  /**\n', '   * @dev fallback implementation.\n', '   * Extracted to enable manual triggering.\n', '   */\n', '  function _fallback() internal {\n', '    _willFallback();\n', '    _delegate(_implementation());\n', '  }\n', '}\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library Address {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title UpgradeabilityProxy\n', ' * @dev This contract implements a proxy that allows to change the\n', ' * implementation address to which it will delegate.\n', ' * Such a change is called an implementation upgrade.\n', ' */\n', 'contract UpgradeabilityProxy is Proxy {\n', '  /**\n', '   * @dev Emitted when the implementation is upgraded.\n', '   * @param implementation Address of the new implementation.\n', '   */\n', '  event Upgraded(address indexed implementation);\n', '\n', '  /**\n', '   * @dev Storage slot with the address of the current implementation.\n', '   * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is\n', '   * validated in the constructor.\n', '   */\n', '  bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;\n', '\n', '  /**\n', '   * @dev Contract constructor.\n', '   * @param _implementation Address of the initial implementation.\n', '   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.\n', '   */\n', '  constructor(address _implementation, bytes memory _data) public payable {\n', '    assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));\n', '    _setImplementation(_implementation);\n', '    if (_data.length > 0) {\n', '      bool rv;\n', '      (rv,) = _implementation.delegatecall(_data);\n', '      require(rv);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the current implementation.\n', '   * @return Address of the current implementation\n', '   */\n', '  function _implementation() internal view returns (address impl) {\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '    assembly {\n', '      impl := sload(slot)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrades the proxy to a new implementation.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _upgradeTo(address newImplementation) internal {\n', '    _setImplementation(newImplementation);\n', '    emit Upgraded(newImplementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the implementation address of the proxy.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function _setImplementation(address newImplementation) private {\n', '    require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");\n', '\n', '    bytes32 slot = IMPLEMENTATION_SLOT;\n', '\n', '    assembly {\n', '      sstore(slot, newImplementation)\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title AdminUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with an authorization\n', ' * mechanism for administrative tasks.\n', ' * All external functions in this contract must be guarded by the\n', ' * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity\n', ' * feature proposal that would enable this to be done automatically.\n', ' */\n', 'contract AdminUpgradeabilityProxy is UpgradeabilityProxy {\n', '  /**\n', '   * @dev Emitted when the administration has been transferred.\n', '   * @param previousAdmin Address of the previous admin.\n', '   * @param newAdmin Address of the new admin.\n', '   */\n', '  event AdminChanged(address previousAdmin, address newAdmin);\n', '\n', '  /**\n', '   * @dev Storage slot with the admin of the contract.\n', '   * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is\n', '   * validated in the constructor.\n', '   */\n', '  bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;\n', '\n', '  /**\n', '   * @dev Modifier to check whether the `msg.sender` is the admin.\n', '   * If it is, it will run the function. Otherwise, it will delegate the call\n', '   * to the implementation.\n', '   */\n', '  modifier ifAdmin() {\n', '    if (msg.sender == _admin()) {\n', '      _;\n', '    } else {\n', '      _fallback();\n', '    }\n', '  }\n', '\n', '  /**\n', '   * Contract constructor.\n', '   * It sets the `msg.sender` as the proxy administrator.\n', '   * @param _implementation address of the initial implementation.\n', '   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.\n', '   */\n', '  constructor(address _implementation, bytes memory _data) UpgradeabilityProxy(_implementation, _data) public payable {\n', '    assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));\n', '\n', '    _setAdmin(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @return The address of the proxy admin.\n', '   */\n', '  function admin() external ifAdmin returns (address) {\n', '    return _admin();\n', '  }\n', '\n', '  /**\n', '   * @return The address of the implementation.\n', '   */\n', '  function implementation() external ifAdmin returns (address) {\n', '    return _implementation();\n', '  }\n', '\n', '  /**\n', '   * @dev Changes the admin of the proxy.\n', '   * Only the current admin can call this function.\n', '   * @param newAdmin Address to transfer proxy administration to.\n', '   */\n', '  function changeAdmin(address newAdmin) external ifAdmin {\n', '    require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");\n', '    emit AdminChanged(_admin(), newAdmin);\n', '    _setAdmin(newAdmin);\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrade the backing implementation of the proxy.\n', '   * Only the admin can call this function.\n', '   * @param newImplementation Address of the new implementation.\n', '   */\n', '  function upgradeTo(address newImplementation) external ifAdmin {\n', '    _upgradeTo(newImplementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrade the backing implementation of the proxy and call a function\n', '   * on the new implementation.\n', '   * This is useful to initialize the proxied contract.\n', '   * @param newImplementation Address of the new implementation.\n', '   * @param data Data to send as msg.data in the low level call.\n', '   * It should include the signature and the parameters of the function to be called, as described in\n', '   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.\n', '   */\n', '  function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {\n', '    _upgradeTo(newImplementation);\n', '    bool rv;\n', '    (rv,) = newImplementation.delegatecall(data);\n', '    require(rv);\n', '  }\n', '\n', '  /**\n', '   * @return The admin slot.\n', '   */\n', '  function _admin() internal view returns (address adm) {\n', '    bytes32 slot = ADMIN_SLOT;\n', '    assembly {\n', '      adm := sload(slot)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the proxy admin.\n', '   * @param newAdmin Address of the new proxy admin.\n', '   */\n', '  function _setAdmin(address newAdmin) internal {\n', '    bytes32 slot = ADMIN_SLOT;\n', '\n', '    assembly {\n', '      sstore(slot, newAdmin)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Only fall back when the sender is not the admin.\n', '   */\n', '  function _willFallback() internal {\n', '    require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");\n', '    super._willFallback();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title AdminUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with an authorization\n', ' * mechanism for administrative tasks.\n', ' * All external functions in this contract must be guarded by the\n', ' * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity\n', ' * feature proposal that would enable this to be done automatically.\n', ' */\n', 'contract AdminableProxy is AdminUpgradeabilityProxy {\n', '\n', '  /**\n', '   * Contract constructor.\n', '   */\n', '  constructor(address _implementation, bytes memory _data) \n', '  AdminUpgradeabilityProxy(_implementation, _data) public payable {\n', '  }\n', '\n', '  /**\n', '   * @dev apply proposal.\n', '   */\n', '  function applyProposal(bytes calldata data) external ifAdmin returns (bool) {\n', '    bool rv;\n', '    (rv, ) = _implementation().delegatecall(data);\n', '    return rv;\n', '  }\n', '\n', '}']