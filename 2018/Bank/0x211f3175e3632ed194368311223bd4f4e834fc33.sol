['pragma solidity ^0.4.24;\n', '\n', '//    _____ _     _      _                _____           _    \n', '//   / ____| |   (_)    | |              |  __ \\         | |   \n', '//  | |    | |__  _  ___| | _____ _ __   | |__) |_ _ _ __| | __\n', '//  | |    | &#39;_ \\| |/ __| |/ / _ \\ &#39;_ \\  |  ___/ _` | &#39;__| |/ /\n', '//  | |____| | | | | (__|   <  __/ | | | | |  | (_| | |  |   < \n', '//   \\_____|_| |_|_|\\___|_|\\_\\___|_| |_| |_|   \\__,_|_|  |_|\\_\\\n', '\n', '// ------- What? ------- \n', '//A home for blockchain games.\n', '\n', '// ------- How? ------- \n', '//Buy CKN Token before playing any games.\n', '//You can buy & sell CKN in this contract at anytime and anywhere.\n', '//As the amount of ETH in the contract increases to 10,000, the dividend will gradually drop to 2%.\n', '\n', '//We got 4 phase in the Roadmap, will launch Plasma chain in the phase 2.\n', '\n', '// ------- How? ------- \n', '//10/2018 SIMPLE E-SPORT\n', '//11/2018 SPORT PREDICTION\n', '//02/2019 MOBILE GAME\n', '//06/2019 MMORPG\n', '\n', '// ------- Who? ------- \n', '//Only 1/10 smarter than vitalik.\n', '//<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="d0b1b4bdb9be90b3b8b9b3bbb5bea0b1a2bbfeb9bf">[email&#160;protected]</a>\n', '//Sometime we think plama is a Pseudo topic, but it&#39;s a only way to speed up the TPS.\n', '//And Everybody will also trust the Node & Result.\n', '\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) \n', '        internal \n', '        pure \n', '        returns (uint256 c) \n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath mul failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256) \n', '    {\n', '        require(b <= a, "SafeMath sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath add failed");\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square root of given x.\n', '     */\n', '    function sqrt(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256 y) \n', '    {\n', '        uint256 z = ((add(x,1)) / 2);\n', '        y = x;\n', '        while (z < y) \n', '        {\n', '            y = z;\n', '            z = ((add((x / z),z)) / 2);\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square. multiplies x by x\n', '     */\n', '    function sq(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return (mul(x,x));\n', '    }\n', '    \n', '    /**\n', '     * @dev x to the power of y \n', '     */\n', '    function pwr(uint256 x, uint256 y)\n', '        internal \n', '        pure \n', '        returns (uint256)\n', '    {\n', '        if (x==0)\n', '            return (0);\n', '        else if (y==0)\n', '            return (1);\n', '        else \n', '        {\n', '            uint256 z = x;\n', '            for (uint256 i=1; i < y; i++)\n', '                z = mul(z,x);\n', '            return (z);\n', '        }\n', '    }   \n', '}\n', '\n', 'contract ERC223ReceivingContract { \n', '/**\n', ' * @dev Standard ERC223 function that will handle incoming token transfers.\n', ' *\n', ' * @param _from  Token sender address.\n', ' * @param _value Amount of tokens.\n', ' * @param _data  Transaction metadata.\n', ' */\n', '    function tokenFallback(address _from, uint _value, bytes _data)public;\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', 'contract ChickenPark is Owned{\n', '\n', '    using SafeMath for *;\n', '\n', '    modifier notContract() {\n', '        require (msg.sender == tx.origin);\n', '        _;\n', '    }\n', '    \n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint tokens\n', '    );\n', '\n', '    event Approval(\n', '        address indexed tokenOwner,\n', '        address indexed spender,\n', '        uint tokens\n', '    );\n', '\n', '    event CKNPrice(\n', '        address indexed who,\n', '        uint prePrice,\n', '        uint afterPrice,\n', '        uint ethValue,\n', '        uint token,\n', '        uint timestamp,\n', '        string action\n', '    );\n', '    \n', '    event Withdraw(\n', '        address indexed who,\n', '        uint dividents\n', '    );\n', '\n', '    /*=====================================\n', '    =            CONSTANTS                =\n', '    =====================================*/\n', '    uint8 constant public                decimals              = 18;\n', '    uint constant internal               tokenPriceInitial_    = 0.00001 ether;\n', '    uint constant internal               magnitude             = 2**64;\n', '\n', '    /*================================\n', '    =          CONFIGURABLES         =\n', '    ================================*/\n', '    string public                        name               = "Chicken Park Coin";\n', '    string public                        symbol             = "CKN";\n', '\n', '    /*================================\n', '    =            DATASETS            =\n', '    ================================*/\n', '\n', '    // Tracks Token\n', '    mapping(address => uint) internal    balances;\n', '    mapping(address => mapping (address => uint))public allowed;\n', '\n', '    // Payout tracking\n', '    mapping(address => uint)    public referralBalance_;\n', '    mapping(address => int256)  public payoutsTo_;\n', '    uint256 public profitPerShare_ = 0;\n', '    \n', '    // Token\n', '    uint internal tokenSupply = 0;\n', '\n', '    // Sub Contract\n', '    mapping(address => bool)  public gameAddress;\n', '    address public marketAddress;\n', '\n', '    /*================================\n', '    =            FUNCTION            =\n', '    ================================*/\n', '\n', '    constructor() public {\n', '\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return tokenSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`  CKN\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the referral balance for account `tokenOwner`   ETH\n', '    // ------------------------------------------------------------------------\n', '    function referralBalanceOf(address tokenOwner) public view returns(uint){\n', '        return referralBalance_[tokenOwner];\n', '    }\n', '\n', '    function setGameAddrt(address addr_, bool status_) public onlyOwner{\n', '        gameAddress[addr_] = status_;\n', '    }\n', '    \n', '    function setMarketAddr(address addr_) public onlyOwner{\n', '        marketAddress = addr_;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 Basic Function: Transfer CKN Token\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);\n', '\n', '        payoutsTo_[msg.sender] = payoutsTo_[msg.sender] - int(tokens.mul(profitPerShare_)/1e18);\n', '        payoutsTo_[to] = payoutsTo_[to] + int(tokens.mul(profitPerShare_)/1e18);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(tokens <= balances[from] &&  tokens <= allowed[from][msg.sender]);\n', '\n', '        payoutsTo_[from] = payoutsTo_[from] - int(tokens.mul(profitPerShare_)/1e18);\n', '        payoutsTo_[to] = payoutsTo_[to] + int(tokens.mul(profitPerShare_)/1e18);\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Buy Chicken Park Coin, 1% for me, 1% for chicken market, 19.6 ~ 0% for dividents\n', '    // ------------------------------------------------------------------------\n', '    function buyChickenParkCoin(address referedAddress) notContract() public payable{\n', '        uint fee = msg.value.mul(2)/100;\n', '        owner.transfer(fee/2);\n', '\n', '        marketAddress.transfer(fee/2);\n', '\n', '        uint realBuy = msg.value.sub(fee).mul((1e20).sub(calculateDivi()))/1e20;\n', '        uint divMoney = msg.value.sub(realBuy).sub(fee);\n', '\n', '        if(referedAddress != msg.sender && referedAddress != address(0)){\n', '            uint referralMoney = divMoney/10;\n', '            referralBalance_[referedAddress] = referralBalance_[referedAddress].add(referralMoney);\n', '            divMoney = divMoney.sub(referralMoney);\n', '        }\n', '\n', '        uint tokenAdd = getBuy(realBuy);\n', '        uint price1 = getCKNPriceNow();\n', '\n', '        tokenSupply = tokenSupply.add(tokenAdd);\n', '\n', '        payoutsTo_[msg.sender] += (int256)(profitPerShare_.mul(tokenAdd)/1e18);\n', '        profitPerShare_ = profitPerShare_.add(divMoney.mul(1e18)/totalSupply());\n', '        balances[msg.sender] = balances[msg.sender].add(tokenAdd);\n', '\n', '        uint price2 = getCKNPriceNow();\n', '        emit Transfer(address(0x0), msg.sender, tokenAdd);\n', '        emit CKNPrice(msg.sender,price1,price2,msg.value,tokenAdd,now,"BUY");\n', '    } \n', '\n', '    // ------------------------------------------------------------------------\n', '    // Sell Chicken Park Coin, 1% for me, 1% for chicken market, 19.6 ~ 0% for dividents\n', '    // ------------------------------------------------------------------------\n', '    function sellChickenParkCoin(uint tokenAnount) notContract() public {\n', '        uint tokenSub = tokenAnount;\n', '        uint sellEther = getSell(tokenSub);\n', '        uint price1 = getCKNPriceNow();\n', '\n', '        payoutsTo_[msg.sender] = payoutsTo_[msg.sender] - int(tokenSub.mul(profitPerShare_)/1e18);\n', '        tokenSupply = tokenSupply.sub(tokenSub);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokenSub);\n', '        uint diviTo = sellEther.mul(calculateDivi())/1e20;\n', '\n', '        if(totalSupply()>0){\n', '            profitPerShare_ = profitPerShare_.add(diviTo.mul(1e18)/totalSupply());\n', '        }else{\n', '            owner.transfer(diviTo); \n', '        }\n', '\n', '        owner.transfer(sellEther.mul(1)/100);\n', '        marketAddress.transfer(sellEther.mul(1)/100);\n', '\n', '        msg.sender.transfer((sellEther.mul(98)/(100)).sub(diviTo));\n', '\n', '        uint price2 = getCKNPriceNow();\n', '        emit Transfer(msg.sender, address(0x0), tokenSub);\n', '        emit CKNPrice(msg.sender,price1,price2,sellEther,tokenSub,now,"SELL");\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Withdraw your ETH dividents from Referral & CKN Dividents\n', '    // ------------------------------------------------------------------------\n', '    function withdraw() public {\n', '        require(msg.sender == tx.origin || msg.sender == marketAddress || gameAddress[msg.sender]);\n', '        require(myDividends(true)>0);\n', '\n', '        uint dividents_ = uint(getDividents()).add(referralBalance_[msg.sender]);\n', '        payoutsTo_[msg.sender] = payoutsTo_[msg.sender] + int(getDividents());\n', '        referralBalance_[msg.sender] = 0;\n', '\n', '        msg.sender.transfer(dividents_);\n', '        emit Withdraw(msg.sender, dividents_);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // ERC223 Transfer CKN Token With Data Function\n', '    // ------------------------------------------------------------------------\n', '    function transferTo (address _from, address _to, uint _amountOfTokens, bytes _data) public {\n', '        if (_from != msg.sender){\n', '            require(_amountOfTokens <= balances[_from] &&  _amountOfTokens <= allowed[_from][msg.sender]);\n', '        }\n', '        else{\n', '            require(_amountOfTokens <= balances[_from]);\n', '        }\n', '\n', '        transferFromInternal(_from, _to, _amountOfTokens, _data);\n', '    }\n', '\n', '    function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data) internal\n', '    {\n', '        require(_toAddress != address(0x0));\n', '        address _customerAddress     = _from;\n', '        \n', '        if (_customerAddress != msg.sender){\n', '        // Update the allowed balance.\n', '        // Don&#39;t update this if we are transferring our own tokens (via transfer or buyAndTransfer)\n', '            allowed[_customerAddress][msg.sender] = allowed[_customerAddress][msg.sender].sub(_amountOfTokens);\n', '        }\n', '\n', '        // Exchange tokens\n', '        balances[_customerAddress]    = balances[_customerAddress].sub(_amountOfTokens);\n', '        balances[_toAddress]          = balances[_toAddress].add(_amountOfTokens);\n', '\n', '        // Update dividend trackers\n', '        payoutsTo_[_customerAddress] -= (int256)(profitPerShare_.mul(_amountOfTokens)/1e18);\n', '        payoutsTo_[_toAddress]       +=  (int256)(profitPerShare_.mul(_amountOfTokens)/1e18);\n', '\n', '        uint length;\n', '\n', '        assembly {\n', '            length := extcodesize(_toAddress)\n', '        }\n', '\n', '        if (length > 0){\n', '        // its a contract\n', '        // note: at ethereum update ALL addresses are contracts\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_toAddress);\n', '            receiver.tokenFallback(_from, _amountOfTokens, _data);\n', '        }\n', '\n', '        // Fire logging event.\n', '        emit Transfer(_customerAddress, _toAddress, _amountOfTokens);\n', '    }\n', '\n', '    function getCKNPriceNow() public view returns(uint){\n', '        return (tokenPriceInitial_.mul(1e18+totalSupply()/100000000))/(1e18);\n', '    }\n', '\n', '    function getBuy(uint eth) public view returns(uint){\n', '        return ((((1e36).add(totalSupply().sq()/1e16).add(totalSupply().mul(2).mul(1e10)).add(eth.mul(1e28).mul(2)/tokenPriceInitial_)).sqrt()).sub(1e18).sub(totalSupply()/1e8)).mul(1e8);\n', '    }\n', '\n', '    function calculateDivi()public view returns(uint){\n', '        if(totalSupply() < 4e26){\n', '            uint diviRate = (20e18).sub(totalSupply().mul(5)/1e8);\n', '            return diviRate;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function getSell(uint token) public view returns(uint){\n', '        return tokenPriceInitial_.mul((1e18).add((totalSupply().sub(token/2))/100000000)).mul(token)/(1e36);\n', '    }\n', '\n', '    function myDividends(bool _includeReferralBonus) public view returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return _includeReferralBonus ? getDividents().add(referralBalance_[_customerAddress]) : getDividents() ;\n', '    }\n', '\n', '    function getDividents() public view returns(uint){\n', '        require(int((balances[msg.sender].mul(profitPerShare_)/1e18))-(payoutsTo_[msg.sender])>=0);\n', '        return uint(int((balances[msg.sender].mul(profitPerShare_)/1e18))-(payoutsTo_[msg.sender]));\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '//    _____ _     _      _                _____           _    \n', '//   / ____| |   (_)    | |              |  __ \\         | |   \n', '//  | |    | |__  _  ___| | _____ _ __   | |__) |_ _ _ __| | __\n', "//  | |    | '_ \\| |/ __| |/ / _ \\ '_ \\  |  ___/ _` | '__| |/ /\n", '//  | |____| | | | | (__|   <  __/ | | | | |  | (_| | |  |   < \n', '//   \\_____|_| |_|_|\\___|_|\\_\\___|_| |_| |_|   \\__,_|_|  |_|\\_\\\n', '\n', '// ------- What? ------- \n', '//A home for blockchain games.\n', '\n', '// ------- How? ------- \n', '//Buy CKN Token before playing any games.\n', '//You can buy & sell CKN in this contract at anytime and anywhere.\n', '//As the amount of ETH in the contract increases to 10,000, the dividend will gradually drop to 2%.\n', '\n', '//We got 4 phase in the Roadmap, will launch Plasma chain in the phase 2.\n', '\n', '// ------- How? ------- \n', '//10/2018 SIMPLE E-SPORT\n', '//11/2018 SPORT PREDICTION\n', '//02/2019 MOBILE GAME\n', '//06/2019 MMORPG\n', '\n', '// ------- Who? ------- \n', '//Only 1/10 smarter than vitalik.\n', '//admin@chickenpark.io\n', "//Sometime we think plama is a Pseudo topic, but it's a only way to speed up the TPS.\n", '//And Everybody will also trust the Node & Result.\n', '\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) \n', '        internal \n', '        pure \n', '        returns (uint256 c) \n', '    {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b, "SafeMath mul failed");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256) \n', '    {\n', '        require(b <= a, "SafeMath sub failed");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        require(c >= a, "SafeMath add failed");\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square root of given x.\n', '     */\n', '    function sqrt(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256 y) \n', '    {\n', '        uint256 z = ((add(x,1)) / 2);\n', '        y = x;\n', '        while (z < y) \n', '        {\n', '            y = z;\n', '            z = ((add((x / z),z)) / 2);\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * @dev gives square. multiplies x by x\n', '     */\n', '    function sq(uint256 x)\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return (mul(x,x));\n', '    }\n', '    \n', '    /**\n', '     * @dev x to the power of y \n', '     */\n', '    function pwr(uint256 x, uint256 y)\n', '        internal \n', '        pure \n', '        returns (uint256)\n', '    {\n', '        if (x==0)\n', '            return (0);\n', '        else if (y==0)\n', '            return (1);\n', '        else \n', '        {\n', '            uint256 z = x;\n', '            for (uint256 i=1; i < y; i++)\n', '                z = mul(z,x);\n', '            return (z);\n', '        }\n', '    }   \n', '}\n', '\n', 'contract ERC223ReceivingContract { \n', '/**\n', ' * @dev Standard ERC223 function that will handle incoming token transfers.\n', ' *\n', ' * @param _from  Token sender address.\n', ' * @param _value Amount of tokens.\n', ' * @param _data  Transaction metadata.\n', ' */\n', '    function tokenFallback(address _from, uint _value, bytes _data)public;\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', 'contract ChickenPark is Owned{\n', '\n', '    using SafeMath for *;\n', '\n', '    modifier notContract() {\n', '        require (msg.sender == tx.origin);\n', '        _;\n', '    }\n', '    \n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint tokens\n', '    );\n', '\n', '    event Approval(\n', '        address indexed tokenOwner,\n', '        address indexed spender,\n', '        uint tokens\n', '    );\n', '\n', '    event CKNPrice(\n', '        address indexed who,\n', '        uint prePrice,\n', '        uint afterPrice,\n', '        uint ethValue,\n', '        uint token,\n', '        uint timestamp,\n', '        string action\n', '    );\n', '    \n', '    event Withdraw(\n', '        address indexed who,\n', '        uint dividents\n', '    );\n', '\n', '    /*=====================================\n', '    =            CONSTANTS                =\n', '    =====================================*/\n', '    uint8 constant public                decimals              = 18;\n', '    uint constant internal               tokenPriceInitial_    = 0.00001 ether;\n', '    uint constant internal               magnitude             = 2**64;\n', '\n', '    /*================================\n', '    =          CONFIGURABLES         =\n', '    ================================*/\n', '    string public                        name               = "Chicken Park Coin";\n', '    string public                        symbol             = "CKN";\n', '\n', '    /*================================\n', '    =            DATASETS            =\n', '    ================================*/\n', '\n', '    // Tracks Token\n', '    mapping(address => uint) internal    balances;\n', '    mapping(address => mapping (address => uint))public allowed;\n', '\n', '    // Payout tracking\n', '    mapping(address => uint)    public referralBalance_;\n', '    mapping(address => int256)  public payoutsTo_;\n', '    uint256 public profitPerShare_ = 0;\n', '    \n', '    // Token\n', '    uint internal tokenSupply = 0;\n', '\n', '    // Sub Contract\n', '    mapping(address => bool)  public gameAddress;\n', '    address public marketAddress;\n', '\n', '    /*================================\n', '    =            FUNCTION            =\n', '    ================================*/\n', '\n', '    constructor() public {\n', '\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return tokenSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`  CKN\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the referral balance for account `tokenOwner`   ETH\n', '    // ------------------------------------------------------------------------\n', '    function referralBalanceOf(address tokenOwner) public view returns(uint){\n', '        return referralBalance_[tokenOwner];\n', '    }\n', '\n', '    function setGameAddrt(address addr_, bool status_) public onlyOwner{\n', '        gameAddress[addr_] = status_;\n', '    }\n', '    \n', '    function setMarketAddr(address addr_) public onlyOwner{\n', '        marketAddress = addr_;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // ERC20 Basic Function: Transfer CKN Token\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        require(balances[msg.sender] >= tokens);\n', '\n', '        payoutsTo_[msg.sender] = payoutsTo_[msg.sender] - int(tokens.mul(profitPerShare_)/1e18);\n', '        payoutsTo_[to] = payoutsTo_[to] + int(tokens.mul(profitPerShare_)/1e18);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        require(tokens <= balances[from] &&  tokens <= allowed[from][msg.sender]);\n', '\n', '        payoutsTo_[from] = payoutsTo_[from] - int(tokens.mul(profitPerShare_)/1e18);\n', '        payoutsTo_[to] = payoutsTo_[to] + int(tokens.mul(profitPerShare_)/1e18);\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Buy Chicken Park Coin, 1% for me, 1% for chicken market, 19.6 ~ 0% for dividents\n', '    // ------------------------------------------------------------------------\n', '    function buyChickenParkCoin(address referedAddress) notContract() public payable{\n', '        uint fee = msg.value.mul(2)/100;\n', '        owner.transfer(fee/2);\n', '\n', '        marketAddress.transfer(fee/2);\n', '\n', '        uint realBuy = msg.value.sub(fee).mul((1e20).sub(calculateDivi()))/1e20;\n', '        uint divMoney = msg.value.sub(realBuy).sub(fee);\n', '\n', '        if(referedAddress != msg.sender && referedAddress != address(0)){\n', '            uint referralMoney = divMoney/10;\n', '            referralBalance_[referedAddress] = referralBalance_[referedAddress].add(referralMoney);\n', '            divMoney = divMoney.sub(referralMoney);\n', '        }\n', '\n', '        uint tokenAdd = getBuy(realBuy);\n', '        uint price1 = getCKNPriceNow();\n', '\n', '        tokenSupply = tokenSupply.add(tokenAdd);\n', '\n', '        payoutsTo_[msg.sender] += (int256)(profitPerShare_.mul(tokenAdd)/1e18);\n', '        profitPerShare_ = profitPerShare_.add(divMoney.mul(1e18)/totalSupply());\n', '        balances[msg.sender] = balances[msg.sender].add(tokenAdd);\n', '\n', '        uint price2 = getCKNPriceNow();\n', '        emit Transfer(address(0x0), msg.sender, tokenAdd);\n', '        emit CKNPrice(msg.sender,price1,price2,msg.value,tokenAdd,now,"BUY");\n', '    } \n', '\n', '    // ------------------------------------------------------------------------\n', '    // Sell Chicken Park Coin, 1% for me, 1% for chicken market, 19.6 ~ 0% for dividents\n', '    // ------------------------------------------------------------------------\n', '    function sellChickenParkCoin(uint tokenAnount) notContract() public {\n', '        uint tokenSub = tokenAnount;\n', '        uint sellEther = getSell(tokenSub);\n', '        uint price1 = getCKNPriceNow();\n', '\n', '        payoutsTo_[msg.sender] = payoutsTo_[msg.sender] - int(tokenSub.mul(profitPerShare_)/1e18);\n', '        tokenSupply = tokenSupply.sub(tokenSub);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokenSub);\n', '        uint diviTo = sellEther.mul(calculateDivi())/1e20;\n', '\n', '        if(totalSupply()>0){\n', '            profitPerShare_ = profitPerShare_.add(diviTo.mul(1e18)/totalSupply());\n', '        }else{\n', '            owner.transfer(diviTo); \n', '        }\n', '\n', '        owner.transfer(sellEther.mul(1)/100);\n', '        marketAddress.transfer(sellEther.mul(1)/100);\n', '\n', '        msg.sender.transfer((sellEther.mul(98)/(100)).sub(diviTo));\n', '\n', '        uint price2 = getCKNPriceNow();\n', '        emit Transfer(msg.sender, address(0x0), tokenSub);\n', '        emit CKNPrice(msg.sender,price1,price2,sellEther,tokenSub,now,"SELL");\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Withdraw your ETH dividents from Referral & CKN Dividents\n', '    // ------------------------------------------------------------------------\n', '    function withdraw() public {\n', '        require(msg.sender == tx.origin || msg.sender == marketAddress || gameAddress[msg.sender]);\n', '        require(myDividends(true)>0);\n', '\n', '        uint dividents_ = uint(getDividents()).add(referralBalance_[msg.sender]);\n', '        payoutsTo_[msg.sender] = payoutsTo_[msg.sender] + int(getDividents());\n', '        referralBalance_[msg.sender] = 0;\n', '\n', '        msg.sender.transfer(dividents_);\n', '        emit Withdraw(msg.sender, dividents_);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // ERC223 Transfer CKN Token With Data Function\n', '    // ------------------------------------------------------------------------\n', '    function transferTo (address _from, address _to, uint _amountOfTokens, bytes _data) public {\n', '        if (_from != msg.sender){\n', '            require(_amountOfTokens <= balances[_from] &&  _amountOfTokens <= allowed[_from][msg.sender]);\n', '        }\n', '        else{\n', '            require(_amountOfTokens <= balances[_from]);\n', '        }\n', '\n', '        transferFromInternal(_from, _to, _amountOfTokens, _data);\n', '    }\n', '\n', '    function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data) internal\n', '    {\n', '        require(_toAddress != address(0x0));\n', '        address _customerAddress     = _from;\n', '        \n', '        if (_customerAddress != msg.sender){\n', '        // Update the allowed balance.\n', "        // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)\n", '            allowed[_customerAddress][msg.sender] = allowed[_customerAddress][msg.sender].sub(_amountOfTokens);\n', '        }\n', '\n', '        // Exchange tokens\n', '        balances[_customerAddress]    = balances[_customerAddress].sub(_amountOfTokens);\n', '        balances[_toAddress]          = balances[_toAddress].add(_amountOfTokens);\n', '\n', '        // Update dividend trackers\n', '        payoutsTo_[_customerAddress] -= (int256)(profitPerShare_.mul(_amountOfTokens)/1e18);\n', '        payoutsTo_[_toAddress]       +=  (int256)(profitPerShare_.mul(_amountOfTokens)/1e18);\n', '\n', '        uint length;\n', '\n', '        assembly {\n', '            length := extcodesize(_toAddress)\n', '        }\n', '\n', '        if (length > 0){\n', '        // its a contract\n', '        // note: at ethereum update ALL addresses are contracts\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_toAddress);\n', '            receiver.tokenFallback(_from, _amountOfTokens, _data);\n', '        }\n', '\n', '        // Fire logging event.\n', '        emit Transfer(_customerAddress, _toAddress, _amountOfTokens);\n', '    }\n', '\n', '    function getCKNPriceNow() public view returns(uint){\n', '        return (tokenPriceInitial_.mul(1e18+totalSupply()/100000000))/(1e18);\n', '    }\n', '\n', '    function getBuy(uint eth) public view returns(uint){\n', '        return ((((1e36).add(totalSupply().sq()/1e16).add(totalSupply().mul(2).mul(1e10)).add(eth.mul(1e28).mul(2)/tokenPriceInitial_)).sqrt()).sub(1e18).sub(totalSupply()/1e8)).mul(1e8);\n', '    }\n', '\n', '    function calculateDivi()public view returns(uint){\n', '        if(totalSupply() < 4e26){\n', '            uint diviRate = (20e18).sub(totalSupply().mul(5)/1e8);\n', '            return diviRate;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function getSell(uint token) public view returns(uint){\n', '        return tokenPriceInitial_.mul((1e18).add((totalSupply().sub(token/2))/100000000)).mul(token)/(1e36);\n', '    }\n', '\n', '    function myDividends(bool _includeReferralBonus) public view returns(uint256)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        return _includeReferralBonus ? getDividents().add(referralBalance_[_customerAddress]) : getDividents() ;\n', '    }\n', '\n', '    function getDividents() public view returns(uint){\n', '        require(int((balances[msg.sender].mul(profitPerShare_)/1e18))-(payoutsTo_[msg.sender])>=0);\n', '        return uint(int((balances[msg.sender].mul(profitPerShare_)/1e18))-(payoutsTo_[msg.sender]));\n', '    }\n', '}']
