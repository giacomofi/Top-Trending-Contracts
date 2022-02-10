['pragma solidity ^0.4.10;\n', '\n', 'contract ERC20Interface {    \n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract UBCToken is ERC20Interface{\n', '    string public standard = &#39;Token 1.0&#39;;\n', '    string public constant name="Ubiquitous Business Credit";\n', '    string public constant symbol="UBC";\n', '    uint8 public constant decimals=4;\n', '    uint256 public constant _totalSupply=10000000000000;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => uint256) balances;\n', '\n', '    /* 全部*/\n', '    function UBCToken() {\n', '        balances[msg.sender] = _totalSupply; \n', '    }\n', '   function totalSupply() constant returns (uint256 totalSupply) {\n', '          totalSupply = _totalSupply;\n', '    }\n', '    \n', '    /*balanceOf*/\n', '    function balanceOf(address _owner) constant returns (uint256 balance){\n', '        return balances[_owner]; \n', '    }\n', '\n', '    /* transfer */\n', '    function transfer(address _to, uint256 _amount) returns (bool success)  {\n', '       if (balances[msg.sender] >= _amount \n', '              && _amount > 0\n', '              && balances[_to] + _amount > balances[_to]) {\n', '              balances[msg.sender] -= _amount;\n', '              balances[_to] += _amount;\n', '              Transfer(msg.sender, _to, _amount);\n', '              return true;\n', '          } else {\n', '              return false;\n', '          }          \n', '    }\n', '\n', '    /*transferFrom*/\n', '    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success){\n', '        if (balances[_from] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]  && _amount <= allowed[_from][msg.sender]) {\n', '             balances[_from] -= _amount;\n', '             balances[_to] += _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '    }\n', '\n', '    /**/\n', '    function approve(address _spender, uint256 _value) \n', '        returns (bool success){\n', '         allowed[msg.sender][_spender] = _value;\n', '         Approval(msg.sender, _spender, _value);\n', '         return true;\n', '    }\n', '    /**/\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']