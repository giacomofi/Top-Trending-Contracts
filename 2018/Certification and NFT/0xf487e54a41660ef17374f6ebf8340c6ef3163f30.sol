['pragma solidity 0.4.15;\n', '\n', 'contract ERC20 {\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', 'contract REMMESale {\n', '    uint public constant SALES_START = 1518552000; // 13.02.2018 20:00:00 UTC\n', '    uint public constant FIRST_DAY_END = 1518638400; // 14.02.2018 20:00:00 UTC\n', '    uint public constant SALES_DEADLINE = 1518724800; // 15.02.2018 20:00:00 UTC\n', '    address public constant ASSET_MANAGER_WALLET = 0xbb12800E7446A51395B2d853D6Ce7F22210Bb5E5;\n', '    address public constant TOKEN = 0x83984d6142934bb535793A82ADB0a46EF0F66B6d; // REMME token\n', '    address public constant WHITELIST_SUPPLIER = 0x1Ff21eCa1c3ba96ed53783aB9C92FfbF77862584;\n', '    uint public constant TOKEN_CENTS = 10000; // 1 REM is 1.0000 REM\n', '    uint public constant BONUS = 10;\n', '    uint public constant SALE_MAX_CAP = 500000000 * TOKEN_CENTS;\n', '    uint public constant MINIMAL_PARTICIPATION = 0.1 ether;\n', '    uint public constant MAXIMAL_PARTICIPATION = 15 ether;\n', '\n', '    uint public saleContributions;\n', '    uint public tokensPurchased;\n', '    uint public allowedGasPrice = 20000000000 wei;\n', '    uint public tokenPriceWei;\n', '\n', '    mapping(address => uint) public participantContribution;\n', '    mapping(address => bool) public whitelist;\n', '\n', '    event Contributed(address receiver, uint contribution, uint reward);\n', '    event WhitelistUpdated(address participant, bool isWhitelisted);\n', '    event AllowedGasPriceUpdated(uint gasPrice);\n', '    event TokenPriceUpdated(uint tokenPriceWei);\n', '    event Error(string message);\n', '\n', '    function REMMESale(uint _ethUsdPrice) {\n', '        tokenPriceWei = 0.04 ether / _ethUsdPrice;\n', '    }\n', '\n', '    function contribute() payable returns(bool) {\n', '        return contributeFor(msg.sender);\n', '    }\n', '\n', '    function contributeFor(address _participant) payable returns(bool) {\n', '        require(now >= SALES_START);\n', '        require(now < SALES_DEADLINE);\n', '        require((participantContribution[_participant] + msg.value) >= MINIMAL_PARTICIPATION);\n', '        // Only the whitelisted addresses can participate.\n', '        require(whitelist[_participant]);\n', '\n', '        //check for MAXIMAL_PARTICIPATION and allowedGasPrice only at first day\n', '        if (now <= FIRST_DAY_END) {\n', '            require((participantContribution[_participant] + msg.value) <= MAXIMAL_PARTICIPATION);\n', '            require(tx.gasprice <= allowedGasPrice);\n', '        }\n', '\n', '        // If there is some division reminder, we just collect it too.\n', '        uint tokensAmount = (msg.value * TOKEN_CENTS) / tokenPriceWei;\n', '        require(tokensAmount > 0);\n', '        uint bonusTokens = (tokensAmount * BONUS) / 100;\n', '        uint totalTokens = tokensAmount + bonusTokens;\n', '\n', '        tokensPurchased += totalTokens;\n', '        require(tokensPurchased <= SALE_MAX_CAP);\n', '        require(ERC20(TOKEN).transferFrom(ASSET_MANAGER_WALLET, _participant, totalTokens));\n', '        saleContributions += msg.value;\n', '        participantContribution[_participant] += msg.value;\n', '        ASSET_MANAGER_WALLET.transfer(msg.value);\n', '\n', '        Contributed(_participant, msg.value, totalTokens);\n', '        return true;\n', '    }\n', '\n', '    modifier onlyWhitelistSupplier() {\n', '        require(msg.sender == WHITELIST_SUPPLIER || msg.sender == ASSET_MANAGER_WALLET);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == ASSET_MANAGER_WALLET);\n', '        _;\n', '    }\n', '\n', '    function addToWhitelist(address _participant) onlyWhitelistSupplier() returns(bool) {\n', '        if (whitelist[_participant]) {\n', '            return true;\n', '        }\n', '        whitelist[_participant] = true;\n', '        WhitelistUpdated(_participant, true);\n', '        return true;\n', '    }\n', '\n', '    function removeFromWhitelist(address _participant) onlyWhitelistSupplier() returns(bool) {\n', '        if (!whitelist[_participant]) {\n', '            return true;\n', '        }\n', '        whitelist[_participant] = false;\n', '        WhitelistUpdated(_participant, false);\n', '        return true;\n', '    }\n', '\n', '    function setGasPrice(uint _allowedGasPrice) onlyAdmin() returns(bool) {\n', '        allowedGasPrice = _allowedGasPrice;\n', '        AllowedGasPriceUpdated(allowedGasPrice);\n', '        return true;\n', '    }\n', '\n', '    function setEthPrice(uint _ethUsdPrice) onlyAdmin() returns(bool) {\n', '        tokenPriceWei = 0.04 ether / _ethUsdPrice;\n', '        TokenPriceUpdated(tokenPriceWei);\n', '        return true;\n', '    }\n', '\n', '    function () payable {\n', '        contribute();\n', '    }\n', '}']