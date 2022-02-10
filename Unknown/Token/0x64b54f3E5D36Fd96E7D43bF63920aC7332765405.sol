['pragma solidity ^0.4.13;\n', '\n', '\n', 'contract Emoji {\n', '    /* Public variables of the token */\n', '    string public name;\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '   \n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function Emoji () {\n', '        totalSupply = 600600600600600600600600600;                        // Update total supply\n', '        name = "Emoji";                                   // Set the name for display purposes\n', '        symbol = ":)";                               // Set the symbol for display purposes\n', '        decimals = 3;                            // Amount of decimals for display purposes\n', '        balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens\n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Send `_value` tokens to `_to` from your account\n', '    /// @param _to The address of the recipient\n', '    /// @param _value the amount to send\n', '    function transfer(address _to, uint256 _value) {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /// @notice Send `_value` tokens to `_to` in behalf of `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value the amount to send\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require (_value < allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value the max amount they can spend\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '}']