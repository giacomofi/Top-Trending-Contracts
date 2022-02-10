['pragma solidity ^0.4.0;\n', 'contract MyToken {\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MyToken(\n', '        \n', '        ) {\n', '        balanceOf[msg.sender] = 210000;              // Give the creator all initial tokens\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '    }\n', '}']
['pragma solidity ^0.4.0;\n', 'contract MyToken {\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MyToken(\n', '        \n', '        ) {\n', '        balanceOf[msg.sender] = 210000;              // Give the creator all initial tokens\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '    }\n', '}']
