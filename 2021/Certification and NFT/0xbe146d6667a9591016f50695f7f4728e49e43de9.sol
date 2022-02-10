['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-03\n', '*/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'library StaticCallProxy {\n', '    function read(address _destination, bytes memory _calldata) public returns (bytes32) {\n', '        assembly {\n', '            let _calldatasize := calldatasize()\n', '            calldatacopy(0, 0, _calldatasize)\n', '            \n', '            // 0x9569bf28 = keccak256(readInternal(address,bytes))\n', '            mstore8(0, 0x95)\n', '            mstore8(add(0, 1), 0x69)\n', '            mstore8(add(0, 2), 0xbf)\n', '            mstore8(add(0, 3), 0x28)\n', '            pop(call(gas(), address(), 0, 0, _calldatasize, 0, 0))\n', '            returndatacopy(0, 0, returndatasize())\n', '            return(0, 32)\n', '        }\n', '    }\n', '}']