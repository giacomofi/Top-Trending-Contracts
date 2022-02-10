['pragma solidity 0.6.10;\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two unsigned integers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two unsigned integers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Lazarus {\n', '  using SafeMath for uint256;\n', '\n', '  // standard ERC20 variables. \n', '  string public name;\n', '  string public symbol;\n', '  uint256 public constant decimals = 18; // the supply \n', '  // owner of the contract\n', '  uint256 public supply;\n', '  address public owner;\n', '\n', '  // events\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  // mappings\n', '  mapping(address => uint256) public _balanceOf;\n', '  mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '  constructor(address _owner, string memory _name, string memory _symbol, uint256 _supply) public {\n', '    owner = _owner;\n', '    name = _name;\n', '    symbol = _symbol;\n', '    supply = _supply * 10 ** decimals;\n', '    _balanceOf[owner] = supply;\n', '    emit Transfer(address(0x0), owner, supply);\n', '  }\n', '\n', '  function balanceOf (address who) public view returns (uint256) {\n', '    return _balanceOf[who];\n', '  }\n', '\n', '  function totalSupply () public view returns (uint256) {\n', '    return supply;\n', '  }\n', '\n', '  // ensure the address is valid.\n', '  function _transfer(address _from, address _to, uint256 _value) internal {\n', '    _balanceOf[_from] = _balanceOf[_from].sub(_value);\n', '    _balanceOf[_to] = _balanceOf[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '  }\n', '\n', '  // send tokens\n', '  function transfer(address _to, uint256 _value) public returns (bool success) {\n', '    require(_balanceOf[msg.sender] >= _value);\n', '    _transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // approve tokens\n', '  function approve(address _spender, uint256 _value) public returns (bool success) {\n', '    require(_spender != address(0));\n', '    allowance[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  // transfer from\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    require(_value <= _balanceOf[_from]);\n', '    require(_value <= allowance[_from][msg.sender]);\n', '    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '    _transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address _spender, uint256 _value) public returns (bool) {\n', '    require(_spender != address(0));\n', '    require(allowance[msg.sender][_spender] > 0);\n', '    allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_value);\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address _spender, uint256 _value) public returns (bool) {\n', '    require(_spender != address(0));\n', '    require(allowance[msg.sender][_spender].sub(_value) >= 0);\n', '    allowance[msg.sender][_spender] = allowance[msg.sender][_spender].sub(_value);\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  // can only burn from the deployer address.\n', '  function burn (uint256 amount) public {\n', '    require(msg.sender == owner);\n', '    require(_balanceOf[msg.sender] >= amount);\n', '    supply = supply.sub(amount);\n', '    _transfer(msg.sender, address(0), amount);\n', '\n', '  }\n', '\n', '  // transfer ownership to a new address.\n', '  function transferOwnership (address newOwner) public {\n', '    require(msg.sender == owner);\n', '    owner = newOwner;\n', '  }\n', '}']