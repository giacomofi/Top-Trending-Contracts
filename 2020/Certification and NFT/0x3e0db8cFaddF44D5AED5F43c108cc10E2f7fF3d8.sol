['// Dependency file: contracts/interfaces/IERC20.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '// Dependency file: contracts/ballots/DemaxBallot.sol\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// pragma solidity >=0.6.6;\n', '\n', "// import '../interfaces/IERC20.sol';\n", '\n', '/**\n', ' * @title DemaxBallot\n', ' * @dev Implements voting process along with vote delegation\n', ' */\n', 'contract DemaxBallot {\n', '\n', '    struct Voter {\n', '        uint weight; // weight is accumulated by delegation\n', '        bool voted;  // if true, that person already voted\n', '        address delegate; // person delegated to\n', '        uint vote;   // index of the voted proposal\n', '    }\n', '\n', '    mapping(address => Voter) public voters;\n', '    mapping(uint => uint) public proposals;\n', '\n', '    address public governor;\n', '    address public proposer;\n', '    uint public value;\n', '    uint public endBlockNumber;\n', '    bool public ended;\n', '    string public subject;\n', '    string public content;\n', '\n', '    uint private constant NONE = 0;\n', '    uint private constant YES = 1;\n', '    uint private constant NO = 2;\n', '\n', '    uint public total;\n', '    uint public createTime;\n', '\n', '    modifier onlyGovernor() {\n', "        require(msg.sender == governor, 'DemaxBallot: FORBIDDEN');\n", '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Create a new ballot.\n', '     */\n', '    constructor(address _proposer, uint _value, uint _endBlockNumber, address _governor, string memory _subject, string memory _content) public {\n', '        proposer = _proposer;\n', '        value = _value;\n', '        endBlockNumber = _endBlockNumber;\n', '        governor = _governor;\n', '        subject = _subject;\n', '        content = _content;\n', '        proposals[YES] = 0;\n', '        proposals[NO] = 0;\n', '        createTime = block.timestamp;\n', '    }\n', '\n', '    /**\n', "     * @dev Give 'voter' the right to vote on this ballot.\n", '     * @param voter address of voter\n', '     */\n', '    function _giveRightToVote(address voter) private returns (Voter storage) {\n', '        require(block.number < endBlockNumber, "Bollot is ended");\n', '        Voter storage sender = voters[voter];\n', '        require(!sender.voted, "You already voted");\n', '        sender.weight += IERC20(governor).balanceOf(voter);\n', '        require(sender.weight != 0, "Has no right to vote");\n', '        return sender;\n', '    }\n', '\n', '    /**\n', "     * @dev Delegate your vote to the voter 'to'.\n", '     * @param to address to which vote is delegated\n', '     */\n', '    function delegate(address to) public {\n', '        Voter storage sender = _giveRightToVote(msg.sender);\n', '        require(to != msg.sender, "Self-delegation is disallowed");\n', '\n', '        while (voters[to].delegate != address(0)) {\n', '            to = voters[to].delegate;\n', '\n', '            // We found a loop in the delegation, not allowed.\n', '            require(to != msg.sender, "Found loop in delegation");\n', '        }\n', '        sender.voted = true;\n', '        sender.delegate = to;\n', '        Voter storage delegate_ = voters[to];\n', '        if (delegate_.voted) {\n', '            // If the delegate already voted,\n', '            // directly add to the number of votes\n', '            proposals[delegate_.vote] += sender.weight;\n', '            total += sender.weight;\n', '        } else {\n', '            // If the delegate did not vote yet,\n', '            // add to her weight.\n', '            delegate_.weight += sender.weight;\n', '            total += sender.weight;\n', '        }\n', '    }\n', '\n', '    /**\n', "     * @dev Give your vote (including votes delegated to you) to proposal 'proposals[proposal].name'.\n", '     * @param proposal index of proposal in the proposals array\n', '     */\n', '    function vote(uint proposal) public {\n', '        Voter storage sender = _giveRightToVote(msg.sender);\n', "        require(proposal==YES || proposal==NO, 'Only vote 1 or 2');\n", '        sender.voted = true;\n', '        sender.vote = proposal;\n', '        proposals[proposal] += sender.weight;\n', '        total += sender.weight;\n', '    }\n', '\n', '    /**\n', '     * @dev Computes the winning proposal taking all previous votes into account.\n', '     * @return winningProposal_ index of winning proposal in the proposals array\n', '     */\n', '    function winningProposal() public view returns (uint) {\n', '        if (proposals[YES] > proposals[NO]) {\n', '            return YES;\n', '        } else if (proposals[YES] < proposals[NO]) {\n', '            return NO;\n', '        } else {\n', '            return NONE;\n', '        }\n', '    }\n', '\n', '    function result() public view returns (bool) {\n', '        uint winner = winningProposal();\n', '        if (winner == YES) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function end() public onlyGovernor returns (bool) {\n', '        require(block.number >= endBlockNumber, "ballot not yet ended");\n', '        require(!ended, "end has already been called");\n', '        ended = true;\n', '        return result();\n', '    }\n', '\n', '    function weight(address user) external view returns (uint) {\n', '        Voter memory voter = voters[user];\n', '        return voter.weight;\n', '    }\n', '\n', '}\n', '\n', 'pragma solidity >=0.6.6;\n', '\n', '// import "./DemaxBallot.sol";\n', '\n', 'contract DemaxBallotFactory {\n', '\n', '    event Created(address indexed proposer, address indexed ballotAddr, uint createTime);\n', '\n', '    constructor () public {\n', '    }\n', '\n', '    function create(address _proposer, uint _value, uint _endBlockNumber, string calldata _subject, string calldata _content) external returns (address) {\n', "        require(_value >= 0, 'DemaxBallotFactory: INVALID_PARAMTERS');\n", '        address ballotAddr = address(\n', '            new DemaxBallot(_proposer, _value, _endBlockNumber, msg.sender, _subject, _content)\n', '        );\n', '        emit Created(_proposer, ballotAddr, block.timestamp);\n', '        return ballotAddr;\n', '    }\n', '}']