['pragma solidity ^0.4.23;\n', '\n', '/*\n', '!!! THIS CONTRACT IS EXPLOITABLE AND FOR EDUCATIONAL PURPOSES ONLY !!!\n', '\n', 'This smart contract allows a user to (insecurely) store funds\n', 'in this smart contract and withdraw them at any later point in time\n', '*/\n', '\n', 'contract keepMyEther {\n', '    mapping(address => uint256) public balances;\n', '    \n', '    function () payable public {\n', '        balances[msg.sender] += msg.value;\n', '    }\n', '    \n', '    function withdraw() public {\n', '        msg.sender.call.value(balances[msg.sender])();\n', '        balances[msg.sender] = 0;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/*\n', '!!! THIS CONTRACT IS EXPLOITABLE AND FOR EDUCATIONAL PURPOSES ONLY !!!\n', '\n', 'This smart contract allows a user to (insecurely) store funds\n', 'in this smart contract and withdraw them at any later point in time\n', '*/\n', '\n', 'contract keepMyEther {\n', '    mapping(address => uint256) public balances;\n', '    \n', '    function () payable public {\n', '        balances[msg.sender] += msg.value;\n', '    }\n', '    \n', '    function withdraw() public {\n', '        msg.sender.call.value(balances[msg.sender])();\n', '        balances[msg.sender] = 0;\n', '    }\n', '}']