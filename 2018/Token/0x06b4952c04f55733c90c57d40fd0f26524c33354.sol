['pragma solidity ^0.4.24;\n', '\n', '// File: contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/InvestedProvider.sol\n', '\n', 'contract InvestedProvider is Ownable {\n', '\n', '  uint public invested;\n', '\n', '}\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/token/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/MintableToken.sol\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  address public saleAgent;\n', '\n', '  mapping(address => bool) public unlockedAddressesDuringITO;\n', '\n', '  address[] public tokenHolders;\n', '\n', '  modifier onlyOwnerOrSaleAgent() {\n', '    require(msg.sender == saleAgent || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function unlockAddressDuringITO(address addressToUnlock) public onlyOwnerOrSaleAgent {\n', '    unlockedAddressesDuringITO[addressToUnlock] = true;\n', '  }\n', '\n', '  modifier notLocked(address sender) {\n', '    require(mintingFinished ||\n', '            sender == saleAgent || \n', '            sender == owner ||\n', '            (!mintingFinished && unlockedAddressesDuringITO[sender]));\n', '    _;\n', '  }\n', '\n', '  function setSaleAgent(address newSaleAgnet) public onlyOwnerOrSaleAgent {\n', '    saleAgent = newSaleAgnet;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) public returns (bool) {\n', '    require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);\n', '    if(balances[_to] == 0) tokenHolders.push(_to);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() public returns (bool) {\n', '    require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public notLocked(msg.sender) returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {\n', '    return super.transferFrom(from, to, value);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/TokenProvider.sol\n', '\n', 'contract TokenProvider is Ownable {\n', '\n', '  MintableToken public token;\n', '\n', '  function setToken(address newToken) public onlyOwner {\n', '    token = MintableToken(newToken);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/MintTokensInterface.sol\n', '\n', 'contract MintTokensInterface is TokenProvider {\n', '\n', '  function mintTokens(address to, uint tokens) internal;\n', '\n', '}\n', '\n', '// File: contracts/MintTokensFeature.sol\n', '\n', 'contract MintTokensFeature is MintTokensInterface {\n', '\n', '  function mintTokens(address to, uint tokens) internal {\n', '    token.mint(to, tokens);\n', '  }\n', '\n', '  function mintTokensBatch(uint amount, address[] to) public onlyOwner {\n', '    for(uint i = 0; i < to.length; i++) {\n', '      token.mint(to[i], amount);\n', '    }\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/PercentRateProvider.sol\n', '\n', 'contract PercentRateProvider is Ownable {\n', '\n', '  uint public percentRate = 100;\n', '\n', '  function setPercentRate(uint newPercentRate) public onlyOwner {\n', '    percentRate = newPercentRate;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/RetrieveTokensFeature.sol\n', '\n', 'contract RetrieveTokensFeature is Ownable {\n', '\n', '  function retrieveTokens(address to, address anotherToken) public onlyOwner {\n', '    ERC20 alienToken = ERC20(anotherToken);\n', '    alienToken.transfer(to, alienToken.balanceOf(this));\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/WalletProvider.sol\n', '\n', 'contract WalletProvider is Ownable {\n', '\n', '  address public wallet;\n', '\n', '  function setWallet(address newWallet) public onlyOwner {\n', '    wallet = newWallet;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/CommonSale.sol\n', '\n', 'contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature, MintTokensFeature {\n', '\n', '  using SafeMath for uint;\n', '\n', '  address public directMintAgent;\n', '\n', '  uint public price;\n', '\n', '  uint public start;\n', '\n', '  uint public minInvestedLimit;\n', '\n', '  uint public hardcap;\n', '\n', '  modifier isUnderHardcap() {\n', '    require(invested <= hardcap);\n', '    _;\n', '  }\n', '\n', '  function setHardcap(uint newHardcap) public onlyOwner {\n', '    hardcap = newHardcap;\n', '  }\n', '\n', '  modifier onlyDirectMintAgentOrOwner() {\n', '    require(directMintAgent == msg.sender || owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  modifier minInvestLimited(uint value) {\n', '    require(value >= minInvestedLimit);\n', '    _;\n', '  }\n', '\n', '  function setStart(uint newStart) public onlyOwner {\n', '    start = newStart;\n', '  }\n', '\n', '  function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {\n', '    minInvestedLimit = newMinInvestedLimit;\n', '  }\n', '\n', '  function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {\n', '    directMintAgent = newDirectMintAgent;\n', '  }\n', '\n', '  function setPrice(uint newPrice) public onlyOwner {\n', '    price = newPrice;\n', '  }\n', '\n', '  function setToken(address newToken) public onlyOwner {\n', '    token = MintableToken(newToken);\n', '  }\n', '\n', '  function calculateTokens(uint _invested) internal returns(uint);\n', '\n', '  function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {\n', '    mintTokens(to, tokens);\n', '  }\n', '\n', '  function endSaleDate() public view returns(uint);\n', '\n', '  function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner {\n', '    updateInvested(_invested);\n', '    mintTokensByETH(to, _invested);\n', '  }\n', '\n', '  function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {\n', '    uint tokens = calculateTokens(_invested);\n', '    mintTokens(to, tokens);\n', '    return tokens;\n', '  }\n', '\n', '  function updateInvested(uint value) internal {\n', '    invested = invested.add(value);\n', '  }\n', '\n', '  function fallback() internal minInvestLimited(msg.value) returns(uint) {\n', '    require(now >= start && now < endSaleDate());\n', '    wallet.transfer(msg.value);\n', '    updateInvested(msg.value);\n', '    return mintTokensByETH(msg.sender, msg.value);\n', '  }\n', '\n', '  function () public payable {\n', '    fallback();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/AssembledCommonSale.sol\n', '\n', 'contract AssembledCommonSale is CommonSale {\n', '\n', '}\n', '\n', '// File: contracts/WalletsPercents.sol\n', '\n', 'contract WalletsPercents is Ownable {\n', '\n', '  address[] public wallets;\n', '\n', '  mapping (address => uint) percents;\n', '\n', '  function addWallet(address wallet, uint percent) public onlyOwner {\n', '    wallets.push(wallet);\n', '    percents[wallet] = percent;\n', '  }\n', ' \n', '  function cleanWallets() public onlyOwner {\n', '    wallets.length = 0;\n', '  }\n', '\n', '\n', '}\n', '\n', '// File: contracts/ExtendedWalletsMintTokensFeature.sol\n', '\n', 'contract ExtendedWalletsMintTokensFeature is MintTokensInterface, WalletsPercents {\n', '\n', '  using SafeMath for uint;\n', '\n', '  uint public percentRate = 100;\n', '\n', '  function mintExtendedTokens() public onlyOwner {\n', '    uint summaryTokensPercent = 0;\n', '    for(uint i = 0; i < wallets.length; i++) {\n', '      summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);\n', '    }\n', '    uint mintedTokens = token.totalSupply();\n', '    uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));\n', '    for(uint k = 0; k < wallets.length; k++) {\n', '      mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));\n', '    }\n', '\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/StagedCrowdsale.sol\n', '\n', 'contract StagedCrowdsale is Ownable {\n', '\n', '  using SafeMath for uint;\n', '\n', '  struct Milestone {\n', '    uint period;\n', '    uint bonus;\n', '  }\n', '\n', '  uint public totalPeriod;\n', '\n', '  Milestone[] public milestones;\n', '\n', '  function milestonesCount() public view returns(uint) {\n', '    return milestones.length;\n', '  }\n', '\n', '  function addMilestone(uint period, uint bonus) public onlyOwner {\n', '    require(period > 0);\n', '    milestones.push(Milestone(period, bonus));\n', '    totalPeriod = totalPeriod.add(period);\n', '  }\n', '\n', '  function removeMilestone(uint8 number) public onlyOwner {\n', '    require(number < milestones.length);\n', '    Milestone storage milestone = milestones[number];\n', '    totalPeriod = totalPeriod.sub(milestone.period);\n', '\n', '    delete milestones[number];\n', '\n', '    for (uint i = number; i < milestones.length - 1; i++) {\n', '      milestones[i] = milestones[i+1];\n', '    }\n', '\n', '    milestones.length--;\n', '  }\n', '\n', '  function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {\n', '    require(number < milestones.length);\n', '    Milestone storage milestone = milestones[number];\n', '\n', '    totalPeriod = totalPeriod.sub(milestone.period);\n', '\n', '    milestone.period = period;\n', '    milestone.bonus = bonus;\n', '\n', '    totalPeriod = totalPeriod.add(period);\n', '  }\n', '\n', '  function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {\n', '    require(numberAfter < milestones.length);\n', '\n', '    totalPeriod = totalPeriod.add(period);\n', '\n', '    milestones.length++;\n', '\n', '    for (uint i = milestones.length - 2; i > numberAfter; i--) {\n', '      milestones[i + 1] = milestones[i];\n', '    }\n', '\n', '    milestones[numberAfter + 1] = Milestone(period, bonus);\n', '  }\n', '\n', '  function clearMilestones() public onlyOwner {\n', '    require(milestones.length > 0);\n', '    for (uint i = 0; i < milestones.length; i++) {\n', '      delete milestones[i];\n', '    }\n', '    milestones.length -= milestones.length;\n', '    totalPeriod = 0;\n', '  }\n', '\n', '  function lastSaleDate(uint start) public view returns(uint) {\n', '    return start + totalPeriod * 1 days;\n', '  }\n', '\n', '  function currentMilestone(uint start) public view returns(uint) {\n', '    uint previousDate = start;\n', '    for(uint i=0; i < milestones.length; i++) {\n', '      if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {\n', '        return i;\n', '      }\n', '      previousDate = previousDate.add(milestones[i].period * 1 days);\n', '    }\n', '    revert();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ITO.sol\n', '\n', 'contract ITO is ExtendedWalletsMintTokensFeature, StagedCrowdsale, AssembledCommonSale {\n', '\n', '  function endSaleDate() public view returns(uint) {\n', '    return lastSaleDate(start);\n', '  }\n', '\n', '  function calculateTokens(uint _invested) internal returns(uint) {\n', '    uint milestoneIndex = currentMilestone(start);\n', '    Milestone storage milestone = milestones[milestoneIndex];\n', '    uint tokens = _invested.mul(price).div(1 ether);\n', '    if(milestone.bonus > 0) {\n', '      tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));\n', '    }\n', '    return tokens;\n', '  }\n', '\n', '  function finish() public onlyOwner {\n', '    mintExtendedTokens();\n', '    token.finishMinting();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/NextSaleAgentFeature.sol\n', '\n', 'contract NextSaleAgentFeature is Ownable {\n', '\n', '  address public nextSaleAgent;\n', '\n', '  function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {\n', '    nextSaleAgent = newNextSaleAgent;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/SoftcapFeature.sol\n', '\n', 'contract SoftcapFeature is InvestedProvider, WalletProvider {\n', '\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) public balances;\n', '\n', '  bool public softcapAchieved;\n', '\n', '  bool public refundOn;\n', '\n', '  uint public softcap;\n', '\n', '  uint public constant devLimit = 22500000000000000000;\n', '\n', '  bool public devFeePaid;\n', '\n', '  address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;\n', '\n', '  function setSoftcap(uint newSoftcap) public onlyOwner {\n', '    softcap = newSoftcap;\n', '  }\n', '\n', '  function withdraw() public {\n', '    require(msg.sender == owner || msg.sender == devWallet);\n', '    require(softcapAchieved);\n', '    if(!devFeePaid) {\n', '      devWallet.transfer(devLimit);\n', '      devFeePaid = true;\n', '    }\n', '    wallet.transfer(address(this).balance);\n', '  }\n', '\n', '  function updateBalance(address to, uint amount) internal {\n', '    balances[to] = balances[to].add(amount);\n', '    if (!softcapAchieved && invested >= softcap) {\n', '      softcapAchieved = true;\n', '    }\n', '  }\n', '\n', '  function refund() public {\n', '    require(refundOn && balances[msg.sender] > 0);\n', '    uint value = balances[msg.sender];\n', '    balances[msg.sender] = 0;\n', '    msg.sender.transfer(value);\n', '  }\n', '\n', '  function updateRefundState() internal returns(bool) {\n', '    if (!softcapAchieved) {\n', '      refundOn = true;\n', '    }\n', '    return refundOn;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/PreITO.sol\n', '\n', 'contract PreITO is NextSaleAgentFeature, SoftcapFeature, AssembledCommonSale {\n', '\n', '  uint public period;\n', '\n', '  function calculateTokens(uint _invested) internal returns(uint) {\n', '    return _invested.mul(price).div(1 ether);\n', '  }\n', '\n', '  function setPeriod(uint newPeriod) public onlyOwner {\n', '    period = newPeriod;\n', '  }\n', '\n', '  function endSaleDate() public view returns(uint) {\n', '    return start.add(period * 1 days);\n', '  }\n', '  \n', '  function mintTokensByETH(address to, uint _invested) internal returns(uint) {\n', '    uint _tokens = super.mintTokensByETH(to, _invested);\n', '    updateBalance(to, _invested);\n', '    return _tokens;\n', '  }\n', '\n', '  function finish() public onlyOwner {\n', '    if (updateRefundState()) {\n', '      token.finishMinting();\n', '    } else {\n', '      withdraw();\n', '      token.setSaleAgent(nextSaleAgent);\n', '    }\n', '  }\n', '\n', '  function fallback() internal minInvestLimited(msg.value) returns(uint) {\n', '    require(now >= start && now < endSaleDate());\n', '    updateInvested(msg.value);\n', '    return mintTokensByETH(msg.sender, msg.value);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ReceivingContractCallback.sol\n', '\n', 'contract ReceivingContractCallback {\n', '\n', '  function tokenFallback(address _from, uint _value) public;\n', '\n', '}\n', '\n', '// File: contracts/Token.sol\n', '\n', 'contract Token is MintableToken {\n', '\n', '  string public constant name = "FRSCoin";\n', '\n', '  string public constant symbol = "FRS";\n', '\n', '  uint32 public constant decimals = 18;\n', '\n', '  mapping(address => bool)  public registeredCallbacks;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);\n', '  }\n', '\n', '  function registerCallback(address callback) public onlyOwner {\n', '    registeredCallbacks[callback] = true;\n', '  }\n', '\n', '  function deregisterCallback(address callback) public onlyOwner {\n', '    registeredCallbacks[callback] = false;\n', '  }\n', '\n', '  function processCallback(bool result, address from, address to, uint value) internal returns(bool) {\n', '    if (result && registeredCallbacks[to]) {\n', '      ReceivingContractCallback targetCallback = ReceivingContractCallback(to);\n', '      targetCallback.tokenFallback(from, value);\n', '    }\n', '    return result;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Configurator.sol\n', '\n', 'contract Configurator is Ownable {\n', '\n', '  Token public token;\n', '\n', '  PreITO public preITO;\n', '\n', '  ITO public ito;\n', '\n', '  function deploy() public onlyOwner {\n', '\n', '    token = new Token();\n', '\n', '    preITO = new PreITO();\n', '\n', '    preITO.setWallet(0x89C92383bCF3EecD5180aBd055Bf319ceFD2D516);\n', '    preITO.setStart(1531612800);\n', '    preITO.setPeriod(48);\n', '    preITO.setPrice(1080000000000000000000);\n', '    preITO.setMinInvestedLimit(100000000000000000);\n', '    preITO.setSoftcap(1000000000000000000000);\n', '    preITO.setHardcap(4000000000000000000000);\n', '    preITO.setToken(token);\n', '    preITO.setDirectMintAgent(0xF3D57FC2903Cbdfe1e1d33bE38Ad0A0753E72406);\n', '\n', '    token.setSaleAgent(preITO);\n', '\n', '    ito = new ITO();\n', '\n', '    ito.setWallet(0xb13a4803bcC374B8BbCaf625cdD0a3Ac85CdC0DA);\n', '    ito.setStart(1535760000);\n', '    ito.addMilestone(7, 15);\n', '    ito.addMilestone(7, 13);\n', '    ito.addMilestone(7, 11);\n', '    ito.addMilestone(7, 9);\n', '    ito.addMilestone(7, 7);\n', '    ito.addMilestone(7, 5);\n', '    ito.addMilestone(7, 3);\n', '    ito.setPrice(900000000000000000000);\n', '    ito.setMinInvestedLimit(100000000000000000);\n', '    ito.setHardcap(32777000000000000000000);\n', '    ito.addWallet(0xA5A5cf5325AeDA4aB32b9b0E0E8fa91aBDb64DdC, 10);\n', '    ito.setToken(token);\n', '    ito.setDirectMintAgent(0xF3D57FC2903Cbdfe1e1d33bE38Ad0A0753E72406);\n', '\n', '    preITO.setNextSaleAgent(ito);\n', '\n', '    address manager = 0xd8Fe93097F0Ef354fEfee2e77458eeCc19D8D704;\n', '\n', '    token.transferOwnership(manager);\n', '    preITO.transferOwnership(manager);\n', '    ito.transferOwnership(manager);\n', '  }\n', '\n', '}']