['pragma solidity ^0.4.16;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC677 is ERC20 {\n', '  function transferAndCall(address to, uint value, bytes data) returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', 'contract ERC677Receiver {\n', '  function onTokenTransfer(address _sender, uint _value, bytes _data);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '  function increaseApproval (address _spender, uint _addedValue) \n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) \n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC677Token is ERC677 {\n', '\n', '  function transferAndCall(address _to, uint _value, bytes _data)\n', '    public\n', '    returns (bool success)\n', '  {\n', '    super.transfer(_to, _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    if (isContract(_to)) {\n', '      contractFallback(_to, _value, _data);\n', '    }\n', '    return true;\n', '  }\n', '\n', '\n', '  function contractFallback(address _to, uint _value, bytes _data)\n', '    private\n', '  {\n', '    ERC677Receiver receiver = ERC677Receiver(_to);\n', '    receiver.onTokenTransfer(msg.sender, _value, _data);\n', '  }\n', '\n', '  function isContract(address _addr)\n', '    private\n', '    returns (bool hasCode)\n', '  {\n', '    uint length;\n', '    assembly { length := extcodesize(_addr) }\n', '    return length > 0;\n', '  }\n', '\n', '}\n', '\n', 'contract FormsToken is StandardToken, ERC677Token {\n', '\n', '  uint public constant totalSupply = 9311608e18;\n', "  string public constant name = 'FORMS';\n", '  uint8 public constant decimals = 18;\n', "  string public constant symbol = 'FMS';\n", '\n', '  function FormsToken()\n', '    public\n', '  {\n', '    balances[msg.sender] = totalSupply;\n', '  }\n', '\n', '  function transferAndCall(address _to, uint _value, bytes _data)\n', '    public\n', '    validRecipient(_to)\n', '    returns (bool success)\n', '  {\n', '    return super.transferAndCall(_to, _value, _data);\n', '  }\n', '\n', '  function transfer(address _to, uint _value)\n', '    public\n', '    validRecipient(_to)\n', '    returns (bool success)\n', '  {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value)\n', '    public\n', '    validRecipient(_spender)\n', '    returns (bool)\n', '  {\n', '    return super.approve(_spender,  _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public\n', '    validRecipient(_to)\n', '    returns (bool)\n', '  {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  modifier validRecipient(address _recipient) {\n', '    require(_recipient != address(0) && _recipient != address(this));\n', '    _;\n', '  }\n', '\n', '}']