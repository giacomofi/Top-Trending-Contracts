['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balanceOf[msg.sender]);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);\n', '        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract BSE is StandardToken {\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '\n', '    string public name = "BiSale";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "BSE";\n', '    string public version = &#39;v0.1&#39;;\n', '    uint256 public totalSupply = 0;\n', '\n', '    function BSE () {\n', '        totalSupply = 100000000000 * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balanceOf[msg.sender]);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);\n', '        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract BSE is StandardToken {\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '\n', '    string public name = "BiSale";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "BSE";\n', "    string public version = 'v0.1';\n", '    uint256 public totalSupply = 0;\n', '\n', '    function BSE () {\n', '        totalSupply = 100000000000 * 10 ** uint256(decimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '}']