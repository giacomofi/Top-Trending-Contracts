['/**\n', '* The BIGFARM Coin contract bases on the ERC20 standard token contracts\n', '* Author: Farm Suk Jai Social Enterprise\n', '*/\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract Authorizable is owned {\n', '\n', '    struct Authoriz{\n', '        uint index;\n', '        address account;\n', '    }\n', '    \n', '    mapping(address => bool) public authorized;\n', '    mapping(address => Authoriz) public authorizs;\n', '    address[] public authorizedAccts;\n', '\n', '    modifier onlyAuthorized() {\n', '        if(authorizedAccts.length >0)\n', '        {\n', '            require(authorized[msg.sender] == true || owner == msg.sender);\n', '            _;\n', '        }else{\n', '            require(owner == msg.sender);\n', '            _;\n', '        }\n', '     \n', '    }\n', '\n', '    function addAuthorized(address _toAdd) \n', '        onlyOwner \n', '        public \n', '    {\n', '        require(_toAdd != 0);\n', '        require(!isAuthorizedAccount(_toAdd));\n', '        authorized[_toAdd] = true;\n', '        Authoriz storage authoriz = authorizs[_toAdd];\n', '        authoriz.account = _toAdd;\n', '        authoriz.index = authorizedAccts.push(_toAdd) -1;\n', '    }\n', '\n', '    function removeAuthorized(address _toRemove) \n', '        onlyOwner \n', '        public \n', '    {\n', '        require(_toRemove != 0);\n', '        require(_toRemove != msg.sender);\n', '        authorized[_toRemove] = false;\n', '    }\n', '    \n', '    function isAuthorizedAccount(address account) \n', '        public \n', '        constant \n', '        returns(bool isIndeed) \n', '    {\n', '        if(account == owner) return true;\n', '        if(authorizedAccts.length == 0) return false;\n', '        return (authorizedAccts[authorizs[account].index] == account);\n', '    }\n', '\n', '}\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/******************************************/\n', '/* BIGFARM COIN STARTS HERE               */\n', '/******************************************/\n', '\n', 'contract BIGFARMCoin is Authorizable, TokenERC20 {\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    /// Maximum tokens to be allocated on the sale\n', '    uint256 public tokenSaleHardCap;\n', '    /// Base exchange rate is set to 1 ETH = BIF.\n', '    uint256 public baseRate;\n', '\n', '   /// no tokens can be ever issued when this is set to "true"\n', '    bool public tokenSaleClosed = false;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    modifier inProgress {\n', '        require(totalSupply < tokenSaleHardCap\n', '            && !tokenSaleClosed);\n', '        _;\n', '    }\n', '\n', '    modifier beforeEnd {\n', '        require(!tokenSaleClosed);\n', '        _;\n', '    }\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {\n', '        tokenSaleHardCap = 3376050000 * 10**uint256(decimals); // Default Crowsale Hard Cap amount with decimals\n', '        baseRate = 4000 * 10**uint256(decimals); // Default base rate BIF :1 eth amount with decimals\n', '    }\n', '\n', '    /// @dev This default function allows token to be purchased by directly\n', '    /// sending ether to this smart contract.\n', '    function () public payable {\n', '       purchaseTokens(msg.sender);\n', '    }\n', '    \n', '    /// @dev Issue token based on Ether received.\n', '    /// @param _beneficiary Address that newly issued token will be sent to.\n', '    function purchaseTokens(address _beneficiary) public payable inProgress{\n', '        // only accept a minimum amount of ETH?\n', '        require(msg.value >= 0.01 ether);\n', '\n', '        uint _tokens = computeTokenAmount(msg.value); \n', '        doIssueTokens(_beneficiary, _tokens);\n', '        /// forward the raised funds to the contract creator\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyAuthorized public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyAuthorized public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newRatePrice` eth \n', '    /// @param newRate Price the users can sell to the contract\n', '    function setRatePrices(uint256 newRate) onlyAuthorized public {\n', '        baseRate = newRate;\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newTokenSaleHardCap` BIF \n', '    /// @param newTokenSaleHardCap Amount of BIF token sale hard cap\n', '    function setTokenSaleHardCap(uint256 newTokenSaleHardCap) onlyAuthorized public {\n', '        tokenSaleHardCap = newTokenSaleHardCap;\n', '    }\n', '\n', '    function doIssueTokens(address _beneficiary, uint256 _tokens) internal {\n', '        require(_beneficiary != address(0));\n', '        balanceOf[_beneficiary] += _tokens;\n', '        totalSupply += _tokens;\n', '        emit Transfer(0, this, _tokens);\n', '        emit Transfer(this, _beneficiary, _tokens);\n', '    }\n', '\n', '    /// @dev Compute the amount of BIF token that can be purchased.\n', '    /// @param ethAmount Amount of Ether in WEI to purchase BIF.\n', '    /// @return Amount of BIF token to purchase\n', '    function computeTokenAmount(uint256 ethAmount) internal view returns (uint256) {\n', '        uint256 tokens = ethAmount.mul(baseRate) / 10**uint256(decimals);\n', '        return tokens;\n', '    }\n', '\n', '    /// @notice collect ether to owner account\n', '    function collect() external onlyAuthorized {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    /// @notice getBalance ether\n', '    function getBalance() public view onlyAuthorized returns (uint) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    /// @dev Closes the sale, issues the team tokens and burns the unsold\n', '    function close() public onlyAuthorized beforeEnd {\n', '        tokenSaleClosed = true;\n', '        /// forward the raised funds to the contract creator\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    /// @dev Open the sale status\n', '    function openSale() public onlyAuthorized{\n', '        tokenSaleClosed = false;\n', '    }\n', '\n', '}']