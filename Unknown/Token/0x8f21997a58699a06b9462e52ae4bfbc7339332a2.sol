['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract MithrilArrows is IERC20 {\n', '    /* Public variables of the token */\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public constant name = "Mithril Arrows";\n', '    string public constant symbol = "MROW";\n', '    uint8 public constant decimals = 2;\n', '    uint256 public initialSupply;\n', '    uint256 public totalSupply;\n', '\n', '    using SafeMath for uint256;\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MithrilArrows() {\n', '\n', '         initialSupply = 3050000;\n', '        \n', '        \n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '                                   \n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply){\n', '        return totalSupply;\n', '    } \n', '    function balanceOf(address _owner) constant returns (uint256 balance){\n', '        return balanceOf[_owner];\n', '    }\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '\t    balanceOf[_to] = balanceOf[_to].add(_value);\n', '\t    Transfer(msg.sender, _to, _value);\n', '\t    return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '        require(\n', '            allowance [_from][msg.sender] >= _value\n', '            && balanceOf[_from] >= _value\n', '            && _value > 0\n', '            );\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '\t    balanceOf[_to] = balanceOf[_to].add(_value);\n', '\t    allowance[_from][msg.sender] -= _value;\n', '\t    Transfer (_from, _to, _value);\n', '\t    return true;\n', '    }\n', '    function approve(address _spender, uint256 _value) returns (bool success){\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowance[_owner][_spender];\n', '}\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract MithrilArrows is IERC20 {\n', '    /* Public variables of the token */\n', "    string public standard = 'Token 0.1';\n", '    string public constant name = "Mithril Arrows";\n', '    string public constant symbol = "MROW";\n', '    uint8 public constant decimals = 2;\n', '    uint256 public initialSupply;\n', '    uint256 public totalSupply;\n', '\n', '    using SafeMath for uint256;\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  \n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MithrilArrows() {\n', '\n', '         initialSupply = 3050000;\n', '        \n', '        \n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '                                   \n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply){\n', '        return totalSupply;\n', '    } \n', '    function balanceOf(address _owner) constant returns (uint256 balance){\n', '        return balanceOf[_owner];\n', '    }\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '\t    balanceOf[_to] = balanceOf[_to].add(_value);\n', '\t    Transfer(msg.sender, _to, _value);\n', '\t    return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '        require(\n', '            allowance [_from][msg.sender] >= _value\n', '            && balanceOf[_from] >= _value\n', '            && _value > 0\n', '            );\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '\t    balanceOf[_to] = balanceOf[_to].add(_value);\n', '\t    allowance[_from][msg.sender] -= _value;\n', '\t    Transfer (_from, _to, _value);\n', '\t    return true;\n', '    }\n', '    function approve(address _spender, uint256 _value) returns (bool success){\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowance[_owner][_spender];\n', '}\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}']
