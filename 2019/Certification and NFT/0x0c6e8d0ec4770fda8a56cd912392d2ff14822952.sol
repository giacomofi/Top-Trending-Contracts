['pragma solidity >=0.5.0 <0.6.0;\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', 'contract PauserRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '\n', '    constructor () internal {\n', '        _addPauser(msg.sender);\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '\n', '    function renouncePauser() public {\n', '        _removePauser(msg.sender);\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {\n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', 'contract Pausable is PauserRole {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'library BytesUtils {\n', '  function isZero(bytes memory b) internal pure returns (bool) {\n', '    if (b.length == 0) {\n', '      return true;\n', '    }\n', '    bytes memory zero = new bytes(b.length);\n', '    return keccak256(b) == keccak256(zero);\n', '  }\n', '}\n', '\n', 'library DnsUtils {\n', '  function isDomainName(bytes memory s) internal pure returns (bool) {\n', "    byte last = '.';\n", '    bool ok = false;\n', '    uint partlen = 0;\n', '\n', '    for (uint i = 0; i < s.length; i++) {\n', '      byte c = s[i];\n', "      if (c >= 'a' && c <= 'z' || c == '_') {\n", '        ok = true;\n', '        partlen++;\n', "      } else if (c >= '0' && c <= '9') {\n", '        partlen++;\n', "      } else if (c == '-') {\n", '        // byte before dash cannot be dot.\n', "        if (last == '.') {\n", '          return false;\n', '        }\n', '        partlen++;\n', "      } else if (c == '.') {\n", '        // byte before dot cannot be dot, dash.\n', "        if (last == '.' || last == '-') {\n", '          return false;\n', '        }\n', '        if (partlen > 63 || partlen == 0) {\n', '          return false;\n', '        }\n', '        partlen = 0;\n', '      } else {\n', '        return false;\n', '      }\n', '      last = c;\n', '    }\n', "    if (last == '-' || partlen > 63) {\n", '      return false;\n', '    }\n', '    return ok;\n', '  }\n', '}\n', '\n', 'contract Marketplace is Ownable, Pausable {\n', '  using BytesUtils for bytes;\n', '  using DnsUtils for bytes;\n', '\n', '  /**\n', '    Structures\n', '   */\n', '\n', '  struct Service {\n', '    uint256 createTime;\n', '    address owner;\n', '    bytes sid;\n', '\n', '    mapping(bytes32 => Version) versions; // version hash => Version\n', '    bytes32[] versionsList;\n', '\n', '    Offer[] offers;\n', '\n', "    mapping(address => Purchase) purchases; // purchaser's address => Purchase\n", '    address[] purchasesList;\n', '  }\n', '\n', '  struct Purchase {\n', '    uint256 createTime;\n', '    uint expire;\n', '  }\n', '\n', '  struct Version {\n', '    uint256 createTime;\n', '    bytes manifest;\n', '    bytes manifestProtocol;\n', '  }\n', '\n', '  struct Offer {\n', '    uint256 createTime;\n', '    uint price;\n', '    uint duration;\n', '    bool active;\n', '  }\n', '\n', '  /**\n', '    Constant\n', '   */\n', '\n', '  uint constant INFINITY = ~uint256(0);\n', '  uint constant SID_MIN_LEN = 1;\n', '  uint constant SID_MAX_LEN = 63;\n', '\n', '  /**\n', '    Errors\n', '  */\n', '\n', '  string constant private ERR_ADDRESS_ZERO = "address is zero";\n', '\n', '  string constant private ERR_SID_LEN = "sid must be between 1 and 63 characters";\n', '  string constant private ERR_SID_INVALID = "sid must be a valid dns name";\n', '\n', '  string constant private ERR_SERVICE_EXIST = "service with given sid already exists";\n', '  string constant private ERR_SERVICE_NOT_EXIST = "service with given sid does not exist";\n', '  string constant private ERR_SERVICE_NOT_OWNER = "sender is not the service owner";\n', '\n', '  string constant private ERR_VERSION_EXIST = "version with given hash already exists";\n', '  string constant private ERR_VERSION_MANIFEST_LEN = "version manifest must have at least 1 character";\n', '  string constant private ERR_VERSION_MANIFEST_PROTOCOL_LEN = "version manifest protocol must have at least 1 character";\n', '\n', '  string constant private ERR_OFFER_NOT_EXIST = "offer dose not exist";\n', '  string constant private ERR_OFFER_NO_VERSION = "offer must be created with at least 1 version";\n', '  string constant private ERR_OFFER_NOT_ACTIVE = "offer must be active";\n', '  string constant private ERR_OFFER_DURATION_MIN = "offer duration must be greater than 0";\n', '\n', '  string constant private ERR_PURCHASE_OWNER = "sender cannot purchase his own service";\n', '  string constant private ERR_PURCHASE_INFINITY = "service already purchase for infinity";\n', '  string constant private ERR_PURCHASE_TOKEN_BALANCE = "token balance must be greater to purchase the service";\n', '  string constant private ERR_PURCHASE_TOKEN_APPROVE = "sender must approve the marketplace to spend token";\n', '\n', '  /**\n', '    State variables\n', '   */\n', '\n', '  IERC20 public token;\n', '\n', '  mapping(bytes32 => Service) public services; // service hashed sid => Service\n', '  bytes32[] public servicesList;\n', '\n', '  mapping(bytes32 => bytes32) public versionHashToService; // version hash => service hashed sid\n', '\n', '  /**\n', '    Constructor\n', '   */\n', '\n', '  constructor(IERC20 _token) public {\n', '    token = _token;\n', '  }\n', '\n', '  /**\n', '    Events\n', '   */\n', '\n', '  event ServiceCreated(\n', '    bytes sid,\n', '    address indexed owner\n', '  );\n', '\n', '  event ServiceOwnershipTransferred(\n', '    bytes sid,\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  event ServiceVersionCreated(\n', '    bytes sid,\n', '    bytes32 indexed versionHash,\n', '    bytes manifest,\n', '    bytes manifestProtocol\n', '  );\n', '\n', '  event ServiceOfferCreated(\n', '    bytes sid,\n', '    uint indexed offerIndex,\n', '    uint price,\n', '    uint duration\n', '  );\n', '\n', '  event ServiceOfferDisabled(\n', '    bytes sid,\n', '    uint indexed offerIndex\n', '  );\n', '\n', '  event ServicePurchased(\n', '    bytes sid,\n', '    uint indexed offerIndex,\n', '    address indexed purchaser,\n', '    uint price,\n', '    uint duration,\n', '    uint expire\n', '  );\n', '\n', '  /**\n', '    Modifiers\n', '   */\n', '\n', '  modifier whenAddressNotZero(address a) {\n', '    require(a != address(0), ERR_ADDRESS_ZERO);\n', '    _;\n', '  }\n', '\n', '  modifier whenManifestNotEmpty(bytes memory manifest) {\n', '    require(!manifest.isZero(), ERR_VERSION_MANIFEST_LEN);\n', '    _;\n', '  }\n', '\n', '  modifier whenManifestProtocolNotEmpty(bytes memory manifestProtocol) {\n', '    require(!manifestProtocol.isZero(), ERR_VERSION_MANIFEST_PROTOCOL_LEN);\n', '    _;\n', '  }\n', '\n', '  modifier whenDurationNotZero(uint duration) {\n', '    require(duration > 0, ERR_OFFER_DURATION_MIN);\n', '    _;\n', '  }\n', '\n', '  /**\n', '    Internals\n', '   */\n', '\n', '  function _service(bytes memory sid)\n', '    internal view\n', '    returns (Service storage service, bytes32 sidHash)\n', '  {\n', '    sidHash = keccak256(sid);\n', '    require(_isServiceExist(sidHash), ERR_SERVICE_NOT_EXIST);\n', '    return (services[sidHash], sidHash);\n', '  }\n', '\n', '  function _isServiceExist(bytes32 sidHash)\n', '    internal view\n', '    returns (bool exist)\n', '  {\n', '    return services[sidHash].owner != address(0);\n', '  }\n', '\n', '  function _isServiceOwner(bytes32 sidHash, address owner)\n', '    internal view\n', '    returns (bool isOwner)\n', '  {\n', '    return services[sidHash].owner == owner;\n', '  }\n', '\n', '  function _isServiceOfferExist(bytes32 sidHash, uint offerIndex)\n', '    internal view\n', '    returns (bool exist)\n', '  {\n', '    return offerIndex < services[sidHash].offers.length;\n', '  }\n', '\n', '  function _isServicesPurchaseExist(bytes32 sidHash, address purchaser)\n', '    internal view\n', '    returns (bool exist)\n', '  {\n', '    return services[sidHash].purchases[purchaser].createTime > 0;\n', '  }\n', '\n', '  /**\n', '    External and public functions\n', '   */\n', '\n', '  function createService(bytes memory sid)\n', '    public\n', '    whenNotPaused\n', '  {\n', '    require(SID_MIN_LEN <= sid.length && sid.length <= SID_MAX_LEN, ERR_SID_LEN);\n', '    require(sid.isDomainName(), ERR_SID_INVALID);\n', '    bytes32 sidHash = keccak256(sid);\n', '    require(!_isServiceExist(sidHash), ERR_SERVICE_EXIST);\n', '    services[sidHash].owner = msg.sender;\n', '    services[sidHash].sid = sid;\n', '    services[sidHash].createTime = now;\n', '    servicesList.push(sidHash);\n', '    emit ServiceCreated(sid, msg.sender);\n', '  }\n', '\n', '  function transferServiceOwnership(bytes calldata sid, address newOwner)\n', '    external\n', '    whenNotPaused\n', '    whenAddressNotZero(newOwner)\n', '  {\n', '    (Service storage service, bytes32 sidHash) = _service(sid);\n', '    require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);\n', '    emit ServiceOwnershipTransferred(sid, service.owner, newOwner);\n', '    service.owner = newOwner;\n', '  }\n', '\n', '  function createServiceVersion(\n', '    bytes memory sid,\n', '    bytes memory manifest,\n', '    bytes memory manifestProtocol\n', '  )\n', '    public\n', '    whenNotPaused\n', '    whenManifestNotEmpty(manifest)\n', '    whenManifestProtocolNotEmpty(manifestProtocol)\n', '  {\n', '    (Service storage service, bytes32 sidHash) = _service(sid);\n', '    require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);\n', '    bytes32 versionHash = keccak256(abi.encodePacked(msg.sender, sid, manifest, manifestProtocol));\n', '    require(!isServiceVersionExist(versionHash), ERR_VERSION_EXIST);\n', '    Version storage version = service.versions[versionHash];\n', '    version.manifest = manifest;\n', '    version.manifestProtocol = manifestProtocol;\n', '    version.createTime = now;\n', '    services[sidHash].versionsList.push(versionHash);\n', '    versionHashToService[versionHash] = sidHash;\n', '    emit ServiceVersionCreated(sid, versionHash, manifest, manifestProtocol);\n', '  }\n', '\n', '  function publishServiceVersion(\n', '    bytes calldata sid,\n', '    bytes calldata manifest,\n', '    bytes calldata manifestProtocol\n', '  )\n', '    external\n', '    whenNotPaused\n', '  {\n', '    if (!isServiceExist(sid)) {\n', '      createService(sid);\n', '    }\n', '    createServiceVersion(sid, manifest, manifestProtocol);\n', '  }\n', '\n', '  function createServiceOffer(bytes calldata sid, uint price, uint duration)\n', '    external\n', '    whenNotPaused\n', '    whenDurationNotZero(duration)\n', '    returns (uint offerIndex)\n', '  {\n', '    (Service storage service, bytes32 sidHash) = _service(sid);\n', '    require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);\n', '    require(service.versionsList.length > 0, ERR_OFFER_NO_VERSION);\n', '    Offer[] storage offers = services[sidHash].offers;\n', '    offers.push(Offer({\n', '      createTime: now,\n', '      price: price,\n', '      duration: duration,\n', '      active: true\n', '    }));\n', '    emit ServiceOfferCreated(sid, offers.length - 1, price, duration);\n', '    return offers.length - 1;\n', '  }\n', '\n', '  function disableServiceOffer(bytes calldata sid, uint offerIndex)\n', '    external\n', '    whenNotPaused\n', '  {\n', '    (Service storage service, bytes32 sidHash) = _service(sid);\n', '    require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);\n', '    require(_isServiceOfferExist(sidHash, offerIndex), ERR_OFFER_NOT_EXIST);\n', '    service.offers[offerIndex].active = false;\n', '    emit ServiceOfferDisabled(sid, offerIndex);\n', '  }\n', '\n', '  function purchase(bytes calldata sid, uint offerIndex)\n', '    external\n', '    whenNotPaused\n', '  {\n', '    (Service storage service, bytes32 sidHash) = _service(sid);\n', '    require(!_isServiceOwner(sidHash, msg.sender), ERR_PURCHASE_OWNER);\n', '    require(_isServiceOfferExist(sidHash, offerIndex), ERR_OFFER_NOT_EXIST);\n', '    require(service.offers[offerIndex].active, ERR_OFFER_NOT_ACTIVE);\n', '\n', '    Offer storage offer = service.offers[offerIndex];\n', '\n', '    // if offer has been purchased for infinity then return\n', '    require(service.purchases[msg.sender].expire != INFINITY, ERR_PURCHASE_INFINITY);\n', '\n', '    // Check if offer is active, sender has enough balance and approved the transform\n', '    require(token.balanceOf(msg.sender) >= offer.price, ERR_PURCHASE_TOKEN_BALANCE);\n', '    require(token.allowance(msg.sender, address(this)) >= offer.price, ERR_PURCHASE_TOKEN_APPROVE);\n', '\n', '    // Transfer the token from sender to service owner\n', '    token.transferFrom(msg.sender, service.owner, offer.price);\n', '\n', '    // max(service.purchases[msg.sender].expire,  now)\n', '    uint expire = service.purchases[msg.sender].expire <= now ?\n', '                     now : service.purchases[msg.sender].expire;\n', '\n', '    // set expire + duration or INFINITY on overflow\n', '    expire = expire + offer.duration < expire ?\n', '               INFINITY : expire + offer.duration;\n', '\n', '    // if given address purchase service\n', '    // 1st time add it to purchases list and set create time\n', '    if (service.purchases[msg.sender].expire == 0) {\n', '      service.purchases[msg.sender].createTime = now;\n', '      service.purchasesList.push(msg.sender);\n', '    }\n', '\n', '    // set new expire time\n', '    service.purchases[msg.sender].expire = expire;\n', '    emit ServicePurchased(\n', '      sid,\n', '      offerIndex,\n', '      msg.sender,\n', '      offer.price,\n', '      offer.duration,\n', '      expire\n', '    );\n', '  }\n', '\n', '  function destroy() public onlyOwner {\n', '    selfdestruct(msg.sender);\n', '  }\n', '\n', '  /**\n', '    External views\n', '   */\n', '\n', '  function servicesLength()\n', '    external view\n', '    returns (uint length)\n', '  {\n', '    return servicesList.length;\n', '  }\n', '\n', '  function service(bytes calldata _sid)\n', '    external view\n', '    returns (uint256 createTime, address owner, bytes memory sid)\n', '  {\n', '    bytes32 sidHash = keccak256(_sid);\n', '    Service storage s = services[sidHash];\n', '    return (s.createTime, s.owner, s.sid);\n', '  }\n', '\n', '  function serviceVersionsLength(bytes calldata sid)\n', '    external view\n', '    returns (uint length)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    return s.versionsList.length;\n', '  }\n', '\n', '  function serviceVersionHash(bytes calldata sid, uint versionIndex)\n', '    external view\n', '    returns (bytes32 versionHash)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    return s.versionsList[versionIndex];\n', '  }\n', '\n', '  function serviceVersion(bytes32 versionHash)\n', '    external view\n', '    returns (\n', '      uint256 createTime,\n', '      bytes memory manifest,\n', '      bytes memory manifestProtocol\n', '    )\n', '  {\n', '    bytes32 sidHash = versionHashToService[versionHash];\n', '    require(_isServiceExist(sidHash), ERR_SERVICE_NOT_EXIST);\n', '    Version storage version = services[sidHash].versions[versionHash];\n', '    return (version.createTime, version.manifest, version.manifestProtocol);\n', '  }\n', '\n', '  function serviceOffersLength(bytes calldata sid)\n', '    external view\n', '    returns (uint length)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    return s.offers.length;\n', '  }\n', '\n', '  function serviceOffer(bytes calldata sid, uint offerIndex)\n', '    external view\n', '    returns (uint256 createTime, uint price, uint duration, bool active)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    Offer storage offer = s.offers[offerIndex];\n', '    return (offer.createTime, offer.price, offer.duration, offer.active);\n', '  }\n', '\n', '  function servicePurchasesLength(bytes calldata sid)\n', '    external view\n', '    returns (uint length)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    return s.purchasesList.length;\n', '  }\n', '\n', '  function servicePurchaseAddress(bytes calldata sid, uint purchaseIndex)\n', '    external view\n', '    returns (address purchaser)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    return s.purchasesList[purchaseIndex];\n', '  }\n', '\n', '  function servicePurchase(bytes calldata sid, address purchaser)\n', '    external view\n', '    returns (uint256 createTime, uint expire)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    Purchase storage p = s.purchases[purchaser];\n', '    return (p.createTime, p.expire);\n', '  }\n', '\n', '  function isAuthorized(bytes calldata sid, address purchaser)\n', '    external view\n', '    returns (bool authorized)\n', '  {\n', '    (Service storage s,) = _service(sid);\n', '    if (s.owner == purchaser || s.purchases[purchaser].expire >= now) {\n', '      return true;\n', '    }\n', '\n', '    for (uint i = 0; i < s.offers.length; i++) {\n', '      if (s.offers[i].active && s.offers[i].price == 0) {\n', '        return true;\n', '      }\n', '    }\n', '\n', '    return false;\n', '  }\n', '\n', '  /**\n', '    Public views\n', '   */\n', '\n', '  function isServiceExist(bytes memory sid)\n', '    public view\n', '    returns (bool exist)\n', '  {\n', '    bytes32 sidHash = keccak256(sid);\n', '    return _isServiceExist(sidHash);\n', '  }\n', '\n', '  function isServiceOwner(bytes memory sid, address owner)\n', '    public view\n', '    returns (bool isOwner)\n', '  {\n', '    bytes32 sidHash = keccak256(sid);\n', '    return _isServiceOwner(sidHash, owner);\n', '  }\n', '\n', '  function isServiceVersionExist(bytes32 versionHash)\n', '    public view\n', '    returns (bool exist)\n', '  {\n', '    return _isServiceExist(versionHashToService[versionHash]);\n', '  }\n', '\n', '  function isServiceOfferExist(bytes memory sid, uint offerIndex)\n', '    public view\n', '    returns (bool exist)\n', '  {\n', '    bytes32 sidHash = keccak256(sid);\n', '    return _isServiceOfferExist(sidHash, offerIndex);\n', '  }\n', '\n', '  function isServicesPurchaseExist(bytes memory sid, address purchaser)\n', '    public view\n', '  returns (bool exist) {\n', '    bytes32 sidHash = keccak256(sid);\n', '    return _isServicesPurchaseExist(sidHash, purchaser);\n', '  }\n', '\n', '}']