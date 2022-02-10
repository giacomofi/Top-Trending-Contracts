['pragma solidity ^0.4.19;\n', '\n', '\n', '/**\n', ' * PIEXGO TEAM\n', ' */\n', ' \n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Token {\n', '\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract RegularToken is Token, SafeMath {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        require(balances[msg.sender] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        balances[msg.sender] = sub(balances[msg.sender], _value);\n', '        balances[_to] = add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        balances[_from] = sub(balances[_from], _value);\n', '        balances[_to] = add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', 'contract PXGToken is RegularToken {\n', '\n', '    uint256 public totalSupply = 100*10**(18+8);\n', '    uint8 constant public decimals = 18;\n', '    string constant public name = "PIEXGO";\n', '    string constant public symbol = "PXG";\n', '\n', '    function PXGToken() {\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '\n', '/**\n', ' * PIEXGO TEAM\n', ' */\n', ' \n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Token {\n', '\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract RegularToken is Token, SafeMath {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        require(balances[msg.sender] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        balances[msg.sender] = sub(balances[msg.sender], _value);\n', '        balances[_to] = add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        balances[_from] = sub(balances[_from], _value);\n', '        balances[_to] = add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', 'contract PXGToken is RegularToken {\n', '\n', '    uint256 public totalSupply = 100*10**(18+8);\n', '    uint8 constant public decimals = 18;\n', '    string constant public name = "PIEXGO";\n', '    string constant public symbol = "PXG";\n', '\n', '    function PXGToken() {\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']