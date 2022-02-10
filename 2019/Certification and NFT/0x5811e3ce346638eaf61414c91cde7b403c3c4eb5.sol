['/**\n', ' *Submitted for verification at Etherscan.io on 2021-01-31\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title IRegistry\n', ' * @dev This contract represents the interface of a registry contract\n', ' */\n', 'interface ITwoKeySingletonesRegistry {\n', '\n', '    /**\n', '    * @dev This event will be emitted every time a new proxy is created\n', '    * @param proxy representing the address of the proxy created\n', '    */\n', '    event ProxyCreated(address proxy);\n', '\n', '\n', '    /**\n', '    * @dev This event will be emitted every time a new implementation is registered\n', '    * @param version representing the version name of the registered implementation\n', '    * @param implementation representing the address of the registered implementation\n', '    * @param contractName is the name of the contract we added new version\n', '    */\n', '    event VersionAdded(string version, address implementation, string contractName);\n', '\n', '    /**\n', '    * @dev Registers a new version with its implementation address\n', '    * @param version representing the version name of the new implementation to be registered\n', '    * @param implementation representing the address of the new implementation to be registered\n', '    */\n', '    function addVersion(string _contractName, string version, address implementation) public;\n', '\n', '    /**\n', '    * @dev Tells the address of the implementation for a given version\n', "    * @param _contractName is the name of the contract we're querying\n", '    * @param version to query the implementation of\n', '    * @return address of the implementation registered for the given version\n', '    */\n', '    function getVersion(string _contractName, string version) public view returns (address);\n', '}\n', '\n', '\n', '/**\n', ' * @title Proxy\n', ' */\n', 'contract Proxy {\n', '\n', '\n', '    // Gives the possibility to delegate any call to a foreign implementation.\n', '\n', '\n', '    /**\n', '    * @dev Tells the address of the implementation where every call will be delegated.\n', '    * @return address of the implementation to which it will be delegated\n', '    */\n', '    function implementation() public view returns (address);\n', '\n', '    /**\n', '    * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '    * This function will return whatever the implementation call returns\n', '    */\n', '    function () payable public {\n', '        address _impl = implementation();\n', '        require(_impl != address(0));\n', '\n', '        assembly {\n', '            let ptr := mload(0x40)\n', '            calldatacopy(ptr, 0, calldatasize)\n', '            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)\n', '            let size := returndatasize\n', '            returndatacopy(ptr, 0, size)\n', '\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @author Nikola Madjarevic\n', ' * @dev This contract holds all the necessary state variables to support the upgrade functionality\n', ' */\n', 'contract UpgradeabilityStorage {\n', '    // Versions registry\n', '    ITwoKeySingletonesRegistry internal registry;\n', '\n', '    // Address of the current implementation\n', '    address internal _implementation;\n', '\n', '    /**\n', '    * @dev Tells the address of the current implementation\n', '    * @return address of the current implementation\n', '    */\n', '    function implementation() public view returns (address) {\n', '        return _implementation;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title UpgradeabilityProxy\n', ' * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded\n', ' */\n', 'contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {\n', '\n', '    //TODO: Add event through event source whenever someone calls upgradeTo\n', '    /**\n', '    * @dev Constructor function\n', '    */\n', '    constructor (string _contractName, string _version) public {\n', '        registry = ITwoKeySingletonesRegistry(msg.sender);\n', '        _implementation = registry.getVersion(_contractName, _version);\n', '    }\n', '\n', '    /**\n', '    * @dev Upgrades the implementation to the requested version\n', '    * @param _version representing the version name of the new implementation to be set\n', '    */\n', '    function upgradeTo(string _contractName, string _version, address _impl) public {\n', '        require(msg.sender == address(registry));\n', '        require(_impl != address(0));\n', '        _implementation = _impl;\n', '    }\n', '\n', '}']