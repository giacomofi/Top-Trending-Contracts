['pragma solidity ^0.4.24;\n', '/***\n', '* Team JUST presents..\n', '* ============================================================== *\n', 'RRRRRRRRRRRRRRRRR   BBBBBBBBBBBBBBBBB   XXXXXXX       XXXXXXX\n', 'R::::::::::::::::R  B::::::::::::::::B  X:::::X       X:::::X\n', 'R::::::RRRRRR:::::R B::::::BBBBBB:::::B X:::::X       X:::::X\n', 'RR:::::R     R:::::RBB:::::B     B:::::BX::::::X     X::::::X\n', '  R::::R     R:::::R  B::::B     B:::::BXXX:::::X   X:::::XXX\n', '  R::::R     R:::::R  B::::B     B:::::B   X:::::X X:::::X   \n', '  R::::RRRRRR:::::R   B::::BBBBBB:::::B     X:::::X:::::X    \n', '  R:::::::::::::RR    B:::::::::::::BB       X:::::::::X     \n', '  R::::RRRRRR:::::R   B::::BBBBBB:::::B      X:::::::::X     \n', '  R::::R     R:::::R  B::::B     B:::::B    X:::::X:::::X    \n', '  R::::R     R:::::R  B::::B     B:::::B   X:::::X X:::::X   \n', '  R::::R     R:::::R  B::::B     B:::::BXXX:::::X   X:::::XXX\n', 'RR:::::R     R:::::RBB:::::BBBBBB::::::BX::::::X     X::::::X\n', 'R::::::R     R:::::RB:::::::::::::::::B X:::::X       X:::::X\n', 'R::::::R     R:::::RB::::::::::::::::B  X:::::X       X:::::X\n', 'RRRRRRRR     RRRRRRRBBBBBBBBBBBBBBBBB   XXXXXXX       XXXXXXX\n', '* ============================================================== *\n', '*/\n', 'contract risebox {\n', '    string public name = "RiseBox";\n', '    string public symbol = "RBX";\n', '    uint8 constant public decimals = 0;\n', '    uint8 constant internal dividendFee_ = 10;\n', '\n', '    uint256 constant ONEDAY = 86400;\n', '    uint256 public lastBuyTime;\n', '    address public lastBuyer;\n', '    bool public isEnd = false;\n', '\n', '    mapping(address => uint256) internal tokenBalanceLedger_;\n', '    mapping(address => uint256) internal referralBalance_;\n', '    mapping(address => int256) internal payoutsTo_;\n', '    uint256 internal profitPerShare_ = 0;\n', '    address internal foundation;\n', '    \n', '    uint256 internal tokenSupply_ = 0;\n', '    uint256 constant internal tokenPriceInitial_ = 1e14;\n', '    uint256 constant internal tokenPriceIncremental_ = 15e6;\n', '\n', '\n', '    /*=================================\n', '    =            MODIFIERS            =\n', '    =================================*/\n', '    // only people with tokens\n', '    modifier onlyBagholders() {\n', '        require(myTokens() > 0);\n', '        _;\n', '    }\n', '    \n', '    // only people with profits\n', '    modifier onlyStronghands() {\n', '        require(myDividends(true) > 0);\n', '        _;\n', '    }\n', '\n', '    // healthy longevity\n', '    modifier antiEarlyWhale(uint256 _amountOfEthereum){\n', '        uint256 _balance = address(this).balance;\n', '\n', '        if(_balance <= 1000 ether) {\n', '            require(_amountOfEthereum <= 2 ether);\n', '            _;\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '    /*==============================\n', '    =            EVENTS            =\n', '    ==============================*/\n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 incomingEthereum,\n', '        uint256 tokensMinted,\n', '        address indexed referredBy\n', '    );\n', '    \n', '    \n', '    event onReinvestment(\n', '        address indexed customerAddress,\n', '        uint256 ethereumReinvested,\n', '        uint256 tokensMinted\n', '    );\n', '    \n', '    event onWithdraw(\n', '        address indexed customerAddress,\n', '        uint256 ethereumWithdrawn\n', '    );\n', '    // ERC20\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 tokens\n', '    );\n', '\n', '    constructor () public {\n', '        foundation =  msg.sender;\n', '        lastBuyTime = now;\n', '    }\n', '\n', '    function buy(address _referredBy) \n', '        public \n', '        payable \n', '        returns(uint256)\n', '    {\n', '        assert(isEnd==false);\n', '\n', '        if(breakDown()) {\n', '            return liquidate();\n', '        } else {\n', '            return purchaseTokens(msg.value, _referredBy);\n', '        }\n', '    }\n', '\n', '    function()\n', '        payable\n', '        public\n', '    {\n', '        assert(isEnd==false);\n', '\n', '        if(breakDown()) {\n', '            liquidate();\n', '        } else {\n', '            purchaseTokens(msg.value, 0x00);\n', '        }\n', '    }\n', '\n', '    /**\n', "     * Converts all of caller's dividends to tokens.\n", '     */\n', '    function reinvest()\n', '        onlyStronghands() //针对有利润的客户\n', '        public\n', '    {\n', '        // fetch dividends\n', '        uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code\n', '        \n', '        // pay out the dividends virtually\n', '        address _customerAddress = msg.sender;\n', '        payoutsTo_[_customerAddress] +=  (int256) (_dividends);\n', '        \n', '        // retrieve ref. bonus\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '        \n', '        // dispatch a buy order with the virtualized "withdrawn dividends"\n', '        uint256 _tokens = purchaseTokens(_dividends, 0x00);\n', '        \n', '        // fire event\n', '        emit onReinvestment(_customerAddress, _dividends, _tokens);\n', '    }\n', '\n', '\n', '    /**\n', '     * Alias of sell() and withdraw().\n', '     */\n', '    function exit(address _targetAddress)\n', '        public\n', '    {\n', '        // get token count for caller & sell them all\n', '        address _customerAddress = msg.sender;\n', '        uint256 _tokens = tokenBalanceLedger_[_customerAddress];\n', '        if(_tokens > 0) sell(_tokens);\n', '        \n', '        // lambo delivery service\n', '        withdraw(_targetAddress);\n', '    }\n', '\n', '\n', '    function sell(uint256 _amountOfTokens)\n', '        onlyBagholders()\n', '        internal\n', '    {\n', '        // setup data\n', '        address _customerAddress = msg.sender;\n', '        // russian hackers BTFO\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '        \n', '        uint256 _tokens = _amountOfTokens;\n', '        uint256 _ethereum = tokensToEthereum_(_tokens);\n', '        uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);\n', '\n', '        // update dividends tracker\n', '        int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum));\n', '        payoutsTo_[_customerAddress] -= _updatedPayouts;       \n', '        \n', '        payoutsTo_[foundation] -= (int256)(_dividends);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * 提取ETH\n', '     */\n', '    function withdraw(address _targetAddress)\n', '        onlyStronghands()\n', '        internal\n', '    {\n', '        // setup data\n', '        address _customerAddress = msg.sender;\n', '        uint256 _dividends = myDividends(false); // get ref. bonus later in the code\n', '        \n', '        // update dividend tracker\n', '        payoutsTo_[_customerAddress] +=  (int256) (_dividends);\n', '        \n', '        // add ref. bonus\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '        \n', '        // anti whale\n', '        if(_dividends > address(this).balance/2) {\n', '            _dividends = address(this).balance / 2;\n', '        }\n', '\n', '        _targetAddress.transfer(_dividends);\n', '\n', '        // fire event\n', '        emit onWithdraw(_targetAddress, _dividends);       \n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from the caller to a new holder.\n', "     * Remember, there's a 10% fee here as well.\n", '     */\n', '    function transfer(address _toAddress, uint256 _amountOfTokens)\n', '        onlyBagholders()\n', '        public\n', '        returns(bool)\n', '    {\n', '        // setup\n', '        address _customerAddress = msg.sender;\n', '        \n', '        // make sure we have the requested tokens\n', '        // also disables transfers until ambassador phase is over\n', '        // ( we dont want whale premines )\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '        \n', '        // withdraw all outstanding dividends first\n', '        if(myDividends(true) > 0) withdraw(msg.sender);\n', '        \n', '\n', '        // exchange tokens\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);\n', '        \n', '        // update dividend trackers\n', '        payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);\n', '        payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);\n', '        \n', '        \n', '        // fire event\n', '        emit Transfer(_customerAddress, _toAddress, _amountOfTokens);\n', '        \n', '        // ERC20\n', '        return true;\n', '       \n', '    }\n', '\n', '    /*==========================================\n', '    =            INTERNAL FUNCTIONS            =\n', '    ==========================================*/\n', '    function purchaseTokens(uint256 _incomingEthereum, address _referredBy)\n', '        antiEarlyWhale(_incomingEthereum)\n', '        internal\n', '        returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender; \n', '        uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);\n', '        uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); \n', '        uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus); \n', '        uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends); \n', '\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        uint256 _fee = _dividends;\n', '\n', '        require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));\n', '\n', '        if(\n', '            // is this a referred purchase?\n', '            _referredBy != 0x0000000000000000000000000000000000000000 &&\n', '\n', '            // no cheating!\n', '            _referredBy != _customerAddress\n', '        ) {\n', '            // wealth redistribution\n', '            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);\n', '        } else if (\n', '            _referredBy != _customerAddress\n', '        ){\n', '            payoutsTo_[foundation] -= (int256)(_referralBonus);\n', '        } else {\n', '            referralBalance_[foundation] -= _referralBonus;\n', '        }\n', '\n', "        // we can't give people infinite ethereum\n", '        if(tokenSupply_ > 0){\n', '            \n', '            tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);\n', '\n', '            _fee = _amountOfTokens * (_dividends / tokenSupply_);\n', '         \n', '        } else {\n', '            // add tokens to the pool\n', '            tokenSupply_ = _amountOfTokens;\n', '        }\n', '\n', '        profitPerShare_ += SafeMath.div(_dividends , tokenSupply_);\n', '\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '\n', '        int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);\n', '        payoutsTo_[_customerAddress] += _updatedPayouts;\n', '\n', '        lastBuyTime = now;\n', '        lastBuyer = msg.sender;\n', '        // fire event\n', '        emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);\n', '        return _amountOfTokens;\n', '    }\n', '\n', '\n', '    // ETH for Token\n', '    function ethereumToTokens_(uint256 _ethereum)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _tokensReceived = 0;\n', '        \n', '        if(_ethereum < (tokenPriceInitial_ + tokenPriceIncremental_*tokenSupply_)) {\n', '            return _tokensReceived;\n', '        }\n', '\n', '        _tokensReceived = \n', '         (\n', '            (\n', '                // underflow attempts BTFO\n', '                SafeMath.sub(\n', '                    (SafeMath.sqrt\n', '                        (\n', '                            (tokenPriceInitial_**2)\n', '                            +\n', '                            (2 * tokenPriceIncremental_ * _ethereum)\n', '                            +\n', '                            (((tokenPriceIncremental_)**2)*(tokenSupply_**2))\n', '                            +\n', '                            (2*(tokenPriceIncremental_)*tokenPriceInitial_*tokenSupply_)\n', '                        )\n', '                    ), tokenPriceInitial_\n', '                )\n', '            )/(tokenPriceIncremental_)\n', '        )-(tokenSupply_)\n', '        ;\n', '  \n', '        return _tokensReceived;\n', '    }\n', '\n', '    // Token for eth\n', '    function tokensToEthereum_(uint256 _tokens)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _etherReceived = \n', '\n', '        SafeMath.sub(\n', '            _tokens * (tokenPriceIncremental_ * tokenSupply_ +     tokenPriceInitial_) , \n', '            (_tokens**2)*tokenPriceIncremental_/2\n', '        );\n', '\n', '        return _etherReceived;\n', '    }\n', '\n', '\n', '    /**\n', '     * Retrieve the dividend balance of any single address.\n', '     */\n', '    function dividendsOf(address _customerAddress)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        int256 _dividend = (int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress];\n', '\n', '        if(_dividend < 0) {\n', '            _dividend = 0;\n', '        }\n', '        return (uint256)(_dividend);\n', '    }\n', '\n', '\n', '    /**\n', '     * Retrieve the token balance of any single address.\n', '     */\n', '    function balanceOf(address _customerAddress)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        return tokenBalanceLedger_[_customerAddress];\n', '    }\n', '\n', '    /**\n', '     * to check is game breakdown.\n', '     */\n', '    function breakDown() \n', '        internal\n', '        returns(bool)\n', '    {\n', '        // is game ended\n', '        if (lastBuyTime + ONEDAY < now) {\n', '            isEnd = true;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function liquidate()\n', '        internal\n', '        returns(uint256)\n', '    {\n', '        // you are late,so sorry\n', '        msg.sender.transfer(msg.value);\n', '\n', '        // Ethereum in pool\n', '        uint256 _balance = address(this).balance;\n', '        // taxed\n', '        uint256 _taxedEthereum = _balance * 88 / 100;\n', '        // tax value\n', '        uint256 _tax = SafeMath.sub(_balance , _taxedEthereum);\n', '\n', '        foundation.transfer(_tax);\n', '        lastBuyer.transfer(_taxedEthereum);\n', '\n', '        return _taxedEthereum;\n', '    }\n', '\n', '    /*----------  HELPERS AND CALCULATORS  ----------*/\n', '    /**\n', '     * Method to view the current Ethereum stored in the contract\n', '     * Example: totalEthereumBalance()\n', '     */\n', '    function totalEthereumBalance()\n', '        public\n', '        view\n', '        returns(uint)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '    \n', '    /**\n', '     * Retrieve the total token supply.\n', '     */\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        return tokenSupply_;\n', '    }\n', '    \n', '    /**\n', '     * Retrieve the tokens owned by the caller.\n', '     */\n', '    function myTokens()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return balanceOf(_customerAddress);\n', '    }\n', '   \n', '    /**\n', '     * Retrieve the dividends owned by the caller.\n', '     * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.\n', '     * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)\n', '     * But in the internal calculations, we want them separate. \n', '     */ \n', '    function myDividends(bool _includeReferralBonus) \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;\n', '    }\n', '    \n', '    /**\n', '     * Return the buy price of 1 individual token.\n', '     */\n', '    function sellPrice() \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if(tokenSupply_ == 0){\n', '            return tokenPriceInitial_ - tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1);\n', '            uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );\n', '            uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Return the sell price of 1 individual token.\n', '     */\n', '    function buyPrice() \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if(tokenSupply_ == 0){\n', '            return tokenPriceInitial_ + tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1);\n', '            uint256 _dividends = SafeMath.div(_ethereum, (dividendFee_-1)  );\n', '            uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Function for the frontend to dynamically retrieve the price scaling of buy orders.\n', '     */\n', '    function calculateTokensReceived(uint256 _ethereumToSpend) \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        // overflow check\n', '        require(_ethereumToSpend <= 1e32 , "number is too big");\n', '        uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        return _amountOfTokens;\n', '    }\n', '    \n', '    /**\n', '     * Function for the frontend to dynamically retrieve the price scaling of sell orders.\n', '     */\n', '    function calculateEthereumReceived(uint256 _tokensToSell) \n', '        public \n', '        view \n', '        returns(uint256)\n', '    {\n', '        require(_tokensToSell <= tokenSupply_);\n', '        uint256 _ethereum = tokensToEthereum_(_tokensToSell);\n', '        uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '        return _taxedEthereum;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath v0.1.9\n', ' * @dev Math operations with safety checks that throw on error\n', ' * change notes:  original SafeMath library from OpenZeppelin modified by Inventor\n', ' * - added sqrt\n', ' * - added sq\n', ' * - added pwr \n', ' * - changed asserts to requires with error log outputs\n', ' * - removed div, its useless\n', ' */\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) \n', '        internal \n', '        pure \n', '        returns (uint256 c) \n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath mul failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '      uint256 c = a / b;\n', "      // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '      return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256) \n', '    {\n', '        require(b <= a, "SafeMath sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath add failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev gives square root of given x.\n', '     */\n', '    function sqrt(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256 y) \n', '    {\n', '        uint256 z = ((add(x,1)) / 2);\n', '        y = x;\n', '        while (z < y) \n', '        {\n', '            y = z;\n', '            z = ((add((x / z),z)) / 2);\n', '        }\n', '\n', '        return y;\n', '    }\n', '\n', '}']