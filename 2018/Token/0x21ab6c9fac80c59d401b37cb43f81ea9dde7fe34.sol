['pragma solidity ^0.4.8;\n', '\n', '   \n', '\n', 'interface ERC20Interface {\n', '\n', '   \n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) ;\n', '\n', '       \n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '       \n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '       \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '       \n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '       \n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '       \n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '       \n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '       \n', '\n', ' }\n', '\n', '     \n', '\n', ' contract BRC is ERC20Interface {\n', '\n', '      string public constant symbol = "BRC";\n', '\n', '      string public constant name = "Baer Chain";\n', '\n', '      uint8 public constant decimals = 8;\n', '\n', '      uint256 _totalSupply = 58000000000000000;\n', '\n', '    \n', '\n', '      address public owner;\n', '\n', '      \n', '\n', '      mapping(address => uint256) balances;\n', '\n', '      \n', '\n', '    \n', '\n', '      mapping(address => mapping (address => uint256)) allowed;\n', '\n', '      \n', '\n', '         \n', '\n', '      modifier onlyOwner() {\n', '\n', '          if (msg.sender != owner) {\n', '\n', '              throw;\n', '\n', '          }\n', '\n', '          _;\n', '\n', '      }\n', '\n', '      \n', '\n', '      function BRC() {\n', '\n', '          owner = msg.sender;\n', '\n', '          balances[owner] = _totalSupply;\n', '\n', '      }\n', '\n', '      \n', '\n', '      function totalSupply() constant returns (uint256 totalSupply) {\n', '\n', '          totalSupply = _totalSupply;\n', '\n', '      }\n', '\n', '      \n', '\n', '      function balanceOf(address _owner) constant returns (uint256 balance) {\n', '\n', '          return balances[_owner];\n', '\n', '      }\n', '\n', '      \n', '\n', '      function transfer(address _to, uint256 _amount) returns (bool success) {\n', '\n', '          if (balances[msg.sender] >= _amount \n', '\n', '              && _amount > 0\n', '\n', '              && balances[_to] + _amount > balances[_to]) {\n', '\n', '              balances[msg.sender] -= _amount;\n', '\n', '              balances[_to] += _amount;\n', '\n', '              Transfer(msg.sender, _to, _amount);\n', '\n', '              return true;\n', '\n', '          } else {\n', '\n', '              return false;\n', '\n', '          }\n', '\n', '      }\n', '\n', '      \n', '\n', '      function transferFrom(\n', '\n', '          address _from,\n', '\n', '          address _to,\n', '\n', '          uint256 _amount\n', '\n', '     ) returns (bool success) {\n', '\n', '         if (balances[_from] >= _amount\n', '\n', '             && allowed[_from][msg.sender] >= _amount\n', '\n', '             && _amount > 0\n', '\n', '             && balances[_to] + _amount > balances[_to]) {\n', '\n', '             balances[_from] -= _amount;\n', '\n', '             allowed[_from][msg.sender] -= _amount;\n', '\n', '             balances[_to] += _amount;\n', '\n', '             Transfer(_from, _to, _amount);\n', '\n', '             return true;\n', '\n', '         } else {\n', '\n', '             return false;\n', '\n', '         }\n', '\n', '     }\n', '\n', '   \n', '\n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '\n', '         allowed[msg.sender][_spender] = _amount;\n', '\n', '         Approval(msg.sender, _spender, _amount);\n', '\n', '         return true;\n', '\n', '     }\n', '\n', '     \n', '\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '         return allowed[_owner][_spender];\n', '\n', '     }\n', '\n', ' }']
['pragma solidity ^0.4.8;\n', '\n', '   \n', '\n', 'interface ERC20Interface {\n', '\n', '   \n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) ;\n', '\n', '       \n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '       \n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '       \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '       \n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '       \n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '       \n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '       \n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '       \n', '\n', ' }\n', '\n', '     \n', '\n', ' contract BRC is ERC20Interface {\n', '\n', '      string public constant symbol = "BRC";\n', '\n', '      string public constant name = "Baer Chain";\n', '\n', '      uint8 public constant decimals = 8;\n', '\n', '      uint256 _totalSupply = 58000000000000000;\n', '\n', '    \n', '\n', '      address public owner;\n', '\n', '      \n', '\n', '      mapping(address => uint256) balances;\n', '\n', '      \n', '\n', '    \n', '\n', '      mapping(address => mapping (address => uint256)) allowed;\n', '\n', '      \n', '\n', '         \n', '\n', '      modifier onlyOwner() {\n', '\n', '          if (msg.sender != owner) {\n', '\n', '              throw;\n', '\n', '          }\n', '\n', '          _;\n', '\n', '      }\n', '\n', '      \n', '\n', '      function BRC() {\n', '\n', '          owner = msg.sender;\n', '\n', '          balances[owner] = _totalSupply;\n', '\n', '      }\n', '\n', '      \n', '\n', '      function totalSupply() constant returns (uint256 totalSupply) {\n', '\n', '          totalSupply = _totalSupply;\n', '\n', '      }\n', '\n', '      \n', '\n', '      function balanceOf(address _owner) constant returns (uint256 balance) {\n', '\n', '          return balances[_owner];\n', '\n', '      }\n', '\n', '      \n', '\n', '      function transfer(address _to, uint256 _amount) returns (bool success) {\n', '\n', '          if (balances[msg.sender] >= _amount \n', '\n', '              && _amount > 0\n', '\n', '              && balances[_to] + _amount > balances[_to]) {\n', '\n', '              balances[msg.sender] -= _amount;\n', '\n', '              balances[_to] += _amount;\n', '\n', '              Transfer(msg.sender, _to, _amount);\n', '\n', '              return true;\n', '\n', '          } else {\n', '\n', '              return false;\n', '\n', '          }\n', '\n', '      }\n', '\n', '      \n', '\n', '      function transferFrom(\n', '\n', '          address _from,\n', '\n', '          address _to,\n', '\n', '          uint256 _amount\n', '\n', '     ) returns (bool success) {\n', '\n', '         if (balances[_from] >= _amount\n', '\n', '             && allowed[_from][msg.sender] >= _amount\n', '\n', '             && _amount > 0\n', '\n', '             && balances[_to] + _amount > balances[_to]) {\n', '\n', '             balances[_from] -= _amount;\n', '\n', '             allowed[_from][msg.sender] -= _amount;\n', '\n', '             balances[_to] += _amount;\n', '\n', '             Transfer(_from, _to, _amount);\n', '\n', '             return true;\n', '\n', '         } else {\n', '\n', '             return false;\n', '\n', '         }\n', '\n', '     }\n', '\n', '   \n', '\n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '\n', '         allowed[msg.sender][_spender] = _amount;\n', '\n', '         Approval(msg.sender, _spender, _amount);\n', '\n', '         return true;\n', '\n', '     }\n', '\n', '     \n', '\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '         return allowed[_owner][_spender];\n', '\n', '     }\n', '\n', ' }']
