['pragma solidity ^0.5.1;\n', '\n', 'contract SC {\n', '    address public owner;\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals = 10;\n', '    uint tokenSupply = 0;\n', '    bool public paused = false;\n', '    uint[7] milestones = [200000000000000000,700000000000000000,1300000000000000000,1600000000000000000,1800000000000000000,1900000000000000000,2000000000000000000];\n', '    uint[7] conversion = [8125000,5078100,1103800,380800,114600,31300,15600];\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    modifier notPaused {\n', '        require(paused == false);\n', '        _;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Pause();\n', '    event UnPause();\n', '    event Burn(uint amount);\n', '    event Mint(uint amount);\n', '\n', '    constructor(string memory _name) public {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = 0;\n', '        symbol = _name;\n', '        name = _name;\n', '\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '\n', '    function burn(uint amount) public onlyOwner {\n', '        if (balances[owner] < amount) revert();\n', '        balances[owner] = safeSub(balances[owner], amount);\n', '        tokenSupply = safeSub(tokenSupply, amount);\n', '        emit Burn(amount);\n', '    }\n', '\n', '    function mintFromTraded(uint tradedAmount) public onlyOwner returns (uint minted) {\n', '        uint toMint = 0;\n', '        uint ts = tokenSupply;\n', '\n', '        for (uint8 ml = 0; ml <= 6; ml++) {\n', '            if (ts >= milestones[ml]) {\n', '                continue;\n', '            }\n', '            if (ts + tradedAmount * conversion[ml] < milestones[ml]) {\n', '                toMint += tradedAmount * conversion[ml];\n', '                ts += tradedAmount * conversion[ml];\n', '                tradedAmount = 0;\n', '                break;\n', '            }\n', '            uint diff = (milestones[ml] - ts) / conversion[ml];\n', '            tradedAmount -= diff;\n', '            toMint += milestones[ml] - ts;\n', '            ts = milestones[ml];\n', '        }\n', '        if (tradedAmount > 0) {\n', '            toMint += tradedAmount * conversion[6];\n', '            ts += tradedAmount * conversion[6];\n', '        }\n', '\n', '        tokenSupply = ts;\n', '        balances[owner] = safeAdd(balances[owner], toMint);\n', '        emit Mint(toMint);\n', '\n', '        return toMint;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return tokenSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function transfer(address to, uint tokens) public notPaused returns (bool success) {\n', '        if (tokens <= 0) revert();\n', '        if (to == address(0)) revert();\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public notPaused returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public notPaused returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function etherBalance() public view onlyOwner returns (uint balance) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function sendEther(uint amount, address payable to) public onlyOwner {\n', '        to.transfer(amount);\n', '    }\n', '\n', '    function pause() public notPaused onlyOwner {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unPause() public onlyOwner {\n', '        if (paused == false) revert();\n', '        paused = false;\n', '        emit UnPause();\n', '    }\n', '\n', '    function() external payable {}\n', '}']