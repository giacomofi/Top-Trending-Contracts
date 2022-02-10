['pragma solidity ^0.4.24;\n', '\n', 'contract Token {\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "msg.sender is not the owner");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '        @dev Transfers the ownership of the contract.\n', '\n', '        @param _to Address of the new owner\n', '    */\n', '    function transferTo(address _to) external onlyOwner returns (bool) {\n', '        require(_to != address(0), "Can&#39;t transfer to address 0x0");\n', '        owner = _to;\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '    @dev Defines the interface of a standard RCN oracle.\n', '\n', '    The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,\n', '    it&#39;s primarily used by the exchange but could be used by any other agent.\n', '*/\n', 'contract Oracle is Ownable {\n', '    uint256 public constant VERSION = 4;\n', '\n', '    event NewSymbol(bytes32 _currency);\n', '\n', '    mapping(bytes32 => bool) public supported;\n', '    bytes32[] public currencies;\n', '\n', '    /**\n', '        @dev Returns the url where the oracle exposes a valid "oracleData" if needed\n', '    */\n', '    function url() public view returns (string);\n', '\n', '    /**\n', '        @dev Returns a valid convertion rate from the currency given to RCN\n', '\n', '        @param symbol Symbol of the currency\n', '        @param data Generic data field, could be used for off-chain signing\n', '    */\n', '    function getRate(bytes32 symbol, bytes data) external returns (uint256 rate, uint256 decimals);\n', '\n', '    /**\n', '        @dev Adds a currency to the oracle, once added it cannot be removed\n', '\n', '        @param ticker Symbol of the currency\n', '\n', '        @return if the creation was done successfully\n', '    */\n', '    function addCurrency(string ticker) public onlyOwner returns (bool) {\n', '        bytes32 currency = encodeCurrency(ticker);\n', '        emit NewSymbol(currency);\n', '        supported[currency] = true;\n', '        currencies.push(currency);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @return the currency encoded as a bytes32\n', '    */\n', '    function encodeCurrency(string currency) public pure returns (bytes32 o) {\n', '        require(bytes(currency).length <= 32, "Currency too long");\n', '        assembly {\n', '            o := mload(add(currency, 32))\n', '        }\n', '    }\n', '    \n', '    /**\n', '        @return the currency string from a encoded bytes32\n', '    */\n', '    function decodeCurrency(bytes32 b) public pure returns (string o) {\n', '        uint256 ns = 256;\n', '        while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }\n', '        assembly {\n', '            ns := div(ns, 8)\n', '            o := mload(0x40)\n', '            mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))\n', '            mstore(o, ns)\n', '            mstore(add(o, 32), b)\n', '        }\n', '    }\n', '}\n', '\n', 'contract Engine {\n', '    uint256 public VERSION;\n', '    string public VERSION_NAME;\n', '\n', '    enum Status { initial, lent, paid, destroyed }\n', '    struct Approbation {\n', '        bool approved;\n', '        bytes data;\n', '        bytes32 checksum;\n', '    }\n', '\n', '    function getTotalLoans() public view returns (uint256);\n', '    function getOracle(uint index) public view returns (Oracle);\n', '    function getBorrower(uint index) public view returns (address);\n', '    function getCosigner(uint index) public view returns (address);\n', '    function ownerOf(uint256) public view returns (address owner);\n', '    function getCreator(uint index) public view returns (address);\n', '    function getAmount(uint index) public view returns (uint256);\n', '    function getPaid(uint index) public view returns (uint256);\n', '    function getDueTime(uint index) public view returns (uint256);\n', '    function getApprobation(uint index, address _address) public view returns (bool);\n', '    function getStatus(uint index) public view returns (Status);\n', '    function isApproved(uint index) public view returns (bool);\n', '    function getPendingAmount(uint index) public returns (uint256);\n', '    function getCurrency(uint index) public view returns (bytes32);\n', '    function cosign(uint index, uint256 cost) external returns (bool);\n', '    function approveLoan(uint index) public returns (bool);\n', '    function transfer(address to, uint256 index) public returns (bool);\n', '    function takeOwnership(uint256 index) public returns (bool);\n', '    function withdrawal(uint index, address to, uint256 amount) public returns (bool);\n', '    function identifierToIndex(bytes32 signature) public view returns (uint256);\n', '}\n', '\n', '\n', '/**\n', '    @dev Defines the interface of a standard RCN cosigner.\n', '\n', '    The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions\n', '    of the insurance and the cost of the given are defined by the cosigner. \n', '\n', '    The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the\n', '    agent should be passed as params when the lender calls the "lend" method on the engine.\n', '    \n', '    When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine\n', '    should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to\n', '    call this method, like the transfer of the ownership of the loan.\n', '*/\n', 'contract Cosigner {\n', '    uint256 public constant VERSION = 2;\n', '    \n', '    /**\n', '        @return the url of the endpoint that exposes the insurance offers.\n', '    */\n', '    function url() public view returns (string);\n', '    \n', '    /**\n', '        @dev Retrieves the cost of a given insurance, this amount should be exact.\n', '\n', '        @return the cost of the cosign, in RCN wei\n', '    */\n', '    function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);\n', '    \n', '    /**\n', '        @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of\n', '        the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or\n', '        does not return true to this method, the operation fails.\n', '\n', '        @return true if the cosigner accepts the liability\n', '    */\n', '    function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);\n', '    \n', '    /**\n', '        @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the\n', '        current lender of the loan.\n', '\n', '        @return true if the claim was done correctly.\n', '    */\n', '    function claim(address engine, uint256 index, bytes oracleData) public returns (bool);\n', '}\n', '\n', '\n', 'contract TokenConverter {\n', '    address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;\n', '    function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);\n', '    function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);\n', '}\n', '\n', '\n', 'contract TokenConverterOracle2 is Oracle {\n', '    address public delegate;\n', '    address public ogToken;\n', '\n', '    mapping(bytes32 => Currency) public sources;\n', '    mapping(bytes32 => Cache) public cache;\n', '    \n', '    event DelegatedCall(address _requester, address _to);\n', '    event CacheHit(address _requester, bytes32 _currency, uint256 _rate, uint256 _decimals);\n', '    event DeliveredRate(address _requester, bytes32 _currency, uint256 _rate, uint256 _decimals);\n', '    event SetSource(bytes32 _currency, address _converter, address _token, uint128 _sample, bool _cached);\n', '    event SetDelegate(address _prev, address _new);\n', '    event SetOgToken(address _prev, address _new);\n', '\n', '    struct Cache {\n', '        uint64 decimals;\n', '        uint64 blockNumber;\n', '        uint128 rate;\n', '    }\n', '\n', '    struct Currency {\n', '        bool cached;\n', '        uint8 decimals;\n', '        address converter;\n', '        address token;\n', '    }\n', '\n', '    function setDelegate(\n', '        address _delegate\n', '    ) external onlyOwner {\n', '        emit SetDelegate(delegate, _delegate);\n', '        delegate = _delegate;\n', '    }\n', '\n', '    function setOgToken(\n', '        address _ogToken\n', '    ) external onlyOwner {\n', '        emit SetOgToken(ogToken, _ogToken);\n', '        ogToken = _ogToken;\n', '    }\n', '\n', '    function setCurrency(\n', '        string code,\n', '        address converter,\n', '        address token,\n', '        uint8 decimals,\n', '        bool cached\n', '    ) external onlyOwner returns (bool) {\n', '        // Set supported currency\n', '        bytes32 currency = encodeCurrency(code);\n', '        if (!supported[currency]) {\n', '            emit NewSymbol(currency);\n', '            supported[currency] = true;\n', '            currencies.push(currency);\n', '        }\n', '\n', '        // Save converter info\n', '        sources[currency] = Currency({\n', '            cached: cached,\n', '            converter: converter,\n', '            token: token,\n', '            decimals: decimals\n', '        });\n', '\n', '        emit SetSource(currency, converter, token, decimals, cached);\n', '        return true;\n', '    }\n', '\n', '    function url() public view returns (string) {\n', '        return "";\n', '    }\n', '\n', '    function getRate(\n', '        bytes32 _symbol,\n', '        bytes _data\n', '    ) external returns (uint256 rate, uint256 decimals) {\n', '        if (delegate != address(0)) {\n', '            emit DelegatedCall(msg.sender, delegate);\n', '            return Oracle(delegate).getRate(_symbol, _data);\n', '        }\n', '\n', '        Currency memory currency = sources[_symbol];\n', '\n', '        if (currency.cached) {\n', '            Cache memory _cache = cache[_symbol];\n', '            if (_cache.blockNumber == block.number) {\n', '                emit CacheHit(msg.sender, _symbol, _cache.rate, _cache.decimals);\n', '                return (_cache.rate, _cache.decimals);\n', '            }\n', '        }\n', '        \n', '        require(currency.converter != address(0), "Currency not supported");\n', '        decimals = currency.decimals;\n', '        rate = TokenConverter(currency.converter).getReturn(Token(currency.token), Token(ogToken), 10 ** decimals);\n', '        emit DeliveredRate(msg.sender, _symbol, rate, decimals);\n', '\n', '        // If cached and rate < 2 ** 128\n', '        if (currency.cached && rate < 340282366920938463463374607431768211456) {\n', '            cache[_symbol] = Cache({\n', '                decimals: currency.decimals,\n', '                blockNumber: uint64(block.number),\n', '                rate: uint128(rate)\n', '            });\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract Token {\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "msg.sender is not the owner");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '        @dev Transfers the ownership of the contract.\n', '\n', '        @param _to Address of the new owner\n', '    */\n', '    function transferTo(address _to) external onlyOwner returns (bool) {\n', '        require(_to != address(0), "Can\'t transfer to address 0x0");\n', '        owner = _to;\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '    @dev Defines the interface of a standard RCN oracle.\n', '\n', '    The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,\n', "    it's primarily used by the exchange but could be used by any other agent.\n", '*/\n', 'contract Oracle is Ownable {\n', '    uint256 public constant VERSION = 4;\n', '\n', '    event NewSymbol(bytes32 _currency);\n', '\n', '    mapping(bytes32 => bool) public supported;\n', '    bytes32[] public currencies;\n', '\n', '    /**\n', '        @dev Returns the url where the oracle exposes a valid "oracleData" if needed\n', '    */\n', '    function url() public view returns (string);\n', '\n', '    /**\n', '        @dev Returns a valid convertion rate from the currency given to RCN\n', '\n', '        @param symbol Symbol of the currency\n', '        @param data Generic data field, could be used for off-chain signing\n', '    */\n', '    function getRate(bytes32 symbol, bytes data) external returns (uint256 rate, uint256 decimals);\n', '\n', '    /**\n', '        @dev Adds a currency to the oracle, once added it cannot be removed\n', '\n', '        @param ticker Symbol of the currency\n', '\n', '        @return if the creation was done successfully\n', '    */\n', '    function addCurrency(string ticker) public onlyOwner returns (bool) {\n', '        bytes32 currency = encodeCurrency(ticker);\n', '        emit NewSymbol(currency);\n', '        supported[currency] = true;\n', '        currencies.push(currency);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @return the currency encoded as a bytes32\n', '    */\n', '    function encodeCurrency(string currency) public pure returns (bytes32 o) {\n', '        require(bytes(currency).length <= 32, "Currency too long");\n', '        assembly {\n', '            o := mload(add(currency, 32))\n', '        }\n', '    }\n', '    \n', '    /**\n', '        @return the currency string from a encoded bytes32\n', '    */\n', '    function decodeCurrency(bytes32 b) public pure returns (string o) {\n', '        uint256 ns = 256;\n', '        while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }\n', '        assembly {\n', '            ns := div(ns, 8)\n', '            o := mload(0x40)\n', '            mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))\n', '            mstore(o, ns)\n', '            mstore(add(o, 32), b)\n', '        }\n', '    }\n', '}\n', '\n', 'contract Engine {\n', '    uint256 public VERSION;\n', '    string public VERSION_NAME;\n', '\n', '    enum Status { initial, lent, paid, destroyed }\n', '    struct Approbation {\n', '        bool approved;\n', '        bytes data;\n', '        bytes32 checksum;\n', '    }\n', '\n', '    function getTotalLoans() public view returns (uint256);\n', '    function getOracle(uint index) public view returns (Oracle);\n', '    function getBorrower(uint index) public view returns (address);\n', '    function getCosigner(uint index) public view returns (address);\n', '    function ownerOf(uint256) public view returns (address owner);\n', '    function getCreator(uint index) public view returns (address);\n', '    function getAmount(uint index) public view returns (uint256);\n', '    function getPaid(uint index) public view returns (uint256);\n', '    function getDueTime(uint index) public view returns (uint256);\n', '    function getApprobation(uint index, address _address) public view returns (bool);\n', '    function getStatus(uint index) public view returns (Status);\n', '    function isApproved(uint index) public view returns (bool);\n', '    function getPendingAmount(uint index) public returns (uint256);\n', '    function getCurrency(uint index) public view returns (bytes32);\n', '    function cosign(uint index, uint256 cost) external returns (bool);\n', '    function approveLoan(uint index) public returns (bool);\n', '    function transfer(address to, uint256 index) public returns (bool);\n', '    function takeOwnership(uint256 index) public returns (bool);\n', '    function withdrawal(uint index, address to, uint256 amount) public returns (bool);\n', '    function identifierToIndex(bytes32 signature) public view returns (uint256);\n', '}\n', '\n', '\n', '/**\n', '    @dev Defines the interface of a standard RCN cosigner.\n', '\n', '    The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions\n', '    of the insurance and the cost of the given are defined by the cosigner. \n', '\n', '    The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the\n', '    agent should be passed as params when the lender calls the "lend" method on the engine.\n', '    \n', '    When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine\n', '    should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to\n', '    call this method, like the transfer of the ownership of the loan.\n', '*/\n', 'contract Cosigner {\n', '    uint256 public constant VERSION = 2;\n', '    \n', '    /**\n', '        @return the url of the endpoint that exposes the insurance offers.\n', '    */\n', '    function url() public view returns (string);\n', '    \n', '    /**\n', '        @dev Retrieves the cost of a given insurance, this amount should be exact.\n', '\n', '        @return the cost of the cosign, in RCN wei\n', '    */\n', '    function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);\n', '    \n', '    /**\n', '        @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of\n', '        the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or\n', '        does not return true to this method, the operation fails.\n', '\n', '        @return true if the cosigner accepts the liability\n', '    */\n', '    function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);\n', '    \n', '    /**\n', '        @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the\n', '        current lender of the loan.\n', '\n', '        @return true if the claim was done correctly.\n', '    */\n', '    function claim(address engine, uint256 index, bytes oracleData) public returns (bool);\n', '}\n', '\n', '\n', 'contract TokenConverter {\n', '    address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;\n', '    function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);\n', '    function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);\n', '}\n', '\n', '\n', 'contract TokenConverterOracle2 is Oracle {\n', '    address public delegate;\n', '    address public ogToken;\n', '\n', '    mapping(bytes32 => Currency) public sources;\n', '    mapping(bytes32 => Cache) public cache;\n', '    \n', '    event DelegatedCall(address _requester, address _to);\n', '    event CacheHit(address _requester, bytes32 _currency, uint256 _rate, uint256 _decimals);\n', '    event DeliveredRate(address _requester, bytes32 _currency, uint256 _rate, uint256 _decimals);\n', '    event SetSource(bytes32 _currency, address _converter, address _token, uint128 _sample, bool _cached);\n', '    event SetDelegate(address _prev, address _new);\n', '    event SetOgToken(address _prev, address _new);\n', '\n', '    struct Cache {\n', '        uint64 decimals;\n', '        uint64 blockNumber;\n', '        uint128 rate;\n', '    }\n', '\n', '    struct Currency {\n', '        bool cached;\n', '        uint8 decimals;\n', '        address converter;\n', '        address token;\n', '    }\n', '\n', '    function setDelegate(\n', '        address _delegate\n', '    ) external onlyOwner {\n', '        emit SetDelegate(delegate, _delegate);\n', '        delegate = _delegate;\n', '    }\n', '\n', '    function setOgToken(\n', '        address _ogToken\n', '    ) external onlyOwner {\n', '        emit SetOgToken(ogToken, _ogToken);\n', '        ogToken = _ogToken;\n', '    }\n', '\n', '    function setCurrency(\n', '        string code,\n', '        address converter,\n', '        address token,\n', '        uint8 decimals,\n', '        bool cached\n', '    ) external onlyOwner returns (bool) {\n', '        // Set supported currency\n', '        bytes32 currency = encodeCurrency(code);\n', '        if (!supported[currency]) {\n', '            emit NewSymbol(currency);\n', '            supported[currency] = true;\n', '            currencies.push(currency);\n', '        }\n', '\n', '        // Save converter info\n', '        sources[currency] = Currency({\n', '            cached: cached,\n', '            converter: converter,\n', '            token: token,\n', '            decimals: decimals\n', '        });\n', '\n', '        emit SetSource(currency, converter, token, decimals, cached);\n', '        return true;\n', '    }\n', '\n', '    function url() public view returns (string) {\n', '        return "";\n', '    }\n', '\n', '    function getRate(\n', '        bytes32 _symbol,\n', '        bytes _data\n', '    ) external returns (uint256 rate, uint256 decimals) {\n', '        if (delegate != address(0)) {\n', '            emit DelegatedCall(msg.sender, delegate);\n', '            return Oracle(delegate).getRate(_symbol, _data);\n', '        }\n', '\n', '        Currency memory currency = sources[_symbol];\n', '\n', '        if (currency.cached) {\n', '            Cache memory _cache = cache[_symbol];\n', '            if (_cache.blockNumber == block.number) {\n', '                emit CacheHit(msg.sender, _symbol, _cache.rate, _cache.decimals);\n', '                return (_cache.rate, _cache.decimals);\n', '            }\n', '        }\n', '        \n', '        require(currency.converter != address(0), "Currency not supported");\n', '        decimals = currency.decimals;\n', '        rate = TokenConverter(currency.converter).getReturn(Token(currency.token), Token(ogToken), 10 ** decimals);\n', '        emit DeliveredRate(msg.sender, _symbol, rate, decimals);\n', '\n', '        // If cached and rate < 2 ** 128\n', '        if (currency.cached && rate < 340282366920938463463374607431768211456) {\n', '            cache[_symbol] = Cache({\n', '                decimals: currency.decimals,\n', '                blockNumber: uint64(block.number),\n', '                rate: uint128(rate)\n', '            });\n', '        }\n', '    }\n', '}']
