['pragma solidity ^0.4.24;\n', '//\n', '// Hello World: Simple SHA3() Function Test\n', '// WARNING: DO NOT USE THIS CONTRACT OR YOU LOSE EVERYTHING!!!!!!!!!!!\n', '// KECCAK256("test") = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664cb9a3cb658\n', '// \n', '//\n', 'contract Simple_SHA3_Test {\n', '    \n', '    event test(string result);\n', '    \n', '    address private owner;\n', '    bytes32 hash = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664cb9a3cb658;\n', '\n', '    function () payable public {}\n', '    \n', '    constructor () public payable {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function withdraw(string preimage) public payable {\n', '        require(msg.value >= 10 ether);\n', '        require(bytes(preimage).length > 0);\n', '\n', '        bytes32 solution = keccak256(bytes(preimage));\n', '        if (solution == hash) {\n', '            emit test("SHA works");\n', '            msg.sender.transfer(address(this).balance);\n', '        }else{\n', '            emit test("SHA doesnt work");\n', '        }\n', '    }\n', '    \n', '    function test_withdraw() public {\n', '        require(msg.sender == owner);\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '    \n', '    function test_suicide() public {\n', '        require(msg.sender == owner);\n', '        selfdestruct(msg.sender);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '//\n', '// Hello World: Simple SHA3() Function Test\n', '// WARNING: DO NOT USE THIS CONTRACT OR YOU LOSE EVERYTHING!!!!!!!!!!!\n', '// KECCAK256("test") = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664cb9a3cb658\n', '// \n', '//\n', 'contract Simple_SHA3_Test {\n', '    \n', '    event test(string result);\n', '    \n', '    address private owner;\n', '    bytes32 hash = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664cb9a3cb658;\n', '\n', '    function () payable public {}\n', '    \n', '    constructor () public payable {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function withdraw(string preimage) public payable {\n', '        require(msg.value >= 10 ether);\n', '        require(bytes(preimage).length > 0);\n', '\n', '        bytes32 solution = keccak256(bytes(preimage));\n', '        if (solution == hash) {\n', '            emit test("SHA works");\n', '            msg.sender.transfer(address(this).balance);\n', '        }else{\n', '            emit test("SHA doesnt work");\n', '        }\n', '    }\n', '    \n', '    function test_withdraw() public {\n', '        require(msg.sender == owner);\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '    \n', '    function test_suicide() public {\n', '        require(msg.sender == owner);\n', '        selfdestruct(msg.sender);\n', '    }\n', '}']