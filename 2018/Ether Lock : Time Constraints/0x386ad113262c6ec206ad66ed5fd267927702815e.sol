['pragma solidity ^0.4.24;\n', '/**\n', ' * Easy Hold Contract\n', ' * INVEST AND HOLD\n', ' * NO COMMISSION NO FEES NO REFERRALS NO OWNER\n', ' * !!! THE MORE YOU HOLD THE MORE YOU GET !!!\n', ' * \n', ' * ======== PAYAOUT TABLE ========\n', ' *  DAYS    PAYOUT\n', ' *  HOLD    %\n', ' *  1\t    0,16\n', ' *  2\t    0,64\n', ' *  3\t    1,44\n', ' *  4\t    2,56\n', ' *  5\t    4\n', ' *  6\t    5,76\n', ' *  7\t    7,84\n', ' *  8\t    10,24\n', ' *  9\t    12,96\n', ' *  10\t    16\n', ' *  11\t    19,36\n', ' *  12\t    23,04\n', ' *  13\t    27,04\n', ' *  14\t    31,36\n', ' *  15\t    36\n', ' *  16\t    40,96\n', ' *  17\t    46,24\n', ' *  18\t    51,84\n', ' *  19\t    57,76\n', ' *  20\t    64\n', ' *  21\t    70,56\n', ' *  22\t    77,44\n', ' *  23\t    84,64\n', ' *  24\t    92,16\n', ' *  25\t    100     <- YOU&#39;ll get 100% if you HOLD for 25 days\n', ' *  26\t    108,16\n', ' *  27\t    116,64\n', ' *  28\t    125,44\n', ' *  29\t    134,56\n', ' *  30\t    144\n', ' *  31\t    153,76\n', ' *  32\t    163,84\n', ' *  33\t    174,24\n', ' *  34\t    184,96\n', ' *  35\t    196     <- YOU&#39;ll get 200% if you HOLD for 35 days\n', ' * AND SO ON\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', ' *  2. Wait some time. The more you wait the more your proft is\n', ' *  3. Claim your profit by sending 0 ether transaction\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 70000\n', ' *\n', ' */\n', ' \n', 'contract EasyHOLD {\n', '    mapping (address => uint256) invested; // records amounts invested\n', '    mapping (address => uint256) atTime;    // records time at which investments were made \n', '\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function () external payable {\n', '        // if sender (aka YOU) is invested more than 0 ether\n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * ((days since last transaction) / 25 days)^2\n', '            uint waited = block.timestamp - atTime[msg.sender];\n', '            uint256 amount = invested[msg.sender] * waited * waited / (25 days) / (25 days);\n', '\n', '            msg.sender.send(amount);// send calculated amount to sender (aka YOU)\n', '        }\n', '\n', '        // record block number and invested amount (msg.value) of this transaction\n', '        atTime[msg.sender] = block.timestamp;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '/**\n', ' * Easy Hold Contract\n', ' * INVEST AND HOLD\n', ' * NO COMMISSION NO FEES NO REFERRALS NO OWNER\n', ' * !!! THE MORE YOU HOLD THE MORE YOU GET !!!\n', ' * \n', ' * ======== PAYAOUT TABLE ========\n', ' *  DAYS    PAYOUT\n', ' *  HOLD    %\n', ' *  1\t    0,16\n', ' *  2\t    0,64\n', ' *  3\t    1,44\n', ' *  4\t    2,56\n', ' *  5\t    4\n', ' *  6\t    5,76\n', ' *  7\t    7,84\n', ' *  8\t    10,24\n', ' *  9\t    12,96\n', ' *  10\t    16\n', ' *  11\t    19,36\n', ' *  12\t    23,04\n', ' *  13\t    27,04\n', ' *  14\t    31,36\n', ' *  15\t    36\n', ' *  16\t    40,96\n', ' *  17\t    46,24\n', ' *  18\t    51,84\n', ' *  19\t    57,76\n', ' *  20\t    64\n', ' *  21\t    70,56\n', ' *  22\t    77,44\n', ' *  23\t    84,64\n', ' *  24\t    92,16\n', " *  25\t    100     <- YOU'll get 100% if you HOLD for 25 days\n", ' *  26\t    108,16\n', ' *  27\t    116,64\n', ' *  28\t    125,44\n', ' *  29\t    134,56\n', ' *  30\t    144\n', ' *  31\t    153,76\n', ' *  32\t    163,84\n', ' *  33\t    174,24\n', ' *  34\t    184,96\n', " *  35\t    196     <- YOU'll get 200% if you HOLD for 35 days\n", ' * AND SO ON\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', ' *  2. Wait some time. The more you wait the more your proft is\n', ' *  3. Claim your profit by sending 0 ether transaction\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 70000\n', ' *\n', ' */\n', ' \n', 'contract EasyHOLD {\n', '    mapping (address => uint256) invested; // records amounts invested\n', '    mapping (address => uint256) atTime;    // records time at which investments were made \n', '\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function () external payable {\n', '        // if sender (aka YOU) is invested more than 0 ether\n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * ((days since last transaction) / 25 days)^2\n', '            uint waited = block.timestamp - atTime[msg.sender];\n', '            uint256 amount = invested[msg.sender] * waited * waited / (25 days) / (25 days);\n', '\n', '            msg.sender.send(amount);// send calculated amount to sender (aka YOU)\n', '        }\n', '\n', '        // record block number and invested amount (msg.value) of this transaction\n', '        atTime[msg.sender] = block.timestamp;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '}']