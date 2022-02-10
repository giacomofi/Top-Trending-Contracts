['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert() on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    asserts(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    asserts(b <= a);\n', '    return a - b;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    asserts(b > 0);\n', '    uint c = a / b;\n', '    asserts(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    asserts(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    asserts(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '  function asserts(bool assertion) internal {\n', '    if (!assertion) {\n', '      revert();\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) revert();\n', '    _;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  bool public stopped;\n', '  modifier stopInEmergency {\n', '    if (stopped) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    if (!stopped) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function emergencyStop() external onlyOwner {\n', '    stopped = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function release() external onlyOwner onlyInEmergency {\n', '    stopped = false;\n', '  }\n', '}\n', '\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract Token {\n', '  /// @return total amount of tokens\n', '  function totalSupply() constant returns (uint256 supply) {}\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of token to be transferred\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of wei to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens allowed to spent\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * ERC 20 token\n', ' *\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is Token {\n', '  /**\n', '   * Reviewed:\n', '   * - Interger overflow = OK, checked\n', '   */\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', "    //Default assumes totalSupply can't be over max (2^256 - 1).\n", "    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '    //Replace the if with this one instead.\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  uint256 public totalSupply;\n', '}\n', '\n', '\n', 'contract DigipulseFirstRoundToken is StandardToken {\n', '  using SafeMath for uint;\n', '}\n', '\n', 'contract DigipulseToken is StandardToken, Pausable {\n', '  using SafeMath for uint;\n', '\n', '  // Digipulse Token setup\n', '  string public           name                    = "DigiPulse Token";\n', '  string public           symbol                  = "DGPT";\n', '  uint8 public            decimals                = 18;\n', "  string public           version                 = 'v0.0.3';\n", '  address public          owner                   = msg.sender;\n', '  uint freezeTransferForOwnerTime;\n', '\n', '  // Token information\n', '  address public DGPTokenOldContract = 0x9AcA6aBFe63A5ae0Dc6258cefB65207eC990Aa4D;\n', '  DigipulseFirstRoundToken public coin;\n', '\n', '\n', '  // Token details\n', '\n', '  // ICO details\n', '  bool public             finalizedCrowdfunding   = false;\n', '  uint public constant    MIN_CAP                 = 500   * 1e18;\n', '  uint public constant    MAX_CAP                 = 41850 * 1e18; // + 1600 OBR + 1200 PRE\n', '  uint public             TierAmount              = 8300  * 1e18;\n', '  uint public constant    TOKENS_PER_ETH          = 250;\n', '  uint public constant    MIN_INVEST_ETHER        = 500 finney;\n', '  uint public             startTime;\n', '  uint public             endTime;\n', '  uint public             etherReceived;\n', '  uint public             coinSentToEther;\n', '  bool public             isFinalized;\n', '\n', '  // Original Backers round\n', '  bool public             isOBR;\n', '  uint public             raisedOBR;\n', '  uint public             MAX_OBR_CAP             = 1600  * 1e18;\n', '  uint public             OBR_Duration;\n', '\n', '  // Enums\n', '  enum TierState{Completed, Tier01, Tier02, Tier03, Tier04, Tier05, Overspend, Failure, OBR}\n', '\n', '  // Modifiers\n', '  modifier minCapNotReached() {\n', '    require (now < endTime && etherReceived <= MIN_CAP);\n', '    _;\n', '  }\n', '\n', '  // Mappings\n', '  mapping(address => Backer) public backers;\n', '  struct Backer {\n', '    uint weiReceived;\n', '    uint coinSent;\n', '  }\n', '\n', '  // Events\n', '  event LogReceivedETH(address addr, uint value);\n', '  event LogCoinsEmited(address indexed from, uint amount);\n', '\n', '\n', '  // Bounties, Presale, Company tokens\n', '  address public          presaleWallet           = 0x83D0Aa2292efD8475DF241fBA42fe137dA008d79;\n', '  address public          companyWallet           = 0x5C967dE68FC54365872203D49B51cDc79a61Ca85;\n', '  address public          bountyWallet            = 0x49fe3E535906d10e55E2e4AD47ff6cB092Abc692;\n', '\n', '  // Allocated 10% for the team members\n', '  address public          teamWallet_1            = 0x91D9B09a4157e02783D5D19f7DfC66a759bDc1E4;\n', '  address public          teamWallet_2            = 0x56298A4e0f60Ab4A323EDB0b285A9421F8e6E276;\n', '  address public          teamWallet_3            = 0x09e9e24b3e6bA1E714FB86B04602a7Aa62D587FD;\n', '  address public          teamWallet_4            = 0x2F4283D0362A3AaEe359aC55F2aC7a4615f97c46;\n', '\n', '\n', '\n', '  mapping(address => uint256) public payments;\n', '  uint256 public totalPayments;\n', '\n', '\n', '  function asyncSend(address dest, uint256 amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '    totalPayments = totalPayments.add(amount);\n', '  }\n', '\n', '\n', '  function withdrawPayments() onlyOwner {\n', '    // Can only be called if the ICO is successfull\n', '    require (isFinalized);\n', '    require (etherReceived != 0);\n', '\n', '    owner.transfer(this.balance);\n', '  }\n', '\n', '\n', '  // Init contract\n', '  function DigipulseToken() {\n', '    coin = DigipulseFirstRoundToken(DGPTokenOldContract);\n', '    isOBR = true;\n', '    isFinalized = false;\n', '    start();\n', '\n', '    // Allocate tokens\n', '    balances[presaleWallet]         = 600000 * 1e18;                // 600.000 for presale (closed already)\n', '    Transfer(0x0, presaleWallet, 600000 * 1e18);\n', '\n', '    balances[teamWallet_1]          = 20483871 * 1e16;              // 1% for team member 1\n', '    Transfer(0x0, teamWallet_1, 20483871 * 1e16);\n', '\n', '    balances[teamWallet_2]          = 901290324 * 1e15;             // 4.4% for team member 2\n', '    Transfer(0x0, teamWallet_2, 901290324 * 1e15);\n', '\n', '    balances[teamWallet_3]          = 901290324 * 1e15;             // 4.4% for team member 3\n', '    Transfer(0x0, teamWallet_3, 901290324 * 1e15);\n', '\n', '    balances[teamWallet_4]          = 40967724 * 1e15;              // 0.2% for team member 4\n', '    Transfer(0x0, teamWallet_4, 40967724 * 1e15);\n', '\n', '    balances[companyWallet]          = 512096775 * 1e16;            // Company shares\n', '    Transfer(0x0, companyWallet, 512096775 * 1e16);\n', '\n', '    balances[bountyWallet]          = 61451613 * 1e16;              // Bounty shares\n', '    Transfer(0x0, bountyWallet, 61451613 * 1e16);\n', '\n', '    balances[this]                  = 12100000 * 1e18;              // Tokens to be issued during the crowdsale\n', '    Transfer(0x0, this, 12100000 * 1e18);\n', '\n', '    totalSupply = 20483871 * 1e18;\n', '  }\n', '\n', '\n', '  function start() onlyOwner {\n', '    if (startTime != 0) revert();\n', '    startTime    =  1506610800 ;  //28/09/2017 03:00 PM UTC\n', '    endTime      =  1509494400 ;  //01/11/2017 00:00 PM UTC\n', '    OBR_Duration =  startTime + 72 hours;\n', '  }\n', '\n', '\n', '  function toWei(uint _amount) constant returns (uint256 result){\n', '    // Set to finney for ease of testing on ropsten: 1e15 (or smaller) || Ether for main net 1e18\n', '    result = _amount.mul(1e18);\n', '    return result;\n', '  }\n', '\n', '\n', '  function isOriginalRoundContributor() constant returns (bool _state){\n', '    uint balance = coin.balanceOf(msg.sender);\n', '    if (balance > 0) return true;\n', '  }\n', '\n', '\n', '  function() payable {\n', '    if (isOBR) {\n', '      buyDigipulseOriginalBackersRound(msg.sender);\n', '    } else {\n', '      buyDigipulseTokens(msg.sender);\n', '    }\n', '  }\n', '\n', '\n', '  function buyDigipulseOriginalBackersRound(address beneficiary) internal  {\n', '    // User must have old tokens\n', '    require (isOBR);\n', '    require(msg.value > 0);\n', '    require(msg.value > MIN_INVEST_ETHER);\n', '    require(isOriginalRoundContributor());\n', '\n', '    uint ethRaised          = raisedOBR;\n', '    uint userContribution   = msg.value;\n', '    uint shouldBecome       = ethRaised.add(userContribution);\n', '    uint excess             = 0;\n', '    Backer storage backer   = backers[beneficiary];\n', '\n', '    // Define excess and amount to include\n', '    if (shouldBecome > MAX_OBR_CAP) {\n', '      userContribution = MAX_OBR_CAP - ethRaised;\n', '      excess = msg.value - userContribution;\n', '    }\n', '\n', '    uint tierBonus   = getBonusPercentage( userContribution );\n', '    balances[beneficiary] += tierBonus;\n', '    balances[this]      -= tierBonus;\n', '    raisedOBR = raisedOBR.add(userContribution);\n', '    backer.coinSent = backer.coinSent.add(tierBonus);\n', '    backer.weiReceived = backer.weiReceived.add(userContribution);\n', '\n', '    if (raisedOBR >= MAX_OBR_CAP) {\n', '      isOBR = false;\n', '    }\n', '\n', '    Transfer(this, beneficiary, tierBonus);\n', '    LogCoinsEmited(beneficiary, tierBonus);\n', '    LogReceivedETH(beneficiary, userContribution);\n', '\n', '    // Send excess back\n', '    if (excess > 0) {\n', '      assert(msg.sender.send(excess));\n', '    }\n', '  }\n', '\n', '\n', '  function buyDigipulseTokens(address beneficiary) internal {\n', '    require (!finalizedCrowdfunding);\n', '    require (now > OBR_Duration);\n', '    require (msg.value > MIN_INVEST_ETHER);\n', '\n', '    uint CurrentTierMax = getCurrentTier().mul(TierAmount);\n', '\n', '    // Account for last tier with extra 350 ETH\n', '    if (getCurrentTier() == 5) {\n', '      CurrentTierMax = CurrentTierMax.add(350 * 1e18);\n', '    }\n', '    uint userContribution = msg.value;\n', '    uint shouldBecome = etherReceived.add(userContribution);\n', '    uint tierBonus = 0;\n', '    uint excess = 0;\n', '    uint excess_bonus = 0;\n', '\n', '    Backer storage backer = backers[beneficiary];\n', '\n', '    // Define excess over tier and amount to include\n', '    if (shouldBecome > CurrentTierMax) {\n', '      userContribution = CurrentTierMax - etherReceived;\n', '      excess = msg.value - userContribution;\n', '    }\n', '\n', '    tierBonus = getBonusPercentage( userContribution );\n', '    balances[beneficiary] += tierBonus;\n', '    balances[this] -= tierBonus;\n', '    etherReceived = etherReceived.add(userContribution);\n', '    backer.coinSent = backer.coinSent.add(tierBonus);\n', '    backer.weiReceived = backer.weiReceived.add(userContribution);\n', '    Transfer(this, beneficiary, tierBonus);\n', '\n', '    // Tap into next tier with appropriate bonuses\n', '    if (excess > 0 && etherReceived < MAX_CAP) {\n', '      excess_bonus = getBonusPercentage( excess );\n', '      balances[beneficiary] += excess_bonus;\n', '      balances[this] -= excess_bonus;\n', '      etherReceived = etherReceived.add(excess);\n', '      backer.coinSent = backer.coinSent.add(excess_bonus);\n', '      backer.weiReceived = backer.weiReceived.add(excess);\n', '      Transfer(this, beneficiary, excess_bonus);\n', '    }\n', '\n', '    LogCoinsEmited(beneficiary, tierBonus.add(excess_bonus));\n', '    LogReceivedETH(beneficiary, userContribution.add(excess));\n', '\n', '    if(etherReceived >= MAX_CAP) {\n', '      finalizedCrowdfunding = true;\n', '    }\n', '\n', '    // Send excess back\n', '    if (excess > 0 && etherReceived == MAX_CAP) {\n', '      assert(msg.sender.send(excess));\n', '    }\n', '  }\n', '\n', '\n', '  function getCurrentTier() returns (uint Tier) {\n', '    uint ethRaised = etherReceived;\n', '\n', '    if (isOBR) return uint(TierState.OBR);\n', '\n', '    if (ethRaised >= 0 && ethRaised < toWei(8300)) return uint(TierState.Tier01);\n', '    else if (ethRaised >= toWei(8300) && ethRaised < toWei(16600)) return uint(TierState.Tier02);\n', '    else if (ethRaised >= toWei(16600) && ethRaised < toWei(24900)) return uint(TierState.Tier03);\n', '    else if (ethRaised >= toWei(24900) && ethRaised < toWei(33200)) return uint(TierState.Tier04);\n', '    else if (ethRaised >= toWei(33200) && ethRaised <= toWei(MAX_CAP)) return uint(TierState.Tier05); // last tier has 8650\n', '    else if (ethRaised > toWei(MAX_CAP)) {\n', '      finalizedCrowdfunding = true;\n', '      return uint(TierState.Overspend);\n', '    }\n', '    else return uint(TierState.Failure);\n', '  }\n', '\n', '\n', '  function getBonusPercentage(uint contribution) returns (uint _amount) {\n', '    uint tier = getCurrentTier();\n', '\n', '    uint bonus =\n', '        tier == 1 ? 20 :\n', '        tier == 2 ? 15 :\n', '        tier == 3 ? 10 :\n', '        tier == 4 ? 5 :\n', '        tier == 5 ? 0 :\n', '        tier == 8 ? 50 :\n', '                    0;\n', '\n', '    return contribution.mul(TOKENS_PER_ETH).mul(bonus + 100).div(100);\n', '  }\n', '\n', '\n', '  function refund(uint _value) minCapNotReached public {\n', '\n', '    if (_value != backers[msg.sender].coinSent) revert(); // compare value from backer balance\n', '\n', '    uint ETHToSend = backers[msg.sender].weiReceived;\n', '    backers[msg.sender].weiReceived=0;\n', '\n', '    if (ETHToSend > 0) {\n', '      asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH\n', '    }\n', '  }\n', '\n', '\n', '  function finalize() onlyOwner public {\n', '    require (now >= endTime);\n', '    require (etherReceived >= MIN_CAP);\n', '\n', '    finalizedCrowdfunding = true;\n', '    isFinalized = true;\n', '    freezeTransferForOwnerTime = now + 182 days;\n', '  }\n', '\n', '\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    require(isFinalized);\n', '\n', '    if (msg.sender == owner) {\n', '      require(now > freezeTransferForOwnerTime);\n', '    }\n', '\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    require(isFinalized);\n', '\n', '    if (msg.sender == owner) {\n', '      require(now > freezeTransferForOwnerTime);\n', '    }\n', '\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '}']