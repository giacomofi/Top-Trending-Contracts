['pragma solidity ^0.4.13;\n', '\n', '\n', 'contract ERC20Interface {\n', '     \n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);  \n', '    function transfer(address _to, uint256 _value) returns (bool success);  \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', '  \n', ' contract Cipher is ERC20Interface {\n', '    string public constant symbol = "CPR";\n', '    string public constant name = "Cipher";\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply = 1080000000000000000000000000;\n', '    address public owner;\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    modifier onlyOwner() {\n', '        require(msg.sender != owner); {\n', '             \n', '        }\n', '          _;\n', '    }\n', '   \n', '    function Cipher() {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '  \n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        totalSupply = _totalSupply;\n', '    }\n', '  \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '   \n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount \n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '            }\n', '      }\n', '   \n', '      function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) returns (bool success) {\n', '       if (balances[_from] >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '        } else {\n', '            return false;\n', '         }\n', '     }\n', '  \n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '\n', 'contract ERC20Interface {\n', '     \n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);  \n', '    function transfer(address _to, uint256 _value) returns (bool success);  \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', '  \n', ' contract Cipher is ERC20Interface {\n', '    string public constant symbol = "CPR";\n', '    string public constant name = "Cipher";\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply = 1080000000000000000000000000;\n', '    address public owner;\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    modifier onlyOwner() {\n', '        require(msg.sender != owner); {\n', '             \n', '        }\n', '          _;\n', '    }\n', '   \n', '    function Cipher() {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '  \n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        totalSupply = _totalSupply;\n', '    }\n', '  \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '   \n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount \n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '            }\n', '      }\n', '   \n', '      function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) returns (bool success) {\n', '       if (balances[_from] >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '        } else {\n', '            return false;\n', '         }\n', '     }\n', '  \n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '}']