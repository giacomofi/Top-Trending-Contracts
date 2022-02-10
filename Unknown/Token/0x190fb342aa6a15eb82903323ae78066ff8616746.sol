['pragma solidity ^0.4.2;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) balances;\n', '  \n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '  */\n', '  modifier onlyPayloadSize(uint size) {\n', '     require(msg.data.length >= size + 4);\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract PullPayment {\n', '\n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) public payments;\n', '\n', '  event LogRefundETH(address to, uint value);\n', '\n', '\n', '  /**\n', '  *  Store sent amount as credit to be pulled, called by payer \n', '  **/\n', '  function asyncSend(address dest, uint amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '  }\n', '\n', '  // withdraw accumulated balance, called by payee\n', '  function withdrawPayments() {\n', '    address payee = msg.sender;\n', '    uint payment = payments[payee];\n', '    \n', '    require (payment > 0);\n', '    require (this.balance >= payment);\n', '\n', '    payments[payee] = 0;\n', '\n', '    require (payee.send(payment));\n', '    \n', '    LogRefundETH(payee,payment);\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  bool public stopped;\n', '\n', '  modifier stopInEmergency {\n', '    require(!stopped);\n', '    _;\n', '  }\n', '  \n', '  modifier onlyInEmergency {\n', '    require(stopped);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function emergencyStop() external onlyOwner {\n', '    stopped = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function release() external onlyOwner onlyInEmergency {\n', '    stopped = false;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' *  UmbrellaCoin token contract.\n', ' */\n', 'contract UmbrellaCoin is StandardToken, Ownable {\n', '  string public constant name = "UmbrellaCoin";\n', '  string public constant symbol = "UMC";\n', '  uint public constant decimals = 6;\n', '  address public floatHolder;\n', '\n', '  // Constructor\n', '  function UmbrellaCoin() {\n', '      totalSupply = 100000000000000;\n', '      balances[msg.sender] = totalSupply; // Send all tokens to owner\n', '      floatHolder = msg.sender;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.2;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) balances;\n', '  \n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '  */\n', '  modifier onlyPayloadSize(uint size) {\n', '     require(msg.data.length >= size + 4);\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', 'contract PullPayment {\n', '\n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) public payments;\n', '\n', '  event LogRefundETH(address to, uint value);\n', '\n', '\n', '  /**\n', '  *  Store sent amount as credit to be pulled, called by payer \n', '  **/\n', '  function asyncSend(address dest, uint amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '  }\n', '\n', '  // withdraw accumulated balance, called by payee\n', '  function withdrawPayments() {\n', '    address payee = msg.sender;\n', '    uint payment = payments[payee];\n', '    \n', '    require (payment > 0);\n', '    require (this.balance >= payment);\n', '\n', '    payments[payee] = 0;\n', '\n', '    require (payee.send(payment));\n', '    \n', '    LogRefundETH(payee,payment);\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  bool public stopped;\n', '\n', '  modifier stopInEmergency {\n', '    require(!stopped);\n', '    _;\n', '  }\n', '  \n', '  modifier onlyInEmergency {\n', '    require(stopped);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function emergencyStop() external onlyOwner {\n', '    stopped = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function release() external onlyOwner onlyInEmergency {\n', '    stopped = false;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' *  UmbrellaCoin token contract.\n', ' */\n', 'contract UmbrellaCoin is StandardToken, Ownable {\n', '  string public constant name = "UmbrellaCoin";\n', '  string public constant symbol = "UMC";\n', '  uint public constant decimals = 6;\n', '  address public floatHolder;\n', '\n', '  // Constructor\n', '  function UmbrellaCoin() {\n', '      totalSupply = 100000000000000;\n', '      balances[msg.sender] = totalSupply; // Send all tokens to owner\n', '      floatHolder = msg.sender;\n', '  }\n', '\n', '}']
