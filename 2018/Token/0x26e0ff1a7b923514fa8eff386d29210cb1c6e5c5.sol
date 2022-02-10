['pragma solidity ^0.4.16;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) pure internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) pure internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) pure internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract StandardToken {\n', '  using SafeMath for uint256;\n', '  uint256 public totalSupply;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value > 0 && _value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value > 0 && _value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', 'contract AirdropToken is StandardToken, Ownable {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals = 18;\n', '\n', '  constructor(string _name, string _symbol) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    totalSupply = 10000000000 * 1 ether;\n', '    balances[msg.sender] = totalSupply;\n', '  }\n', '\n', '  function batchTransfer(address[] _receivers, uint _ether_value) onlyOwner public returns (bool) {\n', '    uint cnt = _receivers.length;\n', '    uint256 _value = _ether_value;\n', '\n', '    for (uint i = 0; i < cnt; i++) {\n', '      balances[_receivers[i]] += _value;\n', '      emit Transfer(msg.sender, _receivers[i], _value);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  function kill() {\n', '    if (owner == msg.sender) {\n', '      selfdestruct(owner);\n', '    }\n', '  }\n', '\n', '  function() payable external {}\n', '}']