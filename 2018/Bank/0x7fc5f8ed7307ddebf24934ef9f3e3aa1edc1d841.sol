['pragma solidity ^0.4.21;\n', '\n', '/*\n', '* JIGSAW IS BACK\n', '*\n', '* YOU TOUGHT THE GAME WAS OVER? THINK AGAIN \n', '* ARE YOU READY TO PARTICIPATE? OR ARE YOU AFRAID? MAKE JIGSAW LAUGH!\n', '* https://discord.gg/ZxEja6a\n', '* Jiggs.io is the only official website!\n', '* Only 1 token to activate your masterkey\n', '* 20% IN / 20% OUT / 33% MASTERNODE - DONT LIKE IT? STAY AWAY! DIVIDENDS LOVERS ONLY!\n', '* NO FUNNY ADMINISTRATOR/AMBASSADOR FUNCTIONS, FREEDOM TO EVERYONE!\n', '* NO DEV FEES, WHO NEED DEV FEES IF THE SITE KEEPS RUNNING FOR $10 A MONTH? WHAT A BULLSHIT\n', '* WE STAY REAL, 5% CHARITY FEE TO SEND JIGSAW ON VACATION, STRAIGHT TO THE POINT\n', '*/\n', '\n', '\n', 'contract JiggsRezurrection {\n', '    /*=================================\n', '    =            MODIFIERS            =\n', '    =================================*/\n', '    // only people with tokens\n', '    modifier onlyBagholders() {\n', '        require(myTokens() > 0);\n', '        _;\n', '    }\n', '\n', '    // only people with profits\n', '    modifier onlyStronghands() {\n', '        require(myDividends(true) > 0);\n', '        _;\n', '    }\n', '\n', '    modifier notContract() {\n', '      require (msg.sender == tx.origin);\n', '      _;\n', '    }\n', '\n', '    /*==============================\n', '    =            EVENTS            =\n', '    ==============================*/\n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 incomingEthereum,\n', '        uint256 tokensMinted,\n', '        address indexed referredBy\n', '    );\n', '\n', '    event onTokenSell(\n', '        address indexed customerAddress,\n', '        uint256 tokensBurned,\n', '        uint256 ethereumEarned\n', '    );\n', '\n', '    event onReinvestment(\n', '        address indexed customerAddress,\n', '        uint256 ethereumReinvested,\n', '        uint256 tokensMinted\n', '    );\n', '\n', '    event onWithdraw(\n', '        address indexed customerAddress,\n', '        uint256 ethereumWithdrawn\n', '    );\n', '\n', '    // ERC20\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 tokens\n', '    );\n', '\n', '\n', '    /*=====================================\n', '    =            CONFIGURABLES            =\n', '    =====================================*/\n', '    string public name = "Jiggs Rezurrection";\n', '    string public symbol = "Jiggs";\n', '    uint8 constant public decimals = 18;\n', '    uint8 constant internal dividendFee_ = 20; // FOR DIV LOVERS ONLY, THE AIR IS FOR FREE\n', '    uint8 constant internal charityFee_ = 5; // 5% CHARITY TO SEND JIGSAW ON VACATION\n', '    uint256 constant internal tokenPriceInitial_ = 0.000000000001 ether;\n', '    uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;\n', '    uint256 constant internal magnitude = 2**64;\n', '\n', '    address constant public giveEthCharityAddress = 0xE40FFEA88309174321ef230e10bfcCC7c2687f76;\n', '    uint256 public totalEthCharityRecieved; // WHAT IS SEND TO JIGSAW..?\n', '    uint256 public totalEthCharityCollected; // HOW MANY FLIGHT TICKETS CAN WE PURCHASE FOR JIGSAW?\n', '\n', '    // NO BULLSHIT, ONLY 1 TOKEN NEEDED, WE TAKE ALREADY 20% OF YOUR ETH\n', '    uint256 public stakingRequirement = 1e18;\n', '\n', '\n', '   /*================================\n', '    =            DATASETS            =\n', '    ================================*/\n', '    // amount of shares for each address (scaled number)\n', '    mapping(address => uint256) internal tokenBalanceLedger_;\n', '    mapping(address => uint256) internal referralBalance_;\n', '    mapping(address => int256) internal payoutsTo_;\n', '    mapping(address => uint256) internal ambassadorAccumulatedQuota_;\n', '    uint256 internal tokenSupply_ = 0;\n', '    uint256 internal profitPerShare_;\n', '\n', '\n', '\n', '    /*=======================================\n', '    =            PUBLIC FUNCTIONS            =\n', '    =======================================*/\n', '    /*\n', '    * -- APPLICATION ENTRY POINTS --\n', '    */\n', '    function JiggsR()\n', '        public\n', '    {\n', '   \n', '    }\n', '\n', '\n', '    /**\n', '     * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)\n', '     */\n', '    function buy(address _referredBy)\n', '        public\n', '        payable\n', '        returns(uint256)\n', '    {\n', '        purchaseInternal(msg.value, _referredBy);\n', '    }\n', '\n', '    /**\n', '     * Fallback function to handle ethereum that was send straight to the contract\n', '     * Unfortunately we cannot use a referral address this way.\n', '     */\n', '    function()\n', '        payable\n', '        public\n', '    {\n', '        purchaseInternal(msg.value, 0x0);\n', '    }\n', '\n', '    function payCharity() payable public {\n', '      uint256 ethToPay = SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);\n', '      require(ethToPay > 1);\n', '      totalEthCharityRecieved = SafeMath.add(totalEthCharityRecieved, ethToPay);\n', '      if(!giveEthCharityAddress.call.value(ethToPay).gas(400000)()) {\n', '         totalEthCharityRecieved = SafeMath.sub(totalEthCharityRecieved, ethToPay);\n', '      }\n', '    }\n', '\n', '    /**\n', "     * Converts all of caller's dividends to tokens.\n", '     */\n', '    function reinvest()\n', '        onlyStronghands()\n', '        public\n', '    {\n', '        // fetch dividends\n', '        uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code\n', '\n', '        // pay out the dividends virtually\n', '        address _customerAddress = msg.sender;\n', '        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);\n', '\n', '        // retrieve ref. bonus\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '\n', '        // dispatch a buy order with the virtualized "withdrawn dividends"\n', '        uint256 _tokens = purchaseTokens(_dividends, 0x0);\n', '\n', '        // fire event\n', '        onReinvestment(_customerAddress, _dividends, _tokens);\n', '    }\n', '\n', '    /**\n', '     * Alias of sell() and withdraw().\n', '     */\n', '    function exit()\n', '        public\n', '    {\n', '        // get token count for caller & sell them all\n', '        address _customerAddress = msg.sender;\n', '        uint256 _tokens = tokenBalanceLedger_[_customerAddress];\n', '        if(_tokens > 0) sell(_tokens);\n', '\n', '        // lambo delivery service\n', '        withdraw();\n', '    }\n', '\n', '    /**\n', '     * Withdraws all of the callers earnings.\n', '     */\n', '    function withdraw()\n', '        onlyStronghands()\n', '        public\n', '    {\n', '        // setup data\n', '        address _customerAddress = msg.sender;\n', '        uint256 _dividends = myDividends(false); // get ref. bonus later in the code\n', '\n', '        // update dividend tracker\n', '        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);\n', '\n', '        // add ref. bonus\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '\n', '        // lambo delivery service\n', '        _customerAddress.transfer(_dividends);\n', '\n', '        // fire event\n', '        onWithdraw(_customerAddress, _dividends);\n', '    }\n', '\n', '    /**\n', '     * Liquifies tokens to ethereum.\n', '     */\n', '    function sell(uint256 _amountOfTokens)\n', '        onlyBagholders()\n', '        public\n', '    {\n', '        // setup data\n', '        address _customerAddress = msg.sender;\n', '        // russian hackers BTFO\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '        uint256 _tokens = _amountOfTokens;\n', '        uint256 _ethereum = tokensToEthereum_(_tokens);\n', '\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);\n', '        uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);\n', '\n', '        // Take out dividends and then _charityPayout\n', '        uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);\n', '\n', '        // Add ethereum to send to charity\n', '        totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);\n', '\n', '        // burn the sold tokens\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);\n', '\n', '        // update dividends tracker\n', '        int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));\n', '        payoutsTo_[_customerAddress] -= _updatedPayouts;\n', '\n', '        // dividing by zero is a bad idea\n', '        if (tokenSupply_ > 0) {\n', '            // update the amount of dividends per token\n', '            profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);\n', '        }\n', '\n', '        // fire event\n', '        onTokenSell(_customerAddress, _tokens, _taxedEthereum);\n', '    }\n', '\n', '\n', '    /**\n', '     * Transfer tokens from the caller to a new holder.\n', '     * REMEMBER THIS IS 0% TRANSFER FEE\n', '     */\n', '    function transfer(address _toAddress, uint256 _amountOfTokens)\n', '        onlyBagholders()\n', '        public\n', '        returns(bool)\n', '    {\n', '        // setup\n', '        address _customerAddress = msg.sender;\n', '\n', '        // make sure we have the requested tokens\n', '        // also disables transfers until ambassador phase is over\n', '        // ( we dont want whale premines )\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '\n', '        // withdraw all outstanding dividends first\n', '        if(myDividends(true) > 0) withdraw();\n', '\n', '        // exchange tokens\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);\n', '\n', '        // update dividend trackers\n', '        payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);\n', '        payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);\n', '\n', '\n', '        // fire event\n', '        Transfer(_customerAddress, _toAddress, _amountOfTokens);\n', '\n', '        // ERC20\n', '        return true;\n', '    }\n', '\n', ' \n', '    /*----------  HELPERS AND CALCULATORS  ----------*/\n', '    /**\n', '     * Method to view the current Ethereum stored in the contract\n', '     * Example: totalEthereumBalance()\n', '     */\n', '    function totalEthereumBalance()\n', '        public\n', '        view\n', '        returns(uint)\n', '    {\n', '        return this.balance;\n', '    }\n', '\n', '    /**\n', '     * Retrieve the total token supply.\n', '     */\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        return tokenSupply_;\n', '    }\n', '\n', '    /**\n', '     * Retrieve the tokens owned by the caller.\n', '     */\n', '    function myTokens()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return balanceOf(_customerAddress);\n', '    }\n', '\n', '    /**\n', '     * Retrieve the dividends owned by the caller.\n', '     * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.\n', '     * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)\n', '     * But in the internal calculations, we want them separate.\n', '     */\n', '    function myDividends(bool _includeReferralBonus)\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;\n', '    }\n', '\n', '    /**\n', '     * Retrieve the token balance of any single address.\n', '     */\n', '    function balanceOf(address _customerAddress)\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return tokenBalanceLedger_[_customerAddress];\n', '    }\n', '\n', '    /**\n', '     * Retrieve the dividend balance of any single address.\n', '     */\n', '    function dividendsOf(address _customerAddress)\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;\n', '    }\n', '\n', '    /**\n', '     * Return the buy price of 1 individual token.\n', '     */\n', '    function sellPrice()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if(tokenSupply_ == 0){\n', '            return tokenPriceInitial_ - tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);\n', '            uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);\n', '            uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Return the sell price of 1 individual token.\n', '     */\n', '    function buyPrice()\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if(tokenSupply_ == 0){\n', '            return tokenPriceInitial_ + tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);\n', '            uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);\n', '            uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _charityPayout);\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Function for the frontend to dynamically retrieve the price scaling of buy orders.\n', '     */\n', '    function calculateTokensReceived(uint256 _ethereumToSpend)\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);\n', '        uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, charityFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _charityPayout);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        return _amountOfTokens;\n', '    }\n', '\n', '    /**\n', '     * Function for the frontend to dynamically retrieve the price scaling of sell orders.\n', '     */\n', '    function calculateEthereumReceived(uint256 _tokensToSell)\n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        require(_tokensToSell <= tokenSupply_);\n', '        uint256 _ethereum = tokensToEthereum_(_tokensToSell);\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);\n', '        uint256 _charityPayout = SafeMath.div(SafeMath.mul(_ethereum, charityFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _charityPayout);\n', '        return _taxedEthereum;\n', '    }\n', '\n', '    /**\n', '     * Function for the frontend to show ether waiting to be send to charity in contract\n', '     */\n', '    function etherToSendCharity()\n', '        public\n', '        view\n', '        returns(uint256) {\n', '        return SafeMath.sub(totalEthCharityCollected, totalEthCharityRecieved);\n', '    }\n', '\n', '\n', '    /*==========================================\n', '    =            INTERNAL FUNCTIONS            =\n', '    ==========================================*/\n', '\n', '    // Make sure we will send back excess if user sends more then 5 ether before 100 ETH in contract\n', '    function purchaseInternal(uint256 _incomingEthereum, address _referredBy)\n', '      notContract()// no contracts allowed\n', '      internal\n', '      returns(uint256) {\n', '\n', '      uint256 purchaseEthereum = _incomingEthereum;\n', '      uint256 excess;\n', '      if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether\n', '          if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether\n', '              purchaseEthereum = 5 ether;\n', '              excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);\n', '          }\n', '      }\n', '\n', '      purchaseTokens(purchaseEthereum, _referredBy);\n', '\n', '      if (excess > 0) {\n', '        msg.sender.transfer(excess);\n', '      }\n', '    }\n', '\n', '\n', '    function purchaseTokens(uint256 _incomingEthereum, address _referredBy)\n', '        internal\n', '        returns(uint256)\n', '    {\n', '        // data setup\n', '        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);\n', '        uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);\n', '        uint256 _charityPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, charityFee_), 100);\n', '        uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);\n', '        uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _charityPayout);\n', '\n', '        totalEthCharityCollected = SafeMath.add(totalEthCharityCollected, _charityPayout);\n', '\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        uint256 _fee = _dividends * magnitude;\n', '\n', '        // no point in continuing execution if OP is a poorfag russian hacker\n', '        // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world\n', '        // (or hackers)\n', '        // and yes we know that the safemath function automatically rules out the "greater then" equasion.\n', '        require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));\n', '\n', '        // is the user referred by a masternode?\n', '        if(\n', '            // is this a referred purchase?\n', '            _referredBy != 0x0000000000000000000000000000000000000000 &&\n', '\n', '            // no cheating!\n', '            _referredBy != msg.sender &&\n', '\n', '            // does the referrer have at least X whole tokens?\n', '            // i.e is the referrer a godly chad masternode\n', '            tokenBalanceLedger_[_referredBy] >= stakingRequirement\n', '        ){\n', '            // wealth redistribution\n', '            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);\n', '        } else {\n', '            // no ref purchase\n', '            // add the referral bonus back to the global dividends cake\n', '            _dividends = SafeMath.add(_dividends, _referralBonus);\n', '            _fee = _dividends * magnitude;\n', '        }\n', '\n', "        // we can't give people infinite ethereum\n", '        if(tokenSupply_ > 0){\n', '\n', '            // add tokens to the pool\n', '            tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);\n', '\n', '            // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder\n', '            profitPerShare_ += (_dividends * magnitude / (tokenSupply_));\n', '\n', '            // calculate the amount of tokens the customer receives over his purchase\n', '            _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));\n', '\n', '        } else {\n', '            // add tokens to the pool\n', '            tokenSupply_ = _amountOfTokens;\n', '        }\n', '\n', '        // update circulating supply & the ledger address for the customer\n', '        tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);\n', '\n', "        // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;\n", "        //really i know you think you do but you don't\n", '        int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);\n', '        payoutsTo_[msg.sender] += _updatedPayouts;\n', '\n', '        // fire event\n', '        onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);\n', '\n', '        return _amountOfTokens;\n', '    }\n', '\n', '    /**\n', '     * Calculate Token price based on an amount of incoming ethereum\n', "     * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;\n", '     * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.\n', '     */\n', '    function ethereumToTokens_(uint256 _ethereum)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '        uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;\n', '        uint256 _tokensReceived =\n', '         (\n', '            (\n', '                // underflow attempts BTFO\n', '                SafeMath.sub(\n', '                    (sqrt\n', '                        (\n', '                            (_tokenPriceInitial**2)\n', '                            +\n', '                            (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))\n', '                            +\n', '                            (((tokenPriceIncremental_)**2)*(tokenSupply_**2))\n', '                            +\n', '                            (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)\n', '                        )\n', '                    ), _tokenPriceInitial\n', '                )\n', '            )/(tokenPriceIncremental_)\n', '        )-(tokenSupply_)\n', '        ;\n', '\n', '        return _tokensReceived;\n', '    }\n', '\n', '    /**\n', '     * Calculate token sell value.\n', "     * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;\n", '     * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.\n', '     */\n', '     function tokensToEthereum_(uint256 _tokens)\n', '        internal\n', '        view\n', '        returns(uint256)\n', '    {\n', '\n', '        uint256 tokens_ = (_tokens + 1e18);\n', '        uint256 _tokenSupply = (tokenSupply_ + 1e18);\n', '        uint256 _etherReceived =\n', '        (\n', '            // underflow attempts BTFO\n', '            SafeMath.sub(\n', '                (\n', '                    (\n', '                        (\n', '                            tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))\n', '                        )-tokenPriceIncremental_\n', '                    )*(tokens_ - 1e18)\n', '                ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2\n', '            )\n', '        /1e18);\n', '        return _etherReceived;\n', '    }\n', '\n', '\n', '    //This is where all your gas goes, sorry\n', '    //Not sorry, you probably only paid 1 gwei\n', '    function sqrt(uint x) internal pure returns (uint y) {\n', '        uint z = (x + 1) / 2;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']