['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end block where investments are allowed (both inclusive)\n', '  uint256 public startBlock;\n', '  uint256 public endBlock;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */ \n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {\n', '    require(_startBlock >= block.number);\n', '    require(_endBlock >= _startBlock);\n', '    require(_rate > 0);\n', '    require(_wallet != 0x0);\n', '\n', '    token = createTokenContract();\n', '    startBlock = _startBlock;\n', '    endBlock = _endBlock;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // creates the token to be sold. \n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    uint256 current = block.number;\n', '    bool withinPeriod = current >= startBlock && current <= endBlock;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return block.number > endBlock;\n', '  }\n', '\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract FinalizableCrowdsale is Crowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  // should be called after crowdsale ends, to do\n', '  // some extra finalization work\n', '  function finalize() onlyOwner {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '\n', '    finalization();\n', '    Finalized();\n', '    \n', '    isFinalized = true;\n', '  }\n', '\n', '  // end token minting on finalization\n', '  // override this with custom logic if needed\n', '  function finalization() internal {\n', '    token.finishMinting();\n', '  }\n', '\n', '\n', '\n', '}\n', '\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedCrowdsale(uint256 _cap) {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return super.validPurchase() && withinCap;\n', '  }\n', '\n', '  // overriding Crowdsale#hasEnded to add cap logic\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return super.hasEnded() || capReached;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract RenderToken is MintableToken {\n', '\n', '  string public constant name = "Render Token";\n', '  string public constant symbol = "RNDR";\n', '  uint8 public constant decimals = 18;\n', '\n', '}\n', '\n', 'contract RenderTokenCrowdsale is CappedCrowdsale, FinalizableCrowdsale {\n', '\n', '  address public foundationAddress;\n', '  address public foundersAddress;\n', '\n', '  mapping(address => bool) public whitelistedAddrs;\n', '\n', '  modifier fromWhitelistedAddr(){\n', '    require(whitelistedAddrs[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  function RenderTokenCrowdsale(\n', '    uint256 startBlock, uint256 endBlock,\n', '    uint256 rate, uint256 cap, address wallet,\n', '    address _foundationAddress, address _foundersAddress\n', '  ) CappedCrowdsale(cap)\n', '    FinalizableCrowdsale()\n', '    Crowdsale(startBlock, endBlock, rate, wallet)\n', '  {\n', '    require(_foundationAddress != address(0));\n', '    require(_foundersAddress != address(0));\n', '\n', '    foundationAddress = _foundationAddress;\n', '    foundersAddress = _foundersAddress;\n', '  }\n', '\n', '  // override buyTokens function to allow only whitelisted addresses buy\n', '  function buyTokens(address beneficiary) fromWhitelistedAddr() payable {\n', '    super.buyTokens(beneficiary);\n', '  }\n', '\n', '  // add a whitelisted address\n', '  function addWhitelistedAddr(address whitelistedAddr) onlyOwner {\n', '    require(!whitelistedAddrs[whitelistedAddr]);\n', '    whitelistedAddrs[whitelistedAddr] = true;\n', '  }\n', '\n', '  // remove a whitelisted address\n', '  function removeWhitelistedAddr(address whitelistedAddr) onlyOwner {\n', '    require(whitelistedAddrs[whitelistedAddr]);\n', '    whitelistedAddrs[whitelistedAddr] = false;\n', '  }\n', '\n', '  // finalization function called by the finalize function that will distribute\n', '  // the remaining tokens\n', '  function finalization() internal {\n', '    uint256 tokensSold = token.totalSupply();\n', '    uint256 finalTotalSupply = cap.mul(rate).mul(4);\n', '\n', '    // send the 10% of the final total supply to the founders\n', '    uint256 foundersTokens = finalTotalSupply.div(10);\n', '    token.mint(foundersAddress, foundersTokens);\n', '\n', '    // send the 65% plus the unsold tokens in ICO to the foundation\n', '    uint256 foundationTokens = finalTotalSupply.sub(tokensSold)\n', '      .sub(foundersTokens);\n', '    token.mint(foundationAddress, foundationTokens);\n', '\n', '    super.finalization();\n', '  }\n', '\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new RenderToken();\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  MintableToken public token;\n', '\n', '  // start and end block where investments are allowed (both inclusive)\n', '  uint256 public startBlock;\n', '  uint256 public endBlock;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */ \n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {\n', '    require(_startBlock >= block.number);\n', '    require(_endBlock >= _startBlock);\n', '    require(_rate > 0);\n', '    require(_wallet != 0x0);\n', '\n', '    token = createTokenContract();\n', '    startBlock = _startBlock;\n', '    endBlock = _endBlock;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // creates the token to be sold. \n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    uint256 current = block.number;\n', '    bool withinPeriod = current >= startBlock && current <= endBlock;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return block.number > endBlock;\n', '  }\n', '\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract FinalizableCrowdsale is Crowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  // should be called after crowdsale ends, to do\n', '  // some extra finalization work\n', '  function finalize() onlyOwner {\n', '    require(!isFinalized);\n', '    require(hasEnded());\n', '\n', '    finalization();\n', '    Finalized();\n', '    \n', '    isFinalized = true;\n', '  }\n', '\n', '  // end token minting on finalization\n', '  // override this with custom logic if needed\n', '  function finalization() internal {\n', '    token.finishMinting();\n', '  }\n', '\n', '\n', '\n', '}\n', '\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedCrowdsale(uint256 _cap) {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return super.validPurchase() && withinCap;\n', '  }\n', '\n', '  // overriding Crowdsale#hasEnded to add cap logic\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return super.hasEnded() || capReached;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract RenderToken is MintableToken {\n', '\n', '  string public constant name = "Render Token";\n', '  string public constant symbol = "RNDR";\n', '  uint8 public constant decimals = 18;\n', '\n', '}\n', '\n', 'contract RenderTokenCrowdsale is CappedCrowdsale, FinalizableCrowdsale {\n', '\n', '  address public foundationAddress;\n', '  address public foundersAddress;\n', '\n', '  mapping(address => bool) public whitelistedAddrs;\n', '\n', '  modifier fromWhitelistedAddr(){\n', '    require(whitelistedAddrs[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  function RenderTokenCrowdsale(\n', '    uint256 startBlock, uint256 endBlock,\n', '    uint256 rate, uint256 cap, address wallet,\n', '    address _foundationAddress, address _foundersAddress\n', '  ) CappedCrowdsale(cap)\n', '    FinalizableCrowdsale()\n', '    Crowdsale(startBlock, endBlock, rate, wallet)\n', '  {\n', '    require(_foundationAddress != address(0));\n', '    require(_foundersAddress != address(0));\n', '\n', '    foundationAddress = _foundationAddress;\n', '    foundersAddress = _foundersAddress;\n', '  }\n', '\n', '  // override buyTokens function to allow only whitelisted addresses buy\n', '  function buyTokens(address beneficiary) fromWhitelistedAddr() payable {\n', '    super.buyTokens(beneficiary);\n', '  }\n', '\n', '  // add a whitelisted address\n', '  function addWhitelistedAddr(address whitelistedAddr) onlyOwner {\n', '    require(!whitelistedAddrs[whitelistedAddr]);\n', '    whitelistedAddrs[whitelistedAddr] = true;\n', '  }\n', '\n', '  // remove a whitelisted address\n', '  function removeWhitelistedAddr(address whitelistedAddr) onlyOwner {\n', '    require(whitelistedAddrs[whitelistedAddr]);\n', '    whitelistedAddrs[whitelistedAddr] = false;\n', '  }\n', '\n', '  // finalization function called by the finalize function that will distribute\n', '  // the remaining tokens\n', '  function finalization() internal {\n', '    uint256 tokensSold = token.totalSupply();\n', '    uint256 finalTotalSupply = cap.mul(rate).mul(4);\n', '\n', '    // send the 10% of the final total supply to the founders\n', '    uint256 foundersTokens = finalTotalSupply.div(10);\n', '    token.mint(foundersAddress, foundersTokens);\n', '\n', '    // send the 65% plus the unsold tokens in ICO to the foundation\n', '    uint256 foundationTokens = finalTotalSupply.sub(tokensSold)\n', '      .sub(foundersTokens);\n', '    token.mint(foundationAddress, foundationTokens);\n', '\n', '    super.finalization();\n', '  }\n', '\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new RenderToken();\n', '  }\n', '\n', '}']
