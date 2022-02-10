['// SPDX-License-Identifier: MIT\n', '\n', '\n', '/**\n', ' * KP2R.NETWORK\n', ' * A standard implementation of kp3rv1 protocol\n', ' * Optimized Dapp\n', ' * Scalability\n', ' * Clean & tested code\n', ' */\n', '\n', '\n', '/*\n', '\n', ' This contract is provided "as is" and "with all faults." The deployer makes no representations or warranties\n', ' of any kind concerning the safety, suitability, lack of exploits, inaccuracies, typographical errors, or other\n', ' harmful components of this contract. There are inherent dangers in the use of any contract, and you are solely\n', ' responsible for determining whether this contract is safe to use. You are also solely responsible for the \n', ' protection of your funds, and the deployer will not be liable for any damages you may suffer in connection with\n', ' using, modifying, or distributing this contract.\n', '\n', '*/\n', '\n', 'pragma solidity ^0.5.17;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '  function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, errorMessage);\n', '\n', '        return c;\n', '    }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction underflow");\n', '    }\n', '  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '     if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '  function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '      if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, errorMessage);\n', '\n', '        return c;\n', '    }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', ' function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', ' function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Governance {\n', '    using SafeMath for uint;\n', '    /// @notice The name of this contract\n', '    string public constant name = "Governance";\n', '\n', '    /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed\n', '    uint public _quorumVotes = 200; // % of total supply required\n', '    \n', '    /// @notice The number of votes required in order for a voter to become a proposer\n', '    uint public _proposalThreshold = 100; \n', '\n', '    uint public constant BASE = 10000;\n', '    \n', '    function setQuorum(uint quorum_) external {\n', '        require(msg.sender == address(this), "Governance::setQuorum: timelock only");\n', '        _quorumVotes = quorum_;\n', '    }\n', '    \n', '    function quorumVotes() public view returns (uint) {\n', '        return VOTER.totalSupply().mul(_quorumVotes).div(BASE);\n', '    }\n', '    \n', '    function proposalThreshold() public view returns (uint) {\n', '        return VOTER.totalSupply().mul(_proposalThreshold).div(BASE);\n', '    }\n', '    \n', '    function setThreshold(uint threshold_) external {\n', '        require(msg.sender == address(this), "Governance::setQuorum: timelock only");\n', '        _proposalThreshold = threshold_;\n', '    }\n', '\n', '    /// @notice The maximum number of actions that can be included in a proposal\n', '    function proposalMaxOperations() public pure returns (uint) { return 10; } // 10 actions\n', '\n', '    /// @notice The delay before voting on a proposal may take place, once proposed\n', '    function votingDelay() public pure returns (uint) { return 1; } // 1 block\n', '\n', '    /// @notice The duration of voting on a proposal, in blocks\n', '    function votingPeriod() public pure returns (uint) { return 40_320; } // ~7 days in blocks (assuming 15s blocks)\n', '\n', '    /// @notice The address of the governance token\n', '    DelegateInterface public VOTER;\n', '\n', '    /// @notice The total number of proposals\n', '    uint public proposalCount;\n', '\n', '    struct Proposal {\n', '        /// @notice Unique id for looking up a proposal\n', '        uint id;\n', '\n', '        /// @notice Creator of the proposal\n', '        address proposer;\n', '\n', '        /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds\n', '        uint eta;\n', '\n', '        /// @notice the ordered list of target addresses for calls to be made\n', '        address[] targets;\n', '\n', '        /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made\n', '        uint[] values;\n', '\n', '        /// @notice The ordered list of function signatures to be called\n', '        string[] signatures;\n', '\n', '        /// @notice The ordered list of calldata to be passed to each call\n', '        bytes[] calldatas;\n', '\n', '        /// @notice The block at which voting begins: holders must delegate their votes prior to this block\n', '        uint startBlock;\n', '\n', '        /// @notice The block at which voting ends: votes must be cast prior to this block\n', '        uint endBlock;\n', '\n', '        /// @notice Current number of votes in favor of this proposal\n', '        uint forVotes;\n', '\n', '        /// @notice Current number of votes in opposition to this proposal\n', '        uint againstVotes;\n', '\n', '        /// @notice Flag marking whether the proposal has been canceled\n', '        bool canceled;\n', '\n', '        /// @notice Flag marking whether the proposal has been executed\n', '        bool executed;\n', '\n', '        /// @notice Receipts of ballots for the entire set of voters\n', '        mapping (address => Receipt) receipts;\n', '    }\n', '\n', '    /// @notice Ballot receipt record for a voter\n', '    struct Receipt {\n', '        /// @notice Whether or not a vote has been cast\n', '        bool hasVoted;\n', '\n', '        /// @notice Whether or not the voter supports the proposal\n', '        bool support;\n', '\n', '        /// @notice The number of votes the voter had, which were cast\n', '        uint votes;\n', '    }\n', '\n', '    /// @notice Possible states that a proposal may be in\n', '    enum ProposalState {\n', '        Pending,\n', '        Active,\n', '        Canceled,\n', '        Defeated,\n', '        Succeeded,\n', '        Queued,\n', '        Expired,\n', '        Executed\n', '    }\n', '\n', '    /// @notice The official record of all proposals ever proposed\n', '    mapping (uint => Proposal) public proposals;\n', '\n', '    /// @notice The latest proposal for each proposer\n', '    mapping (address => uint) public latestProposalIds;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    /// @notice The EIP-712 typehash for the ballot struct used by the contract\n', '    bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");\n', '\n', '    /// @notice An event emitted when a new proposal is created\n', '    event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);\n', '\n', '    /// @notice An event emitted when a vote has been cast on a proposal\n', '    event VoteCast(address voter, uint proposalId, bool support, uint votes);\n', '\n', '    /// @notice An event emitted when a proposal has been canceled\n', '    event ProposalCanceled(uint id);\n', '\n', '    /// @notice An event emitted when a proposal has been queued in the Timelock\n', '    event ProposalQueued(uint id, uint eta);\n', '\n', '    /// @notice An event emitted when a proposal has been executed in the Timelock\n', '    event ProposalExecuted(uint id);\n', '\n', '    function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {\n', '        require(VOTER.getPriorVotes(msg.sender, block.number.sub(1)) > proposalThreshold(), "Governance::propose: proposer votes below proposal threshold");\n', '        require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "Governance::propose: proposal function information arity mismatch");\n', '        require(targets.length != 0, "Governance::propose: must provide actions");\n', '        require(targets.length <= proposalMaxOperations(), "Governance::propose: too many actions");\n', '\n', '        uint latestProposalId = latestProposalIds[msg.sender];\n', '        if (latestProposalId != 0) {\n', '          ProposalState proposersLatestProposalState = state(latestProposalId);\n', '          require(proposersLatestProposalState != ProposalState.Active, "Governance::propose: one live proposal per proposer, found an already active proposal");\n', '          require(proposersLatestProposalState != ProposalState.Pending, "Governance::propose: one live proposal per proposer, found an already pending proposal");\n', '        }\n', '\n', '        uint startBlock = block.number.add(votingDelay());\n', '        uint endBlock = startBlock.add(votingPeriod());\n', '\n', '        proposalCount++;\n', '        Proposal memory newProposal = Proposal({\n', '            id: proposalCount,\n', '            proposer: msg.sender,\n', '            eta: 0,\n', '            targets: targets,\n', '            values: values,\n', '            signatures: signatures,\n', '            calldatas: calldatas,\n', '            startBlock: startBlock,\n', '            endBlock: endBlock,\n', '            forVotes: 0,\n', '            againstVotes: 0,\n', '            canceled: false,\n', '            executed: false\n', '        });\n', '\n', '        proposals[newProposal.id] = newProposal;\n', '        latestProposalIds[newProposal.proposer] = newProposal.id;\n', '\n', '        emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);\n', '        return newProposal.id;\n', '    }\n', '\n', '    function queue(uint proposalId) public {\n', '        require(state(proposalId) == ProposalState.Succeeded, "Governance::queue: proposal can only be queued if it is succeeded");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        uint eta = block.timestamp.add(delay);\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);\n', '        }\n', '        proposal.eta = eta;\n', '        emit ProposalQueued(proposalId, eta);\n', '    }\n', '\n', '    function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {\n', '        require(!queuedTransactions[keccak256(abi.encode(target, value, signature, data, eta))], "Governance::_queueOrRevert: proposal action already queued at eta");\n', '        queueTransaction(target, value, signature, data, eta);\n', '    }\n', '\n', '    function execute(uint proposalId) public payable {\n', '        require(state(proposalId) == ProposalState.Queued, "Governance::execute: proposal can only be executed if it is queued");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        proposal.executed = true;\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            executeTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '        emit ProposalExecuted(proposalId);\n', '    }\n', '\n', '    function cancel(uint proposalId) public {\n', '        ProposalState state = state(proposalId);\n', '        require(state != ProposalState.Executed, "Governance::cancel: cannot cancel executed proposal");\n', '\n', '        Proposal storage proposal = proposals[proposalId];\n', '        require(VOTER.getPriorVotes(proposal.proposer, block.number.sub(1)) < proposalThreshold(), "Governance::cancel: proposer above threshold");\n', '\n', '        proposal.canceled = true;\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '\n', '        emit ProposalCanceled(proposalId);\n', '    }\n', '\n', '    function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {\n', '        Proposal storage p = proposals[proposalId];\n', '        return (p.targets, p.values, p.signatures, p.calldatas);\n', '    }\n', '\n', '    function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {\n', '        return proposals[proposalId].receipts[voter];\n', '    }\n', '\n', '    function state(uint proposalId) public view returns (ProposalState) {\n', '        require(proposalCount >= proposalId && proposalId > 0, "Governance::state: invalid proposal id");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        if (proposal.canceled) {\n', '            return ProposalState.Canceled;\n', '        } else if (block.number <= proposal.startBlock) {\n', '            return ProposalState.Pending;\n', '        } else if (block.number <= proposal.endBlock) {\n', '            return ProposalState.Active;\n', '        } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {\n', '            return ProposalState.Defeated;\n', '        } else if (proposal.eta == 0) {\n', '            return ProposalState.Succeeded;\n', '        } else if (proposal.executed) {\n', '            return ProposalState.Executed;\n', '        } else if (block.timestamp >= proposal.eta.add(GRACE_PERIOD)) {\n', '            return ProposalState.Expired;\n', '        } else {\n', '            return ProposalState.Queued;\n', '        }\n', '    }\n', '\n', '    function castVote(uint proposalId, bool support) public {\n', '        return _castVote(msg.sender, proposalId, support);\n', '    }\n', '\n', '    function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "Governance::castVoteBySig: invalid signature");\n', '        return _castVote(signatory, proposalId, support);\n', '    }\n', '\n', '    function _castVote(address voter, uint proposalId, bool support) internal {\n', '        require(state(proposalId) == ProposalState.Active, "Governance::_castVote: voting is closed");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        Receipt storage receipt = proposal.receipts[voter];\n', '        require(receipt.hasVoted == false, "Governance::_castVote: voter already voted");\n', '        uint votes = VOTER.getPriorVotes(voter, proposal.startBlock);\n', '\n', '        if (support) {\n', '            proposal.forVotes = proposal.forVotes.add(votes);\n', '        } else {\n', '            proposal.againstVotes = proposal.againstVotes.add(votes);\n', '        }\n', '\n', '        receipt.hasVoted = true;\n', '        receipt.support = support;\n', '        receipt.votes = votes;\n', '\n', '        emit VoteCast(voter, proposalId, support, votes);\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '    \n', '    event NewDelay(uint indexed newDelay);\n', '    event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);\n', '    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);\n', '    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);\n', '\n', '    uint public constant GRACE_PERIOD = 14 days;\n', '    uint public constant MINIMUM_DELAY = 1 days;\n', '    uint public constant MAXIMUM_DELAY = 30 days;\n', '    \n', '    uint public delay = MINIMUM_DELAY;\n', '\n', '    mapping (bytes32 => bool) public queuedTransactions;\n', '\n', '    constructor(address token_) public {\n', '        VOTER = DelegateInterface(token_);\n', '    }\n', '\n', '    function() external payable { }\n', '\n', '    function setDelay(uint delay_) public {\n', '        require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");\n', '        require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");\n', '        require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");\n', '        delay = delay_;\n', '\n', '        emit NewDelay(delay);\n', '    }\n', '\n', '    function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {\n', '        require(msg.sender == address(this), "Timelock::queueTransaction: Call must come from admin.");\n', '        require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");\n', '\n', '        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '        queuedTransactions[txHash] = true;\n', '\n', '        emit QueueTransaction(txHash, target, value, signature, data, eta);\n', '        return txHash;\n', '    }\n', '\n', '    function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {\n', '        require(msg.sender == address(this), "Timelock::cancelTransaction: Call must come from admin.");\n', '\n', '        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '        queuedTransactions[txHash] = false;\n', '\n', '        emit CancelTransaction(txHash, target, value, signature, data, eta);\n', '    }\n', '\n', '    function executeTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {\n', '        require(msg.sender == address(this), "Timelock::executeTransaction: Call must come from admin.");\n', '\n', '        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '        require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn\'t been queued.");\n', '        require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn\'t surpassed time lock.");\n', '        require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");\n', '\n', '        queuedTransactions[txHash] = false;\n', '\n', '        bytes memory callData;\n', '\n', '        if (bytes(signature).length == 0) {\n', '            callData = data;\n', '        } else {\n', '            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);\n', '        }\n', '\n', '        // solium-disable-next-line security/no-call-value\n', '        (bool success, bytes memory returnData) = target.call.value(value)(callData);\n', '        require(success, "Timelock::executeTransaction: Transaction execution reverted.");\n', '\n', '        emit ExecuteTransaction(txHash, target, value, signature, data, eta);\n', '\n', '        return returnData;\n', '    }\n', '\n', '    function getBlockTimestamp() internal view returns (uint) {\n', '        // solium-disable-next-line security/no-block-members\n', '        return block.timestamp;\n', '    }\n', '}\n', '\n', 'interface DelegateInterface {\n', '    function getPriorVotes(address account, uint blockNumber) external view returns (uint);\n', '    function totalSupply() external view returns (uint);\n', '}\n', '\n', 'contract GovernanceFactory {\n', '    function deploy(address voter) external returns (address) {\n', '        return address(new Governance(voter));\n', '    }\n', '}']