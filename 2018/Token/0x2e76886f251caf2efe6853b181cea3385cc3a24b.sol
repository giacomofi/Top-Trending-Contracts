['pragma solidity ^0.4.16;\n', '\n', '  /**\n', '  * @title SafeMath\n', '  * @dev Math operations with safety checks that throw on error\n', '  */\n', '  library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 is Pausable{\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    uint256 public totalSupplyForDivision;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf; \n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;\n', '    }\n', '    \n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal whenNotPaused{\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public whenNotPaused {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public whenNotPaused\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenNotPaused\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public whenPaused returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        totalSupplyForDivision -= _value;                              // Update totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public whenPaused returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        totalSupplyForDivision -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract DunkPayToken is TokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    uint256 public buySupply;\n', '    uint256 public totalEth;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function DunkPayToken() TokenERC20(totalSupply, name, symbol) public {\n', '\n', '        buyPrice = 1000;\n', '        sellPrice = 1000;\n', '        \n', '        name = "BitcoinYo Token";\n', '        symbol = "BTY";\n', '        totalSupply = buyPrice * 10000 * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = buyPrice * 5100 * 10 ** uint256(decimals);              \n', '        balanceOf[this] = totalSupply - balanceOf[msg.sender];\n', '        buySupply = balanceOf[this];\n', '        totalSupplyForDivision = totalSupply;// Set the symbol for display purposes\n', '        totalEth = address(this).balance;\n', '    }\n', '\n', '    function percent(uint256 numerator, uint256 denominator , uint precision) returns(uint256 quotient) {\n', '        if(numerator <= 0)\n', '        {\n', '            return 0;\n', '        }\n', '        // caution, check safe-to-multiply here\n', '        uint256 _numerator  = numerator * 10 ** uint256(precision+1);\n', '        // with rounding of last digit\n', '        uint256 _quotient =  ((_numerator / denominator) - 5) / 10;\n', '        return  _quotient;\n', '    }\n', '    \n', '    function getZero(uint256 number) returns(uint num_len) {\n', '        uint i = 1;\n', '        uint _num_len = 0;\n', '        while( number > i )\n', '        {\n', '            i *= 10;\n', '            _num_len++;\n', '        }\n', '        return _num_len;\n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        totalSupplyForDivision += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '        \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused {\n', '        if(_to == address(this)){\n', '            sell(_value);\n', '        }else{\n', '            _transfer(msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function () payable public {\n', '     buy();\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable whenNotPaused public {\n', '        uint256 dnkForBuy = msg.value;\n', '        uint zeros = getZero(buySupply);\n', '        uint256 interest = msg.value / 2 * percent(balanceOf[this] , buySupply , zeros);\n', '        interest = interest / 10 ** uint256(zeros);\n', '        dnkForBuy = dnkForBuy + interest;\n', '        _transfer(this, msg.sender, dnkForBuy * buyPrice);              // makes the transfers\n', '        totalEth += msg.value;\n', '    }\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) whenNotPaused public {\n', '        uint256 ethForSell =  amount;\n', '        uint zeros = getZero(balanceOf[this]);\n', '        uint256 interest = amount / 2 * percent( buySupply , balanceOf[this] ,zeros);\n', '        interest = interest / 10 ** uint256(zeros);\n', '        ethForSell = ethForSell - interest;\n', '        ethForSell = ethForSell - (ethForSell/100); // minus 1% for refund fee.   \n', '        ethForSell = ethForSell / sellPrice;\n', '        uint256 minimumAmount = address(this).balance; \n', '        require(minimumAmount >= ethForSell);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', '        msg.sender.transfer(ethForSell);          // sends ether to the seller. It&#39;s important to do this last to avoid recursion attacks\n', '        totalEth -= ethForSell;\n', '    } \n', '\n', '    /// @notice withDraw `amount` ETH to contract\n', '    /// @param amount amount of ETH to be sent\n', '    function withdraw(uint256 amount) onlyOwner public {\n', '        uint256 minimumAmount = address(this).balance; \n', '        require(minimumAmount >= amount);      // checks if the contract has enough ether to buy\n', '        msg.sender.transfer(amount);          // sends ether to the seller. It&#39;s important to do this last to avoid recursion attacks\n', '    }\n', '\n', '    function airdrop(address[] _holders, uint256 mintedAmount) onlyOwner whenPaused public {\n', '        for (uint i = 0; i < _holders.length; i++) {\n', '            uint zeros = getZero(totalSupplyForDivision);\n', '            uint256 amount = percent(balanceOf[_holders[i]],totalSupplyForDivision,zeros)  * mintedAmount;\n', '            amount = amount / 10 ** uint256(zeros);\n', '            if(amount != 0){\n', '                mintToken(_holders[i], amount);\n', '            }\n', '        }\n', '        totalSupplyForDivision = totalSupply;\n', '    }\n', '\n', '    function bankrupt(address[] _holders) onlyOwner whenPaused public {\n', '        uint256 restBalance = balanceOf[this];\n', '        balanceOf[this] -= restBalance;                        // Subtract from the targeted balance\n', '        totalSupply -= restBalance;                              // Update totalSupply\n', '        totalSupplyForDivision -= restBalance;                             // Update totalSupply\n', '        totalEth = address(this).balance;\n', '        \n', '        for (uint i = 0; i < _holders.length; i++) {\n', '          uint zeros = getZero(totalSupplyForDivision);\n', '          uint256 amount = percent(balanceOf[_holders[i]],totalSupplyForDivision , zeros) * totalEth;\n', '          amount = amount / 10 ** uint256(zeros);\n', '        \n', '          if(amount != 0){\n', '            uint256 minimumAmount = address(this).balance; \n', '            require(minimumAmount >= amount);      // checks if the contract has enough ether to buy\n', '            uint256 holderBalance = balanceOf[_holders[i]];\n', '            balanceOf[_holders[i]] -= holderBalance;                        // Subtract from the targeted balance\n', '            totalSupply -= holderBalance;            \n', '            _holders[i].transfer(amount);          // sends ether to the seller. It&#39;s important to do this last to \n', '          } \n', '        }\n', '        totalSupplyForDivision = totalSupply;\n', '        totalEth = address(this).balance;\n', '    }    \n', '}']
['pragma solidity ^0.4.16;\n', '\n', '  /**\n', '  * @title SafeMath\n', '  * @dev Math operations with safety checks that throw on error\n', '  */\n', '  library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 is Pausable{\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    uint256 public totalSupplyForDivision;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf; \n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;\n', '    }\n', '    \n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal whenNotPaused{\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public whenNotPaused {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public whenNotPaused\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenNotPaused\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public whenPaused returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        totalSupplyForDivision -= _value;                              // Update totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public whenPaused returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        totalSupplyForDivision -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract DunkPayToken is TokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    uint256 public buySupply;\n', '    uint256 public totalEth;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function DunkPayToken() TokenERC20(totalSupply, name, symbol) public {\n', '\n', '        buyPrice = 1000;\n', '        sellPrice = 1000;\n', '        \n', '        name = "BitcoinYo Token";\n', '        symbol = "BTY";\n', '        totalSupply = buyPrice * 10000 * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = buyPrice * 5100 * 10 ** uint256(decimals);              \n', '        balanceOf[this] = totalSupply - balanceOf[msg.sender];\n', '        buySupply = balanceOf[this];\n', '        totalSupplyForDivision = totalSupply;// Set the symbol for display purposes\n', '        totalEth = address(this).balance;\n', '    }\n', '\n', '    function percent(uint256 numerator, uint256 denominator , uint precision) returns(uint256 quotient) {\n', '        if(numerator <= 0)\n', '        {\n', '            return 0;\n', '        }\n', '        // caution, check safe-to-multiply here\n', '        uint256 _numerator  = numerator * 10 ** uint256(precision+1);\n', '        // with rounding of last digit\n', '        uint256 _quotient =  ((_numerator / denominator) - 5) / 10;\n', '        return  _quotient;\n', '    }\n', '    \n', '    function getZero(uint256 number) returns(uint num_len) {\n', '        uint i = 1;\n', '        uint _num_len = 0;\n', '        while( number > i )\n', '        {\n', '            i *= 10;\n', '            _num_len++;\n', '        }\n', '        return _num_len;\n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        totalSupplyForDivision += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '        \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused {\n', '        if(_to == address(this)){\n', '            sell(_value);\n', '        }else{\n', '            _transfer(msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function () payable public {\n', '     buy();\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable whenNotPaused public {\n', '        uint256 dnkForBuy = msg.value;\n', '        uint zeros = getZero(buySupply);\n', '        uint256 interest = msg.value / 2 * percent(balanceOf[this] , buySupply , zeros);\n', '        interest = interest / 10 ** uint256(zeros);\n', '        dnkForBuy = dnkForBuy + interest;\n', '        _transfer(this, msg.sender, dnkForBuy * buyPrice);              // makes the transfers\n', '        totalEth += msg.value;\n', '    }\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) whenNotPaused public {\n', '        uint256 ethForSell =  amount;\n', '        uint zeros = getZero(balanceOf[this]);\n', '        uint256 interest = amount / 2 * percent( buySupply , balanceOf[this] ,zeros);\n', '        interest = interest / 10 ** uint256(zeros);\n', '        ethForSell = ethForSell - interest;\n', '        ethForSell = ethForSell - (ethForSell/100); // minus 1% for refund fee.   \n', '        ethForSell = ethForSell / sellPrice;\n', '        uint256 minimumAmount = address(this).balance; \n', '        require(minimumAmount >= ethForSell);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', "        msg.sender.transfer(ethForSell);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '        totalEth -= ethForSell;\n', '    } \n', '\n', '    /// @notice withDraw `amount` ETH to contract\n', '    /// @param amount amount of ETH to be sent\n', '    function withdraw(uint256 amount) onlyOwner public {\n', '        uint256 minimumAmount = address(this).balance; \n', '        require(minimumAmount >= amount);      // checks if the contract has enough ether to buy\n', "        msg.sender.transfer(amount);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '    }\n', '\n', '    function airdrop(address[] _holders, uint256 mintedAmount) onlyOwner whenPaused public {\n', '        for (uint i = 0; i < _holders.length; i++) {\n', '            uint zeros = getZero(totalSupplyForDivision);\n', '            uint256 amount = percent(balanceOf[_holders[i]],totalSupplyForDivision,zeros)  * mintedAmount;\n', '            amount = amount / 10 ** uint256(zeros);\n', '            if(amount != 0){\n', '                mintToken(_holders[i], amount);\n', '            }\n', '        }\n', '        totalSupplyForDivision = totalSupply;\n', '    }\n', '\n', '    function bankrupt(address[] _holders) onlyOwner whenPaused public {\n', '        uint256 restBalance = balanceOf[this];\n', '        balanceOf[this] -= restBalance;                        // Subtract from the targeted balance\n', '        totalSupply -= restBalance;                              // Update totalSupply\n', '        totalSupplyForDivision -= restBalance;                             // Update totalSupply\n', '        totalEth = address(this).balance;\n', '        \n', '        for (uint i = 0; i < _holders.length; i++) {\n', '          uint zeros = getZero(totalSupplyForDivision);\n', '          uint256 amount = percent(balanceOf[_holders[i]],totalSupplyForDivision , zeros) * totalEth;\n', '          amount = amount / 10 ** uint256(zeros);\n', '        \n', '          if(amount != 0){\n', '            uint256 minimumAmount = address(this).balance; \n', '            require(minimumAmount >= amount);      // checks if the contract has enough ether to buy\n', '            uint256 holderBalance = balanceOf[_holders[i]];\n', '            balanceOf[_holders[i]] -= holderBalance;                        // Subtract from the targeted balance\n', '            totalSupply -= holderBalance;            \n', "            _holders[i].transfer(amount);          // sends ether to the seller. It's important to do this last to \n", '          } \n', '        }\n', '        totalSupplyForDivision = totalSupply;\n', '        totalEth = address(this).balance;\n', '    }    \n', '}']
