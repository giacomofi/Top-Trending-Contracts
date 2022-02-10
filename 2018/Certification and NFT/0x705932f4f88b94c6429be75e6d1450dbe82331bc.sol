['pragma solidity 0.4.21;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract CryptoRoboticsToken {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    function burn(uint256 value) public;\n', '}\n', '\n', '\n', 'contract RefundVault is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    enum State { Active, Refunding, Closed }\n', '\n', '    mapping (address => uint256) public deposited;\n', '    address public wallet;\n', '    State public state;\n', '\n', '    event Closed();\n', '    event RefundsEnabled();\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '    /**\n', '     * @param _wallet Vault address\n', '     */\n', '    function RefundVault(address _wallet) public {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '        state = State.Active;\n', '    }\n', '\n', '    /**\n', '     * @param investor Investor address\n', '     */\n', '    function deposit(address investor) onlyOwner public payable {\n', '        require(state == State.Active);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function close() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Closed;\n', '        emit Closed();\n', '        wallet.transfer(address(this).balance);\n', '    }\n', '\n', '    function enableRefunds() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        emit RefundsEnabled();\n', '    }\n', '\n', '    /**\n', '     * @param investor Investor address\n', '     */\n', '    function refund(address investor) public {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        emit Refunded(investor, depositedValue);\n', '    }\n', '}\n', '\n', '\n', 'contract Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    CryptoRoboticsToken public token;\n', '    //MAKE APPROVAL TO Crowdsale\n', '    address public reserve_fund = 0x7C88C296B9042946f821F5456bd00EA92a13B3BB;\n', '    address preico;\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    uint256 public openingTime;\n', '    uint256 public closingTime;\n', '\n', '    bool public isFinalized = false;\n', '\n', '    uint public currentStage = 0;\n', '\n', '    uint256 public goal = 1000 ether;\n', '    uint256 public cap  = 6840  ether;\n', '\n', '    RefundVault public vault;\n', '\n', '\n', '\n', '    //price in wei for stage\n', '    uint[4] public stagePrices = [\n', '    127500000000000 wei,     //0.000085 - ICO Stage 1\n', '    135 szabo,     //0.000090 - ICO Stage 2\n', '    142500000000000 wei,     //0.000095 - ICO Stage 3\n', '    150 szabo     //0.0001 - ICO Stage 4\n', '    ];\n', '\n', '    //limit in wei for stage 612 + 1296 + 2052 + 2880\n', '    uint[4] internal stageLimits = [\n', '    612 ether,    //4800000 tokens 10% of ICO tokens (ICO token 40% of all (48 000 000) )\n', '    1296 ether,    //9600000 tokens 20% of ICO tokens\n', '    2052 ether,   //14400000 tokens 30% of ICO tokens\n', '    2880 ether    //19200000 tokens 40% of ICO tokens\n', '    ];\n', '\n', '    mapping(address => bool) public referrals;\n', '    mapping(address => uint) public reservedTokens;\n', '    mapping(address => uint) public reservedRefsTokens;\n', '    uint public amountReservedTokens;\n', '    uint public amountReservedRefsTokens;\n', '\n', '    event Finalized();\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenReserved(address indexed beneficiary, uint256 value, uint256 amount, address referral);\n', '\n', '\n', '    modifier onlyWhileOpen {\n', '        require(now >= openingTime && now <= closingTime);\n', '        _;\n', '    }\n', '\n', '\n', '    modifier onlyPreIco {\n', '        require(msg.sender == preico);\n', '        _;\n', '    }\n', '\n', '\n', '    function Crowdsale(CryptoRoboticsToken _token) public\n', '    {\n', '        require(_token != address(0));\n', '\n', '        wallet = 0x3eb945fd746fbdf641f1063731d91a6fb381ea0f;\n', '        token = _token;\n', '        openingTime = 1526774400;\n', '        closingTime = 1532044800;\n', '        vault = new RefundVault(wallet);\n', '    }\n', '\n', '\n', '    function () external payable {\n', '        buyTokens(msg.sender, address(0));\n', '    }\n', '\n', '\n', '    function buyTokens(address _beneficiary, address _ref) public payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '        _getTokenAmount(weiAmount,true,_beneficiary,_ref);\n', '    }\n', '\n', '\n', '    function reserveTokens(address _ref) public payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidateReserve(msg.sender, weiAmount, _ref);\n', '        _getTokenAmount(weiAmount, false,msg.sender,_ref);\n', '    }\n', '\n', '\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen {\n', '        require(weiRaised.add(_weiAmount) <= cap);\n', '        require(_weiAmount >= stagePrices[currentStage]);\n', '        require(_beneficiary != address(0));\n', '\n', '    }\n', '\n', '    function _preValidateReserve(address _beneficiary, uint256 _weiAmount, address _ref) internal view {\n', '        require(now < openingTime);\n', '        require(referrals[_ref]);\n', '        require(weiRaised.add(_weiAmount) <= cap);\n', '        require(_weiAmount >= stagePrices[currentStage]);\n', '        require(_beneficiary != address(0));\n', '    }\n', '\n', '\n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        token.transfer(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount, address _ref) internal {\n', '        _tokenAmount = _tokenAmount * 1 ether;\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '        if (referrals[_ref]) {\n', '            uint _refTokens = valueFromPercent(_tokenAmount,10);\n', '            token.transferFrom(reserve_fund, _ref, _refTokens);\n', '        }\n', '    }\n', '\n', '\n', '    function _processReserve(address _beneficiary, uint256 _tokenAmount, address _ref) internal {\n', '        _tokenAmount = _tokenAmount * 1 ether;\n', '        _reserveTokens(_beneficiary, _tokenAmount);\n', '        uint _refTokens = valueFromPercent(_tokenAmount,10);\n', '        _reserveRefTokens(_ref, _refTokens);\n', '    }\n', '\n', '\n', '    function _reserveTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        reservedTokens[_beneficiary] = reservedTokens[_beneficiary].add(_tokenAmount);\n', '        amountReservedTokens = amountReservedTokens.add(_tokenAmount);\n', '    }\n', '\n', '\n', '    function _reserveRefTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        reservedRefsTokens[_beneficiary] = reservedRefsTokens[_beneficiary].add(_tokenAmount);\n', '        amountReservedRefsTokens = amountReservedRefsTokens.add(_tokenAmount);\n', '    }\n', '\n', '\n', '    function getReservedTokens() public {\n', '        require(now >= openingTime);\n', '        require(reservedTokens[msg.sender] > 0);\n', '        amountReservedTokens = amountReservedTokens.sub(reservedTokens[msg.sender]);\n', '        reservedTokens[msg.sender] = 0;\n', '        token.transfer(msg.sender, reservedTokens[msg.sender]);\n', '    }\n', '\n', '\n', '    function getRefReservedTokens() public {\n', '        require(now >= openingTime);\n', '        require(reservedRefsTokens[msg.sender] > 0);\n', '        amountReservedRefsTokens = amountReservedRefsTokens.sub(reservedRefsTokens[msg.sender]);\n', '        reservedRefsTokens[msg.sender] = 0;\n', '        token.transferFrom(reserve_fund, msg.sender, reservedRefsTokens[msg.sender]);\n', '    }\n', '\n', '\n', '    function valueFromPercent(uint _value, uint _percent) internal pure returns(uint amount)    {\n', '        uint _amount = _value.mul(_percent).div(100);\n', '        return (_amount);\n', '    }\n', '\n', '\n', '    function _getTokenAmount(uint256 _weiAmount, bool _buy, address _beneficiary, address _ref) internal {\n', '        uint256 weiAmount = _weiAmount;\n', '        uint _tokens = 0;\n', '        uint _tokens_price = 0;\n', '        uint _current_tokens = 0;\n', '\n', '        for (uint p = currentStage; p < 4 && _weiAmount >= stagePrices[p]; p++) {\n', '            if (stageLimits[p] > 0 ) {\n', '                //если лимит больше чем _weiAmount, тогда считаем все из расчета что вписываемся в лимит\n', '                //и выходим из цикла\n', '                if (stageLimits[p] > _weiAmount) {\n', '                    //количество токенов по текущему прайсу (останется остаток если прислали  больше чем на точное количество монет)\n', '                    _current_tokens = _weiAmount.div(stagePrices[p]);\n', '                    //цена всех монет, чтобы определить остаток неизрасходованных wei\n', '                    _tokens_price = _current_tokens.mul(stagePrices[p]);\n', '                    //получаем остаток\n', '                    _weiAmount = _weiAmount.sub(_tokens_price);\n', '                    //добавляем токены текущего стэйджа к общему количеству\n', '                    _tokens = _tokens.add(_current_tokens);\n', '                    //обновляем лимиты\n', '                    stageLimits[p] = stageLimits[p].sub(_tokens_price);\n', '                    break;\n', '                } else { //лимит меньше чем количество wei\n', '                    //получаем все оставшиеся токены в стейдже\n', '                    _current_tokens = stageLimits[p].div(stagePrices[p]);\n', '                    _weiAmount = _weiAmount.sub(stageLimits[p]);\n', '                    _tokens = _tokens.add(_current_tokens);\n', '                    stageLimits[p] = 0;\n', '                    _updateStage();\n', '                }\n', '\n', '            }\n', '        }\n', '\n', '        weiAmount = weiAmount.sub(_weiAmount);\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        if (_buy) {\n', '            _processPurchase(_beneficiary, _tokens, _ref);\n', '            emit TokenPurchase(msg.sender, _beneficiary, weiAmount, _tokens);\n', '        } else {\n', '            _processReserve(msg.sender, _tokens, _ref);\n', '            emit TokenReserved(msg.sender, weiAmount, _tokens, _ref);\n', '        }\n', '\n', '        //отправляем обратно неизрасходованный остаток\n', '        if (_weiAmount > 0) {\n', '            msg.sender.transfer(_weiAmount);\n', '        }\n', '\n', '        // update state\n', '\n', '\n', '        _forwardFunds(weiAmount);\n', '    }\n', '\n', '\n', '    function _updateStage() internal {\n', '        if ((stageLimits[currentStage] == 0) && currentStage < 3) {\n', '            currentStage++;\n', '        }\n', '    }\n', '\n', '\n', '    function _forwardFunds(uint _weiAmount) internal {\n', '        vault.deposit.value(_weiAmount)(msg.sender);\n', '    }\n', '\n', '\n', '    function hasClosed() public view returns (bool) {\n', '        return now > closingTime;\n', '    }\n', '\n', '\n', '    function capReached() public view returns (bool) {\n', '        return weiRaised >= cap;\n', '    }\n', '\n', '\n', '    function goalReached() public view returns (bool) {\n', '        return weiRaised >= goal;\n', '    }\n', '\n', '\n', '    function finalize() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(hasClosed() || capReached());\n', '\n', '        finalization();\n', '        emit Finalized();\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '\n', '    function finalization() internal {\n', '        if (goalReached()) {\n', '            vault.close();\n', '        } else {\n', '            vault.enableRefunds();\n', '        }\n', '\n', '        uint token_balace = token.balanceOf(this);\n', '        token_balace = token_balace.sub(amountReservedTokens);//\n', '        token.burn(token_balace);\n', '    }\n', '\n', '\n', '    function addReferral(address _ref) external onlyOwner {\n', '        referrals[_ref] = true;\n', '    }\n', '\n', '\n', '    function removeReferral(address _ref) external onlyOwner {\n', '        referrals[_ref] = false;\n', '    }\n', '\n', '\n', '    function setPreIco(address _preico) onlyOwner public {\n', '        preico = _preico;\n', '    }\n', '\n', '\n', '    function setTokenCountFromPreIco(uint _value) onlyPreIco public{\n', '        _value = _value.div(1 ether);\n', '        uint weis = _value.mul(stagePrices[3]);\n', '        stageLimits[3] = stageLimits[3].add(weis);\n', '        cap = cap.add(weis);\n', '\n', '    }\n', '\n', '\n', '    function claimRefund() public {\n', '        require(isFinalized);\n', '        require(!goalReached());\n', '\n', '        vault.refund(msg.sender);\n', '    }\n', '\n', '}']
['pragma solidity 0.4.21;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract CryptoRoboticsToken {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    function burn(uint256 value) public;\n', '}\n', '\n', '\n', 'contract RefundVault is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    enum State { Active, Refunding, Closed }\n', '\n', '    mapping (address => uint256) public deposited;\n', '    address public wallet;\n', '    State public state;\n', '\n', '    event Closed();\n', '    event RefundsEnabled();\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '    /**\n', '     * @param _wallet Vault address\n', '     */\n', '    function RefundVault(address _wallet) public {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '        state = State.Active;\n', '    }\n', '\n', '    /**\n', '     * @param investor Investor address\n', '     */\n', '    function deposit(address investor) onlyOwner public payable {\n', '        require(state == State.Active);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function close() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Closed;\n', '        emit Closed();\n', '        wallet.transfer(address(this).balance);\n', '    }\n', '\n', '    function enableRefunds() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        emit RefundsEnabled();\n', '    }\n', '\n', '    /**\n', '     * @param investor Investor address\n', '     */\n', '    function refund(address investor) public {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        emit Refunded(investor, depositedValue);\n', '    }\n', '}\n', '\n', '\n', 'contract Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    CryptoRoboticsToken public token;\n', '    //MAKE APPROVAL TO Crowdsale\n', '    address public reserve_fund = 0x7C88C296B9042946f821F5456bd00EA92a13B3BB;\n', '    address preico;\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // Amount of wei raised\n', '    uint256 public weiRaised;\n', '\n', '    uint256 public openingTime;\n', '    uint256 public closingTime;\n', '\n', '    bool public isFinalized = false;\n', '\n', '    uint public currentStage = 0;\n', '\n', '    uint256 public goal = 1000 ether;\n', '    uint256 public cap  = 6840  ether;\n', '\n', '    RefundVault public vault;\n', '\n', '\n', '\n', '    //price in wei for stage\n', '    uint[4] public stagePrices = [\n', '    127500000000000 wei,     //0.000085 - ICO Stage 1\n', '    135 szabo,     //0.000090 - ICO Stage 2\n', '    142500000000000 wei,     //0.000095 - ICO Stage 3\n', '    150 szabo     //0.0001 - ICO Stage 4\n', '    ];\n', '\n', '    //limit in wei for stage 612 + 1296 + 2052 + 2880\n', '    uint[4] internal stageLimits = [\n', '    612 ether,    //4800000 tokens 10% of ICO tokens (ICO token 40% of all (48 000 000) )\n', '    1296 ether,    //9600000 tokens 20% of ICO tokens\n', '    2052 ether,   //14400000 tokens 30% of ICO tokens\n', '    2880 ether    //19200000 tokens 40% of ICO tokens\n', '    ];\n', '\n', '    mapping(address => bool) public referrals;\n', '    mapping(address => uint) public reservedTokens;\n', '    mapping(address => uint) public reservedRefsTokens;\n', '    uint public amountReservedTokens;\n', '    uint public amountReservedRefsTokens;\n', '\n', '    event Finalized();\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenReserved(address indexed beneficiary, uint256 value, uint256 amount, address referral);\n', '\n', '\n', '    modifier onlyWhileOpen {\n', '        require(now >= openingTime && now <= closingTime);\n', '        _;\n', '    }\n', '\n', '\n', '    modifier onlyPreIco {\n', '        require(msg.sender == preico);\n', '        _;\n', '    }\n', '\n', '\n', '    function Crowdsale(CryptoRoboticsToken _token) public\n', '    {\n', '        require(_token != address(0));\n', '\n', '        wallet = 0x3eb945fd746fbdf641f1063731d91a6fb381ea0f;\n', '        token = _token;\n', '        openingTime = 1526774400;\n', '        closingTime = 1532044800;\n', '        vault = new RefundVault(wallet);\n', '    }\n', '\n', '\n', '    function () external payable {\n', '        buyTokens(msg.sender, address(0));\n', '    }\n', '\n', '\n', '    function buyTokens(address _beneficiary, address _ref) public payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidatePurchase(_beneficiary, weiAmount);\n', '        _getTokenAmount(weiAmount,true,_beneficiary,_ref);\n', '    }\n', '\n', '\n', '    function reserveTokens(address _ref) public payable {\n', '        uint256 weiAmount = msg.value;\n', '        _preValidateReserve(msg.sender, weiAmount, _ref);\n', '        _getTokenAmount(weiAmount, false,msg.sender,_ref);\n', '    }\n', '\n', '\n', '    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen {\n', '        require(weiRaised.add(_weiAmount) <= cap);\n', '        require(_weiAmount >= stagePrices[currentStage]);\n', '        require(_beneficiary != address(0));\n', '\n', '    }\n', '\n', '    function _preValidateReserve(address _beneficiary, uint256 _weiAmount, address _ref) internal view {\n', '        require(now < openingTime);\n', '        require(referrals[_ref]);\n', '        require(weiRaised.add(_weiAmount) <= cap);\n', '        require(_weiAmount >= stagePrices[currentStage]);\n', '        require(_beneficiary != address(0));\n', '    }\n', '\n', '\n', '    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        token.transfer(_beneficiary, _tokenAmount);\n', '    }\n', '\n', '\n', '    function _processPurchase(address _beneficiary, uint256 _tokenAmount, address _ref) internal {\n', '        _tokenAmount = _tokenAmount * 1 ether;\n', '        _deliverTokens(_beneficiary, _tokenAmount);\n', '        if (referrals[_ref]) {\n', '            uint _refTokens = valueFromPercent(_tokenAmount,10);\n', '            token.transferFrom(reserve_fund, _ref, _refTokens);\n', '        }\n', '    }\n', '\n', '\n', '    function _processReserve(address _beneficiary, uint256 _tokenAmount, address _ref) internal {\n', '        _tokenAmount = _tokenAmount * 1 ether;\n', '        _reserveTokens(_beneficiary, _tokenAmount);\n', '        uint _refTokens = valueFromPercent(_tokenAmount,10);\n', '        _reserveRefTokens(_ref, _refTokens);\n', '    }\n', '\n', '\n', '    function _reserveTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        reservedTokens[_beneficiary] = reservedTokens[_beneficiary].add(_tokenAmount);\n', '        amountReservedTokens = amountReservedTokens.add(_tokenAmount);\n', '    }\n', '\n', '\n', '    function _reserveRefTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '        reservedRefsTokens[_beneficiary] = reservedRefsTokens[_beneficiary].add(_tokenAmount);\n', '        amountReservedRefsTokens = amountReservedRefsTokens.add(_tokenAmount);\n', '    }\n', '\n', '\n', '    function getReservedTokens() public {\n', '        require(now >= openingTime);\n', '        require(reservedTokens[msg.sender] > 0);\n', '        amountReservedTokens = amountReservedTokens.sub(reservedTokens[msg.sender]);\n', '        reservedTokens[msg.sender] = 0;\n', '        token.transfer(msg.sender, reservedTokens[msg.sender]);\n', '    }\n', '\n', '\n', '    function getRefReservedTokens() public {\n', '        require(now >= openingTime);\n', '        require(reservedRefsTokens[msg.sender] > 0);\n', '        amountReservedRefsTokens = amountReservedRefsTokens.sub(reservedRefsTokens[msg.sender]);\n', '        reservedRefsTokens[msg.sender] = 0;\n', '        token.transferFrom(reserve_fund, msg.sender, reservedRefsTokens[msg.sender]);\n', '    }\n', '\n', '\n', '    function valueFromPercent(uint _value, uint _percent) internal pure returns(uint amount)    {\n', '        uint _amount = _value.mul(_percent).div(100);\n', '        return (_amount);\n', '    }\n', '\n', '\n', '    function _getTokenAmount(uint256 _weiAmount, bool _buy, address _beneficiary, address _ref) internal {\n', '        uint256 weiAmount = _weiAmount;\n', '        uint _tokens = 0;\n', '        uint _tokens_price = 0;\n', '        uint _current_tokens = 0;\n', '\n', '        for (uint p = currentStage; p < 4 && _weiAmount >= stagePrices[p]; p++) {\n', '            if (stageLimits[p] > 0 ) {\n', '                //если лимит больше чем _weiAmount, тогда считаем все из расчета что вписываемся в лимит\n', '                //и выходим из цикла\n', '                if (stageLimits[p] > _weiAmount) {\n', '                    //количество токенов по текущему прайсу (останется остаток если прислали  больше чем на точное количество монет)\n', '                    _current_tokens = _weiAmount.div(stagePrices[p]);\n', '                    //цена всех монет, чтобы определить остаток неизрасходованных wei\n', '                    _tokens_price = _current_tokens.mul(stagePrices[p]);\n', '                    //получаем остаток\n', '                    _weiAmount = _weiAmount.sub(_tokens_price);\n', '                    //добавляем токены текущего стэйджа к общему количеству\n', '                    _tokens = _tokens.add(_current_tokens);\n', '                    //обновляем лимиты\n', '                    stageLimits[p] = stageLimits[p].sub(_tokens_price);\n', '                    break;\n', '                } else { //лимит меньше чем количество wei\n', '                    //получаем все оставшиеся токены в стейдже\n', '                    _current_tokens = stageLimits[p].div(stagePrices[p]);\n', '                    _weiAmount = _weiAmount.sub(stageLimits[p]);\n', '                    _tokens = _tokens.add(_current_tokens);\n', '                    stageLimits[p] = 0;\n', '                    _updateStage();\n', '                }\n', '\n', '            }\n', '        }\n', '\n', '        weiAmount = weiAmount.sub(_weiAmount);\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        if (_buy) {\n', '            _processPurchase(_beneficiary, _tokens, _ref);\n', '            emit TokenPurchase(msg.sender, _beneficiary, weiAmount, _tokens);\n', '        } else {\n', '            _processReserve(msg.sender, _tokens, _ref);\n', '            emit TokenReserved(msg.sender, weiAmount, _tokens, _ref);\n', '        }\n', '\n', '        //отправляем обратно неизрасходованный остаток\n', '        if (_weiAmount > 0) {\n', '            msg.sender.transfer(_weiAmount);\n', '        }\n', '\n', '        // update state\n', '\n', '\n', '        _forwardFunds(weiAmount);\n', '    }\n', '\n', '\n', '    function _updateStage() internal {\n', '        if ((stageLimits[currentStage] == 0) && currentStage < 3) {\n', '            currentStage++;\n', '        }\n', '    }\n', '\n', '\n', '    function _forwardFunds(uint _weiAmount) internal {\n', '        vault.deposit.value(_weiAmount)(msg.sender);\n', '    }\n', '\n', '\n', '    function hasClosed() public view returns (bool) {\n', '        return now > closingTime;\n', '    }\n', '\n', '\n', '    function capReached() public view returns (bool) {\n', '        return weiRaised >= cap;\n', '    }\n', '\n', '\n', '    function goalReached() public view returns (bool) {\n', '        return weiRaised >= goal;\n', '    }\n', '\n', '\n', '    function finalize() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(hasClosed() || capReached());\n', '\n', '        finalization();\n', '        emit Finalized();\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '\n', '    function finalization() internal {\n', '        if (goalReached()) {\n', '            vault.close();\n', '        } else {\n', '            vault.enableRefunds();\n', '        }\n', '\n', '        uint token_balace = token.balanceOf(this);\n', '        token_balace = token_balace.sub(amountReservedTokens);//\n', '        token.burn(token_balace);\n', '    }\n', '\n', '\n', '    function addReferral(address _ref) external onlyOwner {\n', '        referrals[_ref] = true;\n', '    }\n', '\n', '\n', '    function removeReferral(address _ref) external onlyOwner {\n', '        referrals[_ref] = false;\n', '    }\n', '\n', '\n', '    function setPreIco(address _preico) onlyOwner public {\n', '        preico = _preico;\n', '    }\n', '\n', '\n', '    function setTokenCountFromPreIco(uint _value) onlyPreIco public{\n', '        _value = _value.div(1 ether);\n', '        uint weis = _value.mul(stagePrices[3]);\n', '        stageLimits[3] = stageLimits[3].add(weis);\n', '        cap = cap.add(weis);\n', '\n', '    }\n', '\n', '\n', '    function claimRefund() public {\n', '        require(isFinalized);\n', '        require(!goalReached());\n', '\n', '        vault.refund(msg.sender);\n', '    }\n', '\n', '}']
