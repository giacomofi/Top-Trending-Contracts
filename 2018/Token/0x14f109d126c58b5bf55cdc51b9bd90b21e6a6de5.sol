['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 15;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowanceEliminate;\n', '    mapping (address => mapping (address => uint256)) public allowanceTransfer;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount Eliminatet\n', '    event Eliminate(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use Eliminate() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowanceTransfer[_from][msg.sender]);     // Check allowance\n', '        allowanceTransfer[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approveTransfer(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowanceTransfer[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can Eliminate\n', '     */\n', '    function approveEliminate(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowanceEliminate[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to Eliminate\n', '     */\n', '    function eliminate(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Eliminate(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to Eliminate\n', '     */\n', '    function eliminateFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                    // Check if the targeted balance is enough\n', '        require(_value <= allowanceEliminate[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                             // Subtract from the targeted balance\n', "        allowanceEliminate[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                                  // Update totalSupply\n', '        Eliminate(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract RESToken is owned, TokenERC20 {\n', '\n', '    uint256 initialSellPrice = 1000; \n', '    uint256 initialBuyPrice = 1000;\n', '    uint256 initialSupply = 8551000000; // the projected number of people in 2030\n', '    string tokenName = "Resource";\n', '    string tokenSymbol = "RES";\n', '\n', '    uint256 public sellPrice; \n', '    uint256 public buyPrice;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function RESToken() TokenERC20(initialSupply, tokenName, tokenSymbol) public {\n', '        sellPrice = initialSellPrice;\n', '        buyPrice = initialBuyPrice;\n', '        allowanceEliminate[this][msg.sender] = initialSupply / 2 * (10 ** uint256(decimals)); \n', '    }\n', '\n', '    /// @notice update the price based on the remaining count of resources\n', '    function updatePrice() public {\n', '        sellPrice = initialSellPrice * initialSupply / totalSupply;\n', '        buyPrice = initialBuyPrice * initialSupply / totalSupply;\n', '    }\n', '\n', '    /// @notice Buy tokens from contract by sending ether\n', '    function buy() payable public {\n', '        uint amount = msg.value * 1000 / buyPrice;        // calculates the amount (1 eth == 1000 finney)\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '    }\n', '\n', '    /// @notice Sell `amount` tokens to contract\n', '    /// @param amount amount of tokens to be sold\n', '    function sell(uint256 amount) public {\n', '        require(this.balance >= amount * sellPrice / 1000); // checks if the contract has enough ether to buy\n', '        _transfer(msg.sender, this, amount);                // makes the transfers\n', "        msg.sender.transfer(amount * sellPrice / 1000);     // sends ether to the seller. It's important to do this last to avoid recursion attacks\n", '    }\n', '    \n', '}']