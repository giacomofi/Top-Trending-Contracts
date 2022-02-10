['pragma solidity ^0.4.16;\n', '\n', 'contract FUTokenContract {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {\n', '        totalSupply = initialSupply;\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public {\n', '        require(_to != 0x0);                                // Prevent transfer to 0x0 address.\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                    // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract FUTokenContract {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {\n', '        totalSupply = initialSupply;\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public {\n', '        require(_to != 0x0);                                // Prevent transfer to 0x0 address.\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                    // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '    }\n', '}']
