['pragma solidity ^0.4.24;\n', '\n', 'contract TCOMDividend {\n', '\n', '    string public name = "TCOM Dividend";\n', '    string public symbol = "TCOMD";\n', '\n', '    // This code assumes decimals is zero\n', '    uint8 public decimals = 0;\n', '\n', '    uint256 public totalSupply = 10000 * (uint256(10) ** decimals);\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    constructor() public {\n', "        // Initially assign all tokens to the contract's creator.\n", '        balanceOf[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '\n', '    mapping(address => uint256) public dividendBalanceOf;\n', '\n', '    uint256 public dividendPerToken;\n', '\n', '    mapping(address => uint256) public dividendCreditedTo;\n', '\n', '    function update(address account) internal {\n', '        uint256 owed =\n', '        dividendPerToken - dividendCreditedTo[account];\n', '        dividendBalanceOf[account] += balanceOf[account] * owed;\n', '        dividendCreditedTo[account] = dividendPerToken;\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    function () public payable {\n', '        dividendPerToken += msg.value / totalSupply;  // ignoring remainder\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= value);\n', '\n', '        update(msg.sender);  // <-- added to simple ERC20 contract\n', '        update(to);          // <-- added to simple ERC20 contract\n', '\n', '        balanceOf[msg.sender] -= value;\n', '        balanceOf[to] += value;\n', '\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(value <= balanceOf[from]);\n', '        require(value <= allowance[from][msg.sender]);\n', '\n', '        update(from);        // <-- added to simple ERC20 contract\n', '        update(to);          // <-- added to simple ERC20 contract\n', '\n', '        balanceOf[from] -= value;\n', '        balanceOf[to] += value;\n', '        allowance[from][msg.sender] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function withdraw() public {\n', '        update(msg.sender);\n', '        uint256 amount = dividendBalanceOf[msg.sender];\n', '        dividendBalanceOf[msg.sender] = 0;\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '    function approve(address spender, uint256 value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '}']