['pragma solidity ^0.4.23;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract HammerChainBeta {\n', '    address  owner;   \n', '    \n', '    // Public variables of the token\n', '    string  name;\n', '    string  symbol;\n', '    uint8  decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256  totalSupply;\n', '\n', '    address INCENTIVE_POOL_ADDR = 0x0;\n', '    address FOUNDATION_POOL_ADDR = 0x0;\n', '    address COMMUNITY_POOL_ADDR = 0x0;\n', '    address FOUNDERS_POOL_ADDR = 0x0;\n', '\n', '    bool releasedFoundation = false;\n', '    bool releasedCommunity = false;\n', '    uint256  timeIncentive = 0x0;\n', '    uint256 limitIncentive=0x0;\n', '    uint256 timeFounders= 0x0;\n', '    uint256 limitFounders=0x0;\n', '\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', ' \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        totalSupply = 512000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = "HammerChain(alpha)";                        // Set the name for display purposes\n', '        symbol = "HRC";                                     // Set the symbol for display purposes\n', '    }\n', '\n', '    function sendIncentive() onlyOwner public{\n', '        require(limitIncentive < totalSupply/2);\n', '        if (timeIncentive < now){\n', '            if (timeIncentive == 0x0){\n', '                _transfer(owner,INCENTIVE_POOL_ADDR,totalSupply/10);\n', '                limitIncentive += totalSupply/10;\n', '            }\n', '            else{\n', '                _transfer(owner,INCENTIVE_POOL_ADDR,totalSupply/20);\n', '                limitIncentive += totalSupply/20;\n', '            }\n', '            timeIncentive = now + 365 days;\n', '        }\n', '    }\n', '\n', '    function sendFounders() onlyOwner public{\n', '        require(limitFounders < totalSupply/20);\n', '        if (timeFounders== 0x0 || timeFounders < now){\n', '            _transfer(owner,FOUNDERS_POOL_ADDR,totalSupply/100);\n', '            timeFounders = now + 365 days;\n', '            limitFounders += totalSupply/100;\n', '        }\n', '    }\n', '\n', '    function sendFoundation() onlyOwner public{\n', '        require(releasedFoundation == false);\n', '        _transfer(owner,FOUNDATION_POOL_ADDR,totalSupply/4);\n', '        releasedFoundation = true;\n', '    }\n', '\n', '\n', '    function sendCommunity() onlyOwner public{\n', '        require(releasedCommunity == false);\n', '        _transfer(owner,COMMUNITY_POOL_ADDR,totalSupply/5);\n', '        releasedCommunity = true;\n', '    }\n', '\n', '    function setINCENTIVE_POOL_ADDR(address addr) onlyOwner public{\n', '        INCENTIVE_POOL_ADDR = addr;\n', '    }\n', '\n', '    function setFOUNDATION_POOL_ADDR(address addr) onlyOwner public{\n', '        FOUNDATION_POOL_ADDR = addr;\n', '    }\n', '    \n', '    function setCOMMUNITY_POOL_ADDR(address addr) onlyOwner public{\n', '        COMMUNITY_POOL_ADDR = addr;\n', '    }\n', '\n', '    function setFOUNDERS_POOL_ADDR(address addr) onlyOwner public{\n', '        FOUNDERS_POOL_ADDR = addr;\n', '    }\n', '\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        require(msg.sender != owner);\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(msg.sender != owner);\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract HammerChainBeta {\n', '    address  owner;   \n', '    \n', '    // Public variables of the token\n', '    string  name;\n', '    string  symbol;\n', '    uint8  decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256  totalSupply;\n', '\n', '    address INCENTIVE_POOL_ADDR = 0x0;\n', '    address FOUNDATION_POOL_ADDR = 0x0;\n', '    address COMMUNITY_POOL_ADDR = 0x0;\n', '    address FOUNDERS_POOL_ADDR = 0x0;\n', '\n', '    bool releasedFoundation = false;\n', '    bool releasedCommunity = false;\n', '    uint256  timeIncentive = 0x0;\n', '    uint256 limitIncentive=0x0;\n', '    uint256 timeFounders= 0x0;\n', '    uint256 limitFounders=0x0;\n', '\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', ' \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        totalSupply = 512000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = "HammerChain(alpha)";                        // Set the name for display purposes\n', '        symbol = "HRC";                                     // Set the symbol for display purposes\n', '    }\n', '\n', '    function sendIncentive() onlyOwner public{\n', '        require(limitIncentive < totalSupply/2);\n', '        if (timeIncentive < now){\n', '            if (timeIncentive == 0x0){\n', '                _transfer(owner,INCENTIVE_POOL_ADDR,totalSupply/10);\n', '                limitIncentive += totalSupply/10;\n', '            }\n', '            else{\n', '                _transfer(owner,INCENTIVE_POOL_ADDR,totalSupply/20);\n', '                limitIncentive += totalSupply/20;\n', '            }\n', '            timeIncentive = now + 365 days;\n', '        }\n', '    }\n', '\n', '    function sendFounders() onlyOwner public{\n', '        require(limitFounders < totalSupply/20);\n', '        if (timeFounders== 0x0 || timeFounders < now){\n', '            _transfer(owner,FOUNDERS_POOL_ADDR,totalSupply/100);\n', '            timeFounders = now + 365 days;\n', '            limitFounders += totalSupply/100;\n', '        }\n', '    }\n', '\n', '    function sendFoundation() onlyOwner public{\n', '        require(releasedFoundation == false);\n', '        _transfer(owner,FOUNDATION_POOL_ADDR,totalSupply/4);\n', '        releasedFoundation = true;\n', '    }\n', '\n', '\n', '    function sendCommunity() onlyOwner public{\n', '        require(releasedCommunity == false);\n', '        _transfer(owner,COMMUNITY_POOL_ADDR,totalSupply/5);\n', '        releasedCommunity = true;\n', '    }\n', '\n', '    function setINCENTIVE_POOL_ADDR(address addr) onlyOwner public{\n', '        INCENTIVE_POOL_ADDR = addr;\n', '    }\n', '\n', '    function setFOUNDATION_POOL_ADDR(address addr) onlyOwner public{\n', '        FOUNDATION_POOL_ADDR = addr;\n', '    }\n', '    \n', '    function setCOMMUNITY_POOL_ADDR(address addr) onlyOwner public{\n', '        COMMUNITY_POOL_ADDR = addr;\n', '    }\n', '\n', '    function setFOUNDERS_POOL_ADDR(address addr) onlyOwner public{\n', '        FOUNDERS_POOL_ADDR = addr;\n', '    }\n', '\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        require(msg.sender != owner);\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(msg.sender != owner);\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']
