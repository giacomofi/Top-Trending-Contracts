['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/// @dev `Owned` is a base level contract that assigns an `owner` that can be\n', '///  later changed\n', 'contract Owned {\n', '\n', '    /// @dev `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    /// @notice The Constructor assigns the message sender to be `owner`\n', '    function Owned() public {owner = msg.sender;}\n', '\n', '    /// @notice `owner` can step down and assign some other address to this role\n', '    /// @param _newOwner The address of the new owner. 0x0 can be used to create\n', '    ///  an unowned neutral vault, however that cannot be undone\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract Callable is Owned {\n', '\n', '    //sender => _allowed\n', '    mapping(address => bool) public callers;\n', '\n', '    //modifiers\n', '    modifier onlyCaller {\n', '        require(callers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    //management of the repositories\n', '    function updateCaller(address _caller, bool allowed) public onlyOwner {\n', '        callers[_caller] = allowed;\n', '    }\n', '}\n', '\n', 'contract EternalStorage is Callable {\n', '\n', '    mapping(bytes32 => uint) uIntStorage;\n', '    mapping(bytes32 => string) stringStorage;\n', '    mapping(bytes32 => address) addressStorage;\n', '    mapping(bytes32 => bytes) bytesStorage;\n', '    mapping(bytes32 => bool) boolStorage;\n', '    mapping(bytes32 => int) intStorage;\n', '\n', '    // *** Getter Methods ***\n', '    function getUint(bytes32 _key) external view returns (uint) {\n', '        return uIntStorage[_key];\n', '    }\n', '\n', '    function getString(bytes32 _key) external view returns (string) {\n', '        return stringStorage[_key];\n', '    }\n', '\n', '    function getAddress(bytes32 _key) external view returns (address) {\n', '        return addressStorage[_key];\n', '    }\n', '\n', '    function getBytes(bytes32 _key) external view returns (bytes) {\n', '        return bytesStorage[_key];\n', '    }\n', '\n', '    function getBool(bytes32 _key) external view returns (bool) {\n', '        return boolStorage[_key];\n', '    }\n', '\n', '    function getInt(bytes32 _key) external view returns (int) {\n', '        return intStorage[_key];\n', '    }\n', '\n', '    // *** Setter Methods ***\n', '    function setUint(bytes32 _key, uint _value) onlyCaller external {\n', '        uIntStorage[_key] = _value;\n', '    }\n', '\n', '    function setString(bytes32 _key, string _value) onlyCaller external {\n', '        stringStorage[_key] = _value;\n', '    }\n', '\n', '    function setAddress(bytes32 _key, address _value) onlyCaller external {\n', '        addressStorage[_key] = _value;\n', '    }\n', '\n', '    function setBytes(bytes32 _key, bytes _value) onlyCaller external {\n', '        bytesStorage[_key] = _value;\n', '    }\n', '\n', '    function setBool(bytes32 _key, bool _value) onlyCaller external {\n', '        boolStorage[_key] = _value;\n', '    }\n', '\n', '    function setInt(bytes32 _key, int _value) onlyCaller external {\n', '        intStorage[_key] = _value;\n', '    }\n', '\n', '    // *** Delete Methods ***\n', '    function deleteUint(bytes32 _key) onlyCaller external {\n', '        delete uIntStorage[_key];\n', '    }\n', '\n', '    function deleteString(bytes32 _key) onlyCaller external {\n', '        delete stringStorage[_key];\n', '    }\n', '\n', '    function deleteAddress(bytes32 _key) onlyCaller external {\n', '        delete addressStorage[_key];\n', '    }\n', '\n', '    function deleteBytes(bytes32 _key) onlyCaller external {\n', '        delete bytesStorage[_key];\n', '    }\n', '\n', '    function deleteBool(bytes32 _key) onlyCaller external {\n', '        delete boolStorage[_key];\n', '    }\n', '\n', '    function deleteInt(bytes32 _key) onlyCaller external {\n', '        delete intStorage[_key];\n', '    }\n', '}\n', '\n', '/*\n', ' * Database Contract\n', ' * Davy Van Roy\n', ' * Quinten De Swaef\n', ' */\n', 'contract FundRepository is Callable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    EternalStorage public db;\n', '\n', '    //platform -> platformId => _funding\n', '    mapping(bytes32 => mapping(string => Funding)) funds;\n', '\n', '    struct Funding {\n', '        address[] funders; //funders that funded tokens\n', '        address[] tokens; //tokens that were funded\n', '        mapping(address => TokenFunding) tokenFunding;\n', '    }\n', '\n', '    struct TokenFunding {\n', '        mapping(address => uint256) balance;\n', '        uint256 totalTokenBalance;\n', '    }\n', '\n', '    constructor(address _eternalStorage) public {\n', '        db = EternalStorage(_eternalStorage);\n', '    }\n', '\n', '    function updateFunders(address _from, bytes32 _platform, string _platformId) public onlyCaller {\n', '        bool existing = db.getBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)));\n', '        if (!existing) {\n', '            uint funderCount = getFunderCount(_platform, _platformId);\n', '            db.setAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, funderCount)), _from);\n', '            db.setUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)), funderCount.add(1));\n', '        }\n', '    }\n', '\n', '    function updateBalances(address _from, bytes32 _platform, string _platformId, address _token, uint256 _value) public onlyCaller {\n', '        if (db.getBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token))) == false) {\n', '            db.setBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token)), true);\n', '            //add to the list of tokens for this platformId\n', '            uint tokenCount = getFundedTokenCount(_platform, _platformId);\n', '            db.setAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, tokenCount)), _token);\n', '            db.setUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)), tokenCount.add(1));\n', '        }\n', '\n', '        //add to the balance of this platformId for this token\n', '        db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), balance(_platform, _platformId, _token).add(_value));\n', '\n', '        //add to the balance the user has funded for the request\n', '        db.setUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _from, _token)), amountFunded(_platform, _platformId, _from, _token).add(_value));\n', '\n', '        //add the fact that the user has now funded this platformId\n', '        db.setBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)), true);\n', '    }\n', '\n', '    function claimToken(bytes32 platform, string platformId, address _token) public onlyCaller returns (uint256) {\n', '        require(!issueResolved(platform, platformId), "Can&#39;t claim token, issue is already resolved.");\n', '        uint256 totalTokenBalance = balance(platform, platformId, _token);\n', '        db.deleteUint(keccak256(abi.encodePacked("funds.tokenBalance", platform, platformId, _token)));\n', '        return totalTokenBalance;\n', '    }\n', '\n', '    function refundToken(bytes32 _platform, string _platformId, address _owner, address _token) public onlyCaller returns (uint256) {\n', '        require(!issueResolved(_platform, _platformId), "Can&#39;t refund token, issue is already resolved.");\n', '\n', '        //delete amount from user, so he can&#39;t refund again\n', '        uint256 userTokenBalance = amountFunded(_platform, _platformId, _owner, _token);\n', '        db.deleteUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _owner, _token)));\n', '\n', '\n', '        uint256 oldBalance = balance(_platform, _platformId, _token);\n', '        uint256 newBalance = oldBalance.sub(userTokenBalance);\n', '\n', '        require(newBalance <= oldBalance);\n', '\n', '        //subtract amount from tokenBalance\n', '        db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), newBalance);\n', '\n', '        return userTokenBalance;\n', '    }\n', '\n', '    function finishResolveFund(bytes32 platform, string platformId) public onlyCaller returns (bool) {\n', '        db.setBool(keccak256(abi.encodePacked("funds.issueResolved", platform, platformId)), true);\n', '        db.deleteUint(keccak256(abi.encodePacked("funds.funderCount", platform, platformId)));\n', '        return true;\n', '    }\n', '\n', '    //constants\n', '    function getFundInfo(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256, uint256, uint256) {\n', '        return (\n', '        getFunderCount(_platform, _platformId),\n', '        balance(_platform, _platformId, _token),\n', '        amountFunded(_platform, _platformId, _funder, _token)\n', '        );\n', '    }\n', '\n', '    function issueResolved(bytes32 _platform, string _platformId) public view returns (bool) {\n', '        return db.getBool(keccak256(abi.encodePacked("funds.issueResolved", _platform, _platformId)));\n', '    }\n', '\n', '    function getFundedTokenCount(bytes32 _platform, string _platformId) public view returns (uint256) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)));\n', '    }\n', '\n', '    function getFundedTokensByIndex(bytes32 _platform, string _platformId, uint _index) public view returns (address) {\n', '        return db.getAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _index)));\n', '    }\n', '\n', '    function getFunderCount(bytes32 _platform, string _platformId) public view returns (uint) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)));\n', '    }\n', '\n', '    function getFunderByIndex(bytes32 _platform, string _platformId, uint index) external view returns (address) {\n', '        return db.getAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, index)));\n', '    }\n', '\n', '    function amountFunded(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _funder, _token)));\n', '    }\n', '\n', '    function balance(bytes32 _platform, string _platformId, address _token) view public returns (uint256) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)));\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/// @dev `Owned` is a base level contract that assigns an `owner` that can be\n', '///  later changed\n', 'contract Owned {\n', '\n', '    /// @dev `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    /// @notice The Constructor assigns the message sender to be `owner`\n', '    function Owned() public {owner = msg.sender;}\n', '\n', '    /// @notice `owner` can step down and assign some other address to this role\n', '    /// @param _newOwner The address of the new owner. 0x0 can be used to create\n', '    ///  an unowned neutral vault, however that cannot be undone\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract Callable is Owned {\n', '\n', '    //sender => _allowed\n', '    mapping(address => bool) public callers;\n', '\n', '    //modifiers\n', '    modifier onlyCaller {\n', '        require(callers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    //management of the repositories\n', '    function updateCaller(address _caller, bool allowed) public onlyOwner {\n', '        callers[_caller] = allowed;\n', '    }\n', '}\n', '\n', 'contract EternalStorage is Callable {\n', '\n', '    mapping(bytes32 => uint) uIntStorage;\n', '    mapping(bytes32 => string) stringStorage;\n', '    mapping(bytes32 => address) addressStorage;\n', '    mapping(bytes32 => bytes) bytesStorage;\n', '    mapping(bytes32 => bool) boolStorage;\n', '    mapping(bytes32 => int) intStorage;\n', '\n', '    // *** Getter Methods ***\n', '    function getUint(bytes32 _key) external view returns (uint) {\n', '        return uIntStorage[_key];\n', '    }\n', '\n', '    function getString(bytes32 _key) external view returns (string) {\n', '        return stringStorage[_key];\n', '    }\n', '\n', '    function getAddress(bytes32 _key) external view returns (address) {\n', '        return addressStorage[_key];\n', '    }\n', '\n', '    function getBytes(bytes32 _key) external view returns (bytes) {\n', '        return bytesStorage[_key];\n', '    }\n', '\n', '    function getBool(bytes32 _key) external view returns (bool) {\n', '        return boolStorage[_key];\n', '    }\n', '\n', '    function getInt(bytes32 _key) external view returns (int) {\n', '        return intStorage[_key];\n', '    }\n', '\n', '    // *** Setter Methods ***\n', '    function setUint(bytes32 _key, uint _value) onlyCaller external {\n', '        uIntStorage[_key] = _value;\n', '    }\n', '\n', '    function setString(bytes32 _key, string _value) onlyCaller external {\n', '        stringStorage[_key] = _value;\n', '    }\n', '\n', '    function setAddress(bytes32 _key, address _value) onlyCaller external {\n', '        addressStorage[_key] = _value;\n', '    }\n', '\n', '    function setBytes(bytes32 _key, bytes _value) onlyCaller external {\n', '        bytesStorage[_key] = _value;\n', '    }\n', '\n', '    function setBool(bytes32 _key, bool _value) onlyCaller external {\n', '        boolStorage[_key] = _value;\n', '    }\n', '\n', '    function setInt(bytes32 _key, int _value) onlyCaller external {\n', '        intStorage[_key] = _value;\n', '    }\n', '\n', '    // *** Delete Methods ***\n', '    function deleteUint(bytes32 _key) onlyCaller external {\n', '        delete uIntStorage[_key];\n', '    }\n', '\n', '    function deleteString(bytes32 _key) onlyCaller external {\n', '        delete stringStorage[_key];\n', '    }\n', '\n', '    function deleteAddress(bytes32 _key) onlyCaller external {\n', '        delete addressStorage[_key];\n', '    }\n', '\n', '    function deleteBytes(bytes32 _key) onlyCaller external {\n', '        delete bytesStorage[_key];\n', '    }\n', '\n', '    function deleteBool(bytes32 _key) onlyCaller external {\n', '        delete boolStorage[_key];\n', '    }\n', '\n', '    function deleteInt(bytes32 _key) onlyCaller external {\n', '        delete intStorage[_key];\n', '    }\n', '}\n', '\n', '/*\n', ' * Database Contract\n', ' * Davy Van Roy\n', ' * Quinten De Swaef\n', ' */\n', 'contract FundRepository is Callable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    EternalStorage public db;\n', '\n', '    //platform -> platformId => _funding\n', '    mapping(bytes32 => mapping(string => Funding)) funds;\n', '\n', '    struct Funding {\n', '        address[] funders; //funders that funded tokens\n', '        address[] tokens; //tokens that were funded\n', '        mapping(address => TokenFunding) tokenFunding;\n', '    }\n', '\n', '    struct TokenFunding {\n', '        mapping(address => uint256) balance;\n', '        uint256 totalTokenBalance;\n', '    }\n', '\n', '    constructor(address _eternalStorage) public {\n', '        db = EternalStorage(_eternalStorage);\n', '    }\n', '\n', '    function updateFunders(address _from, bytes32 _platform, string _platformId) public onlyCaller {\n', '        bool existing = db.getBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)));\n', '        if (!existing) {\n', '            uint funderCount = getFunderCount(_platform, _platformId);\n', '            db.setAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, funderCount)), _from);\n', '            db.setUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)), funderCount.add(1));\n', '        }\n', '    }\n', '\n', '    function updateBalances(address _from, bytes32 _platform, string _platformId, address _token, uint256 _value) public onlyCaller {\n', '        if (db.getBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token))) == false) {\n', '            db.setBool(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _token)), true);\n', '            //add to the list of tokens for this platformId\n', '            uint tokenCount = getFundedTokenCount(_platform, _platformId);\n', '            db.setAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, tokenCount)), _token);\n', '            db.setUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)), tokenCount.add(1));\n', '        }\n', '\n', '        //add to the balance of this platformId for this token\n', '        db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), balance(_platform, _platformId, _token).add(_value));\n', '\n', '        //add to the balance the user has funded for the request\n', '        db.setUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _from, _token)), amountFunded(_platform, _platformId, _from, _token).add(_value));\n', '\n', '        //add the fact that the user has now funded this platformId\n', '        db.setBool(keccak256(abi.encodePacked("funds.userHasFunded", _platform, _platformId, _from)), true);\n', '    }\n', '\n', '    function claimToken(bytes32 platform, string platformId, address _token) public onlyCaller returns (uint256) {\n', '        require(!issueResolved(platform, platformId), "Can\'t claim token, issue is already resolved.");\n', '        uint256 totalTokenBalance = balance(platform, platformId, _token);\n', '        db.deleteUint(keccak256(abi.encodePacked("funds.tokenBalance", platform, platformId, _token)));\n', '        return totalTokenBalance;\n', '    }\n', '\n', '    function refundToken(bytes32 _platform, string _platformId, address _owner, address _token) public onlyCaller returns (uint256) {\n', '        require(!issueResolved(_platform, _platformId), "Can\'t refund token, issue is already resolved.");\n', '\n', "        //delete amount from user, so he can't refund again\n", '        uint256 userTokenBalance = amountFunded(_platform, _platformId, _owner, _token);\n', '        db.deleteUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _owner, _token)));\n', '\n', '\n', '        uint256 oldBalance = balance(_platform, _platformId, _token);\n', '        uint256 newBalance = oldBalance.sub(userTokenBalance);\n', '\n', '        require(newBalance <= oldBalance);\n', '\n', '        //subtract amount from tokenBalance\n', '        db.setUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)), newBalance);\n', '\n', '        return userTokenBalance;\n', '    }\n', '\n', '    function finishResolveFund(bytes32 platform, string platformId) public onlyCaller returns (bool) {\n', '        db.setBool(keccak256(abi.encodePacked("funds.issueResolved", platform, platformId)), true);\n', '        db.deleteUint(keccak256(abi.encodePacked("funds.funderCount", platform, platformId)));\n', '        return true;\n', '    }\n', '\n', '    //constants\n', '    function getFundInfo(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256, uint256, uint256) {\n', '        return (\n', '        getFunderCount(_platform, _platformId),\n', '        balance(_platform, _platformId, _token),\n', '        amountFunded(_platform, _platformId, _funder, _token)\n', '        );\n', '    }\n', '\n', '    function issueResolved(bytes32 _platform, string _platformId) public view returns (bool) {\n', '        return db.getBool(keccak256(abi.encodePacked("funds.issueResolved", _platform, _platformId)));\n', '    }\n', '\n', '    function getFundedTokenCount(bytes32 _platform, string _platformId) public view returns (uint256) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.tokenCount", _platform, _platformId)));\n', '    }\n', '\n', '    function getFundedTokensByIndex(bytes32 _platform, string _platformId, uint _index) public view returns (address) {\n', '        return db.getAddress(keccak256(abi.encodePacked("funds.token.address", _platform, _platformId, _index)));\n', '    }\n', '\n', '    function getFunderCount(bytes32 _platform, string _platformId) public view returns (uint) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.funderCount", _platform, _platformId)));\n', '    }\n', '\n', '    function getFunderByIndex(bytes32 _platform, string _platformId, uint index) external view returns (address) {\n', '        return db.getAddress(keccak256(abi.encodePacked("funds.funders.address", _platform, _platformId, index)));\n', '    }\n', '\n', '    function amountFunded(bytes32 _platform, string _platformId, address _funder, address _token) public view returns (uint256) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.amountFundedByUser", _platform, _platformId, _funder, _token)));\n', '    }\n', '\n', '    function balance(bytes32 _platform, string _platformId, address _token) view public returns (uint256) {\n', '        return db.getUint(keccak256(abi.encodePacked("funds.tokenBalance", _platform, _platformId, _token)));\n', '    }\n', '}']
