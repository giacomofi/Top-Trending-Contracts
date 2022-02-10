['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract MultiEthSender {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    event Send(uint256 _amount, address indexed _receiver);\n', '\n', '    modifier enoughBalance(uint256 amount, address[] list) {\n', '        uint256 totalAmount = amount.mul(list.length);\n', '        require(address(this).balance >= totalAmount);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '\n', '    }\n', '\n', '    function () public payable {\n', '        require(msg.value >= 0);\n', '    }\n', '\n', '    function multiSendEth(uint256 amount, address[] list)\n', '    enoughBalance(amount, list)\n', '    public\n', '    returns (bool) \n', '    {\n', '        for (uint256 i = 0; i < list.length; i++) {\n', '            address(list[i]).transfer(amount);\n', '            emit Send(amount, address(list[i]));\n', '        }\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract MultiEthSender {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    event Send(uint256 _amount, address indexed _receiver);\n', '\n', '    modifier enoughBalance(uint256 amount, address[] list) {\n', '        uint256 totalAmount = amount.mul(list.length);\n', '        require(address(this).balance >= totalAmount);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '\n', '    }\n', '\n', '    function () public payable {\n', '        require(msg.value >= 0);\n', '    }\n', '\n', '    function multiSendEth(uint256 amount, address[] list)\n', '    enoughBalance(amount, list)\n', '    public\n', '    returns (bool) \n', '    {\n', '        for (uint256 i = 0; i < list.length; i++) {\n', '            address(list[i]).transfer(amount);\n', '            emit Send(amount, address(list[i]));\n', '        }\n', '        return true;\n', '    }\n', '}']
