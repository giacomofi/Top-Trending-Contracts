['pragma solidity 0.4.21;\n', '\n', '/**\n', '* @title SafeMath by OpenZeppelin (commit: 5daaf60)\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals = 18;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _from, uint256 _value);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens assigned to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) \n', '    public \n', '    {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                     // Give the creator all initial tokens\n', '        name = tokenName;                                       // Set the name for display purposes\n', '        symbol = tokenSymbol;                                   // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     * Send `_value` tokens to `_to` from your account\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);        \n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // To prevent attack vectors problem discussed in the following comment\n', '        // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     * Remove `_value` tokens from the system irreversibly\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); // Subtract from the sender\n', '        totalSupply = SafeMath.sub(totalSupply, _value);                     // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    // ------- View functions -------\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }   \n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']
['pragma solidity 0.4.21;\n', '\n', '/**\n', '* @title SafeMath by OpenZeppelin (commit: 5daaf60)\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    uint8 public decimals = 18;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _from, uint256 _value);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens assigned to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) \n', '    public \n', '    {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                     // Give the creator all initial tokens\n', '        name = tokenName;                                       // Set the name for display purposes\n', '        symbol = tokenSymbol;                                   // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     * Send `_value` tokens to `_to` from your account\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);        \n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // To prevent attack vectors problem discussed in the following comment\n', '        // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     * Remove `_value` tokens from the system irreversibly\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); // Subtract from the sender\n', '        totalSupply = SafeMath.sub(totalSupply, _value);                     // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    // ------- View functions -------\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }   \n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']