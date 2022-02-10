['// File: contracts/lib/interface/IVirtContractResolver.sol\n', '\n', 'pragma solidity ^0.5.1;\n', '\n', '/**\n', ' * @title VirtContractResolver interface\n', ' */\n', 'interface IVirtContractResolver {\n', '    function deploy(bytes calldata _code, uint _nonce) external returns (bool);\n', '    \n', '    function resolve(bytes32 _virtAddr) external view returns (address);\n', '\n', '    event Deploy(bytes32 indexed virtAddr);\n', '}\n', '\n', '// File: contracts/VirtContractResolver.sol\n', '\n', 'pragma solidity ^0.5.1;\n', '\n', '\n', '/**\n', ' * @title Virtual Contract Resolver contract\n', ' * @notice Implementation of the Virtual Contract Resolver.\n', ' * @dev this resolver establishes the mapping from off-chain address to on-chain address\n', ' */\n', 'contract VirtContractResolver is IVirtContractResolver {\n', '    mapping(bytes32 => address) virtToRealMap;\n', '\n', '    /**\n', '     * @notice Deploy virtual contract to an on-chain address\n', '     * @param _code bytes of virtual contract code\n', '     * @param _nonce nonce associated to virtual contract code\n', '     * @return true if deployment succeeds\n', '     */\n', '    function deploy(bytes calldata _code, uint _nonce) external returns(bool) {\n', '        bytes32 virtAddr = keccak256(abi.encodePacked(_code, _nonce));\n', '        bytes memory c = _code;\n', '        require(virtToRealMap[virtAddr] == address(0), "Current real address is not 0");\n', '        address deployedAddress;\n', '        assembly {\n', '            deployedAddress := create(0, add(c, 32), mload(c))\n', '        }\n', "        require(deployedAddress != address(0), 'Create contract failed.');\n", '\n', '        virtToRealMap[virtAddr] = deployedAddress;\n', '        emit Deploy(virtAddr);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice look up the deployed address of a virtual address\n', '     * @param _virtAddr the virtual address to be looked up\n', '     * @return the deployed address of the input virtual address\n', '     */\n', '    function resolve(bytes32 _virtAddr) external view returns(address) {\n', "        require(virtToRealMap[_virtAddr] != address(0), 'Nonexistent virtual address');\n", '        return virtToRealMap[_virtAddr];\n', '    }\n', '}']