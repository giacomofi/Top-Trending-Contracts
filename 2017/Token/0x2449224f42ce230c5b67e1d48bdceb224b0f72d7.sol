['pragma solidity ^0.4.16;\n', 'contract owned {\n', '    address public owner;\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\t\n', '}\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', 'contract TokenERC20 {\n', '    string public name = "DIVMGroup";\n', '    string public symbol = "DIVM";\n', '    uint8 public decimals = 18;\n', '\tuint256 public initialSupply = 10000;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    function TokenERC20() public {\n', '    totalSupply = initialSupply * 1 ether;\n', '    balanceOf[msg.sender] = totalSupply;\n', '  }\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);  \t\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] -= _value;                         \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              \n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', 'contract MyAdvancedToken is owned, TokenERC20 {\n', '\taddress public beneficiary;\n', '\taddress public reserveFund;\n', '\taddress public Bounty;\n', '    uint256 public sellPriceInWei;\n', '    uint256 public buyPriceInWei;\n', '\tuint256 public Limit;\n', '\tuint256 public issueOfTokens;\n', '    bool    public TokenSaleStop = false;\n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '\t\n', '    function MyAdvancedToken()  public {\n', '\tbeneficiary = 0xe0C3c3FBA6D9793EDCeA6EA18298Fe22310Ed094;\n', '\tBounty = 0xC87bB60EB3f7052f66E60BB5d961Eeffee1A8765;\n', '\treserveFund = 0x60ab253bD32429ACD4242f14F54A8e50E233c0C5;\n', '\t}\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \n', '        require (balanceOf[_from] > _value);               \n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        require(!frozenAccount[_from]);                    \n', '        require(!frozenAccount[_to]);                       \n', '        balanceOf[_from] -= _value;                        \n', '        balanceOf[_to] += _value;                          \n', '        Transfer(_from, _to, _value);\n', '    }\n', '\t\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner  public  {\n', '\t    require (!TokenSaleStop);\n', '        require (mintedAmount <= 7000000 * 1 ether - totalSupply);\n', '        require (totalSupply + mintedAmount <= 7000000 * 1 ether); \n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '\t\tissueOfTokens = totalSupply / 1 ether - initialSupply;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price in wei the users can sell to the contract\n', '    /// @param newBuyPrice Price in wei users can buy from the contract  \n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice, uint256 newLimit) onlyOwner public {\n', '        sellPriceInWei = newSellPrice;\n', '        buyPriceInWei = newBuyPrice;\n', '\t\tLimit = newLimit;\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether  \n', '    function () payable public {\n', '\t    require (msg.value * Limit / 1 ether > 1);\n', '\t    require (!TokenSaleStop);\n', '        uint amount = msg.value * 1 ether / buyPriceInWei;               \n', '        _transfer(this, msg.sender, amount);\n', '        if (this.balance > 2 ether) {\n', '\t\tBounty.transfer(msg.value / 40);}\t\t\n', '\t\tif (this.balance > 10 ether) {\n', '\t\treserveFund.transfer(msg.value / 7);}\n', '    }\n', '\n', '    function forwardFunds(uint256 withdraw) onlyOwner public {\n', '\t     require (withdraw > 0);\n', '         beneficiary.transfer(withdraw * 1 ether);  \n', '  }\n', '\t\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount  of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '\t    require (amount > Limit);\n', '\t    require (!TokenSaleStop);\n', '        require(this.balance >= amount * sellPriceInWei);       \n', '        _transfer(msg.sender, this, amount * 1 ether);              \n', '        msg.sender.transfer(amount * sellPriceInWei);          \n', '    }\n', '    \t  \n', '  function crowdsaleStop(bool Stop) onlyOwner public {\n', '      TokenSaleStop = Stop;\n', '  }\n', '}']