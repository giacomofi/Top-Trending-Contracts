['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-06\n', '*/\n', '\n', 'pragma solidity 0.5.10;\n', '\n', '// ----------------------------------------------------------------------------\n', '// WUMI token contract (2021)\n', '//\n', '// Symbol       : WUMI\n', '// Name         : WUMI\n', '// Total supply : 1.175.000 (burnable)\n', '// Decimals     : 18\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) { c = a + b; require(c >= a); }\n', '    function sub(uint a, uint b) internal pure returns (uint c) { require(b <= a); c = a - b; }\n', '    function mul(uint a, uint b) internal pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); }\n', '    function div(uint a, uint b) internal pure returns (uint c) { require(b > 0); c = a / b; }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint tokens, address token, bytes memory data) public;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address transferOwner) public onlyOwner {\n', '        require(transferOwner != newOwner);\n', '        newOwner = transferOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// WUMI ERC20 Token \n', '// ----------------------------------------------------------------------------\n', 'contract WUMI is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    bool public running = true;\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Contract init. Set symbol, name, decimals and initial fixed supply\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        symbol = "WUMI";\n', '        name = "WUMI";\n', '        decimals = 18;\n', '        _totalSupply = 1175000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Start-stop contract functions:\n', '    // transfer, approve, transferFrom, approveAndCall\n', '    // ------------------------------------------------------------------------\n', '    modifier isRunning {\n', '        require(running);\n', '        _;\n', '    }\n', '\n', '    function startStop () public onlyOwner returns (bool success) {\n', '        if (running) { running = false; } else { running = true; }\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public isRunning returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        require(to != address(0));\n', '        _transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Internal transfer function\n', '    // ------------------------------------------------------------------------\n', '    function _transfer(address from, address to, uint256 tokens) internal {\n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Increase the amount of tokens that an owner allowed to a spender.\n', '    // ------------------------------------------------------------------------\n', '    function increaseAllowance(address spender, uint addedTokens) public isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, allowed[msg.sender][spender].add(addedTokens));\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Decrease the amount of tokens that an owner allowed to a spender.\n', '    // ------------------------------------------------------------------------\n', '    function decreaseAllowance(address spender, uint subtractedTokens) public isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, allowed[msg.sender][spender].sub(subtractedTokens));\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public isRunning returns (bool success) {\n', '        _approve(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Approve an address to spend another addresses' tokens.\n", '    // ------------------------------------------------------------------------\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0));\n', '        require(spender != address(0));\n', '        allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public isRunning returns (bool success) {\n', '        require(to != address(0));\n', '        _approve(from, msg.sender, allowed[from][msg.sender].sub(tokens));\n', '        _transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Tokens burn\n', '    // ------------------------------------------------------------------------\n', '    function burnTokens(uint tokens) public returns (bool success) {\n', '        require(tokens <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        _totalSupply = _totalSupply.sub(tokens);\n', '        emit Transfer(msg.sender, address(0), tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Tokens multisend from owner only by owner\n', '    // ------------------------------------------------------------------------\n', '    function multisend(address[] memory to, uint[] memory values) public onlyOwner returns (uint) {\n', '        require(to.length == values.length);\n', '        require(to.length < 100);\n', '        uint sum;\n', '        for (uint j; j < values.length; j++) {\n', '            sum += values[j];\n', '        }\n', '        balances[owner] = balances[owner].sub(sum);\n', '        for (uint i; i < to.length; i++) {\n', '            balances[to[i]] = balances[to[i]].add(values[i]);\n', '            emit Transfer(owner, to[i], values[i]);\n', '        }\n', '        return(to.length);\n', '    }\n', '}']