['pragma solidity ^0.4.10;\n', '\n', 'contract FunGame \n', '{\n', '    address owner;\n', '    modifier OnlyOwner() \n', '    {\n', '        if (msg.sender == owner) \n', '        _;\n', '    }\n', '    function FunGame()\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '    function TakeMoney() OnlyOwner\n', '    {\n', '        owner.transfer(this.balance);\n', '    }\n', '    function ChangeOwner(address NewOwner) OnlyOwner \n', '    {\n', '        owner = NewOwner;\n', '    }\n', '}']