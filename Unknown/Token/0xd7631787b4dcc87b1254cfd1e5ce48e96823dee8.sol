['pragma solidity ^0.4.6;\n', '\n', 'contract Owned {\n', '\n', '    // The address of the account that is the current owner \n', '    address public owner;\n', '\n', '    // The publiser is the inital owner\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Access is restricted to the current owner\n', '     */\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transfer ownership to `_newOwner`\n', '     *\n', '     * @param _newOwner The address of the account that will become the new owner \n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', ' *\n', ' * Modified version of https://github.com/ConsenSys/Tokens that implements the \n', ' * original Token contract, an abstract contract for the full ERC 20 Token standard\n', ' */\n', 'contract StandardToken is Token {\n', '\n', '    // Token starts if the locked state restricting transfers\n', '    bool public locked;\n', '\n', '    // DCORP token balances\n', '    mapping (address => uint256) balances;\n', '\n', '    // DCORP token allowances\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '\n', '    /** \n', '     * Get balance of `_owner` \n', '     * \n', '     * @param _owner The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     * \n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough tokens\n', '        if (balances[msg.sender] < _value) { \n', '            throw;\n', '        }        \n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to])  { \n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '\n', '        // Notify listners\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     * \n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\n', '         // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough\n', '        if (balances[_from] < _value) { \n', '            throw;\n', '        }\n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to]) { \n', '            throw;\n', '        }\n', '\n', '        // Check allowance\n', '        if (_value > allowed[_from][msg.sender]) { \n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '\n', '        // Update allowance\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        // Notify listners\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * `msg.sender` approves `_spender` to spend `_value` tokens\n', '     * \n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to approve while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Update allowance\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        // Notify listners\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`\n', '     * \n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SCL (Social) token\n', ' *\n', ' * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition \n', ' * of ownership, a lock and issuing.\n', ' *\n', ' * #created 05/03/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract SCLToken is Owned, StandardToken {\n', '\n', '    // Ethereum token standaard\n', '    string public standard = "Token 0.1";\n', '\n', '    // Full name\n', '    string public name = "SOCIAL";        \n', '    \n', '    // Symbol\n', '    string public symbol = "SCL";\n', '\n', '    // No decimal points\n', '    uint8 public decimals = 8;\n', '\n', '\n', '    /**\n', '     * Starts with a total supply of zero and the creator starts with \n', '     * zero tokens (just like everyone else)\n', '     */\n', '    function SCLToken() {  \n', '        balances[msg.sender] = 0;\n', '        totalSupply = 0;\n', '        locked = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Unlocks the token irreversibly so that the transfering of value is enabled \n', '     *\n', '     * @return Whether the unlocking was successful or not\n', '     */\n', '    function unlock() onlyOwner returns (bool success)  {\n', '        locked = false;\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Issues `_value` new tokens to `_recipient` (_value < 0 guarantees that tokens are never removed)\n', '     *\n', '     * @param _recipient The address to which the tokens will be issued\n', '     * @param _value The amount of new tokens to issue\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {\n', '\n', '        // Guarantee positive \n', '        if (_value < 0) {\n', '            throw;\n', '        }\n', '\n', '        // Create tokens\n', '        balances[_recipient] += _value;\n', '        totalSupply += _value;\n', '\n', '        // Notify listners\n', '        Transfer(0, owner, _value);\n', '        Transfer(owner, _recipient, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Prevents accidental sending of ether\n', '     */\n', '    function () {\n', '        throw;\n', '    }\n', '}']
['pragma solidity ^0.4.6;\n', '\n', 'contract Owned {\n', '\n', '    // The address of the account that is the current owner \n', '    address public owner;\n', '\n', '    // The publiser is the inital owner\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Access is restricted to the current owner\n', '     */\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Transfer ownership to `_newOwner`\n', '     *\n', '     * @param _newOwner The address of the account that will become the new owner \n', '     */\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', ' *\n', ' * Modified version of https://github.com/ConsenSys/Tokens that implements the \n', ' * original Token contract, an abstract contract for the full ERC 20 Token standard\n', ' */\n', 'contract StandardToken is Token {\n', '\n', '    // Token starts if the locked state restricting transfers\n', '    bool public locked;\n', '\n', '    // DCORP token balances\n', '    mapping (address => uint256) balances;\n', '\n', '    // DCORP token allowances\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '\n', '    /** \n', '     * Get balance of `_owner` \n', '     * \n', '     * @param _owner The address from which the balance will be retrieved\n', '     * @return The balance\n', '     */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `msg.sender`\n', '     * \n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough tokens\n', '        if (balances[msg.sender] < _value) { \n', '            throw;\n', '        }        \n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to])  { \n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '\n', '        // Notify listners\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '     * \n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value The amount of token to be transferred\n', '     * @return Whether the transfer was successful or not\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\n', '         // Unable to transfer while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Check if the sender has enough\n', '        if (balances[_from] < _value) { \n', '            throw;\n', '        }\n', '\n', '        // Check for overflows\n', '        if (balances[_to] + _value < balances[_to]) { \n', '            throw;\n', '        }\n', '\n', '        // Check allowance\n', '        if (_value > allowed[_from][msg.sender]) { \n', '            throw;\n', '        }\n', '\n', '        // Transfer tokens\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '\n', '        // Update allowance\n', '        allowed[_from][msg.sender] -= _value;\n', '\n', '        // Notify listners\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * `msg.sender` approves `_spender` to spend `_value` tokens\n', '     * \n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @param _value The amount of tokens to be approved for transfer\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        // Unable to approve while still locked\n', '        if (locked) {\n', '            throw;\n', '        }\n', '\n', '        // Update allowance\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        // Notify listners\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /** \n', '     * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`\n', '     * \n', '     * @param _owner The address of the account owning tokens\n', '     * @param _spender The address of the account able to transfer the tokens\n', '     * @return Amount of remaining tokens allowed to spent\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SCL (Social) token\n', ' *\n', ' * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition \n', ' * of ownership, a lock and issuing.\n', ' *\n', ' * #created 05/03/2017\n', ' * #author Frank Bonnet\n', ' */\n', 'contract SCLToken is Owned, StandardToken {\n', '\n', '    // Ethereum token standaard\n', '    string public standard = "Token 0.1";\n', '\n', '    // Full name\n', '    string public name = "SOCIAL";        \n', '    \n', '    // Symbol\n', '    string public symbol = "SCL";\n', '\n', '    // No decimal points\n', '    uint8 public decimals = 8;\n', '\n', '\n', '    /**\n', '     * Starts with a total supply of zero and the creator starts with \n', '     * zero tokens (just like everyone else)\n', '     */\n', '    function SCLToken() {  \n', '        balances[msg.sender] = 0;\n', '        totalSupply = 0;\n', '        locked = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Unlocks the token irreversibly so that the transfering of value is enabled \n', '     *\n', '     * @return Whether the unlocking was successful or not\n', '     */\n', '    function unlock() onlyOwner returns (bool success)  {\n', '        locked = false;\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Issues `_value` new tokens to `_recipient` (_value < 0 guarantees that tokens are never removed)\n', '     *\n', '     * @param _recipient The address to which the tokens will be issued\n', '     * @param _value The amount of new tokens to issue\n', '     * @return Whether the approval was successful or not\n', '     */\n', '    function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {\n', '\n', '        // Guarantee positive \n', '        if (_value < 0) {\n', '            throw;\n', '        }\n', '\n', '        // Create tokens\n', '        balances[_recipient] += _value;\n', '        totalSupply += _value;\n', '\n', '        // Notify listners\n', '        Transfer(0, owner, _value);\n', '        Transfer(owner, _recipient, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Prevents accidental sending of ether\n', '     */\n', '    function () {\n', '        throw;\n', '    }\n', '}']