['// File: contracts/lib/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/governance/DMCGovernorAlpha.sol\n', '\n', 'pragma solidity ^0.5.17;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '// Original work from Compound: https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/GovernorAlpha.sol\n', '// Modified to work in the DMC system\n', '\n', '// all votes work on underlying _DMCBalances[address], not balanceOf(address)\n', '\n', '// Original audit: https://blog.openzeppelin.com/compound-alpha-governance-system-audit/\n', '// Overview:\n', '//    No Critical\n', '//    High:\n', '//      Issue:\n', '//        Approved proposal may be impossible to queue, cancel or execute\n', '//        Fixed with `proposalMaxOperations`\n', '//      Issue:\n', '//        Queued proposal with repeated actions cannot be executed\n', '//        Fixed by explicitly disallow proposals with repeated actions to be queued in the Timelock contract.\n', '//\n', '// Changes made by DMC after audit:\n', '//    Formatting, naming, & uint256 instead of uint\n', '//    Since DMC supply changes, updated quorum & proposal requirements\n', '//    If any uint96, changed to uint256 to match DMC as opposed to comp\n', '\n', '\n', 'contract GovernorAlpha {\n', '    /// @notice The name of this contract\n', '    string public constant name = "DMC Governor Alpha";\n', '\n', '    /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed\n', '    function quorumVotes() public view returns (uint256) { return 17_600_000 * 10e18; } // 20% of DMC\n', '\n', '    /// @notice The number of votes required in order for a voter to become a proposer\n', '    function proposalThreshold() public view returns (uint256) { return 880_000 * 10e18; } // 1% of DMC\n', '\n', '    /// @notice The maximum number of actions that can be included in a proposal\n', '    function proposalMaxOperations() public pure returns (uint256) { return 10; } // 10 actions\n', '\n', '    /// @notice The delay before voting on a proposal may take place, once proposed\n', '    function votingDelay() public pure returns (uint256) { return 1; } // 1 block\n', '\n', '    /// @notice The duration of voting on a proposal, in blocks\n', '    function votingPeriod() public pure returns (uint256) { return 40320; } // ~7 days in blocks (assuming 15s blocks)\n', '\n', '    /// @notice The address of the Compound Protocol Timelock\n', '    TimelockInterface public timelock;\n', '\n', '    /// @notice The address of the Compound governance token\n', '    DMCInterface public DMC;\n', '\n', '    /// @notice The address of the Governor Guardian\n', '    address public guardian;\n', '\n', '    /// @notice The total number of proposals\n', '    uint256 public proposalCount;\n', '\n', '    struct Proposal {\n', '        /// @notice Unique id for looking up a proposal\n', '        uint256 id;\n', '\n', '        /// @notice Creator of the proposal\n', '        address proposer;\n', '\n', '        /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds\n', '        uint256 eta;\n', '\n', '        /// @notice the ordered list of target addresses for calls to be made\n', '        address[] targets;\n', '\n', '        /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made\n', '        uint[] values;\n', '\n', '        /// @notice The ordered list of function signatures to be called\n', '        string[] signatures;\n', '\n', '        /// @notice The ordered list of calldata to be passed to each call\n', '        bytes[] calldatas;\n', '\n', '        /// @notice The block at which voting begins: holders must delegate their votes prior to this block\n', '        uint256 startBlock;\n', '\n', '        /// @notice The block at which voting ends: votes must be cast prior to this block\n', '        uint256 endBlock;\n', '\n', '        /// @notice Current number of votes in favor of this proposal\n', '        uint256 forVotes;\n', '\n', '        /// @notice Current number of votes in opposition to this proposal\n', '        uint256 againstVotes;\n', '\n', '        /// @notice Flag marking whether the proposal has been canceled\n', '        bool canceled;\n', '\n', '        /// @notice Flag marking whether the proposal has been executed\n', '        bool executed;\n', '\n', '        /// @notice Receipts of ballots for the entire set of voters\n', '        mapping (address => Receipt) receipts;\n', '    }\n', '\n', '    /// @notice Ballot receipt record for a voter\n', '    struct Receipt {\n', '        /// @notice Whether or not a vote has been cast\n', '        bool hasVoted;\n', '\n', '        /// @notice Whether or not the voter supports the proposal\n', '        bool support;\n', '\n', '        /// @notice The number of votes the voter had, which were cast\n', '        uint256 votes;\n', '    }\n', '\n', '    /// @notice Possible states that a proposal may be in\n', '    enum ProposalState {\n', '        Pending,\n', '        Active,\n', '        Canceled,\n', '        Defeated,\n', '        Succeeded,\n', '        Queued,\n', '        Expired,\n', '        Executed\n', '    }\n', '\n', '    /// @notice The official record of all proposals ever proposed\n', '    mapping (uint256 => Proposal) public proposals;\n', '\n', '    /// @notice The latest proposal for each proposer\n', '    mapping (address => uint256) public latestProposalIds;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    /// @notice The EIP-712 typehash for the ballot struct used by the contract\n', '    bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");\n', '\n', '    /// @notice An event emitted when a new proposal is created\n', '    event ProposalCreated(uint256 id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint256 startBlock, uint256 endBlock, string description);\n', '\n', '    /// @notice An event emitted when a vote has been cast on a proposal\n', '    event VoteCast(address voter, uint256 proposalId, bool support, uint256 votes);\n', '\n', '    /// @notice An event emitted when a proposal has been canceled\n', '    event ProposalCanceled(uint256 id);\n', '\n', '    /// @notice An event emitted when a proposal has been queued in the Timelock\n', '    event ProposalQueued(uint256 id, uint256 eta);\n', '\n', '    /// @notice An event emitted when a proposal has been executed in the Timelock\n', '    event ProposalExecuted(uint256 id);\n', '\n', '    constructor(address timelock_, address DMC_) public {\n', '        timelock = TimelockInterface(timelock_);\n', '        DMC = DMCInterface(DMC_);\n', '        guardian = msg.sender;\n', '    }\n', '\n', '    function propose(\n', '        address[] memory targets,\n', '        uint[] memory values,\n', '        string[] memory signatures,\n', '        bytes[] memory calldatas,\n', '        string memory description\n', '    )\n', '        public\n', '        returns (uint256)\n', '    {\n', '        require(DMC.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(), "GovernorAlpha::propose: proposer votes below proposal threshold");\n', '        require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorAlpha::propose: proposal function information arity mismatch");\n', '        require(targets.length != 0, "GovernorAlpha::propose: must provide actions");\n', '        require(targets.length <= proposalMaxOperations(), "GovernorAlpha::propose: too many actions");\n', '\n', '        uint256 latestProposalId = latestProposalIds[msg.sender];\n', '        if (latestProposalId != 0) {\n', '          ProposalState proposersLatestProposalState = state(latestProposalId);\n', '          require(proposersLatestProposalState != ProposalState.Active, "GovernorAlpha::propose: one live proposal per proposer, found an already active proposal");\n', '          require(proposersLatestProposalState != ProposalState.Pending, "GovernorAlpha::propose: one live proposal per proposer, found an already pending proposal");\n', '        }\n', '\n', '        uint256 startBlock = add256(block.number, votingDelay());\n', '        uint256 endBlock = add256(startBlock, votingPeriod());\n', '\n', '        proposalCount++;\n', '        Proposal memory newProposal = Proposal({\n', '            id: proposalCount,\n', '            proposer: msg.sender,\n', '            eta: 0,\n', '            targets: targets,\n', '            values: values,\n', '            signatures: signatures,\n', '            calldatas: calldatas,\n', '            startBlock: startBlock,\n', '            endBlock: endBlock,\n', '            forVotes: 0,\n', '            againstVotes: 0,\n', '            canceled: false,\n', '            executed: false\n', '        });\n', '\n', '        proposals[newProposal.id] = newProposal;\n', '        latestProposalIds[newProposal.proposer] = newProposal.id;\n', '\n', '        emit ProposalCreated(\n', '            newProposal.id,\n', '            msg.sender,\n', '            targets,\n', '            values,\n', '            signatures,\n', '            calldatas,\n', '            startBlock,\n', '            endBlock,\n', '            description\n', '        );\n', '        return newProposal.id;\n', '    }\n', '\n', '    function queue(uint256 proposalId)\n', '        public\n', '    {\n', '        require(state(proposalId) == ProposalState.Succeeded, "GovernorAlpha::queue: proposal can only be queued if it is succeeded");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        uint256 eta = add256(block.timestamp, timelock.delay());\n', '        for (uint256 i = 0; i < proposal.targets.length; i++) {\n', '            _queueOrRevert(\n', '                proposal.targets[i],\n', '                proposal.values[i],\n', '                proposal.signatures[i],\n', '                proposal.calldatas[i],\n', '                eta\n', '            );\n', '        }\n', '        proposal.eta = eta;\n', '        emit ProposalQueued(proposalId, eta);\n', '    }\n', '\n', '    function _queueOrRevert(\n', '        address target,\n', '        uint256 value,\n', '        string memory signature,\n', '        bytes memory data,\n', '        uint256 eta\n', '    )\n', '        internal\n', '    {\n', '        require(!timelock.queuedTransactions(\n', '              keccak256(\n', '                  abi.encode(\n', '                      target,\n', '                      value,\n', '                      signature,\n', '                      data,\n', '                      eta\n', '                  )\n', '              )\n', '          ),\n', '          "GovernorAlpha::_queueOrRevert: proposal action already queued at eta"\n', '        );\n', '\n', '        timelock.queueTransaction(target, value, signature, data, eta);\n', '    }\n', '\n', '    function execute(uint256 proposalId)\n', '        public\n', '        payable\n', '    {\n', '        require(state(proposalId) == ProposalState.Queued, "GovernorAlpha::execute: proposal can only be executed if it is queued");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        proposal.executed = true;\n', '        for (uint256 i = 0; i < proposal.targets.length; i++) {\n', '            timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '        emit ProposalExecuted(proposalId);\n', '    }\n', '\n', '    function cancel(uint256 proposalId)\n', '        public\n', '    {\n', '        ProposalState state = state(proposalId);\n', '        require(state != ProposalState.Executed, "GovernorAlpha::cancel: cannot cancel executed proposal");\n', '\n', '        Proposal storage proposal = proposals[proposalId];\n', '        require(msg.sender == guardian || DMC.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(), "GovernorAlpha::cancel: proposer above threshold");\n', '\n', '        proposal.canceled = true;\n', '        for (uint256 i = 0; i < proposal.targets.length; i++) {\n', '            timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '\n', '        emit ProposalCanceled(proposalId);\n', '    }\n', '\n', '    function getActions(uint256 proposalId)\n', '        public\n', '        view\n', '        returns (\n', '            address[] memory targets,\n', '            uint[] memory values,\n', '            string[] memory signatures,\n', '            bytes[] memory calldatas\n', '        )\n', '    {\n', '        Proposal storage p = proposals[proposalId];\n', '        return (p.targets, p.values, p.signatures, p.calldatas);\n', '    }\n', '\n', '    function getReceipt(uint256 proposalId, address voter)\n', '        public\n', '        view\n', '        returns (Receipt memory)\n', '    {\n', '        return proposals[proposalId].receipts[voter];\n', '    }\n', '\n', '    function state(uint256 proposalId)\n', '        public\n', '        view\n', '        returns (ProposalState)\n', '    {\n', '        require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha::state: invalid proposal id");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        if (proposal.canceled) {\n', '            return ProposalState.Canceled;\n', '        } else if (block.number <= proposal.startBlock) {\n', '            return ProposalState.Pending;\n', '        } else if (block.number <= proposal.endBlock) {\n', '            return ProposalState.Active;\n', '        } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {\n', '            return ProposalState.Defeated;\n', '        } else if (proposal.eta == 0) {\n', '            return ProposalState.Succeeded;\n', '        } else if (proposal.executed) {\n', '            return ProposalState.Executed;\n', '        } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {\n', '            return ProposalState.Expired;\n', '        } else {\n', '            return ProposalState.Queued;\n', '        }\n', '    }\n', '\n', '    function castVote(uint256 proposalId, bool support)\n', '        public\n', '    {\n', '        return _castVote(msg.sender, proposalId, support);\n', '    }\n', '\n', '    function castVoteBySig(\n', '        uint256 proposalId,\n', '        bool support,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '        public\n', '    {\n', '        bytes32 domainSeparator = keccak256(\n', '            abi.encode(\n', '                DOMAIN_TYPEHASH,\n', '                keccak256(bytes(name)),\n', '                getChainId(),\n', '                address(this)\n', '            )\n', '        );\n', '\n', '        bytes32 structHash = keccak256(\n', '            abi.encode(\n', '                BALLOT_TYPEHASH,\n', '                proposalId,\n', '                support\n', '            )\n', '        );\n', '\n', '        bytes32 digest = keccak256(\n', '            abi.encodePacked(\n', '                "\\x19\\x01",\n', '                domainSeparator,\n', '                structHash\n', '            )\n', '        );\n', '\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "GovernorAlpha::castVoteBySig: invalid signature");\n', '        return _castVote(signatory, proposalId, support);\n', '    }\n', '\n', '    function _castVote(\n', '        address voter,\n', '        uint256 proposalId,\n', '        bool support\n', '    )\n', '        internal\n', '    {\n', '        require(state(proposalId) == ProposalState.Active, "GovernorAlpha::_castVote: voting is closed");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        Receipt storage receipt = proposal.receipts[voter];\n', '        require(receipt.hasVoted == false, "GovernorAlpha::_castVote: voter already voted");\n', '        uint256 votes = DMC.getPriorVotes(voter, proposal.startBlock);\n', '\n', '        if (support) {\n', '            proposal.forVotes = add256(proposal.forVotes, votes);\n', '        } else {\n', '            proposal.againstVotes = add256(proposal.againstVotes, votes);\n', '        }\n', '\n', '        receipt.hasVoted = true;\n', '        receipt.support = support;\n', '        receipt.votes = votes;\n', '\n', '        emit VoteCast(voter, proposalId, support, votes);\n', '    }\n', '\n', '    function __acceptAdmin()\n', '        public\n', '    {\n', '        require(msg.sender == guardian, "GovernorAlpha::__acceptAdmin: sender must be gov guardian");\n', '        timelock.acceptAdmin();\n', '    }\n', '\n', '    function __abdicate()\n', '        public\n', '    {\n', '        require(msg.sender == guardian, "GovernorAlpha::__abdicate: sender must be gov guardian");\n', '        guardian = address(0);\n', '    }\n', '\n', '    function __queueSetTimelockPendingAdmin(\n', '        address newPendingAdmin,\n', '        uint256 eta\n', '    )\n', '        public\n', '    {\n', '        require(msg.sender == guardian, "GovernorAlpha::__queueSetTimelockPendingAdmin: sender must be gov guardian");\n', '        timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);\n', '    }\n', '\n', '    function __executeSetTimelockPendingAdmin(\n', '        address newPendingAdmin,\n', '        uint256 eta\n', '    )\n', '        public\n', '    {\n', '        require(msg.sender == guardian, "GovernorAlpha::__executeSetTimelockPendingAdmin: sender must be gov guardian");\n', '        timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);\n', '    }\n', '\n', '    function add256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "subtraction underflow");\n', '        return a - b;\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint256) {\n', '        uint256 chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '}\n', '\n', 'interface TimelockInterface {\n', '    function delay() external view returns (uint256);\n', '    function GRACE_PERIOD() external view returns (uint256);\n', '    function acceptAdmin() external;\n', '    function queuedTransactions(bytes32 hash) external view returns (bool);\n', '    function queueTransaction(address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta) external returns (bytes32);\n', '    function cancelTransaction(address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta) external;\n', '    function executeTransaction(address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta) external payable returns (bytes memory);\n', '}\n', '\n', 'interface DMCInterface {\n', '    function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256);\n', '    function initSupply() external view returns (uint256);\n', '    function _acceptGov() external;\n', '}']