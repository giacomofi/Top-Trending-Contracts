['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  *  Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  uint256 public totalSupply;\n', '\n', '  function balanceOf(address _who) public view returns (uint256);\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256);\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '\n', '  event Transfer( address indexed from, address indexed to,  uint256 value);\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  event Burn(address indexed from, uint256 value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  mapping(string => address) username;\n', '  \n', '\n', '  mapping(address => uint256) allowedMiner;\n', '  mapping(bytes32 => uint256) tradeID;\n', '\n', '  //setting\n', '  bool public enable = true;\n', '  bytes32 public uniqueStr = 0x736363745f756e697175655f6964000000000000000000000000000000000000;\n', '  address public admin = 0x441b8F00004620F4D39359D1f0C20Ae971988DE8;\n', '  address public admin0x0 = 0x441b8F00004620F4D39359D1f0C20Ae971988DE8;\n', '  address public commonAdmin = 0x441b8F00004620F4D39359D1f0C20Ae971988DE8;\n', '  address public feeBank = 0x17C71f69972536a552B4b43f7F7187FcF530140c;\n', '  uint256 public systemFee = 4000;\n', '\n', '\n', '  /**\n', '  * Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   *  Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256){\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '  * Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(enable == true);\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   *  Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool){\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = (\n', '    allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   *  Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender,  uint256 _subtractedValue) public returns (bool) {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '   /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    //Other\n', '    function setAdmin(address _address) public {\n', '        require(msg.sender == admin);\n', '        admin = _address;\n', '    }\n', '    \n', '    function setAdmin0x0(address _address) public {\n', '        require(msg.sender == admin);\n', '        admin0x0 = _address;\n', '    }\n', '    \n', '    function setCommonAdmin(address _address) public {\n', '        require(msg.sender == admin);\n', '        commonAdmin = _address;\n', '    }\n', '\n', '    function setSystemFee(uint256 _value) public {\n', '        require(msg.sender == commonAdmin);\n', '        systemFee = _value;\n', '    }\n', '\n', '    function setFeeBank(address _address) public {\n', '        require(msg.sender == commonAdmin);\n', '        feeBank = _address;\n', '    }\n', '    \n', '    function setEnable(bool _status) public {\n', '        require(msg.sender == commonAdmin);\n', '        enable = _status;\n', '    }\n', '\n', '    function setUsername(address _address, string _username) public {\n', '        require(msg.sender == commonAdmin);\n', '        username[_username] = _address;\n', '    }\n', '\n', '    function addMiner(address _address) public {\n', '        require(msg.sender == commonAdmin);\n', '        allowedMiner[_address] = 1;\n', '    }\n', '\n', '    function removeMiner(address _address) public {\n', '        require(msg.sender == commonAdmin);\n', '        allowedMiner[_address] = 0;\n', '    }\n', '\n', '    function checkTradeID(bytes32 _tid) public view returns (uint256){\n', '        return tradeID[_tid];\n', '    }\n', '\n', '    function getMinerStatus(address _owner) public view returns (uint256) {\n', '        return allowedMiner[_owner];\n', '    }\n', '\n', '    function getUsername(string _username) public view returns (address) {\n', '        return username[_username];\n', '    }\n', '\n', '    function transferBySystem(uint256 _expire, bytes32 _tid, address _from, address _to, uint256 _value, uint8 _v, bytes32 _r, bytes32 _s) public returns (bool) {\n', '        require(allowedMiner[msg.sender] == 1);\n', '        require(tradeID[_tid] == 0);\n', '        require(_from != _to);\n', '        \n', '        //check exipre\n', '        uint256 maxExpire = _expire.add(86400);\n', '        require(maxExpire >= block.timestamp);\n', '        \n', '        //check value\n', '        uint256 totalPay = _value.add(systemFee);\n', '        require(balances[_from] >= totalPay);\n', '\n', '        //create hash\n', '        bytes32 hash = keccak256(\n', '          abi.encodePacked(_expire, uniqueStr, _tid, _from, _to, _value)\n', '        );\n', '\n', '        //check hash isValid\n', '        address theAddress = ecrecover(hash, _v, _r, _s);\n', '        require(theAddress == _from);\n', '        \n', '        //set tradeID\n', '        tradeID[_tid] = 1;\n', '        \n', '        //sub value\n', '        balances[_from] = balances[_from].sub(totalPay);\n', '\n', '        //add fee\n', '        balances[feeBank] = balances[feeBank].add(systemFee);\n', '\n', '        //add value\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        emit Transfer(_from, feeBank, systemFee);\n', '\n', '        return true;\n', '    }\n', '    \n', '    function draw0x0(address _to, uint256 _value) public returns (bool) {\n', '        require(msg.sender == admin0x0);\n', '        require(_value <= balances[address(0)]);\n', '    \n', '        balances[address(0)] = balances[address(0)].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(address(0), _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function doAirdrop(address[] _dests, uint256[] _values) public returns (bool) {\n', '        require(_dests.length == _values.length);\n', '\n', '        uint256 i = 0;\n', '        while (i < _dests.length) {\n', '            require(balances[msg.sender] >= _values[i]);\n', '            require(_dests[i] != address(0));\n', '\n', '            balances[msg.sender] = balances[msg.sender].sub(_values[i]);\n', '            balances[_dests[i]] = balances[_dests[i]].add(_values[i]);\n', '            emit Transfer(msg.sender, _dests[i], _values[i]);\n', '\n', '            i += 1;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract SCCTERC20 is StandardToken {\n', '    // Public variables of the token\n', '    string public name = "Smart Cash Coin Tether";\n', '    string public symbol = "SCCT";\n', '    uint8 constant public decimals = 4;\n', '    uint256 constant public initialSupply = 100000000;\n', '\n', '    constructor() public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '        allowedMiner[0x222dAa632Af2D8EB82e091318A6bC7404E3cC980] = 1;\n', '        allowedMiner[0x887f8EEB3F011ddC9C38580De7380b3c033483Ad] = 1;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']