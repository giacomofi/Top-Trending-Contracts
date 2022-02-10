['pragma solidity ^0.4.18;\n', '\n', 'contract HasManager {\n', '  address public manager;\n', '\n', '  modifier onlyManager {\n', '    require(msg.sender == manager);\n', '    _;\n', '  }\n', '\n', '  function transferManager(address _newManager) public onlyManager() {\n', '    require(_newManager != address(0));\n', '    manager = _newManager;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  function Ownable() public { owner = msg.sender; }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {owner = newOwner;}\n', '}contract IERC20 {\n', '\n', '  function totalSupply() public constant returns (uint256);\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256);\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', ' }\n', '\n', '\n', '\n', '\n', '\n', '\n', '// Crowdsale contracts interface\n', 'contract ICrowdsaleProcessor is Ownable, HasManager {\n', '  modifier whenCrowdsaleAlive() {\n', '    require(isActive());\n', '    _;\n', '  }\n', '\n', '  modifier whenCrowdsaleFailed() {\n', '    require(isFailed());\n', '    _;\n', '  }\n', '\n', '  modifier whenCrowdsaleSuccessful() {\n', '    require(isSuccessful());\n', '    _;\n', '  }\n', '\n', '  modifier hasntStopped() {\n', '    require(!stopped);\n', '    _;\n', '  }\n', '\n', '  modifier hasBeenStopped() {\n', '    require(stopped);\n', '    _;\n', '  }\n', '\n', '  modifier hasntStarted() {\n', '    require(!started);\n', '    _;\n', '  }\n', '\n', '  modifier hasBeenStarted() {\n', '    require(started);\n', '    _;\n', '  }\n', '\n', '  // Minimal acceptable hard cap\n', '  uint256 constant public MIN_HARD_CAP = 1 ether;\n', '\n', '  // Minimal acceptable duration of crowdsale\n', '  uint256 constant public MIN_CROWDSALE_TIME = 3 days;\n', '\n', '  // Maximal acceptable duration of crowdsale\n', '  uint256 constant public MAX_CROWDSALE_TIME = 50 days;\n', '\n', '  // Becomes true when timeframe is assigned\n', '  bool public started;\n', '\n', '  // Becomes true if cancelled by owner\n', '  bool public stopped;\n', '\n', '  // Total collected Ethereum: must be updated every time tokens has been sold\n', '  uint256 public totalCollected;\n', '\n', '  // Total amount of project&#39;s token sold: must be updated every time tokens has been sold\n', '  uint256 public totalSold;\n', '\n', '  // Crowdsale minimal goal, must be greater or equal to Forecasting min amount\n', '  uint256 public minimalGoal;\n', '\n', '  // Crowdsale hard cap, must be less or equal to Forecasting max amount\n', '  uint256 public hardCap;\n', '\n', '  // Crowdsale duration in seconds.\n', '  // Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.\n', '  uint256 public duration;\n', '\n', '  // Start timestamp of crowdsale, absolute UTC time\n', '  uint256 public startTimestamp;\n', '\n', '  // End timestamp of crowdsale, absolute UTC time\n', '  uint256 public endTimestamp;\n', '\n', '  // Allows to transfer some ETH into the contract without selling tokens\n', '  function deposit() public payable {}\n', '\n', '  // Returns address of crowdsale token, must be ERC20 compilant\n', '  function getToken() public returns(address);\n', '\n', '  // Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract\n', '  function mintETHRewards(address _contract, uint256 _amount) public onlyManager();\n', '\n', '  // Mints token Rewards to Forecasting contract\n', '  function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();\n', '\n', '  // Releases tokens (transfers crowdsale token from mintable to transferrable state)\n', '  function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful();\n', '\n', '  // Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.\n', '  // Crowdsale may be stopped any time before it finishes.\n', '  function stop() public onlyManager() hasntStopped();\n', '\n', '  // Validates parameters and starts crowdsale\n', '  function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress)\n', '    public onlyManager() hasntStarted() hasntStopped();\n', '\n', '  // Is crowdsale failed (completed, but minimal goal wasn&#39;t reached)\n', '  function isFailed() public constant returns (bool);\n', '\n', '  // Is crowdsale active (i.e. the token can be sold)\n', '  function isActive() public constant returns (bool);\n', '\n', '  // Is crowdsale completed successfully\n', '  function isSuccessful() public constant returns (bool);\n', '}\n', '\n', '// Basic crowdsale implementation both for regualt and 3rdparty Crowdsale contracts\n', 'contract BasicCrowdsale is ICrowdsaleProcessor {\n', '  event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);\n', '\n', '  // Where to transfer collected ETH\n', '  address public fundingAddress;\n', '\n', '  // Ctor.\n', '  function BasicCrowdsale(\n', '    address _owner,\n', '    address _manager\n', '  )\n', '    public\n', '  {\n', '    owner = _owner;\n', '    manager = _manager;\n', '  }\n', '\n', '  // called by CrowdsaleController to transfer reward part of ETH\n', '  // collected by successful crowdsale to Forecasting contract.\n', '  // This call is made upon closing successful crowdfunding process\n', '  // iff agreed ETH reward part is not zero\n', '  function mintETHRewards(\n', '    address _contract,  // Forecasting contract\n', '    uint256 _amount     // agreed part of totalCollected which is intended for rewards\n', '  )\n', '    public\n', '    onlyManager() // manager is CrowdsaleController instance\n', '  {\n', '    require(_contract.call.value(_amount)());\n', '  }\n', '\n', '  // cancels crowdsale\n', '  function stop() public onlyManager() hasntStopped()  {\n', '    // we can stop only not started and not completed crowdsale\n', '    if (started) {\n', '      require(!isFailed());\n', '      require(!isSuccessful());\n', '    }\n', '    stopped = true;\n', '  }\n', '\n', '  // called by CrowdsaleController to setup start and end time of crowdfunding process\n', '  // as well as funding address (where to transfer ETH upon successful crowdsale)\n', '  function start(\n', '    uint256 _startTimestamp,\n', '    uint256 _endTimestamp,\n', '    address _fundingAddress\n', '  )\n', '    public\n', '    onlyManager()   // manager is CrowdsaleController instance\n', '    hasntStarted()  // not yet started\n', '    hasntStopped()  // crowdsale wasn&#39;t cancelled\n', '  {\n', '    require(_fundingAddress != address(0));\n', '\n', '    // start time must not be earlier than current time\n', '    require(_startTimestamp >= block.timestamp);\n', '\n', '    // range must be sane\n', '    require(_endTimestamp > _startTimestamp);\n', '    duration = _endTimestamp - _startTimestamp;\n', '\n', '    // duration must fit constraints\n', '    require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);\n', '\n', '    startTimestamp = _startTimestamp;\n', '    endTimestamp = _endTimestamp;\n', '    fundingAddress = _fundingAddress;\n', '\n', '    // now crowdsale is considered started, even if the current time is before startTimestamp\n', '    started = true;\n', '\n', '    CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);\n', '  }\n', '\n', '  // must return true if crowdsale is over, but it failed\n', '  function isFailed()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // it was started\n', '      started &&\n', '\n', '      // crowdsale period has finished\n', '      block.timestamp >= endTimestamp &&\n', '\n', '      // but collected ETH is below the required minimum\n', '      totalCollected < minimalGoal\n', '    );\n', '  }\n', '\n', '  // must return true if crowdsale is active (i.e. the token can be bought)\n', '  function isActive()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // it was started\n', '      started &&\n', '\n', '      // hard cap wasn&#39;t reached yet\n', '      totalCollected < hardCap &&\n', '\n', '      // and current time is within the crowdfunding period\n', '      block.timestamp >= startTimestamp &&\n', '      block.timestamp < endTimestamp\n', '    );\n', '  }\n', '\n', '  // must return true if crowdsale completed successfully\n', '  function isSuccessful()\n', '    public\n', '    constant\n', '    returns(bool)\n', '  {\n', '    return (\n', '      // either the hard cap is collected\n', '      totalCollected >= hardCap ||\n', '\n', '      // ...or the crowdfunding period is over, but the minimum has been reached\n', '      (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)\n', '    );\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract SmartOToken is Ownable, IERC20 {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /* Public variables of the token */\n', '  string public constant name = "STO";\n', '  string public constant symbol = "STO";\n', '  uint public constant decimals = 18;\n', '  uint256 public constant initialSupply = 12000000000 * 1 ether;\n', '  uint256 public totalSupply;\n', '\n', '  /* This creates an array with all balances */\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '  /* Events */\n', '  event Burn(address indexed burner, uint256 value);\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  /* Constuctor: Initializes contract with initial supply tokens to the creator of the contract */\n', '  function SmartOToken() public {\n', '      balances[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '      totalSupply = initialSupply;                        // Update total supply\n', '  }\n', '\n', '\n', '  /* Implementation of ERC20Interface */\n', '\n', '  function totalSupply() public constant returns (uint256) { return totalSupply; }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }\n', '\n', '  /* Internal transfer, only can be called by this contract */\n', '  function _transfer(address _from, address _to, uint _amount) internal {\n', '      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '      require (balances[_from] >= _amount);                // Check if the sender has enough\n', '      balances[_from] = balances[_from].sub(_amount);\n', '      balances[_to] = balances[_to].add(_amount);\n', '      Transfer(_from, _to, _amount);\n', '\n', '  }\n', '\n', '  function transfer(address _to, uint256 _amount) public returns (bool) {\n', '    _transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require (_value <= allowed[_from][msg.sender]);     // Check allowance\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    _transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _amount) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '// Custom crowdsale example\n', 'contract SmatrOCrowdsale is BasicCrowdsale {\n', '  // Crowdsale participants\n', '  mapping(address => uint256) participants;\n', '\n', '  // tokens per ETH fixed price\n', '  uint256 tokensPerEthPrice;\n', '\n', '  // Crowdsale token\n', '  SmartOToken crowdsaleToken;\n', '\n', '  // Ctor. In this example, minimalGoal, hardCap, and price are not changeable.\n', '  // In more complex cases, those parameters may be changed until start() is called.\n', '  function SmatrOCrowdsale(\n', '    uint256 _minimalGoal,\n', '    uint256 _hardCap,\n', '    uint256 _tokensPerEthPrice,\n', '    address _token\n', '  )\n', '    public\n', '    // simplest case where manager==owner. See onlyOwner() and onlyManager() modifiers\n', '    // before functions to figure out the cases in which those addresses should differ\n', '    BasicCrowdsale(msg.sender, msg.sender)\n', '  {\n', '    // just setup them once...\n', '    minimalGoal = _minimalGoal;\n', '    hardCap = _hardCap;\n', '    tokensPerEthPrice = _tokensPerEthPrice;\n', '    crowdsaleToken = SmartOToken(_token);\n', '  }\n', '\n', '// Here goes ICrowdsaleProcessor implementation\n', '\n', '  // returns address of crowdsale token. The token must be ERC20-compliant\n', '  function getToken()\n', '    public\n', '    returns(address)\n', '  {\n', '    return address(crowdsaleToken);\n', '  }\n', '\n', '  // called by CrowdsaleController to transfer reward part of\n', '  // tokens sold by successful crowdsale to Forecasting contract.\n', '  // This call is made upon closing successful crowdfunding process.\n', '  function mintTokenRewards(\n', '    address _contract,  // Forecasting contract\n', '    uint256 _amount     // agreed part of totalSold which is intended for rewards\n', '  )\n', '    public\n', '    onlyManager() // manager is CrowdsaleController instance\n', '  {\n', '    // crowdsale token is mintable in this example, tokens are created here\n', '    crowdsaleToken.transfer(_contract, _amount);\n', '  }\n', '\n', '  // transfers crowdsale token from mintable to transferrable state\n', '  function releaseTokens()\n', '    public\n', '    onlyManager()             // manager is CrowdsaleController instance\n', '    hasntStopped()            // crowdsale wasn&#39;t cancelled\n', '    whenCrowdsaleSuccessful() // crowdsale was successful\n', '  {\n', '    // do nothing\n', '  }\n', '\n', '// Here go crowdsale process itself and token manipulations\n', '\n', '  function setRate(uint256 _tokensPerEthPrice)\n', '    public\n', '    onlyOwner\n', '  {\n', '    tokensPerEthPrice = _tokensPerEthPrice;\n', '  }\n', '\n', '  // default function allows for ETH transfers to the contract\n', '  function () payable public {\n', '    require(msg.value >= 0.1 * 1 ether);\n', '\n', '    // and it sells the token\n', '    sellTokens(msg.sender, msg.value);\n', '  }\n', '\n', '  // sels the project&#39;s token to buyers\n', '  function sellTokens(address _recepient, uint256 _value)\n', '    internal\n', '    hasBeenStarted()     // crowdsale started\n', '    hasntStopped()       // wasn&#39;t cancelled by owner\n', '    whenCrowdsaleAlive() // in active state\n', '  {\n', '    uint256 newTotalCollected = totalCollected + _value;\n', '\n', '    if (hardCap < newTotalCollected) {\n', '      // don&#39;t sell anything above the hard cap\n', '\n', '      uint256 refund = newTotalCollected - hardCap;\n', '      uint256 diff = _value - refund;\n', '\n', '      // send the ETH part which exceeds the hard cap back to the buyer\n', '      _recepient.transfer(refund);\n', '      _value = diff;\n', '    }\n', '\n', '    // token amount as per price (fixed in this example)\n', '    uint256 tokensSold = _value * tokensPerEthPrice;\n', '\n', '    // create new tokens for this buyer\n', '    crowdsaleToken.transfer(_recepient, tokensSold);\n', '\n', '    // remember the buyer so he/she/it may refund its ETH if crowdsale failed\n', '    participants[_recepient] += _value;\n', '\n', '    // update total ETH collected\n', '    totalCollected += _value;\n', '\n', '    // update totel tokens sold\n', '    totalSold += tokensSold;\n', '  }\n', '\n', '  // project&#39;s owner withdraws ETH funds to the funding address upon successful crowdsale\n', '  function withdraw(\n', '    uint256 _amount // can be done partially\n', '  )\n', '    public\n', '    onlyOwner() // project&#39;s owner\n', '    hasntStopped()  // crowdsale wasn&#39;t cancelled\n', '    whenCrowdsaleSuccessful() // crowdsale completed successfully\n', '  {\n', '    require(_amount <= this.balance);\n', '    fundingAddress.transfer(_amount);\n', '  }\n', '\n', '  // backers refund their ETH if the crowdsale was cancelled or has failed\n', '  function refund()\n', '    public\n', '  {\n', '    // either cancelled or failed\n', '    require(stopped || isFailed());\n', '\n', '    uint256 amount = participants[msg.sender];\n', '\n', '    // prevent from doing it twice\n', '    require(amount > 0);\n', '    participants[msg.sender] = 0;\n', '\n', '    msg.sender.transfer(amount);\n', '  }\n', '}']