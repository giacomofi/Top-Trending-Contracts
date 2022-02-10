['library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract SKYFTokenInterface {\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract SKYFNetworkDevelopmentFund is Ownable{\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public constant startTime = 1534334400;\n', '    uint256 public constant firstYearEnd = startTime + 365 days;\n', '    uint256 public constant secondYearEnd = firstYearEnd + 365 days;\n', '    \n', '    uint256 public initialSupply;\n', '    SKYFTokenInterface public token;\n', '\n', '    function setToken(address _token) public onlyOwner returns (bool) {\n', '        require(_token != address(0));\n', '        if (token == address(0)) {\n', '            token = SKYFTokenInterface(_token);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public onlyOwner returns (bool) {\n', '        uint256 balance = token.balanceOf(this);\n', '        if (initialSupply == 0) {\n', '            initialSupply = balance;\n', '        }\n', '        \n', '        if (now < firstYearEnd) {\n', '            require(balance.sub(_value).mul(2) >= initialSupply); //no less than 50%(1/2) should be left on account after first year\n', '        } else if (now < secondYearEnd) {\n', '            require(balance.sub(_value).mul(20) >= initialSupply.mul(3)); //no less than 15%(3/20) should be left on account after second year\n', '        }\n', '\n', '        token.transfer(_to, _value);\n', '\n', '    }\n', '}']