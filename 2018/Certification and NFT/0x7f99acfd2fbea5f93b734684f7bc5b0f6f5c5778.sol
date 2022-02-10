['pragma solidity 0.4.25;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract Token{\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '}\n', '\n', '\n', '/**\n', ' * @title token token initial distribution\n', ' *\n', ' * @dev Distribute purchasers, airdrop, reserve, and founder tokens\n', ' */\n', 'contract MapAirDrop is Owned {\n', '  using SafeMath for uint256;\n', '  Token public token;\n', '  uint256 private constant decimalFactor = 10**uint256(18);\n', '  // Keeps track of whether or not a token airdrop has been made to a particular address\n', '  mapping (address => bool) public airdrops;\n', '  \n', '  /**\n', '    * @dev Constructor function - Set the token token address\n', '    */\n', '  constructor(address _tokenContractAdd, address _owner) public {\n', '    // takes an address of the existing token contract as parameter\n', '    token = Token(_tokenContractAdd);\n', '    owner = _owner;\n', '  }\n', '  \n', '  /**\n', '    * @dev perform a transfer of allocations\n', '    * @param _recipient is a list of recipients\n', '    */\n', '  function airdropTokens(address[] _recipient, uint256[] _tokens) external onlyOwner{\n', '    uint airdropped;\n', '    for(uint256 i = 0; i< _recipient.length; i++)\n', '    {\n', '        // if (!airdrops[_recipient[i]]) {\n', '          airdrops[_recipient[i]] = true;\n', '          require(token.transferFrom(msg.sender, _recipient[i], _tokens[i] * decimalFactor));\n', '          airdropped = airdropped.add(_tokens[i] * decimalFactor);\n', '        // }\n', '    }\n', '  }\n', '}']