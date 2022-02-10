['pragma solidity ^0.5.16;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '// Copyright 2020 Compound Labs, Inc.\n', '// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n', '// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n', '// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n', '// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n', '// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '\n', 'contract Governor {\n', '    /// @notice The name of this contract\n', '    string public constant name = "Sync Governor";\n', '\n', '    /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed\n', '    uint public quorumVotes;\n', '\n', '    /// @notice The number of votes required in order for a voter to become a proposer\n', '    uint public proposalThreshold;\n', '\n', '    /// @notice The maximum number of actions that can be included in a proposal\n', '    uint public proposalMaxOperations = 20;\n', '\n', '    /// @notice The delay before voting on a proposal may take place, once proposed\n', '    uint public votingDelay;\n', '\n', '    /// @notice The duration of voting on a proposal, in blocks\n', '    uint public votingPeriod;\n', '\n', '    /// @notice The address of the Timelock contract\n', '    TimelockInterface public timelock;\n', '\n', '    /// @notice The address of the SyncToken contract\n', '    SyncTokenInterface public sync;\n', '\n', '    /// @notice The address of the Governor Guardian\n', '    address public guardian;\n', '\n', '    /// @notice The total number of proposals\n', '    uint public proposalCount;\n', '\n', '    struct Proposal {\n', '        /// @notice Unique id for looking up a proposal\n', '        uint id;\n', '\n', '        /// @notice Creator of the proposal\n', '        address proposer;\n', '\n', '        /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds\n', '        uint eta;\n', '\n', '        /// @notice the ordered list of target addresses for calls to be made\n', '        address[] targets;\n', '\n', '        /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made\n', '        uint[] values;\n', '\n', '        /// @notice The ordered list of function signatures to be called\n', '        string[] signatures;\n', '\n', '        /// @notice The ordered list of calldata to be passed to each call\n', '        bytes[] calldatas;\n', '\n', '        /// @notice The block at which voting begins: holders must delegate their votes prior to this block\n', '        uint startBlock;\n', '\n', '        /// @notice The block at which voting ends: votes must be cast prior to this block\n', '        uint endBlock;\n', '\n', '        /// @notice Current number of votes in favor of this proposal\n', '        uint forVotes;\n', '\n', '        /// @notice Current number of votes in opposition to this proposal\n', '        uint againstVotes;\n', '\n', '        /// @notice Flag marking whether the proposal has been canceled\n', '        bool canceled;\n', '\n', '        /// @notice Flag marking whether the proposal has been executed\n', '        bool executed;\n', '\n', '        /// @notice Receipts of ballots for the entire set of voters\n', '        mapping (address => Receipt) receipts;\n', '    }\n', '\n', '    /// @notice Ballot receipt record for a voter\n', '    struct Receipt {\n', '        /// @notice Whether or not a vote has been cast\n', '        bool hasVoted;\n', '\n', '        /// @notice Whether or not the voter supports the proposal\n', '        bool support;\n', '\n', '        /// @notice The number of votes the voter had, which were cast\n', '        uint96 votes;\n', '    }\n', '\n', '    /// @notice Possible states that a proposal may be in\n', '    enum ProposalState {\n', '        Pending,\n', '        Active,\n', '        Canceled,\n', '        Defeated,\n', '        Succeeded,\n', '        Queued,\n', '        Expired,\n', '        Executed\n', '    }\n', '\n', '    /// @notice The official record of all proposals ever proposed\n', '    mapping (uint => Proposal) public proposals;\n', '\n', '    /// @notice The latest proposal for each proposer\n', '    mapping (address => uint) public latestProposalIds;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    /// @notice The EIP-712 typehash for the ballot struct used by the contract\n', '    bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");\n', '\n', '    /// @notice An event emitted when a new proposal is created\n', '    event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);\n', '\n', '    /// @notice An event emitted when a vote has been cast on a proposal\n', '    event VoteCast(address voter, uint proposalId, bool support, uint votes);\n', '\n', '    /// @notice An event emitted when a proposal has been canceled\n', '    event ProposalCanceled(uint id);\n', '\n', '    /// @notice An event emitted when a proposal has been queued in the Timelock\n', '    event ProposalQueued(uint id, uint eta);\n', '\n', '    /// @notice An event emitted when a proposal has been executed in the Timelock\n', '    event ProposalExecuted(uint id);\n', '\n', '    constructor(address timelock_, address sync_, address guardian_, uint quorumVotes_, uint proposalThreshold_, uint votingPeriodBlocks_, uint votingDelayBlocks_) public {\n', '        timelock = TimelockInterface(timelock_);\n', '        sync = SyncTokenInterface(sync_);\n', '        guardian = guardian_;\n', '        quorumVotes = quorumVotes_;\n', '        proposalThreshold = proposalThreshold_;\n', '        votingPeriod = votingPeriodBlocks_;\n', '        votingDelay = votingDelayBlocks_;\n', '    }\n', '\n', '    function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {\n', '        require(sync.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold, "Governor::propose: proposer votes below proposal threshold");\n', '        require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "Governor::propose: proposal function information arity mismatch");\n', '        require(targets.length != 0, "Governor::propose: must provide actions");\n', '        require(targets.length <= proposalMaxOperations, "Governor::propose: too many actions");\n', '\n', '        uint latestProposalId = latestProposalIds[msg.sender];\n', '        if (latestProposalId != 0) {\n', '          ProposalState proposersLatestProposalState = state(latestProposalId);\n', '          require(proposersLatestProposalState != ProposalState.Active, "Governor::propose: one live proposal per proposer, found an already active proposal");\n', '          require(proposersLatestProposalState != ProposalState.Pending, "Governor::propose: one live proposal per proposer, found an already pending proposal");\n', '        }\n', '\n', '        uint startBlock = add256(block.number, votingDelay);\n', '        uint endBlock = add256(startBlock, votingPeriod);\n', '\n', '        proposalCount++;\n', '        Proposal memory newProposal = Proposal({\n', '            id: proposalCount,\n', '            proposer: msg.sender,\n', '            eta: 0,\n', '            targets: targets,\n', '            values: values,\n', '            signatures: signatures,\n', '            calldatas: calldatas,\n', '            startBlock: startBlock,\n', '            endBlock: endBlock,\n', '            forVotes: 0,\n', '            againstVotes: 0,\n', '            canceled: false,\n', '            executed: false\n', '        });\n', '\n', '        proposals[newProposal.id] = newProposal;\n', '        latestProposalIds[newProposal.proposer] = newProposal.id;\n', '\n', '        emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);\n', '        return newProposal.id;\n', '    }\n', '\n', '    function queue(uint proposalId) public {\n', '        require(state(proposalId) == ProposalState.Succeeded, "Governor::queue: proposal can only be queued if it is succeeded");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        uint eta = add256(block.timestamp, timelock.delay());\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);\n', '        }\n', '        proposal.eta = eta;\n', '        emit ProposalQueued(proposalId, eta);\n', '    }\n', '\n', '    function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {\n', '        require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "Governor::_queueOrRevert: proposal action already queued at eta");\n', '        timelock.queueTransaction(target, value, signature, data, eta);\n', '    }\n', '\n', '    function execute(uint proposalId) public payable {\n', '        require(state(proposalId) == ProposalState.Queued, "Governor::execute: proposal can only be executed if it is queued");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        proposal.executed = true;\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '        emit ProposalExecuted(proposalId);\n', '    }\n', '\n', '    function cancel(uint proposalId) public {\n', '        ProposalState state = state(proposalId);\n', '        require(state != ProposalState.Executed, "Governor::cancel: cannot cancel executed proposal");\n', '\n', '        Proposal storage proposal = proposals[proposalId];\n', '        require(msg.sender == guardian || sync.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold, "Governor::cancel: proposer above threshold");\n', '\n', '        proposal.canceled = true;\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '\n', '        emit ProposalCanceled(proposalId);\n', '    }\n', '\n', '    function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {\n', '        Proposal storage p = proposals[proposalId];\n', '        return (p.targets, p.values, p.signatures, p.calldatas);\n', '    }\n', '\n', '    function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {\n', '        return proposals[proposalId].receipts[voter];\n', '    }\n', '\n', '    function state(uint proposalId) public view returns (ProposalState) {\n', '        require(proposalCount >= proposalId && proposalId > 0, "Governor::state: invalid proposal id");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        if (proposal.canceled) {\n', '            return ProposalState.Canceled;\n', '        } else if (block.number <= proposal.startBlock) {\n', '            return ProposalState.Pending;\n', '        } else if (block.number <= proposal.endBlock) {\n', '            return ProposalState.Active;\n', '        } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes) {\n', '            return ProposalState.Defeated;\n', '        } else if (proposal.eta == 0) {\n', '            return ProposalState.Succeeded;\n', '        } else if (proposal.executed) {\n', '            return ProposalState.Executed;\n', '        } else if (block.timestamp >= add256(proposal.eta, timelock.gracePeriod())) {\n', '            return ProposalState.Expired;\n', '        } else {\n', '            return ProposalState.Queued;\n', '        }\n', '    }\n', '\n', '    function castVote(uint proposalId, bool support) public {\n', '        return _castVote(msg.sender, proposalId, support);\n', '    }\n', '\n', '    function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "Governor::castVoteBySig: invalid signature");\n', '        return _castVote(signatory, proposalId, support);\n', '    }\n', '\n', '    function _castVote(address voter, uint proposalId, bool support) internal {\n', '        require(state(proposalId) == ProposalState.Active, "Governor::_castVote: voting is closed");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        Receipt storage receipt = proposal.receipts[voter];\n', '        require(receipt.hasVoted == false, "Governor::_castVote: voter already voted");\n', '        uint96 votes = sync.getPriorVotes(voter, proposal.startBlock);\n', '\n', '        if (support) {\n', '            proposal.forVotes = add256(proposal.forVotes, votes);\n', '        } else {\n', '            proposal.againstVotes = add256(proposal.againstVotes, votes);\n', '        }\n', '\n', '        receipt.hasVoted = true;\n', '        receipt.support = support;\n', '        receipt.votes = votes;\n', '\n', '        emit VoteCast(voter, proposalId, support, votes);\n', '    }\n', '\n', '    function __acceptAdmin() public {\n', '        require(msg.sender == guardian, "Governor::__acceptAdmin: sender must be gov guardian");\n', '        timelock.acceptAdmin();\n', '    }\n', '\n', '    function __abdicate() public {\n', '        require(msg.sender == guardian, "Governor::__abdicate: sender must be gov guardian");\n', '        guardian = address(0);\n', '    }\n', '\n', '    function __moveGuardianship(address _guardian) public {\n', '        require(msg.sender == guardian, "Governor::__moveGuardianship: sender must be gov guardian");\n', '        require(_guardian != address(0), "Governor::__moveGuardianship: new guardian cannot be address zero");\n', '        guardian = _guardian;\n', '    }\n', '\n', '    function add256(uint256 a, uint256 b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub256(uint256 a, uint256 b) internal pure returns (uint) {\n', '        require(b <= a, "subtraction underflow");\n', '        return a - b;\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '}\n', '\n', 'interface TimelockInterface {\n', '    function delay() external view returns (uint);\n', '    function gracePeriod() external view returns (uint);\n', '    function acceptAdmin() external;\n', '    function queuedTransactions(bytes32 hash) external view returns (bool);\n', '    function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);\n', '    function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;\n', '    function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);\n', '}\n', '\n', 'interface SyncTokenInterface {\n', '    function getPriorVotes(address account, uint blockNumber) external view returns (uint96);\n', '}']