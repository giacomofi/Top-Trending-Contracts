['contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract SKYFTokenInterface {\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract SKYFTeamFund is Ownable{\n', '    uint256 public constant startTime = 1534334400;\n', '    uint256 public constant firstYearEnd = startTime + 365 days;\n', '    \n', '    SKYFTokenInterface public token;\n', '\n', '    function setToken(address _token) public onlyOwner returns (bool) {\n', '        require(_token != address(0));\n', '        if (token == address(0)) {\n', '            token = SKYFTokenInterface(_token);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public onlyOwner returns (bool) {\n', '        require(now > firstYearEnd);\n', '\n', '        token.transfer(_to, _value);\n', '\n', '    }\n', '}']