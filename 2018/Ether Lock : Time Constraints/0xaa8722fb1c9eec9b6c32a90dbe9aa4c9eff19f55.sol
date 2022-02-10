['pragma solidity ^0.4.21;\n', '\n', '\n', 'contract OrganicumOrders {\n', '    struct order {\n', '    uint256 balance;\n', '    uint256 tokens;\n', '    }\n', '\n', '    mapping (address => order) public orders;\n', '    address[] public holders;\n', '\n', '    uint256 public supplyTokens;\n', '    uint256 public supplyTokensSaved;\n', '    uint256 public tokenDecimal = 18;\n', '\n', '    uint256 minAmount = 1000; // minAmount / 100 = 10 $\n', '    uint256 softCap = 5000000; // softCap / 100 = 50 000 $\n', '    uint256 supplyInvestmen = 0;\n', '\n', '    uint16 fee = 500; // fee / 10000 = 0.05 = 5%\n', '\n', '    uint256 public etherCost = 60000; // etherCost / 100 = 600 $\n', '\n', '    address public owner;\n', '\n', '    uint256 public startDate = 1521849600; // 24.03.2018\n', '    uint256 public firstPeriod = 1522540800; // 01.04.2018\n', '    uint256 public secondPeriod = 1525132800; // 01.05.2018\n', '    uint256 public thirdPeriod = 1527811200; // 01.06.2018\n', '    uint256 public endDate = 1530403200; // 01.07.2018\n', '\n', '    function OrganicumOrders()\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier isOwner()\n', '    {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address new_owner) isOwner\n', '    {\n', '        assert(new_owner != address(0x0));\n', '        assert(new_owner != address(this));\n', '        owner = new_owner;\n', '    }\n', '\n', '    function changeEtherCost(uint256 new_cost) isOwner external\n', '    {\n', '        assert(new_cost > 0);\n', '        etherCost = new_cost*100;\n', '    }\n', '\n', '    function getPrice() constant returns(uint256)\n', '    {\n', '        if(now < firstPeriod)\n', '        {\n', '            return 95; // 0.95 $\n', '        }\n', '        else if(now < secondPeriod)\n', '        {\n', '            return 100; // 1.00 $\n', '        }\n', '        else if(now < thirdPeriod)\n', '        {\n', '            return 110; // 1.10 $\n', '        }\n', '        else\n', '        {\n', '            return 120; // 1.20 $\n', '        }\n', '    }\n', '\n', '    function () payable\n', '    {\n', '        assert(now >= startDate && now < endDate);\n', '        assert((msg.value * etherCost)/10**18 >= minAmount);\n', '\n', '        if(orders[msg.sender].balance == 0 && orders[msg.sender].tokens == 0)\n', '        {\n', '            holders.push(msg.sender);\n', '        }\n', '\n', '        uint256 countTokens = (msg.value * etherCost) / getPrice();\n', '        orders[msg.sender].balance += msg.value;\n', '        orders[msg.sender].tokens += countTokens;\n', '\n', '        supplyTokens += countTokens;\n', '        supplyTokensSaved += countTokens;\n', '        supplyInvestmen += msg.value;\n', '    }\n', '\n', '    function orderFor(address to) payable\n', '    {\n', '        assert(now >= startDate && now < endDate);\n', '        assert((msg.value * etherCost)/10**18 >= minAmount);\n', '\n', '        if(orders[to].balance == 0 && orders[to].tokens == 0)\n', '        {\n', '            holders.push(to);\n', '            if (to.balance == 0)\n', '            {\n', '                to.transfer(0.001 ether);\n', '            }\n', '        }\n', '\n', '        uint256 countTokens = ((msg.value - 0.001 ether) * etherCost) / getPrice();\n', '        orders[to].balance += msg.value;\n', '        orders[to].tokens += countTokens;\n', '\n', '        supplyTokens += countTokens;\n', '        supplyTokensSaved += countTokens;\n', '        supplyInvestmen += msg.value;\n', '    }\n', '\n', '    mapping (address => bool) public voter;\n', '    uint256 public sumVote = 0;\n', '    uint256 public durationVoting = 24 hours;\n', '\n', '    function vote()\n', '    {\n', '        assert(!voter[msg.sender]);\n', '        assert(now >= endDate && now < endDate + durationVoting);\n', '        assert((supplyInvestmen * etherCost)/10**18 >= softCap);\n', '        assert(orders[msg.sender].tokens > 0);\n', '\n', '        voter[msg.sender] = true;\n', '        sumVote += orders[msg.sender].tokens;\n', '    }\n', '\n', '    function refund(address holder)\n', '    {\n', '        assert(orders[holder].balance > 0);\n', '\n', '        uint256 etherToSend = 0;\n', '        if ((supplyInvestmen * etherCost)/10**18 >= softCap)\n', '        {\n', '            assert(sumVote > supplyTokensSaved / 2); // > 50%\n', '            etherToSend = orders[holder].balance * 95 / 100;\n', '        }\n', '        else\n', '        {\n', '            etherToSend = orders[holder].balance;\n', '        }\n', '        assert(etherToSend > 0);\n', '\n', '        if (etherToSend > this.balance) etherToSend = this.balance;\n', '\n', '        holder.transfer(etherToSend);\n', '\n', '        supplyTokens -= orders[holder].tokens;\n', '        orders[holder].balance = 0;\n', '        orders[holder].tokens = 0;\n', '    }\n', '\n', '    function takeInvest() isOwner\n', '    {\n', '        assert(now >= endDate + durationVoting);\n', '        assert(this.balance > 0);\n', '\n', '        if(sumVote > supplyTokensSaved / 2)\n', '        {\n', '            assert(supplyTokens == 0);\n', '        }\n', '\n', '        owner.transfer(this.balance);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', 'contract OrganicumOrders {\n', '    struct order {\n', '    uint256 balance;\n', '    uint256 tokens;\n', '    }\n', '\n', '    mapping (address => order) public orders;\n', '    address[] public holders;\n', '\n', '    uint256 public supplyTokens;\n', '    uint256 public supplyTokensSaved;\n', '    uint256 public tokenDecimal = 18;\n', '\n', '    uint256 minAmount = 1000; // minAmount / 100 = 10 $\n', '    uint256 softCap = 5000000; // softCap / 100 = 50 000 $\n', '    uint256 supplyInvestmen = 0;\n', '\n', '    uint16 fee = 500; // fee / 10000 = 0.05 = 5%\n', '\n', '    uint256 public etherCost = 60000; // etherCost / 100 = 600 $\n', '\n', '    address public owner;\n', '\n', '    uint256 public startDate = 1521849600; // 24.03.2018\n', '    uint256 public firstPeriod = 1522540800; // 01.04.2018\n', '    uint256 public secondPeriod = 1525132800; // 01.05.2018\n', '    uint256 public thirdPeriod = 1527811200; // 01.06.2018\n', '    uint256 public endDate = 1530403200; // 01.07.2018\n', '\n', '    function OrganicumOrders()\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier isOwner()\n', '    {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address new_owner) isOwner\n', '    {\n', '        assert(new_owner != address(0x0));\n', '        assert(new_owner != address(this));\n', '        owner = new_owner;\n', '    }\n', '\n', '    function changeEtherCost(uint256 new_cost) isOwner external\n', '    {\n', '        assert(new_cost > 0);\n', '        etherCost = new_cost*100;\n', '    }\n', '\n', '    function getPrice() constant returns(uint256)\n', '    {\n', '        if(now < firstPeriod)\n', '        {\n', '            return 95; // 0.95 $\n', '        }\n', '        else if(now < secondPeriod)\n', '        {\n', '            return 100; // 1.00 $\n', '        }\n', '        else if(now < thirdPeriod)\n', '        {\n', '            return 110; // 1.10 $\n', '        }\n', '        else\n', '        {\n', '            return 120; // 1.20 $\n', '        }\n', '    }\n', '\n', '    function () payable\n', '    {\n', '        assert(now >= startDate && now < endDate);\n', '        assert((msg.value * etherCost)/10**18 >= minAmount);\n', '\n', '        if(orders[msg.sender].balance == 0 && orders[msg.sender].tokens == 0)\n', '        {\n', '            holders.push(msg.sender);\n', '        }\n', '\n', '        uint256 countTokens = (msg.value * etherCost) / getPrice();\n', '        orders[msg.sender].balance += msg.value;\n', '        orders[msg.sender].tokens += countTokens;\n', '\n', '        supplyTokens += countTokens;\n', '        supplyTokensSaved += countTokens;\n', '        supplyInvestmen += msg.value;\n', '    }\n', '\n', '    function orderFor(address to) payable\n', '    {\n', '        assert(now >= startDate && now < endDate);\n', '        assert((msg.value * etherCost)/10**18 >= minAmount);\n', '\n', '        if(orders[to].balance == 0 && orders[to].tokens == 0)\n', '        {\n', '            holders.push(to);\n', '            if (to.balance == 0)\n', '            {\n', '                to.transfer(0.001 ether);\n', '            }\n', '        }\n', '\n', '        uint256 countTokens = ((msg.value - 0.001 ether) * etherCost) / getPrice();\n', '        orders[to].balance += msg.value;\n', '        orders[to].tokens += countTokens;\n', '\n', '        supplyTokens += countTokens;\n', '        supplyTokensSaved += countTokens;\n', '        supplyInvestmen += msg.value;\n', '    }\n', '\n', '    mapping (address => bool) public voter;\n', '    uint256 public sumVote = 0;\n', '    uint256 public durationVoting = 24 hours;\n', '\n', '    function vote()\n', '    {\n', '        assert(!voter[msg.sender]);\n', '        assert(now >= endDate && now < endDate + durationVoting);\n', '        assert((supplyInvestmen * etherCost)/10**18 >= softCap);\n', '        assert(orders[msg.sender].tokens > 0);\n', '\n', '        voter[msg.sender] = true;\n', '        sumVote += orders[msg.sender].tokens;\n', '    }\n', '\n', '    function refund(address holder)\n', '    {\n', '        assert(orders[holder].balance > 0);\n', '\n', '        uint256 etherToSend = 0;\n', '        if ((supplyInvestmen * etherCost)/10**18 >= softCap)\n', '        {\n', '            assert(sumVote > supplyTokensSaved / 2); // > 50%\n', '            etherToSend = orders[holder].balance * 95 / 100;\n', '        }\n', '        else\n', '        {\n', '            etherToSend = orders[holder].balance;\n', '        }\n', '        assert(etherToSend > 0);\n', '\n', '        if (etherToSend > this.balance) etherToSend = this.balance;\n', '\n', '        holder.transfer(etherToSend);\n', '\n', '        supplyTokens -= orders[holder].tokens;\n', '        orders[holder].balance = 0;\n', '        orders[holder].tokens = 0;\n', '    }\n', '\n', '    function takeInvest() isOwner\n', '    {\n', '        assert(now >= endDate + durationVoting);\n', '        assert(this.balance > 0);\n', '\n', '        if(sumVote > supplyTokensSaved / 2)\n', '        {\n', '            assert(supplyTokens == 0);\n', '        }\n', '\n', '        owner.transfer(this.balance);\n', '    }\n', '}']
