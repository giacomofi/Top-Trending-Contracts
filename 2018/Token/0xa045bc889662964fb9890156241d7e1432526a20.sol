['pragma solidity ^0.4.11;\n', '/**\n', '    ERC20 Interface\n', '    @author DongOk Peter Ryu - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="4b242f22250b322c2c2f392a3823652224">[email&#160;protected]</a>>\n', '*/\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint supply);\n', '    function balanceOf( address who ) public constant returns (uint value);\n', '    function allowance( address owner, address spender ) public constant returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) public returns (bool ok);\n', '    function transferFrom( address from, address to, uint value) public returns (bool ok);\n', '    function approve( address spender, uint value ) public returns (bool ok);\n', '\n', '    event Transfer( address indexed from, address indexed to, uint value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/**\n', '    LOCKABLE TOKEN\n', '    @author DongOk Peter Ryu - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="18777c717658617f7f7c6a796b70367177">[email&#160;protected]</a>>\n', '*/\n', 'contract Lockable {\n', '    uint public creationTime;\n', '    bool public lock;\n', '    bool public tokenTransfer;\n', '    address public owner;\n', '    mapping( address => bool ) public unlockaddress;\n', '    // lockaddress List\n', '    mapping( address => bool ) public lockaddress;\n', '\n', '    // LOCK EVENT\n', '    event Locked(address lockaddress,bool status);\n', '    // UNLOCK EVENT\n', '    event Unlocked(address unlockedaddress, bool status);\n', '\n', '\n', '    // if Token transfer\n', '    modifier isTokenTransfer {\n', '        // if token transfer is not allow\n', '        if(!tokenTransfer) {\n', '            require(unlockaddress[msg.sender]);\n', '        }\n', '        _;\n', '    }\n', '\n', '    // This modifier check whether the contract should be in a locked\n', '    // or unlocked state, then acts and updates accordingly if\n', '    // necessary\n', '    modifier checkLock {\n', '        assert(!lockaddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier isOwner\n', '    {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function Lockable()\n', '    public\n', '    {\n', '        creationTime = now;\n', '        tokenTransfer = false;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Lock Address\n', '    function lockAddress(address target, bool status)\n', '    external\n', '    isOwner\n', '    {\n', '        require(owner != target);\n', '        lockaddress[target] = status;\n', '        Locked(target, status);\n', '    }\n', '\n', '    // UnLock Address\n', '    function unlockAddress(address target, bool status)\n', '    external\n', '    isOwner\n', '    {\n', '        unlockaddress[target] = status;\n', '        Unlocked(target, status);\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', '/**\n', '    YGGDRASH Token\n', '    @author DongOk Peter Ryu - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="1b747f72755b627c7c7f697a6873357274">[email&#160;protected]</a>>\n', '*/\n', 'contract YeedToken is ERC20, Lockable {\n', '    using SafeMath for uint;\n', '\n', '    mapping( address => uint ) _balances;\n', '    mapping( address => mapping( address => uint ) ) _approvals;\n', '    uint _supply;\n', '    address public walletAddress;\n', '\n', '    event TokenBurned(address burnAddress, uint amountOfTokens);\n', '    event TokenTransfer();\n', '\n', '    modifier onlyFromWallet {\n', '        require(msg.sender != walletAddress);\n', '        _;\n', '    }\n', '\n', '    function YeedToken( uint initial_balance, address wallet)\n', '    public\n', '    {\n', '        require(wallet != 0);\n', '        require(initial_balance != 0);\n', '        _balances[msg.sender] = initial_balance;\n', '        _supply = initial_balance;\n', '        walletAddress = wallet;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint supply) {\n', '        return _supply;\n', '    }\n', '\n', '    function balanceOf( address who ) public constant returns (uint value) {\n', '        return _balances[who];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public constant returns (uint _allowance) {\n', '        return _approvals[owner][spender];\n', '    }\n', '\n', '    function transfer( address to, uint value)\n', '    public\n', '    isTokenTransfer\n', '    checkLock\n', '    returns (bool success) {\n', '\n', '        require( _balances[msg.sender] >= value );\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        Transfer( msg.sender, to, value );\n', '        return true;\n', '    }\n', '\n', '    function transferFrom( address from, address to, uint value)\n', '    public\n', '    isTokenTransfer\n', '    checkLock\n', '    returns (bool success) {\n', '        // if you don&#39;t have enough balance, throw\n', '        require( _balances[from] >= value );\n', '        // if you don&#39;t have approval, throw\n', '        require( _approvals[from][msg.sender] >= value );\n', '        // transfer and return true\n', '        _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        Transfer( from, to, value );\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint value)\n', '    public\n', '    checkLock\n', '    returns (bool success) {\n', '        _approvals[msg.sender][spender] = value;\n', '        Approval( msg.sender, spender, value );\n', '        return true;\n', '    }\n', '\n', '    // burnToken burn tokensAmount for sender balance\n', '    function burnTokens(uint tokensAmount)\n', '    public\n', '    isTokenTransfer\n', '    {\n', '        require( _balances[msg.sender] >= tokensAmount );\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);\n', '        _supply = _supply.sub(tokensAmount);\n', '        TokenBurned(msg.sender, tokensAmount);\n', '\n', '    }\n', '\n', '\n', '    function enableTokenTransfer()\n', '    external\n', '    onlyFromWallet\n', '    {\n', '        tokenTransfer = true;\n', '        TokenTransfer();\n', '    }\n', '\n', '    function disableTokenTransfer()\n', '    external\n', '    onlyFromWallet\n', '    {\n', '        tokenTransfer = false;\n', '        TokenTransfer();\n', '    }\n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '/**\n', '    ERC20 Interface\n', '    @author DongOk Peter Ryu - <odin@yggdrash.io>\n', '*/\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint supply);\n', '    function balanceOf( address who ) public constant returns (uint value);\n', '    function allowance( address owner, address spender ) public constant returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) public returns (bool ok);\n', '    function transferFrom( address from, address to, uint value) public returns (bool ok);\n', '    function approve( address spender, uint value ) public returns (bool ok);\n', '\n', '    event Transfer( address indexed from, address indexed to, uint value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/**\n', '    LOCKABLE TOKEN\n', '    @author DongOk Peter Ryu - <odin@yggdrash.io>\n', '*/\n', 'contract Lockable {\n', '    uint public creationTime;\n', '    bool public lock;\n', '    bool public tokenTransfer;\n', '    address public owner;\n', '    mapping( address => bool ) public unlockaddress;\n', '    // lockaddress List\n', '    mapping( address => bool ) public lockaddress;\n', '\n', '    // LOCK EVENT\n', '    event Locked(address lockaddress,bool status);\n', '    // UNLOCK EVENT\n', '    event Unlocked(address unlockedaddress, bool status);\n', '\n', '\n', '    // if Token transfer\n', '    modifier isTokenTransfer {\n', '        // if token transfer is not allow\n', '        if(!tokenTransfer) {\n', '            require(unlockaddress[msg.sender]);\n', '        }\n', '        _;\n', '    }\n', '\n', '    // This modifier check whether the contract should be in a locked\n', '    // or unlocked state, then acts and updates accordingly if\n', '    // necessary\n', '    modifier checkLock {\n', '        assert(!lockaddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier isOwner\n', '    {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function Lockable()\n', '    public\n', '    {\n', '        creationTime = now;\n', '        tokenTransfer = false;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Lock Address\n', '    function lockAddress(address target, bool status)\n', '    external\n', '    isOwner\n', '    {\n', '        require(owner != target);\n', '        lockaddress[target] = status;\n', '        Locked(target, status);\n', '    }\n', '\n', '    // UnLock Address\n', '    function unlockAddress(address target, bool status)\n', '    external\n', '    isOwner\n', '    {\n', '        unlockaddress[target] = status;\n', '        Unlocked(target, status);\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', '/**\n', '    YGGDRASH Token\n', '    @author DongOk Peter Ryu - <odin@yggdrash.io>\n', '*/\n', 'contract YeedToken is ERC20, Lockable {\n', '    using SafeMath for uint;\n', '\n', '    mapping( address => uint ) _balances;\n', '    mapping( address => mapping( address => uint ) ) _approvals;\n', '    uint _supply;\n', '    address public walletAddress;\n', '\n', '    event TokenBurned(address burnAddress, uint amountOfTokens);\n', '    event TokenTransfer();\n', '\n', '    modifier onlyFromWallet {\n', '        require(msg.sender != walletAddress);\n', '        _;\n', '    }\n', '\n', '    function YeedToken( uint initial_balance, address wallet)\n', '    public\n', '    {\n', '        require(wallet != 0);\n', '        require(initial_balance != 0);\n', '        _balances[msg.sender] = initial_balance;\n', '        _supply = initial_balance;\n', '        walletAddress = wallet;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint supply) {\n', '        return _supply;\n', '    }\n', '\n', '    function balanceOf( address who ) public constant returns (uint value) {\n', '        return _balances[who];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public constant returns (uint _allowance) {\n', '        return _approvals[owner][spender];\n', '    }\n', '\n', '    function transfer( address to, uint value)\n', '    public\n', '    isTokenTransfer\n', '    checkLock\n', '    returns (bool success) {\n', '\n', '        require( _balances[msg.sender] >= value );\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        Transfer( msg.sender, to, value );\n', '        return true;\n', '    }\n', '\n', '    function transferFrom( address from, address to, uint value)\n', '    public\n', '    isTokenTransfer\n', '    checkLock\n', '    returns (bool success) {\n', "        // if you don't have enough balance, throw\n", '        require( _balances[from] >= value );\n', "        // if you don't have approval, throw\n", '        require( _approvals[from][msg.sender] >= value );\n', '        // transfer and return true\n', '        _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        Transfer( from, to, value );\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint value)\n', '    public\n', '    checkLock\n', '    returns (bool success) {\n', '        _approvals[msg.sender][spender] = value;\n', '        Approval( msg.sender, spender, value );\n', '        return true;\n', '    }\n', '\n', '    // burnToken burn tokensAmount for sender balance\n', '    function burnTokens(uint tokensAmount)\n', '    public\n', '    isTokenTransfer\n', '    {\n', '        require( _balances[msg.sender] >= tokensAmount );\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);\n', '        _supply = _supply.sub(tokensAmount);\n', '        TokenBurned(msg.sender, tokensAmount);\n', '\n', '    }\n', '\n', '\n', '    function enableTokenTransfer()\n', '    external\n', '    onlyFromWallet\n', '    {\n', '        tokenTransfer = true;\n', '        TokenTransfer();\n', '    }\n', '\n', '    function disableTokenTransfer()\n', '    external\n', '    onlyFromWallet\n', '    {\n', '        tokenTransfer = false;\n', '        TokenTransfer();\n', '    }\n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '}']
