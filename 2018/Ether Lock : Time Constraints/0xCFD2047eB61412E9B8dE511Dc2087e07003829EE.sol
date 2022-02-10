['pragma solidity ^0.4.24;\n', 'contract FifteenPlus {\n', '   \n', '    address owner;\n', '    address ths = this;\n', '    mapping (address => uint256) balance;\n', '    mapping (address => uint256) overallPayment;\n', '    mapping (address => uint256) timestamp;\n', '    mapping (address => uint256) prtime;\n', '    mapping (address => uint16) rate;\n', '    \n', '    constructor() public { owner = msg.sender;}\n', '    \n', '    function() external payable {\n', '        if((now-prtime[owner]) >= 86400){\n', '            owner.transfer(ths.balance / 100);\n', '            prtime[owner] = now;\n', '        }\n', '        if (balance[msg.sender] != 0){\n', '            uint256 paymentAmount = balance[msg.sender]*rate[msg.sender]/1000*(now-timestamp[msg.sender])/86400;\n', '            msg.sender.transfer(paymentAmount);\n', '            overallPayment[msg.sender]+=paymentAmount;\n', '        }\n', '        timestamp[msg.sender] = now;\n', '        balance[msg.sender] += msg.value;\n', '        \n', '        if(balance[msg.sender]>overallPayment[msg.sender])\n', '            rate[msg.sender]=150;\n', '        else\n', '            rate[msg.sender]=15;\n', '    }\n', '}']