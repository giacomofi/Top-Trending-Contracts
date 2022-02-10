['pragma solidity 0.4.8;\n', '\n', 'contract madrachip {\n', '    /* some init vars */\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    \n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', 'function madrachip (uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {\n', '    balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '    name = tokenName;                                   // Set the name for display purposes\n', '    symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '}\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '    }\n', '}']