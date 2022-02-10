['pragma solidity ^0.4.23;\n', '\n', '\n', '\n', 'contract EternalStorage {\n', '\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'contract Proxy {\n', '\n', '    function () public payable {\n', '        address _impl = implementation();\n', '        require(_impl != address(0));\n', '        bytes memory data = msg.data;\n', '\n', '        assembly {\n', '            let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)\n', '            let size := returndatasize\n', '\n', '            let ptr := mload(0x40)\n', '            returndatacopy(ptr, 0, size)\n', '\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '\n', '    function implementation() public view returns (address);\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'contract UpgradeabilityStorage {\n', '    string internal _version;\n', '\n', '    address internal _implementation;\n', '\n', '    function version() public view returns (string) {\n', '        return _version;\n', '    }\n', '\n', '    function implementation() public view returns (address) {\n', '        return _implementation;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', 'contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {\n', '\n', '    event Upgraded(string version, address indexed implementation);\n', '\n', '\n', '    function _upgradeTo(string version, address implementation) internal {\n', '        require(_implementation != implementation);\n', '        _version = version;\n', '        _implementation = implementation;\n', '        Upgraded(version, implementation);\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'contract UpgradeabilityOwnerStorage {\n', '    address private _upgradeabilityOwner;\n', '\n', '    function upgradeabilityOwner() public view returns (address) {\n', '        return _upgradeabilityOwner;\n', '    }\n', '\n', '\n', '    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {\n', '        _upgradeabilityOwner = newUpgradeabilityOwner;\n', '    }\n', '\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '\n', 'contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {\n', '\n', '    event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '\n', '    function OwnedUpgradeabilityProxy(address _owner) public {\n', '        setUpgradeabilityOwner(_owner);\n', '    }\n', '\n', '\n', '    modifier onlyProxyOwner() {\n', '        require(msg.sender == proxyOwner());\n', '        _;\n', '    }\n', '\n', '\n', '    function proxyOwner() public view returns (address) {\n', '        return upgradeabilityOwner();\n', '    }\n', '\n', '\n', '    function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '        require(newOwner != address(0));\n', '        ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '        setUpgradeabilityOwner(newOwner);\n', '    }\n', '\n', '\n', '    function upgradeTo(string version, address implementation) public onlyProxyOwner {\n', '        _upgradeTo(version, implementation);\n', '    }\n', '\n', '\n', '    function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {\n', '        upgradeTo(version, implementation);\n', '        require(this.call.value(msg.value)(data));\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', 'contract EternalStorageProxyForPayinMultisender is OwnedUpgradeabilityProxy, EternalStorage {\n', '\n', '    function EternalStorageProxyForPayinMultisender(address _owner) public OwnedUpgradeabilityProxy(_owner) {}\n', '\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '\n', '\n', 'contract EternalStorage {\n', '\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'contract Proxy {\n', '\n', '    function () public payable {\n', '        address _impl = implementation();\n', '        require(_impl != address(0));\n', '        bytes memory data = msg.data;\n', '\n', '        assembly {\n', '            let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)\n', '            let size := returndatasize\n', '\n', '            let ptr := mload(0x40)\n', '            returndatacopy(ptr, 0, size)\n', '\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '\n', '    function implementation() public view returns (address);\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'contract UpgradeabilityStorage {\n', '    string internal _version;\n', '\n', '    address internal _implementation;\n', '\n', '    function version() public view returns (string) {\n', '        return _version;\n', '    }\n', '\n', '    function implementation() public view returns (address) {\n', '        return _implementation;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', 'contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {\n', '\n', '    event Upgraded(string version, address indexed implementation);\n', '\n', '\n', '    function _upgradeTo(string version, address implementation) internal {\n', '        require(_implementation != implementation);\n', '        _version = version;\n', '        _implementation = implementation;\n', '        Upgraded(version, implementation);\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'contract UpgradeabilityOwnerStorage {\n', '    address private _upgradeabilityOwner;\n', '\n', '    function upgradeabilityOwner() public view returns (address) {\n', '        return _upgradeabilityOwner;\n', '    }\n', '\n', '\n', '    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {\n', '        _upgradeabilityOwner = newUpgradeabilityOwner;\n', '    }\n', '\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '\n', 'contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {\n', '\n', '    event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '\n', '    function OwnedUpgradeabilityProxy(address _owner) public {\n', '        setUpgradeabilityOwner(_owner);\n', '    }\n', '\n', '\n', '    modifier onlyProxyOwner() {\n', '        require(msg.sender == proxyOwner());\n', '        _;\n', '    }\n', '\n', '\n', '    function proxyOwner() public view returns (address) {\n', '        return upgradeabilityOwner();\n', '    }\n', '\n', '\n', '    function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '        require(newOwner != address(0));\n', '        ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '        setUpgradeabilityOwner(newOwner);\n', '    }\n', '\n', '\n', '    function upgradeTo(string version, address implementation) public onlyProxyOwner {\n', '        _upgradeTo(version, implementation);\n', '    }\n', '\n', '\n', '    function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {\n', '        upgradeTo(version, implementation);\n', '        require(this.call.value(msg.value)(data));\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', 'contract EternalStorageProxyForPayinMultisender is OwnedUpgradeabilityProxy, EternalStorage {\n', '\n', '    function EternalStorageProxyForPayinMultisender(address _owner) public OwnedUpgradeabilityProxy(_owner) {}\n', '\n', '}']
