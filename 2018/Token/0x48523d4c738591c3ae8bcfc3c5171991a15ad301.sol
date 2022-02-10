['pragma solidity ^0.4.0;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract MyFirstEthereumToken {\n', '    // The keyword "public" makes those variables\n', '    // readable from outside.\n', '    address public owner;\n', '\t// Public variables of the token\n', '    string public name = "MyFirstEthereumToken";\n', '    string public symbol = "MFET";\n', '    uint8 public decimals = 18;\t// 18 decimals is the strongly suggested default, avoid changing it\n', ' \n', '    uint256 public totalSupply; \n', '\tuint256 public totalExtraTokens = 0;\n', '\tuint256 public totalContributed = 0;\n', '\t\n', '\tbool public onSale = false;\n', '\n', '\t/* This creates an array with all balances */\n', '    mapping (address => uint256) public balances;\n', '\tmapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // Events allow light clients to react on\n', '    // changes efficiently.\n', '    event Sent(address from, address to, uint amount);\n', '\t// This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\t\n', '\tevent Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '\tfunction name() public constant returns (string) { return name; }\n', '    function symbol() public constant returns (string) { return symbol; }\n', '    function decimals() public constant returns (uint8) { return decimals; }\n', '\tfunction totalSupply() public constant returns (uint256) { return totalSupply; }\n', '\tfunction balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }\n', '\t\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function MyFirstEthereumToken(uint256 initialSupply) public payable\n', '\t{\n', '\t\towner = msg.sender;\n', '\t\t\n', '\t\t// Update total supply with the decimal amount\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '\t\t//totalSupply = initialSupply;  \n', '\t\t// Give the creator all initial tokens\n', '        balances[msg.sender] = totalSupply; \n', '\t\t// Give the creator all initial tokens\t\t\n', '        //balanceOf[msg.sender] = initialSupply;  \n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success)\n', '\t{\n', '        return _transfer(msg.sender, _to, _value);\n', '    }\n', '\t\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal returns (bool success)\n', '\t{\n', '\t\t// mitigates the ERC20 short address attack\n', '\t\t//require(msg.data.length >= (2 * 32) + 4);\n', '\t\t// checks for minimum transfer amount\n', '\t\trequire(_value > 0);\n', '\t\t// Prevent transfer to 0x0 address. Use burn() instead  \n', '        require(_to != 0x0);\t      \n', '\t\t// Check if the sender has enough\n', '        require(balances[_from] >= _value);\t\n', '\t\t// Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\t// Check for overflows\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        // Subtract from the sender\n', '        balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balances[_to] += _value;\n', '\t\t// Call for Event\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '\t\t\n', '\t\treturn true;\n', '    }\n', '\n', '    /**\n', '     * Send tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function send(address _to, uint256 _value) public \n', '\t{\n', '        _send(_to, _value);\n', '    }\n', '\t\n', '    /**\n', '     * Internal send, only can be called by this contract\n', '     */\n', '    function _send(address _to, uint256 _value) internal \n', '\t{\t\n', '\t\taddress _from = msg.sender;\n', '\t\t\n', '\t\t// mitigates the ERC20 short address attack\n', '\t\t//require(msg.data.length >= (2 * 32) + 4);\n', '\t\t// checks for minimum transfer amount\n', '\t\trequire(_value > 0);\n', '\t\t// Prevent transfer to 0x0 address. Use burn() instead  \n', '        require(_to != 0x0);\t      \n', '\t\t// Check if the sender has enough\n', '        require(balances[_from] >= _value);\t\n', '\t\t// Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\t// Check for overflows\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        // Subtract from the sender\n', '        balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balances[_to] += _value;\n', '\t\t// Call for Event\n', '        Sent(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '    }\n', '\n', '   /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) \n', '\t{\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) \n', '\t{\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) \n', '\t{\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\t\t\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\t\n', '\t/**\n', '     * Create tokens\n', '     *\n', '     * Create `_amount` tokens to `owner` account\n', '     *\n', '     * @param _amount the amount to create\n', '     */\t\n', '    function createTokens(uint256 _amount) public\n', '\t{\n', '\t    require(msg.sender == owner);\n', '        //if (msg.sender != owner) return;\n', '        \n', '        balances[owner] += _amount; \n', '        totalSupply += _amount;\n', '\t\t\n', '        Transfer(0, owner, _amount);\n', '    }\n', '\n', '\t/**\n', '     * Withdraw funds\n', '     *\n', '     * Transfers the total amount of funds to ownwer account minus gas fee\n', '     *\n', '     */\t\n', '    function safeWithdrawAll() public returns (bool)\n', '\t{\n', '\t    require(msg.sender == owner);\n', '\t\t\n', '\t\tuint256 _gasPrice = 30000000000;\n', '\t\t\n', '\t\trequire(this.balance > _gasPrice);\n', '\t\t\n', '\t\tuint256 _totalAmount = this.balance - _gasPrice;\n', '\t\t\n', '\t\towner.transfer(_totalAmount);\n', '\t\t\n', '\t\treturn true;\n', '    }\n', '\t\n', '\t/**\n', '     * Withdraw funds\n', '     *\n', '     * Create `_amount` tokens to `owner` account\n', '     *\n', '     * @param _amount the amount to create\n', '     */\t\n', '    function safeWithdraw(uint256 _amount) public returns (bool)\n', '\t{\n', '\t    require(msg.sender == owner);\n', '\t\t\n', '\t\tuint256 _gasPrice = 30000000000;\n', '\t\t\n', '\t\trequire(_amount > 0);\n', '\t\t\n', '\t\tuint256 totalAmount = _amount + _gasPrice; \n', '\t\t\n', '\t\trequire(this.balance >= totalAmount);\n', '\t\t\n', '\t\towner.transfer(totalAmount);\n', '\t\t\n', '\t\treturn true;\n', '    }\n', '    \n', '\tfunction getBalanceContract() public constant returns(uint)\n', '\t{\n', '\t\trequire(msg.sender == owner);\n', '\t\t\n', '        return this.balance;\n', '    }\n', '\t\n', '\t/**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\t\n', '\t// A function to buy tokens accesible by any address\n', '\t// The payable keyword allows the contract to accept ethers\n', '\t// from the transactor. The ethers to be deposited is entered as msg.value\n', '\t// (which will get clearer when we will call the functions in browser-solidity)\n', '\t// and the corresponding tokens are stored in balance[msg.sender] mapping.\n', '\t// underflows and overflows are security consideration which are\n', '\t// not checked in the process. But lets not worry about them for now.\n', '\n', '\tfunction buyTokens () public payable \n', '\t{\n', '\t\t// checks for minimum transfer amount\n', '\t\trequire(msg.value > 0);\n', '\t\t\n', '\t\trequire(onSale == true);\n', '\t\t\n', '\t\towner.transfer(msg.value);\n', '\t\t\t\n', '\t\ttotalContributed += msg.value;\n', '\t\t\n', '\t\tuint256 tokensAmount = msg.value * 1000;\n', '\t\t\n', '\t\tif(totalContributed >= 1 ether)\n', '\t\t{\n', '\t\t\t\n', '\t\t\tuint256 multiplier = (totalContributed / 1 ether);\n', '\t\t\t\n', '\t\t\tuint256 extraTokens = (tokensAmount * multiplier) / 10;\n', '\t\t\t\n', '\t\t\ttotalExtraTokens += extraTokens;\n', '\t\t\t\n', '\t\t\ttokensAmount += extraTokens;\n', '\t\t}\n', '\t\t\t\n', '\t\tbalances[msg.sender] += tokensAmount;\n', '\t\t\n', '\t\ttotalSupply += tokensAmount;\n', '        \n', '        Transfer(address(this), msg.sender, tokensAmount);\n', '\t}\n', '\t\n', '\t/**\n', '     * EnableSale Function\n', '     *\n', '     */\t\n', '\tfunction enableSale() public\n', '\t{\n', '\t\trequire(msg.sender == owner);\n', '\n', '        onSale = true;\n', '    }\n', '\t\n', '\t/**\n', '     * DisableSale Function\n', '     *\n', '     */\t\n', '\tfunction disableSale() public \n', '\t{\n', '\t\trequire(msg.sender == owner);\n', '\n', '        onSale = false;\n', '    }\n', '\t\n', '    /**\n', '     * Kill Function\n', '     *\n', '     */\t\n', '    function kill() public\n', '\t{\n', '\t    require(msg.sender == owner);\n', '\t\n', '\t\tonSale = false;\n', '\t\n', '        selfdestruct(owner);\n', '    }\n', '\t\n', '    /**\n', '     * Fallback Function\n', '     *\n', '     */\t\n', '\tfunction() public payable \n', '\t{\n', '\t\tbuyTokens();\n', '\t\t//totalContributed += msg.value;\n', '\t}\n', '}']