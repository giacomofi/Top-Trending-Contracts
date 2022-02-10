['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  uint8 public decimals;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract BatchUtils is Ownable {\n', '  using SafeMath for uint256;\n', '  mapping (address => bool) public operational;\n', '  uint256 public sendlimit = 10;\n', '  \n', '  function BatchUtils() {\n', '      operational[msg.sender] = true;\n', '  }\n', '  \n', '  function setLimit(uint256 _limit) onlyOwner public {\n', '      sendlimit = _limit;\n', '  }\n', '  \n', '  function setOperational(address[] addresses, bool op) onlyOwner public {\n', '    for (uint i = 0; i < addresses.length; i++) {\n', '        operational[addresses[i]] = op;\n', '    }\n', '  }\n', '  \n', '  function batchTransfer(address[] _tokens, address[] _receivers, uint256 _value) {\n', '    require(operational[msg.sender]); \n', '    require(_value <= sendlimit);\n', '    \n', '    uint cnt = _receivers.length;\n', '    require(cnt > 0 && cnt <= 121);\n', '    \n', '    for (uint j = 0; j < _tokens.length; j++) {\n', '        ERC20Basic token = ERC20Basic(_tokens[j]);\n', '        \n', '        uint256 value = _value.mul(10**uint256(token.decimals()));\n', '        uint256 amount = uint256(cnt).mul(value);\n', '        \n', '        require(value > 0 && token.balanceOf(this) >= amount);\n', '        \n', '        for (uint i = 0; i < cnt; i++) {\n', '            token.transfer(_receivers[i], value);\n', '        }\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  uint8 public decimals;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract BatchUtils is Ownable {\n', '  using SafeMath for uint256;\n', '  mapping (address => bool) public operational;\n', '  uint256 public sendlimit = 10;\n', '  \n', '  function BatchUtils() {\n', '      operational[msg.sender] = true;\n', '  }\n', '  \n', '  function setLimit(uint256 _limit) onlyOwner public {\n', '      sendlimit = _limit;\n', '  }\n', '  \n', '  function setOperational(address[] addresses, bool op) onlyOwner public {\n', '    for (uint i = 0; i < addresses.length; i++) {\n', '        operational[addresses[i]] = op;\n', '    }\n', '  }\n', '  \n', '  function batchTransfer(address[] _tokens, address[] _receivers, uint256 _value) {\n', '    require(operational[msg.sender]); \n', '    require(_value <= sendlimit);\n', '    \n', '    uint cnt = _receivers.length;\n', '    require(cnt > 0 && cnt <= 121);\n', '    \n', '    for (uint j = 0; j < _tokens.length; j++) {\n', '        ERC20Basic token = ERC20Basic(_tokens[j]);\n', '        \n', '        uint256 value = _value.mul(10**uint256(token.decimals()));\n', '        uint256 amount = uint256(cnt).mul(value);\n', '        \n', '        require(value > 0 && token.balanceOf(this) >= amount);\n', '        \n', '        for (uint i = 0; i < cnt; i++) {\n', '            token.transfer(_receivers[i], value);\n', '        }\n', '    }\n', '  }\n', '}']