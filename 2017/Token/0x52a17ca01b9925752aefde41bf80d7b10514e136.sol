['pragma solidity ^0.4.18;\n', ' \n', '/* \n', '    Pump it up, \n', '    get rich, \n', '    buy lambo, \n', '    enjoy cool life\n', ' */\n', ' \n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', ' \n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', ' \n', ' function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', ' \n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', ' \n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '   require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', ' \n', '  /*\n', '  Function to check the amount of tokens that an owner allowed to a spender.\n', '  param _owner address The address which owns the funds.\n', '  param _spender address The address which will spend the funds.\n', '  return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '}\n', '}\n', ' \n', '/*\n', 'The Ownable contract has an owner address, and provides basic authorization control\n', ' functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '  address public owner;\n', ' \n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '  /*\n', '  Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', ' \n', '  /*\n', '  Allows the current owner to transfer control of the contract to a newOwner.\n', '  param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '}\n', '  \n', 'contract Pumpcoin is StandardToken, Ownable {\n', '  string public constant name = "Pump coin";\n', '  string public constant symbol = "PUMP";\n', '  uint public constant decimals = 15;\n', '  uint256 public initialSupply;\n', '    \n', '  function Pumpcoin () { \n', '     totalSupply = 1000000 * 10 ** decimals;\n', '      balances[msg.sender] = totalSupply;\n', '      initialSupply = totalSupply; \n', '        Transfer(0, this, totalSupply);\n', '        Transfer(this, msg.sender, totalSupply);\n', '  }\n', '}']