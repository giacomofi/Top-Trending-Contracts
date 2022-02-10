['pragma solidity ^0.4.16;\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', ' contract ERC20Interface {\n', '     function totalSupply() constant returns (uint256 totalSupply);\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', '  \n', ' contract MyToken is ERC20Interface {\n', '      string public constant symbol = "FOD"; \n', '      string public constant name = "fodcreate";   \n', '      uint8 public constant decimals = 18;\n', '      uint256 _totalSupply = 2000000000000000000000000000; \n', '     \n', '      address public owner;\n', '  \n', '      mapping(address => uint256) balances;\n', '  \n', '      mapping(address => mapping (address => uint256)) allowed;\n', '  \n', '      function MyToken() {\n', '          owner = msg.sender;\n', '          balances[owner] = _totalSupply;\n', '      }\n', '  \n', '      function totalSupply() constant returns (uint256 totalSupply) {\n', '         totalSupply = _totalSupply;\n', '      }\n', '  \n', '      // What is the balance of a particular account?\n', '      function balanceOf(address _owner) constant returns (uint256 balance) {\n', '         return balances[_owner];\n', '      }\n', '   \n', '      // Transfer the balance from owner&#39;s account to another account\n', '      function transfer(address _to, uint256 _amount) returns (bool success) {\n', '         if (balances[msg.sender] >= _amount) {\n', '            balances[msg.sender] = SafeMath.sub(balances[msg.sender],_amount);\n', '            balances[_to] = SafeMath.add(balances[_to],_amount);\n', '            \n', '            return true;\n', '         }\n', '         \n', '         return false;\n', '      }\n', '      \n', '      function transferFrom(\n', '          address _from,\n', '          address _to,\n', '         uint256 _amount\n', '    ) returns (bool success) {\n', '         require(_to != address(0));\n', '    \n', '         if (balances[_from] >= _amount) {\n', '            balances[_from] = SafeMath.sub(balances[_from],_amount);\n', '            balances[_to] = SafeMath.add(balances[_to],_amount);\n', '            \n', '            return true;\n', '         }\n', '         \n', '         return false;\n', '     }\n', '  \n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '}']
['pragma solidity ^0.4.16;\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', ' contract ERC20Interface {\n', '     function totalSupply() constant returns (uint256 totalSupply);\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' }\n', '  \n', ' contract MyToken is ERC20Interface {\n', '      string public constant symbol = "FOD"; \n', '      string public constant name = "fodcreate";   \n', '      uint8 public constant decimals = 18;\n', '      uint256 _totalSupply = 2000000000000000000000000000; \n', '     \n', '      address public owner;\n', '  \n', '      mapping(address => uint256) balances;\n', '  \n', '      mapping(address => mapping (address => uint256)) allowed;\n', '  \n', '      function MyToken() {\n', '          owner = msg.sender;\n', '          balances[owner] = _totalSupply;\n', '      }\n', '  \n', '      function totalSupply() constant returns (uint256 totalSupply) {\n', '         totalSupply = _totalSupply;\n', '      }\n', '  \n', '      // What is the balance of a particular account?\n', '      function balanceOf(address _owner) constant returns (uint256 balance) {\n', '         return balances[_owner];\n', '      }\n', '   \n', "      // Transfer the balance from owner's account to another account\n", '      function transfer(address _to, uint256 _amount) returns (bool success) {\n', '         if (balances[msg.sender] >= _amount) {\n', '            balances[msg.sender] = SafeMath.sub(balances[msg.sender],_amount);\n', '            balances[_to] = SafeMath.add(balances[_to],_amount);\n', '            \n', '            return true;\n', '         }\n', '         \n', '         return false;\n', '      }\n', '      \n', '      function transferFrom(\n', '          address _from,\n', '          address _to,\n', '         uint256 _amount\n', '    ) returns (bool success) {\n', '         require(_to != address(0));\n', '    \n', '         if (balances[_from] >= _amount) {\n', '            balances[_from] = SafeMath.sub(balances[_from],_amount);\n', '            balances[_to] = SafeMath.add(balances[_to],_amount);\n', '            \n', '            return true;\n', '         }\n', '         \n', '         return false;\n', '     }\n', '  \n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '}']
