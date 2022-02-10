['contract GUIDEToken {\n', '\n', '    string public name = "GUIDE TOKEN";          //  token name\n', '    string public symbol = "GUIDE";           //  token symbol\n', '    uint256 public decimals = 8;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 1000000000000000000;\n', '    address public owner = 0x0;\n', '\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '    \n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function GUIDEToken() {\n', '        owner = msg.sender;\n', '        balanceOf[msg.sender] = totalSupply;\n', '        Transfer(0x0, msg.sender, totalSupply);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) validAddress returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(totalSupply >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '    }\n', '    \n', '    function setName(string _name) isOwner {\n', '        name = _name;\n', '    }\n', '\n', '    function setSymbol(string _symbol) isOwner{\n', '        symbol = _symbol;\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '}']