['pragma solidity ^0.4.16;\n', ' \n', 'contract CodexBeta {\n', '    struct MyCode {\n', '        string code;\n', '    }\n', '    event Record(string code);\n', '    function record(string code) public {\n', '        registry[msg.sender] = MyCode(code);\n', '    }\n', '    mapping (address => MyCode) public registry;\n', '}']
['pragma solidity ^0.4.16;\n', ' \n', 'contract CodexBeta {\n', '    struct MyCode {\n', '        string code;\n', '    }\n', '    event Record(string code);\n', '    function record(string code) public {\n', '        registry[msg.sender] = MyCode(code);\n', '    }\n', '    mapping (address => MyCode) public registry;\n', '}']