['pragma solidity ^0.4.11;\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value);\n', '  function approve(address spender, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract FinalizableToken {\n', '    bool public isFinalized = false;\n', '}\n', '\n', 'contract BasicToken is FinalizableToken, ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) {\n', '    if (!isFinalized) revert();\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) {\n', '    if (!isFinalized) revert();\n', '\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract SimpleToken is StandardToken {\n', '\n', '  string public name = "SimpleToken";\n', '  string public symbol = "SIM";\n', '  uint256 public decimals = 18;\n', '  uint256 public INITIAL_SUPPLY = 10000;\n', '\n', '  /**\n', '   * @dev Contructor that gives msg.sender all of existing tokens. \n', '   */\n', '  function SimpleToken() {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'library Math {\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract RexToken is StandardToken, Ownable {\n', '\n', '  function version() constant returns (bytes32) {\n', '      return "0.1.2-debug";\n', '  }\n', '\n', '  string public constant name = "REX - Real Estate tokens";\n', '  string public constant symbol = "REX";\n', '  uint256 public constant decimals = 18;\n', '\n', '  uint256 constant BASE_RATE = 700;\n', '  uint256 constant ETH_RATE = 225; // TODO: update before deploying\n', '  uint256 constant USD_RAISED_CAP = 27*10**6; // 30*10**6 = $30 Million USD\n', '  uint256 constant ETHER_RAISED_CAP = USD_RAISED_CAP / ETH_RATE;\n', '  uint256 public constant WEI_RAISED_CAP = ETHER_RAISED_CAP * 1 ether;\n', '  uint256 constant DURATION = 4 weeks;\n', '\n', '  uint256 TOTAL_SHARE = 1000;\n', '  uint256 CROWDSALE_SHARE = 500;\n', '\n', '  address ANGELS_ADDRESS = 0x00998eba0E5B83018a0CFCdeCc5304f9f167d27a;\n', '  uint256 ANGELS_SHARE = 50;\n', '\n', '  address CORE_1_ADDRESS = 0x4aD48BE9bf6E2d35277Bd33C100D283C29C7951F;\n', '  uint256 CORE_1_SHARE = 75;\n', '  address CORE_2_ADDRESS = 0x2a62609c6A6bDBE25Da4fb05980e85db9A479C5e;\n', '  uint256 CORE_2_SHARE = 75;\n', '\n', '  address PARTNERSHIP_ADDRESS = 0x53B8fFBe35AE548f22d5a3b31D6E5e0C04f0d2DF;\n', '  uint256 PARTNERSHIP_SHARE = 70;\n', '\n', '  address REWARDS_ADDRESS = 0x43F1aa047D3241B7DD250EB37b25fc509085fDf9;\n', '  uint256 REWARDS_SHARE = 200;\n', '\n', '  address AFFILIATE_ADDRESS = 0x64ea62A8080eD1C2b8d996ACC7a82108975e5361;\n', '  uint256 AFFILIATE_SHARE = 30;\n', '\n', '  // state variables\n', '  address vault;\n', '  address previousToken;\n', '  uint256 public startTime;\n', '  uint256 public weiRaised;\n', '\n', '  event TokenCreated(address indexed investor, uint256 amount);\n', '\n', '  function RexToken(uint256 _start, address _vault, address _previousToken) {\n', '    startTime = _start;\n', '    vault = _vault;\n', '    previousToken = _previousToken;\n', '    isFinalized = false;\n', '  }\n', '\n', '  function () payable {\n', '    createTokens(msg.sender);\n', '  }\n', '\n', '  function createTokens(address recipient) payable {\n', '    if (tokenSaleOnHold) revert();\n', '    if (msg.value == 0) revert();\n', '    if (now < startTime) revert();\n', '    if (now > startTime + DURATION) revert();\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    if (weiRaised >= WEI_RAISED_CAP) revert();\n', '\n', '    //if funder sent more than the remaining amount then send them a refund of the difference\n', '    if ((weiRaised + weiAmount) > WEI_RAISED_CAP) {\n', '      weiAmount = WEI_RAISED_CAP - weiRaised;\n', '      if (!msg.sender.send(msg.value - weiAmount)) \n', '        revert();\n', '    }\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(getRate());\n', '\n', '    // update totals\n', '    totalSupply = totalSupply.add(tokens);\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    balances[recipient] = balances[recipient].add(tokens);\n', '    TokenCreated(recipient, tokens);\n', '\n', '    // send ether to the vault\n', '    if (!vault.send(weiAmount)) revert();\n', '  }\n', '\n', '  // return dynamic pricing\n', '  function getRate() constant returns (uint256) {\n', '    uint256 bonus = 0;\n', '    if (now < (startTime + 1 weeks)) {\n', '      bonus = 300;\n', '    } else if (now < (startTime + 2 weeks)) {\n', '      bonus = 200;\n', '    } else if (now < (startTime + 3 weeks)) {\n', '      bonus = 100;\n', '    }\n', '    return BASE_RATE.add(bonus);\n', '  }\n', '\n', '  function tokenAmount(uint256 share, uint256 finalSupply) constant returns (uint) {\n', '    if (share > TOTAL_SHARE) revert();\n', '\n', '    return share.mul(finalSupply).div(TOTAL_SHARE);\n', '  }\n', '\n', '  // grant regular tokens by share\n', '  function grantTokensByShare(address to, uint256 share, uint256 finalSupply) internal {\n', '    uint256 tokens = tokenAmount(share, finalSupply);\n', '    balances[to] = balances[to].add(tokens);\n', '    TokenCreated(to, tokens);\n', '    totalSupply = totalSupply.add(tokens);\n', '  }\n', '\n', '  function getFinalSupply() constant returns (uint256) {\n', '    return TOTAL_SHARE.mul(totalSupply).div(CROWDSALE_SHARE);\n', '  }\n', '\n', '\n', '  // do final token distribution\n', '  function finalize() onlyOwner() {\n', '    if (isFinalized) revert();\n', '\n', '    //if we are under the cap and not hit the duration then throw\n', '    if (weiRaised < WEI_RAISED_CAP && now <= startTime + DURATION) revert();\n', '\n', '    uint256 finalSupply = getFinalSupply();\n', '\n', '    grantTokensByShare(ANGELS_ADDRESS, ANGELS_SHARE, finalSupply);\n', '    grantTokensByShare(CORE_1_ADDRESS, CORE_1_SHARE, finalSupply);\n', '    grantTokensByShare(CORE_2_ADDRESS, CORE_2_SHARE, finalSupply);\n', '\n', '    grantTokensByShare(PARTNERSHIP_ADDRESS, PARTNERSHIP_SHARE, finalSupply);\n', '    grantTokensByShare(REWARDS_ADDRESS, REWARDS_SHARE, finalSupply);\n', '    grantTokensByShare(AFFILIATE_ADDRESS, AFFILIATE_SHARE, finalSupply);\n', '    \n', '    isFinalized = true;\n', '  }\n', '\n', '  bool public tokenSaleOnHold;\n', '\n', '  function toggleTokenSaleOnHold() onlyOwner() {\n', '    if (tokenSaleOnHold)\n', '      tokenSaleOnHold = false;\n', '    else\n', '      tokenSaleOnHold = true;\n', '  }\n', '\n', '  bool public migrateDisabled;\n', '\n', '  struct structMigrate {\n', '    uint dateTimeCreated;\n', '    uint amount;\n', '  }\n', '\n', '  mapping(address => structMigrate) pendingMigrations;\n', '\n', '  function toggleMigrationStatus() onlyOwner() {\n', '    if (migrateDisabled)\n', '      migrateDisabled = false;\n', '    else\n', '      migrateDisabled = true;\n', '  }\n', '\n', '  function migrate(uint256 amount) {\n', '\n', '    //dont allow migrations until crowdfund is done\n', '    if (!isFinalized) \n', '      revert();\n', '\n', '    //dont proceed if migrate is disabled\n', '    if (migrateDisabled) \n', '      revert();\n', '\n', '    //dont proceed if there is pending value\n', '    if (pendingMigrations[msg.sender].amount > 0)\n', '      revert();\n', '\n', '\n', '    //this will throw if they dont have the balance/allowance\n', '    StandardToken(previousToken).transferFrom(msg.sender, this, amount);\n', '\n', '    //store time and amount in pending mapping\n', '    pendingMigrations[msg.sender].dateTimeCreated = now;\n', '    pendingMigrations[msg.sender].amount = amount;\n', '  }\n', '\n', '  function claimMigrate() {\n', '\n', '    //dont allow if migrations are disabled\n', '    if (migrateDisabled) \n', '      revert();\n', '\n', '    //dont proceed if no value\n', '    if (pendingMigrations[msg.sender].amount == 0)\n', '      revert();\n', '\n', '    //can only claim after a week has passed\n', '    if (now < pendingMigrations[msg.sender].dateTimeCreated + 1 weeks)\n', '      revert();\n', '\n', '    //credit the balances\n', '    balances[msg.sender] += pendingMigrations[msg.sender].amount;\n', '    totalSupply += pendingMigrations[msg.sender].amount;\n', '\n', '    //remove the pending migration from the mapping\n', '    delete pendingMigrations[msg.sender];\n', '  }\n', '\n', '  function transferOwnCoins(address _to, uint _value) onlyOwner() {\n', '    if (!isFinalized) revert();\n', '\n', '    balances[this] = balances[this].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(this, _to, _value);\n', '  }\n', '\n', '}']