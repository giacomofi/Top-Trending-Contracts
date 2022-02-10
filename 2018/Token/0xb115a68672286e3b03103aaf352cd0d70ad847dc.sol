['pragma solidity ^0.4.19;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'CI10' token contract\n", '//\n', '// Symbol      : CI10\n', '// Name        : Compound Interest 10x per Year\n', '// Total supply: 1,000,000.000000000000000000\n', '// Decimals    : 10\n', '//\n', "// based on the 'FIXED' example from https://theethereum.wiki/w/index.php/ERC20_Token_Standard\n", '// (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract CI10Token is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\n', '    mapping(address => uint) startBalances;\n', '    mapping(address => uint) startBlocks;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function CI10Token() public {\n', '        symbol = "CI10";\n', '        name = "Compound Interest 10x per Year";\n', '        decimals = 10;\n', '        _totalSupply = 1000000 * 10**uint(decimals);\n', '        startBalances[owner] = _totalSupply;\n', '        startBlocks[owner] = block.number;\n', '        Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Computes `k * (1+1/q) ^ N`, with precision `p`. The higher\n', '    // the precision, the higher the gas cost. It should be\n', '    // something around the log of `n`. When `p == n`, the\n', '    // precision is absolute (sans possible integer overflows). <edit: NOT true, see comments>\n', '    // Much smaller values are sufficient to get a great approximation.\n', '    // from https://ethereum.stackexchange.com/questions/10425/is-there-any-efficient-way-to-compute-the-exponentiation-of-a-fraction-and-an-in\n', '    // ------------------------------------------------------------------------\n', '    function fracExp(uint k, uint q, uint n, uint p) pure public returns (uint) {\n', '        uint s = 0;\n', '        uint N = 1;\n', '        uint B = 1;\n', '        for (uint i = 0; i < p; ++i) {\n', '            s += k * N / B / (q**i);\n', '            N = N * (n-i);\n', '            B = B * (i+1);\n', '        }\n', '        return s;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Computes the compound interest for an account since the block stored in startBlock\n', '    // about factor 10 for 2 million blocks\n', '    // ------------------------------------------------------------------------\n', '    function compoundInterest(address tokenOwner) view public returns (uint) {\n', '        require(startBlocks[tokenOwner] > 0);\n', '        uint startBlock = startBlocks[tokenOwner];\n', '        uint currentBlock = block.number;\n', '        uint blockCount = currentBlock - startBlock;\n', '        uint balance = startBalances[tokenOwner];\n', '        return fracExp(balance, 867598, blockCount, 8).sub(balance);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return startBalances[tokenOwner] + compoundInterest(tokenOwner);\n', '    }\n', '\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Add the compound interest to the startBalance, update the start block,\n', '    // and update totalSupply\n', '    // ------------------------------------------------------------------------\n', '    function updateBalance(address tokenOwner) private {\n', '        if (startBlocks[tokenOwner] == 0) {\n', '            startBlocks[tokenOwner] = block.number;\n', '        }\n', '        uint ci = compoundInterest(tokenOwner);\n', '        startBalances[tokenOwner] = startBalances[tokenOwner].add(ci);\n', '        _totalSupply = _totalSupply.add(ci);\n', '        startBlocks[tokenOwner] = block.number;\n', '    }\n', '    \n', '    \n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        updateBalance(msg.sender);\n', '        updateBalance(to);\n', '        startBalances[msg.sender] = startBalances[msg.sender].sub(tokens);\n', '        startBalances[to] = startBalances[to].add(tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        updateBalance(from);\n', '        updateBalance(to);\n', '        startBalances[from] = startBalances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        startBalances[to] = startBalances[to].add(tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']