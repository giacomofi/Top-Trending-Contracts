['pragma solidity ^0.4.11;\n', 'contract WaykiCoin{\n', '\tmapping (address => uint256) balances;\n', '\taddress public owner;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\t// total amount of tokens\n', '    uint256 public totalSupply;\n', '\t// `allowed` tracks any extra transfer rights as in all ERC20 tokens\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    function WaykiCoin() public { \n', '        owner = msg.sender;                                         // Set owner of contract \n', '        name = "WaykiCoin";                                         // Set the name for display purposes\n', '        symbol = "WIC";                                             // Set the symbol for display purposes\n', '        decimals = 8;                                               // Amount of decimals for display purposes\n', '\t\ttotalSupply = 21000000000000000;                            // Total supply\n', '\t\tbalances[owner] = totalSupply;                              // Set owner balance equal totalsupply \n', '    }\n', '\t\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '\t\t return balances[_owner];\n', '\t}\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '\t    require(_value > 0 );                                      // Check send token value > 0;\n', '\t\trequire(balances[msg.sender] >= _value);                    // Check if the sender has enough\n', '        require(balances[_to] + _value > balances[_to]);           // Check for overflows\t\t\t\t\t\t\t\t\t\t\t\n', '\t\tbalances[msg.sender] -= _value;                          // Subtract from the sender\n', '\t\tbalances[_to] += _value;                                 // Add the same to the recipient                       \n', '\t\t \n', '\t\tTransfer(msg.sender, _to, _value); \t\t\t\t\t\t\t// Notify anyone listening that this transfer took place\n', '\t\treturn true;      \n', '\t}\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\t  \n', '\t    require(balances[_from] >= _value);                 // Check if the sender has enough\n', '        require(balances[_to] + _value >= balances[_to]);   // Check for overflows\n', '        require(_value <= allowed[_from][msg.sender]);      // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the sender\n', '        balances[_to] += _value;                           // Add the same to the recipient\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '\t}\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '\t\trequire(balances[msg.sender] >= _value);\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '\t\n', '\t}\n', '\t\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '\t}\n', '\t\n', '\t/* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () private {\n', '        revert();     // Prevents accidental sending of ether\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.11;\n', 'contract WaykiCoin{\n', '\tmapping (address => uint256) balances;\n', '\taddress public owner;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\t// total amount of tokens\n', '    uint256 public totalSupply;\n', '\t// `allowed` tracks any extra transfer rights as in all ERC20 tokens\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    function WaykiCoin() public { \n', '        owner = msg.sender;                                         // Set owner of contract \n', '        name = "WaykiCoin";                                         // Set the name for display purposes\n', '        symbol = "WIC";                                             // Set the symbol for display purposes\n', '        decimals = 8;                                               // Amount of decimals for display purposes\n', '\t\ttotalSupply = 21000000000000000;                            // Total supply\n', '\t\tbalances[owner] = totalSupply;                              // Set owner balance equal totalsupply \n', '    }\n', '\t\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '\t\t return balances[_owner];\n', '\t}\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '\t    require(_value > 0 );                                      // Check send token value > 0;\n', '\t\trequire(balances[msg.sender] >= _value);                    // Check if the sender has enough\n', '        require(balances[_to] + _value > balances[_to]);           // Check for overflows\t\t\t\t\t\t\t\t\t\t\t\n', '\t\tbalances[msg.sender] -= _value;                          // Subtract from the sender\n', '\t\tbalances[_to] += _value;                                 // Add the same to the recipient                       \n', '\t\t \n', '\t\tTransfer(msg.sender, _to, _value); \t\t\t\t\t\t\t// Notify anyone listening that this transfer took place\n', '\t\treturn true;      \n', '\t}\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\t  \n', '\t    require(balances[_from] >= _value);                 // Check if the sender has enough\n', '        require(balances[_to] + _value >= balances[_to]);   // Check for overflows\n', '        require(_value <= allowed[_from][msg.sender]);      // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the sender\n', '        balances[_to] += _value;                           // Add the same to the recipient\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '\t}\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '\t\trequire(balances[msg.sender] >= _value);\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '\t\n', '\t}\n', '\t\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '\t}\n', '\t\n', '\t/* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () private {\n', '        revert();     // Prevents accidental sending of ether\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
