['pragma solidity ^0.4.18;\n', '\n', 'contract AbstractToken {\n', "    // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions\n", '    function totalSupply() public constant returns (uint256) {}\n', '    function balanceOf(address owner) public constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '    function approve(address spender, uint256 value) public returns (bool success);\n', '    function allowance(address owner, address spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Issuance(address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    assert(b != 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {\n', '      return div(mul(number, numerator), denominator);\n', '  }\n', '}\n', '\n', 'contract PreIco is SafeMath {\n', '    /*\n', '     * PreIco meta data\n', '     */\n', '    string public constant name = "Remechain Presale Token";\n', '    string public constant symbol = "iRMC";\n', '    uint public constant decimals = 18;\n', '\n', '    // addresses of managers\n', '    address public manager;\n', '    address public reserveManager;\n', '    // addresses of escrows\n', '    address public escrow;\n', '    address public reserveEscrow;\n', '\n', '    // BASE = 10^18\n', '    uint constant BASE = 1000000000000000000;\n', '\n', '    // amount of supplied tokens\n', '    uint public tokensSupplied = 0;\n', '    // amount of supplied bounty reward\n', '    uint public bountySupplied = 0;\n', '    // Soft capacity = 6250 ETH\n', '    uint public constant SOFT_CAPACITY = 2000000 * BASE;\n', '    // Hard capacity = 18750 ETH\n', '    uint public constant TOKENS_SUPPLY = 6000000 * BASE;\n', '    // Amount of bounty reward\n', '    uint public constant BOUNTY_SUPPLY = 350000 * BASE;\n', '    // Total supply\n', '    uint public constant totalSupply = TOKENS_SUPPLY + BOUNTY_SUPPLY;\n', '\n', '    // 1 RMC = 0.003125 ETH for  600 000 000 RMC\n', '\n', '    uint public constant TOKEN_PRICE = 3125000000000000;\n', '    uint tokenAmount1 = 6000000 * BASE;\n', '\n', '    uint tokenPriceMultiply1 = 1;\n', '    uint tokenPriceDivide1 = 1;\n', '\n', '    uint[] public tokenPriceMultiplies;\n', '    uint[] public tokenPriceDivides;\n', '    uint[] public tokenAmounts;\n', '\n', '    // ETH balances of accounts\n', '    mapping(address => uint) public ethBalances;\n', '    uint[] public prices;\n', '    uint[] public amounts;\n', '\n', '    mapping(address => uint) private balances;\n', '\n', '    // 2018.02.25 17:00 MSK\n', '    uint public constant defaultDeadline = 1519567200;\n', '    uint public deadline = defaultDeadline;\n', '\n', '    // Is ICO frozen\n', '    bool public isIcoStopped = false;\n', '\n', '    // Addresses of allowed tokens for buying\n', '    address[] public allowedTokens;\n', '    // Amount of token\n', '    mapping(address => uint) public tokenAmount;\n', '    // Price of current token amount\n', '    mapping(address => uint) public tokenPrice;\n', '\n', '    // Full users list\n', '    address[] public usersList;\n', '    mapping(address => bool) isUserInList;\n', '    // Number of users that have returned their money\n', '    uint numberOfUsersReturned = 0;\n', '\n', '    // user => token[]\n', '    mapping(address => address[]) public userTokens;\n', '    //  user => token => amount\n', '    mapping(address => mapping(address => uint)) public userTokensValues;\n', '\n', '    /*\n', '     * Events\n', '     */\n', '\n', '    event BuyTokens(address indexed _user, uint _ethValue, uint _boughtTokens);\n', '    event BuyTokensWithTokens(address indexed _user, address indexed _token, uint _tokenValue, uint _boughtTokens);\n', '    event GiveReward(address indexed _to, uint _value);\n', '\n', '    event IcoStoppedManually();\n', '    event IcoRunnedManually();\n', '\n', '    event WithdrawEther(address indexed _escrow, uint _ethValue);\n', '    event WithdrawToken(address indexed _escrow, address indexed _token, uint _value);\n', '    event ReturnEthersFor(address indexed _user, uint _value);\n', '    event ReturnTokensFor(address indexed _user, address indexed _token, uint _value);\n', '\n', '    event AddToken(address indexed _token, uint _amount, uint _price);\n', '    event RemoveToken(address indexed _token);\n', '\n', '    event MoveTokens(address indexed _from, address indexed _to, uint _value);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    /*\n', '     * Modifiers\n', '     */\n', '\n', '    modifier onlyManager {\n', '        assert(msg.sender == manager || msg.sender == reserveManager);\n', '        _;\n', '    }\n', '    modifier onlyManagerOrContract {\n', '        assert(msg.sender == manager || msg.sender == reserveManager || msg.sender == address(this));\n', '        _;\n', '    }\n', '    modifier IcoIsActive {\n', '        assert(isIcoActive());\n', '        _;\n', '    }\n', '\n', '\n', '    /// @dev Constructor of PreIco.\n', '    /// @param _manager Address of manager\n', '    /// @param _reserveManager Address of reserve manager\n', '    /// @param _escrow Address of escrow\n', '    /// @param _reserveEscrow Address of reserve escrow\n', '    /// @param _deadline ICO deadline timestamp. If is 0, sets 1515679200\n', '    function PreIco(address _manager, address _reserveManager, address _escrow, address _reserveEscrow, uint _deadline) public {\n', '        assert(_manager != 0x0);\n', '        assert(_reserveManager != 0x0);\n', '        assert(_escrow != 0x0);\n', '        assert(_reserveEscrow != 0x0);\n', '\n', '        manager = _manager;\n', '        reserveManager = _reserveManager;\n', '        escrow = _escrow;\n', '        reserveEscrow = _reserveEscrow;\n', '\n', '        if (_deadline != 0) {\n', '            deadline = _deadline;\n', '        }\n', '        tokenPriceMultiplies.push(tokenPriceMultiply1);\n', '        tokenPriceDivides.push(tokenPriceDivide1);\n', '        tokenAmounts.push(tokenAmount1);\n', '    }\n', '\n', '    /// @dev Returns token balance of user. 1 token = 1/10^18 RMC\n', '    /// @param _user Address of user\n', '    function balanceOf(address _user) public returns(uint balance) {\n', '        return balances[_user];\n', '    }\n', '\n', '    /// @dev Returns, is ICO enabled\n', '    function isIcoActive() public returns(bool isActive) {\n', '        return !isIcoStopped && now < deadline;\n', '    }\n', '\n', '    /// @dev Returns, is SoftCap reached\n', '    function isIcoSuccessful() public returns(bool isSuccessful) {\n', '        return tokensSupplied >= SOFT_CAPACITY;\n', '    }\n', '\n', '    /// @dev Calculates number of tokens RMC for buying with custom price of token\n', '    /// @param _amountOfToken Amount of RMC token\n', '    /// @param _priceAmountOfToken Price of amount of RMC\n', '    /// @param _value Amount of custom token\n', '    function getTokensAmount(uint _amountOfToken, uint _priceAmountOfToken,  uint _value) private returns(uint tokensToBuy) {\n', '        uint currentStep;\n', '        uint tokensRemoved = tokensSupplied;\n', '        for (currentStep = 0; currentStep < tokenAmounts.length; currentStep++) {\n', '            if (tokensRemoved >= tokenAmounts[currentStep]) {\n', '                tokensRemoved -= tokenAmounts[currentStep];\n', '            } else {\n', '                break;\n', '            }\n', '        }\n', '        assert(currentStep < tokenAmounts.length);\n', '\n', '        uint result = 0;\n', '\n', '        for (; currentStep <= tokenAmounts.length; currentStep++) {\n', '            assert(currentStep < tokenAmounts.length);\n', '\n', '            uint tokenOnStepLeft = tokenAmounts[currentStep] - tokensRemoved;\n', '            tokensRemoved = 0;\n', '            uint howManyTokensCanBuy = _value\n', '                    * _amountOfToken / _priceAmountOfToken\n', '                    * tokenPriceDivides[currentStep] / tokenPriceMultiplies[currentStep];\n', '\n', '            if (howManyTokensCanBuy > tokenOnStepLeft) {\n', '                result = add(result, tokenOnStepLeft);\n', '                uint spent = tokenOnStepLeft\n', '                    * _priceAmountOfToken / _amountOfToken\n', '                    * tokenPriceMultiplies[currentStep] / tokenPriceDivides[currentStep];\n', '                if (_value <= spent) {\n', '                    break;\n', '                }\n', '                _value -= spent;\n', '                tokensRemoved = 0;\n', '            } else {\n', '                result = add(result, howManyTokensCanBuy);\n', '                break;\n', '            }\n', '        }\n', '\n', '        return result;\n', '    }\n', '\n', '    /// @dev Calculates number of tokens RMC for buying with ETH\n', '    /// @param _value Amount of ETH token\n', '    function getTokensAmountWithEth(uint _value) private returns(uint tokensToBuy) {\n', '        return getTokensAmount(BASE, TOKEN_PRICE, _value);\n', '    }\n', '\n', '    /// @dev Calculates number of tokens RMC for buying with ERC-20 token\n', '    /// @param _token Address of ERC-20 token\n', '    /// @param _tokenValue Amount of ETH token\n', '    function getTokensAmountByTokens(address _token, uint _tokenValue) private returns(uint tokensToBuy) {\n', '        assert(tokenPrice[_token] > 0);\n', '        return getTokensAmount(tokenPrice[_token], tokenAmount[_token], _tokenValue);\n', '    }\n', '\n', '    /// @dev Solds tokens for user by ETH\n', '    /// @param _user Address of user which buys token\n', '    /// @param _value Amount of ETH. 1 _value = 1/10^18 ETH\n', '    function buyTokens(address _user, uint _value) private IcoIsActive {\n', '        uint boughtTokens = getTokensAmountWithEth(_value);\n', '        burnTokens(boughtTokens);\n', '\n', '        balances[_user] = add(balances[_user], boughtTokens);\n', '        addUserToList(_user);\n', '        BuyTokens(_user, _value, boughtTokens);\n', '    }\n', '\n', '    /// @dev Makes ERC-20 token sellable\n', '    /// @param _token Address of ERC-20 token\n', '    /// @param _amount Amount of current token\n', '    /// @param _price Price of _amount of token\n', '    function addToken(address _token, uint _amount, uint _price) onlyManager public {\n', '        assert(_token != 0x0);\n', '        assert(_amount > 0);\n', '        assert(_price > 0);\n', '\n', '        bool isNewToken = true;\n', '        for (uint i = 0; i < allowedTokens.length; i++) {\n', '            if (allowedTokens[i] == _token) {\n', '                isNewToken = false;\n', '                break;\n', '            }\n', '        }\n', '        if (isNewToken) {\n', '            allowedTokens.push(_token);\n', '        }\n', '\n', '        tokenPrice[_token] = _price;\n', '        tokenAmount[_token] = _amount;\n', '    }\n', '\n', '    /// @dev Makes ERC-20 token not sellable\n', '    /// @param _token Address of ERC-20 token\n', '    function removeToken(address _token) onlyManager public {\n', '        for (uint i = 0; i < allowedTokens.length; i++) {\n', '            if (_token == allowedTokens[i]) {\n', '                if (i < allowedTokens.length - 1) {\n', '                    allowedTokens[i] = allowedTokens[allowedTokens.length - 1];\n', '                }\n', '                allowedTokens[allowedTokens.length - 1] = 0x0;\n', '                allowedTokens.length--;\n', '                break;\n', '            }\n', '        }\n', '\n', '        tokenPrice[_token] = 0;\n', '        tokenAmount[_token] = 0;\n', '    }\n', '\n', '    /// @dev add user to usersList\n', '    /// @param _user Address of user\n', '    function addUserToList(address _user) private {\n', '        if (!isUserInList[_user]) {\n', '            isUserInList[_user] = true;\n', '            usersList.push(_user);\n', '        }\n', '    }\n', '\n', '    /// @dev Makes amount of tokens not purchasable\n', '    /// @param _amount Amount of RMC tokens\n', '    function burnTokens(uint _amount) private {\n', '        assert(add(tokensSupplied, _amount) <= TOKENS_SUPPLY);\n', '        tokensSupplied = add(tokensSupplied, _amount);\n', '    }\n', '\n', '    /// @dev Takes ERC-20 tokens approved by user for using and gives him RMC tokens\n', '    /// @param _token Address of ERC-20 token\n', '    function buyWithTokens(address _token) public {\n', '        buyWithTokensBy(msg.sender, _token);\n', '    }\n', '\n', '    /// @dev Takes ERC-20 tokens approved by user for using and gives him RMC tokens. Can be called by anyone\n', '    /// @param _user Address of user\n', '    /// @param _token Address of ERC-20 token\n', '    function buyWithTokensBy(address _user, address _token) public IcoIsActive {\n', '        // Checks whether the token is allowed\n', '        assert(tokenPrice[_token] > 0);\n', '\n', '        AbstractToken token = AbstractToken(_token);\n', '        uint tokensToSend = token.allowance(_user, address(this));\n', '        assert(tokensToSend > 0);\n', '\n', '        uint boughtTokens = getTokensAmountByTokens(_token, tokensToSend);\n', '        burnTokens(boughtTokens);\n', '        balances[_user] = add(balances[_user], boughtTokens);\n', '\n', '        uint prevBalance = token.balanceOf(address(this));\n', '        assert(token.transferFrom(_user, address(this), tokensToSend));\n', '        assert(token.balanceOf(address(this)) - prevBalance == tokensToSend);\n', '\n', '        userTokensValues[_user][_token] = add(userTokensValues[_user][_token], tokensToSend);\n', '\n', '        addTokenToUser(_user, _token);\n', '        addUserToList(_user);\n', '        BuyTokensWithTokens(_user, _token, tokensToSend, boughtTokens);\n', '    }\n', '\n', '    /// @dev Makes amount of tokens returnable for user. If _buyTokens equals true, buy tokens\n', '    /// @param _user Address of user\n', '    /// @param _token Address of ERC-20 token\n', '    /// @param _tokenValue Amount of ERC-20 token\n', '    /// @param _buyTokens If true, buys tokens for this sum\n', '    function addTokensToReturn(address _user, address _token, uint _tokenValue, bool _buyTokens) public onlyManager {\n', '        // Checks whether the token is allowed\n', '        assert(tokenPrice[_token] > 0);\n', '\n', '        if (_buyTokens) {\n', '            uint boughtTokens = getTokensAmountByTokens(_token, _tokenValue);\n', '            burnTokens(boughtTokens);\n', '            balances[_user] = add(balances[_user], boughtTokens);\n', '            BuyTokensWithTokens(_user, _token, _tokenValue, boughtTokens);\n', '        }\n', '\n', '        userTokensValues[_user][_token] = add(userTokensValues[_user][_token], _tokenValue);\n', '        addTokenToUser(_user, _token);\n', '        addUserToList(_user);\n', '    }\n', '\n', '\n', "    /// @dev Adds ERC-20 tokens to user's token list\n", '    /// @param _user Address of user\n', '    /// @param _token Address of ERC-20 token\n', '    function addTokenToUser(address _user, address _token) private {\n', '        for (uint i = 0; i < userTokens[_user].length; i++) {\n', '            if (userTokens[_user][i] == _token) {\n', '                return;\n', '            }\n', '        }\n', '        userTokens[_user].push(_token);\n', '    }\n', '\n', '    /// @dev Returns ether and tokens to user. Can be called only if ICO is ended and SoftCap is not reached\n', '    function returnFunds() public {\n', '        assert(!isIcoSuccessful() && !isIcoActive());\n', '\n', '        returnFundsFor(msg.sender);\n', '    }\n', '\n', '    /// @dev Moves tokens from one user to another. Can be called only by manager. This function added for users that send ether by stock exchanges\n', '    function moveIcoTokens(address _from, address _to, uint _value) public onlyManager {\n', '        balances[_from] = sub(balances[_from], _value);\n', '        balances[_to] = add(balances[_to], _value);\n', '\n', '        MoveTokens(_from, _to, _value);\n', '    }\n', '\n', '    /// @dev Returns ether and tokens to user. Can be called only by manager or contract\n', '    /// @param _user Address of user\n', '    function returnFundsFor(address _user) public onlyManagerOrContract returns(bool) {\n', '        if (ethBalances[_user] > 0) {\n', '            if (_user.send(ethBalances[_user])) {\n', '                ReturnEthersFor(_user, ethBalances[_user]);\n', '                ethBalances[_user] = 0;\n', '            }\n', '        }\n', '\n', '        for (uint i = 0; i < userTokens[_user].length; i++) {\n', '            address tokenAddress = userTokens[_user][i];\n', '            uint userTokenValue = userTokensValues[_user][tokenAddress];\n', '            if (userTokenValue > 0) {\n', '                AbstractToken token = AbstractToken(tokenAddress);\n', '                if (token.transfer(_user, userTokenValue)) {\n', '                    ReturnTokensFor(_user, tokenAddress, userTokenValue);\n', '                    userTokensValues[_user][tokenAddress] = 0;\n', '                }\n', '            }\n', '        }\n', '\n', '        balances[_user] = 0;\n', '    }\n', '\n', '    /// @dev Returns ether and tokens to list of users. Can be called only by manager\n', '    /// @param _users Array of addresses of users\n', '    function returnFundsForMultiple(address[] _users) public onlyManager {\n', '        for (uint i = 0; i < _users.length; i++) {\n', '            returnFundsFor(_users[i]);\n', '        }\n', '    }\n', '\n', '    /// @dev Returns ether and tokens to 50 users. Can be called only by manager\n', '    function returnFundsForAll() public onlyManager {\n', '        assert(!isIcoActive() && !isIcoSuccessful());\n', '\n', '        uint first = numberOfUsersReturned;\n', '        uint last  = (first + 50 < usersList.length) ? first + 50 : usersList.length;\n', '\n', '        for (uint i = first; i < last; i++) {\n', '            returnFundsFor(usersList[i]);\n', '        }\n', '\n', '        numberOfUsersReturned = last;\n', '    }\n', '\n', '    /// @dev Withdraws ether and tokens to _escrow if SoftCap is reached\n', '    /// @param _escrow Address of escrow\n', '    function withdrawEtherTo(address _escrow) private {\n', '        assert(isIcoSuccessful());\n', '\n', '        if (this.balance > 0) {\n', '            if (_escrow.send(this.balance)) {\n', '                WithdrawEther(_escrow, this.balance);\n', '            }\n', '        }\n', '\n', '        for (uint i = 0; i < allowedTokens.length; i++) {\n', '            AbstractToken token = AbstractToken(allowedTokens[i]);\n', '            uint tokenBalance = token.balanceOf(address(this));\n', '            if (tokenBalance > 0) {\n', '                if (token.transfer(_escrow, tokenBalance)) {\n', '                    WithdrawToken(_escrow, address(token), tokenBalance);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    /// @dev Withdraw ether and tokens to escrow. Can be called only by manager\n', '    function withdrawEther() public onlyManager {\n', '        withdrawEtherTo(escrow);\n', '    }\n', '\n', '    /// @dev Withdraw ether and tokens to reserve escrow. Can be called only by manager\n', '    function withdrawEtherToReserveEscrow() public onlyManager {\n', '        withdrawEtherTo(reserveEscrow);\n', '    }\n', '\n', '    /// @dev Enables disabled ICO. Can be called only by manager\n', '    function runIco() public onlyManager {\n', '        assert(isIcoStopped);\n', '        isIcoStopped = false;\n', '        IcoRunnedManually();\n', '    }\n', '\n', '    /// @dev Disables ICO. Can be called only by manager\n', '    function stopIco() public onlyManager {\n', '        isIcoStopped = true;\n', '        IcoStoppedManually();\n', '    }\n', '\n', '    /// @dev Fallback function. Buy RMC tokens on sending ether\n', '    function () public payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    /// @dev Gives bounty reward to user. Can be called only by manager\n', '    /// @param _to Address of user\n', '    /// @param _amount Amount of bounty\n', '    function giveReward(address _to, uint _amount) public onlyManager {\n', '        assert(_to != 0x0);\n', '        assert(_amount > 0);\n', '        assert(add(bountySupplied, _amount) <= BOUNTY_SUPPLY);\n', '\n', '        bountySupplied = add(bountySupplied, _amount);\n', '        balances[_to] = add(balances[_to], _amount);\n', '\n', '        GiveReward(_to, _amount);\n', '    }\n', '\n', '    /// Adds other ERC-20 functions\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        return false;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        return false;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        return false;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return 0;\n', '    }\n', '}']