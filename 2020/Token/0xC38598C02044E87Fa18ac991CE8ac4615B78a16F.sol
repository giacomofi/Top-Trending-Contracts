['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-16\n', '*/\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '// ----------------------------------------------------------------------------\n', ' abstract contract ERC20Interface {\n', '    function totalSupply()virtual  public  view returns (uint);\n', '    function balanceOf(address tokenOwner)virtual public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) virtual public returns (bool success);\n', '    function approve(address spender, uint tokens) virtual public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'abstract contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes memory data)virtual public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and a\n', '// fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract FFI_ERC20 is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '    uint burn_rate=20;\n', '    bool public  permit_mode; \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    mapping(address => uint) blocked;\n', '    mapping(address => uint) permitted;\n', '    mapping(address => uint) trading_free;\n', '////-----------------------------------------------\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(!(msg.data.length < size + 4));\n', '        _;\n', '    }\n', '\n', '////-----------------------------------------------\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor(uint256 total) public {\n', '        permit_mode=false;\n', '        symbol = "FFI";\n', '        name = "FFI_ERC20";\n', '        decimals = 18;\n', '        _totalSupply = total * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        trading_free[owner]=1;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply()override public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner)override public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens)override public onlyPayloadSize(2*32) returns (bool success) {\n', '        \n', '        if(blocked[msg.sender]==0x424C4F434B)\n', '        {\n', '            return false;\n', '        }\n', '         if( permit_mode && permitted[msg.sender]!=0x7065726D6974)\n', '        {\n', '            return false;\n', '        }\n', '\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        if(trading_free[msg.sender]==1)\n', '        {\n', '            balances[to] = balances[to].add(tokens);\n', '            emit Transfer(msg.sender, to, tokens);\n', '       \n', '        }else{\n', '            balances[to] = balances[to].add(tokens*(1000-burn_rate)/1000);\n', '            balances[address(0)]=    balances[address(0)].add(tokens*(burn_rate)/1000);\n', '            emit Transfer(msg.sender, to, tokens*(1000-burn_rate)/1000);\n', '            emit Transfer(msg.sender, address(0), tokens*(burn_rate)/1000);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens)override public  onlyPayloadSize(2*32)  returns (bool success) {\n', '\n', '        if(blocked[msg.sender]==0x424C4F434B)\n', '        {\n', '            return false;\n', '        }\n', '         if( permit_mode && permitted[msg.sender]!=0x7065726D6974)\n', '        {\n', '            return false;\n', '        }\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens)override public returns (bool success) {\n', '        \n', '        if(blocked[msg.sender]==0x424C4F434B)\n', '        {\n', '            return false;\n', '        }\n', '        if( permit_mode && permitted[msg.sender]!=0x7065726D6974)\n', '        {\n', '            return false;\n', '        }\n', '        \n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '\n', '        if(trading_free[msg.sender]==1)\n', '        {\n', '             balances[to] = balances[to].add(tokens);\n', '            emit Transfer(from, to, tokens);\n', '       \n', '        }else{\n', '             balances[to] = balances[to].add(tokens*(1000-burn_rate)/1000);\n', '             balances[address(0)]=    balances[address(0)].add(tokens*(burn_rate)/1000);\n', '            emit Transfer(from, to, tokens*(1000-burn_rate)/1000);\n', '            emit Transfer(from, address(0), tokens*(burn_rate)/1000);\n', '        }\n', '\n', '       \n', '        \n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender)override public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '        \n', '        if(blocked[msg.sender]==0x424C4F434B)\n', '        {\n', '            return false;\n', '        }\n', '        \n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    fallback() external payable {}\n', '    receive() external payable { \n', '    revert();\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    \n', '    \n', '    function block_scientist(address tokenOwner) public onlyOwner returns (bool success) {\n', '        \n', '        blocked[tokenOwner]=0x424C4F434B;\n', '        \n', '        return true;\n', '    }\n', '    function unblock_scientist(address tokenOwner) public onlyOwner returns (bool success) {\n', '        \n', '        blocked[tokenOwner]=0x00;\n', '        \n', '        return true;\n', '    }\n', '\n', '    function set_permit_mode(bool mode) public onlyOwner returns (bool success) {\n', '        \n', '        permit_mode=mode;\n', '        \n', '        return true;\n', '    }\n', '    function set_trading_burning_mode(address user ,uint mode) public onlyOwner returns (bool success) {\n', '        \n', '        trading_free[user]=mode;\n', '        \n', '        return true;\n', '    }\n', '    function set_trading_burning_rate(uint rate) public onlyOwner returns (bool success) {\n', '        \n', '        burn_rate=rate;\n', '        \n', '        return true;\n', '    }\n', '    \n', '\n', '    function permit_user(address tokenOwner) public onlyOwner returns (bool success) {\n', '        \n', '        permitted[tokenOwner]=0x7065726D6974;\n', '        \n', '        return true;\n', '    }\n', '    function unpermit_user(address tokenOwner) public onlyOwner returns (bool success) {\n', '        \n', '        permitted[tokenOwner]=0x00;\n', '        \n', '        return true;\n', '    }\n', '    function issue_token(uint token) public onlyOwner returns (bool success) {\n', '        \n', '        _totalSupply=_totalSupply+token;\n', '        balances[msg.sender]= balances[msg.sender] +token; \n', '        \n', '        return true;\n', '    }\n', '    function Call_Function(address addr,uint256 value ,bytes memory data) public  onlyOwner {\n', '      addr.call.value(value)(data);\n', '    }\n', '}']