['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract iPromo {\n', '    function massNotify(address[] _owners) public;\n', '    function transferOwnership(address newOwner) public;\n', '}\n', '\n', '/**\n', '* Distribute promo tokens parallel\n', '*   negligible, +3k gas cost / tx\n', '*   500 address ~ 1.7M gas\n', '* author: thesved, viktor.tabori at etheal dot com\n', '*/\n', 'contract EthealPromoDistribute is Ownable {\n', '    mapping (address => bool) public admins;\n', '    iPromo public token;\n', '\n', '    // constructor\n', '    constructor(address _promo) public {\n', '        token = iPromo(_promo);\n', '    }\n', '\n', '    // set promo token\n', '    function setToken(address _promo) onlyOwner public {\n', '        token = iPromo(_promo);\n', '    }\n', '\n', '    // transfer ownership of token\n', '    function passToken(address _promo) onlyOwner public {\n', '        require(_promo != address(0));\n', '        require(address(token) != address(0));\n', '\n', '        token.transferOwnership(_promo);\n', '    }\n', '\n', '    // set admins\n', '    function setAdmin(address[] _admins, bool _v) onlyOwner public {\n', '        for (uint256 i = 0; i<_admins.length; i++) {\n', '            admins[ _admins[i] ] = _v;\n', '        }\n', '    }\n', '\n', '    // notify\n', '    function massNotify(address[] _owners) external {\n', '        require(admins[msg.sender] || msg.sender == owner);\n', '        token.massNotify(_owners);\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract iPromo {\n', '    function massNotify(address[] _owners) public;\n', '    function transferOwnership(address newOwner) public;\n', '}\n', '\n', '/**\n', '* Distribute promo tokens parallel\n', '*   negligible, +3k gas cost / tx\n', '*   500 address ~ 1.7M gas\n', '* author: thesved, viktor.tabori at etheal dot com\n', '*/\n', 'contract EthealPromoDistribute is Ownable {\n', '    mapping (address => bool) public admins;\n', '    iPromo public token;\n', '\n', '    // constructor\n', '    constructor(address _promo) public {\n', '        token = iPromo(_promo);\n', '    }\n', '\n', '    // set promo token\n', '    function setToken(address _promo) onlyOwner public {\n', '        token = iPromo(_promo);\n', '    }\n', '\n', '    // transfer ownership of token\n', '    function passToken(address _promo) onlyOwner public {\n', '        require(_promo != address(0));\n', '        require(address(token) != address(0));\n', '\n', '        token.transferOwnership(_promo);\n', '    }\n', '\n', '    // set admins\n', '    function setAdmin(address[] _admins, bool _v) onlyOwner public {\n', '        for (uint256 i = 0; i<_admins.length; i++) {\n', '            admins[ _admins[i] ] = _v;\n', '        }\n', '    }\n', '\n', '    // notify\n', '    function massNotify(address[] _owners) external {\n', '        require(admins[msg.sender] || msg.sender == owner);\n', '        token.massNotify(_owners);\n', '    }\n', '}']
