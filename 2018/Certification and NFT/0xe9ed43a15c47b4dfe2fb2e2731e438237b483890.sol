['pragma solidity ^0.4.0;\n', '\n', 'contract CrypteloERC20{\n', '  mapping (address => uint256) public balanceOf;\n', '  function transfer(address to, uint amount);\n', '  function burn(uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract CrypteloPreSale{\n', '  function isWhiteList(address _addr) public returns (uint _group);\n', '}\n', '\n', 'contract TadamWhitelistPublicSale{\n', '    function isWhiteListed(address _addr) returns (uint _group);\n', '    mapping (address => uint) public PublicSaleWhiteListed;\n', '}\n', '\n', 'contract CrypteloPublicSale{\n', '    using SafeMath for uint256;\n', '    mapping (address => bool) private owner;\n', '\n', '    \n', '    uint public contributorCounter = 0;\n', '    mapping (uint => address) contributor;\n', '    mapping (address => uint) contributorAmount;\n', '    \n', '    /*\n', '        Public Sale Timings and bonuses\n', '    */\n', '    \n', '    \n', '    uint ICOstartTime = 0; \n', '    uint ICOendTime = now + 46 days;\n', '    \n', '    //first 7 days bonus 25%\n', '    uint firstDiscountStartTime = ICOstartTime;\n', '    uint firstDiscountEndTime = ICOstartTime + 7 days;\n', '    \n', '    //day 7 to day 14 bonus 20%\n', '    uint secDiscountStartTime = ICOstartTime + 7 days;\n', '    uint secDiscountEndTime = ICOstartTime + 14 days;\n', '    \n', '    //day 14 to day 21 bonus 15%\n', '    uint thirdDiscountStartTime = ICOstartTime + 14 days;\n', '    uint thirdDiscountEndTime = ICOstartTime + 21 days;\n', '    \n', '    //day 21 to day 28 bonus 10%\n', '    uint fourthDiscountStartTime = ICOstartTime + 21 days;\n', '    uint fourthDiscountEndTime = ICOstartTime + 28 days;\n', '\n', '    /*\n', '        External addresses\n', '    */\n', '    address public ERC20Address; \n', '    address public preSaleContract;\n', '    address private forwardFundsWallet;\n', '    address public whiteListAddress;\n', '    \n', '    event eSendTokens(address _addr, uint _amount);\n', '    event eStateChange(bool state);\n', '    event eLog(string str, uint no);\n', '    event eWhiteList(address adr, uint group);\n', '    \n', '    function calculateBonus(uint _whiteListLevel) returns (uint _totalBonus){\n', '        uint timeBonus = currentTimeBonus();\n', '        uint totalBonus = 0;\n', '        uint whiteListBonus = 0;\n', '        if (_whiteListLevel == 1){\n', '            whiteListBonus = whiteListBonus.add(5);\n', '        }\n', '        totalBonus = totalBonus.add(timeBonus).add(whiteListBonus);\n', '        return totalBonus;\n', '    }\n', '    function currentTimeBonus () public returns (uint _bonus){\n', '        uint bonus = 0;\n', '        //ICO is running\n', '        if (now >= firstDiscountStartTime && now <= firstDiscountEndTime){\n', '            bonus = 25;\n', '        }else if(now >= secDiscountStartTime && now <= secDiscountEndTime){\n', '            bonus = 20;\n', '        }else if(now >= thirdDiscountStartTime && now <= thirdDiscountEndTime){\n', '            bonus = 15;\n', '        }else if(now >= fourthDiscountStartTime && now <= fourthDiscountEndTime){\n', '            bonus = 10;\n', '        }else{\n', '            bonus = 5;\n', '        }\n', '        return bonus;\n', '    }\n', '    \n', '    function CrypteloPublicSale(address _ERC20Address, address _preSaleContract, address _forwardFundsWallet, address _whiteListAddress ){\n', '        owner[msg.sender] = true;\n', '        ERC20Address = _ERC20Address;\n', '        preSaleContract = _preSaleContract;\n', '        forwardFundsWallet = _forwardFundsWallet;\n', '        whiteListAddress = _whiteListAddress;    \n', '    }\n', '    /*\n', '        States are\n', '            false - Paused - it doesn&#39;t accept payments\n', '            true - Live - accepts payments and disburse tokens if conditions meet\n', '    */\n', '    bool public currentState = false;\n', '\n', '    \n', '    /*\n', '        Financial Ratios \n', '    */\n', '    uint hardCapTokens = addDecimals(8,187500000);\n', '    uint raisedWei = 0;\n', '    uint tokensLeft = hardCapTokens;\n', '    uint reservedTokens = 0;\n', '    uint minimumDonationWei = 100000000000000000;\n', '    uint public tokensPerEther = addDecimals(8, 12500); //1250000000000\n', '    uint public tokensPerMicroEther = tokensPerEther.div(1000000);\n', '    \n', '    function () payable {\n', '\n', '        uint tokensToSend = 0;\n', '        uint amountEthWei = msg.value;\n', '        address sender = msg.sender;\n', '        \n', '        //check if its live\n', '        \n', '        require(currentState);\n', '        eLog("state OK", 0);\n', '        require(amountEthWei >= minimumDonationWei);\n', '        eLog("amount OK", amountEthWei);\n', '        \n', '        uint whiteListedLevel = isWhiteListed(sender);\n', '        require( whiteListedLevel > 0);\n', '\n', '        tokensToSend = calculateTokensToSend(amountEthWei, whiteListedLevel);\n', '        \n', '        require(tokensLeft >= tokensToSend);\n', '        eLog("tokens left vs tokens to send ok", tokensLeft);    \n', '        eLog("tokensToSend", tokensToSend);\n', '        \n', '        //test for minus\n', '        if (tokensToSend <= tokensLeft){\n', '            tokensLeft = tokensLeft.sub(tokensToSend);    \n', '        }\n', '        \n', '        addContributor(sender, tokensToSend);\n', '        reservedTokens = reservedTokens.add(tokensToSend);\n', '        eLog("send tokens ok", 0);\n', '        \n', '        forwardFunds(amountEthWei);\n', '        eLog("forward funds ok", amountEthWei);\n', '    }\n', '    \n', '    function  calculateTokensToSend(uint _amount_wei, uint _whiteListLevel) public returns (uint _tokensToSend){\n', '        uint tokensToSend = 0;\n', '        uint amountMicroEther = _amount_wei.div(1000000000000);\n', '        uint tokens = amountMicroEther.mul(tokensPerMicroEther);\n', '        \n', '        eLog("tokens: ", tokens);\n', '        uint bonusPerc = calculateBonus(_whiteListLevel); \n', '        uint bonusTokens = 0;\n', '        if (bonusPerc > 0){\n', '            bonusTokens = tokens.div(100).mul(bonusPerc);    \n', '        }\n', '        eLog("bonusTokens", bonusTokens); \n', '        \n', '        tokensToSend = tokens.add(bonusTokens);\n', '\n', '        eLog("tokensToSend", tokensToSend);  \n', '        return tokensToSend;\n', '    }\n', '    \n', '    function payContributorByNumber(uint _n) onlyOwner{\n', '        require(now > ICOendTime);\n', '        \n', '        address adr = contributor[_n];\n', '        uint amount = contributorAmount[adr];\n', '        sendTokens(adr, amount);\n', '        contributorAmount[adr] = 0;\n', '    }\n', '    \n', '    function payContributorByAdress(address _adr) {\n', '        require(now > ICOendTime);\n', '        uint amount = contributorAmount[_adr];\n', '        sendTokens(_adr, amount);\n', '        contributorAmount[_adr] = 0;\n', '    }\n', '    \n', '    function addContributor(address _addr, uint _amount) private{\n', '        contributor[contributorCounter] = _addr;\n', '        if (contributorAmount[_addr] > 0){\n', '            contributorAmount[_addr] += _amount;\n', '        }else{\n', '            contributorAmount[_addr] = _amount;    \n', '        }\n', '        \n', '        contributorCounter++;\n', '    }\n', '    function getContributorByAddress(address _addr) constant returns (uint _amount){\n', '        return contributorAmount[_addr];\n', '    }\n', '    \n', '    function getContributorByNumber(uint _n) constant returns (address _adr, uint _amount){\n', '        address contribAdr = contributor[_n];\n', '        uint amount = contributorAmount[contribAdr];\n', '        return (contribAdr, amount);\n', '        \n', '    }\n', '    \n', '    function forwardFunds(uint _amountEthWei) private{\n', '        raisedWei += _amountEthWei;\n', '        forwardFundsWallet.transfer(_amountEthWei);  //find balance\n', '    }\n', '    \n', '    function sendTokens(address _to, uint _amountCRL) private{\n', '        //invoke call on token address\n', '       CrypteloERC20 _tadamerc20;\n', '        _tadamerc20 = CrypteloERC20(ERC20Address);\n', '        _tadamerc20.transfer(_to, _amountCRL);\n', '        eSendTokens(_to, _amountCRL);\n', '    }\n', '    \n', '    function setCurrentState(bool _state) public onlyOwner {\n', '        currentState = _state;\n', '        eStateChange(_state);\n', '    } \n', '    \n', '    function burnAllTokens() public onlyOwner{\n', '        CrypteloERC20 _tadamerc20;\n', '        _tadamerc20 = CrypteloERC20(ERC20Address);\n', '        uint tokensToBurn = _tadamerc20.balanceOf(this);\n', '        require (tokensToBurn > reservedTokens);\n', '        tokensToBurn -= reservedTokens;\n', '        eLog("tokens burned", tokensToBurn);\n', '        _tadamerc20.burn(tokensToBurn);\n', '    }\n', '    \n', '    function isWhiteListed(address _address) returns (uint){\n', '        \n', '        /*\n', '            return values :\n', '            0 = not whitelisted at all,\n', '            1 = white listed early (pre sale or before 15th of March)\n', '            2 = white listed after 15th of March\n', '        */\n', '        uint256 whiteListedStatus = 0;\n', '        \n', '        TadamWhitelistPublicSale whitelistPublic;\n', '        whitelistPublic = TadamWhitelistPublicSale(whiteListAddress);\n', '        \n', '        uint256 PSaleGroup = whitelistPublic.PublicSaleWhiteListed(_address);\n', '        //if we have it in the PublicSale add it\n', '        if (PSaleGroup > 0){\n', '            whiteListedStatus = PSaleGroup;\n', '        }else{\n', '            CrypteloPreSale _testPreSale;\n', '            _testPreSale = CrypteloPreSale(preSaleContract);\n', '            if (_testPreSale.isWhiteList(_address) > 0){\n', '                //exists in the pre-sale white list threfore give em early 1\n', '                whiteListedStatus = 1;\n', '            }else{\n', '                //not found on either\n', '                whiteListedStatus = 0;\n', '            }\n', '        }\n', '        eWhiteList(_address, whiteListedStatus);\n', '        return whiteListedStatus;\n', '    }\n', '    \n', '    function addDecimals(uint _noDecimals, uint _toNumber) private returns (uint _finalNo) {\n', '        uint finalNo = _toNumber * (10 ** _noDecimals);\n', '        return finalNo;\n', '    }\n', '    \n', '    function withdrawAllTokens() public onlyOwner{\n', '        CrypteloERC20 _tadamerc20;\n', '        _tadamerc20 = CrypteloERC20(ERC20Address);\n', '        uint totalAmount = _tadamerc20.balanceOf(this);\n', '        require(totalAmount > reservedTokens);\n', '        uint toWithdraw = totalAmount.sub(reservedTokens);\n', '        sendTokens(msg.sender, toWithdraw);\n', '    }\n', '    \n', '    function withdrawAllEther() public onlyOwner{\n', '        msg.sender.send(this.balance);\n', '    }\n', '     \n', '    modifier onlyOwner(){\n', '        require(owner[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.0;\n', '\n', 'contract CrypteloERC20{\n', '  mapping (address => uint256) public balanceOf;\n', '  function transfer(address to, uint amount);\n', '  function burn(uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract CrypteloPreSale{\n', '  function isWhiteList(address _addr) public returns (uint _group);\n', '}\n', '\n', 'contract TadamWhitelistPublicSale{\n', '    function isWhiteListed(address _addr) returns (uint _group);\n', '    mapping (address => uint) public PublicSaleWhiteListed;\n', '}\n', '\n', 'contract CrypteloPublicSale{\n', '    using SafeMath for uint256;\n', '    mapping (address => bool) private owner;\n', '\n', '    \n', '    uint public contributorCounter = 0;\n', '    mapping (uint => address) contributor;\n', '    mapping (address => uint) contributorAmount;\n', '    \n', '    /*\n', '        Public Sale Timings and bonuses\n', '    */\n', '    \n', '    \n', '    uint ICOstartTime = 0; \n', '    uint ICOendTime = now + 46 days;\n', '    \n', '    //first 7 days bonus 25%\n', '    uint firstDiscountStartTime = ICOstartTime;\n', '    uint firstDiscountEndTime = ICOstartTime + 7 days;\n', '    \n', '    //day 7 to day 14 bonus 20%\n', '    uint secDiscountStartTime = ICOstartTime + 7 days;\n', '    uint secDiscountEndTime = ICOstartTime + 14 days;\n', '    \n', '    //day 14 to day 21 bonus 15%\n', '    uint thirdDiscountStartTime = ICOstartTime + 14 days;\n', '    uint thirdDiscountEndTime = ICOstartTime + 21 days;\n', '    \n', '    //day 21 to day 28 bonus 10%\n', '    uint fourthDiscountStartTime = ICOstartTime + 21 days;\n', '    uint fourthDiscountEndTime = ICOstartTime + 28 days;\n', '\n', '    /*\n', '        External addresses\n', '    */\n', '    address public ERC20Address; \n', '    address public preSaleContract;\n', '    address private forwardFundsWallet;\n', '    address public whiteListAddress;\n', '    \n', '    event eSendTokens(address _addr, uint _amount);\n', '    event eStateChange(bool state);\n', '    event eLog(string str, uint no);\n', '    event eWhiteList(address adr, uint group);\n', '    \n', '    function calculateBonus(uint _whiteListLevel) returns (uint _totalBonus){\n', '        uint timeBonus = currentTimeBonus();\n', '        uint totalBonus = 0;\n', '        uint whiteListBonus = 0;\n', '        if (_whiteListLevel == 1){\n', '            whiteListBonus = whiteListBonus.add(5);\n', '        }\n', '        totalBonus = totalBonus.add(timeBonus).add(whiteListBonus);\n', '        return totalBonus;\n', '    }\n', '    function currentTimeBonus () public returns (uint _bonus){\n', '        uint bonus = 0;\n', '        //ICO is running\n', '        if (now >= firstDiscountStartTime && now <= firstDiscountEndTime){\n', '            bonus = 25;\n', '        }else if(now >= secDiscountStartTime && now <= secDiscountEndTime){\n', '            bonus = 20;\n', '        }else if(now >= thirdDiscountStartTime && now <= thirdDiscountEndTime){\n', '            bonus = 15;\n', '        }else if(now >= fourthDiscountStartTime && now <= fourthDiscountEndTime){\n', '            bonus = 10;\n', '        }else{\n', '            bonus = 5;\n', '        }\n', '        return bonus;\n', '    }\n', '    \n', '    function CrypteloPublicSale(address _ERC20Address, address _preSaleContract, address _forwardFundsWallet, address _whiteListAddress ){\n', '        owner[msg.sender] = true;\n', '        ERC20Address = _ERC20Address;\n', '        preSaleContract = _preSaleContract;\n', '        forwardFundsWallet = _forwardFundsWallet;\n', '        whiteListAddress = _whiteListAddress;    \n', '    }\n', '    /*\n', '        States are\n', "            false - Paused - it doesn't accept payments\n", '            true - Live - accepts payments and disburse tokens if conditions meet\n', '    */\n', '    bool public currentState = false;\n', '\n', '    \n', '    /*\n', '        Financial Ratios \n', '    */\n', '    uint hardCapTokens = addDecimals(8,187500000);\n', '    uint raisedWei = 0;\n', '    uint tokensLeft = hardCapTokens;\n', '    uint reservedTokens = 0;\n', '    uint minimumDonationWei = 100000000000000000;\n', '    uint public tokensPerEther = addDecimals(8, 12500); //1250000000000\n', '    uint public tokensPerMicroEther = tokensPerEther.div(1000000);\n', '    \n', '    function () payable {\n', '\n', '        uint tokensToSend = 0;\n', '        uint amountEthWei = msg.value;\n', '        address sender = msg.sender;\n', '        \n', '        //check if its live\n', '        \n', '        require(currentState);\n', '        eLog("state OK", 0);\n', '        require(amountEthWei >= minimumDonationWei);\n', '        eLog("amount OK", amountEthWei);\n', '        \n', '        uint whiteListedLevel = isWhiteListed(sender);\n', '        require( whiteListedLevel > 0);\n', '\n', '        tokensToSend = calculateTokensToSend(amountEthWei, whiteListedLevel);\n', '        \n', '        require(tokensLeft >= tokensToSend);\n', '        eLog("tokens left vs tokens to send ok", tokensLeft);    \n', '        eLog("tokensToSend", tokensToSend);\n', '        \n', '        //test for minus\n', '        if (tokensToSend <= tokensLeft){\n', '            tokensLeft = tokensLeft.sub(tokensToSend);    \n', '        }\n', '        \n', '        addContributor(sender, tokensToSend);\n', '        reservedTokens = reservedTokens.add(tokensToSend);\n', '        eLog("send tokens ok", 0);\n', '        \n', '        forwardFunds(amountEthWei);\n', '        eLog("forward funds ok", amountEthWei);\n', '    }\n', '    \n', '    function  calculateTokensToSend(uint _amount_wei, uint _whiteListLevel) public returns (uint _tokensToSend){\n', '        uint tokensToSend = 0;\n', '        uint amountMicroEther = _amount_wei.div(1000000000000);\n', '        uint tokens = amountMicroEther.mul(tokensPerMicroEther);\n', '        \n', '        eLog("tokens: ", tokens);\n', '        uint bonusPerc = calculateBonus(_whiteListLevel); \n', '        uint bonusTokens = 0;\n', '        if (bonusPerc > 0){\n', '            bonusTokens = tokens.div(100).mul(bonusPerc);    \n', '        }\n', '        eLog("bonusTokens", bonusTokens); \n', '        \n', '        tokensToSend = tokens.add(bonusTokens);\n', '\n', '        eLog("tokensToSend", tokensToSend);  \n', '        return tokensToSend;\n', '    }\n', '    \n', '    function payContributorByNumber(uint _n) onlyOwner{\n', '        require(now > ICOendTime);\n', '        \n', '        address adr = contributor[_n];\n', '        uint amount = contributorAmount[adr];\n', '        sendTokens(adr, amount);\n', '        contributorAmount[adr] = 0;\n', '    }\n', '    \n', '    function payContributorByAdress(address _adr) {\n', '        require(now > ICOendTime);\n', '        uint amount = contributorAmount[_adr];\n', '        sendTokens(_adr, amount);\n', '        contributorAmount[_adr] = 0;\n', '    }\n', '    \n', '    function addContributor(address _addr, uint _amount) private{\n', '        contributor[contributorCounter] = _addr;\n', '        if (contributorAmount[_addr] > 0){\n', '            contributorAmount[_addr] += _amount;\n', '        }else{\n', '            contributorAmount[_addr] = _amount;    \n', '        }\n', '        \n', '        contributorCounter++;\n', '    }\n', '    function getContributorByAddress(address _addr) constant returns (uint _amount){\n', '        return contributorAmount[_addr];\n', '    }\n', '    \n', '    function getContributorByNumber(uint _n) constant returns (address _adr, uint _amount){\n', '        address contribAdr = contributor[_n];\n', '        uint amount = contributorAmount[contribAdr];\n', '        return (contribAdr, amount);\n', '        \n', '    }\n', '    \n', '    function forwardFunds(uint _amountEthWei) private{\n', '        raisedWei += _amountEthWei;\n', '        forwardFundsWallet.transfer(_amountEthWei);  //find balance\n', '    }\n', '    \n', '    function sendTokens(address _to, uint _amountCRL) private{\n', '        //invoke call on token address\n', '       CrypteloERC20 _tadamerc20;\n', '        _tadamerc20 = CrypteloERC20(ERC20Address);\n', '        _tadamerc20.transfer(_to, _amountCRL);\n', '        eSendTokens(_to, _amountCRL);\n', '    }\n', '    \n', '    function setCurrentState(bool _state) public onlyOwner {\n', '        currentState = _state;\n', '        eStateChange(_state);\n', '    } \n', '    \n', '    function burnAllTokens() public onlyOwner{\n', '        CrypteloERC20 _tadamerc20;\n', '        _tadamerc20 = CrypteloERC20(ERC20Address);\n', '        uint tokensToBurn = _tadamerc20.balanceOf(this);\n', '        require (tokensToBurn > reservedTokens);\n', '        tokensToBurn -= reservedTokens;\n', '        eLog("tokens burned", tokensToBurn);\n', '        _tadamerc20.burn(tokensToBurn);\n', '    }\n', '    \n', '    function isWhiteListed(address _address) returns (uint){\n', '        \n', '        /*\n', '            return values :\n', '            0 = not whitelisted at all,\n', '            1 = white listed early (pre sale or before 15th of March)\n', '            2 = white listed after 15th of March\n', '        */\n', '        uint256 whiteListedStatus = 0;\n', '        \n', '        TadamWhitelistPublicSale whitelistPublic;\n', '        whitelistPublic = TadamWhitelistPublicSale(whiteListAddress);\n', '        \n', '        uint256 PSaleGroup = whitelistPublic.PublicSaleWhiteListed(_address);\n', '        //if we have it in the PublicSale add it\n', '        if (PSaleGroup > 0){\n', '            whiteListedStatus = PSaleGroup;\n', '        }else{\n', '            CrypteloPreSale _testPreSale;\n', '            _testPreSale = CrypteloPreSale(preSaleContract);\n', '            if (_testPreSale.isWhiteList(_address) > 0){\n', '                //exists in the pre-sale white list threfore give em early 1\n', '                whiteListedStatus = 1;\n', '            }else{\n', '                //not found on either\n', '                whiteListedStatus = 0;\n', '            }\n', '        }\n', '        eWhiteList(_address, whiteListedStatus);\n', '        return whiteListedStatus;\n', '    }\n', '    \n', '    function addDecimals(uint _noDecimals, uint _toNumber) private returns (uint _finalNo) {\n', '        uint finalNo = _toNumber * (10 ** _noDecimals);\n', '        return finalNo;\n', '    }\n', '    \n', '    function withdrawAllTokens() public onlyOwner{\n', '        CrypteloERC20 _tadamerc20;\n', '        _tadamerc20 = CrypteloERC20(ERC20Address);\n', '        uint totalAmount = _tadamerc20.balanceOf(this);\n', '        require(totalAmount > reservedTokens);\n', '        uint toWithdraw = totalAmount.sub(reservedTokens);\n', '        sendTokens(msg.sender, toWithdraw);\n', '    }\n', '    \n', '    function withdrawAllEther() public onlyOwner{\n', '        msg.sender.send(this.balance);\n', '    }\n', '     \n', '    modifier onlyOwner(){\n', '        require(owner[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
