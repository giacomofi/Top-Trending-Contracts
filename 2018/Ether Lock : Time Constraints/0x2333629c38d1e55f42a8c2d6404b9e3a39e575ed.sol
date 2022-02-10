['pragma solidity 0.4.24;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract DinoToken is StandardToken, Pausable {\n', '    string public constant name = "DINO Token";\n', '    string public constant symbol = "DINO";\n', '    uint8  public constant decimals = 18;\n', '\n', '    address public  tokenSaleContract;\n', '\n', '    modifier validDestination(address to) {\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    function DinoToken(uint _tokenTotalAmount) public {\n', '        totalSupply = _tokenTotalAmount * (10 ** uint256(decimals));\n', '\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(address(0x0), msg.sender, totalSupply);\n', '\n', '        tokenSaleContract = msg.sender;\n', '    }\n', '\n', '    function transfer(address _to, uint _value)\n', '        public\n', '        validDestination(_to)\n', '        whenNotPaused\n', '        returns (bool) \n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value)\n', '        public\n', '        validDestination(_to)\n', '        whenNotPaused\n', '        returns (bool) \n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract DinoTokenSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '\t// token allocation\n', '    uint public constant TOTAL_DINOTOKEN_SUPPLY  = 200000000;\n', '    uint public constant ALLOC_FOUNDATION       = 40000000e18; // 20%\n', '    uint public constant ALLOC_TEAM             = 30000000e18; // 15%\n', '    uint public constant ALLOC_MARKETING        = 30000000e18; // 15%\n', '    uint public constant ALLOC_ADVISOR          = 10000000e18; // 5%\n', '    uint public constant ALLOC_SALE             = 90000000e18; // 45%\n', '\n', '    // sale stage\n', '    uint public constant STAGE1_TIME_END  = 9 days; \n', '    uint public constant STAGE2_TIME_END  = 20 days; \n', '    uint public constant STAGE3_TIME_END  = 35 days; \n', '\n', '    // Token sale rate from ETH to DINO\n', '    uint public constant RATE_PRESALE      = 4000; // +25%\n', '    uint public constant RATE_CROWDSALE_S1 = 3680; // +15%\n', '    uint public constant RATE_CROWDSALE_S2 = 3424; // +7%\n', '    uint public constant RATE_CROWDSALE_S3 = 3200; // +0%\n', '\n', '\t// For token transfer\n', '    address public constant WALLET_FOUNDATION = 0x9bd5ae7400ce11b418a4ef9e9310fbd0c2f5e503; \n', '    address public constant WALLET_TEAM       = 0x9bb148948a75a5b205b4d13efb9fe893c8c8fb7b; \n', '    address public constant WALLET_MARKETING  = 0x83e5e7f8f90c90a0b8948dc2c1116f8c0dcf10d8; \n', '    address public constant WALLET_ADVISOR    = 0x5c166aa48503fbec223fa06d2757af01850d60f7; \n', '\n', '    // For ether transfer\n', '    address private constant WALLET_ETH_DINO  = 0x191B29ADbCA5Ecb285005Cff15441F8411DF5f72; \n', '    address private constant WALLET_ETH_ADMIN = 0xAba33f3a098f7f0AC9B60614e395A40406e97915; \n', '\n', '    DinoToken public dinoToken; \n', '\n', '    uint256 public presaleStartTime = 1528416000; // 2018-6-8 8:00 (UTC+8) 1528416000\n', '    uint256 public startTime        = 1528848000; // 2018-6-13 8:00 (UTC+8) 1528848000\n', '    uint256 public endTime          = 1531872000; // 2018-7-18 8:00 (UTC+8) 1531872000\n', '    bool public halted;\n', '\n', '    mapping(address=>bool) public whitelisted_Presale;\n', '\n', '    // stats\n', '    uint256 public totalDinoSold;\n', '    uint256 public weiRaised;\n', '    mapping(address => uint256) public weiContributions;\n', '\n', '    // EVENTS\n', '    event updatedPresaleWhitelist(address target, bool isWhitelisted);\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '\n', '    function DinoTokenSale() public {\n', '        dinoToken = new DinoToken(TOTAL_DINOTOKEN_SUPPLY);\n', '        dinoToken.transfer(WALLET_FOUNDATION, ALLOC_FOUNDATION);\n', '        dinoToken.transfer(WALLET_TEAM, ALLOC_TEAM);\n', '        dinoToken.transfer(WALLET_MARKETING, ALLOC_MARKETING);\n', '        dinoToken.transfer(WALLET_ADVISOR, ALLOC_ADVISOR);\n', '\n', '        dinoToken.transferOwnership(owner);\n', '    }\n', '\n', '    function updatePresaleWhitelist(address[] _targets, bool _isWhitelisted)\n', '        public\n', '        onlyOwner\n', '    {\n', '        for (uint i = 0; i < _targets.length; i++) {\n', '            whitelisted_Presale[_targets[i]] = _isWhitelisted;\n', '            emit updatedPresaleWhitelist(_targets[i], _isWhitelisted);\n', '        }\n', '    }\n', '\n', '    function validPurchase() \n', '        internal \n', '        returns(bool) \n', '    {\n', '        bool withinPeriod = now >= presaleStartTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '        return withinPeriod && nonZeroPurchase && !halted;\n', '    }\n', '\n', '    function getPriceRate()\n', '        public\n', '        view\n', '        returns (uint)\n', '    {\n', '        if (now <= startTime) return 0;\n', '        if (now <= startTime + STAGE1_TIME_END) return RATE_CROWDSALE_S1;\n', '        if (now <= startTime + STAGE2_TIME_END) return RATE_CROWDSALE_S2;\n', '        if (now <= startTime + STAGE3_TIME_END) return RATE_CROWDSALE_S3;\n', '        return 0;\n', '    }\n', '\n', '    function ()\n', '        public \n', '        payable \n', '    {\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '        uint256 purchaseTokens;\n', '\n', '        if (whitelisted_Presale[msg.sender]) \n', '            purchaseTokens = weiAmount.mul(RATE_PRESALE); \n', '        else\n', '            purchaseTokens = weiAmount.mul(getPriceRate()); \n', '\n', '        require(purchaseTokens > 0 && ALLOC_SALE - totalDinoSold >= purchaseTokens); // supply check\n', '        require(dinoToken.transfer(msg.sender, purchaseTokens));\n', '        emit TokenPurchase(msg.sender, weiAmount, purchaseTokens);\n', '\n', '        totalDinoSold = totalDinoSold.add(purchaseTokens); \n', '        weiRaised = weiRaised.add(weiAmount);\n', '        weiContributions[msg.sender] = weiContributions[msg.sender].add(weiAmount);\n', '        \n', '        forwardFunds();\n', '    }\n', '\n', '    function forwardFunds() \n', '        internal \n', '    {\n', '        WALLET_ETH_DINO.transfer((msg.value).mul(91).div(100));\n', '        WALLET_ETH_ADMIN.transfer((msg.value).mul(9).div(100));\n', '    }\n', '\n', '    function hasEnded() \n', '        public \n', '        view\n', '        returns(bool) \n', '    {\n', '        return now > endTime;\n', '    }\n', '\n', '    function toggleHalt(bool _halted)\n', '        public\n', '        onlyOwner\n', '    {\n', '        halted = _halted;\n', '    }\n', '\n', '    function drainToken(address _to, uint256 _amount) \n', '        public\n', '        onlyOwner\n', '    {\n', '        require(dinoToken.balanceOf(this) >= _amount);\n', '        dinoToken.transfer(_to, _amount);\n', '    }\n', '\n', '    function drainRemainingToken(address _to) \n', '        public\n', '        onlyOwner\n', '    {\n', '        require(hasEnded());\n', '        dinoToken.transfer(_to, dinoToken.balanceOf(this));\n', '    }\n', '\n', '    function safeDrain() \n', '        public\n', '        onlyOwner\n', '    {\n', '        WALLET_ETH_ADMIN.transfer(this.balance);\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract DinoToken is StandardToken, Pausable {\n', '    string public constant name = "DINO Token";\n', '    string public constant symbol = "DINO";\n', '    uint8  public constant decimals = 18;\n', '\n', '    address public  tokenSaleContract;\n', '\n', '    modifier validDestination(address to) {\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    function DinoToken(uint _tokenTotalAmount) public {\n', '        totalSupply = _tokenTotalAmount * (10 ** uint256(decimals));\n', '\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(address(0x0), msg.sender, totalSupply);\n', '\n', '        tokenSaleContract = msg.sender;\n', '    }\n', '\n', '    function transfer(address _to, uint _value)\n', '        public\n', '        validDestination(_to)\n', '        whenNotPaused\n', '        returns (bool) \n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value)\n', '        public\n', '        validDestination(_to)\n', '        whenNotPaused\n', '        returns (bool) \n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract DinoTokenSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '\t// token allocation\n', '    uint public constant TOTAL_DINOTOKEN_SUPPLY  = 200000000;\n', '    uint public constant ALLOC_FOUNDATION       = 40000000e18; // 20%\n', '    uint public constant ALLOC_TEAM             = 30000000e18; // 15%\n', '    uint public constant ALLOC_MARKETING        = 30000000e18; // 15%\n', '    uint public constant ALLOC_ADVISOR          = 10000000e18; // 5%\n', '    uint public constant ALLOC_SALE             = 90000000e18; // 45%\n', '\n', '    // sale stage\n', '    uint public constant STAGE1_TIME_END  = 9 days; \n', '    uint public constant STAGE2_TIME_END  = 20 days; \n', '    uint public constant STAGE3_TIME_END  = 35 days; \n', '\n', '    // Token sale rate from ETH to DINO\n', '    uint public constant RATE_PRESALE      = 4000; // +25%\n', '    uint public constant RATE_CROWDSALE_S1 = 3680; // +15%\n', '    uint public constant RATE_CROWDSALE_S2 = 3424; // +7%\n', '    uint public constant RATE_CROWDSALE_S3 = 3200; // +0%\n', '\n', '\t// For token transfer\n', '    address public constant WALLET_FOUNDATION = 0x9bd5ae7400ce11b418a4ef9e9310fbd0c2f5e503; \n', '    address public constant WALLET_TEAM       = 0x9bb148948a75a5b205b4d13efb9fe893c8c8fb7b; \n', '    address public constant WALLET_MARKETING  = 0x83e5e7f8f90c90a0b8948dc2c1116f8c0dcf10d8; \n', '    address public constant WALLET_ADVISOR    = 0x5c166aa48503fbec223fa06d2757af01850d60f7; \n', '\n', '    // For ether transfer\n', '    address private constant WALLET_ETH_DINO  = 0x191B29ADbCA5Ecb285005Cff15441F8411DF5f72; \n', '    address private constant WALLET_ETH_ADMIN = 0xAba33f3a098f7f0AC9B60614e395A40406e97915; \n', '\n', '    DinoToken public dinoToken; \n', '\n', '    uint256 public presaleStartTime = 1528416000; // 2018-6-8 8:00 (UTC+8) 1528416000\n', '    uint256 public startTime        = 1528848000; // 2018-6-13 8:00 (UTC+8) 1528848000\n', '    uint256 public endTime          = 1531872000; // 2018-7-18 8:00 (UTC+8) 1531872000\n', '    bool public halted;\n', '\n', '    mapping(address=>bool) public whitelisted_Presale;\n', '\n', '    // stats\n', '    uint256 public totalDinoSold;\n', '    uint256 public weiRaised;\n', '    mapping(address => uint256) public weiContributions;\n', '\n', '    // EVENTS\n', '    event updatedPresaleWhitelist(address target, bool isWhitelisted);\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '\n', '    function DinoTokenSale() public {\n', '        dinoToken = new DinoToken(TOTAL_DINOTOKEN_SUPPLY);\n', '        dinoToken.transfer(WALLET_FOUNDATION, ALLOC_FOUNDATION);\n', '        dinoToken.transfer(WALLET_TEAM, ALLOC_TEAM);\n', '        dinoToken.transfer(WALLET_MARKETING, ALLOC_MARKETING);\n', '        dinoToken.transfer(WALLET_ADVISOR, ALLOC_ADVISOR);\n', '\n', '        dinoToken.transferOwnership(owner);\n', '    }\n', '\n', '    function updatePresaleWhitelist(address[] _targets, bool _isWhitelisted)\n', '        public\n', '        onlyOwner\n', '    {\n', '        for (uint i = 0; i < _targets.length; i++) {\n', '            whitelisted_Presale[_targets[i]] = _isWhitelisted;\n', '            emit updatedPresaleWhitelist(_targets[i], _isWhitelisted);\n', '        }\n', '    }\n', '\n', '    function validPurchase() \n', '        internal \n', '        returns(bool) \n', '    {\n', '        bool withinPeriod = now >= presaleStartTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '        return withinPeriod && nonZeroPurchase && !halted;\n', '    }\n', '\n', '    function getPriceRate()\n', '        public\n', '        view\n', '        returns (uint)\n', '    {\n', '        if (now <= startTime) return 0;\n', '        if (now <= startTime + STAGE1_TIME_END) return RATE_CROWDSALE_S1;\n', '        if (now <= startTime + STAGE2_TIME_END) return RATE_CROWDSALE_S2;\n', '        if (now <= startTime + STAGE3_TIME_END) return RATE_CROWDSALE_S3;\n', '        return 0;\n', '    }\n', '\n', '    function ()\n', '        public \n', '        payable \n', '    {\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '        uint256 purchaseTokens;\n', '\n', '        if (whitelisted_Presale[msg.sender]) \n', '            purchaseTokens = weiAmount.mul(RATE_PRESALE); \n', '        else\n', '            purchaseTokens = weiAmount.mul(getPriceRate()); \n', '\n', '        require(purchaseTokens > 0 && ALLOC_SALE - totalDinoSold >= purchaseTokens); // supply check\n', '        require(dinoToken.transfer(msg.sender, purchaseTokens));\n', '        emit TokenPurchase(msg.sender, weiAmount, purchaseTokens);\n', '\n', '        totalDinoSold = totalDinoSold.add(purchaseTokens); \n', '        weiRaised = weiRaised.add(weiAmount);\n', '        weiContributions[msg.sender] = weiContributions[msg.sender].add(weiAmount);\n', '        \n', '        forwardFunds();\n', '    }\n', '\n', '    function forwardFunds() \n', '        internal \n', '    {\n', '        WALLET_ETH_DINO.transfer((msg.value).mul(91).div(100));\n', '        WALLET_ETH_ADMIN.transfer((msg.value).mul(9).div(100));\n', '    }\n', '\n', '    function hasEnded() \n', '        public \n', '        view\n', '        returns(bool) \n', '    {\n', '        return now > endTime;\n', '    }\n', '\n', '    function toggleHalt(bool _halted)\n', '        public\n', '        onlyOwner\n', '    {\n', '        halted = _halted;\n', '    }\n', '\n', '    function drainToken(address _to, uint256 _amount) \n', '        public\n', '        onlyOwner\n', '    {\n', '        require(dinoToken.balanceOf(this) >= _amount);\n', '        dinoToken.transfer(_to, _amount);\n', '    }\n', '\n', '    function drainRemainingToken(address _to) \n', '        public\n', '        onlyOwner\n', '    {\n', '        require(hasEnded());\n', '        dinoToken.transfer(_to, dinoToken.balanceOf(this));\n', '    }\n', '\n', '    function safeDrain() \n', '        public\n', '        onlyOwner\n', '    {\n', '        WALLET_ETH_ADMIN.transfer(this.balance);\n', '    }\n', '}']