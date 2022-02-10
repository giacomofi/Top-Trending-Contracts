['pragma solidity ^0.4.26;\n', '\n', 'contract LTT_Exchange {\n', '    // only people with tokens\n', '    modifier onlyBagholders() {\n', '        require(myTokens() > 0);\n', '        _;\n', '    }\n', '    modifier onlyAdministrator(){\n', '        address _customerAddress = msg.sender;\n', '        require(administrators[_customerAddress]);\n', '        _;\n', '    }\n', '    /*==============================\n', '    =            EVENTS            =\n', '    ==============================*/\n', '\n', '    event Reward(\n', '       address indexed to,\n', '       uint256 rewardAmount,\n', '       uint256 level\n', '    );\n', '    // ERC20\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 tokens\n', '    );\n', '   \n', '    /*=====================================\n', '    =            CONFIGURABLES            =\n', '    =====================================*/\n', '    string public name = "Link Trade Token";\n', '    string public symbol = "LTT";\n', '    uint8 constant public decimals = 0;\n', '    uint256 public totalSupply_ = 900000;\n', '    uint256 constant internal tokenPriceInitial_ = 0.00013 ether;\n', '    uint256 constant internal tokenPriceIncremental_ = 263157894;\n', '    uint256 public currentPrice_ = tokenPriceInitial_ + tokenPriceIncremental_;\n', '    uint256 public base = 1;\n', '    uint256 public basePrice = 380;\n', '    uint public percent = 1100;\n', '    uint256 public rewardSupply_ = 2000000;\n', '    mapping(address => uint256) internal tokenBalanceLedger_;\n', '    mapping(address => uint256) internal rewardBalanceLedger_;\n', '    address commissionHolder;\n', '    uint256 internal tokenSupply_ = 0;\n', '    mapping(address => bool) internal administrators;\n', '    mapping(address => address) public genTree;\n', '    mapping(address => uint256) public level1Holding_;\n', '    address terminal;\n', '    uint8[] percent_ = [5,2,1,1,1];\n', '    uint256[] holding_ = [0,460,460,930,930];\n', '    uint internal minWithdraw = 1000;\n', '    uint funds = 0;\n', '    bool distributeRewards_ = false;\n', '    bool reEntrancyMutex = false;\n', '   \n', '    constructor() public\n', '    {\n', '        terminal = msg.sender;\n', '        administrators[terminal] = true;\n', '    }\n', '   \n', '   function upgradeContract(address[] _users, uint256[] _balances, uint256[] _rewards, address[] _referredBy, uint modeType)\n', '    onlyAdministrator()\n', '    public\n', '    {\n', '        if(modeType == 1)\n', '        {\n', '            for(uint i = 0; i<_users.length;i++)\n', '            {\n', '                tokenBalanceLedger_[_users[i]] += _balances[i];\n', '                tokenSupply_ += _balances[i];\n', '                genTree[_users[i]] = _referredBy[i];\n', '                \n', '                rewardBalanceLedger_[_users[i]] += _rewards[i];\n', '                tokenSupply_ += _rewards[i]/100;\n', '                \n', '                emit Transfer(address(this),_users[i],_balances[i]);\n', '            }\n', '        }\n', '        if(modeType == 2)\n', '        {\n', '            for(i = 0; i<_users.length;i++)\n', '            {\n', '                rewardBalanceLedger_[_users[i]] += _balances[i];\n', '                tokenSupply_ += _balances[i]/100;\n', '            }\n', '        }\n', '    }\n', '   \n', '   function fundsInjection() public payable returns(bool)\n', '    {\n', '        return true;\n', '    }\n', '    \n', '    function startSellDistribution() onlyAdministrator() public\n', '    {\n', '        distributeRewards_ = true;\n', '    }\n', '    \n', '    function stopSellDistribution() onlyAdministrator() public\n', '    {\n', '        distributeRewards_ = false;\n', '    }\n', '    \n', '    function upgradeDetails(uint256 _currentPrice, uint256 _grv)\n', '    onlyAdministrator()\n', '    public\n', '    {\n', '        currentPrice_ = _currentPrice;\n', '        base = _grv;\n', '    }\n', '   \n', '    function withdrawRewards() public returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        require(!reEntrancyMutex);\n', '        require(rewardBalanceLedger_[_customerAddress]>minWithdraw);\n', '        reEntrancyMutex = true;\n', '        uint256 _balance = rewardBalanceLedger_[_customerAddress]/100;\n', '        rewardBalanceLedger_[_customerAddress] -= _balance*100;\n', '        emit Transfer(_customerAddress, address(this),_balance);\n', '        _balance = SafeMath.sub(_balance, (_balance*percent/10000));\n', '        uint256 _ethereum = tokensToEthereum_(_balance,true);\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _balance);\n', '        _customerAddress.transfer(_ethereum);\n', '        reEntrancyMutex = false;\n', '    }\n', '   \n', '    function distributeRewards(uint256 _amountToDistribute, address _idToDistribute)\n', '    internal\n', '    {\n', '        uint256 _currentPrice = currentPrice_*basePrice;\n', '        uint256 _tempAmountToDistribute = _amountToDistribute*100;\n', '        for(uint i=0; i<5; i++)\n', '        {\n', '            address referrer = genTree[_idToDistribute];\n', '            uint256 value = _currentPrice*tokenBalanceLedger_[referrer];\n', '            uint256 _holdingLevel1 = level1Holding_[referrer]*_currentPrice;\n', '            if(referrer != 0x0 && value >= (50*10**18) && _holdingLevel1 >= (holding_[i]*10**18))\n', '            {\n', '                rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[i]*100)/10;\n', '                _idToDistribute = referrer;\n', '                emit Reward(referrer,(_amountToDistribute*percent_[i]*100)/10,i);\n', '                _tempAmountToDistribute -= (_amountToDistribute*percent_[i]*100)/10;\n', '            }\n', '        }\n', '        rewardBalanceLedger_[commissionHolder] += _tempAmountToDistribute;\n', '    }\n', '   \n', '   function setBasePrice(uint256 _price)\n', '    onlyAdministrator()\n', '    public\n', '    returns(bool) {\n', '        basePrice = _price;\n', '    }\n', '   \n', '    function buy(address _referredBy)\n', '        public\n', '        payable\n', '        returns(uint256)\n', '    {\n', '        if(msg.sender == _referredBy)\n', '        {\n', '            genTree[msg.sender] = terminal;\n', '        }\n', '        else\n', '        {\n', '            genTree[msg.sender] = _referredBy;\n', '        }\n', '        purchaseTokens(msg.value, _referredBy);\n', '    }\n', '   \n', '    function()\n', '        payable\n', '        public\n', '    {\n', '        purchaseTokens(msg.value, 0x0);\n', '    }\n', '   \n', '    /**\n', '     * Liquifies tokens to ethereum.\n', '    */\n', '     \n', '    function sell(uint256 _amountOfTokens)\n', '        onlyBagholders()\n', '        public\n', '    {\n', '        require(!reEntrancyMutex);\n', '        // setup data\n', '        reEntrancyMutex = true;\n', '        address _customerAddress = msg.sender;\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '        uint256 _tokens = _amountOfTokens;\n', '        uint256 _deficit = _tokens * percent / 10000;\n', '        uint256 _dividends = _tokens * (percent-200)/10000;\n', '        tokenBalanceLedger_[commissionHolder] += (_tokens*200)/10000;\n', '        _tokens = SafeMath.sub(_tokens, _deficit);\n', '        uint256 _ethereum = tokensToEthereum_(_tokens,true);\n', '        // burn the sold tokens\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        if(_dividends > 0 && distributeRewards_)\n', '        {\n', '            distributeRewards(_dividends,_customerAddress);\n', '        }\n', '        level1Holding_[genTree[_customerAddress]] -=_amountOfTokens;\n', '        \n', '        _customerAddress.transfer(_ethereum);\n', '        emit Transfer(_customerAddress, address(this), _amountOfTokens);\n', '        reEntrancyMutex = false;\n', '    }\n', '   \n', '    function rewardOf(address _toCheck)\n', '        public view\n', '        returns(uint256)\n', '    {\n', '        return rewardBalanceLedger_[_toCheck];    \n', '    }\n', '   \n', '    function holdingLevel1(address _toCheck)\n', '        public view\n', '        returns(uint256)\n', '    {\n', '        return level1Holding_[_toCheck];    \n', '    }\n', '   \n', '    function transfer(address _toAddress, uint256 _amountOfTokens)\n', '        onlyAdministrator()\n', '        public\n', '        returns(bool)\n', '    {\n', '        // setup\n', '        address _customerAddress = msg.sender;\n', '        // exchange tokens\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);\n', '        emit Transfer(_customerAddress, _toAddress, _amountOfTokens);\n', '        return true;\n', '    }\n', '   \n', '    function destruct() onlyAdministrator() public{\n', '        selfdestruct(terminal);\n', '    }\n', '   \n', '    function setName(string _name)\n', '        onlyAdministrator()\n', '        public\n', '    {\n', '        name = _name;\n', '    }\n', '   \n', '    function setSymbol(string _symbol)\n', '        onlyAdministrator()\n', '        public\n', '    {\n', '        symbol = _symbol;\n', '    }\n', '\n', '    function setupCommissionHolder(address _commissionHolder)\n', '    onlyAdministrator()\n', '    public\n', '    {\n', '        commissionHolder = _commissionHolder;\n', '        administrators[commissionHolder] = true;\n', '    }\n', '\n', '    function totalEthereumBalance()\n', '        public\n', '        view\n', '        returns(uint)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '   \n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        return totalSupply_;\n', '    }\n', '   \n', '    function tokenSupply()\n', '    public\n', '    view\n', '    returns(uint256)\n', '    {\n', '        return tokenSupply_;\n', '    }\n', '   \n', '    /**\n', '     * Retrieve the tokens owned by the caller.\n', '     */\n', '    function myTokens()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return balanceOf(_customerAddress);\n', '    }\n', '   \n', '   \n', '    /**\n', '     * Retrieve the token balance of any single address.\n', '     */\n', '    function balanceOf(address _customerAddress)\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return tokenBalanceLedger_[_customerAddress];\n', '    }\n', '   \n', '    /**\n', '     * Return the sell price of 1 individual token.\n', '     */\n', '    function buyPrice()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        return currentPrice_;\n', '    }\n', '   \n', '    function calculateEthereumReceived(uint256 _tokensToSell)\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        require(_tokensToSell <= tokenSupply_);\n', '        uint256 _deficit = _tokensToSell * percent / 10000;\n', '        _tokensToSell = SafeMath.sub(_tokensToSell, (_deficit-1));\n', '        uint256 _ethereum = tokensToEthereum_(_tokensToSell,false);\n', '        return _ethereum;\n', '    }\n', '   \n', '    /*==========================================\n', '    =            INTERNAL FUNCTIONS            =\n', '    ==========================================*/\n', '   \n', '    event testLog(\n', '        uint256 currBal\n', '    );\n', '\n', '    function calculateTokensReceived(uint256 _ethereumToSpend)\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _amountOfTokens = ethereumToTokens_(_ethereumToSpend, currentPrice_, base, false);\n', '        _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * percent/10000);\n', '        return _amountOfTokens;\n', '    }\n', '   \n', '    function purchaseTokens(uint256 _incomingEthereum, address _referredBy)\n', '        internal\n', '        returns(uint256)\n', '    {\n', '        // data setup\n', '        address _customerAddress = msg.sender;\n', '        uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum , currentPrice_, base, true);\n', '        require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));\n', '        tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);\n', '        require(SafeMath.add(_amountOfTokens,tokenSupply_) < (totalSupply_+rewardSupply_));\n', '        //deduct commissions for referrals\n', '        distributeRewards(_amountOfTokens * (percent-200)/10000,_customerAddress);\n', '        _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * percent/10000);\n', '        level1Holding_[_referredBy] +=_amountOfTokens;\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        // fire event\n', '        emit Transfer(address(this), _customerAddress, _amountOfTokens);\n', '        return _amountOfTokens;\n', '    }\n', '   \n', '    function ethereumToTokens_(uint256 _ethereum, uint256 _currentPrice, uint256 _grv, bool _buy)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _tokenPriceIncremental = (tokenPriceIncremental_*(2**(_grv-1)));\n', '        uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);\n', '        uint256 _tokenSupply = tokenSupply_;\n', '        uint256 _totalTokens = 0;\n', '        uint256 _tokensReceived = (\n', '            (\n', '                SafeMath.sub(\n', '                    (sqrt\n', '                        (\n', '                            _tempad**2\n', '                            + (8*_tokenPriceIncremental*_ethereum)\n', '                        )\n', '                    ), _tempad\n', '                )\n', '            )/(2*_tokenPriceIncremental)\n', '        );\n', '        uint256 tempbase = upperBound_(_grv);\n', '        while((_tokensReceived + _tokenSupply) > tempbase){\n', '            _tokensReceived = tempbase - _tokenSupply;\n', '            _ethereum = SafeMath.sub(\n', '                _ethereum,\n', '                ((_tokensReceived)/2)*\n', '                ((2*_currentPrice)+((_tokensReceived-1)\n', '                *_tokenPriceIncremental))\n', '            );\n', '            _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);\n', '            _grv = _grv + 1;\n', '            _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));\n', '            _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);\n', '            uint256 _tempTokensReceived = (\n', '                (\n', '                    SafeMath.sub(\n', '                        (sqrt\n', '                            (\n', '                                _tempad**2\n', '                                + (8*_tokenPriceIncremental*_ethereum)\n', '                            )\n', '                        ), _tempad\n', '                    )\n', '                )/(2*_tokenPriceIncremental)\n', '            );\n', '            _tokenSupply = _tokenSupply + _tokensReceived;\n', '            _totalTokens = _totalTokens + _tokensReceived;\n', '            _tokensReceived = _tempTokensReceived;\n', '            tempbase = upperBound_(_grv);\n', '        }\n', '        _totalTokens = _totalTokens + _tokensReceived;\n', '        _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);\n', '        if(_buy == true)\n', '        {\n', '            currentPrice_ = _currentPrice;\n', '            base = _grv;\n', '        }\n', '        return _totalTokens;\n', '    }\n', '   \n', '    function upperBound_(uint256 _grv)\n', '    internal\n', '    view\n', '    returns(uint256)\n', '    {\n', '        if(_grv <= 5)\n', '        {\n', '            return (60000 * _grv);\n', '        }\n', '        if(_grv > 5 && _grv <= 10)\n', '        {\n', '            return (300000 + ((_grv-5)*50000));\n', '        }\n', '        if(_grv > 10 && _grv <= 15)\n', '        {\n', '            return (550000 + ((_grv-10)*40000));\n', '        }\n', '        if(_grv > 15 && _grv <= 20)\n', '        {\n', '            return (750000 +((_grv-15)*30000));\n', '        }\n', '        return 0;\n', '    }\n', '   \n', '     function tokensToEthereum_(uint256 _tokens, bool _sell)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _tokenSupply = tokenSupply_;\n', '        uint256 _etherReceived = 0;\n', '        uint256 _grv = base;\n', '        uint256 tempbase = upperBound_(_grv-1);\n', '        uint256 _currentPrice = currentPrice_;\n', '        uint256 _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));\n', '        while((_tokenSupply - _tokens) < tempbase)\n', '        {\n', '            uint256 tokensToSell = _tokenSupply - tempbase;\n', '            if(tokensToSell == 0)\n', '            {\n', '                _tokenSupply = _tokenSupply - 1;\n', '                _grv -= 1;\n', '                tempbase = upperBound_(_grv-1);\n', '                continue;\n', '            }\n', '            uint256 b = ((tokensToSell-1)*_tokenPriceIncremental);\n', '            uint256 a = _currentPrice - b;\n', '            _tokens = _tokens - tokensToSell;\n', '            _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+b));\n', '            _currentPrice = a;\n', '            _tokenSupply = _tokenSupply - tokensToSell;\n', '            _grv = _grv-1 ;\n', '            _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));\n', '            tempbase = upperBound_(_grv-1);\n', '        }\n', '        if(_tokens > 0)\n', '        {\n', '             a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);\n', '             _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));\n', '             _tokenSupply = _tokenSupply - _tokens;\n', '             _currentPrice = a;\n', '        }\n', '       \n', '        if(_sell == true)\n', '        {\n', '            base = _grv;\n', '            currentPrice_ = _currentPrice;\n', '        }\n', '        return _etherReceived;\n', '    }\n', '   \n', '   \n', '    function sqrt(uint x) internal pure returns (uint y) {\n', '        uint z = (x + 1) / 2;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']