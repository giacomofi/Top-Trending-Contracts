['pragma solidity 0.6.0;\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two unsigned integers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two unsigned integers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public _owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor () public {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), msg.sender);\n', '  }\n', '\n', '  function owner() public view returns (address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function renounceOwnership() public virtual onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public virtual onlyOwner {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract YFMARSToken is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  string public constant name = "YFMARS";\n', '  string public constant symbol = "YFMR";\n', '  uint256 public constant decimals = 18;\n', '  // the supply will not exceed 10,000 YFMR\n', '  uint256 private constant _maximumSupply = 10000 * 10 ** decimals;\n', '  uint256 private constant _maximumPresaleBurnAmount = 500 * 10 ** decimals;\n', '  uint256 public _presaleBurnTotal = 0;\n', '  uint256 public _totalSupply;\n', '\n', '  // events\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  // mappings\n', '  mapping(address => uint256) public _balanceOf;\n', '  mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '  constructor() public override {\n', '    // transfer the entire supply to contract creator\n', '    _owner = msg.sender;\n', '    _totalSupply = _maximumSupply;\n', '    _balanceOf[msg.sender] = _maximumSupply;\n', '    emit Transfer(address(0x0), msg.sender, _maximumSupply);\n', '  }\n', '\n', '  function totalSupply () public view returns (uint256) {\n', '    return _totalSupply; \n', '  }\n', '\n', '  function balanceOf (address who) public view returns (uint256) {\n', '    return _balanceOf[who];\n', '  }\n', '\n', '  // checks that the address is valid\n', '  function _transfer(address _from, address _to, uint256 _value) internal {\n', '    _balanceOf[_from] = _balanceOf[_from].sub(_value);\n', '    _balanceOf[_to] = _balanceOf[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '  }\n', '\n', '  // transfer tokens\n', '  function transfer(address _to, uint256 _value) public returns (bool success) {\n', '    require(_balanceOf[msg.sender] >= _value);\n', '    _transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // performs presale burn\n', '  function burn (uint256 _burnAmount, bool _presaleBurn) public onlyOwner returns (bool success) {\n', '    if (_presaleBurn) {\n', '      require(_presaleBurnTotal.add(_burnAmount) <= _maximumPresaleBurnAmount);\n', '      _presaleBurnTotal = _presaleBurnTotal.add(_burnAmount);\n', '      _transfer(_owner, address(0), _burnAmount);\n', '      _totalSupply = _totalSupply.sub(_burnAmount);\n', '    } else {\n', '      _transfer(_owner, address(0), _burnAmount);\n', '      _totalSupply = _totalSupply.sub(_burnAmount);\n', '    }\n', '    return true;\n', '  }\n', '\n', '  // approve spend\n', '  function approve(address _spender, uint256 _value) public returns (bool success) {\n', '    require(_spender != address(0));\n', '    allowance[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  // transfer from\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    require(_value <= _balanceOf[_from]);\n', '    require(_value <= allowance[_from][msg.sender]);\n', '    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '    _transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '}']