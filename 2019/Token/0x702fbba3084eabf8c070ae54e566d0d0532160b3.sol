['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-05\n', '*/\n', '\n', 'pragma solidity >=0.4.22 <0.6.0;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }\n', '\n', 'contract TokenBase {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        totalSupply = 1;                      // Set the initial total supply\n', '        balanceOf[msg.sender] = totalSupply;  // Send the initial total supply to the creator the contract\n', '        name = "Microcoin";                   // Set the name for display purposes\n', '        symbol = "MCR";                       // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != address(0x0));\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, address(this), _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Microcoin is owned, TokenBase {\n', '    uint256 public buyPrice;\n', '    bool public canBuy;\n', '\n', '    mapping (address => bool) public isPartner;\n', '    mapping (address => uint256) public partnerMaxMint;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() TokenBase() public {\n', '        canBuy = false;\n', '        buyPrice = 672920000000000;\n', '    }\n', '\n', '    /// @notice Register a new partner. (admins only)\n', '    /// @param partnerAddress The address of the partner\n', '    /// @param maxMint The maximum amount the partner can mint\n', '    function registerPartner(address partnerAddress, uint256 maxMint) onlyOwner public {\n', '        isPartner[partnerAddress] = true;\n', '        partnerMaxMint[partnerAddress] = maxMint;\n', '    }\n', '\n', '    /// @notice Edit the maximum amount mintable by a partner. (admins only)\n', '    /// @param partnerAddress The address of the partner\n', '    /// @param maxMint The (new) maximum amount the partner can mint\n', '    function editPartnerMaxMint(address partnerAddress, uint256 maxMint) onlyOwner public {\n', '        partnerMaxMint[partnerAddress] = maxMint;\n', '    }\n', '\n', '    /// @notice Remove a partner from the system. (admins only)\n', '    /// @param partnerAddress The address of the partner\n', '    function removePartner(address partnerAddress) onlyOwner public {\n', '        isPartner[partnerAddress] = false;\n', '        partnerMaxMint[partnerAddress] = 0;\n', '    }\n', '\n', '    /* Internal mint, can only be called by this contract */\n', '    function _mintToken(address target, uint256 mintedAmount, bool purchased) internal {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(address(0), address(this), mintedAmount);\n', '        emit Transfer(address(this), target, mintedAmount);\n', '        if (purchased == true) {\n', '            /* To prevent attacks, the equivalent amount of tokens purchased is sent to the creator of the contract. */\n', '            balanceOf[owner] += mintedAmount;\n', '            totalSupply += mintedAmount;\n', '            emit Transfer(address(0), address(this), mintedAmount);\n', '            emit Transfer(address(this), owner, mintedAmount);\n', '        }\n', '    }\n', '    \n', '    /// @notice Create `mintedAmount` tokens and send it to `target` (for partners)\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount The amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) public {\n', '        require(isPartner[msg.sender] == true);\n', '        require(partnerMaxMint[msg.sender] >= mintedAmount);\n', '        _mintToken(target, mintedAmount, true);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target` (admins only)\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount The amount of tokens it will receive\n', '    /// @param simulatePurchase Whether or not to treat the minted token as purchased\n', '    function adminMintToken(address target, uint256 mintedAmount, bool simulatePurchase) onlyOwner public {\n', '        _mintToken(target, mintedAmount, simulatePurchase);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public {\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    /// @notice Toggle buying tokens from the contract\n', '    /// @param newCanBuy Whether or not users can buy tokens from the contract\n', '    function toggleBuy(bool newCanBuy) onlyOwner public {\n', '        canBuy = newCanBuy;\n', '    }\n', '\n', '    /// @notice Donate ether to the Microcoin project\n', '    function () payable external {\n', '        if (canBuy == true) {\n', '            uint amount = msg.value / buyPrice;               // calculates the amount\n', '            _mintToken(address(this), amount, true);          // mints tokens\n', '            _transfer(address(this), msg.sender, amount);     // makes the transfers\n', '        }\n', '    }\n', '\n', '    /// @notice Withdraw ether from the contract\n', '    function withdrawEther() onlyOwner public {\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '}']
['pragma solidity >=0.4.22 <0.6.0;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }\n', '\n', 'contract TokenBase {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        totalSupply = 1;                      // Set the initial total supply\n', '        balanceOf[msg.sender] = totalSupply;  // Send the initial total supply to the creator the contract\n', '        name = "Microcoin";                   // Set the name for display purposes\n', '        symbol = "MCR";                       // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != address(0x0));\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, address(this), _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Microcoin is owned, TokenBase {\n', '    uint256 public buyPrice;\n', '    bool public canBuy;\n', '\n', '    mapping (address => bool) public isPartner;\n', '    mapping (address => uint256) public partnerMaxMint;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() TokenBase() public {\n', '        canBuy = false;\n', '        buyPrice = 672920000000000;\n', '    }\n', '\n', '    /// @notice Register a new partner. (admins only)\n', '    /// @param partnerAddress The address of the partner\n', '    /// @param maxMint The maximum amount the partner can mint\n', '    function registerPartner(address partnerAddress, uint256 maxMint) onlyOwner public {\n', '        isPartner[partnerAddress] = true;\n', '        partnerMaxMint[partnerAddress] = maxMint;\n', '    }\n', '\n', '    /// @notice Edit the maximum amount mintable by a partner. (admins only)\n', '    /// @param partnerAddress The address of the partner\n', '    /// @param maxMint The (new) maximum amount the partner can mint\n', '    function editPartnerMaxMint(address partnerAddress, uint256 maxMint) onlyOwner public {\n', '        partnerMaxMint[partnerAddress] = maxMint;\n', '    }\n', '\n', '    /// @notice Remove a partner from the system. (admins only)\n', '    /// @param partnerAddress The address of the partner\n', '    function removePartner(address partnerAddress) onlyOwner public {\n', '        isPartner[partnerAddress] = false;\n', '        partnerMaxMint[partnerAddress] = 0;\n', '    }\n', '\n', '    /* Internal mint, can only be called by this contract */\n', '    function _mintToken(address target, uint256 mintedAmount, bool purchased) internal {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(address(0), address(this), mintedAmount);\n', '        emit Transfer(address(this), target, mintedAmount);\n', '        if (purchased == true) {\n', '            /* To prevent attacks, the equivalent amount of tokens purchased is sent to the creator of the contract. */\n', '            balanceOf[owner] += mintedAmount;\n', '            totalSupply += mintedAmount;\n', '            emit Transfer(address(0), address(this), mintedAmount);\n', '            emit Transfer(address(this), owner, mintedAmount);\n', '        }\n', '    }\n', '    \n', '    /// @notice Create `mintedAmount` tokens and send it to `target` (for partners)\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount The amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) public {\n', '        require(isPartner[msg.sender] == true);\n', '        require(partnerMaxMint[msg.sender] >= mintedAmount);\n', '        _mintToken(target, mintedAmount, true);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target` (admins only)\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount The amount of tokens it will receive\n', '    /// @param simulatePurchase Whether or not to treat the minted token as purchased\n', '    function adminMintToken(address target, uint256 mintedAmount, bool simulatePurchase) onlyOwner public {\n', '        _mintToken(target, mintedAmount, simulatePurchase);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public {\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    /// @notice Toggle buying tokens from the contract\n', '    /// @param newCanBuy Whether or not users can buy tokens from the contract\n', '    function toggleBuy(bool newCanBuy) onlyOwner public {\n', '        canBuy = newCanBuy;\n', '    }\n', '\n', '    /// @notice Donate ether to the Microcoin project\n', '    function () payable external {\n', '        if (canBuy == true) {\n', '            uint amount = msg.value / buyPrice;               // calculates the amount\n', '            _mintToken(address(this), amount, true);          // mints tokens\n', '            _transfer(address(this), msg.sender, amount);     // makes the transfers\n', '        }\n', '    }\n', '\n', '    /// @notice Withdraw ether from the contract\n', '    function withdrawEther() onlyOwner public {\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '}']