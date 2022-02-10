['pragma solidity ^0.4.23;\n', '\n', '// ----------------------------------------------------------------------------\n', '// @Project FunkeyCoin (FNK)\n', '// @Creator FunkeyRyu\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// @Name SafeMath\n', '// @Desc Math operations with safety checks that throw on error\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '// ----------------------------------------------------------------------------\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// @Name Lockable\n', '// @Desc Admin Lock\n', '// ----------------------------------------------------------------------------\n', 'contract Lockable {\n', '    bool public    m_bIsLock;\n', '    \n', '    // Admin Address\n', '    address public m_aOwner;\n', '    mapping( address => bool ) public m_mLockAddress;\n', '\n', '    event Locked(address a_aLockAddress, bool a_bStatus);\n', '\n', '    modifier IsOwner {\n', '        require(m_aOwner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier CheckAllLock {\n', '        require(!m_bIsLock);\n', '        _;\n', '    }\n', '\n', '    modifier CheckLockAddress {\n', '        if (m_mLockAddress[msg.sender]) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        m_bIsLock   = true;\n', '        m_aOwner    = msg.sender;\n', '    }\n', '\n', '    function SetAllLock(bool a_bStatus)\n', '    public\n', '    IsOwner\n', '    {\n', '        m_bIsLock = a_bStatus;\n', '    }\n', '\n', '    // Lock Address\n', '    function SetLockAddress(address a_aLockAddress, bool a_bStatus)\n', '    external\n', '    IsOwner\n', '    {\n', '        require(m_aOwner != a_aLockAddress);\n', '\n', '        m_mLockAddress[a_aLockAddress] = a_bStatus;\n', '        \n', '        emit Locked(a_aLockAddress, a_bStatus);\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '// ----------------------------------------------------------------------------\n', '// @Name FunkeyCoinBase\n', '// @Desc ERC20-based token\n', '// ----------------------------------------------------------------------------\n', 'contract FunkeyCoinBase is ERC20Interface, Lockable {\n', '    using SafeMath for uint;\n', '\n', '    uint                                                _totalSupply;\n', '    mapping(address => uint256)                         _balances;\n', '    mapping(address => mapping(address => uint256))     _allowed;\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return _balances[tokenOwner];\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return _allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) \n', '    CheckAllLock\n', '    CheckLockAddress\n', '    public returns (bool success) {\n', '        require( _balances[msg.sender] >= tokens);\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(tokens);\n', '        _balances[to] = _balances[to].add(tokens);\n', '\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens)\n', '    CheckAllLock\n', '    CheckLockAddress\n', '    public returns (bool success) {\n', '        _allowed[msg.sender][spender] = tokens;\n', '\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens)\n', '    CheckAllLock\n', '    CheckLockAddress\n', '    public returns (bool success) {\n', '        require(tokens <= _balances[from]);\n', '        require(tokens <= _allowed[from][msg.sender]);\n', '        \n', '        _balances[from] = _balances[from].sub(tokens);\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);\n', '        _balances[to] = _balances[to].add(tokens);\n', '\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// @Name FunkeyCoin (FNK)\n', '// @Desc Funkey Admin Ryu\n', '// ----------------------------------------------------------------------------\n', 'contract FunkeyCoin is FunkeyCoinBase {\n', '    string  public   name;\n', '    uint8   public   decimals;\n', '    string  public   symbol;\n', '\n', '    event EventBurnCoin(address a_burnAddress, uint a_amount);\n', '\n', '    constructor (uint a_totalSupply, string a_tokenName, string a_tokenSymbol, uint8 a_decimals) public {\n', '        m_aOwner = msg.sender;\n', '        \n', '        _totalSupply = a_totalSupply;\n', '        _balances[msg.sender] = a_totalSupply;\n', '\n', '        name = a_tokenName;\n', '        symbol = a_tokenSymbol;\n', '        decimals = a_decimals;\n', '    }\n', '\n', '    function burnCoin(uint a_coinAmount)\n', '    external\n', '    IsOwner\n', '    {\n', '        require(_balances[msg.sender] >= a_coinAmount);\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(a_coinAmount);\n', '        _totalSupply = _totalSupply.sub(a_coinAmount);\n', '\n', '        emit EventBurnCoin(msg.sender, a_coinAmount);\n', '    }\n', '\n', '    // Allocate tokens to the users\n', '    function allocateCoins(address[] a_receiver, uint[] a_values)\n', '    external\n', '    IsOwner{\n', '        require(a_receiver.length == a_values.length);\n', '\n', '        uint    receiverLength = a_receiver.length;\n', '        address to;\n', '        uint    value;\n', '\n', '        for(uint ui = 0; ui < receiverLength; ui++){\n', '            to      = a_receiver[ui];\n', '            value   = a_values[ui].mul(10**uint(decimals));\n', '\n', '            require(_balances[msg.sender] >= value);\n', '\n', '            _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '            _balances[to] = _balances[to].add(value);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '// ----------------------------------------------------------------------------\n', '// @Project FunkeyCoin (FNK)\n', '// @Creator FunkeyRyu\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// @Name SafeMath\n', '// @Desc Math operations with safety checks that throw on error\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '// ----------------------------------------------------------------------------\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// @Name Lockable\n', '// @Desc Admin Lock\n', '// ----------------------------------------------------------------------------\n', 'contract Lockable {\n', '    bool public    m_bIsLock;\n', '    \n', '    // Admin Address\n', '    address public m_aOwner;\n', '    mapping( address => bool ) public m_mLockAddress;\n', '\n', '    event Locked(address a_aLockAddress, bool a_bStatus);\n', '\n', '    modifier IsOwner {\n', '        require(m_aOwner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier CheckAllLock {\n', '        require(!m_bIsLock);\n', '        _;\n', '    }\n', '\n', '    modifier CheckLockAddress {\n', '        if (m_mLockAddress[msg.sender]) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        m_bIsLock   = true;\n', '        m_aOwner    = msg.sender;\n', '    }\n', '\n', '    function SetAllLock(bool a_bStatus)\n', '    public\n', '    IsOwner\n', '    {\n', '        m_bIsLock = a_bStatus;\n', '    }\n', '\n', '    // Lock Address\n', '    function SetLockAddress(address a_aLockAddress, bool a_bStatus)\n', '    external\n', '    IsOwner\n', '    {\n', '        require(m_aOwner != a_aLockAddress);\n', '\n', '        m_mLockAddress[a_aLockAddress] = a_bStatus;\n', '        \n', '        emit Locked(a_aLockAddress, a_bStatus);\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '// ----------------------------------------------------------------------------\n', '// @Name FunkeyCoinBase\n', '// @Desc ERC20-based token\n', '// ----------------------------------------------------------------------------\n', 'contract FunkeyCoinBase is ERC20Interface, Lockable {\n', '    using SafeMath for uint;\n', '\n', '    uint                                                _totalSupply;\n', '    mapping(address => uint256)                         _balances;\n', '    mapping(address => mapping(address => uint256))     _allowed;\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return _balances[tokenOwner];\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return _allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) \n', '    CheckAllLock\n', '    CheckLockAddress\n', '    public returns (bool success) {\n', '        require( _balances[msg.sender] >= tokens);\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(tokens);\n', '        _balances[to] = _balances[to].add(tokens);\n', '\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens)\n', '    CheckAllLock\n', '    CheckLockAddress\n', '    public returns (bool success) {\n', '        _allowed[msg.sender][spender] = tokens;\n', '\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens)\n', '    CheckAllLock\n', '    CheckLockAddress\n', '    public returns (bool success) {\n', '        require(tokens <= _balances[from]);\n', '        require(tokens <= _allowed[from][msg.sender]);\n', '        \n', '        _balances[from] = _balances[from].sub(tokens);\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);\n', '        _balances[to] = _balances[to].add(tokens);\n', '\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// @Name FunkeyCoin (FNK)\n', '// @Desc Funkey Admin Ryu\n', '// ----------------------------------------------------------------------------\n', 'contract FunkeyCoin is FunkeyCoinBase {\n', '    string  public   name;\n', '    uint8   public   decimals;\n', '    string  public   symbol;\n', '\n', '    event EventBurnCoin(address a_burnAddress, uint a_amount);\n', '\n', '    constructor (uint a_totalSupply, string a_tokenName, string a_tokenSymbol, uint8 a_decimals) public {\n', '        m_aOwner = msg.sender;\n', '        \n', '        _totalSupply = a_totalSupply;\n', '        _balances[msg.sender] = a_totalSupply;\n', '\n', '        name = a_tokenName;\n', '        symbol = a_tokenSymbol;\n', '        decimals = a_decimals;\n', '    }\n', '\n', '    function burnCoin(uint a_coinAmount)\n', '    external\n', '    IsOwner\n', '    {\n', '        require(_balances[msg.sender] >= a_coinAmount);\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(a_coinAmount);\n', '        _totalSupply = _totalSupply.sub(a_coinAmount);\n', '\n', '        emit EventBurnCoin(msg.sender, a_coinAmount);\n', '    }\n', '\n', '    // Allocate tokens to the users\n', '    function allocateCoins(address[] a_receiver, uint[] a_values)\n', '    external\n', '    IsOwner{\n', '        require(a_receiver.length == a_values.length);\n', '\n', '        uint    receiverLength = a_receiver.length;\n', '        address to;\n', '        uint    value;\n', '\n', '        for(uint ui = 0; ui < receiverLength; ui++){\n', '            to      = a_receiver[ui];\n', '            value   = a_values[ui].mul(10**uint(decimals));\n', '\n', '            require(_balances[msg.sender] >= value);\n', '\n', '            _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '            _balances[to] = _balances[to].add(value);\n', '        }\n', '    }\n', '}']
