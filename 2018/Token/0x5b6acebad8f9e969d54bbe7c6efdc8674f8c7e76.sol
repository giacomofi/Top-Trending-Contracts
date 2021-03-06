['pragma solidity ^0.4.16;\n', '/*-------------------------------------------------------------------------*/\n', ' /*\n', '  * Website\t: https://gemstonetokenblog.blogspot.com\n', '  * Email\t: gemstonetoken@gmail.com\n', ' */\n', '/*-------------------------------------------------------------------------*/\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '/*-------------------------------------------------------------------------*/\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner == 0x0) throw;\n', '        owner = newOwner;\n', '    }\n', '}\n', '/*-------------------------------------------------------------------------*/\n', '/**\n', ' * Overflow aware uint math functions.\n', ' */\n', 'contract SafeMath {\n', '  //internals\n', '\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '/*-------------------------------------------------------------------------*/\n', 'contract GemstoneToken is owned, SafeMath {\n', '\t\n', '\tstring \tpublic EthernetCashWebsite\t= "https://ethernet.cash";\n', '\taddress public EthernetCashAddress \t= this;\n', '\taddress public creator \t\t\t\t= msg.sender;\n', '    string \tpublic name \t\t\t\t= "Gemstone Token";\n', '    string \tpublic symbol \t\t\t\t= "GST";\n', '    uint8 \tpublic decimals \t\t\t= 18;\t\t\t\t\t\t\t\t\t\t\t    \n', '    uint256 public totalSupply \t\t\t= 19999999986000000000000000000;\n', '    uint256 public buyPrice \t\t\t= 18000000;\n', '\tuint256 public sellPrice \t\t\t= 18000000;\n', '   \t\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\tmapping (address => bool) public frozenAccount;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\t\t\t\t\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '     // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\tevent FrozenFunds(address target, bool frozen);\n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function GemstoneToken() public {\n', '        balanceOf[msg.sender] = totalSupply;    \t\t\t\t\t\t\t\t\t\t\t\n', '\t\tcreator = msg.sender;\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    /// @notice Buy tokens from contract by sending ether\n', '    function () payable internal {\n', '        uint amount = msg.value * buyPrice ; \n', '\t\tuint amountRaised;\n', '\t\tuint bonus = 0;\n', '\t\t\n', '\t\tbonus = getBonus(amount);\n', '\t\tamount = amount +  bonus;\n', '\t\t\n', '\t\t//amount = now ;\n', '\t\t\n', '        require(balanceOf[creator] >= amount);               \t\t\t\t\n', '        require(msg.value > 0);\n', '\t\tamountRaised = safeAdd(amountRaised, msg.value);                    \n', '\t\tbalanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);     \n', '        balanceOf[creator] = safeSub(balanceOf[creator], amount);           \n', '        Transfer(creator, msg.sender, amount);               \t\t\t\t\n', '        creator.transfer(amountRaised);\n', '    }\n', '\t\n', '\t/// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '\t\n', '\t/**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\t\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\t\n', '\t\n', '\t/**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\t/**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction getBonus(uint _amount) constant private returns (uint256) {\n', '        \n', '\t\tif(now >= 1524873600 && now <= 1527551999) { \n', '            return _amount * 50 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1527552000 && now <= 1530316799) { \n', '            return _amount * 40 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1530316800 && now <= 1532995199) { \n', '            return _amount * 30 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1532995200 && now <= 1535759999) { \n', '            return _amount * 20 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1535760000 && now <= 1538438399) { \n', '            return _amount * 10 / 100;\n', '        }\n', '\t\t\n', '        return 0;\n', '    }\n', '\t\n', '\t/// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', '        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It&#39;s important to do this last to avoid recursion attacks\n', '    }\n', '\t\n', ' }\n', '/*-------------------------------------------------------------------------*/']
['pragma solidity ^0.4.16;\n', '/*-------------------------------------------------------------------------*/\n', ' /*\n', '  * Website\t: https://gemstonetokenblog.blogspot.com\n', '  * Email\t: gemstonetoken@gmail.com\n', ' */\n', '/*-------------------------------------------------------------------------*/\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '/*-------------------------------------------------------------------------*/\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner == 0x0) throw;\n', '        owner = newOwner;\n', '    }\n', '}\n', '/*-------------------------------------------------------------------------*/\n', '/**\n', ' * Overflow aware uint math functions.\n', ' */\n', 'contract SafeMath {\n', '  //internals\n', '\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '/*-------------------------------------------------------------------------*/\n', 'contract GemstoneToken is owned, SafeMath {\n', '\t\n', '\tstring \tpublic EthernetCashWebsite\t= "https://ethernet.cash";\n', '\taddress public EthernetCashAddress \t= this;\n', '\taddress public creator \t\t\t\t= msg.sender;\n', '    string \tpublic name \t\t\t\t= "Gemstone Token";\n', '    string \tpublic symbol \t\t\t\t= "GST";\n', '    uint8 \tpublic decimals \t\t\t= 18;\t\t\t\t\t\t\t\t\t\t\t    \n', '    uint256 public totalSupply \t\t\t= 19999999986000000000000000000;\n', '    uint256 public buyPrice \t\t\t= 18000000;\n', '\tuint256 public sellPrice \t\t\t= 18000000;\n', '   \t\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\tmapping (address => bool) public frozenAccount;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\t\t\t\t\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '     // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\tevent FrozenFunds(address target, bool frozen);\n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function GemstoneToken() public {\n', '        balanceOf[msg.sender] = totalSupply;    \t\t\t\t\t\t\t\t\t\t\t\n', '\t\tcreator = msg.sender;\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    /// @notice Buy tokens from contract by sending ether\n', '    function () payable internal {\n', '        uint amount = msg.value * buyPrice ; \n', '\t\tuint amountRaised;\n', '\t\tuint bonus = 0;\n', '\t\t\n', '\t\tbonus = getBonus(amount);\n', '\t\tamount = amount +  bonus;\n', '\t\t\n', '\t\t//amount = now ;\n', '\t\t\n', '        require(balanceOf[creator] >= amount);               \t\t\t\t\n', '        require(msg.value > 0);\n', '\t\tamountRaised = safeAdd(amountRaised, msg.value);                    \n', '\t\tbalanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);     \n', '        balanceOf[creator] = safeSub(balanceOf[creator], amount);           \n', '        Transfer(creator, msg.sender, amount);               \t\t\t\t\n', '        creator.transfer(amountRaised);\n', '    }\n', '\t\n', '\t/// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '\t\n', '\t/**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\t\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\t\n', '\t\n', '\t/**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\t/**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction getBonus(uint _amount) constant private returns (uint256) {\n', '        \n', '\t\tif(now >= 1524873600 && now <= 1527551999) { \n', '            return _amount * 50 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1527552000 && now <= 1530316799) { \n', '            return _amount * 40 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1530316800 && now <= 1532995199) { \n', '            return _amount * 30 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1532995200 && now <= 1535759999) { \n', '            return _amount * 20 / 100;\n', '        }\n', '\t\t\n', '\t\tif(now >= 1535760000 && now <= 1538438399) { \n', '            return _amount * 10 / 100;\n', '        }\n', '\t\t\n', '        return 0;\n', '    }\n', '\t\n', '\t/// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', "        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '    }\n', '\t\n', ' }\n', '/*-------------------------------------------------------------------------*/']
