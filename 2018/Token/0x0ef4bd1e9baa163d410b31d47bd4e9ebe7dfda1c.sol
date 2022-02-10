['// mock class using ERC20\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    _transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param value The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(value);\n', '    _balances[account] = _balances[account].add(value);\n', '    emit Transfer(address(0), account, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 value) internal {\n', '    require(account != 0);\n', '    require(value <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(value);\n', '    _balances[account] = _balances[account].sub(value);\n', '    emit Transfer(account, address(0), value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 value) internal {\n', '    require(value <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      value);\n', '    _burn(account, value);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract EdxToken is ERC20 {\n', '  using SafeMath for uint256;\n', '\tstring public name = "Enterprise Decentralized Token";\n', '\tstring public symbol = "EDX";\n', '\tuint8 public decimals = 18;\n', '\n', '\tstruct VestInfo { // Struct\n', '\t\t\tuint256 vested;\n', '\t\t\tuint256 remain;\n', '\t}\n', '\tstruct CoinInfo {\n', '\t\tuint256 bsRemain;\n', '\t\tuint256 tmRemain;\n', '\t\tuint256 peRemain;\n', '\t\tuint256 remains;\n', '\t}\n', '\tstruct GrantInfo {\n', '\t\taddress holder;\n', '\t\tuint256 remain;\n', '\t}\n', '  mapping (address => uint256) private _balances;\t\t //balance of transferrable\n', '  mapping (address => VestInfo) private _bs_balance; //info of vested\n', '  mapping (address => VestInfo) private _pe_balance;\n', '  mapping (address => VestInfo) private _tm_balance;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint    _releaseTime;\n', '  bool    mainnet;\n', '  uint256 private _totalSupply;\n', '  address _owner;\n', '\tGrantInfo _bsholder;\n', '\tGrantInfo _peholder;\n', '\tGrantInfo _tmholder;\n', '  CoinInfo supplies;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Mint(uint8 mtype,uint256 value);\n', '  event Burn(uint8 mtype,uint256 value);\n', '\tevent Invest( address indexed account, uint indexed mtype, uint256 vested);\n', '  event Migrate(address indexed account,uint8 indexed mtype,uint256 vested,uint256 remain);\n', '\n', '  constructor() public {\n', '\t\t// 450 million , other 1.05 billion will be minted\n', '\t\t_totalSupply = 450*(10**6)*(10**18);\n', '\t\t_owner = msg.sender;\n', '\n', '\t\tsupplies.bsRemain = 80*1000000*(10**18);\n', '\t\tsupplies.peRemain = 200*1000000*(10**18);\n', '\t\tsupplies.tmRemain = 75*1000000*(10**18);\n', '\t\tsupplies.remains =  95*1000000*(10**18);\n', '\t\t//_balances[_owner] = supplies.remains;\n', '\t\tmainnet = false;\n', '\t}\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\tfunction getSupplies() public view returns (uint256,uint256,uint256,uint256) {\n', '\t    require(msg.sender == _owner);\n', '\n', '\t    return (supplies.remains,supplies.bsRemain,supplies.peRemain,supplies.tmRemain);\n', '\n', '\t}\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '\t\tuint256 result = 0;\n', '\t\tresult = result.add(_balances[owner]).add(_bs_balance[owner].remain).add(_pe_balance[owner].remain).add(_tm_balance[owner].remain);\n', '\n', '    return result;\n', '  }\n', '    function  detailedBalance(address account, uint dtype) public view returns(uint256,uint256) {\n', '\n', '        if (dtype == 0 || dtype == 1) {\n', '\t\t\t\t\t  uint256 result = balanceOf(account);\n', '\t\t\t\t\t\tuint256 locked = getBSBalance(account).add(getPEBalance(account)).add(getTMBalance(account));\n', '\t\t\t\t\t\tif(dtype == 0){\n', '\t\t\t\t\t\t   return (result,locked);\n', '\t\t\t\t\t\t}else{\n', '\t\t\t\t\t\t\t return (result,result.sub(locked));\n', '\t\t\t\t\t\t}\n', '\n', '        } else if( dtype ==  2 ) {\n', '            return  (_bs_balance[account].vested,getBSBalance(account));\n', '        }else if (dtype ==  3){\n', '\t\t\t\t\t  return (_pe_balance[account].vested,getPEBalance(account));\n', '\t\t}else if (dtype ==  4){\n', '\t\t\t\t\t  return (_tm_balance[account].vested,getTMBalance(account));\n', '\t\t}else {\n', '\t\t    return (0,0);\n', '\t\t }\n', '\n', '    }\n', '\t//set rol for account\n', '\tfunction grantRole(address account,uint8 mtype,uint256 amount) public{\n', '\t\trequire(msg.sender == _owner);\n', '\n', '\t\t\tif(_bsholder.holder == account) {\n', '\t\t\t\t_bsholder.holder = address(0);\n', '\t\t\t}\n', '\t\t\tif(_peholder.holder == account){\n', '\t\t\t\t_peholder.holder = address(0);\n', '\t\t\t}\n', '\t\t\tif(_tmholder.holder == account){\n', '\t\t\t\t\t_tmholder.holder = address(0);\n', '\t\t\t}\n', '\t\t if(mtype == 2) {\n', '\t\t\t require(supplies.bsRemain >= amount);\n', '\t\t\t _bsholder.holder = account;\n', '\t\t\t _bsholder.remain = amount;\n', '\n', '\t\t}else if(mtype == 3){\n', '\t\t\trequire(supplies.peRemain >= amount);\n', '\t\t\t_peholder.holder = account;\n', '\t\t\t_peholder.remain = amount;\n', '\t\t}else if(mtype == 4){\n', '\t\t\trequire(supplies.tmRemain >= amount);\n', '\t\t\t_tmholder.holder = account;\n', '\t\t\t_tmholder.remain = amount;\n', '\t\t}\n', '\t}\n', '\tfunction roleInfo(uint8 mtype)  public view returns(address,uint256) {\n', '\t\tif(mtype == 2) {\n', '\t\t\treturn (_bsholder.holder,_bsholder.remain);\n', '\t\t} else if(mtype == 3) {\n', '\t\t\treturn (_peholder.holder,_peholder.remain);\n', '\t\t}else if(mtype == 4) {\n', '\t\t\treturn (_tmholder.holder,_tmholder.remain);\n', '\t\t}else {\n', '\t\t\treturn (address(0),0);\n', '\t\t}\n', '\t}\n', '\tfunction  transferBasestone(address account, uint256 value) public {\n', '\t\trequire(msg.sender == _owner);\n', '\t\t_transferBasestone(account,value);\n', '\n', '\t}\n', '\tfunction  _transferBasestone(address account, uint256 value) internal {\n', '\n', '\t\trequire(supplies.bsRemain > value);\n', '\t\tsupplies.bsRemain = supplies.bsRemain.sub(value);\n', '\t\t_bs_balance[account].vested = _bs_balance[account].vested.add(value);\n', '\t\t_bs_balance[account].remain = _bs_balance[account].remain.add(value);\n', '\n', '\t}\n', '\tfunction  transferPE(address account, uint256 value) public {\n', '\t\trequire(msg.sender == _owner);\n', '\t\t_transferPE(account,value);\n', '\t}\n', '\tfunction  _transferPE(address account, uint256 value) internal {\n', '\t\trequire(supplies.peRemain > value);\n', '\t\tsupplies.peRemain = supplies.peRemain.sub(value);\n', '\t\t_pe_balance[account].vested = _pe_balance[account].vested.add(value);\n', '\t\t_pe_balance[account].remain = _pe_balance[account].remain.add(value);\n', '\t}\n', '\tfunction  transferTM(address account, uint256 value) public {\n', '\t\trequire(msg.sender == _owner);\n', '\t\t_transferTM(account,value);\n', '\t}\n', '\tfunction  _transferTM(address account, uint256 value) internal {\n', '\t\trequire(supplies.tmRemain > value);\n', '\t\tsupplies.tmRemain = supplies.tmRemain.sub(value);\n', '\t\t_tm_balance[account].vested = _tm_balance[account].vested.add(value);\n', '\t\t_tm_balance[account].remain = _tm_balance[account].remain.add(value);\n', '\t}\n', '\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '\t\tif(msg.sender == _owner){\n', '\t\t\trequire(supplies.remains >= value);\n', '\t\t\trequire(to != address(0));\n', '\t\t\tsupplies.remains = supplies.remains.sub(value);\n', '\t\t\t_balances[to] = _balances[to].add(value);\n', '\t\t\temit Transfer(address(0), to, value);\n', '\t\t}else if(msg.sender == _bsholder.holder ){\n', '\t\t\trequire(_bsholder.remain >= value);\n', '\t\t\t_bsholder.remain = _bsholder.remain.sub(value);\n', '\t\t\t_transferBasestone(to,value);\n', '\n', '\t\t}else if(msg.sender == _peholder.holder) {\n', '\t\t\trequire(_peholder.remain >= value);\n', '\t\t\t_peholder.remain = _peholder.remain.sub(value);\n', '\t\t\t_transferPE(to,value);\n', '\n', '\t\t}else if(msg.sender == _tmholder.holder){\n', '\t\t\trequire(_tmholder.remain >= value);\n', '\t\t\t_tmholder.remain = _tmholder.remain.sub(value);\n', '\t\t\t_transferTM(to,value);\n', '\n', '\t\t}else{\n', '    \t_transfer(msg.sender, to, value);\n', '\t\t}\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _allowed[from][msg.sender]);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    _transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '    _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '    _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified addresses\n', '  * @param from The address to transfer from.\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function _transfer(address from, address to, uint256 value) internal {\n', '\n', '\t\t_moveBSBalance(from);\n', '\t\t_movePEBalance(from);\n', '\t\t_moveTMBalance(from);\n', '    require(value <= _balances[from]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(from, to, value);\n', '  }\n', '\n', '\n', '\n', '//上所，开始分发\n', '\tfunction release() public {\n', '\t\trequire(msg.sender == _owner);\n', '\t\tif(_releaseTime == 0) {\n', '\t\t\t_releaseTime = now;\n', '\t\t}\n', '\t}\n', '\tfunction getBSBalance(address account) public view returns(uint256){\n', '\t\tuint  elasped = now - _releaseTime;\n', '\t\tuint256 shouldRemain = _bs_balance[account].remain;\n', '\t\tif( _releaseTime !=  0 && now > _releaseTime && _bs_balance[account].remain > 0){\n', '\n', '\t\t\tif(elasped < 180 days) { //\n', '\t\t\t\tshouldRemain = _bs_balance[account].vested.mul(9).div(10);\n', '\t\t\t} else if(elasped < 420 days) {\n', '\t\t\t\t\tshouldRemain = _bs_balance[account].vested .mul(6).div(10);\n', '\t\t\t} else if( elasped < 720 days) {\n', '\t\t\t\t\tshouldRemain = _bs_balance[account].vested .mul(3).div(10);\n', '\t\t\t}else {\n', '\t\t\t\tshouldRemain = 0;\n', '\t\t\t}\n', '\n', '\t\t}\n', '\t\treturn shouldRemain;\n', '\t}\n', '\t//基石代币释放\n', '\tfunction _moveBSBalance(address account) internal {\n', '\t\tuint256 shouldRemain = getBSBalance(account);\n', '\t\tif(_bs_balance[account].remain > shouldRemain) {\n', '\t\t\tuint256 toMove = _bs_balance[account].remain.sub(shouldRemain);\n', '\t\t\t_bs_balance[account].remain = shouldRemain;\n', '\t\t\t_balances[account] = _balances[account].add(toMove);\n', '\t\t}\n', '\t}\n', '\tfunction getPEBalance(address account) public view returns(uint256) {\n', '\t\tuint  elasped = now - _releaseTime;\n', '\t\tuint256 shouldRemain = _pe_balance[account].remain;\n', '\t\tif( _releaseTime !=  0 && _pe_balance[account].remain > 0){\n', '\n', '\n', '\t\t\tif(elasped < 150 days) { //首先释放10%\n', '\t\t\t\tshouldRemain = _pe_balance[account].vested.mul(9).div(10);\n', '\n', '\t\t\t} else if(elasped < 330 days) {//5-11个月\n', '\t\t\t\t\tshouldRemain = _pe_balance[account].vested .mul(6).div(10);\n', '\t\t\t} else if( elasped < 540 days) {//11-18个月\n', '\t\t\t\t\tshouldRemain = _pe_balance[account].vested .mul(3).div(10);\n', '\t\t\t} else {\n', '\t\t\t\t\tshouldRemain = 0;\n', '\t\t\t}\n', '\n', '\t\t}\n', '\t\treturn shouldRemain;\n', '\t}\n', '\t//私募代币释放\n', '\tfunction _movePEBalance(address account) internal {\n', '\t\tuint256 shouldRemain = getPEBalance(account);\n', '\t\tif(_pe_balance[account].remain > shouldRemain) {\n', '\t\t\tuint256 toMove = _pe_balance[account].remain.sub(shouldRemain);\n', '\t\t\t_pe_balance[account].remain = shouldRemain;\n', '\t\t\t_balances[account] = _balances[account].add(toMove);\n', '\t\t}\n', '\t}\n', '\tfunction getTMBalance(address account ) public view returns(uint256){\n', '\t\tuint  elasped = now - _releaseTime;\n', '\t\tuint256 shouldRemain = _tm_balance[account].remain;\n', '\t\tif( _releaseTime !=  0 && _tm_balance[account].remain > 0){\n', '\t\t\t//三个月起，每天释放千分之一，\n', '\t\t\tif(elasped < 90 days) { //release 10%\n', '\t\t\t\tshouldRemain = _tm_balance[account].vested;\n', '\t\t\t} else {\n', '\t\t\t\t\t//release other 90% linearly\n', '\t\t\t\t\telasped = elasped / 1 days;\n', '\t\t\t\t\tif(elasped <= 1090){\n', '\t\t\t\t\t\t\tshouldRemain = _tm_balance[account].vested.mul(1090-elasped).div(1000);\n', '\t\t\t\t\t}else {\n', '\t\t\t\t\t\t\tshouldRemain = 0;\n', '\t\t\t\t\t}\n', '\t\t\t}\n', '\t\t}\n', '\t\treturn shouldRemain;\n', '\t}\n', '\tfunction _moveTMBalance(address account ) internal {\n', '\t\tuint256 shouldRemain = getTMBalance(account);\n', '\t\tif(_tm_balance[account].remain > shouldRemain) {\n', '\t\t\tuint256 toMove = _tm_balance[account].remain.sub(shouldRemain);\n', '\t\t\t_tm_balance[account].remain = shouldRemain;\n', '\t\t\t_balances[account] = _balances[account].add(toMove);\n', '\t\t}\n', '\t}\n', '\t//增发\n', ' function _mint(uint256 value) public {\n', '\t require(msg.sender == _owner);\n', '\t require(mainnet == false); //主网上线后冻结代币\n', '\t _totalSupply = _totalSupply.add(value);\n', '\t //增发的部分总是可以自由转移的\n', '\t supplies.remains = supplies.remains.add(value);\n', '\t \t\temit Mint(1,value);\n', ' }\n', ' //增发\n', ' function _mintBS(uint256 value) public {\n', '\trequire(msg.sender == _owner);\n', '\t\trequire(mainnet == false); //主网上线后冻结代币\n', '\t_totalSupply = _totalSupply.add(value);\n', '\t//增发的部分总是可以自由转移的\n', '\tsupplies.bsRemain = supplies.bsRemain.add(value);\n', '\t\t\temit Mint(2,value);\n', ' }\n', ' //增发\n', ' function _mintPE(uint256 value) public {\n', '\trequire(msg.sender == _owner);\n', '\t\trequire(mainnet == false); //主网上线后冻结代币\n', '\t_totalSupply = _totalSupply.add(value);\n', '\t//增发的部分总是可以自由转移的\n', '\tsupplies.peRemain = supplies.peRemain.add(value);\n', '\t\temit Mint(3,value);\n', ' }\n', ' //销毁\n', ' function _burn(uint256 value) public {\n', '\trequire(msg.sender == _owner);\n', '\trequire(mainnet == false); //主网上线后冻结代币\n', '\trequire(supplies.remains >= value);\n', '\t_totalSupply = _totalSupply.sub(value);\n', '\tsupplies.remains = supplies.remains.sub(value);\n', '\temit Burn(0,value);\n', ' }\n', '  //销毁团队的\n', ' function _burnTM(uint256 value) public {\n', '\trequire(msg.sender == _owner);\n', '\trequire(mainnet == false); //主网上线后冻结代币\n', '\trequire(supplies.remains >= value);\n', '\t_totalSupply = _totalSupply.sub(value);\n', '\tsupplies.tmRemain = supplies.tmRemain.sub(value);\n', '  emit Burn(3,value);\n', ' }\n', ' //主网上线，允许迁移代币\n', ' function startupMainnet() public {\n', '     require(msg.sender == _owner);\n', '\n', '     mainnet = true;\n', ' }\n', ' //migrate to mainnet, erc20 will be destoryed, and coin will be created at same address on mainnet\n', ' function migrate() public {\n', '     //only runnable after mainnet started up\n', '     require(mainnet == true);\n', '     require(msg.sender != _owner);\n', '     uint256 value;\n', '     if( _balances[msg.sender] > 0) {\n', '         value = _balances[msg.sender];\n', '         _balances[msg.sender] = 0;\n', '         emit Migrate(msg.sender,0,value,value);\n', '     }\n', '     if( _bs_balance[msg.sender].remain > 0) {\n', '         value = _bs_balance[msg.sender].remain;\n', '         _bs_balance[msg.sender].remain = 0;\n', '         emit Migrate(msg.sender,1,_bs_balance[msg.sender].vested,value);\n', '     }\n', '     if( _pe_balance[msg.sender].remain > 0) {\n', '         value = _pe_balance[msg.sender].remain;\n', '         _pe_balance[msg.sender].remain = 0;\n', '         emit Migrate(msg.sender,2,_pe_balance[msg.sender].vested,value);\n', '     }\n', '     if( _tm_balance[msg.sender].remain > 0){\n', '          value = _tm_balance[msg.sender].remain;\n', '         _tm_balance[msg.sender].remain = 0;\n', '         emit Migrate(msg.sender,3,_pe_balance[msg.sender].vested,value);\n', '     }\n', '\n', ' }\n', ' //团队的奖励，分批逐步发送，可以撤回未发放的\n', '\tfunction revokeTMBalance(address account) public {\n', '\t        require(msg.sender == _owner);\n', '\t\t\tif(_tm_balance[account].remain > 0  && _tm_balance[account].vested >= _tm_balance[account].remain ){\n', '\t\t\t\t_tm_balance[account].vested = _tm_balance[account].vested.sub(_tm_balance[account].remain);\n', '\t\t\t\t_tm_balance[account].remain = 0;\n', '\t\t\t\tsupplies.tmRemain = supplies.tmRemain.add(_tm_balance[account].remain);\n', '\t\t\t}\n', '\t}\n', '}']