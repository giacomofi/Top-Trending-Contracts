['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract TaskFairToken is StandardToken, Ownable {\t\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  event MintFinished();\n', '    \n', '  string public constant name = "Task Fair Token";\n', '   \n', '  string public constant symbol = "TFT";\n', '    \n', '  uint32 public constant decimals = 18;\n', '\n', '  bool public mintingFinished = false;\n', ' \n', '  address public saleAgent;\n', '\n', '  modifier notLocked() {\n', '    require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);\n', '    _;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public notLocked returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {\n', '    return super.transferFrom(from, to, value);\n', '  }\n', '\n', '  function setSaleAgent(address newSaleAgent) public {\n', '    require(saleAgent == msg.sender || owner == msg.sender);\n', '    saleAgent = newSaleAgent;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) public returns (bool) {\n', '    require(!mintingFinished);\n', '    require(msg.sender == saleAgent);\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() public returns (bool) {\n', '    require(!mintingFinished);\n', '    require(msg.sender == owner || msg.sender == saleAgent);\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract StagedCrowdsale is Ownable {\n', '\n', '  using SafeMath for uint;\n', '\n', '  uint public price;\n', '\n', '  struct Stage {\n', '    uint period;\n', '    uint hardCap;\n', '    uint discount;\n', '    uint invested;\n', '    uint closed;\n', '  }\n', '\n', '  uint public constant STAGES_PERCENT_RATE = 100;\n', '\n', '  uint public start;\n', '\n', '  uint public totalPeriod;\n', '\n', '  uint public totalHardCap;\n', ' \n', '  uint public invested;\n', '\n', '  Stage[] public stages;\n', '\n', '  function stagesCount() public constant returns(uint) {\n', '    return stages.length;\n', '  }\n', '\n', '  function setStart(uint newStart) public onlyOwner {\n', '    start = newStart;\n', '  }\n', '\n', '  function setPrice(uint newPrice) public onlyOwner {\n', '    price = newPrice;\n', '  }\n', '\n', '  function addStage(uint period, uint hardCap, uint discount) public onlyOwner {\n', '    require(period > 0 && hardCap > 0);\n', '    stages.push(Stage(period, hardCap, discount, 0, 0));\n', '    totalPeriod = totalPeriod.add(period);\n', '    totalHardCap = totalHardCap.add(hardCap);\n', '  }\n', '\n', '  function removeStage(uint8 number) public onlyOwner {\n', '    require(number >=0 && number < stages.length);\n', '\n', '    Stage storage stage = stages[number];\n', '    totalHardCap = totalHardCap.sub(stage.hardCap);    \n', '    totalPeriod = totalPeriod.sub(stage.period);\n', '\n', '    delete stages[number];\n', '\n', '    for (uint i = number; i < stages.length - 1; i++) {\n', '      stages[i] = stages[i+1];\n', '    }\n', '\n', '    stages.length--;\n', '  }\n', '\n', '  function changeStage(uint8 number, uint period, uint hardCap, uint discount) public onlyOwner {\n', '    require(number >= 0 && number < stages.length);\n', '\n', '    Stage storage stage = stages[number];\n', '\n', '    totalHardCap = totalHardCap.sub(stage.hardCap);    \n', '    totalPeriod = totalPeriod.sub(stage.period);    \n', '\n', '    stage.hardCap = hardCap;\n', '    stage.period = period;\n', '    stage.discount = discount;\n', '\n', '    totalHardCap = totalHardCap.add(hardCap);    \n', '    totalPeriod = totalPeriod.add(period);    \n', '  }\n', '\n', '  function insertStage(uint8 numberAfter, uint period, uint hardCap, uint discount) public onlyOwner {\n', '    require(numberAfter < stages.length);\n', '\n', '\n', '    totalPeriod = totalPeriod.add(period);\n', '    totalHardCap = totalHardCap.add(hardCap);\n', '\n', '    stages.length++;\n', '\n', '    for (uint i = stages.length - 2; i > numberAfter; i--) {\n', '      stages[i + 1] = stages[i];\n', '    }\n', '\n', '    stages[numberAfter + 1] = Stage(period, hardCap, discount, 0, 0);\n', '  }\n', '\n', '  function clearStages() public onlyOwner {\n', '    for (uint i = 0; i < stages.length; i++) {\n', '      delete stages[i];\n', '    }\n', '    stages.length -= stages.length;\n', '    totalPeriod = 0;\n', '    totalHardCap = 0;\n', '  }\n', '\n', '  function lastSaleDate() public constant returns(uint) {\n', '    require(stages.length > 0);\n', '    uint lastDate = start;\n', '    for(uint i=0; i < stages.length; i++) {\n', '      if(stages[i].invested >= stages[i].hardCap) {\n', '        lastDate = stages[i].closed;\n', '      } else {\n', '        lastDate = lastDate.add(stages[i].period * 1 days);\n', '      }\n', '    }\n', '    return lastDate;\n', '  }\n', '\n', '  function currentStage() public constant returns(uint) {\n', '    require(now >= start);\n', '    uint previousDate = start;\n', '    for(uint i=0; i < stages.length; i++) {\n', '      if(stages[i].invested < stages[i].hardCap) {\n', '        if(now >= previousDate && now < previousDate + stages[i].period * 1 days) {\n', '          return i;\n', '        }\n', '        previousDate = previousDate.add(stages[i].period * 1 days);\n', '      } else {\n', '        previousDate = stages[i].closed;\n', '      }\n', '    }\n', '    revert();\n', '  }\n', '\n', '  function updateStageWithInvested(uint stageIndex, uint investedInWei) internal {\n', '    invested = invested.add(investedInWei);\n', '    Stage storage stage = stages[stageIndex];\n', '    stage.invested = stage.invested.add(investedInWei);\n', '    if(stage.invested >= stage.hardCap) {\n', '      stage.closed = now;\n', '    }\n', '  }\n', '\n', '\n', '}\n', '\n', '\n', 'contract CommonCrowdsale is StagedCrowdsale {\n', '\n', '  uint public constant PERCENT_RATE = 1000;\n', '\n', '  uint public minInvestedLimit;\n', '\n', '  uint public minted;\n', '\n', '  address public directMintAgent;\n', '  \n', '  address public wallet;\n', '\n', '  address public devWallet;\n', '\n', '  address public devTokensWallet;\n', '\n', '  address public securityWallet;\n', '\n', '  address public foundersTokensWallet;\n', '\n', '  address public bountyTokensWallet;\n', '\n', '  address public growthTokensWallet;\n', '\n', '  address public advisorsTokensWallet;\n', '\n', '  address public securityTokensWallet;\n', '\n', '  uint public devPercent;\n', '\n', '  uint public securityPercent;\n', '\n', '  uint public bountyTokensPercent;\n', '\n', '  uint public devTokensPercent;\n', '\n', '  uint public advisorsTokensPercent;\n', '\n', '  uint public foundersTokensPercent;\n', '\n', '  uint public growthTokensPercent;\n', '\n', '  uint public securityTokensPercent;\n', '\n', '  TaskFairToken public token;\n', '\n', '  modifier canMint(uint value) {\n', '    require(now >= start && value >= minInvestedLimit);\n', '    _;\n', '  }\n', '\n', '  modifier onlyDirectMintAgentOrOwner() {\n', '    require(directMintAgent == msg.sender || owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {\n', '    minInvestedLimit = newMinInvestedLimit;\n', '  }\n', '\n', '  function setDevPercent(uint newDevPercent) public onlyOwner { \n', '    devPercent = newDevPercent;\n', '  }\n', '\n', '  function setSecurityPercent(uint newSecurityPercent) public onlyOwner { \n', '    securityPercent = newSecurityPercent;\n', '  }\n', '\n', '  function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner { \n', '    bountyTokensPercent = newBountyTokensPercent;\n', '  }\n', '\n', '  function setGrowthTokensPercent(uint newGrowthTokensPercent) public onlyOwner { \n', '    growthTokensPercent = newGrowthTokensPercent;\n', '  }\n', '\n', '  function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner { \n', '    foundersTokensPercent = newFoundersTokensPercent;\n', '  }\n', '\n', '  function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner { \n', '    advisorsTokensPercent = newAdvisorsTokensPercent;\n', '  }\n', '\n', '  function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner { \n', '    devTokensPercent = newDevTokensPercent;\n', '  }\n', '\n', '  function setSecurityTokensPercent(uint newSecurityTokensPercent) public onlyOwner { \n', '    securityTokensPercent = newSecurityTokensPercent;\n', '  }\n', '\n', '  function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner { \n', '    foundersTokensWallet = newFoundersTokensWallet;\n', '  }\n', '\n', '  function setGrowthTokensWallet(address newGrowthTokensWallet) public onlyOwner { \n', '    growthTokensWallet = newGrowthTokensWallet;\n', '  }\n', '\n', '  function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner { \n', '    bountyTokensWallet = newBountyTokensWallet;\n', '  }\n', '\n', '  function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner { \n', '    advisorsTokensWallet = newAdvisorsTokensWallet;\n', '  }\n', '\n', '  function setDevTokensWallet(address newDevTokensWallet) public onlyOwner { \n', '    devTokensWallet = newDevTokensWallet;\n', '  }\n', '\n', '  function setSecurityTokensWallet(address newSecurityTokensWallet) public onlyOwner { \n', '    securityTokensWallet = newSecurityTokensWallet;\n', '  }\n', '\n', '  function setWallet(address newWallet) public onlyOwner { \n', '    wallet = newWallet;\n', '  }\n', '\n', '  function setDevWallet(address newDevWallet) public onlyOwner { \n', '    devWallet = newDevWallet;\n', '  }\n', '\n', '  function setSecurityWallet(address newSecurityWallet) public onlyOwner { \n', '    securityWallet = newSecurityWallet;\n', '  }\n', '\n', '  function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {\n', '    directMintAgent = newDirectMintAgent;\n', '  }\n', '\n', '  function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner canMint(investedWei) {\n', '    calculateAndTransferTokens(to, investedWei);\n', '  }\n', '\n', '  function setStart(uint newStart) public onlyOwner { \n', '    start = newStart;\n', '  }\n', '\n', '  function setToken(address newToken) public onlyOwner { \n', '    token = TaskFairToken(newToken);\n', '  }\n', '\n', '  function mintExtendedTokens() internal {\n', '    uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent).add(foundersTokensPercent).add(growthTokensPercent).add(securityTokensPercent);\n', '    uint allTokens = minted.mul(PERCENT_RATE).div(PERCENT_RATE.sub(extendedTokensPercent));\n', '\n', '    uint bountyTokens = allTokens.mul(bountyTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(bountyTokensWallet, bountyTokens);\n', '\n', '    uint advisorsTokens = allTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(advisorsTokensWallet, advisorsTokens);\n', '\n', '    uint foundersTokens = allTokens.mul(foundersTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(foundersTokensWallet, foundersTokens);\n', '\n', '    uint growthTokens = allTokens.mul(growthTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(growthTokensWallet, growthTokens);\n', '\n', '    uint devTokens = allTokens.mul(devTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(devTokensWallet, devTokens);\n', '\n', '    uint secuirtyTokens = allTokens.mul(securityTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(securityTokensWallet, secuirtyTokens);\n', '  }\n', '\n', '  function mintAndSendTokens(address to, uint amount) internal {\n', '    token.mint(to, amount);\n', '    minted = minted.add(amount);\n', '  }\n', '\n', '  function calculateAndTransferTokens(address to, uint investedInWei) internal {\n', '    uint stageIndex = currentStage();\n', '    Stage storage stage = stages[stageIndex];\n', '\n', '    // calculate tokens\n', '    uint tokens = investedInWei.mul(price).mul(STAGES_PERCENT_RATE).div(STAGES_PERCENT_RATE.sub(stage.discount)).div(1 ether);\n', '    \n', '    // transfer tokens\n', '    mintAndSendTokens(to, tokens);\n', '\n', '    updateStageWithInvested(stageIndex, investedInWei);\n', '  }\n', '\n', '  function createTokens() public payable;\n', '\n', '  function() external payable {\n', '    createTokens();\n', '  }\n', '\n', '  function retrieveTokens(address anotherToken) public onlyOwner {\n', '    ERC20 alienToken = ERC20(anotherToken);\n', '    alienToken.transfer(wallet, alienToken.balanceOf(this));\n', '  }\n', '\n', '}\n', '\n', 'contract PreTGE is CommonCrowdsale {\n', '  \n', '  uint public softcap;\n', '  \n', '  bool public refundOn;\n', '\n', '  bool public softcapAchieved;\n', '\n', '  address public nextSaleAgent;\n', '\n', '  mapping (address => uint) public balances;\n', '\n', '  event RefundsEnabled();\n', '\n', '  event SoftcapReached();\n', '\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  function PreTGE() public {\n', '    setMinInvestedLimit(1000000000000000000);  \n', '    setPrice(4000000000000000000000);\n', '    setBountyTokensPercent(50);\n', '    setAdvisorsTokensPercent(20);\n', '    setDevTokensPercent(30);\n', '    setFoundersTokensPercent(50);\n', '    setGrowthTokensPercent(300);\n', '    setSecurityTokensPercent(5);\n', '    setDevPercent(20);\n', '    setSecurityPercent(10);\n', '    \n', '    // fix in prod\n', '    setSoftcap(40000000000000000000);\n', '    \n', '    addStage(7, 570000000000000000000, 40);\n', '    addStage(7, 1400000000000000000000, 30);\n', '    addStage(7, 2570000000000000000000, 20);\n', '    \n', '    setStart(1512867600);\n', '    setWallet(0x73598a82559f3566Ecf93aab415323668124191C);\n', '    setBountyTokensWallet(0x1C59BD0658DA5f357926D38083286A7E25Cd6f97);\n', '    setDevTokensWallet(0xad3Df84A21d508Ad1E782956badeBE8725a9A447);\n', '    setAdvisorsTokensWallet(0x17D34009D6e16Ae35dCfF3840d9eeC832d75FeA6);\n', '    setFoundersTokensWallet(0xd63c6c4977B80a2042aA71bEd548e32A856e9481);\n', '    setGrowthTokensWallet(0x9518ea93647DC3B198d3B04AD229977d8485fA1A);\n', '    setDevWallet(0xad3Df84A21d508Ad1E782956badeBE8725a9A447);\n', '    setSecurityTokensWallet(0x6Ea796DA599827ba871BE76fAF1948e45Bce4628);\n', '    setSecurityWallet(0xfA4b94A9Ab8b5Ae3a1fd10aCE18724Bf1EC8CB07);\n', '  }\n', '\n', '  function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {\n', '    nextSaleAgent = newNextSaleAgent;\n', '  }\n', '\n', '  function setSoftcap(uint newSoftcap) public onlyOwner {\n', '    softcap = newSoftcap;\n', '  }\n', '\n', '  function setDevWallet(address newDevWallet) public onlyOwner {\n', '    devWallet = newDevWallet;\n', '  }\n', '\n', '  function refund() public {\n', '    require(now > start && refundOn && balances[msg.sender] > 0);\n', '    uint value = balances[msg.sender];\n', '    balances[msg.sender] = 0;\n', '    msg.sender.transfer(value);\n', '    Refunded(msg.sender, value);\n', '  } \n', '\n', '  function createTokens() public payable canMint(msg.value) {\n', '    balances[msg.sender] = balances[msg.sender].add(msg.value);\n', '    calculateAndTransferTokens(msg.sender, msg.value);\n', '  } \n', '\n', '  function calculateAndTransferTokens(address to, uint investorWei) internal {\n', '    super.calculateAndTransferTokens(to, investorWei);\n', '    if(!softcapAchieved && invested >= softcap) {\n', '      softcapAchieved = true;      \n', '      SoftcapReached();\n', '    }\n', '  }\n', '\n', '  function widthraw() public onlyOwner {\n', '    require(softcapAchieved);\n', '    uint devWei = this.balance.mul(devPercent).div(PERCENT_RATE);\n', '    devWallet.transfer(devWei);\n', '    uint securityWei = this.balance.mul(securityPercent).div(PERCENT_RATE);\n', '    securityWallet.transfer(securityWei);\n', '    wallet.transfer(this.balance);\n', '  } \n', '\n', '  function finishMinting() public onlyOwner {\n', '    if(!softcapAchieved) {\n', '      refundOn = true;      \n', '      token.finishMinting();\n', '      RefundsEnabled();\n', '    } else {\n', '      widthraw();\n', '      mintExtendedTokens();\n', '      token.setSaleAgent(nextSaleAgent);\n', '    }    \n', '  }\n', '\n', '}']