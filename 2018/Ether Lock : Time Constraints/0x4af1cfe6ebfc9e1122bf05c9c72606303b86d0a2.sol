['pragma solidity ^0.4.24;\n', '\n', 'contract BonusContract {\n', '    \n', '    address advadr = 0x1Cc9a2500BCBd243a0f19A010786e5Da9CAb3273;\n', '    address defRefadr = 0xD83c0B015224C88b7c61B7C1658B42764e7652A8;\n', '    uint refPercent = 3;\n', '    uint refBack = 3;\n', '    uint public users = 0;\n', '   \n', '    mapping (address => uint256) public invested;\n', '    mapping (address => uint256) public atBlock;\n', '    \n', '    \n', '    function bToAdd(bytes bys) private pure returns (address addr)\n', '    {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '    \n', '    function () external payable {\n', '        uint256 getmsgvalue = msg.value/10;\n', '        advadr.transfer(getmsgvalue);\n', '        \n', '        if (invested[msg.sender] != 0) {\n', '            uint256 amount = invested[msg.sender] * 5/100 * (block.number - atBlock[msg.sender]) / 5900;\n', '            msg.sender.transfer(amount);\n', '            invested[msg.sender] += msg.value;\n', '        }\n', '        else\n', '        {\n', '            if((msg.value >= 0)&&(msg.value<10000000000000000))\n', '            {\n', '                invested[msg.sender] += msg.value + 1000000000000000;\n', '            }\n', '            else\n', '            {\n', '                invested[msg.sender] += msg.value + 10000000000000000;\n', '            }\n', '            users += 1;\n', '        }\n', '\n', '        if (msg.data.length != 0)\n', '        {\n', '            address Ref = bToAdd(msg.data);\n', '            address sender = msg.sender;\n', '            if(Ref != sender)\n', '            {\n', '                sender.transfer(msg.value * refBack / 100);\n', '                Ref.transfer(msg.value * refPercent / 100);\n', '            }\n', '            else\n', '            {\n', '                defRefadr.transfer(msg.value * refPercent / 100);\n', '            }\n', '        }\n', '        else\n', '        {\n', '            defRefadr.transfer(msg.value * refPercent / 100);\n', '        }\n', '\n', '        \n', '        atBlock[msg.sender] = block.number;\n', '        \n', '    }\n', '}']