['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function multiply(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     */\n', '    function division(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function subtract(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     */\n', '    function plus(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns(uint256);\n', '\n', '    function balanceOf(address who) public view returns(uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath\n', '    for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '     * @dev total number of tokens in existence\n', '     */\n', '    function totalSupply() public view returns(uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    /*\n', '    function _transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].subtract(_value);\n', '        balances[_to] = balances[_to].plus(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    */\n', '\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[_from] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to].plus(_value) > balances[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balances[_from].plus(balances[_to]);\n', '        // Subtract from the sender\n', '        balances[_from] = balances[_from].subtract(_value);\n', '        // Add the same to the recipient\n', '        balances[_to] = balances[_to].plus(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[_from].plus(balances[_to]) == previousBalances);\n', '\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].subtract(_value);\n', '        balances[_to] = balances[_to].plus(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].subtract(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].plus(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.subtract(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SimpleToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `StandardToken` functions.\n', ' */\n', 'contract LBCoinJ is owned, StandardToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    bool public emergencyStop;\n', '\n', '    mapping(address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    event Emergency(bool stop);\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\n', '    \n', '    /// @dev Constructor that gives msg.sender all of existing tokens.\n', '    function LBCoinJ(string tokenName, string tokenSymbol, uint256 initialSupply) public {\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        totalSupply_ = initialSupply * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply_;\n', '        emit Transfer(0x0, msg.sender, totalSupply_);\n', '    }\n', '    \n', '    \n', '    /*\n', '    function LBCoinJ() public {\n', '        name = "LBCoinTest2";\n', '        symbol = "LBCTS";\n', '        totalSupply_ = 10000 * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply_;\n', '        emit Transfer(0x0, msg.sender, totalSupply_);\n', '    }\n', '    */\n', '    \n', '\n', '\n', '    /// Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balances[_from] >= _value); // Check if the sender has enough\n', '        require(balances[_to].plus(_value) >= balances[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]); // Check if sender is frozen\n', '        require(!frozenAccount[_to]); // Check if recipient is frozen\n', '        require(!emergencyStop); // Check Emergency\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[_from] = balances[_from].subtract(_value);\n', '        balances[_to] = balances[_to].plus(_value);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /// @notice Create `mintedAmount` tokens and send it to `target`\n', '    /// @param target Address to receive the tokens\n', '    /// @param mintedAmount the amount of tokens it will receive\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balances[target] = balances[target].plus(mintedAmount);\n', '        totalSupply_ = totalSupply_.plus(mintedAmount);\n', '        emit Transfer(0, this, mintedAmount);\n', '        emit Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    /// @notice Destroy tokens\n', '    /// @notice Remove `_value` tokens from the system irreversibly\n', '    /// @param _value the amount of money to burn\n', '    function burn(uint256 _value) public returns(bool success) {\n', '        require(balances[msg.sender] >= _value); // Check if the sender has enough\n', '        balances[msg.sender] = balances[msg.sender].subtract(_value); // Subtract from the sender\n', '        totalSupply_ = totalSupply_.subtract(_value); // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '    /// @param target Address to be frozen\n', '    /// @param freeze either to freeze it or not\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth\n', '    /// @param newSellPrice Price the users can sell to the contract\n', '    /// @param newBuyPrice Price users can buy from the contract\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    // setting emergency stop !!\n', '    function emergency(bool stop) onlyOwner public {\n', '        emergencyStop = stop;\n', '        emit Emergency(emergencyStop);\n', '    }\n', '}']