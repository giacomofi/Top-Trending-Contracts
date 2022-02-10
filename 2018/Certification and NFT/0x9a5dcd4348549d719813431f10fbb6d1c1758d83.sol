['pragma solidity ^0.4.24;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', '   防止整数溢出问题\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract StandardToken {\n', '\t//使用SafeMath\n', '    using SafeMath for uint256;\n', '   \n', '    //代币名称\n', '    string public name;\n', '    //代币缩写\n', '    string public symbol;\n', '\t//代币小数位数(一个代币可以分为多少份)\n', '    uint8 public  decimals;\n', '\t//代币总数\n', '\tuint256 public totalSupply;\n', '   \n', '\t//交易的发起方(谁调用这个方法，谁就是交易的发起方)把_value数量的代币发送到_to账户\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    //从_from账户里转出_value数量的代币到_to账户\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '\t//交易的发起方把_value数量的代币的使用权交给_spender，然后_spender才能调用transferFrom方法把我账户里的钱转给另外一个人\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '\t//查询_spender目前还有多少_owner账户代币的使用权\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '\t//转账成功的事件\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\t//使用权委托成功的事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '//设置代币控制合约的管理员\n', 'contract Owned {\n', '\n', '    // modifier(条件)，表示必须是权力所有者才能do something，类似administrator的意思\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;//do something \n', '    }\n', '\n', '\t//权力所有者\n', '    address public owner;\n', '\n', '\t//合约创建的时候执行，执行合约的人是第一个owner\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\t//新的owner,初始为空地址，类似null\n', '    address newOwner=0x0;\n', '\n', '\t//更换owner成功的事件\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    //现任owner把所有权交给新的owner(需要新的owner调用acceptOwnership方法才会生效)\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    //新的owner接受所有权,权力交替正式生效\n', '    function acceptOwnership() public{\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '//代币的控制合约\n', 'contract Controlled is Owned{\n', '\n', '\t//创世vip\n', '    constructor() public {\n', '       setExclude(msg.sender,true);\n', '    }\n', '\n', '    // 控制代币是否可以交易，true代表可以(exclude里的账户不受此限制，具体实现在下面的transferAllowed里)\n', '    bool public transferEnabled = true;\n', '\n', '    // 是否启用账户锁定功能，true代表启用\n', '    bool lockFlag=true;\n', '\t// 锁定的账户集合，address账户，bool是否被锁，true:被锁定，当lockFlag=true时，恭喜，你转不了账了，哈哈\n', '    mapping(address => bool) locked;\n', '\t// 拥有特权用户，不受transferEnabled和lockFlag的限制，vip啊，bool为true代表vip有效\n', '    mapping(address => bool) exclude;\n', '\n', '\t//设置transferEnabled值\n', '    function enableTransfer(bool _enable) public onlyOwner returns (bool success){\n', '        transferEnabled=_enable;\n', '\t\treturn true;\n', '    }\n', '\n', '\t//设置lockFlag值\n', '    function disableLock(bool _enable) public onlyOwner returns (bool success){\n', '        lockFlag=_enable;\n', '        return true;\n', '    }\n', '\n', '\t// 把_addr加到锁定账户里，拉黑名单。。。\n', '    function addLock(address _addr) public onlyOwner returns (bool success){\n', '        require(_addr!=msg.sender);\n', '        locked[_addr]=true;\n', '        return true;\n', '    }\n', '\n', '\t//设置vip用户\n', '    function setExclude(address _addr,bool _enable) public onlyOwner returns (bool success){\n', '        exclude[_addr]=_enable;\n', '        return true;\n', '    }\n', '\n', '\t//解锁_addr用户\n', '    function removeLock(address _addr) public onlyOwner returns (bool success){\n', '        locked[_addr]=false;\n', '        return true;\n', '    }\n', '\t//控制合约 核心实现\n', '    modifier transferAllowed(address _addr) {\n', '        if (!exclude[_addr]) {\n', '            require(transferEnabled,"transfer is not enabeled now!");\n', '            if(lockFlag){\n', '                require(!locked[_addr],"you are locked!");\n', '            }\n', '        }\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '//端午节，代币离骚\n', 'contract LiSaoToken is StandardToken,Controlled {\n', '\n', '\t//账户集合\n', '\tmapping (address => uint256) public balanceOf;\n', '\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\t\n', '\tconstructor() public {\n', '        totalSupply = 1000000000;//10亿\n', '        name = "LiSao Token";\n', '        symbol = "LS";\n', '        decimals = 0;\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balanceOf[msg.sender]);\n', '\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {\n', '\t\trequire(_to != address(0));\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', '   防止整数溢出问题\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract StandardToken {\n', '\t//使用SafeMath\n', '    using SafeMath for uint256;\n', '   \n', '    //代币名称\n', '    string public name;\n', '    //代币缩写\n', '    string public symbol;\n', '\t//代币小数位数(一个代币可以分为多少份)\n', '    uint8 public  decimals;\n', '\t//代币总数\n', '\tuint256 public totalSupply;\n', '   \n', '\t//交易的发起方(谁调用这个方法，谁就是交易的发起方)把_value数量的代币发送到_to账户\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    //从_from账户里转出_value数量的代币到_to账户\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '\t//交易的发起方把_value数量的代币的使用权交给_spender，然后_spender才能调用transferFrom方法把我账户里的钱转给另外一个人\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '\t//查询_spender目前还有多少_owner账户代币的使用权\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '\t//转账成功的事件\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\t//使用权委托成功的事件\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '//设置代币控制合约的管理员\n', 'contract Owned {\n', '\n', '    // modifier(条件)，表示必须是权力所有者才能do something，类似administrator的意思\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;//do something \n', '    }\n', '\n', '\t//权力所有者\n', '    address public owner;\n', '\n', '\t//合约创建的时候执行，执行合约的人是第一个owner\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\t//新的owner,初始为空地址，类似null\n', '    address newOwner=0x0;\n', '\n', '\t//更换owner成功的事件\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    //现任owner把所有权交给新的owner(需要新的owner调用acceptOwnership方法才会生效)\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    //新的owner接受所有权,权力交替正式生效\n', '    function acceptOwnership() public{\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '//代币的控制合约\n', 'contract Controlled is Owned{\n', '\n', '\t//创世vip\n', '    constructor() public {\n', '       setExclude(msg.sender,true);\n', '    }\n', '\n', '    // 控制代币是否可以交易，true代表可以(exclude里的账户不受此限制，具体实现在下面的transferAllowed里)\n', '    bool public transferEnabled = true;\n', '\n', '    // 是否启用账户锁定功能，true代表启用\n', '    bool lockFlag=true;\n', '\t// 锁定的账户集合，address账户，bool是否被锁，true:被锁定，当lockFlag=true时，恭喜，你转不了账了，哈哈\n', '    mapping(address => bool) locked;\n', '\t// 拥有特权用户，不受transferEnabled和lockFlag的限制，vip啊，bool为true代表vip有效\n', '    mapping(address => bool) exclude;\n', '\n', '\t//设置transferEnabled值\n', '    function enableTransfer(bool _enable) public onlyOwner returns (bool success){\n', '        transferEnabled=_enable;\n', '\t\treturn true;\n', '    }\n', '\n', '\t//设置lockFlag值\n', '    function disableLock(bool _enable) public onlyOwner returns (bool success){\n', '        lockFlag=_enable;\n', '        return true;\n', '    }\n', '\n', '\t// 把_addr加到锁定账户里，拉黑名单。。。\n', '    function addLock(address _addr) public onlyOwner returns (bool success){\n', '        require(_addr!=msg.sender);\n', '        locked[_addr]=true;\n', '        return true;\n', '    }\n', '\n', '\t//设置vip用户\n', '    function setExclude(address _addr,bool _enable) public onlyOwner returns (bool success){\n', '        exclude[_addr]=_enable;\n', '        return true;\n', '    }\n', '\n', '\t//解锁_addr用户\n', '    function removeLock(address _addr) public onlyOwner returns (bool success){\n', '        locked[_addr]=false;\n', '        return true;\n', '    }\n', '\t//控制合约 核心实现\n', '    modifier transferAllowed(address _addr) {\n', '        if (!exclude[_addr]) {\n', '            require(transferEnabled,"transfer is not enabeled now!");\n', '            if(lockFlag){\n', '                require(!locked[_addr],"you are locked!");\n', '            }\n', '        }\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '//端午节，代币离骚\n', 'contract LiSaoToken is StandardToken,Controlled {\n', '\n', '\t//账户集合\n', '\tmapping (address => uint256) public balanceOf;\n', '\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\t\n', '\tconstructor() public {\n', '        totalSupply = 1000000000;//10亿\n', '        name = "LiSao Token";\n', '        symbol = "LS";\n', '        decimals = 0;\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balanceOf[msg.sender]);\n', '\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {\n', '\t\trequire(_to != address(0));\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}']
