['pragma solidity ^ 0.4 .11;\n', '\n', '\n', '\n', '\n', '\n', 'contract tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '\n', '    function totalSupply() constant returns(uint _totalSupply);\n', '\n', '    function balanceOf(address who) constant returns(uint256);\n', '\n', '    function transfer(address to, uint value) returns(bool ok);\n', '\n', '    function transferFrom(address from, address to, uint value) returns(bool ok);\n', '\n', '    function approve(address spender, uint value) returns(bool ok);\n', '\n', '    function allowance(address owner, address spender) constant returns(uint);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', ' \n', 'contract Studio is ERC20 {\n', '\n', '\n', "    string public standard = 'STUDIO 1.0';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    address public owner;\n', '    mapping( address => uint256) public balanceOf;\n', '    mapping( uint => address) public accountIndex;\n', '    uint accountCount;\n', '    \n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed _owner, address indexed spender, uint value);\n', '    event Message ( address a, uint256 amount );\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    \n', '    function Studio() {\n', '         \n', '        uint supply = 50000000; \n', '        appendTokenHolders( msg.sender );\n', '        balanceOf[msg.sender] =  supply;\n', '        totalSupply = supply; // \n', '        name = "STUDIO"; // Set the name for display purposes\n', '        symbol = "STDO"; // Set the symbol for display purposes\n', '        decimals = 0; // Amount of decimals for display purposes\n', '        owner = msg.sender;\n', '        \n', '  \n', '    }\n', '\n', '    \n', '    function balanceOf(address tokenHolder) constant returns(uint256) {\n', '\n', '        return balanceOf[tokenHolder];\n', '    }\n', '\n', '    function totalSupply() constant returns(uint256) {\n', '\n', '        return totalSupply;\n', '    }\n', '\n', '    function getAccountCount() constant returns(uint256) {\n', '\n', '        return accountCount;\n', '    }\n', '\n', '    function getAddress(uint slot) constant returns(address) {\n', '\n', '        return accountIndex[slot];\n', '\n', '    }\n', '\n', '    \n', '    function appendTokenHolders(address tokenHolder) private {\n', '\n', '        if (balanceOf[tokenHolder] == 0) {\n', '            accountIndex[accountCount] = tokenHolder;\n', '            accountCount++;\n', '        }\n', '\n', '    }\n', '\n', '    \n', '    function transfer(address _to, uint256 _value) returns(bool ok) {\n', '        if (_to == 0x0) throw; \n', '        if (balanceOf[msg.sender] < _value) throw; \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        \n', '        appendTokenHolders(_to);\n', '        balanceOf[msg.sender] -= _value; \n', '        balanceOf[_to] += _value; \n', '        Transfer(msg.sender, _to, _value); \n', '        \n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value)\n', '    returns(bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval( msg.sender ,_spender, _value);\n', '        return true;\n', '    }\n', '\n', ' \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '    returns(bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', ' \n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {\n', '        if (_to == 0x0) throw;  \n', '        if (balanceOf[_from] < _value) throw;  \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  \n', '        if (_value > allowance[_from][msg.sender]) throw; \n', '        appendTokenHolders(_to);\n', '        balanceOf[_from] -= _value; \n', '        balanceOf[_to] += _value; \n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function burn(uint256 _value) returns(bool success) {\n', '        if (balanceOf[msg.sender] < _value) throw; \n', '        balanceOf[msg.sender] -= _value; \n', '        totalSupply -= _value; \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns(bool success) {\n', '    \n', '        if (balanceOf[_from] < _value) throw; \n', '        if (_value > allowance[_from][msg.sender]) throw; \n', '        balanceOf[_from] -= _value; \n', '        totalSupply -= _value; \n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', ' \n', '    \n', '}']