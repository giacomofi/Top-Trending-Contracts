['pragma solidity ^0.4.20;\n', '\n', 'contract DTTToken {\n', '    \n', '    // only people with tokens\n', '    modifier onlyBagholders() {\n', '        require(myTokens() > 0);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdministrator(){\n', '        address _customerAddress = msg.sender;\n', '        require(administrators[_customerAddress]);\n', '        _;\n', '    }\n', '    \n', '    \n', '    /*==============================\n', '    =            EVENTS            =\n', '    ==============================*/\n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 incomingEthereum,\n', '        uint256 tokensMinted,\n', '        uint256 totalSupply,\n', '        address indexed referredBy\n', '    );\n', '    \n', '    event onTokenSell(\n', '        address indexed customerAddress,\n', '        uint256 tokensBurned,\n', '        uint256 ethereumEarned\n', '    );\n', '    \n', '    event onReinvestment(\n', '        address indexed customerAddress,\n', '        uint256 ethereumReinvested,\n', '        uint256 tokensMinted\n', '    );\n', '    \n', '    event onWithdraw(\n', '        address indexed customerAddress,\n', '        uint256 ethereumWithdrawn\n', '    );\n', '    \n', '    // ERC20\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 tokens\n', '    );\n', '    \n', '    \n', '    /*=====================================\n', '    =            CONFIGURABLES            =\n', '    =====================================*/\n', '    string public name = "DTT TOKEN";\n', '    string public symbol = "DTT";\n', '    uint8 constant public decimals = 18;\n', '    //uint8 constant internal dividendFee_ = 2;\n', '    uint256 constant internal tokenPriceInitial_ = 0.000010 ether; \n', '    uint256 constant internal tokenPriceIncremental_ = 0.0000000010 ether;\n', '    uint256 constant internal magnitude = 2**64;\n', '    uint256 public percent = 75;\n', '    \n', '    address commissionHolder; // holds commissions fees \n', '    address stakeHolder; // holds stake\n', '    address dev2; // Marketing funds\n', '    address dev3; // Advertisement funds\n', '    address dev4; // Dev ops funds\n', '    address dev5; // Management funds\n', '    address dev6; // Server, admin and domain Management\n', '    \n', '    \n', '    \n', '   /*================================\n', '    =            DATASETS            =\n', '    ================================*/\n', '    mapping(address => uint256) internal tokenBalanceLedger_;\n', '    address sonk;\n', '    uint256 internal tokenSupply_ = 0;\n', '    // uint256 internal profitPerShare_;\n', '    mapping(address => bool) public administrators;\n', '    uint256 commFunds;\n', '    \n', '    \n', '    function DTTToken()\n', '    public\n', '    {\n', '        sonk = msg.sender;\n', '        administrators[sonk] = true; \n', '        commissionHolder = sonk;\n', '        stakeHolder = sonk;\n', '    }\n', '    \n', '    function buy(address _referredBy)\n', '        public\n', '        payable\n', '        returns(uint256)\n', '    {\n', '        purchaseTokens(msg.value, _referredBy);\n', '    }\n', '    \n', '    function()\n', '        payable\n', '        public\n', '    {\n', '        purchaseTokens(msg.value, 0x0);\n', '    }\n', '    \n', '    function holdStake(uint256 _amount) \n', '        onlyBagholders()\n', '        public\n', '        {\n', '            tokenBalanceLedger_[msg.sender] = SafeMath.sub(tokenBalanceLedger_[msg.sender], _amount);\n', '            tokenBalanceLedger_[stakeHolder] = SafeMath.add(tokenBalanceLedger_[stakeHolder], _amount);\n', '        }\n', '        \n', '    function unstake(uint256 _amount, address _customerAddress)\n', '        onlyAdministrator()\n', '        public\n', '    {\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress],_amount);\n', '        tokenBalanceLedger_[stakeHolder] = SafeMath.sub(tokenBalanceLedger_[stakeHolder], _amount);\n', '    }\n', '    \n', '    function withdrawRewards(uint256 _amount, address _customerAddress)\n', '        onlyAdministrator()\n', '        public \n', '    {\n', '        _amount = SafeMath.mul(_amount,10**18);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress],_amount);\n', '        tokenSupply_ = SafeMath.add (tokenSupply_,_amount);\n', '    }\n', '    \n', '    function withdrawComm(uint256 _amount, address _customerAddress)\n', '        onlyAdministrator()\n', '        public \n', '    {\n', '        _amount = SafeMath.mul(_amount,10**18);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress],_amount);\n', '        tokenBalanceLedger_[commissionHolder] = SafeMath.sub(tokenBalanceLedger_[commissionHolder], _amount);\n', '    }\n', '    \n', '    /**\n', '     * Alias of sell() and withdraw().\n', '     */\n', '    function exit()\n', '        public\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        uint256 _tokens = tokenBalanceLedger_[_customerAddress];\n', '        if(_tokens > 0) sell(_tokens);\n', '            // withdraw();\n', '    }\n', '\n', '    /**\n', '     * Liquifies tokens to ethereum.\n', '     */\n', '    function sell(uint256 _amountOfTokens)\n', '        onlyBagholders()\n', '        public\n', '    {\n', '        // setup data\n', '        address _customerAddress = msg.sender;\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '        uint256 _tokens = _amountOfTokens;\n', '        uint256 _ethereum = tokensToEthereum_(_tokens);\n', '        uint256 _dividends = _ethereum * percent/1000;//SafeMath.div(_ethereum, dividendFee_); // 7.5% sell fees\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '        commFunds += _dividends;\n', '        \n', '        // burn the sold tokens\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);\n', '        _customerAddress.transfer(_taxedEthereum);\n', '        onTokenSell(_customerAddress, _tokens, _taxedEthereum);\n', '    }\n', '    \n', '    function registerDev234(address _devAddress2, address _devAddress3, address _devAddress4,address _devAddress5, address _devAddress6,address _commHolder)\n', '    onlyAdministrator()\n', '    public\n', '    {\n', '        dev2 = _devAddress2;\n', '        dev3 = _devAddress3;\n', '        dev4 = _devAddress4;\n', '        dev5 = _devAddress5;\n', '        dev6 = _devAddress6;\n', '        commissionHolder = _commHolder;\n', '        administrators[commissionHolder] = true;\n', '    }\n', '    \n', '    function totalCommFunds() \n', '        onlyAdministrator()\n', '        public view\n', '        returns(uint256)\n', '    {\n', '        return commFunds;    \n', '    }\n', '    \n', '    function getCommFunds(uint256 _amount)\n', '        onlyAdministrator()\n', '        public \n', '    {\n', '        if(_amount <= commFunds)\n', '        {\n', '            dev2.transfer(_amount*20/100);\n', '            dev3.transfer(_amount*20/100);\n', '            dev4.transfer(_amount*25/100);\n', '            dev5.transfer(_amount*10/100);\n', '            dev6.transfer(_amount*25/100);\n', '            commFunds = SafeMath.sub(commFunds,_amount);\n', '        }\n', '    }\n', '\n', '    \n', '    function transfer(address _toAddress, uint256 _amountOfTokens)\n', '        onlyAdministrator()\n', '        public\n', '        returns(bool)\n', '    {\n', '        // setup\n', '        address _customerAddress = msg.sender;\n', '        \n', '        // these are dispersed to shareholders\n', '        uint256 _tokenFee = _amountOfTokens * 15/100;//SafeMath.div(_amountOfTokens, dividendFee_);\n', '        uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);\n', '\n', '        // exchange tokens\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);\n', '        Transfer(_customerAddress, _toAddress, _taxedTokens);\n', '        \n', '        // ERC20\n', '        return true;\n', '       \n', '    }\n', '    \n', '    function destruct() onlyAdministrator() public{\n', '        selfdestruct(dev2);\n', '    }\n', '    \n', '    \n', '    function setPercent(uint256 newPercent) onlyAdministrator() public {\n', '        percent = newPercent * 10;\n', '    }\n', '\n', '    \n', '    function setName(string _name)\n', '        onlyAdministrator()\n', '        public\n', '    {\n', '        name = _name;\n', '    }\n', '    \n', '    function setSymbol(string _symbol)\n', '        onlyAdministrator()\n', '        public\n', '    {\n', '        symbol = _symbol;\n', '    }\n', '\n', '    function setupCommissionHolder(address _commissionHolder)\n', '    onlyAdministrator()\n', '    public\n', '    {\n', '        commissionHolder = _commissionHolder;\n', '    }\n', '\n', '    function totalEthereumBalance()\n', '        public\n', '        view\n', '        returns(uint)\n', '    {\n', '        return this.balance;\n', '    }\n', '    \n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        return tokenSupply_;\n', '    }\n', '    \n', '    /**\n', '     * Retrieve the tokens owned by the caller.\n', '     */\n', '    function myTokens()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return balanceOf(_customerAddress);\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Retrieve the token balance of any single address.\n', '     */\n', '    function balanceOf(address _customerAddress)\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return tokenBalanceLedger_[_customerAddress];\n', '    }\n', '    \n', '\n', '    function sellPrice() \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if(tokenSupply_ == 0){\n', '            return tokenPriceInitial_ - tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = _ethereum * percent/1000;\n', '            uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Return the sell price of 1 individual token.\n', '     */\n', '    function buyPrice() \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if(tokenSupply_ == 0){\n', '            return tokenPriceInitial_ + tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = _ethereum *percent/1000;//SafeMath.div(_ethereum, dividendFee_  );\n', '            uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '    \n', '    \n', '    function calculateEthereumReceived(uint256 _tokensToSell) \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        require(_tokensToSell <= tokenSupply_);\n', '        uint256 _ethereum = tokensToEthereum_(_tokensToSell);\n', '        uint256 _dividends = _ethereum * percent/1000;//SafeMath.div(_ethereum, dividendFee_);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '        return _taxedEthereum;\n', '    }\n', '    \n', '    \n', '    /*==========================================\n', '    =            INTERNAL FUNCTIONS            =\n', '    ==========================================*/\n', '    \n', '    event testLog(\n', '        uint256 currBal\n', '    );\n', '\n', '    function calculateTokensReceived(uint256 _ethereumToSpend) \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        uint256 _dividends = _ethereumToSpend * percent/1000;\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * 20/100);\n', '        return _amountOfTokens;\n', '    }\n', '    \n', '    function purchaseTokens(uint256 _incomingEthereum, address _referredBy)\n', '        internal\n', '        returns(uint256)\n', '    {\n', '        // data setup\n', '        address _customerAddress = msg.sender;\n', '        uint256 _dividends = _incomingEthereum * percent/1000;\n', '        commFunds += _dividends;\n', '        uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        tokenBalanceLedger_[commissionHolder] += _amountOfTokens * 20/100;\n', '        require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));\n', '        \n', '        tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);\n', '        \n', '        //deduct commissions for referrals\n', '        _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * 20/100);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        \n', '        testLog(tokenBalanceLedger_[_customerAddress]);\n', '        \n', '        // fire event\n', '        onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, tokenSupply_, _referredBy);\n', '        \n', '        return _amountOfTokens;\n', '    }\n', '\n', '   \n', '    function ethereumToTokens_(uint256 _ethereum)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;\n', '        uint256 _tokensReceived = \n', '         (\n', '            (\n', '                // underflow attempts BTFO\n', '                SafeMath.sub(\n', '                    (sqrt\n', '                        (\n', '                            (_tokenPriceInitial**2)\n', '                            +\n', '                            (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))\n', '                            +\n', '                            (((tokenPriceIncremental_)**2)*(tokenSupply_**2))\n', '                            +\n', '                            (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)\n', '                        )\n', '                    ), _tokenPriceInitial\n', '                )\n', '            )/(tokenPriceIncremental_)\n', '        )-(tokenSupply_)\n', '        ;\n', '  \n', '        return _tokensReceived;\n', '    }\n', '    \n', '   \n', '     function tokensToEthereum_(uint256 _tokens)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '\n', '        uint256 tokens_ = (_tokens + 1e18);\n', '        uint256 _tokenSupply = (tokenSupply_ + 1e18);\n', '        uint256 _etherReceived =\n', '        (\n', '            // underflow attempts BTFO\n', '            SafeMath.sub(\n', '                (\n', '                    (\n', '                        (\n', '                            tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))\n', '                        )-tokenPriceIncremental_\n', '                    )*(tokens_ - 1e18)\n', '                ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2\n', '            )\n', '        /1e18);\n', '        return _etherReceived;\n', '    }\n', '    \n', '    \n', '    //This is where all your gas goes, sorry\n', '    //Not sorry, you probably only paid 1 gwei\n', '    function sqrt(uint x) internal pure returns (uint y) {\n', '        uint z = (x + 1) / 2;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']