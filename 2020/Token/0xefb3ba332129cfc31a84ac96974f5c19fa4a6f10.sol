['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '     * SafeMath mul function\n', '     * @dev function for safe multiply, throws on overflow.\n', '     **/\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '  \t * SafeMath div function\n', '  \t * @dev function for safe devide, throws on overflow.\n', '  \t **/\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    /**\n', '  \t * SafeMath sub function\n', '  \t * @dev function for safe subtraction, throws on overflow.\n', '  \t **/\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '  \t * SafeMath add function\n', '  \t * @dev Adds two numbers, throws on overflow.\n', '  \t */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier isOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public isOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  event NotPausable();\n', '\n', '  bool public paused = false;\n', '  bool public canPause = true;\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     **/\n', '    function pause() isOwner whenNotPaused public {\n', '        require(canPause == true);\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() isOwner whenPaused public {\n', '    require(paused == true);\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '\n', '  /**\n', '     * @dev Prevent the token from ever being paused again\n', '     **/\n', '    function notPausable() isOwner public{\n', '        paused = false;\n', '        canPause = false;\n', '        emit NotPausable();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', '\n', 'contract StandardToken is Pausable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    /**\n', '     * @dev Returns the total supply of the token\n', '     **/\n', '    function totalSupply() public constant returns (uint256 supply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens when not paused\n', '     **/\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '            balances[_to] = balances[_to].add(_value);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    /**\n', '     * @dev transferFrom function to tansfer tokens when token is not paused\n', '     **/\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = balances[_to].add(_value);\n', '            balances[_from] = balances[_from].sub(_value);\n', '            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    /**\n', '     * @dev returns balance of the owner\n', '     **/\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev approve spender when not paused\n', '     **/\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        totalSupply = totalSupply.add(amount);\n', '        balances[account] = balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface with the features of the above declared standard token\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract POFI is StandardToken  {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', "    string public version = '1.0';\n", '    uint8 public decimals;\n', '    uint16 public exchangeRate;\n', '    uint256 public lockedTime;\n', '    uint256 public othersLockedTime;\n', '    uint256 public marketingLockedTime;\n', '\n', '    event TokenNameChanged(string indexed previousName, string indexed newName);\n', '    event TokenSymbolChanged(string indexed previousSymbol, string indexed newSymbol);\n', '    event ExchangeRateChanged(uint16 indexed previousRate, uint16 indexed newRate);\n', '\n', '    /**\n', '   * ERC20 Token Constructor\n', '   * @dev Create and issue tokens to msg.sender.\n', '   */\n', '    constructor (address privatesale, address presale, address marketing) public {\n', '        decimals        = 18;\n', '        exchangeRate    = 12566;\n', '        lockedTime     = 1632031991; // 1 year locked\n', '        othersLockedTime = 1609528192; // 3 months locked\n', '        marketingLockedTime = 1614625792; // 6 months locked\n', '        symbol          = "POFI";\n', '        name            = "PoFi Network";\n', '\n', '        mint(privatesale, 15000000 * 10**uint256(decimals)); // Privatesale 15% of the tokens\n', '        mint(presale, 10000000 * 10**uint256(decimals)); // Presale 10% of the tokens\n', '        mint(marketing, 5000000 * 10**uint256(decimals)); // Marketing/partnership/uniswap liquidity (5% of the tokens, the other 5% is locked for 6 months)\n', '        mint(address(this), 70000000 * 10**uint256(decimals)); // Team 10% of tokens locked for 1 year, Others(Audit/Dev) 5% of tokens locked for 3 months, marketing 5% of tokens locked for 6 months, rewards 50% of the total token supply is locked for 3 months\n', '\n', '\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev Function to change token name.\n', '     * @return A boolean.\n', '     */\n', '    function changeTokenName(string newName) public isOwner returns (bool success) {\n', '        emit TokenNameChanged(name, newName);\n', '        name = newName;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to change token symbol.\n', '     * @return A boolean.\n', '     */\n', '    function changeTokenSymbol(string newSymbol) public isOwner returns (bool success) {\n', '        emit TokenSymbolChanged(symbol, newSymbol);\n', '        symbol = newSymbol;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the exchangeRate.\n', '     * @return A boolean.\n', '     */\n', '    function changeExchangeRate(uint16 newRate) public isOwner returns (bool success) {\n', '        emit ExchangeRateChanged(exchangeRate, newRate);\n', '        exchangeRate = newRate;\n', '        return true;\n', '    }\n', '\n', '    function () public payable {\n', '        fundTokens();\n', '    }\n', '\n', '    /**\n', '     * @dev Function to fund tokens\n', '     */\n', '    function fundTokens() public payable {\n', '        require(msg.value > 0);\n', '        uint256 tokens = msg.value.mul(exchangeRate);\n', '        require(balances[owner].sub(tokens) > 0);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        balances[owner] = balances[owner].sub(tokens);\n', '        emit Transfer(msg.sender, owner, tokens);\n', '        forwardFunds();\n', '    }\n', '    /**\n', '     * @dev Function to forward funds internally.\n', '     */\n', '    function forwardFunds() internal {\n', '        owner.transfer(msg.value);\n', '    }\n', '\n', '    /**\n', '     * @notice Release locked tokens of team.\n', '     */\n', '    function releaseTeamLockedPOFI() public isOwner returns(bool){\n', '        require(block.timestamp >= lockedTime, "Tokens are locked in the smart contract until respective release Time ");\n', '\n', '        uint256 amount = balances[address(this)];\n', '        require(amount > 0, "TokenTimelock: no tokens to release");\n', '\n', '        emit Transfer(address(this), msg.sender, amount);\n', '\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Release locked tokens of Others(Dev/Audit).\n', '     */\n', '    function releaseOthersLockedPOFI() public isOwner returns(bool){\n', '        require(block.timestamp >= othersLockedTime, "Tokens are locked in the smart contract until respective release time");\n', '\n', '        uint256 amount = 5000000; // 5M others locked tokens which will be released after 3 months\n', '\n', '        emit Transfer(address(this), msg.sender, amount);\n', '\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Release locked tokens of Marketing.\n', '     */\n', '    function releaseMarketingLockedPOFI() public isOwner returns(bool){\n', '        require(block.timestamp >= marketingLockedTime, "Tokens are locked in the smart contract until respective release time");\n', '\n', '        uint256 amount = 5000000; // 5M others locked tokens which will be released after 3 months\n', '\n', '        emit Transfer(address(this), msg.sender, amount);\n', '\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @notice Release locked tokens of Rewards(Staking/Liqudity incentive mining).\n', '     */\n', '    function releaseRewardsLockedPOFI() public isOwner returns(bool){\n', '        require(block.timestamp >= othersLockedTime, "Tokens are locked in the smart contract until respective release time");\n', '\n', '        uint256 amount = 50000000; // 50M rewards locked tokens which will be released after 3 months\n', '\n', '        emit Transfer(address(this), msg.sender, amount);\n', '\n', '        return true;\n', '    }\n', '    \n', '    \n', '    \n', '\n', '    /**\n', '     * @dev User to perform {approve} of token and {transferFrom} in one function call.\n', '     *\n', '     *\n', '     * Requirements\n', '     *\n', "     * - `spender' must have implemented {receiveApproval} function.\n", '     */\n', '    function approveAndCall(\n', '        address _spender,\n', '        uint256 _value,\n', '        bytes _extraData\n', '    ) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        if(!_spender.call(\n', '            bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))),\n', '            msg.sender,\n', '            _value,\n', '            this,\n', '            _extraData\n', '        )) { revert(); }\n', '        return true;\n', '    }\n', '\n', '}']