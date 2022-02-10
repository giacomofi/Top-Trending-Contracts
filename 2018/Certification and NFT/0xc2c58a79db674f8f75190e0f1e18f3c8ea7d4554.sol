['pragma solidity ^0.4.15;\n', '\n', '// File: contracts/Migrations.sol\n', '\n', 'contract Migrations {\n', '  address public owner;\n', '  uint256 public last_completed_migration;\n', '\n', '  modifier restricted() {\n', '    if (msg.sender == owner)\n', '      _;\n', '  }\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function setCompleted(uint completed) restricted public {\n', '    last_completed_migration = completed;\n', '  }\n', '\n', '  function upgrade(address new_address) restricted public {\n', '    Migrations upgraded = Migrations(new_address);\n', '    upgraded.setCompleted(last_completed_migration);\n', '  }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', '// File: contracts/Migrations.sol\n', '\n', 'contract Migrations {\n', '  address public owner;\n', '  uint256 public last_completed_migration;\n', '\n', '  modifier restricted() {\n', '    if (msg.sender == owner)\n', '      _;\n', '  }\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function setCompleted(uint completed) restricted public {\n', '    last_completed_migration = completed;\n', '  }\n', '\n', '  function upgrade(address new_address) restricted public {\n', '    Migrations upgraded = Migrations(new_address);\n', '    upgraded.setCompleted(last_completed_migration);\n', '  }\n', '}']
