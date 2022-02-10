['pragma solidity ^0.4.18;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// &#39;FIXED&#39; &#39;Yobit Coin&#39; token contract\n', '\n', '\n', '// Symbol      : FIXED\n', '\n', '// Name        : Yobit Coin\n', '\n', '// Total supply: 20,000,00.000000000000000000\n', '\n', '// Decimals    : 18\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Safe maths\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b <= a);\n', '\n', '        c = a - b;\n', '\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b > 0);\n', '\n', '        c = a / b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC Token Standard #20 Interface\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Contract function to receive approval and execute function in one call\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ApproveAndCallFallBack {\n', '\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Owned contract\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '\n', '    function Owned() public {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '\n', '        newOwner = _newOwner;\n', '\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '\n', '        require(msg.sender == newOwner);\n', '\n', '        OwnershipTransferred(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '\n', '        newOwner = address(0);\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC20 Token, with the addition of symbol, name and decimals and an initial fixed supply\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract YBCLiveToken is ERC20Interface, Owned {\n', '\n', '    using SafeMath for uint;\n', '\n', '\n', '    string public symbol;\n', '\n', '    string public  name;\n', '\n', '    uint8 public decimals;\n', '\n', '    uint public _totalSupply;\n', '\n', '\n', '    mapping(address => uint) balances;\n', '\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Constructor\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function YBCLiveToken() public {\n', '\n', '        symbol = "YBC";\n', '\n', '        name = "Yobit Coin";\n', '\n', '        decimals = 18;\n', '\n', '        _totalSupply = 2000000 * 10**uint(decimals);\n', '\n', '        balances[owner] = _totalSupply;\n', '\n', '        Transfer(address(0), owner, _totalSupply);\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Total supply\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '\n', '        return _totalSupply  - balances[address(0)];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Get the token balance for account `tokenOwner`\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '\n', '        return balances[tokenOwner];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '\n', '    // - 0 value transfers are allowed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(msg.sender, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner&#39;s account\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[from] = balances[from].sub(tokens);\n', '\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(from, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Returns the amount of tokens approved by the owner that can be transferred to the spender&#39;s account\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '\n', '        return allowed[tokenOwner][spender];\n', '\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner&#39;s account. The `spender` contract function\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Don&#39;t accept ETH\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function () public payable {\n', '\n', '        revert();\n', '\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', "// 'FIXED' 'Yobit Coin' token contract\n", '\n', '\n', '// Symbol      : FIXED\n', '\n', '// Name        : Yobit Coin\n', '\n', '// Total supply: 20,000,00.000000000000000000\n', '\n', '// Decimals    : 18\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Safe maths\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b <= a);\n', '\n', '        c = a - b;\n', '\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b > 0);\n', '\n', '        c = a / b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC Token Standard #20 Interface\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Contract function to receive approval and execute function in one call\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ApproveAndCallFallBack {\n', '\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Owned contract\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '\n', '    function Owned() public {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '\n', '        newOwner = _newOwner;\n', '\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '\n', '        require(msg.sender == newOwner);\n', '\n', '        OwnershipTransferred(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '\n', '        newOwner = address(0);\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC20 Token, with the addition of symbol, name and decimals and an initial fixed supply\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract YBCLiveToken is ERC20Interface, Owned {\n', '\n', '    using SafeMath for uint;\n', '\n', '\n', '    string public symbol;\n', '\n', '    string public  name;\n', '\n', '    uint8 public decimals;\n', '\n', '    uint public _totalSupply;\n', '\n', '\n', '    mapping(address => uint) balances;\n', '\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Constructor\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function YBCLiveToken() public {\n', '\n', '        symbol = "YBC";\n', '\n', '        name = "Yobit Coin";\n', '\n', '        decimals = 18;\n', '\n', '        _totalSupply = 2000000 * 10**uint(decimals);\n', '\n', '        balances[owner] = _totalSupply;\n', '\n', '        Transfer(address(0), owner, _totalSupply);\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Total supply\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '\n', '        return _totalSupply  - balances[address(0)];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Get the token balance for account `tokenOwner`\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '\n', '        return balances[tokenOwner];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', "    // Transfer the balance from token owner's account to `to` account\n", '\n', "    // - Owner's account must have sufficient balance to transfer\n", '\n', '    // - 0 value transfers are allowed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(msg.sender, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', "    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account\n", '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[from] = balances[from].sub(tokens);\n', '\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(from, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', "    // Returns the amount of tokens approved by the owner that can be transferred to the spender's account\n", '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '\n', '        return allowed[tokenOwner][spender];\n', '\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', "    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account. The `spender` contract function\n", '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', "    // Don't accept ETH\n", '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function () public payable {\n', '\n', '        revert();\n', '\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '\n', '    }\n', '\n', '}']
