['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract ATL is StandardToken {\n', '\n', '  string public name = "ATLANT Token";\n', '  string public symbol = "ATL";\n', '  uint public decimals = 18;\n', '  uint constant TOKEN_LIMIT = 150 * 1e6 * 1e18;\n', '\n', '  address public ico;\n', '\n', '  bool public tokensAreFrozen = true;\n', '\n', '  function ATL(address _ico) {\n', '    ico = _ico;\n', '  }\n', '\n', '  function mint(address _holder, uint _value) external {\n', '    require(msg.sender == ico);\n', '    require(_value != 0);\n', '    require(totalSupply + _value <= TOKEN_LIMIT);\n', '\n', '    balances[_holder] += _value;\n', '    totalSupply += _value;\n', '    Transfer(0x0, _holder, _value);\n', '  }\n', '\n', '  function unfreeze() external {\n', '    require(msg.sender == ico);\n', '    tokensAreFrozen = false;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) public {\n', '    require(!tokensAreFrozen);\n', '    super.transfer(_to, _value);\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public {\n', '    require(!tokensAreFrozen);\n', '    super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint _value) public {\n', '    require(!tokensAreFrozen);\n', '    super.approve(_spender, _value);\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract ATL is StandardToken {\n', '\n', '  string public name = "ATLANT Token";\n', '  string public symbol = "ATL";\n', '  uint public decimals = 18;\n', '  uint constant TOKEN_LIMIT = 150 * 1e6 * 1e18;\n', '\n', '  address public ico;\n', '\n', '  bool public tokensAreFrozen = true;\n', '\n', '  function ATL(address _ico) {\n', '    ico = _ico;\n', '  }\n', '\n', '  function mint(address _holder, uint _value) external {\n', '    require(msg.sender == ico);\n', '    require(_value != 0);\n', '    require(totalSupply + _value <= TOKEN_LIMIT);\n', '\n', '    balances[_holder] += _value;\n', '    totalSupply += _value;\n', '    Transfer(0x0, _holder, _value);\n', '  }\n', '\n', '  function unfreeze() external {\n', '    require(msg.sender == ico);\n', '    tokensAreFrozen = false;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) public {\n', '    require(!tokensAreFrozen);\n', '    super.transfer(_to, _value);\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint _value) public {\n', '    require(!tokensAreFrozen);\n', '    super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint _value) public {\n', '    require(!tokensAreFrozen);\n', '    super.approve(_spender, _value);\n', '  }\n', '}']