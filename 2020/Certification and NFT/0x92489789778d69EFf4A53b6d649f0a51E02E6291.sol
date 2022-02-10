['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-30\n', '*/\n', '\n', 'pragma solidity 0.4.24;\n', '\n', 'contract Proxy {\n', '    function () payable external {\n', '        _fallback();\n', '    }\n', '\n', '    function _implementation() internal view returns (address);\n', '\n', '    function _delegate(address implementation) internal {\n', '        assembly {\n', '            calldatacopy(0, 0, calldatasize)\n', '\n', '            let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)\n', '            returndatacopy(0, 0, returndatasize)\n', '\n', '            switch result\n', '            case 0 { revert(0, returndatasize) }\n', '            default { return(0, returndatasize) }\n', '        }\n', '    }\n', '\n', '    function _willFallback() internal pure {\n', '    }\n', '\n', '    function _fallback() internal {\n', '        _willFallback();\n', '        _delegate(_implementation());\n', '    }\n', '}\n', '\n', 'library AddressUtils {\n', '\n', '    function isContract(address addr) internal view returns (bool) {\n', '        uint256 size;\n', '\n', '        assembly { size := extcodesize(addr) }\n', '        return size > 0;\n', '    }\n', '\n', '}\n', '\n', 'contract UpgradeabilityProxy is Proxy {\n', '    event Upgraded(address implementation);\n', '\n', '    bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;\n', '\n', '    constructor(address _implementation) public {\n', '        assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));\n', '\n', '        _setImplementation(_implementation);\n', '    }\n', '\n', '    function _implementation() internal view returns (address impl) {\n', '        bytes32 slot = IMPLEMENTATION_SLOT;\n', '        assembly {\n', '            impl := sload(slot)\n', '        }\n', '    }\n', '\n', '    function _upgradeTo(address newImplementation) internal {\n', '        _setImplementation(newImplementation);\n', '        emit Upgraded(newImplementation);\n', '    }\n', '\n', '    function _setImplementation(address newImplementation) private {\n', '        require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");\n', '\n', '        bytes32 slot = IMPLEMENTATION_SLOT;\n', '\n', '        assembly {\n', '            sstore(slot, newImplementation)\n', '        }\n', '    }\n', '}\n', '\n', 'contract AdminUpgradeabilityProxy is UpgradeabilityProxy {\n', '\n', '    event AdminChanged(address previousAdmin, address newAdmin);\n', '    event AdminUpdated(address newAdmin);\n', '\n', '    bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;\n', '    bytes32 private constant PENDING_ADMIN_SLOT = 0x54ac2bd5363dfe95a011c5b5a153968d77d153d212e900afce8624fdad74525c;\n', '\n', '    modifier ifAdmin() {\n', '        if (msg.sender == _admin()) {\n', '            _;\n', '        }/* else {\n', '        _fallback();\n', '        }*/\n', '    }\n', '\n', '    constructor(address _implementation) UpgradeabilityProxy(_implementation) public {\n', '        assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));\n', '\n', '        _setAdmin(msg.sender);\n', '    }\n', '\n', '    function admin() external view ifAdmin returns (address) {\n', '        return _admin();\n', '    }\n', '\n', '    function pendingAdmin() external view ifAdmin returns (address) {\n', '        return _pendingAdmin();\n', '    }\n', '\n', '    function implementation() external view ifAdmin returns (address) {\n', '        return _implementation();\n', '    }\n', '\n', '    function changeAdmin(address _newAdmin) external ifAdmin {\n', '        require(_newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");\n', '        require(_newAdmin != _admin(), "The current and new admin cannot be the same .");\n', '        require(_newAdmin != _pendingAdmin(), "Cannot set the newAdmin of a proxy to the same address .");\n', '        _setPendingAdmin(_newAdmin);\n', '        emit AdminChanged(_admin(), _newAdmin);\n', '    }\n', '\n', '    function updateAdmin() external {\n', '        address _newAdmin = _pendingAdmin();\n', '        require(_newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");\n', '        require(msg.sender == _newAdmin, "msg.sender and newAdmin must be the same .");\n', '        _setAdmin(_newAdmin);\n', '        _setPendingAdmin(address(0));\n', '        emit AdminUpdated(_newAdmin);\n', '    }\n', '\n', '    function upgradeTo(address newImplementation) external ifAdmin {\n', '        _upgradeTo(newImplementation);\n', '    }\n', '\n', '    function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {\n', '        _upgradeTo(newImplementation);\n', '        (bool success) = address(this).call.value(msg.value)(data);\n', '        require(success, "upgradeToAndCall-error");\n', '    }\n', '\n', '    function _admin() internal view returns (address adm) {\n', '        bytes32 slot = ADMIN_SLOT;\n', '        assembly {\n', '            adm := sload(slot)\n', '        }\n', '    }\n', '\n', '    function _pendingAdmin() internal view returns (address pendingAdm) {\n', '        bytes32 slot = PENDING_ADMIN_SLOT;\n', '        assembly {\n', '            pendingAdm := sload(slot)\n', '        }\n', '    }\n', '\n', '    function _setAdmin(address newAdmin) internal {\n', '        bytes32 slot = ADMIN_SLOT;\n', '\n', '        assembly {\n', '            sstore(slot, newAdmin)\n', '        }\n', '    }\n', '\n', '    function _setPendingAdmin(address pendingAdm) internal {\n', '        bytes32 slot = PENDING_ADMIN_SLOT;\n', '\n', '        assembly {\n', '            sstore(slot, pendingAdm)\n', '        }\n', '    }\n', '\n', '    function _willFallback() internal pure {\n', '        // require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");\n', '        super._willFallback();\n', '    }\n', '}\n', '\n', 'contract DistributionProxy is AdminUpgradeabilityProxy {\n', '    constructor(address _implementation) public AdminUpgradeabilityProxy(_implementation) {\n', '    }\n', '}']