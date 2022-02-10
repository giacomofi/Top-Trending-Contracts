['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title AMTTimelockedToken\n', ' * @dev AMTTimelockedToken is a token holder contract that will allow all\n', ' * beneficiaries to extract the tokens after the given release times\n', ' */\n', 'contract AMTTimelockedToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '  using SafeMath for uint256;\n', '\n', '  uint8 public constant decimals = 18; // solium-disable-line uppercase\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20Basic token;\n', '\n', '  // totalTokenAmounts of each beneficiary\n', '  uint256 public constant MANAGE_CAP = 1 * (10 ** 8) * (10 ** uint256(decimals)); // 5% of AMT in maximum\n', '  uint256 public constant DEVELOP_CAP = 2 * (10 ** 8) * (10 ** uint256(decimals)); // 10% of AMT in maximum\n', '  uint256 public constant MARKET_CAP = 1 * (10 ** 8) * (10 ** uint256(decimals)); // 5% of AMT in maximum\n', '  uint256 public constant FINANCE_CAP = 6 * (10 ** 7) * (10 ** uint256(decimals)); // 3% of AMT in maximum\n', '\n', '  // perRoundTokenAmounts of each beneficiary\n', '  uint256 public constant MANAGE_CAP_PER_ROUND = 2 * (10 ** 7) * (10 ** uint256(decimals));\n', '  uint256 public constant DEVELOP_CAP_PER_ROUND = 4 * (10 ** 7) * (10 ** uint256(decimals));\n', '  uint256 public constant MARKET_CAP_PER_ROUND = 2 * (10 ** 7) * (10 ** uint256(decimals));\n', '  uint256 public constant FINANCE_CAP_PER_ROUND = 12 * (10 ** 6) * (10 ** uint256(decimals));\n', '\n', '  // releasedToken of each beneficiary\n', '  mapping (address => uint256) releasedTokens;\n', '\n', '  // beneficiaries of tokens after they are released\n', '  address beneficiary_manage; // address of management team\n', '  address beneficiary_develop; // address of development team\n', '  address beneficiary_market; // address of marketing team\n', '  address beneficiary_finance; // address of finance team\n', '\n', '  // timestamps when token release is enabled\n', '  uint256 first_round_release_time; // 2019/01/08\n', '  uint256 second_round_release_time; // 2019/07/08\n', '  uint256 third_round_release_time; // 2020/01/08\n', '  uint256 forth_round_release_time; // 2020/07/08\n', '  uint256 fifth_round_release_time; // 2021/01/08\n', '\n', '  /**\n', '   * @dev Constructor initialized all necessary parameters.\n', '   */\n', '  constructor(\n', '    ERC20Basic _token,\n', '    address _beneficiary_manage,\n', '    address _beneficiary_develop,\n', '    address _beneficiary_market,\n', '    address _beneficiary_finance,\n', '    uint256 _first_round_release_time,\n', '    uint256 _second_round_release_time,\n', '    uint256 _third_round_release_time,\n', '    uint256 _forth_round_release_time,\n', '    uint256 _fifth_round_release_time\n', '  ) public {\n', '    // solium-disable-next-line security/no-block-members\n', '    token = _token;\n', '\n', '    beneficiary_manage = _beneficiary_manage;\n', '    beneficiary_develop = _beneficiary_develop;\n', '    beneficiary_market = _beneficiary_market;\n', '    beneficiary_finance = _beneficiary_finance;\n', '\n', '    first_round_release_time = _first_round_release_time;\n', '    second_round_release_time = _second_round_release_time;\n', '    third_round_release_time = _third_round_release_time;\n', '    forth_round_release_time = _forth_round_release_time;\n', '    fifth_round_release_time = _fifth_round_release_time;\n', '\n', '  }\n', '\n', '  /**\n', '  * @dev get AMToken contract address.\n', '  */\n', '  function getToken() public view returns (ERC20Basic) {\n', '    return token;\n', '  }\n', '\n', '  /**\n', '  * @dev get address of management team.\n', '  */\n', '  function getBeneficiaryManage() public view returns (address) {\n', '    return beneficiary_manage;\n', '  }\n', '\n', '  /**\n', '  * @dev get address of development team.\n', '  */\n', '  function getBeneficiaryDevelop() public view returns (address) {\n', '    return beneficiary_develop;\n', '  }\n', '\n', '  /**\n', '  * @dev get address of marketing team.\n', '  */\n', '  function getBeneficiaryMarket() public view returns (address) {\n', '    return beneficiary_market;\n', '  }\n', '\n', '  /**\n', '  * @dev get address of finance team.\n', '  */\n', '  function getBeneficiaryFinance() public view returns (address) {\n', '    return beneficiary_finance;\n', '  }\n', '\n', '  /**\n', '  * @dev get token release time of first round.\n', '  */\n', '  function getFirstRoundReleaseTime() public view returns (uint256) {\n', '    return first_round_release_time;\n', '  }\n', '\n', '  /**\n', '  * @dev get token release time of second round.\n', '  */\n', '  function getSecondRoundReleaseTime() public view returns (uint256) {\n', '    return second_round_release_time;\n', '  }\n', '\n', '  /**\n', '  * @dev get token release time of third round.\n', '  */\n', '  function getThirdRoundReleaseTime() public view returns (uint256) {\n', '    return third_round_release_time;\n', '  }\n', '\n', '  /**\n', '  * @dev get token release time of forth round.\n', '  */\n', '  function getForthRoundReleaseTime() public view returns (uint256) {\n', '    return forth_round_release_time;\n', '  }\n', '\n', '  /**\n', '  * @dev get token release time of fifth round.\n', '  */\n', '  function getFifthRoundReleaseTime() public view returns (uint256) {\n', '    return fifth_round_release_time;\n', '  }\n', '  \n', '  /**\n', '  * @dev Gets the releasedToken of the specified address.\n', '  * @param _owner The address to query the the releasedToken of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function releasedTokenOf(address _owner) public view returns (uint256) {\n', '    return releasedTokens[_owner];\n', '  }\n', '\n', '  /**\n', '  * @dev Caculate AMT to be released of each round.\n', '  * @param _round sequence of round.\n', '  */\n', '  function validateReleasedToken(uint256 _round) internal onlyOwner {\n', '\n', '    uint256 releasedTokenOfManage = releasedTokens[beneficiary_manage];\n', '    uint256 releasedTokenOfDevelop = releasedTokens[beneficiary_develop];\n', '    uint256 releasedTokenOfMarket = releasedTokens[beneficiary_market];\n', '    uint256 releasedTokenOfFinance = releasedTokens[beneficiary_finance];\n', '\n', '    require(releasedTokenOfManage < MANAGE_CAP_PER_ROUND.mul(_round));\n', '    require(releasedTokenOfManage.add(MANAGE_CAP_PER_ROUND) <= MANAGE_CAP_PER_ROUND.mul(_round));\n', '\n', '    require(releasedTokenOfDevelop < DEVELOP_CAP_PER_ROUND.mul(_round));\n', '    require(releasedTokenOfDevelop.add(DEVELOP_CAP_PER_ROUND) <= DEVELOP_CAP_PER_ROUND.mul(_round));\n', '\n', '    require(releasedTokenOfMarket < MARKET_CAP_PER_ROUND.mul(_round));\n', '    require(releasedTokenOfMarket.add(MARKET_CAP_PER_ROUND) <= MARKET_CAP_PER_ROUND.mul(_round));\n', '\n', '    require(releasedTokenOfFinance < FINANCE_CAP_PER_ROUND.mul(_round));\n', '    require(releasedTokenOfFinance.add(FINANCE_CAP_PER_ROUND) <= FINANCE_CAP_PER_ROUND.mul(_round));\n', '\n', '    uint256 totalRoundCap = MANAGE_CAP_PER_ROUND.add(DEVELOP_CAP_PER_ROUND).add(MARKET_CAP_PER_ROUND).add(FINANCE_CAP_PER_ROUND);\n', '    require(token.balanceOf(this) >= totalRoundCap);\n', '\n', '    token.safeTransfer(beneficiary_manage, MANAGE_CAP_PER_ROUND);\n', '    releasedTokens[beneficiary_manage] = releasedTokens[beneficiary_manage].add(MANAGE_CAP_PER_ROUND);\n', '\n', '    token.safeTransfer(beneficiary_develop, DEVELOP_CAP_PER_ROUND);\n', '    releasedTokens[beneficiary_develop] = releasedTokens[beneficiary_develop].add(DEVELOP_CAP_PER_ROUND);\n', '\n', '    token.safeTransfer(beneficiary_market, MARKET_CAP_PER_ROUND);\n', '    releasedTokens[beneficiary_market] = releasedTokens[beneficiary_market].add(MARKET_CAP_PER_ROUND);\n', '\n', '    token.safeTransfer(beneficiary_finance, FINANCE_CAP_PER_ROUND);\n', '    releasedTokens[beneficiary_finance] = releasedTokens[beneficiary_finance].add(FINANCE_CAP_PER_ROUND);\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers tokens held by timelock to beneficiaries.\n', '   */\n', '  function releaseToken() public onlyOwner {\n', '\n', '    if (block.timestamp >= fifth_round_release_time) {\n', '\n', '      validateReleasedToken(5);\n', '      return;\n', '\n', '    }else if (block.timestamp >= forth_round_release_time) {\n', '\n', '      validateReleasedToken(4);\n', '      return;\n', '\n', '    }else if (block.timestamp >= third_round_release_time) {\n', '\n', '      validateReleasedToken(3);\n', '      return;\n', '\n', '    }else if (block.timestamp >= second_round_release_time) {\n', '\n', '      validateReleasedToken(2);\n', '      return;\n', '\n', '    }else if (block.timestamp >= first_round_release_time) {\n', '\n', '      validateReleasedToken(1);\n', '      return;\n', '\n', '    }\n', '\n', '  }\n', '}']