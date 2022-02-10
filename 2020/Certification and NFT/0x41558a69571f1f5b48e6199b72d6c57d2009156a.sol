['pragma solidity 0.6.0;\n', '\n', '// AgnosticPrivateSale\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint value) external  returns (bool success);\n', '}\n', '\n', 'interface DFED {\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint value) external  returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '}\n', '\n', 'contract AgnosticPrivateSale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public totalExchanged;\n', '  ERC20 public Token;\n', '  DFED public PreviousToken;\n', '  address payable public owner;\n', '  uint256 public constant decimals = 12;\n', '  uint256 private constant _precision = 10 ** decimals;\n', '  uint256 public startDate;\n', '  \n', '  bool ableToClaim;\n', '  bool sellSystem;\n', '  \n', '  struct User {\n', '    uint256 accountBalance;\n', '  }\n', '    \n', '  mapping(address => User) public users;\n', '  \n', '  address[] public allUsers;\n', '   \n', '  constructor(address token, address previousToken) public {\n', '    owner = msg.sender;\n', '    Token = ERC20(token);\n', '    PreviousToken = DFED(previousToken);\n', '    ableToClaim = false;\n', '    sellSystem = true;\n', '    startDate = now;\n', '  }\n', '\n', '  function contribute() public {\n', '    require(sellSystem);\n', '    \n', '    uint256 allTokens = PreviousToken.balanceOf(msg.sender);\n', '    \n', '    uint256 amount = allTokens.mul(_precision).mul(15);\n', '    \n', '    totalExchanged = totalExchanged.add(amount);\n', '    \n', '    users[msg.sender].accountBalance = users[msg.sender].accountBalance.add(amount);\n', '     \n', '    allUsers.push(msg.sender);\n', '    \n', '    PreviousToken.transferFrom(msg.sender, owner, allTokens);\n', '  }\n', '  \n', '   function returnAllTokens() public {\n', '    require(msg.sender == owner);\n', '    require(ableToClaim);\n', '        \n', '    for (uint id = 0; id < allUsers.length; id++) {\n', '          address getAddressUser = allUsers[id];\n', '          uint256 value = users[getAddressUser].accountBalance;\n', '          users[getAddressUser].accountBalance = users[getAddressUser].accountBalance.sub(value);\n', '          if(value != 0){\n', '             Token.transfer(getAddressUser, value);\n', '          }\n', '     }\n', '  }\n', '           \n', '  function claimTokens() public {\n', '    require(ableToClaim);\n', '    uint256 value = users[msg.sender].accountBalance;\n', '    users[msg.sender].accountBalance = users[msg.sender].accountBalance.sub(value);\n', '    Token.transfer(msg.sender, value);\n', '  }\n', '  \n', '  function openClaimSystem (bool _ableToClaim) public {\n', '    require(msg.sender == owner);\n', '    ableToClaim = _ableToClaim;\n', '  }\n', '  \n', '  function closeSellSystem () public {\n', '    require(msg.sender == owner);\n', '    sellSystem = false;\n', '  }\n', '\n', '  function liqudity() public {\n', '    require(msg.sender == owner);\n', '    Token.transfer(msg.sender, Token.balanceOf(address(this)));\n', '  }\n', '  \n', '  function availableTokens() public view returns(uint256) {\n', '    return Token.balanceOf(address(this));\n', '  }\n', '  \n', '  function yourTokens() public view returns(uint256) {\n', '    return users[msg.sender].accountBalance;\n', '  }\n', '  \n', '}']