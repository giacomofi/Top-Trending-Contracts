['pragma solidity ^0.4.21;\n', '\n', '// ----------------------------------------------------------------------------\n', '// ZAN token contract\n', '//\n', '// Symbol      : ZAN\n', '// Name        : ZAN Coin\n', '// Total supply: 17,148,385.000000000000000000\n', '// Decimals    : 18\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        assert(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        assert(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract ZanCoin is ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Metadata\n', '    // ------------------------------------------------------------------------\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '\n', '    mapping(address => uint) public balances;\n', '    mapping(address => mapping(address => uint)) public allowed;\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Crowdsale data\n', '    // ------------------------------------------------------------------------\n', '    bool public isInPreSaleState;\n', '    bool public isInRoundOneState;\n', '    bool public isInRoundTwoState;\n', '    bool public isInFinalState;\n', '    uint public stateStartDate;\n', '    uint public stateEndDate;\n', '    uint public saleCap;\n', '    uint public exchangeRate;\n', '    \n', '    uint public burnedTokensCount;\n', '\n', '    event SwitchCrowdSaleStage(string stage, uint exchangeRate);\n', '    event BurnTokens(address indexed burner, uint amount);\n', '    event PurchaseZanTokens(address indexed contributor, uint eth_sent, uint zan_received);\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function ZanCoin() public {\n', '        symbol = "ZAN";\n', '        name = "ZAN Coin";\n', '        decimals = 18;\n', '        _totalSupply = 17148385 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        \n', '        isInPreSaleState = false;\n', '        isInRoundOneState = false;\n', '        isInRoundTwoState = false;\n', '        isInFinalState = false;\n', '        burnedTokensCount = 0;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account. The `spender` contract function\n', '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Accepts ETH and transfers ZAN tokens based on exchage rate and state\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        uint eth_sent = msg.value;\n', '        uint tokens_amount = eth_sent.mul(exchangeRate);\n', '        \n', '        require(eth_sent > 0);\n', '        require(exchangeRate > 0);\n', '        require(stateStartDate < now && now < stateEndDate);\n', '        require(balances[owner] >= tokens_amount);\n', '        require(_totalSupply - (balances[owner] - tokens_amount) <= saleCap);\n', '        \n', '        // Don&#39;t accept ETH in the final state\n', '        require(!isInFinalState);\n', '        require(isInPreSaleState || isInRoundOneState || isInRoundTwoState);\n', '        \n', '        balances[owner] = balances[owner].sub(tokens_amount);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens_amount);\n', '        emit PurchaseZanTokens(msg.sender, eth_sent, tokens_amount);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Switches crowdsale stages: PreSale -> Round One -> Round Two\n', '    // ------------------------------------------------------------------------\n', '    function switchCrowdSaleStage() external onlyOwner {\n', '        require(!isInFinalState && !isInRoundTwoState);\n', '        \n', '        if (!isInPreSaleState) {\n', '            isInPreSaleState = true;\n', '            exchangeRate = 1500;\n', '            saleCap = (3 * 10**6) * (uint(10) ** decimals);\n', '            emit SwitchCrowdSaleStage("PreSale", exchangeRate);\n', '        }\n', '        else if (!isInRoundOneState) {\n', '            isInRoundOneState = true;\n', '            exchangeRate = 1200;\n', '            saleCap = saleCap + ((4 * 10**6) * (uint(10) ** decimals));\n', '            emit SwitchCrowdSaleStage("RoundOne", exchangeRate);\n', '        }\n', '        else if (!isInRoundTwoState) {\n', '            isInRoundTwoState = true;\n', '            exchangeRate = 900;\n', '            saleCap = saleCap + ((5 * 10**6) * (uint(10) ** decimals));\n', '            emit SwitchCrowdSaleStage("RoundTwo", exchangeRate);\n', '        }\n', '        \n', '        stateStartDate = now + 5 minutes;\n', '        stateEndDate = stateStartDate + 7 days;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Switches to Complete stage of the contract. Sends all funds collected\n', '    // to the contract owner.\n', '    // ------------------------------------------------------------------------\n', '    function completeCrowdSale() external onlyOwner {\n', '        require(!isInFinalState);\n', '        require(isInPreSaleState && isInRoundOneState && isInRoundTwoState);\n', '        \n', '        owner.transfer(address(this).balance);\n', '        exchangeRate = 0;\n', '        isInFinalState = true;\n', '        emit SwitchCrowdSaleStage("Complete", exchangeRate);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token holders are able to burn their tokens.\n', '    // ------------------------------------------------------------------------\n', '    function burn(uint amount) public {\n', '        require(amount > 0);\n', '        require(amount <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        burnedTokensCount = burnedTokensCount + amount;\n', '        emit BurnTokens(msg.sender, amount);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']