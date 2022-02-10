['pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' /// @title SafeMath contract - math operations with safety checks\n', ' /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="1074756650637d716264737f7e646271736475717d3e737f7d">[email&#160;protected]</a>\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    require(assertion);  \n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' /// @title Ownable contract - base contract with an owner\n', ' /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="c2a6a7b482b1afa3b0b6a1adacb6b0a3a1b6a7a3afeca1adaf">[email&#160;protected]</a>\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);  \n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.\n', '/// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="2347465563504e425157404c4d575142405746424e0d404c4e">[email&#160;protected]</a>\n', '/// Originally envisioned in FirstBlood ICO contract.\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    require(!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    require(halted);       \n', '    _;\n', '  }\n', '\n', '  /// called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  /// called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' \n', '\n', '\n', ' /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.\n', ' /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="81e5e4f7c1f2ece0f3f5e2eeeff5f3e0e2f5e4e0ecafe2eeec">[email&#160;protected]</a>\n', 'contract Killable is Ownable {\n', '  function kill() onlyOwner {\n', '    selfdestruct(owner);\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' \n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20\n', ' /// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="1276776452617f736066717d7c666073716677737f3c717d7f">[email&#160;protected]</a>\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function mint(address receiver, uint amount);\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' \n', '\n', '\n', '/// @title ZiberToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', '/// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="aecacbd8eeddc3cfdcdacdc1c0dadccfcddacbcfc380cdc1c3">[email&#160;protected]</a>\n', 'contract ZiberToken is SafeMath, ERC20, Ownable {\n', ' string public name = "Ziber Token";\n', ' string public symbol = "ZBR";\n', ' uint public decimals = 8;\n', ' uint public constant FROZEN_TOKENS = 1e7;\n', ' uint public constant FREEZE_PERIOD = 1 years;\n', ' uint public crowdSaleOverTimestamp;\n', '\n', ' /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token\n', ' address public crowdsaleAgent;\n', ' /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.\n', ' bool public released = false;\n', ' /// approve() allowances\n', ' mapping (address => mapping (address => uint)) allowed;\n', ' /// holder balances\n', ' mapping(address => uint) balances;\n', '\n', ' /// @dev Limit token transfer until the crowdsale is over.\n', ' modifier canTransfer() {\n', '   if(!released) {\n', '     require(msg.sender == crowdsaleAgent);\n', '   }\n', '   _;\n', ' }\n', '\n', ' modifier checkFrozenAmount(address source, uint amount) {\n', '   if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {\n', '     var frozenTokens = 10 ** decimals * FROZEN_TOKENS;\n', '     require(safeSub(balances[owner], amount) > frozenTokens);\n', '   }\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only before or after the tokens have been releasesd\n', ' /// @param _released token transfer and mint state\n', ' modifier inReleaseState(bool _released) {\n', '   require(_released == released);\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only by release agent.\n', ' modifier onlyCrowdsaleAgent() {\n', '   require(msg.sender == crowdsaleAgent);\n', '   _;\n', ' }\n', '\n', ' /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/\n', ' /// @param size payload size\n', ' modifier onlyPayloadSize(uint size) {\n', '   require(msg.data.length >= size + 4);\n', '    _;\n', ' }\n', '\n', ' /// @dev Make sure we are not done yet.\n', ' modifier canMint() {\n', '   require(!released);\n', '    _;\n', '  }\n', '\n', ' /// @dev Constructor\n', ' function ZiberToken() {\n', '   owner = msg.sender;\n', ' }\n', '\n', ' /// Fallback method will buyout tokens\n', ' function() payable {\n', '   revert();\n', ' }\n', ' /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract\n', ' /// @param receiver Address of receiver\n', ' /// @param amount  Number of tokens to issue.\n', ' function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '    balances[receiver] = safeAdd(balances[receiver], amount);\n', '    Transfer(0, receiver, amount);\n', ' }\n', '\n', ' /// @dev Set the contract that can call release and make the token transferable.\n', ' /// @param _crowdsaleAgent crowdsale contract address\n', ' function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {\n', '   crowdsaleAgent = _crowdsaleAgent;\n', ' }\n', ' /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', ' function releaseTokenTransfer() public onlyCrowdsaleAgent {\n', '   crowdSaleOverTimestamp = now;\n', '   released = true;\n', ' }\n', ' /// @dev Tranfer tokens to address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {\n', '   balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '   balances[_to] = safeAdd(balances[_to], _value);\n', '\n', '   Transfer(msg.sender, _to, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Tranfer tokens from one address to other\n', ' /// @param _from source address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', ' }\n', ' /// @dev Tokens balance\n', ' /// @param _owner holder address\n', ' /// @return balance amount\n', ' function balanceOf(address _owner) constant returns (uint balance) {\n', '   return balances[_owner];\n', ' }\n', '\n', ' /// @dev Approve transfer\n', ' /// @param _spender holder address\n', ' /// @param _value tokens amount\n', ' /// @return result\n', ' function approve(address _spender, uint _value) returns (bool success) {\n', '   // To change the approve amount you first have to reduce the addresses`\n', '   //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '   //  already 0 to mitigate the race condition described here:\n', '   //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   require(_value == 0 && allowed[msg.sender][_spender] == 0);\n', '\n', '   allowed[msg.sender][_spender] = _value;\n', '   Approval(msg.sender, _spender, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Token allowance\n', ' /// @param _owner holder address\n', ' /// @param _spender spender address\n', ' /// @return remain amount\n', ' function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '   return allowed[_owner][_spender];\n', ' }\n', '}\n', '\n', '\n', '/// @title ZiberCrowdsale contract - contract for token sales.\n', '/// @author <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="acc8c9daecdfc1cdded8cfc3c2d8decdcfd8c9cdc182cfc3c1">[email&#160;protected]</a>\n', 'contract ZiberCrowdsale is Haltable, Killable, SafeMath {\n', '\n', '  /// Total count of tokens distributed via ICO\n', '  uint public constant TOTAL_ICO_TOKENS = 1e8;\n', '\n', '  /// Miminal tokens funding goal in Wei, if this goal isn&#39;t reached during ICO, refund will begin\n', '  uint public constant MIN_ICO_GOAL = 5e3 ether;\n', '\n', '  /// Maximal tokens funding goal in Wei\n', '  uint public constant MAX_ICO_GOAL = 5e4 ether;\n', '\n', '  /// the UNIX timestamp 5e4 ether funded\n', '  uint public maxGoalReachedAt = 0;\n', '\n', '  /// The duration of ICO\n', '  uint public constant ICO_DURATION = 10 days;\n', '\n', '  /// The duration of ICO\n', '  uint public constant AFTER_MAX_GOAL_DURATION = 24 hours;\n', '\n', '  /// The token we are selling\n', '  ZiberToken public token;\n', '\n', '  /// the UNIX timestamp start date of the crowdsale\n', '  uint public startsAt;\n', '\n', '  /// How many wei of funding we have raised\n', '  uint public weiRaised = 0;\n', '\n', '  /// How much wei we have returned back to the contract after a failed crowdfund.\n', '  uint public loadedRefund = 0;\n', '\n', '  /// How much wei we have given back to investors.\n', '  uint public weiRefunded = 0;\n', '\n', '  /// Has this crowdsale been finalized\n', '  bool public finalized;\n', '\n', '  /// How much ETH each address has invested to this crowdsale\n', '  mapping (address => uint256) public investedAmountOf;\n', '\n', '  /// How much tokens this crowdsale has credited for each investor address\n', '  mapping (address => uint256) public tokenAmountOf;\n', '\n', '  /// Define a structure for one investment event occurrence\n', '  struct Investment {\n', '      /// Who invested\n', '      address source;\n', '      /// Amount invested\n', '      uint weiValue;\n', '  }\n', '\n', '  Investment[] public investments;\n', '\n', '  /// State machine\n', '  /// Preparing: All contract initialization calls and variables have not been set yet\n', '  /// Prefunding: We have not passed start time yet\n', '  /// Funding: Active crowdsale\n', '  /// Success: Minimum funding goal reached\n', '  /// Failure: Minimum funding goal not reached before ending time\n', '  /// Finalized: The finalized has been called and succesfully executed\\\n', '  /// Refunding: Refunds are loaded on the contract for reclaim.\n', '  enum State {Unknown, Preparing, Funding, Success, Failure, Finalized, Refunding}\n', '\n', '  /// A new investment was made\n', '  event Invested(address investor, uint weiAmount);\n', '  /// Refund was processed for a contributor\n', '  event Refund(address investor, uint weiAmount);\n', '\n', '  /// @dev Modified allowing execution only if the crowdsale is currently running\n', '  modifier inState(State state) {\n', '    require(getState() == state);\n', '    _;\n', '  }\n', '\n', '  /// @dev Constructor\n', '  /// @param _token Pay Fair token address\n', '  /// @param _start token ICO start date\n', '  function Crowdsale(address _token, uint _start) {\n', '    require(_token != 0);\n', '    require(_start != 0);\n', '\n', '    owner = msg.sender;\n', '    token = ZiberToken(_token);\n', '    startsAt = _start;\n', '  }\n', '\n', '  ///  Don&#39;t expect to just send in money and get tokens.\n', '  function() payable {\n', '    buy();\n', '  }\n', '\n', '   /// @dev Make an investment. Crowdsale must be running for one to invest.\n', '   /// @param receiver The Ethereum address who receives the tokens\n', '  function investInternal(address receiver) stopInEmergency private {\n', '    var state = getState();\n', '    require(state == State.Funding);\n', '    require(msg.value > 0);\n', '\n', '    // Add investment record\n', '    var weiAmount = msg.value;\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);\n', '    investments.push(Investment(receiver, weiAmount));\n', '\n', '    // Update totals\n', '    weiRaised = safeAdd(weiRaised, weiAmount);\n', '    // Max ICO goal reached at\n', '    if(maxGoalReachedAt == 0 && weiRaised >= MAX_ICO_GOAL)\n', '      maxGoalReachedAt = now;\n', '    // Tell us invest was success\n', '    Invested(receiver, weiAmount);\n', '  }\n', '\n', '  /// @dev Allow anonymous contributions to this crowdsale.\n', '  /// @param receiver The Ethereum address who receives the tokens\n', '  function invest(address receiver) public payable {\n', '    investInternal(receiver);\n', '  }\n', '\n', '  /// @dev The basic entry point to participate the crowdsale process.\n', '  function buy() public payable {\n', '    invest(msg.sender);\n', '  }\n', '\n', '  /// @dev Finalize a succcesful crowdsale.\n', '  function finalize() public inState(State.Success) onlyOwner stopInEmergency {\n', '    require(!finalized);\n', '\n', '    finalized = true;\n', '    finalizeCrowdsale();\n', '  }\n', '\n', '  /// @dev Owner can withdraw contract funds\n', '  function withdraw() public onlyOwner {\n', '    // Transfer funds to the team wallet\n', '    owner.transfer(this.balance);\n', '  }\n', '\n', '  /// @dev Finalize a succcesful crowdsale.\n', '  function finalizeCrowdsale() internal {\n', '    // Calculate divisor of the total token count\n', '    uint divisor;\n', '    for (uint i = 0; i < investments.length; i++)\n', '       divisor = safeAdd(divisor, investments[i].weiValue);\n', '\n', '    var multiplier = 10 ** token.decimals();\n', '    // Get unit price\n', '    uint unitPrice = safeDiv(safeMul(TOTAL_ICO_TOKENS, multiplier), divisor);\n', '\n', '    // Distribute tokens among investors\n', '    for (i = 0; i < investments.length; i++) {\n', '        var tokenAmount = safeMul(unitPrice, investments[i].weiValue);\n', '        tokenAmountOf[investments[i].source] += tokenAmount;\n', '        assignTokens(investments[i].source, tokenAmount);\n', '    }\n', '    assignTokens(owner, 2e7);\n', '    token.releaseTokenTransfer();\n', '  }\n', '\n', '  /// @dev Allow load refunds back on the contract for the refunding.\n', '  function loadRefund() public payable inState(State.Failure) {\n', '    require(msg.value > 0);\n', '    loadedRefund = safeAdd(loadedRefund, msg.value);\n', '  }\n', '\n', '  /// @dev Investors can claim refund.\n', '  function refund() public inState(State.Refunding) {\n', '    uint256 weiValue = investedAmountOf[msg.sender];\n', '    if (weiValue == 0)\n', '      return;\n', '    investedAmountOf[msg.sender] = 0;\n', '    weiRefunded = safeAdd(weiRefunded, weiValue);\n', '    Refund(msg.sender, weiValue);\n', '    msg.sender.transfer(weiValue);\n', '  }\n', '\n', '  /// @dev Minimum goal was reached\n', '  /// @return true if the crowdsale has raised enough money to not initiate the refunding\n', '  function isMinimumGoalReached() public constant returns (bool reached) {\n', '    return weiRaised >= MIN_ICO_GOAL;\n', '  }\n', '\n', '  /// @dev Check if the ICO goal was reached.\n', '  /// @return true if the crowdsale has raised enough money to be a success\n', '  function isCrowdsaleFull() public constant returns (bool) {\n', '    return weiRaised >= MAX_ICO_GOAL && now > maxGoalReachedAt + AFTER_MAX_GOAL_DURATION;\n', '  }\n', '\n', '  /// @dev Crowdfund state machine management.\n', '  /// @return State current state\n', '  function getState() public constant returns (State) {\n', '    if (finalized)\n', '      return State.Finalized;\n', '    if (address(token) == 0)\n', '      return State.Preparing;\n', '    if (now >= startsAt && now < startsAt + ICO_DURATION && !isCrowdsaleFull())\n', '      return State.Funding;\n', '    if (isCrowdsaleFull())\n', '      return State.Success;\n', '    if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)\n', '      return State.Refunding;\n', '    return State.Failure;\n', '  }\n', '\n', '   /// @dev Dynamically create tokens and assign them to the investor.\n', '   /// @param receiver investor address\n', '   /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction\n', '   function assignTokens(address receiver, uint tokenAmount) private {\n', '     token.mint(receiver, tokenAmount);\n', '   }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' /// @title SafeMath contract - math operations with safety checks\n', ' /// @author dev@smartcontracteam.com\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    require(assertion);  \n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' /// @title Ownable contract - base contract with an owner\n', ' /// @author dev@smartcontracteam.com\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);  \n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/// @title Haltable contract - abstract contract that allows children to implement an emergency stop mechanism.\n', '/// @author dev@smartcontracteam.com\n', '/// Originally envisioned in FirstBlood ICO contract.\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    require(!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    require(halted);       \n', '    _;\n', '  }\n', '\n', '  /// called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  /// called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' \n', '\n', '\n', ' /// @title Killable contract - base contract that can be killed by owner. All funds in contract will be sent to the owner.\n', ' /// @author dev@smartcontracteam.com\n', 'contract Killable is Ownable {\n', '  function kill() onlyOwner {\n', '    selfdestruct(owner);\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' \n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20\n', ' /// @author dev@smartcontracteam.com\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function mint(address receiver, uint amount);\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', ' \n', '\n', '\n', '/// @title ZiberToken contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', '/// @author dev@smartcontracteam.com\n', 'contract ZiberToken is SafeMath, ERC20, Ownable {\n', ' string public name = "Ziber Token";\n', ' string public symbol = "ZBR";\n', ' uint public decimals = 8;\n', ' uint public constant FROZEN_TOKENS = 1e7;\n', ' uint public constant FREEZE_PERIOD = 1 years;\n', ' uint public crowdSaleOverTimestamp;\n', '\n', ' /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token\n', ' address public crowdsaleAgent;\n', ' /// A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.\n', ' bool public released = false;\n', ' /// approve() allowances\n', ' mapping (address => mapping (address => uint)) allowed;\n', ' /// holder balances\n', ' mapping(address => uint) balances;\n', '\n', ' /// @dev Limit token transfer until the crowdsale is over.\n', ' modifier canTransfer() {\n', '   if(!released) {\n', '     require(msg.sender == crowdsaleAgent);\n', '   }\n', '   _;\n', ' }\n', '\n', ' modifier checkFrozenAmount(address source, uint amount) {\n', '   if (source == owner && now < crowdSaleOverTimestamp + FREEZE_PERIOD) {\n', '     var frozenTokens = 10 ** decimals * FROZEN_TOKENS;\n', '     require(safeSub(balances[owner], amount) > frozenTokens);\n', '   }\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only before or after the tokens have been releasesd\n', ' /// @param _released token transfer and mint state\n', ' modifier inReleaseState(bool _released) {\n', '   require(_released == released);\n', '   _;\n', ' }\n', '\n', ' /// @dev The function can be called only by release agent.\n', ' modifier onlyCrowdsaleAgent() {\n', '   require(msg.sender == crowdsaleAgent);\n', '   _;\n', ' }\n', '\n', ' /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/\n', ' /// @param size payload size\n', ' modifier onlyPayloadSize(uint size) {\n', '   require(msg.data.length >= size + 4);\n', '    _;\n', ' }\n', '\n', ' /// @dev Make sure we are not done yet.\n', ' modifier canMint() {\n', '   require(!released);\n', '    _;\n', '  }\n', '\n', ' /// @dev Constructor\n', ' function ZiberToken() {\n', '   owner = msg.sender;\n', ' }\n', '\n', ' /// Fallback method will buyout tokens\n', ' function() payable {\n', '   revert();\n', ' }\n', ' /// @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract\n', ' /// @param receiver Address of receiver\n', ' /// @param amount  Number of tokens to issue.\n', ' function mint(address receiver, uint amount) onlyCrowdsaleAgent canMint public {\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '    balances[receiver] = safeAdd(balances[receiver], amount);\n', '    Transfer(0, receiver, amount);\n', ' }\n', '\n', ' /// @dev Set the contract that can call release and make the token transferable.\n', ' /// @param _crowdsaleAgent crowdsale contract address\n', ' function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner inReleaseState(false) public {\n', '   crowdsaleAgent = _crowdsaleAgent;\n', ' }\n', ' /// @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).\n', ' function releaseTokenTransfer() public onlyCrowdsaleAgent {\n', '   crowdSaleOverTimestamp = now;\n', '   released = true;\n', ' }\n', ' /// @dev Tranfer tokens to address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(msg.sender, _value) returns (bool success) {\n', '   balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '   balances[_to] = safeAdd(balances[_to], _value);\n', '\n', '   Transfer(msg.sender, _to, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Tranfer tokens from one address to other\n', ' /// @param _from source address\n', ' /// @param _to dest address\n', ' /// @param _value tokens amount\n', ' /// @return transfer result\n', ' function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer checkFrozenAmount(_from, _value) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', ' }\n', ' /// @dev Tokens balance\n', ' /// @param _owner holder address\n', ' /// @return balance amount\n', ' function balanceOf(address _owner) constant returns (uint balance) {\n', '   return balances[_owner];\n', ' }\n', '\n', ' /// @dev Approve transfer\n', ' /// @param _spender holder address\n', ' /// @param _value tokens amount\n', ' /// @return result\n', ' function approve(address _spender, uint _value) returns (bool success) {\n', '   // To change the approve amount you first have to reduce the addresses`\n', '   //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '   //  already 0 to mitigate the race condition described here:\n', '   //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   require(_value == 0 && allowed[msg.sender][_spender] == 0);\n', '\n', '   allowed[msg.sender][_spender] = _value;\n', '   Approval(msg.sender, _spender, _value);\n', '   return true;\n', ' }\n', '\n', ' /// @dev Token allowance\n', ' /// @param _owner holder address\n', ' /// @param _spender spender address\n', ' /// @return remain amount\n', ' function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '   return allowed[_owner][_spender];\n', ' }\n', '}\n', '\n', '\n', '/// @title ZiberCrowdsale contract - contract for token sales.\n', '/// @author dev@smartcontracteam.com\n', 'contract ZiberCrowdsale is Haltable, Killable, SafeMath {\n', '\n', '  /// Total count of tokens distributed via ICO\n', '  uint public constant TOTAL_ICO_TOKENS = 1e8;\n', '\n', "  /// Miminal tokens funding goal in Wei, if this goal isn't reached during ICO, refund will begin\n", '  uint public constant MIN_ICO_GOAL = 5e3 ether;\n', '\n', '  /// Maximal tokens funding goal in Wei\n', '  uint public constant MAX_ICO_GOAL = 5e4 ether;\n', '\n', '  /// the UNIX timestamp 5e4 ether funded\n', '  uint public maxGoalReachedAt = 0;\n', '\n', '  /// The duration of ICO\n', '  uint public constant ICO_DURATION = 10 days;\n', '\n', '  /// The duration of ICO\n', '  uint public constant AFTER_MAX_GOAL_DURATION = 24 hours;\n', '\n', '  /// The token we are selling\n', '  ZiberToken public token;\n', '\n', '  /// the UNIX timestamp start date of the crowdsale\n', '  uint public startsAt;\n', '\n', '  /// How many wei of funding we have raised\n', '  uint public weiRaised = 0;\n', '\n', '  /// How much wei we have returned back to the contract after a failed crowdfund.\n', '  uint public loadedRefund = 0;\n', '\n', '  /// How much wei we have given back to investors.\n', '  uint public weiRefunded = 0;\n', '\n', '  /// Has this crowdsale been finalized\n', '  bool public finalized;\n', '\n', '  /// How much ETH each address has invested to this crowdsale\n', '  mapping (address => uint256) public investedAmountOf;\n', '\n', '  /// How much tokens this crowdsale has credited for each investor address\n', '  mapping (address => uint256) public tokenAmountOf;\n', '\n', '  /// Define a structure for one investment event occurrence\n', '  struct Investment {\n', '      /// Who invested\n', '      address source;\n', '      /// Amount invested\n', '      uint weiValue;\n', '  }\n', '\n', '  Investment[] public investments;\n', '\n', '  /// State machine\n', '  /// Preparing: All contract initialization calls and variables have not been set yet\n', '  /// Prefunding: We have not passed start time yet\n', '  /// Funding: Active crowdsale\n', '  /// Success: Minimum funding goal reached\n', '  /// Failure: Minimum funding goal not reached before ending time\n', '  /// Finalized: The finalized has been called and succesfully executed\\\n', '  /// Refunding: Refunds are loaded on the contract for reclaim.\n', '  enum State {Unknown, Preparing, Funding, Success, Failure, Finalized, Refunding}\n', '\n', '  /// A new investment was made\n', '  event Invested(address investor, uint weiAmount);\n', '  /// Refund was processed for a contributor\n', '  event Refund(address investor, uint weiAmount);\n', '\n', '  /// @dev Modified allowing execution only if the crowdsale is currently running\n', '  modifier inState(State state) {\n', '    require(getState() == state);\n', '    _;\n', '  }\n', '\n', '  /// @dev Constructor\n', '  /// @param _token Pay Fair token address\n', '  /// @param _start token ICO start date\n', '  function Crowdsale(address _token, uint _start) {\n', '    require(_token != 0);\n', '    require(_start != 0);\n', '\n', '    owner = msg.sender;\n', '    token = ZiberToken(_token);\n', '    startsAt = _start;\n', '  }\n', '\n', "  ///  Don't expect to just send in money and get tokens.\n", '  function() payable {\n', '    buy();\n', '  }\n', '\n', '   /// @dev Make an investment. Crowdsale must be running for one to invest.\n', '   /// @param receiver The Ethereum address who receives the tokens\n', '  function investInternal(address receiver) stopInEmergency private {\n', '    var state = getState();\n', '    require(state == State.Funding);\n', '    require(msg.value > 0);\n', '\n', '    // Add investment record\n', '    var weiAmount = msg.value;\n', '    investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);\n', '    investments.push(Investment(receiver, weiAmount));\n', '\n', '    // Update totals\n', '    weiRaised = safeAdd(weiRaised, weiAmount);\n', '    // Max ICO goal reached at\n', '    if(maxGoalReachedAt == 0 && weiRaised >= MAX_ICO_GOAL)\n', '      maxGoalReachedAt = now;\n', '    // Tell us invest was success\n', '    Invested(receiver, weiAmount);\n', '  }\n', '\n', '  /// @dev Allow anonymous contributions to this crowdsale.\n', '  /// @param receiver The Ethereum address who receives the tokens\n', '  function invest(address receiver) public payable {\n', '    investInternal(receiver);\n', '  }\n', '\n', '  /// @dev The basic entry point to participate the crowdsale process.\n', '  function buy() public payable {\n', '    invest(msg.sender);\n', '  }\n', '\n', '  /// @dev Finalize a succcesful crowdsale.\n', '  function finalize() public inState(State.Success) onlyOwner stopInEmergency {\n', '    require(!finalized);\n', '\n', '    finalized = true;\n', '    finalizeCrowdsale();\n', '  }\n', '\n', '  /// @dev Owner can withdraw contract funds\n', '  function withdraw() public onlyOwner {\n', '    // Transfer funds to the team wallet\n', '    owner.transfer(this.balance);\n', '  }\n', '\n', '  /// @dev Finalize a succcesful crowdsale.\n', '  function finalizeCrowdsale() internal {\n', '    // Calculate divisor of the total token count\n', '    uint divisor;\n', '    for (uint i = 0; i < investments.length; i++)\n', '       divisor = safeAdd(divisor, investments[i].weiValue);\n', '\n', '    var multiplier = 10 ** token.decimals();\n', '    // Get unit price\n', '    uint unitPrice = safeDiv(safeMul(TOTAL_ICO_TOKENS, multiplier), divisor);\n', '\n', '    // Distribute tokens among investors\n', '    for (i = 0; i < investments.length; i++) {\n', '        var tokenAmount = safeMul(unitPrice, investments[i].weiValue);\n', '        tokenAmountOf[investments[i].source] += tokenAmount;\n', '        assignTokens(investments[i].source, tokenAmount);\n', '    }\n', '    assignTokens(owner, 2e7);\n', '    token.releaseTokenTransfer();\n', '  }\n', '\n', '  /// @dev Allow load refunds back on the contract for the refunding.\n', '  function loadRefund() public payable inState(State.Failure) {\n', '    require(msg.value > 0);\n', '    loadedRefund = safeAdd(loadedRefund, msg.value);\n', '  }\n', '\n', '  /// @dev Investors can claim refund.\n', '  function refund() public inState(State.Refunding) {\n', '    uint256 weiValue = investedAmountOf[msg.sender];\n', '    if (weiValue == 0)\n', '      return;\n', '    investedAmountOf[msg.sender] = 0;\n', '    weiRefunded = safeAdd(weiRefunded, weiValue);\n', '    Refund(msg.sender, weiValue);\n', '    msg.sender.transfer(weiValue);\n', '  }\n', '\n', '  /// @dev Minimum goal was reached\n', '  /// @return true if the crowdsale has raised enough money to not initiate the refunding\n', '  function isMinimumGoalReached() public constant returns (bool reached) {\n', '    return weiRaised >= MIN_ICO_GOAL;\n', '  }\n', '\n', '  /// @dev Check if the ICO goal was reached.\n', '  /// @return true if the crowdsale has raised enough money to be a success\n', '  function isCrowdsaleFull() public constant returns (bool) {\n', '    return weiRaised >= MAX_ICO_GOAL && now > maxGoalReachedAt + AFTER_MAX_GOAL_DURATION;\n', '  }\n', '\n', '  /// @dev Crowdfund state machine management.\n', '  /// @return State current state\n', '  function getState() public constant returns (State) {\n', '    if (finalized)\n', '      return State.Finalized;\n', '    if (address(token) == 0)\n', '      return State.Preparing;\n', '    if (now >= startsAt && now < startsAt + ICO_DURATION && !isCrowdsaleFull())\n', '      return State.Funding;\n', '    if (isCrowdsaleFull())\n', '      return State.Success;\n', '    if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised)\n', '      return State.Refunding;\n', '    return State.Failure;\n', '  }\n', '\n', '   /// @dev Dynamically create tokens and assign them to the investor.\n', '   /// @param receiver investor address\n', '   /// @param tokenAmount The amount of tokens we try to give to the investor in the current transaction\n', '   function assignTokens(address receiver, uint tokenAmount) private {\n', '     token.mint(receiver, tokenAmount);\n', '   }\n', '}']
