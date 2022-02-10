['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-20\n', '*/\n', '\n', 'pragma solidity 0.6.0;\n', '\n', '\n', 'abstract contract IERC20 {\n', '    \n', '    function totalSupply() virtual public view returns (uint);\n', '    function balanceOf(address tokenOwner) virtual public view returns (uint);\n', '    function allowance(address tokenOwner, address spender) virtual public view returns (uint);\n', '    function transfer(address to, uint tokens) virtual public returns (bool);\n', '    function approve(address spender, uint tokens) virtual public returns (bool);\n', '    function transferFrom(address from, address to, uint tokens) virtual public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Buyerlist(address indexed tokenHolder);\n', '    event issueDivi(address indexed tokenHolder,uint256 amount);\n', '    event startSale(uint256 fromtime,uint256 totime,uint256 rate,uint256 supply);\n', '}\n', '\n', '\n', 'contract SafeMath {\n', '    \n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '    \n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '    \n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract AssetBackedCurrency is IERC20, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals; \n', '    \n', '    uint256 public _totalSupply;\n', '    uint256 public _circulating_supply;\n', '    uint256 public _sold;\n', '    address public owner;\n', '    address private feecollectaddress=0x222926cA4E89Dc1D6099b98C663efd3b0f60f474;\n', '    bool public isMinting;\n', '    uint256 public RATE;\n', '    uint256 public Start;\n', '    uint256 public End;\n', '    uint256 total;\n', '    address private referaddr=0x0000000000000000000000000000000000000000;\n', '    uint256 private referamt=0;\n', '    \n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    constructor() payable public {\n', '        name = "Asset Backed Currency";\n', '        symbol = "ABC";\n', '        decimals = 0;\n', '        owner = msg.sender;\n', '        isMinting = true;\n', '        RATE = 1;\n', '        _totalSupply = 10000000000000 * 10 ** uint256(decimals);   // 24 decimals \n', '        balances[msg.sender] = _totalSupply;\n', '        _circulating_supply = 0;\n', '        _sold=0;\n', '        address(uint160(referamt)).transfer(referamt);\n', '        address(uint160(feecollectaddress)).transfer(safeSub(msg.value,referamt));\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "UnAuthorized");\n', '         _;\n', '     }\n', '    \n', '    /**\n', '     * @dev allowance : Check approved balance\n', '     */\n', '    function allowance(address tokenOwner, address spender) virtual override public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    /**\n', '     * @dev approve : Approve token for spender\n', '     */ \n', '    function approve(address spender, uint tokens) virtual override public returns (bool success) {\n', '        require(tokens >= 0, "Invalid value");\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev transfer : Transfer token to another etherum address\n', '     */ \n', '    function transfer(address to, uint tokens) virtual override public returns (bool success) {\n', '        require(to != address(0), "Null address");                                         \n', '        require(tokens > 0, "Invalid Value");\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev transferFrom : Transfer token after approval \n', '     */ \n', '    function transferFrom(address from, address to, uint tokens) virtual override public returns (bool success) {\n', '        require(to != address(0), "Null address");\n', '        require(from != address(0), "Null address");\n', '        require(tokens > 0, "Invalid value"); \n', '        require(tokens <= balances[from], "Insufficient balance");\n', '        require(tokens <= allowed[from][msg.sender], "Insufficient allowance");\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev totalSupply : Display total supply of token\n', '     */ \n', '    function totalSupply() virtual override public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '      function circulatingSupply() virtual public view returns (uint) {\n', '        return _circulating_supply;\n', '    }\n', '    \n', '    \n', '     function sold() virtual public view returns (uint) {\n', '        return _sold;\n', '    }\n', '    /**\n', '     * @dev balanceOf : Displya token balance of given address\n', '     */ \n', '    function balanceOf(address tokenOwner) virtual override public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    \n', '    function buyTokens(uint256 tokens) payable public {\n', '        if(isMinting==true && Start <= block.timestamp && End >= block.timestamp)\n', '        {\n', '             require(msg.value > 0);\n', '             require(_totalSupply >= _sold,"Token sold");\n', '             uint256 value = safeMul(tokens,RATE);\n', '             value=safeDiv(value,(10**(decimals)));\n', '             require(msg.value==value);\n', '             require(_circulating_supply >= tokens,"Circulating supply not enough");\n', '             address(uint160(owner)).transfer(msg.value);\n', '             _circulating_supply = safeSub(_circulating_supply,tokens);\n', '             _sold=safeAdd(_sold,tokens);\n', '             balances[owner]=safeSub(balances[owner],tokens);\n', '             balances[msg.sender] = safeAdd(balances[msg.sender], tokens);\n', '             if(balances[msg.sender]==tokens){\n', '                  emit Buyerlist(msg.sender);\n', '            }\n', '            emit Transfer(owner,msg.sender, tokens);\n', '              \n', '        }\n', '        else\n', '        {\n', '            revert("isMiniting False");\n', '        }\n', '    }\n', '    \n', '    \n', '\n', '    function endCrowdsale() onlyOwner public {\n', '        isMinting = false;\n', '    }\n', '\n', '    function changeCrowdsaleRate(uint256 _value) onlyOwner public {\n', '        RATE = _value;\n', '    }\n', '    \n', '    function startCrowdsale(uint256 _fromtime,uint256 _totime,uint256 _rate, uint256 supply) onlyOwner public returns(bool){\n', '        require(safeAdd(_sold,supply) <= _totalSupply, "Token sold issue");\n', '        Start=_fromtime;\n', '        End=_totime;\n', '        RATE=_rate;\n', '        isMinting = true;\n', '        _circulating_supply=safeAdd(_circulating_supply,supply);\n', '        emit startSale(_fromtime,_totime,_rate,supply);\n', '        return true;\n', '    }\n', '    \n', '    function getblocktime() public view returns(uint256)\n', '    {\n', '        return block.timestamp;\n', '    }\n', '    \n', '    function issueDivident(address[] memory addr,uint256[] memory amount) payable public onlyOwner returns(bool){\n', '        require(amount.length > 0,"Enter valid amount");\n', '        for(uint256 i; i < amount.length;i++)\n', '        {\n', '            address(uint160(addr[i])).transfer(amount[i]);\n', '            emit issueDivi(addr[i],amount[i]);\n', '        }\n', '    }\n', '    \n', '     /**\n', '     * @dev burn : To decrease total supply of tokens\n', '     */ \n', '    function burn(uint256 _amount) public onlyOwner returns (bool) {\n', '        require(_amount >= 0, "Invalid amount");\n', '        require(_amount <= balances[msg.sender], "Insufficient Balance");\n', '        _totalSupply = safeSub(_totalSupply, _amount);\n', '        balances[owner] = safeSub(balances[owner], _amount);\n', '        emit Transfer(owner, address(0), _amount);\n', '        return true;\n', '    }\n', '    \n', '      function mint(uint256 _amount) public onlyOwner returns (bool) {\n', '        require(_amount >= 0, "Invalid amount");\n', '        _totalSupply = safeAdd(_totalSupply, _amount);\n', '         balances[owner] = safeAdd(balances[owner], _amount);\n', '        return true;\n', '    }\n', ' \n', '     receive() external payable {\n', '     revert("Incorrect Function access");\n', '    }\n', '\n', '\n', '}']