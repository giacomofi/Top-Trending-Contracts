['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '}    \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint32 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract x32323 is owned{\n', '    \n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 0;\n', '    // 0 decimals is the strongly suggested default, avoid changing it\n', '    uint32 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint32) public balanceOf;\n', '    mapping (address => mapping (address => uint32)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint32 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = 23000000;  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = "測試8";                                   // Set the name for display purposes\n', '        symbol = "測試8";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint32 _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint _value) public {\n', '        require(!frozenAccount[msg.sender]);\n', '\tif(msg.sender.balance < minBalanceForAccounts)\n', '            sell(uint32(minBalanceForAccounts - msg.sender.balance) / sellPrice);\n', '        _transfer(msg.sender, _to, uint32(_value));\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint32 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint32 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '\n', '\n', '    uint32 public sellPrice;\n', '    uint32 public buyPrice;\n', '\n', '    \n', '    \n', '\n', '    function setPrices(uint32 newSellPrice, uint32 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable returns (uint32 amount){\n', '        amount = uint32(msg.value) / buyPrice;                    // calculates the amount\n', '        require(balanceOf[this] >= amount);               // checks if it has enough to sell\n', '        balanceOf[msg.sender] += amount;                  // adds the amount to buyer&#39;s balance\n', '        balanceOf[this] -= amount;                        // subtracts amount from seller&#39;s balance\n', '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '        return amount;                                    // ends function and returns\n', '    }\n', '\n', '    function sell(uint32 amount) returns (uint32 revenue){\n', '        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell\n', '        balanceOf[this] += amount;                        // adds the amount to owner&#39;s balance\n', '        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller&#39;s balance\n', '        revenue = amount * sellPrice;\n', '        msg.sender.transfer(revenue);                     // sends ether to the seller: it&#39;s important to do this last to prevent recursion attacks\n', '        Transfer(msg.sender, this, amount);               // executes an event reflecting on the change\n', '        return revenue;                                   // ends function and returns\n', '    }\n', '\n', '\n', '    uint minBalanceForAccounts;\n', '    \n', '    function setMinBalance(uint32 minimumBalanceInFinney) onlyOwner {\n', '         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '}    \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint32 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract x32323 is owned{\n', '    \n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 0;\n', '    // 0 decimals is the strongly suggested default, avoid changing it\n', '    uint32 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint32) public balanceOf;\n', '    mapping (address => mapping (address => uint32)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint32 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = 23000000;  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = "測試8";                                   // Set the name for display purposes\n', '        symbol = "測試8";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint32 _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint _value) public {\n', '        require(!frozenAccount[msg.sender]);\n', '\tif(msg.sender.balance < minBalanceForAccounts)\n', '            sell(uint32(minBalanceForAccounts - msg.sender.balance) / sellPrice);\n', '        _transfer(msg.sender, _to, uint32(_value));\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint32 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint32 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '\n', '\n', '    uint32 public sellPrice;\n', '    uint32 public buyPrice;\n', '\n', '    \n', '    \n', '\n', '    function setPrices(uint32 newSellPrice, uint32 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable returns (uint32 amount){\n', '        amount = uint32(msg.value) / buyPrice;                    // calculates the amount\n', '        require(balanceOf[this] >= amount);               // checks if it has enough to sell\n', "        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance\n", "        balanceOf[this] -= amount;                        // subtracts amount from seller's balance\n", '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '        return amount;                                    // ends function and returns\n', '    }\n', '\n', '    function sell(uint32 amount) returns (uint32 revenue){\n', '        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell\n', "        balanceOf[this] += amount;                        // adds the amount to owner's balance\n", "        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance\n", '        revenue = amount * sellPrice;\n', "        msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks\n", '        Transfer(msg.sender, this, amount);               // executes an event reflecting on the change\n', '        return revenue;                                   // ends function and returns\n', '    }\n', '\n', '\n', '    uint minBalanceForAccounts;\n', '    \n', '    function setMinBalance(uint32 minimumBalanceInFinney) onlyOwner {\n', '         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '    }\n', '\n', '}']