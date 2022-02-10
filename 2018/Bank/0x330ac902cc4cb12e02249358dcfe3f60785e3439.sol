['pragma solidity ^0.4.25;\n', '\n', '\n', '/**\n', ' *  - 30% PER 24 HOURS (every 86400 secs)\n', ' *  - NO COMMISSION\n', ' *  - NO FEES\n', ' */\n', 'contract Easy30 {\n', '\n', '    mapping (address => uint256) dates;\n', '    mapping (address => uint256) invests;\n', '\n', '    function() external payable {\n', '        address sender = msg.sender;\n', '        if (invests[sender] != 0) {\n', '            uint256 payout = invests[sender] / 100 * 30 * (now - dates[sender]) / 1 days;\n', '            if (payout > address(this).balance) {\n', '                payout = address(this).balance;\n', '            }\n', '            sender.transfer(payout);\n', '        }\n', '        dates[sender]    = now;\n', '        invests[sender] += msg.value;\n', '    }\n', '\n', '}']