['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        assert(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        assert(b > 0);\n', '        c = a / b;\n', '        assert(a == b * c + a % b);\n', '    }\n', '}\n', '\n', 'contract ownable {\n', '    address public owner;\n', '\n', '    function ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function isOwner(address _owner) internal view returns (bool) {\n', '        return owner == _owner;\n', '    }\n', '}\n', '\n', 'contract Pausable is ownable {\n', '    bool public paused = false;\n', '    \n', '    event Pause();\n', '    event Unpause();\n', '    \n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '    \n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '    \n', '    function pause() onlyOwner whenNotPaused public returns (bool success) {\n', '        paused = true;\n', '        Pause();\n', '        return true;\n', '    }\n', '  \n', '    function unpause() onlyOwner whenPaused public returns (bool success) {\n', '        paused = false;\n', '        Unpause();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Lockable is Pausable {\n', '    mapping (address => bool) public locked;\n', '    \n', '    event Lockup(address indexed target);\n', '    event UnLockup(address indexed target);\n', '    \n', '    function lockup(address _target) onlyOwner public returns (bool success) {\n', '        require(!isOwner(_target));\n', '        locked[_target] = true;\n', '        Lockup(_target);\n', '        return true;\n', '    }\n', '\n', '    function unlockup(address _target) onlyOwner public returns (bool success) {\n', '        require(!isOwner(_target));\n', '        delete locked[_target];\n', '        UnLockup(_target);\n', '        return true;\n', '    }\n', '    \n', '    function isLockup(address _target) internal view returns (bool) {\n', '        if(true == locked[_target])\n', '            return true;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 {\n', '    using SafeMath for uint;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    \n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20 (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);\n', '\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     * Send `_value` tokens to `_to` from your account\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     * Remove `_value` tokens from the system irreversibly\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);                               // Check if the sender has enough\n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);    // Subtract from the sender\n', '        totalSupply = SafeMath.sub(totalSupply, _value);                        // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                        // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);            // Check allowance\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);  // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value); // Subtract from the sender&#39;s allowance\n', '        totalSupply = SafeMath.sub(totalSupply, _value);            // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ValueToken is Lockable, TokenERC20 {\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    uint256 public minAmount;\n', '    uint256 public soldToken;\n', '\n', '    uint internal constant MIN_ETHER        = 1*1e16; // 0.01 ether\n', '    uint internal constant EXCHANGE_RATE    = 10000;  // 1 eth = 10000 VALUE\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '    event LogWithdrawContractToken(address indexed owner, uint value);\n', '    event LogFallbackTracer(address indexed owner, uint value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function ValueToken (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {\n', '        \n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                                 // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);                 // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows\n', '        require(!frozenAccount[_from]);                       // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                         // Check if recipient is frozen\n', '        require(!isLockup(_from));\n', '        require(!isLockup(_to));\n', '\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);   // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);       // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] = SafeMath.add(balanceOf[target], mintedAmount);\n', '        totalSupply = SafeMath.add(totalSupply, mintedAmount);\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        require(!isOwner(target));\n', '        require(!frozenAccount[target]);\n', '\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function withdrawContractToken(uint _value) onlyOwner public returns (bool success) {\n', '        _transfer(this, msg.sender, _value);\n', '        LogWithdrawContractToken(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function getContractBalanceOf() public constant returns(uint blance) {\n', '        blance = balanceOf[this];\n', '    }\n', '    \n', '    // payable\n', '    function () payable public {\n', '        require(MIN_ETHER <= msg.value);\n', '        uint amount = msg.value;\n', '        uint token = amount.mul(EXCHANGE_RATE);\n', '        require(token > 0);\n', '        _transfer(this, msg.sender, amount);\n', '        LogFallbackTracer(msg.sender, amount);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        assert(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        assert(b > 0);\n', '        c = a / b;\n', '        assert(a == b * c + a % b);\n', '    }\n', '}\n', '\n', 'contract ownable {\n', '    address public owner;\n', '\n', '    function ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function isOwner(address _owner) internal view returns (bool) {\n', '        return owner == _owner;\n', '    }\n', '}\n', '\n', 'contract Pausable is ownable {\n', '    bool public paused = false;\n', '    \n', '    event Pause();\n', '    event Unpause();\n', '    \n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '    \n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '    \n', '    function pause() onlyOwner whenNotPaused public returns (bool success) {\n', '        paused = true;\n', '        Pause();\n', '        return true;\n', '    }\n', '  \n', '    function unpause() onlyOwner whenPaused public returns (bool success) {\n', '        paused = false;\n', '        Unpause();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Lockable is Pausable {\n', '    mapping (address => bool) public locked;\n', '    \n', '    event Lockup(address indexed target);\n', '    event UnLockup(address indexed target);\n', '    \n', '    function lockup(address _target) onlyOwner public returns (bool success) {\n', '        require(!isOwner(_target));\n', '        locked[_target] = true;\n', '        Lockup(_target);\n', '        return true;\n', '    }\n', '\n', '    function unlockup(address _target) onlyOwner public returns (bool success) {\n', '        require(!isOwner(_target));\n', '        delete locked[_target];\n', '        UnLockup(_target);\n', '        return true;\n', '    }\n', '    \n', '    function isLockup(address _target) internal view returns (bool) {\n', '        if(true == locked[_target])\n', '            return true;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 {\n', '    using SafeMath for uint;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    \n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20 (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);\n', '\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     * Send `_value` tokens to `_to` from your account\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     * Remove `_value` tokens from the system irreversibly\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);                               // Check if the sender has enough\n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);    // Subtract from the sender\n', '        totalSupply = SafeMath.sub(totalSupply, _value);                        // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                        // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);            // Check allowance\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);  // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value); // Subtract from the sender's allowance\n", '        totalSupply = SafeMath.sub(totalSupply, _value);            // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ValueToken is Lockable, TokenERC20 {\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    uint256 public minAmount;\n', '    uint256 public soldToken;\n', '\n', '    uint internal constant MIN_ETHER        = 1*1e16; // 0.01 ether\n', '    uint internal constant EXCHANGE_RATE    = 10000;  // 1 eth = 10000 VALUE\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '    event LogWithdrawContractToken(address indexed owner, uint value);\n', '    event LogFallbackTracer(address indexed owner, uint value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function ValueToken (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {\n', '        \n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                                 // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);                 // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows\n', '        require(!frozenAccount[_from]);                       // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                         // Check if recipient is frozen\n', '        require(!isLockup(_from));\n', '        require(!isLockup(_to));\n', '\n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);   // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);       // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] = SafeMath.add(balanceOf[target], mintedAmount);\n', '        totalSupply = SafeMath.add(totalSupply, mintedAmount);\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        require(!isOwner(target));\n', '        require(!frozenAccount[target]);\n', '\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function withdrawContractToken(uint _value) onlyOwner public returns (bool success) {\n', '        _transfer(this, msg.sender, _value);\n', '        LogWithdrawContractToken(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function getContractBalanceOf() public constant returns(uint blance) {\n', '        blance = balanceOf[this];\n', '    }\n', '    \n', '    // payable\n', '    function () payable public {\n', '        require(MIN_ETHER <= msg.value);\n', '        uint amount = msg.value;\n', '        uint token = amount.mul(EXCHANGE_RATE);\n', '        require(token > 0);\n', '        _transfer(this, msg.sender, amount);\n', '        LogFallbackTracer(msg.sender, amount);\n', '    }\n', '}']
