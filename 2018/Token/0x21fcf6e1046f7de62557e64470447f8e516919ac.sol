['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner{\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool){\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract ComissionList is Claimable {\n', '  using SafeMath for uint256;\n', '\n', '  struct Transfer {\n', '    uint256 stat;\n', '    uint256 perc;\n', '  }\n', '\n', '  mapping (string => Transfer) refillPaySystemInfo;\n', '  mapping (string => Transfer) widthrawPaySystemInfo;\n', '\n', '  Transfer transferInfo;\n', '\n', '  event RefillCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);\n', '  event WidthrawCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);\n', '  event TransferCommisionIsChanged(uint256 stat, uint256 perc);\n', '\n', '  // установить информацию по комиссии для пополняемой платёжной системы\n', '  function setRefillFor(string _paySystem, uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {\n', '    refillPaySystemInfo[_paySystem].stat = _stat;\n', '    refillPaySystemInfo[_paySystem].perc = _perc;\n', '\n', '    RefillCommisionIsChanged(_paySystem, _stat, _perc);\n', '  }\n', '\n', '  // установить информацию по комиссии для снимаеомй платёжной системы\n', '  function setWidthrawFor(string _paySystem,uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {\n', '    widthrawPaySystemInfo[_paySystem].stat = _stat;\n', '    widthrawPaySystemInfo[_paySystem].perc = _perc;\n', '\n', '    WidthrawCommisionIsChanged(_paySystem, _stat, _perc);\n', '  }\n', '\n', '  // установить информацию по комиссии для перевода\n', '  function setTransfer(uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {\n', '    transferInfo.stat = _stat;\n', '    transferInfo.perc = _perc;\n', '\n', '    TransferCommisionIsChanged(_stat, _perc);\n', '  }\n', '\n', '  // взять процент по комиссии для пополняемой платёжной системы\n', '  function getRefillStatFor(string _paySystem) public view returns (uint256) {\n', '    return refillPaySystemInfo[_paySystem].perc;\n', '  }\n', '\n', '  // взять фикс по комиссии для пополняемой платёжной системы\n', '  function getRefillPercFor(string _paySystem) public view returns (uint256) {\n', '    return refillPaySystemInfo[_paySystem].stat;\n', '  }\n', '\n', '  // взять процент по комиссии для снимаемой платёжной системы\n', '  function getWidthrawStatFor(string _paySystem) public view returns (uint256) {\n', '    return widthrawPaySystemInfo[_paySystem].perc;\n', '  }\n', '\n', '  // взять фикс по комиссии для снимаемой платёжной системы\n', '  function getWidthrawPercFor(string _paySystem) public view returns (uint256) {\n', '    return widthrawPaySystemInfo[_paySystem].stat;\n', '  }\n', '\n', '  // взять процент по комиссии для перевода\n', '  function getTransferPerc() public view returns (uint256) {\n', '    return transferInfo.perc;\n', '  }\n', '  \n', '  // взять фикс по комиссии для перевода\n', '  function getTransferStat() public view returns (uint256) {\n', '    return transferInfo.stat;\n', '  }\n', '\n', '  // рассчитать комиссию со снятия для платёжной системы и суммы\n', '  function calcWidthraw(string _paySystem, uint256 _value) public view returns(uint256) {\n', '    uint256 _totalComission;\n', '    _totalComission = widthrawPaySystemInfo[_paySystem].stat + (_value / 100 ) * widthrawPaySystemInfo[_paySystem].perc;\n', '\n', '    return _totalComission;\n', '  }\n', '\n', '  // рассчитать комиссию с пополнения для платёжной системы и суммы\n', '  function calcRefill(string _paySystem, uint256 _value) public view returns(uint256) {\n', '    uint256 _totalComission;\n', '    _totalComission = refillPaySystemInfo[_paySystem].stat + (_value / 100 ) * refillPaySystemInfo[_paySystem].perc;\n', '\n', '    return _totalComission;\n', '  }\n', '\n', '  // рассчитать комиссию с перевода для платёжной системы и суммы\n', '  function calcTransfer(uint256 _value) public view returns(uint256) {\n', '    uint256 _totalComission;\n', '    _totalComission = transferInfo.stat + (_value / 100 ) * transferInfo.perc;\n', '\n', '    return _totalComission;\n', '  }\n', '}\n', '\n', 'contract EvaCurrency is PausableToken, BurnableToken {\n', '  string public name = "EvaUSD";\n', '  string public symbol = "EUSD";\n', '\n', '  ComissionList public comissionList;\n', '\n', '  uint8 public constant decimals = 3;\n', '\n', '  mapping(address => uint) lastUsedNonce;\n', '\n', '  address public staker;\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  function EvaCurrency(string _name, string _symbol) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    staker = msg.sender;\n', '  }\n', '\n', '  function changeName(string _name, string _symbol) onlyOwner public {\n', '      name = _name;\n', '      symbol = _symbol;\n', '  }\n', '\n', '  function setComissionList(ComissionList _comissionList) onlyOwner public {\n', '    comissionList = _comissionList;\n', '  }\n', '\n', '  modifier onlyStaker() {\n', '    require(msg.sender == staker);\n', '    _;\n', '  }\n', '\n', '  // Перевод между кошельками по VRS\n', '  function transferOnBehalf(address _to, uint _amount, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyStaker public returns (bool success) {\n', '    uint256 fee;\n', '    uint256 resultAmount;\n', '    bytes32 hash = keccak256(_to, _amount, _nonce, address(this));\n', '    address sender = ecrecover(hash, _v, _r, _s);\n', '\n', '    require(lastUsedNonce[sender] < _nonce);\n', '    require(_amount <= balances[sender]);\n', '\n', '    fee = comissionList.calcTransfer(_amount);\n', '    resultAmount = _amount.sub(fee);\n', '\n', '    balances[sender] = balances[sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(resultAmount);\n', '    balances[staker] = balances[staker].add(fee);\n', '    lastUsedNonce[sender] = _nonce;\n', '    \n', '    emit Transfer(sender, address(0), _amount);\n', '    emit Transfer(address(0), _to, resultAmount);\n', '    return true;\n', '  }\n', '\n', '  function withdrawOnBehalf(uint _amount, string _paySystem, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyStaker public returns (bool success) {\n', '    uint256 fee;\n', '    uint256 resultAmount;\n', '    bytes32 hash = keccak256(address(0), _amount, _nonce, address(this));\n', '    address sender = ecrecover(hash, _v, _r, _s);\n', '\n', '    require(lastUsedNonce[sender] < _nonce);\n', '    require(_amount <= balances[sender]);\n', '\n', '    fee = comissionList.calcWidthraw(_paySystem, _amount);\n', '    resultAmount = _amount.sub(fee);\n', '\n', '    balances[sender] = balances[sender].sub(_amount);\n', '    balances[staker] = balances[staker].add(fee);\n', '    totalSupply_ = totalSupply_.sub(resultAmount);\n', '\n', '    emit Transfer(sender, address(0), resultAmount);\n', '    Burn(sender, resultAmount);\n', '    return true;\n', '  }\n', '\n', '  // Пополнение баланса пользователя, так-же отправляет комиссию для staker\n', '  // _to - адрес пополняемого кошелька, _amount - сумма, _paySystem - платёжная система\n', '  function refill(address _to, uint256 _amount, string _paySystem) onlyStaker public returns (bool success) {\n', '      uint256 fee;\n', '      uint256 resultAmount;\n', '\n', '      fee = comissionList.calcRefill(_paySystem, _amount);\n', '      resultAmount = _amount.sub(fee);\n', '\n', '      balances[_to] = balances[_to].add(resultAmount);\n', '      balances[staker] = balances[staker].add(fee);\n', '      totalSupply_ = totalSupply_.add(_amount);\n', '\n', '      emit Transfer(address(0), _to, resultAmount);\n', '      Mint(_to, resultAmount);\n', '      return true;\n', '  }\n', '\n', '  function changeStaker(address _staker) onlyOwner public returns (bool success) {\n', '    staker = _staker;\n', '  }\n', '  \n', '  function getNullAddress() public view returns (address) {\n', '    return address(0);\n', '  }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner{\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool){\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success)\n', '  {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract ComissionList is Claimable {\n', '  using SafeMath for uint256;\n', '\n', '  struct Transfer {\n', '    uint256 stat;\n', '    uint256 perc;\n', '  }\n', '\n', '  mapping (string => Transfer) refillPaySystemInfo;\n', '  mapping (string => Transfer) widthrawPaySystemInfo;\n', '\n', '  Transfer transferInfo;\n', '\n', '  event RefillCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);\n', '  event WidthrawCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);\n', '  event TransferCommisionIsChanged(uint256 stat, uint256 perc);\n', '\n', '  // установить информацию по комиссии для пополняемой платёжной системы\n', '  function setRefillFor(string _paySystem, uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {\n', '    refillPaySystemInfo[_paySystem].stat = _stat;\n', '    refillPaySystemInfo[_paySystem].perc = _perc;\n', '\n', '    RefillCommisionIsChanged(_paySystem, _stat, _perc);\n', '  }\n', '\n', '  // установить информацию по комиссии для снимаеомй платёжной системы\n', '  function setWidthrawFor(string _paySystem,uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {\n', '    widthrawPaySystemInfo[_paySystem].stat = _stat;\n', '    widthrawPaySystemInfo[_paySystem].perc = _perc;\n', '\n', '    WidthrawCommisionIsChanged(_paySystem, _stat, _perc);\n', '  }\n', '\n', '  // установить информацию по комиссии для перевода\n', '  function setTransfer(uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {\n', '    transferInfo.stat = _stat;\n', '    transferInfo.perc = _perc;\n', '\n', '    TransferCommisionIsChanged(_stat, _perc);\n', '  }\n', '\n', '  // взять процент по комиссии для пополняемой платёжной системы\n', '  function getRefillStatFor(string _paySystem) public view returns (uint256) {\n', '    return refillPaySystemInfo[_paySystem].perc;\n', '  }\n', '\n', '  // взять фикс по комиссии для пополняемой платёжной системы\n', '  function getRefillPercFor(string _paySystem) public view returns (uint256) {\n', '    return refillPaySystemInfo[_paySystem].stat;\n', '  }\n', '\n', '  // взять процент по комиссии для снимаемой платёжной системы\n', '  function getWidthrawStatFor(string _paySystem) public view returns (uint256) {\n', '    return widthrawPaySystemInfo[_paySystem].perc;\n', '  }\n', '\n', '  // взять фикс по комиссии для снимаемой платёжной системы\n', '  function getWidthrawPercFor(string _paySystem) public view returns (uint256) {\n', '    return widthrawPaySystemInfo[_paySystem].stat;\n', '  }\n', '\n', '  // взять процент по комиссии для перевода\n', '  function getTransferPerc() public view returns (uint256) {\n', '    return transferInfo.perc;\n', '  }\n', '  \n', '  // взять фикс по комиссии для перевода\n', '  function getTransferStat() public view returns (uint256) {\n', '    return transferInfo.stat;\n', '  }\n', '\n', '  // рассчитать комиссию со снятия для платёжной системы и суммы\n', '  function calcWidthraw(string _paySystem, uint256 _value) public view returns(uint256) {\n', '    uint256 _totalComission;\n', '    _totalComission = widthrawPaySystemInfo[_paySystem].stat + (_value / 100 ) * widthrawPaySystemInfo[_paySystem].perc;\n', '\n', '    return _totalComission;\n', '  }\n', '\n', '  // рассчитать комиссию с пополнения для платёжной системы и суммы\n', '  function calcRefill(string _paySystem, uint256 _value) public view returns(uint256) {\n', '    uint256 _totalComission;\n', '    _totalComission = refillPaySystemInfo[_paySystem].stat + (_value / 100 ) * refillPaySystemInfo[_paySystem].perc;\n', '\n', '    return _totalComission;\n', '  }\n', '\n', '  // рассчитать комиссию с перевода для платёжной системы и суммы\n', '  function calcTransfer(uint256 _value) public view returns(uint256) {\n', '    uint256 _totalComission;\n', '    _totalComission = transferInfo.stat + (_value / 100 ) * transferInfo.perc;\n', '\n', '    return _totalComission;\n', '  }\n', '}\n', '\n', 'contract EvaCurrency is PausableToken, BurnableToken {\n', '  string public name = "EvaUSD";\n', '  string public symbol = "EUSD";\n', '\n', '  ComissionList public comissionList;\n', '\n', '  uint8 public constant decimals = 3;\n', '\n', '  mapping(address => uint) lastUsedNonce;\n', '\n', '  address public staker;\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  function EvaCurrency(string _name, string _symbol) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    staker = msg.sender;\n', '  }\n', '\n', '  function changeName(string _name, string _symbol) onlyOwner public {\n', '      name = _name;\n', '      symbol = _symbol;\n', '  }\n', '\n', '  function setComissionList(ComissionList _comissionList) onlyOwner public {\n', '    comissionList = _comissionList;\n', '  }\n', '\n', '  modifier onlyStaker() {\n', '    require(msg.sender == staker);\n', '    _;\n', '  }\n', '\n', '  // Перевод между кошельками по VRS\n', '  function transferOnBehalf(address _to, uint _amount, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyStaker public returns (bool success) {\n', '    uint256 fee;\n', '    uint256 resultAmount;\n', '    bytes32 hash = keccak256(_to, _amount, _nonce, address(this));\n', '    address sender = ecrecover(hash, _v, _r, _s);\n', '\n', '    require(lastUsedNonce[sender] < _nonce);\n', '    require(_amount <= balances[sender]);\n', '\n', '    fee = comissionList.calcTransfer(_amount);\n', '    resultAmount = _amount.sub(fee);\n', '\n', '    balances[sender] = balances[sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(resultAmount);\n', '    balances[staker] = balances[staker].add(fee);\n', '    lastUsedNonce[sender] = _nonce;\n', '    \n', '    emit Transfer(sender, address(0), _amount);\n', '    emit Transfer(address(0), _to, resultAmount);\n', '    return true;\n', '  }\n', '\n', '  function withdrawOnBehalf(uint _amount, string _paySystem, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyStaker public returns (bool success) {\n', '    uint256 fee;\n', '    uint256 resultAmount;\n', '    bytes32 hash = keccak256(address(0), _amount, _nonce, address(this));\n', '    address sender = ecrecover(hash, _v, _r, _s);\n', '\n', '    require(lastUsedNonce[sender] < _nonce);\n', '    require(_amount <= balances[sender]);\n', '\n', '    fee = comissionList.calcWidthraw(_paySystem, _amount);\n', '    resultAmount = _amount.sub(fee);\n', '\n', '    balances[sender] = balances[sender].sub(_amount);\n', '    balances[staker] = balances[staker].add(fee);\n', '    totalSupply_ = totalSupply_.sub(resultAmount);\n', '\n', '    emit Transfer(sender, address(0), resultAmount);\n', '    Burn(sender, resultAmount);\n', '    return true;\n', '  }\n', '\n', '  // Пополнение баланса пользователя, так-же отправляет комиссию для staker\n', '  // _to - адрес пополняемого кошелька, _amount - сумма, _paySystem - платёжная система\n', '  function refill(address _to, uint256 _amount, string _paySystem) onlyStaker public returns (bool success) {\n', '      uint256 fee;\n', '      uint256 resultAmount;\n', '\n', '      fee = comissionList.calcRefill(_paySystem, _amount);\n', '      resultAmount = _amount.sub(fee);\n', '\n', '      balances[_to] = balances[_to].add(resultAmount);\n', '      balances[staker] = balances[staker].add(fee);\n', '      totalSupply_ = totalSupply_.add(_amount);\n', '\n', '      emit Transfer(address(0), _to, resultAmount);\n', '      Mint(_to, resultAmount);\n', '      return true;\n', '  }\n', '\n', '  function changeStaker(address _staker) onlyOwner public returns (bool success) {\n', '    staker = _staker;\n', '  }\n', '  \n', '  function getNullAddress() public view returns (address) {\n', '    return address(0);\n', '  }\n', '}']