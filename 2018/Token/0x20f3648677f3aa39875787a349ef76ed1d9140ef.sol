['pragma solidity ^0.4.20;\n', '\n', 'contract MYCCToken {\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MYCCToken(\n', '        uint256 initialSupply\n', '        ) public {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                    // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'contract MYCCToken {\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MYCCToken(\n', '        uint256 initialSupply\n', '        ) public {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                    // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        return true;\n', '    }\n', '}']
