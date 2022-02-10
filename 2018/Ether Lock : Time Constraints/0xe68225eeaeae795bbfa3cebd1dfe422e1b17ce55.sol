['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract Raindrop is Ownable {\n', '\n', '  // Event for when an address is authenticated\n', '  event AuthenticateEvent(\n', '      uint partnerId,\n', '      address indexed from,\n', '      uint value\n', '      );\n', '\n', '  // Event for when an address is whitelisted to authenticate\n', '  event WhitelistEvent(\n', '      uint partnerId,\n', '      address target,\n', '      bool whitelist\n', '      );\n', '\n', '  address public hydroContract = 0x0;\n', '\n', '  mapping (uint => mapping (address => bool)) public whitelist;\n', '  mapping (uint => mapping (address => partnerValues)) public partnerMap;\n', '  mapping (uint => mapping (address => hydroValues)) public hydroPartnerMap;\n', '\n', '  struct partnerValues {\n', '      uint value;\n', '      uint challenge;\n', '  }\n', '\n', '  struct hydroValues {\n', '      uint value;\n', '      uint timestamp;\n', '  }\n', '\n', '  function setHydroContractAddress(address _addr) public onlyOwner {\n', '      hydroContract = _addr;\n', '  }\n', '\n', '  /* Function to whitelist partner address. Can only be called by owner */\n', '  function whitelistAddress(address _target, bool _whitelistBool, uint _partnerId) public onlyOwner {\n', '      whitelist[_partnerId][_target] = _whitelistBool;\n', '      emit WhitelistEvent(_partnerId, _target, _whitelistBool);\n', '  }\n', '\n', '  /* Function to authenticate user\n', '     Restricted to whitelisted partners */\n', '  function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) public {\n', '      require(msg.sender == hydroContract);\n', '      require(whitelist[_partnerId][_sender]);         // Make sure the sender is whitelisted\n', '      require(hydroPartnerMap[_partnerId][_sender].value == _value);\n', '      updatePartnerMap(_sender, _value, _challenge, _partnerId);\n', '      emit AuthenticateEvent(_partnerId, _sender, _value);\n', '  }\n', '\n', '  function checkForValidChallenge(address _sender, uint _partnerId) public view returns (uint value){\n', '      if (hydroPartnerMap[_partnerId][_sender].timestamp > block.timestamp){\n', '          return hydroPartnerMap[_partnerId][_sender].value;\n', '      }\n', '      return 1;\n', '  }\n', '\n', '  /* Function to update the hydroValuesMap. Called exclusively from the Hydro API */\n', '  function updateHydroMap(address _sender, uint _value, uint _partnerId) public onlyOwner {\n', '      hydroPartnerMap[_partnerId][_sender].value = _value;\n', '      hydroPartnerMap[_partnerId][_sender].timestamp = block.timestamp + 1 days;\n', '  }\n', '\n', '  /* Function called by Hydro API to check if the partner has validated\n', '   * The partners value and data must match and it must be less than a day since the last authentication\n', '   */\n', '  function validateAuthentication(address _sender, uint _challenge, uint _partnerId) public constant returns (bool _isValid) {\n', '      if (partnerMap[_partnerId][_sender].value == hydroPartnerMap[_partnerId][_sender].value\n', '      && block.timestamp < hydroPartnerMap[_partnerId][_sender].timestamp\n', '      && partnerMap[_partnerId][_sender].challenge == _challenge) {\n', '          return true;\n', '      }\n', '      return false;\n', '  }\n', '\n', '  /* Function to update the partnerValuesMap with their amount and challenge string */\n', '  function updatePartnerMap(address _sender, uint _value, uint _challenge, uint _partnerId) internal {\n', '      partnerMap[_partnerId][_sender].value = _value;\n', '      partnerMap[_partnerId][_sender].challenge = _challenge;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract Raindrop is Ownable {\n', '\n', '  // Event for when an address is authenticated\n', '  event AuthenticateEvent(\n', '      uint partnerId,\n', '      address indexed from,\n', '      uint value\n', '      );\n', '\n', '  // Event for when an address is whitelisted to authenticate\n', '  event WhitelistEvent(\n', '      uint partnerId,\n', '      address target,\n', '      bool whitelist\n', '      );\n', '\n', '  address public hydroContract = 0x0;\n', '\n', '  mapping (uint => mapping (address => bool)) public whitelist;\n', '  mapping (uint => mapping (address => partnerValues)) public partnerMap;\n', '  mapping (uint => mapping (address => hydroValues)) public hydroPartnerMap;\n', '\n', '  struct partnerValues {\n', '      uint value;\n', '      uint challenge;\n', '  }\n', '\n', '  struct hydroValues {\n', '      uint value;\n', '      uint timestamp;\n', '  }\n', '\n', '  function setHydroContractAddress(address _addr) public onlyOwner {\n', '      hydroContract = _addr;\n', '  }\n', '\n', '  /* Function to whitelist partner address. Can only be called by owner */\n', '  function whitelistAddress(address _target, bool _whitelistBool, uint _partnerId) public onlyOwner {\n', '      whitelist[_partnerId][_target] = _whitelistBool;\n', '      emit WhitelistEvent(_partnerId, _target, _whitelistBool);\n', '  }\n', '\n', '  /* Function to authenticate user\n', '     Restricted to whitelisted partners */\n', '  function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) public {\n', '      require(msg.sender == hydroContract);\n', '      require(whitelist[_partnerId][_sender]);         // Make sure the sender is whitelisted\n', '      require(hydroPartnerMap[_partnerId][_sender].value == _value);\n', '      updatePartnerMap(_sender, _value, _challenge, _partnerId);\n', '      emit AuthenticateEvent(_partnerId, _sender, _value);\n', '  }\n', '\n', '  function checkForValidChallenge(address _sender, uint _partnerId) public view returns (uint value){\n', '      if (hydroPartnerMap[_partnerId][_sender].timestamp > block.timestamp){\n', '          return hydroPartnerMap[_partnerId][_sender].value;\n', '      }\n', '      return 1;\n', '  }\n', '\n', '  /* Function to update the hydroValuesMap. Called exclusively from the Hydro API */\n', '  function updateHydroMap(address _sender, uint _value, uint _partnerId) public onlyOwner {\n', '      hydroPartnerMap[_partnerId][_sender].value = _value;\n', '      hydroPartnerMap[_partnerId][_sender].timestamp = block.timestamp + 1 days;\n', '  }\n', '\n', '  /* Function called by Hydro API to check if the partner has validated\n', '   * The partners value and data must match and it must be less than a day since the last authentication\n', '   */\n', '  function validateAuthentication(address _sender, uint _challenge, uint _partnerId) public constant returns (bool _isValid) {\n', '      if (partnerMap[_partnerId][_sender].value == hydroPartnerMap[_partnerId][_sender].value\n', '      && block.timestamp < hydroPartnerMap[_partnerId][_sender].timestamp\n', '      && partnerMap[_partnerId][_sender].challenge == _challenge) {\n', '          return true;\n', '      }\n', '      return false;\n', '  }\n', '\n', '  /* Function to update the partnerValuesMap with their amount and challenge string */\n', '  function updatePartnerMap(address _sender, uint _value, uint _challenge, uint _partnerId) internal {\n', '      partnerMap[_partnerId][_sender].value = _value;\n', '      partnerMap[_partnerId][_sender].challenge = _challenge;\n', '  }\n', '\n', '}']
