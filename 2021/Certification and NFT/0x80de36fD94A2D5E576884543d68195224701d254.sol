['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.8.0;\n', '\n', 'contract Migrations {\n', '    address public owner = msg.sender;\n', '    uint256 public last_completed_migration;\n', '\n', '    modifier restricted() {\n', '        require(\n', '            msg.sender == owner,\n', '            "This function is restricted to the contract\'s owner"\n', '        );\n', '        _;\n', '    }\n', '\n', '    function setCompleted(uint256 completed) public restricted {\n', '        last_completed_migration = completed;\n', '    }\n', '}\n', '\n', '{\n', '  "remappings": [],\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']