['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-08\n', '*/\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '// File: contracts/token/ERC20Basic.sol\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/token/ERC20.sol\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/token/DetailedERC20.sol\n', '\n', 'contract DetailedERC20 is ERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '// File: contracts/token/Ownable.sol\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    require(newOwner != owner);\n', '\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/SafeMath.sol\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0 || b == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a); // overflow check\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/token/MVLToken.sol\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 _totalSupply;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value > 0);\n', '    require(_value <= balances[msg.sender]);\n', '\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract ERC20Token is BasicToken, ERC20 {\n', '  using SafeMath for uint256;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken, Ownable {\n', '  // events\n', '  event Burn(address indexed burner, uint256 amount);\n', '\n', '  // reduce sender balance and Token total supply\n', '  function burn(uint256 _value) onlyOwner public {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    _totalSupply = _totalSupply.sub(_value);\n', '    emit Burn(msg.sender, _value);\n', '    emit Transfer(msg.sender, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract TokenLock is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public transferEnabled = false; // indicates that token is transferable or not\n', '\n', '//   bool public noTokenLocked = false; // indicates all token is released or not\n', '\n', ' \n', '  mapping (address => bool) public lockAddresses;\n', '\n', '   modifier canTransfer(address _sender) {\n', '    require((_sender == owner) || (transferEnabled));\n', '    if(lockAddresses[_sender]) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '\n', '  function setLockAddress(address addr, bool state) onlyOwner /*inReleaseState(false)*/ public {\n', '    lockAddresses[addr] = state;\n', '  }\n', '\n', '  function enableTransfer(bool _enable) public onlyOwner {\n', '    transferEnabled = _enable;\n', '  }\n', '\n', '  // calculate the amount of tokens an address can use\n', '\n', '}\n', '\n', 'contract ABP is BurnableToken, DetailedERC20, ERC20Token, TokenLock {\n', '  using SafeMath for uint256;\n', '\n', '  // events\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  string public constant symbol = "ABP";\n', '  string public constant name = "Ai Bitcoin Pick";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant TOTAL_SUPPLY = 20*(10**8)*(10**uint256(decimals));\n', '\n', '  constructor() DetailedERC20(name, symbol, decimals) public {\n', '    _totalSupply = TOTAL_SUPPLY;\n', '\n', '    // initial supply belongs to owner\n', '    balances[owner] = _totalSupply;\n', '    emit Transfer(address(0x0), msg.sender, _totalSupply);\n', '  }\n', '\n', '  // override function using canTransfer on the sender address\n', '//   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {\n', '  function transfer(address _to, uint256 _value) canTransfer(msg.sender) public returns (bool success) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  // transfer tokens from one address to another\n', '//   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {\n', '  function transferFrom(address _from, address _to, uint256 _value)  canTransfer(_from) public returns (bool success) {\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', "    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance\n", '\n', '    // this event comes from BasicToken.sol\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', "  function() public payable { // don't send eth directly to token contract\n", '    revert();\n', '  }\n', '}']