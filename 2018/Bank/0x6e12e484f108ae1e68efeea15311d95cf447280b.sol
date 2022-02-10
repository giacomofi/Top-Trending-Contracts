['pragma solidity 0.4.21;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract HUNDREDTIMES {\n', '\n', '        uint private multiplier;\n', '        uint private payoutOrder = 0;\n', '\n', '        address private owner;\n', '\n', '        function HUNDREDTIMES(uint multiplierPercent) public {\n', '            owner = msg.sender;\n', '            multiplier = multiplierPercent;\n', '        }\n', '\n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '\n', '        modifier onlyPositiveSend {\n', '            require(msg.value > 0);\n', '            _;\n', '        }\n', '        struct Participant {\n', '            address etherAddress;\n', '            uint payout;\n', '        }\n', '\n', '        Participant[] private participants;\n', '\n', '\n', '        function() public payable onlyPositiveSend {\n', '            participants.push(Participant(msg.sender, (msg.value * multiplier) / 100));\n', '            uint balance = msg.value;\n', '            while (balance > 0) {\n', '                uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;\n', '                participants[payoutOrder].payout -= payoutToSend;\n', '                balance -= payoutToSend;\n', '                participants[payoutOrder].etherAddress.transfer(payoutToSend);\n', '                if(balance > 0){\n', '                    payoutOrder += 1;\n', '                }\n', '            }\n', '        }\n', '\n', '\n', '        function currentMultiplier() view public returns(uint) {\n', '            return multiplier;\n', '        }\n', '\n', '        function totalParticipants() view public returns(uint count) {\n', '                count = participants.length;\n', '        }\n', '\n', '        function numberOfParticipantsWaitingForPayout() view public returns(uint ) {\n', '                return participants.length - payoutOrder;\n', '        }\n', '\n', '        function participantDetails(uint orderInPyramid) view public returns(address Address, uint Payout) {\n', '                if (orderInPyramid <= participants.length) {\n', '                        Address = participants[orderInPyramid].etherAddress;\n', '                        Payout = participants[orderInPyramid].payout;\n', '                }\n', '        }\n', '        \n', '        function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '            return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '        }\n', '}']
['pragma solidity 0.4.21;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract HUNDREDTIMES {\n', '\n', '        uint private multiplier;\n', '        uint private payoutOrder = 0;\n', '\n', '        address private owner;\n', '\n', '        function HUNDREDTIMES(uint multiplierPercent) public {\n', '            owner = msg.sender;\n', '            multiplier = multiplierPercent;\n', '        }\n', '\n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '\n', '        modifier onlyPositiveSend {\n', '            require(msg.value > 0);\n', '            _;\n', '        }\n', '        struct Participant {\n', '            address etherAddress;\n', '            uint payout;\n', '        }\n', '\n', '        Participant[] private participants;\n', '\n', '\n', '        function() public payable onlyPositiveSend {\n', '            participants.push(Participant(msg.sender, (msg.value * multiplier) / 100));\n', '            uint balance = msg.value;\n', '            while (balance > 0) {\n', '                uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;\n', '                participants[payoutOrder].payout -= payoutToSend;\n', '                balance -= payoutToSend;\n', '                participants[payoutOrder].etherAddress.transfer(payoutToSend);\n', '                if(balance > 0){\n', '                    payoutOrder += 1;\n', '                }\n', '            }\n', '        }\n', '\n', '\n', '        function currentMultiplier() view public returns(uint) {\n', '            return multiplier;\n', '        }\n', '\n', '        function totalParticipants() view public returns(uint count) {\n', '                count = participants.length;\n', '        }\n', '\n', '        function numberOfParticipantsWaitingForPayout() view public returns(uint ) {\n', '                return participants.length - payoutOrder;\n', '        }\n', '\n', '        function participantDetails(uint orderInPyramid) view public returns(address Address, uint Payout) {\n', '                if (orderInPyramid <= participants.length) {\n', '                        Address = participants[orderInPyramid].etherAddress;\n', '                        Payout = participants[orderInPyramid].payout;\n', '                }\n', '        }\n', '        \n', '        function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '            return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '        }\n', '}']
