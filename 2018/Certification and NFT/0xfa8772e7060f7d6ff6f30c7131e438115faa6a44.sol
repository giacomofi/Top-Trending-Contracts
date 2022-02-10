['pragma solidity ^0.4.18;\n', ' \n', '//Never Mind :P\n', '/* @dev The Ownable contract has an owner address, and provides basic authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract NVTReceiver {\n', '    function NVTFallback(address _from, uint _value, uint _code);\n', '}\n', '\n', 'contract BasicToken {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    \n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    if(!isContract(_to)){\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;}\n', '    else{\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    NVTReceiver receiver = NVTReceiver(_to);\n', '    receiver.NVTFallback(msg.sender, _value, 0);\n', '    Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '  }\n', '  function transfer(address _to, uint _value, uint _code) public returns (bool) {\n', '      require(isContract(_to));\n', '      require(_value <= balances[msg.sender]);\n', '      balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '      balances[_to] = balanceOf(_to).add(_value);\n', '      NVTReceiver receiver = NVTReceiver(_to);\n', '      receiver.NVTFallback(msg.sender, _value, _code);\n', '      Transfer(msg.sender, _to, _value);\n', '    \n', '      return true;\n', '    \n', '    }\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '\n', 'function isContract(address _addr) private returns (bool is_contract) {\n', '    uint length;\n', '    assembly {\n', '        //retrieve the size of the code on target address, this needs assembly\n', '        length := extcodesize(_addr)\n', '    }\n', '    return (length>0);\n', '  }\n', '\n', '\n', '  //function that is called when transaction target is a contract\n', '  //Only used for recycling NVTs\n', '  function transferToContract(address _to, uint _value, uint _code) public returns (bool success) {\n', '    require(isContract(_to));\n', '    require(_value <= balances[msg.sender]);\n', '  \n', '      balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    NVTReceiver receiver = NVTReceiver(_to);\n', '    receiver.NVTFallback(msg.sender, _value, _code);\n', '    Transfer(msg.sender, _to, _value);\n', '    \n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract NVT is BasicToken, Ownable {\n', '\n', '  string public constant name = "NiceVotingToken";\n', '  string public constant symbol = "NVT";\n', '  uint8 public constant decimals = 2;\n', '\n', '  uint256 public constant TOTAL_SUPPLY = 100 * 10 ** 10; //10 billion tokens\n', '  uint256 public RELEASE_TIME ;\n', '  uint256 public TOKEN_FOR_SALE = 40 * 10 ** 10;\n', '  uint256 public TOKEN_FOR_TEAM = 10 * 10 ** 10;\n', '  uint256 public TOKEN_FOR_COMUNITY = 20 * 10 ** 10;\n', '  uint256 public TOKEN_FOR_INVESTER = 25 * 10 ** 10;\n', '\n', '\n', '  uint256 public price = 10 ** 12; //1:10000\n', '  bool public halted = false;\n', '\n', '  /**\n', '  * @dev Constructor that gives msg.sender all of existing tokens.\n', '  */\n', '  function NVT() public {\n', '    totalSupply_ = 5 * 10 ** 10; // 5 percent for early market promotion\n', '    balances[msg.sender] = 5 * 10 ** 10;\n', '    Transfer(0x0, msg.sender, 5 * 10 ** 10);\n', '    RELEASE_TIME = now;\n', '  }\n', '\n', '  //Rember 18 zeros for decimals of eth(wei), and 2 zeros for NVT. So add 16 zeros with * 10 ** 16\n', '  //price can only go higher\n', '  function setPrice(uint _newprice) onlyOwner{\n', '    require(_newprice > price);\n', '    price=_newprice; \n', '  }\n', '\n', '  //Incoming payment for purchase\n', '  function () public payable{\n', '    require(halted == false);\n', '    uint amout = msg.value.div(price);\n', '    require(amout <= TOKEN_FOR_SALE);\n', '    TOKEN_FOR_SALE = TOKEN_FOR_SALE.sub(amout);\n', '    balances[msg.sender] = balanceOf(msg.sender).add(amout);\n', '    totalSupply_=totalSupply_.add(amout);\n', '    Transfer(0x0, msg.sender, amout);\n', '  }\n', '\n', '  function getTokenForTeam (address _to, uint _amout) onlyOwner returns(bool){\n', '    TOKEN_FOR_TEAM = TOKEN_FOR_TEAM.sub(_amout);\n', '    totalSupply_=totalSupply_.add(_amout);\n', '    balances[_to] = balanceOf(_to).add(_amout);\n', '    Transfer(0x0, _to, _amout);\n', '    return true;\n', '  }\n', '\n', '\n', '  function getTokenForInvester (address _to, uint _amout) onlyOwner returns(bool){\n', '    TOKEN_FOR_INVESTER = TOKEN_FOR_INVESTER.sub(_amout);\n', '    totalSupply_=totalSupply_.add(_amout);\n', '    balances[_to] = balanceOf(_to).add(_amout);\n', '    Transfer(0x0, _to, _amout);\n', '    return true;\n', '  }\n', '\n', '\n', '  function getTokenForCommunity (address _to, uint _amout) onlyOwner{\n', '    require(_amout <= TOKEN_FOR_COMUNITY);\n', '    TOKEN_FOR_COMUNITY = TOKEN_FOR_COMUNITY.sub(_amout);\n', '    totalSupply_=totalSupply_.add(_amout);\n', '    balances[_to] = balanceOf(_to).add(_amout);\n', '    Transfer(0x0, _to, _amout);\n', '  }\n', '  \n', '\n', '  function getFunding (address _to, uint _amout) onlyOwner{\n', '    _to.transfer(_amout);\n', '  }\n', '\n', '\n', '  function getAllFunding() onlyOwner{\n', '    owner.transfer(this.balance);\n', '  }\n', '\n', '\n', '  /* stop ICO*/\n', '  function halt() onlyOwner{\n', '    halted = true;\n', '  }\n', '  function unhalt() onlyOwner{\n', '    halted = false;\n', '  }\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.18;\n', ' \n', '//Never Mind :P\n', '/* @dev The Ownable contract has an owner address, and provides basic authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract NVTReceiver {\n', '    function NVTFallback(address _from, uint _value, uint _code);\n', '}\n', '\n', 'contract BasicToken {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    \n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    if(!isContract(_to)){\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;}\n', '    else{\n', '        balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    NVTReceiver receiver = NVTReceiver(_to);\n', '    receiver.NVTFallback(msg.sender, _value, 0);\n', '    Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '  }\n', '  function transfer(address _to, uint _value, uint _code) public returns (bool) {\n', '      require(isContract(_to));\n', '      require(_value <= balances[msg.sender]);\n', '      balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '      balances[_to] = balanceOf(_to).add(_value);\n', '      NVTReceiver receiver = NVTReceiver(_to);\n', '      receiver.NVTFallback(msg.sender, _value, _code);\n', '      Transfer(msg.sender, _to, _value);\n', '    \n', '      return true;\n', '    \n', '    }\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '\n', 'function isContract(address _addr) private returns (bool is_contract) {\n', '    uint length;\n', '    assembly {\n', '        //retrieve the size of the code on target address, this needs assembly\n', '        length := extcodesize(_addr)\n', '    }\n', '    return (length>0);\n', '  }\n', '\n', '\n', '  //function that is called when transaction target is a contract\n', '  //Only used for recycling NVTs\n', '  function transferToContract(address _to, uint _value, uint _code) public returns (bool success) {\n', '    require(isContract(_to));\n', '    require(_value <= balances[msg.sender]);\n', '  \n', '      balances[msg.sender] = balanceOf(msg.sender).sub(_value);\n', '    balances[_to] = balanceOf(_to).add(_value);\n', '    NVTReceiver receiver = NVTReceiver(_to);\n', '    receiver.NVTFallback(msg.sender, _value, _code);\n', '    Transfer(msg.sender, _to, _value);\n', '    \n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract NVT is BasicToken, Ownable {\n', '\n', '  string public constant name = "NiceVotingToken";\n', '  string public constant symbol = "NVT";\n', '  uint8 public constant decimals = 2;\n', '\n', '  uint256 public constant TOTAL_SUPPLY = 100 * 10 ** 10; //10 billion tokens\n', '  uint256 public RELEASE_TIME ;\n', '  uint256 public TOKEN_FOR_SALE = 40 * 10 ** 10;\n', '  uint256 public TOKEN_FOR_TEAM = 10 * 10 ** 10;\n', '  uint256 public TOKEN_FOR_COMUNITY = 20 * 10 ** 10;\n', '  uint256 public TOKEN_FOR_INVESTER = 25 * 10 ** 10;\n', '\n', '\n', '  uint256 public price = 10 ** 12; //1:10000\n', '  bool public halted = false;\n', '\n', '  /**\n', '  * @dev Constructor that gives msg.sender all of existing tokens.\n', '  */\n', '  function NVT() public {\n', '    totalSupply_ = 5 * 10 ** 10; // 5 percent for early market promotion\n', '    balances[msg.sender] = 5 * 10 ** 10;\n', '    Transfer(0x0, msg.sender, 5 * 10 ** 10);\n', '    RELEASE_TIME = now;\n', '  }\n', '\n', '  //Rember 18 zeros for decimals of eth(wei), and 2 zeros for NVT. So add 16 zeros with * 10 ** 16\n', '  //price can only go higher\n', '  function setPrice(uint _newprice) onlyOwner{\n', '    require(_newprice > price);\n', '    price=_newprice; \n', '  }\n', '\n', '  //Incoming payment for purchase\n', '  function () public payable{\n', '    require(halted == false);\n', '    uint amout = msg.value.div(price);\n', '    require(amout <= TOKEN_FOR_SALE);\n', '    TOKEN_FOR_SALE = TOKEN_FOR_SALE.sub(amout);\n', '    balances[msg.sender] = balanceOf(msg.sender).add(amout);\n', '    totalSupply_=totalSupply_.add(amout);\n', '    Transfer(0x0, msg.sender, amout);\n', '  }\n', '\n', '  function getTokenForTeam (address _to, uint _amout) onlyOwner returns(bool){\n', '    TOKEN_FOR_TEAM = TOKEN_FOR_TEAM.sub(_amout);\n', '    totalSupply_=totalSupply_.add(_amout);\n', '    balances[_to] = balanceOf(_to).add(_amout);\n', '    Transfer(0x0, _to, _amout);\n', '    return true;\n', '  }\n', '\n', '\n', '  function getTokenForInvester (address _to, uint _amout) onlyOwner returns(bool){\n', '    TOKEN_FOR_INVESTER = TOKEN_FOR_INVESTER.sub(_amout);\n', '    totalSupply_=totalSupply_.add(_amout);\n', '    balances[_to] = balanceOf(_to).add(_amout);\n', '    Transfer(0x0, _to, _amout);\n', '    return true;\n', '  }\n', '\n', '\n', '  function getTokenForCommunity (address _to, uint _amout) onlyOwner{\n', '    require(_amout <= TOKEN_FOR_COMUNITY);\n', '    TOKEN_FOR_COMUNITY = TOKEN_FOR_COMUNITY.sub(_amout);\n', '    totalSupply_=totalSupply_.add(_amout);\n', '    balances[_to] = balanceOf(_to).add(_amout);\n', '    Transfer(0x0, _to, _amout);\n', '  }\n', '  \n', '\n', '  function getFunding (address _to, uint _amout) onlyOwner{\n', '    _to.transfer(_amout);\n', '  }\n', '\n', '\n', '  function getAllFunding() onlyOwner{\n', '    owner.transfer(this.balance);\n', '  }\n', '\n', '\n', '  /* stop ICO*/\n', '  function halt() onlyOwner{\n', '    halted = true;\n', '  }\n', '  function unhalt() onlyOwner{\n', '    halted = false;\n', '  }\n', '\n', '\n', '\n', '}']