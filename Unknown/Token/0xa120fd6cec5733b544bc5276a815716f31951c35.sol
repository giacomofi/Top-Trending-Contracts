['/*\n', 'Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '*/\n', '\n', 'pragma solidity ^0.4.2;\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.2;\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    function transfer(address _to, uint256 _value);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    function transferFrom(address _from, address _to, uint256 _value);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'pragma solidity ^0.4.2;\n', '\n', 'contract Owned {\n', '\n', '\taddress owner;\n', '\n', '\tfunction Owned() {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyOwner {\n', '        if (msg.sender != owner)\n', '            throw;\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract AliceToken is Token, Owned {\n', '\n', '    string public name = "Alice Token";\n', '    uint8 public decimals = 2;\n', '    string public symbol = "ALT";\n', "    string public version = 'ALT 1.0';\n", '\n', '\n', '    function transfer(address _to, uint256 _value) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '        } else { throw; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '        } else { throw; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function mint(address _to, uint256 _value) onlyOwner {\n', '        if (totalSupply + _value < totalSupply) throw;\n', '            totalSupply += _value;\n', '            balances[_to] += _value;\n', '\n', '            MintEvent(_to, _value);\n', '    }\n', '\n', '    function destroy(address _from, uint256 _value) onlyOwner {\n', '        if (balances[_from] < _value || _value < 0) throw;\n', '            totalSupply -= _value;\n', '            balances[_from] -= _value;\n', '\n', '            DestroyEvent(_from, _value);\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    event MintEvent(address indexed to, uint value);\n', '    event DestroyEvent(address indexed from, uint value);\n', '}']