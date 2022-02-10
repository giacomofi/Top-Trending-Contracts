['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20Standard {\n', ' uint public totalSupply;\n', ' \n', ' string public name;\n', ' uint8 public decimals;\n', ' string public symbol;\n', ' string public version;\n', ' \n', ' mapping (address => uint256) balances;\n', ' mapping (address => mapping (address => uint)) allowed;\n', '\n', ' //Fix for short address attack against ERC20\n', ' modifier onlyPayloadSize(uint size) {\n', '  assert(msg.data.length == size + 4);\n', '  _;\n', ' } \n', '\n', ' function balanceOf(address _owner) constant returns (uint balance) {\n', '  return balances[_owner];\n', ' }\n', '\n', ' function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {\n', '  require(balances[msg.sender] >= _value && _value > 0);\n', '     balances[msg.sender] -= _value;\n', '     balances[_recipient] += _value;\n', '     Transfer(msg.sender, _recipient, _value);        \n', '    }\n', '\n', ' function transferFrom(address _from, address _to, uint _value) {\n', '  require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', ' function approve(address _spender, uint _value) {\n', '  allowed[msg.sender][_spender] = _value;\n', '  Approval(msg.sender, _spender, _value);\n', ' }\n', '\n', ' function allowance(address _spender, address _owner) constant returns (uint balance) {\n', '  return allowed[_owner][_spender];\n', ' }\n', '\n', " //Event which is triggered to log all transfers to this contract's event log\n", ' event Transfer(\n', '  address indexed _from,\n', '  address indexed _to,\n', '  uint _value\n', '  );\n', '  \n', ' //Event which is triggered whenever an owner approves a new allowance for a spender.\n', ' event Approval(\n', '  address indexed _owner,\n', '  address indexed _spender,\n', '  uint _value\n', '  );\n', '\n', '}\n', 'contract NewToken is ERC20Standard {\n', ' function NewToken() {\n', '  totalSupply = 10000000000000000000000000000;\n', '  name = "Fext Coin";\n', '  decimals = 18;\n', '  symbol = "FEXT";\n', '  version = "1.0";\n', '  balances[msg.sender] = totalSupply;\n', ' }\n', '}']