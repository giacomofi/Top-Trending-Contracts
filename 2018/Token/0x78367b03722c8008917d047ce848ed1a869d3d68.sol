['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * title ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Token{\n', '  uint256 public totalSupply;\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * title Standard ERC20 token\n', ' *\n', ' * Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20Token{\n', '  string public version = "1.0";\n', '  string public name = "eleven-dimensional resonnance";\n', '  string public symbol = "R11";\n', '  uint8 public  decimals = 18;\n', '\n', '  bool public transfersEnabled = true;\n', '\n', '  /**\n', '   * to stop this contract\n', '   */\n', '  modifier transable(){\n', '      require(transfersEnabled);\n', '      _;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) transable public returns (bool) {\n', '    require(_to != address(0)&&_value>0);\n', '    require(balanceOf[msg.sender]>_value);\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Transfer tokens from one address to another\n', '   * param _from address The address which you want to send tokens from\n', '   * param _to address The address which you want to transfer to\n', '   * param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) transable public returns (bool) {\n', '    require(_to != address(0)&&_value>0);\n', '\n', '    uint256 _allowance = allowance[_from][msg.sender];\n', '\n', '    require (_value <= _allowance);\n', '    require(balanceOf[_from]>_value);\n', '\n', '    balanceOf[_from] -= _value;\n', '    balanceOf[_to] += _value;\n', '    allowance[_from][msg.sender] -= _value;\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * \n', '   * param _spender The address which will spend the funds.\n', '   * param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(allowance[msg.sender][_spender]==0);\n', '    allowance[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  /**\n', '   * approve should be called only first. To increment\n', '   * allowed value is better to use this function\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowance[msg.sender][_spender] += _addedValue;\n', '    emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowance[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowance[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowance[msg.sender][_spender] -= _subtractedValue;\n', '    }\n', '    emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// This is just a contract of a BOP Token.\n', '// It is a ERC20 token\n', 'contract Token is StandardToken{\n', '\n', '    //解锁信息\n', '    uint  currUnlockStep; //当前解锁step\n', '    uint256 currUnlockSeq; //当前解锁step 内的游标\n', '\n', '    //Key1: step(募资阶段); Key2: user sequence(用户序列)\n', '    mapping (uint => uint256[]) public freezeOf; //所有数额，地址与数额合并为uint256，位运算拆分。\n', '    mapping (uint => bool) public stepUnlockInfo; //所有锁仓，key 使用序号向上增加，value,是否已解锁。\n', '    mapping (address => uint256) public freezeOfUser; //用户所有锁仓，方便用户查询自己锁仓余额\n', '    \n', '   \n', '    uint256 internal constant INITIAL_SUPPLY = 1 * (10**8) * (10 **18);\n', '\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '    event Freeze(address indexed locker, uint256 value);\n', '    event Unfreeze(address indexed unlocker, uint256 value);\n', '    event TransferMulti(uint256 count, uint256 total);\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '        balanceOf[owner] = INITIAL_SUPPLY;\n', '        totalSupply = INITIAL_SUPPLY;\n', '    }\n', '\n', '    // transfer to and lock it\n', '    function transferAndLock(address _to, uint256 _value, uint256 _lockValue, uint _step) transable public returns (bool success) {\n', '        require(_to != 0x0);\n', '        require(_value <= balanceOf[msg.sender]);\n', '        require(_value > 0);\n', '\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        freeze(_to, _lockValue, _step);\n', '        return true;\n', '    }\n', '\n', '    // transfer to and lock it\n', '    function transferFromAndLock(address _from, address _to, uint256 _value, uint256 _lockValue, uint _step) transable public returns (bool success) {\n', '        uint256 _allowance = allowance[_from][msg.sender];\n', '\n', '        require (_value <= _allowance);\n', '        require(_to != 0x0);\n', '        require(_value <= balanceOf[_from]);\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        freeze(_to, _lockValue, _step);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferMulti(address[] _to, uint256[] _value) transable public returns (uint256 amount){\n', '        require(_to.length == _value.length && _to.length <= 1024);\n', '        uint256 balanceOfSender = balanceOf[msg.sender];\n', '        uint256 len = _to.length;\n', '        for(uint256 j; j<len; j++){\n', '            require(_value[j] <= balanceOfSender); //limit transfer value\n', '            require(amount <= balanceOfSender);\n', '            amount += _value[j];\n', '        }\n', '        require(balanceOfSender >= amount); //check enough and not overflow\n', '        balanceOf[msg.sender] -= amount;\n', '        for(uint256 i; i<len; i++){\n', '            address _toI = _to[i];\n', '            uint256 _valueI = _value[i];\n', '            balanceOf[_toI] += _valueI;\n', '            emit Transfer(msg.sender, _toI, _valueI);\n', '        }\n', '        emit TransferMulti(len, amount);\n', '    }\n', '    \n', '    //冻结账户\n', '    function freeze(address _user, uint256 _value, uint _step) internal returns (bool success) {\n', '        require(balanceOf[_user] >= _value);\n', '        balanceOf[_user] -= _value;\n', '        freezeOfUser[_user] += _value;\n', '        freezeOf[_step].push(uint256(_user)<<92|_value);\n', '        emit Freeze(_user, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    //event ShowStart(uint256 start);\n', '\n', '    //为用户解锁账户资金\n', '    function unFreeze(uint _step) onlyOwner public returns (bool unlockOver) {\n', '        require(currUnlockStep==_step || currUnlockSeq==uint256(0));\n', '        require(stepUnlockInfo[_step]==false);\n', '        uint256[] memory currArr = freezeOf[_step];\n', '        currUnlockStep = _step;\n', '        if(currUnlockSeq==uint256(0)){\n', '            currUnlockSeq = currArr.length;\n', '        }\n', '\n', '        uint256 userLockInfo;\n', '        uint256 _amount;\n', '        address userAddress;\n', '\n', '        for(uint i = 0; i<99&&currUnlockSeq>0; i++){\n', '            userLockInfo = freezeOf[_step][currUnlockSeq-1];\n', '            _amount = userLockInfo&0xFFFFFFFFFFFFFFFFFFFFFFF;\n', '            userAddress = address(userLockInfo>>92);\n', '            if(freezeOfUser[userAddress]>= _amount){\n', '              balanceOf[userAddress] += _amount;\n', '              freezeOfUser[userAddress] -= _amount;\n', '              emit Unfreeze(userAddress, _amount);\n', '            }\n', '            \n', '            currUnlockSeq--;\n', '        }\n', '        if(currUnlockSeq==0){\n', '            stepUnlockInfo[_step] = true;\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    //为用户解锁账户资金\n', '    function unFreezeUser(address _user) onlyOwner public returns (bool unlockOver) {\n', '        require(_user != address(0));\n', '        \n', '        uint256 _amount = freezeOfUser[_user];\n', '        if(_amount>0){\n', '          balanceOf[_user] += _amount;\n', '          delete freezeOfUser[_user];\n', '          emit Unfreeze(_user, _amount);\n', '        }\n', '           \n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Burns a specific amount of tokens.\n', '     * param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) transable public returns (bool success) {\n', '        require(_value > 0);\n', '        require(_value <= balanceOf[msg.sender]);\n', '   \n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * dev Function to mint tokens\n', '     * param _to The address that will receive the minted tokens.\n', '     * param _amount The amount of tokens to mint.\n', '     * return A boolean that indicates if the operation was successful.\n', '     */\n', '    function enableTransfers(bool _transfersEnabled) onlyOwner public {\n', '      transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '\n', '    address public owner;\n', '\n', '    event ChangeOwner(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * revert if called by any account except owner.\n', '     */\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Allows the current owner to transfer control of the contract to a newOwner.\n', '     * param newOwner The address to transfer ownership to.\n', '     */\n', '    function changeOwner(address newOwner) onlyOwner public {\n', '      require(newOwner != address(0));\n', '      owner = newOwner;\n', '      emit ChangeOwner(owner, newOwner);\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * title ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Token{\n', '  uint256 public totalSupply;\n', '  mapping (address => uint256) public balanceOf;\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * title Standard ERC20 token\n', ' *\n', ' * Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20Token{\n', '  string public version = "1.0";\n', '  string public name = "eleven-dimensional resonnance";\n', '  string public symbol = "R11";\n', '  uint8 public  decimals = 18;\n', '\n', '  bool public transfersEnabled = true;\n', '\n', '  /**\n', '   * to stop this contract\n', '   */\n', '  modifier transable(){\n', '      require(transfersEnabled);\n', '      _;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) transable public returns (bool) {\n', '    require(_to != address(0)&&_value>0);\n', '    require(balanceOf[msg.sender]>_value);\n', '    balanceOf[msg.sender] -= _value;\n', '    balanceOf[_to] += _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Transfer tokens from one address to another\n', '   * param _from address The address which you want to send tokens from\n', '   * param _to address The address which you want to transfer to\n', '   * param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) transable public returns (bool) {\n', '    require(_to != address(0)&&_value>0);\n', '\n', '    uint256 _allowance = allowance[_from][msg.sender];\n', '\n', '    require (_value <= _allowance);\n', '    require(balanceOf[_from]>_value);\n', '\n', '    balanceOf[_from] -= _value;\n', '    balanceOf[_to] += _value;\n', '    allowance[_from][msg.sender] -= _value;\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * \n', '   * param _spender The address which will spend the funds.\n', '   * param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(allowance[msg.sender][_spender]==0);\n', '    allowance[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  /**\n', '   * approve should be called only first. To increment\n', '   * allowed value is better to use this function\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowance[msg.sender][_spender] += _addedValue;\n', '    emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowance[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowance[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowance[msg.sender][_spender] -= _subtractedValue;\n', '    }\n', '    emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '// This is just a contract of a BOP Token.\n', '// It is a ERC20 token\n', 'contract Token is StandardToken{\n', '\n', '    //解锁信息\n', '    uint  currUnlockStep; //当前解锁step\n', '    uint256 currUnlockSeq; //当前解锁step 内的游标\n', '\n', '    //Key1: step(募资阶段); Key2: user sequence(用户序列)\n', '    mapping (uint => uint256[]) public freezeOf; //所有数额，地址与数额合并为uint256，位运算拆分。\n', '    mapping (uint => bool) public stepUnlockInfo; //所有锁仓，key 使用序号向上增加，value,是否已解锁。\n', '    mapping (address => uint256) public freezeOfUser; //用户所有锁仓，方便用户查询自己锁仓余额\n', '    \n', '   \n', '    uint256 internal constant INITIAL_SUPPLY = 1 * (10**8) * (10 **18);\n', '\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '    event Freeze(address indexed locker, uint256 value);\n', '    event Unfreeze(address indexed unlocker, uint256 value);\n', '    event TransferMulti(uint256 count, uint256 total);\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '        balanceOf[owner] = INITIAL_SUPPLY;\n', '        totalSupply = INITIAL_SUPPLY;\n', '    }\n', '\n', '    // transfer to and lock it\n', '    function transferAndLock(address _to, uint256 _value, uint256 _lockValue, uint _step) transable public returns (bool success) {\n', '        require(_to != 0x0);\n', '        require(_value <= balanceOf[msg.sender]);\n', '        require(_value > 0);\n', '\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        freeze(_to, _lockValue, _step);\n', '        return true;\n', '    }\n', '\n', '    // transfer to and lock it\n', '    function transferFromAndLock(address _from, address _to, uint256 _value, uint256 _lockValue, uint _step) transable public returns (bool success) {\n', '        uint256 _allowance = allowance[_from][msg.sender];\n', '\n', '        require (_value <= _allowance);\n', '        require(_to != 0x0);\n', '        require(_value <= balanceOf[_from]);\n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        freeze(_to, _lockValue, _step);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferMulti(address[] _to, uint256[] _value) transable public returns (uint256 amount){\n', '        require(_to.length == _value.length && _to.length <= 1024);\n', '        uint256 balanceOfSender = balanceOf[msg.sender];\n', '        uint256 len = _to.length;\n', '        for(uint256 j; j<len; j++){\n', '            require(_value[j] <= balanceOfSender); //limit transfer value\n', '            require(amount <= balanceOfSender);\n', '            amount += _value[j];\n', '        }\n', '        require(balanceOfSender >= amount); //check enough and not overflow\n', '        balanceOf[msg.sender] -= amount;\n', '        for(uint256 i; i<len; i++){\n', '            address _toI = _to[i];\n', '            uint256 _valueI = _value[i];\n', '            balanceOf[_toI] += _valueI;\n', '            emit Transfer(msg.sender, _toI, _valueI);\n', '        }\n', '        emit TransferMulti(len, amount);\n', '    }\n', '    \n', '    //冻结账户\n', '    function freeze(address _user, uint256 _value, uint _step) internal returns (bool success) {\n', '        require(balanceOf[_user] >= _value);\n', '        balanceOf[_user] -= _value;\n', '        freezeOfUser[_user] += _value;\n', '        freezeOf[_step].push(uint256(_user)<<92|_value);\n', '        emit Freeze(_user, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    //event ShowStart(uint256 start);\n', '\n', '    //为用户解锁账户资金\n', '    function unFreeze(uint _step) onlyOwner public returns (bool unlockOver) {\n', '        require(currUnlockStep==_step || currUnlockSeq==uint256(0));\n', '        require(stepUnlockInfo[_step]==false);\n', '        uint256[] memory currArr = freezeOf[_step];\n', '        currUnlockStep = _step;\n', '        if(currUnlockSeq==uint256(0)){\n', '            currUnlockSeq = currArr.length;\n', '        }\n', '\n', '        uint256 userLockInfo;\n', '        uint256 _amount;\n', '        address userAddress;\n', '\n', '        for(uint i = 0; i<99&&currUnlockSeq>0; i++){\n', '            userLockInfo = freezeOf[_step][currUnlockSeq-1];\n', '            _amount = userLockInfo&0xFFFFFFFFFFFFFFFFFFFFFFF;\n', '            userAddress = address(userLockInfo>>92);\n', '            if(freezeOfUser[userAddress]>= _amount){\n', '              balanceOf[userAddress] += _amount;\n', '              freezeOfUser[userAddress] -= _amount;\n', '              emit Unfreeze(userAddress, _amount);\n', '            }\n', '            \n', '            currUnlockSeq--;\n', '        }\n', '        if(currUnlockSeq==0){\n', '            stepUnlockInfo[_step] = true;\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '    //为用户解锁账户资金\n', '    function unFreezeUser(address _user) onlyOwner public returns (bool unlockOver) {\n', '        require(_user != address(0));\n', '        \n', '        uint256 _amount = freezeOfUser[_user];\n', '        if(_amount>0){\n', '          balanceOf[_user] += _amount;\n', '          delete freezeOfUser[_user];\n', '          emit Unfreeze(_user, _amount);\n', '        }\n', '           \n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Burns a specific amount of tokens.\n', '     * param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) transable public returns (bool success) {\n', '        require(_value > 0);\n', '        require(_value <= balanceOf[msg.sender]);\n', '   \n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * dev Function to mint tokens\n', '     * param _to The address that will receive the minted tokens.\n', '     * param _amount The amount of tokens to mint.\n', '     * return A boolean that indicates if the operation was successful.\n', '     */\n', '    function enableTransfers(bool _transfersEnabled) onlyOwner public {\n', '      transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '\n', '    address public owner;\n', '\n', '    event ChangeOwner(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * revert if called by any account except owner.\n', '     */\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Allows the current owner to transfer control of the contract to a newOwner.\n', '     * param newOwner The address to transfer ownership to.\n', '     */\n', '    function changeOwner(address newOwner) onlyOwner public {\n', '      require(newOwner != address(0));\n', '      owner = newOwner;\n', '      emit ChangeOwner(owner, newOwner);\n', '    }\n', '}']