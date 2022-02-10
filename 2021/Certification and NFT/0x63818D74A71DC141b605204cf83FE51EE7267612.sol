['// SPDX-License-Identifier: Unlicense\n', 'pragma solidity >=0.7.6;\n', '\n', '// Audit-1: ok\n', 'interface IModule {\n', '  enum VotingStatus {\n', '    UNKNOWN,\n', '    OPEN,\n', '    CLOSED,\n', '    PASSED\n', '  }\n', '\n', '  function onCreateProposal (\n', '    bytes32 communityId,\n', '    uint256 totalMemberCount,\n', '    uint256 totalValueLocked,\n', '    address proposer,\n', '    uint256 proposerBalance,\n', '    uint256 startDate,\n', '    bytes calldata internalActions,\n', '    bytes calldata externalActions\n', '  ) external view;\n', '\n', '  function onProcessProposal (\n', '    bytes32 proposalId,\n', '    bytes32 communityId,\n', '    uint256 totalMemberCount,\n', '    uint256 totalVoteCount,\n', '    uint256 totalVotingShares,\n', '    uint256 totalVotingSignal,\n', '    uint256 totalValueLocked,\n', '    uint256 secondsPassed\n', '  ) external view returns (VotingStatus, uint256 secondsTillClose, uint256 quorumPercent);\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicense\n', 'pragma solidity >=0.7.6;\n', '\n', "import '../IModule.sol';\n", '\n', '/// @notice Signaling - used for gathering feedback and sentiment.\n', '/// * Continous voting, no deadlines and always open.\n', '/// * No quorum required.\n', '/// * 0.001% of TVL needed to propose.\n', '// Audit-1: ok\n', 'contract FeatureFarmSignaling is IModule {\n', '  /// @notice Called if a proposal gets created.\n', '  /// Requirements:\n', '  /// - proposerBalance needs to be at least 0.001% of TVL.\n', '  function onCreateProposal (\n', '    bytes32 /*communityId*/,\n', '    uint256 /*totalMemberCount*/,\n', '    uint256 totalValueLocked,\n', '    address /*proposer*/,\n', '    uint256 proposerBalance,\n', '    uint256 /*startDate*/,\n', '    bytes calldata /*internalActions*/,\n', '    bytes calldata /*externalActions*/\n', '  ) external pure override\n', '  {\n', '    uint256 minProposerBalance = totalValueLocked / 100_000;\n', '    require(\n', '      proposerBalance >= minProposerBalance,\n', "      'Not enough balance'\n", '    );\n', '  }\n', '\n', '  /// @notice Signaling Proposals are forever open.\n', '  /// The resulting voting signal is `totalVotingSignal / totalVoteCount` if `totalVoteCount > 0`,\n', '  /// else `0`.\n', '  function onProcessProposal (\n', '    bytes32 /*proposalId*/,\n', '    bytes32 /*communityId*/,\n', '    uint256 /*totalMemberCount*/,\n', '    uint256 totalVoteCount,\n', '    uint256 /*totalVotingShares*/,\n', '    uint256 totalVotingSignal,\n', '    uint256 /*totalValueLocked*/,\n', '    uint256 /*secondsPassed*/\n', '  ) external pure override returns (VotingStatus, uint256, uint256) {\n', '    return (VotingStatus.OPEN, uint256(-1), totalVoteCount == 0 ? 0 : totalVotingSignal / totalVoteCount);\n', '  }\n', '}\n', '\n', '{\n', '  "evmVersion": "berlin",\n', '  "libraries": {},\n', '  "metadata": {\n', '    "bytecodeHash": "none"\n', '  },\n', '  "optimizer": {\n', '    "details": {\n', '      "constantOptimizer": true,\n', '      "cse": true,\n', '      "deduplicate": true,\n', '      "jumpdestRemover": true,\n', '      "orderLiterals": false,\n', '      "peephole": true,\n', '      "yul": false\n', '    },\n', '    "runs": 256\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']