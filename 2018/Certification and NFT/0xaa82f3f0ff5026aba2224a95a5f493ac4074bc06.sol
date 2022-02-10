['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '\n', '\t// Contract&#39;s owner.\n', '\taddress owner;\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire (msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\n', '\t// Constructor.\n', '\tfunction Ownable() public {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\t// Returns current contract&#39;s owner.\n', '\tfunction getOwner() public constant returns(address) {\n', '\t\treturn owner;\n', '\t}\n', '\n', '\t// Transfers contract&#39;s ownership.\n', '\tfunction transferOwnership(address newOwner) onlyOwner public {\n', '\t\trequire(newOwner != address(0));\n', '\t\towner = newOwner;\n', '\t}\n', '}\n', '\n', 'contract ICKBase {\n', '\n', '\tfunction ownerOf(uint256) public pure returns (address);\n', '}\n', '\n', 'contract IKittyKendoStorage {\n', '\n', '\tfunction createProposal(uint proposal, address proposalOwner) public;\n', '\tfunction createVoter(address account) public;\n', '\n', '\tfunction updateProposalOwner(uint proposal, address voter) public;\n', '\n', '\tfunction voterExists(address voter) public constant returns (bool);\n', '\tfunction proposalExists(uint proposal) public constant returns (bool);\n', '\n', '\tfunction proposalOwner(uint proposal) public constant returns (address);\n', '\tfunction proposalCreateTime(uint proposal) public constant returns (uint);\n', '\n', '\tfunction voterVotingTime(address voter) public constant returns (uint);\n', '\n', '\tfunction addProposalVote(uint proposal, address voter) public;\n', '\tfunction addVoterVote(address voter) public;\n', '\n', '\tfunction updateVoterTimes(address voter, uint time) public;\n', '\n', '\tfunction getProposalTTL() public constant returns (uint);\n', '\tfunction setProposalTTL(uint time) public;\n', '\n', '\tfunction getVotesPerProposal() public constant returns (uint);\n', '\tfunction setVotesPerProposal(uint votes) public;\n', '\n', '\tfunction getTotalProposalsCount() public constant returns(uint);\n', '\tfunction getTotalVotersCount() public constant returns(uint);\n', '\n', '\tfunction getProposalVotersCount(uint proposal) public constant returns(uint);\n', '\tfunction getProposalVotesCount(uint proposal) public constant returns(uint);\n', '\tfunction getProposalVoterVotesCount(uint proposal, address voter) public constant returns(uint);\n', '\n', '\tfunction getVoterProposalsCount(address voter) public constant returns(uint);\n', '\tfunction getVoterVotesCount(address voter) public constant returns(uint);\n', '\tfunction getVoterProposal(address voter, uint index) public constant returns(uint);\n', '}\n', '\n', 'contract KittyKendoCore is Ownable {\n', '\n', '\tIKittyKendoStorage kks;\n', '\taddress kksAddress;\n', '\n', '\t// Event is emitted when new votes have been recorded.\n', '\tevent VotesRecorded (\n', '\t\taddress indexed from,\n', '\t\tuint[] votes\n', '\t);\n', '\n', '\t// Event is emitted when new proposal has been added.\n', '\tevent ProposalAdded (\n', '\t\taddress indexed from,\n', '\t\tuint indexed proposal\n', '\t);\n', '\n', '\t// Registering fee.\n', '\tuint fee;\n', '\n', '\t// Constructor.\n', '\tfunction KittyKendoCore() public {\n', '\t\tfee = 0;\n', '\t\tkksAddress = address(0);\n', '\t}\n', '\t\n', '\t// Returns storage&#39;s address.\n', '\tfunction storageAddress() onlyOwner public constant returns(address) {\n', '\t\treturn kksAddress;\n', '\t}\n', '\n', '\t// Sets storage&#39;s address.\n', '\tfunction setStorageAddress(address addr) onlyOwner public {\n', '\t\tkksAddress = addr;\n', '\t\tkks = IKittyKendoStorage(kksAddress);\n', '\t}\n', '\n', '\t// Returns default register fee.\n', '\tfunction getFee() public constant returns(uint) {\n', '\t\treturn fee;\n', '\t}\n', '\n', '\t// Sets default register fee.\n', '\tfunction setFee(uint val) onlyOwner public {\n', '\t\tfee = val;\n', '\t}\n', '\n', '\t// Contract balance withdrawal.\n', '\tfunction withdraw(uint amount) onlyOwner public {\n', '\t\trequire(amount <= address(this).balance);\n', '\t\towner.transfer(amount);\n', '\t}\n', '\t\n', '\t// Returns contract&#39;s balance.\n', '\tfunction getBalance() onlyOwner public constant returns(uint) {\n', '\t    return address(this).balance;\n', '\t}\n', '\n', '\t// Registering proposal in replacement for provided votes.\n', '\tfunction registerProposal(uint proposal, uint[] votes) public payable {\n', '\n', '\t\t// Value must be at least equal to default fee.\n', '\t\trequire(msg.value >= fee);\n', '\n', '\t\trecordVotes(votes);\n', '\n', '\t\tif (proposal > 0) {\n', '\t\t\taddProposal(proposal);\n', '\t\t}\n', '\t}\n', '\n', '\t// Recording proposals votes.\n', '\tfunction recordVotes(uint[] votes) private {\n', '\n', '        require(kksAddress != address(0));\n', '\n', '\t\t// Checking if voter already exists, otherwise adding it.\n', '\t\tif (!kks.voterExists(msg.sender)) {\n', '\t\t\tkks.createVoter(msg.sender);\n', '\t\t}\n', '\n', '\t\t// Recording all passed votes from voter.\n', '\t\tfor (uint i = 0; i < votes.length; i++) {\n', '\t\t\t// Checking if proposal exists.\n', '\t\t\tif (kks.proposalExists(votes[i])) {\n', '\t\t\t\t// Proposal owner can&#39;t vote for own proposal.\n', '\t\t\t\trequire(kks.proposalOwner(votes[i]) != msg.sender);\n', '\n', '\t\t\t\t// Checking if proposal isn&#39;t expired yet.\n', '\t\t\t\tif (kks.proposalCreateTime(votes[i]) + kks.getProposalTTL() <= now) {\n', '\t\t\t\t\tcontinue;\n', '\t\t\t\t}\n', '\n', '\t\t\t\t// Voter can vote for each proposal only once.\n', '\t\t\t\trequire(kks.getProposalVoterVotesCount(votes[i], msg.sender) == uint(0));\n', '\n', '\t\t\t\t// Adding proposal&#39;s voter and updating total votes count per proposal.\n', '\t\t\t\tkks.addProposalVote(votes[i], msg.sender);\n', '\t\t\t}\n', '\n', '\t\t\t// Recording vote per voter.\n', '\t\t\tkks.addVoterVote(msg.sender);\n', '\t\t}\n', '\n', '\t\t// Updating voter&#39;s last voting time and updating create time for voter&#39;s proposals.\n', '\t\tkks.updateVoterTimes(msg.sender, now);\n', '\n', '\t\t// Emitting event.\n', '\t\tVotesRecorded(msg.sender, votes);\n', '\t}\n', '\n', '\t// Adding new voter&#39;s proposal.\n', '\tfunction addProposal(uint proposal) private {\n', '\n', '        require(kksAddress != address(0));\n', '\n', '\t\t// Only existing voters can add own proposals.\n', '\t\trequire(kks.voterExists(msg.sender));\n', '\n', '\t\t// Checking if voter has enough votes count to add own proposal.\n', '\t\trequire(kks.getVoterVotesCount(msg.sender) / kks.getVotesPerProposal() > kks.getVoterProposalsCount(msg.sender));\n', '\n', '\t\t// Prevent voter from adding own proposal&#39;s too often.\n', '\t\t//require(now - kks.voterVotingTime(msg.sender) > 1 minutes);\n', '\n', '\t\t// Checking if proposal(i.e. Crypto Kitty Token) belongs to sender.\n', '\t\trequire(getCKOwner(proposal) == msg.sender);\n', '\n', '\t\t// Checking if proposal already exists.\n', '\t\tif (!kks.proposalExists(proposal)) {\n', '\t\t\t// Adding new proposal.\n', '\t\t\tkks.createProposal(proposal, msg.sender);\n', '\t\t} else {\n', '\t\t\t// Updating proposal&#39;s owner.\n', '\t\t\tkks.updateProposalOwner(proposal, msg.sender);\n', '\t\t}\n', '\n', '\t\t// Emitting event.\n', '\t\tProposalAdded(msg.sender, proposal);\n', '\t}\n', '\n', '\t// Returns the CryptoKitty&#39;s owner address.\n', '\tfunction getCKOwner(uint proposal) private pure returns(address) {\n', '\t\tICKBase ckBase = ICKBase(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);\n', '\t\treturn ckBase.ownerOf(uint256(proposal));\n', '\t}\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '\n', "\t// Contract's owner.\n", '\taddress owner;\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire (msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\n', '\t// Constructor.\n', '\tfunction Ownable() public {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', "\t// Returns current contract's owner.\n", '\tfunction getOwner() public constant returns(address) {\n', '\t\treturn owner;\n', '\t}\n', '\n', "\t// Transfers contract's ownership.\n", '\tfunction transferOwnership(address newOwner) onlyOwner public {\n', '\t\trequire(newOwner != address(0));\n', '\t\towner = newOwner;\n', '\t}\n', '}\n', '\n', 'contract ICKBase {\n', '\n', '\tfunction ownerOf(uint256) public pure returns (address);\n', '}\n', '\n', 'contract IKittyKendoStorage {\n', '\n', '\tfunction createProposal(uint proposal, address proposalOwner) public;\n', '\tfunction createVoter(address account) public;\n', '\n', '\tfunction updateProposalOwner(uint proposal, address voter) public;\n', '\n', '\tfunction voterExists(address voter) public constant returns (bool);\n', '\tfunction proposalExists(uint proposal) public constant returns (bool);\n', '\n', '\tfunction proposalOwner(uint proposal) public constant returns (address);\n', '\tfunction proposalCreateTime(uint proposal) public constant returns (uint);\n', '\n', '\tfunction voterVotingTime(address voter) public constant returns (uint);\n', '\n', '\tfunction addProposalVote(uint proposal, address voter) public;\n', '\tfunction addVoterVote(address voter) public;\n', '\n', '\tfunction updateVoterTimes(address voter, uint time) public;\n', '\n', '\tfunction getProposalTTL() public constant returns (uint);\n', '\tfunction setProposalTTL(uint time) public;\n', '\n', '\tfunction getVotesPerProposal() public constant returns (uint);\n', '\tfunction setVotesPerProposal(uint votes) public;\n', '\n', '\tfunction getTotalProposalsCount() public constant returns(uint);\n', '\tfunction getTotalVotersCount() public constant returns(uint);\n', '\n', '\tfunction getProposalVotersCount(uint proposal) public constant returns(uint);\n', '\tfunction getProposalVotesCount(uint proposal) public constant returns(uint);\n', '\tfunction getProposalVoterVotesCount(uint proposal, address voter) public constant returns(uint);\n', '\n', '\tfunction getVoterProposalsCount(address voter) public constant returns(uint);\n', '\tfunction getVoterVotesCount(address voter) public constant returns(uint);\n', '\tfunction getVoterProposal(address voter, uint index) public constant returns(uint);\n', '}\n', '\n', 'contract KittyKendoCore is Ownable {\n', '\n', '\tIKittyKendoStorage kks;\n', '\taddress kksAddress;\n', '\n', '\t// Event is emitted when new votes have been recorded.\n', '\tevent VotesRecorded (\n', '\t\taddress indexed from,\n', '\t\tuint[] votes\n', '\t);\n', '\n', '\t// Event is emitted when new proposal has been added.\n', '\tevent ProposalAdded (\n', '\t\taddress indexed from,\n', '\t\tuint indexed proposal\n', '\t);\n', '\n', '\t// Registering fee.\n', '\tuint fee;\n', '\n', '\t// Constructor.\n', '\tfunction KittyKendoCore() public {\n', '\t\tfee = 0;\n', '\t\tkksAddress = address(0);\n', '\t}\n', '\t\n', "\t// Returns storage's address.\n", '\tfunction storageAddress() onlyOwner public constant returns(address) {\n', '\t\treturn kksAddress;\n', '\t}\n', '\n', "\t// Sets storage's address.\n", '\tfunction setStorageAddress(address addr) onlyOwner public {\n', '\t\tkksAddress = addr;\n', '\t\tkks = IKittyKendoStorage(kksAddress);\n', '\t}\n', '\n', '\t// Returns default register fee.\n', '\tfunction getFee() public constant returns(uint) {\n', '\t\treturn fee;\n', '\t}\n', '\n', '\t// Sets default register fee.\n', '\tfunction setFee(uint val) onlyOwner public {\n', '\t\tfee = val;\n', '\t}\n', '\n', '\t// Contract balance withdrawal.\n', '\tfunction withdraw(uint amount) onlyOwner public {\n', '\t\trequire(amount <= address(this).balance);\n', '\t\towner.transfer(amount);\n', '\t}\n', '\t\n', "\t// Returns contract's balance.\n", '\tfunction getBalance() onlyOwner public constant returns(uint) {\n', '\t    return address(this).balance;\n', '\t}\n', '\n', '\t// Registering proposal in replacement for provided votes.\n', '\tfunction registerProposal(uint proposal, uint[] votes) public payable {\n', '\n', '\t\t// Value must be at least equal to default fee.\n', '\t\trequire(msg.value >= fee);\n', '\n', '\t\trecordVotes(votes);\n', '\n', '\t\tif (proposal > 0) {\n', '\t\t\taddProposal(proposal);\n', '\t\t}\n', '\t}\n', '\n', '\t// Recording proposals votes.\n', '\tfunction recordVotes(uint[] votes) private {\n', '\n', '        require(kksAddress != address(0));\n', '\n', '\t\t// Checking if voter already exists, otherwise adding it.\n', '\t\tif (!kks.voterExists(msg.sender)) {\n', '\t\t\tkks.createVoter(msg.sender);\n', '\t\t}\n', '\n', '\t\t// Recording all passed votes from voter.\n', '\t\tfor (uint i = 0; i < votes.length; i++) {\n', '\t\t\t// Checking if proposal exists.\n', '\t\t\tif (kks.proposalExists(votes[i])) {\n', "\t\t\t\t// Proposal owner can't vote for own proposal.\n", '\t\t\t\trequire(kks.proposalOwner(votes[i]) != msg.sender);\n', '\n', "\t\t\t\t// Checking if proposal isn't expired yet.\n", '\t\t\t\tif (kks.proposalCreateTime(votes[i]) + kks.getProposalTTL() <= now) {\n', '\t\t\t\t\tcontinue;\n', '\t\t\t\t}\n', '\n', '\t\t\t\t// Voter can vote for each proposal only once.\n', '\t\t\t\trequire(kks.getProposalVoterVotesCount(votes[i], msg.sender) == uint(0));\n', '\n', "\t\t\t\t// Adding proposal's voter and updating total votes count per proposal.\n", '\t\t\t\tkks.addProposalVote(votes[i], msg.sender);\n', '\t\t\t}\n', '\n', '\t\t\t// Recording vote per voter.\n', '\t\t\tkks.addVoterVote(msg.sender);\n', '\t\t}\n', '\n', "\t\t// Updating voter's last voting time and updating create time for voter's proposals.\n", '\t\tkks.updateVoterTimes(msg.sender, now);\n', '\n', '\t\t// Emitting event.\n', '\t\tVotesRecorded(msg.sender, votes);\n', '\t}\n', '\n', "\t// Adding new voter's proposal.\n", '\tfunction addProposal(uint proposal) private {\n', '\n', '        require(kksAddress != address(0));\n', '\n', '\t\t// Only existing voters can add own proposals.\n', '\t\trequire(kks.voterExists(msg.sender));\n', '\n', '\t\t// Checking if voter has enough votes count to add own proposal.\n', '\t\trequire(kks.getVoterVotesCount(msg.sender) / kks.getVotesPerProposal() > kks.getVoterProposalsCount(msg.sender));\n', '\n', "\t\t// Prevent voter from adding own proposal's too often.\n", '\t\t//require(now - kks.voterVotingTime(msg.sender) > 1 minutes);\n', '\n', '\t\t// Checking if proposal(i.e. Crypto Kitty Token) belongs to sender.\n', '\t\trequire(getCKOwner(proposal) == msg.sender);\n', '\n', '\t\t// Checking if proposal already exists.\n', '\t\tif (!kks.proposalExists(proposal)) {\n', '\t\t\t// Adding new proposal.\n', '\t\t\tkks.createProposal(proposal, msg.sender);\n', '\t\t} else {\n', "\t\t\t// Updating proposal's owner.\n", '\t\t\tkks.updateProposalOwner(proposal, msg.sender);\n', '\t\t}\n', '\n', '\t\t// Emitting event.\n', '\t\tProposalAdded(msg.sender, proposal);\n', '\t}\n', '\n', "\t// Returns the CryptoKitty's owner address.\n", '\tfunction getCKOwner(uint proposal) private pure returns(address) {\n', '\t\tICKBase ckBase = ICKBase(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);\n', '\t\treturn ckBase.ownerOf(uint256(proposal));\n', '\t}\n', '\n', '}']