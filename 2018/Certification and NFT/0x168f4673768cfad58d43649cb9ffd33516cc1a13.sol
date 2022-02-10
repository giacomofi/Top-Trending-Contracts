['pragma solidity 0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="ed898c9b88ad8c8682808f8cc38e8280">[email&#160;protected]</a>\n', '// released under Apache 2.0 licence\n', 'contract Migrations {\n', '    address public owner;\n', '    uint public last_completed_migration;\n', '\n', '    modifier restricted() {\n', '        if (msg.sender == owner) _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function setCompleted(uint completed) public restricted {\n', '        last_completed_migration = completed;\n', '    }\n', '\n', '    function upgrade(address new_address) public restricted {\n', '        Migrations upgraded = Migrations(new_address);\n', '        upgraded.setCompleted(last_completed_migration);\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', 'contract Migrations {\n', '    address public owner;\n', '    uint public last_completed_migration;\n', '\n', '    modifier restricted() {\n', '        if (msg.sender == owner) _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function setCompleted(uint completed) public restricted {\n', '        last_completed_migration = completed;\n', '    }\n', '\n', '    function upgrade(address new_address) public restricted {\n', '        Migrations upgraded = Migrations(new_address);\n', '        upgraded.setCompleted(last_completed_migration);\n', '    }\n', '}']