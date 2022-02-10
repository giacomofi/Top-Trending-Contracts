['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.7.0 <0.8.0;\n', '\n', "import './UpgradeabilityProxy.sol';\n", '\n', '/**\n', ' * @title OwnedUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with basic authorization control functionalities\n', ' */\n', 'contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {\n', '  /**\n', '  * @dev Event to show ownership has been transferred\n', '  * @param previousOwner representing the address of the previous owner\n', '  * @param newOwner representing the address of the new owner\n', '  */\n', '  event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '  // Storage position of the owner of the contract\n', '  bytes32 private constant proxyOwnerPosition = keccak256("org.beefledger.proxy.owner");\n', '\n', '  /**\n', '  * @dev the constructor sets the original owner of the contract to the sender account.\n', '  */\n', '  constructor() {\n', '    setUpgradeabilityOwner(msg.sender);\n', '  }\n', '\n', '  /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '  modifier onlyProxyOwner() {\n', '    require(msg.sender == proxyOwner(), "sender is not proxy owner");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Tells the address of the owner\n', '   * return the address of the owner\n', '   */\n', '  function proxyOwner() public view returns (address owner) {\n', '    bytes32 position = proxyOwnerPosition;\n', '    assembly {\n', '      owner := sload(position)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the owner\n', '   */\n', '  function setUpgradeabilityOwner(address newProxyOwner) internal {\n', '    bytes32 position = proxyOwnerPosition;\n', '    assembly {\n', '      sstore(position, newProxyOwner)\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '    require(newOwner != address(0), "new owner cannot be 0");\n', '    emit ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '    setUpgradeabilityOwner(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the proxy owner to upgrade the current version of the proxy.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   */\n', '  function upgradeTo(address implementation) public onlyProxyOwner {\n', '    _upgradeTo(implementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation\n', '   * to initialize whatever is needed through a low level call.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function\n', '   * signature of the implementation to be called with the needed payload\n', '   */\n', '  function upgradeToAndCall(address implementation, bytes memory data) payable public onlyProxyOwner {\n', '    upgradeTo(implementation);\n', '    (bool success,  ) = address(this).call{value: msg.value}(data);\n', '    require(success, "error");\n', '  }\n', '}']