['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library _SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// contract WhiteListAccess\n', '// ----------------------------------------------------------------------------\n', 'contract WhiteListAccess {\n', '    \n', '    function WhiteListAccess() public {\n', '        owner = msg.sender;\n', '        whitelist[owner] = true;\n', '        whitelist[address(this)] = true;\n', '    }\n', '    \n', '    address public owner;\n', '    mapping (address => bool) whitelist;\n', '\n', '    modifier onlyOwner {require(msg.sender == owner); _;}\n', '    modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}\n', '\n', '    function addToWhiteList(address trusted) public onlyOwner() {\n', '        whitelist[trusted] = true;\n', '    }\n', '\n', '    function removeFromWhiteList(address untrusted) public onlyOwner() {\n', '        whitelist[untrusted] = false;\n', '    }\n', '\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract _ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract _Token is WhiteListAccess, _ERC20Interface {\n', '    using _SafeMath for uint;\n', '    \n', '    uint8   public   decimals;\n', '    uint    public   totSupply;\n', '    string  public   symbol;\n', '    string  public   name;\n', '\n', '    mapping(address => uint) public balances;\n', '    mapping(address => mapping(address => uint)) public allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function _Token(string _name, string _sym) public {\n', '        symbol = _sym;\n', '        name = _name;\n', '        decimals = 0;\n', '        totSupply = 0;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return totSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the _token balance for account `_tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address _tokenOwner) public constant returns (uint balance) {\n', '        return balances[_tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(!freezed);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function desapprove(address spender) public returns (bool success) {\n', '        allowed[msg.sender][spender] = 0;\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(!freezed);\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // FLC API \n', '    // ------------------------------------------------------------------------\n', '    bool freezed;\n', '\n', '    function create(uint units) public onlyWhitelisted() {\n', '        totSupply = totSupply + units;\n', '        balances[msg.sender] = balances[msg.sender] + units;\n', '    }\n', '\n', '    function freeze() public onlyWhitelisted() {\n', '        freezed = true;\n', '    }\n', '    \n', '    function unfreeze() public onlyWhitelisted() {\n', '        freezed = false;\n', '    }\n', '}\n', '\n', 'contract FourLeafClover is _Token("Four Leaf Clover", "FLC") {\n', '    function FourLeafClover() public {}\n', '}']