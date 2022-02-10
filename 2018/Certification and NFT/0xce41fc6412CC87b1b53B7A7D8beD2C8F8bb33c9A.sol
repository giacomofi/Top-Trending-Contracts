['pragma solidity 0.4.23;\n', '\n', '// File: contracts/upgradeability/EternalStorage.sol\n', '\n', '/**\n', ' * @title EternalStorage\n', ' * @dev This contract holds all the necessary state variables to carry out the storage of any contract.\n', ' */\n', 'contract EternalStorage {\n', '\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '\n', '}\n', '\n', '// File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol\n', '\n', '/**\n', ' * @title UpgradeabilityOwnerStorage\n', ' * @dev This contract keeps track of the upgradeability owner\n', ' */\n', 'contract UpgradeabilityOwnerStorage {\n', '    // Owner of the contract\n', '    address private _upgradeabilityOwner;\n', '\n', '    /**\n', '    * @dev Tells the address of the owner\n', '    * @return the address of the owner\n', '    */\n', '    function upgradeabilityOwner() public view returns (address) {\n', '        return _upgradeabilityOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Sets the address of the owner\n', '    */\n', '    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {\n', '        _upgradeabilityOwner = newUpgradeabilityOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeability/Proxy.sol\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Gives the possibility to delegate any call to a foreign implementation.\n', ' */\n', 'contract Proxy {\n', '\n', '  /**\n', '  * @dev Tells the address of the implementation where every call will be delegated.\n', '  * @return address of the implementation to which it will be delegated\n', '  */\n', '    function implementation() public view returns (address);\n', '\n', '  /**\n', '  * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '  * This function will return whatever the implementation call returns\n', '  */\n', '    function () payable public {\n', '        address _impl = implementation();\n', '        require(_impl != address(0));\n', '        assembly {\n', '            /*\n', '                0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)\n', '                loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty\n', '                memory. It&#39;s needed because we&#39;re going to write the return data of delegatecall to the\n', '                free memory slot.\n', '            */\n', '            let ptr := mload(0x40)\n', '            /*\n', '                `calldatacopy` is copy calldatasize bytes from calldata\n', '                First argument is the destination to which data is copied(ptr)\n', '                Second argument specifies the start position of the copied data.\n', '                    Since calldata is sort of its own unique location in memory,\n', '                    0 doesn&#39;t refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.\n', '                    That&#39;s always going to be the zeroth byte of the function selector.\n', '                Third argument, calldatasize, specifies how much data will be copied.\n', '                    calldata is naturally calldatasize bytes long (same thing as msg.data.length)\n', '            */\n', '            calldatacopy(ptr, 0, calldatasize)\n', '            /*\n', '                delegatecall params explained:\n', '                gas: the amount of gas to provide for the call. `gas` is an Opcode that gives\n', '                    us the amount of gas still available to execution\n', '\n', '                _impl: address of the contract to delegate to\n', '\n', '                ptr: to pass copied data\n', '\n', '                calldatasize: loads the size of `bytes memory data`, same as msg.data.length\n', '\n', '                0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,\n', '                        these are set to 0, 0 so the output data will not be written to memory. The output\n', '                        data will be read using `returndatasize` and `returdatacopy` instead.\n', '\n', '                result: This will be 0 if the call fails and 1 if it succeeds\n', '            */\n', '            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)\n', '            /*\n', '\n', '            */\n', '            /*\n', '                ptr current points to the value stored at 0x40,\n', '                because we assigned it like ptr := mload(0x40).\n', '                Because we use 0x40 as a free memory pointer,\n', '                we want to make sure that the next time we want to allocate memory,\n', '                we aren&#39;t overwriting anything important.\n', '                So, by adding ptr and returndatasize,\n', '                we get a memory location beyond the end of the data we will be copying to ptr.\n', '                We place this in at 0x40, and any reads from 0x40 will now read from free memory\n', '            */\n', '            mstore(0x40, add(ptr, returndatasize))\n', '            /*\n', '                `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the\n', '                    slot it will copy to, 0 means copy from the beginning of the return data, and size is\n', '                    the amount of data to copy.\n', '                `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall\n', '            */\n', '            returndatacopy(ptr, 0, returndatasize)\n', '\n', '            /*\n', '                if `result` is 0, revert.\n', '                if `result` is 1, return `size` amount of data from `ptr`. This is the data that was\n', '                copied to `ptr` from the delegatecall return data\n', '            */\n', '            switch result\n', '            case 0 { revert(ptr, returndatasize) }\n', '            default { return(ptr, returndatasize) }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeability/UpgradeabilityStorage.sol\n', '\n', '/**\n', ' * @title UpgradeabilityStorage\n', ' * @dev This contract holds all the necessary state variables to support the upgrade functionality\n', ' */\n', 'contract UpgradeabilityStorage {\n', '    // Version name of the current implementation\n', '    uint256 internal _version;\n', '\n', '    // Address of the current implementation\n', '    address internal _implementation;\n', '\n', '    /**\n', '    * @dev Tells the version name of the current implementation\n', '    * @return string representing the name of the current version\n', '    */\n', '    function version() public view returns (uint256) {\n', '        return _version;\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the current implementation\n', '    * @return address of the current implementation\n', '    */\n', '    function implementation() public view returns (address) {\n', '        return _implementation;\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeability/UpgradeabilityProxy.sol\n', '\n', '/**\n', ' * @title UpgradeabilityProxy\n', ' * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded\n', ' */\n', 'contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {\n', '    /**\n', '    * @dev This event will be emitted every time the implementation gets upgraded\n', '    * @param version representing the version name of the upgraded implementation\n', '    * @param implementation representing the address of the upgraded implementation\n', '    */\n', '    event Upgraded(uint256 version, address indexed implementation);\n', '\n', '    /**\n', '    * @dev Upgrades the implementation address\n', '    * @param version representing the version name of the new implementation to be set\n', '    * @param implementation representing the address of the new implementation to be set\n', '    */\n', '    function _upgradeTo(uint256 version, address implementation) internal {\n', '        require(_implementation != implementation);\n', '        require(version > _version);\n', '        _version = version;\n', '        _implementation = implementation;\n', '        emit Upgraded(version, implementation);\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol\n', '\n', '/**\n', ' * @title OwnedUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with basic authorization control functionalities\n', ' */\n', 'contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {\n', '  /**\n', '  * @dev Event to show ownership has been transferred\n', '  * @param previousOwner representing the address of the previous owner\n', '  * @param newOwner representing the address of the new owner\n', '  */\n', '    event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '    /**\n', '    * @dev the constructor sets the original owner of the contract to the sender account.\n', '    */\n', '     constructor() public {\n', '        setUpgradeabilityOwner(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyProxyOwner() {\n', '        require(msg.sender == proxyOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the proxy owner\n', '    * @return the address of the proxy owner\n', '    */\n', '    function proxyOwner() public view returns (address) {\n', '        return upgradeabilityOwner();\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '        require(newOwner != address(0));\n', '        emit ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '        setUpgradeabilityOwner(newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the upgradeability owner to upgrade the current version of the proxy.\n', '    * @param version representing the version name of the new implementation to be set.\n', '    * @param implementation representing the address of the new implementation to be set.\n', '    */\n', '    function upgradeTo(uint256 version, address implementation) public onlyProxyOwner {\n', '        _upgradeTo(version, implementation);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation\n', '    * to initialize whatever is needed through a low level call.\n', '    * @param version representing the version name of the new implementation to be set.\n', '    * @param implementation representing the address of the new implementation to be set.\n', '    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function\n', '    * signature of the implementation to be called with the needed payload\n', '    */\n', '    function upgradeToAndCall(uint256 version, address implementation, bytes data) payable public onlyProxyOwner {\n', '        upgradeTo(version, implementation);\n', '        require(address(this).call.value(msg.value)(data));\n', '    }\n', '}\n', '\n', '// File: contracts/EternalStorageProxyForStormMultisender.sol\n', '\n', '// Roman Storm Multi Sender\n', '// To Use this Dapp: https://poanetwork.github.io/multisender\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title EternalStorageProxy\n', ' * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.\n', ' * Besides, it allows to upgrade the token&#39;s behaviour towards further implementations, and provides basic\n', ' * authorization control functionalities\n', ' */\n', 'contract EternalStorageProxyForStormMultisender is OwnedUpgradeabilityProxy, EternalStorage {\n', '\n', '\n', '}']