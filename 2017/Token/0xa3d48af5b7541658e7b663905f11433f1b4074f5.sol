['pragma solidity ^0.4.17;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract OysterPearl {\n', '    // Public variables of the token\n', '    string public name = "Oyster Pearl";\n', '    string public symbol = "TPRL";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '    uint256 public funds = 0;\n', '    address public owner;\n', '    bool public saleClosed = false;\n', '    bool public ownerLock = false;\n', '    uint256 public claimAmount;\n', '    uint256 public payAmount;\n', '    uint256 public feeAmount;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public buried;\n', '    mapping (address => uint256) public claimed;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    event Bury(address indexed target, uint256 value);\n', '    \n', '    event Claim(address indexed payout, address indexed fee);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract\n', '     */\n', '    function OysterPearl() public {\n', '        owner = msg.sender;\n', '        totalSupply = 0;\n', '        totalSupply += 25000000 * 10 ** uint256(decimals); //marketing share (5%)\n', '        totalSupply += 75000000 * 10 ** uint256(decimals); //devfund share (15%)\n', '        totalSupply += 1000000 * 10 ** uint256(decimals);  //allocation to match PREPRL supply\n', '        balanceOf[owner] = totalSupply;\n', '        \n', '        claimAmount = 5 * 10 ** (uint256(decimals) - 1);\n', '        payAmount = 4 * 10 ** (uint256(decimals) - 1);\n', '        feeAmount = 1 * 10 ** (uint256(decimals) - 1);\n', '    }\n', '    \n', '    modifier onlyOwner {\n', '        require(!ownerLock);\n', '        require(block.number < 8000000);\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function selfLock() public onlyOwner {\n', '        ownerLock = true;\n', '    }\n', '    \n', '    function amendAmount(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet) public onlyOwner {\n', '        require(claimAmountSet == (payAmountSet + feeAmountSet));\n', '        claimAmount = claimAmountSet * 10 ** (uint256(decimals) - 1);\n', '        payAmount = payAmountSet * 10 ** (uint256(decimals) - 1);\n', '        feeAmount = feeAmountSet * 10 ** (uint256(decimals) - 1);\n', '    }\n', '    \n', '    function closeSale() public onlyOwner {\n', '        saleClosed = true;\n', '    }\n', '\n', '    function openSale() public onlyOwner {\n', '        saleClosed = false;\n', '    }\n', '    \n', '    function bury() public {\n', '        require(balanceOf[msg.sender] > claimAmount);\n', '        require(!buried[msg.sender]);\n', '        buried[msg.sender] = true;\n', '        claimed[msg.sender] = 1;\n', '        Bury(msg.sender, balanceOf[msg.sender]);\n', '    }\n', '    \n', '    function claim(address _payout, address _fee) public {\n', '        require(buried[msg.sender]);\n', '        require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= 60);\n', '        require(balanceOf[msg.sender] >= claimAmount);\n', '        claimed[msg.sender] = block.timestamp;\n', '        balanceOf[msg.sender] -= claimAmount;\n', '        balanceOf[_payout] -= payAmount;\n', '        balanceOf[_fee] -= feeAmount;\n', '        Claim(_payout, _fee);\n', '    }\n', '    \n', '    function () payable public {\n', '        require(!saleClosed);\n', '        require(msg.value >= 1 finney);\n', '        uint256 amount = msg.value * 5000;                // calculates the amount\n', '        require(totalSupply + amount <= (500000000 * 10 ** uint256(decimals)));\n', '        totalSupply += amount;                            // increases the total supply \n', "        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance\n", '        funds += msg.value;                               // track eth amount raised\n', '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '    }\n', '    \n', '    function withdrawFunds() public onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(!buried[_from]);\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']