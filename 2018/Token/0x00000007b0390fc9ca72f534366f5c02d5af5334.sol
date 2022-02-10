['pragma solidity 0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '// FOTON token main contract\n', '//\n', '// Symbol       : FTN\n', '// Name         : FOTON\n', '// Total supply : 3.000.000.000,000000000000000000 (burnable)\n', '// Decimals     : 18\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Funds(address indexed from, uint coins);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    \n', '    mapping(address => bool) public isBenefeciary;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        isBenefeciary[0x00000007A394B99baFfd858Ce77a56CA11e93757] = true;\n', '        isBenefeciary[0xA0aE338E9FC22DE613CEC2d79477877f02751ceb] = true;\n', '        isBenefeciary[0x721Ea19D5E96eEB25c6e847F3209f3ca82B41CC9] = true;\n', '    }\n', '    \n', '    modifier onlyBenefeciary {\n', '        require(isBenefeciary[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract FTN is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    bool public running = true;\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '    uint public contractBalance;\n', '    address ben3 = 0x2f22dC7eA406B14EC368C2d4875946ADFd02450e;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    uint public reqTime;\n', '    uint public reqAmount;\n', '    address public reqAddress;\n', '    address public reqTo;\n', '\n', '    constructor() public {\n', '        symbol = "FTN";\n', '        name = "FOTON";\n', '        decimals = 18;\n', '        _totalSupply = 3000000000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    modifier isRunnning {\n', '        require(running);\n', '        _;\n', '    }\n', '    \n', '    function () payable public {\n', '        emit Funds(msg.sender, msg.value);\n', '        ben3.transfer(msg.value.mul(3).div(100));\n', '        contractBalance = address(this).balance;\n', '    }\n', '\n', '    function startStop () public onlyOwner returns (bool success) {\n', '        if (running) { running = false; } else { running = true; }\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public isRunnning returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        require(tokens != 0);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public isRunnning returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public isRunnning returns (bool success) {\n', '        require(tokens <= balances[from]);\n', '        require(tokens <= allowed[from][msg.sender]);\n', '        require(tokens != 0);\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public isRunnning returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    function burnTokens(uint256 tokens) public returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        require(tokens != 0);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        _totalSupply = _totalSupply.sub(tokens);\n', '        emit Transfer(msg.sender, address(0), tokens);\n', '        return true;\n', '    }    \n', '\n', '    function multisend(address[] to, uint256[] values) public onlyOwner returns (uint256) {\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            balances[owner] = balances[owner].sub(values[i]);\n', '            balances[to[i]] = balances[to[i]].add(values[i]);\n', '            emit Transfer(owner, to[i], values[i]);\n', '        }\n', '        return(i);\n', '    }\n', '    \n', '    function multiSigWithdrawal(address to, uint amount) public onlyBenefeciary returns (bool success) {\n', '        if (reqTime == 0 && reqAmount == 0) {\n', '        reqTime = now.add(3600);\n', '        reqAmount = amount;\n', '        reqAddress = msg.sender;\n', '        reqTo = to;\n', '        } else {\n', '            if (msg.sender != reqAddress && to == reqTo && amount == reqAmount && now < reqTime) {\n', '                to.transfer(amount);\n', '            }\n', '            reqTime = 0;\n', '            reqAmount = 0;\n', '            reqAddress = address(0);\n', '            reqTo = address(0);\n', '        }\n', '        return true;\n', '    }\n', '}']
['pragma solidity 0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '// FOTON token main contract\n', '//\n', '// Symbol       : FTN\n', '// Name         : FOTON\n', '// Total supply : 3.000.000.000,000000000000000000 (burnable)\n', '// Decimals     : 18\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Funds(address indexed from, uint coins);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    \n', '    mapping(address => bool) public isBenefeciary;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        isBenefeciary[0x00000007A394B99baFfd858Ce77a56CA11e93757] = true;\n', '        isBenefeciary[0xA0aE338E9FC22DE613CEC2d79477877f02751ceb] = true;\n', '        isBenefeciary[0x721Ea19D5E96eEB25c6e847F3209f3ca82B41CC9] = true;\n', '    }\n', '    \n', '    modifier onlyBenefeciary {\n', '        require(isBenefeciary[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract FTN is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    bool public running = true;\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '    uint public contractBalance;\n', '    address ben3 = 0x2f22dC7eA406B14EC368C2d4875946ADFd02450e;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    uint public reqTime;\n', '    uint public reqAmount;\n', '    address public reqAddress;\n', '    address public reqTo;\n', '\n', '    constructor() public {\n', '        symbol = "FTN";\n', '        name = "FOTON";\n', '        decimals = 18;\n', '        _totalSupply = 3000000000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    modifier isRunnning {\n', '        require(running);\n', '        _;\n', '    }\n', '    \n', '    function () payable public {\n', '        emit Funds(msg.sender, msg.value);\n', '        ben3.transfer(msg.value.mul(3).div(100));\n', '        contractBalance = address(this).balance;\n', '    }\n', '\n', '    function startStop () public onlyOwner returns (bool success) {\n', '        if (running) { running = false; } else { running = true; }\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public isRunnning returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        require(tokens != 0);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public isRunnning returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public isRunnning returns (bool success) {\n', '        require(tokens <= balances[from]);\n', '        require(tokens <= allowed[from][msg.sender]);\n', '        require(tokens != 0);\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public isRunnning returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    function burnTokens(uint256 tokens) public returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        require(tokens != 0);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        _totalSupply = _totalSupply.sub(tokens);\n', '        emit Transfer(msg.sender, address(0), tokens);\n', '        return true;\n', '    }    \n', '\n', '    function multisend(address[] to, uint256[] values) public onlyOwner returns (uint256) {\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            balances[owner] = balances[owner].sub(values[i]);\n', '            balances[to[i]] = balances[to[i]].add(values[i]);\n', '            emit Transfer(owner, to[i], values[i]);\n', '        }\n', '        return(i);\n', '    }\n', '    \n', '    function multiSigWithdrawal(address to, uint amount) public onlyBenefeciary returns (bool success) {\n', '        if (reqTime == 0 && reqAmount == 0) {\n', '        reqTime = now.add(3600);\n', '        reqAmount = amount;\n', '        reqAddress = msg.sender;\n', '        reqTo = to;\n', '        } else {\n', '            if (msg.sender != reqAddress && to == reqTo && amount == reqAmount && now < reqTime) {\n', '                to.transfer(amount);\n', '            }\n', '            reqTime = 0;\n', '            reqAmount = 0;\n', '            reqAddress = address(0);\n', '            reqTo = address(0);\n', '        }\n', '        return true;\n', '    }\n', '}']