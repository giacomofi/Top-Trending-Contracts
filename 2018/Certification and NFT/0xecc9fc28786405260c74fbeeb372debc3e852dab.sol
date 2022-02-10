['pragma solidity 0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '/**\n', ' * @title ViteCoinICO\n', ' * @dev   ViteCoinICO accepting contributions only within a time frame.\n', ' */\n', 'contract ViteCoinICO is ERC20Interface, Owned {\n', '  using SafeMath for uint256;\n', '  string  public symbol; \n', '  string  public name;\n', '  uint8   public decimals;\n', '  uint256 public fundsRaised;         \n', '  uint256 public privateSaleTokens;\n', '  uint256 public preSaleTokens;\n', '  uint256 public saleTokens;\n', '  uint256 public teamAdvTokens;\n', '  uint256 public reserveTokens;\n', '  uint256 public bountyTokens;\n', '  uint256 public hardCap;\n', '  string  internal minTxSize;\n', '  string  internal maxTxSize;\n', '  string  public TokenPrice;\n', '  uint    internal _totalSupply;\n', '  address public wallet;\n', '  uint256 internal privatesaleopeningTime;\n', '  uint256 internal privatesaleclosingTime;\n', '  uint256 internal presaleopeningTime;\n', '  uint256 internal presaleclosingTime;\n', '  uint256 internal saleopeningTime;\n', '  uint256 internal saleclosingTime;\n', '  bool    internal privatesaleOpen;\n', '  bool    internal presaleOpen;\n', '  bool    internal saleOpen;\n', '  bool    internal Open;\n', '  \n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '    modifier onlyWhileOpen {\n', '        require(now >= privatesaleopeningTime && now <= (saleclosingTime + 30 days) && Open);\n', '        _;\n', '    }\n', '  \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor (address _owner, address _wallet) public {\n', '        _allocateTokens();\n', '        _setTimes();\n', '    \n', '        symbol = "VT";\n', '        name = "Vitecoin";\n', '        decimals = 18;\n', '        owner = _owner;\n', '        wallet = _wallet;\n', '        _totalSupply = 200000000;\n', '        Open = true;\n', '        balances[this] = totalSupply();\n', '        emit Transfer(address(0),this, totalSupply());\n', '    }\n', '    \n', '    function _setTimes() internal{\n', '        privatesaleopeningTime    = 1534723200; // 20th Aug 2018 00:00:00 GMT \n', '        privatesaleclosingTime    = 1541462399; // 05th Nov 2018 23:59:59 GMT   \n', '        presaleopeningTime        = 1541462400; // 06th Nov 2018 00:00:00 GMT \n', '        presaleclosingTime        = 1546214399; // 30th Dec 2018 23:59:59 GMT\n', '        saleopeningTime           = 1546214400; // 31st Dec 2018 00:00:00 GMT\n', '        saleclosingTime           = 1553990399; // 30th Mar 2019 23:59:59 GMT\n', '    }\n', '  \n', '    function _allocateTokens() internal{\n', '        privateSaleTokens     = 10000000;   // 5%\n', '        preSaleTokens         = 80000000;   // 40%\n', '        saleTokens            = 60000000;   // 30%\n', '        teamAdvTokens         = 24000000;   // 12%\n', '        reserveTokens         = 20000000;   // 10%\n', '        bountyTokens          = 6000000;    // 3%\n', '        hardCap               = 36825;      // 36825 eths or 36825*10^18 weis \n', '        minTxSize             = "0,5 ETH"; // (0,5 ETH)\n', '        maxTxSize             = "1000 ETH"; // (1000 ETH)\n', '        TokenPrice            = "$0.05";\n', '        privatesaleOpen       = true;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint){\n', '       return _totalSupply* 10**uint(decimals);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        // prevent transfer to 0x0, use burn instead\n', '        require(to != 0x0);\n', '        require(balances[msg.sender] >= tokens );\n', '        require(balances[to] + tokens >= balances[to]);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender,to,tokens);\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success){\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender,spender,tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success){\n', '        require(tokens <= allowed[from][msg.sender]); //check allowance\n', '        require(balances[from] >= tokens);\n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        emit Transfer(from,to,tokens);\n', '        return true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    function _checkOpenings() internal{\n', '        if(now >= privatesaleopeningTime && now <= privatesaleclosingTime){\n', '          privatesaleOpen = true;\n', '          presaleOpen = false;\n', '          saleOpen = false;\n', '        }\n', '        else if(now >= presaleopeningTime && now <= presaleclosingTime){\n', '          privatesaleOpen = false;\n', '          presaleOpen = true;\n', '          saleOpen = false;\n', '        }\n', '        else if(now >= saleopeningTime && now <= (saleclosingTime + 30 days)){\n', '            privatesaleOpen = false;\n', '            presaleOpen = false;\n', '            saleOpen = true;\n', '        }\n', '        else{\n', '          privatesaleOpen = false;\n', '          presaleOpen = false;\n', '          saleOpen = false;\n', '        }\n', '    }\n', '    \n', '        function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _beneficiary) public payable onlyWhileOpen {\n', '    \n', '        uint256 weiAmount = msg.value;\n', '    \n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '    \n', '        _checkOpenings();\n', '        \n', '        if(privatesaleOpen){\n', '            require(weiAmount >= 5e17  && weiAmount <= 1e21 ,"FUNDS should be MIN 0,5 ETH and Max 1000 ETH");\n', '        }\n', '        else {\n', '            require(weiAmount >= 1e17  && weiAmount <= 5e21 ,"FUNDS should be MIN 0,1 ETH and Max 5000 ETH");\n', '        }\n', '        \n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '        \n', '        if(weiAmount > 50e18){ // greater than 50 eths\n', '            // 10% extra discount\n', '            tokens = tokens.add((tokens.mul(10)).div(100));\n', '        }\n', '        \n', '        // update state\n', '        fundsRaised = fundsRaised.add(weiAmount);\n', '\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(this, _beneficiary, weiAmount, tokens);\n', '\n', '        _forwardFunds(msg.value);\n', '    }\n', '    \n', '        function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '        // require(_weiAmount >= 5e17  && _weiAmount <= 1e21 ,"FUNDS should be MIN 0,5 ETH and Max 1000 ETH");\n', '    }\n', '  \n', '    function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {\n', '        uint256 rate;\n', '        if(privatesaleOpen){\n', '           rate = 10000; //per wei\n', '        }\n', '        else if(presaleOpen){\n', '            rate = 8000; //per wei\n', '        }\n', '        else if(saleOpen){\n', '            rate = 8000; //per wei\n', '        }\n', '        \n', '        return _weiAmount.mul(rate);\n', '    }\n', '    \n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _transfer(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '    \n', '    function _forwardFunds(uint256 _amount) internal {\n', '        wallet.transfer(_amount);\n', '    }\n', '    \n', '    function _transfer(address to, uint tokens) internal returns (bool success) {\n', '        // prevent transfer to 0x0, use burn instead\n', '        require(to != 0x0);\n', '        require(balances[this] >= tokens );\n', '        require(balances[to] + tokens >= balances[to]);\n', '        balances[this] = balances[this].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(this,to,tokens);\n', '        return true;\n', '    }\n', '    \n', '    function freeTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner{\n', '       _transfer(_beneficiary, _tokenAmount);\n', '    }\n', '    \n', '    function stopICO() public onlyOwner{\n', '        Open = false;\n', '    }\n', '    \n', '    function multipleTokensSend (address[] _addresses, uint256[] _values) public onlyOwner{\n', '        for (uint i = 0; i < _addresses.length; i++){\n', '            _transfer(_addresses[i], _values[i]*10**uint(decimals));\n', '        }\n', '    }\n', '    \n', '    function burnRemainingTokens() public onlyOwner{\n', '        balances[this] = 0;\n', '    }\n', '\n', '}']
['pragma solidity 0.4.25;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '/**\n', ' * @title ViteCoinICO\n', ' * @dev   ViteCoinICO accepting contributions only within a time frame.\n', ' */\n', 'contract ViteCoinICO is ERC20Interface, Owned {\n', '  using SafeMath for uint256;\n', '  string  public symbol; \n', '  string  public name;\n', '  uint8   public decimals;\n', '  uint256 public fundsRaised;         \n', '  uint256 public privateSaleTokens;\n', '  uint256 public preSaleTokens;\n', '  uint256 public saleTokens;\n', '  uint256 public teamAdvTokens;\n', '  uint256 public reserveTokens;\n', '  uint256 public bountyTokens;\n', '  uint256 public hardCap;\n', '  string  internal minTxSize;\n', '  string  internal maxTxSize;\n', '  string  public TokenPrice;\n', '  uint    internal _totalSupply;\n', '  address public wallet;\n', '  uint256 internal privatesaleopeningTime;\n', '  uint256 internal privatesaleclosingTime;\n', '  uint256 internal presaleopeningTime;\n', '  uint256 internal presaleclosingTime;\n', '  uint256 internal saleopeningTime;\n', '  uint256 internal saleclosingTime;\n', '  bool    internal privatesaleOpen;\n', '  bool    internal presaleOpen;\n', '  bool    internal saleOpen;\n', '  bool    internal Open;\n', '  \n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '    modifier onlyWhileOpen {\n', '        require(now >= privatesaleopeningTime && now <= (saleclosingTime + 30 days) && Open);\n', '        _;\n', '    }\n', '  \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor (address _owner, address _wallet) public {\n', '        _allocateTokens();\n', '        _setTimes();\n', '    \n', '        symbol = "VT";\n', '        name = "Vitecoin";\n', '        decimals = 18;\n', '        owner = _owner;\n', '        wallet = _wallet;\n', '        _totalSupply = 200000000;\n', '        Open = true;\n', '        balances[this] = totalSupply();\n', '        emit Transfer(address(0),this, totalSupply());\n', '    }\n', '    \n', '    function _setTimes() internal{\n', '        privatesaleopeningTime    = 1534723200; // 20th Aug 2018 00:00:00 GMT \n', '        privatesaleclosingTime    = 1541462399; // 05th Nov 2018 23:59:59 GMT   \n', '        presaleopeningTime        = 1541462400; // 06th Nov 2018 00:00:00 GMT \n', '        presaleclosingTime        = 1546214399; // 30th Dec 2018 23:59:59 GMT\n', '        saleopeningTime           = 1546214400; // 31st Dec 2018 00:00:00 GMT\n', '        saleclosingTime           = 1553990399; // 30th Mar 2019 23:59:59 GMT\n', '    }\n', '  \n', '    function _allocateTokens() internal{\n', '        privateSaleTokens     = 10000000;   // 5%\n', '        preSaleTokens         = 80000000;   // 40%\n', '        saleTokens            = 60000000;   // 30%\n', '        teamAdvTokens         = 24000000;   // 12%\n', '        reserveTokens         = 20000000;   // 10%\n', '        bountyTokens          = 6000000;    // 3%\n', '        hardCap               = 36825;      // 36825 eths or 36825*10^18 weis \n', '        minTxSize             = "0,5 ETH"; // (0,5 ETH)\n', '        maxTxSize             = "1000 ETH"; // (1000 ETH)\n', '        TokenPrice            = "$0.05";\n', '        privatesaleOpen       = true;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint){\n', '       return _totalSupply* 10**uint(decimals);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        // prevent transfer to 0x0, use burn instead\n', '        require(to != 0x0);\n', '        require(balances[msg.sender] >= tokens );\n', '        require(balances[to] + tokens >= balances[to]);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender,to,tokens);\n', '        return true;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success){\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender,spender,tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success){\n', '        require(tokens <= allowed[from][msg.sender]); //check allowance\n', '        require(balances[from] >= tokens);\n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        emit Transfer(from,to,tokens);\n', '        return true;\n', '    }\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    function _checkOpenings() internal{\n', '        if(now >= privatesaleopeningTime && now <= privatesaleclosingTime){\n', '          privatesaleOpen = true;\n', '          presaleOpen = false;\n', '          saleOpen = false;\n', '        }\n', '        else if(now >= presaleopeningTime && now <= presaleclosingTime){\n', '          privatesaleOpen = false;\n', '          presaleOpen = true;\n', '          saleOpen = false;\n', '        }\n', '        else if(now >= saleopeningTime && now <= (saleclosingTime + 30 days)){\n', '            privatesaleOpen = false;\n', '            presaleOpen = false;\n', '            saleOpen = true;\n', '        }\n', '        else{\n', '          privatesaleOpen = false;\n', '          presaleOpen = false;\n', '          saleOpen = false;\n', '        }\n', '    }\n', '    \n', '        function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _beneficiary) public payable onlyWhileOpen {\n', '    \n', '        uint256 weiAmount = msg.value;\n', '    \n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '    \n', '        _checkOpenings();\n', '        \n', '        if(privatesaleOpen){\n', '            require(weiAmount >= 5e17  && weiAmount <= 1e21 ,"FUNDS should be MIN 0,5 ETH and Max 1000 ETH");\n', '        }\n', '        else {\n', '            require(weiAmount >= 1e17  && weiAmount <= 5e21 ,"FUNDS should be MIN 0,1 ETH and Max 5000 ETH");\n', '        }\n', '        \n', '        uint256 tokens = _getTokenAmount(weiAmount);\n', '        \n', '        if(weiAmount > 50e18){ // greater than 50 eths\n', '            // 10% extra discount\n', '            tokens = tokens.add((tokens.mul(10)).div(100));\n', '        }\n', '        \n', '        // update state\n', '        fundsRaised = fundsRaised.add(weiAmount);\n', '\n', '        _processPurchase(_beneficiary, tokens);\n', '        emit TokenPurchase(this, _beneficiary, weiAmount, tokens);\n', '\n', '        _forwardFunds(msg.value);\n', '    }\n', '    \n', '        function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{\n', '        require(_beneficiary != address(0));\n', '        require(_weiAmount != 0);\n', '        // require(_weiAmount >= 5e17  && _weiAmount <= 1e21 ,"FUNDS should be MIN 0,5 ETH and Max 1000 ETH");\n', '    }\n', '  \n', '    function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {\n', '        uint256 rate;\n', '        if(privatesaleOpen){\n', '           rate = 10000; //per wei\n', '        }\n', '        else if(presaleOpen){\n', '            rate = 8000; //per wei\n', '        }\n', '        else if(saleOpen){\n', '            rate = 8000; //per wei\n', '        }\n', '        \n', '        return _weiAmount.mul(rate);\n', '    }\n', '    \n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _transfer(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '    }\n', '    \n', '    function _forwardFunds(uint256 _amount) internal {\n', '        wallet.transfer(_amount);\n', '    }\n', '    \n', '    function _transfer(address to, uint tokens) internal returns (bool success) {\n', '        // prevent transfer to 0x0, use burn instead\n', '        require(to != 0x0);\n', '        require(balances[this] >= tokens );\n', '        require(balances[to] + tokens >= balances[to]);\n', '        balances[this] = balances[this].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(this,to,tokens);\n', '        return true;\n', '    }\n', '    \n', '    function freeTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner{\n', '       _transfer(_beneficiary, _tokenAmount);\n', '    }\n', '    \n', '    function stopICO() public onlyOwner{\n', '        Open = false;\n', '    }\n', '    \n', '    function multipleTokensSend (address[] _addresses, uint256[] _values) public onlyOwner{\n', '        for (uint i = 0; i < _addresses.length; i++){\n', '            _transfer(_addresses[i], _values[i]*10**uint(decimals));\n', '        }\n', '    }\n', '    \n', '    function burnRemainingTokens() public onlyOwner{\n', '        balances[this] = 0;\n', '    }\n', '\n', '}']