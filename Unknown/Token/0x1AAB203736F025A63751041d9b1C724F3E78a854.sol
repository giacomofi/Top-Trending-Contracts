['contract SCUDO {\n', '    /* Public variables of the token */\n', "    string public standard = 'Token 0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public initialSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function SCUDO() {\n', '\n', '         initialSupply = 50000000;\n', '         name ="SCUDO";\n', '        decimals = 2;\n', '         symbol = "SCUDO";\n', '        \n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        uint256 totalSupply = initialSupply;                        // Update total supply\n', '                                   \n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '      \n', '    }\n', '\n', '   \n', '\n', '    \n', '\n', '   \n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () {\n', '        throw;     // Prevents accidental sending of ether\n', '    }\n', '}']