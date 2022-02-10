['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-03\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-02\n', '*/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * Static call proxy\n', ' *\n', ' * Use case: Obtain the result of a contract write method from a view method without actually writing state\n', ' * Context: In EVM versions Byzantium or newer view methods utilize the `staticcall` opcode which enforces state to\n', ' *          remain unmodified as part of EVM execution. This proxy contract was made to allow easier access to write method\n', ' *          output from a view method without modifying state in newer versions of the EVM.\n', ' *\n', ' * Given a destination address and calldata:\n', ' * - Forward request to an internal method (readInternal)\n', ' * - Perform an eth_call to the destination address using calldata\n', ' * - Perform a revert to roll back state\n', ' * - Save the result of the call in a the revert message\n', ' * - Throw out the revert and return the revert message as a successful response\n', ' *\n', ' * Usage: IStaticCallProxy(proxyAddress).read(destination, abi.encodeWithSignature("method(uint256)", arg));\n', ' * \n', ' * Based on previous work from axic: https://gist.github.com/axic/fc61daf7775c56da02d21368865a9416\n', ' */\n', ' \n', 'interface IStaticCallProxy {\n', '    function read(address _destination, bytes _calldata) external view returns (uint256);\n', '}\n', '\n', 'contract StaticCallProxy {\n', '    uint256 i = 5;\n', '    function readInternal(address _destination, bytes _calldata) public view returns (bytes32) {\n', '        uint256 _calldata_length = _calldata.length;\n', '        assembly {\n', '            pop(call(gas(), _destination, 0, add(_calldata, 0x20), _calldata_length, 0, 0))\n', '            returndatacopy(0, 0, returndatasize())\n', '            revert(0, 32)\n', '        }\n', '    }\n', '\n', '    function read(address _destination, bytes memory _calldata) public view returns (bytes32) {\n', '        assembly {\n', '            let _calldatasize := calldatasize()\n', '            calldatacopy(0, 0, _calldatasize)\n', '\n', '            // 0x9569bf28 = keccak256(readInternal(address,bytes))\n', '            mstore8(0, 0x95)\n', '            mstore8(add(0, 1), 0x69)\n', '            mstore8(add(0, 2), 0xbf)\n', '            mstore8(add(0, 3), 0x28)\n', '            pop(call(gas(), address(), 0, 0, _calldatasize, 0, 0))\n', '            returndatacopy(0, 0, returndatasize())\n', '            return(0, 32)\n', '        }\n', '    }\n', '\n', '    function oldI() public view returns (uint256) {\n', '        return i;\n', '    }\n', '\n', '    function alterState() public returns (uint256) {\n', '        i = 7;\n', '        return i;\n', '    }\n', '    \n', '    function directGet() public view returns (uint256) {\n', '        return alterState();\n', '    }\n', '    \n', '    function newI() public view returns (uint256) {\n', '        return IStaticCallProxy(this).read(this, abi.encodeWithSignature("alterState()"));\n', '    }\n', '}']