['pragma solidity ^0.4.18;\n', '\n', 'contract SafeMath {\n', '\n', '    function SafeMath() {\n', '    }\n', '\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract TOT is SafeMath {\n', '    string public constant standard = &#39;Token 0.1&#39;;\n', '    uint8 public constant decimals = 18;\n', '\n', '    string public constant name = &#39;Token of Tea&#39;;\n', '    string public constant symbol = &#39;TOT&#39;;\n', '    uint256 public totalSupply = 10 * 10**8 * 10**uint256(decimals);\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function TOT() public {\n', '        Transfer(0x00, msg.sender, totalSupply);\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract SafeMath {\n', '\n', '    function SafeMath() {\n', '    }\n', '\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract TOT is SafeMath {\n', "    string public constant standard = 'Token 0.1';\n", '    uint8 public constant decimals = 18;\n', '\n', "    string public constant name = 'Token of Tea';\n", "    string public constant symbol = 'TOT';\n", '    uint256 public totalSupply = 10 * 10**8 * 10**uint256(decimals);\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function TOT() public {\n', '        Transfer(0x00, msg.sender, totalSupply);\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '    public\n', '    returns (bool success)\n', '    {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}']