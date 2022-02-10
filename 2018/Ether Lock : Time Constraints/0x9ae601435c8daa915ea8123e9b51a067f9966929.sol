['pragma solidity ^0.4.24;\n', '\n', 'contract FastProfit {\n', '    address constant private PROMO = 0xA93c13B3E3561e5e2A1a20239486D03A16d1Fc4b;\n', '    uint constant public PROMO_PERCENT = 5;\n', '    uint constant public MULTIPLIER = 110;\n', '    uint constant public MAX_DEPOSIT = 1 ether;\n', '    uint constant public MIN_DEPOSIT = 0.01 ether;\n', '\n', '    uint constant public LAST_DEPOSIT_PERCENT = 2;\n', '    \n', '    LastDeposit public last;\n', '\n', '    struct Deposit {\n', '        address depositor; \n', '        uint128 deposit;   \n', '        uint128 expect;    \n', '    }\n', '\n', '    struct LastDeposit {\n', '        address depositor;\n', '        uint expect;\n', '        uint blockNumber;\n', '    }\n', '\n', '    Deposit[] private queue;\n', '    uint public currentReceiverIndex = 0; \n', '\n', '    function () public payable {\n', '        if(msg.value == 0 && msg.sender == last.depositor) {\n', '            require(gasleft() >= 220000, "We require more gas!");\n', '            require(last.blockNumber + 258 < block.number, "Last depositor should wait 258 blocks (~1 hour) to claim reward");\n', '            \n', '            uint128 money = uint128((address(this).balance));\n', '            if(money >= last.expect){\n', '                last.depositor.transfer(last.expect);\n', '            } else {\n', '                last.depositor.transfer(money);\n', '            }\n', '            \n', '            delete last;\n', '        }\n', '        else if(msg.value > 0){\n', '            require(gasleft() >= 220000, "We require more gas!");\n', '            require(msg.value <= MAX_DEPOSIT && msg.value >= MIN_DEPOSIT, "Deposit must be >= 0.01 ETH and <= 1 ETH"); \n', '\n', '            queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));\n', '\n', '            last.depositor = msg.sender;\n', '            last.expect += msg.value*LAST_DEPOSIT_PERCENT/100;\n', '            last.blockNumber = block.number;\n', '\n', '            uint promo = msg.value*PROMO_PERCENT/100;\n', '            PROMO.transfer(promo);\n', '\n', '            pay();\n', '        }\n', '    }\n', '\n', '    function pay() private {\n', '        uint128 money = uint128((address(this).balance)-last.expect);\n', '\n', '        for(uint i=0; i<queue.length; i++){\n', '\n', '            uint idx = currentReceiverIndex + i;  \n', '\n', '            Deposit storage dep = queue[idx]; \n', '\n', '            if(money >= dep.expect){  \n', '                dep.depositor.transfer(dep.expect); \n', '                money -= dep.expect;            \n', '\n', '                \n', '                delete queue[idx];\n', '            }else{\n', '                dep.depositor.transfer(money); \n', '                dep.expect -= money;       \n', '                break;\n', '            }\n', '\n', '            if(gasleft() <= 50000)        \n', '                break;\n', '        }\n', '\n', '        currentReceiverIndex += i; \n', '    }\n', '\n', '    function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){\n', '        Deposit storage dep = queue[idx];\n', '        return (dep.depositor, dep.deposit, dep.expect);\n', '    }\n', '\n', '    function getDepositsCount(address depositor) public view returns (uint) {\n', '        uint c = 0;\n', '        for(uint i=currentReceiverIndex; i<queue.length; ++i){\n', '            if(queue[i].depositor == depositor)\n', '                c++;\n', '        }\n', '        return c;\n', '    }\n', '\n', '    function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {\n', '        uint c = getDepositsCount(depositor);\n', '\n', '        idxs = new uint[](c);\n', '        deposits = new uint128[](c);\n', '        expects = new uint128[](c);\n', '\n', '        if(c > 0) {\n', '            uint j = 0;\n', '            for(uint i=currentReceiverIndex; i<queue.length; ++i){\n', '                Deposit storage dep = queue[i];\n', '                if(dep.depositor == depositor){\n', '                    idxs[j] = i;\n', '                    deposits[j] = dep.deposit;\n', '                    expects[j] = dep.expect;\n', '                    j++;\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    function getQueueLength() public view returns (uint) {\n', '        return queue.length - currentReceiverIndex;\n', '    }\n', '\n', '}']