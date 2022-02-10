['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender) public view returns (uint256);\n', '  function transferFrom(address _from, address _to, uint256 _value)  public returns (bool);\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(address indexed owner,address indexed spender,uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) internal balances;\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', ' \n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// ERC20 standard token\n', 'contract NBE is StandardToken {\n', '    address public admin;\n', '    string public name = "NBE";\n', '    string public symbol = "NBE"; \n', '    uint8 public decimals = 18; \n', '    uint256 public INITIAL_SUPPLY = 10000000000000000000000000000;\n', '    \n', '    mapping (address => uint256) public frozenTimestamp; \n', '\n', '    bool public exchangeFlag = true; \n', '   \n', '    uint256 public minWei = 1;  // 1 wei  1eth = 1*10^18 wei\n', '    uint256 public maxWei = 20000000000000000000000; // 20000 eth\n', '    uint256 public maxRaiseAmount = 500000000000000000000000; //  500000 eth\n', '    uint256 public raisedAmount = 0; //  0 eth\n', '    uint256 public raiseRatio = 10000; //  1eth = 10000\n', '\n', '    constructor() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        admin = msg.sender;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '    }\n', '\n', '    function()\n', '    public payable {\n', '        require(msg.value > 0);\n', '        if (exchangeFlag) {\n', '            if (msg.value >= minWei && msg.value <= maxWei){\n', '                if (raisedAmount < maxRaiseAmount) {\n', '                    uint256 valueNeed = msg.value;\n', '                    raisedAmount = raisedAmount.add(msg.value);\n', '                    if (raisedAmount > maxRaiseAmount) {\n', '                        uint256 valueLeft = raisedAmount.sub(maxRaiseAmount);\n', '                        valueNeed = msg.value.sub(valueLeft);\n', '                        msg.sender.transfer(valueLeft);\n', '                        raisedAmount = maxRaiseAmount;\n', '                    }\n', '                    if (raisedAmount >= maxRaiseAmount) {\n', '                        exchangeFlag = false;\n', '                    }\n', '                   \n', '                    uint256 _value = valueNeed.mul(raiseRatio);\n', '\n', '                    require(_value <= balances[admin]);\n', '                    balances[admin] = balances[admin].sub(_value);\n', '                    balances[msg.sender] = balances[msg.sender].add(_value);\n', '\n', '                    emit Transfer(admin, msg.sender, _value);\n', '\n', '                }\n', '            } else {\n', '                msg.sender.transfer(msg.value);\n', '            }\n', '        } else {\n', '            msg.sender.transfer(msg.value);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * admin\n', '    */\n', '    function changeAdmin(\n', '        address _newAdmin\n', '    )\n', '    public\n', '    returns (bool)  {\n', '        require(msg.sender == admin);\n', '        require(_newAdmin != address(0));\n', '        balances[_newAdmin] = balances[_newAdmin].add(balances[admin]);\n', '        balances[admin] = 0;\n', '        admin = _newAdmin;\n', '        return true;\n', '    }\n', '\n', '    // withdraw admin\n', '    function withdraw (\n', '        uint256 _amount\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        msg.sender.transfer(_amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * \n', '    */\n', '    function freezeWithTimestamp(\n', '        address _target,\n', '        uint256 _timestamp\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        require(_target != address(0));\n', '        frozenTimestamp[_target] = _timestamp;\n', '        return true;\n', '    }\n', '\n', '    \n', '    /**\n', '    * \n', '    */\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        // require(!frozenAccount[msg.sender]);\n', '        require(now > frozenTimestamp[msg.sender]);\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    //********************************************************************************\n', '    //\n', '    function getFrozenTimestamp(\n', '        address _target\n', '    )\n', '    public view\n', '    returns (uint256) {\n', '        require(_target != address(0));\n', '        return frozenTimestamp[_target];\n', '    }\n', '  \n', '    //\n', '    function getBalance()\n', '    public view\n', '    returns (uint256) {\n', '        return address(this).balance;\n', '    }\n', '    \n', '\n', '    // change flag\n', '    function setExchangeFlag (\n', '        bool _flag\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        exchangeFlag = _flag;\n', '        return true;\n', '\n', '    }\n', '\n', '    // change ratio\n', '    function setRaiseRatio (\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool) {\n', '        require(msg.sender == admin);\n', '        raiseRatio = _value;\n', '        return true;\n', '    }\n', '\n', '\n', '}']