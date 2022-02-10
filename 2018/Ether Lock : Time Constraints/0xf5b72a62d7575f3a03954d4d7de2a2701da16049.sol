['pragma solidity ^0.4.16;\n', '\n', 'contract PresaleFund {\n', '    bool isClosed;\n', '    struct Deposit { address buyer; uint amount; }\n', '    uint refundDate;\n', '    address fiduciary = msg.sender;\n', '    Deposit[] Deposits;\n', '    mapping (address => uint) total;\n', '\n', '    function() public payable { }\n', '    \n', '    function init(uint date)\n', '    {\n', '        refundDate = date;\n', '    }\n', '\n', '    function deposit()\n', '    public payable {\n', '        if (msg.value >= 0.25 ether && !isClosed)\n', '        {\n', '            Deposit newDeposit;\n', '            newDeposit.buyer = msg.sender;\n', '            newDeposit.amount = msg.value;\n', '            Deposits.push(newDeposit);\n', '            total[msg.sender] += msg.value;\n', '        }\n', '        if (this.balance >= 25 ether)\n', '        {\n', '            isClosed = true;\n', '        }\n', '    }\n', '\n', '    function refund(uint amount)\n', '    public {\n', '        if (total[msg.sender] >= amount && amount > 0)\n', '        {\n', '            if (now >= refundDate && isClosed==false)\n', '            {\n', '                msg.sender.transfer(amount);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function close()\n', '    public {\n', '        if (msg.sender == fiduciary)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '            isClosed = true;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract PresaleFund {\n', '    bool isClosed;\n', '    struct Deposit { address buyer; uint amount; }\n', '    uint refundDate;\n', '    address fiduciary = msg.sender;\n', '    Deposit[] Deposits;\n', '    mapping (address => uint) total;\n', '\n', '    function() public payable { }\n', '    \n', '    function init(uint date)\n', '    {\n', '        refundDate = date;\n', '    }\n', '\n', '    function deposit()\n', '    public payable {\n', '        if (msg.value >= 0.25 ether && !isClosed)\n', '        {\n', '            Deposit newDeposit;\n', '            newDeposit.buyer = msg.sender;\n', '            newDeposit.amount = msg.value;\n', '            Deposits.push(newDeposit);\n', '            total[msg.sender] += msg.value;\n', '        }\n', '        if (this.balance >= 25 ether)\n', '        {\n', '            isClosed = true;\n', '        }\n', '    }\n', '\n', '    function refund(uint amount)\n', '    public {\n', '        if (total[msg.sender] >= amount && amount > 0)\n', '        {\n', '            if (now >= refundDate && isClosed==false)\n', '            {\n', '                msg.sender.transfer(amount);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function close()\n', '    public {\n', '        if (msg.sender == fiduciary)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '            isClosed = true;\n', '        }\n', '    }\n', '}']
