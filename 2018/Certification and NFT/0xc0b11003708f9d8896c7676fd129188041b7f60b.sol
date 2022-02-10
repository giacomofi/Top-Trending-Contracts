['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract Whitelist is Ownable {\n', '\n', '  address public opsAddress;\n', '  mapping(address => uint8) public whitelist;\n', '\n', '  event WhitelistUpdated(address indexed _account, uint8 _phase);\n', '\n', '  function isWhitelisted(address _account) public constant returns (bool) {\n', '      return whitelist[_account] == 1;\n', '  }\n', '\n', '  /**\n', ' *  @notice function to whitelist an address which can be called only by the ops address.\n', ' *\n', ' *  @param _account account address to be whitelisted\n', ' *  @param _phase 0: unwhitelisted, 1: whitelisted\n', '\n', ' *\n', ' *  @return bool address is successfully whitelisted/unwhitelisted.\n', ' */\n', 'function updateWhitelist(\n', '    address _account,\n', '    uint8 _phase) public\n', '    returns (bool)\n', '{\n', '    require(_account != address(0));\n', '    require(_phase <= 1);\n', '    require(isOps(msg.sender));\n', '\n', '    whitelist[_account] = _phase;\n', '\n', '    emit WhitelistUpdated(_account, _phase);\n', '\n', '    return true;\n', '}\n', '\n', '\n', '  /** Internal Functions */\n', '  /**\n', '   *  @notice checks If the sender is the owner of the contract.\n', '   *\n', '   *  @param _address address to be checked if valid owner or not.\n', '   *\n', '   *  @return bool valid owner or not.\n', '   */\n', '  function isOwner(\n', '      address _address)\n', '      internal\n', '      view\n', '      returns (bool)\n', '  {\n', '      return (_address == owner);\n', '  }\n', '  /**\n', '   *  @notice check If the sender is the ops address.\n', '   *\n', '   *  @param _address address to be checked for ops.\n', '   *\n', '   *  @return bool valid ops or not.\n', '   */\n', '  function isOps(\n', '      address _address)\n', '      internal\n', '      view\n', '      returns (bool)\n', '  {\n', '      return (opsAddress != address(0) && _address == opsAddress) || isOwner(_address);\n', '  }\n', '\n', '  /** External Functions */\n', '\n', '  /**\n', '   *  @notice Owner can change the verified operator address.\n', '   *\n', '   *  @param _opsAddress address to be set as ops.\n', '   *\n', '   *  @return bool address is successfully set as ops or not.\n', '   */\n', '  function setOpsAddress(\n', '      address _opsAddress)\n', '      external\n', '      onlyOwner\n', '      returns (bool)\n', '  {\n', '      require(_opsAddress != owner);\n', '      require(_opsAddress != address(this));\n', '      require(_opsAddress != address(0));\n', '\n', '      opsAddress = _opsAddress;\n', '\n', '      return true;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract Whitelist is Ownable {\n', '\n', '  address public opsAddress;\n', '  mapping(address => uint8) public whitelist;\n', '\n', '  event WhitelistUpdated(address indexed _account, uint8 _phase);\n', '\n', '  function isWhitelisted(address _account) public constant returns (bool) {\n', '      return whitelist[_account] == 1;\n', '  }\n', '\n', '  /**\n', ' *  @notice function to whitelist an address which can be called only by the ops address.\n', ' *\n', ' *  @param _account account address to be whitelisted\n', ' *  @param _phase 0: unwhitelisted, 1: whitelisted\n', '\n', ' *\n', ' *  @return bool address is successfully whitelisted/unwhitelisted.\n', ' */\n', 'function updateWhitelist(\n', '    address _account,\n', '    uint8 _phase) public\n', '    returns (bool)\n', '{\n', '    require(_account != address(0));\n', '    require(_phase <= 1);\n', '    require(isOps(msg.sender));\n', '\n', '    whitelist[_account] = _phase;\n', '\n', '    emit WhitelistUpdated(_account, _phase);\n', '\n', '    return true;\n', '}\n', '\n', '\n', '  /** Internal Functions */\n', '  /**\n', '   *  @notice checks If the sender is the owner of the contract.\n', '   *\n', '   *  @param _address address to be checked if valid owner or not.\n', '   *\n', '   *  @return bool valid owner or not.\n', '   */\n', '  function isOwner(\n', '      address _address)\n', '      internal\n', '      view\n', '      returns (bool)\n', '  {\n', '      return (_address == owner);\n', '  }\n', '  /**\n', '   *  @notice check If the sender is the ops address.\n', '   *\n', '   *  @param _address address to be checked for ops.\n', '   *\n', '   *  @return bool valid ops or not.\n', '   */\n', '  function isOps(\n', '      address _address)\n', '      internal\n', '      view\n', '      returns (bool)\n', '  {\n', '      return (opsAddress != address(0) && _address == opsAddress) || isOwner(_address);\n', '  }\n', '\n', '  /** External Functions */\n', '\n', '  /**\n', '   *  @notice Owner can change the verified operator address.\n', '   *\n', '   *  @param _opsAddress address to be set as ops.\n', '   *\n', '   *  @return bool address is successfully set as ops or not.\n', '   */\n', '  function setOpsAddress(\n', '      address _opsAddress)\n', '      external\n', '      onlyOwner\n', '      returns (bool)\n', '  {\n', '      require(_opsAddress != owner);\n', '      require(_opsAddress != address(this));\n', '      require(_opsAddress != address(0));\n', '\n', '      opsAddress = _opsAddress;\n', '\n', '      return true;\n', '  }\n', '\n', '}']