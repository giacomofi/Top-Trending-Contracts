['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-19\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract Riddle {\n', '    bytes32 private answerHash;\n', '    bool public isActive;\n', '    string public riddle;\n', '    string public answer;\n', '\n', '    address private riddler;\n', '\n', '    function () payable public {}\n', '    \n', '    constructor (string _riddle, bytes32 _answerHash) public payable {\n', '        riddler = msg.sender;\n', '        riddle = _riddle;\n', '        answerHash = _answerHash;\n', '        isActive = true;\n', '    }\n', '    \n', '    function verifyAnswer(string guess) public view returns(bool) {\n', '        if (keccak256(guess) == answerHash) {\n', '           return true;\n', '        }\n', '\n', '    }\n', '\n', '    function play(string guess) public {\n', '        require(isActive);\n', '        require(bytes(guess).length > 0);\n', '        \n', '        if (keccak256(guess) == answerHash) {\n', '            answer = guess;\n', '            isActive = false;\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function end(string _answer) public {\n', '        require(msg.sender == riddler);\n', '        answer = _answer;\n', '        isActive = false;\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '}']