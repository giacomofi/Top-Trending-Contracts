['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '    uint256 public MaxICOSellSupply;\n', '    uint256 public CoinsRemainAfterICO;\n', "    uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.\n", '    uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?\n', '    address public fundsWallet;           // Where should the raised ETH go?\n', '    uint public deadline;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20() public {\n', '\n', '        totalSupply = 10000000 * 1 ether;                        // Update total supply (1000 for example) (CHANGE THIS)\n', '        MaxICOSellSupply = 9000000 * 1 ether;\n', '        CoinsRemainAfterICO = totalSupply - MaxICOSellSupply;\n', '        balanceOf[msg.sender] = totalSupply;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)\n', '        name = "Reference Line Coin";                                   // Set the name for display purposes (CHANGE THIS)\n', '        decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)\n', '        symbol = "RECO";                                             // Set the symbol for display purposes (CHANGE THIS)\n', '        unitsOneEthCanBuy = 10000;                                      // Set the price of your token for the ICO (CHANGE THIS)\n', '        fundsWallet = msg.sender;                                    // The owner of the contract gets ETH\n', '        deadline = now + 90000 * 1 minutes;  //ca 2 Monate ICO Periode\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function() payable public{\n', '        uint256 amount = msg.value * unitsOneEthCanBuy;\n', '        require(now < deadline);\n', '        require(balanceOf[fundsWallet] > amount);\n', '        require(balanceOf[fundsWallet]-amount > CoinsRemainAfterICO ); //Change CAD-KAS: do not sell CoinsRemainAfterICO tokens at the ICO\n', '\n', '        totalEthInWei = totalEthInWei + msg.value;\n', '\n', '        balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;\n', '        balanceOf[msg.sender] = balanceOf[msg.sender] + amount;\n', '\n', '        Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain\n', '\n', '        //Transfer ether to fundsWallet\n', '        fundsWallet.transfer(msg.value);\n', '    }\n', '\n', '}']