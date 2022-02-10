['pragma solidity 0.4.15;\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function Owned() { owner = msg.sender; }\n', '\n', '    function isOwner(address addr) public returns(bool) { return addr == owner; }\n', '\n', '    function transfer(address newOwner) public onlyOwner {\n', '        if (newOwner != address(this)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract Proxy is Owned {\n', '    event Forwarded (address indexed destination, uint value, bytes data);\n', '    event Received (address indexed sender, uint value);\n', '\n', '    function () payable { Received(msg.sender, msg.value); }\n', '\n', '    function forward(address destination, uint value, bytes data) public onlyOwner {\n', '        require(destination.call.value(value)(data));\n', '        Forwarded(destination, value, data);\n', '    }\n', '}\n', '\n', '\n', 'contract MetaIdentityManager {\n', '    uint adminTimeLock;\n', '    uint userTimeLock;\n', '    uint adminRate;\n', '    address relay;\n', '\n', '    event LogIdentityCreated(\n', '        address indexed identity,\n', '        address indexed creator,\n', '        address owner,\n', '        address indexed recoveryKey);\n', '\n', '    event LogOwnerAdded(\n', '        address indexed identity,\n', '        address indexed owner,\n', '        address instigator);\n', '\n', '    event LogOwnerRemoved(\n', '        address indexed identity,\n', '        address indexed owner,\n', '        address instigator);\n', '\n', '    event LogRecoveryChanged(\n', '        address indexed identity,\n', '        address indexed recoveryKey,\n', '        address instigator);\n', '\n', '    event LogMigrationInitiated(\n', '        address indexed identity,\n', '        address indexed newIdManager,\n', '        address instigator);\n', '\n', '    event LogMigrationCanceled(\n', '        address indexed identity,\n', '        address indexed newIdManager,\n', '        address instigator);\n', '\n', '    event LogMigrationFinalized(\n', '        address indexed identity,\n', '        address indexed newIdManager,\n', '        address instigator);\n', '\n', '    mapping(address => mapping(address => uint)) owners;\n', '    mapping(address => address) recoveryKeys;\n', '    mapping(address => mapping(address => uint)) limiter;\n', '    mapping(address => uint) public migrationInitiated;\n', '    mapping(address => address) public migrationNewAddress;\n', '\n', '    modifier onlyAuthorized() {\n', '        require(msg.sender == relay || checkMessageData(msg.sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner(address identity, address sender) {\n', '        require(isOwner(identity, sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyOlderOwner(address identity, address sender) {\n', '        require(isOlderOwner(identity, sender));\n', '        _;\n', '    }\n', '\n', '    modifier onlyRecovery(address identity, address sender) {\n', '        require(recoveryKeys[identity] == sender);\n', '        _;\n', '    }\n', '\n', '    modifier rateLimited(Proxy identity, address sender) {\n', '        require(limiter[identity][sender] < (now - adminRate));\n', '        limiter[identity][sender] = now;\n', '        _;\n', '    }\n', '\n', '    modifier validAddress(address addr) { //protects against some weird attacks\n', '        require(addr != address(0));\n', '        _;\n', '    }\n', '\n', '    /// @dev Contract constructor sets initial timelocks and meta-tx relay address\n', '    /// @param _userTimeLock Time before new owner added by recovery can control proxy\n', '    /// @param _adminTimeLock Time before new owner can add/remove owners\n', '    /// @param _adminRate Time period used for rate limiting a given key for admin functionality\n', '    /// @param _relayAddress Address of meta transaction relay contract\n', '    function MetaIdentityManager(uint _userTimeLock, uint _adminTimeLock, uint _adminRate, address _relayAddress) {\n', '        require(_adminTimeLock >= _userTimeLock);\n', '        adminTimeLock = _adminTimeLock;\n', '        userTimeLock = _userTimeLock;\n', '        adminRate = _adminRate;\n', '        relay = _relayAddress;\n', '    }\n', '\n', '    /// @dev Creates a new proxy contract for an owner and recovery\n', '    /// @param owner Key who can use this contract to control proxy. Given full power\n', '    /// @param recoveryKey Key of recovery network or address from seed to recovery proxy\n', '    /// Gas cost of ~300,000\n', '    function createIdentity(address owner, address recoveryKey) public validAddress(recoveryKey) {\n', '        Proxy identity = new Proxy();\n', '        owners[identity][owner] = now - adminTimeLock; // This is to ensure original owner has full power from day one\n', '        recoveryKeys[identity] = recoveryKey;\n', '        LogIdentityCreated(identity, msg.sender, owner,  recoveryKey);\n', '    }\n', '\n', '    /// @dev Creates a new proxy contract for an owner and recovery and allows an initial forward call which would be to set the registry in our case\n', '    /// @param owner Key who can use this contract to control proxy. Given full power\n', '    /// @param recoveryKey Key of recovery network or address from seed to recovery proxy\n', '    /// @param destination Address of contract to be called after proxy is created\n', '    /// @param data of function to be called at the destination contract\n', '    function createIdentityWithCall(address owner, address recoveryKey, address destination, bytes data) public validAddress(recoveryKey) {\n', '        Proxy identity = new Proxy();\n', '        owners[identity][owner] = now - adminTimeLock; // This is to ensure original owner has full power from day one\n', '        recoveryKeys[identity] = recoveryKey;\n', '        LogIdentityCreated(identity, msg.sender, owner,  recoveryKey);\n', '        identity.forward(destination, 0, data);\n', '    }\n', '\n', '    /// @dev Allows a user to transfer control of existing proxy to this contract. Must come through proxy\n', '    /// @param owner Key who can use this contract to control proxy. Given full power\n', '    /// @param recoveryKey Key of recovery network or address from seed to recovery proxy\n', '    /// Note: User must change owner of proxy to this contract after calling this\n', '    function registerIdentity(address owner, address recoveryKey) public validAddress(recoveryKey) {\n', '        require(recoveryKeys[msg.sender] == 0); // Deny any funny business\n', '        owners[msg.sender][owner] = now - adminTimeLock; // Owner has full power from day one\n', '        recoveryKeys[msg.sender] = recoveryKey;\n', '        LogIdentityCreated(msg.sender, msg.sender, owner, recoveryKey);\n', '    }\n', '\n', '    /// @dev Allows a user to forward a call through their proxy.\n', '    function forwardTo(address sender, Proxy identity, address destination, uint value, bytes data) public\n', '        onlyAuthorized\n', '        onlyOwner(identity, sender)\n', '    {\n', '        identity.forward(destination, value, data);\n', '    }\n', '\n', '    /// @dev Allows an olderOwner to add a new owner instantly\n', '    function addOwner(address sender, Proxy identity, address newOwner) public\n', '        onlyAuthorized\n', '        onlyOlderOwner(identity, sender)\n', '        rateLimited(identity, sender)\n', '    {\n', '        require(!isOwner(identity, newOwner));\n', '        owners[identity][newOwner] = now - userTimeLock;\n', '        LogOwnerAdded(identity, newOwner, sender);\n', '    }\n', '\n', '    /// @dev Allows a recoveryKey to add a new owner with userTimeLock waiting time\n', '    function addOwnerFromRecovery(address sender, Proxy identity, address newOwner) public\n', '        onlyAuthorized\n', '        onlyRecovery(identity, sender)\n', '        rateLimited(identity, sender)\n', '    {\n', '        require(!isOwner(identity, newOwner));\n', '        owners[identity][newOwner] = now;\n', '        LogOwnerAdded(identity, newOwner, sender);\n', '    }\n', '\n', '    /// @dev Allows an owner to remove another owner instantly\n', '    function removeOwner(address sender, Proxy identity, address owner) public\n', '        onlyAuthorized\n', '        onlyOlderOwner(identity, sender)\n', '        rateLimited(identity, sender)\n', '    {\n', '        // an owner should not be allowed to remove itself\n', '        require(sender != owner);\n', '        delete owners[identity][owner];\n', '        LogOwnerRemoved(identity, owner, sender);\n', '    }\n', '\n', '    /// @dev Allows an owner to change the recoveryKey instantly\n', '    function changeRecovery(address sender, Proxy identity, address recoveryKey) public\n', '        onlyAuthorized\n', '        onlyOlderOwner(identity, sender)\n', '        rateLimited(identity, sender)\n', '        validAddress(recoveryKey)\n', '    {\n', '        recoveryKeys[identity] = recoveryKey;\n', '        LogRecoveryChanged(identity, recoveryKey, sender);\n', '    }\n', '\n', '    /// @dev Allows an owner to begin process of transfering proxy to new IdentityManager\n', '    function initiateMigration(address sender, Proxy identity, address newIdManager) public\n', '        onlyAuthorized\n', '        onlyOlderOwner(identity, sender)\n', '    {\n', '        migrationInitiated[identity] = now;\n', '        migrationNewAddress[identity] = newIdManager;\n', '        LogMigrationInitiated(identity, newIdManager, sender);\n', '    }\n', '\n', '    /// @dev Allows an owner to cancel the process of transfering proxy to new IdentityManager\n', '    function cancelMigration(address sender, Proxy identity) public\n', '        onlyAuthorized\n', '        onlyOwner(identity, sender)\n', '    {\n', '        address canceledManager = migrationNewAddress[identity];\n', '        delete migrationInitiated[identity];\n', '        delete migrationNewAddress[identity];\n', '        LogMigrationCanceled(identity, canceledManager, sender);\n', '    }\n', '\n', '    /// @dev Allows an owner to finalize and completly transfer proxy to new IdentityManager\n', '    /// Note: before transfering to a new address, make sure this address is "ready to recieve" the proxy.\n', '    /// Not doing so risks the proxy becoming stuck.\n', '    function finalizeMigration(address sender, Proxy identity) onlyAuthorized onlyOlderOwner(identity, sender) {\n', '        require(migrationInitiated[identity] != 0 && migrationInitiated[identity] + adminTimeLock < now);\n', '        address newIdManager = migrationNewAddress[identity];\n', '        delete migrationInitiated[identity];\n', '        delete migrationNewAddress[identity];\n', '        identity.transfer(newIdManager);\n', '        delete recoveryKeys[identity];\n', '        // We can only delete the owner that we know of. All other owners\n', '        // needs to be removed before a call to this method.\n', '        delete owners[identity][sender];\n', '        LogMigrationFinalized(identity, newIdManager, sender);\n', '    }\n', '\n', '    //Checks that address a is the first input in msg.data.\n', '    //Has very minimal gas overhead.\n', '    function checkMessageData(address a) internal constant returns (bool t) {\n', '        if (msg.data.length < 36) return false;\n', '        assembly {\n', '            let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF\n', '            t := eq(a, and(mask, calldataload(4)))\n', '        }\n', '    }\n', '\n', '    function isOwner(address identity, address owner) public constant returns (bool) {\n', '        return (owners[identity][owner] > 0 && (owners[identity][owner] + userTimeLock) <= now);\n', '    }\n', '\n', '    function isOlderOwner(address identity, address owner) public constant returns (bool) {\n', '        return (owners[identity][owner] > 0 && (owners[identity][owner] + adminTimeLock) <= now);\n', '    }\n', '\n', '    function isRecovery(address identity, address recoveryKey) public constant returns (bool) {\n', '        return recoveryKeys[identity] == recoveryKey;\n', '    }\n', '}']