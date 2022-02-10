['pragma solidity ^0.4.24;\n', '\n', "import './UpgradeabilityProxy.sol';\n", '\n', '\n', 'contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {\n', '\n', '  event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '  // Storage position of the owner of the contract\n', '  bytes32 private constant proxyOwnerPosition = keccak256("org.zeppelinos.proxy.owner");\n', '\n', '  constructor() public {\n', '    setUpgradeabilityOwner(msg.sender);\n', '  }\n', '\n', '  modifier onlyProxyOwner() {\n', '    require(msg.sender == proxyOwner());\n', '    _;\n', '  }\n', '\n', '\n', '  function proxyOwner() public view returns (address owner) {\n', '    bytes32 position = proxyOwnerPosition;\n', '    assembly {\n', '      owner := sload(position)\n', '    }\n', '  }\n', '\n', '  function setUpgradeabilityOwner(address newProxyOwner) internal {\n', '    bytes32 position = proxyOwnerPosition;\n', '    assembly {\n', '      sstore(position, newProxyOwner)\n', '    }\n', '  }\n', '\n', '\n', '  function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '    require(newOwner != address(0));\n', '    emit ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '    setUpgradeabilityOwner(newOwner);\n', '  }\n', '\n', '  function upgradeTo(address implementation) public onlyProxyOwner {\n', '    _upgradeTo(implementation);\n', '  }\n', '\n', '  function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {\n', '    upgradeTo(implementation);\n', '    require(implementation.delegatecall(data));\n', '}\n', '}']