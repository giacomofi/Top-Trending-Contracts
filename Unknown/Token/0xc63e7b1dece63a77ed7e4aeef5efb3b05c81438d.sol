['pragma solidity ^0.4.8;\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract FuckToken {\n', '    /* Public variables of the FUCK token */\n', '    string public standard = &#39;FUCK 0.1&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* Creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* Generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to me */\n', '    function FuckToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens on my behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance\n', '        balanceOf[_from] -= _value;                           // Subtract from the sender\n', '        balanceOf[_to] += _value;                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;                      // Subtract from the sender\n', '        totalSupply -= _value;                                // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '        if (balanceOf[_from] < _value) throw;                // Check if the sender has enough\n', '        if (_value > allowance[_from][msg.sender]) throw;    // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        totalSupply -= _value;                               // Updates totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    function giveBlockReward() {\n', '        balanceOf[block.coinbase] += 70000;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.8;\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract FuckToken {\n', '    /* Public variables of the FUCK token */\n', "    string public standard = 'FUCK 0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* Creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* Generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to me */\n', '    function FuckToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens on my behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance\n', '        balanceOf[_from] -= _value;                           // Subtract from the sender\n', '        balanceOf[_to] += _value;                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;                      // Subtract from the sender\n', '        totalSupply -= _value;                                // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '        if (balanceOf[_from] < _value) throw;                // Check if the sender has enough\n', '        if (_value > allowance[_from][msg.sender]) throw;    // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        totalSupply -= _value;                               // Updates totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    function giveBlockReward() {\n', '        balanceOf[block.coinbase] += 70000;\n', '    }\n', '\n', '}']
