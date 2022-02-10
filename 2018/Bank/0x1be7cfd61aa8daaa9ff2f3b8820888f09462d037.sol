['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address tokenOwner) public view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b != 0);\n', '        c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract GGCToken is ERC20Interface{\n', '    using SafeMath for uint256;\n', '    using SafeMath for uint8;\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Events\n', '    // ------------------------------------------------------------------------\n', '    //typeNo WL 1, ACL 2, BL 3, FeeL 4, TransConL 5, GGCPool 6, GGEPool 7\n', '    event ListLog(address addr, uint8 indexed typeNo, bool active);\n', '    event Trans(address indexed fromAddr, address indexed toAddr, uint256 transAmount, uint256 ggcAmount, uint256 ggeAmount, uint64 time);\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    event Deposit(address indexed sender, uint value);\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint8 public ggcFee; \n', '    uint8 public ggeFee; \n', '    uint8 public maxFee;\n', '    uint256 public _totalSupply;\n', '\n', '    bool public feeLocked; \n', '    bool public transContractLocked;\n', '\n', '    address public owner;\n', '    address public ggcPoolAddr;\n', '    address public ggePoolAddr;     \n', '    address private ownerContract = address(0x0);\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => bool) public whiteList;\n', '    mapping(address => bool) public allowContractList;\n', '    mapping(address => bool) public blackList;\n', '    \n', '    constructor() public {\n', '        symbol = "GGC";\n', '        name = "GramGold Coin";\n', '        owner = msg.sender;\n', '        decimals = 8;\n', '        ggcFee = 2;\n', '        ggeFee = 1; \n', '        maxFee = 3;\n', '        _totalSupply = 600 * 10**uint256(decimals);\n', '        balances[owner] = _totalSupply;\n', '        ggcPoolAddr = address(0x0);\n', '        ggePoolAddr = address(0x0);\n', '        feeLocked = false;\n', '        transContractLocked = true;\n', '        whiteList[owner] = true; \n', '        emit ListLog(owner, 1, true);\n', '        emit Transfer(address(0x0), owner, _totalSupply);\n', '    }\n', '    \n', '    /**\n', '    * @dev Allow current contract owner transfer ownership to other address\n', '    */\n', '    function AssignGGCOwner(address _ownerContract) \n', '    public \n', '    onlyOwner \n', '    notNull(_ownerContract) \n', '    {\n', '        uint256 remainTokens = balances[owner];\n', '        ownerContract = _ownerContract;\n', '        balances[owner] = 0;\n', '        balances[ownerContract] = balances[ownerContract].add(remainTokens);\n', '        whiteList[ownerContract] = true; \n', '        emit ListLog(ownerContract, 1, true);\n', '        emit Transfer(owner, ownerContract, remainTokens);\n', '        emit OwnershipTransferred(owner, ownerContract);\n', '        owner = ownerContract;\n', '    }\n', '\n', '    /**\n', '    * @dev Check if the address is a wallet or a contract\n', '    */\n', '    function isContract(address _addr) \n', '    private \n', '    view \n', '    returns (bool) \n', '    {\n', '        if(allowContractList[_addr] || !transContractLocked){\n', '            return false;\n', '        }\n', '\n', '        uint256 codeLength = 0;\n', '\n', '        assembly {\n', '            codeLength := extcodesize(_addr)\n', '        }\n', '        \n', '        return (codeLength > 0);\n', '    }\n', '\n', '    /**\n', '    * @dev transfer _value from msg.sender to receiver\n', '    * Both sender and receiver pays a transaction fees\n', '    * The transaction fees will be transferred into GGCPool and GGEPool\n', '    */\n', '    function transfer(address _to, uint256 _value) \n', '    public \n', '    notNull(_to) \n', '    returns (bool success) \n', '    {\n', '        uint256 ggcFeeFrom;\n', '        uint256 ggeFeeFrom;\n', '        uint256 ggcFeeTo;\n', '        uint256 ggeFeeTo;\n', '\n', '        if (feeLocked) {\n', '            ggcFeeFrom = 0;\n', '            ggeFeeFrom = 0;\n', '            ggcFeeTo = 0;\n', '            ggeFeeTo = 0;\n', '        }else{\n', '            (ggcFeeFrom, ggeFeeFrom) = feesCal(msg.sender, _value);\n', '            (ggcFeeTo, ggeFeeTo) = feesCal(_to, _value);\n', '        }\n', '\n', '        require(balances[msg.sender] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        success = _transfer(msg.sender, _to, _value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        require(success);\n', '        success = _transfer(msg.sender, ggcPoolAddr, ggcFeeFrom.add(ggcFeeTo));\n', '        require(success);\n', '        success = _transfer(msg.sender, ggePoolAddr, ggeFeeFrom.add(ggeFeeTo));\n', '        require(success);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        balances[_to] = balances[_to].add(_value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        balances[ggcPoolAddr] = balances[ggcPoolAddr].add(ggcFeeFrom).add(ggcFeeTo);\n', '        balances[ggePoolAddr] = balances[ggePoolAddr].add(ggeFeeFrom).add(ggeFeeTo); \n', '\n', '        emit Trans(msg.sender, _to, _value, ggcFeeFrom.add(ggcFeeTo), ggeFeeFrom.add(ggeFeeTo), uint64(now));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer _value from contract owner to receiver\n', '    * Both contract owner and receiver pay transaction fees \n', '    * The transaction fees will be transferred into GGCPool and GGEPool\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) \n', '    public \n', '    notNull(_to) \n', '    returns (bool success) \n', '    {\n', '        uint256 ggcFeeFrom;\n', '        uint256 ggeFeeFrom;\n', '        uint256 ggcFeeTo;\n', '        uint256 ggeFeeTo;\n', '\n', '        if (feeLocked) {\n', '            ggcFeeFrom = 0;\n', '            ggeFeeFrom = 0;\n', '            ggcFeeTo = 0;\n', '            ggeFeeTo = 0;\n', '        }else{\n', '            (ggcFeeFrom, ggeFeeFrom) = feesCal(_from, _value);\n', '            (ggcFeeTo, ggeFeeTo) = feesCal(_to, _value);\n', '        }\n', '\n', '        require(balances[_from] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        require(allowed[_from][msg.sender] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '\n', '        success = _transfer(_from, _to, _value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        require(success);\n', '        success = _transfer(_from, ggcPoolAddr, ggcFeeFrom.add(ggcFeeTo));\n', '        require(success);\n', '        success = _transfer(_from, ggePoolAddr, ggeFeeFrom.add(ggeFeeTo));\n', '        require(success);\n', '\n', '        balances[_from] = balances[_from].sub(_value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        balances[_to] = balances[_to].add(_value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        balances[ggcPoolAddr] = balances[ggcPoolAddr].add(ggcFeeFrom).add(ggcFeeTo);\n', '        balances[ggePoolAddr] = balances[ggePoolAddr].add(ggeFeeFrom).add(ggeFeeTo); \n', '\n', '        emit Trans(_from, _to, _value, ggcFeeFrom.add(ggcFeeTo), ggeFeeFrom.add(ggeFeeTo), uint64(now));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev calculate transaction fee base on address and value.\n', '    * Check whiteList\n', '    */\n', '    function feesCal(address _addr, uint256 _value)\n', '    public\n', '    view\n', '    notNull(_addr) \n', '    returns (uint256 _ggcFee, uint256 _ggeFee)\n', '    {\n', '        if(whiteList[_addr]){\n', '            return (0, 0);\n', '        }else{\n', '            _ggcFee = _value.mul(ggcFee).div(1000).div(2);\n', '            _ggeFee = _value.mul(ggeFee).div(1000).div(2);\n', '            return (_ggcFee, _ggeFee);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev both transfer and transferfrom are dispatched here\n', '    * Check blackList\n', '    */\n', '    function _transfer(address _from, address _to, uint256 _value) \n', '    internal \n', '    notNull(_from) \n', '    notNull(_to) \n', '    returns (bool) \n', '    {\n', '        require(!blackList[_from]);\n', '        require(!blackList[_to]);       \n', '        require(!isContract(_to));\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) \n', '    public \n', '    returns (bool success) \n', '    {\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {\n', '            return false;\n', '        }\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _tokenOwner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _tokenOwner, address _spender) \n', '    public \n', '    view \n', '    returns (uint256 remaining) \n', '    {\n', '        return allowed[_tokenOwner][_spender];\n', '    }\n', '    \n', '    function() \n', '    payable\n', '    {\n', '        if (msg.value > 0)\n', '            emit Deposit(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '    * @dev Reject all ERC223 compatible tokens\n', '    * @param from_ address The address that is transferring the tokens\n', '    * @param value_ uint256 the amount of the specified token\n', '    * @param data_ Bytes The data passed from the caller.\n', '    */\n', '    function tokenFallback(address from_, uint256 value_, bytes data_) \n', '    external \n', '    {\n', '        from_;\n', '        value_;\n', '        data_;\n', '        revert();\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Modifiers\n', '    // ------------------------------------------------------------------------\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier notNull(address _address) {\n', '        require(_address != address(0x0));\n', '        _;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // onlyOwner API\n', '    // ------------------------------------------------------------------------\n', '    function setGGCAddress(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        if(ggcPoolAddr == address(0x0)){\n', '            ggcPoolAddr = _addr;    \n', '        }else{\n', '            ggcPoolAddr = owner;\n', '        }\n', '        \n', '        emit ListLog(ggcPoolAddr, 6, false);\n', '    }\n', '\n', '    function setGGEAddress(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        if(ggePoolAddr == address(0x0)){\n', '            ggePoolAddr = _addr;    \n', '        }else{\n', '            ggePoolAddr = owner;\n', '        }\n', '                        \n', '        emit ListLog(ggePoolAddr, 7, false);\n', '    }\n', '\n', '    function setGGCFee(uint8 _val) \n', '    public \n', '    onlyOwner \n', '    {\n', '        require(ggeFee.add(_val) <= maxFee);\n', '        ggcFee = _val;\n', '    }\n', '\n', '    function setGGEFee(uint8 _val) \n', '    public \n', '    onlyOwner \n', '    {\n', '        require(ggcFee.add(_val) <= maxFee);\n', '        ggeFee = _val;\n', '    }\n', '    \n', '    function addBlacklist(address _addr) public notNull(_addr) onlyOwner {\n', '        blackList[_addr] = true; \n', '        emit ListLog(_addr, 3, true);\n', '    }\n', '    \n', '    function delBlackList(address _addr) public notNull(_addr) onlyOwner {\n', '        delete blackList[_addr];                \n', '        emit ListLog(_addr, 3, false);\n', '    }\n', '\n', '    function setFeeLocked(bool _lock) \n', '    public \n', '    onlyOwner \n', '    {\n', '        feeLocked = _lock;    \n', '        emit ListLog(address(0x0), 4, _lock); \n', '    }\n', '\n', '    function setTransContractLocked(bool _lock) \n', '    public \n', '    onlyOwner \n', '    {\n', '        transContractLocked = _lock;                  \n', '        emit ListLog(address(0x0), 5, _lock); \n', '    }\n', '\n', '    function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) \n', '    public \n', '    onlyOwner \n', '    returns (bool success) \n', '    {\n', '        return ERC20Interface(_tokenAddress).transfer(owner, _tokens);\n', '    }\n', '\n', '    function reclaimEther(address _addr) \n', '    external \n', '    onlyOwner \n', '    {\n', '        assert(_addr.send(this.balance));\n', '    }\n', '  \n', '    function mintToken(address _targetAddr, uint256 _mintedAmount) \n', '    public \n', '    onlyOwner \n', '    {\n', '        balances[_targetAddr] = balances[_targetAddr].add(_mintedAmount);\n', '        _totalSupply = _totalSupply.add(_mintedAmount);\n', '        \n', '        emit Transfer(address(0x0), _targetAddr, _mintedAmount);\n', '    }\n', ' \n', '    function burnToken(uint256 _burnedAmount) \n', '    public \n', '    onlyOwner \n', '    {\n', '        require(balances[owner] >= _burnedAmount);\n', '        \n', '        balances[owner] = balances[owner].sub(_burnedAmount);\n', '        _totalSupply = _totalSupply.sub(_burnedAmount);\n', '        \n', '        emit Transfer(owner, address(0x0), _burnedAmount);\n', '    }\n', '\n', '    function addWhiteList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        whiteList[_addr] = true; \n', '        emit ListLog(_addr, 1, true);\n', '    }\n', '  \n', '    function delWhiteList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner\n', '    {\n', '        delete whiteList[_addr];\n', '        emit ListLog(_addr, 1, false);\n', '    }\n', '\n', '    function addAllowContractList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        allowContractList[_addr] = true; \n', '        emit ListLog(_addr, 2, true);\n', '    }\n', '  \n', '    function delAllowContractList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        delete allowContractList[_addr];\n', '        emit ListLog(_addr, 2, false);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint256 _addedValue) \n', '    public \n', '    notNull(_spender) \n', '    onlyOwner returns (bool) \n', '    {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '   }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) \n', '    public \n', '    notNull(_spender) \n', '    onlyOwner returns (bool) \n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) { \n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function changeName(string _name, string _symbol) \n', '    public\n', '    onlyOwner\n', '    {\n', '        name = _name;\n', '        symbol = _symbol;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Public view API\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address _tokenOwner) \n', '    public \n', '    view \n', '    returns (uint256 balance) \n', '    {\n', '        return balances[_tokenOwner];\n', '    }\n', '    \n', '    function totalSupply() \n', '    public \n', '    view \n', '    returns (uint256) \n', '    {\n', '        return _totalSupply.sub(balances[address(0x0)]);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address tokenOwner) public view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b != 0);\n', '        c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract GGCToken is ERC20Interface{\n', '    using SafeMath for uint256;\n', '    using SafeMath for uint8;\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Events\n', '    // ------------------------------------------------------------------------\n', '    //typeNo WL 1, ACL 2, BL 3, FeeL 4, TransConL 5, GGCPool 6, GGEPool 7\n', '    event ListLog(address addr, uint8 indexed typeNo, bool active);\n', '    event Trans(address indexed fromAddr, address indexed toAddr, uint256 transAmount, uint256 ggcAmount, uint256 ggeAmount, uint64 time);\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    event Deposit(address indexed sender, uint value);\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint8 public ggcFee; \n', '    uint8 public ggeFee; \n', '    uint8 public maxFee;\n', '    uint256 public _totalSupply;\n', '\n', '    bool public feeLocked; \n', '    bool public transContractLocked;\n', '\n', '    address public owner;\n', '    address public ggcPoolAddr;\n', '    address public ggePoolAddr;     \n', '    address private ownerContract = address(0x0);\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => bool) public whiteList;\n', '    mapping(address => bool) public allowContractList;\n', '    mapping(address => bool) public blackList;\n', '    \n', '    constructor() public {\n', '        symbol = "GGC";\n', '        name = "GramGold Coin";\n', '        owner = msg.sender;\n', '        decimals = 8;\n', '        ggcFee = 2;\n', '        ggeFee = 1; \n', '        maxFee = 3;\n', '        _totalSupply = 600 * 10**uint256(decimals);\n', '        balances[owner] = _totalSupply;\n', '        ggcPoolAddr = address(0x0);\n', '        ggePoolAddr = address(0x0);\n', '        feeLocked = false;\n', '        transContractLocked = true;\n', '        whiteList[owner] = true; \n', '        emit ListLog(owner, 1, true);\n', '        emit Transfer(address(0x0), owner, _totalSupply);\n', '    }\n', '    \n', '    /**\n', '    * @dev Allow current contract owner transfer ownership to other address\n', '    */\n', '    function AssignGGCOwner(address _ownerContract) \n', '    public \n', '    onlyOwner \n', '    notNull(_ownerContract) \n', '    {\n', '        uint256 remainTokens = balances[owner];\n', '        ownerContract = _ownerContract;\n', '        balances[owner] = 0;\n', '        balances[ownerContract] = balances[ownerContract].add(remainTokens);\n', '        whiteList[ownerContract] = true; \n', '        emit ListLog(ownerContract, 1, true);\n', '        emit Transfer(owner, ownerContract, remainTokens);\n', '        emit OwnershipTransferred(owner, ownerContract);\n', '        owner = ownerContract;\n', '    }\n', '\n', '    /**\n', '    * @dev Check if the address is a wallet or a contract\n', '    */\n', '    function isContract(address _addr) \n', '    private \n', '    view \n', '    returns (bool) \n', '    {\n', '        if(allowContractList[_addr] || !transContractLocked){\n', '            return false;\n', '        }\n', '\n', '        uint256 codeLength = 0;\n', '\n', '        assembly {\n', '            codeLength := extcodesize(_addr)\n', '        }\n', '        \n', '        return (codeLength > 0);\n', '    }\n', '\n', '    /**\n', '    * @dev transfer _value from msg.sender to receiver\n', '    * Both sender and receiver pays a transaction fees\n', '    * The transaction fees will be transferred into GGCPool and GGEPool\n', '    */\n', '    function transfer(address _to, uint256 _value) \n', '    public \n', '    notNull(_to) \n', '    returns (bool success) \n', '    {\n', '        uint256 ggcFeeFrom;\n', '        uint256 ggeFeeFrom;\n', '        uint256 ggcFeeTo;\n', '        uint256 ggeFeeTo;\n', '\n', '        if (feeLocked) {\n', '            ggcFeeFrom = 0;\n', '            ggeFeeFrom = 0;\n', '            ggcFeeTo = 0;\n', '            ggeFeeTo = 0;\n', '        }else{\n', '            (ggcFeeFrom, ggeFeeFrom) = feesCal(msg.sender, _value);\n', '            (ggcFeeTo, ggeFeeTo) = feesCal(_to, _value);\n', '        }\n', '\n', '        require(balances[msg.sender] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        success = _transfer(msg.sender, _to, _value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        require(success);\n', '        success = _transfer(msg.sender, ggcPoolAddr, ggcFeeFrom.add(ggcFeeTo));\n', '        require(success);\n', '        success = _transfer(msg.sender, ggePoolAddr, ggeFeeFrom.add(ggeFeeTo));\n', '        require(success);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        balances[_to] = balances[_to].add(_value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        balances[ggcPoolAddr] = balances[ggcPoolAddr].add(ggcFeeFrom).add(ggcFeeTo);\n', '        balances[ggePoolAddr] = balances[ggePoolAddr].add(ggeFeeFrom).add(ggeFeeTo); \n', '\n', '        emit Trans(msg.sender, _to, _value, ggcFeeFrom.add(ggcFeeTo), ggeFeeFrom.add(ggeFeeTo), uint64(now));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer _value from contract owner to receiver\n', '    * Both contract owner and receiver pay transaction fees \n', '    * The transaction fees will be transferred into GGCPool and GGEPool\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) \n', '    public \n', '    notNull(_to) \n', '    returns (bool success) \n', '    {\n', '        uint256 ggcFeeFrom;\n', '        uint256 ggeFeeFrom;\n', '        uint256 ggcFeeTo;\n', '        uint256 ggeFeeTo;\n', '\n', '        if (feeLocked) {\n', '            ggcFeeFrom = 0;\n', '            ggeFeeFrom = 0;\n', '            ggcFeeTo = 0;\n', '            ggeFeeTo = 0;\n', '        }else{\n', '            (ggcFeeFrom, ggeFeeFrom) = feesCal(_from, _value);\n', '            (ggcFeeTo, ggeFeeTo) = feesCal(_to, _value);\n', '        }\n', '\n', '        require(balances[_from] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        require(allowed[_from][msg.sender] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '\n', '        success = _transfer(_from, _to, _value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        require(success);\n', '        success = _transfer(_from, ggcPoolAddr, ggcFeeFrom.add(ggcFeeTo));\n', '        require(success);\n', '        success = _transfer(_from, ggePoolAddr, ggeFeeFrom.add(ggeFeeTo));\n', '        require(success);\n', '\n', '        balances[_from] = balances[_from].sub(_value.add(ggcFeeFrom).add(ggeFeeFrom));\n', '        balances[_to] = balances[_to].add(_value.sub(ggcFeeTo).sub(ggeFeeTo));\n', '        balances[ggcPoolAddr] = balances[ggcPoolAddr].add(ggcFeeFrom).add(ggcFeeTo);\n', '        balances[ggePoolAddr] = balances[ggePoolAddr].add(ggeFeeFrom).add(ggeFeeTo); \n', '\n', '        emit Trans(_from, _to, _value, ggcFeeFrom.add(ggcFeeTo), ggeFeeFrom.add(ggeFeeTo), uint64(now));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev calculate transaction fee base on address and value.\n', '    * Check whiteList\n', '    */\n', '    function feesCal(address _addr, uint256 _value)\n', '    public\n', '    view\n', '    notNull(_addr) \n', '    returns (uint256 _ggcFee, uint256 _ggeFee)\n', '    {\n', '        if(whiteList[_addr]){\n', '            return (0, 0);\n', '        }else{\n', '            _ggcFee = _value.mul(ggcFee).div(1000).div(2);\n', '            _ggeFee = _value.mul(ggeFee).div(1000).div(2);\n', '            return (_ggcFee, _ggeFee);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev both transfer and transferfrom are dispatched here\n', '    * Check blackList\n', '    */\n', '    function _transfer(address _from, address _to, uint256 _value) \n', '    internal \n', '    notNull(_from) \n', '    notNull(_to) \n', '    returns (bool) \n', '    {\n', '        require(!blackList[_from]);\n', '        require(!blackList[_to]);       \n', '        require(!isContract(_to));\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) \n', '    public \n', '    returns (bool success) \n', '    {\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {\n', '            return false;\n', '        }\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _tokenOwner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _tokenOwner, address _spender) \n', '    public \n', '    view \n', '    returns (uint256 remaining) \n', '    {\n', '        return allowed[_tokenOwner][_spender];\n', '    }\n', '    \n', '    function() \n', '    payable\n', '    {\n', '        if (msg.value > 0)\n', '            emit Deposit(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '    * @dev Reject all ERC223 compatible tokens\n', '    * @param from_ address The address that is transferring the tokens\n', '    * @param value_ uint256 the amount of the specified token\n', '    * @param data_ Bytes The data passed from the caller.\n', '    */\n', '    function tokenFallback(address from_, uint256 value_, bytes data_) \n', '    external \n', '    {\n', '        from_;\n', '        value_;\n', '        data_;\n', '        revert();\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Modifiers\n', '    // ------------------------------------------------------------------------\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier notNull(address _address) {\n', '        require(_address != address(0x0));\n', '        _;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // onlyOwner API\n', '    // ------------------------------------------------------------------------\n', '    function setGGCAddress(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        if(ggcPoolAddr == address(0x0)){\n', '            ggcPoolAddr = _addr;    \n', '        }else{\n', '            ggcPoolAddr = owner;\n', '        }\n', '        \n', '        emit ListLog(ggcPoolAddr, 6, false);\n', '    }\n', '\n', '    function setGGEAddress(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        if(ggePoolAddr == address(0x0)){\n', '            ggePoolAddr = _addr;    \n', '        }else{\n', '            ggePoolAddr = owner;\n', '        }\n', '                        \n', '        emit ListLog(ggePoolAddr, 7, false);\n', '    }\n', '\n', '    function setGGCFee(uint8 _val) \n', '    public \n', '    onlyOwner \n', '    {\n', '        require(ggeFee.add(_val) <= maxFee);\n', '        ggcFee = _val;\n', '    }\n', '\n', '    function setGGEFee(uint8 _val) \n', '    public \n', '    onlyOwner \n', '    {\n', '        require(ggcFee.add(_val) <= maxFee);\n', '        ggeFee = _val;\n', '    }\n', '    \n', '    function addBlacklist(address _addr) public notNull(_addr) onlyOwner {\n', '        blackList[_addr] = true; \n', '        emit ListLog(_addr, 3, true);\n', '    }\n', '    \n', '    function delBlackList(address _addr) public notNull(_addr) onlyOwner {\n', '        delete blackList[_addr];                \n', '        emit ListLog(_addr, 3, false);\n', '    }\n', '\n', '    function setFeeLocked(bool _lock) \n', '    public \n', '    onlyOwner \n', '    {\n', '        feeLocked = _lock;    \n', '        emit ListLog(address(0x0), 4, _lock); \n', '    }\n', '\n', '    function setTransContractLocked(bool _lock) \n', '    public \n', '    onlyOwner \n', '    {\n', '        transContractLocked = _lock;                  \n', '        emit ListLog(address(0x0), 5, _lock); \n', '    }\n', '\n', '    function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) \n', '    public \n', '    onlyOwner \n', '    returns (bool success) \n', '    {\n', '        return ERC20Interface(_tokenAddress).transfer(owner, _tokens);\n', '    }\n', '\n', '    function reclaimEther(address _addr) \n', '    external \n', '    onlyOwner \n', '    {\n', '        assert(_addr.send(this.balance));\n', '    }\n', '  \n', '    function mintToken(address _targetAddr, uint256 _mintedAmount) \n', '    public \n', '    onlyOwner \n', '    {\n', '        balances[_targetAddr] = balances[_targetAddr].add(_mintedAmount);\n', '        _totalSupply = _totalSupply.add(_mintedAmount);\n', '        \n', '        emit Transfer(address(0x0), _targetAddr, _mintedAmount);\n', '    }\n', ' \n', '    function burnToken(uint256 _burnedAmount) \n', '    public \n', '    onlyOwner \n', '    {\n', '        require(balances[owner] >= _burnedAmount);\n', '        \n', '        balances[owner] = balances[owner].sub(_burnedAmount);\n', '        _totalSupply = _totalSupply.sub(_burnedAmount);\n', '        \n', '        emit Transfer(owner, address(0x0), _burnedAmount);\n', '    }\n', '\n', '    function addWhiteList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        whiteList[_addr] = true; \n', '        emit ListLog(_addr, 1, true);\n', '    }\n', '  \n', '    function delWhiteList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner\n', '    {\n', '        delete whiteList[_addr];\n', '        emit ListLog(_addr, 1, false);\n', '    }\n', '\n', '    function addAllowContractList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        allowContractList[_addr] = true; \n', '        emit ListLog(_addr, 2, true);\n', '    }\n', '  \n', '    function delAllowContractList(address _addr) \n', '    public \n', '    notNull(_addr) \n', '    onlyOwner \n', '    {\n', '        delete allowContractList[_addr];\n', '        emit ListLog(_addr, 2, false);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint256 _addedValue) \n', '    public \n', '    notNull(_spender) \n', '    onlyOwner returns (bool) \n', '    {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '   }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) \n', '    public \n', '    notNull(_spender) \n', '    onlyOwner returns (bool) \n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) { \n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function changeName(string _name, string _symbol) \n', '    public\n', '    onlyOwner\n', '    {\n', '        name = _name;\n', '        symbol = _symbol;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Public view API\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address _tokenOwner) \n', '    public \n', '    view \n', '    returns (uint256 balance) \n', '    {\n', '        return balances[_tokenOwner];\n', '    }\n', '    \n', '    function totalSupply() \n', '    public \n', '    view \n', '    returns (uint256) \n', '    {\n', '        return _totalSupply.sub(balances[address(0x0)]);\n', '    }\n', '}']