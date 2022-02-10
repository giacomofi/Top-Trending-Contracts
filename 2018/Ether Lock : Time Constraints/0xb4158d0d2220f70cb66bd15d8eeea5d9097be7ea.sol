['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '// Time-locked wallet for Serenity advisors tokens\n', 'contract SerenityTeamAllocator {\n', '    // Address of team member to allocations mapping\n', '    mapping (address => uint256) allocations;\n', '\n', '    ERC20Basic erc20_contract = ERC20Basic(0xBC7942054F77b82e8A71aCE170E4B00ebAe67eB6);\n', '    uint unlockedAt;\n', '    address owner;\n', '\n', '    function SerenityTeamAllocator() {\n', '        unlockedAt = now + 11 * 30 days;\n', '        owner = msg.sender;\n', '\n', '        allocations[0x4bA894C02BC92FC59573F1A4D0d82361AC3a6284] = 840497 ether;\n', '        allocations[0xA71703676002410fa62EE74052b991B1b5F6c891] = 133333 ether;\n', '        allocations[0x530f065d63FD73480e34da84E5aE1dfD6f77Aa73] = 66666 ether;\n', '        allocations[0xa33def7d09B1CE511f7d5675B2C374526fAB44c7] = 66666 ether;\n', '        allocations[0x11C6F9ccf49EBE938Dae82AE6c50a64eB5778dCC] = 40000 ether;\n', '        allocations[0x4296C27536553c59e57Fa8EA47913F5000311f03] = 66666 ether;\n', '    }\n', '\n', '    // Unlock team member&#39;s tokens by transferring them to his address\n', '    function unlock() external {\n', '        require (now >= unlockedAt);\n', '\n', '        var amount = allocations[msg.sender];\n', '        allocations[msg.sender] = 0;\n', '\n', '        if (!erc20_contract.transfer(msg.sender, amount)) {\n', '            revert();\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '// Time-locked wallet for Serenity advisors tokens\n', 'contract SerenityTeamAllocator {\n', '    // Address of team member to allocations mapping\n', '    mapping (address => uint256) allocations;\n', '\n', '    ERC20Basic erc20_contract = ERC20Basic(0xBC7942054F77b82e8A71aCE170E4B00ebAe67eB6);\n', '    uint unlockedAt;\n', '    address owner;\n', '\n', '    function SerenityTeamAllocator() {\n', '        unlockedAt = now + 11 * 30 days;\n', '        owner = msg.sender;\n', '\n', '        allocations[0x4bA894C02BC92FC59573F1A4D0d82361AC3a6284] = 840497 ether;\n', '        allocations[0xA71703676002410fa62EE74052b991B1b5F6c891] = 133333 ether;\n', '        allocations[0x530f065d63FD73480e34da84E5aE1dfD6f77Aa73] = 66666 ether;\n', '        allocations[0xa33def7d09B1CE511f7d5675B2C374526fAB44c7] = 66666 ether;\n', '        allocations[0x11C6F9ccf49EBE938Dae82AE6c50a64eB5778dCC] = 40000 ether;\n', '        allocations[0x4296C27536553c59e57Fa8EA47913F5000311f03] = 66666 ether;\n', '    }\n', '\n', "    // Unlock team member's tokens by transferring them to his address\n", '    function unlock() external {\n', '        require (now >= unlockedAt);\n', '\n', '        var amount = allocations[msg.sender];\n', '        allocations[msg.sender] = 0;\n', '\n', '        if (!erc20_contract.transfer(msg.sender, amount)) {\n', '            revert();\n', '        }\n', '    }\n', '}']