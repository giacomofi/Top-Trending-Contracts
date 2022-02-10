['pragma solidity ^0.4.18;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract OysterShell {\n', '    // Public variables of SHL\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    address public director;\n', '    bool public directorLock;\n', '    uint256 public feeAmount;\n', '    uint256 public retentionMin;\n', '    uint256 public retentionMax;\n', '\n', '    // Array definitions\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => uint256) public locked;\n', '\n', '    // ERC20 event\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    // ERC20 event\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed _from, uint256 _value);\n', '    \n', '    // This notifies clients about an address getting locked\n', '    event Lock(address indexed _target, uint256 _value, uint256 _interval);\n', '    \n', '    // This notifies clients about a claim being made on a locked address\n', '    event Claim(address indexed _target, address indexed _payout, address indexed _fee);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract\n', '     */\n', '    function OysterShell() public {\n', '        director = msg.sender;\n', '        name = "Oyster Shell TEST";\n', '        symbol = "PRESHL";\n', '        decimals = 18;\n', '        directorLock = false;\n', '        totalSupply = 98592692;\n', '        \n', '        // Assign total SHL supply to the director\n', '        balances[director] = totalSupply;\n', '        \n', '        // SHL fee paid to brokers\n', '        feeAmount = 10;\n', '        \n', '        // Maximum time for a sector to remain stored\n', '        retentionMin = 20;\n', '        \n', '        // Maximum time for a sector to remain stored\n', '        retentionMax = 200;\n', '    }\n', '    \n', '    /**\n', '     * ERC20 balance function\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    modifier onlyDirector {\n', '        // Director can lock themselves out to complete decentralization of Oyster network\n', '        // An alternative is that another smart contract could become the decentralized director\n', '        require(!directorLock);\n', '        \n', '        // Only the director is permitted\n', '        require(msg.sender == director);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyDirectorForce {\n', '        // Only the director is permitted\n', '        require(msg.sender == director);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Transfers the director to a new address\n', '     */\n', '    function transferDirector(address newDirector) public onlyDirectorForce {\n', '        director = newDirector;\n', '    }\n', '    \n', '    /**\n', '     * Withdraw funds from the contract\n', '     */\n', '    function withdrawFunds() public onlyDirectorForce {\n', '        director.transfer(this.balance);\n', '    }\n', '    \n', '    /**\n', '     * Permanently lock out the director to decentralize Oyster\n', '     * Invocation is discretionary because Oyster might be better suited to\n', '     * transition to an artificially intelligent smart contract director\n', '     */\n', '    function selfLock() public payable onlyDirector {\n', '        // Prevents accidental lockout\n', '        require(msg.value == 10 ether);\n', '        \n', '        // Permanently lock out the director\n', '        directorLock = true;\n', '    }\n', '    \n', '    /**\n', '     * Director can alter the broker fee rate\n', '     */\n', '    function amendFee(uint256 feeAmountSet) public onlyDirector returns (bool success) {\n', '        feeAmount = feeAmountSet;\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Director can alter the maximum time of storage retention\n', '     */\n', '    function amendRetention(uint256 retentionMinSet, uint256 retentionMaxSet) public onlyDirector returns (bool success) {\n', '        // Set retentionMin\n', '        retentionMin = retentionMinSet;\n', '        \n', '        // Set retentionMax\n', '        retentionMax = retentionMaxSet;\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Oyster Protocol Function\n', '     * More information at https://oyster.ws/OysterWhitepaper.pdf\n', '     * \n', '     * Lock an address\n', '     *\n', '     * When an address is locked; only claimAmount can be withdrawn once per epoch\n', '     */\n', '    function lock(uint256 interval) public returns (bool success) {\n', '        // The address must be previously unlocked\n', '        require(locked[msg.sender] == 0);\n', '        \n', '        // An address must have at least retentionMin to be locked\n', '        require(balances[msg.sender] >= retentionMin);\n', '        \n', '        // Prevent addresses with large balances from getting buried\n', '        require(balances[msg.sender] <= retentionMax);\n', '        \n', '        // Set locked state to true\n', '        locked[msg.sender] = interval;\n', '        \n', '        // Execute an event reflecting the change\n', '        Lock(msg.sender, balances[msg.sender], interval);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Oyster Protocol Function\n', '     * More information at https://oyster.ws/OysterWhitepaper.pdf\n', '     * \n', '     * Claim all SHL from a locked address\n', '     *\n', '     * If a prior claim wasn&#39;t made during the current epoch, then claimAmount can be withdrawn\n', '     *\n', '     * @param _payout the address of the website owner\n', '     * @param _fee the address of the broker node\n', '     */\n', '    function claim(address _payout, address _fee) public returns (bool success) {\n', '        // The claimed address must have already been locked\n', '        require(locked[msg.sender] >= block.timestamp);\n', '        \n', '        // The payout and fee addresses must be different\n', '        require(_payout != _fee);\n', '        \n', '        // The claimed address cannot pay itself\n', '        require(msg.sender != _payout);\n', '        \n', '        // The claimed address cannot pay itself\n', '        require(msg.sender != _fee);\n', '        \n', '        // Check if the locked address has enough\n', '        require(balances[msg.sender] >= retentionMin);\n', '        \n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];\n', '        \n', '        // Calculate amount to be paid to _payout\n', '        uint256 payAmount = balances[msg.sender] - feeAmount;\n', '        \n', '        // Remove claimAmount from the buried address\n', '        balances[msg.sender] = 0;\n', '        \n', '        // Pay the website owner that invoked the web node that found the PRL seed key\n', '        balances[_payout] += payAmount;\n', '        \n', '        // Pay the broker node that unlocked the PRL\n', '        balances[_fee] += feeAmount;\n', '        \n', '        // Execute events to reflect the changes\n', '        Claim(msg.sender, _payout, _fee);\n', '        Transfer(msg.sender, _payout, payAmount);\n', '        Transfer(msg.sender, _fee, feeAmount);\n', '        \n', '        // Failsafe logic that should never be false\n', '        assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Crowdsale function\n', '     */\n', '    function () public payable {\n', '        // Prevent ETH from getting sent to contract\n', '        require(false);\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, can be called by this contract only\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Sending addresses cannot be locked\n', '        require(locked[_from] == 0);\n', '        \n', '        // If the receiving address is locked, it cannot exceed retentionMax\n', '        if (locked[_to] > 0) {\n', '            require(balances[_to] + _value <= retentionMax);\n', '        }\n', '        \n', '        // Prevent transfer to 0x0 address, use burn() instead\n', '        require(_to != 0x0);\n', '        \n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        \n', '        // Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\n', '        \n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balances[_from] + balances[_to];\n', '        \n', '        // Subtract from the sender\n', '        balances[_from] -= _value;\n', '        \n', '        // Add the same to the recipient\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        \n', '        // Failsafe logic that should never be false\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to the address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _to the address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        // Check allowance\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf\n', '     *\n', '     * @param _spender the address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // Locked addresses cannot be approved\n', '        require(locked[msg.sender] == 0);\n', '        \n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender the address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        // Buried addresses cannot be burnt\n', '        require(locked[msg.sender] == 0);\n', '        \n', '        // Check if the sender has enough\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        // Subtract from the sender\n', '        balances[msg.sender] -= _value;\n', '        \n', '        // Updates totalSupply\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        // Buried addresses cannot be burnt\n', '        require(locked[_from] == 0);\n', '        \n', '        // Check if the targeted balance is enough\n', '        require(balances[_from] >= _value);\n', '        \n', '        // Check allowance\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        \n', '        // Subtract from the targeted balance\n', '        balances[_from] -= _value;\n', '        \n', '        // Subtract from the sender&#39;s allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        \n', '        // Update totalSupply\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']