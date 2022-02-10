['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Centaure\n', '// ----------------------------------------------------------------------------\n', 'contract Centaure is ERC20Interface, Owned, SafeMath {\n', '    string public  name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public _tokens;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '  \tstruct TokenLock { uint8 id; uint start; uint256 totalAmount;  uint256 amountWithDrawn; uint duration; uint8 withdrawSteps; }\n', '\n', '    TokenLock public futureDevLock = TokenLock({\n', '        id: 1,\n', '        start: now,\n', '        totalAmount: 7500000000000000000000000,\n', '        amountWithDrawn: 0,\n', '        duration: 180 days,\n', '        withdrawSteps: 3\n', '    });\n', '\n', '    TokenLock public advisorsLock = TokenLock({\n', '        id: 2,\n', '        start: now,\n', '        totalAmount: 2500000000000000000000000,\n', '        amountWithDrawn: 0,\n', '        duration: 180 days,\n', '        withdrawSteps: 1\n', '    });\n', '\n', '    TokenLock public teamLock = TokenLock({\n', '        id: 3,\n', '        start: now,\n', '        totalAmount: 6000000000000000000000000,\n', '        amountWithDrawn: 0,\n', '        duration: 180 days,\n', '        withdrawSteps: 6\n', '    });\n', '\n', '    function Centaure() public {\n', '        symbol = "CEN";\n', '        name = "Centaure Token";\n', '        decimals = 18;\n', '\n', '        _totalSupply = 50000000* 10**uint(decimals);\n', '\n', '        balances[owner] = _totalSupply;\n', '        Transfer(address(0), owner, _totalSupply);\n', '\n', '        lockTokens(futureDevLock);\n', '        lockTokens(advisorsLock);\n', '        lockTokens(teamLock);\n', '    }\n', '\n', '    function lockTokens(TokenLock lock) internal {\n', '        balances[owner] = safeSub(balances[owner], lock.totalAmount);\n', '        balances[address(0)] = safeAdd(balances[address(0)], lock.totalAmount);\n', '        Transfer(owner, address(0), lock.totalAmount);\n', '    }\n', '\n', '    function withdrawLockedTokens() external onlyOwner {\n', '        if(unlockTokens(futureDevLock)){\n', '          futureDevLock.start = now;\n', '        }\n', '        if(unlockTokens(advisorsLock)){\n', '          advisorsLock.start = now;\n', '        }\n', '        if(unlockTokens(teamLock)){\n', '          teamLock.start = now;\n', '        }\n', '    }\n', '\n', '\tfunction unlockTokens(TokenLock lock) internal returns (bool) {\n', '        uint lockReleaseTime = lock.start + lock.duration;\n', '\n', '        if(lockReleaseTime < now && lock.amountWithDrawn < lock.totalAmount) {\n', '            if(lock.withdrawSteps > 1){\n', '                _tokens = safeDiv(lock.totalAmount, lock.withdrawSteps);\n', '            }else{\n', '                _tokens = safeSub(lock.totalAmount, lock.amountWithDrawn);\n', '            }\n', '\n', '            balances[owner] = safeAdd(balances[owner], _tokens);\n', '            balances[address(0)] = safeSub(balances[address(0)], _tokens);\n', '            Transfer(address(0), owner, _tokens);\n', '\n', '            if(lock.id==1 && lock.amountWithDrawn < lock.totalAmount){\n', '              futureDevLock.amountWithDrawn = safeAdd(futureDevLock.amountWithDrawn, _tokens);\n', '            }\n', '            if(lock.id==2 && lock.amountWithDrawn < lock.totalAmount){\n', '              advisorsLock.amountWithDrawn = safeAdd(advisorsLock.amountWithDrawn, _tokens);\n', '            }\n', '            if(lock.id==3 && lock.amountWithDrawn < lock.totalAmount) {\n', '              teamLock.amountWithDrawn = safeAdd(teamLock.amountWithDrawn, _tokens);\n', '              teamLock.withdrawSteps = 1;\n', '            }\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account tokenOwner\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to to account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer tokens from the from account to the to account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the from account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', '    // from the token owner&#39;s account. The spender contract function\n', '    // receiveApproval(...) is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Don&#39;t accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Centaure\n', '// ----------------------------------------------------------------------------\n', 'contract Centaure is ERC20Interface, Owned, SafeMath {\n', '    string public  name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public _tokens;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '  \tstruct TokenLock { uint8 id; uint start; uint256 totalAmount;  uint256 amountWithDrawn; uint duration; uint8 withdrawSteps; }\n', '\n', '    TokenLock public futureDevLock = TokenLock({\n', '        id: 1,\n', '        start: now,\n', '        totalAmount: 7500000000000000000000000,\n', '        amountWithDrawn: 0,\n', '        duration: 180 days,\n', '        withdrawSteps: 3\n', '    });\n', '\n', '    TokenLock public advisorsLock = TokenLock({\n', '        id: 2,\n', '        start: now,\n', '        totalAmount: 2500000000000000000000000,\n', '        amountWithDrawn: 0,\n', '        duration: 180 days,\n', '        withdrawSteps: 1\n', '    });\n', '\n', '    TokenLock public teamLock = TokenLock({\n', '        id: 3,\n', '        start: now,\n', '        totalAmount: 6000000000000000000000000,\n', '        amountWithDrawn: 0,\n', '        duration: 180 days,\n', '        withdrawSteps: 6\n', '    });\n', '\n', '    function Centaure() public {\n', '        symbol = "CEN";\n', '        name = "Centaure Token";\n', '        decimals = 18;\n', '\n', '        _totalSupply = 50000000* 10**uint(decimals);\n', '\n', '        balances[owner] = _totalSupply;\n', '        Transfer(address(0), owner, _totalSupply);\n', '\n', '        lockTokens(futureDevLock);\n', '        lockTokens(advisorsLock);\n', '        lockTokens(teamLock);\n', '    }\n', '\n', '    function lockTokens(TokenLock lock) internal {\n', '        balances[owner] = safeSub(balances[owner], lock.totalAmount);\n', '        balances[address(0)] = safeAdd(balances[address(0)], lock.totalAmount);\n', '        Transfer(owner, address(0), lock.totalAmount);\n', '    }\n', '\n', '    function withdrawLockedTokens() external onlyOwner {\n', '        if(unlockTokens(futureDevLock)){\n', '          futureDevLock.start = now;\n', '        }\n', '        if(unlockTokens(advisorsLock)){\n', '          advisorsLock.start = now;\n', '        }\n', '        if(unlockTokens(teamLock)){\n', '          teamLock.start = now;\n', '        }\n', '    }\n', '\n', '\tfunction unlockTokens(TokenLock lock) internal returns (bool) {\n', '        uint lockReleaseTime = lock.start + lock.duration;\n', '\n', '        if(lockReleaseTime < now && lock.amountWithDrawn < lock.totalAmount) {\n', '            if(lock.withdrawSteps > 1){\n', '                _tokens = safeDiv(lock.totalAmount, lock.withdrawSteps);\n', '            }else{\n', '                _tokens = safeSub(lock.totalAmount, lock.amountWithDrawn);\n', '            }\n', '\n', '            balances[owner] = safeAdd(balances[owner], _tokens);\n', '            balances[address(0)] = safeSub(balances[address(0)], _tokens);\n', '            Transfer(address(0), owner, _tokens);\n', '\n', '            if(lock.id==1 && lock.amountWithDrawn < lock.totalAmount){\n', '              futureDevLock.amountWithDrawn = safeAdd(futureDevLock.amountWithDrawn, _tokens);\n', '            }\n', '            if(lock.id==2 && lock.amountWithDrawn < lock.totalAmount){\n', '              advisorsLock.amountWithDrawn = safeAdd(advisorsLock.amountWithDrawn, _tokens);\n', '            }\n', '            if(lock.id==3 && lock.amountWithDrawn < lock.totalAmount) {\n', '              teamLock.amountWithDrawn = safeAdd(teamLock.amountWithDrawn, _tokens);\n', '              teamLock.withdrawSteps = 1;\n', '            }\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account tokenOwner\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to to account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer tokens from the from account to the to account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the from account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account. The spender contract function\n", '    // receiveApproval(...) is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
