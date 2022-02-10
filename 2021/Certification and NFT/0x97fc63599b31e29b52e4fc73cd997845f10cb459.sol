['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-01\n', '*/\n', '\n', '// SPDX-License-Identifier: MPL-2.0\n', 'pragma solidity 0.7.6;\n', '\n', 'interface IVoteEmitter {\n', '\tevent Vote(address indexed dispatcher, address voter, uint8[] percentiles);\n', '\n', '\tfunction dispatch(address voter, uint8[] memory percentiles) external;\n', '}\n', '\n', 'contract VoteEmitter is IVoteEmitter {\n', '\tfunction dispatch(address voter, uint8[] memory percentiles)\n', '\t\texternal\n', '\t\toverride\n', '\t{\n', '\t\temit Vote(msg.sender, voter, percentiles);\n', '\t}\n', '}']