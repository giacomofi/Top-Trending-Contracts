['pragma solidity ^0.4.21;\n', '\n', '// ----------------------------------------------------------------------------\n', '// TOKENMOM Korean Won(KRWT) Smart contract Token V.10\n', '// 토큰맘 거래소 Korean Won 스마트 컨트랙트 토큰\n', '// Deployed to : 0x8af2d2e23f0913af81abc6ccaa6200c945a161b4\n', '// Symbol      : BETA\n', '// Name        : TOKENMOM Korean Won\n', '// Total supply: 10000000000\n', '// Decimals    : 8\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  function burn(uint256 _value) public {\n', '    require(_value <= balances[msg.sender]);\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract CappedToken is MintableToken {\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedToken(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    require(totalSupply_.add(_amount) <= cap);\n', '\n', '    return super.mint(_to, _amount);\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract ERC827 is ERC20 {\n', '\n', '  function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);\n', '  function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value,\n', '    bytes _data\n', '  )\n', '    public\n', '    returns (bool);\n', '\n', '}\n', '\n', 'contract ERC827Token is ERC827, StandardToken {\n', '\n', '  function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.approve(_spender, _value);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {\n', '    require(_to != address(this));\n', '\n', '    super.transfer(_to, _value);\n', '\n', '    require(_to.call(_data));\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value,\n', '    bytes _data\n', '  )\n', '    public returns (bool)\n', '  {\n', '    require(_to != address(this));\n', '\n', '    super.transferFrom(_from, _to, _value);\n', '\n', '    require(_to.call(_data));\n', '    return true;\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.increaseApproval(_spender, _addedValue);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '    require(_spender.call(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract KRWT is StandardToken, MintableToken, BurnableToken, PausableToken {\n', '    string constant public name = "Korean Won";\n', '    string constant public symbol = "KRWT";\n', '    uint8 constant public decimals = 8;\n', '    uint256 public totalSupply_ = 10000000000  * (10 ** uint256(decimals));\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Pause(address indexed from, uint256 value);\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    function KRWT () public {\n', '        balances[msg.sender] = totalSupply_;\n', '        Transfer(address(0), msg.sender, totalSupply_);\n', '    }\n', '}']