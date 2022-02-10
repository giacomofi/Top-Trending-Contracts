['contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC827 is ERC20 {\n', '  function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);\n', '  function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);\n', '  function transferFromAndCall(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value,\n', '    bytes _data\n', '  )\n', '    public\n', '    payable\n', '    returns (bool);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC827Token is ERC827, StandardToken {\n', '\n', '  /**\n', '   * @dev Addition to ERC20 token methods. It allows to\n', '   * @dev approve the transfer of value and execute a call with the sent data.\n', '   *\n', '   * @dev Beware that changing an allowance with this method brings the risk that\n', '   * @dev someone may use both the old and the new allowance by unfortunate\n', '   * @dev transaction ordering. One possible solution to mitigate this race condition\n', '   * @dev is to first reduce the spender&#39;s allowance to 0 and set the desired value\n', '   * @dev afterwards:\n', '   * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   * @param _spender The address that will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   * @param _data ABI-encoded contract call to call `_to` address.\n', '   *\n', '   * @return true if the call function was executed successfully\n', '   */\n', '  function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.approve(_spender, _value);\n', '\n', '    // solium-disable-next-line security/no-call-value\n', '    require(_spender.call.value(msg.value)(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to ERC20 token methods. Transfer tokens to a specified\n', '   * @dev address and execute a call with the sent data on the same transaction\n', '   *\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   * @param _data ABI-encoded contract call to call `_to` address.\n', '   *\n', '   * @return true if the call function was executed successfully\n', '   */\n', '  function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {\n', '    require(_to != address(this));\n', '\n', '    super.transfer(_to, _value);\n', '\n', '    // solium-disable-next-line security/no-call-value\n', '    require(_to.call.value(msg.value)(_data));\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to ERC20 token methods. Transfer tokens from one address to\n', '   * @dev another and make a contract call on the same transaction\n', '   *\n', '   * @param _from The address which you want to send tokens from\n', '   * @param _to The address which you want to transfer to\n', '   * @param _value The amout of tokens to be transferred\n', '   * @param _data ABI-encoded contract call to call `_to` address.\n', '   *\n', '   * @return true if the call function was executed successfully\n', '   */\n', '  function transferFromAndCall(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value,\n', '    bytes _data\n', '  )\n', '    public payable returns (bool)\n', '  {\n', '    require(_to != address(this));\n', '\n', '    super.transferFrom(_from, _to, _value);\n', '\n', '    // solium-disable-next-line security/no-call-value\n', '    require(_to.call.value(msg.value)(_data));\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to StandardToken methods. Increase the amount of tokens that\n', '   * @dev an owner allowed to a spender and execute a call with the sent data.\n', '   *\n', '   * @dev approve should be called when allowed[_spender] == 0. To increment\n', '   * @dev allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * @dev the first transaction is mined)\n', '   * @dev From MonolithDAO Token.sol\n', '   *\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   * @param _data ABI-encoded contract call to call `_spender` address.\n', '   */\n', '  function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.increaseApproval(_spender, _addedValue);\n', '\n', '    // solium-disable-next-line security/no-call-value\n', '    require(_spender.call.value(msg.value)(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Addition to StandardToken methods. Decrease the amount of tokens that\n', '   * @dev an owner allowed to a spender and execute a call with the sent data.\n', '   *\n', '   * @dev approve should be called when allowed[_spender] == 0. To decrement\n', '   * @dev allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * @dev the first transaction is mined)\n', '   * @dev From MonolithDAO Token.sol\n', '   *\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   * @param _data ABI-encoded contract call to call `_spender` address.\n', '   */\n', '  function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {\n', '    require(_spender != address(this));\n', '\n', '    super.decreaseApproval(_spender, _subtractedValue);\n', '\n', '    // solium-disable-next-line security/no-call-value\n', '    require(_spender.call.value(msg.value)(_data));\n', '\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', 'contract Controller is ERC827Token, MintableToken, PausableToken {\n', '  address public thisAddr; // matches delegation slot in proxy\n', '  uint256 public cap;      // the max cap of this token\n', '  string public constant name = "LifeTask"; // solium-disable-line uppercase\n', '  string public constant symbol = "LTS"; // solium-disable-line uppercase\n', '  uint8 public constant decimals = 18; // solium-disable-line uppercase\n', '\n', '  /**\n', '   * @dev Function to initialize storage, only callable from proxy.\n', '   * @param _controller The address where code is loaded from through delegatecall\n', '   * @param _cap The cap that should be set for the token\n', '   */\n', '  function initialize(address _controller, uint256 _cap) onlyOwner public {\n', '    require(cap == 0);\n', '    require(_cap > 0);\n', '    require(thisAddr == _controller);\n', '    cap = _cap;\n', '    totalSupply_ = 0;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '  \trequire(cap > 0);\n', '    require(totalSupply_.add(_amount) <= cap);\n', '    return super.mint(_to, _amount);\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']