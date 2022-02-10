['pragma solidity ^0.4.2;\n', '\n', '/// @title GNT Allocation - Time-locked vault of tokens allocated\n', '/// to developers and Golem Factory\n', 'contract GNTAllocation {\n', '    // Total number of allocations to distribute additional tokens among\n', '    // developers and the Golem Factory. The Golem Factory has right to 20000\n', '    // allocations, developers to 10000 allocations, divides among individual\n', '    // developers by numbers specified in  `allocations` table.\n', '    uint256 constant totalAllocations = 30000;\n', '\n', '    // Addresses of developer and the Golem Factory to allocations mapping.\n', '    mapping (address => uint256) allocations;\n', '\n', '    GolemNetworkToken gnt;\n', '    uint256 unlockedAt;\n', '\n', '    uint256 tokensCreated = 0;\n', '\n', '    function GNTAllocation(address _golemFactory) internal {\n', '        gnt = GolemNetworkToken(msg.sender);\n', '        unlockedAt = now + 30 minutes;\n', '\n', '        // For the Golem Factory:\n', '        allocations[_golemFactory] = 20000; // 12/18 pp of 30000 allocations.\n', '\n', '        // For developers:\n', "        allocations[0x3F4e79023273E82EfcD8B204fF1778e09df1a597] = 2500; // 25.0% of developers' allocations (10000).\n", "        allocations[0x1A5218B6E5C49c290745552481bb0335be2fB0F4] =  730; //  7.3% of developers' allocations.\n", '        allocations[0x00eA32D8DAe74c01eBe293C74921DB27a6398D57] =  730;\n', '        allocations[0xde03] =  730;\n', '        allocations[0xde04] =  730;\n', '        allocations[0xde05] =  730;\n', "        allocations[0xde06] =  630; //  6.3% of developers' allocations.\n", '        allocations[0xde07] =  630;\n', '        allocations[0xde08] =  630;\n', '        allocations[0xde09] =  630;\n', "        allocations[0xde10] =  310; //  3.1% of developers' allocations.\n", "        allocations[0xde11] =  153; //  1.53% of developers' allocations.\n", "        allocations[0xde12] =  150; //  1.5% of developers' allocations.\n", "        allocations[0xde13] =  100; //  1.0% of developers' allocations.\n", '        allocations[0xde14] =  100;\n', '        allocations[0xde15] =  100;\n', "        allocations[0xde16] =   70; //  0.7% of developers' allocations.\n", '        allocations[0xde17] =   70;\n', '        allocations[0xde18] =   70;\n', '        allocations[0xde19] =   70;\n', '        allocations[0xde20] =   70;\n', "        allocations[0xde21] =   42; //  0.42% of developers' allocations.\n", "        allocations[0xde22] =   25; //  0.25% of developers' allocations.\n", '    }\n', '\n', '    /// @notice Allow developer to unlock allocated tokens by transferring them\n', "    /// from GNTAllocation to developer's address.\n", '    function unlock() external {\n', '        if (now < unlockedAt) throw;\n', '\n', '        // During first unlock attempt fetch total number of locked tokens.\n', '        if (tokensCreated == 0)\n', '            tokensCreated = gnt.balanceOf(this);\n', '\n', '        var allocation = allocations[msg.sender];\n', '        allocations[msg.sender] = 0;\n', '        var toTransfer = tokensCreated * allocation / totalAllocations;\n', '\n', '        // Will fail if allocation (and therefore toTransfer) is 0.\n', '        if (!gnt.transfer(msg.sender, toTransfer)) throw;\n', '    }\n', '}\n', '\n', '/// @title Migration Agent interface\n', 'contract MigrationAgent {\n', '    function migrateFrom(address _from, uint256 _value);\n', '}\n', '\n', '/// @title Golem Network Token (GNT) - crowdfunding code for Golem Project\n', 'contract GolemNetworkToken {\n', '    string public constant name = "Test Network Token";\n', '    string public constant symbol = "TNT";\n', '    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.\n', '\n', '    uint256 public constant tokenCreationRate = 1000;\n', '\n', '    // The funding cap in weis.\n', '    uint256 public constant tokenCreationCap = 3 ether * tokenCreationRate;\n', '    uint256 public constant tokenCreationMin = 1 ether * tokenCreationRate;\n', '\n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingEndBlock;\n', '\n', '    // The flag indicates if the GNT contract is in Funding state.\n', '    bool public funding = true;\n', '\n', '    // Receives ETH and its own GNT endowment.\n', '    address public golemFactory;\n', '\n', '    // Has control over token migration to next version of token.\n', '    address public migrationMaster;\n', '\n', '    GNTAllocation lockedAllocation;\n', '\n', '    // The current total token supply.\n', '    uint256 totalTokens;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    address public migrationAgent;\n', '    uint256 public totalMigrated;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed _from, uint256 _value);\n', '\n', '    function GolemNetworkToken(address _golemFactory,\n', '                               address _migrationMaster,\n', '                               uint256 _fundingStartBlock,\n', '                               uint256 _fundingEndBlock) {\n', '\n', '        if (_golemFactory == 0) throw;\n', '        if (_migrationMaster == 0) throw;\n', '        if (_fundingStartBlock <= block.number) throw;\n', '        if (_fundingEndBlock   <= _fundingStartBlock) throw;\n', '\n', '        lockedAllocation = new GNTAllocation(_golemFactory);\n', '        migrationMaster = _migrationMaster;\n', '        golemFactory = _golemFactory;\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingEndBlock = _fundingEndBlock;\n', '    }\n', '\n', "    /// @notice Transfer `_value` GNT tokens from sender's account\n", '    /// `msg.sender` to provided account address `_to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Operational\n', '    /// @param _to The address of the tokens recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        // Abort if not in Operational state.\n', '        if (funding) throw;\n', '\n', '        var senderBalance = balances[msg.sender];\n', '        if (senderBalance >= _value && _value > 0) {\n', '            senderBalance -= _value;\n', '            balances[msg.sender] = senderBalance;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function totalSupply() external constant returns (uint256) {\n', '        return totalTokens;\n', '    }\n', '\n', '    function balanceOf(address _owner) external constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    // Token migration support:\n', '\n', '    /// @notice Migrate tokens to the new token contract.\n', '    /// @dev Required state: Operational Migration\n', '    /// @param _value The amount of token to be migrated\n', '    function migrate(uint256 _value) external {\n', '        // Abort if not in Operational Migration state.\n', '        if (funding) throw;\n', '        if (migrationAgent == 0) throw;\n', '\n', '        // Validate input value.\n', '        if (_value == 0) throw;\n', '        if (_value > balances[msg.sender]) throw;\n', '\n', '        balances[msg.sender] -= _value;\n', '        totalTokens -= _value;\n', '        totalMigrated += _value;\n', '        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);\n', '        Migrate(msg.sender, migrationAgent, _value);\n', '    }\n', '\n', '    /// @notice Set address of migration target contract and enable migration\n', '\t/// process.\n', '    /// @dev Required state: Operational Normal\n', '    /// @dev State transition: -> Operational Migration\n', '    /// @param _agent The address of the MigrationAgent contract\n', '    function setMigrationAgent(address _agent) external {\n', '        // Abort if not in Operational Normal state.\n', '        if (funding) throw;\n', '        if (migrationAgent != 0) throw;\n', '        if (msg.sender != migrationMaster) throw;\n', '        migrationAgent = _agent;\n', '    }\n', '\n', '    function setMigrationMaster(address _master) external {\n', '        if (msg.sender != migrationMaster) throw;\n', '        if (_master == 0) throw;\n', '        migrationMaster = _master;\n', '    }\n', '\n', '    // Crowdfunding:\n', '\n', '    /// @notice Create tokens when funding is active.\n', '    /// @dev Required state: Funding Active\n', '    /// @dev State transition: -> Funding Success (only if cap reached)\n', '    function create() payable external {\n', '        // Abort if not in Funding Active state.\n', '        // The checks are split (instead of using or operator) because it is\n', '        // cheaper this way.\n', '        if (!funding) throw;\n', '        if (block.number < fundingStartBlock) throw;\n', '        if (block.number > fundingEndBlock) throw;\n', '\n', '        // Do not allow creating 0 or more than the cap tokens.\n', '        if (msg.value == 0) throw;\n', '        if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)\n', '            throw;\n', '\n', '        var numTokens = msg.value * tokenCreationRate;\n', '        totalTokens += numTokens;\n', '\n', '        // Assign new tokens to the sender\n', '        balances[msg.sender] += numTokens;\n', '\n', '        // Log token creation event\n', '        Transfer(0, msg.sender, numTokens);\n', '    }\n', '\n', '    /// @notice Finalize crowdfunding\n', '    /// @dev If cap was reached or crowdfunding has ended then:\n', '    /// create GNT for the Golem Factory and developer,\n', '    /// transfer ETH to the Golem Factory address.\n', '    /// @dev Required state: Funding Success\n', '    /// @dev State transition: -> Operational Normal\n', '    function finalize() external {\n', '        // Abort if not in Funding Success state.\n', '        if (!funding) throw;\n', '        if ((block.number <= fundingEndBlock ||\n', '             totalTokens < tokenCreationMin) &&\n', '            totalTokens < tokenCreationCap) throw;\n', '\n', '        // Switch to Operational state. This is the only place this can happen.\n', '        funding = false;\n', '\n', '        // Create additional GNT for the Golem Factory and developers as\n', '        // the 18% of total number of tokens.\n', '        // All additional tokens are transfered to the account controller by\n', '        // GNTAllocation contract which will not allow using them for 6 months.\n', '        uint256 percentOfTotal = 18;\n', '        uint256 additionalTokens =\n', '            totalTokens * percentOfTotal / (100 - percentOfTotal);\n', '        totalTokens += additionalTokens;\n', '        balances[lockedAllocation] += additionalTokens;\n', '        Transfer(0, lockedAllocation, additionalTokens);\n', '\n', '        // Transfer ETH to the Golem Factory address.\n', '        if (!golemFactory.send(this.balance)) throw;\n', '    }\n', '\n', '    /// @notice Get back the ether sent during the funding in case the funding\n', '    /// has not reached the minimum level.\n', '    /// @dev Required state: Funding Failure\n', '    function refund() external {\n', '        // Abort if not in Funding Failure state.\n', '        if (!funding) throw;\n', '        if (block.number <= fundingEndBlock) throw;\n', '        if (totalTokens >= tokenCreationMin) throw;\n', '\n', '        var gntValue = balances[msg.sender];\n', '        if (gntValue == 0) throw;\n', '        balances[msg.sender] = 0;\n', '        totalTokens -= gntValue;\n', '\n', '        var ethValue = gntValue / tokenCreationRate;\n', '        Refund(msg.sender, ethValue);\n', '        if (!msg.sender.send(ethValue)) throw;\n', '    }\n', '}']