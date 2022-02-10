['pragma solidity ^0.4.19;\n', '\n', '//safeMath Library for Arithmetic operations\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', 'contract LCXCoin is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public  name;\n', '    uint256 public decimals;\n', '    uint256 public _totalSupply;\n', '    uint256 public burnt;\n', '    address public charityFund = 0x1F53b1E1E9771A38eDA9d144eF4877341e47CF51;\n', '    address public bountyFund = 0xfF311F52ddCC4E9Ba94d2559975efE3eb1Ea3bc6;\n', '    address public tradingFund = 0xf609127b10DaB6e53B7c489899B265c46Cee1E9d;\n', '    \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    \n', '    event FrozenFunds(address target, bool frozen); // notifies clients about the fund frozen\n', '    event Burn(address indexed burner, uint256 value);\n', '    event Burnfrom(address indexed _from, uint256 value);\n', '  \n', '    // Constructor\n', '    constructor () public {\n', '        symbol = "LCX";\n', '        name = "London Crypto Exchange";\n', '        decimals = 18;\n', '        _totalSupply = 113000000 * 10 ** uint(decimals);    //totalSupply = initialSupply * 10 ** uint(decimals);\n', '        balances[charityFund] = safeAdd(balances[charityFund], 13000000 * (10 ** decimals)); // 13M to charityFund\n', '        emit Transfer(address(0), charityFund, 13000000 * (10 ** decimals));     // Event for token transfer\n', '        balances[bountyFund] = safeAdd(balances[bountyFund], 25000000 * (10 ** decimals)); // 25M to bountyFund\n', '        emit Transfer(address(0), bountyFund, 25000000 * (10 ** decimals));     // Event for token transfer\n', '        balances[tradingFund] = safeAdd(balances[tradingFund], 75000000 * (10 ** decimals)); // 75M to tradingFund\n', '        emit Transfer(address(0), tradingFund, 75000000 * (10 ** decimals));     // Event for token transfer\n', '    }\n', '\n', '    // Total supply\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // Get the token balance for account tokenOwner\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // Internal transfer, only can be called by this contract \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \t\t\t// Prevent transfer to 0x0 address.\n', '        require (balances[_from] >= _value);               \t\t\t    // Check if the sender has enough balance\n', '        require (balances[_to] + _value > balances[_to]); \t\t\t    // Check for overflows\n', '        require(!frozenAccount[_from]);                     \t\t\t// Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       \t\t\t// Check if recipient is frozen\n', '        uint previousBalances = balances[_from] + balances[_to];\t\t// Save this for an assertion in the future\n', '        balances[_from] = safeSub(balances[_from],_value);    \t\t\t// Subtract from the sender\n', '        balances[_to] = safeAdd(balances[_to],_value);        \t\t\t// Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\t\t\t\t\t\t\t\t\t// raise Event\n', '        assert(balances[_from] + balances[_to] == previousBalances); \n', '    }\n', '    \n', '   \n', '    // Transfer the balance from token owner&#39;s account to user account\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        _transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // Transfer tokens from the from account to the to account\n', '  \n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        \n', '        require(tokens <= allowed[from][msg.sender]); \n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); \n', '        _transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `spender` to spend no more than `_value` tokens in your behalf\n', '     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '     * recommends that there are no checks for the approval double-spend attack\n', '     * as this should be implemented in user interfaces \n', '\n', '     */\n', '     \n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender,0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((tokens == 0) || (allowed[msg.sender][spender] == 0));\n', '        \n', '        allowed[msg.sender][spender] = tokens; // allow tokens to spender\n', '        emit Approval(msg.sender, spender, tokens); // raise Approval Event\n', '        return true;\n', '    }\n', '\n', '    // Get the amount of tokens approved by the owner that can be transferred to the spender&#39;s account\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', '    // from the token owner&#39;s account. The spender contract function\n', '    // receiveApproval(...) is then executed\n', '    ///* Allow another contract to spend some tokens in your behalf */\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        //allowed[msg.sender][spender] = tokens;\n', '        //Approval(msg.sender, spender, tokens);\n', '        \n', '        require(approve(spender, tokens)); // approve function to be called first\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Don&#39;t accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = safeSub(balances[burner],_value);\n', '        _totalSupply = safeSub(_totalSupply,_value);\n', '        burnt = safeAdd(burnt,_value);\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0), _value);\n', '    }\n', '  \n', '    function burnFrom(address _from, uint256 _value) public onlyOwner returns  (bool success) {\n', '        require (balances[_from] >= _value);            \n', '        require (msg.sender == owner);   \n', '        _totalSupply = safeSub(_totalSupply,_value);\n', '        burnt = safeAdd(burnt,_value);\n', '        balances[_from] = safeSub(balances[_from],_value);                      \n', '        emit Burnfrom(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can take back  any accidentally sent ERC20 tokens from any address\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '//safeMath Library for Arithmetic operations\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', 'contract LCXCoin is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public  name;\n', '    uint256 public decimals;\n', '    uint256 public _totalSupply;\n', '    uint256 public burnt;\n', '    address public charityFund = 0x1F53b1E1E9771A38eDA9d144eF4877341e47CF51;\n', '    address public bountyFund = 0xfF311F52ddCC4E9Ba94d2559975efE3eb1Ea3bc6;\n', '    address public tradingFund = 0xf609127b10DaB6e53B7c489899B265c46Cee1E9d;\n', '    \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    \n', '    event FrozenFunds(address target, bool frozen); // notifies clients about the fund frozen\n', '    event Burn(address indexed burner, uint256 value);\n', '    event Burnfrom(address indexed _from, uint256 value);\n', '  \n', '    // Constructor\n', '    constructor () public {\n', '        symbol = "LCX";\n', '        name = "London Crypto Exchange";\n', '        decimals = 18;\n', '        _totalSupply = 113000000 * 10 ** uint(decimals);    //totalSupply = initialSupply * 10 ** uint(decimals);\n', '        balances[charityFund] = safeAdd(balances[charityFund], 13000000 * (10 ** decimals)); // 13M to charityFund\n', '        emit Transfer(address(0), charityFund, 13000000 * (10 ** decimals));     // Event for token transfer\n', '        balances[bountyFund] = safeAdd(balances[bountyFund], 25000000 * (10 ** decimals)); // 25M to bountyFund\n', '        emit Transfer(address(0), bountyFund, 25000000 * (10 ** decimals));     // Event for token transfer\n', '        balances[tradingFund] = safeAdd(balances[tradingFund], 75000000 * (10 ** decimals)); // 75M to tradingFund\n', '        emit Transfer(address(0), tradingFund, 75000000 * (10 ** decimals));     // Event for token transfer\n', '    }\n', '\n', '    // Total supply\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // Get the token balance for account tokenOwner\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // Internal transfer, only can be called by this contract \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \t\t\t// Prevent transfer to 0x0 address.\n', '        require (balances[_from] >= _value);               \t\t\t    // Check if the sender has enough balance\n', '        require (balances[_to] + _value > balances[_to]); \t\t\t    // Check for overflows\n', '        require(!frozenAccount[_from]);                     \t\t\t// Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       \t\t\t// Check if recipient is frozen\n', '        uint previousBalances = balances[_from] + balances[_to];\t\t// Save this for an assertion in the future\n', '        balances[_from] = safeSub(balances[_from],_value);    \t\t\t// Subtract from the sender\n', '        balances[_to] = safeAdd(balances[_to],_value);        \t\t\t// Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\t\t\t\t\t\t\t\t\t// raise Event\n', '        assert(balances[_from] + balances[_to] == previousBalances); \n', '    }\n', '    \n', '   \n', "    // Transfer the balance from token owner's account to user account\n", '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        _transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // Transfer tokens from the from account to the to account\n', '  \n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        \n', '        require(tokens <= allowed[from][msg.sender]); \n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); \n', '        _transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `spender` to spend no more than `_value` tokens in your behalf\n', '     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '     * recommends that there are no checks for the approval double-spend attack\n', '     * as this should be implemented in user interfaces \n', '\n', '     */\n', '     \n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender,0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((tokens == 0) || (allowed[msg.sender][spender] == 0));\n', '        \n', '        allowed[msg.sender][spender] = tokens; // allow tokens to spender\n', '        emit Approval(msg.sender, spender, tokens); // raise Approval Event\n', '        return true;\n', '    }\n', '\n', "    // Get the amount of tokens approved by the owner that can be transferred to the spender's account\n", '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', "    // from the token owner's account. The spender contract function\n", '    // receiveApproval(...) is then executed\n', '    ///* Allow another contract to spend some tokens in your behalf */\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        //allowed[msg.sender][spender] = tokens;\n', '        //Approval(msg.sender, spender, tokens);\n', '        \n', '        require(approve(spender, tokens)); // approve function to be called first\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    \n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = safeSub(balances[burner],_value);\n', '        _totalSupply = safeSub(_totalSupply,_value);\n', '        burnt = safeAdd(burnt,_value);\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0), _value);\n', '    }\n', '  \n', '    function burnFrom(address _from, uint256 _value) public onlyOwner returns  (bool success) {\n', '        require (balances[_from] >= _value);            \n', '        require (msg.sender == owner);   \n', '        _totalSupply = safeSub(_totalSupply,_value);\n', '        burnt = safeAdd(burnt,_value);\n', '        balances[_from] = safeSub(balances[_from],_value);                      \n', '        emit Burnfrom(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can take back  any accidentally sent ERC20 tokens from any address\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
