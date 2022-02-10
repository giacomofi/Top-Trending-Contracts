['pragma solidity 0.4.24;\n', '\n', '/// @dev `Owned` is a base level contract that assigns an `owner` that can be\n', '///  later changed\n', 'contract Owned {\n', '\n', '    /// @dev `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    /// @notice The Constructor assigns the message sender to be `owner`\n', '    function Owned() public {owner = msg.sender;}\n', '\n', '    /// @notice `owner` can step down and assign some other address to this role\n', '    /// @param _newOwner The address of the new owner. 0x0 can be used to create\n', '    ///  an unowned neutral vault, however that cannot be undone\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Callable is Owned {\n', '\n', '    //sender => _allowed\n', '    mapping(address => bool) public callers;\n', '\n', '    //modifiers\n', '    modifier onlyCaller {\n', '        require(callers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    //management of the repositories\n', '    function updateCaller(address _caller, bool allowed) public onlyOwner {\n', '        callers[_caller] = allowed;\n', '    }\n', '}\n', '\n', 'contract EternalStorage is Callable {\n', '\n', '    mapping(bytes32 => uint) uIntStorage;\n', '    mapping(bytes32 => string) stringStorage;\n', '    mapping(bytes32 => address) addressStorage;\n', '    mapping(bytes32 => bytes) bytesStorage;\n', '    mapping(bytes32 => bool) boolStorage;\n', '    mapping(bytes32 => int) intStorage;\n', '\n', '    // *** Getter Methods ***\n', '    function getUint(bytes32 _key) external view returns (uint) {\n', '        return uIntStorage[_key];\n', '    }\n', '\n', '    function getString(bytes32 _key) external view returns (string) {\n', '        return stringStorage[_key];\n', '    }\n', '\n', '    function getAddress(bytes32 _key) external view returns (address) {\n', '        return addressStorage[_key];\n', '    }\n', '\n', '    function getBytes(bytes32 _key) external view returns (bytes) {\n', '        return bytesStorage[_key];\n', '    }\n', '\n', '    function getBool(bytes32 _key) external view returns (bool) {\n', '        return boolStorage[_key];\n', '    }\n', '\n', '    function getInt(bytes32 _key) external view returns (int) {\n', '        return intStorage[_key];\n', '    }\n', '\n', '    // *** Setter Methods ***\n', '    function setUint(bytes32 _key, uint _value) onlyCaller external {\n', '        uIntStorage[_key] = _value;\n', '    }\n', '\n', '    function setString(bytes32 _key, string _value) onlyCaller external {\n', '        stringStorage[_key] = _value;\n', '    }\n', '\n', '    function setAddress(bytes32 _key, address _value) onlyCaller external {\n', '        addressStorage[_key] = _value;\n', '    }\n', '\n', '    function setBytes(bytes32 _key, bytes _value) onlyCaller external {\n', '        bytesStorage[_key] = _value;\n', '    }\n', '\n', '    function setBool(bytes32 _key, bool _value) onlyCaller external {\n', '        boolStorage[_key] = _value;\n', '    }\n', '\n', '    function setInt(bytes32 _key, int _value) onlyCaller external {\n', '        intStorage[_key] = _value;\n', '    }\n', '\n', '    // *** Delete Methods ***\n', '    function deleteUint(bytes32 _key) onlyCaller external {\n', '        delete uIntStorage[_key];\n', '    }\n', '\n', '    function deleteString(bytes32 _key) onlyCaller external {\n', '        delete stringStorage[_key];\n', '    }\n', '\n', '    function deleteAddress(bytes32 _key) onlyCaller external {\n', '        delete addressStorage[_key];\n', '    }\n', '\n', '    function deleteBytes(bytes32 _key) onlyCaller external {\n', '        delete bytesStorage[_key];\n', '    }\n', '\n', '    function deleteBool(bytes32 _key) onlyCaller external {\n', '        delete boolStorage[_key];\n', '    }\n', '\n', '    function deleteInt(bytes32 _key) onlyCaller external {\n', '        delete intStorage[_key];\n', '    }\n', '}\n', '\n', 'contract ClaimRepository is Callable {\n', '    using SafeMath for uint256;\n', '\n', '    EternalStorage public db;\n', '\n', '    constructor(address _eternalStorage) public {\n', '        //constructor\n', '        require(_eternalStorage != address(0), "Eternal storage cannot be 0x0");\n', '        db = EternalStorage(_eternalStorage);\n', '    }\n', '\n', '    function addClaim(address _solverAddress, bytes32 _platform, string _platformId, string _solver, address _token, uint256 _requestBalance) public onlyCaller returns (bool) {\n', '        if (db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0)) {\n', '            require(db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) == _solverAddress, "Adding a claim needs to happen with the same claimer as before");\n', '        } else {\n', '            db.setString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)), _solver);\n', '            db.setAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)), _solverAddress);\n', '        }\n', '\n', '        uint tokenCount = db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));\n', '        db.setUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)), tokenCount.add(1));\n', '        db.setUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)), _requestBalance);\n', '        db.setAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, tokenCount)), _token);\n', '        return true;\n', '    }\n', '\n', '    function isClaimed(bytes32 _platform, string _platformId) view external returns (bool claimed) {\n', '        return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId))) != address(0);\n', '    }\n', '\n', '    function getSolverAddress(bytes32 _platform, string _platformId) view external returns (address solverAddress) {\n', '        return db.getAddress(keccak256(abi.encodePacked("claims.solver_address", _platform, _platformId)));\n', '    }\n', '\n', '    function getSolver(bytes32 _platform, string _platformId) view external returns (string){\n', '        return db.getString(keccak256(abi.encodePacked("claims.solver", _platform, _platformId)));\n', '    }\n', '\n', '    function getTokenCount(bytes32 _platform, string _platformId) view external returns (uint count) {\n', '        return db.getUint(keccak256(abi.encodePacked("claims.tokenCount", _platform, _platformId)));\n', '    }\n', '\n', '    function getTokenByIndex(bytes32 _platform, string _platformId, uint _index) view external returns (address token) {\n', '        return db.getAddress(keccak256(abi.encodePacked("claims.token.address", _platform, _platformId, _index)));\n', '    }\n', '\n', '    function getAmountByToken(bytes32 _platform, string _platformId, address _token) view external returns (uint token) {\n', '        return db.getUint(keccak256(abi.encodePacked("claims.token.amount", _platform, _platformId, _token)));\n', '    }\n', '}']