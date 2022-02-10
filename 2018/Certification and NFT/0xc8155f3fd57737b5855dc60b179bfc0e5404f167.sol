['pragma solidity ^0.4.18;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) private onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    address public escrow;\n', '    \n', '    token public tokenReward;\n', '    \n', '    uint start = 1525132800;\n', '    \n', '    uint period = 31;\n', '    \n', '    \n', '    \n', '    function Crowdsale (\n', '        \n', '        \n', '        ) public {\n', '        escrow = 0x8bB3E0e70Fa2944DBA0cf5a1AF6e230A9453c647;\n', '        tokenReward = token(0xACE380244861698DBa241C4e0d6F8fFc588A6F73);\n', '    }\n', '    \n', '        modifier saleIsOn() {\n', '        require(now > start && now < start + period * 1 days);\n', '        _;\n', '    }\n', '    \n', '    function sellTokens() public saleIsOn payable {\n', '        escrow.transfer(msg.value);\n', '        \n', '        uint price = 400;\n', '        \n', '    \n', '    uint tokens = msg.value.mul(price);\n', '    \n', '    tokenReward.transfer(msg.sender, tokens); \n', '    \n', '    }\n', '    \n', '    \n', '   function() external payable {\n', '        sellTokens();\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) private onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    address public escrow;\n', '    \n', '    token public tokenReward;\n', '    \n', '    uint start = 1525132800;\n', '    \n', '    uint period = 31;\n', '    \n', '    \n', '    \n', '    function Crowdsale (\n', '        \n', '        \n', '        ) public {\n', '        escrow = 0x8bB3E0e70Fa2944DBA0cf5a1AF6e230A9453c647;\n', '        tokenReward = token(0xACE380244861698DBa241C4e0d6F8fFc588A6F73);\n', '    }\n', '    \n', '        modifier saleIsOn() {\n', '        require(now > start && now < start + period * 1 days);\n', '        _;\n', '    }\n', '    \n', '    function sellTokens() public saleIsOn payable {\n', '        escrow.transfer(msg.value);\n', '        \n', '        uint price = 400;\n', '        \n', '    \n', '    uint tokens = msg.value.mul(price);\n', '    \n', '    tokenReward.transfer(msg.sender, tokens); \n', '    \n', '    }\n', '    \n', '    \n', '   function() external payable {\n', '        sellTokens();\n', '    }\n', '    \n', '}']
