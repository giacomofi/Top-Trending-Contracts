['pragma solidity ^0.4.11;\n', '\n', 'contract Incrementer {\n', '\n', '    event LogWinner(address winner, uint amount);\n', '    \n', '    uint c = 0;\n', '\n', '    function ticket() payable {\n', '        \n', '        uint ethrebuts = msg.value;\n', '        if (ethrebuts != 10) {\n', '            throw;\n', '        }\n', '        c++;\n', '        \n', '        if (c==3) {\n', '            LogWinner(msg.sender,this.balance);\n', '            msg.sender.transfer(this.balance);\n', '            c=0;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract Incrementer {\n', '\n', '    event LogWinner(address winner, uint amount);\n', '    \n', '    uint c = 0;\n', '\n', '    function ticket() payable {\n', '        \n', '        uint ethrebuts = msg.value;\n', '        if (ethrebuts != 10) {\n', '            throw;\n', '        }\n', '        c++;\n', '        \n', '        if (c==3) {\n', '            LogWinner(msg.sender,this.balance);\n', '            msg.sender.transfer(this.balance);\n', '            c=0;\n', '        }\n', '    }\n', '}']