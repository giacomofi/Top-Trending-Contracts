['pragma solidity ^0.4.13;\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract UNIT is ERC20,Ownable{\n', '\tusing SafeMath for uint256;\n', '\n', '\t//the base info of the token\n', '\tstring public constant name="Unit Pay";\n', '\tstring public constant symbol="UNIT";\n', '\tstring public constant version = "1.0";\n', '\tuint256 public constant decimals = 18;\n', '\n', '\tuint256 public constant MAX_PRIVATE_FUNDING_SUPPLY=600000000*10**decimals;\n', '\n', '\tuint256 public constant COOPERATE_REWARD=300000000*10**decimals;\n', '\n', '\tuint256 public constant COMMON_WITHDRAW_SUPPLY=MAX_PRIVATE_FUNDING_SUPPLY+COOPERATE_REWARD;\n', '\n', '\tuint256 public constant PARTNER_SUPPLY=600000000*10**decimals;\n', '\n', '\tuint256 public constant MAX_PUBLIC_FUNDING_SUPPLY=150000000*10**decimals;\n', '\n', '\tuint256 public constant TEAM_KEEPING=1350000000*10**decimals;\n', '\n', '\tuint256 public constant MAX_SUPPLY=COMMON_WITHDRAW_SUPPLY+PARTNER_SUPPLY+MAX_PUBLIC_FUNDING_SUPPLY+TEAM_KEEPING;\n', '\n', '\tuint256 public rate;\n', '\n', '\tmapping(address=>uint256) public publicFundingWhiteList;\n', '\t\n', '\n', '\tuint256 public totalCommonWithdrawSupply;\n', '\n', '\tuint256 public totalPartnerWithdrawSupply;\n', '\n', '\tuint256 public totalPublicFundingSupply;\n', '\n', '\tuint256 public startTime;\n', '\tuint256 public endTime;\n', '\n', '\tuint256 public constant TEAM_UNFREEZE=270000000*10**decimals;\n', '\tbool public hasOneStepWithdraw;\n', '\tbool public hasTwoStepWithdraw;\n', '\tbool public hasThreeStepWithdraw;\n', '\tbool public hasFourStepWithdraw;\n', '\tbool public hasFiveStepWithdraw;\t\n', '\t\n', '    struct epoch  {\n', '        uint256 lockEndTime;\n', '        uint256 lockAmount;\n', '    }\n', '\n', '    mapping(address=>epoch[]) public lockEpochsMap;\n', '\t \n', '    mapping(address => uint256) balances;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\t\n', '\n', '\tfunction UNIT(){\n', '\t\ttotalSupply = 0 ;\n', '\t\ttotalCommonWithdrawSupply=0;\n', '\t\ttotalPartnerWithdrawSupply=0;\n', '\t\ttotalPublicFundingSupply = 0;\n', '\n', '\t\tstartTime = 1525104000;\n', '\t\tendTime = 1525104000;\n', '\t\trate=80000;\n', '\n', '\n', '\t\thasOneStepWithdraw=false;\n', '\t\thasTwoStepWithdraw=false;\n', '\t\thasThreeStepWithdraw=false;\n', '\t\thasFourStepWithdraw=false;\n', '\t\thasFiveStepWithdraw=false;\n', '\t}\n', '\n', '\tevent CreateUNIT(address indexed _to, uint256 _value);\n', '\n', '\n', '\tmodifier notReachTotalSupply(uint256 _value,uint256 _rate){\n', '\t\tassert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier notReachPublicFundingSupply(uint256 _value,uint256 _rate){\n', '\t\tassert(MAX_PUBLIC_FUNDING_SUPPLY>=totalPublicFundingSupply.add(_value.mul(_rate)));\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier notReachCommonWithdrawSupply(uint256 _value,uint256 _rate){\n', '\t\tassert(COMMON_WITHDRAW_SUPPLY>=totalCommonWithdrawSupply.add(_value.mul(_rate)));\n', '\t\t_;\n', '\t}\n', '\n', '\n', '\tmodifier notReachPartnerWithdrawSupply(uint256 _value,uint256 _rate){\n', '\t\tassert(PARTNER_SUPPLY>=totalPartnerWithdrawSupply.add(_value.mul(_rate)));\n', '\t\t_;\n', '\t}\n', '\n', '\n', '\tmodifier assertFalse(bool withdrawStatus){\n', '\t\tassert(!withdrawStatus);\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier notBeforeTime(uint256 targetTime){\n', '\t\tassert(now>targetTime);\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier notAfterTime(uint256 targetTime){\n', '\t\tassert(now<=targetTime);\n', '\t\t_;\n', '\t}\n', '\tfunction etherProceeds() external\n', '\t\tonlyOwner\n', '\n', '\t{\n', '\t\tif(!msg.sender.send(this.balance)) revert();\n', '\t}\n', '\n', '\tfunction processFunding(address receiver,uint256 _value,uint256 _rate) internal\n', '\t\tnotReachTotalSupply(_value,_rate)\n', '\t{\n', '\t\tuint256 amount=_value.mul(_rate);\n', '\t\ttotalSupply=totalSupply.add(amount);\n', '\t\tbalances[receiver] +=amount;\n', '\t\tCreateUNIT(receiver,amount);\n', '\t\tTransfer(0x0, receiver, amount);\n', '\t}\n', '\n', '\tfunction commonWithdraw(uint256 _value) external\n', '\t\tonlyOwner\n', '\t\tnotReachCommonWithdrawSupply(_value,1)\n', '\n', '\t{\n', '\t\tprocessFunding(msg.sender,_value,1);\n', '\t\ttotalCommonWithdrawSupply=totalCommonWithdrawSupply.add(_value);\n', '\t}\n', '\n', '\tfunction withdrawToPartner(address _to,uint256 _value) external\n', '\t\tonlyOwner\n', '\t\tnotReachPartnerWithdrawSupply(_value,1)\n', '\t{\n', '\t\tprocessFunding(_to,_value,1);\n', '\t\ttotalPartnerWithdrawSupply=totalPartnerWithdrawSupply.add(_value);\n', '\t\tlockBalance(_to,_value,1541865600);\n', '\t}\n', '\n', '\tfunction () payable external\n', '\t\tnotBeforeTime(startTime)\n', '\t\tnotAfterTime(endTime)\n', '\t\tnotReachPublicFundingSupply(msg.value,rate)\n', '\t{\n', '\t\trequire(publicFundingWhiteList[msg.sender]==1);\n', '\n', '\t\tprocessFunding(msg.sender,msg.value,rate);\n', '\t\tuint256 amount=msg.value.mul(rate);\n', '\t\ttotalPublicFundingSupply = totalPublicFundingSupply.add(amount);\n', '\n', '\t}\n', '\n', '\n', '\tfunction withdrawForOneStep() external\n', '\t\tonlyOwner\n', '\t\tassertFalse(hasOneStepWithdraw)\n', '\t\tnotBeforeTime(1525968000)\n', '\t{\n', '\t\tprocessFunding(msg.sender,TEAM_UNFREEZE,1);\n', '\t\thasOneStepWithdraw = true;\n', '\t}\n', '\n', '\t//20181111\n', '\tfunction withdrawForTwoStep() external\n', '\t\tonlyOwner\n', '\t\tassertFalse(hasTwoStepWithdraw)\n', '\t\tnotBeforeTime(1541865600)\n', '\t{\n', '\t\tprocessFunding(msg.sender,TEAM_UNFREEZE,1);\n', '\t\thasTwoStepWithdraw = true;\n', '\t}\n', '\n', '\t//20190511\n', '\tfunction withdrawForThreeStep() external\n', '\t\tonlyOwner\n', '\t\tassertFalse(hasThreeStepWithdraw)\n', '\t\tnotBeforeTime(1557504000)\n', '\t{\n', '\t\tprocessFunding(msg.sender,TEAM_UNFREEZE,1);\n', '\t\thasThreeStepWithdraw = true;\n', '\t}\n', '\n', '\t//20191111\n', '\tfunction withdrawForFourStep() external\n', '\t\tonlyOwner\n', '\t\tassertFalse(hasFourStepWithdraw)\n', '\t\tnotBeforeTime(1573401600)\n', '\t{\n', '\t\tprocessFunding(msg.sender,TEAM_UNFREEZE,1);\n', '\t\thasFourStepWithdraw = true;\n', '\t}\n', '\n', '\t//20200511\n', '\tfunction withdrawForFiveStep() external\n', '\t\tonlyOwner\n', '\t\tassertFalse(hasFiveStepWithdraw)\n', '\t\tnotBeforeTime(1589126400)\n', '\t{\n', '\t\tprocessFunding(msg.sender,TEAM_UNFREEZE,1);\n', '\t\thasFiveStepWithdraw = true;\n', '\t}\t\t\t\n', '\n', '\n', '  \tfunction transfer(address _to, uint256 _value) public  returns (bool)\n', ' \t{\n', '\t\trequire(_to != address(0));\n', '\n', '\t\tepoch[] epochs = lockEpochsMap[msg.sender];\n', '\t\tuint256 needLockBalance = 0;\n', '\t\tfor(uint256 i = 0;i<epochs.length;i++)\n', '\t\t{\n', '\t\t\tif( now < epochs[i].lockEndTime )\n', '\t\t\t{\n', '\t\t\t\tneedLockBalance=needLockBalance.add(epochs[i].lockAmount);\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\trequire(balances[msg.sender].sub(_value)>=needLockBalance);\n', '\n', '\t\t// SafeMath.sub will throw if there is not enough balance.\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tTransfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction balanceOf(address _owner) public constant returns (uint256 balance) \n', '  \t{\n', '\t\treturn balances[_owner];\n', '  \t}\n', '\n', '\n', '  \tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool) \n', '  \t{\n', '\t\trequire(_to != address(0));\n', '\n', '\t\tepoch[] epochs = lockEpochsMap[_from];\n', '\t\tuint256 needLockBalance = 0;\n', '\t\tfor(uint256 i = 0;i<epochs.length;i++)\n', '\t\t{\n', '\t\t\tif( now < epochs[i].lockEndTime )\n', '\t\t\t{\n', '\t\t\t\tneedLockBalance = needLockBalance.add(epochs[i].lockAmount);\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\trequire(balances[_from].sub(_value)>=needLockBalance);\n', '\n', '\t\tuint256 _allowance = allowed[_from][msg.sender];\n', '\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tallowed[_from][msg.sender] = _allowance.sub(_value);\n', '\t\tTransfer(_from, _to, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction approve(address _spender, uint256 _value) public returns (bool) \n', '  \t{\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction allowance(address _owner, address _spender) public constant returns (uint256 remaining) \n', '  \t{\n', '\t\treturn allowed[_owner][_spender];\n', '  \t}\n', '\n', '\tfunction lockBalance(address user, uint256 lockAmount,uint256 lockEndTime) internal\n', '\t{\n', '\t\t epoch[] storage epochs = lockEpochsMap[user];\n', '\t\t epochs.push(epoch(lockEndTime,lockAmount));\n', '\t}\n', '\n', '    function addPublicFundingWhiteList(address[] _list) external\n', '    \tonlyOwner\n', '    {\n', '        uint256 count = _list.length;\n', '        for (uint256 i = 0; i < count; i++) {\n', '        \tpublicFundingWhiteList[_list [i]] = 1;\n', '        }    \t\n', '    }\n', '\n', '\tfunction refreshRate(uint256 _rate) external\n', '\t\tonlyOwner\n', '\t{\n', '\t\trate=_rate;\n', '\t}\n', '\t\n', '    function refreshPublicFundingTime(uint256 _startTime,uint256 _endTime) external\n', '        onlyOwner\n', '    {\n', '\t\tstartTime=_startTime;\n', '\t\tendTime=_endTime;\n', '    }\n', '\n', '\t  \n', '}']