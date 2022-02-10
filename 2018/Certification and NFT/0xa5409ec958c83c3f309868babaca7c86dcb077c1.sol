['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract TokenRecipient {\n', '    event ReceivedEther(address indexed sender, uint amount);\n', '    event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);\n', '\n', '    /**\n', '     * @dev Receive tokens and generate a log event\n', '     * @param from Address from which to transfer tokens\n', '     * @param value Amount of tokens to transfer\n', '     * @param token Address of token\n', '     * @param extraData Additional data to log\n', '     */\n', '    function receiveApproval(address from, uint256 value, address token, bytes extraData) public {\n', '        ERC20 t = ERC20(token);\n', '        require(t.transferFrom(from, this, value));\n', '        emit ReceivedTokens(from, value, token, extraData);\n', '    }\n', '\n', '    /**\n', '     * @dev Receive Ether and generate a log event\n', '     */\n', '    function () payable public {\n', '        emit ReceivedEther(msg.sender, msg.value);\n', '    }\n', '}\n', '\n', 'contract ProxyRegistry is Ownable {\n', '\n', '    /* DelegateProxy implementation contract. Must be initialized. */\n', '    address public delegateProxyImplementation;\n', '\n', '    /* Authenticated proxies by user. */\n', '    mapping(address => OwnableDelegateProxy) public proxies;\n', '\n', '    /* Contracts pending access. */\n', '    mapping(address => uint) public pending;\n', '\n', '    /* Contracts allowed to call those proxies. */\n', '    mapping(address => bool) public contracts;\n', '\n', '    /* Delay period for adding an authenticated contract.\n', '       This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),\n', '       a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have\n', '       plenty of time to notice and transfer their assets.\n', '    */\n', '    uint public DELAY_PERIOD = 2 weeks;\n', '\n', '    /**\n', '     * Start the process to enable access for specified contract. Subject to delay period.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address to which to grant permissions\n', '     */\n', '    function startGrantAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(!contracts[addr] && pending[addr] == 0);\n', '        pending[addr] = now;\n', '    }\n', '\n', '    /**\n', '     * End the process to nable access for specified contract after delay period has passed.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address to which to grant permissions\n', '     */\n', '    function endGrantAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));\n', '        pending[addr] = 0;\n', '        contracts[addr] = true;\n', '    }\n', '\n', '    /**\n', '     * Revoke access for specified contract. Can be done instantly.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address of which to revoke permissions\n', '     */    \n', '    function revokeAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        contracts[addr] = false;\n', '    }\n', '\n', '    /**\n', '     * Register a proxy contract with this registry\n', '     *\n', '     * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy\n', '     * @return New AuthenticatedProxy contract\n', '     */\n', '    function registerProxy()\n', '        public\n', '        returns (OwnableDelegateProxy proxy)\n', '    {\n', '        require(proxies[msg.sender] == address(0));\n', '        proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));\n', '        proxies[msg.sender] = proxy;\n', '        return proxy;\n', '    }\n', '\n', '}\n', '\n', 'contract WyvernProxyRegistry is ProxyRegistry {\n', '\n', '    string public constant name = "Project Wyvern Proxy Registry";\n', '\n', '    /* Whether the initial auth address has been set. */\n', '    bool public initialAddressSet = false;\n', '\n', '    constructor ()\n', '        public\n', '    {\n', '        delegateProxyImplementation = new AuthenticatedProxy();\n', '    }\n', '\n', '    /** \n', '     * Grant authentication to the initial Exchange protocol contract\n', '     *\n', '     * @dev No delay, can only be called once - after that the standard registry process with a delay must be used\n', '     * @param authAddress Address of the contract to grant authentication\n', '     */\n', '    function grantInitialAuthentication (address authAddress)\n', '        onlyOwner\n', '        public\n', '    {\n', '        require(!initialAddressSet);\n', '        initialAddressSet = true;\n', '        contracts[authAddress] = true;\n', '    }\n', '\n', '}\n', '\n', 'contract OwnedUpgradeabilityStorage {\n', '\n', '  // Current implementation\n', '  address internal _implementation;\n', '\n', '  // Owner of the contract\n', '  address private _upgradeabilityOwner;\n', '\n', '  /**\n', '   * @dev Tells the address of the owner\n', '   * @return the address of the owner\n', '   */\n', '  function upgradeabilityOwner() public view returns (address) {\n', '    return _upgradeabilityOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the owner\n', '   */\n', '  function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {\n', '    _upgradeabilityOwner = newUpgradeabilityOwner;\n', '  }\n', '\n', '  /**\n', '  * @dev Tells the address of the current implementation\n', '  * @return address of the current implementation\n', '  */\n', '  function implementation() public view returns (address) {\n', '    return _implementation;\n', '  }\n', '\n', '  /**\n', '  * @dev Tells the proxy type (EIP 897)\n', '  * @return Proxy type, 2 for forwarding proxy\n', '  */\n', '  function proxyType() public pure returns (uint256 proxyTypeId) {\n', '    return 2;\n', '  }\n', '}\n', '\n', 'contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {\n', '\n', '    /* Whether initialized. */\n', '    bool initialized = false;\n', '\n', '    /* Address which owns this proxy. */\n', '    address public user;\n', '\n', '    /* Associated registry with contract authentication information. */\n', '    ProxyRegistry public registry;\n', '\n', '    /* Whether access has been revoked. */\n', '    bool public revoked;\n', '\n', '    /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */\n', '    enum HowToCall { Call, DelegateCall }\n', '\n', '    /* Event fired when the proxy access is revoked or unrevoked. */\n', '    event Revoked(bool revoked);\n', '\n', '    /**\n', '     * Initialize an AuthenticatedProxy\n', '     *\n', '     * @param addrUser Address of user on whose behalf this proxy will act\n', '     * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy\n', '     */\n', '    function initialize (address addrUser, ProxyRegistry addrRegistry)\n', '        public\n', '    {\n', '        require(!initialized);\n', '        initialized = true;\n', '        user = addrUser;\n', '        registry = addrRegistry;\n', '    }\n', '\n', '    /**\n', '     * Set the revoked flag (allows a user to revoke ProxyRegistry access)\n', '     *\n', '     * @dev Can be called by the user only\n', '     * @param revoke Whether or not to revoke access\n', '     */\n', '    function setRevoke(bool revoke)\n', '        public\n', '    {\n', '        require(msg.sender == user);\n', '        revoked = revoke;\n', '        emit Revoked(revoke);\n', '    }\n', '\n', '    /**\n', '     * Execute a message call from the proxy contract\n', '     *\n', '     * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access\n', '     * @param dest Address to which the call will be sent\n', '     * @param howToCall Which kind of call to make\n', '     * @param calldata Calldata to send\n', '     * @return Result of the call (success or failure)\n', '     */\n', '    function proxy(address dest, HowToCall howToCall, bytes calldata)\n', '        public\n', '        returns (bool result)\n', '    {\n', '        require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));\n', '        if (howToCall == HowToCall.Call) {\n', '            result = dest.call(calldata);\n', '        } else if (howToCall == HowToCall.DelegateCall) {\n', '            result = dest.delegatecall(calldata);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    /**\n', '     * Execute a message call and assert success\n', '     * \n', '     * @dev Same functionality as `proxy`, just asserts the return value\n', '     * @param dest Address to which the call will be sent\n', '     * @param howToCall What kind of call to make\n', '     * @param calldata Calldata to send\n', '     */\n', '    function proxyAssert(address dest, HowToCall howToCall, bytes calldata)\n', '        public\n', '    {\n', '        require(proxy(dest, howToCall, calldata));\n', '    }\n', '\n', '}\n', '\n', 'contract Proxy {\n', '\n', '  /**\n', '  * @dev Tells the address of the implementation where every call will be delegated.\n', '  * @return address of the implementation to which it will be delegated\n', '  */\n', '  function implementation() public view returns (address);\n', '\n', '  /**\n', '  * @dev Tells the type of proxy (EIP 897)\n', '  * @return Type of proxy, 2 for upgradeable proxy\n', '  */\n', '  function proxyType() public pure returns (uint256 proxyTypeId);\n', '\n', '  /**\n', '  * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '  * This function will return whatever the implementation call returns\n', '  */\n', '  function () payable public {\n', '    address _impl = implementation();\n', '    require(_impl != address(0));\n', '\n', '    assembly {\n', '      let ptr := mload(0x40)\n', '      calldatacopy(ptr, 0, calldatasize)\n', '      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)\n', '      let size := returndatasize\n', '      returndatacopy(ptr, 0, size)\n', '\n', '      switch result\n', '      case 0 { revert(ptr, size) }\n', '      default { return(ptr, size) }\n', '    }\n', '  }\n', '}\n', '\n', 'contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {\n', '  /**\n', '  * @dev Event to show ownership has been transferred\n', '  * @param previousOwner representing the address of the previous owner\n', '  * @param newOwner representing the address of the new owner\n', '  */\n', '  event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '  /**\n', '  * @dev This event will be emitted every time the implementation gets upgraded\n', '  * @param implementation representing the address of the upgraded implementation\n', '  */\n', '  event Upgraded(address indexed implementation);\n', '\n', '  /**\n', '  * @dev Upgrades the implementation address\n', '  * @param implementation representing the address of the new implementation to be set\n', '  */\n', '  function _upgradeTo(address implementation) internal {\n', '    require(_implementation != implementation);\n', '    _implementation = implementation;\n', '    emit Upgraded(implementation);\n', '  }\n', '\n', '  /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '  modifier onlyProxyOwner() {\n', '    require(msg.sender == proxyOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Tells the address of the proxy owner\n', '   * @return the address of the proxy owner\n', '   */\n', '  function proxyOwner() public view returns (address) {\n', '    return upgradeabilityOwner();\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '    require(newOwner != address(0));\n', '    emit ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '    setUpgradeabilityOwner(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   */\n', '  function upgradeTo(address implementation) public onlyProxyOwner {\n', '    _upgradeTo(implementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy\n', '   * and delegatecall the new implementation for initialization.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function\n', '   * signature of the implementation to be called with the needed payload\n', '   */\n', '  function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {\n', '    upgradeTo(implementation);\n', '    require(address(this).delegatecall(data));\n', '  }\n', '}\n', '\n', 'contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {\n', '\n', '    constructor(address owner, address initialImplementation, bytes calldata)\n', '        public\n', '    {\n', '        setUpgradeabilityOwner(owner);\n', '        _upgradeTo(initialImplementation);\n', '        require(initialImplementation.delegatecall(calldata));\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract TokenRecipient {\n', '    event ReceivedEther(address indexed sender, uint amount);\n', '    event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);\n', '\n', '    /**\n', '     * @dev Receive tokens and generate a log event\n', '     * @param from Address from which to transfer tokens\n', '     * @param value Amount of tokens to transfer\n', '     * @param token Address of token\n', '     * @param extraData Additional data to log\n', '     */\n', '    function receiveApproval(address from, uint256 value, address token, bytes extraData) public {\n', '        ERC20 t = ERC20(token);\n', '        require(t.transferFrom(from, this, value));\n', '        emit ReceivedTokens(from, value, token, extraData);\n', '    }\n', '\n', '    /**\n', '     * @dev Receive Ether and generate a log event\n', '     */\n', '    function () payable public {\n', '        emit ReceivedEther(msg.sender, msg.value);\n', '    }\n', '}\n', '\n', 'contract ProxyRegistry is Ownable {\n', '\n', '    /* DelegateProxy implementation contract. Must be initialized. */\n', '    address public delegateProxyImplementation;\n', '\n', '    /* Authenticated proxies by user. */\n', '    mapping(address => OwnableDelegateProxy) public proxies;\n', '\n', '    /* Contracts pending access. */\n', '    mapping(address => uint) public pending;\n', '\n', '    /* Contracts allowed to call those proxies. */\n', '    mapping(address => bool) public contracts;\n', '\n', '    /* Delay period for adding an authenticated contract.\n', '       This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),\n', '       a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have\n', '       plenty of time to notice and transfer their assets.\n', '    */\n', '    uint public DELAY_PERIOD = 2 weeks;\n', '\n', '    /**\n', '     * Start the process to enable access for specified contract. Subject to delay period.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address to which to grant permissions\n', '     */\n', '    function startGrantAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(!contracts[addr] && pending[addr] == 0);\n', '        pending[addr] = now;\n', '    }\n', '\n', '    /**\n', '     * End the process to nable access for specified contract after delay period has passed.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address to which to grant permissions\n', '     */\n', '    function endGrantAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));\n', '        pending[addr] = 0;\n', '        contracts[addr] = true;\n', '    }\n', '\n', '    /**\n', '     * Revoke access for specified contract. Can be done instantly.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address of which to revoke permissions\n', '     */    \n', '    function revokeAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        contracts[addr] = false;\n', '    }\n', '\n', '    /**\n', '     * Register a proxy contract with this registry\n', '     *\n', '     * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy\n', '     * @return New AuthenticatedProxy contract\n', '     */\n', '    function registerProxy()\n', '        public\n', '        returns (OwnableDelegateProxy proxy)\n', '    {\n', '        require(proxies[msg.sender] == address(0));\n', '        proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));\n', '        proxies[msg.sender] = proxy;\n', '        return proxy;\n', '    }\n', '\n', '}\n', '\n', 'contract WyvernProxyRegistry is ProxyRegistry {\n', '\n', '    string public constant name = "Project Wyvern Proxy Registry";\n', '\n', '    /* Whether the initial auth address has been set. */\n', '    bool public initialAddressSet = false;\n', '\n', '    constructor ()\n', '        public\n', '    {\n', '        delegateProxyImplementation = new AuthenticatedProxy();\n', '    }\n', '\n', '    /** \n', '     * Grant authentication to the initial Exchange protocol contract\n', '     *\n', '     * @dev No delay, can only be called once - after that the standard registry process with a delay must be used\n', '     * @param authAddress Address of the contract to grant authentication\n', '     */\n', '    function grantInitialAuthentication (address authAddress)\n', '        onlyOwner\n', '        public\n', '    {\n', '        require(!initialAddressSet);\n', '        initialAddressSet = true;\n', '        contracts[authAddress] = true;\n', '    }\n', '\n', '}\n', '\n', 'contract OwnedUpgradeabilityStorage {\n', '\n', '  // Current implementation\n', '  address internal _implementation;\n', '\n', '  // Owner of the contract\n', '  address private _upgradeabilityOwner;\n', '\n', '  /**\n', '   * @dev Tells the address of the owner\n', '   * @return the address of the owner\n', '   */\n', '  function upgradeabilityOwner() public view returns (address) {\n', '    return _upgradeabilityOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the owner\n', '   */\n', '  function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {\n', '    _upgradeabilityOwner = newUpgradeabilityOwner;\n', '  }\n', '\n', '  /**\n', '  * @dev Tells the address of the current implementation\n', '  * @return address of the current implementation\n', '  */\n', '  function implementation() public view returns (address) {\n', '    return _implementation;\n', '  }\n', '\n', '  /**\n', '  * @dev Tells the proxy type (EIP 897)\n', '  * @return Proxy type, 2 for forwarding proxy\n', '  */\n', '  function proxyType() public pure returns (uint256 proxyTypeId) {\n', '    return 2;\n', '  }\n', '}\n', '\n', 'contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {\n', '\n', '    /* Whether initialized. */\n', '    bool initialized = false;\n', '\n', '    /* Address which owns this proxy. */\n', '    address public user;\n', '\n', '    /* Associated registry with contract authentication information. */\n', '    ProxyRegistry public registry;\n', '\n', '    /* Whether access has been revoked. */\n', '    bool public revoked;\n', '\n', '    /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */\n', '    enum HowToCall { Call, DelegateCall }\n', '\n', '    /* Event fired when the proxy access is revoked or unrevoked. */\n', '    event Revoked(bool revoked);\n', '\n', '    /**\n', '     * Initialize an AuthenticatedProxy\n', '     *\n', '     * @param addrUser Address of user on whose behalf this proxy will act\n', '     * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy\n', '     */\n', '    function initialize (address addrUser, ProxyRegistry addrRegistry)\n', '        public\n', '    {\n', '        require(!initialized);\n', '        initialized = true;\n', '        user = addrUser;\n', '        registry = addrRegistry;\n', '    }\n', '\n', '    /**\n', '     * Set the revoked flag (allows a user to revoke ProxyRegistry access)\n', '     *\n', '     * @dev Can be called by the user only\n', '     * @param revoke Whether or not to revoke access\n', '     */\n', '    function setRevoke(bool revoke)\n', '        public\n', '    {\n', '        require(msg.sender == user);\n', '        revoked = revoke;\n', '        emit Revoked(revoke);\n', '    }\n', '\n', '    /**\n', '     * Execute a message call from the proxy contract\n', '     *\n', '     * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access\n', '     * @param dest Address to which the call will be sent\n', '     * @param howToCall Which kind of call to make\n', '     * @param calldata Calldata to send\n', '     * @return Result of the call (success or failure)\n', '     */\n', '    function proxy(address dest, HowToCall howToCall, bytes calldata)\n', '        public\n', '        returns (bool result)\n', '    {\n', '        require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));\n', '        if (howToCall == HowToCall.Call) {\n', '            result = dest.call(calldata);\n', '        } else if (howToCall == HowToCall.DelegateCall) {\n', '            result = dest.delegatecall(calldata);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    /**\n', '     * Execute a message call and assert success\n', '     * \n', '     * @dev Same functionality as `proxy`, just asserts the return value\n', '     * @param dest Address to which the call will be sent\n', '     * @param howToCall What kind of call to make\n', '     * @param calldata Calldata to send\n', '     */\n', '    function proxyAssert(address dest, HowToCall howToCall, bytes calldata)\n', '        public\n', '    {\n', '        require(proxy(dest, howToCall, calldata));\n', '    }\n', '\n', '}\n', '\n', 'contract Proxy {\n', '\n', '  /**\n', '  * @dev Tells the address of the implementation where every call will be delegated.\n', '  * @return address of the implementation to which it will be delegated\n', '  */\n', '  function implementation() public view returns (address);\n', '\n', '  /**\n', '  * @dev Tells the type of proxy (EIP 897)\n', '  * @return Type of proxy, 2 for upgradeable proxy\n', '  */\n', '  function proxyType() public pure returns (uint256 proxyTypeId);\n', '\n', '  /**\n', '  * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '  * This function will return whatever the implementation call returns\n', '  */\n', '  function () payable public {\n', '    address _impl = implementation();\n', '    require(_impl != address(0));\n', '\n', '    assembly {\n', '      let ptr := mload(0x40)\n', '      calldatacopy(ptr, 0, calldatasize)\n', '      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)\n', '      let size := returndatasize\n', '      returndatacopy(ptr, 0, size)\n', '\n', '      switch result\n', '      case 0 { revert(ptr, size) }\n', '      default { return(ptr, size) }\n', '    }\n', '  }\n', '}\n', '\n', 'contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {\n', '  /**\n', '  * @dev Event to show ownership has been transferred\n', '  * @param previousOwner representing the address of the previous owner\n', '  * @param newOwner representing the address of the new owner\n', '  */\n', '  event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '  /**\n', '  * @dev This event will be emitted every time the implementation gets upgraded\n', '  * @param implementation representing the address of the upgraded implementation\n', '  */\n', '  event Upgraded(address indexed implementation);\n', '\n', '  /**\n', '  * @dev Upgrades the implementation address\n', '  * @param implementation representing the address of the new implementation to be set\n', '  */\n', '  function _upgradeTo(address implementation) internal {\n', '    require(_implementation != implementation);\n', '    _implementation = implementation;\n', '    emit Upgraded(implementation);\n', '  }\n', '\n', '  /**\n', '  * @dev Throws if called by any account other than the owner.\n', '  */\n', '  modifier onlyProxyOwner() {\n', '    require(msg.sender == proxyOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Tells the address of the proxy owner\n', '   * @return the address of the proxy owner\n', '   */\n', '  function proxyOwner() public view returns (address) {\n', '    return upgradeabilityOwner();\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferProxyOwnership(address newOwner) public onlyProxyOwner {\n', '    require(newOwner != address(0));\n', '    emit ProxyOwnershipTransferred(proxyOwner(), newOwner);\n', '    setUpgradeabilityOwner(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   */\n', '  function upgradeTo(address implementation) public onlyProxyOwner {\n', '    _upgradeTo(implementation);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy\n', '   * and delegatecall the new implementation for initialization.\n', '   * @param implementation representing the address of the new implementation to be set.\n', '   * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function\n', '   * signature of the implementation to be called with the needed payload\n', '   */\n', '  function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {\n', '    upgradeTo(implementation);\n', '    require(address(this).delegatecall(data));\n', '  }\n', '}\n', '\n', 'contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {\n', '\n', '    constructor(address owner, address initialImplementation, bytes calldata)\n', '        public\n', '    {\n', '        setUpgradeabilityOwner(owner);\n', '        _upgradeTo(initialImplementation);\n', '        require(initialImplementation.delegatecall(calldata));\n', '    }\n', '\n', '}']
