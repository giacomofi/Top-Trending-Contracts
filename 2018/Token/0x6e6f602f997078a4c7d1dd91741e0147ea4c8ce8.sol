['pragma solidity ^0.4.24;\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract SXDT is ERC20 {\n', '\n', '  string public constant name = "Spectre.ai D-Token";\n', '  string public constant symbol = "SXDT";\n', '  uint8 public constant decimals = 18; \n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '  mapping (address => uint) balances;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] +=_value;\n', '    balances[_from] -= _value;\n', '    allowed[_from][msg.sender] -= _value;\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function transfer(address _to, uint _value) {\n', '    balances[msg.sender] -= _value;\n', '    balances[_to] += _value;\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function StandardToken(){\n', '  balances[msg.sender] = 100000000000000000000000000;\n', '}\n', '}']