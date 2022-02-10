['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract ClubMatesCom is StandardToken, Claimable {\n', '  using SafeMath for uint256;\n', '  uint8 public constant PERCENT_BONUS=15;\n', '\n', '  ///////////////////////\n', '  // DATA STRUCTURES  ///\n', '  ///////////////////////\n', '  enum StatusName {Pending, OneSign, TwoSign, Minted}\n', '\n', '  struct MintStatus {\n', '    StatusName status;\n', '    address    beneficiary;\n', '    uint256    amount;\n', '    address    firstSign;\n', '    address    secondSign;\n', '  }\n', '  \n', '  MintStatus public additionalMint;\n', '\n', '  string  public name;\n', '  string  public symbol;\n', '  uint8   public decimals;\n', '  address public accICO;\n', '  address public accBonusTokens;\n', '  address public accMinterOne; \n', '  address public accMinterTwo;\n', '\n', '  ///////////////\n', '  // EVENTS    //\n', '  ///////////////\n', '  event BatchDistrib(uint8 cnt , uint256 batchAmount);\n', '  event NewMintPending(address _beneficiary, uint256 mintAmount, uint64 timestamp);\n', '  event FirstSign(address _signer, uint64 timestamp);\n', '  event SecondSign(address _signer, uint64 timestamp);\n', '  event Minted(address _to, uint256 _amount);\n', '\n', '  constructor (\n', '      address _accICO, \n', '      address _accBonusTokens, \n', '      address _accMinterOne, \n', '      address _accMinterTwo,\n', '      uint256 _initialSupply)\n', '  public \n', '  {\n', '      name           = "ClubMatesCom_TEST";\n', '      symbol         = "CMC";\n', '      decimals       = 18;\n', '      accICO         = _accICO;\n', '      accBonusTokens = _accBonusTokens;\n', '      accMinterOne   = _accMinterOne; \n', '      accMinterTwo   = _accMinterTwo;\n', '      totalSupply_   = _initialSupply * (10 ** uint256(decimals));// All CIX tokens in the world\n', '      //Initial token distribution\n', '      balances[_accICO]         = totalSupply()/100*(100-PERCENT_BONUS);\n', '      balances[_accBonusTokens] = totalSupply()/100*PERCENT_BONUS;\n', '      emit Transfer(address(0), _accICO, totalSupply()/100*(100-PERCENT_BONUS));\n', '      emit Transfer(address(0), _accBonusTokens, totalSupply()/100*PERCENT_BONUS);\n', '      //Default values for additionalMint record\n', '      additionalMint.status     = StatusName.Minted;\n', '      additionalMint.amount     = totalSupply();\n', '      additionalMint.firstSign  = address(0);\n', '      additionalMint.secondSign = address(0);\n', '  }\n', '\n', '  modifier onlyTrustedSign() {\n', '      require(msg.sender == accMinterOne || msg.sender == accMinterTwo);\n', '      _;\n', '  }\n', '\n', '  modifier onlyTokenKeeper() {\n', '      require(msg.sender == accICO || msg.sender == accBonusTokens);\n', '      _;\n', '  }\n', '\n', '\n', '  function() public { } \n', '\n', '\n', '  //Batch token distribution from cab\n', '  function multiTransfer(address[] _investors, uint256[] _value )  \n', '      public \n', '      onlyTokenKeeper \n', '      returns (uint256 _batchAmount)\n', '  {\n', '      require(_investors.length <= 255); //audit recommendation\n', '      require(_value.length == _investors.length);\n', '      uint8      cnt = uint8(_investors.length);\n', '      uint256 amount = 0;\n', '      for (uint i=0; i<cnt; i++){\n', '        amount = amount.add(_value[i]);\n', '        require(_investors[i] != address(0));\n', '        balances[_investors[i]] = balances[_investors[i]].add(_value[i]);\n', '        emit Transfer(msg.sender, _investors[i], _value[i]);\n', '      }\n', '      require(amount <= balances[msg.sender]);\n', '      balances[msg.sender] = balances[msg.sender].sub(amount);\n', '      emit BatchDistrib(cnt, amount);\n', '      return amount;\n', '  }\n', '\n', '  function requestNewMint(address _beneficiary, uint256 _amount) public onlyOwner  {\n', '      require(_beneficiary != address(0) && _beneficiary != address(this));\n', '      require(_amount > 0);\n', '      require(\n', '          additionalMint.status == StatusName.Minted  ||\n', '          additionalMint.status == StatusName.Pending || \n', '          additionalMint.status == StatusName.OneSign \n', '      );\n', '      additionalMint.status      = StatusName.Pending;\n', '      additionalMint.beneficiary = _beneficiary;\n', '      additionalMint.amount      = _amount;\n', '      additionalMint.firstSign   = address(0);\n', '      additionalMint.secondSign  = address(0);\n', '      emit NewMintPending(_beneficiary,  _amount, uint64(now));\n', '  }\n', '\n', '  //Get  signs  from defined accounts\n', '  function sign() public onlyTrustedSign  returns (bool) {\n', '      require(\n', '          additionalMint.status == StatusName.Pending || \n', '          additionalMint.status == StatusName.OneSign ||\n', '          additionalMint.status == StatusName.TwoSign //non existing sit\n', '      );\n', '\n', '      if (additionalMint.status == StatusName.Pending) {\n', '          additionalMint.firstSign = msg.sender;\n', '          additionalMint.status    = StatusName.OneSign;\n', '          emit FirstSign(msg.sender, uint64(now));\n', '          return true;\n', '      }\n', '\n', '      if (additionalMint.status == StatusName.OneSign) {\n', '        if (additionalMint.firstSign != msg.sender) {\n', '            additionalMint.secondSign = msg.sender;\n', '            additionalMint.status     = StatusName.TwoSign;\n', '            emit SecondSign(msg.sender, uint64(now));\n', '        }    \n', '      }\n', '        \n', '      if (additionalMint.status == StatusName.TwoSign) {\n', '          if (mint(additionalMint.beneficiary, additionalMint.amount)) {\n', '              additionalMint.status = StatusName.Minted;\n', '              emit   Minted(additionalMint.beneficiary, additionalMint.amount);\n', '          }    \n', '      }\n', '      return true;\n', '  }\n', '\n', '  //\n', '  function mint(address _to, uint256 _amount) internal returns (bool) {\n', '      totalSupply_  = totalSupply_.add(_amount);\n', '      balances[_to] = balances[_to].add(_amount);\n', '      emit Transfer(address(0), _to, _amount);\n', '      return true;\n', '  }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract ClubMatesCom is StandardToken, Claimable {\n', '  using SafeMath for uint256;\n', '  uint8 public constant PERCENT_BONUS=15;\n', '\n', '  ///////////////////////\n', '  // DATA STRUCTURES  ///\n', '  ///////////////////////\n', '  enum StatusName {Pending, OneSign, TwoSign, Minted}\n', '\n', '  struct MintStatus {\n', '    StatusName status;\n', '    address    beneficiary;\n', '    uint256    amount;\n', '    address    firstSign;\n', '    address    secondSign;\n', '  }\n', '  \n', '  MintStatus public additionalMint;\n', '\n', '  string  public name;\n', '  string  public symbol;\n', '  uint8   public decimals;\n', '  address public accICO;\n', '  address public accBonusTokens;\n', '  address public accMinterOne; \n', '  address public accMinterTwo;\n', '\n', '  ///////////////\n', '  // EVENTS    //\n', '  ///////////////\n', '  event BatchDistrib(uint8 cnt , uint256 batchAmount);\n', '  event NewMintPending(address _beneficiary, uint256 mintAmount, uint64 timestamp);\n', '  event FirstSign(address _signer, uint64 timestamp);\n', '  event SecondSign(address _signer, uint64 timestamp);\n', '  event Minted(address _to, uint256 _amount);\n', '\n', '  constructor (\n', '      address _accICO, \n', '      address _accBonusTokens, \n', '      address _accMinterOne, \n', '      address _accMinterTwo,\n', '      uint256 _initialSupply)\n', '  public \n', '  {\n', '      name           = "ClubMatesCom_TEST";\n', '      symbol         = "CMC";\n', '      decimals       = 18;\n', '      accICO         = _accICO;\n', '      accBonusTokens = _accBonusTokens;\n', '      accMinterOne   = _accMinterOne; \n', '      accMinterTwo   = _accMinterTwo;\n', '      totalSupply_   = _initialSupply * (10 ** uint256(decimals));// All CIX tokens in the world\n', '      //Initial token distribution\n', '      balances[_accICO]         = totalSupply()/100*(100-PERCENT_BONUS);\n', '      balances[_accBonusTokens] = totalSupply()/100*PERCENT_BONUS;\n', '      emit Transfer(address(0), _accICO, totalSupply()/100*(100-PERCENT_BONUS));\n', '      emit Transfer(address(0), _accBonusTokens, totalSupply()/100*PERCENT_BONUS);\n', '      //Default values for additionalMint record\n', '      additionalMint.status     = StatusName.Minted;\n', '      additionalMint.amount     = totalSupply();\n', '      additionalMint.firstSign  = address(0);\n', '      additionalMint.secondSign = address(0);\n', '  }\n', '\n', '  modifier onlyTrustedSign() {\n', '      require(msg.sender == accMinterOne || msg.sender == accMinterTwo);\n', '      _;\n', '  }\n', '\n', '  modifier onlyTokenKeeper() {\n', '      require(msg.sender == accICO || msg.sender == accBonusTokens);\n', '      _;\n', '  }\n', '\n', '\n', '  function() public { } \n', '\n', '\n', '  //Batch token distribution from cab\n', '  function multiTransfer(address[] _investors, uint256[] _value )  \n', '      public \n', '      onlyTokenKeeper \n', '      returns (uint256 _batchAmount)\n', '  {\n', '      require(_investors.length <= 255); //audit recommendation\n', '      require(_value.length == _investors.length);\n', '      uint8      cnt = uint8(_investors.length);\n', '      uint256 amount = 0;\n', '      for (uint i=0; i<cnt; i++){\n', '        amount = amount.add(_value[i]);\n', '        require(_investors[i] != address(0));\n', '        balances[_investors[i]] = balances[_investors[i]].add(_value[i]);\n', '        emit Transfer(msg.sender, _investors[i], _value[i]);\n', '      }\n', '      require(amount <= balances[msg.sender]);\n', '      balances[msg.sender] = balances[msg.sender].sub(amount);\n', '      emit BatchDistrib(cnt, amount);\n', '      return amount;\n', '  }\n', '\n', '  function requestNewMint(address _beneficiary, uint256 _amount) public onlyOwner  {\n', '      require(_beneficiary != address(0) && _beneficiary != address(this));\n', '      require(_amount > 0);\n', '      require(\n', '          additionalMint.status == StatusName.Minted  ||\n', '          additionalMint.status == StatusName.Pending || \n', '          additionalMint.status == StatusName.OneSign \n', '      );\n', '      additionalMint.status      = StatusName.Pending;\n', '      additionalMint.beneficiary = _beneficiary;\n', '      additionalMint.amount      = _amount;\n', '      additionalMint.firstSign   = address(0);\n', '      additionalMint.secondSign  = address(0);\n', '      emit NewMintPending(_beneficiary,  _amount, uint64(now));\n', '  }\n', '\n', '  //Get  signs  from defined accounts\n', '  function sign() public onlyTrustedSign  returns (bool) {\n', '      require(\n', '          additionalMint.status == StatusName.Pending || \n', '          additionalMint.status == StatusName.OneSign ||\n', '          additionalMint.status == StatusName.TwoSign //non existing sit\n', '      );\n', '\n', '      if (additionalMint.status == StatusName.Pending) {\n', '          additionalMint.firstSign = msg.sender;\n', '          additionalMint.status    = StatusName.OneSign;\n', '          emit FirstSign(msg.sender, uint64(now));\n', '          return true;\n', '      }\n', '\n', '      if (additionalMint.status == StatusName.OneSign) {\n', '        if (additionalMint.firstSign != msg.sender) {\n', '            additionalMint.secondSign = msg.sender;\n', '            additionalMint.status     = StatusName.TwoSign;\n', '            emit SecondSign(msg.sender, uint64(now));\n', '        }    \n', '      }\n', '        \n', '      if (additionalMint.status == StatusName.TwoSign) {\n', '          if (mint(additionalMint.beneficiary, additionalMint.amount)) {\n', '              additionalMint.status = StatusName.Minted;\n', '              emit   Minted(additionalMint.beneficiary, additionalMint.amount);\n', '          }    \n', '      }\n', '      return true;\n', '  }\n', '\n', '  //\n', '  function mint(address _to, uint256 _amount) internal returns (bool) {\n', '      totalSupply_  = totalSupply_.add(_amount);\n', '      balances[_to] = balances[_to].add(_amount);\n', '      emit Transfer(address(0), _to, _amount);\n', '      return true;\n', '  }\n', '}']
