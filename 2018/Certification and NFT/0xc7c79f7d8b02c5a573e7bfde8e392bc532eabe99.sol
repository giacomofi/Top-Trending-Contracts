['pragma solidity ^0.4.23;\n', '\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender)\n', '        public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '    );\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract DefaultToken is BasicToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '\n', '\n', '// Wings Controller Interface\n', 'contract IWingsController {\n', '  uint256 public ethRewardPart;\n', '  uint256 public tokenRewardPart;\n', '\n', '  function fitCollectedValueIntoRange(uint256 _totalCollected) public view returns (uint256);\n', '}\n', '\n', '\n', 'contract HasManager {\n', '  address public manager;\n', '\n', '  modifier onlyManager {\n', '    require(msg.sender == manager);\n', '    _;\n', '  }\n', '\n', '  function transferManager(address _newManager) public onlyManager() {\n', '    require(_newManager != address(0));\n', '    manager = _newManager;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '// Crowdsale contracts interface\n', 'contract ICrowdsaleProcessor is Ownable, HasManager {\n', '  modifier whenCrowdsaleAlive() {\n', '    require(isActive());\n', '    _;\n', '  }\n', '\n', '  modifier whenCrowdsaleFailed() {\n', '    require(isFailed());\n', '    _;\n', '  }\n', '\n', '  modifier whenCrowdsaleSuccessful() {\n', '    require(isSuccessful());\n', '    _;\n', '  }\n', '\n', '  modifier hasntStopped() {\n', '    require(!stopped);\n', '    _;\n', '  }\n', '\n', '  modifier hasBeenStopped() {\n', '    require(stopped);\n', '    _;\n', '  }\n', '\n', '  modifier hasntStarted() {\n', '    require(!started);\n', '    _;\n', '  }\n', '\n', '  modifier hasBeenStarted() {\n', '    require(started);\n', '    _;\n', '  }\n', '\n', '  // Minimal acceptable hard cap\n', '  uint256 constant public MIN_HARD_CAP = 1 ether;\n', '\n', '  // Minimal acceptable duration of crowdsale\n', '  uint256 constant public MIN_CROWDSALE_TIME = 3 days;\n', '\n', '  // Maximal acceptable duration of crowdsale\n', '  uint256 constant public MAX_CROWDSALE_TIME = 50 days;\n', '\n', '  // Becomes true when timeframe is assigned\n', '  bool public started;\n', '\n', '  // Becomes true if cancelled by owner\n', '  bool public stopped;\n', '\n', '  // Total collected forecast question currency\n', '  uint256 public totalCollected;\n', '\n', '  // Total collected Ether\n', '  uint256 public totalCollectedETH;\n', '\n', '  // Total amount of project&#39;s token sold: must be updated every time tokens has been sold\n', '  uint256 public totalSold;\n', '\n', '  // Crowdsale minimal goal, must be greater or equal to Forecasting min amount\n', '  uint256 public minimalGoal;\n', '\n', '  // Crowdsale hard cap, must be less or equal to Forecasting max amount\n', '  uint256 public hardCap;\n', '\n', '  // Crowdsale duration in seconds.\n', '  // Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.\n', '  uint256 public duration;\n', '\n', '  // Start timestamp of crowdsale, absolute UTC time\n', '  uint256 public startTimestamp;\n', '\n', '  // End timestamp of crowdsale, absolute UTC time\n', '  uint256 public endTimestamp;\n', '\n', '  // Allows to transfer some ETH into the contract without selling tokens\n', '  function deposit() public payable {}\n', '\n', '  // Returns address of crowdsale token, must be ERC20 compilant\n', '  function getToken() public returns(address);\n', '\n', '  // Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract\n', '  function mintETHRewards(address _contract, uint256 _amount) public onlyManager();\n', '\n', '  // Mints token Rewards to Forecasting contract\n', '  function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();\n', '\n', '  // Releases tokens (transfers crowdsale token from mintable to transferrable state)\n', '  function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful();\n', '\n', '  // Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.\n', '  // Crowdsale may be stopped any time before it finishes.\n', '  function stop() public onlyManager() hasntStopped();\n', '\n', '  // Validates parameters and starts crowdsale\n', '  function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress)\n', '    public onlyManager() hasntStarted() hasntStopped();\n', '\n', '  // Is crowdsale failed (completed, but minimal goal wasn&#39;t reached)\n', '  function isFailed() public constant returns (bool);\n', '\n', '  // Is crowdsale active (i.e. the token can be sold)\n', '  function isActive() public constant returns (bool);\n', '\n', '  // Is crowdsale completed successfully\n', '  function isSuccessful() public constant returns (bool);\n', '}\n', '\n', '\n', '// Basic crowdsale implementation both for regualt and 3rdparty Crowdsale contracts\n', 'contract BasicCrowdsale is ICrowdsaleProcessor {\n', '  event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);\n', '\n', '  // Where to transfer collected ETH\n', '  address public fundingAddress;\n', '\n', '  // Ctor.\n', '  function BasicCrowdsale(\n', '    address _owner,\n', '    address _manager\n', '  )\n', '    public\n', '  {\n', '    owner = _owner;\n', '    manager = _manager;\n', '  }\n', '\n', '  // called by CrowdsaleController to transfer reward part of ETH\n', '  // collected by successful crowdsale to Forecasting contract.\n', '  // This call is made upon closing successful crowdfunding process\n', '  // iff agreed ETH reward part is not zero\n', '  function mintETHRewards(\n', '    address _contract,  // Forecasting contract\n', '    uint256 _amount     // agreed part of totalCollected which is intended for rewards\n', '  )\n', '    public\n', '    onlyManager() // manager is CrowdsaleController instance\n', '  {\n', '    require(_contract.call.value(_amount)());\n', '  }\n', '\n', '  // cancels crowdsale\n', '  function stop() public onlyManager() hasntStopped()  {\n', '    // we can stop only not started and not completed crowdsale\n', '    if (started) {\n', '      require(!isFailed());\n', '      require(!isSuccessful());\n', '    }\n', '    stopped = true;\n', '  }\n', '\n', '  // called by CrowdsaleController to setup start and end time of crowdfunding process\n', '  // as well as funding address (where to transfer ETH upon successful crowdsale)\n', '  function start(\n', '    uint256 _startTimestamp,\n', '    uint256 _endTimestamp,\n', '    address _fundingAddress\n', '  )\n', '    public\n', '    onlyManager()   // manager is CrowdsaleController instance\n', '    hasntStarted()  // not yet started\n', '    hasntStopped()  // crowdsale wasn&#39;t cancelled\n', '  {\n', '    require(_fundingAddress != address(0));\n', '\n', '    // start time must not be earlier than current time\n', '    require(_startTimestamp >= block.timestamp);\n', '\n', '    // range must be sane\n', '    require(_endTimestamp > _startTimestamp);\n', '    duration = _endTimestamp - _startTimestamp;\n', '\n', '    // duration must fit constraints\n', '    require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);\n', '\n', '    startTimestamp = _startTimestamp;\n', '    endTimestamp = _endTimestamp;\n', '    fundingAddress = _fundingAddress;\n', '\n', '    // now crowdsale is considered started, even if the current time is before startTimestamp\n', '    started = true;\n', '\n', '    CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);\n', '  }\n', '\n', '  // must return true if crowdsale is over, but it failed\n', '  function isFailed()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // it was started\n', '      started &&\n', '\n', '      // crowdsale period has finished\n', '      block.timestamp >= endTimestamp &&\n', '\n', '      // but collected ETH is below the required minimum\n', '      totalCollected < minimalGoal\n', '    );\n', '  }\n', '\n', '  // must return true if crowdsale is active (i.e. the token can be bought)\n', '  function isActive()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // it was started\n', '      started &&\n', '\n', '      // hard cap wasn&#39;t reached yet\n', '      totalCollected < hardCap &&\n', '\n', '      // and current time is within the crowdfunding period\n', '      block.timestamp >= startTimestamp &&\n', '      block.timestamp < endTimestamp\n', '    );\n', '  }\n', '\n', '  // must return true if crowdsale completed successfully\n', '  function isSuccessful()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // either the hard cap is collected\n', '      totalCollected >= hardCap ||\n', '\n', '      // ...or the crowdfunding period is over, but the minimum has been reached\n', '      (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)\n', '    );\n', '  }\n', '}\n', '\n', '\n', '/*\n', '  Standalone Bridge\n', '*/\n', 'contract Bridge is BasicCrowdsale {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  event CUSTOM_CROWDSALE_TOKEN_ADDED(address token, uint8 decimals);\n', '  event CUSTOM_CROWDSALE_FINISH();\n', '\n', '  // Crowdsale token must be ERC20-compliant\n', '  DefaultToken token;\n', '\n', '  // Crowdsale state\n', '  bool completed;\n', '\n', '  // Constructor\n', '  constructor(\n', '    //uint256 _minimalGoal,\n', '    //uint256 _hardCap,\n', '    //address _token\n', '  ) public\n', '    BasicCrowdsale(msg.sender, msg.sender) // owner, manager\n', '  {\n', '    minimalGoal = 1;\n', '    hardCap = 1;\n', '    token = DefaultToken(0x9998Db897783603c9344ED2678AB1B5D73d0f7C3);\n', '  }\n', '\n', '  /*\n', '     Here goes ICrowdsaleProcessor methods implementation\n', '  */\n', '\n', '  // Returns address of crowdsale token\n', '  function getToken()\n', '    public\n', '    returns (address)\n', '  {\n', '    return address(token);\n', '  }\n', '\n', '  // Mints token Rewards to Forecasting contract\n', '  // called by CrowdsaleController\n', '  function mintTokenRewards(\n', '    address _contract,\n', '    uint256 _amount    // agreed part of totalSold which is intended for rewards\n', '  )\n', '    public\n', '    onlyManager()\n', '  {\n', '    // in our example we are transferring tokens instead of minting them\n', '    token.transfer(_contract, _amount);\n', '  }\n', '\n', '  function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful() {\n', '  }\n', '\n', '  /*\n', '     Crowdsale methods implementation\n', '  */\n', '\n', '  // Fallback payable function\n', '  function() public payable {\n', '  }\n', '\n', '  // Update information about collected ETH and sold tokens amount\n', '  function notifySale(uint256 _amount, uint256 _ethAmount, uint256 _tokensAmount)\n', '    public\n', '    hasBeenStarted()\n', '    hasntStopped()\n', '    whenCrowdsaleAlive()\n', '    onlyOwner()\n', '  {\n', '    totalCollected = totalCollected.add(_amount);\n', '    totalCollectedETH = totalCollectedETH.add(_ethAmount);\n', '    totalSold = totalSold.add(_tokensAmount);\n', '  }\n', '\n', '  // Validates parameters and starts crowdsale\n', '  // called by CrowdsaleController\n', '  function start(\n', '    uint256 _startTimestamp,\n', '    uint256 _endTimestamp,\n', '    address _fundingAddress\n', '  )\n', '    public\n', '    hasntStarted()\n', '    hasntStopped()\n', '    onlyManager()\n', '  {\n', '    started = true;\n', '\n', '    emit CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);\n', '  }\n', '\n', '  // Finish crowdsale\n', '  function finish()\n', '    public\n', '    hasntStopped()\n', '    hasBeenStarted()\n', '    whenCrowdsaleAlive()\n', '    onlyOwner()\n', '  {\n', '    completed = true;\n', '\n', '    emit CUSTOM_CROWDSALE_FINISH();\n', '  }\n', '\n', '  function isFailed()\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return (false);\n', '  }\n', '\n', '  function isActive()\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return (started && !completed);\n', '  }\n', '\n', '  function isSuccessful()\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return (completed);\n', '  }\n', '\n', '  // Find out the amount of rewards in ETH and tokens\n', '  function calculateRewards() public view returns (uint256, uint256) {\n', '    uint256 tokenRewardPart = IWingsController(manager).tokenRewardPart();\n', '    uint256 ethRewardPart = IWingsController(manager).ethRewardPart();\n', '    uint256 ethReward;\n', '    bool hasEthReward = (ethRewardPart != 0);\n', '\n', '    uint256 tokenReward = totalSold.mul(tokenRewardPart) / 1000000;\n', '\n', '    if (totalCollectedETH != 0) {\n', '      totalCollected = totalCollectedETH;\n', '    }\n', '\n', '    totalCollected = IWingsController(manager).fitCollectedValueIntoRange(totalCollected);\n', '\n', '    if (hasEthReward) {\n', '      ethReward = totalCollected.mul(ethRewardPart) / 1000000;\n', '    }\n', '\n', '    return (ethReward, tokenReward);\n', '  }\n', '\n', '  // Change token address (in case you&#39;ve used the dafault token address during bridge deployment)\n', '  function changeToken(address _newToken) public onlyOwner() {\n', '    token = DefaultToken(_newToken);\n', '\n', '    emit CUSTOM_CROWDSALE_TOKEN_ADDED(address(token), uint8(token.decimals()));\n', '  }\n', '\n', '  // Gives owner ability to withdraw eth and wings from Bridge contract balance in case if some error during reward calculation occured\n', '  function withdraw() public onlyOwner() {\n', '    uint256 ethBalance = address(this).balance;\n', '    uint256 tokenBalance = token.balanceOf(address(this));\n', '\n', '    if (ethBalance > 0) {\n', '      require(msg.sender.send(ethBalance));\n', '    }\n', '\n', '    if (tokenBalance > 0) {\n', '      require(token.transfer(msg.sender, tokenBalance));\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender)\n', '        public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '    );\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract DefaultToken is BasicToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '\n', '\n', '// Wings Controller Interface\n', 'contract IWingsController {\n', '  uint256 public ethRewardPart;\n', '  uint256 public tokenRewardPart;\n', '\n', '  function fitCollectedValueIntoRange(uint256 _totalCollected) public view returns (uint256);\n', '}\n', '\n', '\n', 'contract HasManager {\n', '  address public manager;\n', '\n', '  modifier onlyManager {\n', '    require(msg.sender == manager);\n', '    _;\n', '  }\n', '\n', '  function transferManager(address _newManager) public onlyManager() {\n', '    require(_newManager != address(0));\n', '    manager = _newManager;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '\n', '// Crowdsale contracts interface\n', 'contract ICrowdsaleProcessor is Ownable, HasManager {\n', '  modifier whenCrowdsaleAlive() {\n', '    require(isActive());\n', '    _;\n', '  }\n', '\n', '  modifier whenCrowdsaleFailed() {\n', '    require(isFailed());\n', '    _;\n', '  }\n', '\n', '  modifier whenCrowdsaleSuccessful() {\n', '    require(isSuccessful());\n', '    _;\n', '  }\n', '\n', '  modifier hasntStopped() {\n', '    require(!stopped);\n', '    _;\n', '  }\n', '\n', '  modifier hasBeenStopped() {\n', '    require(stopped);\n', '    _;\n', '  }\n', '\n', '  modifier hasntStarted() {\n', '    require(!started);\n', '    _;\n', '  }\n', '\n', '  modifier hasBeenStarted() {\n', '    require(started);\n', '    _;\n', '  }\n', '\n', '  // Minimal acceptable hard cap\n', '  uint256 constant public MIN_HARD_CAP = 1 ether;\n', '\n', '  // Minimal acceptable duration of crowdsale\n', '  uint256 constant public MIN_CROWDSALE_TIME = 3 days;\n', '\n', '  // Maximal acceptable duration of crowdsale\n', '  uint256 constant public MAX_CROWDSALE_TIME = 50 days;\n', '\n', '  // Becomes true when timeframe is assigned\n', '  bool public started;\n', '\n', '  // Becomes true if cancelled by owner\n', '  bool public stopped;\n', '\n', '  // Total collected forecast question currency\n', '  uint256 public totalCollected;\n', '\n', '  // Total collected Ether\n', '  uint256 public totalCollectedETH;\n', '\n', "  // Total amount of project's token sold: must be updated every time tokens has been sold\n", '  uint256 public totalSold;\n', '\n', '  // Crowdsale minimal goal, must be greater or equal to Forecasting min amount\n', '  uint256 public minimalGoal;\n', '\n', '  // Crowdsale hard cap, must be less or equal to Forecasting max amount\n', '  uint256 public hardCap;\n', '\n', '  // Crowdsale duration in seconds.\n', '  // Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.\n', '  uint256 public duration;\n', '\n', '  // Start timestamp of crowdsale, absolute UTC time\n', '  uint256 public startTimestamp;\n', '\n', '  // End timestamp of crowdsale, absolute UTC time\n', '  uint256 public endTimestamp;\n', '\n', '  // Allows to transfer some ETH into the contract without selling tokens\n', '  function deposit() public payable {}\n', '\n', '  // Returns address of crowdsale token, must be ERC20 compilant\n', '  function getToken() public returns(address);\n', '\n', '  // Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract\n', '  function mintETHRewards(address _contract, uint256 _amount) public onlyManager();\n', '\n', '  // Mints token Rewards to Forecasting contract\n', '  function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();\n', '\n', '  // Releases tokens (transfers crowdsale token from mintable to transferrable state)\n', '  function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful();\n', '\n', '  // Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.\n', '  // Crowdsale may be stopped any time before it finishes.\n', '  function stop() public onlyManager() hasntStopped();\n', '\n', '  // Validates parameters and starts crowdsale\n', '  function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress)\n', '    public onlyManager() hasntStarted() hasntStopped();\n', '\n', "  // Is crowdsale failed (completed, but minimal goal wasn't reached)\n", '  function isFailed() public constant returns (bool);\n', '\n', '  // Is crowdsale active (i.e. the token can be sold)\n', '  function isActive() public constant returns (bool);\n', '\n', '  // Is crowdsale completed successfully\n', '  function isSuccessful() public constant returns (bool);\n', '}\n', '\n', '\n', '// Basic crowdsale implementation both for regualt and 3rdparty Crowdsale contracts\n', 'contract BasicCrowdsale is ICrowdsaleProcessor {\n', '  event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);\n', '\n', '  // Where to transfer collected ETH\n', '  address public fundingAddress;\n', '\n', '  // Ctor.\n', '  function BasicCrowdsale(\n', '    address _owner,\n', '    address _manager\n', '  )\n', '    public\n', '  {\n', '    owner = _owner;\n', '    manager = _manager;\n', '  }\n', '\n', '  // called by CrowdsaleController to transfer reward part of ETH\n', '  // collected by successful crowdsale to Forecasting contract.\n', '  // This call is made upon closing successful crowdfunding process\n', '  // iff agreed ETH reward part is not zero\n', '  function mintETHRewards(\n', '    address _contract,  // Forecasting contract\n', '    uint256 _amount     // agreed part of totalCollected which is intended for rewards\n', '  )\n', '    public\n', '    onlyManager() // manager is CrowdsaleController instance\n', '  {\n', '    require(_contract.call.value(_amount)());\n', '  }\n', '\n', '  // cancels crowdsale\n', '  function stop() public onlyManager() hasntStopped()  {\n', '    // we can stop only not started and not completed crowdsale\n', '    if (started) {\n', '      require(!isFailed());\n', '      require(!isSuccessful());\n', '    }\n', '    stopped = true;\n', '  }\n', '\n', '  // called by CrowdsaleController to setup start and end time of crowdfunding process\n', '  // as well as funding address (where to transfer ETH upon successful crowdsale)\n', '  function start(\n', '    uint256 _startTimestamp,\n', '    uint256 _endTimestamp,\n', '    address _fundingAddress\n', '  )\n', '    public\n', '    onlyManager()   // manager is CrowdsaleController instance\n', '    hasntStarted()  // not yet started\n', "    hasntStopped()  // crowdsale wasn't cancelled\n", '  {\n', '    require(_fundingAddress != address(0));\n', '\n', '    // start time must not be earlier than current time\n', '    require(_startTimestamp >= block.timestamp);\n', '\n', '    // range must be sane\n', '    require(_endTimestamp > _startTimestamp);\n', '    duration = _endTimestamp - _startTimestamp;\n', '\n', '    // duration must fit constraints\n', '    require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);\n', '\n', '    startTimestamp = _startTimestamp;\n', '    endTimestamp = _endTimestamp;\n', '    fundingAddress = _fundingAddress;\n', '\n', '    // now crowdsale is considered started, even if the current time is before startTimestamp\n', '    started = true;\n', '\n', '    CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);\n', '  }\n', '\n', '  // must return true if crowdsale is over, but it failed\n', '  function isFailed()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // it was started\n', '      started &&\n', '\n', '      // crowdsale period has finished\n', '      block.timestamp >= endTimestamp &&\n', '\n', '      // but collected ETH is below the required minimum\n', '      totalCollected < minimalGoal\n', '    );\n', '  }\n', '\n', '  // must return true if crowdsale is active (i.e. the token can be bought)\n', '  function isActive()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // it was started\n', '      started &&\n', '\n', "      // hard cap wasn't reached yet\n", '      totalCollected < hardCap &&\n', '\n', '      // and current time is within the crowdfunding period\n', '      block.timestamp >= startTimestamp &&\n', '      block.timestamp < endTimestamp\n', '    );\n', '  }\n', '\n', '  // must return true if crowdsale completed successfully\n', '  function isSuccessful()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // either the hard cap is collected\n', '      totalCollected >= hardCap ||\n', '\n', '      // ...or the crowdfunding period is over, but the minimum has been reached\n', '      (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)\n', '    );\n', '  }\n', '}\n', '\n', '\n', '/*\n', '  Standalone Bridge\n', '*/\n', 'contract Bridge is BasicCrowdsale {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  event CUSTOM_CROWDSALE_TOKEN_ADDED(address token, uint8 decimals);\n', '  event CUSTOM_CROWDSALE_FINISH();\n', '\n', '  // Crowdsale token must be ERC20-compliant\n', '  DefaultToken token;\n', '\n', '  // Crowdsale state\n', '  bool completed;\n', '\n', '  // Constructor\n', '  constructor(\n', '    //uint256 _minimalGoal,\n', '    //uint256 _hardCap,\n', '    //address _token\n', '  ) public\n', '    BasicCrowdsale(msg.sender, msg.sender) // owner, manager\n', '  {\n', '    minimalGoal = 1;\n', '    hardCap = 1;\n', '    token = DefaultToken(0x9998Db897783603c9344ED2678AB1B5D73d0f7C3);\n', '  }\n', '\n', '  /*\n', '     Here goes ICrowdsaleProcessor methods implementation\n', '  */\n', '\n', '  // Returns address of crowdsale token\n', '  function getToken()\n', '    public\n', '    returns (address)\n', '  {\n', '    return address(token);\n', '  }\n', '\n', '  // Mints token Rewards to Forecasting contract\n', '  // called by CrowdsaleController\n', '  function mintTokenRewards(\n', '    address _contract,\n', '    uint256 _amount    // agreed part of totalSold which is intended for rewards\n', '  )\n', '    public\n', '    onlyManager()\n', '  {\n', '    // in our example we are transferring tokens instead of minting them\n', '    token.transfer(_contract, _amount);\n', '  }\n', '\n', '  function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful() {\n', '  }\n', '\n', '  /*\n', '     Crowdsale methods implementation\n', '  */\n', '\n', '  // Fallback payable function\n', '  function() public payable {\n', '  }\n', '\n', '  // Update information about collected ETH and sold tokens amount\n', '  function notifySale(uint256 _amount, uint256 _ethAmount, uint256 _tokensAmount)\n', '    public\n', '    hasBeenStarted()\n', '    hasntStopped()\n', '    whenCrowdsaleAlive()\n', '    onlyOwner()\n', '  {\n', '    totalCollected = totalCollected.add(_amount);\n', '    totalCollectedETH = totalCollectedETH.add(_ethAmount);\n', '    totalSold = totalSold.add(_tokensAmount);\n', '  }\n', '\n', '  // Validates parameters and starts crowdsale\n', '  // called by CrowdsaleController\n', '  function start(\n', '    uint256 _startTimestamp,\n', '    uint256 _endTimestamp,\n', '    address _fundingAddress\n', '  )\n', '    public\n', '    hasntStarted()\n', '    hasntStopped()\n', '    onlyManager()\n', '  {\n', '    started = true;\n', '\n', '    emit CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);\n', '  }\n', '\n', '  // Finish crowdsale\n', '  function finish()\n', '    public\n', '    hasntStopped()\n', '    hasBeenStarted()\n', '    whenCrowdsaleAlive()\n', '    onlyOwner()\n', '  {\n', '    completed = true;\n', '\n', '    emit CUSTOM_CROWDSALE_FINISH();\n', '  }\n', '\n', '  function isFailed()\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return (false);\n', '  }\n', '\n', '  function isActive()\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return (started && !completed);\n', '  }\n', '\n', '  function isSuccessful()\n', '    public\n', '    view\n', '    returns (bool)\n', '  {\n', '    return (completed);\n', '  }\n', '\n', '  // Find out the amount of rewards in ETH and tokens\n', '  function calculateRewards() public view returns (uint256, uint256) {\n', '    uint256 tokenRewardPart = IWingsController(manager).tokenRewardPart();\n', '    uint256 ethRewardPart = IWingsController(manager).ethRewardPart();\n', '    uint256 ethReward;\n', '    bool hasEthReward = (ethRewardPart != 0);\n', '\n', '    uint256 tokenReward = totalSold.mul(tokenRewardPart) / 1000000;\n', '\n', '    if (totalCollectedETH != 0) {\n', '      totalCollected = totalCollectedETH;\n', '    }\n', '\n', '    totalCollected = IWingsController(manager).fitCollectedValueIntoRange(totalCollected);\n', '\n', '    if (hasEthReward) {\n', '      ethReward = totalCollected.mul(ethRewardPart) / 1000000;\n', '    }\n', '\n', '    return (ethReward, tokenReward);\n', '  }\n', '\n', "  // Change token address (in case you've used the dafault token address during bridge deployment)\n", '  function changeToken(address _newToken) public onlyOwner() {\n', '    token = DefaultToken(_newToken);\n', '\n', '    emit CUSTOM_CROWDSALE_TOKEN_ADDED(address(token), uint8(token.decimals()));\n', '  }\n', '\n', '  // Gives owner ability to withdraw eth and wings from Bridge contract balance in case if some error during reward calculation occured\n', '  function withdraw() public onlyOwner() {\n', '    uint256 ethBalance = address(this).balance;\n', '    uint256 tokenBalance = token.balanceOf(address(this));\n', '\n', '    if (ethBalance > 0) {\n', '      require(msg.sender.send(ethBalance));\n', '    }\n', '\n', '    if (tokenBalance > 0) {\n', '      require(token.transfer(msg.sender, tokenBalance));\n', '    }\n', '  }\n', '}']