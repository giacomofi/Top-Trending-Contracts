['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal  constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    \n', '    uint256 public totalSupply;\n', '\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    \n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        totalSupply = 200000000;  \n', '        balanceOf[msg.sender] = totalSupply;               \n', '        name = "CTB";                                  \n', '        symbol = "ȼ";                           \n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '       function _transfer(address _from, address _to, uint _value) internal {\n', '        \n', '        require(_to != 0x0);\n', '       \n', '        require(balanceOf[_from] >= _value);\n', '       \n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        \n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        \n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        \n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     \n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '       require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);           \n', '        totalSupply = totalSupply.sub(_value);                      \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                     \n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);       \n', '        totalSupply = totalSupply.sub(_value);                        \n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract CTBCoin is owned, TokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() TokenERC20() public {}\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                    \n', '        require (balanceOf[_from] >= _value);             \n', '        require (balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);                      \n', '        balanceOf[_from] -= _value;                        \n', '        balanceOf[_to] += _value;                          \n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '}']