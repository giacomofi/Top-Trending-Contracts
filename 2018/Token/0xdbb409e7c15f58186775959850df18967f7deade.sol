['pragma solidity ^0.4.24;\n', '\n', '// ****************************************************************************\n', '//\n', '// Symbol          : BECC\n', '// Name            : Beechain Exchange Cross-chain Coin\n', '// Decimals        : 18\n', '// Total supply    : 500,000,000.000000000000000000\n', '// Initial release : 70 percent (350,000,000.000000000000000000)\n', '// Initial Locked  : 30 percent (150,000,000.000000000000000000)\n', '// Contract start  : 2018-08-15 00:00:00 (UTC timestamp: 1534233600)\n', '// Lock duration   : 180 days\n', '// Release rate    : 10 percent / 30 days (15,000,000.000000000000000000)\n', '// Release duration: 300 days.\n', '//\n', '// ****************************************************************************\n', '\n', '\n', '// ****************************************************************************\n', '// Safe math\n', '// ****************************************************************************\n', '\n', 'library SafeMath {\n', '    \n', '  function mul(uint _a, uint _b) internal pure returns (uint c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint _a, uint _b) internal pure returns (uint) {\n', '    return _a / _b;\n', '  }\n', '\n', '  function sub(uint _a, uint _b) internal pure returns (uint) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  function add(uint _a, uint _b) internal pure returns (uint c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// ****************************************************************************\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ****************************************************************************\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ****************************************************************************\n', '// Contract function to receive approval and execute function\n', '// ****************************************************************************\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint tokens, address token, bytes data) public;\n', '}\n', '\n', '// ****************************************************************************\n', '// Owned contract\n', '// ****************************************************************************\n', 'contract Owned {\n', '    \n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ****************************************************************************\n', '// BECC Token, with the addition of symbol, name and decimals and a fixed supply\n', '// ****************************************************************************\n', 'contract BECCToken is ERC20, Owned {\n', '    using SafeMath for uint;\n', '    \n', '    event Pause();\n', '    event Unpause();\n', '    event ReleasedTokens(uint tokens);\n', '    event AllocateTokens(address to, uint tokens);\n', '    \n', '    bool public paused = false;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    \n', '    uint private _totalSupply;              //total supply\n', '    uint private _initialRelease;           //initial release\n', '    uint private _locked;                   //locked tokens\n', '    uint private _released = 0;             //alloced tokens\n', '    uint private _allocated = 0;\n', '    uint private _startTime = 1534233600 + 180 days;    //release start time:2018-08-15 00:00:00(UTC) + 180 days\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    // ************************************************************************\n', '    // Modifier to make a function callable only when the contract is not paused.\n', '    // ************************************************************************\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Modifier to make a function callable only when the contract is paused.\n', '    // ************************************************************************\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '  \n', '    // ************************************************************************\n', '    // Constructor\n', '    // ************************************************************************\n', '    constructor() public {\n', '        symbol = "BECC";\n', '        name = "Beechain Exchange Cross-chain Coin";\n', '        decimals = 18;\n', '        _totalSupply = 500000000 * 10**uint(decimals);\n', '        _initialRelease = _totalSupply * 7 / 10;\n', '        _locked = _totalSupply * 3 / 10;\n', '        balances[owner] = _initialRelease;\n', '        emit Transfer(address(0), owner, _initialRelease);\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Total supply\n', '    // ************************************************************************\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Get the token balance for account `tokenOwner`\n', '    // ************************************************************************\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ************************************************************************\n', '    function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        require(address(0) != to && tokens <= balances[msg.sender] && 0 <= tokens);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    // ************************************************************************\n', '    function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {\n', '        require(address(0) != spender && 0 <= tokens);\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ************************************************************************\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ************************************************************************\n', '    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        require(address(0) != to && tokens <= balances[from] && tokens <= allowed[from][msg.sender] && 0 <= tokens);\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ************************************************************************\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ************************************************************************\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account. The `spender` contract function\n', '    // `receiveApproval(...)` is then executed\n', '    // ************************************************************************\n', '    function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Don&#39;t accept ETH\n', '    // ************************************************************************\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ************************************************************************\n', '    function transferERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    // ************************************************************************\n', '    // called by the owner to pause, triggers stopped state\n', '    // ************************************************************************\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    // ************************************************************************\n', '    // called by the owner to unpause, returns to normal state\n', '    // ************************************************************************\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '    \n', '    // ************************************************************************\n', '    // return free Tokens\n', '    // ************************************************************************\n', '    function freeBalance() public view returns (uint tokens) {\n', '        return _released.sub(_allocated);\n', '    }\n', '\n', '    // ************************************************************************\n', '    // return released Tokens\n', '    // ************************************************************************\n', '    function releasedBalance() public view returns (uint tokens) {\n', '        return _released;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // return allocated Tokens\n', '    // ************************************************************************\n', '    function allocatedBalance() public view returns (uint tokens) {\n', '        return _allocated;\n', '    }\n', '    \n', '    // ************************************************************************\n', '    // calculate released Tokens by the owner\n', '    // ************************************************************************\n', '    function calculateReleased() public onlyOwner returns (uint tokens) {\n', '        require(now > _startTime);\n', '        uint _monthDiff = (now.sub(_startTime)).div(30 days);\n', '\n', '        if (_monthDiff >= 10 ) {\n', '            _released = _locked;\n', '        } else {\n', '            _released = _monthDiff.mul(_locked.div(10));\n', '        }\n', '        emit ReleasedTokens(_released);\n', '        return _released;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // called by the owner to alloc the released tokens\n', '    // ************************************************************************     \n', '    function allocateTokens(address to, uint tokens) public onlyOwner returns (bool success){\n', '        require(address(0) != to && 0 <= tokens && tokens <= _released.sub(_allocated));\n', '        balances[to] = balances[to].add(tokens);\n', '        _allocated = _allocated.add(tokens);\n', '        emit AllocateTokens(to, tokens);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// ****************************************************************************\n', '//\n', '// Symbol          : BECC\n', '// Name            : Beechain Exchange Cross-chain Coin\n', '// Decimals        : 18\n', '// Total supply    : 500,000,000.000000000000000000\n', '// Initial release : 70 percent (350,000,000.000000000000000000)\n', '// Initial Locked  : 30 percent (150,000,000.000000000000000000)\n', '// Contract start  : 2018-08-15 00:00:00 (UTC timestamp: 1534233600)\n', '// Lock duration   : 180 days\n', '// Release rate    : 10 percent / 30 days (15,000,000.000000000000000000)\n', '// Release duration: 300 days.\n', '//\n', '// ****************************************************************************\n', '\n', '\n', '// ****************************************************************************\n', '// Safe math\n', '// ****************************************************************************\n', '\n', 'library SafeMath {\n', '    \n', '  function mul(uint _a, uint _b) internal pure returns (uint c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint _a, uint _b) internal pure returns (uint) {\n', '    return _a / _b;\n', '  }\n', '\n', '  function sub(uint _a, uint _b) internal pure returns (uint) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  function add(uint _a, uint _b) internal pure returns (uint c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// ****************************************************************************\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ****************************************************************************\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ****************************************************************************\n', '// Contract function to receive approval and execute function\n', '// ****************************************************************************\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint tokens, address token, bytes data) public;\n', '}\n', '\n', '// ****************************************************************************\n', '// Owned contract\n', '// ****************************************************************************\n', 'contract Owned {\n', '    \n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ****************************************************************************\n', '// BECC Token, with the addition of symbol, name and decimals and a fixed supply\n', '// ****************************************************************************\n', 'contract BECCToken is ERC20, Owned {\n', '    using SafeMath for uint;\n', '    \n', '    event Pause();\n', '    event Unpause();\n', '    event ReleasedTokens(uint tokens);\n', '    event AllocateTokens(address to, uint tokens);\n', '    \n', '    bool public paused = false;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    \n', '    uint private _totalSupply;              //total supply\n', '    uint private _initialRelease;           //initial release\n', '    uint private _locked;                   //locked tokens\n', '    uint private _released = 0;             //alloced tokens\n', '    uint private _allocated = 0;\n', '    uint private _startTime = 1534233600 + 180 days;    //release start time:2018-08-15 00:00:00(UTC) + 180 days\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    // ************************************************************************\n', '    // Modifier to make a function callable only when the contract is not paused.\n', '    // ************************************************************************\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Modifier to make a function callable only when the contract is paused.\n', '    // ************************************************************************\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '  \n', '    // ************************************************************************\n', '    // Constructor\n', '    // ************************************************************************\n', '    constructor() public {\n', '        symbol = "BECC";\n', '        name = "Beechain Exchange Cross-chain Coin";\n', '        decimals = 18;\n', '        _totalSupply = 500000000 * 10**uint(decimals);\n', '        _initialRelease = _totalSupply * 7 / 10;\n', '        _locked = _totalSupply * 3 / 10;\n', '        balances[owner] = _initialRelease;\n', '        emit Transfer(address(0), owner, _initialRelease);\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Total supply\n', '    // ************************************************************************\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Get the token balance for account `tokenOwner`\n', '    // ************************************************************************\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ************************************************************************\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ************************************************************************\n', '    function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        require(address(0) != to && tokens <= balances[msg.sender] && 0 <= tokens);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    // ************************************************************************\n', '    function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {\n', '        require(address(0) != spender && 0 <= tokens);\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ************************************************************************\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ************************************************************************\n', '    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        require(address(0) != to && tokens <= balances[from] && tokens <= allowed[from][msg.sender] && 0 <= tokens);\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ************************************************************************\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ************************************************************************\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ************************************************************************\n', '    function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ************************************************************************\n', "    // Don't accept ETH\n", '    // ************************************************************************\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    // ************************************************************************\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ************************************************************************\n', '    function transferERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    // ************************************************************************\n', '    // called by the owner to pause, triggers stopped state\n', '    // ************************************************************************\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    // ************************************************************************\n', '    // called by the owner to unpause, returns to normal state\n', '    // ************************************************************************\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '    \n', '    // ************************************************************************\n', '    // return free Tokens\n', '    // ************************************************************************\n', '    function freeBalance() public view returns (uint tokens) {\n', '        return _released.sub(_allocated);\n', '    }\n', '\n', '    // ************************************************************************\n', '    // return released Tokens\n', '    // ************************************************************************\n', '    function releasedBalance() public view returns (uint tokens) {\n', '        return _released;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // return allocated Tokens\n', '    // ************************************************************************\n', '    function allocatedBalance() public view returns (uint tokens) {\n', '        return _allocated;\n', '    }\n', '    \n', '    // ************************************************************************\n', '    // calculate released Tokens by the owner\n', '    // ************************************************************************\n', '    function calculateReleased() public onlyOwner returns (uint tokens) {\n', '        require(now > _startTime);\n', '        uint _monthDiff = (now.sub(_startTime)).div(30 days);\n', '\n', '        if (_monthDiff >= 10 ) {\n', '            _released = _locked;\n', '        } else {\n', '            _released = _monthDiff.mul(_locked.div(10));\n', '        }\n', '        emit ReleasedTokens(_released);\n', '        return _released;\n', '    }\n', '\n', '    // ************************************************************************\n', '    // called by the owner to alloc the released tokens\n', '    // ************************************************************************     \n', '    function allocateTokens(address to, uint tokens) public onlyOwner returns (bool success){\n', '        require(address(0) != to && 0 <= tokens && tokens <= _released.sub(_allocated));\n', '        balances[to] = balances[to].add(tokens);\n', '        _allocated = _allocated.add(tokens);\n', '        emit AllocateTokens(to, tokens);\n', '        return true;\n', '    }\n', '}']
