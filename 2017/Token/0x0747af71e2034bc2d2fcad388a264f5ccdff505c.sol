['pragma solidity ^ 0.4 .11;\n', '\n', '\n', '\n', 'contract tokenRecipient {\n', '\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract ERC20 {\n', '\n', '\n', '\n', '    function totalSupply() constant returns(uint _totalSupply);\n', '\n', '\n', '\n', '    function balanceOf(address who) constant returns(uint256);\n', '\n', '\n', '\n', '    function transfer(address to, uint value) returns(bool ok);\n', '\n', '\n', '\n', '    function transferFrom(address from, address to, uint value) returns(bool ok);\n', '\n', '\n', '\n', '    function approve(address spender, uint value) returns(bool ok);\n', '\n', '\n', '\n', '    function allowance(address owner, address spender) constant returns(uint);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', ' \n', '\n', 'contract BlockVentureCoin is ERC20 {\n', '\n', '\n', '\n', '\n', '\n', "    string public standard = 'BVC 1.1';\n", '\n', '    string public name;\n', '\n', '    string public symbol;\n', '\n', '    uint8 public decimals;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    \n', '\n', '    \n', '\n', '    \n', '\n', '   \n', '\n', '    mapping( address => uint256) public balanceOf;\n', '\n', '    mapping( uint => address) public accountIndex;\n', '\n', '    uint accountCount;\n', '\n', '    \n', '\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '   \n', '\n', '    \n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed _owner, address indexed spender, uint value);\n', '\n', '    event Message ( address a, uint256 amount );\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\n', '\n', '\n', '\n', '   \n', '\n', '    \n', '\n', '    function BlockVentureCoin() {\n', '\n', '         \n', '\n', '        uint supply = 10000000000000000; \n', '\n', '        appendTokenHolders( msg.sender );\n', '\n', '        balanceOf[msg.sender] =  supply;\n', '\n', '        totalSupply = supply; \n', '\n', '        name = "BlockVentureCoin"; \n', '\n', '        symbol = "BVC"; \n', '\n', '        decimals = 8; \n', '\n', '       \n', '\n', ' \n', '\n', '        \n', '\n', '  \n', '\n', '    }\n', '\n', '    \n', '\n', '  \n', '\n', '  \n', '\n', '    function balanceOf(address tokenHolder) constant returns(uint256) {\n', '\n', '\n', '\n', '        return balanceOf[tokenHolder];\n', '\n', '    }\n', '\n', '\n', '\n', '    function totalSupply() constant returns(uint256) {\n', '\n', '\n', '\n', '        return totalSupply;\n', '\n', '    }\n', '\n', '\n', '\n', '    function getAccountCount() constant returns(uint256) {\n', '\n', '\n', '\n', '        return accountCount;\n', '\n', '    }\n', '\n', '\n', '\n', '    function getAddress(uint slot) constant returns(address) {\n', '\n', '\n', '\n', '        return accountIndex[slot];\n', '\n', '\n', '\n', '    }\n', '\n', '\n', '\n', '    \n', '\n', '    function appendTokenHolders(address tokenHolder) private {\n', '\n', '\n', '\n', '        if (balanceOf[tokenHolder] == 0) {\n', '\n', '          \n', '\n', '            accountIndex[accountCount] = tokenHolder;\n', '\n', '            accountCount++;\n', '\n', '        }\n', '\n', '\n', '\n', '    }\n', '\n', '\n', '\n', '    \n', '\n', '    function transfer(address _to, uint256 _value) returns(bool ok) {\n', '\n', '        if (_to == 0x0) throw; \n', '\n', '        if (balanceOf[msg.sender] < _value) throw; \n', '\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '\n', '        \n', '\n', '        appendTokenHolders(_to);\n', '\n', '        balanceOf[msg.sender] -= _value; \n', '\n', '        balanceOf[_to] += _value; \n', '\n', '        Transfer(msg.sender, _to, _value); \n', '\n', '    \n', '\n', '        \n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    \n', '\n', '    function approve(address _spender, uint256 _value)\n', '\n', '    returns(bool success) {\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', '        Approval( msg.sender ,_spender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', ' \n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '\n', '    returns(bool success) {\n', '\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '        if (approve(_spender, _value)) {\n', '\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\n', '            return true;\n', '\n', '        }\n', '\n', '    }\n', '\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '\n', '        return allowance[_owner][_spender];\n', '\n', '    }\n', '\n', '\n', '\n', ' \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {\n', '\n', '        if (_to == 0x0) throw;  \n', '\n', '        if (balanceOf[_from] < _value) throw;  \n', '\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  \n', '\n', '        if (_value > allowance[_from][msg.sender]) throw; \n', '\n', '        appendTokenHolders(_to);\n', '\n', '        balanceOf[_from] -= _value; \n', '\n', '        balanceOf[_to] += _value; \n', '\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '       \n', '\n', '        return true;\n', '\n', '    }\n', '\n', '  \n', '\n', '    function burn(uint256 _value) returns(bool success) {\n', '\n', '        if (balanceOf[msg.sender] < _value) throw; \n', '\n', '        balanceOf[msg.sender] -= _value; \n', '\n', '        totalSupply -= _value; \n', '\n', '        Burn(msg.sender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function burnFrom(address _from, uint256 _value) returns(bool success) {\n', '\n', '    \n', '\n', '        if (balanceOf[_from] < _value) throw; \n', '\n', '        if (_value > allowance[_from][msg.sender]) throw; \n', '\n', '        allowance[_from][msg.sender] -= _value; \n', '\n', '        balanceOf[_from] -= _value; \n', '\n', '        totalSupply -= _value; \n', '\n', '        Burn(_from, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    \n', '\n', '  \n', '\n', ' \n', '\n', '    \n', '\n', '}']