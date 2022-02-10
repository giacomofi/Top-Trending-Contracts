['pragma solidity ^0.4.23;\n', '\n', 'contract Migrations {\n', '  address public owner;\n', '  uint public last_completed_migration;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier restricted() {\n', '    if (msg.sender == owner) _;\n', '  }\n', '\n', '  function setCompleted(uint completed) public restricted {\n', '    last_completed_migration = completed;\n', '  }\n', '\n', '  function upgrade(address new_address) public restricted {\n', '    Migrations upgraded = Migrations(new_address);\n', '    upgraded.setCompleted(last_completed_migration);\n', '  }\n', '}']