['pragma solidity  0.4.24;\n', '\n', '\n', 'contract showNum {\n', '    address owner = msg.sender;\n', '    uint _num = 0;\n', '    constructor(uint number) public {\n', '        _num = number;\n', '    }\n', '    function setNum(uint number) public payable {\n', '        _num = number;\n', '    }\n', '    function getNum() constant public returns(uint) {\n', '        return _num;\n', '    }\n', '}']
['pragma solidity  0.4.24;\n', '\n', '\n', 'contract showNum {\n', '    address owner = msg.sender;\n', '    uint _num = 0;\n', '    constructor(uint number) public {\n', '        _num = number;\n', '    }\n', '    function setNum(uint number) public payable {\n', '        _num = number;\n', '    }\n', '    function getNum() constant public returns(uint) {\n', '        return _num;\n', '    }\n', '}']
