['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value)public  returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value)public  returns (bool);\n', '  function approve(address spender, uint256 value)public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    emit Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause()public onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    emit Unpause();\n', '    return true;\n', '  }\n', '}\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value)public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title FFC Token\n', ' * @dev FFC is PausableToken\n', ' */\n', 'contract FFCToken is StandardToken, Pausable {\n', '\n', '  string public constant name = "FFC";\n', '  string public constant symbol = "FFC";\n', '  uint256 public constant decimals = 18;\n', '  \n', '  // lock\n', '  struct LockToken{\n', '      uint256 amount;\n', '      uint32  time;\n', '  }\n', '  struct LockTokenSet{\n', '      LockToken[] lockList;\n', '  }\n', '  mapping ( address => LockTokenSet ) addressTimeLock;\n', '  mapping ( address => bool ) lockAdminList;\n', '  event TransferWithLockEvt(address indexed from, address indexed to, uint256 value,uint256 lockValue,uint32 lockTime );\n', '  /**\n', '    * @dev Creates a new MPKToken instance\n', '    */\n', '  constructor() public {\n', '    totalSupply = 10 * (10 ** 8) * (10 ** 18);\n', '    balances[0xC0FF6587381Ed1690baC9954f9Ace2768738BaDa] = totalSupply;\n', '  }\n', '  \n', '  function transfer(address _to, uint256 _value)public whenNotPaused returns (bool) {\n', '    assert ( balances[msg.sender].sub( getLockAmount( msg.sender ) ) >= _value );\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)public whenNotPaused returns (bool) {\n', '    assert ( balances[_from].sub( getLockAmount( msg.sender ) ) >= _value );\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '  function getLockAmount( address myaddress ) public view returns ( uint256 lockSum ) {\n', '        uint256 lockAmount = 0;\n', '        for( uint32 i = 0; i < addressTimeLock[myaddress].lockList.length; i ++ ){\n', '            if( addressTimeLock[myaddress].lockList[i].time > now ){\n', '                lockAmount += addressTimeLock[myaddress].lockList[i].amount;\n', '            }\n', '        }\n', '        return lockAmount;\n', '  }\n', '  \n', '  function getLockListLen( address myaddress ) public view returns ( uint256 lockAmount  ){\n', '      return addressTimeLock[myaddress].lockList.length;\n', '  }\n', '  \n', '  function getLockByIdx( address myaddress,uint32 idx ) public view returns ( uint256 lockAmount, uint32 lockTime ){\n', '      if( idx >= addressTimeLock[myaddress].lockList.length ){\n', '        return (0,0);          \n', '      }\n', '      lockAmount = addressTimeLock[myaddress].lockList[idx].amount;\n', '      lockTime = addressTimeLock[myaddress].lockList[idx].time;\n', '      return ( lockAmount,lockTime );\n', '  }\n', '  \n', '  function transferWithLock( address _to, uint256 _value,uint256 _lockValue,uint32 _lockTime )public whenNotPaused {\n', '      if( lockAdminList[msg.sender] != true ){\n', '            return;\n', '      }\n', '      assert( _lockTime > now  );\n', '      assert( _lockValue > 0 && _lockValue <= _value );\n', '      transfer( _to, _value );\n', '      bool needNewLock = true;\n', '      for( uint32 i = 0 ; i< addressTimeLock[_to].lockList.length; i ++ ){\n', '          if( addressTimeLock[_to].lockList[i].time < now ){\n', '              addressTimeLock[_to].lockList[i].time = _lockTime;\n', '              addressTimeLock[_to].lockList[i].amount = _lockValue;\n', '              emit TransferWithLockEvt( msg.sender,_to,_value,_lockValue,_lockTime );\n', '              needNewLock = false;\n', '              break;\n', '          }\n', '      }\n', '      if( needNewLock == true ){\n', '          // add a lock\n', '          addressTimeLock[_to].lockList.length ++ ;\n', '          addressTimeLock[_to].lockList[(addressTimeLock[_to].lockList.length-1)].time = _lockTime;\n', '          addressTimeLock[_to].lockList[(addressTimeLock[_to].lockList.length-1)].amount = _lockValue;\n', '          emit TransferWithLockEvt( msg.sender,_to,_value,_lockValue,_lockTime);\n', '      }\n', '  }\n', '  function setLockAdmin(address _to,bool canUse)public onlyOwner{\n', '      lockAdminList[_to] = canUse;\n', '  }\n', '  function canUseLock()  public view returns (bool){\n', '      return lockAdminList[msg.sender];\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value)public  returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value)public  returns (bool);\n', '  function approve(address spender, uint256 value)public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    emit Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause()public onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    emit Unpause();\n', '    return true;\n', '  }\n', '}\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value)public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title FFC Token\n', ' * @dev FFC is PausableToken\n', ' */\n', 'contract FFCToken is StandardToken, Pausable {\n', '\n', '  string public constant name = "FFC";\n', '  string public constant symbol = "FFC";\n', '  uint256 public constant decimals = 18;\n', '  \n', '  // lock\n', '  struct LockToken{\n', '      uint256 amount;\n', '      uint32  time;\n', '  }\n', '  struct LockTokenSet{\n', '      LockToken[] lockList;\n', '  }\n', '  mapping ( address => LockTokenSet ) addressTimeLock;\n', '  mapping ( address => bool ) lockAdminList;\n', '  event TransferWithLockEvt(address indexed from, address indexed to, uint256 value,uint256 lockValue,uint32 lockTime );\n', '  /**\n', '    * @dev Creates a new MPKToken instance\n', '    */\n', '  constructor() public {\n', '    totalSupply = 10 * (10 ** 8) * (10 ** 18);\n', '    balances[0xC0FF6587381Ed1690baC9954f9Ace2768738BaDa] = totalSupply;\n', '  }\n', '  \n', '  function transfer(address _to, uint256 _value)public whenNotPaused returns (bool) {\n', '    assert ( balances[msg.sender].sub( getLockAmount( msg.sender ) ) >= _value );\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)public whenNotPaused returns (bool) {\n', '    assert ( balances[_from].sub( getLockAmount( msg.sender ) ) >= _value );\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '  function getLockAmount( address myaddress ) public view returns ( uint256 lockSum ) {\n', '        uint256 lockAmount = 0;\n', '        for( uint32 i = 0; i < addressTimeLock[myaddress].lockList.length; i ++ ){\n', '            if( addressTimeLock[myaddress].lockList[i].time > now ){\n', '                lockAmount += addressTimeLock[myaddress].lockList[i].amount;\n', '            }\n', '        }\n', '        return lockAmount;\n', '  }\n', '  \n', '  function getLockListLen( address myaddress ) public view returns ( uint256 lockAmount  ){\n', '      return addressTimeLock[myaddress].lockList.length;\n', '  }\n', '  \n', '  function getLockByIdx( address myaddress,uint32 idx ) public view returns ( uint256 lockAmount, uint32 lockTime ){\n', '      if( idx >= addressTimeLock[myaddress].lockList.length ){\n', '        return (0,0);          \n', '      }\n', '      lockAmount = addressTimeLock[myaddress].lockList[idx].amount;\n', '      lockTime = addressTimeLock[myaddress].lockList[idx].time;\n', '      return ( lockAmount,lockTime );\n', '  }\n', '  \n', '  function transferWithLock( address _to, uint256 _value,uint256 _lockValue,uint32 _lockTime )public whenNotPaused {\n', '      if( lockAdminList[msg.sender] != true ){\n', '            return;\n', '      }\n', '      assert( _lockTime > now  );\n', '      assert( _lockValue > 0 && _lockValue <= _value );\n', '      transfer( _to, _value );\n', '      bool needNewLock = true;\n', '      for( uint32 i = 0 ; i< addressTimeLock[_to].lockList.length; i ++ ){\n', '          if( addressTimeLock[_to].lockList[i].time < now ){\n', '              addressTimeLock[_to].lockList[i].time = _lockTime;\n', '              addressTimeLock[_to].lockList[i].amount = _lockValue;\n', '              emit TransferWithLockEvt( msg.sender,_to,_value,_lockValue,_lockTime );\n', '              needNewLock = false;\n', '              break;\n', '          }\n', '      }\n', '      if( needNewLock == true ){\n', '          // add a lock\n', '          addressTimeLock[_to].lockList.length ++ ;\n', '          addressTimeLock[_to].lockList[(addressTimeLock[_to].lockList.length-1)].time = _lockTime;\n', '          addressTimeLock[_to].lockList[(addressTimeLock[_to].lockList.length-1)].amount = _lockValue;\n', '          emit TransferWithLockEvt( msg.sender,_to,_value,_lockValue,_lockTime);\n', '      }\n', '  }\n', '  function setLockAdmin(address _to,bool canUse)public onlyOwner{\n', '      lockAdminList[_to] = canUse;\n', '  }\n', '  function canUseLock()  public view returns (bool){\n', '      return lockAdminList[msg.sender];\n', '  }\n', '\n', '}']
