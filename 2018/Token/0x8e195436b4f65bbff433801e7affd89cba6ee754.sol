['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of user permissions.\n', ' */\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '    address public adminer;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '  /**\n', '   * @dev Throws if called by any account other than the adminer.\n', '   */\n', '    modifier onlyAdminer {\n', '        require(msg.sender == owner || msg.sender == adminer);\n', '        _;\n', '    }\n', '    \n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a new owner.\n', '   * @param _owner The address to transfer ownership to.\n', '   */\n', '    function transferOwnership(address _owner) public onlyOwner {\n', '        newOwner = _owner;\n', '    }\n', '    \n', '  /**\n', '   * @dev New owner accept control of the contract.\n', '   */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0x0);\n', '    }\n', '    \n', '  /**\n', '   * @dev change the control of the contract to a new adminer.\n', '   * @param _adminer The address to transfer adminer to.\n', '   */\n', '    function changeAdminer(address _adminer) public onlyOwner {\n', '        adminer = _adminer;\n', '    }\n', '    \n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', ' \n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', ' \n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', ' \n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', ' \n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' */\n', ' \n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to tran sfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        return BasicToken.transfer(_to, _value);\n', '    }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '    function mint(address _to, uint256 _amount) onlyAdminer public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Additioal token\n', ' * @dev Mintable token with a token can be increased with proportion.\n', ' */\n', ' \n', 'contract AdditionalToken is MintableToken {\n', '\n', '    uint256 public maxProportion;\n', '    uint256 public lockedYears;\n', '    uint256 public initTime;\n', '\n', '    mapping(uint256 => uint256) public records;\n', '    mapping(uint256 => uint256) public maxAmountPer;\n', '    \n', '    event MintRequest(uint256 _curTimes, uint256 _maxAmountPer, uint256 _curAmount);\n', '\n', '\n', '    constructor(uint256 _maxProportion, uint256 _lockedYears) public {\n', '        require(_maxProportion >= 0);\n', '        require(_lockedYears >= 0);\n', '        \n', '        maxProportion = _maxProportion;\n', '        lockedYears = _lockedYears;\n', '        initTime = block.timestamp;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to Increase tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of the minted tokens.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '    function mint(address _to, uint256 _amount) onlyAdminer public returns (bool) {\n', '        uint256 curTime = block.timestamp;\n', '        uint256 curTimes = curTime.sub(initTime)/(31536000);\n', '        \n', '        require(curTimes >= lockedYears);\n', '        \n', '        uint256 _maxAmountPer;\n', '        if(maxAmountPer[curTimes] == 0) {\n', '            maxAmountPer[curTimes] = totalSupply.mul(maxProportion).div(100);\n', '        }\n', '        _maxAmountPer = maxAmountPer[curTimes];\n', '        require(records[curTimes].add(_amount) <= _maxAmountPer);\n', '        records[curTimes] = records[curTimes].add(_amount);\n', '        emit MintRequest(curTimes, _maxAmountPer, records[curTimes]);        \n', '        return(super.mint(_to, _amount));\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', ' \n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '    function pause() onlyAdminer whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '    function unpause() onlyAdminer whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Token contract\n', ' */\n', ' \n', 'contract Token is AdditionalToken, PausableToken {\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    string public  name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '\n', '    mapping(address => bool) public singleLockFinished;\n', '    \n', '    struct lockToken {\n', '        uint256 amount;\n', '        uint256 validity;\n', '    }\n', '\n', '    mapping(address => lockToken[]) public locked;\n', '    \n', '    \n', '    event Lock(\n', '        address indexed _of,\n', '        uint256 _amount,\n', '        uint256 _validity\n', '    );\n', '    \n', '    function () payable public  {\n', '        revert();\n', '    }\n', '    \n', '    constructor (string _symbol, string _name, uint256 _decimals, uint256 _initSupply, \n', '                    uint256 _maxProportion, uint256 _lockedYears) AdditionalToken(_maxProportion, _lockedYears) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = totalSupply.add(_initSupply * (10 ** decimals));\n', '        balances[msg.sender] = totalSupply.div(2);\n', '        balances[address(this)] = totalSupply - balances[msg.sender];\n', '        emit Transfer(address(0), msg.sender, totalSupply.div(2));\n', '        emit Transfer(address(0), address(this), totalSupply - balances[msg.sender]);\n', '    }\n', '\n', '    /**\n', '     * @dev Lock the special address \n', '     *\n', '     * @param _time The array of released timestamp \n', '     * @param _amountWithoutDecimal The array of amount of released tokens\n', '     * NOTICE: the amount in this function not include decimals. \n', '     */\n', '    \n', '    function lock(address _address, uint256[] _time, uint256[] _amountWithoutDecimal) onlyAdminer public returns(bool) {\n', '        require(!singleLockFinished[_address]);\n', '        require(_time.length == _amountWithoutDecimal.length);\n', '        if(locked[_address].length != 0) {\n', '            locked[_address].length = 0;\n', '        }\n', '        uint256 len = _time.length;\n', '        uint256 totalAmount = 0;\n', '        uint256 i = 0;\n', '        for(i = 0; i<len; i++) {\n', '            totalAmount = totalAmount.add(_amountWithoutDecimal[i]*(10 ** decimals));\n', '        }\n', '        require(balances[_address] >= totalAmount);\n', '        for(i = 0; i < len; i++) {\n', '            locked[_address].push(lockToken(_amountWithoutDecimal[i]*(10 ** decimals), block.timestamp.add(_time[i])));\n', '            emit Lock(_address, _amountWithoutDecimal[i]*(10 ** decimals), block.timestamp.add(_time[i]));\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function finishSingleLock(address _address) onlyAdminer public {\n', '        singleLockFinished[_address] = true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified purpose at a specified time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, uint256 _time)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        for(uint256 i = 0;i < locked[_of].length;i++)\n', '        {\n', '            if(locked[_of][i].validity>_time)\n', '                amount += locked[_of][i].amount;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns tokens available for transfer for a specified address\n', '     * @param _of The address to query the the lock tokens of\n', '     */\n', '    function transferableBalanceOf(address _of)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        uint256 lockedAmount = 0;\n', '        lockedAmount += tokensLocked(_of, block.timestamp);\n', '        amount = balances[_of].sub(lockedAmount);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public  returns (bool) {\n', '        require(_value <= transferableBalanceOf(msg.sender));\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {\n', '        require(_value <= transferableBalanceOf(_from));\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '    \n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdminer returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of user permissions.\n', ' */\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '    address public adminer;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '  /**\n', '   * @dev Throws if called by any account other than the adminer.\n', '   */\n', '    modifier onlyAdminer {\n', '        require(msg.sender == owner || msg.sender == adminer);\n', '        _;\n', '    }\n', '    \n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a new owner.\n', '   * @param _owner The address to transfer ownership to.\n', '   */\n', '    function transferOwnership(address _owner) public onlyOwner {\n', '        newOwner = _owner;\n', '    }\n', '    \n', '  /**\n', '   * @dev New owner accept control of the contract.\n', '   */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0x0);\n', '    }\n', '    \n', '  /**\n', '   * @dev change the control of the contract to a new adminer.\n', '   * @param _adminer The address to transfer adminer to.\n', '   */\n', '    function changeAdminer(address _adminer) public onlyOwner {\n', '        adminer = _adminer;\n', '    }\n', '    \n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', ' \n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' */\n', ' \n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', ' \n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', ' \n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' */\n', ' \n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to tran sfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        return BasicToken.transfer(_to, _value);\n', '    }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '    function mint(address _to, uint256 _amount) onlyAdminer public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Additioal token\n', ' * @dev Mintable token with a token can be increased with proportion.\n', ' */\n', ' \n', 'contract AdditionalToken is MintableToken {\n', '\n', '    uint256 public maxProportion;\n', '    uint256 public lockedYears;\n', '    uint256 public initTime;\n', '\n', '    mapping(uint256 => uint256) public records;\n', '    mapping(uint256 => uint256) public maxAmountPer;\n', '    \n', '    event MintRequest(uint256 _curTimes, uint256 _maxAmountPer, uint256 _curAmount);\n', '\n', '\n', '    constructor(uint256 _maxProportion, uint256 _lockedYears) public {\n', '        require(_maxProportion >= 0);\n', '        require(_lockedYears >= 0);\n', '        \n', '        maxProportion = _maxProportion;\n', '        lockedYears = _lockedYears;\n', '        initTime = block.timestamp;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to Increase tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of the minted tokens.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '    function mint(address _to, uint256 _amount) onlyAdminer public returns (bool) {\n', '        uint256 curTime = block.timestamp;\n', '        uint256 curTimes = curTime.sub(initTime)/(31536000);\n', '        \n', '        require(curTimes >= lockedYears);\n', '        \n', '        uint256 _maxAmountPer;\n', '        if(maxAmountPer[curTimes] == 0) {\n', '            maxAmountPer[curTimes] = totalSupply.mul(maxProportion).div(100);\n', '        }\n', '        _maxAmountPer = maxAmountPer[curTimes];\n', '        require(records[curTimes].add(_amount) <= _maxAmountPer);\n', '        records[curTimes] = records[curTimes].add(_amount);\n', '        emit MintRequest(curTimes, _maxAmountPer, records[curTimes]);        \n', '        return(super.mint(_to, _amount));\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', ' \n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '    function pause() onlyAdminer whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '    function unpause() onlyAdminer whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Token contract\n', ' */\n', ' \n', 'contract Token is AdditionalToken, PausableToken {\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    string public  name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '\n', '    mapping(address => bool) public singleLockFinished;\n', '    \n', '    struct lockToken {\n', '        uint256 amount;\n', '        uint256 validity;\n', '    }\n', '\n', '    mapping(address => lockToken[]) public locked;\n', '    \n', '    \n', '    event Lock(\n', '        address indexed _of,\n', '        uint256 _amount,\n', '        uint256 _validity\n', '    );\n', '    \n', '    function () payable public  {\n', '        revert();\n', '    }\n', '    \n', '    constructor (string _symbol, string _name, uint256 _decimals, uint256 _initSupply, \n', '                    uint256 _maxProportion, uint256 _lockedYears) AdditionalToken(_maxProportion, _lockedYears) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = totalSupply.add(_initSupply * (10 ** decimals));\n', '        balances[msg.sender] = totalSupply.div(2);\n', '        balances[address(this)] = totalSupply - balances[msg.sender];\n', '        emit Transfer(address(0), msg.sender, totalSupply.div(2));\n', '        emit Transfer(address(0), address(this), totalSupply - balances[msg.sender]);\n', '    }\n', '\n', '    /**\n', '     * @dev Lock the special address \n', '     *\n', '     * @param _time The array of released timestamp \n', '     * @param _amountWithoutDecimal The array of amount of released tokens\n', '     * NOTICE: the amount in this function not include decimals. \n', '     */\n', '    \n', '    function lock(address _address, uint256[] _time, uint256[] _amountWithoutDecimal) onlyAdminer public returns(bool) {\n', '        require(!singleLockFinished[_address]);\n', '        require(_time.length == _amountWithoutDecimal.length);\n', '        if(locked[_address].length != 0) {\n', '            locked[_address].length = 0;\n', '        }\n', '        uint256 len = _time.length;\n', '        uint256 totalAmount = 0;\n', '        uint256 i = 0;\n', '        for(i = 0; i<len; i++) {\n', '            totalAmount = totalAmount.add(_amountWithoutDecimal[i]*(10 ** decimals));\n', '        }\n', '        require(balances[_address] >= totalAmount);\n', '        for(i = 0; i < len; i++) {\n', '            locked[_address].push(lockToken(_amountWithoutDecimal[i]*(10 ** decimals), block.timestamp.add(_time[i])));\n', '            emit Lock(_address, _amountWithoutDecimal[i]*(10 ** decimals), block.timestamp.add(_time[i]));\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function finishSingleLock(address _address) onlyAdminer public {\n', '        singleLockFinished[_address] = true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified purpose at a specified time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, uint256 _time)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        for(uint256 i = 0;i < locked[_of].length;i++)\n', '        {\n', '            if(locked[_of][i].validity>_time)\n', '                amount += locked[_of][i].amount;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns tokens available for transfer for a specified address\n', '     * @param _of The address to query the the lock tokens of\n', '     */\n', '    function transferableBalanceOf(address _of)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        uint256 lockedAmount = 0;\n', '        lockedAmount += tokensLocked(_of, block.timestamp);\n', '        amount = balances[_of].sub(lockedAmount);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public  returns (bool) {\n', '        require(_value <= transferableBalanceOf(msg.sender));\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {\n', '        require(_value <= transferableBalanceOf(_from));\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '    \n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdminer returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
