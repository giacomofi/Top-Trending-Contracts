['pragma solidity ^0.4.18;\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ApproveAndCallReceiver {\n', '    function receiveApproval(\n', '    address _from,\n', '    uint256 _amount,\n', '    address _token,\n', '    bytes _data\n', '    ) public;\n', '}\n', '\n', 'contract ERC20Token {\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public totalSupply;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract TokenI is ERC20Token {\n', '\n', '    string public name;                \n', '    uint8 public decimals;             \n', '    string public symbol;              \n', '\n', '    function approveAndCall(\n', '    address _spender,\n', '    uint256 _amount,\n', '    bytes _extraData\n', '    ) public returns (bool success);\n', '\n', '\n', '    function generateTokens(address _owner, uint _amount) public returns (bool);\n', '\n', '    function destroyTokens(address _owner, uint _amount) public returns (bool);\n', '\n', '}\n', '\n', 'contract Token is TokenI {\n', '\n', '    struct FreezeInfo {\n', '    address user;\n', '    uint256 amount;\n', '    }\n', '    //Key1: step(募资阶段); Key2: user sequence(用户序列)\n', '    mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。\n', '    mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence\n', '    mapping (address => uint256) public airdropOf;//空投用户\n', '\n', '    address public owner;\n', '    bool public paused=false;//是否暂停私募\n', '    bool public pauseTransfer=false;//是否允许转账\n', '    uint256 public minFunding = 1 ether;  //最低起投额度\n', '    uint256 public airdropQty=0;//每个账户空投获得的量\n', '    uint256 public airdropTotalQty=0;//总共发放的空投代币数量\n', '    uint256 public tokensPerEther = 10000;//1eth兑换多少代币\n', '    address private vaultAddress;//存储众筹ETH的地址\n', '    uint256 public totalCollected = 0;//已经募到ETH的总数量\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    event Freeze(address indexed from, uint256 value);\n', '\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    event Payment(address sender, uint256 _ethAmount, uint256 _tokenAmount);\n', '\n', '    function Token(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol,\n', '        address _vaultAddress\n', '    ) public {\n', '        require(_vaultAddress != 0);\n', '        totalSupply = initialSupply * 10 ** uint256(decimalUnits);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals = decimalUnits;\n', '        owner = msg.sender;\n', '        vaultAddress=_vaultAddress;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier realUser(address user){\n', '        if(user == 0x0){\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier moreThanZero(uint256 _value){\n', '        if (_value <= 0){\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) public returns (bool) {\n', '        require(!pauseTransfer);\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) moreThanZero(_value) public\n', '    returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender,_spender,_value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {\n', '        require(approve(_spender, _amount));\n', '        ApproveAndCallReceiver(_spender).receiveApproval(\n', '        msg.sender,\n', '        _amount,\n', '        this,\n', '        _extraData\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {\n', '        require(!pauseTransfer);\n', '        require(balanceOf[_from] >= _value);                 // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows\n', '        require(allowance[_from][msg.sender] >= _value);     // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferMulti(address[] _to, uint256[] _value) onlyOwner public returns (uint256 amount){\n', '        require(_to.length == _value.length);\n', '        uint8 len = uint8(_to.length);\n', '        for(uint8 j; j<len; j++){\n', '            amount = amount.add(_value[j]*10**uint256(decimals));\n', '        }\n', '        require(balanceOf[msg.sender] >= amount);\n', '        for(uint8 i; i<len; i++){\n', '            address _toI = _to[i];\n', '            uint256 _valueI = _value[i]*10**uint256(decimals);\n', '            balanceOf[_toI] = balanceOf[_toI].add(_valueI);\n', '            balanceOf[msg.sender] =balanceOf[msg.sender].sub(_valueI);\n', '            emit Transfer(msg.sender, _toI, _valueI);\n', '        }\n', '    }\n', '\n', '    //冻结账户\n', '    function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyOwner public returns (bool success) {\n', '        _value=_value*10**uint256(decimals);\n', '        return _freeze(_user,_value,_step);\n', '    }\n', '\n', '    function _freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) private returns (bool success) {\n', '        //info256("balanceOf[_user]", balanceOf[_user]);\n', '        require(balanceOf[_user] >= _value);\n', '        balanceOf[_user] = balanceOf[_user].sub(_value);\n', '        freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});\n', '        lastFreezeSeq[_step]++;\n', '        emit Freeze(_user, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    //为用户解锁账户资金\n', '    function unFreeze(uint8 _step) onlyOwner public returns (bool unlockOver) {\n', '        //_end = length of freezeOf[_step]\n', '        uint8 _end = lastFreezeSeq[_step];\n', '        require(_end > 0);\n', '        unlockOver=false;\n', '        uint8  _start=0;\n', '        for(; _end>_start; _end--){\n', '            FreezeInfo storage fInfo = freezeOf[_step][_end-1];\n', '            uint256 _amount = fInfo.amount;\n', '            balanceOf[fInfo.user] += _amount;\n', '            delete freezeOf[_step][_end-1];\n', '            lastFreezeSeq[_step]--;\n', '            emit Unfreeze(fInfo.user, _amount);\n', '        }\n', '    }\n', '\n', '    function generateTokens(address _user, uint _amount) onlyOwner public returns (bool) {\n', '        _amount=_amount*10**uint256(decimals);\n', '        return _generateTokens(_user,_amount);\n', '    }\n', '\n', '    function _generateTokens(address _user, uint _amount)  private returns (bool) {\n', '        require(balanceOf[owner] >= _amount);\n', '        balanceOf[_user] = balanceOf[_user].add(_amount);\n', '        balanceOf[owner] = balanceOf[owner].sub(_amount);\n', '        emit Transfer(0, _user, _amount);\n', '        return true;\n', '    }\n', '\n', '    function destroyTokens(address _user, uint256 _amount) onlyOwner public returns (bool) {\n', '        _amount=_amount*10**uint256(decimals);\n', '        return _destroyTokens(_user,_amount);\n', '    }\n', '\n', '    function _destroyTokens(address _user, uint256 _amount) private returns (bool) {\n', '        require(balanceOf[_user] >= _amount);\n', '        balanceOf[owner] = balanceOf[owner].add(_amount);\n', '        balanceOf[_user] = balanceOf[_user].sub(_amount);\n', '        emit Transfer(_user, 0, _amount);\n', '        emit Burn(_user, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function changeOwner(address newOwner) onlyOwner public returns (bool) {\n', '        balanceOf[newOwner] = balanceOf[owner];\n', '        balanceOf[owner] = 0;\n', '        owner = newOwner;\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * 修改token兑换比率,1eth兑换多少代币\n', '     */\n', '    function changeTokensPerEther(uint256 _newRate) onlyOwner public {\n', '        tokensPerEther = _newRate;\n', '    }\n', '\n', '    /**\n', '     * 修改每个账户可获得的空投量\n', '     */   \n', '    function changeAirdropQty(uint256 _airdropQty) onlyOwner public {\n', '        airdropQty = _airdropQty;\n', '    }\n', '\n', '    /**\n', '     * 修改空投总量\n', '     */   \n', '    function changeAirdropTotalQty(uint256 _airdropTotalQty) onlyOwner public {\n', '        uint256 _token =_airdropTotalQty*10**uint256(decimals);\n', '        require(balanceOf[owner] >= _token);\n', '        airdropTotalQty = _airdropTotalQty;\n', '    }\n', '\n', '        ////////////////\n', '    // 修是否暂停私募\n', '    ////////////////\n', '    function changePaused(bool _paused) onlyOwner public {\n', '        paused = _paused;\n', '    }\n', '    \n', '    function changePauseTranfser(bool _paused) onlyOwner public {\n', '        pauseTransfer = _paused;\n', '    }\n', '\n', '    //accept ether\n', '    function() payable public {\n', '        require(!paused);\n', '        address _user=msg.sender;\n', '        uint256 tokenValue;\n', '        if(msg.value==0){//空投\n', '            require(airdropQty>0);\n', '            require(airdropTotalQty>=airdropQty);\n', '            require(airdropOf[_user]==0);\n', '            tokenValue=airdropQty*10**uint256(decimals);\n', '            airdropOf[_user]=tokenValue;\n', '            airdropTotalQty-=airdropQty;\n', '            require(_generateTokens(_user, tokenValue));\n', '            emit Payment(_user, msg.value, tokenValue);\n', '        }else{\n', '            require(msg.value >= minFunding);//最低起投\n', '            require(msg.value % 1 ether==0);//只能投整数倍eth\n', '            totalCollected +=msg.value;\n', '            require(vaultAddress.send(msg.value));//Send the ether to the vault\n', '            tokenValue = (msg.value/1 ether)*(tokensPerEther*10 ** uint256(decimals));\n', '            require(_generateTokens(_user, tokenValue));\n', '            uint256 lock1 = tokenValue / 5;\n', '            require(_freeze(_user, lock1, 0));\n', '            _freeze(_user, lock1, 1);\n', '            _freeze(_user, lock1, 2);\n', '            _freeze(_user, lock1, 3);\n', '            emit Payment(_user, msg.value, tokenValue);\n', '\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ApproveAndCallReceiver {\n', '    function receiveApproval(\n', '    address _from,\n', '    uint256 _amount,\n', '    address _token,\n', '    bytes _data\n', '    ) public;\n', '}\n', '\n', 'contract ERC20Token {\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public totalSupply;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract TokenI is ERC20Token {\n', '\n', '    string public name;                \n', '    uint8 public decimals;             \n', '    string public symbol;              \n', '\n', '    function approveAndCall(\n', '    address _spender,\n', '    uint256 _amount,\n', '    bytes _extraData\n', '    ) public returns (bool success);\n', '\n', '\n', '    function generateTokens(address _owner, uint _amount) public returns (bool);\n', '\n', '    function destroyTokens(address _owner, uint _amount) public returns (bool);\n', '\n', '}\n', '\n', 'contract Token is TokenI {\n', '\n', '    struct FreezeInfo {\n', '    address user;\n', '    uint256 amount;\n', '    }\n', '    //Key1: step(募资阶段); Key2: user sequence(用户序列)\n', '    mapping (uint8 => mapping (uint8 => FreezeInfo)) public freezeOf; //所有锁仓，key 使用序号向上增加，方便程序查询。\n', '    mapping (uint8 => uint8) public lastFreezeSeq; //最后的 freezeOf 键值。key: step; value: sequence\n', '    mapping (address => uint256) public airdropOf;//空投用户\n', '\n', '    address public owner;\n', '    bool public paused=false;//是否暂停私募\n', '    bool public pauseTransfer=false;//是否允许转账\n', '    uint256 public minFunding = 1 ether;  //最低起投额度\n', '    uint256 public airdropQty=0;//每个账户空投获得的量\n', '    uint256 public airdropTotalQty=0;//总共发放的空投代币数量\n', '    uint256 public tokensPerEther = 10000;//1eth兑换多少代币\n', '    address private vaultAddress;//存储众筹ETH的地址\n', '    uint256 public totalCollected = 0;//已经募到ETH的总数量\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    event Freeze(address indexed from, uint256 value);\n', '\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    event Payment(address sender, uint256 _ethAmount, uint256 _tokenAmount);\n', '\n', '    function Token(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol,\n', '        address _vaultAddress\n', '    ) public {\n', '        require(_vaultAddress != 0);\n', '        totalSupply = initialSupply * 10 ** uint256(decimalUnits);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals = decimalUnits;\n', '        owner = msg.sender;\n', '        vaultAddress=_vaultAddress;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier realUser(address user){\n', '        if(user == 0x0){\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier moreThanZero(uint256 _value){\n', '        if (_value <= 0){\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) realUser(_to) moreThanZero(_value) public returns (bool) {\n', '        require(!pauseTransfer);\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) moreThanZero(_value) public\n', '    returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender,_spender,_value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {\n', '        require(approve(_spender, _amount));\n', '        ApproveAndCallReceiver(_spender).receiveApproval(\n', '        msg.sender,\n', '        _amount,\n', '        this,\n', '        _extraData\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) realUser(_from) realUser(_to) moreThanZero(_value) public returns (bool success) {\n', '        require(!pauseTransfer);\n', '        require(balanceOf[_from] >= _value);                 // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows\n', '        require(allowance[_from][msg.sender] >= _value);     // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferMulti(address[] _to, uint256[] _value) onlyOwner public returns (uint256 amount){\n', '        require(_to.length == _value.length);\n', '        uint8 len = uint8(_to.length);\n', '        for(uint8 j; j<len; j++){\n', '            amount = amount.add(_value[j]*10**uint256(decimals));\n', '        }\n', '        require(balanceOf[msg.sender] >= amount);\n', '        for(uint8 i; i<len; i++){\n', '            address _toI = _to[i];\n', '            uint256 _valueI = _value[i]*10**uint256(decimals);\n', '            balanceOf[_toI] = balanceOf[_toI].add(_valueI);\n', '            balanceOf[msg.sender] =balanceOf[msg.sender].sub(_valueI);\n', '            emit Transfer(msg.sender, _toI, _valueI);\n', '        }\n', '    }\n', '\n', '    //冻结账户\n', '    function freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) onlyOwner public returns (bool success) {\n', '        _value=_value*10**uint256(decimals);\n', '        return _freeze(_user,_value,_step);\n', '    }\n', '\n', '    function _freeze(address _user, uint256 _value, uint8 _step) moreThanZero(_value) private returns (bool success) {\n', '        //info256("balanceOf[_user]", balanceOf[_user]);\n', '        require(balanceOf[_user] >= _value);\n', '        balanceOf[_user] = balanceOf[_user].sub(_value);\n', '        freezeOf[_step][lastFreezeSeq[_step]] = FreezeInfo({user:_user, amount:_value});\n', '        lastFreezeSeq[_step]++;\n', '        emit Freeze(_user, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    //为用户解锁账户资金\n', '    function unFreeze(uint8 _step) onlyOwner public returns (bool unlockOver) {\n', '        //_end = length of freezeOf[_step]\n', '        uint8 _end = lastFreezeSeq[_step];\n', '        require(_end > 0);\n', '        unlockOver=false;\n', '        uint8  _start=0;\n', '        for(; _end>_start; _end--){\n', '            FreezeInfo storage fInfo = freezeOf[_step][_end-1];\n', '            uint256 _amount = fInfo.amount;\n', '            balanceOf[fInfo.user] += _amount;\n', '            delete freezeOf[_step][_end-1];\n', '            lastFreezeSeq[_step]--;\n', '            emit Unfreeze(fInfo.user, _amount);\n', '        }\n', '    }\n', '\n', '    function generateTokens(address _user, uint _amount) onlyOwner public returns (bool) {\n', '        _amount=_amount*10**uint256(decimals);\n', '        return _generateTokens(_user,_amount);\n', '    }\n', '\n', '    function _generateTokens(address _user, uint _amount)  private returns (bool) {\n', '        require(balanceOf[owner] >= _amount);\n', '        balanceOf[_user] = balanceOf[_user].add(_amount);\n', '        balanceOf[owner] = balanceOf[owner].sub(_amount);\n', '        emit Transfer(0, _user, _amount);\n', '        return true;\n', '    }\n', '\n', '    function destroyTokens(address _user, uint256 _amount) onlyOwner public returns (bool) {\n', '        _amount=_amount*10**uint256(decimals);\n', '        return _destroyTokens(_user,_amount);\n', '    }\n', '\n', '    function _destroyTokens(address _user, uint256 _amount) private returns (bool) {\n', '        require(balanceOf[_user] >= _amount);\n', '        balanceOf[owner] = balanceOf[owner].add(_amount);\n', '        balanceOf[_user] = balanceOf[_user].sub(_amount);\n', '        emit Transfer(_user, 0, _amount);\n', '        emit Burn(_user, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function changeOwner(address newOwner) onlyOwner public returns (bool) {\n', '        balanceOf[newOwner] = balanceOf[owner];\n', '        balanceOf[owner] = 0;\n', '        owner = newOwner;\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * 修改token兑换比率,1eth兑换多少代币\n', '     */\n', '    function changeTokensPerEther(uint256 _newRate) onlyOwner public {\n', '        tokensPerEther = _newRate;\n', '    }\n', '\n', '    /**\n', '     * 修改每个账户可获得的空投量\n', '     */   \n', '    function changeAirdropQty(uint256 _airdropQty) onlyOwner public {\n', '        airdropQty = _airdropQty;\n', '    }\n', '\n', '    /**\n', '     * 修改空投总量\n', '     */   \n', '    function changeAirdropTotalQty(uint256 _airdropTotalQty) onlyOwner public {\n', '        uint256 _token =_airdropTotalQty*10**uint256(decimals);\n', '        require(balanceOf[owner] >= _token);\n', '        airdropTotalQty = _airdropTotalQty;\n', '    }\n', '\n', '        ////////////////\n', '    // 修是否暂停私募\n', '    ////////////////\n', '    function changePaused(bool _paused) onlyOwner public {\n', '        paused = _paused;\n', '    }\n', '    \n', '    function changePauseTranfser(bool _paused) onlyOwner public {\n', '        pauseTransfer = _paused;\n', '    }\n', '\n', '    //accept ether\n', '    function() payable public {\n', '        require(!paused);\n', '        address _user=msg.sender;\n', '        uint256 tokenValue;\n', '        if(msg.value==0){//空投\n', '            require(airdropQty>0);\n', '            require(airdropTotalQty>=airdropQty);\n', '            require(airdropOf[_user]==0);\n', '            tokenValue=airdropQty*10**uint256(decimals);\n', '            airdropOf[_user]=tokenValue;\n', '            airdropTotalQty-=airdropQty;\n', '            require(_generateTokens(_user, tokenValue));\n', '            emit Payment(_user, msg.value, tokenValue);\n', '        }else{\n', '            require(msg.value >= minFunding);//最低起投\n', '            require(msg.value % 1 ether==0);//只能投整数倍eth\n', '            totalCollected +=msg.value;\n', '            require(vaultAddress.send(msg.value));//Send the ether to the vault\n', '            tokenValue = (msg.value/1 ether)*(tokensPerEther*10 ** uint256(decimals));\n', '            require(_generateTokens(_user, tokenValue));\n', '            uint256 lock1 = tokenValue / 5;\n', '            require(_freeze(_user, lock1, 0));\n', '            _freeze(_user, lock1, 1);\n', '            _freeze(_user, lock1, 2);\n', '            _freeze(_user, lock1, 3);\n', '            emit Payment(_user, msg.value, tokenValue);\n', '\n', '        }\n', '    }\n', '}']
