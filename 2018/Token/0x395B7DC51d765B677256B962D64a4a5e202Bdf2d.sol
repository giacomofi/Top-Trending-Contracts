['pragma solidity ^0.4.0;\n', '   \n', '\n', '\n', 'contract PacBall{\n', '    /* Public variables of the token */\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public initialSupply;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function Token() {\n', '\n', '         initialSupply = 10000;\n', '         name ="PacBall";\n', '        decimals = 5;\n', '         symbol = "PBC";\n', '        \n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '                                   \n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '      \n', '    }\n', '\n', '   \n', '\n', '    \n', '\n', '   \n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () {\n', '        throw;     // Prevents accidental sending of ether\n', '    }\n', '}']