['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-12\n', '*/\n', '\n', 'pragma solidity ^0.4.12;\n', 'contract hodlEthereum {\n', '    event Hodl(address indexed hodler, uint indexed amount);\n', '    event Party(address indexed hodler, uint indexed amount);\n', '    mapping (address => uint) public hodlers;\n', '    uint constant partyTime = 1623494533; // 30th July 2020\n', '    function() payable {\n', '        hodlers[msg.sender] += msg.value;\n', '        Hodl(msg.sender, msg.value);\n', '    }\n', '    function party() {\n', '        require (block.timestamp > partyTime && hodlers[msg.sender] > 0);\n', '        uint value = hodlers[msg.sender];\n', '        hodlers[msg.sender] = 0;\n', '        msg.sender.transfer(value);\n', '        Party(msg.sender, value);\n', '    }\n', '}']