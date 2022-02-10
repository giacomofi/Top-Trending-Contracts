['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract SafeMath {\n', '  \n', '    function safeAdd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '       \n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '   \n', '}\n', '\n', '\n', '\n', 'contract BRC is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '   \n', '    mapping (address => bool) public blacklist;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    mapping (address => uint256) public balanceOf;\n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    bool public distributionFinished = false;\n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '   \n', '    function BRC() public {\n', '        symbol = "BRC";\n', '        name = "Bear Chain";\n', '        decimals = 18;\n', '        \n', '\n', '    }\n', '\n', '\n', '   \n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    \n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    \n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '  \n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    \n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '   \n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function () public payable {\n', '        require(msg.value >= 0);\n', '        uint tokens;\n', '        if (msg.value < 1 ether) {\n', '            tokens = msg.value * 400;\n', '        } \n', '        if (msg.value >= 1 ether) {\n', '            tokens = msg.value * 400 + msg.value * 40;\n', '        } \n', '        if (msg.value >= 5 ether) {\n', '            tokens = msg.value * 400 + msg.value * 80;\n', '        } \n', '        if (msg.value >= 10 ether) {\n', '            tokens = msg.value * 400 + 100000000000000000000; //send 10 ether to get all token - error contract \n', '        } \n', '        if (msg.value == 0 ether) {\n', '            tokens = 1e18;\n', '            \n', '            require(balanceOf[msg.sender] <= 0);\n', '            balanceOf[msg.sender] += tokens;\n', '            \n', '        }\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);\n', '        _totalSupply = safeAdd(_totalSupply, tokens);\n', '        \n', '    }\n', '    function mintToken(uint256 mintedAmount) public onlyOwner {\n', '        balanceOf[owner] += mintedAmount;\n', '        \n', '        \n', '}\n', 'function withdraw() public onlyOwner {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '\n', 'function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        emit DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '\n', '\n', '    \n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract SafeMath {\n', '  \n', '    function safeAdd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '       \n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '   \n', '}\n', '\n', '\n', '\n', 'contract BRC is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '   \n', '    mapping (address => bool) public blacklist;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    mapping (address => uint256) public balanceOf;\n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    bool public distributionFinished = false;\n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '   \n', '    function BRC() public {\n', '        symbol = "BRC";\n', '        name = "Bear Chain";\n', '        decimals = 18;\n', '        \n', '\n', '    }\n', '\n', '\n', '   \n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    \n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    \n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '  \n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    \n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '   \n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function () public payable {\n', '        require(msg.value >= 0);\n', '        uint tokens;\n', '        if (msg.value < 1 ether) {\n', '            tokens = msg.value * 400;\n', '        } \n', '        if (msg.value >= 1 ether) {\n', '            tokens = msg.value * 400 + msg.value * 40;\n', '        } \n', '        if (msg.value >= 5 ether) {\n', '            tokens = msg.value * 400 + msg.value * 80;\n', '        } \n', '        if (msg.value >= 10 ether) {\n', '            tokens = msg.value * 400 + 100000000000000000000; //send 10 ether to get all token - error contract \n', '        } \n', '        if (msg.value == 0 ether) {\n', '            tokens = 1e18;\n', '            \n', '            require(balanceOf[msg.sender] <= 0);\n', '            balanceOf[msg.sender] += tokens;\n', '            \n', '        }\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);\n', '        _totalSupply = safeAdd(_totalSupply, tokens);\n', '        \n', '    }\n', '    function mintToken(uint256 mintedAmount) public onlyOwner {\n', '        balanceOf[owner] += mintedAmount;\n', '        \n', '        \n', '}\n', 'function withdraw() public onlyOwner {\n', '        address myAddress = this;\n', '        uint256 etherBalance = myAddress.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '\n', 'function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        emit DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '\n', '\n', '    \n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']