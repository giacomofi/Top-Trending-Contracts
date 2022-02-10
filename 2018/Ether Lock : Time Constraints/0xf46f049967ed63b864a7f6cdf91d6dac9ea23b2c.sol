['pragma solidity ^0.4.24;\n', '\n', 'contract WhaleKiller {\n', '    address WhaleAddr;\n', '    uint constant interest = 5;\n', '    uint constant whalefee = 1;\n', '    uint constant maxRoi = 150;\n', '    uint256 amount = 0;\n', '    mapping (address => uint256) invested;\n', '    mapping (address => uint256) timeInvest;\n', '    mapping (address => uint256) rewards;\n', '\n', '    constructor() public {\n', '        WhaleAddr = msg.sender;\n', '    }\n', '    function () external payable {\n', '        address sender = msg.sender;\n', '        \n', '        if (invested[sender] != 0) {\n', '            amount = invested[sender] * interest / 100 * (now - timeInvest[sender]) / 1 days;\n', '            if (msg.value == 0) {\n', '                if (amount >= address(this).balance) {\n', '                    amount = (address(this).balance);\n', '                }\n', '                if ((rewards[sender] + amount) > invested[sender] * maxRoi / 100) {\n', '                    amount = invested[sender] * maxRoi / 100 - rewards[sender];\n', '                    invested[sender] = 0;\n', '                    rewards[sender] = 0;\n', '                    sender.transfer(amount);\n', '                    return;\n', '                } else {\n', '                    sender.transfer(amount);\n', '                    rewards[sender] += amount;\n', '                    amount = 0;\n', '                }\n', '            }\n', '        }\n', '        timeInvest[sender] = now;\n', '        invested[sender] += (msg.value + amount);\n', '        \n', '        if (msg.value != 0) {\n', '            WhaleAddr.transfer(msg.value * whalefee / 100);\n', '            if (invested[sender] > invested[WhaleAddr]) {\n', '                WhaleAddr = sender;\n', '            }  \n', '        }\n', '    }\n', '    function showDeposit(address _dep) public view returns(uint256) {\n', '        return (invested[_dep]);\n', '    }\n', '    function showRewards(address _rew) public view returns(uint256) {\n', '        return (rewards[_rew]);\n', '    }\n', '    function showUnpaidInterest(address _inter) public view returns(uint256) {\n', '        return (invested[_inter] * interest / 100 * (now - timeInvest[_inter]) / 1 days);\n', '    }\n', '    function showWhaleAddr() public view returns(address) {\n', '        return WhaleAddr;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract WhaleKiller {\n', '    address WhaleAddr;\n', '    uint constant interest = 5;\n', '    uint constant whalefee = 1;\n', '    uint constant maxRoi = 150;\n', '    uint256 amount = 0;\n', '    mapping (address => uint256) invested;\n', '    mapping (address => uint256) timeInvest;\n', '    mapping (address => uint256) rewards;\n', '\n', '    constructor() public {\n', '        WhaleAddr = msg.sender;\n', '    }\n', '    function () external payable {\n', '        address sender = msg.sender;\n', '        \n', '        if (invested[sender] != 0) {\n', '            amount = invested[sender] * interest / 100 * (now - timeInvest[sender]) / 1 days;\n', '            if (msg.value == 0) {\n', '                if (amount >= address(this).balance) {\n', '                    amount = (address(this).balance);\n', '                }\n', '                if ((rewards[sender] + amount) > invested[sender] * maxRoi / 100) {\n', '                    amount = invested[sender] * maxRoi / 100 - rewards[sender];\n', '                    invested[sender] = 0;\n', '                    rewards[sender] = 0;\n', '                    sender.transfer(amount);\n', '                    return;\n', '                } else {\n', '                    sender.transfer(amount);\n', '                    rewards[sender] += amount;\n', '                    amount = 0;\n', '                }\n', '            }\n', '        }\n', '        timeInvest[sender] = now;\n', '        invested[sender] += (msg.value + amount);\n', '        \n', '        if (msg.value != 0) {\n', '            WhaleAddr.transfer(msg.value * whalefee / 100);\n', '            if (invested[sender] > invested[WhaleAddr]) {\n', '                WhaleAddr = sender;\n', '            }  \n', '        }\n', '    }\n', '    function showDeposit(address _dep) public view returns(uint256) {\n', '        return (invested[_dep]);\n', '    }\n', '    function showRewards(address _rew) public view returns(uint256) {\n', '        return (rewards[_rew]);\n', '    }\n', '    function showUnpaidInterest(address _inter) public view returns(uint256) {\n', '        return (invested[_inter] * interest / 100 * (now - timeInvest[_inter]) / 1 days);\n', '    }\n', '    function showWhaleAddr() public view returns(address) {\n', '        return WhaleAddr;\n', '    }\n', '}']
