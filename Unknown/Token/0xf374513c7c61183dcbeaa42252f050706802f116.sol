['pragma solidity ^0.4.8;\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract MyToken {\n', '    /* Public variables of the token */\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MyToken() {\n', '        balanceOf[msg.sender] = 7000000000000;              // Give the creator all initial tokens\n', '        totalSupply = 7000000000000;                        // Update total supply\n', '        name = &#39;Scrypto&#39;;                                   // Set the name for display purposes\n', '        symbol = &#39;SCT&#39;;                                     // Set the symbol for display purposes\n', '        decimals = 6;                                       // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        require(_to != 0x0);                                 // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balanceOf[msg.sender] > _value);             // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);   // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balanceOf[_from] > _value);                 // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows\n', '        require(_value < allowance[_from][msg.sender]);     // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) returns (bool success) {\n', '        require(balanceOf[msg.sender] > _value);            // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;                    // Subtract from the sender\n', '        totalSupply -= _value;                              // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '        require(balanceOf[_from] > _value);                // Check if the sender has enough\n', '        require(_value < allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                        // Subtract from the sender\n', '        totalSupply -= _value;                             // Updates totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']