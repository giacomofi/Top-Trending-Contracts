['pragma solidity ^0.4.17;\n', '\n', 'contract owned {\n', '    address public owner;    \n', '    \n', '    function owned() {\n', '        owner=msg.sender;\n', '    }\n', '\n', '    modifier onlyowner{\n', '        if (msg.sender!=owner)\n', '            throw;\n', '        _;\n', '    }\n', '}\n', '\n', 'contract MyNewBank is owned {\n', '    address public owner;\n', '    mapping (address=>uint) public deposits;\n', '    \n', '    function init() {\n', '        owner=msg.sender;\n', '    }\n', '    \n', '    function() payable {\n', '        deposit();\n', '    }\n', '    \n', '    function deposit() payable {\n', '        if (msg.value >= 100 finney)\n', '            deposits[msg.sender]+=msg.value;\n', '        else\n', '            throw;\n', '    }\n', '    \n', '    function withdraw(uint amount) public onlyowner {\n', '        require(amount>0);\n', '        uint depo = deposits[msg.sender];\n', '        if (amount <= depo)\n', '            msg.sender.send(amount);\n', '        else\n', '            revert();\n', '            \n', '    }\n', '\n', '\tfunction kill() onlyowner {\n', '\t    if(this.balance==0) {  \n', '\t\t    selfdestruct(msg.sender);\n', '\t    }\n', '\t}\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract owned {\n', '    address public owner;    \n', '    \n', '    function owned() {\n', '        owner=msg.sender;\n', '    }\n', '\n', '    modifier onlyowner{\n', '        if (msg.sender!=owner)\n', '            throw;\n', '        _;\n', '    }\n', '}\n', '\n', 'contract MyNewBank is owned {\n', '    address public owner;\n', '    mapping (address=>uint) public deposits;\n', '    \n', '    function init() {\n', '        owner=msg.sender;\n', '    }\n', '    \n', '    function() payable {\n', '        deposit();\n', '    }\n', '    \n', '    function deposit() payable {\n', '        if (msg.value >= 100 finney)\n', '            deposits[msg.sender]+=msg.value;\n', '        else\n', '            throw;\n', '    }\n', '    \n', '    function withdraw(uint amount) public onlyowner {\n', '        require(amount>0);\n', '        uint depo = deposits[msg.sender];\n', '        if (amount <= depo)\n', '            msg.sender.send(amount);\n', '        else\n', '            revert();\n', '            \n', '    }\n', '\n', '\tfunction kill() onlyowner {\n', '\t    if(this.balance==0) {  \n', '\t\t    selfdestruct(msg.sender);\n', '\t    }\n', '\t}\n', '}']
