['pragma solidity ^0.4.23;\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'contract owned {\n', '\n', ' \n', '\n', '    address public owner;\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    function owned() public {\n', '\n', ' \n', '\n', '        owner = msg.sender;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    modifier onlyOwner {\n', '\n', ' \n', '\n', '        require(msg.sender == owner);\n', '\n', ' \n', '\n', '        _;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '\n', ' \n', '\n', '        owner = newOwner;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', '}\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'contract TokenERC20 {\n', '\n', ' \n', '\n', '    // Public variables of the token\n', '\n', ' \n', '\n', '    string public name = "Yumerium Token";\n', '\n', ' \n', '\n', '    string public symbol = "YUM";\n', '\n', ' \n', '\n', '    uint8 public decimals = 8;\n', '\n', ' \n', '\n', '    uint256 public totalSupply = 808274854 * 10 ** uint256(decimals);\n', '\n', ' \n', '\n', ' \n', '\n', '    // This creates an array with all balances\n', '\n', ' \n', '\n', '    mapping (address => uint256) public balanceOf;\n', '\n', ' \n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', ' \n', '    \n', ' \n', '\n', ' \n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '\n', ' \n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    // This notifies clients about the amount burnt\n', '\n', ' \n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Constrctor function\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    \n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Internal transfer, only can be called by this contract\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', ' \n', '\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '\n', ' \n', '\n', '        require(_to != 0x0);\n', '\n', ' \n', '\n', '        // Check if the sender has enough\n', '\n', ' \n', '\n', '        require(balanceOf[_from] >= _value);\n', '\n', ' \n', '\n', '        // Check for overflows\n', '\n', ' \n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', ' \n', '\n', '        // Save this for an assertion in the future\n', '\n', ' \n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', ' \n', '\n', '        // Subtract from the sender\n', '\n', ' \n', '\n', '        balanceOf[_from] -= _value;\n', '\n', ' \n', '\n', '        // Add the same to the recipient\n', '\n', ' \n', '\n', '        balanceOf[_to] += _value;\n', '\n', ' \n', '\n', '        Transfer(_from, _to, _value);\n', '\n', ' \n', '\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '\n', ' \n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Transfer tokens\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Send `_value` tokens to `_to` from your account\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _to The address of the recipient\n', '\n', ' \n', '\n', '     * @param _value the amount to send\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '\n', ' \n', '\n', '        _transfer(msg.sender, _to, _value);\n', '\n', ' \n', '\n', '    }\n', '    \n', '    \n', '    \n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Transfer tokens from other address\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _from The address of the sender\n', '\n', ' \n', '\n', '     * @param _to The address of the recipient\n', '\n', ' \n', '\n', '     * @param _value the amount to send\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\n', ' \n', '\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\n', ' \n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', ' \n', '\n', '        _transfer(_from, _to, _value);\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Set allowance for other address\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _spender The address authorized to spend\n', '\n', ' \n', '\n', '     * @param _value the max amount they can spend\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function approve(address _spender, uint256 _value) public\n', '\n', ' \n', '\n', '        returns (bool success) {\n', '\n', ' \n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Set allowance for other address and notify\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _spender The address authorized to spend\n', '\n', ' \n', '\n', '     * @param _value the max amount they can spend\n', '\n', ' \n', '\n', '     * @param _extraData some extra information to send to the approved contract\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '\n', ' \n', '\n', '        public\n', '\n', ' \n', '\n', '        returns (bool success) {\n', '\n', ' \n', '\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', ' \n', '\n', '        if (approve(_spender, _value)) {\n', '\n', ' \n', '\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\n', ' \n', '\n', '            return true;\n', '\n', ' \n', '\n', '        }\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Destroy tokens\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Remove `_value` tokens from the system irreversibly\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _value the amount of money to burn\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '\n', ' \n', '\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', ' \n', '\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '\n', ' \n', '\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '\n', ' \n', '\n', '        Burn(msg.sender, _value);\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Destroy tokens from other account\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _from the address of the sender\n', '\n', ' \n', '\n', '     * @param _value the amount of money to burn\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', ' \n', '\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '\n', ' \n', '\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '\n', ' \n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '\n', ' \n', '\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '\n', ' \n', '\n', '        totalSupply -= _value;                              // Update totalSupply\n', '\n', ' \n', '\n', '        Burn(_from, _value);\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', '}\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '/******************************************/\n', '\n', ' \n', '\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '\n', ' \n', '\n', '/******************************************/\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'contract Yumerium is owned, TokenERC20 {\n', '\n', '    address public saleAddress;\n', '    \n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    \n', '\n', '    event Buy(address indexed to, uint256 value);\n', '\n', '    \n', '\n', '    event Sell(address indexed from, uint256 value);\n', '\n', '    event Sale(address indexed to, uint256 value);\n', ' \n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '\n', ' \n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    \n', '\n', '    function Yumerium() public {\n', '\n', '        balanceOf[this] = totalSupply; \n', '        \n', '\n', '    }\n', '    \n', '    \n', '    function sale(address _to, uint256 _value) public {\n', '        require (msg.sender == saleAddress);\n', '        require (balanceOf[this] >= _value);\n', '        \n', '        balanceOf[this] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Sale(_to, _value);\n', '        Transfer(this, _to, _value);\n', '    }\n', '    \n', '    \n', '    function privateSale(address _to, uint256 _value) onlyOwner public {\n', '        require (balanceOf[this] >= _value);\n', '        \n', '        balanceOf[this] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Sale(_to, _value);\n', '        Transfer(this, _to, _value);\n', '    }\n', '    \n', '    \n', '    \n', '    function changeSaleAddress(address _saleAddress) onlyOwner public {\n', '        saleAddress = _saleAddress;\n', '    }\n', ' \n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '\n', ' \n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', ' \n', '\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\n', ' \n', '\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '\n', ' \n', '\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '\n', ' \n', '\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '\n', ' \n', '\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '\n', ' \n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '\n', ' \n', '\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '\n', ' \n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '\n', ' \n', '\n', '    /// @param target Address to receive the tokens\n', '\n', ' \n', '\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '\n', ' \n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '\n', ' \n', '\n', '        balanceOf[target] += mintedAmount;\n', '\n', ' \n', '\n', '        totalSupply += mintedAmount;\n', '\n', ' \n', '\n', '        Transfer(0, this, mintedAmount);\n', '\n', ' \n', '\n', '        Transfer(this, target, mintedAmount);\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '\n', ' \n', '\n', '    /// @param target Address to be frozen\n', '\n', ' \n', '\n', '    /// @param freeze either to freeze it or not\n', '\n', ' \n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '\n', ' \n', '\n', '        frozenAccount[target] = freeze;\n', '\n', ' \n', '\n', '        FrozenFunds(target, freeze);\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', '\n', '    \n', '\n', '    \n', '\n', '    function sell(uint256 amount) payable public {\n', '\n', '        _transfer(msg.sender, owner, amount);\n', '\n', '\n', '        Sell(msg.sender, amount);\n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '}']
['pragma solidity ^0.4.23;\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'contract owned {\n', '\n', ' \n', '\n', '    address public owner;\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    function owned() public {\n', '\n', ' \n', '\n', '        owner = msg.sender;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    modifier onlyOwner {\n', '\n', ' \n', '\n', '        require(msg.sender == owner);\n', '\n', ' \n', '\n', '        _;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '\n', ' \n', '\n', '        owner = newOwner;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', '}\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'contract TokenERC20 {\n', '\n', ' \n', '\n', '    // Public variables of the token\n', '\n', ' \n', '\n', '    string public name = "Yumerium Token";\n', '\n', ' \n', '\n', '    string public symbol = "YUM";\n', '\n', ' \n', '\n', '    uint8 public decimals = 8;\n', '\n', ' \n', '\n', '    uint256 public totalSupply = 808274854 * 10 ** uint256(decimals);\n', '\n', ' \n', '\n', ' \n', '\n', '    // This creates an array with all balances\n', '\n', ' \n', '\n', '    mapping (address => uint256) public balanceOf;\n', '\n', ' \n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', ' \n', '    \n', ' \n', '\n', ' \n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '\n', ' \n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    // This notifies clients about the amount burnt\n', '\n', ' \n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Constrctor function\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    \n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Internal transfer, only can be called by this contract\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', ' \n', '\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '\n', ' \n', '\n', '        require(_to != 0x0);\n', '\n', ' \n', '\n', '        // Check if the sender has enough\n', '\n', ' \n', '\n', '        require(balanceOf[_from] >= _value);\n', '\n', ' \n', '\n', '        // Check for overflows\n', '\n', ' \n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', ' \n', '\n', '        // Save this for an assertion in the future\n', '\n', ' \n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\n', ' \n', '\n', '        // Subtract from the sender\n', '\n', ' \n', '\n', '        balanceOf[_from] -= _value;\n', '\n', ' \n', '\n', '        // Add the same to the recipient\n', '\n', ' \n', '\n', '        balanceOf[_to] += _value;\n', '\n', ' \n', '\n', '        Transfer(_from, _to, _value);\n', '\n', ' \n', '\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '\n', ' \n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Transfer tokens\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Send `_value` tokens to `_to` from your account\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _to The address of the recipient\n', '\n', ' \n', '\n', '     * @param _value the amount to send\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '\n', ' \n', '\n', '        _transfer(msg.sender, _to, _value);\n', '\n', ' \n', '\n', '    }\n', '    \n', '    \n', '    \n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Transfer tokens from other address\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _from The address of the sender\n', '\n', ' \n', '\n', '     * @param _to The address of the recipient\n', '\n', ' \n', '\n', '     * @param _value the amount to send\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '\n', ' \n', '\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\n', ' \n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', ' \n', '\n', '        _transfer(_from, _to, _value);\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Set allowance for other address\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _spender The address authorized to spend\n', '\n', ' \n', '\n', '     * @param _value the max amount they can spend\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function approve(address _spender, uint256 _value) public\n', '\n', ' \n', '\n', '        returns (bool success) {\n', '\n', ' \n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Set allowance for other address and notify\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _spender The address authorized to spend\n', '\n', ' \n', '\n', '     * @param _value the max amount they can spend\n', '\n', ' \n', '\n', '     * @param _extraData some extra information to send to the approved contract\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '\n', ' \n', '\n', '        public\n', '\n', ' \n', '\n', '        returns (bool success) {\n', '\n', ' \n', '\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', ' \n', '\n', '        if (approve(_spender, _value)) {\n', '\n', ' \n', '\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\n', ' \n', '\n', '            return true;\n', '\n', ' \n', '\n', '        }\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Destroy tokens\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Remove `_value` tokens from the system irreversibly\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _value the amount of money to burn\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '\n', ' \n', '\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', ' \n', '\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '\n', ' \n', '\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '\n', ' \n', '\n', '        Burn(msg.sender, _value);\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /**\n', '\n', ' \n', '\n', '     * Destroy tokens from other account\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '\n', ' \n', '\n', '     *\n', '\n', ' \n', '\n', '     * @param _from the address of the sender\n', '\n', ' \n', '\n', '     * @param _value the amount of money to burn\n', '\n', ' \n', '\n', '     */\n', '\n', ' \n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '\n', ' \n', '\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '\n', ' \n', '\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '\n', ' \n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '\n', ' \n', '\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '\n', ' \n', '\n', '        totalSupply -= _value;                              // Update totalSupply\n', '\n', ' \n', '\n', '        Burn(_from, _value);\n', '\n', ' \n', '\n', '        return true;\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', '}\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '/******************************************/\n', '\n', ' \n', '\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '\n', ' \n', '\n', '/******************************************/\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', 'contract Yumerium is owned, TokenERC20 {\n', '\n', '    address public saleAddress;\n', '    \n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    \n', '\n', '    event Buy(address indexed to, uint256 value);\n', '\n', '    \n', '\n', '    event Sell(address indexed from, uint256 value);\n', '\n', '    event Sale(address indexed to, uint256 value);\n', ' \n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '\n', ' \n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    \n', '\n', '    function Yumerium() public {\n', '\n', '        balanceOf[this] = totalSupply; \n', '        \n', '\n', '    }\n', '    \n', '    \n', '    function sale(address _to, uint256 _value) public {\n', '        require (msg.sender == saleAddress);\n', '        require (balanceOf[this] >= _value);\n', '        \n', '        balanceOf[this] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Sale(_to, _value);\n', '        Transfer(this, _to, _value);\n', '    }\n', '    \n', '    \n', '    function privateSale(address _to, uint256 _value) onlyOwner public {\n', '        require (balanceOf[this] >= _value);\n', '        \n', '        balanceOf[this] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Sale(_to, _value);\n', '        Transfer(this, _to, _value);\n', '    }\n', '    \n', '    \n', '    \n', '    function changeSaleAddress(address _saleAddress) onlyOwner public {\n', '        saleAddress = _saleAddress;\n', '    }\n', ' \n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '\n', ' \n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', ' \n', '\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\n', ' \n', '\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '\n', ' \n', '\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '\n', ' \n', '\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '\n', ' \n', '\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '\n', ' \n', '\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '\n', ' \n', '\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '\n', ' \n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '\n', ' \n', '\n', '    /// @param target Address to receive the tokens\n', '\n', ' \n', '\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '\n', ' \n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '\n', ' \n', '\n', '        balanceOf[target] += mintedAmount;\n', '\n', ' \n', '\n', '        totalSupply += mintedAmount;\n', '\n', ' \n', '\n', '        Transfer(0, this, mintedAmount);\n', '\n', ' \n', '\n', '        Transfer(this, target, mintedAmount);\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '\n', ' \n', '\n', '    /// @param target Address to be frozen\n', '\n', ' \n', '\n', '    /// @param freeze either to freeze it or not\n', '\n', ' \n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '\n', ' \n', '\n', '        frozenAccount[target] = freeze;\n', '\n', ' \n', '\n', '        FrozenFunds(target, freeze);\n', '\n', ' \n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', '\n', '    \n', '\n', '    \n', '\n', '    function sell(uint256 amount) payable public {\n', '\n', '        _transfer(msg.sender, owner, amount);\n', '\n', '\n', '        Sell(msg.sender, amount);\n', '\n', '    }\n', '\n', ' \n', '\n', ' \n', '\n', ' \n', '\n', '}']