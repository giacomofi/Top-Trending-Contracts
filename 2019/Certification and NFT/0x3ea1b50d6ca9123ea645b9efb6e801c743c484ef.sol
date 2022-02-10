['pragma solidity ^0.5.0;\n', '\n', 'contract Election {\n', '    \n', '    address owner;\n', '    \n', '    struct Candidate {\n', '        uint id;\n', '        string name;\n', '        uint voteCount;\n', '    }\n', '\n', '    event votedEvent (\n', '        uint indexed candidateID\n', '    );\n', '\n', '    uint public candidatesCount;\n', '    mapping(uint => Candidate) public candidates;\n', '    mapping(address => bool) public voters;\n', '\n', '\n', '    constructor() public payable\n', '\n', '    {\n', '        owner = msg.sender;\n', '        addCandidate("Candidate 1");\n', '        addCandidate("Candidate 2");\n', '    }\n', '    \n', '    function kill() public {\n', '        if (msg.sender == owner) selfdestruct(msg.sender);\n', '    }\n', '    \n', '\n', '    function addCandidate(string memory name) private\n', '    {\n', '        ++candidatesCount;\n', '        candidates[candidatesCount] = Candidate(candidatesCount, name, 0);\n', '    }\n', '\n', '    function vote(uint candidateID) public\n', '    {\n', '        require(!voters[msg.sender]);\n', '        require(candidateID > 0 && candidateID <= candidatesCount);\n', '\n', '        voters[msg.sender] = true;\n', '        candidates[candidateID].voteCount++;\n', '        emit votedEvent(candidateID);\n', '    }\n', '}']