['pragma solidity ^0.4.8;\n', 'contract Ownable {\n', '  address public owner;\n', '  \n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '  \n', '  function kill() onlyOwner {\n', '     selfdestruct(owner);\n', '  }\n', '}\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract GCCToken is Ownable{\n', '    /* Public variables of the token */\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function () {\n', '        throw;\n', '    }\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function GCCToken(\n', '        ) {\n', '        balanceOf[msg.sender] = 210000000000000000;              // Give the creator all initial tokens\n', '        totalSupply = 210000000000000000;                        // Update total supply\n', '        name = "GCC";                                   // Set the name for display purposes\n', '        symbol = "GCC";                              // Set the symbol for display purposes\n', '        decimals = 8;                            // Amount of decimals for display purposes\n', '        \n', '    }\n', '    \n', '   \n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance\n', '        balanceOf[_from] -= _value;                           // Subtract from the sender\n', '        balanceOf[_to] += _value;                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', 'contract Ownable {\n', '  address public owner;\n', '  \n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '  \n', '  function kill() onlyOwner {\n', '     selfdestruct(owner);\n', '  }\n', '}\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract GCCToken is Ownable{\n', '    /* Public variables of the token */\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function () {\n', '        throw;\n', '    }\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function GCCToken(\n', '        ) {\n', '        balanceOf[msg.sender] = 210000000000000000;              // Give the creator all initial tokens\n', '        totalSupply = 210000000000000000;                        // Update total supply\n', '        name = "GCC";                                   // Set the name for display purposes\n', '        symbol = "GCC";                              // Set the symbol for display purposes\n', '        decimals = 8;                            // Amount of decimals for display purposes\n', '        \n', '    }\n', '    \n', '   \n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance\n', '        balanceOf[_from] -= _value;                           // Subtract from the sender\n', '        balanceOf[_to] += _value;                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
