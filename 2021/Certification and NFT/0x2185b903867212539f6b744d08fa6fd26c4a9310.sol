['// SPDX-License-Identifier: MIT\n', '// solhint-disable const-name-snakecase\n', 'pragma solidity 0.6.10;\n', '\n', '/**\n', ' * @title OwnedUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with basic authorization control functionalities\n', ' */\n', 'contract OwnedUpgradeabilityProxy {\n', '    /**\n', '     * @dev Event to show ownership has been transferred\n', '     * @param previousOwner representing the address of the previous owner\n', '     * @param newOwner representing the address of the new owner\n', '     */\n', '    event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Event to show ownership transfer is pending\n', '     * @param currentOwner representing the address of the current owner\n', '     * @param pendingOwner representing the address of the pending owner\n', '     */\n', '    event NewPendingOwner(address currentOwner, address pendingOwner);\n', '\n', '    // Storage position of the owner and pendingOwner of the contract\n', '    bytes32 private constant proxyOwnerPosition = 0x6279e8199720cf3557ecd8b58d667c8edc486bd1cf3ad59ea9ebdfcae0d0dfac; //keccak256("trueUSD.proxy.owner");\n', '    bytes32 private constant pendingProxyOwnerPosition = 0x8ddbac328deee8d986ec3a7b933a196f96986cb4ee030d86cc56431c728b83f4; //keccak256("trueUSD.pending.proxy.owner");\n', '\n', '    /**\n', '     * @dev the constructor sets the original owner of the contract to the sender account.\n', '     */\n', '    constructor() public {\n', '        _setUpgradeabilityOwner(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyProxyOwner() {\n', '        require(msg.sender == proxyOwner(), "only Proxy Owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the pending owner.\n', '     */\n', '    modifier onlyPendingProxyOwner() {\n', '        require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Tells the address of the owner\n', '     * @return owner the address of the owner\n', '     */\n', '    function proxyOwner() public view returns (address owner) {\n', '        bytes32 position = proxyOwnerPosition;\n', '        assembly {\n', '            owner := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Tells the address of the owner\n', '     * @return pendingOwner the address of the pending owner\n', '     */\n', '    function pendingProxyOwner() public view returns (address pendingOwner) {\n', '        bytes32 position = pendingProxyOwnerPosition;\n', '        assembly {\n', '            pendingOwner := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of the owner\n', '     */\n', '    function _setUpgradeabilityOwner(address newProxyOwner) internal {\n', '        bytes32 position = proxyOwnerPosition;\n', '        assembly {\n', '            sstore(position, newProxyOwner)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of the owner\n', '     */\n', '    function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {\n', '        bytes32 position = pendingProxyOwnerPosition;\n', '        assembly {\n', '            sstore(position, newPendingProxyOwner)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', "     *changes the pending owner to newOwner. But doesn't actually transfer\n", '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferProxyOwnership(address newOwner) external onlyProxyOwner {\n', '        require(newOwner != address(0));\n', '        _setPendingUpgradeabilityOwner(newOwner);\n', '        emit NewPendingOwner(proxyOwner(), newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingOwner to claim ownership of the proxy\n', '     */\n', '    function claimProxyOwnership() external onlyPendingProxyOwner {\n', '        emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());\n', '        _setUpgradeabilityOwner(pendingProxyOwner());\n', '        _setPendingUpgradeabilityOwner(address(0));\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the proxy owner to upgrade the current version of the proxy.\n', '     * @param implementation representing the address of the new implementation to be set.\n', '     */\n', '    function upgradeTo(address implementation) public virtual onlyProxyOwner {\n', '        address currentImplementation;\n', '        bytes32 position = implementationPosition;\n', '        assembly {\n', '            currentImplementation := sload(position)\n', '        }\n', '        require(currentImplementation != implementation);\n', '        assembly {\n', '            sstore(position, implementation)\n', '        }\n', '        emit Upgraded(implementation);\n', '    }\n', '\n', '    /**\n', '     * @dev This event will be emitted every time the implementation gets upgraded\n', '     * @param implementation representing the address of the upgraded implementation\n', '     */\n', '    event Upgraded(address indexed implementation);\n', '\n', '    // Storage position of the address of the current implementation\n', '    bytes32 private constant implementationPosition = 0x6e41e0fbe643dfdb6043698bf865aada82dc46b953f754a3468eaa272a362dc7; //keccak256("trueUSD.proxy.implementation");\n', '\n', '    function implementation() public view returns (address impl) {\n', '        bytes32 position = implementationPosition;\n', '        assembly {\n', '            impl := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback functions allowing to perform a delegatecall to the given implementation.\n', '     * This function will return whatever the implementation call returns\n', '     */\n', '    fallback() external payable {\n', '        proxyCall();\n', '    }\n', '\n', '    receive() external payable {\n', '        proxyCall();\n', '    }\n', '\n', '    function proxyCall() internal {\n', '        bytes32 position = implementationPosition;\n', '\n', '        assembly {\n', '            let ptr := mload(0x40)\n', '            calldatacopy(ptr, returndatasize(), calldatasize())\n', '            let result := delegatecall(gas(), sload(position), ptr, calldatasize(), returndatasize(), returndatasize())\n', '            returndatacopy(ptr, 0, returndatasize())\n', '\n', '            switch result\n', '                case 0 {\n', '                    revert(ptr, returndatasize())\n', '                }\n', '                default {\n', '                    return(ptr, returndatasize())\n', '                }\n', '        }\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 20000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']