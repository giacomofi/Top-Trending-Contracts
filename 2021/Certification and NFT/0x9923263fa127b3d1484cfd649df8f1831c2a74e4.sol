['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-12\n', '*/\n', '\n', '// File: contracts/common/Proxy/IERCProxy.sol\n', '\n', 'pragma solidity 0.6.6;\n', '\n', 'interface IERCProxy {\n', '    function proxyType() external pure returns (uint256 proxyTypeId);\n', '\n', '    function implementation() external view returns (address codeAddr);\n', '}\n', '\n', '// File: contracts/common/Proxy/Proxy.sol\n', '\n', 'pragma solidity 0.6.6;\n', '\n', '\n', 'abstract contract Proxy is IERCProxy {\n', '    function delegatedFwd(address _dst, bytes memory _calldata) internal {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            let result := delegatecall(\n', '                sub(gas(), 10000),\n', '                _dst,\n', '                add(_calldata, 0x20),\n', '                mload(_calldata),\n', '                0,\n', '                0\n', '            )\n', '            let size := returndatasize()\n', '\n', '            let ptr := mload(0x40)\n', '            returndatacopy(ptr, 0, size)\n', '\n', '            // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.\n', '            // if the call returned error data, forward it\n', '            switch result\n', '                case 0 {\n', '                    revert(ptr, size)\n', '                }\n', '                default {\n', '                    return(ptr, size)\n', '                }\n', '        }\n', '    }\n', '\n', '    function proxyType() external virtual override pure returns (uint256 proxyTypeId) {\n', '        // Upgradeable proxy\n', '        proxyTypeId = 2;\n', '    }\n', '\n', '    function implementation() external virtual override view returns (address);\n', '}\n', '\n', '// File: contracts/common/Proxy/UpgradableProxy.sol\n', '\n', 'pragma solidity 0.6.6;\n', '\n', '\n', 'contract UpgradableProxy is Proxy {\n', '    event ProxyUpdated(address indexed _new, address indexed _old);\n', '    event ProxyOwnerUpdate(address _new, address _old);\n', '\n', '    bytes32 constant IMPLEMENTATION_SLOT = keccak256("matic.network.proxy.implementation");\n', '    bytes32 constant OWNER_SLOT = keccak256("matic.network.proxy.owner");\n', '\n', '    constructor(address _proxyTo) public {\n', '        setProxyOwner(msg.sender);\n', '        setImplementation(_proxyTo);\n', '    }\n', '\n', '    fallback() external payable {\n', '        delegatedFwd(loadImplementation(), msg.data);\n', '    }\n', '\n', '    receive() external payable {\n', '        delegatedFwd(loadImplementation(), msg.data);\n', '    }\n', '\n', '    modifier onlyProxyOwner() {\n', '        require(loadProxyOwner() == msg.sender, "NOT_OWNER");\n', '        _;\n', '    }\n', '\n', '    function proxyOwner() external view returns(address) {\n', '        return loadProxyOwner();\n', '    }\n', '\n', '    function loadProxyOwner() internal view returns(address) {\n', '        address _owner;\n', '        bytes32 position = OWNER_SLOT;\n', '        assembly {\n', '            _owner := sload(position)\n', '        }\n', '        return _owner;\n', '    }\n', '\n', '    function implementation() external override view returns (address) {\n', '        return loadImplementation();\n', '    }\n', '\n', '    function loadImplementation() internal view returns(address) {\n', '        address _impl;\n', '        bytes32 position = IMPLEMENTATION_SLOT;\n', '        assembly {\n', '            _impl := sload(position)\n', '        }\n', '        return _impl;\n', '    }\n', '\n', '    function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '        require(newOwner != address(0), "ZERO_ADDRESS");\n', '        emit ProxyOwnerUpdate(newOwner, loadProxyOwner());\n', '        setProxyOwner(newOwner);\n', '    }\n', '\n', '    function setProxyOwner(address newOwner) private {\n', '        bytes32 position = OWNER_SLOT;\n', '        assembly {\n', '            sstore(position, newOwner)\n', '        }\n', '    }\n', '\n', '    function updateImplementation(address _newProxyTo) public onlyProxyOwner {\n', '        require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");\n', '        require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");\n', '\n', '        emit ProxyUpdated(_newProxyTo, loadImplementation());\n', '        \n', '        setImplementation(_newProxyTo);\n', '    }\n', '\n', '    function updateAndCall(address _newProxyTo, bytes memory data) payable public onlyProxyOwner {\n', '        updateImplementation(_newProxyTo);\n', '\n', '        (bool success, bytes memory returnData) = address(this).call{value: msg.value}(data);\n', '        require(success, string(returnData));\n', '    }\n', '\n', '    function setImplementation(address _newProxyTo) private {\n', '        bytes32 position = IMPLEMENTATION_SLOT;\n', '        assembly {\n', '            sstore(position, _newProxyTo)\n', '        }\n', '    }\n', '    \n', '    function isContract(address _target) internal view returns (bool) {\n', '        if (_target == address(0)) {\n', '            return false;\n', '        }\n', '\n', '        uint256 size;\n', '        assembly {\n', '            size := extcodesize(_target)\n', '        }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '// File: contracts/root/TokenPredicates/MintableERC20PredicateProxy.sol\n', '\n', 'pragma solidity 0.6.6;\n', '\n', '\n', 'contract MintableERC20PredicateProxy is UpgradableProxy {\n', '    constructor(address _proxyTo)\n', '        public\n', '        UpgradableProxy(_proxyTo)\n', '    {}\n', '}']