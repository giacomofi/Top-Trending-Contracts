['contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '\n', '/**\n', ' * @title Contract for object that have an owner\n', ' */\n', 'contract Owned {\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public owner;\n', '\n', '    /**\n', '     * @dev Delegate contract to another person\n', '     * @param _owner New owner address\n', '     */\n', '    function setOwner(address _owner) onlyOwner\n', '    { owner = _owner; }\n', '\n', '    /**\n', '     * @dev Owner check modifier\n', '     */\n', '    modifier onlyOwner { if (msg.sender != owner) throw; _; }\n', '}\n', '\n', '\n', 'contract TRMCrowdsale is Owned {\n', '    using SafeMath for uint;\n', '\n', '    event Print(string _message, address _msgSender);\n', '\n', '    uint public ETHUSD = 38390; //in cent\n', '    address manager = 0xf5c723B7Cc90eaA3bEec7B05D6bbeBCd9AFAA69a;\n', '    address ETHUSDdemon = 0xb42f06b2fc28decc022985a1a35c7b868f91bd17;\n', '    address public multisig = 0xc2CDcE18deEcC1d5274D882aEd0FB082B813FFE8;\n', '    address public addressOfERC20Token = 0x8BeF0141e8D078793456C4b74f7E60640f618594;\n', '    ERC20 public token;\n', '\n', '    uint public startICO = now;\n', '    uint public endICO = 1519862400; // Thu, 01 Mar 2018 00:00:00 GMT\n', '    uint public endPostICO = 1525132800;  // Tue, 01 May 2018 00:00:00 GMT\n', '\n', '    uint public tokenIcoUsdCentPrice = 550;\n', '    uint public tokenPostIcoUsdCentPrice = 650;\n', '\n', '    uint public bonusWeiAmount = 100000000000000000000; //100 ETH\n', '    uint public smallBonusPercent = 333;\n', '    uint public bigBonusPercent = 333;\n', '    \n', '    bool public TRM1BonusActive = false;\n', '    uint public minTokenForSP = 1 * 100000000;\n', '    uint public tokenForSP = 500*100000000;\n', '    uint public tokenForSPSold = 0;\n', '    uint public tokenSPUsdCentPrice = 250;\n', '    address public addressOfERC20OldToken = 0x241684Ef15683ca57c42d8F4BB0e87D3427DdF1c;\n', '    ERC20 public oldToken;\n', '    \n', '    \n', '    \n', '\n', '\n', '    function TRMCrowdsale(){\n', '        owner = msg.sender;\n', '        token = ERC20(addressOfERC20Token);\n', '        oldToken = ERC20(addressOfERC20OldToken);\n', '        ETHUSDdemon = msg.sender;\n', '\n', '\n', '    }\n', '\n', '    function oldTokenBalance(address _holderAdress) constant returns (uint256) {\n', '        return oldToken.balanceOf(_holderAdress);\n', '    }\n', '    \n', '    function tokenBalance() constant returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }    \n', '\n', ' \n', '    function setAddressOfERC20Token(address _addressOfERC20Token) onlyOwner {\n', '        addressOfERC20Token = _addressOfERC20Token;\n', '        token = ERC20(addressOfERC20Token);\n', '    }\n', '    \n', '    function setAddressOfERC20OldToken(address _addressOfERC20OldToken) onlyOwner {\n', '        addressOfERC20OldToken = _addressOfERC20OldToken;\n', '        oldToken = ERC20(addressOfERC20OldToken);\n', '    }    \n', '\n', '    function transferToken(address _to, uint _value) returns (bool) {\n', '        require(msg.sender == manager);\n', '        return token.transfer(_to, _value);\n', '    }\n', '\n', '    function() payable {\n', '        doPurchase();\n', '    }\n', '\n', '    function doPurchase() payable {\n', '        require(now >= startICO && now < endPostICO);\n', '\n', '        require(msg.value > 0);\n', '\n', '        uint sum = msg.value;\n', '\n', '        uint tokensAmount;\n', '        \n', '        if((TRM1BonusActive)&&(oldToken.balanceOf(msg.sender)>=minTokenForSP)&&(tokenForSPSold<tokenForSP)){\n', '            tokensAmount = sum.mul(ETHUSD).div(tokenSPUsdCentPrice).div(10000000000);\n', '            \n', '            tokenForSPSold=tokenForSPSold.add(tokensAmount);\n', '        } else {\n', '\n', '            if(now < endICO){\n', '                tokensAmount = sum.mul(ETHUSD).div(tokenIcoUsdCentPrice).div(10000000000);\n', '            } else {\n', '                tokensAmount = sum.mul(ETHUSD).div(tokenPostIcoUsdCentPrice).div(10000000000);\n', '            }\n', '    \n', '    \n', '            //Bonus\n', '            if(sum < bonusWeiAmount){\n', '               tokensAmount = tokensAmount.mul(100+smallBonusPercent).div(100);\n', '            } else{\n', '               tokensAmount = tokensAmount.mul(100+bigBonusPercent).div(100);\n', '            }\n', '        }\n', '\n', '        if(tokenBalance() > tokensAmount){\n', '            require(token.transfer(msg.sender, tokensAmount));\n', '            multisig.transfer(msg.value);\n', '        } else {\n', '            manager.transfer(msg.value);\n', '            Print("Tokens will be released manually", msg.sender);\n', '        }\n', '\n', '\n', '    }\n', '\n', '    function setETHUSD( uint256 _newPrice ) {\n', '        require((msg.sender == ETHUSDdemon)||(msg.sender == manager));\n', '        ETHUSD = _newPrice;\n', '    }\n', '\n', '    function setBonus( uint256 _bonusWeiAmount, uint256 _smallBonusPercent, uint256 _bigBonusPercent ) {\n', '        require(msg.sender == manager);\n', '\n', '        bonusWeiAmount = _bonusWeiAmount;\n', '        smallBonusPercent = _smallBonusPercent;\n', '        bigBonusPercent = _bigBonusPercent;\n', '    }\n', '    \n', '    function setETHUSDdemon(address _ETHUSDdemon) \n', '    { \n', '        require(msg.sender == manager);\n', '        ETHUSDdemon = _ETHUSDdemon; \n', '    }\n', '    \n', '    function setTokenSPUsdCentPrice(uint _tokenSPUsdCentPrice) \n', '    { \n', '        require(msg.sender == manager);\n', '        tokenSPUsdCentPrice = _tokenSPUsdCentPrice; \n', '    }    \n', '\n', '    function setMinTokenForSP(uint _minTokenForSP) \n', '    { \n', '        require(msg.sender == manager);\n', '        minTokenForSP = _minTokenForSP; \n', '    }   \n', '    \n', '    function setTRM1BonusActive(bool _TRM1BonusActive) \n', '    { \n', '        require(msg.sender == manager);\n', '        TRM1BonusActive = _TRM1BonusActive; \n', '    }  \n', '    \n', '    function setTokenForSP(uint _tokenForSP) \n', '    { \n', '        require(msg.sender == manager);\n', '        tokenForSP = _tokenForSP; \n', '        tokenForSPSold = 0;\n', '    }       \n', '}']
['contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '\n', '/**\n', ' * @title Contract for object that have an owner\n', ' */\n', 'contract Owned {\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public owner;\n', '\n', '    /**\n', '     * @dev Delegate contract to another person\n', '     * @param _owner New owner address\n', '     */\n', '    function setOwner(address _owner) onlyOwner\n', '    { owner = _owner; }\n', '\n', '    /**\n', '     * @dev Owner check modifier\n', '     */\n', '    modifier onlyOwner { if (msg.sender != owner) throw; _; }\n', '}\n', '\n', '\n', 'contract TRMCrowdsale is Owned {\n', '    using SafeMath for uint;\n', '\n', '    event Print(string _message, address _msgSender);\n', '\n', '    uint public ETHUSD = 38390; //in cent\n', '    address manager = 0xf5c723B7Cc90eaA3bEec7B05D6bbeBCd9AFAA69a;\n', '    address ETHUSDdemon = 0xb42f06b2fc28decc022985a1a35c7b868f91bd17;\n', '    address public multisig = 0xc2CDcE18deEcC1d5274D882aEd0FB082B813FFE8;\n', '    address public addressOfERC20Token = 0x8BeF0141e8D078793456C4b74f7E60640f618594;\n', '    ERC20 public token;\n', '\n', '    uint public startICO = now;\n', '    uint public endICO = 1519862400; // Thu, 01 Mar 2018 00:00:00 GMT\n', '    uint public endPostICO = 1525132800;  // Tue, 01 May 2018 00:00:00 GMT\n', '\n', '    uint public tokenIcoUsdCentPrice = 550;\n', '    uint public tokenPostIcoUsdCentPrice = 650;\n', '\n', '    uint public bonusWeiAmount = 100000000000000000000; //100 ETH\n', '    uint public smallBonusPercent = 333;\n', '    uint public bigBonusPercent = 333;\n', '    \n', '    bool public TRM1BonusActive = false;\n', '    uint public minTokenForSP = 1 * 100000000;\n', '    uint public tokenForSP = 500*100000000;\n', '    uint public tokenForSPSold = 0;\n', '    uint public tokenSPUsdCentPrice = 250;\n', '    address public addressOfERC20OldToken = 0x241684Ef15683ca57c42d8F4BB0e87D3427DdF1c;\n', '    ERC20 public oldToken;\n', '    \n', '    \n', '    \n', '\n', '\n', '    function TRMCrowdsale(){\n', '        owner = msg.sender;\n', '        token = ERC20(addressOfERC20Token);\n', '        oldToken = ERC20(addressOfERC20OldToken);\n', '        ETHUSDdemon = msg.sender;\n', '\n', '\n', '    }\n', '\n', '    function oldTokenBalance(address _holderAdress) constant returns (uint256) {\n', '        return oldToken.balanceOf(_holderAdress);\n', '    }\n', '    \n', '    function tokenBalance() constant returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }    \n', '\n', ' \n', '    function setAddressOfERC20Token(address _addressOfERC20Token) onlyOwner {\n', '        addressOfERC20Token = _addressOfERC20Token;\n', '        token = ERC20(addressOfERC20Token);\n', '    }\n', '    \n', '    function setAddressOfERC20OldToken(address _addressOfERC20OldToken) onlyOwner {\n', '        addressOfERC20OldToken = _addressOfERC20OldToken;\n', '        oldToken = ERC20(addressOfERC20OldToken);\n', '    }    \n', '\n', '    function transferToken(address _to, uint _value) returns (bool) {\n', '        require(msg.sender == manager);\n', '        return token.transfer(_to, _value);\n', '    }\n', '\n', '    function() payable {\n', '        doPurchase();\n', '    }\n', '\n', '    function doPurchase() payable {\n', '        require(now >= startICO && now < endPostICO);\n', '\n', '        require(msg.value > 0);\n', '\n', '        uint sum = msg.value;\n', '\n', '        uint tokensAmount;\n', '        \n', '        if((TRM1BonusActive)&&(oldToken.balanceOf(msg.sender)>=minTokenForSP)&&(tokenForSPSold<tokenForSP)){\n', '            tokensAmount = sum.mul(ETHUSD).div(tokenSPUsdCentPrice).div(10000000000);\n', '            \n', '            tokenForSPSold=tokenForSPSold.add(tokensAmount);\n', '        } else {\n', '\n', '            if(now < endICO){\n', '                tokensAmount = sum.mul(ETHUSD).div(tokenIcoUsdCentPrice).div(10000000000);\n', '            } else {\n', '                tokensAmount = sum.mul(ETHUSD).div(tokenPostIcoUsdCentPrice).div(10000000000);\n', '            }\n', '    \n', '    \n', '            //Bonus\n', '            if(sum < bonusWeiAmount){\n', '               tokensAmount = tokensAmount.mul(100+smallBonusPercent).div(100);\n', '            } else{\n', '               tokensAmount = tokensAmount.mul(100+bigBonusPercent).div(100);\n', '            }\n', '        }\n', '\n', '        if(tokenBalance() > tokensAmount){\n', '            require(token.transfer(msg.sender, tokensAmount));\n', '            multisig.transfer(msg.value);\n', '        } else {\n', '            manager.transfer(msg.value);\n', '            Print("Tokens will be released manually", msg.sender);\n', '        }\n', '\n', '\n', '    }\n', '\n', '    function setETHUSD( uint256 _newPrice ) {\n', '        require((msg.sender == ETHUSDdemon)||(msg.sender == manager));\n', '        ETHUSD = _newPrice;\n', '    }\n', '\n', '    function setBonus( uint256 _bonusWeiAmount, uint256 _smallBonusPercent, uint256 _bigBonusPercent ) {\n', '        require(msg.sender == manager);\n', '\n', '        bonusWeiAmount = _bonusWeiAmount;\n', '        smallBonusPercent = _smallBonusPercent;\n', '        bigBonusPercent = _bigBonusPercent;\n', '    }\n', '    \n', '    function setETHUSDdemon(address _ETHUSDdemon) \n', '    { \n', '        require(msg.sender == manager);\n', '        ETHUSDdemon = _ETHUSDdemon; \n', '    }\n', '    \n', '    function setTokenSPUsdCentPrice(uint _tokenSPUsdCentPrice) \n', '    { \n', '        require(msg.sender == manager);\n', '        tokenSPUsdCentPrice = _tokenSPUsdCentPrice; \n', '    }    \n', '\n', '    function setMinTokenForSP(uint _minTokenForSP) \n', '    { \n', '        require(msg.sender == manager);\n', '        minTokenForSP = _minTokenForSP; \n', '    }   \n', '    \n', '    function setTRM1BonusActive(bool _TRM1BonusActive) \n', '    { \n', '        require(msg.sender == manager);\n', '        TRM1BonusActive = _TRM1BonusActive; \n', '    }  \n', '    \n', '    function setTokenForSP(uint _tokenForSP) \n', '    { \n', '        require(msg.sender == manager);\n', '        tokenForSP = _tokenForSP; \n', '        tokenForSPSold = 0;\n', '    }       \n', '}']