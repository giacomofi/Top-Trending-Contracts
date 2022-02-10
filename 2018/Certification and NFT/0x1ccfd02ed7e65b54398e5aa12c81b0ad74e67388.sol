['pragma solidity ^0.4.21;\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // require (_value <= _allowance);\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifing the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnerLog(address a);\n', '\n', '}\n', '\n', 'contract Configurable is Ownable {\n', '\n', '    address public configurer;\n', '\n', '    function Configurable() public {\n', '        configurer = msg.sender;\n', '    }\n', '\n', '    modifier onlyConfigurerOrOwner() {\n', '        require(msg.sender == configurer || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyConfigurer() {\n', '        require(msg.sender == configurer);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract DLCToken is StandardToken, Configurable {\n', '\n', '    string public constant name = "DoubleLand Coin";\n', '    string public constant symbol = "DC";\n', '    uint32 public constant decimals = 18;\n', '\n', '    uint256 public priceOfToken;\n', '\n', '    bool tokenBeenInit = false;\n', '\n', '    uint public constant percentRate = 100;\n', '    uint public investorsTokensPercent;\n', '    uint public foundersTokensPercent;\n', '    uint public bountyTokensPercent;\n', '    uint public developmentAuditPromotionTokensPercent;\n', '\n', '    address public toSaleWallet;\n', '    address public bountyWallet;\n', '    address public foundersWallet;\n', '    address public developmentAuditPromotionWallet;\n', '\n', '    address public saleAgent;\n', '\n', '\n', '    function DLCToken() public {\n', '    }\n', '\n', '    modifier notInit() {\n', '        require(!tokenBeenInit);\n', '        _;\n', '    }\n', '\n', '    function setSaleAgent(address newSaleAgent) public onlyConfigurerOrOwner{\n', '        saleAgent = newSaleAgent;\n', '    }\n', '\n', '    function setPriceOfToken(uint256 newPriceOfToken) public onlyConfigurerOrOwner{\n', '        priceOfToken = newPriceOfToken;\n', '    }\n', '\n', '    function setTotalSupply(uint256 _totalSupply) public notInit onlyConfigurer{\n', '        totalSupply = _totalSupply;\n', '    }\n', '\n', '    function setFoundersTokensPercent(uint _foundersTokensPercent) public notInit onlyConfigurer{\n', '        foundersTokensPercent = _foundersTokensPercent;\n', '    }\n', '\n', '    function setBountyTokensPercent(uint _bountyTokensPercent) public notInit onlyConfigurer{\n', '        bountyTokensPercent = _bountyTokensPercent;\n', '    }\n', '\n', '    function setDevelopmentAuditPromotionTokensPercent(uint _developmentAuditPromotionTokensPercent) public notInit onlyConfigurer{\n', '        developmentAuditPromotionTokensPercent = _developmentAuditPromotionTokensPercent;\n', '    }\n', '\n', '    function setBountyWallet(address _bountyWallet) public notInit onlyConfigurer{\n', '        bountyWallet = _bountyWallet;\n', '    }\n', '\n', '    function setToSaleWallet(address _toSaleWallet) public notInit onlyConfigurer{\n', '        toSaleWallet = _toSaleWallet;\n', '    }\n', '\n', '    function setFoundersWallet(address _foundersWallet) public notInit onlyConfigurer{\n', '        foundersWallet = _foundersWallet;\n', '    }\n', '\n', '    function setDevelopmentAuditPromotionWallet(address _developmentAuditPromotionWallet) public notInit onlyConfigurer {\n', '        developmentAuditPromotionWallet = _developmentAuditPromotionWallet;\n', '    }\n', '\n', '    function init() public notInit onlyConfigurer{\n', '        require(totalSupply > 0);\n', '        require(foundersTokensPercent > 0);\n', '        require(bountyTokensPercent > 0);\n', '        require(developmentAuditPromotionTokensPercent > 0);\n', '        require(foundersWallet != address(0));\n', '        require(bountyWallet != address(0));\n', '        require(developmentAuditPromotionWallet != address(0));\n', '        tokenBeenInit = true;\n', '\n', '        investorsTokensPercent = percentRate - (foundersTokensPercent + bountyTokensPercent + developmentAuditPromotionTokensPercent);\n', '\n', '        balances[toSaleWallet] = totalSupply.mul(investorsTokensPercent).div(percentRate);\n', '        balances[foundersWallet] = totalSupply.mul(foundersTokensPercent).div(percentRate);\n', '        balances[bountyWallet] = totalSupply.mul(bountyTokensPercent).div(percentRate);\n', '        balances[developmentAuditPromotionWallet] = totalSupply.mul(developmentAuditPromotionTokensPercent).div(percentRate);\n', '    }\n', '\n', '    function getRestTokenBalance() public constant returns (uint256) {\n', '        return balances[toSaleWallet];\n', '    }\n', '\n', '    function purchase(address beneficiary, uint256 qty) public {\n', '        require(msg.sender == saleAgent || msg.sender == owner);\n', '        require(beneficiary != address(0));\n', '        require(qty > 0);\n', '        require((getRestTokenBalance().sub(qty)) > 0);\n', '\n', '        balances[beneficiary] = balances[beneficiary].add(qty);\n', '        balances[toSaleWallet] = balances[toSaleWallet].sub(qty);\n', '\n', '        emit Transfer(toSaleWallet, beneficiary, qty);\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}\n', '\n', 'contract Bonuses {\n', '    using SafeMath for uint256;\n', '\n', '    DLCToken public token;\n', '\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    mapping(uint => uint256) public bonusOfDay;\n', '\n', '    bool public bonusInited = false;\n', '\n', '    function initBonuses (string _preset) public {\n', '        require(!bonusInited);\n', '        bonusInited = true;\n', '        bytes32 preset = keccak256(_preset);\n', '\n', '        if(preset == keccak256(&#39;privatesale&#39;)){\n', '            bonusOfDay[0] = 313;\n', '        } else\n', '        if(preset == keccak256(&#39;presale&#39;)){\n', '            bonusOfDay[0] = 210;\n', '        } else\n', '        if(preset == keccak256(&#39;generalsale&#39;)){\n', '            bonusOfDay[0] = 60;\n', '            bonusOfDay[7] = 38;\n', '            bonusOfDay[14] = 10;\n', '        }\n', '    }\n', '\n', '    function calculateTokensQtyByEther(uint256 amount) public constant returns(uint256) {\n', '        int dayOfStart = int(now.sub(startTime).div(86400).add(1));\n', '        uint currentBonus = 0;\n', '        int i;\n', '\n', '        for (i = dayOfStart; i >= 0; i--) {\n', '            if (bonusOfDay[uint(i)] > 0) {\n', '                currentBonus = bonusOfDay[uint(i)];\n', '                break;\n', '            }\n', '        }\n', '\n', '        return amount.div(token.priceOfToken()).mul(currentBonus + 100).div(100).mul(1 ether);\n', '    }\n', '}\n', '\n', 'contract Sale is Configurable, Bonuses{\n', '    using SafeMath for uint256;\n', '\n', '    address public multisigWallet;\n', '    uint256 public tokensLimit;\n', '    uint256 public minimalPrice;\n', '    uint256 public tokensTransferred = 0;\n', '\n', '    string public bonusPreset;\n', '\n', '    uint256 public collected = 0;\n', '\n', '    bool public activated = false;\n', '    bool public closed = false;\n', '    bool public saleInited = false;\n', '\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    function init(\n', '        string _bonusPreset,\n', '        uint256 _startTime,\n', '        uint256 _endTime,\n', '        uint256 _tokensLimit,\n', '        uint256 _minimalPrice,\n', '        DLCToken _token,\n', '        address _multisigWallet\n', '    ) public onlyConfigurer {\n', '        require(!saleInited);\n', '        require(_endTime >= _startTime);\n', '        require(_tokensLimit > 0);\n', '        require(_multisigWallet != address(0));\n', '\n', '        saleInited = true;\n', '\n', '        token = _token;\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        tokensLimit = _tokensLimit;\n', '        multisigWallet = _multisigWallet;\n', '        minimalPrice = _minimalPrice;\n', '        bonusPreset = _bonusPreset;\n', '\n', '        initBonuses(bonusPreset);\n', '    }\n', '\n', '    function activate() public onlyConfigurerOrOwner {\n', '        require(!activated);\n', '        require(!closed);\n', '        activated = true;\n', '    }\n', '\n', '    function close() public onlyConfigurerOrOwner {\n', '        activated = true;\n', '        closed = true;\n', '    }\n', '\n', '    function setMultisigWallet(address _multisigWallet) public onlyConfigurerOrOwner {\n', '        multisigWallet = _multisigWallet;\n', '    }\n', '\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(validPurchase());\n', '\n', '        uint256 amount = msg.value;\n', '        uint256 tokens = calculateTokensQtyByEther({\n', '            amount: amount\n', '            });\n', '\n', '        require(tokensTransferred.add(tokens) < tokensLimit);\n', '\n', '        tokensTransferred = tokensTransferred.add(tokens);\n', '        collected = collected.add(amount);\n', '\n', '        token.purchase(beneficiary, tokens);\n', '        emit TokenPurchase(msg.sender, beneficiary, amount, tokens);\n', '\n', '        forwardFunds();\n', '    }\n', '\n', '    function forwardFunds() internal {\n', '        multisigWallet.transfer(msg.value);\n', '    }\n', '\n', '    function validPurchase() internal constant returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '        bool minimalPriceChecked = msg.value >= minimalPrice;\n', '        return withinPeriod && nonZeroPurchase && minimalPriceChecked && activated && !closed;\n', '    }\n', '\n', '    function isStarted() public constant returns (bool) {\n', '        return now > startTime;\n', '    }\n', '\n', '    function isEnded() public constant returns (bool) {\n', '        return now > endTime;\n', '    }\n', '}\n', '\n', '\n', 'contract DoubleLandICO is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    DLCToken public token;\n', '\n', '    Sale[] public sales;\n', '\n', '    uint256 public softCap;\n', '    uint256 public hardCap;\n', '\n', '    uint public activatedSalesTotalCount = 0;\n', '    uint public maxActivatedSalesTotalCount;\n', '\n', '    address public multisigWallet;\n', '\n', '    bool public isDeployed = false;\n', '\n', '    function createSale(string _bonusPreset, uint256 _startTime, uint256 _endTime,  uint256 _tokensLimit, uint256 _minimalPrice) public onlyOwner{\n', '        require(activatedSalesTotalCount < maxActivatedSalesTotalCount);\n', '        require(getTotalCollected() < hardCap );\n', '        require(token.getRestTokenBalance() >= _tokensLimit);\n', '        require(sales.length == 0 || sales[sales.length - 1].activated());\n', '        Sale newSale = new Sale();\n', '\n', '        newSale.init({\n', '            _bonusPreset: _bonusPreset,\n', '            _startTime: _startTime,\n', '            _endTime: _endTime,\n', '            _tokensLimit: _tokensLimit,\n', '            _minimalPrice: _minimalPrice,\n', '            _token: token,\n', '            _multisigWallet: multisigWallet\n', '            });\n', '        newSale.transferOwnership(owner);\n', '\n', '        sales.push(newSale);\n', '    }\n', '\n', '    function activateLastSale() public onlyOwner {\n', '        require(activatedSalesTotalCount < maxActivatedSalesTotalCount);\n', '        require(!sales[sales.length - 1].activated());\n', '        activatedSalesTotalCount ++;\n', '        sales[sales.length - 1].activate();\n', '        token.setSaleAgent(sales[sales.length - 1]);\n', '    }\n', '\n', '    function removeLastSaleOnlyNotActivated() public onlyOwner {\n', '        require(!sales[sales.length - 1].activated());\n', '        delete sales[sales.length - 1];\n', '    }\n', '\n', '    function closeAllSales() public onlyOwner {\n', '        for (uint i = 0; i < sales.length; i++) {\n', '            sales[i].close();\n', '        }\n', '    }\n', '\n', '    function setGlobalMultisigWallet(address _multisigWallet) public onlyOwner {\n', '        multisigWallet = _multisigWallet;\n', '        for (uint i = 0; i < sales.length; i++) {\n', '            if (!sales[i].closed()) {\n', '                sales[i].setMultisigWallet(multisigWallet);\n', '            }\n', '        }\n', '    }\n', '\n', '    function getTotalCollected() public constant returns(uint256) {\n', '        uint256 _totalCollected = 0;\n', '        for (uint i = 0; i < sales.length; i++) {\n', '            _totalCollected = _totalCollected + sales[i].collected();\n', '        }\n', '        return _totalCollected;\n', '    }\n', '\n', '    function getCurrentSale() public constant returns(address) {\n', '        return token.saleAgent();\n', '    }\n', '\n', '    function deploy() public onlyOwner {\n', '        require(!isDeployed);\n', '        isDeployed = true;\n', '\n', '        softCap = 8000 ether;\n', '        hardCap = 50000 ether;\n', '        maxActivatedSalesTotalCount = 5;\n', '\n', '        setGlobalMultisigWallet(0x9264669C5071944EaF5898B13f049aA667a2f94B);\n', '\n', '        token = new DLCToken();\n', '        token.setTotalSupply(1000000000 * 1 ether);\n', '        token.setFoundersTokensPercent(15);\n', '        token.setBountyTokensPercent(1);\n', '        token.setDevelopmentAuditPromotionTokensPercent(10);\n', '        token.setPriceOfToken(0.000183 * 1 ether);\n', '        token.setToSaleWallet(0x1Ab521E26d76826cE3130Dd7E31c64870016C268);\n', '        token.setBountyWallet(0xD1Aac7097a9a79EC60940Af9c6cCcD78597534bc);\n', '        token.setFoundersWallet(0xf5EEbE2be833458367200389ad567Cc1A450CD64);\n', '        token.setDevelopmentAuditPromotionWallet(0xebb8776f710A5Df053C291Fe65228687f07faACB);\n', '        token.transferOwnership(owner);\n', '        token.init();\n', '\n', '        createSale({\n', '            _bonusPreset: &#39;privatesale&#39;,\n', '            _startTime: 1526331600, // 15.05.2018 00:00:00\n', '            _endTime:   1527714000, // 31.05.2018 00:00:00\n', '            _tokensLimit: 80000000 * 1 ether,\n', '            _minimalPrice: 1 ether\n', '            });\n', '        activateLastSale();\n', '\n', '        createSale({\n', '            _bonusPreset: &#39;presale&#39;,\n', '            _startTime: 1529010000, // 15.06.2018 00:00:00\n', '            _endTime:   1530306000, // 30.06.2018 00:00:00\n', '            _tokensLimit: 75000000 * 1 ether,\n', '            _minimalPrice: 0.03 ether\n', '            });\n', '    }\n', '}']