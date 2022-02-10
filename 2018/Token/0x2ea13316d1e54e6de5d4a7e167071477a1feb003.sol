['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint);\n', '  function transfer(address to, uint value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    if (a == 0) return 0;\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  function transfer(address _to, uint _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value > 0 && _value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '  function transferFrom(address from, address to, uint value) public returns (bool);\n', '  function approve(address spender, uint value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract TokenTimelock is StandardToken, Ownable {\n', '  struct Ice {\n', '    uint value;\n', '    uint time;\n', '  }\n', '  mapping (address => Ice[]) beneficiary;\n', '\n', '  event Freezing(address indexed to, uint value, uint time);\n', '  event UnFreeze(address indexed to, uint time, uint value);\n', '  event Crack(address indexed addr, uint time, uint value);\n', '\n', '  function freeze(address _to, uint _releaseTime, uint _value) public onlyOwner {\n', '    require(_to != address(0));\n', '    require(_value > 0 && _value <= balances[owner]);\n', '\n', '    // Check exist\n', '    uint i;\n', '    bool f;\n', '    while (i < beneficiary[_to].length) {\n', '      if (beneficiary[_to][i].time == _releaseTime) {\n', '        f = true;\n', '        break;\n', '      }\n', '      i++;\n', '    }\n', '\n', '    // Add data\n', '    if (f) {\n', '      beneficiary[_to][i].value = beneficiary[_to][i].value.add(_value);\n', '    } else {\n', '      Ice memory temp = Ice({\n', '          value: _value,\n', '          time: _releaseTime\n', '      });\n', '      beneficiary[_to].push(temp);\n', '    }\n', '    balances[owner] = balances[owner].sub(_value);\n', '    Freezing(_to, _value, _releaseTime);\n', '  }\n', '\n', '  function unfreeze(address _to) public onlyOwner {\n', '    Ice memory record;\n', '    for (uint i = 0; i < beneficiary[_to].length; i++) {\n', '      record = beneficiary[_to][i];\n', '      if (record.value > 0 && record.time < now) {\n', '        beneficiary[_to][i].value = 0;\n', '        balances[_to] = balances[_to].add(record.value);\n', '        UnFreeze(_to, record.time, record.value);\n', '      }\n', '    }\n', '  }\n', '\n', '  function clear(address _to, uint _time, uint _amount) public onlyOwner {\n', '    for (uint i = 0; i < beneficiary[_to].length; i++) {\n', '      if (beneficiary[_to][i].time == _time) {\n', '        beneficiary[_to][i].value = beneficiary[_to][i].value.sub(_amount);\n', '        balances[owner] = balances[owner].add(_amount);\n', '        Crack(_to, _time, _amount);\n', '        break;\n', '      }\n', '    }\n', '  }\n', '\n', '  function getBeneficiaryByTime(address _to, uint _time) public view returns(uint) {\n', '    for (uint i = 0; i < beneficiary[_to].length; i++) {\n', '      if (beneficiary[_to][i].time == _time) {\n', '        return beneficiary[_to][i].value;\n', '      }\n', '    }\n', '  }\n', '\n', '  function getBeneficiaryById(address _to, uint _id) public view returns(uint, uint) {\n', '    return (beneficiary[_to][_id].value, beneficiary[_to][_id].time);\n', '  }\n', '\n', '  function getNumRecords(address _to) public view returns(uint) {\n', '    return beneficiary[_to].length;\n', '  }\n', '}\n', '\n', '\n', 'contract GozToken is TokenTimelock {\n', "  string public constant name = 'GOZ';\n", "  string public constant symbol = 'GOZ';\n", '  uint32 public constant decimals = 18;\n', '  uint public constant initialSupply = 80E25;\n', '\n', '  function GozToken() public {\n', '    totalSupply = initialSupply;\n', '    balances[msg.sender] = initialSupply;\n', '  }\n', '}']