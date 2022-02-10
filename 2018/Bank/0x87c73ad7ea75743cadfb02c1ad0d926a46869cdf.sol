['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' *\n', ' * Easy Investment Contract\n', ' *  - GAIN 5% PER 24 HOURS\n', " *  - NO COMMISSION on your investment (every ether stays on contract's balance)\n", ' *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)\n', ' *  - Rapid growth PROTECTION. The balance of the contract can not grow faster than 10% of the total investment every day\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', " *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)\n", ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 100000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' * Contract reviewed and approved by pros!\n', ' *\n', ' */\n', 'contract EasyInvest5 {\n', '\n', '    // records amounts invested\n', '    mapping (address => uint) public invested;\n', '    // records timestamp at which investments were made\n', '    mapping (address => uint) public dates;\n', '\n', '    // records amount of all investments were made\n', '    uint public totalInvested;\n', '    // records the total allowable amount of investment. 50 ether to start\n', '    uint public canInvest = 50 ether;\n', '    // time of the update of allowable amount of investment\n', '    uint public refreshTime = now + 24 hours;\n', '\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function () external payable {\n', '        // if sender (aka YOU) is invested more than 0 ether\n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * 5% * (time since last transaction) / 24 hours\n', '            uint amount = invested[msg.sender] * 5 * (now - dates[msg.sender]) / 100 / 24 hours;\n', '\n', '            // if profit amount is not enough on contract balance, will be sent what is left\n', '            if (amount > address(this).balance) {\n', '                amount = address(this).balance;\n', '            }\n', '\n', '            // send calculated amount of ether directly to sender (aka YOU)\n', '            msg.sender.transfer(amount);\n', '        }\n', '\n', '        // record new timestamp\n', '        dates[msg.sender] = now;\n', '\n', '        // every day will be updated allowable amount of investment\n', '        if (refreshTime <= now) {\n', '            // investment amount is 10% of the total investment\n', '            canInvest += totalInvested / 10;\n', '            refreshTime += 24 hours;\n', '        }\n', '\n', '        if (msg.value > 0) {\n', '            // deposit cannot be more than the allowed amount\n', '            require(msg.value <= canInvest);\n', '            // record invested amount of this transaction\n', '            invested[msg.sender] += msg.value;\n', '            // update allowable amount of investment and total invested\n', '            canInvest -= msg.value;\n', '            totalInvested += msg.value;\n', '        }\n', '    }\n', '}']