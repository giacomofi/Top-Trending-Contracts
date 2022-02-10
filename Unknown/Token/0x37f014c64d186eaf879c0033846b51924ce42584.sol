['pragma solidity ^0.4.8;\n', '\n', 'contract tokenRecipient { \n', '    \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); \n', '    \n', '}\n', '\n', 'contract MillionDollarToken {\n', '    \n', '    //~ Hashes for lookups\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    //~ Events\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    //~ Setup\n', '    string public standard = &#39;MillionDollarToken&#39;;\n', '    string public name = "MillionDollarToken";\n', '    string public symbol = "MDT";\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply = 1000;\n', '\n', '    //~ Init we set totalSupply\n', '    function MillionDollarToken() {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    //~~ Methods based on Token.sol from Ethereum Foundation\n', '    //~ Transfer FLIP\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) throw;                               \n', '        if (balanceOf[msg.sender] < _value) throw;           \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; \n', '        balanceOf[msg.sender] -= _value;                   \n', '        balanceOf[_to] += _value;                           \n', '        Transfer(msg.sender, _to, _value);                   \n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) throw;                                \n', '        if (balanceOf[_from] < _value) throw;                 \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  \n', '        if (_value > allowance[_from][msg.sender]) throw;     \n', '        balanceOf[_from] -= _value;                           \n', '        balanceOf[_to] += _value;                            \n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', 'contract tokenRecipient { \n', '    \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); \n', '    \n', '}\n', '\n', 'contract MillionDollarToken {\n', '    \n', '    //~ Hashes for lookups\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    //~ Events\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    //~ Setup\n', "    string public standard = 'MillionDollarToken';\n", '    string public name = "MillionDollarToken";\n', '    string public symbol = "MDT";\n', '    uint8 public decimals = 0;\n', '    uint256 public totalSupply = 1000;\n', '\n', '    //~ Init we set totalSupply\n', '    function MillionDollarToken() {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    //~~ Methods based on Token.sol from Ethereum Foundation\n', '    //~ Transfer FLIP\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) throw;                               \n', '        if (balanceOf[msg.sender] < _value) throw;           \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; \n', '        balanceOf[msg.sender] -= _value;                   \n', '        balanceOf[_to] += _value;                           \n', '        Transfer(msg.sender, _to, _value);                   \n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }        \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) throw;                                \n', '        if (balanceOf[_from] < _value) throw;                 \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  \n', '        if (_value > allowance[_from][msg.sender]) throw;     \n', '        balanceOf[_from] -= _value;                           \n', '        balanceOf[_to] += _value;                            \n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
