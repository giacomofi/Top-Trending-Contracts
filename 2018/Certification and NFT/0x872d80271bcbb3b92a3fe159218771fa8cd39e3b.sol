['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract Job {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for ERC20;\n', '\n', '    event MilestoneCreated(uint16 id, uint16 parent, string title);\n', '    event ProposalCreated(uint16 id, uint16 milestone, address contractor, uint256 amount);\n', '\n', '    ERC20 public token;\n', '    string public title; \n', '    string public description; \n', '    address public escrowAdmin;\n', '    address public customer;\n', '    \n', '    struct Proposal {\n', '        address contractor;             //Address of contractor\n', '        uint256 amount;                 //Proposed price\n', '        string description;             //Description of proposal\n', '    }\n', '    struct Milestone {\n', '        uint16 parent;                  //id of parent milestone\n', '        string title;                   //Milestone title\n', '        string description;             //Milestone description\n', '        uint64 deadline;                //Timestamp When work should be done\n', '        Proposal[] proposals;           //Proposals from contractors\n', '        int16 acceptedProposal;         //id of accepted proposal or -1 if no accepted\n', '        bool done;                      //Contractor marked milestone as done\n', '        bool approved;                  //Is approved by manager: general contractor or customer - for general milestones\n', '        bool customerApproved;          //Is approved by customer\n', '        bool requiresCustomerApproval;  //Is customer approval requireds\n', '        uint256 paid;                   //Amount which was already paid to contractor\n', '        uint256 allowance;              //Amount contractor allowed to spend to pay sub-contractors of this milestone\n', '    }\n', '    Milestone[] public milestones;      //Array of all milestones\n', '\n', '    modifier onlyCustomer(){\n', '        require(msg.sender == customer);\n', '        _;\n', '    }\n', '\n', '    constructor(ERC20 _token, string _title, string _description, address _escrowAdmin) public {\n', '        token = _token;\n', '        customer = msg.sender;\n', '        title = _title;\n', '        description = _description;\n', '        escrowAdmin = _escrowAdmin;\n', '\n', '        pushMilestone(0, "", "", 0, false);\n', '    }\n', '\n', '    function addGeneralMilestone(string _title, string _description, uint64 _deadline) onlyCustomer external{\n', '        require(_deadline > now);\n', '        pushMilestone(0, _title, _description, _deadline, false);\n', '    }\n', '    function addSubMilestone(uint16 _parent, string _title, string _description, uint64 _deadline, bool _requiresCustomerApproval) external {\n', '        require(_parent > 0 && _parent < milestones.length);\n', '        Milestone storage parent = milestones[_parent];\n', '        require(parent.acceptedProposal >= 0);\n', '        address generalContractor = parent.proposals[uint16(parent.acceptedProposal)].contractor;\n', '        assert(generalContractor!= address(0));\n', '        require(msg.sender == generalContractor);\n', '        pushMilestone(_parent, _title, _description, _deadline, _requiresCustomerApproval);\n', '    }\n', '\n', '    function addProposal(uint16 milestone, uint256 _amount, string _description) external {\n', '        require(milestone < milestones.length);\n', '        require(_amount > 0);\n', '        milestones[milestone].proposals.push(Proposal({\n', '            contractor: msg.sender,\n', '            amount: _amount,\n', '            description: _description\n', '        }));\n', '        emit ProposalCreated( uint16(milestones[milestone].proposals.length-1), milestone, msg.sender, _amount);\n', '    }\n', '\n', '    function getProposal(uint16 milestone, uint16 proposal) view public returns(address contractor, uint256 amount, string description){\n', '        require(milestone < milestones.length);\n', '        Milestone storage m = milestones[milestone];\n', '        require(proposal < m.proposals.length);\n', '        Proposal storage p = m.proposals[proposal];\n', '        return (p.contractor, p.amount, p.description);\n', '    }\n', '    function getProposalAmount(uint16 milestone, uint16 proposal) view public returns(uint256){\n', '        require(milestone < milestones.length);\n', '        Milestone storage m = milestones[milestone];\n', '        require(proposal < m.proposals.length);\n', '        Proposal storage p = m.proposals[proposal];\n', '        return p.amount;\n', '    }\n', '    function getProposalContractor(uint16 milestone, uint16 proposal) view public returns(address){\n', '        require(milestone < milestones.length);\n', '        Milestone storage m = milestones[milestone];\n', '        require(proposal < m.proposals.length);\n', '        Proposal storage p = m.proposals[proposal];\n', '        return p.contractor;\n', '    }\n', '\n', '\n', '    function confirmProposalAndTransferFunds(uint16 milestone, uint16 proposal) onlyCustomer external returns(bool){\n', '        require(milestone < milestones.length);\n', '        Milestone storage m = milestones[milestone];\n', '        require(m.deadline > now);\n', '\n', '        require(proposal < m.proposals.length);\n', '        Proposal storage p = m.proposals[proposal];\n', '        m.acceptedProposal = int16(proposal);\n', '\n', '        require(token.transferFrom(customer, address(this), p.amount));\n', '        return true;\n', '    }\n', '    function markDone(uint16 _milestone) external {\n', '        require(_milestone < milestones.length);\n', '        Milestone storage m = milestones[_milestone];\n', '        assert(m.acceptedProposal >= 0);\n', '        Proposal storage p = m.proposals[uint16(m.acceptedProposal)];        \n', '        require(msg.sender == p.contractor);\n', '        require(m.done == false);\n', '        m.done = true;\n', '    }\n', '    function approveAndPayout(uint16 _milestone) onlyCustomer external{\n', '        require(_milestone < milestones.length);\n', '        Milestone storage m = milestones[_milestone];\n', '        require(m.acceptedProposal >= 0);\n', '        //require(m.done);  //We do not require this right now\n', '        m.customerApproved = true;\n', '        Proposal storage p = m.proposals[uint16(m.acceptedProposal)];\n', '\n', '        m.paid = p.amount;\n', '        require(token.transfer(p.contractor, p.amount));\n', '    }   \n', '\n', '    function balance() view public returns(uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    function pushMilestone(uint16 _parent, string _title, string _description, uint64 _deadline, bool _requiresCustomerApproval) private returns(uint16) {\n', '        uint16 id = uint16(milestones.length++);\n', '        milestones[id].parent = _parent;\n', '        milestones[id].title = _title;\n', '        milestones[id].description = _description;\n', '        milestones[id].deadline = _deadline;\n', '        milestones[id].acceptedProposal = -1;\n', '        milestones[id].requiresCustomerApproval = _requiresCustomerApproval;\n', '        emit MilestoneCreated(id, _parent, _title);\n', '        return id;\n', '    }\n', '\n', '}']