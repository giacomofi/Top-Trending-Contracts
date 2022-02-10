['pragma solidity ^0.4.25;\n', '\n', '/*\n', '* http://etherminer.club\n', '*\n', '* EthMiner Pro concept\n', '*\n', '* [✓] 25% Withdraw fee\n', '* [✓] 15% Deposit fee\n', '* [✓] 1% Token transfer\n', '* [✓] 30% Referral link\n', '*\n', '*/\n', '\n', 'contract EtherMiner{\n', '\n', '    modifier onlyBagholders {\n', '        require(myTokens() > 0);\n', '        _;\n', '    }\n', '\n', '    modifier onlyStronghands {\n', '        require(myDividends(true) > 0);\n', '        _;\n', '    }\n', '\n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 incomingEthereum,\n', '        uint256 tokensMinted,\n', '        address indexed referredBy,\n', '        uint timestamp,\n', '        uint256 price\n', ');\n', '\n', '    event onTokenSell(\n', '        address indexed customerAddress,\n', '        uint256 tokensBurned,\n', '        uint256 ethereumEarned,\n', '        uint timestamp,\n', '        uint256 price\n', ');\n', '\n', '    event onReinvestment(\n', '        address indexed customerAddress,\n', '        uint256 ethereumReinvested,\n', '        uint256 tokensMinted\n', ');\n', '\n', '    event onWithdraw(\n', '        address indexed customerAddress,\n', '        uint256 ethereumWithdrawn\n', ');\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 tokens\n', ');\n', '\n', '    string public name = "EtherMiner";\n', '    string public symbol = "ETM";\n', '    uint8 constant public decimals = 18;\n', '    uint8 constant internal entryFee_ = 15;\n', '    uint8 constant internal transferFee_ = 1;\n', '    uint8 constant internal exitFee_ = 25;\n', '    uint8 constant internal refferalFee_ = 30;\n', '    uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;\n', '    uint256 constant internal tokenPriceIncremental_ = 0.0000001 ether;\n', '    uint256 constant internal magnitude = 2 ** 64;\n', '    uint256 public stakingRequirement = 50e18;\n', '    mapping(address => uint256) internal tokenBalanceLedger_;\n', '    mapping(address => uint256) internal referralBalance_;\n', '    mapping(address => int256) internal payoutsTo_;\n', '    uint256 internal tokenSupply_;\n', '    uint256 internal profitPerShare_;\n', '\n', '    function buy(address _referredBy) public payable returns (uint256) {\n', '        purchaseTokens(msg.value, _referredBy);\n', '    }\n', '\n', '    function() payable public {\n', '        purchaseTokens(msg.value, 0x0);\n', '    }\n', '\n', '    function reinvest() onlyStronghands public {\n', '        uint256 _dividends = myDividends(false);\n', '        address _customerAddress = msg.sender;\n', '        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '        uint256 _tokens = purchaseTokens(_dividends, 0x0);\n', '        emit onReinvestment(_customerAddress, _dividends, _tokens);\n', '    }\n', '\n', '    function exit() public {\n', '        address _customerAddress = msg.sender;\n', '        uint256 _tokens = tokenBalanceLedger_[_customerAddress];\n', '        if (_tokens > 0) sell(_tokens);\n', '        withdraw();\n', '    }\n', '\n', '    function withdraw() onlyStronghands public {\n', '        address _customerAddress = msg.sender;\n', '        uint256 _dividends = myDividends(false);\n', '        payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '        _customerAddress.transfer(_dividends);\n', '        emit onWithdraw(_customerAddress, _dividends);\n', '    }\n', '\n', '    function sell(uint256 _amountOfTokens) onlyBagholders public {\n', '        address _customerAddress = msg.sender;\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '        uint256 _tokens = _amountOfTokens;\n', '        uint256 _ethereum = tokensToEthereum_(_tokens);\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);\n', '\n', '        int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));\n', '        payoutsTo_[_customerAddress] -= _updatedPayouts;\n', '\n', '        if (tokenSupply_ > 0) {\n', '            profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);\n', '        }\n', '        emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());\n', '    }\n', '\n', '    function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {\n', '        address _customerAddress = msg.sender;\n', '        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);\n', '\n', '        if (myDividends(true) > 0) {\n', '            withdraw();\n', '        }\n', '\n', '        uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);\n', '        uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);\n', '        uint256 _dividends = tokensToEthereum_(_tokenFee);\n', '\n', '        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);\n', '        payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);\n', '        payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);\n', '        profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);\n', '        emit Transfer(_customerAddress, _toAddress, _taxedTokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    function totalEthereumBalance() public view returns (uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return tokenSupply_;\n', '    }\n', '\n', '    function myTokens() public view returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        return balanceOf(_customerAddress);\n', '    }\n', '\n', '    function myDividends(bool _includeReferralBonus) public view returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;\n', '    }\n', '\n', '    function balanceOf(address _customerAddress) public view returns (uint256) {\n', '        return tokenBalanceLedger_[_customerAddress];\n', '    }\n', '\n', '    function dividendsOf(address _customerAddress) public view returns (uint256) {\n', '        return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;\n', '    }\n', '\n', '    function sellPrice() public view returns (uint256) {\n', '        // our calculation relies on the token supply, so we need supply. Doh.\n', '        if (tokenSupply_ == 0) {\n', '            return tokenPriceInitial_ - tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);\n', '            uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '\n', '    function buyPrice() public view returns (uint256) {\n', '        if (tokenSupply_ == 0) {\n', '            return tokenPriceInitial_ + tokenPriceIncremental_;\n', '        } else {\n', '            uint256 _ethereum = tokensToEthereum_(1e18);\n', '            uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);\n', '            uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);\n', '\n', '            return _taxedEthereum;\n', '        }\n', '    }\n', '\n', '    function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '\n', '        return _amountOfTokens;\n', '    }\n', '\n', '    function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {\n', '        require(_tokensToSell <= tokenSupply_);\n', '        uint256 _ethereum = tokensToEthereum_(_tokensToSell);\n', '        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);\n', '        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);\n', '        return _taxedEthereum;\n', '    }\n', '\n', '\n', '    function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);\n', '        uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);\n', '        uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);\n', '        uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);\n', '        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);\n', '        uint256 _fee = _dividends * magnitude;\n', '\n', '        require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);\n', '\n', '        if (\n', '            _referredBy != 0x0000000000000000000000000000000000000000 &&\n', '            _referredBy != _customerAddress &&\n', '            tokenBalanceLedger_[_referredBy] >= stakingRequirement\n', '        ) {\n', '            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);\n', '        } else {\n', '            _dividends = SafeMath.add(_dividends, _referralBonus);\n', '            _fee = _dividends * magnitude;\n', '        }\n', '\n', '        if (tokenSupply_ > 0) {\n', '            tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);\n', '            profitPerShare_ += (_dividends * magnitude / tokenSupply_);\n', '            _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));\n', '        } else {\n', '            tokenSupply_ = _amountOfTokens;\n', '        }\n', '\n', '        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);\n', '        int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);\n', '        payoutsTo_[_customerAddress] += _updatedPayouts;\n', '        emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());\n', '\n', '        return _amountOfTokens;\n', '    }\n', '\n', '    function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {\n', '        uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;\n', '        uint256 _tokensReceived =\n', '            (\n', '                (\n', '                    SafeMath.sub(\n', '                        (sqrt\n', '                            (\n', '                                (_tokenPriceInitial ** 2)\n', '                                +\n', '                                (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))\n', '                                +\n', '                                ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))\n', '                                +\n', '                                (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)\n', '                            )\n', '                        ), _tokenPriceInitial\n', '                    )\n', '                ) / (tokenPriceIncremental_)\n', '            ) - (tokenSupply_);\n', '\n', '        return _tokensReceived;\n', '    }\n', '\n', '    function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {\n', '        uint256 tokens_ = (_tokens + 1e18);\n', '        uint256 _tokenSupply = (tokenSupply_ + 1e18);\n', '        uint256 _etherReceived =\n', '            (\n', '                SafeMath.sub(\n', '                    (\n', '                        (\n', '                            (\n', '                                tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))\n', '                            ) - tokenPriceIncremental_\n', '                        ) * (tokens_ - 1e18)\n', '                    ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2\n', '                )\n', '                / 1e18);\n', '\n', '        return _etherReceived;\n', '    }\n', '\n', '    function sqrt(uint256 x) internal pure returns (uint256 y) {\n', '        uint256 z = (x + 1) / 2;\n', '        y = x;\n', '\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '\n', '\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']