['pragma solidity ^0.4.16; \n', '\n', 'contract IndiVod {\n', '    /* Public variables of the token */\n', "    string public standard = 'Token 0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public initialSupply;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function IndiVod() public {\n', '\n', '         initialSupply = 1000000000;\n', '         name ="IndiVod";\n', '        decimals = 18;\n', '         symbol = "IVT";\n', '        \n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '                                   \n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public {\n', '        if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '      \n', '    }\n', '\n', '   \n', '\n', '    \n', '\n', '   \n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () public{\n', '        revert();     // Prevents accidental sending of ether\n', '    }\n', '}']