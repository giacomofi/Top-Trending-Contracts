['// SPDX-License-Identifier: GPL-3.0\n', "// forked from Compound's autonomous proposal Factory @0x524B54a6A7409A2Ac5b263Fb2A41DAC9d155ae71\n", '// refactored by the penguin party @penguinparty.eth\n', '\n', 'pragma solidity ^0.6.10;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IUni {\n', '    function delegate(address delegatee) external;\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address dst, uint rawAmount) external returns (bool);\n', '    function transferFrom(address src, address dst, uint rawAmount) external returns (bool);\n', '}\n', '\n', 'interface IGovernorAlpha {\n', '    function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) external returns (uint);\n', '    function castVote(uint proposalId, bool support) external;\n', '}\n', '\n', 'contract CrowdProposal {\n', '    /// @notice The crowd proposal author\n', '    address payable public immutable author;\n', '\n', '    /// @notice Governance proposal data\n', '    address[] public targets;\n', '    uint[] public values;\n', '    string[] public signatures;\n', '    bytes[] public calldatas;\n', '    string public description;\n', '\n', '    /// @notice UNI token contract address\n', '    address public immutable uni;\n', '    /// @notice Uniswap protocol `GovernorAlpha` contract address\n', '    address public immutable governor;\n', '\n', '    /// @notice Governance proposal id\n', '    uint public govProposalId;\n', '    /// @notice Terminate flag\n', '    bool public terminated;\n', '\n', '    /// @notice An event emitted when the governance proposal is created\n', '    event CrowdProposalProposed(address indexed proposal, address indexed author, uint proposalId);\n', '    /// @notice An event emitted when the crowd proposal is terminated\n', '    event CrowdProposalTerminated(address indexed proposal, address indexed author);\n', '    /// @notice An event emitted when delegated votes are transfered to the governance proposal\n', '    event CrowdProposalVoted(address indexed proposal, uint proposalId);\n', '\n', '    /**\n', '    * @notice Construct crowd proposal\n', '    * @param author_ The crowd proposal author\n', '    * @param targets_ The ordered list of target addresses for calls to be made\n', '    * @param values_ The ordered list of values (i.e. msg.value) to be passed to the calls to be made\n', '    * @param signatures_ The ordered list of function signatures to be called\n', '    * @param calldatas_ The ordered list of calldata to be passed to each call\n', '    * @param description_ The block at which voting begins: holders must delegate their votes prior to this block\n', '    * @param uni_ `UNI` token contract address\n', '    * @param governor_ Uniswap protocol `GovernorAlpha` contract address\n', '    */\n', '    constructor(address payable author_,\n', '                address[] memory targets_,\n', '                uint[] memory values_,\n', '                string[] memory signatures_,\n', '                bytes[] memory calldatas_,\n', '                string memory description_,\n', '                address uni_,\n', '                address governor_) public {\n', '                    author = author_;\n', '\n', '                    // Save proposal data\n', '                    targets = targets_;\n', '                    values = values_;\n', '                    signatures = signatures_;\n', '                    calldatas = calldatas_;\n', '                    description = description_;\n', '\n', '                    // Save Uniswap contracts data\n', '                    uni = uni_;\n', '                    governor = governor_;\n', '\n', '                    terminated = false;\n', '\n', '                    // Delegate votes to the crowd proposal\n', '                    IUni(uni_).delegate(address(this));\n', '                }\n', '\n', '                /// @notice Create governance proposal\n', '                function propose() external returns (uint) {\n', "                    require(govProposalId == 0, 'CrowdProposal::propose: gov proposal already exists');\n", "                    require(!terminated, 'CrowdProposal::propose: proposal has been terminated');\n", '\n', '                    // Create governance proposal and save proposal id\n', '                    govProposalId = IGovernorAlpha(governor).propose(targets, values, signatures, calldatas, description);\n', '                    emit CrowdProposalProposed(address(this), author, govProposalId);\n', '\n', '                    return govProposalId;\n', '                }\n', '\n', '                /// @notice Terminate the crowd proposal, send back staked UNI tokens\n', '                function terminate() external {\n', "                    require(msg.sender == author, 'CrowdProposal::terminate: only author can terminate');\n", "                    require(!terminated, 'CrowdProposal::terminate: proposal has been already terminated');\n", '\n', '                    terminated = true;\n', '\n', '                    // Transfer staked UNI tokens from the crowd proposal contract back to the author\n', '                    IUni(uni).transfer(author, IUni(uni).balanceOf(address(this)));\n', '\n', '                    emit CrowdProposalTerminated(address(this), author);\n', '                }\n', '\n', '                /// @notice Vote for the governance proposal with all delegated votes\n', '                function vote() external {\n', "                    require(govProposalId > 0, 'CrowdProposal::vote: gov proposal has not been created yet');\n", '                    IGovernorAlpha(governor).castVote(govProposalId, true);\n', '\n', '                    emit CrowdProposalVoted(address(this), govProposalId);\n', '                }\n', '}\n', '\n', '\n', 'contract CrowdProposalFactory {\n', '    /// @notice `UNI` token contract address\n', '    address public immutable uni;\n', '    /// @notice Uniswap protocol `GovernorAlpha` contract address\n', '    address public immutable governor;\n', '    /// @notice Minimum uni tokens required to create a crowd proposal\n', '    uint public immutable uniStakeAmount;\n', '\n', '    /// @notice An event emitted when a crowd proposal is created\n', '    event CrowdProposalCreated(address indexed proposal, address indexed author, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, string description);\n', '\n', '    /**\n', '    * @notice Construct a proposal factory for crowd proposals\n', '    * @param uni_ `UNI` token contract address\n', '    * @param governor_ Uniswap protocol `GovernorAlpha` contract address\n', '    * @param uniStakeAmount_ The minimum amount of uni tokes required for creation of a crowd proposal\n', '        */\n', '    constructor(address uni_,\n', '                address governor_,\n', '                uint uniStakeAmount_) public {\n', '                    uni = uni_;\n', '                    governor = governor_;\n', '                    uniStakeAmount = uniStakeAmount_;\n', '                }\n', '\n', '                /**\n', '                * @notice Create a new crowd proposal\n', '                * @notice Call `uni.approve(factory_address, uniStakeAmount)` before calling this method\n', '                * @param targets The ordered list of target addresses for calls to be made\n', '                * @param values The ordered list of values (i.e. msg.value) to be passed to the calls to be made\n', '                * @param signatures The ordered list of function signatures to be called\n', '                * @param calldatas The ordered list of calldata to be passed to each call\n', '                * @param description The block at which voting begins: holders must delegate their votes prior to this block\n', '                */\n', '                function createCrowdProposal(address[] memory targets,\n', '                                             uint[] memory values,\n', '                                             string[] memory signatures,\n', '                                             bytes[] memory calldatas,\n', '                                             string memory description) external {\n', '                                                 CrowdProposal proposal = new CrowdProposal(msg.sender, targets, values, signatures, calldatas, description, uni, governor);\n', '                                                 emit CrowdProposalCreated(address(proposal), msg.sender, targets, values, signatures, calldatas, description);\n', '\n', '                                                 // Stake UNI and force proposal to delegate votes to itself\n', '                                                 IUni(uni).transferFrom(msg.sender, address(proposal), uniStakeAmount);\n', '                                             }\n', '\n', '}']