['pragma solidity ^0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '//\n', '// Symbol      : CRP\n', '// Name        : Chiwoo Rotary Press\n', '// Total supply: 8000000000\n', '// Decimals    : 18\n', '\n', '\n', '// (c) by Team @ CRP 2018.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', '*/\n', '\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '    }\n', '    \n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '    }\n', '    \n', '     /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '    }\n', '    \n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', '*/\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract CRP_ERC20 is owned {\n', '    using SafeMath for uint;\n', '    \n', '    string public name = "Chiwoo Rotary Press";\n', '    string public symbol = "CRP";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 8000000000 * 10 ** uint256(decimals);\n', '    /// the price of tokenBuy\n', '    uint256 public TokenPerETHBuy = 1000;\n', '    \n', '    /// the price of tokenSell\n', '    uint256 public TokenPerETHSell = 1000;\n', '    \n', '    /// sell token is enabled\n', '    bool public SellTokenAllowed;\n', '    \n', '   \n', '    /// This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    /// This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    /// This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    /// This notifies clients about the new Buy price\n', '    event BuyRateChanged(uint256 oldValue, uint256 newValue);\n', '    \n', '    /// This notifies clients about the new Sell price\n', '    event SellRateChanged(uint256 oldValue, uint256 newValue);\n', '    \n', '    /// This notifies clients about the Buy Token\n', '    event BuyToken(address user, uint256 eth, uint256 token);\n', '    \n', '    /// This notifies clients about the Sell Token\n', '    event SellToken(address user, uint256 eth, uint256 token);\n', '    \n', '    /// Log the event about a deposit being made by an address and its amount\n', '    event LogDepositMade(address indexed accountAddress, uint amount);\n', '    \n', '    /// This generates a public event on the blockchain that will notify clients\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    event SellTokenAllowedEvent(bool isAllowed);\n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor () public {\n', '        balanceOf[owner] = totalSupply;\n', '        SellTokenAllowed = true;\n', '    }\n', '    \n', '     /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '     function _transfer(address _from, address _to, uint256 _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Check if sender is frozen\n', '        require(!frozenAccount[_from]);\n', '        // Check if recipient is frozen\n', '        require(!frozenAccount[_to]);\n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '     /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '     /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '     /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set price function for Buy\n', '     *\n', '     * @param value the amount new Buy Price\n', '     */\n', '    \n', '    function setBuyRate(uint256 value) onlyOwner public {\n', '        require(value > 0);\n', '        emit BuyRateChanged(TokenPerETHBuy, value);\n', '        TokenPerETHBuy = value;\n', '    }\n', '    \n', '     /**\n', '     * Set price function for Sell\n', '     *\n', '     * @param value the amount new Sell Price\n', '     */\n', '    \n', '    function setSellRate(uint256 value) onlyOwner public {\n', '        require(value > 0);\n', '        emit SellRateChanged(TokenPerETHSell, value);\n', '        TokenPerETHSell = value;\n', '    }\n', '    \n', '    /**\n', '    *  function for Buy Token\n', '    */\n', '    \n', '    function buy() payable public returns (uint amount){\n', '          require(msg.value > 0);\n', '\t      require(!frozenAccount[msg.sender]);              // check sender is not frozen account\n', '          amount = ((msg.value.mul(TokenPerETHBuy)).mul( 10 ** uint256(decimals))).div(1 ether);\n', '          balanceOf[this] -= amount;                        // adds the amount to owner&#39;s \n', '          balanceOf[msg.sender] += amount; \n', '          emit Transfer(this,msg.sender ,amount);\n', '          return amount;\n', '    }\n', '    \n', '    /**\n', '    *  function for Sell Token\n', '    */\n', '    \n', '    function sell(uint amount) public returns (uint revenue){\n', '        \n', '        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell\n', '\t\trequire(SellTokenAllowed);                        // check if the sender whitelist\n', '\t\trequire(!frozenAccount[msg.sender]);              // check sender is not frozen account\n', '        balanceOf[this] += amount;                        // adds the amount to owner&#39;s balance\n', '        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller&#39;s balance\n', '        revenue = (amount.mul(1 ether)).div(TokenPerETHSell.mul(10 ** uint256(decimals))) ;\n', '        msg.sender.transfer(revenue);                     // sends ether to the seller: it&#39;s important to do this last to prevent recursion attacks\n', '        emit Transfer(msg.sender, this, amount);               // executes an event reflecting on the change\n', '        return revenue;                                   // ends function and returns\n', '        \n', '    }\n', '    \n', '    /**\n', '    * Deposit Ether in owner account, requires method is "payable"\n', '    */\n', '    \n', '    function deposit() public payable  {\n', '       \n', '    }\n', '    \n', '    /**\n', '    *@notice Withdraw for Ether\n', '    */\n', '     function withdraw(uint withdrawAmount) onlyOwner public  {\n', '          if (withdrawAmount <= address(this).balance) {\n', '            owner.transfer(withdrawAmount);\n', '        }\n', '        \n', '     }\n', '    \n', '    function () public payable {\n', '        buy();\n', '    }\n', '    \n', '    /**\n', '    * Enable Sell Token\n', '    */\n', '    function enableSellToken() onlyOwner public {\n', '        SellTokenAllowed = true;\n', '        emit SellTokenAllowedEvent (true);\n', '          \n', '      }\n', '\n', '    /**\n', '    * Disable Sell Token\n', '    */\n', '    function disableSellToken() onlyOwner public {\n', '        SellTokenAllowed = false;\n', '        emit SellTokenAllowedEvent (false);\n', '    }\n', '    \n', '     \n', '}']
['pragma solidity ^0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '//\n', '// Symbol      : CRP\n', '// Name        : Chiwoo Rotary Press\n', '// Total supply: 8000000000\n', '// Decimals    : 18\n', '\n', '\n', '// (c) by Team @ CRP 2018.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', '*/\n', '\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '    }\n', '    \n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '    }\n', '    \n', '     /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '    }\n', '    \n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', '*/\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract CRP_ERC20 is owned {\n', '    using SafeMath for uint;\n', '    \n', '    string public name = "Chiwoo Rotary Press";\n', '    string public symbol = "CRP";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 8000000000 * 10 ** uint256(decimals);\n', '    /// the price of tokenBuy\n', '    uint256 public TokenPerETHBuy = 1000;\n', '    \n', '    /// the price of tokenSell\n', '    uint256 public TokenPerETHSell = 1000;\n', '    \n', '    /// sell token is enabled\n', '    bool public SellTokenAllowed;\n', '    \n', '   \n', '    /// This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    /// This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    /// This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    /// This notifies clients about the new Buy price\n', '    event BuyRateChanged(uint256 oldValue, uint256 newValue);\n', '    \n', '    /// This notifies clients about the new Sell price\n', '    event SellRateChanged(uint256 oldValue, uint256 newValue);\n', '    \n', '    /// This notifies clients about the Buy Token\n', '    event BuyToken(address user, uint256 eth, uint256 token);\n', '    \n', '    /// This notifies clients about the Sell Token\n', '    event SellToken(address user, uint256 eth, uint256 token);\n', '    \n', '    /// Log the event about a deposit being made by an address and its amount\n', '    event LogDepositMade(address indexed accountAddress, uint amount);\n', '    \n', '    /// This generates a public event on the blockchain that will notify clients\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    event SellTokenAllowedEvent(bool isAllowed);\n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor () public {\n', '        balanceOf[owner] = totalSupply;\n', '        SellTokenAllowed = true;\n', '    }\n', '    \n', '     /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '     function _transfer(address _from, address _to, uint256 _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Check if sender is frozen\n', '        require(!frozenAccount[_from]);\n', '        // Check if recipient is frozen\n', '        require(!frozenAccount[_to]);\n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '     /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '     /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '     /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set price function for Buy\n', '     *\n', '     * @param value the amount new Buy Price\n', '     */\n', '    \n', '    function setBuyRate(uint256 value) onlyOwner public {\n', '        require(value > 0);\n', '        emit BuyRateChanged(TokenPerETHBuy, value);\n', '        TokenPerETHBuy = value;\n', '    }\n', '    \n', '     /**\n', '     * Set price function for Sell\n', '     *\n', '     * @param value the amount new Sell Price\n', '     */\n', '    \n', '    function setSellRate(uint256 value) onlyOwner public {\n', '        require(value > 0);\n', '        emit SellRateChanged(TokenPerETHSell, value);\n', '        TokenPerETHSell = value;\n', '    }\n', '    \n', '    /**\n', '    *  function for Buy Token\n', '    */\n', '    \n', '    function buy() payable public returns (uint amount){\n', '          require(msg.value > 0);\n', '\t      require(!frozenAccount[msg.sender]);              // check sender is not frozen account\n', '          amount = ((msg.value.mul(TokenPerETHBuy)).mul( 10 ** uint256(decimals))).div(1 ether);\n', "          balanceOf[this] -= amount;                        // adds the amount to owner's \n", '          balanceOf[msg.sender] += amount; \n', '          emit Transfer(this,msg.sender ,amount);\n', '          return amount;\n', '    }\n', '    \n', '    /**\n', '    *  function for Sell Token\n', '    */\n', '    \n', '    function sell(uint amount) public returns (uint revenue){\n', '        \n', '        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell\n', '\t\trequire(SellTokenAllowed);                        // check if the sender whitelist\n', '\t\trequire(!frozenAccount[msg.sender]);              // check sender is not frozen account\n', "        balanceOf[this] += amount;                        // adds the amount to owner's balance\n", "        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance\n", '        revenue = (amount.mul(1 ether)).div(TokenPerETHSell.mul(10 ** uint256(decimals))) ;\n', "        msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks\n", '        emit Transfer(msg.sender, this, amount);               // executes an event reflecting on the change\n', '        return revenue;                                   // ends function and returns\n', '        \n', '    }\n', '    \n', '    /**\n', '    * Deposit Ether in owner account, requires method is "payable"\n', '    */\n', '    \n', '    function deposit() public payable  {\n', '       \n', '    }\n', '    \n', '    /**\n', '    *@notice Withdraw for Ether\n', '    */\n', '     function withdraw(uint withdrawAmount) onlyOwner public  {\n', '          if (withdrawAmount <= address(this).balance) {\n', '            owner.transfer(withdrawAmount);\n', '        }\n', '        \n', '     }\n', '    \n', '    function () public payable {\n', '        buy();\n', '    }\n', '    \n', '    /**\n', '    * Enable Sell Token\n', '    */\n', '    function enableSellToken() onlyOwner public {\n', '        SellTokenAllowed = true;\n', '        emit SellTokenAllowedEvent (true);\n', '          \n', '      }\n', '\n', '    /**\n', '    * Disable Sell Token\n', '    */\n', '    function disableSellToken() onlyOwner public {\n', '        SellTokenAllowed = false;\n', '        emit SellTokenAllowedEvent (false);\n', '    }\n', '    \n', '     \n', '}']