['pragma solidity ^0.4.4;\n', '\n', '\n', '/// @title Bitplus Token (BPNT) - crowdfunding code for Bitplus Project\n', 'contract BitplusToken {\n', '    string public constant name = "Bitplus Token";\n', '    string public constant symbol = "BPNT";\n', '    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.\n', '\n', '    uint256 public constant tokenCreationRate = 1000;\n', '\n', '    // The funding cap in weis.\n', '    uint256 public constant tokenCreationCap = 25000 ether * tokenCreationRate;\n', '    uint256 public constant tokenCreationMin = 2500 ether * tokenCreationRate;\n', '\n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingEndBlock;\n', '\n', '    // The flag indicates if the contract is in Funding state.\n', '    bool public funding = true;\n', '\n', '    // Receives ETH\n', '    address public bitplusAddress;\n', '\n', '    // The current total token supply.\n', '    uint256 totalTokens;\n', '\n', '    mapping (address => uint256) balances;\n', '    \n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    struct EarlyBackerCondition {\n', '        address backerAddress;\n', '        uint256 deposited;\n', '        uint256 agreedPercentage;\n', '        uint256 agreedEthPrice;\n', '    }\n', '    \n', '    EarlyBackerCondition[] public earlyBackers;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed _from, uint256 _value);\n', '    event EarlyBackerDeposit(address indexed _from, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function BitplusToken(uint256 _fundingStartBlock,\n', '                          uint256 _fundingEndBlock) {\n', '\n', '        address _bitplusAddress = 0x286e0060d9DBEa0231389485D455A80f14648B3c;\n', '        if (_bitplusAddress == 0) throw;\n', '        if (_fundingStartBlock <= block.number) throw;\n', '        if (_fundingEndBlock   <= _fundingStartBlock) throw;\n', '        \n', '        // special conditions for the early backers\n', '        earlyBackers.push(EarlyBackerCondition({\n', '            backerAddress: 0xa1cfc9ebdffbffe9b27d741ae04cfc2e78af527a,\n', '            deposited: 0,\n', '            agreedPercentage: 1000,\n', '            agreedEthPrice: 250 ether\n', '        }));\n', '        \n', '        // conditions for the company / developers\n', '        earlyBackers.push(EarlyBackerCondition({\n', '            backerAddress: 0x37ef1168252f274D4cA5b558213d7294085BCA08,\n', '            deposited: 0,\n', '            agreedPercentage: 500,\n', '            agreedEthPrice: 0.1 ether\n', '        }));\n', '        \n', '        earlyBackers.push(EarlyBackerCondition({\n', '            backerAddress: 0x246604643ac38e96526b66ba91c1b2ec0c39d8de,\n', '            deposited: 0,\n', '            agreedPercentage: 500,\n', '            agreedEthPrice: 0.1 ether\n', '        }));        \n', '        \n', '        bitplusAddress = _bitplusAddress;\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingEndBlock = _fundingEndBlock;\n', '    }\n', '\n', '    /// @notice Transfer `_value` BPNT tokens from sender&#39;s account\n', '    /// `msg.sender` to provided account address `_to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Operational\n', '    /// @param _to The address of the tokens recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        // Abort if not in Operational state.\n', '        if (funding) throw;\n', '\n', '        var senderBalance = balances[msg.sender];\n', '        if (senderBalance >= _value && _value > 0) {\n', '            senderBalance -= _value;\n', '            balances[msg.sender] = senderBalance;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function transferFrom(\n', '         address _from,\n', '         address _to,\n', '         uint256 _amount\n', '     ) returns (bool success) {\n', '        // Abort if not in Operational state.\n', '        if (funding) throw;         \n', '         \n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '    }    \n', '\n', '    function totalSupply() external constant returns (uint256) {\n', '        return totalTokens;\n', '    }\n', '\n', '    function balanceOf(address _owner) external constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice Create tokens when funding is active.\n', '    /// @dev Required state: Funding Active\n', '    /// @dev State transition: -> Funding Success (only if cap reached)\n', '    function create() payable external {\n', '        // Abort if not in Funding Active state.\n', '        // The checks are split (instead of using or operator) because it is\n', '        // cheaper this way.\n', '        if (!funding) throw;\n', '        if (block.number < fundingStartBlock) throw;\n', '        if (block.number > fundingEndBlock) throw;\n', '\n', '        // Do not allow creating 0 tokens.\n', '        if (msg.value == 0) throw;\n', '        \n', '        bool isEarlyBacker = false;\n', '        \n', '        for (uint i = 0; i < earlyBackers.length; i++) {\n', '            if(earlyBackers[i].backerAddress == msg.sender) {\n', '                earlyBackers[i].deposited += msg.value;\n', '                isEarlyBacker = true;\n', '                EarlyBackerDeposit(msg.sender, msg.value);\n', '            }\n', '        }\n', '        \n', '        \n', '        if(!isEarlyBacker) {\n', '            // do not allow to create more then cap tokens\n', '            if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)\n', '                throw;\n', '\n', '            var numTokens = msg.value * tokenCreationRate;\n', '            totalTokens += numTokens;\n', '\n', '            // Assign new tokens to the sender\n', '            balances[msg.sender] += numTokens;\n', '            \n', '            // Log token creation event\n', '            Transfer(0, msg.sender, numTokens);            \n', '        }\n', '    }\n', '\n', '    /// @notice Finalize crowdfunding\n', '    /// @dev If cap was reached or crowdfunding has ended then:\n', '    /// create BPNT for the early backers,\n', '    /// transfer ETH to the Bitplus address.\n', '    /// @dev Required state: Funding Success\n', '    /// @dev State transition: -> Operational Normal\n', '    function finalize() external {\n', '        // Abort if not in Funding Success state.\n', '        if (!funding) throw;\n', '        if ((block.number <= fundingEndBlock ||\n', '             totalTokens < tokenCreationMin) &&\n', '             totalTokens < tokenCreationCap) throw;\n', '\n', '        // Switch to Operational state. This is the only place this can happen.\n', '        funding = false;\n', '        // Transfer ETH to the Bitplus address.\n', '        if (!bitplusAddress.send(this.balance)) throw;\n', '        \n', '        for (uint i = 0; i < earlyBackers.length; i++) {\n', '            if(earlyBackers[i].deposited != uint256(0)) {\n', '                uint256 percentage = (earlyBackers[i].deposited * earlyBackers[i].agreedPercentage / earlyBackers[i].agreedEthPrice);\n', '                uint256 additionalTokens = totalTokens * percentage / (10000 - percentage);\n', '                address backerAddr = earlyBackers[i].backerAddress;\n', '                balances[backerAddr] = additionalTokens;\n', '                totalTokens += additionalTokens;\n', '                Transfer(0, backerAddr, additionalTokens);\n', '\t\t\t}\n', '        }\n', '    }\n', '\n', '    /// @notice Get back the ether sent during the funding in case the funding\n', '    /// has not reached the minimum level.\n', '    /// @dev Required state: Funding Failure\n', '    function refund() external {\n', '        // Abort if not in Funding Failure state.\n', '        if (!funding) throw;\n', '        if (block.number <= fundingEndBlock) throw;\n', '        if (totalTokens >= tokenCreationMin) throw;\n', '        \n', '        bool isEarlyBacker = false;\n', '        uint256 ethValue;\n', '        for (uint i = 0; i < earlyBackers.length; i++) {\n', '            if(earlyBackers[i].backerAddress == msg.sender) {\n', '                isEarlyBacker = true;\n', '                ethValue = earlyBackers[i].deposited;\n', '                if (ethValue == 0) throw;\n', '            }\n', '        }\n', '\n', '        if(!isEarlyBacker) {\n', '            var bpntValue = balances[msg.sender];\n', '            if (bpntValue == 0) throw;\n', '            balances[msg.sender] = 0;\n', '            totalTokens -= bpntValue;\n', '            ethValue = bpntValue / tokenCreationRate;\n', '        }\n', '        \n', '        Refund(msg.sender, ethValue);\n', '        if (!msg.sender.send(ethValue)) throw;\n', '    }\n', '    \n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    // Just a safeguard for people who might invest and then loose the key\n', '    // If 2 weeks after an unsuccessful end of the campaign there are unclaimed\n', '    // funds, transfer those to Bitplus address - the funds will be returned to \n', '    // respective owners from it\n', '    function safeguard() {\n', '        if(block.number > (fundingEndBlock + 71000)) {\n', '            if (!bitplusAddress.send(this.balance)) throw;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.4;\n', '\n', '\n', '/// @title Bitplus Token (BPNT) - crowdfunding code for Bitplus Project\n', 'contract BitplusToken {\n', '    string public constant name = "Bitplus Token";\n', '    string public constant symbol = "BPNT";\n', '    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.\n', '\n', '    uint256 public constant tokenCreationRate = 1000;\n', '\n', '    // The funding cap in weis.\n', '    uint256 public constant tokenCreationCap = 25000 ether * tokenCreationRate;\n', '    uint256 public constant tokenCreationMin = 2500 ether * tokenCreationRate;\n', '\n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingEndBlock;\n', '\n', '    // The flag indicates if the contract is in Funding state.\n', '    bool public funding = true;\n', '\n', '    // Receives ETH\n', '    address public bitplusAddress;\n', '\n', '    // The current total token supply.\n', '    uint256 totalTokens;\n', '\n', '    mapping (address => uint256) balances;\n', '    \n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    \n', '    struct EarlyBackerCondition {\n', '        address backerAddress;\n', '        uint256 deposited;\n', '        uint256 agreedPercentage;\n', '        uint256 agreedEthPrice;\n', '    }\n', '    \n', '    EarlyBackerCondition[] public earlyBackers;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed _from, uint256 _value);\n', '    event EarlyBackerDeposit(address indexed _from, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function BitplusToken(uint256 _fundingStartBlock,\n', '                          uint256 _fundingEndBlock) {\n', '\n', '        address _bitplusAddress = 0x286e0060d9DBEa0231389485D455A80f14648B3c;\n', '        if (_bitplusAddress == 0) throw;\n', '        if (_fundingStartBlock <= block.number) throw;\n', '        if (_fundingEndBlock   <= _fundingStartBlock) throw;\n', '        \n', '        // special conditions for the early backers\n', '        earlyBackers.push(EarlyBackerCondition({\n', '            backerAddress: 0xa1cfc9ebdffbffe9b27d741ae04cfc2e78af527a,\n', '            deposited: 0,\n', '            agreedPercentage: 1000,\n', '            agreedEthPrice: 250 ether\n', '        }));\n', '        \n', '        // conditions for the company / developers\n', '        earlyBackers.push(EarlyBackerCondition({\n', '            backerAddress: 0x37ef1168252f274D4cA5b558213d7294085BCA08,\n', '            deposited: 0,\n', '            agreedPercentage: 500,\n', '            agreedEthPrice: 0.1 ether\n', '        }));\n', '        \n', '        earlyBackers.push(EarlyBackerCondition({\n', '            backerAddress: 0x246604643ac38e96526b66ba91c1b2ec0c39d8de,\n', '            deposited: 0,\n', '            agreedPercentage: 500,\n', '            agreedEthPrice: 0.1 ether\n', '        }));        \n', '        \n', '        bitplusAddress = _bitplusAddress;\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingEndBlock = _fundingEndBlock;\n', '    }\n', '\n', "    /// @notice Transfer `_value` BPNT tokens from sender's account\n", '    /// `msg.sender` to provided account address `_to`.\n', '    /// @notice This function is disabled during the funding.\n', '    /// @dev Required state: Operational\n', '    /// @param _to The address of the tokens recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        // Abort if not in Operational state.\n', '        if (funding) throw;\n', '\n', '        var senderBalance = balances[msg.sender];\n', '        if (senderBalance >= _value && _value > 0) {\n', '            senderBalance -= _value;\n', '            balances[msg.sender] = senderBalance;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function transferFrom(\n', '         address _from,\n', '         address _to,\n', '         uint256 _amount\n', '     ) returns (bool success) {\n', '        // Abort if not in Operational state.\n', '        if (funding) throw;         \n', '         \n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '    }    \n', '\n', '    function totalSupply() external constant returns (uint256) {\n', '        return totalTokens;\n', '    }\n', '\n', '    function balanceOf(address _owner) external constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice Create tokens when funding is active.\n', '    /// @dev Required state: Funding Active\n', '    /// @dev State transition: -> Funding Success (only if cap reached)\n', '    function create() payable external {\n', '        // Abort if not in Funding Active state.\n', '        // The checks are split (instead of using or operator) because it is\n', '        // cheaper this way.\n', '        if (!funding) throw;\n', '        if (block.number < fundingStartBlock) throw;\n', '        if (block.number > fundingEndBlock) throw;\n', '\n', '        // Do not allow creating 0 tokens.\n', '        if (msg.value == 0) throw;\n', '        \n', '        bool isEarlyBacker = false;\n', '        \n', '        for (uint i = 0; i < earlyBackers.length; i++) {\n', '            if(earlyBackers[i].backerAddress == msg.sender) {\n', '                earlyBackers[i].deposited += msg.value;\n', '                isEarlyBacker = true;\n', '                EarlyBackerDeposit(msg.sender, msg.value);\n', '            }\n', '        }\n', '        \n', '        \n', '        if(!isEarlyBacker) {\n', '            // do not allow to create more then cap tokens\n', '            if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)\n', '                throw;\n', '\n', '            var numTokens = msg.value * tokenCreationRate;\n', '            totalTokens += numTokens;\n', '\n', '            // Assign new tokens to the sender\n', '            balances[msg.sender] += numTokens;\n', '            \n', '            // Log token creation event\n', '            Transfer(0, msg.sender, numTokens);            \n', '        }\n', '    }\n', '\n', '    /// @notice Finalize crowdfunding\n', '    /// @dev If cap was reached or crowdfunding has ended then:\n', '    /// create BPNT for the early backers,\n', '    /// transfer ETH to the Bitplus address.\n', '    /// @dev Required state: Funding Success\n', '    /// @dev State transition: -> Operational Normal\n', '    function finalize() external {\n', '        // Abort if not in Funding Success state.\n', '        if (!funding) throw;\n', '        if ((block.number <= fundingEndBlock ||\n', '             totalTokens < tokenCreationMin) &&\n', '             totalTokens < tokenCreationCap) throw;\n', '\n', '        // Switch to Operational state. This is the only place this can happen.\n', '        funding = false;\n', '        // Transfer ETH to the Bitplus address.\n', '        if (!bitplusAddress.send(this.balance)) throw;\n', '        \n', '        for (uint i = 0; i < earlyBackers.length; i++) {\n', '            if(earlyBackers[i].deposited != uint256(0)) {\n', '                uint256 percentage = (earlyBackers[i].deposited * earlyBackers[i].agreedPercentage / earlyBackers[i].agreedEthPrice);\n', '                uint256 additionalTokens = totalTokens * percentage / (10000 - percentage);\n', '                address backerAddr = earlyBackers[i].backerAddress;\n', '                balances[backerAddr] = additionalTokens;\n', '                totalTokens += additionalTokens;\n', '                Transfer(0, backerAddr, additionalTokens);\n', '\t\t\t}\n', '        }\n', '    }\n', '\n', '    /// @notice Get back the ether sent during the funding in case the funding\n', '    /// has not reached the minimum level.\n', '    /// @dev Required state: Funding Failure\n', '    function refund() external {\n', '        // Abort if not in Funding Failure state.\n', '        if (!funding) throw;\n', '        if (block.number <= fundingEndBlock) throw;\n', '        if (totalTokens >= tokenCreationMin) throw;\n', '        \n', '        bool isEarlyBacker = false;\n', '        uint256 ethValue;\n', '        for (uint i = 0; i < earlyBackers.length; i++) {\n', '            if(earlyBackers[i].backerAddress == msg.sender) {\n', '                isEarlyBacker = true;\n', '                ethValue = earlyBackers[i].deposited;\n', '                if (ethValue == 0) throw;\n', '            }\n', '        }\n', '\n', '        if(!isEarlyBacker) {\n', '            var bpntValue = balances[msg.sender];\n', '            if (bpntValue == 0) throw;\n', '            balances[msg.sender] = 0;\n', '            totalTokens -= bpntValue;\n', '            ethValue = bpntValue / tokenCreationRate;\n', '        }\n', '        \n', '        Refund(msg.sender, ethValue);\n', '        if (!msg.sender.send(ethValue)) throw;\n', '    }\n', '    \n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    // Just a safeguard for people who might invest and then loose the key\n', '    // If 2 weeks after an unsuccessful end of the campaign there are unclaimed\n', '    // funds, transfer those to Bitplus address - the funds will be returned to \n', '    // respective owners from it\n', '    function safeguard() {\n', '        if(block.number > (fundingEndBlock + 71000)) {\n', '            if (!bitplusAddress.send(this.balance)) throw;\n', '        }\n', '    }\n', '}']