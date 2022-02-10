['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/UidCheckerInterface.sol\n', '\n', 'interface UidCheckerInterface {\n', '\n', '  function isUid(\n', '    string _uid\n', '  )\n', '  public\n', '  pure returns (bool);\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol\n', '\n', '/**\n', ' * @title Contracts that should not own Ether\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up\n', ' * in the contract, it will allow the owner to reclaim this ether.\n', ' * @notice Ether can still be send to this contract by:\n', ' * calling functions labeled `payable`\n', ' * `selfdestruct(contract_address)`\n', ' * mining directly to the contract address\n', '*/\n', 'contract HasNoEther is Ownable {\n', '\n', '  /**\n', '  * @dev Constructor that rejects incoming Ether\n', '  * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '  * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '  * we could use assembly to access msg.value.\n', '  */\n', '  function HasNoEther() public payable {\n', '    require(msg.value == 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Disallows direct send by settings a default function without the `payable` flag.\n', '   */\n', '  function() external {\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer all Ether held by the contract to the owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    assert(owner.send(this.balance));\n', '  }\n', '}\n', '\n', '// File: contracts/Datastore.sol\n', '\n', '/**\n', ' * @title Store\n', ' * @author Francesco Sullo <francesco@sullo.co>\n', ' * @dev It store the tweedentities related to the app\n', ' */\n', '\n', '\n', '\n', 'contract Datastore\n', 'is HasNoEther\n', '{\n', '\n', '  string public fromVersion = "1.0.0";\n', '\n', '  uint public appId;\n', '  string public appNickname;\n', '\n', '  uint public identities;\n', '\n', '  address public manager;\n', '  address public newManager;\n', '\n', '  UidCheckerInterface public checker;\n', '\n', '  struct Uid {\n', '    string lastUid;\n', '    uint lastUpdate;\n', '  }\n', '\n', '  struct Address {\n', '    address lastAddress;\n', '    uint lastUpdate;\n', '  }\n', '\n', '  mapping(string => Address) internal __addressByUid;\n', '  mapping(address => Uid) internal __uidByAddress;\n', '\n', '  bool public appSet;\n', '\n', '\n', '\n', '  // events\n', '\n', '\n', '  event AppSet(\n', '    string appNickname,\n', '    uint appId,\n', '    address checker\n', '  );\n', '\n', '\n', '  event ManagerSet(\n', '    address indexed manager,\n', '    bool isNew\n', '  );\n', '\n', '  event ManagerSwitch(\n', '    address indexed oldManager,\n', '    address indexed newManager\n', '  );\n', '\n', '\n', '  event IdentitySet(\n', '    address indexed addr,\n', '    string uid\n', '  );\n', '\n', '\n', '  event IdentityUnset(\n', '    address indexed addr,\n', '    string uid\n', '  );\n', '\n', '\n', '\n', '  // modifiers\n', '\n', '\n', '  modifier onlyManager() {\n', '    require(msg.sender == manager || (newManager != address(0) && msg.sender == newManager));\n', '    _;\n', '  }\n', '\n', '\n', '  modifier whenAppSet() {\n', '    require(appSet);\n', '    _;\n', '  }\n', '\n', '\n', '\n', '  // config\n', '\n', '\n', '  /**\n', '  * @dev Updates the checker for the store\n', '  * @param _address Checker&#39;s address\n', '  */\n', '  function setNewChecker(\n', '    address _address\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(_address != address(0));\n', '    checker = UidCheckerInterface(_address);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets the manager\n', '  * @param _address Manager&#39;s address\n', '  */\n', '  function setManager(\n', '    address _address\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(_address != address(0));\n', '    manager = _address;\n', '    ManagerSet(_address, false);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets new manager\n', '  * @param _address New manager&#39;s address\n', '  */\n', '  function setNewManager(\n', '    address _address\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(_address != address(0) && manager != address(0));\n', '    newManager = _address;\n', '    ManagerSet(_address, true);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets new manager\n', '  */\n', '  function switchManagerAndRemoveOldOne()\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(newManager != address(0));\n', '    ManagerSwitch(manager, newManager);\n', '    manager = newManager;\n', '    newManager = address(0);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets the app\n', '  * @param _appNickname Nickname (e.g. twitter)\n', '  * @param _appId ID (e.g. 1)\n', '  */\n', '  function setApp(\n', '    string _appNickname,\n', '    uint _appId,\n', '    address _checker\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(!appSet);\n', '    require(_appId > 0);\n', '    require(_checker != address(0));\n', '    require(bytes(_appNickname).length > 0);\n', '    appId = _appId;\n', '    appNickname = _appNickname;\n', '    checker = UidCheckerInterface(_checker);\n', '    appSet = true;\n', '    AppSet(_appNickname, _appId, _checker);\n', '  }\n', '\n', '\n', '\n', '  // helpers\n', '\n', '\n', '  /**\n', '   * @dev Checks if a tweedentity is upgradable\n', '   * @param _address The address\n', '   * @param _uid The user-id\n', '   */\n', '  function isUpgradable(\n', '    address _address,\n', '    string _uid\n', '  )\n', '  public\n', '  constant returns (bool)\n', '  {\n', '    if (__addressByUid[_uid].lastAddress != address(0)) {\n', '      return keccak256(getUid(_address)) == keccak256(_uid);\n', '    }\n', '    return true;\n', '  }\n', '\n', '\n', '\n', '  // primary methods\n', '\n', '\n', '  /**\n', '   * @dev Sets a tweedentity\n', '   * @param _address The address of the wallet\n', '   * @param _uid The user-id of the owner user account\n', '   */\n', '  function setIdentity(\n', '    address _address,\n', '    string _uid\n', '  )\n', '  external\n', '  onlyManager\n', '  whenAppSet\n', '  {\n', '    require(_address != address(0));\n', '    require(isUid(_uid));\n', '    require(isUpgradable(_address, _uid));\n', '\n', '    if (bytes(__uidByAddress[_address].lastUid).length > 0) {\n', '      // if _address is associated with an oldUid,\n', '      // this removes the association between _address and oldUid\n', '      __addressByUid[__uidByAddress[_address].lastUid] = Address(address(0), __addressByUid[__uidByAddress[_address].lastUid].lastUpdate);\n', '      identities--;\n', '    }\n', '\n', '    __uidByAddress[_address] = Uid(_uid, now);\n', '    __addressByUid[_uid] = Address(_address, now);\n', '    identities++;\n', '    IdentitySet(_address, _uid);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Unset a tweedentity\n', '   * @param _address The address of the wallet\n', '   */\n', '  function unsetIdentity(\n', '    address _address\n', '  )\n', '  external\n', '  onlyManager\n', '  whenAppSet\n', '  {\n', '    require(_address != address(0));\n', '    require(bytes(__uidByAddress[_address].lastUid).length > 0);\n', '\n', '    string memory uid = __uidByAddress[_address].lastUid;\n', '    __uidByAddress[_address] = Uid(&#39;&#39;, __uidByAddress[_address].lastUpdate);\n', '    __addressByUid[uid] = Address(address(0), __addressByUid[uid].lastUpdate);\n', '    identities--;\n', '    IdentityUnset(_address, uid);\n', '  }\n', '\n', '\n', '\n', '  // getters\n', '\n', '\n', '  /**\n', '   * @dev Returns the keccak256 of the app nickname\n', '   */\n', '  function getAppNickname()\n', '  external\n', '  whenAppSet\n', '  constant returns (bytes32) {\n', '    return keccak256(appNickname);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the appId\n', '   */\n', '  function getAppId()\n', '  external\n', '  whenAppSet\n', '  constant returns (uint) {\n', '    return appId;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the user-id associated to a wallet\n', '   * @param _address The address of the wallet\n', '   */\n', '  function getUid(\n', '    address _address\n', '  )\n', '  public\n', '  constant returns (string)\n', '  {\n', '    return __uidByAddress[_address].lastUid;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the address associated to a user-id\n', '   * @param _uid The user-id\n', '   */\n', '  function getAddress(\n', '    string _uid\n', '  )\n', '  external\n', '  constant returns (address)\n', '  {\n', '    return __addressByUid[_uid].lastAddress;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the timestamp of last update by address\n', '   * @param _address The address of the wallet\n', '   */\n', '  function getAddressLastUpdate(\n', '    address _address\n', '  )\n', '  external\n', '  constant returns (uint)\n', '  {\n', '    return __uidByAddress[_address].lastUpdate;\n', '  }\n', '\n', '\n', '  /**\n', ' * @dev Returns the timestamp of last update by user-id\n', ' * @param _uid The user-id\n', ' */\n', '  function getUidLastUpdate(\n', '    string _uid\n', '  )\n', '  external\n', '  constant returns (uint)\n', '  {\n', '    return __addressByUid[_uid].lastUpdate;\n', '  }\n', '\n', '\n', '\n', '  // utils\n', '\n', '\n', '  function isUid(\n', '    string _uid\n', '  )\n', '  public\n', '  view\n', '  returns (bool)\n', '  {\n', '    return checker.isUid(_uid);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/UidCheckerInterface.sol\n', '\n', 'interface UidCheckerInterface {\n', '\n', '  function isUid(\n', '    string _uid\n', '  )\n', '  public\n', '  pure returns (bool);\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol\n', '\n', '/**\n', ' * @title Contracts that should not own Ether\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up\n', ' * in the contract, it will allow the owner to reclaim this ether.\n', ' * @notice Ether can still be send to this contract by:\n', ' * calling functions labeled `payable`\n', ' * `selfdestruct(contract_address)`\n', ' * mining directly to the contract address\n', '*/\n', 'contract HasNoEther is Ownable {\n', '\n', '  /**\n', '  * @dev Constructor that rejects incoming Ether\n', '  * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '  * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '  * we could use assembly to access msg.value.\n', '  */\n', '  function HasNoEther() public payable {\n', '    require(msg.value == 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Disallows direct send by settings a default function without the `payable` flag.\n', '   */\n', '  function() external {\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer all Ether held by the contract to the owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    assert(owner.send(this.balance));\n', '  }\n', '}\n', '\n', '// File: contracts/Datastore.sol\n', '\n', '/**\n', ' * @title Store\n', ' * @author Francesco Sullo <francesco@sullo.co>\n', ' * @dev It store the tweedentities related to the app\n', ' */\n', '\n', '\n', '\n', 'contract Datastore\n', 'is HasNoEther\n', '{\n', '\n', '  string public fromVersion = "1.0.0";\n', '\n', '  uint public appId;\n', '  string public appNickname;\n', '\n', '  uint public identities;\n', '\n', '  address public manager;\n', '  address public newManager;\n', '\n', '  UidCheckerInterface public checker;\n', '\n', '  struct Uid {\n', '    string lastUid;\n', '    uint lastUpdate;\n', '  }\n', '\n', '  struct Address {\n', '    address lastAddress;\n', '    uint lastUpdate;\n', '  }\n', '\n', '  mapping(string => Address) internal __addressByUid;\n', '  mapping(address => Uid) internal __uidByAddress;\n', '\n', '  bool public appSet;\n', '\n', '\n', '\n', '  // events\n', '\n', '\n', '  event AppSet(\n', '    string appNickname,\n', '    uint appId,\n', '    address checker\n', '  );\n', '\n', '\n', '  event ManagerSet(\n', '    address indexed manager,\n', '    bool isNew\n', '  );\n', '\n', '  event ManagerSwitch(\n', '    address indexed oldManager,\n', '    address indexed newManager\n', '  );\n', '\n', '\n', '  event IdentitySet(\n', '    address indexed addr,\n', '    string uid\n', '  );\n', '\n', '\n', '  event IdentityUnset(\n', '    address indexed addr,\n', '    string uid\n', '  );\n', '\n', '\n', '\n', '  // modifiers\n', '\n', '\n', '  modifier onlyManager() {\n', '    require(msg.sender == manager || (newManager != address(0) && msg.sender == newManager));\n', '    _;\n', '  }\n', '\n', '\n', '  modifier whenAppSet() {\n', '    require(appSet);\n', '    _;\n', '  }\n', '\n', '\n', '\n', '  // config\n', '\n', '\n', '  /**\n', '  * @dev Updates the checker for the store\n', "  * @param _address Checker's address\n", '  */\n', '  function setNewChecker(\n', '    address _address\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(_address != address(0));\n', '    checker = UidCheckerInterface(_address);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets the manager\n', "  * @param _address Manager's address\n", '  */\n', '  function setManager(\n', '    address _address\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(_address != address(0));\n', '    manager = _address;\n', '    ManagerSet(_address, false);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets new manager\n', "  * @param _address New manager's address\n", '  */\n', '  function setNewManager(\n', '    address _address\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(_address != address(0) && manager != address(0));\n', '    newManager = _address;\n', '    ManagerSet(_address, true);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets new manager\n', '  */\n', '  function switchManagerAndRemoveOldOne()\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(newManager != address(0));\n', '    ManagerSwitch(manager, newManager);\n', '    manager = newManager;\n', '    newManager = address(0);\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Sets the app\n', '  * @param _appNickname Nickname (e.g. twitter)\n', '  * @param _appId ID (e.g. 1)\n', '  */\n', '  function setApp(\n', '    string _appNickname,\n', '    uint _appId,\n', '    address _checker\n', '  )\n', '  external\n', '  onlyOwner\n', '  {\n', '    require(!appSet);\n', '    require(_appId > 0);\n', '    require(_checker != address(0));\n', '    require(bytes(_appNickname).length > 0);\n', '    appId = _appId;\n', '    appNickname = _appNickname;\n', '    checker = UidCheckerInterface(_checker);\n', '    appSet = true;\n', '    AppSet(_appNickname, _appId, _checker);\n', '  }\n', '\n', '\n', '\n', '  // helpers\n', '\n', '\n', '  /**\n', '   * @dev Checks if a tweedentity is upgradable\n', '   * @param _address The address\n', '   * @param _uid The user-id\n', '   */\n', '  function isUpgradable(\n', '    address _address,\n', '    string _uid\n', '  )\n', '  public\n', '  constant returns (bool)\n', '  {\n', '    if (__addressByUid[_uid].lastAddress != address(0)) {\n', '      return keccak256(getUid(_address)) == keccak256(_uid);\n', '    }\n', '    return true;\n', '  }\n', '\n', '\n', '\n', '  // primary methods\n', '\n', '\n', '  /**\n', '   * @dev Sets a tweedentity\n', '   * @param _address The address of the wallet\n', '   * @param _uid The user-id of the owner user account\n', '   */\n', '  function setIdentity(\n', '    address _address,\n', '    string _uid\n', '  )\n', '  external\n', '  onlyManager\n', '  whenAppSet\n', '  {\n', '    require(_address != address(0));\n', '    require(isUid(_uid));\n', '    require(isUpgradable(_address, _uid));\n', '\n', '    if (bytes(__uidByAddress[_address].lastUid).length > 0) {\n', '      // if _address is associated with an oldUid,\n', '      // this removes the association between _address and oldUid\n', '      __addressByUid[__uidByAddress[_address].lastUid] = Address(address(0), __addressByUid[__uidByAddress[_address].lastUid].lastUpdate);\n', '      identities--;\n', '    }\n', '\n', '    __uidByAddress[_address] = Uid(_uid, now);\n', '    __addressByUid[_uid] = Address(_address, now);\n', '    identities++;\n', '    IdentitySet(_address, _uid);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Unset a tweedentity\n', '   * @param _address The address of the wallet\n', '   */\n', '  function unsetIdentity(\n', '    address _address\n', '  )\n', '  external\n', '  onlyManager\n', '  whenAppSet\n', '  {\n', '    require(_address != address(0));\n', '    require(bytes(__uidByAddress[_address].lastUid).length > 0);\n', '\n', '    string memory uid = __uidByAddress[_address].lastUid;\n', "    __uidByAddress[_address] = Uid('', __uidByAddress[_address].lastUpdate);\n", '    __addressByUid[uid] = Address(address(0), __addressByUid[uid].lastUpdate);\n', '    identities--;\n', '    IdentityUnset(_address, uid);\n', '  }\n', '\n', '\n', '\n', '  // getters\n', '\n', '\n', '  /**\n', '   * @dev Returns the keccak256 of the app nickname\n', '   */\n', '  function getAppNickname()\n', '  external\n', '  whenAppSet\n', '  constant returns (bytes32) {\n', '    return keccak256(appNickname);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the appId\n', '   */\n', '  function getAppId()\n', '  external\n', '  whenAppSet\n', '  constant returns (uint) {\n', '    return appId;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the user-id associated to a wallet\n', '   * @param _address The address of the wallet\n', '   */\n', '  function getUid(\n', '    address _address\n', '  )\n', '  public\n', '  constant returns (string)\n', '  {\n', '    return __uidByAddress[_address].lastUid;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the address associated to a user-id\n', '   * @param _uid The user-id\n', '   */\n', '  function getAddress(\n', '    string _uid\n', '  )\n', '  external\n', '  constant returns (address)\n', '  {\n', '    return __addressByUid[_uid].lastAddress;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Returns the timestamp of last update by address\n', '   * @param _address The address of the wallet\n', '   */\n', '  function getAddressLastUpdate(\n', '    address _address\n', '  )\n', '  external\n', '  constant returns (uint)\n', '  {\n', '    return __uidByAddress[_address].lastUpdate;\n', '  }\n', '\n', '\n', '  /**\n', ' * @dev Returns the timestamp of last update by user-id\n', ' * @param _uid The user-id\n', ' */\n', '  function getUidLastUpdate(\n', '    string _uid\n', '  )\n', '  external\n', '  constant returns (uint)\n', '  {\n', '    return __addressByUid[_uid].lastUpdate;\n', '  }\n', '\n', '\n', '\n', '  // utils\n', '\n', '\n', '  function isUid(\n', '    string _uid\n', '  )\n', '  public\n', '  view\n', '  returns (bool)\n', '  {\n', '    return checker.isUid(_uid);\n', '  }\n', '\n', '}']