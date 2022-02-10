['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  /**\n', '  * @dev Exponentiation two numbers, throws on overflow.\n', '  */\n', '  function pow(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(a ** b > 0);\n', '    return a ** b;\n', '  }\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20StandardToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '}\n', '\n', 'contract MultiTransfer {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /*\n', '   * @dev. Get ERC20 Standard Token detail information\n', '   */\n', '  function name(address _token) public view returns(string) { return ERC20StandardToken(_token).name(); }\n', '  function symbol(address _token) public view returns(string) { return ERC20StandardToken(_token).symbol(); }\n', '  function decimals(address _token) public view returns(uint8) { return ERC20StandardToken(_token).decimals(); }\n', '  \n', '  /*\n', '   * @dev. Get allowed balance of contract at token\n', '   */\n', '  function allowance(address _token) public view returns(uint256) { return ERC20StandardToken(_token).allowance(msg.sender, address(this)); }\n', '  \n', '  /*\n', '   * @dev. Transfer allowed token\n', '   */\n', '  function transfer(address _token, address[] _to, uint256[] _value) public returns(bool) {\n', '\n', '    // Check invalid request\n', '    require(_to.length != 0);\n', '    require(_value.length != 0);\n', '    require(_to.length == _value.length);\n', '\n', '    uint256 sum = 0;\n', '\n', '    // Check receiver effectiveness\n', '    for (uint256 i = 0; i < _to.length; i++) {\n', '      require(_to[i] != address(0));\n', '      sum.add(_value[i]);\n', '    }\n', '\n', '    // Check allowed token balance effectiveness\n', '    assert(allowance(_token) >= sum);\n', '\n', '    // Send token\n', '    for (i = 0; i < _to.length; i++) {\n', '      require(ERC20StandardToken(_token).transferFrom(msg.sender, _to[i], _value[i]));\n', '    }\n', '\n', '    return true;\n', '  }\n', '}']