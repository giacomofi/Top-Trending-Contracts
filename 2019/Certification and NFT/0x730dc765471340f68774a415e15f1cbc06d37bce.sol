['pragma solidity 0.5.1;\n', '\n', '/**\n', ' * @dev Xcert interface.\n', ' */\n', 'interface Xcert // is ERC721 metadata enumerable\n', '{\n', '\n', '  /**\n', '   * @dev Creates a new Xcert.\n', '   * @param _to The address that will own the created Xcert.\n', '   * @param _id The Xcert to be created by the msg.sender.\n', '   * @param _imprint Cryptographic asset imprint.\n', '   */\n', '  function create(\n', '    address _to,\n', '    uint256 _id,\n', '    bytes32 _imprint\n', '  )\n', '    external;\n', '\n', '  /**\n', '   * @dev Change URI base.\n', '   * @param _uriBase New uriBase.\n', '   */\n', '  function setUriBase(\n', '    string calldata _uriBase\n', '  )\n', '    external;\n', '\n', '  /**\n', '   * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert Protocol convention.\n', '   * @return Schema id.\n', '   */\n', '  function schemaId()\n', '    external\n', '    view\n', '    returns (bytes32 _schemaId);\n', '\n', '  /**\n', '   * @dev Returns imprint for Xcert.\n', '   * @param _tokenId Id of the Xcert.\n', '   * @return Token imprint.\n', '   */\n', '  function tokenImprint(\n', '    uint256 _tokenId\n', '  )\n', '    external\n', '    view\n', '    returns(bytes32 imprint);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @dev Math operations with safety checks that throw on error. This contract is based on the \n', ' * source code at: \n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.\n', ' */\n', 'library SafeMath\n', '{\n', '\n', '  /**\n', '   * @dev Error constants.\n', '   */\n', '  string constant OVERFLOW = "008001";\n', '  string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";\n', '  string constant DIVISION_BY_ZERO = "008003";\n', '\n', '  /**\n', '   * @dev Multiplies two numbers, reverts on overflow.\n', '   * @param _factor1 Factor number.\n', '   * @param _factor2 Factor number.\n', '   * @return The product of the two factors.\n', '   */\n', '  function mul(\n', '    uint256 _factor1,\n', '    uint256 _factor2\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256 product)\n', '  {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_factor1 == 0)\n', '    {\n', '      return 0;\n', '    }\n', '\n', '    product = _factor1 * _factor2;\n', '    require(product / _factor1 == _factor2, OVERFLOW);\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.\n', '   * @param _dividend Dividend number.\n', '   * @param _divisor Divisor number.\n', '   * @return The quotient.\n', '   */\n', '  function div(\n', '    uint256 _dividend,\n', '    uint256 _divisor\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256 quotient)\n', '  {\n', '    // Solidity automatically asserts when dividing by 0, using all gas.\n', '    require(_divisor > 0, DIVISION_BY_ZERO);\n', '    quotient = _dividend / _divisor;\n', "    // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.\n", '  }\n', '\n', '  /**\n', '   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   * @param _minuend Minuend number.\n', '   * @param _subtrahend Subtrahend number.\n', '   * @return Difference.\n', '   */\n', '  function sub(\n', '    uint256 _minuend,\n', '    uint256 _subtrahend\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256 difference)\n', '  {\n', '    require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);\n', '    difference = _minuend - _subtrahend;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, reverts on overflow.\n', '   * @param _addend1 Number.\n', '   * @param _addend2 Number.\n', '   * @return Sum.\n', '   */\n', '  function add(\n', '    uint256 _addend1,\n', '    uint256 _addend2\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256 sum)\n', '  {\n', '    sum = _addend1 + _addend2;\n', '    require(sum >= _addend1, OVERFLOW);\n', '  }\n', '\n', '  /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when\n', '    * dividing by zero.\n', '    * @param _dividend Number.\n', '    * @param _divisor Number.\n', '    * @return Remainder.\n', '    */\n', '  function mod(\n', '    uint256 _dividend,\n', '    uint256 _divisor\n', '  )\n', '    internal\n', '    pure\n', '    returns (uint256 remainder) \n', '  {\n', '    require(_divisor != 0, DIVISION_BY_ZERO);\n', '    remainder = _dividend % _divisor;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Contract for setting abilities.\n', ' * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of\n', ' * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how\n', ' * this works. \n', ' * 00000001 Ability A - number representation 1\n', ' * 00000010 Ability B - number representation 2\n', ' * 00000100 Ability C - number representation 4\n', ' * 00001000 Ability D - number representation 8\n', ' * 00010000 Ability E - number representation 16\n', ' * etc ... \n', ' * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number\n', ' * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities\n', ' * and checking if someone has multiple abilities.\n', ' */\n', 'contract Abilitable\n', '{\n', '  using SafeMath for uint;\n', '\n', '  /**\n', '   * @dev Error constants.\n', '   */\n', '  string constant NOT_AUTHORIZED = "017001";\n', '  string constant ONE_ZERO_ABILITY_HAS_TO_EXIST = "017002";\n', '  string constant INVALID_INPUT = "017003";\n', '\n', '  /**\n', '   * @dev Ability 1 is a reserved ability. It is an ability to grant or revoke abilities. \n', '   * There can be minimum of 1 address with ability 1.\n', '   * Other abilities are determined by implementing contract.\n', '   */\n', '  uint8 constant ABILITY_TO_MANAGE_ABILITIES = 1;\n', '\n', '  /**\n', '   * @dev Maps address to ability ids.\n', '   */\n', '  mapping(address => uint256) public addressToAbility;\n', '\n', '  /**\n', '   * @dev Count of zero ability addresses.\n', '   */\n', '  uint256 private zeroAbilityCount;\n', '\n', '  /**\n', '   * @dev Emits when an address is granted an ability.\n', '   * @param _target Address to which we are granting abilities.\n', '   * @param _abilities Number representing bitfield of abilities we are granting.\n', '   */\n', '  event GrantAbilities(\n', '    address indexed _target,\n', '    uint256 indexed _abilities\n', '  );\n', '\n', '  /**\n', '   * @dev Emits when an address gets an ability revoked.\n', '   * @param _target Address of which we are revoking an ability.\n', '   * @param _abilities Number representing bitfield of abilities we are revoking.\n', '   */\n', '  event RevokeAbilities(\n', '    address indexed _target,\n', '    uint256 indexed _abilities\n', '  );\n', '\n', '  /**\n', '   * @dev Guarantees that msg.sender has certain abilities.\n', '   */\n', '  modifier hasAbilities(\n', '    uint256 _abilities\n', '  ) \n', '  {\n', '    require(_abilities > 0, INVALID_INPUT);\n', '    require(\n', '      (addressToAbility[msg.sender] & _abilities) == _abilities,\n', '      NOT_AUTHORIZED\n', '    );\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Contract constructor.\n', '   * Sets ABILITY_TO_MANAGE_ABILITIES ability to the sender account.\n', '   */\n', '  constructor()\n', '    public\n', '  {\n', '    addressToAbility[msg.sender] = ABILITY_TO_MANAGE_ABILITIES;\n', '    zeroAbilityCount = 1;\n', '    emit GrantAbilities(msg.sender, ABILITY_TO_MANAGE_ABILITIES);\n', '  }\n', '\n', '  /**\n', '   * @dev Grants specific abilities to specified address.\n', '   * @param _target Address to grant abilities to.\n', '   * @param _abilities Number representing bitfield of abilities we are granting.\n', '   */\n', '  function grantAbilities(\n', '    address _target,\n', '    uint256 _abilities\n', '  )\n', '    external\n', '    hasAbilities(ABILITY_TO_MANAGE_ABILITIES)\n', '  {\n', '    addressToAbility[_target] |= _abilities;\n', '\n', '    if((_abilities & ABILITY_TO_MANAGE_ABILITIES) == ABILITY_TO_MANAGE_ABILITIES)\n', '    {\n', '      zeroAbilityCount = zeroAbilityCount.add(1);\n', '    }\n', '    emit GrantAbilities(_target, _abilities);\n', '  }\n', '\n', '  /**\n', '   * @dev Unassigns specific abilities from specified address.\n', '   * @param _target Address of which we revoke abilites.\n', '   * @param _abilities Number representing bitfield of abilities we are revoking.\n', '   */\n', '  function revokeAbilities(\n', '    address _target,\n', '    uint256 _abilities\n', '  )\n', '    external\n', '    hasAbilities(ABILITY_TO_MANAGE_ABILITIES)\n', '  {\n', '    addressToAbility[_target] &= ~_abilities;\n', '    if((_abilities & 1) == 1)\n', '    {\n', '      require(zeroAbilityCount > 1, ONE_ZERO_ABILITY_HAS_TO_EXIST);\n', '      zeroAbilityCount--;\n', '    }\n', '    emit RevokeAbilities(_target, _abilities);\n', '  }\n', '\n', '  /**\n', '   * @dev Check if an address has a specific ability. Throws if checking for 0.\n', '   * @param _target Address for which we want to check if it has a specific abilities.\n', '   * @param _abilities Number representing bitfield of abilities we are checking.\n', '   */\n', '  function isAble(\n', '    address _target,\n', '    uint256 _abilities\n', '  )\n', '    external\n', '    view\n', '    returns (bool)\n', '  {\n', '    require(_abilities > 0, INVALID_INPUT);\n', '    return (addressToAbility[_target] & _abilities) == _abilities;\n', '  }\n', '  \n', '}\n', '\n', '/**\n', ' * @title XcertCreateProxy - creates a token on behalf of contracts that have been approved via\n', ' * decentralized governance.\n', ' */\n', 'contract XcertCreateProxy is \n', '  Abilitable \n', '{\n', '\n', '  /**\n', '   * @dev List of abilities:\n', '   * 2 - Ability to execute create. \n', '   */\n', '  uint8 constant ABILITY_TO_EXECUTE = 2;\n', '\n', '  /**\n', '   * @dev Creates a new NFT.\n', '   * @param _xcert Address of the Xcert contract on which the creation will be perfomed.\n', '   * @param _to The address that will own the created NFT.\n', '   * @param _id The NFT to be created by the msg.sender.\n', '   * @param _imprint Cryptographic asset imprint.\n', '   */\n', '  function create(\n', '    address _xcert,\n', '    address _to,\n', '    uint256 _id,\n', '    bytes32 _imprint\n', '  )\n', '    external\n', '    hasAbilities(ABILITY_TO_EXECUTE)\n', '  {\n', '    Xcert(_xcert).create(_to, _id, _imprint);\n', '  }\n', '  \n', '}']