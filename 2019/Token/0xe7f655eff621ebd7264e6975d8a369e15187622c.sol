['// +----------------------------------------------------------------------\n', '// | Copyright (c) 2019 OFEX Token (OFT)\n', '// +----------------------------------------------------------------------\n', '// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )\n', '// +----------------------------------------------------------------------\n', '// | TECHNICAL SUPPORT: HAO MA STUDIO\n', '// +----------------------------------------------------------------------\n', '\n', 'pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public { owner = msg.sender; }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    uint256 public totalSupply;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', "    // Event which is triggered to log all transfers to this contract's event log\n", '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    // Event which is triggered whenever an owner approves a new allowance for a spender.\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Initialization Construction\n', '     */\n', '    function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {\n', '        totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                     // Give the creator all initial tokens\n', '        name = _tokenName;                                       // Set the name for display purposes\n', '        symbol = _tokenSymbol;                                   // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal Realization of Token Transaction Transfer\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);                                            // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balanceOf[_from] >= _value);                            // Check if the sender has enough    \n', '        require(balanceOf[_to] + _value > balanceOf[_to]);              // Check for overflows\n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];      // Save this for an assertion in the future\n', '        balanceOf[_from] -= _value;                                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                                       // Add the same to the recipient\n', '        Transfer(_from, _to, _value);                                   // Notify anyone listening that this transfer took place\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // Use assert to check code logic\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to     The address of the recipient\n', '     * @param _value  The amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from   The address of the sender\n', '     * @param _to     The address of the recipient\n', '     * @param _value  The amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender  The address authorized to spend\n', '     * @param _value    The max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender    The address authorized to spend\n', '     * @param _value      The max amount they can spend\n', '     * @param _extraData  Some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value  The amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from   The address of the sender\n', '     * @param _value  The amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']