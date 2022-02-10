['pragma solidity ^0.4.13;\n', '\n', 'contract ERC20Interface {\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ViewCoin is ERC20Interface {\n', '  string public constant symbol = "VJU";\n', '  string public constant name = "ViewCoin";\n', '  uint8 public constant decimals = 0;\n', '  uint256 _totalSupply = 100000000;\n', '  uint256 public maxSell = 50000000;\n', '  uint256 public totalSold = 0;\n', '  uint256 public buyPrice = 5 szabo;\n', '  uint256 public minPrice = 5 szabo;\n', '  address public owner;\n', '  mapping(address => uint256) balances;\n', '  mapping(address => mapping (address => uint256)) allowed;\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {revert();}\n', '    _;\n', '  }\n', '  \n', '  function ViewCoin() {\n', '    owner = msg.sender;\n', '    balances[owner] = _totalSupply;\n', '  }\n', '   \n', '  function totalSupply() constant returns (uint256 totalSupply) {\n', '    totalSupply = _totalSupply;\n', '  }\n', '   \n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '   \n', '  function transfer(address _to, uint256 _amount) returns (bool success) {\n', '    if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {\n', '      balances[msg.sender] -= _amount;\n', '      balances[_to] += _amount;\n', '      Transfer(msg.sender, _to, _amount);\n', '      return true;\n', '    } else {return false;}\n', '  }\n', '   \n', '  function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {\n', '    if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {\n', '      balances[_from] -= _amount;\n', '       allowed[_from][msg.sender] -= _amount;\n', '       balances[_to] += _amount;\n', '       Transfer(_from, _to, _amount);\n', '       return true;\n', '    } else {return false;}\n', '  }\n', '  \n', '  function approve(address _spender, uint256 _amount) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '  \n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '  function setPrices(uint256 newBuyPrice) onlyOwner {\n', '        if (newBuyPrice<minPrice) revert();\n', '        buyPrice = newBuyPrice*1 szabo;\n', '    }\n', '\n', '  function () payable {\n', '    uint amount = msg.value / buyPrice;\n', '    if (totalSold>=maxSell || balances[this] < amount) revert(); \n', '    balances[msg.sender] += amount;\n', '    balances[this] -= amount;\n', '    totalSold += amount; \n', '    Transfer(this, msg.sender, amount);\n', '    if (!owner.send(msg.value)) revert();\n', '  }\n', '   \n', '}']