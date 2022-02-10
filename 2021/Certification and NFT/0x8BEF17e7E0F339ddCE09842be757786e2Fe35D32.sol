['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-19\n', '*/\n', '\n', '/*\n', "    .'''''''''''..     ..''''''''''''''''..       ..'''''''''''''''..\n", "    .;;;;;;;;;;;'.   .';;;;;;;;;;;;;;;;;;,.     .,;;;;;;;;;;;;;;;;;,.\n", '    .;;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;,.    .,;;;;;;;;;;;;;;;;;;,.\n', '    .;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.   .;;;;;;;;;;;;;;;;;;;;,.\n', "    ';;;;;;;;'.  .';;;;;;;;;;;;;;;;;;;;;;,. .';;;;;;;;;;;;;;;;;;;;;,.\n", "    ';;;;;,..   .';;;;;;;;;;;;;;;;;;;;;;;,..';;;;;;;;;;;;;;;;;;;;;;,.\n", "    ......     .';;;;;;;;;;;;;,'''''''''''.,;;;;;;;;;;;;;,'''''''''..\n", '              .,;;;;;;;;;;;;;.           .,;;;;;;;;;;;;;.\n', '             .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.\n', '            .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.\n', '           .,;;;;;;;;;;;;,.           .;;;;;;;;;;;;;,.     .....\n', "          .;;;;;;;;;;;;;'.         ..';;;;;;;;;;;;;'.    .',;;;;,'.\n", "        .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.   .';;;;;;;;;;.\n", "       .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.    .;;;;;;;;;;;,.\n", "      .,;;;;;;;;;;;;;'...........,;;;;;;;;;;;;;;.      .;;;;;;;;;;;,.\n", '     .,;;;;;;;;;;;;,..,;;;;;;;;;;;;;;;;;;;;;;;,.       ..;;;;;;;;;,.\n', "    .,;;;;;;;;;;;;,. .,;;;;;;;;;;;;;;;;;;;;;;,.          .',;;;,,..\n", '   .,;;;;;;;;;;;;,.  .,;;;;;;;;;;;;;;;;;;;;;,.              ....\n', "    ..',;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.\n", "       ..',;;;;'.    .,;;;;;;;;;;;;;;;;;;;'.\n", "          ...'..     .';;;;;;;;;;;;;;,,,'.\n", '                       ...............\n', '*/\n', '\n', '// https://github.com/trusttoken/smart-contracts\n', '// Dependency file: contracts/governance/common/ClaimableContract.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '// pragma solidity 0.6.10;\n', '\n', '/**\n', ' * @title ClaimableContract\n', ' * @dev The ClaimableContract contract is a copy of Claimable Contract by Zeppelin.\n', ' and provides basic authorization control functions. Inherits storage layout of\n', ' ProxyStorage.\n', ' */\n', 'contract ClaimableContract {\n', '    address owner_;\n', '    address pendingOwner_;\n', '    bool initalized;\n', '\n', '    function owner() public view returns (address) {\n', '        return owner_;\n', '    }\n', '\n', '    function pendingOwner() public view returns (address) {\n', '        return pendingOwner_;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev sets the original `owner` of the contract to the sender\n', '     * at construction. Must then be reinitialized\n', '     */\n', '    constructor() public {\n', '        owner_ = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner_, "only owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingOwner.\n', '     */\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner_);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to set the pendingOwner address.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        pendingOwner_ = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingOwner address to finalize the transfer.\n', '     */\n', '    function claimOwnership() public onlyPendingOwner {\n', '        address _pendingOwner = pendingOwner_;\n', '        emit OwnershipTransferred(owner_, _pendingOwner);\n', '        owner_ = _pendingOwner;\n', '        pendingOwner_ = address(0);\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/governance/interface/ITimelock.sol\n', '\n', '\n', '// pragma solidity ^0.6.10;\n', '\n', 'interface ITimelock {\n', '    function delay() external view returns (uint256);\n', '\n', '    function GRACE_PERIOD() external view returns (uint256);\n', '\n', '    function acceptAdmin() external;\n', '\n', '    function queuedTransactions(bytes32 hash) external view returns (bool);\n', '\n', '    function queueTransaction(\n', '        address target,\n', '        uint256 value,\n', '        string calldata signature,\n', '        bytes calldata data,\n', '        uint256 eta\n', '    ) external returns (bytes32);\n', '\n', '    function cancelTransaction(\n', '        address target,\n', '        uint256 value,\n', '        string calldata signature,\n', '        bytes calldata data,\n', '        uint256 eta\n', '    ) external;\n', '\n', '    function executeTransaction(\n', '        address target,\n', '        uint256 value,\n', '        string calldata signature,\n', '        bytes calldata data,\n', '        uint256 eta\n', '    ) external payable returns (bytes memory);\n', '}\n', '\n', '\n', '// Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '\n', '// pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * // importANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// Dependency file: contracts/governance/interface/IVoteToken.sol\n', '\n', '// pragma solidity ^0.6.10;\n', '\n', '// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'interface IVoteToken {\n', '    function delegate(address delegatee) external;\n', '\n', '    function delegateBySig(\n', '        address delegatee,\n', '        uint256 nonce,\n', '        uint256 expiry,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '\n', '    function getCurrentVotes(address account) external view returns (uint96);\n', '\n', '    function getPriorVotes(address account, uint256 blockNumber) external view returns (uint96);\n', '}\n', '\n', 'interface IVoteTokenWithERC20 is IVoteToken, IERC20 {}\n', '\n', '\n', '// Root file: contracts/governance/GovernorAlpha.sol\n', '\n', '// AND COPIED FROM https://github.com/compound-finance/compound-protocol/blob/c5fcc34222693ad5f547b14ed01ce719b5f4b000/contracts/Governance/GovernorAlpha.sol\n', '// Copyright 2020 Compound Labs, Inc.\n', '// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n', '// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n', '// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n', '// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n', '// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '//\n', '// Ctrl+f for OLD to see all the modifications.\n', '\n', '// OLD: pragma solidity ^0.5.16;\n', 'pragma solidity ^0.6.10;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '// import {ClaimableContract} from "contracts/governance/common/ClaimableContract.sol";\n', '// import {ITimelock} from "contracts/governance/interface/ITimelock.sol";\n', '// import {IVoteToken} from "contracts/governance/interface/IVoteToken.sol";\n', '\n', 'contract GovernorAlpha is ClaimableContract {\n', '    // @notice The name of this contract\n', '    string public constant name = "TrustToken Governor Alpha";\n', '\n', '    // @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed\n', '    function quorumVotes() public pure returns (uint) { return 10000000e8; } // 10,000,000 Tru\n', '\n', '    // @notice The number of votes required in order for a voter to become a proposer\n', '    function proposalThreshold() public pure returns (uint) { return 100000e8; } // 100,000 TRU\n', '\n', '    // @notice The maximum number of actions that can be included in a proposal\n', '    function proposalMaxOperations() public pure returns (uint) { return 10; } // 10 actions\n', '\n', '    // @notice The delay before voting on a proposal may take place, once proposed\n', '    function votingDelay() public pure returns (uint) { return 1; } // 1 block\n', '\n', '    // @notice The duration of voting on a proposal, in blocks\n', '    uint public votingPeriod;\n', '\n', '    // @notice The address of the TrustToken Protocol Timelock\n', '    ITimelock public timelock;\n', '\n', '    // @notice The address of the TrustToken governance token\n', '    IVoteToken public trustToken;\n', '\n', '    // @notice The address of the stkTRU voting token\n', '    IVoteToken public stkTRU;\n', '\n', '    // @notice The address of the Governor Guardian\n', '    address public guardian;\n', '\n', '    // @notice The total number of proposals\n', '    uint public proposalCount;\n', '\n', '    struct Proposal {\n', '        // @notice Unique id for looking up a proposal\n', '        uint id;\n', '\n', '        // @notice Creator of the proposal\n', '        address proposer;\n', '\n', '        // @notice The timestamp that the proposal will be available for execution, set once the vote succeeds\n', '        uint eta;\n', '\n', '        // @notice the ordered list of target addresses for calls to be made\n', '        address[] targets;\n', '\n', '        // @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made\n', '        uint[] values;\n', '\n', '        // @notice The ordered list of function signatures to be called\n', '        string[] signatures;\n', '\n', '        // @notice The ordered list of calldata to be passed to each call\n', '        bytes[] calldatas;\n', '\n', '        // @notice The block at which voting begins: holders must delegate their votes prior to this block\n', '        uint startBlock;\n', '\n', '        // @notice The block at which voting ends: votes must be cast prior to this block\n', '        uint endBlock;\n', '\n', '        // @notice Current number of votes in favor of this proposal\n', '        uint forVotes;\n', '\n', '        // @notice Current number of votes in opposition to this proposal\n', '        uint againstVotes;\n', '\n', '        // @notice Flag marking whether the proposal has been canceled\n', '        bool canceled;\n', '\n', '        // @notice Flag marking whether the proposal has been executed\n', '        bool executed;\n', '\n', '        // @notice Receipts of ballots for the entire set of voters\n', '        mapping (address => Receipt) receipts;\n', '    }\n', '\n', '    // @notice Ballot receipt record for a voter\n', '    struct Receipt {\n', '        // @notice Whether or not a vote has been cast\n', '        bool hasVoted;\n', '\n', '        // @notice Whether or not the voter supports the proposal\n', '        bool support;\n', '\n', '        // @notice The number of votes the voter had, which were cast\n', '        uint96 votes;\n', '    }\n', '\n', '    // @notice Possible states that a proposal may be in\n', '    enum ProposalState {\n', '        Pending,\n', '        Active,\n', '        Canceled,\n', '        Defeated,\n', '        Succeeded,\n', '        Queued,\n', '        Expired,\n', '        Executed\n', '    }\n', '\n', '    // @notice The official record of all proposals ever proposed\n', '    mapping (uint => Proposal) public proposals;\n', '\n', '    // @notice The latest proposal for each proposer\n', '    mapping (address => uint) public latestProposalIds;\n', '\n', "    // @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");\n', '\n', '    // @notice The EIP-712 typehash for the ballot struct used by the contract\n', '    bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");\n', '\n', '    // @notice An event emitted when a new proposal is created\n', '    event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);\n', '\n', '    // @notice An event emitted when a vote has been cast on a proposal\n', '    event VoteCast(address voter, uint proposalId, bool support, uint votes);\n', '\n', '    // @notice An event emitted when a proposal has been canceled\n', '    event ProposalCanceled(uint id);\n', '\n', '    // @notice An event emitted when a proposal has been queued in the Timelock\n', '    event ProposalQueued(uint id, uint eta);\n', '\n', '    // @notice An event emitted when a proposal has been executed in the Timelock\n', '    event ProposalExecuted(uint id);\n', '\n', '    /**\n', '     * @dev Initialize sets the addresses of timelock contract, trusttoken contract, and guardian\n', '     */\n', '    function initialize(ITimelock _timelock, IVoteToken _trustToken, address _guardian, IVoteToken _stkTRU, uint256 _votingPeriod) external {\n', '        timelock = _timelock;\n', '        trustToken = _trustToken;\n', '        stkTRU = _stkTRU;\n', '        guardian = _guardian;\n', '        votingPeriod = _votingPeriod;\n', '\n', '        owner_ = msg.sender;\n', '        initalized = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Create a proposal to change the protocol\n', '     * @param targets The ordered list of target addresses for calls to be made during proposal execution\n', '     * @param values The ordered list of values to be passed to the calls made during proposal execution\n', '     * @param signatures The ordered list of function signatures to be passed during execution\n', '     * @param calldatas The ordered list of data to be passed to each individual function call\n', '     * @param description A human readable description of the proposal and changes it will enact\n', '     * @return The ID of the newly created proposal\n', '     */\n', '    function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {\n', '        require(countVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(), "GovernorAlpha::propose: proposer votes below proposal threshold");\n', '        require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorAlpha::propose: proposal function information arity mismatch");\n', '        require(targets.length != 0, "GovernorAlpha::propose: must provide actions");\n', '        require(targets.length <= proposalMaxOperations(), "GovernorAlpha::propose: too many actions");\n', '\n', '        uint latestProposalId = latestProposalIds[msg.sender];\n', '        if (latestProposalId != 0) {\n', '          ProposalState proposersLatestProposalState = state(latestProposalId);\n', '          require(proposersLatestProposalState != ProposalState.Active, "GovernorAlpha::propose: one live proposal per proposer, found an already active proposal");\n', '          require(proposersLatestProposalState != ProposalState.Pending, "GovernorAlpha::propose: one live proposal per proposer, found an already pending proposal");\n', '        }\n', '\n', '        uint startBlock = add256(block.number, votingDelay());\n', '        // OLD: uint endBlock = add256(startBlock, votingPeriod());\n', '        uint endBlock = add256(startBlock, votingPeriod);\n', '\n', '        proposalCount++;\n', '        Proposal memory newProposal = Proposal({\n', '            id: proposalCount,\n', '            proposer: msg.sender,\n', '            eta: 0,\n', '            targets: targets,\n', '            values: values,\n', '            signatures: signatures,\n', '            calldatas: calldatas,\n', '            startBlock: startBlock,\n', '            endBlock: endBlock,\n', '            forVotes: 0,\n', '            againstVotes: 0,\n', '            canceled: false,\n', '            executed: false\n', '        });\n', '\n', '        proposals[newProposal.id] = newProposal;\n', '        latestProposalIds[newProposal.proposer] = newProposal.id;\n', '\n', '        emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);\n', '        return newProposal.id;\n', '    }\n', '\n', '    /**\n', '     * @dev Queue a proposal after a proposal has succeeded\n', '     * @param proposalId ID of a proposal that has succeeded\n', '     */\n', '    function queue(uint proposalId) public {\n', '        require(state(proposalId) == ProposalState.Succeeded, "GovernorAlpha::queue: proposal can only be queued if it is succeeded");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        uint eta = add256(block.timestamp, timelock.delay());\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);\n', '        }\n', '        proposal.eta = eta;\n', '        emit ProposalQueued(proposalId, eta);\n', '    }\n', '\n', '    /**\n', '     * @dev Queue one single proposal transaction to timelock contract\n', '     * @param target The target address for call to be made during proposal execution\n', '     * @param value The value to be passed to the calls made during proposal execution\n', '     * @param signature The function signature to be passed during execution\n', '     * @param data The data to be passed to the individual function call\n', '     * @param eta The current timestamp plus the timelock delay\n', '     */\n', '    function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {\n', '        require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "GovernorAlpha::_queueOrRevert: proposal action already queued at eta");\n', '        timelock.queueTransaction(target, value, signature, data, eta);\n', '    }\n', '\n', '    /**\n', '     * @dev Execute a proposal after a proposal has queued and invoke each of the actions in the proposal\n', '     * @param proposalId ID of a proposal that has queued\n', '     */\n', '    function execute(uint proposalId) public payable {\n', '        require(state(proposalId) == ProposalState.Queued, "GovernorAlpha::execute: proposal can only be executed if it is queued");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        proposal.executed = true;\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            //OLD: timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '            timelock.executeTransaction{value: proposal.values[i]}(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '        emit ProposalExecuted(proposalId);\n', '    }\n', '\n', '    /**\n', '     * @dev Cancel a proposal that has not yet been executed\n', '     * @param proposalId ID of a proposal that wished to be canceled\n', '     */\n', '    function cancel(uint proposalId) public {\n', '        ProposalState state = state(proposalId);\n', '        require(state != ProposalState.Executed, "GovernorAlpha::cancel: cannot cancel executed proposal");\n', '\n', '        Proposal storage proposal = proposals[proposalId];\n', '        require(msg.sender == guardian || countVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(), "GovernorAlpha::cancel: proposer above threshold");\n', '\n', '        proposal.canceled = true;\n', '        for (uint i = 0; i < proposal.targets.length; i++) {\n', '            timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);\n', '        }\n', '\n', '        emit ProposalCanceled(proposalId);\n', '    }\n', '\n', '    /**\n', '     * @dev Get the actions of a selected proposal\n', '     * @param proposalId ID of a proposal\n', '     * return An array of target addresses, an array of proposal values, an array of proposal signatures, and an array of calldata\n', '     */\n', '    function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {\n', '        Proposal storage p = proposals[proposalId];\n', '        return (p.targets, p.values, p.signatures, p.calldatas);\n', '    }\n', '\n', '    /**\n', '     * @dev Get a proposal ballot receipt of the indicated voter\n', "     * @param proposalId ID of a proposal in which to get voter's ballot receipt\n", '     * @return the Ballot receipt record for a voter\n', '     */\n', '    function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {\n', '        return proposals[proposalId].receipts[voter];\n', '    }\n', '\n', '    /**\n', '     * @dev Get the proposal state for the specified proposal\n', '     * @param proposalId ID of a proposal in which to get its state\n', '     * @return Enumerated type of ProposalState\n', '     */\n', '    function state(uint proposalId) public view returns (ProposalState) {\n', '        require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha::state: invalid proposal id");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        if (proposal.canceled) {\n', '            return ProposalState.Canceled;\n', '        } else if (block.number <= proposal.startBlock) {\n', '            return ProposalState.Pending;\n', '        } else if (block.number <= proposal.endBlock) {\n', '            return ProposalState.Active;\n', '        } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {\n', '            return ProposalState.Defeated;\n', '        } else if (proposal.eta == 0) {\n', '            return ProposalState.Succeeded;\n', '        } else if (proposal.executed) {\n', '            return ProposalState.Executed;\n', '        } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {\n', '            return ProposalState.Expired;\n', '        } else {\n', '            return ProposalState.Queued;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Cast a vote on a proposal\n', '     * @param proposalId ID of a proposal in which to cast a vote\n', "     * @param support A boolean of true for 'for' or false for 'against' vote\n", '     */\n', '    function castVote(uint proposalId, bool support) public {\n', '        return _castVote(msg.sender, proposalId, support);\n', '    }\n', '\n', '    /**\n', '     * @dev Cast a vote on a proposal by offline signatures\n', '     * @param proposalId ID of a proposal in which to cast a vote\n', "     * @param support A boolean of true for 'for' or false for 'against' vote\n", '     * @param v The recovery byte of the signature\n', '     * @param r Half of the ECDSA signature pair\n', '     * @param s Half of the ECDSA signature pair\n', '     */\n', '    function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));\n', '        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "GovernorAlpha::castVoteBySig: invalid signature");\n', '        return _castVote(signatory, proposalId, support);\n', '    }\n', '\n', '    /**\n', '     * @dev Cast a vote on a proposal internal function\n', '     * @param voter The address of the voter\n', '     * @param proposalId ID of a proposal in which to cast a vote\n', "     * @param support A boolean of true for 'for' or false for 'against' vote\n", '     */\n', '    function _castVote(address voter, uint proposalId, bool support) internal {\n', '        require(state(proposalId) == ProposalState.Active, "GovernorAlpha::_castVote: voting is closed");\n', '        Proposal storage proposal = proposals[proposalId];\n', '        Receipt storage receipt = proposal.receipts[voter];\n', '        require(receipt.hasVoted == false, "GovernorAlpha::_castVote: voter already voted");\n', '        uint96 votes = countVotes(voter, proposal.startBlock);\n', '\n', '        if (support) {\n', '            proposal.forVotes = add256(proposal.forVotes, votes);\n', '        } else {\n', '            proposal.againstVotes = add256(proposal.againstVotes, votes);\n', '        }\n', '\n', '        receipt.hasVoted = true;\n', '        receipt.support = support;\n', '        receipt.votes = votes;\n', '\n', '        emit VoteCast(voter, proposalId, support, votes);\n', '    }\n', '\n', '    /**\n', '     * @dev Accept the pending admin as the admin in timelock contract\n', '     */\n', '    function __acceptAdmin() public {\n', '        require(msg.sender == guardian, "GovernorAlpha::__acceptAdmin: sender must be gov guardian");\n', '        timelock.acceptAdmin();\n', '    }\n', '\n', '    /**\n', '     * @dev Abdicate the guardian address to address(0)\n', '     */\n', '    function __abdicate() public {\n', '        require(msg.sender == guardian, "GovernorAlpha::__abdicate: sender must be gov guardian");\n', '        guardian = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Queue a setTimeLockPendingAdmin transaction to timelock contract\n', '     * @param newPendingAdmin The address of desired pending admin\n', '     * @param eta The current block timestamp plus the timelock.delay() timestamp\n', '     */\n', '    function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {\n', '        require(msg.sender == guardian, "GovernorAlpha::__queueSetTimelockPendingAdmin: sender must be gov guardian");\n', '        timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);\n', '    }\n', '\n', '    /**\n', '     * @dev Execute a setTimeLockPendingAdmin transaction to timelock contract\n', '     * @param newPendingAdmin The address of desired pending admin\n', '     * @param eta The current block timestamp plus the timelock.delay() timestamp\n', '     */\n', '    function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {\n', '        require(msg.sender == guardian, "GovernorAlpha::__executeSetTimelockPendingAdmin: sender must be gov guardian");\n', '        timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);\n', '    }\n', '\n', '    /**\n', '     * @dev safe addition function for uint256\n', '     */\n', '    function add256(uint256 a, uint256 b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev safe subtraction function for uint256\n', '     */\n', '    function sub256(uint256 a, uint256 b) internal pure returns (uint) {\n', '        require(b <= a, "subtraction underflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the chain ID\n', '     * @return The ID of chain\n', '     */\n', '    function getChainId() internal pure returns (uint) {\n', '        uint chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '\n', '    /**\n', '     * @dev Count the total PriorVotes from TRU and stkTRU\n', '     * @param account The address to check the total votes\n', '     * @param blockNumber The block number at which the getPriorVotes() check\n', '     * @return The sum of PriorVotes from TRU and stkTRU\n', '     */\n', '    function countVotes(address account, uint blockNumber) public view returns (uint96) {\n', '        uint96 truVote = trustToken.getPriorVotes(account, blockNumber);\n', '        uint96 stkTRUVote = stkTRU.getPriorVotes(account, blockNumber);\n', '        uint96 totalVote = add96(truVote, stkTRUVote, "GovernorAlpha: countVotes addition overflow");\n', '        return totalVote;\n', '    }\n', '\n', '    function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {\n', '        uint96 c = a + b;\n', '        require(c >= a, errorMessage);\n', '        return c;\n', '    }\n', '}']