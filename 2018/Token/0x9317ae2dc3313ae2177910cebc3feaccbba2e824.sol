['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 6;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    address owner=msg.sender;\n', '\n', '    // This creates an array with all balances, allowances, frozen, master and admin accounts\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping(address => bool) public master;\n', '    mapping(address => bool) public admin;\n', '    \n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event unFrozenFunds(address target, bool unfrozen);\n', '    event AdminAddressAdded(address addr);\n', '    event AdminAddressRemoved(address addr);\n', '    event MasterAddressAdded(address addr);\n', '    event MasterAddressRemoved(address addr);\n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    // Setting the ownership function of this contract\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    // setting the master function of this contract\n', '     modifier onlyMaster() {\n', '     require(master[msg.sender]);\n', '    _;\n', '    }\n', '    \n', '    // setting the addition / removal of master addresses\n', '     function addAddressToMaster(address addr) onlyOwner public returns(bool success) {\n', '     if (!master[addr]) {\n', '       master[addr] = true;\n', '       MasterAddressAdded(addr);\n', '       success = true; \n', '     }\n', '     }\n', '    \n', '     function removeAddressFromMaster(address addr) onlyOwner public returns(bool success) {\n', '     if (master[addr]) {\n', '       master[addr] = false;\n', '       MasterAddressRemoved(addr);\n', '       success = true;\n', '     }\n', '     }\n', '    \n', '    // setting the admin function of this contract\n', '     modifier onlyAdmin() {\n', '     require(admin[msg.sender]);\n', '    _;\n', '    }\n', '    \n', '    // setting the addition / removal of admin addresses\n', '     function addAddressToAdmin(address addr) onlyMaster public returns(bool success) {\n', '     if (!admin[addr]) {\n', '       admin[addr] = true;\n', '       AdminAddressAdded(addr);\n', '       success = true; \n', '     }\n', '     }\n', '    \n', '     function removeAddressFromAdmin(address addr) onlyMaster public returns(bool success) {\n', '     if (admin[addr]) {\n', '       admin[addr] = false;\n', '       AdminAddressRemoved(addr);\n', '       success = true;\n', '     }\n', '     }\n', '     \n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        // Check for frozen accounts\n', '        require(!frozenAccount[_from]);         // Check if sender is frozen\n', '        require(!frozenAccount[_to]);           // Check if recipient is frozen\n', '\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    // This part is for Token Pricing and advanced portions\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyMaster public {\n', '        require(balanceOf[msg.sender]<= totalSupply/10);\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyAdmin public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '     \n', '    function unfreezeAccount(address target, bool freeze) onlyAdmin public {\n', '        frozenAccount[target] = !freeze;\n', '        unFrozenFunds(target, !freeze);\n', '    }\n', '\n', '    // dividend payout section\n', '    // when user wants to claim for dividend, they should press this function\n', '    // which will freeze their account temporarily after diviendend payout is\n', '    // complete\n', '    function claimfordividend() public {\n', '        freezeAccount(msg.sender , true);\n', '    }\n', '    \n', '    // owner will perform this action to payout the dividend and unfreeze the \n', '    // frozen accounts\n', '    function payoutfordividend (address target, uint256 divpercentage) onlyOwner public{\n', '        _transfer(msg.sender, target, ((divpercentage*balanceOf[target]/100 + 5 - 1) / 5)*5);\n', '        unfreezeAccount(target , true);\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 6;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    address owner=msg.sender;\n', '\n', '    // This creates an array with all balances, allowances, frozen, master and admin accounts\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping(address => bool) public master;\n', '    mapping(address => bool) public admin;\n', '    \n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event FrozenFunds(address target, bool frozen);\n', '    event unFrozenFunds(address target, bool unfrozen);\n', '    event AdminAddressAdded(address addr);\n', '    event AdminAddressRemoved(address addr);\n', '    event MasterAddressAdded(address addr);\n', '    event MasterAddressRemoved(address addr);\n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    // Setting the ownership function of this contract\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    // setting the master function of this contract\n', '     modifier onlyMaster() {\n', '     require(master[msg.sender]);\n', '    _;\n', '    }\n', '    \n', '    // setting the addition / removal of master addresses\n', '     function addAddressToMaster(address addr) onlyOwner public returns(bool success) {\n', '     if (!master[addr]) {\n', '       master[addr] = true;\n', '       MasterAddressAdded(addr);\n', '       success = true; \n', '     }\n', '     }\n', '    \n', '     function removeAddressFromMaster(address addr) onlyOwner public returns(bool success) {\n', '     if (master[addr]) {\n', '       master[addr] = false;\n', '       MasterAddressRemoved(addr);\n', '       success = true;\n', '     }\n', '     }\n', '    \n', '    // setting the admin function of this contract\n', '     modifier onlyAdmin() {\n', '     require(admin[msg.sender]);\n', '    _;\n', '    }\n', '    \n', '    // setting the addition / removal of admin addresses\n', '     function addAddressToAdmin(address addr) onlyMaster public returns(bool success) {\n', '     if (!admin[addr]) {\n', '       admin[addr] = true;\n', '       AdminAddressAdded(addr);\n', '       success = true; \n', '     }\n', '     }\n', '    \n', '     function removeAddressFromAdmin(address addr) onlyMaster public returns(bool success) {\n', '     if (admin[addr]) {\n', '       admin[addr] = false;\n', '       AdminAddressRemoved(addr);\n', '       success = true;\n', '     }\n', '     }\n', '     \n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        // Check for frozen accounts\n', '        require(!frozenAccount[_from]);         // Check if sender is frozen\n', '        require(!frozenAccount[_to]);           // Check if recipient is frozen\n', '\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    // This part is for Token Pricing and advanced portions\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyMaster public {\n', '        require(balanceOf[msg.sender]<= totalSupply/10);\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyAdmin public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '     \n', '    function unfreezeAccount(address target, bool freeze) onlyAdmin public {\n', '        frozenAccount[target] = !freeze;\n', '        unFrozenFunds(target, !freeze);\n', '    }\n', '\n', '    // dividend payout section\n', '    // when user wants to claim for dividend, they should press this function\n', '    // which will freeze their account temporarily after diviendend payout is\n', '    // complete\n', '    function claimfordividend() public {\n', '        freezeAccount(msg.sender , true);\n', '    }\n', '    \n', '    // owner will perform this action to payout the dividend and unfreeze the \n', '    // frozen accounts\n', '    function payoutfordividend (address target, uint256 divpercentage) onlyOwner public{\n', '        _transfer(msg.sender, target, ((divpercentage*balanceOf[target]/100 + 5 - 1) / 5)*5);\n', '        unfreezeAccount(target , true);\n', '    }\n', '}']
