['pragma solidity ^0.4.19;\n', '\n', 'library Types {\n', '  struct MutableUint {\n', '    uint256 pre;\n', '    uint256 post;\n', '  }\n', '\n', '  struct MutableTimestamp {\n', '    MutableUint time;\n', '    uint256 in_units;\n', '  }\n', '\n', '  function advance_by(MutableTimestamp memory _original, uint256 _units)\n', '           internal\n', '           constant\n', '           returns (MutableTimestamp _transformed)\n', '  {\n', '    _transformed = _original;\n', '    require(now >= _original.time.pre);\n', '    uint256 _lapsed = now - _original.time.pre;\n', '    _transformed.in_units = _lapsed / _units;\n', '    uint256 _ticks = _transformed.in_units * _units;\n', '    if (_transformed.in_units == 0) {\n', '      _transformed.time.post = _original.time.pre;\n', '    } else {\n', '      _transformed.time = add(_transformed.time, _ticks);\n', '    }\n', '  }\n', '\n', '  function add(MutableUint memory _original, uint256 _amount)\n', '           internal\n', '           pure\n', '           returns (MutableUint _transformed)\n', '  {\n', '    require((_original.pre + _amount) >= _original.pre);\n', '    _transformed = _original;\n', '    _transformed.post = _original.pre + _amount;\n', '  }\n', '}\n', '\n', 'contract DigixConstants {\n', '    /// general constants\n', '    uint256 constant SECONDS_IN_A_DAY = 24 * 60 * 60;\n', '\n', '    /// asset events\n', '    uint256 constant ASSET_EVENT_CREATED_VENDOR_ORDER = 1;\n', '    uint256 constant ASSET_EVENT_CREATED_TRANSFER_ORDER = 2;\n', '    uint256 constant ASSET_EVENT_CREATED_REPLACEMENT_ORDER = 3;\n', '    uint256 constant ASSET_EVENT_FULFILLED_VENDOR_ORDER = 4;\n', '    uint256 constant ASSET_EVENT_FULFILLED_TRANSFER_ORDER = 5;\n', '    uint256 constant ASSET_EVENT_FULFILLED_REPLACEMENT_ORDER = 6;\n', '    uint256 constant ASSET_EVENT_MINTED = 7;\n', '    uint256 constant ASSET_EVENT_MINTED_REPLACEMENT = 8;\n', '    uint256 constant ASSET_EVENT_RECASTED = 9;\n', '    uint256 constant ASSET_EVENT_REDEEMED = 10;\n', '    uint256 constant ASSET_EVENT_FAILED_AUDIT = 11;\n', '    uint256 constant ASSET_EVENT_ADMIN_FAILED = 12;\n', '    uint256 constant ASSET_EVENT_REMINTED = 13;\n', '\n', '    /// roles\n', '    uint256 constant ROLE_ZERO_ANYONE = 0;\n', '    uint256 constant ROLE_ROOT = 1;\n', '    uint256 constant ROLE_VENDOR = 2;\n', '    uint256 constant ROLE_XFERAUTH = 3;\n', '    uint256 constant ROLE_POPADMIN = 4;\n', '    uint256 constant ROLE_CUSTODIAN = 5;\n', '    uint256 constant ROLE_AUDITOR = 6;\n', '    uint256 constant ROLE_MARKETPLACE_ADMIN = 7;\n', '    uint256 constant ROLE_KYC_ADMIN = 8;\n', '    uint256 constant ROLE_FEES_ADMIN = 9;\n', '    uint256 constant ROLE_DOCS_UPLOADER = 10;\n', '    uint256 constant ROLE_KYC_RECASTER = 11;\n', '    uint256 constant ROLE_FEES_DISTRIBUTION_ADMIN = 12;\n', '\n', '    /// states\n', '    uint256 constant STATE_ZERO_UNDEFINED = 0;\n', '    uint256 constant STATE_CREATED = 1;\n', '    uint256 constant STATE_VENDOR_ORDER = 2;\n', '    uint256 constant STATE_TRANSFER = 3;\n', '    uint256 constant STATE_CUSTODIAN_DELIVERY = 4;\n', '    uint256 constant STATE_MINTED = 5;\n', '    uint256 constant STATE_AUDIT_FAILURE = 6;\n', '    uint256 constant STATE_REPLACEMENT_ORDER = 7;\n', '    uint256 constant STATE_REPLACEMENT_DELIVERY = 8;\n', '    uint256 constant STATE_RECASTED = 9;\n', '    uint256 constant STATE_REDEEMED = 10;\n', '    uint256 constant STATE_ADMIN_FAILURE = 11;\n', '\n', '    /// interactive contracts\n', '    bytes32 constant CONTRACT_INTERACTIVE_ASSETS_EXPLORER = "i:asset:explorer";\n', '    bytes32 constant CONTRACT_INTERACTIVE_DIGIX_DIRECTORY = "i:directory";\n', '    bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE = "i:mp";\n', '    bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_ADMIN = "i:mpadmin";\n', '    bytes32 constant CONTRACT_INTERACTIVE_POPADMIN = "i:popadmin";\n', '    bytes32 constant CONTRACT_INTERACTIVE_PRODUCTS_LIST = "i:products";\n', '    bytes32 constant CONTRACT_INTERACTIVE_TOKEN = "i:token";\n', '    bytes32 constant CONTRACT_INTERACTIVE_BULK_WRAPPER = "i:bulk-wrapper";\n', '    bytes32 constant CONTRACT_INTERACTIVE_TOKEN_CONFIG = "i:token:config";\n', '    bytes32 constant CONTRACT_INTERACTIVE_TOKEN_INFORMATION = "i:token:information";\n', '    bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_INFORMATION = "i:mp:information";\n', '    bytes32 constant CONTRACT_INTERACTIVE_IDENTITY = "i:identity";\n', '\n', '    /// controller contracts\n', '    bytes32 constant CONTRACT_CONTROLLER_ASSETS = "c:asset";\n', '    bytes32 constant CONTRACT_CONTROLLER_ASSETS_RECAST = "c:asset:recast";\n', '    bytes32 constant CONTRACT_CONTROLLER_ASSETS_EXPLORER = "c:explorer";\n', '    bytes32 constant CONTRACT_CONTROLLER_DIGIX_DIRECTORY = "c:directory";\n', '    bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE = "c:mp";\n', '    bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE_ADMIN = "c:mpadmin";\n', '    bytes32 constant CONTRACT_CONTROLLER_PRODUCTS_LIST = "c:products";\n', '\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_APPROVAL = "c:token:approval";\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_CONFIG = "c:token:config";\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_INFO = "c:token:info";\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_TRANSFER = "c:token:transfer";\n', '\n', '    bytes32 constant CONTRACT_CONTROLLER_JOB_ID = "c:jobid";\n', '    bytes32 constant CONTRACT_CONTROLLER_IDENTITY = "c:identity";\n', '\n', '    /// storage contracts\n', '    bytes32 constant CONTRACT_STORAGE_ASSETS = "s:asset";\n', '    bytes32 constant CONTRACT_STORAGE_ASSET_EVENTS = "s:asset:events";\n', '    bytes32 constant CONTRACT_STORAGE_DIGIX_DIRECTORY = "s:directory";\n', '    bytes32 constant CONTRACT_STORAGE_MARKETPLACE = "s:mp";\n', '    bytes32 constant CONTRACT_STORAGE_PRODUCTS_LIST = "s:products";\n', '    bytes32 constant CONTRACT_STORAGE_GOLD_TOKEN = "s:goldtoken";\n', '    bytes32 constant CONTRACT_STORAGE_JOB_ID = "s:jobid";\n', '    bytes32 constant CONTRACT_STORAGE_IDENTITY = "s:identity";\n', '\n', '    /// service contracts\n', '    bytes32 constant CONTRACT_SERVICE_TOKEN_DEMURRAGE = "sv:tdemurrage";\n', '    bytes32 constant CONTRACT_SERVICE_MARKETPLACE = "sv:mp";\n', '    bytes32 constant CONTRACT_SERVICE_DIRECTORY = "sv:directory";\n', '\n', '    /// fees distributors\n', '    bytes32 constant CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR = "fees:distributor:demurrage";\n', '    bytes32 constant CONTRACT_RECAST_FEES_DISTRIBUTOR = "fees:distributor:recast";\n', '    bytes32 constant CONTRACT_TRANSFER_FEES_DISTRIBUTOR = "fees:distributor:transfer";\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract ResolverClient {\n', '  /// @dev Get the address of a contract\n', '  /// @param _key the resolver key to look up\n', '  /// @return _contract the address of the contract\n', '  function get_contract(bytes32 _key) public constant returns (address _contract);\n', '}\n', '\n', 'contract TokenInformation is ResolverClient {\n', '  function showDemurrageConfigs() public constant returns (uint256 _base, uint256 _rate, address _collector, bool _no_demurrage_fee);\n', '  function showCollectorsAddresses() public constant returns (address[3] _collectors);\n', '}\n', '\n', 'contract Token {\n', '  function totalSupply() constant public returns (uint256 _total_supply);\n', '  function balanceOf(address _owner) constant public returns (uint256 balance);\n', '}\n', '\n', 'contract DgxDemurrageCalculator {\n', '  address public TOKEN_ADDRESS;\n', '  address public TOKEN_INFORMATION_ADDRESS;\n', '\n', '  function token_information() internal view returns (TokenInformation _token_information) {\n', '    _token_information = TokenInformation(TOKEN_INFORMATION_ADDRESS);\n', '  }\n', '\n', '  function DgxDemurrageCalculator(address _token_address, address _token_information_address) public {\n', '    TOKEN_ADDRESS = _token_address;\n', '    TOKEN_INFORMATION_ADDRESS = _token_information_address;\n', '  }\n', '\n', '  function calculateDemurrage(uint256 _initial_balance, uint256 _days_elapsed)\n', '           public\n', '           view\n', '           returns (uint256 _demurrage_fees, bool _no_demurrage_fees)\n', '  {\n', '    uint256 _base;\n', '    uint256 _rate;\n', '    (_base, _rate,,_no_demurrage_fees) = token_information().showDemurrageConfigs();\n', '    _demurrage_fees = (_initial_balance * _days_elapsed * _rate) / _base;\n', '  }\n', '}\n', '\n', '\n', '/// @title Digix Gold Token Demurrage Reporter\n', '/// @author Digix Holdings Pte Ltd\n', '/// @notice This contract is used to keep a close estimate of how much demurrage fees would have been collected on Digix Gold Token if the demurrage fees is on.\n', '/// @notice Anyone can call the function updateDemurrageReporter() to keep this contract updated to the lastest day. The more often this function is called the more accurate the estimate will be (but it can only be updated at most every 24hrs)\n', 'contract DgxDemurrageReporter is DgxDemurrageCalculator, Claimable, DigixConstants {\n', '  address[] public exempted_accounts;\n', '  uint256 public last_demurrageable_balance; // the total balance of DGX in non-exempted accounts, at last_payment_timestamp\n', '  uint256 public last_payment_timestamp;  // the last time this contract is updated\n', '  uint256 public culmulative_demurrage_collected; // this is the estimate of the demurrage fees that would have been collected from start_of_report_period to last_payment_timestamp\n', '  uint256 public start_of_report_period; // the timestamp when this contract started keeping track of demurrage fees\n', '\n', '  using Types for Types.MutableTimestamp;\n', '\n', '  function DgxDemurrageReporter(address _token_address, address _token_information_address) public DgxDemurrageCalculator(_token_address, _token_information_address)\n', '  {\n', '    address[3] memory _collectors;\n', '    _collectors = token_information().showCollectorsAddresses();\n', '    exempted_accounts.push(_collectors[0]);\n', '    exempted_accounts.push(_collectors[1]);\n', '    exempted_accounts.push(_collectors[2]);\n', '\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR));\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_RECAST_FEES_DISTRIBUTOR));\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_TRANSFER_FEES_DISTRIBUTOR));\n', '\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_STORAGE_MARKETPLACE));\n', '    start_of_report_period = now;\n', '    last_payment_timestamp = now;\n', '    updateDemurrageReporter();\n', '  }\n', '\n', '  function addExemptedAccount(address _account) public onlyOwner {\n', '    exempted_accounts.push(_account);\n', '  }\n', '\n', '  function updateDemurrageReporter() public {\n', '    Types.MutableTimestamp memory payment_timestamp;\n', '    payment_timestamp.time.pre = last_payment_timestamp;\n', '    payment_timestamp = payment_timestamp.advance_by(1 days);\n', '\n', '    uint256 _base;\n', '    uint256 _rate;\n', '    (_base, _rate,,) = token_information().showDemurrageConfigs();\n', '\n', '    culmulative_demurrage_collected += (payment_timestamp.in_units * last_demurrageable_balance * _rate) / _base;\n', '    last_payment_timestamp = payment_timestamp.time.post;\n', '    last_demurrageable_balance = getDemurrageableBalance();\n', '  }\n', '\n', '  function getDemurrageableBalance() internal view returns (uint256 _last_demurrageable_balance) {\n', '    Token token = Token(TOKEN_ADDRESS);\n', '    uint256 _total_supply = token.totalSupply();\n', '    uint256 _no_demurrage_balance = 0;\n', '    for (uint256 i=0;i<exempted_accounts.length;i++) {\n', '      _no_demurrage_balance += token.balanceOf(exempted_accounts[i]);\n', '    }\n', '    _last_demurrageable_balance = _total_supply - _no_demurrage_balance;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'library Types {\n', '  struct MutableUint {\n', '    uint256 pre;\n', '    uint256 post;\n', '  }\n', '\n', '  struct MutableTimestamp {\n', '    MutableUint time;\n', '    uint256 in_units;\n', '  }\n', '\n', '  function advance_by(MutableTimestamp memory _original, uint256 _units)\n', '           internal\n', '           constant\n', '           returns (MutableTimestamp _transformed)\n', '  {\n', '    _transformed = _original;\n', '    require(now >= _original.time.pre);\n', '    uint256 _lapsed = now - _original.time.pre;\n', '    _transformed.in_units = _lapsed / _units;\n', '    uint256 _ticks = _transformed.in_units * _units;\n', '    if (_transformed.in_units == 0) {\n', '      _transformed.time.post = _original.time.pre;\n', '    } else {\n', '      _transformed.time = add(_transformed.time, _ticks);\n', '    }\n', '  }\n', '\n', '  function add(MutableUint memory _original, uint256 _amount)\n', '           internal\n', '           pure\n', '           returns (MutableUint _transformed)\n', '  {\n', '    require((_original.pre + _amount) >= _original.pre);\n', '    _transformed = _original;\n', '    _transformed.post = _original.pre + _amount;\n', '  }\n', '}\n', '\n', 'contract DigixConstants {\n', '    /// general constants\n', '    uint256 constant SECONDS_IN_A_DAY = 24 * 60 * 60;\n', '\n', '    /// asset events\n', '    uint256 constant ASSET_EVENT_CREATED_VENDOR_ORDER = 1;\n', '    uint256 constant ASSET_EVENT_CREATED_TRANSFER_ORDER = 2;\n', '    uint256 constant ASSET_EVENT_CREATED_REPLACEMENT_ORDER = 3;\n', '    uint256 constant ASSET_EVENT_FULFILLED_VENDOR_ORDER = 4;\n', '    uint256 constant ASSET_EVENT_FULFILLED_TRANSFER_ORDER = 5;\n', '    uint256 constant ASSET_EVENT_FULFILLED_REPLACEMENT_ORDER = 6;\n', '    uint256 constant ASSET_EVENT_MINTED = 7;\n', '    uint256 constant ASSET_EVENT_MINTED_REPLACEMENT = 8;\n', '    uint256 constant ASSET_EVENT_RECASTED = 9;\n', '    uint256 constant ASSET_EVENT_REDEEMED = 10;\n', '    uint256 constant ASSET_EVENT_FAILED_AUDIT = 11;\n', '    uint256 constant ASSET_EVENT_ADMIN_FAILED = 12;\n', '    uint256 constant ASSET_EVENT_REMINTED = 13;\n', '\n', '    /// roles\n', '    uint256 constant ROLE_ZERO_ANYONE = 0;\n', '    uint256 constant ROLE_ROOT = 1;\n', '    uint256 constant ROLE_VENDOR = 2;\n', '    uint256 constant ROLE_XFERAUTH = 3;\n', '    uint256 constant ROLE_POPADMIN = 4;\n', '    uint256 constant ROLE_CUSTODIAN = 5;\n', '    uint256 constant ROLE_AUDITOR = 6;\n', '    uint256 constant ROLE_MARKETPLACE_ADMIN = 7;\n', '    uint256 constant ROLE_KYC_ADMIN = 8;\n', '    uint256 constant ROLE_FEES_ADMIN = 9;\n', '    uint256 constant ROLE_DOCS_UPLOADER = 10;\n', '    uint256 constant ROLE_KYC_RECASTER = 11;\n', '    uint256 constant ROLE_FEES_DISTRIBUTION_ADMIN = 12;\n', '\n', '    /// states\n', '    uint256 constant STATE_ZERO_UNDEFINED = 0;\n', '    uint256 constant STATE_CREATED = 1;\n', '    uint256 constant STATE_VENDOR_ORDER = 2;\n', '    uint256 constant STATE_TRANSFER = 3;\n', '    uint256 constant STATE_CUSTODIAN_DELIVERY = 4;\n', '    uint256 constant STATE_MINTED = 5;\n', '    uint256 constant STATE_AUDIT_FAILURE = 6;\n', '    uint256 constant STATE_REPLACEMENT_ORDER = 7;\n', '    uint256 constant STATE_REPLACEMENT_DELIVERY = 8;\n', '    uint256 constant STATE_RECASTED = 9;\n', '    uint256 constant STATE_REDEEMED = 10;\n', '    uint256 constant STATE_ADMIN_FAILURE = 11;\n', '\n', '    /// interactive contracts\n', '    bytes32 constant CONTRACT_INTERACTIVE_ASSETS_EXPLORER = "i:asset:explorer";\n', '    bytes32 constant CONTRACT_INTERACTIVE_DIGIX_DIRECTORY = "i:directory";\n', '    bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE = "i:mp";\n', '    bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_ADMIN = "i:mpadmin";\n', '    bytes32 constant CONTRACT_INTERACTIVE_POPADMIN = "i:popadmin";\n', '    bytes32 constant CONTRACT_INTERACTIVE_PRODUCTS_LIST = "i:products";\n', '    bytes32 constant CONTRACT_INTERACTIVE_TOKEN = "i:token";\n', '    bytes32 constant CONTRACT_INTERACTIVE_BULK_WRAPPER = "i:bulk-wrapper";\n', '    bytes32 constant CONTRACT_INTERACTIVE_TOKEN_CONFIG = "i:token:config";\n', '    bytes32 constant CONTRACT_INTERACTIVE_TOKEN_INFORMATION = "i:token:information";\n', '    bytes32 constant CONTRACT_INTERACTIVE_MARKETPLACE_INFORMATION = "i:mp:information";\n', '    bytes32 constant CONTRACT_INTERACTIVE_IDENTITY = "i:identity";\n', '\n', '    /// controller contracts\n', '    bytes32 constant CONTRACT_CONTROLLER_ASSETS = "c:asset";\n', '    bytes32 constant CONTRACT_CONTROLLER_ASSETS_RECAST = "c:asset:recast";\n', '    bytes32 constant CONTRACT_CONTROLLER_ASSETS_EXPLORER = "c:explorer";\n', '    bytes32 constant CONTRACT_CONTROLLER_DIGIX_DIRECTORY = "c:directory";\n', '    bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE = "c:mp";\n', '    bytes32 constant CONTRACT_CONTROLLER_MARKETPLACE_ADMIN = "c:mpadmin";\n', '    bytes32 constant CONTRACT_CONTROLLER_PRODUCTS_LIST = "c:products";\n', '\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_APPROVAL = "c:token:approval";\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_CONFIG = "c:token:config";\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_INFO = "c:token:info";\n', '    bytes32 constant CONTRACT_CONTROLLER_TOKEN_TRANSFER = "c:token:transfer";\n', '\n', '    bytes32 constant CONTRACT_CONTROLLER_JOB_ID = "c:jobid";\n', '    bytes32 constant CONTRACT_CONTROLLER_IDENTITY = "c:identity";\n', '\n', '    /// storage contracts\n', '    bytes32 constant CONTRACT_STORAGE_ASSETS = "s:asset";\n', '    bytes32 constant CONTRACT_STORAGE_ASSET_EVENTS = "s:asset:events";\n', '    bytes32 constant CONTRACT_STORAGE_DIGIX_DIRECTORY = "s:directory";\n', '    bytes32 constant CONTRACT_STORAGE_MARKETPLACE = "s:mp";\n', '    bytes32 constant CONTRACT_STORAGE_PRODUCTS_LIST = "s:products";\n', '    bytes32 constant CONTRACT_STORAGE_GOLD_TOKEN = "s:goldtoken";\n', '    bytes32 constant CONTRACT_STORAGE_JOB_ID = "s:jobid";\n', '    bytes32 constant CONTRACT_STORAGE_IDENTITY = "s:identity";\n', '\n', '    /// service contracts\n', '    bytes32 constant CONTRACT_SERVICE_TOKEN_DEMURRAGE = "sv:tdemurrage";\n', '    bytes32 constant CONTRACT_SERVICE_MARKETPLACE = "sv:mp";\n', '    bytes32 constant CONTRACT_SERVICE_DIRECTORY = "sv:directory";\n', '\n', '    /// fees distributors\n', '    bytes32 constant CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR = "fees:distributor:demurrage";\n', '    bytes32 constant CONTRACT_RECAST_FEES_DISTRIBUTOR = "fees:distributor:recast";\n', '    bytes32 constant CONTRACT_TRANSFER_FEES_DISTRIBUTOR = "fees:distributor:transfer";\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract ResolverClient {\n', '  /// @dev Get the address of a contract\n', '  /// @param _key the resolver key to look up\n', '  /// @return _contract the address of the contract\n', '  function get_contract(bytes32 _key) public constant returns (address _contract);\n', '}\n', '\n', 'contract TokenInformation is ResolverClient {\n', '  function showDemurrageConfigs() public constant returns (uint256 _base, uint256 _rate, address _collector, bool _no_demurrage_fee);\n', '  function showCollectorsAddresses() public constant returns (address[3] _collectors);\n', '}\n', '\n', 'contract Token {\n', '  function totalSupply() constant public returns (uint256 _total_supply);\n', '  function balanceOf(address _owner) constant public returns (uint256 balance);\n', '}\n', '\n', 'contract DgxDemurrageCalculator {\n', '  address public TOKEN_ADDRESS;\n', '  address public TOKEN_INFORMATION_ADDRESS;\n', '\n', '  function token_information() internal view returns (TokenInformation _token_information) {\n', '    _token_information = TokenInformation(TOKEN_INFORMATION_ADDRESS);\n', '  }\n', '\n', '  function DgxDemurrageCalculator(address _token_address, address _token_information_address) public {\n', '    TOKEN_ADDRESS = _token_address;\n', '    TOKEN_INFORMATION_ADDRESS = _token_information_address;\n', '  }\n', '\n', '  function calculateDemurrage(uint256 _initial_balance, uint256 _days_elapsed)\n', '           public\n', '           view\n', '           returns (uint256 _demurrage_fees, bool _no_demurrage_fees)\n', '  {\n', '    uint256 _base;\n', '    uint256 _rate;\n', '    (_base, _rate,,_no_demurrage_fees) = token_information().showDemurrageConfigs();\n', '    _demurrage_fees = (_initial_balance * _days_elapsed * _rate) / _base;\n', '  }\n', '}\n', '\n', '\n', '/// @title Digix Gold Token Demurrage Reporter\n', '/// @author Digix Holdings Pte Ltd\n', '/// @notice This contract is used to keep a close estimate of how much demurrage fees would have been collected on Digix Gold Token if the demurrage fees is on.\n', '/// @notice Anyone can call the function updateDemurrageReporter() to keep this contract updated to the lastest day. The more often this function is called the more accurate the estimate will be (but it can only be updated at most every 24hrs)\n', 'contract DgxDemurrageReporter is DgxDemurrageCalculator, Claimable, DigixConstants {\n', '  address[] public exempted_accounts;\n', '  uint256 public last_demurrageable_balance; // the total balance of DGX in non-exempted accounts, at last_payment_timestamp\n', '  uint256 public last_payment_timestamp;  // the last time this contract is updated\n', '  uint256 public culmulative_demurrage_collected; // this is the estimate of the demurrage fees that would have been collected from start_of_report_period to last_payment_timestamp\n', '  uint256 public start_of_report_period; // the timestamp when this contract started keeping track of demurrage fees\n', '\n', '  using Types for Types.MutableTimestamp;\n', '\n', '  function DgxDemurrageReporter(address _token_address, address _token_information_address) public DgxDemurrageCalculator(_token_address, _token_information_address)\n', '  {\n', '    address[3] memory _collectors;\n', '    _collectors = token_information().showCollectorsAddresses();\n', '    exempted_accounts.push(_collectors[0]);\n', '    exempted_accounts.push(_collectors[1]);\n', '    exempted_accounts.push(_collectors[2]);\n', '\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_DEMURRAGE_FEES_DISTRIBUTOR));\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_RECAST_FEES_DISTRIBUTOR));\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_TRANSFER_FEES_DISTRIBUTOR));\n', '\n', '    exempted_accounts.push(token_information().get_contract(CONTRACT_STORAGE_MARKETPLACE));\n', '    start_of_report_period = now;\n', '    last_payment_timestamp = now;\n', '    updateDemurrageReporter();\n', '  }\n', '\n', '  function addExemptedAccount(address _account) public onlyOwner {\n', '    exempted_accounts.push(_account);\n', '  }\n', '\n', '  function updateDemurrageReporter() public {\n', '    Types.MutableTimestamp memory payment_timestamp;\n', '    payment_timestamp.time.pre = last_payment_timestamp;\n', '    payment_timestamp = payment_timestamp.advance_by(1 days);\n', '\n', '    uint256 _base;\n', '    uint256 _rate;\n', '    (_base, _rate,,) = token_information().showDemurrageConfigs();\n', '\n', '    culmulative_demurrage_collected += (payment_timestamp.in_units * last_demurrageable_balance * _rate) / _base;\n', '    last_payment_timestamp = payment_timestamp.time.post;\n', '    last_demurrageable_balance = getDemurrageableBalance();\n', '  }\n', '\n', '  function getDemurrageableBalance() internal view returns (uint256 _last_demurrageable_balance) {\n', '    Token token = Token(TOKEN_ADDRESS);\n', '    uint256 _total_supply = token.totalSupply();\n', '    uint256 _no_demurrage_balance = 0;\n', '    for (uint256 i=0;i<exempted_accounts.length;i++) {\n', '      _no_demurrage_balance += token.balanceOf(exempted_accounts[i]);\n', '    }\n', '    _last_demurrageable_balance = _total_supply - _no_demurrage_balance;\n', '  }\n', '\n', '}']
