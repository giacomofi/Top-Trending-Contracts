['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function batchTransfer(address[] receivers, uint256[] values) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '  uint256 internal totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function batchTransfer(address[] _receivers, uint256[] _values) public returns (bool) {\n', '    require(_receivers.length > 0);\n', '    require(_receivers.length < 100000);\n', '    require(_receivers.length == _values.length);\n', '\n', '    uint256 sum;\n', '    for(uint i = 0; i < _values.length; i++) {\n', '      sum = sum.add(_values[i]);\n', '    }\n', '    require(sum <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(sum);\n', '    for(uint j = 0; j < _receivers.length; j++) {\n', '      balances[_receivers[j]] = balances[_receivers[j]].add(_values[j]);\n', '      emit Transfer(msg.sender, _receivers[j], _values[j]);\n', '    }\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract DistributedLotteryPlatform is BasicToken {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor() public {\n', '    name = "Distributed Lottery Platform";\n', '    symbol = "DLP";\n', '    decimals = 18;\n', '    totalSupply_ = 1e28;\n', '    balances[msg.sender]=totalSupply_;\n', '    emit Transfer(address(0), msg.sender, totalSupply_);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function batchTransfer(address[] receivers, uint256[] values) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '  uint256 internal totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function batchTransfer(address[] _receivers, uint256[] _values) public returns (bool) {\n', '    require(_receivers.length > 0);\n', '    require(_receivers.length < 100000);\n', '    require(_receivers.length == _values.length);\n', '\n', '    uint256 sum;\n', '    for(uint i = 0; i < _values.length; i++) {\n', '      sum = sum.add(_values[i]);\n', '    }\n', '    require(sum <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(sum);\n', '    for(uint j = 0; j < _receivers.length; j++) {\n', '      balances[_receivers[j]] = balances[_receivers[j]].add(_values[j]);\n', '      emit Transfer(msg.sender, _receivers[j], _values[j]);\n', '    }\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract DistributedLotteryPlatform is BasicToken {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor() public {\n', '    name = "Distributed Lottery Platform";\n', '    symbol = "DLP";\n', '    decimals = 18;\n', '    totalSupply_ = 1e28;\n', '    balances[msg.sender]=totalSupply_;\n', '    emit Transfer(address(0), msg.sender, totalSupply_);\n', '  }\n', '}']