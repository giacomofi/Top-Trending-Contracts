['pragma solidity ^0.4.16;\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract BitexGlobalXBXCoin  {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    address public owner;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '\t mapping (address => uint256) public lockAmount;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\t\n', '\t//function lockAmount(address who) public view returns (uint256);\n', '\t\n', '\tevent Lock(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    //This is common notifier for all events\n', '    event eventForAllTxn(address indexed from, address indexed to, uint256 value, string eventName, string platformTxId);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '   // function AustralianBitCoin(\n', '\n', '   constructor (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol,\n', '\tstring plaformTxId\n', '\t) public {\n', '        totalSupply = initialSupply;                        // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = initialSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;\n', '        owner = msg.sender;\n', '        emit eventForAllTxn(msg.sender, msg.sender, totalSupply,"DEPLOY", plaformTxId);\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value,string plaformTxId) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '\t    // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        emit eventForAllTxn(_from, _to, _value,"TRANSFER",plaformTxId);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferForExchange(address _to, uint256 _value,string plaformTxId) public returns (bool success) {\n', '       require(balanceOf[msg.sender] - lockAmount[msg.sender] >= _value); \n', '\t\t_transfer(msg.sender, _to, _value,plaformTxId);\n', '        return true;\n', '    }\n', '\t\n', '\t/////////\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool success) {\n', '       require(balanceOf[msg.sender] - lockAmount[msg.sender] >= _value); \n', '\t\t_transfer(msg.sender, _to, _value,"OTHER");\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` on behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\t\trequire(balanceOf[_from] - lockAmount[_from] >= _value); \n', '        allowance[_from][msg.sender] -= _value;\n', '      // require(msg.sender==owner);\n', '       _transfer(_from, _to, _value, "OTHER");\n', '        return true;\n', '    }\n', '\t/////////this is for exchange\n', '\tfunction transferFromForExchange(address _from, address _to, uint256 _value, string plaformTxId) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\t\trequire(balanceOf[_from] - lockAmount[_from] >= _value); \n', '        allowance[_from][msg.sender] -= _value;\n', '      // require(msg.sender==owner);\n', '       _transfer(_from, _to, _value, plaformTxId);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '\t\trequire(msg.sender==owner);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\t/*\n', '\t*lock perticular amount of any user by admin\n', '\t*/\n', '\t function lock(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '\t\trequire(msg.sender==owner);\n', '\t\t require(balanceOf[_spender] >= _value);  \n', '       lockAmount[_spender] += _value;\n', '\t   emit Lock(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\t/*\n', '\t*unlock perticular amount of any user by admin\n', '\t*/\n', '\t function unlock(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '\t\trequire(msg.sender==owner);\n', '\t\trequire(balanceOf[_spender] >= _value);  \n', '       lockAmount[_spender] -= _value;\n', '\t   emit Lock(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\t\n', '\t/**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', ' // function lockAmount(address _spender) public view returns (uint256 balance) {\n', ' //   return balanceOf[_spender];\n', ' // }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value, string plaformTxId) public returns (bool success) {\n', '        require(msg.sender==owner);\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        emit eventForAllTxn(msg.sender, msg.sender, _value,"BURN", plaformTxId);\n', '        return true;\n', '    }\n', '    \n', '       \n', '    \n', '    function mint(uint256 _value, string plaformTxId) public returns (bool success) {  \n', '    \trequire(msg.sender==owner);\n', '\t\trequire(balanceOf[msg.sender] + _value <= 300000000);     //if total supply reaches at 300,000,000 then its not mint\n', '        balanceOf[msg.sender] += _value;                          // Subtract from the sender\n', '        totalSupply += _value;                                    // Updates totalSupply\n', '         emit eventForAllTxn(msg.sender, msg.sender, _value,"MINT", plaformTxId);\n', '        return true;\n', '    }\n', '\n', '    \n', '}']