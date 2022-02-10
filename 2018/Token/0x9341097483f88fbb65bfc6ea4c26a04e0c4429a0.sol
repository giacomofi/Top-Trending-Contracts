['//Local address 0xe0000ac3ced53435ae92789ad5d8157d0293da9f\n', 'pragma solidity 0.4.23;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns(uint amount);\n', '    function balanceOf(address tokenOwner) public view returns(uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining);\n', '    function transfer(address to, uint tokens) public returns(bool status);\n', '    function approve(address spender, uint limit) public returns(bool status);\n', '    function transferFrom(address from, address to, uint amount) public returns(bool status);\n', '    function name() public view returns(string tokenName);\n', '    function symbol() public view returns(string tokenSymbol);\n', '\n', '    event Transfer(address from, address to, uint amount);\n', '    event Approval(address tokenOwner, address spender, uint amount);\n', '}\n', '\n', 'contract Owned {\n', '    address contractOwner;\n', '\n', '    constructor() public { \n', '        contractOwner = msg.sender; \n', '    }\n', '    \n', '    function whoIsTheOwner() public view returns(address) {\n', '        return contractOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract Mortal is Owned  {\n', '    function kill() public {\n', '        if (msg.sender == contractOwner) selfdestruct(contractOwner);\n', '    }\n', '}\n', '\n', 'contract CoquinhoERC20 is ERC20Interface, Mortal {\n', '    string private myName;\n', '    string private mySymbol;\n', '    uint private myTotalSupply;\n', '    uint8 public decimals;\n', '\n', '    mapping (address=>uint) balances;\n', '    mapping (address=>mapping (address=>uint)) ownerAllowances;\n', '\n', '    constructor() public {\n', '        myName = "Coquinho Coin";\n', '        mySymbol = "CQNC";\n', '        myTotalSupply = 1000000;\n', '        decimals = 0;\n', '        balances[msg.sender] = myTotalSupply;\n', '    }\n', '\n', '    function name() public view returns(string tokenName) {\n', '        return myName;\n', '    }\n', '\n', '    function symbol() public view returns(string tokenSymbol) {\n', '        return mySymbol;\n', '    }\n', '\n', '    function totalSupply() public view returns(uint amount) {\n', '        return myTotalSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns(uint balance) {\n', '        require(tokenOwner != address(0));\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining) {\n', '        return ownerAllowances[tokenOwner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint amount) public hasEnoughBalance(msg.sender, amount) tokenAmountValid(amount) returns(bool status) {\n', '        balances[msg.sender] -= amount;\n', '        balances[to] += amount;\n', '        emit Transfer(msg.sender, to, amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint limit) public returns(bool status) {\n', '        ownerAllowances[msg.sender][spender] = limit;\n', '        emit Approval(msg.sender, spender, limit);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint amount) public \n', '    hasEnoughBalance(from, amount) isAllowed(msg.sender, from, amount) tokenAmountValid(amount)\n', '    returns(bool status) {\n', '        balances[from] -= amount;\n', '        balances[to] += amount;\n', '        ownerAllowances[from][msg.sender] = amount;\n', '        emit Transfer(from, to, amount);\n', '        return true;\n', '    }\n', '\n', '    modifier hasEnoughBalance(address owner, uint amount) {\n', '        uint balance;\n', '        balance = balances[owner];\n', '        require (balance >= amount); \n', '        _;\n', '    }\n', '\n', '    modifier isAllowed(address spender, address tokenOwner, uint amount) {\n', '        require (amount <= ownerAllowances[tokenOwner][spender]);\n', '        _;\n', '    }\n', '\n', '    modifier tokenAmountValid(uint amount) {\n', '        require(amount > 0);\n', '        _;\n', '    }\n', '\n', '}']
['//Local address 0xe0000ac3ced53435ae92789ad5d8157d0293da9f\n', 'pragma solidity 0.4.23;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns(uint amount);\n', '    function balanceOf(address tokenOwner) public view returns(uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining);\n', '    function transfer(address to, uint tokens) public returns(bool status);\n', '    function approve(address spender, uint limit) public returns(bool status);\n', '    function transferFrom(address from, address to, uint amount) public returns(bool status);\n', '    function name() public view returns(string tokenName);\n', '    function symbol() public view returns(string tokenSymbol);\n', '\n', '    event Transfer(address from, address to, uint amount);\n', '    event Approval(address tokenOwner, address spender, uint amount);\n', '}\n', '\n', 'contract Owned {\n', '    address contractOwner;\n', '\n', '    constructor() public { \n', '        contractOwner = msg.sender; \n', '    }\n', '    \n', '    function whoIsTheOwner() public view returns(address) {\n', '        return contractOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract Mortal is Owned  {\n', '    function kill() public {\n', '        if (msg.sender == contractOwner) selfdestruct(contractOwner);\n', '    }\n', '}\n', '\n', 'contract CoquinhoERC20 is ERC20Interface, Mortal {\n', '    string private myName;\n', '    string private mySymbol;\n', '    uint private myTotalSupply;\n', '    uint8 public decimals;\n', '\n', '    mapping (address=>uint) balances;\n', '    mapping (address=>mapping (address=>uint)) ownerAllowances;\n', '\n', '    constructor() public {\n', '        myName = "Coquinho Coin";\n', '        mySymbol = "CQNC";\n', '        myTotalSupply = 1000000;\n', '        decimals = 0;\n', '        balances[msg.sender] = myTotalSupply;\n', '    }\n', '\n', '    function name() public view returns(string tokenName) {\n', '        return myName;\n', '    }\n', '\n', '    function symbol() public view returns(string tokenSymbol) {\n', '        return mySymbol;\n', '    }\n', '\n', '    function totalSupply() public view returns(uint amount) {\n', '        return myTotalSupply;\n', '    }\n', '\n', '    function balanceOf(address tokenOwner) public view returns(uint balance) {\n', '        require(tokenOwner != address(0));\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining) {\n', '        return ownerAllowances[tokenOwner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint amount) public hasEnoughBalance(msg.sender, amount) tokenAmountValid(amount) returns(bool status) {\n', '        balances[msg.sender] -= amount;\n', '        balances[to] += amount;\n', '        emit Transfer(msg.sender, to, amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint limit) public returns(bool status) {\n', '        ownerAllowances[msg.sender][spender] = limit;\n', '        emit Approval(msg.sender, spender, limit);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint amount) public \n', '    hasEnoughBalance(from, amount) isAllowed(msg.sender, from, amount) tokenAmountValid(amount)\n', '    returns(bool status) {\n', '        balances[from] -= amount;\n', '        balances[to] += amount;\n', '        ownerAllowances[from][msg.sender] = amount;\n', '        emit Transfer(from, to, amount);\n', '        return true;\n', '    }\n', '\n', '    modifier hasEnoughBalance(address owner, uint amount) {\n', '        uint balance;\n', '        balance = balances[owner];\n', '        require (balance >= amount); \n', '        _;\n', '    }\n', '\n', '    modifier isAllowed(address spender, address tokenOwner, uint amount) {\n', '        require (amount <= ownerAllowances[tokenOwner][spender]);\n', '        _;\n', '    }\n', '\n', '    modifier tokenAmountValid(uint amount) {\n', '        require(amount > 0);\n', '        _;\n', '    }\n', '\n', '}']
