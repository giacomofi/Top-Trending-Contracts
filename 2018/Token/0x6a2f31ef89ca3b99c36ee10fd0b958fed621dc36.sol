['pragma solidity ^0.4.21; //tells that the source code is written for Solidity version 0.4.21 or anything newer that does not break functionality\n', '\n', '\n', 'contract electrolightTestnet {\n', '    // The keyword "public" makes those variables readable from outside.\n', '    \n', '    address public minter;\n', '    \n', '    // Events allow light clients to react on changes efficiently.\n', '    mapping (address => uint) public balances;\n', '    \n', '    // This is the constructor whose code is run only when the contract is created\n', '    event Sent(address from, address to, uint amount);\n', '    \n', '    function electrolightTestnet() public {\n', '        \n', '        minter = msg.sender;\n', '        \n', '    }\n', '    \n', '    function mint(address receiver, uint amount) public {\n', '        \n', '        if(msg.sender != minter) return;\n', '        balances[receiver]+=amount;\n', '        \n', '    }\n', '    \n', '    function send(address receiver, uint amount) public {\n', '        if(balances[msg.sender] < amount) return;\n', '        balances[msg.sender]-=amount;\n', '        balances[receiver]+=amount;\n', '        emit Sent(msg.sender, receiver, amount);\n', '        \n', '    }\n', '    \n', '    \n', '}']
['pragma solidity ^0.4.21; //tells that the source code is written for Solidity version 0.4.21 or anything newer that does not break functionality\n', '\n', '\n', 'contract electrolightTestnet {\n', '    // The keyword "public" makes those variables readable from outside.\n', '    \n', '    address public minter;\n', '    \n', '    // Events allow light clients to react on changes efficiently.\n', '    mapping (address => uint) public balances;\n', '    \n', '    // This is the constructor whose code is run only when the contract is created\n', '    event Sent(address from, address to, uint amount);\n', '    \n', '    function electrolightTestnet() public {\n', '        \n', '        minter = msg.sender;\n', '        \n', '    }\n', '    \n', '    function mint(address receiver, uint amount) public {\n', '        \n', '        if(msg.sender != minter) return;\n', '        balances[receiver]+=amount;\n', '        \n', '    }\n', '    \n', '    function send(address receiver, uint amount) public {\n', '        if(balances[msg.sender] < amount) return;\n', '        balances[msg.sender]-=amount;\n', '        balances[receiver]+=amount;\n', '        emit Sent(msg.sender, receiver, amount);\n', '        \n', '    }\n', '    \n', '    \n', '}']
