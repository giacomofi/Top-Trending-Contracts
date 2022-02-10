['/**\n', ' * Reference Code\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/examples/SimpleToken.sol\n', ' */\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '   * @dev Multiplies two numbers, throws on overflow.\n', '   */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient.\n', '   */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20\n', ' * @dev Standard ERC20 token interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title mameCoin\n', ' * @dev see https://mamecoin.jp/\n', ' */\n', 'contract mameCoin is ERC20, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => mapping (address => uint256)) internal allowed;\n', '  mapping(address => uint256) internal lockups;\n', '\n', '  string public constant name = "mameCoin";\n', '  string public constant symbol = "MAME";\n', '  uint8 public constant decimals = 8;\n', '  uint256 totalSupply_ = 25000000000 * (10 ** uint256(decimals));\n', '\n', '  event Burn(address indexed to, uint256 amount);\n', '  event Refund(address indexed to, uint256 amount);\n', '  event Lockup(address indexed to, uint256 lockuptime);\n', '\n', '  /**\n', '   * @dev Constructor that gives msg.sender all of existing tokens.\n', '   */\n', '  constructor() public {\n', '    balances[msg.sender] = totalSupply_;\n', '    emit Transfer(address(0), msg.sender, totalSupply_);\n', '  }\n', '\n', '  /**\n', '   * @dev total number of tokens in existence\n', '   */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the balance of the specified address.\n', '   * @param _owner The address to query the the balance of.\n', '   * @return An uint256 representing the amount owned by the passed address.\n', '   */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev transfer token for a specified address\n', '   * @param _to The address to transfer to.\n', '   * @param _amount The amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _amount) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_amount <= balances[msg.sender]);\n', '    require(block.timestamp > lockups[msg.sender]);\n', '    require(block.timestamp > lockups[_to]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _amount uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_amount <= balances[_from]);\n', '    require(_amount <= allowed[_from][msg.sender]);\n', '    require(block.timestamp > lockups[_from]);\n', '    require(block.timestamp > lockups[_to]);\n', '\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _amount The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _amount) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _to address The address which is burned.\n', '   * @param _amount The amount of token to be burned.\n', '   */\n', '  function burn(address _to, uint256 _amount) public onlyOwner {\n', '    require(_amount <= balances[_to]);\n', '    require(block.timestamp > lockups[_to]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    balances[_to] = balances[_to].sub(_amount);\n', '    totalSupply_ = totalSupply_.sub(_amount);\n', '    emit Burn(_to, _amount);\n', '    emit Transfer(_to, address(0), _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Refund a specific amount of tokens.\n', '   * @param _to The address that will receive the refunded tokens.\n', '   * @param _amount The amount of tokens to refund.\n', '   */\n', '  function refund(address _to, uint256 _amount) public onlyOwner {\n', '    require(block.timestamp > lockups[_to]);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Refund(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the lockuptime of the specified address.\n', '   * @param _owner The address to query the the lockup of.\n', '   * @return An uint256 unixstime the lockuptime which is locked until that time.\n', '   */\n', '  function lockupOf(address _owner) public view returns (uint256) {\n', '    return lockups[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Lockup a specific address until given time.\n', '   * @param _to address The address which is locked.\n', '   * @param _lockupTimeUntil The lockuptime which is locked until that time.\n', '   */\n', '  function lockup(address _to, uint256 _lockupTimeUntil) public onlyOwner {\n', '    require(lockups[_to] < _lockupTimeUntil);\n', '    lockups[_to] = _lockupTimeUntil;\n', '    emit Lockup(_to, _lockupTimeUntil);\n', '  }\n', '\n', '  /**\n', '   * @dev airdrop tokens for a specified addresses\n', '   * @param _receivers The addresses to transfer to.\n', '   * @param _amount The amount to be transferred.\n', '   */\n', '  function airdrop(address[] _receivers, uint256 _amount) public returns (bool) {\n', '    require(block.timestamp > lockups[msg.sender]);\n', '    require(_receivers.length > 0);\n', '    require(_amount > 0);\n', '\n', '    uint256 _total = 0;\n', '\n', '    for (uint256 i = 0; i < _receivers.length; i++) {\n', '      require(_receivers[i] != address(0));\n', '      require(block.timestamp > lockups[_receivers[i]]);\n', '      _total = _total.add(_amount);\n', '    }\n', '\n', '    require(_total <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_total);\n', '\n', '    for (i = 0; i < _receivers.length; i++) {\n', '      balances[_receivers[i]] = balances[_receivers[i]].add(_amount);\n', '      emit Transfer(msg.sender, _receivers[i], _amount);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev distribute tokens for a specified addresses\n', '   * @param _receivers The addresses to transfer to.\n', '   * @param _amounts The amounts to be transferred.\n', '   */\n', '  function distribute(address[] _receivers, uint256[] _amounts) public returns (bool) {\n', '    require(block.timestamp > lockups[msg.sender]);\n', '    require(_receivers.length > 0);\n', '    require(_amounts.length > 0);\n', '    require(_receivers.length == _amounts.length);\n', '\n', '    uint256 _total = 0;\n', '\n', '    for (uint256 i = 0; i < _receivers.length; i++) {\n', '      require(_receivers[i] != address(0));\n', '      require(block.timestamp > lockups[_receivers[i]]);\n', '      require(_amounts[i] > 0);\n', '      _total = _total.add(_amounts[i]);\n', '    }\n', '\n', '    require(_total <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_total);\n', '\n', '    for (i = 0; i < _receivers.length; i++) {\n', '      balances[_receivers[i]] = balances[_receivers[i]].add(_amounts[i]);\n', '      emit Transfer(msg.sender, _receivers[i], _amounts[i]);\n', '    }\n', '\n', '    return true;\n', '  }\n', '}']
['/**\n', ' * Reference Code\n', ' * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/examples/SimpleToken.sol\n', ' */\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '   * @dev Multiplies two numbers, throws on overflow.\n', '   */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Integer division of two numbers, truncating the quotient.\n', '   */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '   */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds two numbers, throws on overflow.\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20\n', ' * @dev Standard ERC20 token interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title mameCoin\n', ' * @dev see https://mamecoin.jp/\n', ' */\n', 'contract mameCoin is ERC20, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping(address => mapping (address => uint256)) internal allowed;\n', '  mapping(address => uint256) internal lockups;\n', '\n', '  string public constant name = "mameCoin";\n', '  string public constant symbol = "MAME";\n', '  uint8 public constant decimals = 8;\n', '  uint256 totalSupply_ = 25000000000 * (10 ** uint256(decimals));\n', '\n', '  event Burn(address indexed to, uint256 amount);\n', '  event Refund(address indexed to, uint256 amount);\n', '  event Lockup(address indexed to, uint256 lockuptime);\n', '\n', '  /**\n', '   * @dev Constructor that gives msg.sender all of existing tokens.\n', '   */\n', '  constructor() public {\n', '    balances[msg.sender] = totalSupply_;\n', '    emit Transfer(address(0), msg.sender, totalSupply_);\n', '  }\n', '\n', '  /**\n', '   * @dev total number of tokens in existence\n', '   */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the balance of the specified address.\n', '   * @param _owner The address to query the the balance of.\n', '   * @return An uint256 representing the amount owned by the passed address.\n', '   */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev transfer token for a specified address\n', '   * @param _to The address to transfer to.\n', '   * @param _amount The amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _amount) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_amount <= balances[msg.sender]);\n', '    require(block.timestamp > lockups[msg.sender]);\n', '    require(block.timestamp > lockups[_to]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _amount uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_amount <= balances[_from]);\n', '    require(_amount <= allowed[_from][msg.sender]);\n', '    require(block.timestamp > lockups[_from]);\n', '    require(block.timestamp > lockups[_to]);\n', '\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _amount The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _amount) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _to address The address which is burned.\n', '   * @param _amount The amount of token to be burned.\n', '   */\n', '  function burn(address _to, uint256 _amount) public onlyOwner {\n', '    require(_amount <= balances[_to]);\n', '    require(block.timestamp > lockups[_to]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    balances[_to] = balances[_to].sub(_amount);\n', '    totalSupply_ = totalSupply_.sub(_amount);\n', '    emit Burn(_to, _amount);\n', '    emit Transfer(_to, address(0), _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Refund a specific amount of tokens.\n', '   * @param _to The address that will receive the refunded tokens.\n', '   * @param _amount The amount of tokens to refund.\n', '   */\n', '  function refund(address _to, uint256 _amount) public onlyOwner {\n', '    require(block.timestamp > lockups[_to]);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Refund(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the lockuptime of the specified address.\n', '   * @param _owner The address to query the the lockup of.\n', '   * @return An uint256 unixstime the lockuptime which is locked until that time.\n', '   */\n', '  function lockupOf(address _owner) public view returns (uint256) {\n', '    return lockups[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Lockup a specific address until given time.\n', '   * @param _to address The address which is locked.\n', '   * @param _lockupTimeUntil The lockuptime which is locked until that time.\n', '   */\n', '  function lockup(address _to, uint256 _lockupTimeUntil) public onlyOwner {\n', '    require(lockups[_to] < _lockupTimeUntil);\n', '    lockups[_to] = _lockupTimeUntil;\n', '    emit Lockup(_to, _lockupTimeUntil);\n', '  }\n', '\n', '  /**\n', '   * @dev airdrop tokens for a specified addresses\n', '   * @param _receivers The addresses to transfer to.\n', '   * @param _amount The amount to be transferred.\n', '   */\n', '  function airdrop(address[] _receivers, uint256 _amount) public returns (bool) {\n', '    require(block.timestamp > lockups[msg.sender]);\n', '    require(_receivers.length > 0);\n', '    require(_amount > 0);\n', '\n', '    uint256 _total = 0;\n', '\n', '    for (uint256 i = 0; i < _receivers.length; i++) {\n', '      require(_receivers[i] != address(0));\n', '      require(block.timestamp > lockups[_receivers[i]]);\n', '      _total = _total.add(_amount);\n', '    }\n', '\n', '    require(_total <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_total);\n', '\n', '    for (i = 0; i < _receivers.length; i++) {\n', '      balances[_receivers[i]] = balances[_receivers[i]].add(_amount);\n', '      emit Transfer(msg.sender, _receivers[i], _amount);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev distribute tokens for a specified addresses\n', '   * @param _receivers The addresses to transfer to.\n', '   * @param _amounts The amounts to be transferred.\n', '   */\n', '  function distribute(address[] _receivers, uint256[] _amounts) public returns (bool) {\n', '    require(block.timestamp > lockups[msg.sender]);\n', '    require(_receivers.length > 0);\n', '    require(_amounts.length > 0);\n', '    require(_receivers.length == _amounts.length);\n', '\n', '    uint256 _total = 0;\n', '\n', '    for (uint256 i = 0; i < _receivers.length; i++) {\n', '      require(_receivers[i] != address(0));\n', '      require(block.timestamp > lockups[_receivers[i]]);\n', '      require(_amounts[i] > 0);\n', '      _total = _total.add(_amounts[i]);\n', '    }\n', '\n', '    require(_total <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_total);\n', '\n', '    for (i = 0; i < _receivers.length; i++) {\n', '      balances[_receivers[i]] = balances[_receivers[i]].add(_amounts[i]);\n', '      emit Transfer(msg.sender, _receivers[i], _amounts[i]);\n', '    }\n', '\n', '    return true;\n', '  }\n', '}']