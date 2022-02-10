['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner{\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title \n', ' * @dev Very simple ERC20 Token that can be minted.\n', ' * It is meant to be used in a crowdsale contract.\n', ' */\n', 'contract ChariotToken is StandardToken, Ownable {\n', '\n', '  string public constant name = "Chariot Coin";\n', '  string public constant symbol = "TOM";\n', '  uint8 public constant decimals = 18;\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '  event MintPaused(bool pause);\n', '\n', '  bool public mintingFinished = false;\n', '  bool public mintingPaused = false;\n', '  address public saleAgent = address(0);\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  modifier unpauseMint() {\n', '    require(!mintingPaused);\n', '    _;\n', '  }\n', '\n', '  function setSaleAgent(address newSaleAgnet) public {\n', '    require(msg.sender == saleAgent || msg.sender == owner);\n', '    saleAgent = newSaleAgnet;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to pause/unpause minting new tokens.\n', '   * @return True if minting was pause.\n', '   * @return False if minting was unpause\n', '   */\n', '  function pauseMinting(bool _mintingPaused) canMint public returns (bool) {\n', '    require((msg.sender == saleAgent || msg.sender == owner));\n', '    mintingPaused = _mintingPaused;\n', '    MintPaused(_mintingPaused);\n', '    return _mintingPaused;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) canMint unpauseMint public returns (bool) {\n', '    require(msg.sender == saleAgent || msg.sender == owner);\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(this), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() canMint public returns (bool) {\n', '    require((msg.sender == saleAgent || msg.sender == owner));\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '\n', '  function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(msg.sender == saleAgent || msg.sender == owner);\n', '        require(balances[_from] >= _value);// Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);// Check allowance\n', '        balances[_from] = balances[_from].sub(_value); // Subtract from the targeted balance\n', "        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // Subtract from the sender's allowance\n", '        totalSupply = totalSupply.sub(_value);\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract TokenSale is Ownable{\n', '  using SafeMath for uint256;\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '   // The token being sold\n', '  ChariotToken public token;\n', '\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  uint256 public initialSupply = 37600000 * 1 ether;\n', '\n', '  // bool public checkDiscountStage = true;\n', '  uint256 limit;\n', '  uint256 period;\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // one token per one rate, token default = 0.001 ETH = 1 TOM\n', '  uint256 public rate = 1000;\n', '\n', '  // Company addresses\n', '  address public TeamAndAdvisors;\n', '  address public Investors;\n', '  address public EADC;\n', '  address public Bounty;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '  uint256 public weiSoftCap = 800 * 1 ether;\n', '  uint256 public weiHardCap = 1600 * 1 ether;\n', '\n', '  modifier saleIsOn() {\n', '      require(now > startTime && now < endTime);\n', '      require(weiRaised <= weiHardCap);\n', '      require(initialSupply >= token.totalSupply());\n', '      _;\n', '  }\n', '\n', '  uint256 discountStage1 = 60;\n', '  uint256 discountStage2 = 55;\n', '  uint256 discountStage3 = 50;\n', '  uint256 discountStage4 = 40;\n', '\n', '  function setDiscountStage(\n', '    uint256 _newDiscountStage1,\n', '    uint256 _newDiscountStage2,\n', '    uint256 _newDiscountStage3,\n', '    uint256 _newDiscountStage4\n', '    ) onlyOwner public {\n', '    discountStage1 = _newDiscountStage1;\n', '    discountStage2 = _newDiscountStage2;\n', '    discountStage3 = _newDiscountStage3;\n', '    discountStage4 = _newDiscountStage4;\n', '  }\n', '\n', '  function setTime(uint _startTime, uint _endTime) public onlyOwner {\n', '    require(now < _endTime && _startTime < _endTime);\n', '    endTime = _endTime;\n', '    startTime = _startTime;\n', '  }\n', '\n', '  function setRate(uint _newRate) public onlyOwner {\n', '    rate = _newRate;\n', '  }\n', '\n', '  function setTeamAddress(\n', '    address _TeamAndAdvisors,\n', '    address _Investors,\n', '    address _EADC,\n', '    address _Bounty,\n', '    address _wallet) public onlyOwner {\n', '    TeamAndAdvisors = _TeamAndAdvisors;\n', '    Investors = _Investors;\n', '    EADC = _EADC;\n', '    Bounty = _Bounty;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  function getDiscountStage() public view returns (uint256) {\n', '    if(now < startTime + 5 days) {\n', '        return discountStage1;\n', '      } else if(now >= startTime + 5 days && now < startTime + 10 days) {\n', '        return discountStage2;\n', '      } else if(now >= startTime + 10 days && now < startTime + 15 days) {\n', '        return discountStage3;\n', '      } else if(now >= startTime + 15 days && now < endTime) {\n', '        return discountStage4;\n', '      }\n', '  }\n', '\n', '  /**\n', '   * events for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  event TokenPartners(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '  function TokenSale(\n', '    uint256 _startTime,\n', '    uint256 _endTime,\n', '    address _wallet,\n', '    uint256 _limit,\n', '    uint256 _period,\n', '    address _TeamAndAdvisors,\n', '    address _Investors,\n', '    address _Bounty,\n', '    address _EADC\n', '    ) public {\n', '    require(_wallet != address(0));\n', '    require(_TeamAndAdvisors != address(0));\n', '    require(_Investors != address(0));\n', '    require(_EADC != address(0));\n', '    require(_Bounty != address(0));\n', '    require(_endTime > _startTime);\n', '    require(now < _startTime);\n', '    token = new ChariotToken();\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    wallet = _wallet;\n', '    limit = _limit * 1 ether;\n', '    period = _period;\n', '    TeamAndAdvisors = _TeamAndAdvisors;\n', '    Investors = _Investors;\n', '    EADC = _EADC;\n', '    Bounty = _Bounty;\n', '    token.setSaleAgent(owner);\n', '  }\n', '\n', '  function updatePrice() returns(uint256){\n', '    uint256 _days = now.sub(startTime).div(1 days); // days after startTime\n', '    return (_days % period).add(1).mul(rate); // rate in this period\n', '  }\n', '  \n', '  function setLimit(uint256 _newLimit) public onlyOwner {\n', '    limit = _newLimit * 1 ether;\n', '  }\n', '\n', '  // @ value - tokens for sale\n', '  function isUnderLimit(uint256 _value) public returns (bool){\n', '    uint256 _days = now.sub(startTime).div(1 days); // days after startTime\n', '    uint256 coinsLimit = (_days % period).add(1).mul(limit); // limit coins in this period\n', '    return (msg.sender).balance.add(_value) <= coinsLimit;\n', '  }\n', '\n', '  function buyTokens(address beneficiary) saleIsOn public payable {\n', '    require(beneficiary != address(0));\n', '\n', '    uint256 weiAmount = msg.value;\n', '    uint256 all = 100;\n', '    uint256 tokens;\n', '    \n', '    // calculate token amount to be created\n', '    tokens = weiAmount.mul(updatePrice()).mul(100).div(all.sub(getDiscountStage()));\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    if(endTime.sub(now).div(1 days) > 5) {\n', '      require(isUnderLimit(tokens));\n', '    }\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    wallet.transfer(weiAmount.mul(30).div(100));\n', '    Investors.transfer(weiAmount.mul(65).div(100));\n', '    EADC.transfer(weiAmount.mul(5).div(100));\n', '\n', '    uint256 taaTokens = tokens.mul(27).div(100);\n', '    uint256 bountyTokens = tokens.mul(3).div(100);\n', '\n', '    token.mint(TeamAndAdvisors, taaTokens);\n', '    token.mint(Bounty, bountyTokens);\n', '\n', '    TokenPartners(msg.sender, TeamAndAdvisors, taaTokens);\n', '    TokenPartners(msg.sender, Bounty, bountyTokens);  \n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // @return true if tokensale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    return now > endTime;\n', '  }\n', '}']