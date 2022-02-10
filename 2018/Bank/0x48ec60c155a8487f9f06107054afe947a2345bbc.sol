['pragma solidity ^0.4.20;\n', '\n', '/*\n', '*HarjCoin https://harjcoin.io\n', '*\n', '*/\n', '\n', 'contract Harj {\n', '\n', '\n', '    /*=================================\n', '    =            MODIFIERS            =\n', '    =================================*/\n', '\n', '    /// @dev Only people with tokens\n', '    modifier onlyBagholders {\n', '        require(myTokens() > 0);\n', '        _;\n', '    }\n', '\n', '    /// @dev Only people with profits\n', '    modifier onlyStronghands {\n', '        require(myDividends(true) > 0);\n', '        _;\n', '    }\n', '\n', '\n', '    /*==============================\n', '    =            EVENTS            =\n', '    ==============================*/\n', '\n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 incomingEthereum,\n', '        uint256 tokensMinted,\n', '        address indexed referredBy,\n', '        uint timestamp,\n', '        uint256 price\n', '    );\n', '\n', '    event onTokenSell(\n', '        address indexed customerAddress,\n', '        uint256 tokensBurned,\n', '        uint256 ethereumEarned,\n', '        uint timestamp,\n', '        uint256 price\n', '    );\n', '\n', '    event onReinvestment(\n', '        address indexed customerAddress,\n', '        uint256 ethereumReinvested,\n', '        uint256 tokensMinted\n', '    );\n', '\n', '    event onWithdraw(\n', '        address indexed customerAddress,\n', '        uint256 ethereumWithdrawn\n', '    );\n', '\n', '    // ERC20\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 tokens\n', '    );\n', '\n', '\n', '    /*=====================================\n', '    =            CONFIGURABLES            =\n', '    =====================================*/\n', '\n', '    string public name = "Harj Coin";\n', '    string public symbol = "Harj";\n', '    uint8 constant public decimals = 18;\n', '\n', '    /// @dev 10% dividends for token purchase\n', '    uint8 constant internal entryFee_ = 10;\n', '\n', '    /// @dev 0% dividends for token transfer\n', '    uint8 constant internal transferFee_ = 0;\n', '\n', '    /// @dev 10% dividends for token selling\n', '    uint8 constant internal exitFee_ = 10;\n', '\n', '    /// @dev 33% of entryFee_ (i.e. 3% dividends) is given to referrer\n', '    uint8 constant internal refferalFee_ = 33;\n', '\n', '    uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;\n', '    uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;\n', '    uint256 constant internal magnitude = 2 ** 64;\n', '\n', '    /// @dev proof of stake (defaults at 25 tokens)\n', '    uint256 public stakingRequirement = 25e18;\n', '\n', '    /*================================\n', '    =            DATASETS            =\n', '    ================================*/\n', '\n', '    // amount of shares for each address (scaled number)\n', '    mapping(address => uint256) internal tokenBalanceLedger_;\n', '    mapping(address => uint256) internal referralBalance_;\n', '    mapping(address => int256) internal payoutsTo_;\n', '    uint256 internal tokenSupply_;\n', '    uint256 internal profitPerShare_;\n', '\n', '\n', '    /*=======================================\n', '    =            PUBLIC FUNCTIONS           =\n', '    =======================================*/\n', '\n', '    /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)\n', '    function buy(address _referredBy) public payable returns (uint256) {\n', '        purchaseTokens(msg.value, _referredBy);\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback function to handle ethereum that was send straight to the contract\n', '     *  Unfortunately we cannot use a referral address this way.\n', '     */\n', '    function() payable public {\n', '        purchaseTokens(msg.value, 0x0);\n', '    }\n', '\n', '    /// @dev Converts all of caller&#39;s dividends to tokens.\n', '    function reinvest() onlyStronghands public {\n', '        // fetch dividends\n', '        uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code\n', '\n', '        // pay out the dividends virtually\n', '        address _customerAddress = msg.sender;\n', '        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);\n', '\n', '        // retrieve ref. bonus\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '\n', '        // dispatch a buy order with the virtualized "withdrawn dividends"\n', '        uint256 _tokens = purchaseTokens(_dividends, 0x0);\n', '\n', '        // fire event\n', '        onReinvestment(_customerAddress, _dividends, _tokens);\n', '    }\n', '\n', '    /// @dev Alias of sell() and withdraw().\n', '    function exit() public {\n', '        // get token count for caller & sell them all\n', '        address _customerAddress = msg.sender;\n', '        uint256 _tokens = tokenBalanceLedger_[_customerAddress];\n', '        if (_tokens > 0) sell(_tokens);\n', '\n', '        // lambo delivery service\n', '        withdraw();\n', '    }\n', '\n', '    /// @dev Withdraws all of the callers earnings.\n', '    function withdraw() onlyStronghands public {\n', '        // setup data\n', '        address _customerAddress = msg.sender;\n', '        uint256 _dividends = myDividends(false); // get ref. bonus later in the code\n', '\n', '        // update dividend tracker\n', '        payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);\n', '\n', '        // add ref. bonus\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '\n', '        // lambo delivery service\n', '        _customerAddress.transfer(_dividends);\n', '\n', '        // fire event\n', '        onWithdraw(_customerAddress, _dividends);\n', '    }\n', '\n', '    /// @dev Liquifies tokens to ethereum.\n', '    function sell(uint256 _amountOfTokens) onlyBagholders public {\n', '        // setup data\n', '        address _customerAddress = msg.sender;\n', '        // russian hackers BTFO\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '        uint256 _tokens = _amountOfTokens;\n', '        uint256 _ethereum = tokensToEthereum_(_tokens);\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '\n', '        // burn the sold tokens\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);\n', '\n', '        // update dividends tracker\n', '        int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));\n', '        payoutsTo_[_customerAddress] -= _updatedPayouts;\n', '\n', '        // dividing by zero is a bad idea\n', '        if (tokenSupply_ > 0) {\n', '            // update the amount of dividends per token\n', '            profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);\n', '        }\n', '\n', '        // fire event\n', '        onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from the caller to a new holder.\n', '     *  \n', '     */\n', '    function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {\n', '        // setup\n', '        address _customerAddress = msg.sender;\n', '\n', '        // make sure we have the requested tokens\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '\n', '        // withdraw all outstanding dividends first\n', '        if (myDividends(true) > 0) {\n', '            withdraw();\n', '        }\n', '\n', '        \n', '        // these are dispersed to shareholders\n', '        uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);\n', '        uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);\n', '        uint256 _dividends = tokensToEthereum_(_tokenFee);\n', '\n', '        // burn the fee tokens\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);\n', '\n', '        // exchange tokens\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);\n', '\n', '        // update dividend trackers\n', '        payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);\n', '        payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);\n', '\n', '        // disperse dividends among holders\n', '        profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);\n', '\n', '        // fire event\n', '        Transfer(_customerAddress, _toAddress, _taxedTokens);\n', '\n', '        // ERC20\n', '        return true;\n', '    }\n', '\n', '\n', '    /*=====================================\n', '    =      HELPERS AND CALCULATORS        =\n', '    =====================================*/\n', '\n', '    /**\n', '     * @dev Method to view the current Ethereum stored in the contract\n', '     *  Example: totalEthereumBalance()\n', '     */\n', '    function totalEthereumBalance() public view returns (uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    /// @dev Retrieve the total token supply.\n', '    function totalSupply() public view returns (uint256) {\n', '        return tokenSupply_;\n', '    }\n', '\n', '    /// @dev Retrieve the tokens owned by the caller.\n', '    function myTokens() public view returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        return balanceOf(_customerAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev Retrieve the dividends owned by the caller.\n', '     *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.\n', '     *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)\n', '     *  But in the internal calculations, we want them separate.\n', '     */\n', '    function myDividends(bool _includeReferralBonus) public view returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;\n', '    }\n', '\n', '    /// @dev Retrieve the token balance of any single address.\n', '    function balanceOf(address _customerAddress) public view returns (uint256) {\n', '        return tokenBalanceLedger_[_customerAddress];\n', '    }\n', '\n', '    /// @dev Retrieve the dividend balance of any single address.\n', '    function dividendsOf(address _customerAddress) public view returns (uint256) {\n', '        return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;\n', '    }\n', '\n', '    /// @dev Return the sell price of 1 individual token.\n', '    function sellPrice() public view returns (uint256) {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if (tokenSupply_ == 0) {\n', '            return tokenPriceInitial_ - tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);\n', '            uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '\n', '    /// @dev Return the buy price of 1 individual token.\n', '    function buyPrice() public view returns (uint256) {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if (tokenSupply_ == 0) {\n', '            return tokenPriceInitial_ + tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);\n', '            uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);\n', '\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '\n', '    /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.\n', '    function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '\n', '        return _amountOfTokens;\n', '    }\n', '\n', '    /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.\n', '    function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {\n', '        require(_tokensToSell <= tokenSupply_);\n', '        uint256 _ethereum = tokensToEthereum_(_tokensToSell);\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '        return _taxedEthereum;\n', '    }\n', '\n', '\n', '    /*==========================================\n', '    =            INTERNAL FUNCTIONS            =\n', '    ==========================================*/\n', '\n', '    /// @dev Internal function to actually purchase the tokens.\n', '    function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {\n', '        // data setup\n', '        address _customerAddress = msg.sender;\n', '        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);\n', '        uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);\n', '        uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);\n', '        uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        uint256 _fee = _dividends * magnitude;\n', '\n', '        // no point in continuing execution if OP is a poorfag russian hacker\n', '        // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world\n', '        // (or hackers)\n', '        // and yes we know that the safemath function automatically rules out the "greater then" equasion.\n', '        require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);\n', '\n', '        // is the user referred by a masternode?\n', '        if (\n', '            // is this a referred purchase?\n', '            _referredBy != 0x0000000000000000000000000000000000000000 &&\n', '\n', '            // no cheating!\n', '            _referredBy != _customerAddress &&\n', '\n', '            // does the referrer have at least X whole tokens?\n', '            // i.e is the referrer a godly chad masternode\n', '            tokenBalanceLedger_[_referredBy] >= stakingRequirement\n', '        ) {\n', '            // wealth redistribution\n', '            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);\n', '        } else {\n', '            // no ref purchase\n', '            // add the referral bonus back to the global dividends cake\n', '            _dividends = SafeMath.add(_dividends, _referralBonus);\n', '            _fee = _dividends * magnitude;\n', '        }\n', '\n', '        // we can&#39;t give people infinite ethereum\n', '        if (tokenSupply_ > 0) {\n', '            // add tokens to the pool\n', '            tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);\n', '\n', '            // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder\n', '            profitPerShare_ += (_dividends * magnitude / tokenSupply_);\n', '\n', '            // calculate the amount of tokens the customer receives over his purchase\n', '            _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));\n', '        } else {\n', '            // add tokens to the pool\n', '            tokenSupply_ = _amountOfTokens;\n', '        }\n', '\n', '        // update circulating supply & the ledger address for the customer\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '\n', '        // Tells the contract that the buyer doesn&#39;t deserve dividends for the tokens before they owned them;\n', '        // really i know you think you do but you don&#39;t\n', '        int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);\n', '        payoutsTo_[_customerAddress] += _updatedPayouts;\n', '\n', '        // fire event\n', '        onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());\n', '\n', '        return _amountOfTokens;\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate Token price based on an amount of incoming ethereum\n', '     *  It&#39;s an algorithm, hopefully we gave you the whitepaper with it in scientific notation;\n', '     *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.\n', '     */\n', '    function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {\n', '        uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;\n', '        uint256 _tokensReceived =\n', '         (\n', '            (\n', '                // underflow attempts BTFO\n', '                SafeMath.sub(\n', '                    (sqrt\n', '                        (\n', '                            (_tokenPriceInitial ** 2)\n', '                            +\n', '                            (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))\n', '                            +\n', '                            ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))\n', '                            +\n', '                            (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)\n', '                        )\n', '                    ), _tokenPriceInitial\n', '                )\n', '            ) / (tokenPriceIncremental_)\n', '        ) - (tokenSupply_);\n', '\n', '        return _tokensReceived;\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate token sell value.\n', '     *  It&#39;s an algorithm, hopefully we gave you the whitepaper with it in scientific notation;\n', '     *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.\n', '     */\n', '    function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {\n', '        uint256 tokens_ = (_tokens + 1e18);\n', '        uint256 _tokenSupply = (tokenSupply_ + 1e18);\n', '        uint256 _etherReceived =\n', '        (\n', '            // underflow attempts BTFO\n', '            SafeMath.sub(\n', '                (\n', '                    (\n', '                        (\n', '                            tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))\n', '                        ) - tokenPriceIncremental_\n', '                    ) * (tokens_ - 1e18)\n', '                ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2\n', '            )\n', '        / 1e18);\n', '\n', '        return _etherReceived;\n', '    }\n', '\n', '    /// @dev This is where all your gas goes.\n', '    function sqrt(uint256 x) internal pure returns (uint256 y) {\n', '        uint256 z = (x + 1) / 2;\n', '        y = x;\n', '\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}']