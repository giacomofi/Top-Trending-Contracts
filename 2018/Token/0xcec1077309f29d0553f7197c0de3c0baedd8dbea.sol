['pragma solidity ^0.4.21;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract DSC is IERC20 {\n', '\n', '    // ---- DSC Specifications ----\n', '    // Name: DSC (Data Science Coin)\n', '    // Total Supply: 10 billion\n', '    // Initial Ownership Ratio: 100%\n', '    // Another(separate) CONTRACT to be created in the future for crowdsale(ICO)\n', '    //  \n', '    // DSC Phases\n', '    // 1. Create DSC (tokens)\n', '    // 2. Individually distribute tokens to existing BigPlace users & notify them\n', '    // 3. Private Sale\n', '    // 4. Crowdsale (ICO)\n', '    // 5. PROMOTE DATA SCIENCE !\n', '    // \n', '    // **This is the second try. \n', '    //-----------------------------\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public constant _totalSupply = 10000000000000000000000000000;\n', '    \n', '    string public constant symbol = "DSC";\n', '    string public constant name = "Data Science Coin";\n', '    uint8 public constant decimals = 18;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    function DSC() {\n', '        balances[msg.sender] = 10000000000000000000000000000;\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && _value > 0\n', '        );\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(\n', '            allowed[_from][msg.sender] >= _value\n', '            && balances[_from] >= _value\n', '            && _value > 0\n', '        );\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract DSC is IERC20 {\n', '\n', '    // ---- DSC Specifications ----\n', '    // Name: DSC (Data Science Coin)\n', '    // Total Supply: 10 billion\n', '    // Initial Ownership Ratio: 100%\n', '    // Another(separate) CONTRACT to be created in the future for crowdsale(ICO)\n', '    //  \n', '    // DSC Phases\n', '    // 1. Create DSC (tokens)\n', '    // 2. Individually distribute tokens to existing BigPlace users & notify them\n', '    // 3. Private Sale\n', '    // 4. Crowdsale (ICO)\n', '    // 5. PROMOTE DATA SCIENCE !\n', '    // \n', '    // **This is the second try. \n', '    //-----------------------------\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public constant _totalSupply = 10000000000000000000000000000;\n', '    \n', '    string public constant symbol = "DSC";\n', '    string public constant name = "Data Science Coin";\n', '    uint8 public constant decimals = 18;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    function DSC() {\n', '        balances[msg.sender] = 10000000000000000000000000000;\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && _value > 0\n', '        );\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(\n', '            allowed[_from][msg.sender] >= _value\n', '            && balances[_from] >= _value\n', '            && _value > 0\n', '        );\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}']
