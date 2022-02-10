['pragma solidity ^0.4.24;\n', '\n', '/*\n', ' * Part of Daonomic platform (daonomic.io)\n', ' */\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 _value) public {\n', '    _burn(msg.sender, _value);\n', '  }\n', '\n', '  function _burn(address _who, uint256 _value) internal {\n', '    require(_value <= balances[_who]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    balances[_who] = balances[_who].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    emit Burn(_who, _value);\n', '    emit Transfer(_who, address(0), _value);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard Burnable Token\n', ' * @dev Adds burnFrom method to ERC20 implementations\n', ' */\n', 'contract StandardBurnableToken is BurnableToken, StandardToken {\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _value uint256 The amount of token to be burned\n', '   */\n', '  function burnFrom(address _from, uint256 _value) public {\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    _burn(_from, _value);\n', '  }\n', '}\n', '\n', 'contract WgdToken is StandardBurnableToken {\n', '  string public constant name = "webGold";\n', '  string public constant symbol = "WGD";\n', '  uint8 public constant decimals = 18;\n', '\n', '  constructor(uint _total) public {\n', '    balances[msg.sender] = _total;\n', '    totalSupply_ = _total;\n', '    emit Transfer(address(0), msg.sender, _total);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale,\n', ' * allowing investors to purchase tokens with ether. This contract implements\n', ' * such functionality in its most fundamental form and can be extended to provide additional\n', ' * functionality and/or custom behavior.\n', ' * The external interface represents the basic interface for purchasing tokens, and conform\n', ' * the base architecture for crowdsales. They are *not* intended to be modified / overriden.\n', ' * The internal interface conforms the extensible and modifiable surface of crowdsales. Override\n', ' * the methods to add functionality. Consider using &#39;super&#39; where appropiate to concatenate\n', ' * behavior.\n', ' */\n', 'contract DaonomicCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // Amount of wei raised\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * @dev This event should be emitted when user buys something\n', '   */\n', '  event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus, bytes txId);\n', '  /**\n', '   * @dev Should be emitted if new payment method added\n', '   */\n', '  event RateAdd(address token);\n', '  /**\n', '   * @dev Should be emitted if payment method removed\n', '   */\n', '  event RateRemove(address token);\n', '\n', '  // -----------------------------------------\n', '  // Crowdsale external interface\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev fallback function ***DO NOT OVERRIDE***\n', '   */\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev low level token purchase ***DO NOT OVERRIDE***\n', '   * @param _beneficiary Address performing the token purchase\n', '   */\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '    // calculate token amount to be created\n', '    (uint256 tokens, uint256 left) = _getTokenAmount(weiAmount);\n', '    uint256 weiEarned = weiAmount.sub(left);\n', '    uint256 bonus = _getBonus(tokens);\n', '    uint256 withBonus = tokens.add(bonus);\n', '    if (left > 0) {\n', '      _beneficiary.send(left);\n', '    }\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiEarned);\n', '\n', '    _processPurchase(_beneficiary, withBonus);\n', '    emit Purchase(\n', '      _beneficiary,\n', '      address(0),\n', '        weiEarned,\n', '      tokens,\n', '      bonus,\n', '      ""\n', '    );\n', '\n', '    _updatePurchasingState(_beneficiary, weiEarned, withBonus);\n', '    _postValidatePurchase(_beneficiary, weiEarned);\n', '  }\n', '\n', '  // -----------------------------------------\n', '  // Internal interface (extensible)\n', '  // -----------------------------------------\n', '\n', '  /**\n', '   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _postValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.\n', '   * @param _beneficiary Address performing the token purchase\n', '   * @param _tokenAmount Number of tokens to be emitted\n', '   */\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  ) internal;\n', '\n', '  /**\n', '   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _tokenAmount Number of tokens to be purchased\n', '   */\n', '  function _processPurchase(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  )\n', '    internal\n', '  {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  /**\n', '   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)\n', '   * @param _beneficiary Address receiving the tokens\n', '   * @param _weiAmount Value in wei involved in the purchase\n', '   */\n', '  function _updatePurchasingState(\n', '    address _beneficiary,\n', '    uint256 _weiAmount,\n', '    uint256 _tokens\n', '  )\n', '    internal\n', '  {\n', '    // optional override\n', '  }\n', '\n', '  /**\n', '   * @dev Override to extend the way in which ether is converted to tokens.\n', '   * @param _weiAmount Value in wei to be converted into tokens\n', '   * @return Number of tokens that can be purchased with the specified _weiAmount\n', '   *         and wei left (if no more tokens can be sold)\n', '   */\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256, uint256);\n', '\n', '  function _getBonus(uint256 _tokens) internal view returns (uint256);\n', '}\n', '\n', 'contract Whitelist {\n', '  function isInWhitelist(address addr) view public returns (bool);\n', '}\n', '\n', 'contract WhitelistDaonomicCrowdsale is Ownable, DaonomicCrowdsale {\n', '  Whitelist[] public whitelists;\n', '\n', '  constructor (Whitelist[] _whitelists) public {\n', '    whitelists = _whitelists;\n', '  }\n', '\n', '  function setWhitelists(Whitelist[] _whitelists) onlyOwner public {\n', '    whitelists = _whitelists;\n', '  }\n', '\n', '  function getWhitelists() view public returns (Whitelist[]) {\n', '    return whitelists;\n', '  }\n', '\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  ) internal {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(canBuy(_beneficiary), "investor is not verified by Whitelists");\n', '  }\n', '\n', '  function canBuy(address _beneficiary) constant public returns (bool) {\n', '    for (uint i = 0; i < whitelists.length; i++) {\n', '      if (whitelists[i].isInWhitelist(_beneficiary)) {\n', '        return true;\n', '      }\n', '    }\n', '    return false;\n', '  }\n', '}\n', '\n', 'contract RefundableDaonomicCrowdsale is DaonomicCrowdsale {\n', '  event Refund(address _address, uint256 investment);\n', '  mapping(address => uint256) investments;\n', '\n', '  function _updatePurchasingState(\n', '    address _beneficiary,\n', '    uint256 _weiAmount,\n', '    uint256 _tokens\n', '  ) internal {\n', '    super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);\n', '    investments[_beneficiary] = investments[_beneficiary].add(_weiAmount);\n', '  }\n', '\n', '  function claimRefund() public {\n', '    require(isRefundable());\n', '    require(investments[msg.sender] > 0);\n', '\n', '    uint investment = investments[msg.sender];\n', '    investments[msg.sender] = 0;\n', '\n', '    msg.sender.send(investment);\n', '    emit Refund(msg.sender, investment);\n', '  }\n', '\n', '  function isRefundable() view public returns (bool);\n', '}\n', '\n', 'contract WgdSale is WhitelistDaonomicCrowdsale, RefundableDaonomicCrowdsale {\n', '  using SafeERC20 for WgdToken;\n', '\n', '  event Buyback(address indexed addr, uint256 tokens, uint256 value);\n', '\n', '  WgdToken public token;\n', '\n', '  uint256 public forSale;\n', '  uint256 public sold;\n', '  uint256 public minimalWei;\n', '  uint256 public end;\n', '  uint256[] public stages;\n', '  uint256[] public rates;\n', '  uint256[] public bonusStages;\n', '  uint256[] public bonuses;\n', '\n', '  constructor(WgdToken _token, uint256 _end, uint256 _minimalWei, uint256[] _stages, uint256[] _rates, uint256[] _bonusStages, uint256[] _bonuses, Whitelist[] _whitelists)\n', '  WhitelistDaonomicCrowdsale(_whitelists) public {\n', '    require(_stages.length == _rates.length);\n', '    require(_bonusStages.length == _bonuses.length);\n', '\n', '    token = _token;\n', '    end = _end;\n', '    minimalWei = _minimalWei;\n', '    stages = _stages;\n', '    rates = _rates;\n', '    bonusStages = _bonusStages;\n', '    bonuses = _bonuses;\n', '    forSale = stages[stages.length - 1];\n', '\n', '    emit RateAdd(address(0));\n', '  }\n', '\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  ) internal {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(_weiAmount >= minimalWei);\n', '  }\n', '\n', '  /**\n', '   * @dev function for Daonomic UI\n', '   */\n', '  function getRate(address _token) view public returns (uint256) {\n', '    if (_token == address(0)) {\n', '      uint8 stage = getStage(sold);\n', '      if (stage == stages.length) {\n', '        return 0;\n', '      }\n', '      return rates[stage] * 10 ** 18;\n', '    } else {\n', '      return 0;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Executes buyback\n', '   * @dev burns all allowed tokens and returns back Eth\n', '   * @dev call token.approve before calling this function\n', '   */\n', '  function buyback() public {\n', '    require(getStage(sold) > 0, "buyback doesn&#39;t work on stage 0");\n', '\n', '    uint256 approved = token.allowance(msg.sender, this);\n', '    uint256 inCirculation = token.totalSupply().sub(token.balanceOf(this));\n', '    uint256 value = approved.mul(this.balance).div(inCirculation);\n', '\n', '    token.burnFrom(msg.sender, approved);\n', '    msg.sender.send(value);\n', '    emit Buyback(msg.sender, approved, value);\n', '  }\n', '\n', '  function _deliverTokens(\n', '    address _beneficiary,\n', '    uint256 _tokenAmount\n', '  ) internal {\n', '    token.safeTransfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  function _getBonus(uint256 _tokens) internal view returns (uint256) {\n', '    return getRealAmountBonus(forSale, sold, _tokens);\n', '  }\n', '\n', '  function getRealAmountBonus(uint256 _forSale, uint256 _sold, uint256 _tokens) public view returns (uint256) {\n', '    uint256 bonus = getAmountBonus(_tokens);\n', '    uint256 left = _forSale.sub(_sold).sub(_tokens);\n', '    if (left > bonus) {\n', '      return bonus;\n', '    } else {\n', '      return left;\n', '    }\n', '  }\n', '\n', '  function getAmountBonus(uint256 _tokens) public view returns (uint256) {\n', '    uint256 currentBonus = 0;\n', '    for (uint8 i = 0; i < bonuses.length; i++) {\n', '      if (_tokens < bonusStages[i]) {\n', '        return currentBonus;\n', '      }\n', '      currentBonus = bonuses[i];\n', '    }\n', '    return currentBonus;\n', '  }\n', '\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256, uint256) {\n', '    return getTokenAmount(sold, _weiAmount);\n', '  }\n', '\n', '  function getTokenAmount(uint256 _sold, uint256 _weiAmount) public view returns (uint256 tokens, uint256 left) {\n', '    left = _weiAmount;\n', '    while (left > 0) {\n', '      (uint256 currentTokens, uint256 currentLeft) = getTokensForStage(_sold.add(tokens), left);\n', '      if (left == currentLeft) {\n', '        return (tokens, left);\n', '      }\n', '      left = currentLeft;\n', '      tokens = tokens.add(currentTokens);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Calculates tokens for this stage\n', '   * @return Number of tokens that can be purchased in this stage + wei left\n', '   */\n', '  function getTokensForStage(uint256 _sold, uint256 _weiAmount) public view returns (uint256 tokens, uint256 left) {\n', '    uint8 stage = getStage(_sold);\n', '    if (stage == stages.length) {\n', '      return (0, _weiAmount);\n', '    }\n', '    if (stage == 0 && now > end) {\n', '      revert("Sale is refundable, unable to buy");\n', '    }\n', '    uint256 rate = rates[stage];\n', '\n', '    tokens = _weiAmount.mul(rate);\n', '    left = 0;\n', '    uint8 newStage = getStage(_sold.add(tokens));\n', '    if (newStage != stage) {\n', '      tokens = stages[stage].sub(_sold);\n', '      uint256 weiSpent = (tokens.add(rate).sub(1)).div(rate);\n', '      left = _weiAmount.sub(weiSpent);\n', '    }\n', '  }\n', '\n', '  function getStage(uint256 _sold) public view returns (uint8) {\n', '    for (uint8 i = 0; i < stages.length; i++) {\n', '      if (_sold < stages[i]) {\n', '        return i;\n', '      }\n', '    }\n', '    return uint8(stages.length);\n', '  }\n', '\n', '  function _updatePurchasingState(\n', '    address _beneficiary,\n', '    uint256 _weiAmount,\n', '    uint256 _tokens\n', '  ) internal {\n', '    super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);\n', '\n', '    sold = sold.add(_tokens);\n', '  }\n', '\n', '  function isRefundable() view public returns (bool) {\n', '    return now > end && getStage(sold) == 0;\n', '  }\n', '}']