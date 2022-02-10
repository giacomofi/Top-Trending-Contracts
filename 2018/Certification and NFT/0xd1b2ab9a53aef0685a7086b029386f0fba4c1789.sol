['pragma solidity ^0.4.25;\n', '\n', '// Author: Securypto Team | Iceman\n', '// Telegram: ice_man0\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '   constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner)public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev API interface for interacting with the DSGT contract \n', ' */\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value)external returns (bool);\n', '  function balanceOf(address _owner)external view returns (uint256 balance);\n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  Token public token;\n', '\n', '  uint256 public raisedETH; // ETH raised\n', '  uint256 public soldTokens; // Tokens Sold\n', '  uint256 public saleMinimum = 0.1 * 1 ether;\n', '  uint256 public price;\n', '\n', '  address public beneficiary;\n', '\n', '  // They&#39;ll be represented by their index numbers i.e \n', '  // if the state is Dormant, then the value should be 0 \n', '  // Dormant:0, Active:1, , Successful:2\n', '  enum State {Dormant, Active,  Successful }\n', '\n', '  State public state;\n', ' \n', '  event ActiveState();\n', '  event DormantState();\n', '  event SuccessfulState();\n', '\n', '  event BoughtTokens(\n', '      address indexed who, \n', '      uint256 tokensBought, \n', '      uint256 investedETH\n', '      );\n', '  \n', '  constructor() \n', '              public \n', '              {\n', '                token = Token(0x2Ed92cae08B7E24d7C01A11049750498ebCAe8E0);\n', '                beneficiary = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * @dev This function will be called whenever anyone sends funds to a contract,\n', '     * throws if the sale isn&#39;t Active or the sale minimum isn&#39;t met\n', '     */\n', '    function () public payable {\n', '        require(msg.value >= saleMinimum);\n', '        require(state == State.Active);\n', '        require(token.balanceOf(this) > 0);\n', '        \n', '        buyTokens();\n', '      }\n', '\n', '  /**\n', '  * @dev Function that sells available tokens\n', '  */\n', '  function buyTokens() public payable  {\n', '    \n', '    uint256 invested = msg.value;\n', '    \n', '    uint256 numberOfTokens = invested.mul(price);\n', '    \n', '    beneficiary.transfer(msg.value);\n', '    \n', '    token.transfer(msg.sender, numberOfTokens);\n', '    \n', '    raisedETH = raisedETH.add(msg.value);\n', '    \n', '    soldTokens = soldTokens.add(numberOfTokens);\n', '\n', '    emit BoughtTokens(msg.sender, numberOfTokens, invested);\n', '    \n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Change the price during the different rounds\n', '   */\n', '  function changeRate(uint256 _newPrice) public onlyOwner {\n', '      price = _newPrice;\n', '  }    \n', '\n', '  /**\n', '   *  @dev Change the sale minimum\n', '   */\n', '  function changeSaleMinimum(uint256 _newAmount) public onlyOwner {\n', '      saleMinimum = _newAmount;\n', '  }\n', '\n', '  /**\n', '   * @dev Ends the sale\n', '   */\n', '  function endSale() public onlyOwner {\n', '    require(state == State.Active || state == State.Dormant);\n', '    \n', '    state = State.Successful;\n', '    emit SuccessfulState();\n', '\n', '    selfdestruct(owner);\n', '\n', '  }\n', '  \n', '   /**\n', '   * @dev Makes the sale dormant, no deposits are allowed\n', '   */\n', '  function pauseSale() public onlyOwner {\n', '      require(state == State.Active);\n', '      \n', '      state = State.Dormant;\n', '      emit DormantState();\n', '  }\n', '  \n', '  /**\n', '   * @dev Makes the sale active, thus funds can be received\n', '   */\n', '  function openSale() public onlyOwner {\n', '      require(state == State.Dormant);\n', '      \n', '      state = State.Active;\n', '      emit ActiveState();\n', '  }\n', '  \n', '  /**\n', '   *  @dev Returns the number of tokens in contract\n', '   */\n', '  function tokensAvailable() public view returns(uint256) {\n', '      return token.balanceOf(this);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.25;\n', '\n', '// Author: Securypto Team | Iceman\n', '// Telegram: ice_man0\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '   constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner)public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev API interface for interacting with the DSGT contract \n', ' */\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value)external returns (bool);\n', '  function balanceOf(address _owner)external view returns (uint256 balance);\n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  Token public token;\n', '\n', '  uint256 public raisedETH; // ETH raised\n', '  uint256 public soldTokens; // Tokens Sold\n', '  uint256 public saleMinimum = 0.1 * 1 ether;\n', '  uint256 public price;\n', '\n', '  address public beneficiary;\n', '\n', "  // They'll be represented by their index numbers i.e \n", '  // if the state is Dormant, then the value should be 0 \n', '  // Dormant:0, Active:1, , Successful:2\n', '  enum State {Dormant, Active,  Successful }\n', '\n', '  State public state;\n', ' \n', '  event ActiveState();\n', '  event DormantState();\n', '  event SuccessfulState();\n', '\n', '  event BoughtTokens(\n', '      address indexed who, \n', '      uint256 tokensBought, \n', '      uint256 investedETH\n', '      );\n', '  \n', '  constructor() \n', '              public \n', '              {\n', '                token = Token(0x2Ed92cae08B7E24d7C01A11049750498ebCAe8E0);\n', '                beneficiary = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * @dev This function will be called whenever anyone sends funds to a contract,\n', "     * throws if the sale isn't Active or the sale minimum isn't met\n", '     */\n', '    function () public payable {\n', '        require(msg.value >= saleMinimum);\n', '        require(state == State.Active);\n', '        require(token.balanceOf(this) > 0);\n', '        \n', '        buyTokens();\n', '      }\n', '\n', '  /**\n', '  * @dev Function that sells available tokens\n', '  */\n', '  function buyTokens() public payable  {\n', '    \n', '    uint256 invested = msg.value;\n', '    \n', '    uint256 numberOfTokens = invested.mul(price);\n', '    \n', '    beneficiary.transfer(msg.value);\n', '    \n', '    token.transfer(msg.sender, numberOfTokens);\n', '    \n', '    raisedETH = raisedETH.add(msg.value);\n', '    \n', '    soldTokens = soldTokens.add(numberOfTokens);\n', '\n', '    emit BoughtTokens(msg.sender, numberOfTokens, invested);\n', '    \n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Change the price during the different rounds\n', '   */\n', '  function changeRate(uint256 _newPrice) public onlyOwner {\n', '      price = _newPrice;\n', '  }    \n', '\n', '  /**\n', '   *  @dev Change the sale minimum\n', '   */\n', '  function changeSaleMinimum(uint256 _newAmount) public onlyOwner {\n', '      saleMinimum = _newAmount;\n', '  }\n', '\n', '  /**\n', '   * @dev Ends the sale\n', '   */\n', '  function endSale() public onlyOwner {\n', '    require(state == State.Active || state == State.Dormant);\n', '    \n', '    state = State.Successful;\n', '    emit SuccessfulState();\n', '\n', '    selfdestruct(owner);\n', '\n', '  }\n', '  \n', '   /**\n', '   * @dev Makes the sale dormant, no deposits are allowed\n', '   */\n', '  function pauseSale() public onlyOwner {\n', '      require(state == State.Active);\n', '      \n', '      state = State.Dormant;\n', '      emit DormantState();\n', '  }\n', '  \n', '  /**\n', '   * @dev Makes the sale active, thus funds can be received\n', '   */\n', '  function openSale() public onlyOwner {\n', '      require(state == State.Dormant);\n', '      \n', '      state = State.Active;\n', '      emit ActiveState();\n', '  }\n', '  \n', '  /**\n', '   *  @dev Returns the number of tokens in contract\n', '   */\n', '  function tokensAvailable() public view returns(uint256) {\n', '      return token.balanceOf(this);\n', '  }\n', '\n', '}']
