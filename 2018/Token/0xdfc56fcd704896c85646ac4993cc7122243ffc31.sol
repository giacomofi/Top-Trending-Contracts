['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', 'contract BGCoin is Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);\n', '  event FrozenFunds(address target, bool frozen);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals, uint256 _supply)\n', '  {\n', '      name = _name;\n', '      symbol = _symbol;\n', '      decimals = _decimals;\n', '      totalSupply = _supply;\n', '      balances[msg.sender] = totalSupply;\n', '  }\n', '\n', '\n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '  function totalSupply() constant returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '\n', '  function freezeAccount(address target, bool freeze) onlyOwner public {\n', '    frozenAccount[target] = freeze;\n', '    emit FrozenFunds(target, freeze);\n', '  }\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data, string _custom_fallback)\n', '  whenNotPaused\n', '  returns (bool success)\n', '  {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(!frozenAccount[msg.sender]);\n', '    if(isContract(_to)) {\n', '      require(balanceOf(msg.sender) >= _value);\n', '        balances[_to] = balanceOf(_to).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        assert(_to.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data));\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data)\n', '  whenNotPaused\n', '  returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(!frozenAccount[msg.sender]);\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '\n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value)\n', '  whenNotPaused\n', '  returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(!frozenAccount[msg.sender]);\n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(balanceOf(msg.sender) >= _value);\n', '    require(!frozenAccount[msg.sender]);\n', '    balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(balanceOf(msg.sender) >= _value);\n', '    require(!frozenAccount[msg.sender]);\n', '    balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    ContractReceiver receiver = ContractReceiver(_to);\n', '    receiver.tokenFallback(msg.sender, _value, _data);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value)\n', '    public\n', '    whenNotPaused\n', '    returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  \n', '    function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public returns (bool seccess) {\n', '    require(amount > 0);\n', '    require(addresses.length > 0);\n', '    require(!frozenAccount[msg.sender]);\n', '\n', '    uint256 totalAmount = amount.mul(addresses.length);\n', '    require(balances[msg.sender] >= totalAmount);\n', '    bytes memory empty;\n', '\n', '    for (uint i = 0; i < addresses.length; i++) {\n', '      require(addresses[i] != address(0));\n', '      require(!frozenAccount[addresses[i]]);\n', '      balances[addresses[i]] = balances[addresses[i]].add(amount);\n', '      emit Transfer(msg.sender, addresses[i], amount, empty);\n', '    }\n', '    balances[msg.sender] = balances[msg.sender].sub(totalAmount);\n', '    \n', '    return true;\n', '  }\n', '\n', '  function distributeAirdrop(address[] addresses, uint256[] amounts) public returns (bool) {\n', '    require(addresses.length > 0);\n', '    require(addresses.length == amounts.length);\n', '    require(!frozenAccount[msg.sender]);\n', '\n', '    uint256 totalAmount = 0;\n', '\n', '    for(uint i = 0; i < addresses.length; i++){\n', '      require(amounts[i] > 0);\n', '      require(addresses[i] != address(0));\n', '      require(!frozenAccount[addresses[i]]);\n', '\n', '      totalAmount = totalAmount.add(amounts[i]);\n', '    }\n', '    require(balances[msg.sender] >= totalAmount);\n', '\n', '    bytes memory empty;\n', '    for (i = 0; i < addresses.length; i++) {\n', '      balances[addresses[i]] = balances[addresses[i]].add(amounts[i]);\n', '      emit Transfer(msg.sender, addresses[i], amounts[i], empty);\n', '    }\n', '    balances[msg.sender] = balances[msg.sender].sub(totalAmount);\n', '    return true;\n', '  }\n', '  \n', '  /**\n', '     * @dev Function to collect tokens from the list of addresses\n', '     */\n', '    function collectTokens(address[] addresses, uint256[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0);\n', '        require(addresses.length == amounts.length);\n', '\n', '        uint256 totalAmount = 0;\n', '        bytes memory empty;\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0);\n', '            require(addresses[j] != address(0));\n', '            require(!frozenAccount[addresses[j]]);\n', '                    \n', '            require(balances[addresses[j]] >= amounts[j]);\n', '            balances[addresses[j]] = balances[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            emit Transfer(addresses[j], msg.sender, amounts[j], empty);\n', '        }\n', '        balances[msg.sender] = balances[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', 'contract BGCoin is Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);\n', '  event FrozenFunds(address target, bool frozen);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals, uint256 _supply)\n', '  {\n', '      name = _name;\n', '      symbol = _symbol;\n', '      decimals = _decimals;\n', '      totalSupply = _supply;\n', '      balances[msg.sender] = totalSupply;\n', '  }\n', '\n', '\n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '  function totalSupply() constant returns (uint256 _totalSupply) {\n', '      return totalSupply;\n', '  }\n', '\n', '  function freezeAccount(address target, bool freeze) onlyOwner public {\n', '    frozenAccount[target] = freeze;\n', '    emit FrozenFunds(target, freeze);\n', '  }\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data, string _custom_fallback)\n', '  whenNotPaused\n', '  returns (bool success)\n', '  {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(!frozenAccount[msg.sender]);\n', '    if(isContract(_to)) {\n', '      require(balanceOf(msg.sender) >= _value);\n', '        balances[_to] = balanceOf(_to).sub(_value);\n', '        balances[_to] = balanceOf(_to).add(_value);\n', '        assert(_to.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data));\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data)\n', '  whenNotPaused\n', '  returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(!frozenAccount[msg.sender]);\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '\n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value)\n', '  whenNotPaused\n', '  returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(!frozenAccount[msg.sender]);\n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '      }\n', '      return (length>0);\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(balanceOf(msg.sender) >= _value);\n', '    require(!frozenAccount[msg.sender]);\n', '    balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    require(_to != address(0));\n', '    require(!frozenAccount[_to]);\n', '    require(balanceOf(msg.sender) >= _value);\n', '    require(!frozenAccount[msg.sender]);\n', '    balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    ContractReceiver receiver = ContractReceiver(_to);\n', '    receiver.tokenFallback(msg.sender, _value, _data);\n', '    emit Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value)\n', '    public\n', '    whenNotPaused\n', '    returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    whenNotPaused\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  \n', '    function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public returns (bool seccess) {\n', '    require(amount > 0);\n', '    require(addresses.length > 0);\n', '    require(!frozenAccount[msg.sender]);\n', '\n', '    uint256 totalAmount = amount.mul(addresses.length);\n', '    require(balances[msg.sender] >= totalAmount);\n', '    bytes memory empty;\n', '\n', '    for (uint i = 0; i < addresses.length; i++) {\n', '      require(addresses[i] != address(0));\n', '      require(!frozenAccount[addresses[i]]);\n', '      balances[addresses[i]] = balances[addresses[i]].add(amount);\n', '      emit Transfer(msg.sender, addresses[i], amount, empty);\n', '    }\n', '    balances[msg.sender] = balances[msg.sender].sub(totalAmount);\n', '    \n', '    return true;\n', '  }\n', '\n', '  function distributeAirdrop(address[] addresses, uint256[] amounts) public returns (bool) {\n', '    require(addresses.length > 0);\n', '    require(addresses.length == amounts.length);\n', '    require(!frozenAccount[msg.sender]);\n', '\n', '    uint256 totalAmount = 0;\n', '\n', '    for(uint i = 0; i < addresses.length; i++){\n', '      require(amounts[i] > 0);\n', '      require(addresses[i] != address(0));\n', '      require(!frozenAccount[addresses[i]]);\n', '\n', '      totalAmount = totalAmount.add(amounts[i]);\n', '    }\n', '    require(balances[msg.sender] >= totalAmount);\n', '\n', '    bytes memory empty;\n', '    for (i = 0; i < addresses.length; i++) {\n', '      balances[addresses[i]] = balances[addresses[i]].add(amounts[i]);\n', '      emit Transfer(msg.sender, addresses[i], amounts[i], empty);\n', '    }\n', '    balances[msg.sender] = balances[msg.sender].sub(totalAmount);\n', '    return true;\n', '  }\n', '  \n', '  /**\n', '     * @dev Function to collect tokens from the list of addresses\n', '     */\n', '    function collectTokens(address[] addresses, uint256[] amounts) onlyOwner public returns (bool) {\n', '        require(addresses.length > 0);\n', '        require(addresses.length == amounts.length);\n', '\n', '        uint256 totalAmount = 0;\n', '        bytes memory empty;\n', '        \n', '        for (uint j = 0; j < addresses.length; j++) {\n', '            require(amounts[j] > 0);\n', '            require(addresses[j] != address(0));\n', '            require(!frozenAccount[addresses[j]]);\n', '                    \n', '            require(balances[addresses[j]] >= amounts[j]);\n', '            balances[addresses[j]] = balances[addresses[j]].sub(amounts[j]);\n', '            totalAmount = totalAmount.add(amounts[j]);\n', '            emit Transfer(addresses[j], msg.sender, amounts[j], empty);\n', '        }\n', '        balances[msg.sender] = balances[msg.sender].add(totalAmount);\n', '        return true;\n', '    }\n', '}']