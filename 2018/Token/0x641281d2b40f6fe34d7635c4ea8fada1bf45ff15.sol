['pragma solidity ^0.4.23;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != 0x0);\n', '        require(newOwner != owner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20() public {}\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowanc\n', '        allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        require(_spender != 0x0);    \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/******************************************/\n', '/*       BND TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract BNDToken is owned, TokenERC20 {\n', '\n', '    string public name = "Bind Token";\n', '    string public symbol = "BND";\n', '    uint8 public decimals = 18;\n', '    \n', '    \n', '    uint256 public buyPrice;\n', '    uint256 public totalSupply = 100000000000e18;  \n', '    \n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function BNDToken () public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '    function () payable {\n', '        buy();\n', '    }\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(!frozenAccount[msg.sender]);\n', '        require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '        require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflow\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '\trequire(!frozenAccount[_from]);\n', '    return TokenERC20.transferFrom(_from, _to, _value);\n', '  }\n', '  \n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer(address _to, uint256 _value) public {\n', '    require(!frozenAccount[msg.sender]);\n', '    return TokenERC20.transfer(_to, _value);\n', '  }\n', '\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setbuyPrice( uint256 newBuyPrice) onlyOwner public {\n', '        require(newBuyPrice > 0);\n', '        buyPrice = newBuyPrice;\n', '    }\n', '    \n', '    function withdrawEther() onlyOwner {\n', '       require(address(this).balance >= 0 ether);\n', '       owner.transfer(address(this).balance);\n', '    }\n', '   \n', '\t\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public {\n', '        require(msg.value > 0);\n', '        require(buyPrice > 0);\n', '         uint amount = msg.value.mul(buyPrice); \n', '        _transfer(owner, msg.sender, amount);              // makes the transfers\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.23;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != 0x0);\n', '        require(newOwner != owner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20() public {}\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowanc\n', '        allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        require(_spender != 0x0);    \n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/******************************************/\n', '/*       BND TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract BNDToken is owned, TokenERC20 {\n', '\n', '    string public name = "Bind Token";\n', '    string public symbol = "BND";\n', '    uint8 public decimals = 18;\n', '    \n', '    \n', '    uint256 public buyPrice;\n', '    uint256 public totalSupply = 100000000000e18;  \n', '    \n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function BNDToken () public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '    function () payable {\n', '        buy();\n', '    }\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(!frozenAccount[msg.sender]);\n', '        require (balanceOf[_from] > _value);                // Check if the sender has enough\n', '        require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflow\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    /**\n', '   * Transfer given number of tokens from given owner to given recipient.\n', '   *\n', '   * @param _from address to transfer tokens from the owner of\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer from given owner to given\n', '   *        recipient\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '\trequire(!frozenAccount[_from]);\n', '    return TokenERC20.transferFrom(_from, _to, _value);\n', '  }\n', '  \n', '  /**\n', '   * Transfer given number of tokens from message sender to given recipient.\n', '   * @param _to address to transfer tokens to the owner of\n', '   * @param _value number of tokens to transfer to the owner of given address\n', '   * @return true if tokens were transferred successfully, false otherwise\n', '   */\n', '  function transfer(address _to, uint256 _value) public {\n', '    require(!frozenAccount[msg.sender]);\n', '    return TokenERC20.transfer(_to, _value);\n', '  }\n', '\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setbuyPrice( uint256 newBuyPrice) onlyOwner public {\n', '        require(newBuyPrice > 0);\n', '        buyPrice = newBuyPrice;\n', '    }\n', '    \n', '    function withdrawEther() onlyOwner {\n', '       require(address(this).balance >= 0 ether);\n', '       owner.transfer(address(this).balance);\n', '    }\n', '   \n', '\t\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public {\n', '        require(msg.value > 0);\n', '        require(buyPrice > 0);\n', '         uint amount = msg.value.mul(buyPrice); \n', '        _transfer(owner, msg.sender, amount);              // makes the transfers\n', '    }\n', '\n', '\n', '}']