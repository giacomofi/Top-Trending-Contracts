['pragma solidity ^0.4.1;\n', '\n', 'contract tokenRecipient { \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); \n', '}\n', '\n', 'contract MyToken {\n', '    /* Public variables of the token */\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MyToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () {\n', '        throw;     // Prevents accidental sending of ether\n', '    }\n', '    \n', '}']