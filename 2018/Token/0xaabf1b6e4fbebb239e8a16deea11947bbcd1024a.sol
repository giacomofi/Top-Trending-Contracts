['pragma solidity ^0.4.18;\n', '\n', '\n', '// -----------------------------------------------------------------------\n', '// An ERC20 standard\n', 'contract ERC20 {\n', '    // the total token supply\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'interface TokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', '\n', 'contract RetailLoyaltySystemBase is ERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8  public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '\n', '    // Balances\n', '    mapping (address => uint256) balances;\n', '    // Allowances\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '\n', '    // ----- Events -----\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constructor function\n', '     */\n', '    function RetailLoyaltySystemBase(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = _decimals;\n', '\n', '        totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal returns(bool) {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        // Subtract from the sender\n', '        balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        return _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_value <= allowances[_from][msg.sender]);     // Check allowance\n', '        allowances[_from][msg.sender] -= _value;\n', '        return _transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {\n', '        if (approve(_spender, _value)) {\n', '            TokenRecipient spender = TokenRecipient(_spender);\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns(bool) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns(bool) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowances[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowances[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowances[_spender] == 0. To increment\n', '     * allowances value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        // Check for overflows\n', '        require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);\n', '\n', '        allowances[msg.sender][_spender] += _addedValue;\n', '        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowances[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowances[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowances[msg.sender][_spender] = oldValue - _subtractedValue;\n', '        }\n', '        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract RetailLoyaltySystemToken is RetailLoyaltySystemBase {\n', '\n', '    function RetailLoyaltySystemToken() RetailLoyaltySystemBase(500000000, "RST Token", "RST", 18) public {\n', '\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', '// -----------------------------------------------------------------------\n', '// An ERC20 standard\n', 'contract ERC20 {\n', '    // the total token supply\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'interface TokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', '\n', 'contract RetailLoyaltySystemBase is ERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8  public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '\n', '    // Balances\n', '    mapping (address => uint256) balances;\n', '    // Allowances\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '\n', '    // ----- Events -----\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constructor function\n', '     */\n', '    function RetailLoyaltySystemBase(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = _decimals;\n', '\n', '        totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal returns(bool) {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        // Subtract from the sender\n', '        balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        return _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_value <= allowances[_from][msg.sender]);     // Check allowance\n', '        allowances[_from][msg.sender] -= _value;\n', '        return _transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {\n', '        if (approve(_spender, _value)) {\n', '            TokenRecipient spender = TokenRecipient(_spender);\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns(bool) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns(bool) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowances[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowances[_spender] == 0. To increment\n', '     * allowances value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        // Check for overflows\n', '        require(allowances[msg.sender][_spender] + _addedValue > allowances[msg.sender][_spender]);\n', '\n', '        allowances[msg.sender][_spender] += _addedValue;\n', '        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowances[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowances[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowances[msg.sender][_spender] = oldValue - _subtractedValue;\n', '        }\n', '        Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract RetailLoyaltySystemToken is RetailLoyaltySystemBase {\n', '\n', '    function RetailLoyaltySystemToken() RetailLoyaltySystemBase(500000000, "RST Token", "RST", 18) public {\n', '\n', '    }\n', '}']
