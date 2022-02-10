['pragma solidity ^0.4.13;\n', '\n', 'contract latinotokenrecipiente { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract latinotoken {\n', '    /* Public variables of the token */\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function latinotoken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Send `_value` tokens to `_to` from your account\n', '    /// @param _to The address of the recipient\n', '    /// @param _value the amount to send\n', '    function transfer(address _to, uint256 _value) {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /// @notice Send `_value` tokens to `_to` in behalf of `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value the amount to send\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require (_value < allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value the max amount they can spend\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value the max amount they can spend\n', '    /// @param _extraData some extra information to send to the approved contract\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        latinotokenrecipiente spender = latinotokenrecipiente(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    /// @notice Remove `_value` tokens from the system irreversibly\n', '    /// @param _value the amount of money to burn\n', '    function burn(uint256 _value) returns (bool success) {\n', '        require (balanceOf[msg.sender] > _value);            // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;                      // Subtract from the sender\n', '        totalSupply -= _value;                                // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract latinotokenrecipiente { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract latinotoken {\n', '    /* Public variables of the token */\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function latinotoken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Send `_value` tokens to `_to` from your account\n', '    /// @param _to The address of the recipient\n', '    /// @param _value the amount to send\n', '    function transfer(address _to, uint256 _value) {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /// @notice Send `_value` tokens to `_to` in behalf of `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value the amount to send\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require (_value < allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value the max amount they can spend\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value the max amount they can spend\n', '    /// @param _extraData some extra information to send to the approved contract\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        latinotokenrecipiente spender = latinotokenrecipiente(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    /// @notice Remove `_value` tokens from the system irreversibly\n', '    /// @param _value the amount of money to burn\n', '    function burn(uint256 _value) returns (bool success) {\n', '        require (balanceOf[msg.sender] > _value);            // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;                      // Subtract from the sender\n', '        totalSupply -= _value;                                // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
