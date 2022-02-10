['pragma solidity ^0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="345055425174555f5b5956551a575b59">[email&#160;protected]</a>\n', '// released under Apache 2.0 licence\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'library DateTimeUtility {\n', '    \n', '    function toGMT(uint256 _unixtime) \n', '        pure \n', '        internal \n', '        returns(uint32, uint8, uint8, uint8, uint8, uint8)\n', '    {\n', '        // http://ptspts.blogspot.com/2009/11/how-to-convert-unix-timestamp-to-civil.html\n', '        uint256 secs = _unixtime % 86400;\n', '        \n', '        _unixtime /= 86400;\n', '        uint256 e = (_unixtime * 4 + 102032) / 146097 + 15;\n', '        e = _unixtime + 2442113 + e - (e / 4);\n', '        uint256 c = (e * 20 - 2442) / 7305;\n', '        uint256 d = e - 365 * c - c / 4;\n', '        e = d * 1000 / 30601;\n', '        \n', '        if (e < 14) {\n', '            return (uint32(c - 4716)\n', '                , uint8(e - 1)\n', '                , uint8(d - e * 30 - e * 601 / 1000)\n', '                , uint8(secs / 3600)\n', '                , uint8(secs / 60 % 60)\n', '                , uint8(secs % 60));\n', '        } else {\n', '            return (uint32(c - 4715)\n', '                , uint8(e - 13)\n', '                , uint8(d - e * 30 - e * 601 / 1000)\n', '                , uint8(secs / 3600)\n', '                , uint8(secs / 60 % 60)\n', '                , uint8(secs % 60));\n', '        }\n', '    } \n', '    \n', '    function toUnixtime(uint32 _year, uint8 _month, uint8 _mday, uint8 _hour, uint8 _minute, uint8 _second) \n', '        pure \n', '        internal \n', '        returns (uint256)\n', '    {\n', '        // http://ptspts.blogspot.com/2009/11/how-to-convert-unix-timestamp-to-civil.html\n', '        \n', '        uint256 m = uint256(_month);\n', '        uint256 y = uint256(_year);\n', '        if (m <= 2) {\n', '            y -= 1;\n', '            m += 12;\n', '        }\n', '        \n', '        return (365 * y + y / 4 -  y/ 100 + y / 400 + 3 * (m + 1) / 5 + 30 * m + uint256(_mday) - 719561) * 86400 \n', '            + 3600 * uint256(_hour) + 60 * uint256(_minute) + uint256(_second);\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract StrayToken is StandardToken, BurnableToken, Ownable {\n', '\tusing SafeERC20 for ERC20;\n', '\t\n', '\tuint256 public INITIAL_SUPPLY = 1000000000;\n', '\t\n', '\tstring public name = "Stray";\n', '\tstring public symbol = "ST";\n', '\tuint8 public decimals = 18;\n', '\n', '\taddress public companyWallet;\n', '\taddress public privateWallet;\n', '\taddress public fund;\n', '\t\n', '\t/**\n', '\t * @param _companyWallet The company wallet which reserves 15% of the token.\n', '\t * @param _privateWallet Private wallet which reservers 25% of the token.\n', '\t */\n', '\tconstructor(address _companyWallet, address _privateWallet) public {\n', '\t\trequire(_companyWallet != address(0));\n', '\t\trequire(_privateWallet != address(0));\n', '\t\t\n', '\t\ttotalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));\n', '\t\tcompanyWallet = _companyWallet;\n', '\t\tprivateWallet = _privateWallet;\n', '\t\t\n', '\t\t// 15% of tokens for company reserved.\n', '\t\t_preSale(companyWallet, totalSupply_.mul(15).div(100));\n', '\t\t\n', '\t\t// 25% of tokens for private funding.\n', '\t\t_preSale(privateWallet, totalSupply_.mul(25).div(100));\n', '\t\t\n', '\t\t// 60% of tokens for crowdsale.\n', '\t\tuint256 sold = balances[companyWallet].add(balances[privateWallet]);\n', '\t    balances[msg.sender] = balances[msg.sender].add(totalSupply_.sub(sold));\n', '\t    emit Transfer(address(0), msg.sender, balances[msg.sender]);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @param _fund The DAICO fund contract address.\n', '\t */\n', '\tfunction setFundContract(address _fund) onlyOwner public {\n', '\t    require(_fund != address(0));\n', '\t    //require(_fund != owner);\n', '\t    //require(_fund != msg.sender);\n', '\t    require(_fund != address(this));\n', '\t    \n', '\t    fund = _fund;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev The DAICO fund contract calls this function to burn the user&#39;s token\n', '\t * to avoid over refund.\n', '\t * @param _from The address which just took its refund.\n', '\t */\n', '\tfunction burnAll(address _from) public {\n', '\t    require(fund == msg.sender);\n', '\t    require(0 != balances[_from]);\n', '\t    \n', '\t    _burn(_from, balances[_from]);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @param _to The address which will get the token.\n', '\t * @param _value The token amount.\n', '\t */\n', '\tfunction _preSale(address _to, uint256 _value) internal onlyOwner {\n', '\t\tbalances[_to] = _value;\n', '\t\temit Transfer(address(0), _to, _value);\n', '\t}\n', '\t\n', '}\n', '\n', 'contract StrayFund is Ownable {\n', '\tusing SafeMath for uint256;\n', '\tusing DateTimeUtility for uint256;\n', '\t\n', '    // The fund state.\n', '\tenum State {\n', '\t    NotReady       // The fund is not ready for any operations.\n', '\t    , TeamWithdraw // The fund can be withdrawn and voting proposals.\n', '\t    , Refunding    // The fund only can be refund..\n', '\t    , Closed       // The fund is closed.\n', '\t}\n', '\t\n', '\n', '\t// @dev Proposal type for voting.\n', '\tenum ProposalType { \n', '\t    Tap          // Tap proposal sponsored by token holder out of company.\n', '\t    , OfficalTap // Tap proposal sponsored by company.\n', '\t    , Refund     // Refund proposal.\n', '\t}\n', '\t\n', '\t// A special number indicates that no valid id.\n', '\tuint256 NON_UINT256 = (2 ** 256) - 1;\n', '\t\n', '\t// Data type represent a vote.\n', '\tstruct Vote {\n', '\t\taddress tokeHolder; // Voter address.\n', '\t\tbool inSupport;     // Support or not.\n', '\t}\n', '\t\n', '\t// Voting proposal.\n', '\tstruct Proposal {              \n', '\t    ProposalType proposalType; // Proposal type.\n', '\t    address sponsor;           // Who proposed this vote.\n', '\t    uint256 openingTime;       // Opening time of the voting.\n', '\t    uint256 closingTime;       // Closing time of the voting.\n', '\t    Vote[] votes;              // All votes.\n', '\t\tmapping (address => bool) voted; // Prevent duplicate vote.\n', '\t\tbool isPassed;             // Final result.\n', '\t\tbool isFinialized;         // Proposal state.\n', '\t\tuint256 targetWei;         // Tap proposal target.\n', '\t}\n', '\t\n', '\t// Budget plan stands a budget period for the team to withdraw the funds.\n', '\tstruct BudgetPlan {\n', '\t    uint256 proposalId;       // The tap proposal id.\n', '\t    uint256 budgetInWei;      // Budget in wei.\n', '\t    uint256 withdrawnWei;     // Withdrawn wei.\n', '\t    uint256 startTime;        // Start time of this budget plan. \n', '\t    uint256 endTime;          // End time of this budget plan.\n', '\t    uint256 officalVotingTime; // The offical tap voting time in this period.\n', '\t}\n', '\t\n', '\t// Team wallet to receive the budget.\n', '\taddress public teamWallet;\n', '\t\n', '\t// Fund state.\n', '\tState public state;\n', '\t\n', '\t// Stary Token.\n', '\tStrayToken public token;\n', '\t\n', '\t// Proposal history.\n', '\tProposal[] public proposals;\n', '\t\n', '\t// Budget plan history.\n', '\tBudgetPlan[] public budgetPlans;\n', '\t\n', '\t// Current budget plan id.\n', '\tuint256 currentBudgetPlanId;\n', '\t\n', '\t// The mininum budget.\n', '\tuint256 public MIN_WITHDRAW_WEI = 1 ether;\n', '\t\n', '\t// The fist withdraw rate when the crowdsale was successed.\n', '\tuint256 public FIRST_WITHDRAW_RATE = 20;\n', '\t\n', '\t// The voting duration.\n', '\tuint256 public VOTING_DURATION = 1 weeks;\n', '\t\n', '\t// Offical voting day of the last month of budget period. \n', '\tuint8 public OFFICAL_VOTING_DAY_OF_MONTH = 23;\n', '\t\n', '\t// Refund lock duration.\n', '\tuint256 public REFUND_LOCK_DURATION = 30 days;\n', '\t\n', '\t// Refund lock date.\n', '\tuint256 public refundLockDate = 0;\n', '\t\n', '\tevent TeamWithdrawEnabled();\n', '\tevent RefundsEnabled();\n', '\tevent Closed();\n', '\t\n', '\tevent TapVoted(address indexed voter, bool isSupported);\n', '\tevent TapProposalAdded(uint256 openingTime, uint256 closingTime, uint256 targetWei);\n', '\tevent TapProposalClosed(uint256 closingTime, uint256 targetWei, bool isPassed);\n', '\t\n', '\tevent RefundVoted(address indexed voter, bool isSupported);\n', '\tevent RefundProposalAdded(uint256 openingTime, uint256 closingTime);\n', '\tevent RefundProposalClosed(uint256 closingTime, bool isPassed);\n', '\t\n', '\tevent Withdrew(uint256 weiAmount);\n', '\tevent Refund(address indexed holder, uint256 amount);\n', '\t\n', '\tmodifier onlyTokenHolders {\n', '\t\trequire(token.balanceOf(msg.sender) != 0);\n', '\t\t_;\n', '\t}\n', '\t\n', '\tmodifier inWithdrawState {\n', '\t    require(state == State.TeamWithdraw);\n', '\t    _;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @param _teamWallet The wallet which receives the funds.\n', '\t * @param _token Stray token address.\n', '\t */\n', '    constructor(address _teamWallet, address _token) public {\n', '\t\trequire(_teamWallet != address(0));\n', '\t\trequire(_token != address(0));\n', '\t\t\n', '\t\tteamWallet = _teamWallet;\n', '\t\tstate = State.NotReady;\n', '\t\ttoken = StrayToken(_token);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Enable the TeamWithdraw state.\n', '\t */\n', '\tfunction enableTeamWithdraw() onlyOwner public {\n', '\t\trequire(state == State.NotReady);\n', '\t\tstate = State.TeamWithdraw;\n', '\t\temit TeamWithdrawEnabled();\n', '\t\t\n', '\t\tbudgetPlans.length++;\n', '\t\tBudgetPlan storage plan = budgetPlans[0];\n', '\t\t\n', '\t    plan.proposalId = NON_UINT256;\n', '\t    plan.budgetInWei = address(this).balance.mul(FIRST_WITHDRAW_RATE).div(100);\n', '\t    plan.withdrawnWei = 0;\n', '\t    plan.startTime = now;\n', '\t    (plan.endTime, plan.officalVotingTime) = _budgetEndAndOfficalVotingTime(now);\n', '\t    \n', '\t    currentBudgetPlanId = 0;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Close the fund.\n', '\t */\n', '\tfunction close() onlyOwner inWithdrawState public {\n', '\t    require(address(this).balance < MIN_WITHDRAW_WEI);\n', '\t    \n', '\t\tstate = State.Closed;\n', '\t\temit Closed();\n', '\t\t\n', '\t\tteamWallet.transfer(address(this).balance);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Check if there is an ongoing proposal.\n', '\t */\n', '\tfunction isThereAnOnGoingProposal() public view returns (bool) {\n', '\t    if (proposals.length == 0 || state != State.TeamWithdraw) {\n', '\t        return false;\n', '\t    } else {\n', '\t        Proposal storage p = proposals[proposals.length - 1];\n', '\t        return now < p.closingTime;\n', '\t    }\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Check if next budget period plan has been made.\n', '\t */\n', '\tfunction isNextBudgetPlanMade() public view returns (bool) {\n', '\t    if (state != State.TeamWithdraw) {\n', '\t        return false;\n', '\t    } else {\n', '\t        return currentBudgetPlanId != budgetPlans.length - 1;\n', '\t    }\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Get number of proposals. \n', '\t */\n', '\tfunction numberOfProposals() public view returns (uint256) {\n', '\t    return proposals.length;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Get number of budget plans. \n', '\t */\n', '\tfunction numberOfBudgetPlan() public view returns (uint256) {\n', '\t    return budgetPlans.length;\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Try to finialize the last proposal.\n', '\t */\n', '\tfunction tryFinializeLastProposal() inWithdrawState public {\n', '\t    if (proposals.length == 0) {\n', '\t        return;\n', '\t    }\n', '\t    \n', '\t    uint256 id = proposals.length - 1;\n', '\t    Proposal storage p = proposals[id];\n', '\t    if (now > p.closingTime && !p.isFinialized) {\n', '\t        _countVotes(p);\n', '\t        if (p.isPassed) {\n', '\t            if (p.proposalType == ProposalType.Refund) {\n', '\t                _enableRefunds();\n', '\t            } else {\n', '\t                _makeBudgetPlan(p, id);\n', '\t            }\n', '\t        }\n', '\t    }\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Create new tap proposal by address out of company.\n', '\t * @param _targetWei The voting target.\n', '\t */\n', '\tfunction newTapProposalFromTokenHolders(uint256 _targetWei)\n', '\t    onlyTokenHolders \n', '\t    inWithdrawState \n', '\t    public\n', '\t{\n', '\t    // Sponsor cannot be stuff of company.\n', '\t    require(msg.sender != owner);\n', '\t    require(msg.sender != teamWallet);\n', '\t    \n', '\t    // Check the last result.\n', '\t    tryFinializeLastProposal();\n', '\t    require(state == State.TeamWithdraw);\n', '\t    \n', '\t    // Proposal is disable when the budget plan has been made.\n', '\t    require(!isNextBudgetPlanMade());\n', '\t    \n', '\t    // Proposal voting is exclusive.\n', '\t    require(!isThereAnOnGoingProposal());\n', '\t    \n', '\t    // Validation of time restriction.\n', '\t    BudgetPlan storage b = budgetPlans[currentBudgetPlanId];\n', '\t\trequire(now <= b.officalVotingTime && now >= b.startTime);\n', '\t\t\n', '\t\t// Sponsor is not allowed to propose repeatly in the same budget period.\n', '\t\trequire(!_hasProposed(msg.sender, ProposalType.Tap));\n', '\t\t\n', '\t\t// Create a new proposal.\n', '\t\t_newTapProposal(ProposalType.Tap, _targetWei);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Create new tap proposal by company.\n', '\t * @param _targetWei The voting target.\n', '\t */\n', '\tfunction newTapProposalFromCompany(uint256 _targetWei)\n', '\t    onlyOwner \n', '\t    inWithdrawState \n', '\t    public\n', '\t{\n', '\t    // Check the last result.\n', '\t    tryFinializeLastProposal();\n', '\t    require(state == State.TeamWithdraw);\n', '\t    \n', '\t    // Proposal is disable when the budget plan has been made.\n', '\t    require(!isNextBudgetPlanMade());\n', '\t    \n', '\t    // Proposal voting is exclusive.\n', '\t    require(!isThereAnOnGoingProposal());\n', '\t    \n', '\t    // Validation of time restriction.\n', '\t    BudgetPlan storage b = budgetPlans[currentBudgetPlanId];\n', '\t\trequire(now >= b.officalVotingTime);\n', '\t\t\n', '\t\t// Create a new proposal.\n', '\t\t_newTapProposal(ProposalType.OfficalTap, _targetWei);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Create a refund proposal.\n', '\t */\n', '\tfunction newRefundProposal() onlyTokenHolders inWithdrawState public {\n', '\t    // Check the last result.\n', '\t    tryFinializeLastProposal();\n', '\t    require(state == State.TeamWithdraw);\n', '\t    \n', '\t    // Proposal voting is exclusive.\n', '\t    require(!isThereAnOnGoingProposal());\n', '\t    \n', '\t    // Sponsor is not allowed to propose repeatly in the same budget period.\n', '\t    require(!_hasProposed(msg.sender, ProposalType.Refund));\n', '\t    \n', '\t    // Create proposals.\n', '\t\tuint256 id = proposals.length++;\n', '\t\tProposal storage p = proposals[id];\n', '\t\tp.proposalType = ProposalType.Refund;\n', '\t\tp.sponsor = msg.sender;\n', '\t\tp.openingTime = now;\n', '\t\tp.closingTime = now + VOTING_DURATION;\n', '\t\tp.isPassed = false;\n', '\t\tp.isFinialized = false;\n', '\t\t\n', '\t\t// Signal the event.\n', '\t\temit RefundProposalAdded(p.openingTime, p.closingTime);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Vote for a tap proposal.\n', '\t * @param _supportsProposal True if the vote supports the proposal.\n', '\t */\n', '\tfunction voteForTap(bool _supportsProposal)\n', '\t    onlyTokenHolders\n', '\t    inWithdrawState\n', '\t    public\n', '\t{\n', '\t    // Check the last result.\n', '\t    tryFinializeLastProposal();\n', '\t\trequire(isThereAnOnGoingProposal());\n', '\t\t\n', '\t\t// Check the ongoing proposal&#39;s type and reject the voted address.\n', '\t\tProposal storage p = proposals[proposals.length - 1];\n', '\t\trequire(p.proposalType != ProposalType.Refund);\n', '\t\trequire(true != p.voted[msg.sender]);\n', '\t\t\n', '\t\t// Record the vote.\n', '\t\tuint256 voteId = p.votes.length++;\n', '\t\tp.votes[voteId].tokeHolder = msg.sender;\n', '\t\tp.votes[voteId].inSupport = _supportsProposal;\n', '\t\tp.voted[msg.sender] = true;\n', '\t\t\n', '\t\t// Signal the event.\n', '\t\temit TapVoted(msg.sender, _supportsProposal);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Vote for a tap proposal.\n', '\t * @param _supportsProposal True if the vote supports the proposal.\n', '\t */\n', '\tfunction voteForRefund(bool _supportsProposal)\n', '\t    onlyTokenHolders\n', '\t    inWithdrawState\n', '\t    public\n', '\t{\n', '\t    // Check the last result.\n', '\t    tryFinializeLastProposal();\n', '\t\trequire(isThereAnOnGoingProposal());\n', '\t\t\n', '\t\t// Check the ongoing proposal&#39;s type and reject the voted address.\n', '\t\tProposal storage p = proposals[proposals.length - 1];\n', '\t\trequire(p.proposalType == ProposalType.Refund);\n', '\t\trequire(true != p.voted[msg.sender]);\n', '\t\t\n', '\t\t// Record the vote.\n', '\t\tuint256 voteId = p.votes.length++;\n', '\t\tp.votes[voteId].tokeHolder = msg.sender;\n', '\t\tp.votes[voteId].inSupport = _supportsProposal;\n', '\t\tp.voted[msg.sender] = true;\n', '\t\t\n', '\t\t// Signal the event.\n', '\t\temit RefundVoted(msg.sender, _supportsProposal);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Withdraw the wei to team wallet.\n', '\t * @param _amount Withdraw wei.\n', '\t */\n', '\tfunction withdraw(uint256 _amount) onlyOwner inWithdrawState public {\n', '\t    // Check the last result.\n', '\t    tryFinializeLastProposal();\n', '\t    require(state == State.TeamWithdraw);\n', '\t    \n', '\t    // Try to update the budget plans.\n', '\t    BudgetPlan storage currentPlan = budgetPlans[currentBudgetPlanId];\n', '\t    if (now > currentPlan.endTime) {\n', '\t        require(isNextBudgetPlanMade());\n', '\t        ++currentBudgetPlanId;\n', '\t    }\n', '\t    \n', '\t    // Withdraw the weis.\n', '\t    _withdraw(_amount);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Withdraw when there is no budget plans.\n', '\t */\n', '\tfunction withdrawOnNoAvailablePlan() onlyOwner inWithdrawState public {\n', '\t    require(address(this).balance >= MIN_WITHDRAW_WEI);\n', '\t    \n', '\t    // Check the last result.\n', '\t    tryFinializeLastProposal();\n', '\t    require(state == State.TeamWithdraw);\n', '\t    \n', '\t    // Check if someone proposed a tap voting.\n', '\t    require(!_isThereAnOnGoingTapProposal());\n', '\t    \n', '\t    // There is no passed budget plan.\n', '\t    require(!isNextBudgetPlanMade());\n', '\t    \n', '\t    // Validate the time.\n', '\t    BudgetPlan storage currentPlan = budgetPlans[currentBudgetPlanId];\n', '\t    require(now > currentPlan.endTime);\n', '\t    \n', '\t    // Create plan.\n', '\t    uint256 planId = budgetPlans.length++;\n', '\t    BudgetPlan storage plan = budgetPlans[planId];\n', '\t    plan.proposalId = NON_UINT256;\n', '\t    plan.budgetInWei = MIN_WITHDRAW_WEI;\n', '\t    plan.withdrawnWei = 0;\n', '\t    plan.startTime = now;\n', '\t    (plan.endTime, plan.officalVotingTime) = _budgetEndAndOfficalVotingTime(now);\n', '\t    \n', '\t    ++currentBudgetPlanId;\n', '\t    \n', '\t    // Withdraw the weis.\n', '\t    _withdraw(MIN_WITHDRAW_WEI);\n', '\t}\n', '\t\n', '\t/**\n', '     * @dev Tokenholders can claim refunds here.\n', '     */\n', '\tfunction claimRefund() onlyTokenHolders public {\n', '\t    // Check the state.\n', '\t\trequire(state == State.Refunding);\n', '\t\t\n', '\t\t// Validate the time.\n', '\t\trequire(now > refundLockDate + REFUND_LOCK_DURATION);\n', '\t\t\n', '\t\t// Calculate the transfering wei and burn all the token of the refunder.\n', '\t\tuint256 amount = address(this).balance.mul(token.balanceOf(msg.sender)).div(token.totalSupply());\n', '\t\ttoken.burnAll(msg.sender);\n', '\t\t\n', '\t\t// Signal the event.\n', '\t\tmsg.sender.transfer(amount);\n', '\t}\n', '\t\n', '\t/**\n', '\t * @dev Check if refund is in lock period.\n', '\t */\n', '\t function isRefundLocked() public view returns (bool) {\n', '\t     return state == State.Refunding && now < refundLockDate + REFUND_LOCK_DURATION;\n', '\t }\n', '\t\n', '\t/**\n', '\t * @dev Get remaining funds.\n', '\t */\n', '\t function remainingFunds() public view returns (uint256) {\n', '\t     return address(this).balance;\n', '\t }\n', '\t\n', '\t/**\n', '     * @dev Receive the initial funds from crowdsale contract.\n', '     */\n', '\tfunction receiveInitialFunds() payable public {\n', '\t    require(state == State.NotReady);\n', '\t}\n', '\t\n', '\t/**\n', '     * @dev Fallback function to receive initial funds.\n', '     */\n', '\tfunction () payable public {\n', '\t    receiveInitialFunds();\n', '\t}\n', '\t\n', '\tfunction _withdraw(uint256 _amount) internal {\n', '\t    BudgetPlan storage plan = budgetPlans[currentBudgetPlanId];\n', '\t    \n', '\t    // Validate the time.\n', '\t    require(now <= plan.endTime);\n', '\t    \n', '\t    // Check the remaining wei.\n', '\t    require(_amount + plan.withdrawnWei <= plan.budgetInWei);\n', '\t       \n', '\t    // Transfer the wei.\n', '\t    plan.withdrawnWei += _amount;\n', '\t    teamWallet.transfer(_amount);\n', '\t    \n', '\t    // Signal the event.\n', '\t    emit Withdrew(_amount);\n', '\t}\n', '\t\n', '\tfunction _countVotes(Proposal storage p)\n', '\t    internal \n', '\t    returns (bool)\n', '\t{\n', '\t    require(!p.isFinialized);\n', '\t    require(now > p.closingTime);\n', '\t    \n', '\t\tuint256 yes = 0;\n', '\t\tuint256 no = 0;\n', '\t\t\n', '\t\tfor (uint256 i = 0; i < p.votes.length; ++i) {\n', '\t\t\tVote storage v = p.votes[i];\n', '\t\t\tuint256 voteWeight = token.balanceOf(v.tokeHolder);\n', '\t\t\tif (v.inSupport) {\n', '\t\t\t\tyes += voteWeight;\n', '\t\t\t} else {\n', '\t\t\t\tno += voteWeight;\n', '\t\t\t}\n', '\t\t}\n', '\t\t\n', '\t\tp.isPassed = (yes >= no);\n', '\t\tp.isFinialized = true;\n', '\t\t\n', '\t\temit TapProposalClosed(p.closingTime\n', '\t\t\t, p.targetWei\n', '\t\t\t, p.isPassed);\n', '\t\t\n', '\t\treturn p.isPassed;\n', '\t}\n', '\t\n', '\tfunction _enableRefunds() inWithdrawState internal {\n', '\t    state = State.Refunding;\n', '\t\temit RefundsEnabled();\n', '\t\t\n', '\t\trefundLockDate = now;\n', '\t}\n', '\t\n', '\tfunction _makeBudgetPlan(Proposal storage p, uint256 proposalId) \n', '\t    internal\n', '\t{\n', '\t    require(p.proposalType != ProposalType.Refund);\n', '\t    require(p.isFinialized);\n', '\t    require(p.isPassed);\n', '\t    require(!isNextBudgetPlanMade());\n', '\t    \n', '\t    uint256 planId = budgetPlans.length++;\n', '\t    BudgetPlan storage plan = budgetPlans[planId];\n', '\t    plan.proposalId = proposalId;\n', '\t    plan.budgetInWei = p.targetWei;\n', '\t    plan.withdrawnWei = 0;\n', '\t    \n', '\t    if (now > budgetPlans[currentBudgetPlanId].endTime) {\n', '\t        plan.startTime = now;\n', '\t        (plan.endTime, plan.officalVotingTime) = _budgetEndAndOfficalVotingTime(now);\n', '\t        ++currentBudgetPlanId;\n', '\t    } else {\n', '\t        (plan.startTime, plan.endTime, plan.officalVotingTime) = _nextBudgetStartAndEndAndOfficalVotingTime();\n', '\t    }\n', '\t}\n', '\t\n', '\tfunction _newTapProposal(ProposalType _proposalType, uint256 _targetWei) internal {\n', '\t    // The minimum wei requirement.\n', '\t\trequire(_targetWei >= MIN_WITHDRAW_WEI && _targetWei <= address(this).balance);\n', '\t    \n', '\t    uint256 id = proposals.length++;\n', '        Proposal storage p = proposals[id];\n', '        p.proposalType = _proposalType;\n', '\t\tp.sponsor = msg.sender;\n', '\t\tp.openingTime = now;\n', '\t\tp.closingTime = now + VOTING_DURATION;\n', '\t\tp.isPassed = false;\n', '\t\tp.isFinialized = false;\n', '\t\tp.targetWei = _targetWei;\n', '\t\t\n', '\t\temit TapProposalAdded(p.openingTime\n', '\t\t\t, p.closingTime\n', '\t\t\t, p.targetWei);\n', '\t}\n', '\t\n', '\tfunction _isThereAnOnGoingTapProposal() internal view returns (bool) {\n', '\t    if (proposals.length == 0) {\n', '\t        return false;\n', '\t    } else {\n', '\t        Proposal storage p = proposals[proposals.length - 1];\n', '\t        return p.proposalType != ProposalType.Refund  && now < p.closingTime;\n', '\t    }\n', '\t}\n', '\t\n', '\tfunction _budgetEndAndOfficalVotingTime(uint256 _startTime)\n', '\t    view\n', '\t    internal\n', '\t    returns (uint256, uint256)\n', '\t{\n', '\t    // Decompose to datetime.\n', '        uint32 year;\n', '        uint8 month;\n', '        uint8 mday;\n', '        uint8 hour;\n', '        uint8 minute;\n', '        uint8 second;\n', '        (year, month, mday, hour, minute, second) = _startTime.toGMT();\n', '        \n', '        // Calculate the next end time of budget period.\n', '        month = ((month - 1) / 3 + 1) * 3 + 1;\n', '        if (month > 12) {\n', '            month -= 12;\n', '            year += 1;\n', '        }\n', '        \n', '        mday = 1;\n', '        hour = 0;\n', '        minute = 0;\n', '        second = 0;\n', '        \n', '        uint256 end = DateTimeUtility.toUnixtime(year, month, mday, hour, minute, second) - 1;\n', '     \n', '         // Calculate the offical voting time of the budget period.\n', '        mday = OFFICAL_VOTING_DAY_OF_MONTH;\n', '        hour = 0;\n', '        minute = 0;\n', '        second = 0;\n', '        \n', '        uint256 votingTime = DateTimeUtility.toUnixtime(year, month, mday, hour, minute, second);\n', '        \n', '        return (end, votingTime);\n', '\t}\n', '    \n', '    function _nextBudgetStartAndEndAndOfficalVotingTime() \n', '        view \n', '        internal \n', '        returns (uint256, uint256, uint256)\n', '    {\n', '        // Decompose to datetime.\n', '        uint32 year;\n', '        uint8 month;\n', '        uint8 mday;\n', '        uint8 hour;\n', '        uint8 minute;\n', '        uint8 second;\n', '        (year, month, mday, hour, minute, second) = now.toGMT();\n', '        \n', '        // Calculate the next start time of budget period. (1/1, 4/1, 7/1, 10/1)\n', '        month = ((month - 1) / 3 + 1) * 3 + 1;\n', '        if (month > 12) {\n', '            month -= 12;\n', '            year += 1;\n', '        }\n', '        \n', '        mday = 1;\n', '        hour = 0;\n', '        minute = 0;\n', '        second = 0;\n', '        \n', '        uint256 start = DateTimeUtility.toUnixtime(year, month, mday, hour, minute, second);\n', '        \n', '        // Calculate the next end time of budget period.\n', '        month = ((month - 1) / 3 + 1) * 3 + 1;\n', '        if (month > 12) {\n', '            month -= 12;\n', '            year += 1;\n', '        }\n', '        \n', '        uint256 end = DateTimeUtility.toUnixtime(year, month, mday, hour, minute, second) - 1;\n', '        \n', '        // Calculate the offical voting time of the budget period.\n', '        mday = OFFICAL_VOTING_DAY_OF_MONTH;\n', '        hour = 0;\n', '        minute = 0;\n', '        second = 0;\n', '        \n', '        uint256 votingTime = DateTimeUtility.toUnixtime(year, month, mday, hour, minute, second);\n', '        \n', '        return (start, end, votingTime);\n', '    } \n', '    \n', '    function _hasProposed(address _sponsor, ProposalType proposalType)\n', '        internal\n', '        view\n', '        returns (bool)\n', '    {\n', '        if (proposals.length == 0) {\n', '            return false;\n', '        } else {\n', '            BudgetPlan storage b = budgetPlans[currentBudgetPlanId];\n', '            for (uint256 i = proposals.length - 1;; --i) {\n', '                Proposal storage p = proposals[i];\n', '                if (p.openingTime < b.startTime) {\n', '                    return false;\n', '                } else if (p.openingTime <= b.endTime \n', '                            && p.sponsor == _sponsor \n', '                            && p.proposalType == proposalType\n', '                            && !p.isPassed) {\n', '                    return true;\n', '                }\n', '                \n', '                if (i == 0)\n', '                    break;\n', '            }\n', '            return false;\n', '        }\n', '    }\n', '}']