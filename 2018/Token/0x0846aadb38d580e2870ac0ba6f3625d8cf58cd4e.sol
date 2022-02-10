['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract stoppable{\n', '    /// share holder\n', '    struct ShareHolder {\n', '        address addr;// shareholder address\n', '        bool agree;// authorized\n', '    }\n', '\n', '    ShareHolder[] public shareHolders4;// exactly 4, constructor param\n', '\n', '    function _sh_init(address[] shareHolderAddresses4) internal {\n', '        require(shareHolderAddresses4.length==4,"only support 4 shareholders.");\n', '        for (uint i = 0; i < shareHolderAddresses4.length; i++) {\n', '            shareHolders4.push(ShareHolder({\n', '                addr: shareHolderAddresses4[i],\n', '                agree: false\n', '            }));\n', '        }\n', '    }\n', '\n', '    function _sh_index(address target) internal view returns (uint) {\n', '        for(uint i=0;i<shareHolders4.length;i++){\n', '            if(target == shareHolders4[i].addr){\n', '                return i;\n', '            }\n', '        }\n', '        return shareHolders4.length;\n', '    }\n', '\n', '    function _sh_clear_agree() internal {\n', '        for(uint i=0;i<shareHolders4.length;i++){\n', '            shareHolders4[i].agree = false;\n', '        }\n', '    }\n', '\n', '    function sh_doAgree() public {\n', '        uint i = _sh_index(msg.sender);\n', '        require(i<shareHolders4.length, "not valid shareholder.");\n', '\n', '        shareHolders4[i].agree = true;\n', '    }\n', '\n', '    function sh_doTransfer(address other) public {\n', '        uint i1 = _sh_index(msg.sender);\n', '        require(i1<shareHolders4.length,"self is not valid shareholder.");\n', '\n', '        uint i2 = _sh_index(other);\n', '        require(i2==shareHolders4.length,"other is alreay shareholder.");\n', '\n', '        shareHolders4[i1].addr = other;\n', '        shareHolders4[i1].agree = false;\n', '    }\n', '\n', '    modifier sh_agreed {\n', '        uint sum = 0;\n', '        for(uint i=0;i<shareHolders4.length;i++){\n', '            if(shareHolders4[i].agree){\n', '                sum += 1;\n', '            }\n', '        }\n', '        require(sum >= 3, "need at least 3 shareholders to agree.");\n', '        _;\n', '    }\n', '\n', '    /// running\n', '\n', '    bool public isRunning = true;\n', '\n', '    function start() public sh_agreed returns (bool currentStatus) {\n', '        require(!isRunning, "contract is running already.");\n', '        isRunning = true;\n', '        _sh_clear_agree();\n', '        return isRunning;\n', '    }\n', '\n', '    function stop() public sh_agreed returns (bool currentStatus) {\n', '        require(isRunning, "contract is not running already.");\n', '        isRunning = false;\n', '        _sh_clear_agree();\n', '        return isRunning;\n', '    }\n', '\n', '    modifier ifRunning {\n', '        require(isRunning, "contract is not running.");\n', '        _;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 is stoppable{\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public ifRunning returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public ifRunning returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public ifRunning\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public ifRunning\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public ifRunning returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public ifRunning returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', '\n', 'contract MyAdvancedToken is owned, TokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        address[] shareHolderAddresses4\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {\n', '        _sh_init(shareHolderAddresses4);\n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) public onlyOwner {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) public onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public ifRunning {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '    }\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public ifRunning {\n', '        address myAddress = this;\n', '        require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);              // makes the transfers\n', "        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '    }\n', '}']