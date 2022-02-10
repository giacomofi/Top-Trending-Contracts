['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./SafeMath.sol";\n', 'import "./sbVotesInterface.sol";\n', '\n', 'contract sbGovernor {\n', '    event CanceledTransaction(\n', '        bytes32 indexed txHash,\n', '        address indexed target,\n', '        uint256 value,\n', '        string signature,\n', '        bytes data,\n', '        uint256 eta\n', '    );\n', '    event ExecutedTransaction(\n', '        bytes32 indexed txHash,\n', '        address indexed target,\n', '        uint256 value,\n', '        string signature,\n', '        bytes data,\n', '        uint256 eta\n', '    );\n', '    event QueuedTransaction(\n', '        bytes32 indexed txHash,\n', '        address indexed target,\n', '        uint256 value,\n', '        string signature,\n', '        bytes data,\n', '        uint256 eta\n', '    );\n', '    event ProposalCreated(\n', '        uint256 id,\n', '        address proposer,\n', '        address[] targets,\n', '        uint256[] values,\n', '        string[] signatures,\n', '        bytes[] calldatas,\n', '        uint256 startBlock,\n', '        uint256 endBlock,\n', '        string description\n', '    );\n', '    event Voted(address voter, uint256 proposalId, bool support, uint256 votes);\n', '    event ProposalCanceled(uint256 id);\n', '    event ProposalQueued(uint256 id, uint256 eta);\n', '    event ProposalExecuted(uint256 id);\n', '\n', '    using SafeMath for uint256;\n', '\n', '    sbVotesInterface public sbVotes;\n', '\n', '    bool public initDone;\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    address public superAdmin;\n', '    address public pendingSuperAdmin;\n', '\n', '    uint256 public quorumVotesInWei;\n', '    uint256 public proposalThresholdInWei;\n', '    uint256 public proposalMaxOperations;\n', '    uint256 public votingDelayInBlocks;\n', '    uint256 public votingPeriodInBlocks;\n', '    uint256 public queuePeriodInSeconds;\n', '    uint256 public gracePeriodInSeconds;\n', '\n', '    uint256 public proposalCount;\n', '\n', '    mapping(uint256 => address) public proposalProposer;\n', '    mapping(uint256 => uint256) public proposalEta;\n', '    mapping(uint256 => address[]) public proposalTargets;\n', '    mapping(uint256 => uint256[]) public proposalValues;\n', '    mapping(uint256 => string[]) public proposalSignatures;\n', '    mapping(uint256 => bytes[]) public proposalCalldatas;\n', '    mapping(uint256 => uint256) public proposalStartBlock;\n', '    mapping(uint256 => uint256) public proposalEndBlock;\n', '    mapping(uint256 => uint256) public proposalForVotes;\n', '    mapping(uint256 => uint256) public proposalAgainstVotes;\n', '    mapping(uint256 => bool) public proposalCanceled;\n', '    mapping(uint256 => bool) public proposalExecuted;\n', '    mapping(uint256 => mapping(address => bool)) public proposalVoterHasVoted;\n', '    mapping(uint256 => mapping(address => bool)) public proposalVoterSupport;\n', '    mapping(uint256 => mapping(address => uint96)) public proposalVoterVotes;\n', '\n', '    mapping(address => uint256) public latestProposalIds;\n', '    mapping(bytes32 => bool) public queuedTransactions;\n', '\n', '    mapping(string => uint256) public possibleProposalStatesMapping;\n', '    string[] public possibleProposalStatesArray;\n', '\n', '    function init(\n', '        address sbVotesAddress,\n', '        address adminAddress,\n', '        address superAdminAddress\n', '    ) public {\n', '        require(!initDone, "init done");\n', '        sbVotes = sbVotesInterface(sbVotesAddress);\n', '        admin = adminAddress;\n', '        superAdmin = superAdminAddress;\n', '        possibleProposalStatesMapping["Pending"] = 0;\n', '        possibleProposalStatesArray.push("Pending");\n', '        possibleProposalStatesMapping["Active"] = 1;\n', '        possibleProposalStatesArray.push("Active");\n', '        possibleProposalStatesMapping["Canceled"] = 2;\n', '        possibleProposalStatesArray.push("Canceled");\n', '        possibleProposalStatesMapping["Defeated"] = 3;\n', '        possibleProposalStatesArray.push("Defeated");\n', '        possibleProposalStatesMapping["Succeeded"] = 4;\n', '        possibleProposalStatesArray.push("Succeeded");\n', '        possibleProposalStatesMapping["Queued"] = 5;\n', '        possibleProposalStatesArray.push("Queued");\n', '        possibleProposalStatesMapping["Expired"] = 6;\n', '        possibleProposalStatesArray.push("Expired");\n', '        possibleProposalStatesMapping["Executed"] = 7;\n', '        possibleProposalStatesArray.push("Executed");\n', '        initDone = true;\n', '    }\n', '\n', '    // ADMIN\n', '    // *************************************************************************************\n', '    function setPendingAdmin(address newPendingAdmin) public {\n', '        require(msg.sender == admin, "not admin");\n', '        pendingAdmin = newPendingAdmin;\n', '    }\n', '\n', '    function acceptAdmin() public {\n', '        require(\n', '            msg.sender == pendingAdmin && msg.sender != address(0),\n', '            "not pendingAdmin"\n', '        );\n', '        admin = pendingAdmin;\n', '        pendingAdmin = address(0);\n', '    }\n', '\n', '    function setPendingSuperAdmin(address newPendingSuperAdmin) public {\n', '        require(msg.sender == superAdmin, "not superAdmin");\n', '        pendingSuperAdmin = newPendingSuperAdmin;\n', '    }\n', '\n', '    function acceptSuperAdmin() public {\n', '        require(\n', '            msg.sender == pendingSuperAdmin && msg.sender != address(0),\n', '            "not pendingSuperAdmin"\n', '        );\n', '        superAdmin = pendingSuperAdmin;\n', '        pendingSuperAdmin = address(0);\n', '    }\n', '\n', '    // PARAMETERS\n', '    // *************************************************************************************\n', '    function updateQuorumVotesInWei(uint256 amountInWei) public {\n', '        require(msg.sender == admin || msg.sender == superAdmin, "not admin");\n', '        require(amountInWei > 0, "zero");\n', '        quorumVotesInWei = amountInWei;\n', '    }\n', '\n', '    function updateProposalThresholdInWei(uint256 amountInWei) public {\n', '        require(msg.sender == admin || msg.sender == superAdmin, "not admin");\n', '        require(amountInWei > 0, "zero");\n', '        proposalThresholdInWei = amountInWei;\n', '    }\n', '\n', '    function updateProposalMaxOperations(uint256 count) public {\n', '        require(msg.sender == admin || msg.sender == superAdmin, "not admin");\n', '        require(count > 0, "zero");\n', '        proposalMaxOperations = count;\n', '    }\n', '\n', '    function updateVotingDelayInBlocks(uint256 amountInBlocks) public {\n', '        require(msg.sender == admin || msg.sender == superAdmin, "not admin");\n', '        require(amountInBlocks > 0, "zero");\n', '        votingDelayInBlocks = amountInBlocks;\n', '    }\n', '\n', '    function updateVotingPeriodInBlocks(uint256 amountInBlocks) public {\n', '        require(msg.sender == admin || msg.sender == superAdmin, "not admin");\n', '        require(amountInBlocks > 0, "zero");\n', '        votingPeriodInBlocks = amountInBlocks;\n', '    }\n', '\n', '    function updateQueuePeriodInSeconds(uint256 amountInSeconds) public {\n', '        require(msg.sender == admin || msg.sender == superAdmin, "not admin");\n', '        require(amountInSeconds > 0, "zero");\n', '        queuePeriodInSeconds = amountInSeconds;\n', '    }\n', '\n', '    function updateGracePeriodInSeconds(uint256 amountInSeconds) public {\n', '        require(msg.sender == admin || msg.sender == superAdmin, "not admin");\n', '        require(amountInSeconds > 0, "zero");\n', '        gracePeriodInSeconds = amountInSeconds;\n', '    }\n', '\n', '    // PROPOSALS\n', '    // *************************************************************************************\n', '    function propose(\n', '        address[] memory targets,\n', '        uint256[] memory values,\n', '        string[] memory signatures,\n', '        bytes[] memory calldatas,\n', '        string memory description\n', '    ) public returns (uint256) {\n', '        require(\n', '            sbVotes.getPriorProposalVotes(msg.sender, block.number.sub(1)) >\n', '                proposalThresholdInWei,\n', '            "below threshold"\n', '        );\n', '        require(\n', '            targets.length == values.length &&\n', '                targets.length == signatures.length &&\n', '                targets.length == calldatas.length,\n', '            "arity mismatch"\n', '        );\n', '        require(targets.length != 0, "missing actions");\n', '        require(targets.length <= proposalMaxOperations, "too many actions");\n', '\n', '        uint256 latestProposalId = latestProposalIds[msg.sender];\n', '        if (latestProposalId != 0) {\n', '            uint256 proposersLatestProposalState = state(latestProposalId);\n', '            require(\n', '                proposersLatestProposalState !=\n', '                    possibleProposalStatesMapping["Active"],\n', '                "already active proposal"\n', '            );\n', '            require(\n', '                proposersLatestProposalState !=\n', '                    possibleProposalStatesMapping["Pending"],\n', '                "already pending proposal"\n', '            );\n', '        }\n', '\n', '        uint256 startBlock = block.number.add(votingDelayInBlocks);\n', '        uint256 endBlock = startBlock.add(votingPeriodInBlocks);\n', '\n', '        proposalCount = proposalCount.add(1);\n', '\n', '        proposalProposer[proposalCount] = msg.sender;\n', '        proposalEta[proposalCount] = 0;\n', '        proposalTargets[proposalCount] = targets;\n', '        proposalValues[proposalCount] = values;\n', '        proposalSignatures[proposalCount] = signatures;\n', '        proposalCalldatas[proposalCount] = calldatas;\n', '        proposalStartBlock[proposalCount] = startBlock;\n', '        proposalEndBlock[proposalCount] = endBlock;\n', '        proposalForVotes[proposalCount] = 0;\n', '        proposalAgainstVotes[proposalCount] = 0;\n', '        proposalCanceled[proposalCount] = false;\n', '        proposalExecuted[proposalCount] = false;\n', '\n', '        latestProposalIds[msg.sender] = proposalCount;\n', '\n', '        emit ProposalCreated(\n', '            proposalCount,\n', '            msg.sender,\n', '            targets,\n', '            values,\n', '            signatures,\n', '            calldatas,\n', '            startBlock,\n', '            endBlock,\n', '            description\n', '        );\n', '        return proposalCount;\n', '    }\n', '\n', '    function vote(uint256 proposalId, bool support) public {\n', '        return _vote(msg.sender, proposalId, support);\n', '    }\n', '\n', '    function queue(uint256 proposalId) public {\n', '        require(\n', '            state(proposalId) == possibleProposalStatesMapping["Succeeded"],\n', '            "not succeeded"\n', '        );\n', '        uint256 eta = block.timestamp.add(queuePeriodInSeconds);\n', '        for (uint256 i = 0; i < proposalTargets[proposalId].length; i++) {\n', '            _queueOrRevert(\n', '                proposalTargets[proposalId][i],\n', '                proposalValues[proposalId][i],\n', '                proposalSignatures[proposalId][i],\n', '                proposalCalldatas[proposalId][i],\n', '                eta\n', '            );\n', '        }\n', '        proposalEta[proposalId] = eta;\n', '        emit ProposalQueued(proposalId, eta);\n', '    }\n', '\n', '    function cancel(uint256 proposalId) public {\n', '        uint256 state = state(proposalId);\n', '        require(\n', '            state != possibleProposalStatesMapping["Executed"],\n', '            "already executed"\n', '        );\n', '\n', '        require(\n', '            msg.sender == admin ||\n', '                msg.sender == superAdmin ||\n', '                sbVotes.getPriorProposalVotes(\n', '                    proposalProposer[proposalId],\n', '                    block.number.sub(1)\n', '                ) <\n', '                proposalThresholdInWei,\n', '            "below threshold"\n', '        );\n', '\n', '        proposalCanceled[proposalId] = true;\n', '        for (uint256 i = 0; i < proposalTargets[proposalId].length; i++) {\n', '            _cancelTransaction(\n', '                proposalTargets[proposalId][i],\n', '                proposalValues[proposalId][i],\n', '                proposalSignatures[proposalId][i],\n', '                proposalCalldatas[proposalId][i],\n', '                proposalEta[proposalId]\n', '            );\n', '        }\n', '\n', '        emit ProposalCanceled(proposalId);\n', '    }\n', '\n', '    function execute(uint256 proposalId) public payable {\n', '        require(\n', '            state(proposalId) == possibleProposalStatesMapping["Queued"],\n', '            "not queued"\n', '        );\n', '        proposalExecuted[proposalId] = true;\n', '        for (uint256 i = 0; i < proposalTargets[proposalId].length; i++) {\n', '            _executeTransaction(\n', '                proposalTargets[proposalId][i],\n', '                proposalValues[proposalId][i],\n', '                proposalSignatures[proposalId][i],\n', '                proposalCalldatas[proposalId][i],\n', '                proposalEta[proposalId]\n', '            );\n', '        }\n', '        emit ProposalExecuted(proposalId);\n', '    }\n', '\n', '    function getReceipt(uint256 proposalId, address voter)\n', '        public\n', '        view\n', '        returns (\n', '            bool,\n', '            bool,\n', '            uint96\n', '        )\n', '    {\n', '        return (\n', '            proposalVoterHasVoted[proposalId][voter],\n', '            proposalVoterSupport[proposalId][voter],\n', '            proposalVoterVotes[proposalId][voter]\n', '        );\n', '    }\n', '\n', '    function getActions(uint256 proposalId)\n', '        public\n', '        view\n', '        returns (\n', '            address[] memory,\n', '            uint256[] memory,\n', '            string[] memory,\n', '            bytes[] memory\n', '        )\n', '    {\n', '        return (\n', '            proposalTargets[proposalId],\n', '            proposalValues[proposalId],\n', '            proposalSignatures[proposalId],\n', '            proposalCalldatas[proposalId]\n', '        );\n', '    }\n', '\n', '    function getPossibleProposalStates() public view returns (string[] memory) {\n', '        return possibleProposalStatesArray;\n', '    }\n', '\n', '    function getPossibleProposalStateKey(uint256 index)\n', '        public\n', '        view\n', '        returns (string memory)\n', '    {\n', '        require(index < possibleProposalStatesArray.length, "invalid index");\n', '        return possibleProposalStatesArray[index];\n', '    }\n', '\n', '    function state(uint256 proposalId) public view returns (uint256) {\n', '        require(\n', '            proposalCount >= proposalId && proposalId > 0,\n', '            "invalid proposal id"\n', '        );\n', '        if (proposalCanceled[proposalId]) {\n', '            return possibleProposalStatesMapping["Canceled"];\n', '        } else if (block.number <= proposalStartBlock[proposalId]) {\n', '            return possibleProposalStatesMapping["Pending"];\n', '        } else if (block.number <= proposalEndBlock[proposalId]) {\n', '            return possibleProposalStatesMapping["Active"];\n', '        } else if (\n', '            proposalForVotes[proposalId] <= proposalAgainstVotes[proposalId] ||\n', '            proposalForVotes[proposalId] < quorumVotesInWei\n', '        ) {\n', '            return possibleProposalStatesMapping["Defeated"];\n', '        } else if (proposalEta[proposalId] == 0) {\n', '            return possibleProposalStatesMapping["Succeeded"];\n', '        } else if (proposalExecuted[proposalId]) {\n', '            return possibleProposalStatesMapping["Executed"];\n', '        } else if (\n', '            block.timestamp >= proposalEta[proposalId].add(gracePeriodInSeconds)\n', '        ) {\n', '            return possibleProposalStatesMapping["Expired"];\n', '        } else {\n', '            return possibleProposalStatesMapping["Queued"];\n', '        }\n', '    }\n', '\n', '    // SUPPORT\n', '    // *************************************************************************************\n', '    function _queueOrRevert(\n', '        address target,\n', '        uint256 value,\n', '        string memory signature,\n', '        bytes memory data,\n', '        uint256 eta\n', '    ) internal {\n', '        require(\n', '            !queuedTransactions[keccak256(\n', '                abi.encode(target, value, signature, data, eta)\n', '            )],\n', '            "already queued at eta"\n', '        );\n', '        _queueTransaction(target, value, signature, data, eta);\n', '    }\n', '\n', '    function _queueTransaction(\n', '        address target,\n', '        uint256 value,\n', '        string memory signature,\n', '        bytes memory data,\n', '        uint256 eta\n', '    ) internal returns (bytes32) {\n', '        require(\n', '            eta >= block.timestamp.add(queuePeriodInSeconds),\n', '            "not satisfy queue period"\n', '        );\n', '\n', '        bytes32 txHash = keccak256(\n', '            abi.encode(target, value, signature, data, eta)\n', '        );\n', '        queuedTransactions[txHash] = true;\n', '\n', '        emit QueuedTransaction(txHash, target, value, signature, data, eta);\n', '        return txHash;\n', '    }\n', '\n', '    function _cancelTransaction(\n', '        address target,\n', '        uint256 value,\n', '        string memory signature,\n', '        bytes memory data,\n', '        uint256 eta\n', '    ) internal {\n', '        bytes32 txHash = keccak256(\n', '            abi.encode(target, value, signature, data, eta)\n', '        );\n', '        queuedTransactions[txHash] = false;\n', '        emit CanceledTransaction(txHash, target, value, signature, data, eta);\n', '    }\n', '\n', '    function _executeTransaction(\n', '        address target,\n', '        uint256 value,\n', '        string memory signature,\n', '        bytes memory data,\n', '        uint256 eta\n', '    ) internal returns (bytes memory) {\n', '        bytes32 txHash = keccak256(\n', '            abi.encode(target, value, signature, data, eta)\n', '        );\n', '        require(queuedTransactions[txHash], "not queued");\n', '        require(block.timestamp >= eta, "not past eta");\n', '        require(block.timestamp <= eta.add(gracePeriodInSeconds), "stale");\n', '\n', '        queuedTransactions[txHash] = false;\n', '\n', '        bytes memory callData;\n', '\n', '        if (bytes(signature).length == 0) {\n', '            callData = data;\n', '        } else {\n', '            callData = abi.encodePacked(\n', '                bytes4(keccak256(bytes(signature))),\n', '                data\n', '            );\n', '        }\n', '\n', '        (bool success, bytes memory returnData) = target.call{value: value}(\n', '            callData\n', '        );\n', '        require(success, "execution reverted");\n', '\n', '        emit ExecutedTransaction(txHash, target, value, signature, data, eta);\n', '\n', '        return returnData;\n', '    }\n', '\n', '    function _vote(\n', '        address voter,\n', '        uint256 proposalId,\n', '        bool support\n', '    ) internal {\n', '        require(\n', '            state(proposalId) == possibleProposalStatesMapping["Active"],\n', '            "voting closed"\n', '        );\n', '        require(\n', '            proposalVoterHasVoted[proposalId][voter] == false,\n', '            "already voted"\n', '        );\n', '        uint96 votes = sbVotes.getPriorProposalVotes(\n', '            voter,\n', '            proposalStartBlock[proposalId]\n', '        );\n', '\n', '        if (support) {\n', '            proposalForVotes[proposalId] = proposalForVotes[proposalId].add(\n', '                votes\n', '            );\n', '        } else {\n', '            proposalAgainstVotes[proposalId] = proposalAgainstVotes[proposalId]\n', '                .add(votes);\n', '        }\n', '\n', '        proposalVoterHasVoted[proposalId][voter] = true;\n', '        proposalVoterSupport[proposalId][voter] = support;\n', '        proposalVoterVotes[proposalId][voter] = votes;\n', '\n', '        emit Voted(voter, proposalId, support, votes);\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', '\n', 'interface sbVotesInterface {\n', '  function getPriorProposalVotes(address account, uint256 blockNumber) external view returns (uint96);\n', '\n', '  function updateVotes(\n', '    address staker,\n', '    uint256 rawAmount,\n', '    bool adding\n', '  ) external;\n', '}\n']
