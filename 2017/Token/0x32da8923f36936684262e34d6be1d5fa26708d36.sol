['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function () public payable {\n', '    revert();\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract LockableChanges is Ownable {\n', '    \n', '  bool public changesLocked;\n', '  \n', '  modifier notLocked() {\n', '    require(!changesLocked);\n', '    _;\n', '  }\n', '  \n', '  function lockChanges() public onlyOwner {\n', '    changesLocked = true;\n', '  }\n', '    \n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract GENSharesToken is StandardToken, Ownable {\t\n', '\n', '  using SafeMath for uint256;\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  event MintFinished();\n', '    \n', '  string public constant name = "GEN Shares";\n', '   \n', '  string public constant symbol = "GEN";\n', '    \n', '  uint32 public constant decimals = 18;\n', '\n', '  bool public mintingFinished = false;\n', ' \n', '  address public saleAgent;\n', '\n', '  function setSaleAgent(address newSaleAgent) public {\n', '    require(saleAgent == msg.sender || owner == msg.sender);\n', '    saleAgent = newSaleAgent;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) public returns (bool) {\n', '    require(!mintingFinished);\n', '    require(msg.sender == saleAgent);\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() public returns (bool) {\n', '    require(!mintingFinished);\n', '    require(msg.sender == owner || msg.sender == saleAgent);\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract CommonCrowdsale is Ownable, LockableChanges {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  uint public constant PERCENT_RATE = 100;\n', '\n', '  uint public price;\n', '\n', '  uint public minInvestedLimit;\n', '\n', '  uint public hardcap;\n', '\n', '  uint public start;\n', '\n', '  uint public end;\n', '\n', '  uint public invested;\n', '\n', '  uint public minted;\n', '  \n', '  address public wallet;\n', '\n', '  address public bountyTokensWallet;\n', '\n', '  address public devTokensWallet;\n', '\n', '  address public advisorsTokensWallet;\n', '\n', '  uint public bountyTokensPercent;\n', '\n', '  uint public devTokensPercent;\n', '\n', '  uint public advisorsTokensPercent;\n', '\n', '  struct Bonus {\n', '    uint periodInDays;\n', '    uint bonus;\n', '  }\n', '\n', '  Bonus[] public bonuses;\n', '\n', '  GENSharesToken public token;\n', '\n', '  modifier saleIsOn() {\n', '    require(msg.value >= minInvestedLimit && now >= start && now < end && invested < hardcap);\n', '    _;\n', '  }\n', '\n', '  function setHardcap(uint newHardcap) public onlyOwner notLocked { \n', '    hardcap = newHardcap;\n', '  }\n', ' \n', '  function setStart(uint newStart) public onlyOwner notLocked { \n', '    start = newStart;\n', '  }\n', '\n', '  function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner notLocked { \n', '    bountyTokensPercent = newBountyTokensPercent;\n', '  }\n', '\n', '  function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner notLocked { \n', '    advisorsTokensPercent = newAdvisorsTokensPercent;\n', '  }\n', '\n', '  function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner notLocked { \n', '    devTokensPercent = newDevTokensPercent;\n', '  }\n', '\n', '  function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner notLocked { \n', '    bountyTokensWallet = newBountyTokensWallet;\n', '  }\n', '\n', '  function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner notLocked { \n', '    advisorsTokensWallet = newAdvisorsTokensWallet;\n', '  }\n', '\n', '  function setDevTokensWallet(address newDevTokensWallet) public onlyOwner notLocked { \n', '    devTokensWallet = newDevTokensWallet;\n', '  }\n', '\n', '  function setEnd(uint newEnd) public onlyOwner notLocked { \n', '    require(start < newEnd);\n', '    end = newEnd;\n', '  }\n', '\n', '  function setToken(address newToken) public onlyOwner notLocked { \n', '    token = GENSharesToken(newToken);\n', '  }\n', '\n', '  function setWallet(address newWallet) public onlyOwner notLocked { \n', '    wallet = newWallet;\n', '  }\n', '\n', '  function setPrice(uint newPrice) public onlyOwner notLocked {\n', '    price = newPrice;\n', '  }\n', '\n', '  function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner notLocked {\n', '    minInvestedLimit = newMinInvestedLimit;\n', '  }\n', ' \n', '  function bonusesCount() public constant returns(uint) {\n', '    return bonuses.length;\n', '  }\n', '\n', '  function addBonus(uint limit, uint bonus) public onlyOwner notLocked {\n', '    bonuses.push(Bonus(limit, bonus));\n', '  }\n', '\n', '  function mintExtendedTokens() internal {\n', '    uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent);      \n', '    uint extendedTokens = minted.mul(extendedTokensPercent).div(PERCENT_RATE.sub(extendedTokensPercent));\n', '    uint summaryTokens = extendedTokens + minted;\n', '\n', '    uint bountyTokens = summaryTokens.mul(bountyTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(bountyTokensWallet, bountyTokens);\n', '\n', '    uint advisorsTokens = summaryTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);\n', '    mintAndSendTokens(advisorsTokensWallet, advisorsTokens);\n', '\n', '    uint devTokens = summaryTokens.sub(advisorsTokens).sub(bountyTokens);\n', '    mintAndSendTokens(devTokensWallet, devTokens);\n', '  }\n', '\n', '  function mintAndSendTokens(address to, uint amount) internal {\n', '    token.mint(to, amount);\n', '    minted = minted.add(amount);\n', '  }\n', '\n', '  function calculateAndTransferTokens() internal {\n', '    // update invested value\n', '    invested = invested.add(msg.value);\n', '\n', '    // calculate tokens\n', '    uint tokens = msg.value.mul(price).div(1 ether);\n', '    uint bonus = getBonus();\n', '    if(bonus > 0) {\n', '      tokens = tokens.add(tokens.mul(bonus).div(100));      \n', '    }\n', '    \n', '    // transfer tokens\n', '    mintAndSendTokens(msg.sender, tokens);\n', '  }\n', '\n', '  function getBonus() public constant returns(uint) {\n', '    uint prevTimeLimit = start;\n', '    for (uint i = 0; i < bonuses.length; i++) {\n', '      Bonus storage bonus = bonuses[i];\n', '      prevTimeLimit += bonus.periodInDays * 1 days;\n', '      if (now < prevTimeLimit)\n', '        return bonus.bonus;\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  function createTokens() public payable;\n', '\n', '  function() external payable {\n', '    createTokens();\n', '  }\n', '\n', '  function retrieveTokens(address anotherToken) public onlyOwner {\n', '    ERC20 alienToken = ERC20(anotherToken);\n', '    alienToken.transfer(wallet, token.balanceOf(this));\n', '  }\n', '\n', '}\n', '\n', 'contract Presale is CommonCrowdsale {\n', '  \n', '  uint public devLimit;\n', '\n', '  uint public softcap;\n', '  \n', '  bool public refundOn;\n', '\n', '  bool public softcapAchieved;\n', '\n', '  bool public devWithdrawn;\n', '\n', '  address public devWallet;\n', '\n', '  address public nextSaleAgent;\n', '\n', '  mapping (address => uint) public balances;\n', '\n', '  function setNextSaleAgent(address newNextSaleAgent) public onlyOwner notLocked {\n', '    nextSaleAgent = newNextSaleAgent;\n', '  }\n', '\n', '  function setSoftcap(uint newSoftcap) public onlyOwner notLocked {\n', '    softcap = newSoftcap;\n', '  }\n', '\n', '  function setDevWallet(address newDevWallet) public onlyOwner notLocked {\n', '    devWallet = newDevWallet;\n', '  }\n', '\n', '  function setDevLimit(uint newDevLimit) public onlyOwner notLocked {\n', '    devLimit = newDevLimit;\n', '  }\n', '\n', '  function refund() public {\n', '    require(now > start && refundOn && balances[msg.sender] > 0);\n', '    uint value = balances[msg.sender];\n', '    balances[msg.sender] = 0;\n', '    msg.sender.transfer(value);\n', '  } \n', '\n', '  function createTokens() public payable saleIsOn {\n', '    balances[msg.sender] = balances[msg.sender].add(msg.value);\n', '    calculateAndTransferTokens();\n', '    if(!softcapAchieved && invested >= softcap) {\n', '      softcapAchieved = true;      \n', '    }\n', '  } \n', '\n', '  function widthrawDev() public {\n', '    require(softcapAchieved);\n', '    require(devWallet == msg.sender || owner == msg.sender);\n', '    if(!devWithdrawn) {\n', '      devWithdrawn = true;\n', '      devWallet.transfer(devLimit);\n', '    }\n', '  } \n', '\n', '  function widthraw() public {\n', '    require(softcapAchieved);\n', '    require(owner == msg.sender);\n', '    widthrawDev();\n', '    wallet.transfer(this.balance);\n', '  } \n', '\n', '  function finishMinting() public onlyOwner {\n', '    if(!softcapAchieved) {\n', '      refundOn = true;      \n', '      token.finishMinting();\n', '    } else {\n', '      mintExtendedTokens();\n', '      token.setSaleAgent(nextSaleAgent);\n', '    }    \n', '  }\n', '\n', '}\n', '\n', 'contract ICO is CommonCrowdsale {\n', '  \n', '  function finishMinting() public onlyOwner {\n', '    mintExtendedTokens();\n', '    token.finishMinting();\n', '  }\n', '\n', '  function createTokens() public payable saleIsOn {\n', '    calculateAndTransferTokens();\n', '    wallet.transfer(msg.value);\n', '  } \n', '\n', '}\n', '\n', 'contract Deployer is Ownable {\n', '\n', '  Presale public presale;  \n', ' \n', '  ICO public ico;\n', '\n', '  GENSharesToken public token;\n', '\n', '  function deploy() public onlyOwner {\n', '    owner = 0x379264aF7df7CF8141a23bC989aa44266DDD2c62;  \n', '      \n', '    token = new GENSharesToken();\n', '    \n', '    presale = new Presale();\n', '    presale.setToken(token);\n', '    token.setSaleAgent(presale);\n', '    presale.setMinInvestedLimit(100000000000000000);  \n', '    presale.setPrice(250000000000000000000);\n', '    presale.setBountyTokensPercent(4);\n', '    presale.setAdvisorsTokensPercent(2);\n', '    presale.setDevTokensPercent(10);\n', '    presale.setSoftcap(40000000000000000000);\n', '    presale.setHardcap(50000000000000000000000);\n', '    presale.addBonus(7,50);\n', '    presale.addBonus(7,40);\n', '    presale.addBonus(100,35);\n', '    presale.setStart(1511571600);\n', '    presale.setEnd(1514156400);    \n', '    presale.setDevLimit(6000000000000000000);\n', '    presale.setWallet(0x4bB656423f5476FeC4AA729aB7B4EE0fc4d0B314);\n', '    presale.setBountyTokensWallet(0xcACBE5d8Fb017407907026804Fe8BE64B08511f4);\n', '    presale.setDevTokensWallet(0xa20C62282bEC52F9dA240dB8cFFc5B2fc8586652);\n', '    presale.setAdvisorsTokensWallet(0xD3D85a495c7E25eAd39793F959d04ACcDf87e01b);\n', '    presale.setDevWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);\n', '\n', '    ico = new ICO();\n', '    ico.setToken(token); \n', '    presale.setNextSaleAgent(ico);\n', '    ico.setMinInvestedLimit(100000000000000000);\n', '    ico.setPrice(250000000000000000000);\n', '    ico.setBountyTokensPercent(4);\n', '    ico.setAdvisorsTokensPercent(2);\n', '    ico.setDevTokensPercent(10);\n', '\n', '    ico.setHardcap(206000000000000000000000);\n', '    ico.addBonus(7,25);\n', '    ico.addBonus(14,10);\n', '    ico.setStart(1514163600);\n', '    ico.setEnd(1517356800);\n', '    ico.setWallet(0x65954fb8f45b40c9A60dffF3c8f4F39839Bf3596);\n', '    ico.setBountyTokensWallet(0x6b9f45A54cDe417640f7D49D13451D7e2e9b8918);\n', '    ico.setDevTokensWallet(0x55A9E5b55F067078E045c72088C3888Bbcd9a64b);\n', '    ico.setAdvisorsTokensWallet(0x3e11Ff0BDd160C1D85cdf04e012eA9286ae1A964);\n', '\n', '    presale.lockChanges();\n', '    ico.lockChanges();\n', '    \n', '    presale.transferOwnership(owner);\n', '    ico.transferOwnership(owner);\n', '    token.transferOwnership(owner);\n', '  }\n', '\n', '}']