['pragma solidity ^0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'World meds'  token contract\n", '//\n', '// Owner Address : 0xa03eaf0b2490f2b13efc772b8344d08b6a03e661\n', '// Symbol      : wdmd\n', '// Name        : World meds\n', '// Total supply: 1000000000\n', '// Decimals    : 18\n', '// Website     : https://worldwidemeds.online\n', '// Email       : info@worldwidemeds.online\n', '// POWERED BY World Wide Meds.\n', '\n', '// (c) by Team @ World Wide Meds 2018.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', '*/\n', '\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '    }\n', '    \n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '    }\n', '    \n', '     /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '    }\n', '    \n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', '*/\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract ERC20 is owned {\n', '    using SafeMath for uint;\n', '    // Public variables of the token\n', '    string public name = "World meds";\n', '    string public symbol = "wdmd";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);\n', '    \n', '     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token\n', '     address public ICO_Contract;\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '   // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    \n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor () public {\n', '        balanceOf[owner] = totalSupply;\n', '    }\n', '    \n', '     /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '     \n', '     function _transfer(address _from, address _to, uint256 _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Check if sender is frozen\n', '        require(!frozenAccount[_from]);\n', '        // Check if recipient is frozen\n', '        require(!frozenAccount[_to]);\n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '     /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '     /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '    \n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '    \n', '     /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    /// @dev Set the ICO_Contract.\n', '    /// @param _ICO_Contract crowdsale contract address\n', '    function setICO_Contract(address _ICO_Contract) onlyOwner public {\n', '        ICO_Contract = _ICO_Contract;\n', '    }\n', '     \n', '}\n', '\n', 'contract Killable is owned {\n', '    function kill() onlyOwner public {\n', '        selfdestruct(owner);\n', '    }\n', '}\n', '\n', 'contract ERC20_ICO is Killable {\n', '    \n', '     /// The token we are selling\n', '    ERC20 public token;\n', '\n', '    /// the UNIX timestamp start date of the crowdsale\n', '    uint256 public startsAt = 1545048000;\n', '\n', '    /// the UNIX timestamp end date of the crowdsale\n', '    uint256 public endsAt = 1548936000;\n', '\n', '    /// the price of token\n', '    uint256 public TokenPerETH = 5000;\n', '\n', '    /// Has this crowdsale been finalized\n', '    bool public finalized = false;\n', '    \n', '     /// the number of tokens already sold through this contract\n', '    uint256 public tokensSold = 0;\n', '\n', '    /// the number of ETH raised through this contract\n', '    uint256 public weiRaised = 0;\n', '\n', '    /// How many distinct addresses have invested\n', '    uint256 public investorCount = 0;\n', '    \n', '     /// How much ETH each address has invested to this crowdsale\n', '    mapping (address => uint256) public investedAmountOf;\n', '\n', '    /// A new investment was made\n', '    event Invested(address investor, uint256 weiAmount, uint256 tokenAmount);\n', '    /// Crowdsale Start time has been changed\n', '    event StartsAtChanged(uint256 startsAt);\n', '    /// Crowdsale end time has been changed\n', '    event EndsAtChanged(uint256 endsAt);\n', '    /// Calculated new price\n', '    event RateChanged(uint256 oldValue, uint256 newValue);\n', '    \n', '    \n', '    constructor (address _token) public {\n', '        token = ERC20(_token);\n', '    }\n', '\n', '    function investInternal(address receiver) private {\n', '        require(!finalized);\n', '        require(startsAt <= now && endsAt > now);\n', '\n', '        if(investedAmountOf[receiver] == 0) {\n', '            // A new investor\n', '            investorCount++;\n', '        }\n', '\n', '        // Update investor\n', '        uint256 tokensAmount = msg.value * TokenPerETH;\n', '        investedAmountOf[receiver] += msg.value;\n', '        // Update totals\n', '        tokensSold += tokensAmount;\n', '        weiRaised += msg.value;\n', '\n', '        // Emit an event that shows invested successfully\n', '        emit Invested(receiver, msg.value, tokensAmount);\n', '        \n', "        // Transfer Token to owner's address\n", '        token.transfer(receiver, tokensAmount);\n', '\n', "        // Transfer Fund to owner's address\n", '        owner.transfer(address(this).balance);\n', '\n', '    }\n', '     function () public payable {\n', '        investInternal(msg.sender);\n', '    }\n', '\n', '    function setStartsAt(uint256 time) onlyOwner public {\n', '        require(!finalized);\n', '        startsAt = time;\n', '        emit StartsAtChanged(startsAt);\n', '    }\n', '    \n', '    function setEndsAt(uint256 time) onlyOwner public {\n', '        require(!finalized);\n', '        endsAt = time;\n', '        emit EndsAtChanged(endsAt);\n', '    }\n', '    \n', '    function setRate(uint256 value) onlyOwner public {\n', '        require(!finalized);\n', '        require(value > 0);\n', '        emit RateChanged(TokenPerETH, value);\n', '        TokenPerETH = value;\n', '    }\n', '    function finalize() public onlyOwner {\n', '        // Finalized Pre ICO crowdsele.\n', '        finalized = true;\n', '        uint256 tokensAmount = token.balanceOf(this);\n', '        token.transfer(owner, tokensAmount);\n', '    }\n', '}']