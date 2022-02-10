['pragma solidity ^0.4.24;\n', '\n', '\n', 'contract Migrations {\n', '    address public owner;\n', '    uint public lastCompletedMigration;\n', '\n', '    modifier restricted() {\n', '        if (msg.sender == owner) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function setCompleted(uint completed) public restricted {\n', '        lastCompletedMigration = completed;\n', '    }\n', '\n', '    function upgrade(address newAddress) public restricted {\n', '        Migrations upgraded = Migrations(newAddress);\n', '        upgraded.setCompleted(lastCompletedMigration);\n', '    }\n', '}']