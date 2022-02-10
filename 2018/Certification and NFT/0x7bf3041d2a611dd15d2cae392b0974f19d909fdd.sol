['pragma solidity ^0.4.18;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BurnableToken.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/CappedToken.sol\n', '\n', '/**\n', ' * @title Capped token\n', ' * @dev Mintable token with a token cap.\n', ' */\n', '\n', 'contract CappedToken is MintableToken {\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedToken(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    require(totalSupply.add(_amount) <= cap);\n', '\n', '    return super.mint(_to, _amount);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/MMMbCoin.sol\n', '\n', 'contract MMMbCoin is CappedToken, BurnableToken {\n', '\n', '  string public constant name = "MMMbCoin Utils";\n', '  string public constant symbol = "MMB";\n', '  uint256 public constant decimals = 18;\n', '\n', '  function MMMbCoin(uint256 _cap) public CappedToken(_cap) {\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {\n', '    require(_startTime >= now);\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '\n', '    token = createTokenContract();\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // creates the token to be sold.\n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal view returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public view returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '\n', '}\n', '\n', '// File: contracts/MMMbCoinCrowdsale.sol\n', '\n', '// DateCoin \n', '\n', '\n', '// Zeppelin\n', '\n', '\n', '\n', 'contract MMMbCoinCrowdsale is Crowdsale, Ownable {\n', '  enum ManualState {\n', '    WORKING, READY, NONE\n', '  }\n', '\n', '  uint256 public decimals;\n', '  uint256 public emission;\n', '\n', '  // Discount border-lines\n', '  mapping(uint8 => uint256) discountTokens;\n', '  mapping(address => uint256) pendingOrders;\n', '\n', '  uint256 public totalSupply;\n', '  address public vault;\n', '  address public preSaleVault;\n', '  ManualState public manualState = ManualState.NONE;\n', '  bool public disabled = true;\n', '\n', '  function MMMbCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _tokenContractAddress, address _vault, address _preSaleVault) public\n', '    Crowdsale(_startTime, _endTime, _rate, _wallet)\n', '  {\n', '    require(_vault != address(0));\n', '\n', '    vault = _vault;\n', '    preSaleVault = _preSaleVault;\n', '\n', '    token = MMMbCoin(_tokenContractAddress);\n', '    decimals = MMMbCoin(token).decimals();\n', '\n', '    totalSupply = token.balanceOf(vault);\n', '\n', '    defineDiscountBorderLines();\n', '  }\n', '\n', '  // overriding Crowdsale#buyTokens\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != address(0));\n', '    require(validPurchase());\n', '\n', '    if (disabled) {\n', '      pendingOrders[msg.sender] = pendingOrders[msg.sender].add(msg.value);\n', '      forwardFunds();\n', '      return;\n', '    }\n', '\n', '    uint256 weiAmount = msg.value;\n', '    uint256 sold = totalSold();\n', '\n', '    uint256 tokens;\n', '\n', '    if (sold < _discount(25)) {\n', '      tokens = _calculateTokens(weiAmount, 25, sold);\n', '    }\n', '    else if (sold >= _discount(25) && sold < _discount(20)) {\n', '      tokens = _calculateTokens(weiAmount, 20, sold);\n', '    }\n', '    else if (sold >= _discount(20) && sold < _discount(15)) {\n', '      tokens = _calculateTokens(weiAmount, 15, sold);\n', '    }\n', '    else if (sold >= _discount(15) && sold < _discount(10)) {\n', '      tokens = _calculateTokens(weiAmount, 10, sold);\n', '    }\n', '    else if (sold >= _discount(10) && sold < _discount(5)) {\n', '      tokens = _calculateTokens(weiAmount, 5, sold);\n', '    }\n', '    else {\n', '      tokens = weiAmount.mul(rate);\n', '    }\n', '\n', '    // Check limit\n', '    require(sold.add(tokens) <= totalSupply);\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    token.transferFrom(vault, beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  function totalSold() public view returns(uint256) {\n', '    return totalSupply.sub(token.balanceOf(vault));\n', '  }\n', '\n', '  /**\n', '    * @dev This method is allowed to transfer tokens to _to account\n', '    * @param _to target account address\n', '    * @param _amount amout of buying tokens\n', '    */\n', '  function transferTokens(address _to, uint256 _amount) public onlyOwner {\n', '    require(!hasEnded());\n', '    require(_to != address(0));\n', '    require(_amount != 0);\n', '    require(token.balanceOf(vault) >= _amount);\n', '\n', '    token.transferFrom(vault, _to, _amount);\n', '  }\n', '\n', '  function transferPreSaleTokens(address _to, uint256 tokens) public onlyOwner {\n', '    require(_to != address(0));\n', '    require(tokens != 0);\n', '    require(tokens < token.balanceOf(preSaleVault));\n', '\n', '    token.transferFrom(preSaleVault, _to, tokens);\n', '  }\n', '\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    token.transferOwnership(_newOwner);\n', '  }\n', '\n', '  // This method is used for definition of discountTokens borderlines\n', '  function defineDiscountBorderLines() internal onlyOwner {\n', '    discountTokens[25] = 57 * (100000 ether);\n', '    discountTokens[20] = 171 * (100000 ether);\n', '    discountTokens[15] = 342 * (100000 ether);\n', '    discountTokens[10] = 570 * (100000 ether);\n', '    discountTokens[5] = 855 * (100000 ether);\n', '  }\n', '\n', '  /**\n', '    * @dev overriding Crowdsale#validPurchase to add extra sale limit logic\n', '    * @return true if investors can buy at the moment\n', '    */\n', '  function validPurchase() internal view returns(bool) {\n', '    uint256 weiValue = msg.value;\n', '\n', '    bool defaultCase = super.validPurchase();\n', '    bool capCase = token.balanceOf(vault) > 0;\n', '    bool extraCase = weiValue != 0 && capCase && manualState == ManualState.WORKING;\n', '    return defaultCase && capCase || extraCase;\n', '  }\n', '\n', '  /** \n', '    * @dev overriding Crowdsale#hasEnded to add sale limit logic\n', '    * @return true if crowdsale event has ended\n', '    */\n', '  function hasEnded() public view returns (bool) {\n', '    if (manualState == ManualState.WORKING) {\n', '      return false;\n', '    }\n', '    else if (manualState == ManualState.READY) {\n', '      return true;\n', '    }\n', '    bool icoLimitReached = token.balanceOf(vault) == 0;\n', '    return super.hasEnded() || icoLimitReached;\n', '  }\n', '\n', '  /**\n', '    * @dev this method allows to finish crowdsale prematurely\n', '    */\n', '  function finishCrowdsale() public onlyOwner {\n', '    manualState = ManualState.READY;\n', '  }\n', '\n', '\n', '  /**\n', '    * @dev this method allows to start crowdsale prematurely\n', '    */\n', '  function startCrowdsale() public onlyOwner {\n', '    manualState = ManualState.WORKING;\n', '  }\n', '\n', '  /**\n', '    * @dev this method allows to drop manual state of contract \n', '    */\n', '  function dropManualState() public onlyOwner {\n', '    manualState = ManualState.NONE;\n', '  }\n', '\n', '  /**\n', '    * @dev disable automatically seller\n', '    */\n', '  function disableAutoSeller() public onlyOwner {\n', '    disabled = true;\n', '  }\n', '\n', '  /**\n', '    * @dev enable automatically seller\n', '    */\n', '  function enableAutoSeller() public onlyOwner {\n', '    disabled = false;\n', '  }\n', '\n', '  /**\n', '    * @dev this method is used for getting information about account pending orders\n', '    * @param _account which is checked\n', '    * @return has or not\n', '    */\n', '  function hasAccountPendingOrders(address _account) public view returns(bool) {\n', '    return pendingOrders[_account] > 0;\n', '  }\n', '\n', '  /**\n', '    * @dev this method is used for getting account pending value\n', '    * @param _account which is checked\n', '    * @return if account doesn&#39;t have any pending orders, it will return 0\n', '    */\n', '  function getAccountPendingValue(address _account) public view returns(uint256) {\n', '    return pendingOrders[_account];\n', '  }\n', '\n', '  function _discount(uint8 _percent) internal view returns (uint256) {\n', '    return discountTokens[_percent];\n', '  }\n', '\n', '  function _calculateTokens(uint256 _value, uint8 _off, uint256 _sold) internal view returns (uint256) {\n', '    uint256 withoutDiscounts = _value.mul(rate);\n', '    uint256 byDiscount = withoutDiscounts.mul(100).div(100 - _off);\n', '    if (_sold.add(byDiscount) > _discount(_off)) {\n', '      uint256 couldBeSold = _discount(_off).sub(_sold);\n', '      uint256 weiByDiscount = couldBeSold.div(rate).div(100).mul(100 - _off);\n', '      uint256 weiLefts = _value.sub(weiByDiscount);\n', '      uint256 withoutDiscountLeft = weiLefts.mul(rate);\n', '      uint256 byNextDiscount = withoutDiscountLeft.mul(100).div(100 - _off + 5);\n', '      return couldBeSold.add(byNextDiscount);\n', '    }\n', '    return byDiscount;\n', '  }\n', '}']