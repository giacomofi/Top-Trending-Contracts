['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract ShitToken {\n', '  using SafeMath for uint256;\n', '\n', '  string public constant name = "Shit";\n', '  string public constant symbol = "SHT";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public totalSupply;\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '  address crowdsaleWallet;\n', '  address owner;\n', '\n', '  // Christmas!\n', '  uint256 saleEndDate = 1498348800;\n', '\n', '  // Hopefully this is enough, we might run a second and third sale if not!\n', '  uint256 public beerAndHookersCap = 500000 ether;\n', '  uint256 public shitRate = 419;\n', '  uint256 public totalEtherReceived;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '  event Created(address indexed donor, uint256 amount, uint256 tokens);\n', '\n', '  function () payable {\n', '    require(now < saleEndDate);\n', '    require(msg.value > 0);\n', '    require(totalEtherReceived.add(msg.value) <= beerAndHookersCap);\n', '    uint256 tokens = msg.value.mul(shitRate);\n', '    balances[msg.sender] = balances[msg.sender].add(tokens);\n', '    totalEtherReceived = totalEtherReceived.add(msg.value);\n', '    totalSupply = totalSupply.add(tokens);\n', '    Created(msg.sender, msg.value, tokens);\n', '    crowdsaleWallet.transfer(msg.value);\n', '  }\n', '\n', '  function ShitToken(address _crowdsaleWallet) {\n', '    require(_crowdsaleWallet != 0x0);\n', '    owner = msg.sender;\n', '    crowdsaleWallet = _crowdsaleWallet;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function suicide() {\n', '    require(msg.sender == owner);\n', '    selfdestruct(owner);\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract ShitToken {\n', '  using SafeMath for uint256;\n', '\n', '  string public constant name = "Shit";\n', '  string public constant symbol = "SHT";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public totalSupply;\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '  address crowdsaleWallet;\n', '  address owner;\n', '\n', '  // Christmas!\n', '  uint256 saleEndDate = 1498348800;\n', '\n', '  // Hopefully this is enough, we might run a second and third sale if not!\n', '  uint256 public beerAndHookersCap = 500000 ether;\n', '  uint256 public shitRate = 419;\n', '  uint256 public totalEtherReceived;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '  event Created(address indexed donor, uint256 amount, uint256 tokens);\n', '\n', '  function () payable {\n', '    require(now < saleEndDate);\n', '    require(msg.value > 0);\n', '    require(totalEtherReceived.add(msg.value) <= beerAndHookersCap);\n', '    uint256 tokens = msg.value.mul(shitRate);\n', '    balances[msg.sender] = balances[msg.sender].add(tokens);\n', '    totalEtherReceived = totalEtherReceived.add(msg.value);\n', '    totalSupply = totalSupply.add(tokens);\n', '    Created(msg.sender, msg.value, tokens);\n', '    crowdsaleWallet.transfer(msg.value);\n', '  }\n', '\n', '  function ShitToken(address _crowdsaleWallet) {\n', '    require(_crowdsaleWallet != 0x0);\n', '    owner = msg.sender;\n', '    crowdsaleWallet = _crowdsaleWallet;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function suicide() {\n', '    require(msg.sender == owner);\n', '    selfdestruct(owner);\n', '  }\n', '}']