['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        require(newOwner != owner);  //check that ownership is not being transferred to self.\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract TokenERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        \n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        \n', '        // Subtract from the sender .. Add the same to the recipient\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        \n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/******************************************/\n', '/*       KONIOS TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', '\n', 'contract KoniosToken is owned, TokenERC20 {\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    \n', '    uint256 public soldTokens ;\n', '    \n', '    uint256 public remainingTokens ;\n', '\n', '    uint256 startBlock; //crowdsale start block (set in constructor)\n', '\n', '    uint256 teamLockup = 4505142; //team allocation cannot be created until this many blocks after endBlock (assuming 14 second blocks, this is 2 years)\n', '\n', '    uint256 teamAllocation = 250000000 * 10 ** uint256(decimals); //5% of token supply(5,000,000,000) allocated post-crowdsale for the team fund\n', '    bool teamAllocated = false; //this will change to true when the team fund is allocated\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* This notifies clients about the amount allocated to team fund */\n', '    event AllocateTeamTokens(address indexed from, uint256 value);\n', '    \n', '     /* This notifies clients about the amount burned */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function KoniosToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '            \n', '            totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '            balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '            name = tokenName;                                   // Set the name for display purposes\n', '            symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '            startBlock = block.number;\n', '            \n', '            remainingTokens = totalSupply ; //set the initial value of remainingTokens as totalSupply in the constructor\n', '\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '        soldTokens = soldTokens.add(_value);\n', '        remainingTokens = remainingTokens.sub(_value);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /**\n', '     * Set team tokens.\n', '     *\n', '     * Security review\n', '     *\n', '     * - Integer math: ok - only called once with fixed parameters\n', '     *\n', '     * Applicable tests:\n', '     *\n', '     * - Test founder token allocation too early\n', '     * - Test founder token allocation on time\n', '     * - Test founder token allocation twice\n', '     *\n', '     */\n', '    function allocateTeamTokens() onlyOwner public returns (bool success){\n', '        require( (startBlock + teamLockup) > block.number);          // Check if it is time to allocate team tokens\n', '        require(!teamAllocated);\n', '        //check if team tokens have already been allocated\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(teamAllocation);\n', '        totalSupply = totalSupply.add(teamAllocation);\n', '        teamAllocated = true;\n', '        AllocateTeamTokens(msg.sender, teamAllocation);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        require(newOwner != owner);  //check that ownership is not being transferred to self.\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract TokenERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        \n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        \n', '        // Subtract from the sender .. Add the same to the recipient\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        \n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/******************************************/\n', '/*       KONIOS TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', '\n', 'contract KoniosToken is owned, TokenERC20 {\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    \n', '    uint256 public soldTokens ;\n', '    \n', '    uint256 public remainingTokens ;\n', '\n', '    uint256 startBlock; //crowdsale start block (set in constructor)\n', '\n', '    uint256 teamLockup = 4505142; //team allocation cannot be created until this many blocks after endBlock (assuming 14 second blocks, this is 2 years)\n', '\n', '    uint256 teamAllocation = 250000000 * 10 ** uint256(decimals); //5% of token supply(5,000,000,000) allocated post-crowdsale for the team fund\n', '    bool teamAllocated = false; //this will change to true when the team fund is allocated\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* This notifies clients about the amount allocated to team fund */\n', '    event AllocateTeamTokens(address indexed from, uint256 value);\n', '    \n', '     /* This notifies clients about the amount burned */\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function KoniosToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '            \n', '            totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '            balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '            name = tokenName;                                   // Set the name for display purposes\n', '            symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '            startBlock = block.number;\n', '            \n', '            remainingTokens = totalSupply ; //set the initial value of remainingTokens as totalSupply in the constructor\n', '\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '        soldTokens = soldTokens.add(_value);\n', '        remainingTokens = remainingTokens.sub(_value);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /**\n', '     * Set team tokens.\n', '     *\n', '     * Security review\n', '     *\n', '     * - Integer math: ok - only called once with fixed parameters\n', '     *\n', '     * Applicable tests:\n', '     *\n', '     * - Test founder token allocation too early\n', '     * - Test founder token allocation on time\n', '     * - Test founder token allocation twice\n', '     *\n', '     */\n', '    function allocateTeamTokens() onlyOwner public returns (bool success){\n', '        require( (startBlock + teamLockup) > block.number);          // Check if it is time to allocate team tokens\n', '        require(!teamAllocated);\n', '        //check if team tokens have already been allocated\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(teamAllocation);\n', '        totalSupply = totalSupply.add(teamAllocation);\n', '        teamAllocated = true;\n', '        AllocateTeamTokens(msg.sender, teamAllocation);\n', '        return true;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '}']