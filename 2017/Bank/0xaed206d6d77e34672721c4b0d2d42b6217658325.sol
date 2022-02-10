['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' *\n', ' * @author  <pratyush.bhatt@protonmail.com>\n', ' *\n', ' * RDFDM - Riverdimes Fiat Donation Manager\n', ' * Version E\n', ' *\n', ' * Overview:\n', ' * four basic round-up operations are supported:\n', ' *\n', ' * A) fiatCollected: Record Fiat Donation (collection)\n', ' *    inputs:        charity (C), fiat amount ($XX.XX),\n', ' *    summary:       creates a log of a fiat donation to a specified charity, C.\n', ' *    message:       $XX.XX collected FBO Charity C, internal document #ABC\n', " *    - add $XX.XX to chariy's fiatBalanceIn, fiatCollected\n", ' *\n', ' * B) fiatToEth:     Fiat Converted to ETH\n', ' *    inputs:        charity (C), fiat amount ($XX.XX), ETH amount (Z), document reference (ABC)\n', " *    summary:       deduct $XX.XX from charity C's fiatBalanceIn; credit charity C's ethBalanceIn. this operation is invoked\n", ' *                   when fiat donations are converted to ETH. it includes a deposit of Z ETH.\n', ' *    message(s):    On behalf of Charity C, $XX.XX used to purchase Z ETH\n', " *    - $XX.XX deducted from charity C's fiatBalanceIn\n", ' *    - skims 4% of Z for RD Token holders, and 16% for operational overhead\n', ' *    - credits charity C with 80% of Z ETH (ethBalance)\n', ' *\n', ' * C) ethToFiat:     ETH Converted to Fiat\n', ' *    inputs:        charity (C), ETH amount (Z), fiat amount ($XX.XX), document reference (ABC)\n', ' *    summary:       withdraw ETH from and convert to fiat\n', ' *    message(s):    Z ETH converted to $XX.XX FBO Charity C\n', " *    - deducts Z ETH from charity C's ethBalance\n", " *    - adds $XX.XX to charity C's fiatBalanceOut\n", ' *\n', ' * D) fiatDelivered: Record Fiat Delivery to Specified Charity\n', ' *    inputs:        charity (C), fiat amount ($XX.XX), document reference (ABC)\n', ' *    summary:       creates a log of a fiat delivery to a specified charity, C:\n', ' *    message:       $XX.XX delivered to Charity C, internal document #ABC\n', " *    - deducts the dollar amount, $XX.XX from charity's fiatBalanceOut\n", " *    - add $XX.XX to charity's totalDelivered\n", ' *\n', ' * one basic operation, unrelated to round-up\n', ' *\n', ' * A) ethDonation:        Direct ETH Donation to Charity\n', ' *    inputs:             charity (C), ETH amount (Z), document reference (ABC)\n', " *    summary:            ETH donation to a specified charity, crediting charity's ethBalance. ETH in transaction.\n", ' *    messages:           Z ETH donated to Charity C, internal document #ABC\n', " *    - add Z ETH to chariy's ethDonated\n", ' *    - skims 0.5% of Z for RD Token holders, and 1.5% for operational overhead\n', ' *    - credits charity C with 98% of Z ETH (ethBalance)\n', ' *\n', ' * in addition there are shortcut operations (related to round-up):\n', ' *\n', ' * A) fiatCollectedToEth: Record Fiat Donation (collection) and convert to ETH\n', ' *    inputs:             charity (C), fiat amount ($XX.XX), ETH amount (Z), document reference (ABC)\n', ' *    summary:            creates a log of a fiat donation to a specified charity, C; fiat donation is immediately converted to\n', " *                        ETH, crediting charity C's ethBalance. the transaction includes a deposit of Z ETH.\n", ' *    messages:           $XX.XX collected FBO Charity C, internal document #ABC\n', ' *                        On behalf of Charity C, $XX.XX used to purchase Z ETH\n', " *    - add $XX.XX to chariy's fiatCollected\n", ' *    - skims 4% of Z for RD Token holders, and 16% for operational overhead\n', ' *    - credits charity C with 80% of Z ETH (ethBalance)\n', ' *\n', ' * B) ethToFiatDelivered: Record ETH Conversion to Fiat; and Fiat Delivery to Specified Charity\n', ' *    inputs:             charity (C), ETH amount (Z), fiat amount ($XX.XX), document reference (ABC)\n', " *    summary:            withdraw ETH from charity C's ethBalance and convert to fiat; log fiat delivery of $XX.XX.\n", ' *    messages:           Z ETH converted to $XX.XX FBO Charity C\n', ' *                        $XX.XX delivered to Charity C, internal document #ABC\n', " *    - deducts Z ETH from charity C's ethBalance\n", " *    - add $XX.XX to charity's totalDelivered\n", ' *\n', ' */\n', '\n', 'contract RDFDM {\n', '\n', '  //events relating to donation operations\n', '  //\n', '  event FiatCollectedEvent(uint indexed charity, uint usd, string ref);\n', '  event FiatToEthEvent(uint indexed charity, uint usd, uint eth);\n', '  event EthToFiatEvent(uint indexed charity, uint eth, uint usd);\n', '  event FiatDeliveredEvent(uint indexed charity, uint usd, string ref);\n', '  event EthDonationEvent(uint indexed charity, uint eth);\n', '\n', '  //events relating to adding and deleting charities\n', '  //\n', '  event CharityAddedEvent(uint indexed charity, string name, uint8 currency);\n', '  event CharityModifiedEvent(uint indexed charity, string name, uint8 currency);\n', '\n', '  //currencies\n', '  //\n', '  uint constant  CURRENCY_USD  = 0x01;\n', '  uint constant  CURRENCY_EURO = 0x02;\n', '  uint constant  CURRENCY_NIS  = 0x03;\n', '  uint constant  CURRENCY_YUAN = 0x04;\n', '\n', '\n', '  struct Charity {\n', '    uint fiatBalanceIn;           // funds in external acct, collected fbo charity\n', '    uint fiatBalanceOut;          // funds in external acct, pending delivery to charity\n', '    uint fiatCollected;           // total collected since dawn of creation\n', '    uint fiatDelivered;           // total delivered since dawn of creation\n', '    uint ethDonated;              // total eth donated since dawn of creation\n', '    uint ethCredited;             // total eth credited to this charity since dawn of creation\n', '    uint ethBalance;              // current eth balance of this charity\n', '    uint fiatToEthPriceAccEth;    // keep track of fiat to eth conversion price: total eth\n', '    uint fiatToEthPriceAccFiat;   // keep track of fiat to eth conversion price: total fiat\n', '    uint ethToFiatPriceAccEth;    // kkep track of eth to fiat conversion price: total eth\n', '    uint ethToFiatPriceAccFiat;   // kkep track of eth to fiat conversion price: total fiat\n', '    uint8 currency;               // fiat amounts are in smallest denomination of currency\n', '    string name;                  // eg. "Salvation Army"\n', '  }\n', '\n', '  uint public charityCount;\n', '  address public owner;\n', '  address public manager;\n', '  address public token;           //token-holder fees sent to this address\n', '  address public operatorFeeAcct; //operations fees sent to this address\n', '  mapping (uint => Charity) public charities;\n', '  bool public isLocked;\n', '\n', '  modifier ownerOnly {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier managerOnly {\n', '    require(msg.sender == owner || msg.sender == manager);\n', '    _;\n', '  }\n', '\n', '  modifier unlockedOnly {\n', '    require(!isLocked);\n', '    _;\n', '  }\n', '\n', '\n', '  //\n', '  //constructor\n', '  //\n', '  function RDFDM() public {\n', '    owner = msg.sender;\n', '    manager = msg.sender;\n', '    token = msg.sender;\n', '    operatorFeeAcct = msg.sender;\n', '  }\n', '  function lock() public ownerOnly { isLocked = true; }\n', '  function setToken(address _token) public ownerOnly unlockedOnly { token = _token; }\n', '  function setOperatorFeeAcct(address _operatorFeeAcct) public ownerOnly { operatorFeeAcct = _operatorFeeAcct; }\n', '  function setManager(address _manager) public managerOnly { manager = _manager; }\n', '  function deleteManager() public managerOnly { manager = owner; }\n', '\n', '\n', '  function addCharity(string _name, uint8 _currency) public managerOnly {\n', '    charities[charityCount].name = _name;\n', '    charities[charityCount].currency = _currency;\n', '    CharityAddedEvent(charityCount, _name, _currency);\n', '    ++charityCount;\n', '  }\n', '\n', '  function modifyCharity(uint _charity, string _name, uint8 _currency) public managerOnly {\n', '    require(_charity < charityCount);\n', '    charities[_charity].name = _name;\n', '    charities[_charity].currency = _currency;\n', '    CharityModifiedEvent(_charity, _name, _currency);\n', '  }\n', '\n', '\n', '\n', '  //======== basic operations\n', '\n', '  function fiatCollected(uint _charity, uint _fiat, string _ref) public managerOnly {\n', '    require(_charity < charityCount);\n', '    charities[_charity].fiatBalanceIn += _fiat;\n', '    charities[_charity].fiatCollected += _fiat;\n', '    FiatCollectedEvent(_charity, _fiat, _ref);\n', '  }\n', '\n', '  function fiatToEth(uint _charity, uint _fiat) public managerOnly payable {\n', '    require(token != 0);\n', '    require(_charity < charityCount);\n', '    //keep track of fiat to eth conversion price\n', '    charities[_charity].fiatToEthPriceAccFiat += _fiat;\n', '    charities[_charity].fiatToEthPriceAccEth += msg.value;\n', '    charities[_charity].fiatBalanceIn -= _fiat;\n', '    uint _tokenCut = (msg.value * 4) / 100;\n', '    uint _operatorCut = (msg.value * 16) / 100;\n', '    uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;\n', '    operatorFeeAcct.transfer(_operatorCut);\n', '    token.transfer(_tokenCut);\n', '    charities[_charity].ethBalance += _charityCredit;\n', '    charities[_charity].ethCredited += _charityCredit;\n', '    FiatToEthEvent(_charity, _fiat, msg.value);\n', '  }\n', '\n', '  function ethToFiat(uint _charity, uint _eth, uint _fiat) public managerOnly {\n', '    require(_charity < charityCount);\n', '    require(charities[_charity].ethBalance >= _eth);\n', '    //keep track of fiat to eth conversion price\n', '    charities[_charity].ethToFiatPriceAccFiat += _fiat;\n', '    charities[_charity].ethToFiatPriceAccEth += _eth;\n', '    charities[_charity].ethBalance -= _eth;\n', '    charities[_charity].fiatBalanceOut += _fiat;\n', '    //withdraw funds to the caller\n', '    msg.sender.transfer(_eth);\n', '    EthToFiatEvent(_charity, _eth, _fiat);\n', '  }\n', '\n', '  function fiatDelivered(uint _charity, uint _fiat, string _ref) public managerOnly {\n', '    require(_charity < charityCount);\n', '    require(charities[_charity].fiatBalanceOut >= _fiat);\n', '    charities[_charity].fiatBalanceOut -= _fiat;\n', '    charities[_charity].fiatDelivered += _fiat;\n', '    FiatDeliveredEvent(_charity, _fiat, _ref);\n', '  }\n', '\n', '  //======== unrelated to round-up\n', '  function ethDonation(uint _charity) public payable {\n', '    require(token != 0);\n', '    require(_charity < charityCount);\n', '    uint _tokenCut = (msg.value * 1) / 200;\n', '    uint _operatorCut = (msg.value * 3) / 200;\n', '    uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;\n', '    operatorFeeAcct.transfer(_operatorCut);\n', '    token.transfer(_tokenCut);\n', '    charities[_charity].ethDonated += _charityCredit;\n', '    charities[_charity].ethBalance += _charityCredit;\n', '    charities[_charity].ethCredited += _charityCredit;\n', '    EthDonationEvent(_charity, msg.value);\n', '  }\n', '\n', '\n', '  //======== combo operations\n', '  function fiatCollectedToEth(uint _charity, uint _fiat, string _ref) public managerOnly payable {\n', '    require(token != 0);\n', '    require(_charity < charityCount);\n', '    charities[_charity].fiatCollected += _fiat;\n', '    //charities[_charity].fiatBalanceIn does not change, since we immediately convert to eth\n', '    //keep track of fiat to eth conversion price\n', '    charities[_charity].fiatToEthPriceAccFiat += _fiat;\n', '    charities[_charity].fiatToEthPriceAccEth += msg.value;\n', '    uint _tokenCut = (msg.value * 4) / 100;\n', '    uint _operatorCut = (msg.value * 16) / 100;\n', '    uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;\n', '    operatorFeeAcct.transfer(_operatorCut);\n', '    token.transfer(_tokenCut);\n', '    charities[_charity].ethBalance += _charityCredit;\n', '    charities[_charity].ethCredited += _charityCredit;\n', '    FiatCollectedEvent(_charity, _fiat, _ref);\n', '    FiatToEthEvent(_charity, _fiat, msg.value);\n', '  }\n', '\n', '  function ethToFiatDelivered(uint _charity, uint _eth, uint _fiat, string _ref) public managerOnly {\n', '    require(_charity < charityCount);\n', '    require(charities[_charity].ethBalance >= _eth);\n', '    //keep track of fiat to eth conversion price\n', '    charities[_charity].ethToFiatPriceAccFiat += _fiat;\n', '    charities[_charity].ethToFiatPriceAccEth += _eth;\n', '    charities[_charity].ethBalance -= _eth;\n', '    //charities[_charity].fiatBalanceOut does not change, since we immediately deliver\n', '    //withdraw funds to the caller\n', '    msg.sender.transfer(_eth);\n', '    EthToFiatEvent(_charity, _eth, _fiat);\n', '    charities[_charity].fiatDelivered += _fiat;\n', '    FiatDeliveredEvent(_charity, _fiat, _ref);\n', '  }\n', '\n', '\n', '  //note: constant fcn does not need safe math\n', '  function divRound(uint256 _x, uint256 _y) pure internal returns (uint256) {\n', '    uint256 z = (_x + (_y / 2)) / _y;\n', '    return z;\n', '  }\n', '\n', '  function quickAuditEthCredited(uint _charityIdx) public constant returns (uint _fiatCollected,\n', '                                                                            uint _fiatToEthNotProcessed,\n', '                                                                            uint _fiatToEthProcessed,\n', '                                                                            uint _fiatToEthPricePerEth,\n', '                                                                            uint _fiatToEthCreditedSzabo,\n', '                                                                            uint _fiatToEthAfterFeesSzabo,\n', '                                                                            uint _ethDonatedSzabo,\n', '                                                                            uint _ethDonatedAfterFeesSzabo,\n', '                                                                            uint _totalEthCreditedSzabo,\n', '                                                                            int _quickDiscrepancy) {\n', '    require(_charityIdx < charityCount);\n', '    Charity storage _charity = charities[_charityIdx];\n', '    _fiatCollected = _charity.fiatCollected;                                                   //eg. $450 = 45000\n', '    _fiatToEthNotProcessed = _charity.fiatBalanceIn;                                           //eg.            0\n', '    _fiatToEthProcessed = _fiatCollected - _fiatToEthNotProcessed;                             //eg.        45000\n', '    if (_charity.fiatToEthPriceAccEth == 0) {\n', '      _fiatToEthPricePerEth = 0;\n', '      _fiatToEthCreditedSzabo = 0;\n', '    } else {\n', '      _fiatToEthPricePerEth = divRound(_charity.fiatToEthPriceAccFiat * (1 ether),             //eg. 45000 * 10^18 = 45 * 10^21\n', '                                       _charity.fiatToEthPriceAccEth);                         //eg 1.5 ETH        = 15 * 10^17\n', '                                                                                               //               --------------------\n', '                                                                                               //                     3 * 10^4 (30000 cents per ether)\n', '      uint _szaboPerEth = 1 ether / 1 szabo;\n', '      _fiatToEthCreditedSzabo = divRound(_fiatToEthProcessed * _szaboPerEth,                  //eg. 45000 * 1,000,000 / 30000 = 1,500,000 (szabo)\n', '                                          _fiatToEthPricePerEth);\n', '      _fiatToEthAfterFeesSzabo = divRound(_fiatToEthCreditedSzabo * 8, 10);                   //eg. 1,500,000 * 8 / 10 = 1,200,000 (szabo)\n', '    }\n', '    _ethDonatedSzabo = divRound(_charity.ethDonated, 1 szabo);                                //eg. 1 ETH = 1 * 10^18 / 10^12 = 1,000,000 (szabo)\n', '    _ethDonatedAfterFeesSzabo = divRound(_ethDonatedSzabo * 98, 100);                         //eg. 1,000,000 * 98/100 = 980,000 (szabo)\n', '    _totalEthCreditedSzabo = _fiatToEthAfterFeesSzabo + _ethDonatedAfterFeesSzabo;            //eg  1,200,000 + 980,000 = 2,180,000 (szabo)\n', '    uint256 tecf = divRound(_charity.ethCredited, 1 szabo);                                   //eg. 2180000000000000000 * (10^-12) = 2,180,000\n', '    _quickDiscrepancy = int256(_totalEthCreditedSzabo) - int256(tecf);                        //eg. 0\n', '  }\n', '\n', '\n', '\n', '\n', '  //note: contant fcn does not need safe math\n', '  function quickAuditFiatDelivered(uint _charityIdx) public constant returns (uint _totalEthCreditedSzabo,\n', '                                                                              uint _ethNotProcessedSzabo,\n', '                                                                              uint _processedEthCreditedSzabo,\n', '                                                                              uint _ethToFiatPricePerEth,\n', '                                                                              uint _ethToFiatCreditedFiat,\n', '                                                                              uint _ethToFiatNotProcessed,\n', '                                                                              uint _ethToFiatProcessed,\n', '                                                                              uint _fiatDelivered,\n', '                                                                              int _quickDiscrepancy) {\n', '    require(_charityIdx < charityCount);\n', '    Charity storage _charity = charities[_charityIdx];\n', '    _totalEthCreditedSzabo = divRound(_charity.ethCredited, 1 szabo);                          //eg. 2180000000000000000 * (10^-12) = 2,180,000\n', '    _ethNotProcessedSzabo = divRound(_charity.ethBalance, 1 szabo);                            //eg. 1 ETH = 1 * 10^18 / 10^12 = 1,000,000 (szabo)\n', '    _processedEthCreditedSzabo = _totalEthCreditedSzabo - _ethNotProcessedSzabo;               //eg  1,180,000 szabo\n', '    if (_charity.ethToFiatPriceAccEth == 0) {\n', '      _ethToFiatPricePerEth = 0;\n', '      _ethToFiatCreditedFiat = 0;\n', '    } else {\n', '      _ethToFiatPricePerEth = divRound(_charity.ethToFiatPriceAccFiat * (1 ether),             //eg. 35400 * 10^18 = 3540000 * 10^16\n', '                                       _charity.ethToFiatPriceAccEth);                         //eg  1.180 ETH     =     118 * 10^16\n', '                                                                                               //               --------------------\n', '                                                                                               //                      30000 (30000 cents per ether)\n', '      uint _szaboPerEth = 1 ether / 1 szabo;\n', '      _ethToFiatCreditedFiat = divRound(_processedEthCreditedSzabo * _ethToFiatPricePerEth,    //eg. 1,180,000 * 30000 / 1,000,000 = 35400\n', '                                        _szaboPerEth);\n', '    }\n', '    _ethToFiatNotProcessed = _charity.fiatBalanceOut;\n', '    _ethToFiatProcessed = _ethToFiatCreditedFiat - _ethToFiatNotProcessed;\n', '    _fiatDelivered = _charity.fiatDelivered;\n', '    _quickDiscrepancy = int256(_ethToFiatProcessed) - int256(_fiatDelivered);\n', '  }\n', '\n', '\n', '  //\n', '  // default payable function.\n', '  //\n', '  function () public payable {\n', '    revert();\n', '  }\n', '\n', '  //for debug\n', '  //only available before the contract is locked\n', '  function haraKiri() public ownerOnly unlockedOnly {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '}']