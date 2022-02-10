['pragma solidity ^0.4.23;\n', '\n', '/**xxp\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20Basic {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  // store tokens\n', '  mapping(address => uint256) balances;\n', '  // uint256 public totalSupply;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '   /**\n', '    *batch transfer token for a list of specified addresses\n', '    * @param _toList The list of addresses to transfer to.\n', '    * @param _tokensList The list of amount to be transferred.\n', '    */\n', '  function batchTransfer(address[] _toList, uint256[] _tokensList) public  returns (bool) {\n', '      require(_toList.length <= 100);\n', '      require(_toList.length == _tokensList.length);\n', '      \n', '      uint256 sum = 0;\n', '      for (uint32 index = 0; index < _tokensList.length; index++) {\n', '          sum = sum.add(_tokensList[index]);\n', '      }\n', '\n', '      // if the sender doenst have enough balance then stop\n', '      require (balances[msg.sender] >= sum);\n', '        \n', '      for (uint32 i = 0; i < _toList.length; i++) {\n', '          transfer(_toList[i],_tokensList[i]);\n', '      }\n', '      return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is StandardToken,Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  event AddToVestMap(address vestcount);\n', '  event DelFromVestMap(address vestcount);\n', '\n', '  event Released(address vestcount,uint256 amount);\n', '  event Revoked(address vestcount);\n', '\n', '  struct tokenToVest{\n', '      bool  exist;\n', '      uint256  start;\n', '      uint256  cliff;\n', '      uint256  duration;\n', '      uint256  torelease;\n', '      uint256  released;\n', '  }\n', '\n', '  //key is the account to vest\n', '  mapping (address=>tokenToVest) vestToMap;\n', '\n', '\n', '  /**\n', '   * @dev Add one account to the vest Map\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _start the time (as Unix time) at which point vesting starts \n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _torelease  delc count to release\n', '   */\n', '  function addToVestMap(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    uint256 _torelease\n', '  ) public onlyOwner{\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '    require(_start > block.timestamp);\n', '    require(!vestToMap[_beneficiary].exist);\n', '\n', '    vestToMap[_beneficiary] = tokenToVest(true,_start,_start.add(_cliff),_duration,\n', '        _torelease,uint256(0));\n', '\n', '    emit AddToVestMap(_beneficiary);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev del One account to the vest Map\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   */\n', '  function delFromVestMap(\n', '    address _beneficiary\n', '  ) public onlyOwner{\n', '    require(_beneficiary != address(0));\n', '    require(vestToMap[_beneficiary].exist);\n', '\n', '    delete vestToMap[_beneficiary];\n', '\n', '    emit DelFromVestMap(_beneficiary);\n', '  }\n', '\n', '\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   */\n', '  function release(address _beneficiary) public {\n', '\n', '    tokenToVest storage value = vestToMap[_beneficiary];\n', '    require(value.exist);\n', '    uint256 unreleased = releasableAmount(_beneficiary);\n', '    require(unreleased > 0);\n', '    require(unreleased + value.released <= value.torelease);\n', '\n', '\n', '    vestToMap[_beneficiary].released = vestToMap[_beneficiary].released.add(unreleased);\n', '\n', '    transfer(_beneficiary, unreleased);\n', '\n', '    emit Released(_beneficiary,unreleased);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested but hasn&#39;t been released yet.\n', '   */\n', '  function releasableAmount(address _beneficiary) public view returns (uint256) {\n', '    return vestedAmount(_beneficiary).sub(vestToMap[_beneficiary].released);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   */\n', '  function vestedAmount(address _beneficiary) public view returns (uint256) {\n', '\n', '    tokenToVest storage value = vestToMap[_beneficiary];\n', '    //uint256 currentBalance = balanceOf(_beneficiary);\n', '    uint256 totalBalance = value.torelease;\n', '\n', '    if (block.timestamp < value.cliff) {\n', '      return 0;\n', '    } else if (block.timestamp >= value.start.add(value.duration)) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(block.timestamp.sub(value.start)).div(value.duration);\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' *\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', '\n', 'contract PausableToken is TokenVesting, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '  \n', '  function batchTransfer(address[] _toList, uint256[] _tokensList) public whenNotPaused returns (bool) {\n', '      return super.batchTransfer(_toList, _tokensList);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function release(address _beneficiary) public whenNotPaused{\n', '    super.release(_beneficiary);\n', '  }\n', '}\n', '\n', '/*\n', ' * @title DELCToken\n', ' */\n', 'contract DELCToken is BurnableToken, MintableToken, PausableToken {\n', '  // Public variables of the token\n', '  string public name;\n', '  string public symbol;\n', '  // decimals is the strongly suggested default, avoid changing it\n', '  uint8 public decimals;\n', '\n', '  constructor() public {\n', '    name = "DELC Relation Person Token";\n', '    symbol = "DELC";\n', '    decimals = 18;\n', '    totalSupply = 10000000000 * 10 ** uint256(decimals);\n', '\n', '    // Allocate initial balance to the owner\n', '    balances[msg.sender] = totalSupply;\n', '    \n', '    emit Transfer(address(0), msg.sender, totalSupply);\n', '    \n', '  }\n', '\n', '  // transfer balance to owner\n', '  //function withdrawEther() onlyOwner public {\n', '  //    owner.transfer(this.balance);\n', '  //}\n', '\n', '  // can accept ether\n', '  //function() payable public {\n', '  //}\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**xxp\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20Basic {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  // store tokens\n', '  mapping(address => uint256) balances;\n', '  // uint256 public totalSupply;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '   /**\n', '    *batch transfer token for a list of specified addresses\n', '    * @param _toList The list of addresses to transfer to.\n', '    * @param _tokensList The list of amount to be transferred.\n', '    */\n', '  function batchTransfer(address[] _toList, uint256[] _tokensList) public  returns (bool) {\n', '      require(_toList.length <= 100);\n', '      require(_toList.length == _tokensList.length);\n', '      \n', '      uint256 sum = 0;\n', '      for (uint32 index = 0; index < _tokensList.length; index++) {\n', '          sum = sum.add(_tokensList[index]);\n', '      }\n', '\n', '      // if the sender doenst have enough balance then stop\n', '      require (balances[msg.sender] >= sum);\n', '        \n', '      for (uint32 i = 0; i < _toList.length; i++) {\n', '          transfer(_toList[i],_tokensList[i]);\n', '      }\n', '      return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the\n', ' * owner.\n', ' */\n', 'contract TokenVesting is StandardToken,Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  event AddToVestMap(address vestcount);\n', '  event DelFromVestMap(address vestcount);\n', '\n', '  event Released(address vestcount,uint256 amount);\n', '  event Revoked(address vestcount);\n', '\n', '  struct tokenToVest{\n', '      bool  exist;\n', '      uint256  start;\n', '      uint256  cliff;\n', '      uint256  duration;\n', '      uint256  torelease;\n', '      uint256  released;\n', '  }\n', '\n', '  //key is the account to vest\n', '  mapping (address=>tokenToVest) vestToMap;\n', '\n', '\n', '  /**\n', '   * @dev Add one account to the vest Map\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest\n', '   * @param _start the time (as Unix time) at which point vesting starts \n', '   * @param _duration duration in seconds of the period in which the tokens will vest\n', '   * @param _torelease  delc count to release\n', '   */\n', '  function addToVestMap(\n', '    address _beneficiary,\n', '    uint256 _start,\n', '    uint256 _cliff,\n', '    uint256 _duration,\n', '    uint256 _torelease\n', '  ) public onlyOwner{\n', '    require(_beneficiary != address(0));\n', '    require(_cliff <= _duration);\n', '    require(_start > block.timestamp);\n', '    require(!vestToMap[_beneficiary].exist);\n', '\n', '    vestToMap[_beneficiary] = tokenToVest(true,_start,_start.add(_cliff),_duration,\n', '        _torelease,uint256(0));\n', '\n', '    emit AddToVestMap(_beneficiary);\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev del One account to the vest Map\n', '   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred\n', '   */\n', '  function delFromVestMap(\n', '    address _beneficiary\n', '  ) public onlyOwner{\n', '    require(_beneficiary != address(0));\n', '    require(vestToMap[_beneficiary].exist);\n', '\n', '    delete vestToMap[_beneficiary];\n', '\n', '    emit DelFromVestMap(_beneficiary);\n', '  }\n', '\n', '\n', '\n', '  /**\n', '   * @notice Transfers vested tokens to beneficiary.\n', '   */\n', '  function release(address _beneficiary) public {\n', '\n', '    tokenToVest storage value = vestToMap[_beneficiary];\n', '    require(value.exist);\n', '    uint256 unreleased = releasableAmount(_beneficiary);\n', '    require(unreleased > 0);\n', '    require(unreleased + value.released <= value.torelease);\n', '\n', '\n', '    vestToMap[_beneficiary].released = vestToMap[_beneficiary].released.add(unreleased);\n', '\n', '    transfer(_beneficiary, unreleased);\n', '\n', '    emit Released(_beneficiary,unreleased);\n', '  }\n', '\n', '  /**\n', "   * @dev Calculates the amount that has already vested but hasn't been released yet.\n", '   */\n', '  function releasableAmount(address _beneficiary) public view returns (uint256) {\n', '    return vestedAmount(_beneficiary).sub(vestToMap[_beneficiary].released);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates the amount that has already vested.\n', '   */\n', '  function vestedAmount(address _beneficiary) public view returns (uint256) {\n', '\n', '    tokenToVest storage value = vestToMap[_beneficiary];\n', '    //uint256 currentBalance = balanceOf(_beneficiary);\n', '    uint256 totalBalance = value.torelease;\n', '\n', '    if (block.timestamp < value.cliff) {\n', '      return 0;\n', '    } else if (block.timestamp >= value.start.add(value.duration)) {\n', '      return totalBalance;\n', '    } else {\n', '      return totalBalance.mul(block.timestamp.sub(value.start)).div(value.duration);\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' *\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', '\n', 'contract PausableToken is TokenVesting, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '  \n', '  function batchTransfer(address[] _toList, uint256[] _tokensList) public whenNotPaused returns (bool) {\n', '      return super.batchTransfer(_toList, _tokensList);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function release(address _beneficiary) public whenNotPaused{\n', '    super.release(_beneficiary);\n', '  }\n', '}\n', '\n', '/*\n', ' * @title DELCToken\n', ' */\n', 'contract DELCToken is BurnableToken, MintableToken, PausableToken {\n', '  // Public variables of the token\n', '  string public name;\n', '  string public symbol;\n', '  // decimals is the strongly suggested default, avoid changing it\n', '  uint8 public decimals;\n', '\n', '  constructor() public {\n', '    name = "DELC Relation Person Token";\n', '    symbol = "DELC";\n', '    decimals = 18;\n', '    totalSupply = 10000000000 * 10 ** uint256(decimals);\n', '\n', '    // Allocate initial balance to the owner\n', '    balances[msg.sender] = totalSupply;\n', '    \n', '    emit Transfer(address(0), msg.sender, totalSupply);\n', '    \n', '  }\n', '\n', '  // transfer balance to owner\n', '  //function withdrawEther() onlyOwner public {\n', '  //    owner.transfer(this.balance);\n', '  //}\n', '\n', '  // can accept ether\n', '  //function() payable public {\n', '  //}\n', '}']
