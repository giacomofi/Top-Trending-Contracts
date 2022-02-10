['pragma solidity ^0.4.2;\n', '/* The token is used as a voting shares */\n', 'contract token { mapping (address => uint256) public balanceOf;  }\n', '\n', '\n', "/* define 'owned' */\n", 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract tokenRecipient { \n', '    event receivedEther(address sender, uint amount);\n', '    event receivedTokens(address _from, uint256 _value, address _token, bytes _extraData);\n', '\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData){\n', '        Token t = Token(_token);\n', '        if (!t.transferFrom(_from, this, _value)) throw;\n', '        receivedTokens(_from, _value, _token, _extraData);\n', '    }\n', '\n', '    function () payable {\n', '        receivedEther(msg.sender, msg.value);\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', '/* The democracy contract itself */\n', 'contract Association is owned, tokenRecipient {\n', '\n', '    /* Contract Variables and events */\n', '    uint public minimumQuorum;\n', '    uint public debatingPeriodInMinutes;\n', '    Proposal[] public proposals;\n', '    uint public numProposals;\n', '    token public sharesTokenAddress;\n', '\n', '    event ProposalAdded(uint proposalID, address recipient, uint amount, string description);\n', '    event Voted(uint proposalID, bool position, address voter);\n', '    event ProposalTallied(uint proposalID, uint result, uint quorum, bool active);\n', '    event ChangeOfRules(uint minimumQuorum, uint debatingPeriodInMinutes, address sharesTokenAddress);\n', '\n', '    struct Proposal {\n', '        address recipient;\n', '        uint amount;\n', '        string description;\n', '        uint votingDeadline;\n', '        bool executed;\n', '        bool proposalPassed;\n', '        uint numberOfVotes;\n', '        bytes32 proposalHash;\n', '        Vote[] votes;\n', '        mapping (address => bool) voted;\n', '    }\n', '\n', '    struct Vote {\n', '        bool inSupport;\n', '        address voter;\n', '    }\n', '\n', '    /* modifier that allows only shareholders to vote and create new proposals */\n', '    modifier onlyShareholders {\n', '        if (sharesTokenAddress.balanceOf(msg.sender) == 0) throw;\n', '        _;\n', '    }\n', '\n', '    /* First time setup */\n', '    function Association(token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) payable {\n', '        changeVotingRules(sharesAddress, minimumSharesToPassAVote, minutesForDebate);\n', '    }\n', '\n', '    /*change rules*/\n', '    function changeVotingRules(token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) onlyOwner {\n', '        sharesTokenAddress = token(sharesAddress);\n', '        if (minimumSharesToPassAVote == 0 ) minimumSharesToPassAVote = 1;\n', '        minimumQuorum = minimumSharesToPassAVote;\n', '        debatingPeriodInMinutes = minutesForDebate;\n', '        ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, sharesTokenAddress);\n', '    }\n', '\n', '    /* Function to create a new proposal */\n', '    function newProposal(\n', '        address beneficiary,\n', '        uint etherAmount,\n', '        string JobDescription,\n', '        bytes transactionBytecode\n', '    )\n', '        onlyShareholders\n', '        returns (uint proposalID)\n', '    {\n', '        proposalID = proposals.length++;\n', '        Proposal p = proposals[proposalID];\n', '        p.recipient = beneficiary;\n', '        p.amount = etherAmount;\n', '        p.description = JobDescription;\n', '        p.proposalHash = sha3(beneficiary, etherAmount, transactionBytecode);\n', '        p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;\n', '        p.executed = false;\n', '        p.proposalPassed = false;\n', '        p.numberOfVotes = 0;\n', '        ProposalAdded(proposalID, beneficiary, etherAmount, JobDescription);\n', '        numProposals = proposalID+1;\n', '\n', '        return proposalID;\n', '    }\n', '\n', '    /* function to check if a proposal code matches */\n', '    function checkProposalCode(\n', '        uint proposalNumber,\n', '        address beneficiary,\n', '        uint etherAmount,\n', '        bytes transactionBytecode\n', '    )\n', '        constant\n', '        returns (bool codeChecksOut)\n', '    {\n', '        Proposal p = proposals[proposalNumber];\n', '        return p.proposalHash == sha3(beneficiary, etherAmount, transactionBytecode);\n', '    }\n', '\n', '    /* */\n', '    function vote(uint proposalNumber, bool supportsProposal)\n', '        onlyShareholders\n', '        returns (uint voteID)\n', '    {\n', '        Proposal p = proposals[proposalNumber];\n', '        if (p.voted[msg.sender] == true) throw;\n', '\n', '        voteID = p.votes.length++;\n', '        p.votes[voteID] = Vote({inSupport: supportsProposal, voter: msg.sender});\n', '        p.voted[msg.sender] = true;\n', '        p.numberOfVotes = voteID +1;\n', '        Voted(proposalNumber,  supportsProposal, msg.sender); \n', '        return voteID;\n', '    }\n', '\n', '    function executeProposal(uint proposalNumber, bytes transactionBytecode) {\n', '        Proposal p = proposals[proposalNumber];\n', '        /* Check if the proposal can be executed */\n', '        if (now < p.votingDeadline  /* has the voting deadline arrived? */\n', '            ||  p.executed        /* has it been already executed? */\n', '            ||  p.proposalHash != sha3(p.recipient, p.amount, transactionBytecode)) /* Does the transaction code match the proposal? */\n', '            throw;\n', '\n', '        /* tally the votes */\n', '        uint quorum = 0;\n', '        uint yea = 0;\n', '        uint nay = 0;\n', '\n', '        for (uint i = 0; i <  p.votes.length; ++i) {\n', '            Vote v = p.votes[i];\n', '            uint voteWeight = sharesTokenAddress.balanceOf(v.voter);\n', '            quorum += voteWeight;\n', '            if (v.inSupport) {\n', '                yea += voteWeight;\n', '            } else {\n', '                nay += voteWeight;\n', '            }\n', '        }\n', '\n', '        /* execute result */\n', '        if (quorum <= minimumQuorum) {\n', '            /* Not enough significant voters */\n', '            throw;\n', '        } else if (yea > nay ) {\n', '            /* has quorum and was approved */\n', '            p.executed = true;\n', '            if (!p.recipient.call.value(p.amount * 1 ether)(transactionBytecode)) {\n', '                throw;\n', '            }\n', '            p.proposalPassed = true;\n', '        } else {\n', '            p.proposalPassed = false;\n', '        }\n', '        // Fire Events\n', '        ProposalTallied(proposalNumber, yea - nay, quorum, p.proposalPassed);\n', '    }\n', '}']