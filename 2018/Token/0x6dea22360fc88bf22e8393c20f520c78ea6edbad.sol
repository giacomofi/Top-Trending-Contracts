['pragma solidity ^0.4.20;\n', '\n', 'interface ERC20 {\n', '    function totalSupply() constant returns (uint _totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint _totalSupply) {\n', '        _totalSupply = totalSupply;\n', '    }\n', '\n', '\n', '}\n', '\n', '\n', 'contract ByThePeople is StandardToken {\n', '\n', '    string public name ="ByThePeople";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "BTP";\n', '    uint256 public initialSupply = 14000000;\n', '\n', '    function ByThePeople(address _receiver) public {\n', '        require(_receiver != address(0));\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balances[_receiver] = totalSupply;               // Give the receiver all initial tokens\n', '\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'interface ERC20 {\n', '    function totalSupply() constant returns (uint _totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint _totalSupply) {\n', '        _totalSupply = totalSupply;\n', '    }\n', '\n', '\n', '}\n', '\n', '\n', 'contract ByThePeople is StandardToken {\n', '\n', '    string public name ="ByThePeople";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "BTP";\n', '    uint256 public initialSupply = 14000000;\n', '\n', '    function ByThePeople(address _receiver) public {\n', '        require(_receiver != address(0));\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);\n', '        balances[_receiver] = totalSupply;               // Give the receiver all initial tokens\n', '\n', '    }\n', '\n', '\n', '}']
