['pragma solidity 0.6.10;\n', '\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two unsigned integers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two unsigned integers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract LazarusCreators {\n', '  using SafeMath for uint256;\n', '\n', '  address payable public owner;\n', '  uint256 public ethBalance;\n', '  uint256 public fee = 1;\n', '\n', '  // mapping that stores credits for users.\n', '  mapping(address => uint256) credits;\n', '\n', '  constructor () public {\n', '    owner = msg.sender; \n', '  }\n', '\n', '  function getCredit () external payable {\n', '    if (fee == 1) {\n', '      require(msg.value == 0.1 ether);\n', '    } else if (fee == 2) {\n', '      require(msg.value == 0.25 ether);\n', '    } else if (fee == 3) {\n', '      require(msg.value == 0.5 ether);\n', '    } else if (fee == 4) {\n', '      require(msg.value == 1 ether);\n', '    }\n', '    ethBalance = ethBalance.add(msg.value);\n', '    credits[msg.sender] = credits[msg.sender].add(1);\n', '  }\n', '\n', '  function setFee (uint256 _fee) public {\n', '    require(msg.sender == owner);\n', '    fee = _fee;\n', '  }\n', '\n', '  function getUserCredits (address _user) public view returns (uint256) {\n', '    return credits[_user];\n', '  }\n', '\n', '  function useCredit () public {\n', '    require(credits[msg.sender] >= 1);\n', '    credits[msg.sender] = credits[msg.sender].sub(1);\n', '  }\n', '\n', '  function withdrawETH () public {\n', '    require(msg.sender == owner);\n', '    owner.transfer(ethBalance);\n', '    ethBalance = 0;\n', '  }\n', '\n', '  function transferOwnership (address payable _newOwner) public {\n', '    require(msg.sender == owner);\n', '    owner = _newOwner;\n', '  }\n', '}']