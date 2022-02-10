['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '// &#39;VRF&#39; &#39;0xVerify&#39; token contract\n', '//\n', '// Symbol      : VRF\n', '// Name        : 0xVerify\n', '// Decimals    : 18\n', '//\n', '// A faucet distributed token, powered by ethverify.net\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event TokensClaimed(address indexed to, uint tokens);\n', '}\n', '\n', 'contract EthVerifyCore{\n', '    mapping (address => bool) public verifiedUsers;\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// 0xVRF ERC20 Token\n', '// ----------------------------------------------------------------------------\n', 'contract VerifyToken is ERC20Interface {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public dailyDistribution;\n', '    uint public timestep;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    mapping(address => uint) public lastClaimed;\n', '    uint public claimedYesterday;\n', '    uint public claimedToday;\n', '    uint public dayStartTime;\n', '    bool public activated=false;\n', '    address public creator;\n', '\n', '    EthVerifyCore public ethVerify=EthVerifyCore(0x1Ea6fAd76886fE0C0BF8eBb3F51678B33D24186c);//0x286A090b31462890cD9Bf9f167b610Ed8AA8bD1a);\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        timestep=24 hours;//10 minutes;//24 hours;\n', '        symbol = "VRF";\n', '        name = "0xVerify";\n', '        decimals = 18;\n', '        dailyDistribution=10000000 * 10**uint(decimals);\n', '        claimedYesterday=20;\n', '        claimedToday=0;\n', '        dayStartTime=now;\n', '        _totalSupply=140000000 * 10**uint(decimals);\n', '        balances[msg.sender] = _totalSupply;\n', '        creator=msg.sender;\n', '    }\n', '    function activate(){\n', '      require(!activated);\n', '      require(msg.sender==creator);\n', '      dayStartTime=now-1 minutes;\n', '      activated=true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Claim VRF tokens daily, requires an Eth Verify account\n', '    // ------------------------------------------------------------------------\n', '    function claimTokens() public{\n', '        require(activated);\n', '        //progress the day if needed\n', '        if(dayStartTime<now.sub(timestep)){\n', '            uint daysPassed=(now.sub(dayStartTime)).div(timestep);\n', '            dayStartTime=dayStartTime.add(daysPassed.mul(timestep));\n', '            claimedYesterday=claimedToday > 1 ? claimedToday : 1; //make 1 the minimum to avoid divide by zero\n', '            claimedToday=0;\n', '        }\n', '\n', '        //requires each account to be verified with eth verify\n', '        require(ethVerify.verifiedUsers(msg.sender));\n', '\n', '        //only allows each account to claim tokens once per day\n', '        require(lastClaimed[msg.sender] <= dayStartTime);\n', '        lastClaimed[msg.sender]=now;\n', '\n', '        //distribute tokens based on the amount distributed the previous day; the goal is to shoot for an average equal to dailyDistribution.\n', '        claimedToday=claimedToday.add(1);\n', '        balances[msg.sender]=balances[msg.sender].add(dailyDistribution.div(claimedYesterday));\n', '        _totalSupply=_totalSupply.add(dailyDistribution.div(claimedYesterday));\n', '        emit TokensClaimed(msg.sender,dailyDistribution.div(claimedYesterday));\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account. The `spender` contract function\n', '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'VRF' '0xVerify' token contract\n", '//\n', '// Symbol      : VRF\n', '// Name        : 0xVerify\n', '// Decimals    : 18\n', '//\n', '// A faucet distributed token, powered by ethverify.net\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event TokensClaimed(address indexed to, uint tokens);\n', '}\n', '\n', 'contract EthVerifyCore{\n', '    mapping (address => bool) public verifiedUsers;\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// 0xVRF ERC20 Token\n', '// ----------------------------------------------------------------------------\n', 'contract VerifyToken is ERC20Interface {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public dailyDistribution;\n', '    uint public timestep;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    mapping(address => uint) public lastClaimed;\n', '    uint public claimedYesterday;\n', '    uint public claimedToday;\n', '    uint public dayStartTime;\n', '    bool public activated=false;\n', '    address public creator;\n', '\n', '    EthVerifyCore public ethVerify=EthVerifyCore(0x1Ea6fAd76886fE0C0BF8eBb3F51678B33D24186c);//0x286A090b31462890cD9Bf9f167b610Ed8AA8bD1a);\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        timestep=24 hours;//10 minutes;//24 hours;\n', '        symbol = "VRF";\n', '        name = "0xVerify";\n', '        decimals = 18;\n', '        dailyDistribution=10000000 * 10**uint(decimals);\n', '        claimedYesterday=20;\n', '        claimedToday=0;\n', '        dayStartTime=now;\n', '        _totalSupply=140000000 * 10**uint(decimals);\n', '        balances[msg.sender] = _totalSupply;\n', '        creator=msg.sender;\n', '    }\n', '    function activate(){\n', '      require(!activated);\n', '      require(msg.sender==creator);\n', '      dayStartTime=now-1 minutes;\n', '      activated=true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Claim VRF tokens daily, requires an Eth Verify account\n', '    // ------------------------------------------------------------------------\n', '    function claimTokens() public{\n', '        require(activated);\n', '        //progress the day if needed\n', '        if(dayStartTime<now.sub(timestep)){\n', '            uint daysPassed=(now.sub(dayStartTime)).div(timestep);\n', '            dayStartTime=dayStartTime.add(daysPassed.mul(timestep));\n', '            claimedYesterday=claimedToday > 1 ? claimedToday : 1; //make 1 the minimum to avoid divide by zero\n', '            claimedToday=0;\n', '        }\n', '\n', '        //requires each account to be verified with eth verify\n', '        require(ethVerify.verifiedUsers(msg.sender));\n', '\n', '        //only allows each account to claim tokens once per day\n', '        require(lastClaimed[msg.sender] <= dayStartTime);\n', '        lastClaimed[msg.sender]=now;\n', '\n', '        //distribute tokens based on the amount distributed the previous day; the goal is to shoot for an average equal to dailyDistribution.\n', '        claimedToday=claimedToday.add(1);\n', '        balances[msg.sender]=balances[msg.sender].add(dailyDistribution.div(claimedYesterday));\n', '        _totalSupply=_totalSupply.add(dailyDistribution.div(claimedYesterday));\n', '        emit TokensClaimed(msg.sender,dailyDistribution.div(claimedYesterday));\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}']
