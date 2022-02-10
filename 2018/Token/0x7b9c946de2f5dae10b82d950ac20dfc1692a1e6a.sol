['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * Math operations with safety checks that throw on error\n', ' */\n', ' \n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', ' /**\n', ' * Official T_Token as issued by The T****\n', ' * Based off of Standard ERC20 token\n', ' *\n', ' * Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Partially based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', '\n', 'contract T_Token_11 {\n', '    \n', '  using SafeMath for uint256;\n', '  \n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  \n', '  uint256 public totalSupply;\n', '  \n', '  uint256 private tprFund;\n', '  uint256 private founderCoins;\n', '  uint256 private icoReleaseTokens;\n', '  \n', '  uint256 private tprFundReleaseTime;\n', '  uint256 private founderCoinsReleaseTime;\n', '  \n', '  bool private tprFundUnlocked;\n', '  bool private founderCoinsUnlocked;\n', '  \n', '  address private tprFundDeposit;\n', '  address private founderCoinsDeposit;\n', '\n', '  mapping(address => uint256) internal balances;\n', '  \n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Burn(address indexed burner, uint256 value);\n', '  \n', '  function T_Token_11 () public {\n', '      \n', '      name = "T_Token_11";\n', '      symbol = "T_TPR_T11";\n', '      decimals = 18;\n', '      \n', '      tprFund = 260000000 * (10**decimals);\n', '      founderCoins = 30000000 * (10**decimals);\n', '      icoReleaseTokens = 210000000 * (10**decimals);\n', '      \n', '      totalSupply = tprFund + founderCoins + icoReleaseTokens;\n', '      \n', '      balances[msg.sender] = icoReleaseTokens;\n', '      \n', '      tprFundDeposit = 0xF1F465C345b6DBc4Bcdf98aB286762ba282BA69a; //TPR Fund\n', '      balances[tprFundDeposit] = 0;\n', '      tprFundReleaseTime = 30 * 1 minutes; // TPR Fund to be available after 6 months\n', '      tprFundUnlocked = false;\n', '      \n', '      founderCoinsDeposit = 0x64108822C128D11b6956754056ec4bCBe0B0CDaf; // Founders Coins\n', '      balances[founderCoinsDeposit] = 0;\n', '      founderCoinsReleaseTime = 60 * 1 minutes; // Founders coins to be unlocked after 1 year\n', '      founderCoinsUnlocked = false;\n', '  } \n', '  \n', '  \n', '  /**\n', '   * @notice Transfers tokens held by timelock to beneficiary.\n', '   */\n', '   \n', '  function releaseTprFund() public {\n', '    require(now >= tprFundReleaseTime);\n', '    require(!tprFundUnlocked);\n', '\n', '    balances[tprFundDeposit] = tprFund;\n', '    \n', '    Transfer(0, tprFundDeposit, tprFund);\n', '\n', '    tprFundUnlocked = true;\n', '    \n', '  }\n', '  \n', '  function releaseFounderCoins() public {\n', '    require(now >= founderCoinsReleaseTime);\n', '    require(!founderCoinsUnlocked);\n', '\n', '    balances[founderCoinsDeposit] = founderCoins;\n', '    \n', '    Transfer(0, founderCoinsDeposit, founderCoins);\n', '    \n', '    founderCoinsUnlocked = true;\n', '    \n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    require(_value > 0);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_value > 0);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(_value>0);\n', '    require(balances[msg.sender]>_value);\n', '    allowed[msg.sender][_spender] = 0;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '\n', '    /**\n', '     * Burns a specific amount of tokens.\n', '     * @param _value The amount of tokens to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '\n', '}']