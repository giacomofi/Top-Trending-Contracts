['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '    \n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '    \n', '   /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Eurufly is StandardToken, Ownable{\n', '    string  public  constant name = "Eurufly";\n', '    string  public  constant symbol = "EUR";\n', '    uint8   public  constant decimals = 18;\n', '    uint256 public priceOfToken = 2500; // 1 ether = 2500 EUR\n', '  uint256 public icoStartAt ;\n', '  uint256 public icoEndAt ;\n', '  uint256 public preIcoStartAt ;\n', '  uint256 public preIcoEndAt ;\n', '  uint256 public prePreIcoStartAt;\n', '  uint256 public prePreIcoEndAt;\n', '  STATE public state = STATE.UNKNOWN;\n', '  address wallet ; // Where all ether is transfered\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '  address public owner ;\n', '  enum STATE{UNKNOWN, PREPREICO, PREICO, POSTICO}\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  \n', '  function transfer(address _to, uint _value)  public returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value)  public returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '    // Start Pre Pre ICO\n', '    function startPrePreIco(uint256 x) public onlyOwner{\n', '        require(state == STATE.UNKNOWN);\n', '        prePreIcoStartAt = block.timestamp ;\n', '        prePreIcoEndAt = block.timestamp + x * 1 days ; // pre pre\n', '        state = STATE.PREPREICO;\n', '        \n', '    }\n', '    \n', '    // Start Pre ICO\n', '    function startPreIco(uint256 x) public onlyOwner{\n', '        require(state == STATE.PREPREICO);\n', '        preIcoStartAt = block.timestamp ;\n', '        preIcoEndAt = block.timestamp + x * 1 days ; // pre \n', '        state = STATE.PREICO;\n', '        \n', '    }\n', '    \n', '    // Start POSTICO\n', '    function startPostIco(uint256 x) public onlyOwner{\n', '         require(state == STATE.PREICO);\n', '         icoStartAt = block.timestamp ;\n', '         icoEndAt = block.timestamp + x * 1 days;\n', '         state = STATE.POSTICO;\n', '          \n', '     }\n', '    \n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(priceOfToken);\n', '  }\n', '\n', ' \n', '  function _forwardFunds() internal {\n', '     wallet.transfer(msg.value);\n', '  }\n', '  \n', '  function () external payable {\n', '    require(totalSupply_<= 10 ** 26);\n', '    require(state != STATE.UNKNOWN);\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '    \n', '     require(_beneficiary != address(0x0));\n', '     if(state == STATE.PREPREICO){\n', '        require(now >= prePreIcoStartAt && now <= prePreIcoEndAt);\n', '        require(msg.value <= 10 ether);\n', '      }else if(state == STATE.PREICO){\n', '       require(now >= preIcoStartAt && now <= preIcoEndAt);\n', '       require(msg.value <= 15 ether);\n', '      }else if(state == STATE.POSTICO){\n', '        require(now >= icoStartAt && now <= icoEndAt);\n', '        require(msg.value <= 20 ether);\n', '      }\n', '      \n', '      uint256 weiAmount = msg.value;\n', '      uint256 tokens = _getTokenAmount(weiAmount);\n', '      \n', '      if(state == STATE.PREPREICO){                 // bonuses\n', '         tokens = tokens.add(tokens.mul(30).div(100));\n', '      }else if(state == STATE.PREICO){\n', '        tokens = tokens.add(tokens.mul(25).div(100));\n', '      }else if(state == STATE.POSTICO){\n', '        tokens = tokens.add(tokens.mul(20).div(100));\n', '      }\n', '     totalSupply_ = totalSupply_.add(tokens);\n', '     balances[msg.sender] = balances[msg.sender].add(tokens);\n', '     emit Transfer(address(0), msg.sender, tokens);\n', '    // update state\n', '     weiRaised = weiRaised.add(weiAmount);\n', '     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '     _forwardFunds();\n', '   }\n', '    \n', '    constructor(address ethWallet) public{\n', '        wallet = ethWallet;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function emergencyERC20Drain(ERC20 token, uint amount) public onlyOwner {\n', '        // owner can drain tokens that are sent here by mistake\n', '        token.transfer( owner, amount );\n', '    }\n', '    \n', '    function allocate(address user, uint256 amount) public onlyOwner{\n', '       \n', '        require(totalSupply_.add(amount) <= 10 ** 26 );\n', '        uint256 tokens = amount * (10 ** 18);\n', '        totalSupply_ = totalSupply_.add(tokens);\n', '        balances[user] = balances[user].add(tokens);\n', '        emit Transfer(address(0), user , tokens);\n', '   \n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '    \n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '    \n', '   /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Eurufly is StandardToken, Ownable{\n', '    string  public  constant name = "Eurufly";\n', '    string  public  constant symbol = "EUR";\n', '    uint8   public  constant decimals = 18;\n', '    uint256 public priceOfToken = 2500; // 1 ether = 2500 EUR\n', '  uint256 public icoStartAt ;\n', '  uint256 public icoEndAt ;\n', '  uint256 public preIcoStartAt ;\n', '  uint256 public preIcoEndAt ;\n', '  uint256 public prePreIcoStartAt;\n', '  uint256 public prePreIcoEndAt;\n', '  STATE public state = STATE.UNKNOWN;\n', '  address wallet ; // Where all ether is transfered\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '  address public owner ;\n', '  enum STATE{UNKNOWN, PREPREICO, PREICO, POSTICO}\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  \n', '  function transfer(address _to, uint _value)  public returns (bool success) {\n', '    // Call StandardToken.transfer()\n', '   return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value)  public returns (bool success) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '    // Start Pre Pre ICO\n', '    function startPrePreIco(uint256 x) public onlyOwner{\n', '        require(state == STATE.UNKNOWN);\n', '        prePreIcoStartAt = block.timestamp ;\n', '        prePreIcoEndAt = block.timestamp + x * 1 days ; // pre pre\n', '        state = STATE.PREPREICO;\n', '        \n', '    }\n', '    \n', '    // Start Pre ICO\n', '    function startPreIco(uint256 x) public onlyOwner{\n', '        require(state == STATE.PREPREICO);\n', '        preIcoStartAt = block.timestamp ;\n', '        preIcoEndAt = block.timestamp + x * 1 days ; // pre \n', '        state = STATE.PREICO;\n', '        \n', '    }\n', '    \n', '    // Start POSTICO\n', '    function startPostIco(uint256 x) public onlyOwner{\n', '         require(state == STATE.PREICO);\n', '         icoStartAt = block.timestamp ;\n', '         icoEndAt = block.timestamp + x * 1 days;\n', '         state = STATE.POSTICO;\n', '          \n', '     }\n', '    \n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(priceOfToken);\n', '  }\n', '\n', ' \n', '  function _forwardFunds() internal {\n', '     wallet.transfer(msg.value);\n', '  }\n', '  \n', '  function () external payable {\n', '    require(totalSupply_<= 10 ** 26);\n', '    require(state != STATE.UNKNOWN);\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '    \n', '     require(_beneficiary != address(0x0));\n', '     if(state == STATE.PREPREICO){\n', '        require(now >= prePreIcoStartAt && now <= prePreIcoEndAt);\n', '        require(msg.value <= 10 ether);\n', '      }else if(state == STATE.PREICO){\n', '       require(now >= preIcoStartAt && now <= preIcoEndAt);\n', '       require(msg.value <= 15 ether);\n', '      }else if(state == STATE.POSTICO){\n', '        require(now >= icoStartAt && now <= icoEndAt);\n', '        require(msg.value <= 20 ether);\n', '      }\n', '      \n', '      uint256 weiAmount = msg.value;\n', '      uint256 tokens = _getTokenAmount(weiAmount);\n', '      \n', '      if(state == STATE.PREPREICO){                 // bonuses\n', '         tokens = tokens.add(tokens.mul(30).div(100));\n', '      }else if(state == STATE.PREICO){\n', '        tokens = tokens.add(tokens.mul(25).div(100));\n', '      }else if(state == STATE.POSTICO){\n', '        tokens = tokens.add(tokens.mul(20).div(100));\n', '      }\n', '     totalSupply_ = totalSupply_.add(tokens);\n', '     balances[msg.sender] = balances[msg.sender].add(tokens);\n', '     emit Transfer(address(0), msg.sender, tokens);\n', '    // update state\n', '     weiRaised = weiRaised.add(weiAmount);\n', '     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '     _forwardFunds();\n', '   }\n', '    \n', '    constructor(address ethWallet) public{\n', '        wallet = ethWallet;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function emergencyERC20Drain(ERC20 token, uint amount) public onlyOwner {\n', '        // owner can drain tokens that are sent here by mistake\n', '        token.transfer( owner, amount );\n', '    }\n', '    \n', '    function allocate(address user, uint256 amount) public onlyOwner{\n', '       \n', '        require(totalSupply_.add(amount) <= 10 ** 26 );\n', '        uint256 tokens = amount * (10 ** 18);\n', '        totalSupply_ = totalSupply_.add(tokens);\n', '        balances[user] = balances[user].add(tokens);\n', '        emit Transfer(address(0), user , tokens);\n', '   \n', '    }\n', '}']