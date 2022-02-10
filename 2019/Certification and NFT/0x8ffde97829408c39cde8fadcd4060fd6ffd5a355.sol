['pragma solidity ^0.5.2;\n', '// This is basically a shared account in which any transactions done must be signed by multiple parties. Hence, multi-signature wallet.\n', 'contract SimpleMultiSigWallet {\n', '    struct Proposal {\n', '        uint256 amount;\n', '        address payable to;\n', '        uint8 votes;\n', '        bytes data;\n', '        mapping (address => bool) voted;\n', '    }\n', '    \n', '    mapping (bytes32 => Proposal) internal proposals;\n', '    mapping (address => uint8) public voteCount;\n', '    \n', '    uint8 constant public maximumVotes = 2; \n', '    constructor() public{\n', '        voteCount[0x8c070C3c66F62E34bAe561951450f15f3256f67c] = 1; // ARitz Cracker\n', '        voteCount[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 1; // Sumpunk\n', '    }\n', '    \n', '    function proposeTransaction(address payable to, uint256 amount, bytes memory data) public{\n', '        require(voteCount[msg.sender] != 0, "You cannot vote");\n', '        bytes32 hash = keccak256(abi.encodePacked(to, amount, data));\n', '        require(!proposals[hash].voted[msg.sender], "Already voted");\n', '        if (proposals[hash].votes == 0){\n', '            proposals[hash].amount = amount;\n', '            proposals[hash].to = to;\n', '            proposals[hash].data = data;\n', '            proposals[hash].votes = voteCount[msg.sender];\n', '            proposals[hash].voted[msg.sender] = true;\n', '        }else{\n', '            proposals[hash].votes += voteCount[msg.sender];\n', '            proposals[hash].voted[msg.sender] = true;\n', '            if (proposals[hash].votes >= maximumVotes){\n', '                if (proposals[hash].data.length == 0){\n', '                    proposals[hash].to.transfer(proposals[hash].amount);\n', '                }else{\n', '\t\t\t\t\tbool success;\n', '\t\t\t\t\tbytes memory returnData;\n', '\t\t\t\t\t(success, returnData) = proposals[hash].to.call.value(proposals[hash].amount)(proposals[hash].data);\n', '\t\t\t\t\trequire(success);\n', '                }\n', '                delete proposals[hash];\n', '            }\n', '        }\n', '    }\n', '    \n', '    // Yes we will take your free ERC223 tokens, thank you very much\n', '    function tokenFallback(address from, uint value, bytes memory data) public{\n', '        \n', '    }\n', '    \n', '    function() external payable{\n', '        // Accept free ETH\n', '    }\n', '}']
['pragma solidity ^0.5.2;\n', '// This is basically a shared account in which any transactions done must be signed by multiple parties. Hence, multi-signature wallet.\n', 'contract SimpleMultiSigWallet {\n', '    struct Proposal {\n', '        uint256 amount;\n', '        address payable to;\n', '        uint8 votes;\n', '        bytes data;\n', '        mapping (address => bool) voted;\n', '    }\n', '    \n', '    mapping (bytes32 => Proposal) internal proposals;\n', '    mapping (address => uint8) public voteCount;\n', '    \n', '    uint8 constant public maximumVotes = 2; \n', '    constructor() public{\n', '        voteCount[0x8c070C3c66F62E34bAe561951450f15f3256f67c] = 1; // ARitz Cracker\n', '        voteCount[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 1; // Sumpunk\n', '    }\n', '    \n', '    function proposeTransaction(address payable to, uint256 amount, bytes memory data) public{\n', '        require(voteCount[msg.sender] != 0, "You cannot vote");\n', '        bytes32 hash = keccak256(abi.encodePacked(to, amount, data));\n', '        require(!proposals[hash].voted[msg.sender], "Already voted");\n', '        if (proposals[hash].votes == 0){\n', '            proposals[hash].amount = amount;\n', '            proposals[hash].to = to;\n', '            proposals[hash].data = data;\n', '            proposals[hash].votes = voteCount[msg.sender];\n', '            proposals[hash].voted[msg.sender] = true;\n', '        }else{\n', '            proposals[hash].votes += voteCount[msg.sender];\n', '            proposals[hash].voted[msg.sender] = true;\n', '            if (proposals[hash].votes >= maximumVotes){\n', '                if (proposals[hash].data.length == 0){\n', '                    proposals[hash].to.transfer(proposals[hash].amount);\n', '                }else{\n', '\t\t\t\t\tbool success;\n', '\t\t\t\t\tbytes memory returnData;\n', '\t\t\t\t\t(success, returnData) = proposals[hash].to.call.value(proposals[hash].amount)(proposals[hash].data);\n', '\t\t\t\t\trequire(success);\n', '                }\n', '                delete proposals[hash];\n', '            }\n', '        }\n', '    }\n', '    \n', '    // Yes we will take your free ERC223 tokens, thank you very much\n', '    function tokenFallback(address from, uint value, bytes memory data) public{\n', '        \n', '    }\n', '    \n', '    function() external payable{\n', '        // Accept free ETH\n', '    }\n', '}']
