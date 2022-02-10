['pragma solidity 0.6.8;\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two unsigned integers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two unsigned integers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint value) external  returns (bool success);\n', '}\n', '\n', 'contract DMRTokenSale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public totalSold;\n', '  ERC20 public Token;\n', '  address payable public owner;\n', '  uint256 public collectedETH;\n', '  uint256 public startDate;\n', '  bool private presaleClosed = false;\n', '\n', '  constructor(address _wallet) public {\n', '    owner = msg.sender;\n', '    Token = ERC20(_wallet);\n', '  }\n', '\n', '  uint256 amount;\n', ' \n', '  // Converts ETH to Tokens and sends new Tokens to the sender\n', '  receive () external payable {\n', '    require(startDate > 0 && now.sub(startDate) <= 7 days);\n', '    require(Token.balanceOf(address(this)) > 0);\n', '    require(msg.value >= 0.1 ether && msg.value <= 1.5 ether);\n', '    require(!presaleClosed);\n', '     \n', '    if (now.sub(startDate) <= 1 days) {\n', '       amount = msg.value.mul(500000);\n', '    } else if(now.sub(startDate) > 1 days) {\n', '       amount = msg.value.mul(500000);\n', '    } \n', '    \n', '    require(amount <= Token.balanceOf(address(this)));\n', '    // update constants.\n', '    totalSold = totalSold.add(amount);\n', '    collectedETH = collectedETH.add(msg.value);\n', '    // transfer the tokens.\n', '    Token.transfer(msg.sender, amount);\n', '  }\n', '\n', '  // Converts ETH to Tokens 1and sends new Tokens to the sender\n', '  function contribute() external payable {\n', '    require(startDate > 0 && now.sub(startDate) <= 7 days);\n', '    require(Token.balanceOf(address(this)) > 0);\n', '    require(msg.value >= 0.1 ether && msg.value <= 1.5 ether);\n', '    require(!presaleClosed);\n', '     \n', '    if (now.sub(startDate) <= 1 days) {\n', '       amount = msg.value.mul(500000);\n', '    } else if(now.sub(startDate) > 1 days) {\n', '       amount = msg.value.mul(500000);\n', '    } \n', '    \n', '    require(amount <= Token.balanceOf(address(this)));\n', '    // update constants.\n', '    totalSold = totalSold.add(amount);\n', '    collectedETH = collectedETH.add(msg.value);\n', '    // transfer the tokens.\n', '    Token.transfer(msg.sender, amount);\n', '  }\n', '\n', '  function withdrawETH() public {\n', '    require(msg.sender == owner);\n', '    require(presaleClosed == true);\n', '    owner.transfer(collectedETH);\n', '  }\n', '\n', '  function endPresale() public {\n', '    require(msg.sender == owner);\n', '    presaleClosed = true;\n', '  }\n', '\n', '  function burn() public {\n', '    require(msg.sender == owner && Token.balanceOf(address(this)) > 0 && now.sub(startDate) > 7 days);\n', '    // burn the left over.\n', '    Token.transfer(address(0), Token.balanceOf(address(this)));\n', '  }\n', '  \n', '  function startSale() public {\n', '    require(msg.sender == owner && startDate==0);\n', '    startDate=now;\n', '  }\n', '  \n', '  function availableTokens() public view returns(uint256) {\n', '    return Token.balanceOf(address(this));\n', '  }\n', '}']