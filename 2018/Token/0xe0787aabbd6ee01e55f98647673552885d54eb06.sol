['pragma solidity 0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title HydrogenBlueICO\n', ' * @dev   HydrogenBlueICO accepting contributions only within a time frame.\n', ' */\n', 'contract HydrogenBlueICO is ERC20Interface, Owned {\n', '  using SafeMath for uint256;\n', '  string  public symbol; \n', '  string  public name;\n', '  uint8   public decimals;\n', '  uint256 public fundsRaised;\n', '  uint256 public reserveTokens;\n', '  string  public TokenPrice;\n', '  uint256 public saleTokens;\n', '  uint    internal _totalSupply;\n', '  uint internal _totalRemaining;\n', '  address public wallet;\n', '  uint256 internal firststageopeningTime;\n', '  uint256 internal secondstageopeningTime;\n', '  uint256 internal laststageopeningTime;\n', '  bool    internal Open;\n', '  bool internal distributionFinished;\n', '  \n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '    modifier onlyWhileOpen {\n', '        require(now >= firststageopeningTime && Open);\n', '        _;\n', '    }\n', '    \n', '    modifier canDistribut {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '  \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor (address _owner, address _wallet) public {\n', '        Open = true;\n', '        symbol = "HydroB";\n', '        name = " HydrogenBlue";\n', '        decimals = 18;\n', '        owner = _owner;\n', '        wallet = _wallet;\n', '        _totalSupply = 2700000000; // 2.7 billion\n', '        _totalRemaining = totalSupply();\n', '        balances[0xEA40d7bEF6ae216c4218E9bA28f92aF06cC77886] = 2e21;\n', '        emit Transfer(address(0),0xEA40d7bEF6ae216c4218E9bA28f92aF06cC77886, 2e21);\n', '        _totalRemaining = _totalRemaining.sub(2e21);\n', '        balances[0x30D344806E8c13A592F54a123f560ad1976f5eC2] = 2e21;\n', '        emit Transfer(address(0),0x30D344806E8c13A592F54a123f560ad1976f5eC2, 2e21);\n', '        _totalRemaining = _totalRemaining.sub(2e21);\n', '        _allocateTokens();\n', '        _setTimes();\n', '        distributionFinished = false;\n', '    }\n', '    \n', '    function _setTimes() internal {\n', '        firststageopeningTime    = 1539561600; // 15th OCT 2018 00:00:00 GMT\n', '        secondstageopeningTime   = 1540166400; // 22nd OCT 2018 00:00:00 GMT \n', '        laststageopeningTime     = 1540771200; // 29th OCT 2018 00:00:00 GMT\n', '    }\n', '  \n', '    function _allocateTokens() internal {\n', '        reserveTokens         = (_totalSupply.mul(5)).div(100) *10 **uint(decimals);  // 5% of totalSupply\n', '        saleTokens            = (_totalSupply.mul(95)).div(100) *10 **uint(decimals); // 95% of totalSupply\n', '        TokenPrice            = "0.00000023 ETH";\n', '    }\n', '    \n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _beneficiary) public payable onlyWhileOpen {\n', '    \n', '        uint256 weiAmount = msg.value;\n', '    \n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '        \n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '        \n', '        tokens = _getBonus(tokens, weiAmount);\n', '        \n', '        fundsRaised = fundsRaised.add(weiAmount);\n', '\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(this, _beneficiary, weiAmount, tokens);\n', '\n', '        _forwardFunds(msg.value);\n', '    }\n', '    \n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '    }\n', '  \n', '    function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {\n', '        uint256 rate = 4347826; //per wei\n', '        return _weiAmount.mul(rate);\n', '    }\n', '    \n', '    function _getBonus(uint256 tokens, uint256 weiAmount) internal returns (uint256) {\n', '        // DURING FIRST STAGE\n', '        if(now >= firststageopeningTime && now <= secondstageopeningTime) { \n', '            if(weiAmount >= 10e18) { // greater than 10 eths \n', '                // give 80% bonus\n', '                tokens = tokens.add((tokens.mul(80)).div(100));\n', '            } else {\n', '                // give 60% bonus\n', '                tokens = tokens.add((tokens.mul(60)).div(100));\n', '            }\n', '        } \n', '        // DURING SECOND STAGE\n', '        else if (now >= secondstageopeningTime && now <= laststageopeningTime) { \n', '            if(weiAmount >= 10e18) { // greater than 10 eths \n', '                // give 60% bonus\n', '                tokens = tokens.add((tokens.mul(60)).div(100));\n', '            } else {\n', '                // give 30% bonus\n', '                tokens = tokens.add((tokens.mul(30)).div(100));\n', '            }\n', '        } \n', '        // DURING LAST STAGE\n', '        else { \n', '            if(weiAmount >= 10e18) { // greater than 10 eths \n', '                // give 30% bonus\n', '                tokens = tokens.add((tokens.mul(30)).div(100));\n', '            } else {\n', '                // give 10% bonus\n', '                tokens = tokens.add((tokens.mul(10)).div(100));\n', '            }\n', '        }\n', '        \n', '        return tokens;\n', '    }\n', '    \n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        if(_totalRemaining != 0 && _totalRemaining >= _tokenAmount) {\n', '            balances[_beneficiary] = _tokenAmount;\n', '            emit Transfer(address(0),_beneficiary, _tokenAmount);\n', '            _totalRemaining = _totalRemaining.sub(_tokenAmount);\n', '        }\n', '        \n', '        if(_totalRemaining <= 0) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '    \n', '    function _forwardFunds(uint256 _amount) internal {\n', '        wallet.transfer(_amount);\n', '    }\n', '    \n', '    function stopICO() public onlyOwner{\n', '        Open = false;\n', '        if(_totalRemaining != 0){\n', '            uint tenpercentTokens = (_totalRemaining.mul(10)).div(100);\n', '            uint twentypercentTokens = (_totalRemaining.mul(20)).div(100);\n', '            _totalRemaining = _totalRemaining.sub(tenpercentTokens.add(twentypercentTokens));\n', '            emit Transfer(address(0), owner, tenpercentTokens);\n', '            emit Transfer(address(0), wallet, twentypercentTokens);\n', '            _burnRemainingTokens(); // burn the remaining tokens\n', '        }\n', '    }\n', '    \n', '    function _burnRemainingTokens() internal {\n', '        _totalSupply = _totalSupply.sub(_totalRemaining.div(1e18));\n', '    }\n', '    /* ERC20Interface function&#39;s implementation */\n', '    function totalSupply() public constant returns (uint){\n', '       return _totalSupply* 10**uint(decimals);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        // prevent transfer to 0x0, use burn instead\n', '        require(to != 0x0);\n', '        require(balances[msg.sender] >= tokens );\n', '        require(balances[to] + tokens >= balances[to]);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender,to,tokens);\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success){\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender,spender,tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success){\n', '        require(tokens <= allowed[from][msg.sender]); //check allowance\n', '        require(balances[from] >= tokens);\n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        emit Transfer(from,to,tokens);\n', '        return true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '}']
['pragma solidity 0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title HydrogenBlueICO\n', ' * @dev   HydrogenBlueICO accepting contributions only within a time frame.\n', ' */\n', 'contract HydrogenBlueICO is ERC20Interface, Owned {\n', '  using SafeMath for uint256;\n', '  string  public symbol; \n', '  string  public name;\n', '  uint8   public decimals;\n', '  uint256 public fundsRaised;\n', '  uint256 public reserveTokens;\n', '  string  public TokenPrice;\n', '  uint256 public saleTokens;\n', '  uint    internal _totalSupply;\n', '  uint internal _totalRemaining;\n', '  address public wallet;\n', '  uint256 internal firststageopeningTime;\n', '  uint256 internal secondstageopeningTime;\n', '  uint256 internal laststageopeningTime;\n', '  bool    internal Open;\n', '  bool internal distributionFinished;\n', '  \n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '    modifier onlyWhileOpen {\n', '        require(now >= firststageopeningTime && Open);\n', '        _;\n', '    }\n', '    \n', '    modifier canDistribut {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '  \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor (address _owner, address _wallet) public {\n', '        Open = true;\n', '        symbol = "HydroB";\n', '        name = " HydrogenBlue";\n', '        decimals = 18;\n', '        owner = _owner;\n', '        wallet = _wallet;\n', '        _totalSupply = 2700000000; // 2.7 billion\n', '        _totalRemaining = totalSupply();\n', '        balances[0xEA40d7bEF6ae216c4218E9bA28f92aF06cC77886] = 2e21;\n', '        emit Transfer(address(0),0xEA40d7bEF6ae216c4218E9bA28f92aF06cC77886, 2e21);\n', '        _totalRemaining = _totalRemaining.sub(2e21);\n', '        balances[0x30D344806E8c13A592F54a123f560ad1976f5eC2] = 2e21;\n', '        emit Transfer(address(0),0x30D344806E8c13A592F54a123f560ad1976f5eC2, 2e21);\n', '        _totalRemaining = _totalRemaining.sub(2e21);\n', '        _allocateTokens();\n', '        _setTimes();\n', '        distributionFinished = false;\n', '    }\n', '    \n', '    function _setTimes() internal {\n', '        firststageopeningTime    = 1539561600; // 15th OCT 2018 00:00:00 GMT\n', '        secondstageopeningTime   = 1540166400; // 22nd OCT 2018 00:00:00 GMT \n', '        laststageopeningTime     = 1540771200; // 29th OCT 2018 00:00:00 GMT\n', '    }\n', '  \n', '    function _allocateTokens() internal {\n', '        reserveTokens         = (_totalSupply.mul(5)).div(100) *10 **uint(decimals);  // 5% of totalSupply\n', '        saleTokens            = (_totalSupply.mul(95)).div(100) *10 **uint(decimals); // 95% of totalSupply\n', '        TokenPrice            = "0.00000023 ETH";\n', '    }\n', '    \n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _beneficiary) public payable onlyWhileOpen {\n', '    \n', '        uint256 weiAmount = msg.value;\n', '    \n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '        \n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '        \n', '        tokens = _getBonus(tokens, weiAmount);\n', '        \n', '        fundsRaised = fundsRaised.add(weiAmount);\n', '\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(this, _beneficiary, weiAmount, tokens);\n', '\n', '        _forwardFunds(msg.value);\n', '    }\n', '    \n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '    }\n', '  \n', '    function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {\n', '        uint256 rate = 4347826; //per wei\n', '        return _weiAmount.mul(rate);\n', '    }\n', '    \n', '    function _getBonus(uint256 tokens, uint256 weiAmount) internal returns (uint256) {\n', '        // DURING FIRST STAGE\n', '        if(now >= firststageopeningTime && now <= secondstageopeningTime) { \n', '            if(weiAmount >= 10e18) { // greater than 10 eths \n', '                // give 80% bonus\n', '                tokens = tokens.add((tokens.mul(80)).div(100));\n', '            } else {\n', '                // give 60% bonus\n', '                tokens = tokens.add((tokens.mul(60)).div(100));\n', '            }\n', '        } \n', '        // DURING SECOND STAGE\n', '        else if (now >= secondstageopeningTime && now <= laststageopeningTime) { \n', '            if(weiAmount >= 10e18) { // greater than 10 eths \n', '                // give 60% bonus\n', '                tokens = tokens.add((tokens.mul(60)).div(100));\n', '            } else {\n', '                // give 30% bonus\n', '                tokens = tokens.add((tokens.mul(30)).div(100));\n', '            }\n', '        } \n', '        // DURING LAST STAGE\n', '        else { \n', '            if(weiAmount >= 10e18) { // greater than 10 eths \n', '                // give 30% bonus\n', '                tokens = tokens.add((tokens.mul(30)).div(100));\n', '            } else {\n', '                // give 10% bonus\n', '                tokens = tokens.add((tokens.mul(10)).div(100));\n', '            }\n', '        }\n', '        \n', '        return tokens;\n', '    }\n', '    \n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        if(_totalRemaining != 0 && _totalRemaining >= _tokenAmount) {\n', '            balances[_beneficiary] = _tokenAmount;\n', '            emit Transfer(address(0),_beneficiary, _tokenAmount);\n', '            _totalRemaining = _totalRemaining.sub(_tokenAmount);\n', '        }\n', '        \n', '        if(_totalRemaining <= 0) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '    \n', '    function _forwardFunds(uint256 _amount) internal {\n', '        wallet.transfer(_amount);\n', '    }\n', '    \n', '    function stopICO() public onlyOwner{\n', '        Open = false;\n', '        if(_totalRemaining != 0){\n', '            uint tenpercentTokens = (_totalRemaining.mul(10)).div(100);\n', '            uint twentypercentTokens = (_totalRemaining.mul(20)).div(100);\n', '            _totalRemaining = _totalRemaining.sub(tenpercentTokens.add(twentypercentTokens));\n', '            emit Transfer(address(0), owner, tenpercentTokens);\n', '            emit Transfer(address(0), wallet, twentypercentTokens);\n', '            _burnRemainingTokens(); // burn the remaining tokens\n', '        }\n', '    }\n', '    \n', '    function _burnRemainingTokens() internal {\n', '        _totalSupply = _totalSupply.sub(_totalRemaining.div(1e18));\n', '    }\n', "    /* ERC20Interface function's implementation */\n", '    function totalSupply() public constant returns (uint){\n', '       return _totalSupply* 10**uint(decimals);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        // prevent transfer to 0x0, use burn instead\n', '        require(to != 0x0);\n', '        require(balances[msg.sender] >= tokens );\n', '        require(balances[to] + tokens >= balances[to]);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender,to,tokens);\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success){\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender,spender,tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success){\n', '        require(tokens <= allowed[from][msg.sender]); //check allowance\n', '        require(balances[from] >= tokens);\n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        emit Transfer(from,to,tokens);\n', '        return true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '}']
