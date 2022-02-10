['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c; \n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract BasicTokenERC20 {  \n', '    using SafeMath for uint256;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    mapping (uint8 => mapping (address => uint256)) internal whitelist;\n', '\n', '    uint256 totalSupply_;\n', '    address public owner_;\n', '    \n', '    constructor() public {\n', '        owner_ = msg.sender;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return balances[owner];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        require(to != address(0));\n', '        require(value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    } \n', '    \n', '    function transferFrom(address from, address to, uint256 value) public returns (bool){\n', '        require(to != address(0));\n', '        require(value <= balances[from]);\n', '        require(value <= allowed[from][msg.sender]);\n', '\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256){\n', '        return allowed[owner][spender];\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner_);\n', '        _;\n', '    }\n', '\n', '    function addWhiteList(uint8 whiteListType, address investor, uint256 value) public onlyOwner returns (bool){\n', '        whitelist[whiteListType][investor] = value;\n', '        return true;\n', '    }\n', '\n', '    function removeFromWhiteList(uint8 whiteListType, address investor) public onlyOwner returns (bool){\n', '        whitelist[whiteListType][investor] = 0;\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract KeowContract is BasicTokenERC20 {    \n', '\n', '    string public constant name = "KeowToken"; \n', '    string public constant symbol = "KEOW";\n', '    uint public decimals = 18; \n', '    uint256 public milion = 1000000;\n', '    event TestLog(address indexed from, address indexed to, uint256 value, uint8 state);\n', '    //// 1 billion tokkens KEOW\n', '    uint256 public INITIAL_SUPPLY = 1000 * milion * (uint256(10) ** decimals);\n', '    //// exchange in 1 eth = 30000 KEOW\n', '    uint256 public exchangeETH = 30000;\n', '    //// limit min ethsale\n', '    uint256 public limitClosedSale = 100 * (uint256(10) ** decimals);\n', '    uint256 public limitPreSale = 25 * (uint256(10) ** decimals);\n', '    \n', '    /// address of wallet\n', '    address public ecoSystemWallet;\n', '    address public marketWallet;\n', '    address public contributorsWallet;\n', '    address public companyWallet;\n', '    address public closedSaleWallet;\n', '    address public preSaleWallet;\n', '    address public firstStageWallet;\n', '    address public secondStageWallet;\n', '\n', '    uint256 public investors = 0;\n', '    address public currentWallet;    \n', '\n', '    /// 0 - Not start/ pause\n', '    /// 1 - closed sale\n', '    /// 2 - presale\n', '    /// 3 - sale1\n', '    /// 4 - sale2\n', '    /// 9 - end    \n', '    uint8 public state = 0;\n', '        \n', '    constructor(address w0, address w1, address w2, address w3, address w4, address w5, address w6, address w7) public {        \n', '        totalSupply_ = INITIAL_SUPPLY;\n', '\n', '        uint256 esoSystemValue = 20 * milion * (uint256(10) ** decimals);\n', '        ecoSystemWallet = w0;    \n', '        balances[ecoSystemWallet] = esoSystemValue;\n', '        emit Transfer(owner_, ecoSystemWallet, esoSystemValue);\n', '\n', '        uint256 marketValue = 50 * milion * (uint256(10) ** decimals);\n', '        marketWallet = w1;\n', '        balances[marketWallet] = marketValue;\n', '        emit Transfer(owner_, marketWallet, marketValue);\n', '\n', '        uint256 contributorsValue = 100 * milion * (uint256(10) ** decimals);\n', '        contributorsWallet = w2;\n', '        balances[contributorsWallet] = contributorsValue;\n', '        emit Transfer(owner_, contributorsWallet, contributorsValue);\n', '\n', '        uint256 companyValue = 230 * milion * (uint256(10) ** decimals);\n', '        companyWallet = w3;\n', '        balances[companyWallet] = companyValue;\n', '        emit Transfer(owner_, companyWallet, companyValue);\n', '        \n', '        uint256 closedSaleValue = 50 * milion * (uint256(10) ** decimals);\n', '        closedSaleWallet = w4;\n', '        balances[closedSaleWallet] = closedSaleValue;\n', '        emit Transfer(owner_, closedSaleWallet, closedSaleValue);\n', '\n', '        uint256 preSaleValue = 50 * milion * (uint256(10) ** decimals);\n', '        preSaleWallet = w5;\n', '        balances[preSaleWallet] = preSaleValue;\n', '        emit Transfer(owner_, preSaleWallet, preSaleValue);\n', '\n', '        uint256 firstStageValue = 250 * milion * (uint256(10) ** decimals);\n', '        firstStageWallet = w6;\n', '        balances[firstStageWallet] = firstStageValue;\n', '        emit Transfer(owner_, firstStageWallet, firstStageValue);\n', '\n', '        uint256 secondStageValue = 250 * milion * (uint256(10) ** decimals);\n', '        secondStageWallet = w7; \n', '        balances[secondStageWallet] = secondStageValue;\n', '        emit Transfer(owner_, secondStageWallet, secondStageValue);\n', '    }    \n', '\n', '    function () public payable {\n', '        require(state > 0);\n', '        require(state < 9);\n', '        require(msg.sender != 0x0);\n', '        require(msg.value != 0);\n', '        uint256 limit = getMinLimit();\n', '        \n', '        require(msg.value >= limit);\n', '        address beneficiary = msg.sender;\n', '        require(whitelist[state][beneficiary] >= msg.value);\n', '        \n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = weiAmount.mul(exchangeETH);\n', '        require(balances[currentWallet] >= tokens);\n', '        \n', '        balances[currentWallet] = balances[currentWallet].sub(tokens);\n', '        balances[beneficiary] = balances[beneficiary].add(tokens); \n', '        \n', '        emit Transfer(currentWallet, beneficiary, tokens);\n', '        \n', '        whitelist[state][beneficiary] = 0;\n', '        investors++;        \n', '    }\n', '    \n', '    function getMinLimit () public view returns (uint256) {        \n', '        if (state == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        if (state == 1) {\n', '            return limitClosedSale;\n', '        }\n', '        \n', '        if (state == 2) {\n', '            return limitPreSale;\n', '        }\n', '        \n', '        return 1;\n', '    }\n', '\n', '    function updateExchangeRate(uint256 updateExchange) public onlyOwner {\n', '        exchangeETH = updateExchange;\n', '    }\n', '\n', '    function withdraw(uint value) public onlyOwner {\n', '        require(value > 0);\n', '        require(companyWallet != 0x0);        \n', '        companyWallet.transfer(value);\n', '    }\n', '\n', '    function startCloseSalePhase() public onlyOwner { \n', '        currentWallet = closedSaleWallet;      \n', '        state = 1;\n', '    }\n', '\n', '    function startPreSalePhase() public onlyOwner {        \n', '        currentWallet = preSaleWallet;\n', '        state = 2;\n', '    }\n', '\n', '    function startSale1Phase() public onlyOwner {        \n', '        currentWallet = firstStageWallet;\n', '        state = 3;\n', '    }\n', '\n', '    function startSale2Phase() public onlyOwner {        \n', '        currentWallet = secondStageWallet;\n', '        state = 4;\n', '    }    \n', '\n', '    function stopSale() public onlyOwner {        \n', '        currentWallet = 0;\n', '        state = 0;\n', '    }    \n', '\n', '    function endSale () public onlyOwner {\n', '        currentWallet = 0;\n', '        state = 9;\n', '    }        \n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c; \n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract BasicTokenERC20 {  \n', '    using SafeMath for uint256;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    mapping (uint8 => mapping (address => uint256)) internal whitelist;\n', '\n', '    uint256 totalSupply_;\n', '    address public owner_;\n', '    \n', '    constructor() public {\n', '        owner_ = msg.sender;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return balances[owner];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        require(to != address(0));\n', '        require(value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    } \n', '    \n', '    function transferFrom(address from, address to, uint256 value) public returns (bool){\n', '        require(to != address(0));\n', '        require(value <= balances[from]);\n', '        require(value <= allowed[from][msg.sender]);\n', '\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256){\n', '        return allowed[owner][spender];\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner_);\n', '        _;\n', '    }\n', '\n', '    function addWhiteList(uint8 whiteListType, address investor, uint256 value) public onlyOwner returns (bool){\n', '        whitelist[whiteListType][investor] = value;\n', '        return true;\n', '    }\n', '\n', '    function removeFromWhiteList(uint8 whiteListType, address investor) public onlyOwner returns (bool){\n', '        whitelist[whiteListType][investor] = 0;\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract KeowContract is BasicTokenERC20 {    \n', '\n', '    string public constant name = "KeowToken"; \n', '    string public constant symbol = "KEOW";\n', '    uint public decimals = 18; \n', '    uint256 public milion = 1000000;\n', '    event TestLog(address indexed from, address indexed to, uint256 value, uint8 state);\n', '    //// 1 billion tokkens KEOW\n', '    uint256 public INITIAL_SUPPLY = 1000 * milion * (uint256(10) ** decimals);\n', '    //// exchange in 1 eth = 30000 KEOW\n', '    uint256 public exchangeETH = 30000;\n', '    //// limit min ethsale\n', '    uint256 public limitClosedSale = 100 * (uint256(10) ** decimals);\n', '    uint256 public limitPreSale = 25 * (uint256(10) ** decimals);\n', '    \n', '    /// address of wallet\n', '    address public ecoSystemWallet;\n', '    address public marketWallet;\n', '    address public contributorsWallet;\n', '    address public companyWallet;\n', '    address public closedSaleWallet;\n', '    address public preSaleWallet;\n', '    address public firstStageWallet;\n', '    address public secondStageWallet;\n', '\n', '    uint256 public investors = 0;\n', '    address public currentWallet;    \n', '\n', '    /// 0 - Not start/ pause\n', '    /// 1 - closed sale\n', '    /// 2 - presale\n', '    /// 3 - sale1\n', '    /// 4 - sale2\n', '    /// 9 - end    \n', '    uint8 public state = 0;\n', '        \n', '    constructor(address w0, address w1, address w2, address w3, address w4, address w5, address w6, address w7) public {        \n', '        totalSupply_ = INITIAL_SUPPLY;\n', '\n', '        uint256 esoSystemValue = 20 * milion * (uint256(10) ** decimals);\n', '        ecoSystemWallet = w0;    \n', '        balances[ecoSystemWallet] = esoSystemValue;\n', '        emit Transfer(owner_, ecoSystemWallet, esoSystemValue);\n', '\n', '        uint256 marketValue = 50 * milion * (uint256(10) ** decimals);\n', '        marketWallet = w1;\n', '        balances[marketWallet] = marketValue;\n', '        emit Transfer(owner_, marketWallet, marketValue);\n', '\n', '        uint256 contributorsValue = 100 * milion * (uint256(10) ** decimals);\n', '        contributorsWallet = w2;\n', '        balances[contributorsWallet] = contributorsValue;\n', '        emit Transfer(owner_, contributorsWallet, contributorsValue);\n', '\n', '        uint256 companyValue = 230 * milion * (uint256(10) ** decimals);\n', '        companyWallet = w3;\n', '        balances[companyWallet] = companyValue;\n', '        emit Transfer(owner_, companyWallet, companyValue);\n', '        \n', '        uint256 closedSaleValue = 50 * milion * (uint256(10) ** decimals);\n', '        closedSaleWallet = w4;\n', '        balances[closedSaleWallet] = closedSaleValue;\n', '        emit Transfer(owner_, closedSaleWallet, closedSaleValue);\n', '\n', '        uint256 preSaleValue = 50 * milion * (uint256(10) ** decimals);\n', '        preSaleWallet = w5;\n', '        balances[preSaleWallet] = preSaleValue;\n', '        emit Transfer(owner_, preSaleWallet, preSaleValue);\n', '\n', '        uint256 firstStageValue = 250 * milion * (uint256(10) ** decimals);\n', '        firstStageWallet = w6;\n', '        balances[firstStageWallet] = firstStageValue;\n', '        emit Transfer(owner_, firstStageWallet, firstStageValue);\n', '\n', '        uint256 secondStageValue = 250 * milion * (uint256(10) ** decimals);\n', '        secondStageWallet = w7; \n', '        balances[secondStageWallet] = secondStageValue;\n', '        emit Transfer(owner_, secondStageWallet, secondStageValue);\n', '    }    \n', '\n', '    function () public payable {\n', '        require(state > 0);\n', '        require(state < 9);\n', '        require(msg.sender != 0x0);\n', '        require(msg.value != 0);\n', '        uint256 limit = getMinLimit();\n', '        \n', '        require(msg.value >= limit);\n', '        address beneficiary = msg.sender;\n', '        require(whitelist[state][beneficiary] >= msg.value);\n', '        \n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = weiAmount.mul(exchangeETH);\n', '        require(balances[currentWallet] >= tokens);\n', '        \n', '        balances[currentWallet] = balances[currentWallet].sub(tokens);\n', '        balances[beneficiary] = balances[beneficiary].add(tokens); \n', '        \n', '        emit Transfer(currentWallet, beneficiary, tokens);\n', '        \n', '        whitelist[state][beneficiary] = 0;\n', '        investors++;        \n', '    }\n', '    \n', '    function getMinLimit () public view returns (uint256) {        \n', '        if (state == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        if (state == 1) {\n', '            return limitClosedSale;\n', '        }\n', '        \n', '        if (state == 2) {\n', '            return limitPreSale;\n', '        }\n', '        \n', '        return 1;\n', '    }\n', '\n', '    function updateExchangeRate(uint256 updateExchange) public onlyOwner {\n', '        exchangeETH = updateExchange;\n', '    }\n', '\n', '    function withdraw(uint value) public onlyOwner {\n', '        require(value > 0);\n', '        require(companyWallet != 0x0);        \n', '        companyWallet.transfer(value);\n', '    }\n', '\n', '    function startCloseSalePhase() public onlyOwner { \n', '        currentWallet = closedSaleWallet;      \n', '        state = 1;\n', '    }\n', '\n', '    function startPreSalePhase() public onlyOwner {        \n', '        currentWallet = preSaleWallet;\n', '        state = 2;\n', '    }\n', '\n', '    function startSale1Phase() public onlyOwner {        \n', '        currentWallet = firstStageWallet;\n', '        state = 3;\n', '    }\n', '\n', '    function startSale2Phase() public onlyOwner {        \n', '        currentWallet = secondStageWallet;\n', '        state = 4;\n', '    }    \n', '\n', '    function stopSale() public onlyOwner {        \n', '        currentWallet = 0;\n', '        state = 0;\n', '    }    \n', '\n', '    function endSale () public onlyOwner {\n', '        currentWallet = 0;\n', '        state = 9;\n', '    }        \n', '}']