['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *\n', ' * Smartest Investments Contract\n', ' *  - GAIN 4.2% PER 24 HOURS (every 5900 blocks)\n', ' *  - NO FEES on your investment\n', ' *  - NO FEES are collected by the contract creator\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of Ether to contract address to make an investment\n', ' *  2a. Claim your profit by sending 0 Ether transaction\n', ' *  2b. Send more Ether to reinvest and claim your profit at the same time\n', ' *\n', ' * Recommended Gas Limit: 70000\n', ' * Recommended Gas Price: https://ethgasstation.info/\n', ' *\n', ' */\n', '\n', 'contract Smartest {\n', '    mapping (address => uint256) invested;\n', '    mapping (address => uint256) investBlock;\n', '\n', '    function () external payable {\n', '        if (invested[msg.sender] != 0) {\n', '            // use .transfer instead of .send prevents loss of your profit when\n', '            // there is a shortage of funds in the fund at the moment\n', '            msg.sender.transfer(invested[msg.sender] * (block.number - investBlock[msg.sender]) * 21 / 2950000);\n', '        }\n', '\n', '        investBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *\n', ' * Smartest Investments Contract\n', ' *  - GAIN 4.2% PER 24 HOURS (every 5900 blocks)\n', ' *  - NO FEES on your investment\n', ' *  - NO FEES are collected by the contract creator\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of Ether to contract address to make an investment\n', ' *  2a. Claim your profit by sending 0 Ether transaction\n', ' *  2b. Send more Ether to reinvest and claim your profit at the same time\n', ' *\n', ' * Recommended Gas Limit: 70000\n', ' * Recommended Gas Price: https://ethgasstation.info/\n', ' *\n', ' */\n', '\n', 'contract Smartest {\n', '    mapping (address => uint256) invested;\n', '    mapping (address => uint256) investBlock;\n', '\n', '    function () external payable {\n', '        if (invested[msg.sender] != 0) {\n', '            // use .transfer instead of .send prevents loss of your profit when\n', '            // there is a shortage of funds in the fund at the moment\n', '            msg.sender.transfer(invested[msg.sender] * (block.number - investBlock[msg.sender]) * 21 / 2950000);\n', '        }\n', '\n', '        investBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '}']
