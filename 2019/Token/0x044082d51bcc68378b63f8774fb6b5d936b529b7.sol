['pragma solidity 0.5.4;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    uint256 constant internal MAX_UINT = 2 ** 256 - 1; // max uint256\n', '\n', '    /**\n', '     * @dev Multiplies two numbers, reverts on overflow.\n', '     */\n', '    function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '        require(MAX_UINT / _a >= _b);\n', '        return _a * _b;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', '        require(_b != 0);\n', '        return _a / _b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', '        require(_b <= _a);\n', '        return _a - _b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, reverts on overflow.\n', '     */\n', '    function add(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', '        require(MAX_UINT - _a >= _b);\n', '        return _a + _b;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', 'contract StandardToken {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) internal balances;\n', '\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns(uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint256 _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns(bool) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '        totalSupply = totalSupply.sub(value);\n', '        balances[account] = balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        // this function needs to emit an event with the updated approval.\n', '        allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 value) public {\n', '        _burn(msg.sender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '     * @param from address The address which you want to send tokens from\n', '     * @param value uint256 The amount of token to be burned\n', '     */\n', '    function burnFrom(address from, uint256 value) public {\n', '        _burnFrom(from, value);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev ERC20 modified with pausable transfers.\n', ' */\n', 'contract PausableToken is StandardToken, Pausable {\n', '    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {\n', '        return super.approve(spender, value);\n', '    }\n', '\n', '    function increaseApproval(address spender, uint256 addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(spender, addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address spender, uint256 subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(spender, subtractedValue);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title token\n', ' * @dev Standard template for ERC20 Token\n', ' */\n', 'contract Token is PausableToken, BurnableToken {\n', '    string public name; \n', '    string public symbol; \n', '    uint8 public decimals;\n', '\n', '    /**\n', '     * @dev Constructor, to initialize the basic information of token\n', '     * @param _name The name of token\n', '     * @param _symbol The symbol of token\n', '     * @param _decimals The dicemals of token\n', '     * @param _INIT_TOTALSUPPLY The total supply of token\n', '     */\n', '    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _INIT_TOTALSUPPLY) public {\n', '        totalSupply = _INIT_TOTALSUPPLY * 10 ** uint256(_decimals);\n', '        balances[owner] = totalSupply; // Transfers all tokens to owner\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @dev Interface of BDR contract\n', ' */\n', 'interface BDRContract {\n', '    function tokenFallback(address _from, uint256 _value, bytes calldata _data) external;\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function decimals() external returns (uint8);\n', '}\n', '\n', '\n', '/**\n', ' * @title IOAEX ENTITY TOKEN\n', ' */\n', 'contract IOAEX is Token {\n', '    // The address of BDR contract\n', '    BDRContract public BDRInstance;\n', '    // The total amount of locked tokens at the specified address\n', '    mapping(address => uint256) public totalLockAmount;\n', '    // The released amount of the specified address\n', '    mapping(address => uint256) public releasedAmount;\n', '    // \n', '    mapping(address => timeAndAmount[]) public allocations;\n', '    // Stores the timestamp and the amount of tokens released each time\n', '    struct timeAndAmount {\n', '        uint256 releaseTime;\n', '        uint256 releaseAmount;\n', '    }\n', '    \n', '    // events\n', '    event LockToken(address _beneficiary, uint256 totalLockAmount);\n', '    event ReleaseToken(address indexed user, uint256 releaseAmount, uint256 releaseTime);\n', '    event ExchangeBDR(address from, uint256 value);\n', '    event SetBDRContract(address BDRInstanceess);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the BDR contract\n', '     */\n', '    modifier onlyBDRContract() {\n', '        require(msg.sender == address(BDRInstance));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Constructor, to initialize the basic information of token\n', '     */\n', '    constructor (string memory _name, string memory _symbol, uint8 _decimals, uint256 _INIT_TOTALSUPPLY) Token (_name, _symbol, _decimals, _INIT_TOTALSUPPLY) public {\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of BDR contract\n', '     */\n', '    function setBDRContract(address BDRAddress) public onlyOwner {\n', '        require(BDRAddress != address(0));\n', '        BDRInstance = BDRContract(BDRAddress);\n', '        emit SetBDRContract(BDRAddress);\n', '    }\n', '    \n', '    /**\n', '     * @dev The owner can call this function to send tokens to the specified address, but these tokens are only available for more than the specified time\n', '     * @param _beneficiary The address to receive tokens\n', '     * @param _releaseTimes Array, the timestamp for releasing token\n', '     * @param _releaseAmount Array, the amount for releasing token \n', '     */\n', '    function lockToken(address _beneficiary, uint256[] memory _releaseTimes, uint256[] memory _releaseAmount) public onlyOwner returns(bool) {\n', '        \n', '        require(totalLockAmount[_beneficiary] == 0); // The beneficiary is not in any lock-plans at the current timestamp.\n', '        require(_beneficiary != address(0)); // The beneficiary cannot be an empty address\n', '        require(_releaseTimes.length == _releaseAmount.length); // These two lists are equal in length.\n', '        releasedAmount[_beneficiary] = 0;\n', '        for (uint256 i = 0; i < _releaseTimes.length; i++) {\n', '            totalLockAmount[_beneficiary] = totalLockAmount[_beneficiary].add(_releaseAmount[i]);\n', '            require(_releaseAmount[i] > 0); // The amount to release is greater than 0.\n', '            require(_releaseTimes[i] >= now); // Each release time is not lower than the current timestamp.\n', '            // Saves the lock-token information\n', '            allocations[_beneficiary].push(timeAndAmount(_releaseTimes[i], _releaseAmount[i]));\n', '        }\n', '        balances[owner] = balances[owner].sub(totalLockAmount[_beneficiary]); // Removes this part of the locked token from the owner\n', '        emit LockToken(_beneficiary, totalLockAmount[_beneficiary]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Releases token\n', '     */\n', '    function releaseToken() public returns (bool) {\n', '        release(msg.sender); \n', '    }\n', '\n', '    /**\n', '     * @dev The basic function of releasing token\n', '     */\n', '    function release(address addr) internal {\n', '        require(totalLockAmount[addr] > 0); // The address has joined a lock-plan.\n', '\n', '        uint256 amount = releasableAmount(addr); // Gets the amount of release and updates the lock-plans data\n', '        // Unlocks token. Converting locked tokens into normal tokens\n', '        balances[addr] = balances[addr].add(amount);\n', '        // Updates the amount of released tokens.\n', '        releasedAmount[addr] = releasedAmount[addr].add(amount);\n', '        // If the token on this address has been completely released, clears the Record of locking token\n', '        if (releasedAmount[addr] == totalLockAmount[addr]) {\n', '            delete allocations[addr];\n', '            totalLockAmount[addr] = 0;\n', '        }\n', '        emit ReleaseToken(addr, amount, now);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the amount that can be released at current timestamps \n', '     * @param addr A specified address.\n', '     */\n', '    function releasableAmount(address addr) public view returns (uint256) {\n', '        if(totalLockAmount[addr] == 0) {\n', '            return 0;\n', '        }\n', '        uint256 num = 0;\n', '        for (uint256 i = 0; i < allocations[addr].length; i++) {\n', '            if (now >= allocations[addr][i].releaseTime) { // Determines the releasable stage under the current timestamp.\n', '                num = num.add(allocations[addr][i].releaseAmount);\n', '            }\n', '        }\n', '        return num.sub(releasedAmount[addr]); // the amount of current timestamps that can be released - the released amount.\n', '    }\n', '    \n', '    /**\n', '     * @dev Gets the amount of tokens that are still locked at current timestamp.\n', '     * @param addr A specified address.\n', '     */\n', '    function balanceOfLocked(address addr) public view returns(uint256) {\n', '        if (totalLockAmount[addr] > releasedAmount[addr]) {\n', '            return totalLockAmount[addr].sub(releasedAmount[addr]);\n', '        } else {\n', '            return 0;\n', '        }\n', '        \n', '    }\n', '\n', '    /**\n', '     * @dev Transfers token to a specified address. \n', "     *      If 'msg.sender' has releasable tokens, this part of the token will be released automatically.\n", '     *      If the target address of transferring is BDR contract, the operation of changing BDR tokens will be executed.\n', '     * @param to The target address of transfer, which may be the BDR contract\n', '     * @param value The amount of tokens transferred\n', '     */\n', '    function transfer(address to, uint value) public returns (bool) {\n', '        if(releasableAmount(msg.sender) > 0) {\n', "            release(msg.sender); // Calls 'release' function\n", '        }\n', "        super.transfer(to, value); // Transfers tokens to address 'to'\n", '        if(to == address(BDRInstance)) {\n', '            BDRInstance.tokenFallback(msg.sender, value, bytes("")); // Calls \'tokenFallback\' function in BDR contract to exchange tokens\n', '            emit ExchangeBDR(msg.sender, value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers tokens from one address to another.\n', "     *      If 'from' has releasable tokens, this part of the token will be released automatically.\n", '     *      If the target address of transferring is  BDR contract, the operation of changing BDR tokens will be executed.\n', '     * @param from The address which you want to send tokens from\n', '     * @param to The address which you want to transfer to\n', '     * @param value The amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint value) public returns (bool) {\n', '        if(releasableAmount(from) > 0) {\n', "            release(from); // Calls the 'release' function\n", '        }\n', "        super.transferFrom(from, to, value); // Transfers token to address 'to'\n", '        if(to == address(BDRInstance)) {\n', '            BDRInstance.tokenFallback(from, value, bytes("")); // Calls \'tokenFallback\' function in BDR contract to exchange tokens\n', '            emit ExchangeBDR(from, value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * @dev Function that is called by the BDR contract to exchange 'Abc' tokens\n", '     */\n', '    function tokenFallback(address from, uint256 value, bytes calldata) external onlyBDRContract {\n', '        require(from != address(0));\n', '        require(value != uint256(0));\n', '        \n', "        uint256 AbcValue = value.mul(10**uint256(decimals)).div(10**uint256(BDRInstance.decimals())); // Calculates the number of 'Abc' tokens that can be exchanged\n", '        require(AbcValue <= balances[address(BDRInstance)]);\n', '        balances[address(BDRInstance)] = balances[address(BDRInstance)].sub(AbcValue);\n', '        balances[from] = balances[from].add(AbcValue);\n', '        emit Transfer(owner, from, AbcValue);\n', '    }\n', '    \n', '}']