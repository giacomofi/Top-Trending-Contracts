['pragma solidity ^0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', '// input  D:\\MDZA-TESTNET1\\solidity-flattener\\SolidityFlatteryGo\\contract\\MDZAToken.sol\n', '// flattened :  Sunday, 30-Dec-18 09:30:12 UTC\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', 'contract ERCInterface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Burn(address indexed from, uint256 value);\n', '    event FrozenFunds(address target, bool frozen);\n', '}\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract MDZAToken is ERCInterface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '    bool transactionLock;\n', '\n', '    // Balances for each account\n', '    mapping(address => uint) balances;\n', '\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    // Constructor . Please change the values \n', '    constructor() public {\n', '        symbol = "MDZA";\n', '        name = "MEDOOZA Ecosystem v1.1";\n', '        decimals = 10;\n', '        _totalSupply = 1200000000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        transactionLock = false;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    // Get total supply\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    // Get the token balance for specific account\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // Transfer the balance from token owner account to receiver account\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(!transactionLock);  // Check for transaction lock\n', '        require(!frozenAccount[to]);// Check if recipient is frozen\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', "    // Token owner can approve for spender to transferFrom(...) tokens from the token owner's account\n", '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // Transfer token from spender account to receiver account\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(!transactionLock);         // Check for transaction lock\n', '        require(!frozenAccount[from]);     // Check if sender is frozen\n', '        require(!frozenAccount[to]);       // Check if recipient is frozen\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // Get tokens that are approved by the owner \n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', "    // Don't accept ETH \n", '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    // Transfer any ERC Token\n', '    function transferAnyERCToken(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERCInterface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    // Burn specific amount token\n', '    function burn(uint256 tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        _totalSupply = _totalSupply.sub(tokens);\n', '        emit Burn(msg.sender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // Burn token from specific account and with specific value\n', '    function burnFrom(address from, uint256 tokens) public  returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        _totalSupply = _totalSupply.sub(tokens);\n', '        emit Burn(from, tokens);\n', '        return true;\n', '    }\n', '\n', '    // Freeze and unFreeze account from sending and receiving tokens\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    // Get status of a locked account\n', '    function freezeAccountStatus(address target) onlyOwner public view returns (bool response){\n', '        return frozenAccount[target];\n', '    }\n', '\n', '    // Lock and unLock all transactions\n', '    function lockTransactions(bool lock) public onlyOwner returns (bool response){\n', '        transactionLock = lock;\n', '        return lock;\n', '    }\n', '\n', '    // Get status of global transaction lock\n', '    function transactionLockStatus() public onlyOwner view returns (bool response){\n', '        return transactionLock;\n', '    }\n', '}']