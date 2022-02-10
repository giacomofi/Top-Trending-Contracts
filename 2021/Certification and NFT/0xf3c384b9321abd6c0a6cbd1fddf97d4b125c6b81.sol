['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-28\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title S4fechainProxy\n', ' * @dev This contract combines an upgradeability proxy with basic authorization control functionalities\n', ' */\n', 'contract OwnedUpgradeabilityProxy {\n', '    /**\n', '     * @dev Event to show ownership has been transferred\n', '     * @param previousOwner representing the address of the previous owner\n', '     * @param newOwner representing the address of the new owner\n', '     */\n', '    event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '    /**\n', '     * @dev This event will be emitted every time the implementation gets upgraded\n', '     * @param implementation representing the address of the upgraded implementation\n', '     */\n', '    event Upgraded(address indexed implementation);\n', '\n', '    // Storage position of the address of the maintenance boolean\n', '    bytes32 private constant maintenancePosition = keccak256("com.s4fechain.proxy.maintenance");\n', '    // Storage position of the address of the current implementation\n', '    bytes32 private constant implementationPosition = keccak256("com.s4fechain.proxy.implementation");\n', '    // Storage position of the owner of the contract\n', '    bytes32 private constant proxyOwnerPosition = keccak256("com.s4fechain.proxy.owner");\n', '\n', '    /**\n', '     * @dev the constructor sets the original owner of the contract to the sender account.\n', '     */\n', '    constructor() {\n', '        setUpgradeabilityOwner(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Tells if contract is on maintenance\n', '     * @return _maintenance if contract is on maintenance\n', '     */\n', '    function maintenance() public view returns (bool _maintenance) {\n', '        bytes32 position = maintenancePosition;\n', '        assembly {\n', '            _maintenance := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Sets if contract is on maintenance\n', '     */\n', '    function setMaintenance(bool _maintenance) external onlyProxyOwner {\n', '        bytes32 position = maintenancePosition;\n', '        assembly {\n', '            sstore(position, _maintenance)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Tells the address of the owner\n', '     * @return owner the address of the owner\n', '     */\n', '    function proxyOwner() public view returns (address owner) {\n', '        bytes32 position = proxyOwnerPosition;\n', '        assembly {\n', '            owner := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of the owner\n', '     */\n', '    function setUpgradeabilityOwner(address newProxyOwner) internal {\n', '        bytes32 position = proxyOwnerPosition;\n', '        assembly {\n', '            sstore(position, newProxyOwner)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', "        require(newOwner != address(0), 'OwnedUpgradeabilityProxy: INVALID');\n", '        emit ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '        setUpgradeabilityOwner(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the proxy owner to upgrade the current version of the proxy.\n', '     * @param _implementation representing the address of the new implementation to be set.\n', '     */\n', '    function upgradeTo(address _implementation) public onlyProxyOwner {\n', '        _upgradeTo(_implementation);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation\n', '     * to initialize whatever is needed through a low level call.\n', '     * @param _implementation representing the address of the new implementation to be set.\n', '     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function\n', '     * signature of the implementation to be called with the needed payload\n', '     */\n', '    function upgradeToAndCall(address _implementation, bytes memory data) payable public onlyProxyOwner {\n', '        upgradeTo(_implementation);\n', '        (bool success, ) = address(this).call{ value: msg.value }(data);\n', '        require(success, "OwnedUpgradeabilityProxy: INVALID");\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '     * This function will return whatever the implementation call returns\n', '     */\n', '    fallback() external payable {\n', '        _fallback();\n', '    }\n', '\n', '    receive () external payable {\n', '        _fallback();\n', '    }\n', '\n', '    /**\n', '     * @dev Tells the address of the current implementation\n', '     * @return impl address of the current implementation\n', '     */\n', '    function implementation() public view returns (address impl) {\n', '        bytes32 position = implementationPosition;\n', '        assembly {\n', '            impl := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of the current implementation\n', '     * @param newImplementation address representing the new implementation to be set\n', '     */\n', '    function setImplementation(address newImplementation) internal {\n', '        bytes32 position = implementationPosition;\n', '        assembly {\n', '            sstore(position, newImplementation)\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Upgrades the implementation address\n', '     * @param newImplementation representing the address of the new implementation to be set\n', '     */\n', '    function _upgradeTo(address newImplementation) internal {\n', '        address currentImplementation = implementation();\n', "        require(currentImplementation != newImplementation, 'OwnedUpgradeabilityProxy: INVALID');\n", '        setImplementation(newImplementation);\n', '        emit Upgraded(newImplementation);\n', '    }\n', '\n', '    function _fallback() internal {\n', '        if (maintenance()) {\n', "            require(msg.sender == proxyOwner(), 'OwnedUpgradeabilityProxy: FORBIDDEN');\n", '        }\n', '        address _impl = implementation();\n', "        require(_impl != address(0), 'OwnedUpgradeabilityProxy: INVALID');\n", '        assembly {\n', '            let ptr := mload(0x40)\n', '            calldatacopy(ptr, 0, calldatasize())\n', '            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)\n', '            let size := returndatasize()\n', '            returndatacopy(ptr, 0, size)\n', '\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyProxyOwner() {\n', "        require(msg.sender == proxyOwner(), 'OwnedUpgradeabilityProxy: FORBIDDEN');\n", '        _;\n', '    }\n', '}']