['pragma solidity ^0.4.4;\n', '\n', 'contract Deposit {\n', '\n', '    address public owner;\n', '\n', '    // constructor\n', '    function Deposit() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // transfer ether to owner when receive ether\n', '    function() public payable {\n', '        _transter(msg.value);\n', '    }\n', '\n', '    // transfer\n', '    function _transter(uint balance) internal {\n', '        owner.transfer(balance);\n', '    }\n', '}']
['pragma solidity ^0.4.4;\n', '\n', 'contract Deposit {\n', '\n', '    address public owner;\n', '\n', '    // constructor\n', '    function Deposit() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // transfer ether to owner when receive ether\n', '    function() public payable {\n', '        _transter(msg.value);\n', '    }\n', '\n', '    // transfer\n', '    function _transter(uint balance) internal {\n', '        owner.transfer(balance);\n', '    }\n', '}']