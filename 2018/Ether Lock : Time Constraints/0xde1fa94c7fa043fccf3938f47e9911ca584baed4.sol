['pragma solidity ^0.4.24;\n', 'contract DailyGreed {\n', '    address owner;\n', '\n', '    function Daily() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint256) timestamp;\n', '\n', '    function() external payable {\n', '        owner.send(msg.value / 10);\n', '        if (balances[msg.sender] != 0){\n', '        address kashout = msg.sender;\n', '        uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900;\n', '        kashout.send(getout);\n', '        }\n', '\n', '        timestamp[msg.sender] = block.number;\n', '        balances[msg.sender] += msg.value;\n', '\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', 'contract DailyGreed {\n', '    address owner;\n', '\n', '    function Daily() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint256) timestamp;\n', '\n', '    function() external payable {\n', '        owner.send(msg.value / 10);\n', '        if (balances[msg.sender] != 0){\n', '        address kashout = msg.sender;\n', '        uint256 getout = balances[msg.sender]*5/100*(block.number-timestamp[msg.sender])/5900;\n', '        kashout.send(getout);\n', '        }\n', '\n', '        timestamp[msg.sender] = block.number;\n', '        balances[msg.sender] += msg.value;\n', '\n', '    }\n', '}']