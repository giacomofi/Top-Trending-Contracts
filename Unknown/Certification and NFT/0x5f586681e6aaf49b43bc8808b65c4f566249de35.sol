['pragma solidity ^0.4.4;\n', '\n', '/**\n', ' * @title Contract for object that have an owner\n', ' */\n', 'contract Owned {\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public owner;\n', '\n', '    /**\n', '     * @dev Delegate contract to another person\n', '     * @param _owner New owner address \n', '     */\n', '    function setOwner(address _owner) onlyOwner\n', '    { owner = _owner; }\n', '\n', '    /**\n', '     * @dev Owner check modifier\n', '     */\n', '    modifier onlyOwner { if (msg.sender != owner) throw; _; }\n', '}\n', '\n', '/**\n', ' * @title Common pattern for destroyable contracts \n', ' */\n', 'contract Destroyable {\n', '    address public hammer;\n', '\n', '    /**\n', '     * @dev Hammer setter\n', '     * @param _hammer New hammer address\n', '     */\n', '    function setHammer(address _hammer) onlyHammer\n', '    { hammer = _hammer; }\n', '\n', '    /**\n', '     * @dev Destroy contract and scrub a data\n', '     * @notice Only hammer can call it \n', '     */\n', '    function destroy() onlyHammer\n', '    { suicide(msg.sender); }\n', '\n', '    /**\n', '     * @dev Hammer check modifier\n', '     */\n', '    modifier onlyHammer { if (msg.sender != hammer) throw; _; }\n', '}\n', '\n', '/**\n', ' * @title Generic owned destroyable contract\n', ' */\n', 'contract Object is Owned, Destroyable {\n', '    function Object() {\n', '        owner  = msg.sender;\n', '        hammer = msg.sender;\n', '    }\n', '}\n', '\n', '// Standard token interface (ERC 20)\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 \n', '{\n', '// Functions:\n', '    /// @return total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256);\n', '\n', '// Events:\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title Asset recipient interface\n', ' */\n', 'contract Recipient {\n', '    /**\n', '     * @dev On received ethers\n', '     * @param sender Ether sender\n', '     * @param amount Ether value\n', '     */\n', '    event ReceivedEther(address indexed sender,\n', '                        uint256 indexed amount);\n', '\n', '    /**\n', '     * @dev On received custom ERC20 tokens\n', '     * @param from Token sender\n', '     * @param value Token value\n', '     * @param token Token contract address\n', '     * @param extraData Custom additional data\n', '     */\n', '    event ReceivedTokens(address indexed from,\n', '                         uint256 indexed value,\n', '                         address indexed token,\n', '                         bytes extraData);\n', '\n', '    /**\n', '     * @dev Receive approved ERC20 tokens\n', '     * @param _from Spender address\n', '     * @param _value Transaction value\n', '     * @param _token ERC20 token contract address\n', '     * @param _extraData Custom additional data\n', '     */\n', '    function receiveApproval(address _from, uint256 _value,\n', '                             ERC20 _token, bytes _extraData) {\n', '        if (!_token.transferFrom(_from, this, _value)) throw;\n', '        ReceivedTokens(_from, _value, _token, _extraData);\n', '    }\n', '\n', '    /**\n', '     * @dev Catch sended to contract ethers\n', '     */\n', '    function () payable\n', '    { ReceivedEther(msg.sender, msg.value); }\n', '}\n', '\n', '/**\n', ' * @title Improved congress contract by Ethereum Foundation\n', ' * @dev https://www.ethereum.org/dao#the-blockchain-congress \n', ' */\n', 'contract Congress is Object, Recipient {\n', '    /**\n', '     * @dev Minimal quorum value\n', '     */\n', '    uint256 public minimumQuorum;\n', '\n', '    /**\n', '     * @dev Duration of debates\n', '     */\n', '    uint256 public debatingPeriodInMinutes;\n', '\n', '    /**\n', '     * @dev Majority margin is used in voting procedure \n', '     */\n', '    int256 public majorityMargin;\n', '\n', '    /**\n', '     * @dev Archive of all member proposals \n', '     */\n', '    Proposal[] public proposals;\n', '\n', '    /**\n', '     * @dev Count of proposals in archive \n', '     */\n', '    function numProposals() constant returns (uint256)\n', '    { return proposals.length; }\n', '\n', '    /**\n', '     * @dev Congress members list\n', '     */\n', '    Member[] public members;\n', '\n', '    /**\n', '     * @dev Get member identifier by account address\n', '     */\n', '    mapping(address => uint256) public memberId;\n', '\n', '    /**\n', '     * @dev On proposal added \n', '     * @param proposal Proposal identifier\n', '     * @param recipient Ether recipient\n', '     * @param amount Amount of wei to transfer\n', '     */\n', '    event ProposalAdded(uint256 indexed proposal,\n', '                        address indexed recipient,\n', '                        uint256 indexed amount,\n', '                        string description);\n', '\n', '    /**\n', '     * @dev On vote by member accepted\n', '     * @param proposal Proposal identifier\n', '     * @param position Is proposal accepted by memeber\n', '     * @param voter Congress memeber account address\n', '     * @param justification Member comment\n', '     */\n', '    event Voted(uint256 indexed proposal,\n', '                bool    indexed position,\n', '                address indexed voter,\n', '                string justification);\n', '\n', '    /**\n', '     * @dev On Proposal closed\n', '     * @param proposal Proposal identifier\n', '     * @param quorum Number of votes \n', '     * @param active Is proposal passed\n', '     */\n', '    event ProposalTallied(uint256 indexed proposal,\n', '                          uint256 indexed quorum,\n', '                          bool    indexed active);\n', '\n', '    /**\n', '     * @dev On changed membership\n', '     * @param member Account address \n', '     * @param isMember Is account member now\n', '     */\n', '    event MembershipChanged(address indexed member,\n', '                            bool    indexed isMember);\n', '\n', '    /**\n', '     * @dev On voting rules changed\n', '     * @param minimumQuorum New minimal count of votes\n', '     * @param debatingPeriodInMinutes New debating duration\n', '     * @param majorityMargin New majority margin value\n', '     */\n', '    event ChangeOfRules(uint256 indexed minimumQuorum,\n', '                        uint256 indexed debatingPeriodInMinutes,\n', '                        int256  indexed majorityMargin);\n', '\n', '    struct Proposal {\n', '        address recipient;\n', '        uint256 amount;\n', '        string  description;\n', '        uint256 votingDeadline;\n', '        bool    executed;\n', '        bool    proposalPassed;\n', '        uint256 numberOfVotes;\n', '        int256  currentResult;\n', '        bytes32 proposalHash;\n', '        Vote[]  votes;\n', '        mapping(address => bool) voted;\n', '    }\n', '\n', '    struct Member {\n', '        address member;\n', '        string  name;\n', '        uint256 memberSince;\n', '    }\n', '\n', '    struct Vote {\n', '        bool    inSupport;\n', '        address voter;\n', '        string  justification;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier that allows only shareholders to vote and create new proposals\n', '     */\n', '    modifier onlyMembers {\n', '        if (memberId[msg.sender] == 0) throw;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev First time setup\n', '     */\n', '    function Congress(\n', '        uint256 minimumQuorumForProposals,\n', '        uint256 minutesForDebate,\n', '        int256  marginOfVotesForMajority,\n', '        address congressLeader\n', '    ) {\n', '        changeVotingRules(minimumQuorumForProposals, minutesForDebate, marginOfVotesForMajority);\n', '        // It’s necessary to add an empty first member\n', "        addMember(0, ''); // and let's add the founder, to save a step later\n", '        if (congressLeader != 0)\n', "            addMember(congressLeader, 'The Founder');\n", '    }\n', '\n', '    /**\n', '     * @dev Append new congress member \n', '     * @param targetMember Member account address\n', '     * @param memberName Member full name\n', '     */\n', '    function addMember(address targetMember, string memberName) onlyOwner {\n', '        if (memberId[targetMember] != 0) throw;\n', '\n', '        memberId[targetMember] = members.length;\n', '        members.push(Member({member:      targetMember,\n', '                             memberSince: now,\n', '                             name:        memberName}));\n', '\n', '        MembershipChanged(targetMember, true);\n', '    }\n', '\n', '    /**\n', '     * @dev Remove congress member\n', '     * @param targetMember Member account address\n', '     */\n', '    function removeMember(address targetMember) onlyOwner {\n', '        if (memberId[targetMember] == 0) throw;\n', '\n', '        uint256 targetId = memberId[targetMember];\n', '        uint256 lastId   = members.length - 1;\n', '\n', '        // Move last member to removed position\n', '        Member memory moved    = members[lastId];\n', '        members[targetId]      = moved; \n', '        memberId[moved.member] = targetId;\n', '\n', '        // Clean up\n', '        memberId[targetMember] = 0;\n', '        delete members[lastId];\n', '        --members.length;\n', '\n', '        MembershipChanged(targetMember, false);\n', '    }\n', '\n', '    /**\n', '     * @dev Change rules of voting\n', '     * @param minimumQuorumForProposals Minimal count of votes\n', '     * @param minutesForDebate Debate deadline in minutes\n', '     * @param marginOfVotesForMajority Majority margin value\n', '     */\n', '    function changeVotingRules(\n', '        uint256 minimumQuorumForProposals,\n', '        uint256 minutesForDebate,\n', '        int256  marginOfVotesForMajority\n', '    )\n', '        onlyOwner\n', '    {\n', '        minimumQuorum           = minimumQuorumForProposals;\n', '        debatingPeriodInMinutes = minutesForDebate;\n', '        majorityMargin          = marginOfVotesForMajority;\n', '\n', '        ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, majorityMargin);\n', '    }\n', '\n', '    /**\n', '     * @dev Create a new proposal\n', '     * @param beneficiary Beneficiary account address\n', '     * @param amount Transaction value in Wei \n', '     * @param jobDescription Job description string\n', '     * @param transactionBytecode Bytecode of transaction\n', '     */\n', '    function newProposal(\n', '        address beneficiary,\n', '        uint256 amount,\n', '        string  jobDescription,\n', '        bytes   transactionBytecode\n', '    )\n', '        onlyMembers\n', '        returns (uint256 id)\n', '    {\n', '        id               = proposals.length++;\n', '        Proposal p       = proposals[id];\n', '        p.recipient      = beneficiary;\n', '        p.amount         = amount;\n', '        p.description    = jobDescription;\n', '        p.proposalHash   = sha3(beneficiary, amount, transactionBytecode);\n', '        p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;\n', '        p.executed       = false;\n', '        p.proposalPassed = false;\n', '        p.numberOfVotes  = 0;\n', '        ProposalAdded(id, beneficiary, amount, jobDescription);\n', '    }\n', '\n', '    /**\n', '     * @dev Check if a proposal code matches\n', '     * @param id Proposal identifier\n', '     * @param beneficiary Beneficiary account address\n', '     * @param amount Transaction value in Wei \n', '     * @param transactionBytecode Bytecode of transaction\n', '     */\n', '    function checkProposalCode(\n', '        uint256 id,\n', '        address beneficiary,\n', '        uint256 amount,\n', '        bytes   transactionBytecode\n', '    )\n', '        constant\n', '        returns (bool codeChecksOut)\n', '    {\n', '        return proposals[id].proposalHash\n', '            == sha3(beneficiary, amount, transactionBytecode);\n', '    }\n', '\n', '    /**\n', '     * @dev Proposal voting\n', '     * @param id Proposal identifier\n', '     * @param supportsProposal Is proposal supported\n', '     * @param justificationText Member comment\n', '     */\n', '    function vote(\n', '        uint256 id,\n', '        bool    supportsProposal,\n', '        string  justificationText\n', '    )\n', '        onlyMembers\n', '        returns (uint256 vote)\n', '    {\n', '        Proposal p = proposals[id];             // Get the proposal\n', '        if (p.voted[msg.sender] == true) throw; // If has already voted, cancel\n', '        p.voted[msg.sender] = true;             // Set this voter as having voted\n', '        p.numberOfVotes++;                      // Increase the number of votes\n', '        if (supportsProposal) {                 // If they support the proposal\n', '            p.currentResult++;                  // Increase score\n', "        } else {                                // If they don't\n", '            p.currentResult--;                  // Decrease the score\n', '        }\n', '        // Create a log of this event\n', '        Voted(id,  supportsProposal, msg.sender, justificationText);\n', '    }\n', '\n', '    /**\n', '     * @dev Try to execute proposal\n', '     * @param id Proposal identifier\n', '     * @param transactionBytecode Transaction data\n', '     */\n', '    function executeProposal(\n', '        uint256 id,\n', '        bytes   transactionBytecode\n', '    )\n', '        onlyMembers\n', '    {\n', '        Proposal p = proposals[id];\n', '        /* Check if the proposal can be executed:\n', '           - Has the voting deadline arrived?\n', '           - Has it been already executed or is it being executed?\n', '           - Does the transaction code match the proposal?\n', '           - Has a minimum quorum?\n', '        */\n', '\n', '        if (now < p.votingDeadline\n', '            || p.executed\n', '            || p.proposalHash != sha3(p.recipient, p.amount, transactionBytecode)\n', '            || p.numberOfVotes < minimumQuorum)\n', '            throw;\n', '\n', '        /* execute result */\n', '        /* If difference between support and opposition is larger than margin */\n', '        if (p.currentResult > majorityMargin) {\n', '            // Avoid recursive calling\n', '\n', '            p.executed = true;\n', '            if (!p.recipient.call.value(p.amount)(transactionBytecode))\n', '                throw;\n', '\n', '            p.proposalPassed = true;\n', '        } else {\n', '            p.proposalPassed = false;\n', '        }\n', '        // Fire Events\n', '        ProposalTallied(id, p.numberOfVotes, p.proposalPassed);\n', '    }\n', '}\n', '\n', 'library CreatorCongress {\n', '    function create(uint256 minimumQuorumForProposals, uint256 minutesForDebate, int256 marginOfVotesForMajority, address congressLeader) returns (Congress)\n', '    { return new Congress(minimumQuorumForProposals, minutesForDebate, marginOfVotesForMajority, congressLeader); }\n', '\n', '    function version() constant returns (string)\n', '    { return "v0.6.3"; }\n', '\n', '    function abi() constant returns (string)\n', '    { return \'[{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"proposals","outputs":[{"name":"recipient","type":"address"},{"name":"amount","type":"uint256"},{"name":"description","type":"string"},{"name":"votingDeadline","type":"uint256"},{"name":"executed","type":"bool"},{"name":"proposalPassed","type":"bool"},{"name":"numberOfVotes","type":"uint256"},{"name":"currentResult","type":"int256"},{"name":"proposalHash","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"targetMember","type":"address"}],"name":"removeMember","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"}],"name":"setOwner","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"id","type":"uint256"},{"name":"transactionBytecode","type":"bytes"}],"name":"executeProposal","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"memberId","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"numProposals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"hammer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"members","outputs":[{"name":"member","type":"address"},{"name":"name","type":"string"},{"name":"memberSince","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"debatingPeriodInMinutes","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"minimumQuorum","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"destroy","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"},{"name":"_token","type":"address"},{"name":"_extraData","type":"bytes"}],"name":"receiveApproval","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"majorityMargin","outputs":[{"name":"","type":"int256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"beneficiary","type":"address"},{"name":"amount","type":"uint256"},{"name":"jobDescription","type":"string"},{"name":"transactionBytecode","type":"bytes"}],"name":"newProposal","outputs":[{"name":"id","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"minimumQuorumForProposals","type":"uint256"},{"name":"minutesForDebate","type":"uint256"},{"name":"marginOfVotesForMajority","type":"int256"}],"name":"changeVotingRules","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"targetMember","type":"address"},{"name":"memberName","type":"string"}],"name":"addMember","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hammer","type":"address"}],"name":"setHammer","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"id","type":"uint256"},{"name":"supportsProposal","type":"bool"},{"name":"justificationText","type":"string"}],"name":"vote","outputs":[{"name":"vote","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"id","type":"uint256"},{"name":"beneficiary","type":"address"},{"name":"amount","type":"uint256"},{"name":"transactionBytecode","type":"bytes"}],"name":"checkProposalCode","outputs":[{"name":"codeChecksOut","type":"bool"}],"payable":false,"type":"function"},{"inputs":[{"name":"minimumQuorumForProposals","type":"uint256"},{"name":"minutesForDebate","type":"uint256"},{"name":"marginOfVotesForMajority","type":"int256"},{"name":"congressLeader","type":"address"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"proposal","type":"uint256"},{"indexed":true,"name":"recipient","type":"address"},{"indexed":true,"name":"amount","type":"uint256"},{"indexed":false,"name":"description","type":"string"}],"name":"ProposalAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"proposal","type":"uint256"},{"indexed":true,"name":"position","type":"bool"},{"indexed":true,"name":"voter","type":"address"},{"indexed":false,"name":"justification","type":"string"}],"name":"Voted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"proposal","type":"uint256"},{"indexed":true,"name":"quorum","type":"uint256"},{"indexed":true,"name":"active","type":"bool"}],"name":"ProposalTallied","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"member","type":"address"},{"indexed":true,"name":"isMember","type":"bool"}],"name":"MembershipChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"minimumQuorum","type":"uint256"},{"indexed":true,"name":"debatingPeriodInMinutes","type":"uint256"},{"indexed":true,"name":"majorityMargin","type":"int256"}],"name":"ChangeOfRules","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"sender","type":"address"},{"indexed":true,"name":"amount","type":"uint256"}],"name":"ReceivedEther","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"value","type":"uint256"},{"indexed":true,"name":"token","type":"address"},{"indexed":false,"name":"extraData","type":"bytes"}],"name":"ReceivedTokens","type":"event"}]\'; }\n', '}\n', '\n', '/**\n', ' * @title Builder based contract\n', ' */\n', 'contract Builder is Object {\n', '    /**\n', '     * @dev this event emitted for every builded contract\n', '     */\n', '    event Builded(address indexed client, address indexed instance);\n', ' \n', '    /* Addresses builded contracts at sender */\n', '    mapping(address => address[]) public getContractsOf;\n', ' \n', '    /**\n', '     * @dev Get last address\n', '     * @return last address contract\n', '     */\n', '    function getLastContract() constant returns (address) {\n', '        var sender_contracts = getContractsOf[msg.sender];\n', '        return sender_contracts[sender_contracts.length - 1];\n', '    }\n', '\n', '    /* Building beneficiary */\n', '    address public beneficiary;\n', '\n', '    /**\n', '     * @dev Set beneficiary\n', '     * @param _beneficiary is address of beneficiary\n', '     */\n', '    function setBeneficiary(address _beneficiary) onlyOwner\n', '    { beneficiary = _beneficiary; }\n', '\n', '    /* Building cost  */\n', '    uint public buildingCostWei;\n', '\n', '    /**\n', '     * @dev Set building cost\n', '     * @param _buildingCostWei is cost\n', '     */\n', '    function setCost(uint _buildingCostWei) onlyOwner\n', '    { buildingCostWei = _buildingCostWei; }\n', '\n', '    /* Security check report */\n', '    string public securityCheckURI;\n', '\n', '    /**\n', '     * @dev Set security check report URI\n', '     * @param _uri is an URI to report\n', '     */\n', '    function setSecurityCheck(string _uri) onlyOwner\n', '    { securityCheckURI = _uri; }\n', '}\n', '\n', '//\n', '// AIRA Builder for Congress contract\n', '//\n', 'contract BuilderCongress is Builder {\n', '    /**\n', '     * @dev Run script creation contract\n', '     * @return address new contract\n', '     */\n', '    function create(uint256 minimumQuorumForProposals,\n', '                    uint256 minutesForDebate,\n', '                    int256 marginOfVotesForMajority,\n', '                    address congressLeader,\n', '                    address _client) payable returns (address) {\n', '        if (buildingCostWei > 0 && beneficiary != 0) {\n', '            // Too low value\n', '            if (msg.value < buildingCostWei) throw;\n', '            // Beneficiary send\n', '            if (!beneficiary.send(buildingCostWei)) throw;\n', '            // Refund\n', '            if (msg.value > buildingCostWei) {\n', '                if (!msg.sender.send(msg.value - buildingCostWei)) throw;\n', '            }\n', '        } else {\n', '            // Refund all\n', '            if (msg.value > 0) {\n', '                if (!msg.sender.send(msg.value)) throw;\n', '            }\n', '        }\n', '\n', '        if (_client == 0)\n', '            _client = msg.sender;\n', ' \n', '        if (congressLeader == 0)\n', '            congressLeader = _client;\n', '\n', '        var inst = CreatorCongress.create(minimumQuorumForProposals,\n', '                                          minutesForDebate,\n', '                                          marginOfVotesForMajority,\n', '                                          congressLeader);\n', '        inst.setOwner(_client);\n', '        inst.setHammer(_client);\n', '        getContractsOf[_client].push(inst);\n', '        Builded(_client, inst);\n', '        return inst;\n', '    }\n', '}']