['pragma solidity ^0.4.24;\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract KAA is ERC20,Pausable{\n', '\tusing SafeMath for uint256;\n', '\n', '\t//the base info of the token\n', '\tstring public constant name="KAA";\n', '\tstring public constant symbol="KAA";\n', '\tstring public constant version = "1.0";\n', '\tuint256 public constant decimals = 18;\n', '\n', '\n', '\n', '\t//平台基金13395000000\n', '\tuint256 public constant PLATFORM_FUNDING_SUPPLY=13395000000*10**decimals;\n', '\n', '\n', '\t//创始团队13395000000\n', '\tuint256 public constant TEAM_KEEPING=13395000000*10**decimals;\n', '\n', '\t//战略伙伴8037000000\t\n', '\tuint256 public constant COOPERATE_REWARD=8037000000*10**decimals;\n', '\n', '\t//分享奖励8930000000\n', '\tuint256 public constant SHARDING_REWARD=8930000000*10**decimals;\n', '\n', '\t//挖矿奖励45543000000\n', '\tuint256 public constant MINING_REWARD=45543000000*10**decimals;\n', '\n', '\t//可普通提现额度8930000000+45543000000=54473000000\n', '\tuint256 public constant COMMON_WITHDRAW_SUPPLY=SHARDING_REWARD+MINING_REWARD;\n', '\n', '\n', '\t//总发行54473000000+13395000000+13395000000+8037000000=89300000000\n', '\tuint256 public constant MAX_SUPPLY=COMMON_WITHDRAW_SUPPLY+PLATFORM_FUNDING_SUPPLY+TEAM_KEEPING+COOPERATE_REWARD;\n', '\n', '\t//内部锁仓基准时间\n', '\tuint256 public innerlockStartTime;\n', '\t//外部锁仓基准时间\n', '\tuint256 public outterlockStartTime;\n', '\t//解锁步长（30天）\n', '\tuint256 public unlockStepLong;\n', '\n', '\t//平台已提现\n', '\tuint256 public platformFundingSupply;\n', '\t//平台每期可提现\n', '\tuint256 public platformFundingPerEpoch;\n', '\n', '\t//团队已提现\n', '\tuint256 public teamKeepingSupply;\n', '\t//团队每期可提现\n', '\tuint256 public teamKeepingPerEpoch;\n', '\n', '\t//战略伙伴已经分发额度\n', '\tuint256 public cooperateRewardSupply;\n', '\n', '\n', '\t//已经普通提现量\n', '\tuint256 public totalCommonWithdrawSupply;\n', '\n', '    //战略伙伴锁仓总额度\n', '    mapping(address=>uint256) public lockAmount;\n', '\t \n', '\t//ERC20的余额\n', '    mapping(address => uint256) balances;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\t\n', '\n', '     constructor() public{\n', '\t\ttotalSupply = 0 ;\n', '\n', '\t\tplatformFundingSupply=0;\n', '\t\tteamKeepingSupply=0;\n', '\t\tcooperateRewardSupply=0;\n', '\t\ttotalCommonWithdrawSupply=0;\n', '\n', '\t\t//分12期解锁 13395000000/12\n', '\t\tplatformFundingPerEpoch=1116250000*10**decimals;\n', '\t\tteamKeepingPerEpoch=1116250000*10**decimals;\n', '\n', '\n', '\t\t//初始时间 20210818\n', '\t\tinnerlockStartTime = 1629216000;\n', '\t\t//初始时间 20190818\n', '\t\toutterlockStartTime=1566057600;\n', '\n', '\t\tunlockStepLong=2592000;\n', '\n', '\t}\n', '\n', '\tevent CreateKAA(address indexed _to, uint256 _value);\n', '\n', '\n', '\tmodifier notReachTotalSupply(uint256 _value){\n', '\t\tassert(MAX_SUPPLY>=totalSupply.add(_value));\n', '\t\t_;\n', '\t}\n', '\n', '\t//平台最大提现额度\n', '\tmodifier notReachPlatformFundingSupply(uint256 _value){\n', '\t\tassert(PLATFORM_FUNDING_SUPPLY>=platformFundingSupply.add(_value));\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier notReachTeamKeepingSupply(uint256 _value){\n', '\t\tassert(TEAM_KEEPING>=teamKeepingSupply.add(_value));\n', '\t\t_;\n', '\t}\n', '\n', '\n', '\tmodifier notReachCooperateRewardSupply(uint256 _value){\n', '\t\tassert(COOPERATE_REWARD>=cooperateRewardSupply.add(_value));\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier notReachCommonWithdrawSupply(uint256 _value){\n', '\t\tassert(COMMON_WITHDRAW_SUPPLY>=totalCommonWithdrawSupply.add(_value));\n', '\t\t_;\n', '\t}\n', '\n', '\n', '\n', '\t//统一代币分发函数，内部使用\n', '\tfunction processFunding(address receiver,uint256 _value) internal\n', '\t\tnotReachTotalSupply(_value)\n', '\t{\n', '\t\ttotalSupply=totalSupply.add(_value);\n', '\t\tbalances[receiver]=balances[receiver].add(_value);\n', '\t\temit CreateKAA(receiver,_value);\n', '\t\temit Transfer(0x0, receiver, _value);\n', '\t}\n', '\n', '\n', '\n', '\t//普通分发,给分享和挖矿使用\n', '\tfunction commonWithdraw(uint256 _value) external\n', '\t\tonlyOwner\n', '\t\tnotReachCommonWithdrawSupply(_value)\n', '\n', '\t{\n', '\t\tprocessFunding(msg.sender,_value);\n', '\t\t//增加已经普通提现份额\n', '\t\ttotalCommonWithdrawSupply=totalCommonWithdrawSupply.add(_value);\n', '\t}\n', '\n', '\n', '\t//平台基金提币（不持币锁仓，12期释放）\n', '\tfunction withdrawToPlatformFunding(uint256 _value) external\n', '\t\tonlyOwner\n', '\t\tnotReachPlatformFundingSupply(_value)\n', '\t{\n', '\t\t//判断可提现额度是否足够\n', '\t\tif (!canPlatformFundingWithdraw(_value)) {\n', '\t\t\trevert();\n', '\t\t}else{\n', '\t\t\tprocessFunding(msg.sender,_value);\n', '\t\t\t//平台已提现额度\n', '\t\t\tplatformFundingSupply=platformFundingSupply.add(_value);\n', '\t\t}\n', '\n', '\t}\t\n', '\n', '\t//团队提币（不持币锁仓，12期释放）\n', '\tfunction withdrawToTeam(uint256 _value) external\n', '\t\tonlyOwner\n', '\t\tnotReachTeamKeepingSupply(_value)\t\n', '\t{\n', '\t\t//判断可提现额度是否足够\n', '\t\tif (!canTeamKeepingWithdraw(_value)) {\n', '\t\t\trevert();\n', '\t\t}else{\n', '\t\t\tprocessFunding(msg.sender,_value);\n', '\t\t\t//团队已提现额度\n', '\t\t\tteamKeepingSupply=teamKeepingSupply.add(_value);\n', '\t\t}\n', '\t}\n', '\n', '\t//提币给战略伙伴（持币锁仓，12期释放）\n', '\tfunction withdrawToCooperate(address _to,uint256 _value) external\n', '\t\tonlyOwner\n', '\t\tnotReachCooperateRewardSupply(_value)\n', '\t{\n', '\t\tprocessFunding(_to,_value);\n', '\t\tcooperateRewardSupply=cooperateRewardSupply.add(_value);\n', '\n', '\t\t//记录分发份额\n', '\t\tlockAmount[_to]=lockAmount[_to].add(_value);\n', '\t}\n', '\n', '\t//平台是否可提现\n', '\tfunction canPlatformFundingWithdraw(uint256 _value)public view returns (bool) {\n', '\t\t//如果小于基准时间，直接返回false\n', '\t\tif(queryNow()<innerlockStartTime){\n', '\t\t\treturn false;\n', '\t\t}\n', '\n', '\t\t//当前期数=（现时间-初始时间)/期数步长\n', '\t\tuint256 epoch=queryNow().sub(innerlockStartTime).div(unlockStepLong);\n', '\t\t//如果超出12期时间，那么就设置为12\n', '\t\tif (epoch>12) {\n', '\t\t\tepoch=12;\n', '\t\t}\n', '\n', '\t\t//计算已经释放额度 = 每期可提现额度*期数\n', '\t\tuint256 releaseAmount = platformFundingPerEpoch.mul(epoch);\n', '\t\t//计算可提现额度=已经释放额度-已经提现额度\n', '\t\tuint256 canWithdrawAmount=releaseAmount.sub(platformFundingSupply);\n', '\t\tif(canWithdrawAmount>=_value){\n', '\t\t\treturn true;\n', '\t\t}else{\n', '\t\t\treturn false;\n', '\t\t}\n', '\t}\n', '\n', '\tfunction canTeamKeepingWithdraw(uint256 _value)public view returns (bool) {\n', '\t\t//如果小于基准时间，直接返回false\n', '\t\tif(queryNow()<innerlockStartTime){\n', '\t\t\treturn false;\n', '\t\t}\n', '\n', '\t\t//当前期数=（现时间-初始时间)/期数步长\n', '\t\tuint256 epoch=queryNow().sub(innerlockStartTime).div(unlockStepLong);\n', '\t\t//如果超出12期时间，那么就设置为12\n', '\t\tif (epoch>12) {\n', '\t\t\tepoch=12;\n', '\t\t}\n', '\n', '\t\t//计算已经释放额度 = 每期可提现额度*期数\n', '\t\tuint256 releaseAmount=teamKeepingPerEpoch.mul(epoch);\n', '\t\t//计算可提现额度=已经释放额度-已经提现额度\n', '\t\tuint256 canWithdrawAmount=releaseAmount.sub(teamKeepingSupply);\n', '\t\tif(canWithdrawAmount>=_value){\n', '\t\t\treturn true;\n', '\t\t}else{\n', '\t\t\treturn false;\n', '\t\t}\n', '\t}\n', '\n', '\n', '\tfunction clacCooperateNeedLockAmount(uint256 totalLockAmount)public view returns (uint256) {\n', '\t\t//如果小于基准时间，直接返回最大锁仓量\n', '\t\tif(queryNow()<outterlockStartTime){\n', '\t\t\treturn totalLockAmount;\n', '\t\t}\t\t\n', '\t\t\n', '\t\t//当前期数=（现时间-初始时间)/期数步长\n', '\t\tuint256 epoch=queryNow().sub(outterlockStartTime).div(unlockStepLong);\n', '\t\t//如果超出12期时间，那么就设置为12\n', '\t\tif (epoch>12) {\n', '\t\t\tepoch=12;\n', '\t\t}\n', '\n', '\t\t//剩余期数\n', '\t\tuint256 remainingEpoch=uint256(12).sub(epoch);\n', '\n', '\t\t//计算每期可释放转账额度（总分发额度/12）\n', '\t\tuint256 cooperatePerEpoch= totalLockAmount.div(12);\n', '\n', '\t\t//计算剩余锁仓额度（每期可释放转账额度*剩余期数）\n', '\t\treturn cooperatePerEpoch.mul(remainingEpoch);\n', '\t}\n', '    function queryNow() public view returns(uint256){\n', '        return now;\n', '    }\n', '\tfunction () payable external\n', '\t{\n', '\t\trevert();\n', '\t}\n', '\n', '\n', '\n', '  //转账前，先校验减去转出份额后，是否大于等于锁仓份额\n', '  \tfunction transfer(address _to, uint256 _value) public whenNotPaused returns (bool)\n', ' \t{\n', '\t\trequire(_to != address(0));\n', '\n', '\t\t//计算锁仓份额\n', '\t\tuint256 needLockBalance=0;\n', '\t\tif (lockAmount[msg.sender]>0) {\n', '\t\t\tneedLockBalance=clacCooperateNeedLockAmount(lockAmount[msg.sender]);\n', '\t\t}\n', '\n', '\n', '\t\trequire(balances[msg.sender].sub(_value)>=needLockBalance);\n', '\n', '\t\t// SafeMath.sub will throw if there is not enough balance.\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\temit Transfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction balanceOf(address _owner) public constant returns (uint256 balance) \n', '  \t{\n', '\t\treturn balances[_owner];\n', '  \t}\n', '\n', '\n', '  //从委托人账上转出份额时，还要判断委托人的余额-转出份额是否大于等于锁仓份额\n', '  \tfunction transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) \n', '  \t{\n', '\t\trequire(_to != address(0));\n', '\n', '\t\t//计算锁仓份额\n', '\t\tuint256 needLockBalance=0;\n', '\t\tif (lockAmount[_from]>0) {\n', '\t\t\tneedLockBalance=clacCooperateNeedLockAmount(lockAmount[_from]);\n', '\t\t}\n', '\n', '\n', '\t\trequire(balances[_from].sub(_value)>=needLockBalance);\n', '\n', '\t\tuint256 _allowance = allowed[_from][msg.sender];\n', '\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tallowed[_from][msg.sender] = _allowance.sub(_value);\n', '\t\temit Transfer(_from, _to, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction approve(address _spender, uint256 _value) public whenNotPaused returns (bool) \n', '  \t{\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\temit Approval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction allowance(address _owner, address _spender) public constant returns (uint256 remaining) \n', '  \t{\n', '\t\treturn allowed[_owner][_spender];\n', '  \t}\n', '\t  \n', '}']