['pragma solidity ^0.4.19;\n', '\n', '// ----------------------------------------------------------------------------\n', '// (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.\n', '// modified by team garry, thanks heaps BokkyPooBah!\n', '//\n', '// massive shoutout to https://cryptozombies.io\n', '// best solidity learning series out there!\n', "// wait what's to come after Garrys coin :) there must be a Garrys game\n", '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract owner and transfer functions\n', '// just in case someone wants to get my bacon\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 compliant Garry token :)\n', '// Receives ETH and generates Garrys, the world needs more Garrys\n', '// Limited to 10000 on this planet, yup\n', '// 1 Garry can be exchanged for 1 creature in our upcoming game\n', '// ----------------------------------------------------------------------------\n', 'contract Garrys is ERC20Interface, Owned {\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public _maxSupply;\n', '    uint public _ratio;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    address GameContract;\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Launched once when contract starts\n', '    // ------------------------------------------------------------------------\n', '    function Garrys() public {\n', '        symbol = "GAR";\n', '        name = "Garrys";\n', '        decimals = 18;\n', "        // the first coin goes to Garry cause, it's a Garry :P, adding it to total supply here\n", '        _totalSupply = 1 * 10**uint(decimals);      \n', '        // set ratio, get 100 Garrys for 1 Ether\n', '        _ratio = 100;\n', '        // there can never be more than 10000 Garrys in existence, doubt the world can handle 2 :D\n', '        _maxSupply = 10000 * 10**uint(decimals);    \n', '        balances[owner] = _totalSupply;\n', '        // transfer inital coin to Garry, which is 1\n', '        Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // to safe gas, address(0) is removed since it never holds Garrys\n', '    // they are minted and not initially transferred to address(0)\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);\n', '        balances[msg.sender] -= tokens;\n', '        balances[to] += tokens;\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require (allowed[from][msg.sender] >= tokens);\n', '        require (balances[from] >= tokens);\n', '        \n', '        balances[from] -= tokens;\n', '        allowed[from][msg.sender] -= tokens;\n', '        balances[to] += tokens;\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Tokens per Ethererum at a ratio of 100:1\n', '    // But you need to buy at least 0.0001 Garrys to avoid spamming (currently 5 $cent)\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        require(msg.value >= 1000000000000);\n', '        require(_totalSupply+(msg.value*_ratio)<=_maxSupply);\n', '        \n', '        uint tokens;\n', '        tokens = msg.value*_ratio;\n', '\n', '        balances[msg.sender] += tokens;\n', '        _totalSupply += tokens;\n', '        Transfer(address(0), msg.sender, tokens);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', "    // Only if he is in the mood though, I won't give a damn if you are an annoying bot\n", '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Query Ethereum of contract\n', '    // ------------------------------------------------------------------------\n', '    function weiBalance() public constant returns (uint weiBal) {\n', '        return this.balance;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Send Contracts Ethereum to address owner\n', '    // ------------------------------------------------------------------------\n', '    function weiToOwner(address _address, uint amount) public onlyOwner {\n', '        require(amount <= this.balance);\n', '        _address.transfer(amount);\n', '    }\n', '}']