['/* Author: Victor Mezrin  victor@mezrin.com */\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/**\n', ' * @title CommonModifiers\n', ' * @dev Base contract which contains common checks.\n', ' */\n', 'contract CommonModifiersInterface {\n', '\n', '  /**\n', '   * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '   */\n', '  function isContract(address _targetAddress) internal constant returns (bool);\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the _targetAddress is a contract.\n', '   */\n', '  modifier onlyContractAddress(address _targetAddress) {\n', '    require(isContract(_targetAddress) == true);\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title CommonModifiers\n', ' * @dev Base contract which contains common checks.\n', ' */\n', 'contract CommonModifiers is CommonModifiersInterface {\n', '\n', '  /**\n', '   * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '   */\n', '  function isContract(address _targetAddress) internal constant returns (bool) {\n', '    require (_targetAddress != address(0x0));\n', '\n', '    uint256 length;\n', '    assembly {\n', '      //retrieve the size of the code on target address, this needs assembly\n', '      length := extcodesize(_targetAddress)\n', '    }\n', '    return (length > 0);\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title AssetIDInterface\n', ' * @dev Interface of a contract that assigned to an asset (JNT, jUSD etc.)\n', ' * @dev Contracts for the same asset (like JNT, jUSD etc.) will have the same AssetID.\n', ' * @dev This will help to avoid misconfiguration of contracts\n', ' */\n', 'contract AssetIDInterface {\n', '  function getAssetID() public constant returns (string);\n', '  function getAssetIDHash() public constant returns (bytes32);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title AssetID\n', ' * @dev Base contract implementing AssetIDInterface\n', ' */\n', 'contract AssetID is AssetIDInterface {\n', '\n', '  /* Storage */\n', '\n', '  string assetID;\n', '\n', '\n', '  /* Constructor */\n', '\n', '  function AssetID(string _assetID) public {\n', '    require(bytes(_assetID).length > 0);\n', '\n', '    assetID = _assetID;\n', '  }\n', '\n', '\n', '  /* Getters */\n', '\n', '  function getAssetID() public constant returns (string) {\n', '    return assetID;\n', '  }\n', '\n', '  function getAssetIDHash() public constant returns (bytes32) {\n', '    return keccak256(assetID);\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract OwnableInterface {\n', '\n', '  /**\n', '   * @dev The getter for "owner" contract variable\n', '   */\n', '  function getOwner() public constant returns (address);\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the current owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require (msg.sender == getOwner());\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable is OwnableInterface {\n', '\n', '  /* Storage */\n', '\n', '  address owner = address(0x0);\n', '  address proposedOwner = address(0x0);\n', '\n', '\n', '  /* Events */\n', '\n', '  event OwnerAssignedEvent(address indexed newowner);\n', '  event OwnershipOfferCreatedEvent(address indexed currentowner, address indexed proposedowner);\n', '  event OwnershipOfferAcceptedEvent(address indexed currentowner, address indexed proposedowner);\n', '  event OwnershipOfferCancelledEvent(address indexed currentowner, address indexed proposedowner);\n', '\n', '\n', '  /**\n', '   * @dev The constructor sets the initial `owner` to the passed account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '\n', '    OwnerAssignedEvent(owner);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Old owner requests transfer ownership to the new owner.\n', '   * @param _proposedOwner The address to transfer ownership to.\n', '   */\n', '  function createOwnershipOffer(address _proposedOwner) external onlyOwner {\n', '    require (proposedOwner == address(0x0));\n', '    require (_proposedOwner != address(0x0));\n', '    require (_proposedOwner != address(this));\n', '\n', '    proposedOwner = _proposedOwner;\n', '\n', '    OwnershipOfferCreatedEvent(owner, _proposedOwner);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the new owner to accept an ownership offer to contract control.\n', '   */\n', '  //noinspection UnprotectedFunction\n', '  function acceptOwnershipOffer() external {\n', '    require (proposedOwner != address(0x0));\n', '    require (msg.sender == proposedOwner);\n', '\n', '    address _oldOwner = owner;\n', '    owner = proposedOwner;\n', '    proposedOwner = address(0x0);\n', '\n', '    OwnerAssignedEvent(owner);\n', '    OwnershipOfferAcceptedEvent(_oldOwner, owner);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Old owner cancels transfer ownership to the new owner.\n', '   */\n', '  function cancelOwnershipOffer() external {\n', '    require (proposedOwner != address(0x0));\n', '    require (msg.sender == owner || msg.sender == proposedOwner);\n', '\n', '    address _oldProposedOwner = proposedOwner;\n', '    proposedOwner = address(0x0);\n', '\n', '    OwnershipOfferCancelledEvent(owner, _oldProposedOwner);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev The getter for "owner" contract variable\n', '   */\n', '  function getOwner() public constant returns (address) {\n', '    return owner;\n', '  }\n', '\n', '  /**\n', '   * @dev The getter for "proposedOwner" contract variable\n', '   */\n', '  function getProposedOwner() public constant returns (address) {\n', '    return proposedOwner;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ManageableInterface\n', ' * @dev Contract that allows to grant permissions to any address\n', ' * @dev In real life we are no able to perform all actions with just one Ethereum address\n', ' * @dev because risks are too high.\n', ' * @dev Instead owner delegates rights to manage an contract to the different addresses and\n', ' * @dev stay able to revoke permissions at any time.\n', ' */\n', 'contract ManageableInterface {\n', '\n', '  /**\n', '   * @dev Function to check if the manager can perform the action or not\n', '   * @param _manager        address Manager`s address\n', '   * @param _permissionName string  Permission name\n', '   * @return True if manager is enabled and has been granted needed permission\n', '   */\n', '  function isManagerAllowed(address _manager, string _permissionName) public constant returns (bool);\n', '\n', '  /**\n', '   * @dev Modifier to use in derived contracts\n', '   */\n', '  modifier onlyAllowedManager(string _permissionName) {\n', '    require(isManagerAllowed(msg.sender, _permissionName) == true);\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract Manageable is OwnableInterface,\n', '                       ManageableInterface {\n', '\n', '  /* Storage */\n', '\n', '  mapping (address => bool) managerEnabled;  // hard switch for a manager - on/off\n', '  mapping (address => mapping (string => bool)) managerPermissions;  // detailed info about manager`s permissions\n', '\n', '\n', '  /* Events */\n', '\n', '  event ManagerEnabledEvent(address indexed manager);\n', '  event ManagerDisabledEvent(address indexed manager);\n', '  event ManagerPermissionGrantedEvent(address indexed manager, string permission);\n', '  event ManagerPermissionRevokedEvent(address indexed manager, string permission);\n', '\n', '\n', '  /* Configure contract */\n', '\n', '  /**\n', '   * @dev Function to add new manager\n', '   * @param _manager address New manager\n', '   */\n', '  function enableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {\n', '    require(managerEnabled[_manager] == false);\n', '\n', '    managerEnabled[_manager] = true;\n', '    ManagerEnabledEvent(_manager);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to remove existing manager\n', '   * @param _manager address Existing manager\n', '   */\n', '  function disableManager(address _manager) external onlyOwner onlyValidManagerAddress(_manager) {\n', '    require(managerEnabled[_manager] == true);\n', '\n', '    managerEnabled[_manager] = false;\n', '    ManagerDisabledEvent(_manager);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to grant new permission to the manager\n', '   * @param _manager        address Existing manager\n', '   * @param _permissionName string  Granted permission name\n', '   */\n', '  function grantManagerPermission(\n', '    address _manager, string _permissionName\n', '  )\n', '    external\n', '    onlyOwner\n', '    onlyValidManagerAddress(_manager)\n', '    onlyValidPermissionName(_permissionName)\n', '  {\n', '    require(managerPermissions[_manager][_permissionName] == false);\n', '\n', '    managerPermissions[_manager][_permissionName] = true;\n', '    ManagerPermissionGrantedEvent(_manager, _permissionName);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to revoke permission of the manager\n', '   * @param _manager        address Existing manager\n', '   * @param _permissionName string  Revoked permission name\n', '   */\n', '  function revokeManagerPermission(\n', '    address _manager, string _permissionName\n', '  )\n', '    external\n', '    onlyOwner\n', '    onlyValidManagerAddress(_manager)\n', '    onlyValidPermissionName(_permissionName)\n', '  {\n', '    require(managerPermissions[_manager][_permissionName] == true);\n', '\n', '    managerPermissions[_manager][_permissionName] = false;\n', '    ManagerPermissionRevokedEvent(_manager, _permissionName);\n', '  }\n', '\n', '\n', '  /* Getters */\n', '\n', '  /**\n', '   * @dev Function to check manager status\n', '   * @param _manager address Manager`s address\n', '   * @return True if manager is enabled\n', '   */\n', '  function isManagerEnabled(\n', '    address _manager\n', '  )\n', '    public\n', '    constant\n', '    onlyValidManagerAddress(_manager)\n', '    returns (bool)\n', '  {\n', '    return managerEnabled[_manager];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check permissions of a manager\n', '   * @param _manager        address Manager`s address\n', '   * @param _permissionName string  Permission name\n', '   * @return True if manager has been granted needed permission\n', '   */\n', '  function isPermissionGranted(\n', '    address _manager, string _permissionName\n', '  )\n', '    public\n', '    constant\n', '    onlyValidManagerAddress(_manager)\n', '    onlyValidPermissionName(_permissionName)\n', '    returns (bool)\n', '  {\n', '    return managerPermissions[_manager][_permissionName];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check if the manager can perform the action or not\n', '   * @param _manager        address Manager`s address\n', '   * @param _permissionName string  Permission name\n', '   * @return True if manager is enabled and has been granted needed permission\n', '   */\n', '  function isManagerAllowed(\n', '    address _manager, string _permissionName\n', '  )\n', '    public\n', '    constant\n', '    onlyValidManagerAddress(_manager)\n', '    onlyValidPermissionName(_permissionName)\n', '    returns (bool)\n', '  {\n', '    return (managerEnabled[_manager] && managerPermissions[_manager][_permissionName]);\n', '  }\n', '\n', '\n', '  /* Helpers */\n', '\n', '  /**\n', '   * @dev Modifier to check manager address\n', '   */\n', '  modifier onlyValidManagerAddress(address _manager) {\n', '    require(_manager != address(0x0));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to check name of manager permission\n', '   */\n', '  modifier onlyValidPermissionName(string _permissionName) {\n', '    require(bytes(_permissionName).length != 0);\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title PausableInterface\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', " * @dev Based on zeppelin's Pausable, but integrated with Manageable\n", ' * @dev Contract is in paused state by default and should be explicitly unlocked\n', ' */\n', 'contract PausableInterface {\n', '\n', '  /**\n', '   * Events\n', '   */\n', '\n', '  event PauseEvent();\n', '  event UnpauseEvent();\n', '\n', '\n', '  /**\n', '   * @dev called by the manager to pause, triggers stopped state\n', '   */\n', '  function pauseContract() public;\n', '\n', '  /**\n', '   * @dev called by the manager to unpause, returns to normal state\n', '   */\n', '  function unpauseContract() public;\n', '\n', '  /**\n', '   * @dev The getter for "paused" contract variable\n', '   */\n', '  function getPaused() public constant returns (bool);\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenContractNotPaused() {\n', '    require(getPaused() == false);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenContractPaused {\n', '    require(getPaused() == true);\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', " * @dev Based on zeppelin's Pausable, but integrated with Manageable\n", ' * @dev Contract is in paused state by default and should be explicitly unlocked\n', ' */\n', 'contract Pausable is ManageableInterface,\n', '                     PausableInterface {\n', '\n', '  /**\n', '   * Storage\n', '   */\n', '\n', '  bool paused = true;\n', '\n', '\n', '  /**\n', '   * @dev called by the manager to pause, triggers stopped state\n', '   */\n', "  function pauseContract() public onlyAllowedManager('pause_contract') whenContractNotPaused {\n", '    paused = true;\n', '    PauseEvent();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the manager to unpause, returns to normal state\n', '   */\n', "  function unpauseContract() public onlyAllowedManager('unpause_contract') whenContractPaused {\n", '    paused = false;\n', '    UnpauseEvent();\n', '  }\n', '\n', '  /**\n', '   * @dev The getter for "paused" contract variable\n', '   */\n', '  function getPaused() public constant returns (bool) {\n', '    return paused;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title BytecodeExecutorInterface interface\n', ' * @dev Implementation of a contract that execute any bytecode on behalf of the contract\n', ' * @dev Last resort for the immutable and not-replaceable contract :)\n', ' */\n', 'contract BytecodeExecutorInterface {\n', '\n', '  /* Events */\n', '\n', '  event CallExecutedEvent(address indexed target,\n', '                          uint256 suppliedGas,\n', '                          uint256 ethValue,\n', '                          bytes32 transactionBytecodeHash);\n', '  event DelegatecallExecutedEvent(address indexed target,\n', '                                  uint256 suppliedGas,\n', '                                  bytes32 transactionBytecodeHash);\n', '\n', '\n', '  /* Functions */\n', '\n', '  function executeCall(address _target, uint256 _suppliedGas, uint256 _ethValue, bytes _transactionBytecode) external;\n', '  function executeDelegatecall(address _target, uint256 _suppliedGas, bytes _transactionBytecode) external;\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title BytecodeExecutor\n', ' * @dev Implementation of a contract that execute any bytecode on behalf of the contract\n', ' * @dev Last resort for the immutable and not-replaceable contract :)\n', ' */\n', 'contract BytecodeExecutor is ManageableInterface,\n', '                             BytecodeExecutorInterface {\n', '\n', '  /* Storage */\n', '\n', '  bool underExecution = false;\n', '\n', '\n', '  /* BytecodeExecutorInterface */\n', '\n', '  function executeCall(\n', '    address _target,\n', '    uint256 _suppliedGas,\n', '    uint256 _ethValue,\n', '    bytes _transactionBytecode\n', '  )\n', '    external\n', "    onlyAllowedManager('execute_call')\n", '  {\n', '    require(underExecution == false);\n', '\n', '    underExecution = true; // Avoid recursive calling\n', '    _target.call.gas(_suppliedGas).value(_ethValue)(_transactionBytecode);\n', '    underExecution = false;\n', '\n', '    CallExecutedEvent(_target, _suppliedGas, _ethValue, keccak256(_transactionBytecode));\n', '  }\n', '\n', '  function executeDelegatecall(\n', '    address _target,\n', '    uint256 _suppliedGas,\n', '    bytes _transactionBytecode\n', '  )\n', '    external\n', "    onlyAllowedManager('execute_delegatecall')\n", '  {\n', '    require(underExecution == false);\n', '\n', '    underExecution = true; // Avoid recursive calling\n', '    _target.delegatecall.gas(_suppliedGas)(_transactionBytecode);\n', '    underExecution = false;\n', '\n', '    DelegatecallExecutedEvent(_target, _suppliedGas, keccak256(_transactionBytecode));\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title CrydrControllerERC20Interface interface\n', ' * @dev Interface of a contract that implement business-logic of an ERC20 CryDR\n', ' */\n', 'contract CrydrControllerERC20Interface {\n', '\n', '  /* ERC20 support. _msgsender - account that invoked CrydrView */\n', '\n', '  function transfer(address _msgsender, address _to, uint256 _value) public;\n', '  function getTotalSupply() public constant returns (uint256);\n', '  function getBalance(address _owner) public constant returns (uint256);\n', '\n', '  function approve(address _msgsender, address _spender, uint256 _value) public;\n', '  function transferFrom(address _msgsender, address _from, address _to, uint256 _value) public;\n', '  function getAllowance(address _owner, address _spender) public constant returns (uint256);\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract CrydrViewBaseInterface {\n', '\n', '  /* Events */\n', '\n', '  event CrydrControllerChangedEvent(address indexed crydrcontroller);\n', '\n', '\n', '  /* Configuration */\n', '\n', '  function setCrydrController(address _crydrController) external;\n', '  function getCrydrController() public constant returns (address);\n', '\n', '  function getCrydrViewStandardName() public constant returns (string);\n', '  function getCrydrViewStandardNameHash() public constant returns (bytes32);\n', '}\n', '\n', '\n', '\n', 'contract CrydrViewBase is CommonModifiersInterface,\n', '                          AssetIDInterface,\n', '                          ManageableInterface,\n', '                          PausableInterface,\n', '                          CrydrViewBaseInterface {\n', '\n', '  /* Storage */\n', '\n', '  address crydrController = address(0x0);\n', "  string crydrViewStandardName = '';\n", '\n', '\n', '  /* Constructor */\n', '\n', '  function CrydrViewBase(string _crydrViewStandardName) public {\n', '    require(bytes(_crydrViewStandardName).length > 0);\n', '\n', '    crydrViewStandardName = _crydrViewStandardName;\n', '  }\n', '\n', '\n', '  /* CrydrViewBaseInterface */\n', '\n', '  function setCrydrController(\n', '    address _crydrController\n', '  )\n', '    external\n', '    onlyContractAddress(_crydrController)\n', "    onlyAllowedManager('set_crydr_controller')\n", '    whenContractPaused\n', '  {\n', '    require(crydrController != _crydrController);\n', '\n', '    crydrController = _crydrController;\n', '    CrydrControllerChangedEvent(_crydrController);\n', '  }\n', '\n', '  function getCrydrController() public constant returns (address) {\n', '    return crydrController;\n', '  }\n', '\n', '\n', '  function getCrydrViewStandardName() public constant returns (string) {\n', '    return crydrViewStandardName;\n', '  }\n', '\n', '  function getCrydrViewStandardNameHash() public constant returns (bytes32) {\n', '    return keccak256(crydrViewStandardName);\n', '  }\n', '\n', '\n', '  /* PausableInterface */\n', '\n', '  /**\n', '   * @dev Override method to ensure that contract properly configured before it is unpaused\n', '   */\n', '  function unpauseContract() public {\n', '    require(isContract(crydrController) == true);\n', '    require(getAssetIDHash() == AssetIDInterface(crydrController).getAssetIDHash());\n', '\n', '    super.unpauseContract();\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title CrydrViewERC20Interface\n', ' * @dev ERC20 interface to use in applications\n', ' */\n', 'contract CrydrViewERC20Interface {\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '  function totalSupply() external constant returns (uint256);\n', '  function balanceOf(address _owner) external constant returns (uint256);\n', '\n', '  function approve(address _spender, uint256 _value) external returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '  function allowance(address _owner, address _spender) external constant returns (uint256);\n', '}\n', '\n', '\n', '\n', 'contract CrydrViewERC20 is PausableInterface,\n', '                           CrydrViewBaseInterface,\n', '                           CrydrViewERC20Interface {\n', '\n', '  /* ERC20Interface */\n', '\n', '  function transfer(\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    whenContractNotPaused\n', '    onlyPayloadSize(2 * 32)\n', '    returns (bool)\n', '  {\n', '    CrydrControllerERC20Interface(getCrydrController()).transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function totalSupply() external constant returns (uint256) {\n', '    return CrydrControllerERC20Interface(getCrydrController()).getTotalSupply();\n', '  }\n', '\n', '  function balanceOf(address _owner) external constant onlyPayloadSize(1 * 32) returns (uint256) {\n', '    return CrydrControllerERC20Interface(getCrydrController()).getBalance(_owner);\n', '  }\n', '\n', '\n', '  function approve(\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    external\n', '    whenContractNotPaused\n', '    onlyPayloadSize(2 * 32)\n', '    returns (bool)\n', '  {\n', '    CrydrControllerERC20Interface(getCrydrController()).approve(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '    whenContractNotPaused\n', '    onlyPayloadSize(3 * 32)\n', '    returns (bool)\n', '  {\n', '    CrydrControllerERC20Interface(getCrydrController()).transferFrom(msg.sender, _from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '  )\n', '    external\n', '    constant\n', '    onlyPayloadSize(2 * 32)\n', '    returns (uint256)\n', '  {\n', '    return CrydrControllerERC20Interface(getCrydrController()).getAllowance(_owner, _spender);\n', '  }\n', '\n', '\n', '  /* Helpers */\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint256 size) {\n', '    require(msg.data.length == (size + 4));\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title CrydrViewERC20LoggableInterface\n', ' * @dev Contract is able to create Transfer/Approval events with the cal from controller\n', ' */\n', 'contract CrydrViewERC20LoggableInterface {\n', '\n', '  function emitTransferEvent(address _from, address _to, uint256 _value) external;\n', '  function emitApprovalEvent(address _owner, address _spender, uint256 _value) external;\n', '}\n', '\n', '\n', '\n', 'contract CrydrViewERC20Loggable is PausableInterface,\n', '                                   CrydrViewBaseInterface,\n', '                                   CrydrViewERC20Interface,\n', '                                   CrydrViewERC20LoggableInterface {\n', '\n', '  function emitTransferEvent(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    external\n', '  {\n', '    require(msg.sender == getCrydrController());\n', '\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function emitApprovalEvent(\n', '    address _owner,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    external\n', '  {\n', '    require(msg.sender == getCrydrController());\n', '\n', '    Approval(_owner, _spender, _value);\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title CrydrViewERC20MintableInterface\n', ' * @dev Contract is able to create Mint/Burn events with the cal from controller\n', ' */\n', 'contract CrydrViewERC20MintableInterface {\n', '  event MintEvent(address indexed owner, uint256 value);\n', '  event BurnEvent(address indexed owner, uint256 value);\n', '\n', '  function emitMintEvent(address _owner, uint256 _value) external;\n', '  function emitBurnEvent(address _owner, uint256 _value) external;\n', '}\n', '\n', '\n', '\n', 'contract CrydrViewERC20Mintable is PausableInterface,\n', '                                   CrydrViewBaseInterface,\n', '                                   CrydrViewERC20MintableInterface {\n', '\n', '  function emitMintEvent(\n', '    address _owner,\n', '    uint256 _value\n', '  )\n', '    external\n', '  {\n', '    require(msg.sender == getCrydrController());\n', '\n', '    MintEvent(_owner, _value);\n', '  }\n', '\n', '  function emitBurnEvent(\n', '    address _owner,\n', '    uint256 _value\n', '  )\n', '    external\n', '  {\n', '    require(msg.sender == getCrydrController());\n', '\n', '    BurnEvent(_owner, _value);\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title CrydrViewERC20NamedInterface\n', ' * @dev Contract is able to set name/symbol/decimals\n', ' */\n', 'contract CrydrViewERC20NamedInterface {\n', '\n', '  function name() external constant returns (string);\n', '  function symbol() external constant returns (string);\n', '  function decimals() external constant returns (uint8);\n', '\n', '  function getNameHash() external constant returns (bytes32);\n', '  function getSymbolHash() external constant returns (bytes32);\n', '\n', '  function setName(string _name) external;\n', '  function setSymbol(string _symbol) external;\n', '  function setDecimals(uint8 _decimals) external;\n', '}\n', '\n', '\n', '\n', 'contract CrydrViewERC20Named is ManageableInterface,\n', '                                PausableInterface,\n', '                                CrydrViewERC20NamedInterface {\n', '\n', '  /* Storage */\n', '\n', "  string tokenName = '';\n", "  string tokenSymbol = '';\n", '  uint8 tokenDecimals = 0;\n', '\n', '\n', '  /* Constructor */\n', '\n', '  function CrydrViewERC20Named(string _name, string _symbol, uint8 _decimals) public {\n', '    require(bytes(_name).length > 0);\n', '    require(bytes(_symbol).length > 0);\n', '\n', '    tokenName = _name;\n', '    tokenSymbol = _symbol;\n', '    tokenDecimals = _decimals;\n', '  }\n', '\n', '\n', '  /* CrydrViewERC20NamedInterface */\n', '\n', '  function name() external constant returns (string) {\n', '    return tokenName;\n', '  }\n', '\n', '  function symbol() external constant returns (string) {\n', '    return tokenSymbol;\n', '  }\n', '\n', '  function decimals() external constant returns (uint8) {\n', '    return tokenDecimals;\n', '  }\n', '\n', '\n', '  function getNameHash() external constant returns (bytes32){\n', '    return keccak256(tokenName);\n', '  }\n', '\n', '  function getSymbolHash() external constant returns (bytes32){\n', '    return keccak256(tokenSymbol);\n', '  }\n', '\n', '\n', '  function setName(\n', '    string _name\n', '  )\n', '    external\n', '    whenContractPaused\n', "    onlyAllowedManager('set_crydr_name')\n", '  {\n', '    require(bytes(_name).length > 0);\n', '\n', '    tokenName = _name;\n', '  }\n', '\n', '  function setSymbol(\n', '    string _symbol\n', '  )\n', '    external\n', '    whenContractPaused\n', "    onlyAllowedManager('set_crydr_symbol')\n", '  {\n', '    require(bytes(_symbol).length > 0);\n', '\n', '    tokenSymbol = _symbol;\n', '  }\n', '\n', '  function setDecimals(\n', '    uint8 _decimals\n', '  )\n', '    external\n', '    whenContractPaused\n', "    onlyAllowedManager('set_crydr_decimals')\n", '  {\n', '    tokenDecimals = _decimals;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract JCashCrydrViewERC20 is CommonModifiers,\n', '                                AssetID,\n', '                                Ownable,\n', '                                Manageable,\n', '                                Pausable,\n', '                                BytecodeExecutor,\n', '                                CrydrViewBase,\n', '                                CrydrViewERC20,\n', '                                CrydrViewERC20Loggable,\n', '                                CrydrViewERC20Mintable,\n', '                                CrydrViewERC20Named {\n', '\n', '  function JCashCrydrViewERC20(string _assetID, string _name, string _symbol, uint8 _decimals)\n', '    public\n', '    AssetID(_assetID)\n', "    CrydrViewBase('erc20')\n", '    CrydrViewERC20Named(_name, _symbol, _decimals)\n', '  { }\n', '}\n', '\n', '\n', '\n', 'contract JNTViewERC20 is JCashCrydrViewERC20 {\n', "  function JNTViewERC20() public JCashCrydrViewERC20('JNT', 'Jibrel Network Token', 'JNT', 18) {}\n", '}']