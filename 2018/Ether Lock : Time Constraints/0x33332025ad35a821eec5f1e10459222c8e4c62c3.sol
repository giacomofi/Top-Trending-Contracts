['pragma solidity ^0.4.19;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender; \n', '    }\n', '\n', '    /**\n', '        @dev Transfers the ownership of the contract.\n', '\n', '        @param _to Address of the new owner\n', '    */\n', '    function setOwner(address _to) public onlyOwner returns (bool) {\n', '        require(_to != address(0));\n', '        owner = _to;\n', '        return true;\n', '    } \n', '}\n', '\n', '\n', 'contract Delegable is Ownable {\n', '    event AddDelegate(address delegate);\n', '    event RemoveDelegate(address delegate);\n', '\n', '    mapping(address => DelegateLog) public delegates;\n', '\n', '    struct DelegateLog {\n', '        uint256 started;\n', '        uint256 ended;\n', '    }\n', '\n', '    /**\n', '        @dev Only allows current delegates.\n', '    */\n', '    modifier onlyDelegate() {\n', '        DelegateLog memory delegateLog = delegates[msg.sender];\n', '        require(delegateLog.started != 0 && delegateLog.ended == 0);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '        @dev Checks if a delegate existed at the timestamp.\n', '\n', '        @param _address Address of the delegate\n', '        @param timestamp Moment to check\n', '\n', '        @return true if at the timestamp the delegate existed\n', '    */\n', '    function wasDelegate(address _address, uint256 timestamp) public view returns (bool) {\n', '        DelegateLog memory delegateLog = delegates[_address];\n', '        return timestamp >= delegateLog.started && delegateLog.started != 0 && (delegateLog.ended == 0 || timestamp < delegateLog.ended);\n', '    }\n', '\n', '    /**\n', '        @dev Checks if a delegate is active\n', '\n', '        @param _address Address of the delegate\n', '        \n', '        @return true if the delegate is active\n', '    */\n', '    function isDelegate(address _address) public view returns (bool) {\n', '        DelegateLog memory delegateLog = delegates[_address];\n', '        return delegateLog.started != 0 && delegateLog.ended == 0;\n', '    }\n', '\n', '    /**\n', '        @dev Adds a new worker.\n', '\n', '        @param _address Address of the worker\n', '    */\n', '    function addDelegate(address _address) public onlyOwner returns (bool) {\n', '        DelegateLog storage delegateLog = delegates[_address];\n', '        require(delegateLog.started == 0);\n', '        delegateLog.started = block.timestamp;\n', '        emit AddDelegate(_address);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Removes an existing worker, removed workers can&#39;t be added back.\n', '\n', '        @param _address Address of the worker to remove\n', '    */\n', '    function removeDelegate(address _address) public onlyOwner returns (bool) {\n', '        DelegateLog storage delegateLog = delegates[_address];\n', '        require(delegateLog.started != 0 && delegateLog.ended == 0);\n', '        delegateLog.ended = block.timestamp;\n', '        emit RemoveDelegate(_address);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BytesUtils {\n', '    function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {\n', '        require(data.length / 32 > index);\n', '        assembly {\n', '            o := mload(add(data, add(32, mul(32, index))))\n', '        }\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '}\n', '\n', '\n', '/**\n', '    @dev Defines the interface of a standard RCN oracle.\n', '\n', '    The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,\n', '    it&#39;s primarily used by the exchange but could be used by any other agent.\n', '*/\n', 'contract Oracle is Ownable {\n', '    uint256 public constant VERSION = 4;\n', '\n', '    event NewSymbol(bytes32 _currency);\n', '\n', '    mapping(bytes32 => bool) public supported;\n', '    bytes32[] public currencies;\n', '\n', '    /**\n', '        @dev Returns the url where the oracle exposes a valid "oracleData" if needed\n', '    */\n', '    function url() public view returns (string);\n', '\n', '    /**\n', '        @dev Returns a valid convertion rate from the currency given to RCN\n', '\n', '        @param symbol Symbol of the currency\n', '        @param data Generic data field, could be used for off-chain signing\n', '    */\n', '    function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);\n', '\n', '    /**\n', '        @dev Adds a currency to the oracle, once added it cannot be removed\n', '\n', '        @param ticker Symbol of the currency\n', '\n', '        @return if the creation was done successfully\n', '    */\n', '    function addCurrency(string ticker) public onlyOwner returns (bool) {\n', '        bytes32 currency = encodeCurrency(ticker);\n', '        NewSymbol(currency);\n', '        supported[currency] = true;\n', '        currencies.push(currency);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @return the currency encoded as a bytes32\n', '    */\n', '    function encodeCurrency(string currency) public pure returns (bytes32 o) {\n', '        require(bytes(currency).length <= 32);\n', '        assembly {\n', '            o := mload(add(currency, 32))\n', '        }\n', '    }\n', '    \n', '    /**\n', '        @return the currency string from a encoded bytes32\n', '    */\n', '    function decodeCurrency(bytes32 b) public pure returns (string o) {\n', '        uint256 ns = 256;\n', '        while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }\n', '        assembly {\n', '            ns := div(ns, 8)\n', '            o := mload(0x40)\n', '            mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))\n', '            mstore(o, ns)\n', '            mstore(add(o, 32), b)\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract RipioOracle is Oracle, Delegable, BytesUtils {\n', '    event DelegatedCall(address requester, address to);\n', '    event CacheHit(address requester, bytes32 currency, uint256 requestTimestamp, uint256 deliverTimestamp, uint256 rate, uint256 decimals);\n', '    event DeliveredRate(address requester, bytes32 currency, address signer, uint256 requestTimestamp, uint256 rate, uint256 decimals);\n', '\n', '    uint256 public expiration = 6 hours;\n', '\n', '    uint constant private INDEX_TIMESTAMP = 0;\n', '    uint constant private INDEX_RATE = 1;\n', '    uint constant private INDEX_DECIMALS = 2;\n', '    uint constant private INDEX_V = 3;\n', '    uint constant private INDEX_R = 4;\n', '    uint constant private INDEX_S = 5;\n', '\n', '    string private infoUrl;\n', '    \n', '    address public prevOracle;\n', '    Oracle public fallback;\n', '    mapping(bytes32 => RateCache) public cache;\n', '\n', '    struct RateCache {\n', '        uint256 timestamp;\n', '        uint256 rate;\n', '        uint256 decimals;\n', '    }\n', '\n', '    function url() public view returns (string) {\n', '        return infoUrl;\n', '    }\n', '\n', '    /**\n', '        @dev Sets the time window of the validity of the rates signed.\n', '\n', '        @param time Duration of the window\n', '\n', '        @return true is the time was set correctly\n', '    */\n', '    function setExpirationTime(uint256 time) public onlyOwner returns (bool) {\n', '        expiration = time;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Sets the url to retrieve the data for &#39;getRate&#39;\n', '\n', '        @param _url New url\n', '    */\n', '    function setUrl(string _url) public onlyOwner returns (bool) {\n', '        infoUrl = _url;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Sets another oracle as the replacement to this oracle\n', '        All &#39;getRate&#39; calls will be forwarded to this new oracle\n', '\n', '        @param _fallback New oracle\n', '    */\n', '    function setFallback(Oracle _fallback) public onlyOwner returns (bool) {\n', '        fallback = _fallback;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Invalidates the cache of a given currency\n', '\n', '        @param currency Currency to invalidate the cache\n', '    */\n', '    function invalidateCache(bytes32 currency) public onlyOwner returns (bool) {\n', '        delete cache[currency].timestamp;\n', '        return true;\n', '    }\n', '    \n', '    function setPrevOracle(address oracle) public onlyOwner returns (bool) {\n', '        prevOracle = oracle;\n', '        return true;\n', '    }\n', '\n', '    function isExpired(uint256 timestamp) internal view returns (bool) {\n', '        return timestamp <= now - expiration;\n', '    }\n', '\n', '    /**\n', '        @dev Retrieves the convertion rate of a given currency, the information of the rate is carried over the \n', '        data field. If there is a newer rate on the cache, that rate is delivered and the data field is ignored.\n', '\n', '        If the data contains a more recent rate than the cache, the cache is updated.\n', '\n', '        @param currency Hash of the currency\n', '        @param data Data with the rate signed by a delegate\n', '\n', '        @return the rate and decimals of the currency convertion\n', '    */\n', '    function getRate(bytes32 currency, bytes data) public returns (uint256, uint256) {\n', '        if (fallback != address(0)) {\n', '            emit DelegatedCall(msg.sender, fallback);\n', '            return fallback.getRate(currency, data);\n', '        }\n', '\n', '        uint256 timestamp = uint256(readBytes32(data, INDEX_TIMESTAMP));\n', '        RateCache memory rateCache = cache[currency];\n', '        if (rateCache.timestamp >= timestamp && !isExpired(rateCache.timestamp)) {\n', '            emit CacheHit(msg.sender, currency, timestamp, rateCache.timestamp, rateCache.rate, rateCache.decimals);\n', '            return (rateCache.rate, rateCache.decimals);\n', '        } else {\n', '            require(!isExpired(timestamp), "The rate provided is expired");\n', '            uint256 rate = uint256(readBytes32(data, INDEX_RATE));\n', '            uint256 decimals = uint256(readBytes32(data, INDEX_DECIMALS));\n', '            uint8 v = uint8(readBytes32(data, INDEX_V));\n', '            bytes32 r = readBytes32(data, INDEX_R);\n', '            bytes32 s = readBytes32(data, INDEX_S);\n', '            \n', '            bytes32 _hash = keccak256(abi.encodePacked(this, currency, rate, decimals, timestamp));\n', '            address signer = ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)),v,r,s);\n', '\n', '            if(!isDelegate(signer)) {\n', '                _hash = keccak256(abi.encodePacked(prevOracle, currency, rate, decimals, timestamp));\n', '                signer = ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)),v,r,s);\n', '                if(!isDelegate(signer)) {\n', '                    revert(&#39;Signature not valid&#39;);\n', '                }\n', '            }\n', '\n', '            cache[currency] = RateCache(timestamp, rate, decimals);\n', '\n', '            emit DeliveredRate(msg.sender, currency, signer, timestamp, rate, decimals);\n', '            return (rate, decimals);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender; \n', '    }\n', '\n', '    /**\n', '        @dev Transfers the ownership of the contract.\n', '\n', '        @param _to Address of the new owner\n', '    */\n', '    function setOwner(address _to) public onlyOwner returns (bool) {\n', '        require(_to != address(0));\n', '        owner = _to;\n', '        return true;\n', '    } \n', '}\n', '\n', '\n', 'contract Delegable is Ownable {\n', '    event AddDelegate(address delegate);\n', '    event RemoveDelegate(address delegate);\n', '\n', '    mapping(address => DelegateLog) public delegates;\n', '\n', '    struct DelegateLog {\n', '        uint256 started;\n', '        uint256 ended;\n', '    }\n', '\n', '    /**\n', '        @dev Only allows current delegates.\n', '    */\n', '    modifier onlyDelegate() {\n', '        DelegateLog memory delegateLog = delegates[msg.sender];\n', '        require(delegateLog.started != 0 && delegateLog.ended == 0);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '        @dev Checks if a delegate existed at the timestamp.\n', '\n', '        @param _address Address of the delegate\n', '        @param timestamp Moment to check\n', '\n', '        @return true if at the timestamp the delegate existed\n', '    */\n', '    function wasDelegate(address _address, uint256 timestamp) public view returns (bool) {\n', '        DelegateLog memory delegateLog = delegates[_address];\n', '        return timestamp >= delegateLog.started && delegateLog.started != 0 && (delegateLog.ended == 0 || timestamp < delegateLog.ended);\n', '    }\n', '\n', '    /**\n', '        @dev Checks if a delegate is active\n', '\n', '        @param _address Address of the delegate\n', '        \n', '        @return true if the delegate is active\n', '    */\n', '    function isDelegate(address _address) public view returns (bool) {\n', '        DelegateLog memory delegateLog = delegates[_address];\n', '        return delegateLog.started != 0 && delegateLog.ended == 0;\n', '    }\n', '\n', '    /**\n', '        @dev Adds a new worker.\n', '\n', '        @param _address Address of the worker\n', '    */\n', '    function addDelegate(address _address) public onlyOwner returns (bool) {\n', '        DelegateLog storage delegateLog = delegates[_address];\n', '        require(delegateLog.started == 0);\n', '        delegateLog.started = block.timestamp;\n', '        emit AddDelegate(_address);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "        @dev Removes an existing worker, removed workers can't be added back.\n", '\n', '        @param _address Address of the worker to remove\n', '    */\n', '    function removeDelegate(address _address) public onlyOwner returns (bool) {\n', '        DelegateLog storage delegateLog = delegates[_address];\n', '        require(delegateLog.started != 0 && delegateLog.ended == 0);\n', '        delegateLog.ended = block.timestamp;\n', '        emit RemoveDelegate(_address);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BytesUtils {\n', '    function readBytes32(bytes data, uint256 index) internal pure returns (bytes32 o) {\n', '        require(data.length / 32 > index);\n', '        assembly {\n', '            o := mload(add(data, add(32, mul(32, index))))\n', '        }\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '}\n', '\n', '\n', '/**\n', '    @dev Defines the interface of a standard RCN oracle.\n', '\n', '    The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,\n', "    it's primarily used by the exchange but could be used by any other agent.\n", '*/\n', 'contract Oracle is Ownable {\n', '    uint256 public constant VERSION = 4;\n', '\n', '    event NewSymbol(bytes32 _currency);\n', '\n', '    mapping(bytes32 => bool) public supported;\n', '    bytes32[] public currencies;\n', '\n', '    /**\n', '        @dev Returns the url where the oracle exposes a valid "oracleData" if needed\n', '    */\n', '    function url() public view returns (string);\n', '\n', '    /**\n', '        @dev Returns a valid convertion rate from the currency given to RCN\n', '\n', '        @param symbol Symbol of the currency\n', '        @param data Generic data field, could be used for off-chain signing\n', '    */\n', '    function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);\n', '\n', '    /**\n', '        @dev Adds a currency to the oracle, once added it cannot be removed\n', '\n', '        @param ticker Symbol of the currency\n', '\n', '        @return if the creation was done successfully\n', '    */\n', '    function addCurrency(string ticker) public onlyOwner returns (bool) {\n', '        bytes32 currency = encodeCurrency(ticker);\n', '        NewSymbol(currency);\n', '        supported[currency] = true;\n', '        currencies.push(currency);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @return the currency encoded as a bytes32\n', '    */\n', '    function encodeCurrency(string currency) public pure returns (bytes32 o) {\n', '        require(bytes(currency).length <= 32);\n', '        assembly {\n', '            o := mload(add(currency, 32))\n', '        }\n', '    }\n', '    \n', '    /**\n', '        @return the currency string from a encoded bytes32\n', '    */\n', '    function decodeCurrency(bytes32 b) public pure returns (string o) {\n', '        uint256 ns = 256;\n', '        while (true) { if (ns == 0 || (b<<ns-8) != 0) break; ns -= 8; }\n', '        assembly {\n', '            ns := div(ns, 8)\n', '            o := mload(0x40)\n', '            mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))\n', '            mstore(o, ns)\n', '            mstore(add(o, 32), b)\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract RipioOracle is Oracle, Delegable, BytesUtils {\n', '    event DelegatedCall(address requester, address to);\n', '    event CacheHit(address requester, bytes32 currency, uint256 requestTimestamp, uint256 deliverTimestamp, uint256 rate, uint256 decimals);\n', '    event DeliveredRate(address requester, bytes32 currency, address signer, uint256 requestTimestamp, uint256 rate, uint256 decimals);\n', '\n', '    uint256 public expiration = 6 hours;\n', '\n', '    uint constant private INDEX_TIMESTAMP = 0;\n', '    uint constant private INDEX_RATE = 1;\n', '    uint constant private INDEX_DECIMALS = 2;\n', '    uint constant private INDEX_V = 3;\n', '    uint constant private INDEX_R = 4;\n', '    uint constant private INDEX_S = 5;\n', '\n', '    string private infoUrl;\n', '    \n', '    address public prevOracle;\n', '    Oracle public fallback;\n', '    mapping(bytes32 => RateCache) public cache;\n', '\n', '    struct RateCache {\n', '        uint256 timestamp;\n', '        uint256 rate;\n', '        uint256 decimals;\n', '    }\n', '\n', '    function url() public view returns (string) {\n', '        return infoUrl;\n', '    }\n', '\n', '    /**\n', '        @dev Sets the time window of the validity of the rates signed.\n', '\n', '        @param time Duration of the window\n', '\n', '        @return true is the time was set correctly\n', '    */\n', '    function setExpirationTime(uint256 time) public onlyOwner returns (bool) {\n', '        expiration = time;\n', '        return true;\n', '    }\n', '\n', '    /**\n', "        @dev Sets the url to retrieve the data for 'getRate'\n", '\n', '        @param _url New url\n', '    */\n', '    function setUrl(string _url) public onlyOwner returns (bool) {\n', '        infoUrl = _url;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Sets another oracle as the replacement to this oracle\n', "        All 'getRate' calls will be forwarded to this new oracle\n", '\n', '        @param _fallback New oracle\n', '    */\n', '    function setFallback(Oracle _fallback) public onlyOwner returns (bool) {\n', '        fallback = _fallback;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev Invalidates the cache of a given currency\n', '\n', '        @param currency Currency to invalidate the cache\n', '    */\n', '    function invalidateCache(bytes32 currency) public onlyOwner returns (bool) {\n', '        delete cache[currency].timestamp;\n', '        return true;\n', '    }\n', '    \n', '    function setPrevOracle(address oracle) public onlyOwner returns (bool) {\n', '        prevOracle = oracle;\n', '        return true;\n', '    }\n', '\n', '    function isExpired(uint256 timestamp) internal view returns (bool) {\n', '        return timestamp <= now - expiration;\n', '    }\n', '\n', '    /**\n', '        @dev Retrieves the convertion rate of a given currency, the information of the rate is carried over the \n', '        data field. If there is a newer rate on the cache, that rate is delivered and the data field is ignored.\n', '\n', '        If the data contains a more recent rate than the cache, the cache is updated.\n', '\n', '        @param currency Hash of the currency\n', '        @param data Data with the rate signed by a delegate\n', '\n', '        @return the rate and decimals of the currency convertion\n', '    */\n', '    function getRate(bytes32 currency, bytes data) public returns (uint256, uint256) {\n', '        if (fallback != address(0)) {\n', '            emit DelegatedCall(msg.sender, fallback);\n', '            return fallback.getRate(currency, data);\n', '        }\n', '\n', '        uint256 timestamp = uint256(readBytes32(data, INDEX_TIMESTAMP));\n', '        RateCache memory rateCache = cache[currency];\n', '        if (rateCache.timestamp >= timestamp && !isExpired(rateCache.timestamp)) {\n', '            emit CacheHit(msg.sender, currency, timestamp, rateCache.timestamp, rateCache.rate, rateCache.decimals);\n', '            return (rateCache.rate, rateCache.decimals);\n', '        } else {\n', '            require(!isExpired(timestamp), "The rate provided is expired");\n', '            uint256 rate = uint256(readBytes32(data, INDEX_RATE));\n', '            uint256 decimals = uint256(readBytes32(data, INDEX_DECIMALS));\n', '            uint8 v = uint8(readBytes32(data, INDEX_V));\n', '            bytes32 r = readBytes32(data, INDEX_R);\n', '            bytes32 s = readBytes32(data, INDEX_S);\n', '            \n', '            bytes32 _hash = keccak256(abi.encodePacked(this, currency, rate, decimals, timestamp));\n', '            address signer = ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)),v,r,s);\n', '\n', '            if(!isDelegate(signer)) {\n', '                _hash = keccak256(abi.encodePacked(prevOracle, currency, rate, decimals, timestamp));\n', '                signer = ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)),v,r,s);\n', '                if(!isDelegate(signer)) {\n', "                    revert('Signature not valid');\n", '                }\n', '            }\n', '\n', '            cache[currency] = RateCache(timestamp, rate, decimals);\n', '\n', '            emit DeliveredRate(msg.sender, currency, signer, timestamp, rate, decimals);\n', '            return (rate, decimals);\n', '        }\n', '    }\n', '}']