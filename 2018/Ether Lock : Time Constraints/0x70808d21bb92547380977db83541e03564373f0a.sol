['pragma solidity ^0.4.24;\n', '\n', 'contract Test {\n', '    event testLog(address indexed account, uint amount);\n', '    \n', '    constructor() public {\n', '        emit testLog(msg.sender, block.number);\n', '    }\n', '    \n', '    function execute(uint number) public returns (bool) {\n', '        emit testLog(msg.sender, number);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract Test {\n', '    event testLog(address indexed account, uint amount);\n', '    \n', '    constructor() public {\n', '        emit testLog(msg.sender, block.number);\n', '    }\n', '    \n', '    function execute(uint number) public returns (bool) {\n', '        emit testLog(msg.sender, number);\n', '        return true;\n', '    }\n', '}']