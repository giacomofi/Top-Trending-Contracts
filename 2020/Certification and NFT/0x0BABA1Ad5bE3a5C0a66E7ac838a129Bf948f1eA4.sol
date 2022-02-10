['// SPDX-License-Identifier: UNLICENSED\n', '// This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs\n', '// with minor modifications.\n', 'pragma solidity ^0.7.0;\n', '\n', '\n', '// This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs\n', '// with minor modifications.\n', '\n', '\n', '\n', '// This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs\n', '// with minor modifications.\n', '\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Gives the possibility to delegate any call to a foreign implementation.\n', ' */\n', 'abstract contract Proxy {\n', '  /**\n', '  * @dev Tells the address of the implementation where every call will be delegated.\n', '  * @return impl address of the implementation to which it will be delegated\n', '  */\n', '  function implementation() public view virtual returns (address impl);\n', '\n', '  receive() payable external {\n', '    _fallback();\n', '  }\n', '\n', '  fallback() payable external {\n', '    _fallback();\n', '  }\n', '\n', '  function _fallback() private {\n', '    address _impl = implementation();\n', '    require(_impl != address(0));\n', '\n', '    assembly {\n', '      let ptr := mload(0x40)\n', '      calldatacopy(ptr, 0, calldatasize())\n', '      let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)\n', '      let size := returndatasize()\n', '      returndatacopy(ptr, 0, size)\n', '\n', '      switch result\n', '      case 0 { revert(ptr, size) }\n', '      default { return(ptr, size) }\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityProxy\n', ' * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded\n', ' */\n', 'contract UpgradeabilityProxy is Proxy {\n', '  /**\n', '   * @dev This event will be emitted every time the implementation gets upgraded\n', '   * @param implementation representing the address of the upgraded implementation\n', '   */\n', '  event Upgraded(address indexed implementation);\n', '\n', '  // Storage position of the address of the current implementation\n', '  bytes32 private constant implementationPosition = keccak256("org.zeppelinos.proxy.implementation");\n', '\n', '  /**\n', '   * @dev Constructor function\n', '   */\n', '  constructor() {}\n', '\n', '  /**\n', '   * @dev Tells the address of the current implementation\n', '   * @return impl address of the current implementation\n', '   */\n', '  function implementation() public view override returns (address impl) {\n', '    bytes32 position = implementationPosition;\n', '    assembly {\n', '      impl := sload(position)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the current implementation\n', '   * @param newImplementation address representing the new implementation to be set\n', '   */\n', '  function setImplementation(address newImplementation) internal {\n', '    bytes32 position = implementationPosition;\n', '    assembly {\n', '      sstore(position, newImplementation)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Upgrades the implementation address\n', '   * @param newImplementation representing the address of the new implementation to be set\n', '   */\n', '  function _upgradeTo(address newImplementation) internal {\n', '    address currentImplementation = implementation();\n', '    require(currentImplementation != newImplementation);\n', '    setImplementation(newImplementation);\n', '    emit Upgraded(newImplementation);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title OwnedUpgradabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with basic authorization control functionalities\n', ' */\n', 'contract OwnedUpgradabilityProxy is UpgradeabilityProxy {\n', '  /**\n', '  * @dev Event to show ownership has been transferred\n', '  * @param previousOwner representing the address of the previous owner\n', '  * @param newOwner representing the address of the new owner\n', '  */\n', '  event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '  // Storage position of the owner of the contract\n', '  bytes32 private constant proxyOwnerPosition = keccak256("org.zeppelinos.proxy.owner");\n', '\n', '  /**\n', '  * @dev the constructor sets the original owner of the contract to the sender account.\n', '  */\n', '  constructor() {\n', '    setUpgradabilityOwner(msg.sender);\n', '  }\n', '\n', '  /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '  modifier onlyProxyOwner() {\n', '    require(msg.sender == proxyOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Tells the address of the owner\n', '   * @return owner the address of the owner\n', '   */\n', '  function proxyOwner() public view returns (address owner) {\n', '    bytes32 position = proxyOwnerPosition;\n', '    assembly {\n', '      owner := sload(position)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the owner\n', '   */\n', '  function setUpgradabilityOwner(address newProxyOwner) internal {\n', '    bytes32 position = proxyOwnerPosition;\n', '    assembly {\n', '      sstore(position, newProxyOwner)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '    require(newOwner != address(0));\n', '    emit ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '    setUpgradabilityOwner(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the proxy owner to upgrade the current version of the proxy.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   */\n', '  function upgradeTo(address implementation) public onlyProxyOwner {\n', '    _upgradeTo(implementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation\n', '   * to initialize whatever is needed through a low level call.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function\n', '   * signature of the implementation to be called with the needed payload\n', '   */\n', '  function upgradeToAndCall(address implementation, bytes memory data) payable public onlyProxyOwner {\n', '    upgradeTo(implementation);\n', '    (bool success, ) = address(this).call{value: msg.value}(data);\n', '    require(success);\n', '  }\n', '}']