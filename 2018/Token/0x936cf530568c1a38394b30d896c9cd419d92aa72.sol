['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract owned {\n', '    address public Owner; \n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */    \n', '    function owned() public{\n', '        Owner = msg.sender;\n', '    }\n', '    \n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyOwner(){\n', '        require(msg.sender == Owner);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */   \n', '    function TransferOwnership(address newOwner) onlyOwner public {\n', '        Owner = newOwner;\n', '    }\n', '    \n', '  /**\n', '   * @dev Terminates contract when called by the owner.\n', '   */\n', '    function abort() onlyOwner public {\n', '        selfdestruct(Owner);\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract ZegartToken is owned {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    string public version;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default\n', '    uint256 public totalSupply;\n', '    bool tradable;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public frozenAccounts;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '    // ether received to contract\n', '    event RecieveEth(address indexed _from, uint256 _value);\n', '    // ether transferred from contract\n', '    event WithdrawEth(address indexed _to, uint256 _value);\n', '    // allowance for other addresses\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    //tokens sold to users\n', '    event SoldToken(address _buyer, uint256 _value, string note);\n', '    // tokens granted to users\n', '    event BonusToken(address _customer, uint256 _value, string note);\n', '\n', '    /// fallback function\n', '    function () payable public {\n', '        RecieveEth(msg.sender, msg.value);     \n', '    }\n', '    \n', '    function withdrawal(address _to, uint256 Ether, uint256 Token) onlyOwner public {\n', '        require(this.balance >= Ether && balances[this] >= Token );\n', '        \n', '        if(Ether >0){\n', '            _to.transfer(Ether);\n', '            WithdrawEth(_to, Ether);\n', '        }\n', '        \n', '        if(Token > 0)\n', '\t\t{\n', '\t\t\trequire(balances[_to] + Token > balances[_to]);\n', '\t\t\tbalances[this] -= Token;\n', '\t\t\tbalances[_to] += Token;\n', '\t\t\tTransfer(this, _to, Token);\n', '\t\t}\n', '        \n', '    }\n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function ZegartToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        string contractversion\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;         // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        version = contractversion;                          // Set the contract version for display purposes\n', '        \n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\n', '        // Check if sender is frozen\n', '        require(!frozenAccounts[_from]); \n', '        // Check if recipient is frozen                    \n', '        require(!frozenAccounts[_to]);                       \n', '        // Save this for an assertion in the future\n', '        uint previousBalanceOf = balances[_from] + balances[_to];\n', '        // Subtract from the sender\n', '        balances[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from] + balances[_to] == previousBalanceOf);\n', '    }\n', '\n', '    /// @notice Grant tokens to customers\n', '    /// @param _customer Address of account which will receive tokens\n', '    /// @param _value uint256 the amount to be transferred.\n', '    function GrantToken(address _customer, uint256 _value, string note) onlyOwner public {\n', '        require(balances[msg.sender] >= _value && balances[_customer] + _value > balances[_customer]);\n', '        \n', '        BonusToken( _customer,  _value,  note);\n', '        balances[msg.sender] -= _value;\n', '        balances[_customer] += _value;\n', '        Transfer(msg.sender, _customer, _value);\n', '    }\n', '    \n', '    /// @notice Buy quantity of tokens depending on the amount of sent ethers.\n', '    /// @param _buyer Address of account which will receive tokens\n', '    /// @param _value uint256 the amount to be transferred.\n', '    function BuyToken(address _buyer, uint256 _value, string note) onlyOwner public {\n', '        require(balances[msg.sender] >= _value && balances[_buyer] + _value > balances[_buyer]);\n', '        \n', '        SoldToken( _buyer,  _value,  note);\n', '        balances[msg.sender] -= _value;\n', '        balances[_buyer] += _value;\n', '        Transfer(msg.sender, _buyer, _value);\n', '    }\n', '\n', '    /// @notice forbid specified address from sending & receiving tokens\n', '    function FreezeAccount(address toFreeze) onlyOwner public {\n', '        frozenAccounts[toFreeze] = true;\n', '    }\n', '    /// @notice allow specified address sending & receiving tokens\n', '    function UnfreezeAccount(address toUnfreeze) onlyOwner public {\n', '        delete frozenAccounts[toUnfreeze];\n', '    }\n', '    /// @notice let users trade with the token\n', '    function MakeTradable(bool t) onlyOwner public {\n', '        tradable = t;\n', '    }\n', '    /// @notice shows tradability of the contract\n', '    function Tradable() public view returns(bool) {\n', '        return tradable;\n', '    }\n', '    \n', '    modifier notFrozen(){\n', '       require (!frozenAccounts[msg.sender]);\n', '       _;\n', '    }\n', '    \n', '    /// @notice transfers sender&#39;s tokens to a specified address. \n', '    /// @param _to The address of the recipient.\n', '    /// @param _value The amount to be transferred.\n', '    function transfer(address _to, uint256 _value) public notFrozen returns (bool success) {\n', '        require(tradable);\n', '         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {\n', '             balances[msg.sender] -= _value;\n', '             balances[_to] += _value;\n', '             Transfer( msg.sender, _to,  _value);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '     }\n', '     \n', '     \n', '    /// @notice Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from address The address tokens are sending from.\n', '    /// @param _to address The address tokens are sending to.\n', '    /// @param _value the amount of tokens to be transferred. \n', '    function transferFrom(address _from, address _to, uint256 _value) public notFrozen returns (bool success) {\n', '        require(!frozenAccounts[_from] && !frozenAccounts[_to]);\n', '        require(tradable);\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {\n', '            balances[_from] -= _value;\n', '            balances[_to] += _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer( _from, _to,  _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @notice Retrieves the token balance of any single address.\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value the max amount they can spend\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        Approval(msg.sender,  _spender, _value);\n', '        allowed[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /// @notice Returns the amount which _spender is still allowed to withdraw from _owner\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '    /// @param _spender The address authorized to spend\n', '    /// @param _value the max amount they can spend\n', '    /// @param _extraData some extra information to send to the approved contract\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '\n', '    /// @notice Remove `_value` tokens from the system irreversibly\n', '    /// @param _value the amount of money to burn\n', '    /// @return True if the transfer was successful\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '   \n', '    /// @notice Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '    /// @param _from the address of the sender\n', '    /// @param _value the amount of money to burn\n', '    /// @return True if the transfer was successful\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowed[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '}']