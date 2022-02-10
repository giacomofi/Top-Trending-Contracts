['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public constant returns (uint supply);\n', '    function balanceOf( address who ) public constant returns (uint value);\n', '    function allowance( address owner, address spender ) public constant returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) public returns (bool ok);\n', '    function transferFrom( address from, address to, uint value) public returns (bool ok);\n', '    function approve( address spender, uint value ) public returns (bool ok);\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'contract TokenERC20  is ERC20Basic{\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 4;\n', '    uint256 _supply;\n', '    mapping (address => uint256)   _balances;\n', '    mapping (address => mapping (address => uint256)) _allowance;\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint8 decimal\n', '    ) public {\n', '        _supply = initialSupply * 10 ** uint256(decimal);  // Update total supply with the decimal amount\n', '        _balances[msg.sender] = _supply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimal;\n', '    }\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _supply;\n', '    }\n', '    function balanceOf(address src) public constant returns (uint256) {\n', '        return _balances[src];\n', '    }\n', '    function allowance(address src, address guy) public constant returns (uint256) {\n', '        return _allowance[src][guy];\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(_balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(_balances[_to] + _value > _balances[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = _balances[_from] + _balances[_to];\n', '        // Subtract from the sender\n', '        _balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        _balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(_balances[_from] + _balances[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool){\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= _allowance[_from][msg.sender]);     // Check allowance\n', '        _allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        _allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value)\n', '        public returns (bool success) {\n', '        if (approve(_spender, _value)) {\n', '            Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(_balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        _balances[msg.sender] -= _value;            // Subtract from the sender\n', '        _supply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(_balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= _allowance[_from][msg.sender]);    // Check allowance\n', '        _balances[_from] -= _value;                         // Subtract from the targeted balance\n', '        _allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        _supply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract DYITToken is owned, TokenERC20 {\n', '\n', '    uint256 public sellPrice = 0.00000001 ether ; //设置代币的卖的价格等于一个以太币\n', '    uint256 public buyPrice = 0.00000001 ether ;//设置代币的买的价格等于一个以太币\n', '    \n', '    mapping (address => bool) public _frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '   function DYITToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint8 decimal\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol,decimal) public {\n', '        _balances[msg.sender] = _supply;  \n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (_balances[_from] >= _value);               // Check if the sender has enough\n', '        require (_balances[_to] + _value > _balances[_to]); // Check for overflows\n', '        require(!_frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!_frozenAccount[_to]);                       // Check if recipient is frozen\n', '        _balances[_from] -= _value;                         // Subtract from the sender\n', '        _balances[_to] += _value;                           // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        _balances[target] += mintedAmount;\n', '        _supply += mintedAmount;\n', '        Transfer(0, owner, mintedAmount);\n', '        Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        _frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '    /**\n', '     * 实现账户间，代币的转移\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool){\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(owner, msg.sender, amount);              // makes the transfers\n', '    }\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        require(owner.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, owner, amount);              // makes the transfers\n', '        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It&#39;s important to do this last to avoid recursion attacks\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public constant returns (uint supply);\n', '    function balanceOf( address who ) public constant returns (uint value);\n', '    function allowance( address owner, address spender ) public constant returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) public returns (bool ok);\n', '    function transferFrom( address from, address to, uint value) public returns (bool ok);\n', '    function approve( address spender, uint value ) public returns (bool ok);\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'contract TokenERC20  is ERC20Basic{\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 4;\n', '    uint256 _supply;\n', '    mapping (address => uint256)   _balances;\n', '    mapping (address => mapping (address => uint256)) _allowance;\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint8 decimal\n', '    ) public {\n', '        _supply = initialSupply * 10 ** uint256(decimal);  // Update total supply with the decimal amount\n', '        _balances[msg.sender] = _supply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimal;\n', '    }\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _supply;\n', '    }\n', '    function balanceOf(address src) public constant returns (uint256) {\n', '        return _balances[src];\n', '    }\n', '    function allowance(address src, address guy) public constant returns (uint256) {\n', '        return _allowance[src][guy];\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(_balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(_balances[_to] + _value > _balances[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = _balances[_from] + _balances[_to];\n', '        // Subtract from the sender\n', '        _balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        _balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(_balances[_from] + _balances[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool){\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= _allowance[_from][msg.sender]);     // Check allowance\n', '        _allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        _allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value)\n', '        public returns (bool success) {\n', '        if (approve(_spender, _value)) {\n', '            Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(_balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        _balances[msg.sender] -= _value;            // Subtract from the sender\n', '        _supply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(_balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= _allowance[_from][msg.sender]);    // Check allowance\n', '        _balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        _allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        _supply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract DYITToken is owned, TokenERC20 {\n', '\n', '    uint256 public sellPrice = 0.00000001 ether ; //设置代币的卖的价格等于一个以太币\n', '    uint256 public buyPrice = 0.00000001 ether ;//设置代币的买的价格等于一个以太币\n', '    \n', '    mapping (address => bool) public _frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '   function DYITToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint8 decimal\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol,decimal) public {\n', '        _balances[msg.sender] = _supply;  \n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (_balances[_from] >= _value);               // Check if the sender has enough\n', '        require (_balances[_to] + _value > _balances[_to]); // Check for overflows\n', '        require(!_frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!_frozenAccount[_to]);                       // Check if recipient is frozen\n', '        _balances[_from] -= _value;                         // Subtract from the sender\n', '        _balances[_to] += _value;                           // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        _balances[target] += mintedAmount;\n', '        _supply += mintedAmount;\n', '        Transfer(0, owner, mintedAmount);\n', '        Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        _frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '    /**\n', '     * 实现账户间，代币的转移\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool){\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(owner, msg.sender, amount);              // makes the transfers\n', '    }\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        require(owner.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, owner, amount);              // makes the transfers\n', "        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '    }\n', '}']
