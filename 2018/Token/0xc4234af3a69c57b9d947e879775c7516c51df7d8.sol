['pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract Owned {\n', '  address owner;\n', '  constructor () public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner,"Only owner can do it.");\n', '    _;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract HuaLiTestToken is IERC20 , Owned{\n', '\n', '  string public constant name = "HuaLiTestToken";\n', '  string public constant symbol = "HHLCTest";\n', '  uint8 public constant decimals = 18;\n', '\n', '  uint256 private constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  \n', '  mapping(address => uint256) balances;\n', '  uint256[] public releaseTimeLines=[1539515876,1539516176,1539516476,1539516776,1539517076,1539517376,1539517676,1539517976,1539518276,1539518576,1539518876,1539519176,1539519476,1539519776,1539520076,1539520376,1539520676,1539520976,1539521276,1539521576,1539521876,1539522176,1539522476,1539522776];\n', '    \n', '  struct Role {\n', '    address roleAddress;\n', '    uint256 amount;\n', '    uint256 firstRate;\n', '    uint256 round;\n', '    uint256 rate;\n', '  }\n', '   \n', '  mapping (address => mapping (uint256 => Role)) public mapRoles;\n', '  mapping (address => address) private lockList;\n', '  \n', '  event Lock(address from, uint256 value, uint256 lockAmount , uint256 balance);\n', '  \n', '  constructor() public {\n', '    _mint(msg.sender, INITIAL_SUPPLY);\n', '  }\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    if(_canTransfer(msg.sender,value)){ \n', '      _transfer(msg.sender, to, value);\n', '      return true;\n', '    } else {\n', '      emit Lock(msg.sender,value,getLockAmount(msg.sender),balanceOf(msg.sender));\n', '      return false;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '    \n', '    if (_canTransfer(from, value)) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    } else {\n', '        emit Lock(from,value,getLockAmount(from),balanceOf(from));\n', '        return false;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '    \n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '    \n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', '    emit Transfer(address(0), account, value);\n', '  }\n', '  \n', '  function setTimeLine(uint256[] timeLine) onlyOwner public {\n', '    releaseTimeLines = timeLine;\n', '  }\n', '  \n', '  /**\n', '   * @dev getRoleReleaseSeting\n', '   * @param roleType 1:Seed 2:Angel 3:PE 4:AirDrop\n', '   */\n', '  function getRoleReleaseSeting(uint256 roleType) pure public returns (uint256,uint256,uint256) {\n', '    if(roleType == 1){\n', '      return (50,1,10);\n', '    }else if(roleType == 2){\n', '      return (30,1,10);\n', '    }else if(roleType == 3){\n', '      return (40,3,20);\n', '    }else if(roleType == 4){\n', '      return (5,1,5);\n', '    }else {\n', '      return (0,0,0);\n', '    }\n', '  }\n', '  \n', '  function addLockUser(address roleAddress,uint256 amount,uint256 roleType) onlyOwner public {\n', '    (uint256 firstRate, uint256 round, uint256 rate) = getRoleReleaseSeting(roleType);\n', '    mapRoles[roleAddress][roleType] = Role(roleAddress,amount,firstRate,round,rate);\n', '    lockList[roleAddress] = roleAddress;\n', '  }\n', '  \n', '  function addLockUsers(address[] roleAddress,uint256[] amounts,uint256 roleType) onlyOwner public {\n', '    for(uint i= 0;i<roleAddress.length;i++){\n', '      addLockUser(roleAddress[i],amounts[i],roleType);\n', '    }\n', '  }\n', '  \n', '  function removeLockUser(address roleAddress,uint256 role) onlyOwner public {\n', '    mapRoles[roleAddress][role] = Role(0x0,0,0,0,0);\n', '    lockList[roleAddress] = 0x0;\n', '  }\n', '  \n', '  function getRound() constant public returns (uint) {\n', '    for(uint i= 0;i<releaseTimeLines.length;i++){\n', '      if(now<releaseTimeLines[i]){\n', '        if(i>0){\n', '          return i-1;\n', '        }else{\n', '          return 0;\n', '        }\n', '      }\n', '    }\n', '  }\n', '   \n', '  function isUserInLockList(address from) constant public returns (bool) {\n', '    if(lockList[from]==0x0){\n', '      return false;\n', '    } else {\n', '      return true;\n', '    }\n', '  }\n', '  \n', '  function _canTransfer(address from,uint256 _amount) private returns (bool) {\n', '    if(!isUserInLockList(from)){\n', '      return true;\n', '    }\n', '    if((balanceOf(from))<=0){\n', '      return true;\n', '    }\n', '    uint256 _lock = getLockAmount(from);\n', '    if(_lock<=0){\n', '      lockList[from] = 0x0;\n', '    }\n', '    if((balanceOf(from).sub(_amount))<_lock){\n', '      return false;\n', '    }\n', '    return true;\n', '  }\n', '  \n', '  function getLockAmount(address from) constant public returns (uint256) {\n', '    uint256 _lock = 0;\n', '    for(uint i= 1;i<=4;i++){\n', '      if(mapRoles[from][i].roleAddress != 0x0){\n', '        _lock = _lock.add(getLockAmountByRoleType(from,i));\n', '      }\n', '    }\n', '    return _lock;\n', '  }\n', '  \n', '  function getLockAmountByRoleType(address from,uint roleType) constant public returns (uint256) {\n', '    uint256 _rount = getRound();\n', '    uint256 round = 0;\n', '    if(_rount>0){\n', '      round = _rount.div(mapRoles[from][roleType].round);\n', '    }\n', '    if(mapRoles[from][roleType].firstRate.add(round.mul(mapRoles[from][roleType].rate))>=100){\n', '      return 0;\n', '    }\n', '    uint256 firstAmount = mapRoles[from][roleType].amount.mul(mapRoles[from][roleType].firstRate).div(100);\n', '    uint256 rountAmount = 0;\n', '    if(round>0){\n', '      rountAmount = mapRoles[from][roleType].amount.mul(mapRoles[from][roleType].rate.mul(round)).div(100);\n', '    }\n', '    return mapRoles[from][roleType].amount.sub(firstAmount.add(rountAmount));\n', '  }\n', '    \n', '}']