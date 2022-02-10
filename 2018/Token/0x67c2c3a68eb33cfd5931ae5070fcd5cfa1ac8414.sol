['pragma solidity ^0.4.11;\n', '\n', '\n', 'interface ERC20 {\n', '    function totalSupply() constant returns (uint _totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', 'contract Unity3d is ERC20 {\n', '    string public constant symbol = "U3D";\n', '    string public constant name = "unity3d";\n', '    uint8 public constant decimals = 1;\n', '    \n', '    uint private constant __totalSupply = 12800000;\n', '    mapping (address => uint) private __balanceOf;\n', '    mapping (address => mapping (address => uint)) private __allowances;\n', '    \n', '    function MyFirstToken() {\n', '            __balanceOf[msg.sender] = __totalSupply;\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint _totalSupply) {\n', '        _totalSupply = __totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _addr) constant returns (uint balance) {\n', '        return __balanceOf[_addr];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) returns (bool success) {\n', '        if (_value > 0 && _value <= balanceOf(msg.sender)) {\n', '            __balanceOf[msg.sender] -= _value;\n', '            __balanceOf[_to] += _value;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '        if (__allowances[_from][msg.sender] > 0 &&\n', '            _value > 0 &&\n', '            __allowances[_from][msg.sender] >= _value && \n', '            __balanceOf[_from] >= _value) {\n', '            __balanceOf[_from] -= _value;\n', '            __balanceOf[_to] += _value;\n', '            // Missed from the video\n', '            __allowances[_from][msg.sender] -= _value;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) returns (bool success) {\n', '        __allowances[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '        return __allowances[_owner][_spender];\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '\n', 'interface ERC20 {\n', '    function totalSupply() constant returns (uint _totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', 'contract Unity3d is ERC20 {\n', '    string public constant symbol = "U3D";\n', '    string public constant name = "unity3d";\n', '    uint8 public constant decimals = 1;\n', '    \n', '    uint private constant __totalSupply = 12800000;\n', '    mapping (address => uint) private __balanceOf;\n', '    mapping (address => mapping (address => uint)) private __allowances;\n', '    \n', '    function MyFirstToken() {\n', '            __balanceOf[msg.sender] = __totalSupply;\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint _totalSupply) {\n', '        _totalSupply = __totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _addr) constant returns (uint balance) {\n', '        return __balanceOf[_addr];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) returns (bool success) {\n', '        if (_value > 0 && _value <= balanceOf(msg.sender)) {\n', '            __balanceOf[msg.sender] -= _value;\n', '            __balanceOf[_to] += _value;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '        if (__allowances[_from][msg.sender] > 0 &&\n', '            _value > 0 &&\n', '            __allowances[_from][msg.sender] >= _value && \n', '            __balanceOf[_from] >= _value) {\n', '            __balanceOf[_from] -= _value;\n', '            __balanceOf[_to] += _value;\n', '            // Missed from the video\n', '            __allowances[_from][msg.sender] -= _value;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) returns (bool success) {\n', '        __allowances[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '        return __allowances[_owner][_spender];\n', '    }\n', '}']