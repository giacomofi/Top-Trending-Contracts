['pragma solidity ^0.4.21;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/PentacoreToken.sol\n', '\n', '/**\n', ' * @title Smart Contract which defines the token managed by the Pentacore Hedge Fund.\n', ' * @author Jordan Stojanovski\n', ' */\n', 'contract PentacoreToken is StandardToken {\n', '  using SafeMath for uint256;\n', '\n', '  string public name = &#39;PentacoreToken&#39;;\n', '  string public symbol = &#39;PENT&#39;;\n', '  uint256 public constant million = 1000000;\n', '  uint256 public constant tokenCap = 1000 * million; // one billion tokens\n', '  bool public isPaused = true;\n', '\n', '  // Unlike the common practice to put the whitelist checks in the crowdsale,\n', '  // the PentacoreToken does these tests itself.  This is mandated by legal\n', '  // issues, as follows:\n', '  // - The exchange can be anywhere and it should not be concerned with\n', '  //   Pentacore&#39;s whitelisting methods.  If the exchange desires, it can\n', '  //   perform its own KYC.\n', '  // - Even after the Crowdsale / ICO if a whitelisted owner tries to sell\n', '  //   their tokens to a non-whitelisted buyer (address), the seller shall be\n', '  //   directed to the KYC process to be whitelisted before the sale can proceed.\n', '  //   This prevents against selling tokens to buyers under embargo.\n', '  // - If the seller is removed from the whitelist prior to the sale attempt,\n', '  //   the corresponding sale should be reported to the authorities instead of\n', '  //   allowing the seller to proceed.  This is subject of further discussion.\n', '  mapping(address => bool) public whitelist;\n', '\n', '  // If set to true, allow transfers between any addresses regardless of whitelist.\n', '  // However, sale and/or redemption would still be not allowed regardless of this flag.\n', '  // In the future, if it is determined that it is legal to transfer but not sell and/or redeem,\n', '  // we could turn this flag on.\n', '  bool public isFreeTransferAllowed = false;\n', '\n', '  uint256 public tokenNAVMicroUSD; // Net Asset Value per token in MicroUSD (millionths of 1 US$)\n', '  uint256 public weiPerUSD; // How many Wei is one US$\n', '\n', '  // Who&#39;s Who\n', '  address public owner; // The owner of this contract.\n', '  address public kycAdmin; // The address of the caller which can update the KYC status of an address.\n', '  address public navAdmin; // The address of the caller which can update the NAV/USD and ETH/USD values.\n', '  address public crowdsale; //The address of the crowdsale contract.\n', '  address public redemption; // The address of the redemption contract.\n', '  address public distributedAutonomousExchange; // The address of the exchange contract.\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '  event Burn(uint256 amount);\n', '  event AddToWhitelist(address indexed beneficiary);\n', '  event RemoveFromWhitelist(address indexed beneficiary);\n', '\n', '  function PentacoreToken() public {\n', '    owner = msg.sender;\n', '    tokenNAVMicroUSD = million; // Initially 1 PENT = 1 US$ (a million millionths)\n', '    isFreeTransferAllowed = false;\n', '    isPaused = true;\n', '    totalSupply_ = 0; // No tokens exist at creation.  They are minted as sold.\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the authorized one.\n', '   * @param authorized the address of the authorized caller.\n', '   */\n', '  modifier onlyBy(address authorized) {\n', '    require(authorized != address(0));\n', '    require(msg.sender == authorized);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Pauses / unpauses the transferability of the token.\n', '   * @param _pause pause if true; unpause if false\n', '   */\n', '  function setPaused(bool _pause) public {\n', '    require(owner != address(0));\n', '    require(msg.sender == owner);\n', '\n', '    isPaused = _pause;\n', '  }\n', '\n', '  modifier notPaused() {\n', '    require(!isPaused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the owner.\n', '   * @param _address The address of the new owner of the Token Contract.\n', '   */\n', '  function transferOwnership(address _address) external onlyBy(owner) {\n', '    require(_address != address(0)); // Prevent rendering it unusable\n', '    owner = _address;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the PentacoreCrowdsale contract.\n', '   * @param _address PentacoreCrowdsale contract address.\n', '   */\n', '  function setKYCAdmin(address _address) external onlyBy(owner) {\n', '    kycAdmin = _address;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the PentacoreCrowdsale contract.\n', '   * @param _address PentacoreCrowdsale contract address.\n', '   */\n', '  function setNAVAdmin(address _address) external onlyBy(owner) {\n', '    navAdmin = _address;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the PentacoreCrowdsale contract.\n', '   * @param _address PentacoreCrowdsale contract address.\n', '   */\n', '  function setCrowdsaleContract(address _address) external onlyBy(owner) {\n', '    crowdsale = _address;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the address of the PentacoreRedemption contract.\n', '   * @param _address PentacoreRedemption contract address.\n', '   */\n', '  function setRedemptionContract(address _address) external onlyBy(owner) {\n', '    redemption = _address;\n', '  }\n', '\n', '  /**\n', '    * @dev Sets the address of the DistributedAutonomousExchange contract.\n', '    * @param _address DistributedAutonomousExchange contract address.\n', '    */\n', '  function setDistributedAutonomousExchange(address _address) external onlyBy(owner) {\n', '    distributedAutonomousExchange = _address;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the token price in US$.  Set by owner to reflect NAV/token.\n', '   * @param _price PentacoreToken price in USD.\n', '   */\n', '  function setTokenNAVMicroUSD(uint256 _price) external onlyBy(navAdmin) {\n', '    tokenNAVMicroUSD = _price;\n', '  }\n', '\n', '  /**\n', '   * @dev Sets the token price in US$.  Set by owner to reflect NAV/token.\n', '   * @param _price PentacoreToken price in USD.\n', '   */\n', '  function setWeiPerUSD(uint256 _price) external onlyBy(navAdmin) {\n', '    weiPerUSD = _price;\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the amount of Wei for a given token amount.  The result is rounded down (floored) to a millionth of a US$)\n', '   * @param _tokenAmount Whole number of tokens to be converted to Wei\n', '   * @return amount of Wei for the given amount of tokens\n', '   */\n', '  function tokensToWei(uint256 _tokenAmount) public view returns (uint256) {\n', '    require(tokenNAVMicroUSD != uint256(0));\n', '    require(weiPerUSD != uint256(0));\n', '    return _tokenAmount.mul(tokenNAVMicroUSD).mul(weiPerUSD).div(million);\n', '  }\n', '\n', '  /**\n', '   * @dev Calculate the amount tokens for a given Wei amount and the amount of change in Wei.\n', '   * @param _weiAmount Whole number of Wei to be converted to tokens\n', '   * @return whole amount of tokens for the given amount in Wei\n', '   * @return change in Wei that is not sufficient to buy a whole token\n', '   */\n', '  function weiToTokens(uint256 _weiAmount) public view returns (uint256, uint256) {\n', '    require(tokenNAVMicroUSD != uint256(0));\n', '    require(weiPerUSD != uint256(0));\n', '    uint256 tokens = _weiAmount.mul(million).div(weiPerUSD).div(tokenNAVMicroUSD);\n', '    uint256 changeWei = _weiAmount.sub(tokensToWei(tokens));\n', '    return (tokens, changeWei);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows / disallows free transferability of tokens regardless of whitelist.\n', '   * @param _isFreeTransferAllowed disregard whitelist if true; not if false\n', '   */\n', '  function setFreeTransferAllowed(bool _isFreeTransferAllowed) public {\n', '    require(owner != address(0));\n', '    require(msg.sender == owner);\n', '\n', '    isFreeTransferAllowed = _isFreeTransferAllowed;\n', '  }\n', '\n', '  /**\n', '   * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.\n', '   * @param _beneficiary the address which must be whitelisted by the KYC process in order to pass.\n', '   */\n', '  modifier isWhitelisted(address _beneficiary) {\n', '    require(whitelist[_beneficiary]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Reverts if beneficiary is not whitelisted and isFreeTransferAllowed is false. Can be used when extending this contract.\n', '   * @param _beneficiary the address which must be whitelisted by the KYC process in order to pass unless isFreeTransferAllowed.\n', '   */\n', '  modifier isWhitelistedOrFreeTransferAllowed(address _beneficiary) {\n', '    require(isFreeTransferAllowed || whitelist[_beneficiary]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Adds single address to whitelist.\n', '   * @param _beneficiary Address to be added to the whitelist\n', '   */\n', '  function addToWhitelist(address _beneficiary) public onlyBy(kycAdmin) {\n', '    whitelist[_beneficiary] = true;\n', '    emit AddToWhitelist(_beneficiary);\n', '  }\n', '\n', '  /**\n', '   * @dev Adds list of addresses to whitelist.\n', '   * @param _beneficiaries List of addresses to be added to the whitelist\n', '   */\n', '  function addManyToWhitelist(address[] _beneficiaries) external onlyBy(kycAdmin) {\n', '    for (uint256 i = 0; i < _beneficiaries.length; i++) addToWhitelist(_beneficiaries[i]);\n', '  }\n', '\n', '  /**\n', '   * @dev Removes single address from whitelist.\n', '   * @param _beneficiary Address to be removed to the whitelist\n', '   */\n', '  function removeFromWhitelist(address _beneficiary) public onlyBy(kycAdmin) {\n', '    whitelist[_beneficiary] = false;\n', '    emit RemoveFromWhitelist(_beneficiary);\n', '  }\n', '\n', '  /**\n', '   * @dev Removes list of addresses from whitelist.\n', '   * @param _beneficiaries List of addresses to be removed to the whitelist\n', '   */\n', '  function removeManyFromWhitelist(address[] _beneficiaries) external onlyBy(kycAdmin) {\n', '    for (uint256 i = 0; i < _beneficiaries.length; i++) removeFromWhitelist(_beneficiaries[i]);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens. We mint as we sell tokens (actually the PentacoreCrowdsale contract does).\n', '   * @dev The recipient should be whitelisted.\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) public onlyBy(crowdsale) isWhitelisted(_to) returns (bool) {\n', '    // Should run even when the token is paused.\n', '    require(tokenNAVMicroUSD != uint256(0));\n', '    require(weiPerUSD != uint256(0));\n', '    require(totalSupply_.add(_amount) <= tokenCap);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to burn tokens. We burn as owners redeem tokens (actually the PentacoreRedemptions contract does).\n', '   * @param _amount The amount of tokens to burn.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function burn(uint256 _amount) public onlyBy(redemption) returns (bool) {\n', '    // Should run even when the token is paused.\n', '    require(balances[redemption].sub(_amount) >= uint256(0));\n', '    require(totalSupply_.sub(_amount) >= uint256(0));\n', '    balances[redemption] = balances[redemption].sub(_amount);\n', '    totalSupply_ = totalSupply_.sub(_amount);\n', '    emit Burn(_amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev transfer token for a specified address\n', '   * @dev Both the sender and the recipient should be whitelisted.\n', '   * @param _to The address to transfer to.\n', '   * @param _value The amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _value) public notPaused isWhitelistedOrFreeTransferAllowed(msg.sender) isWhitelistedOrFreeTransferAllowed(_to) returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @dev The sender should be whitelisted.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public notPaused isWhitelistedOrFreeTransferAllowed(msg.sender) returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * @dev The sender should be whitelisted.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public notPaused isWhitelistedOrFreeTransferAllowed(msg.sender) returns (bool) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   *\n', '   * @dev The sender does not need to be whitelisted.  This is in case they are removed from white list and no longer agree to sell at an exchange.\n', '   * @dev This function stays untouched (directly inherited), but it&#39;s re-defined for clarity:\n', '   *\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @dev Both the sender and the recipient should be whitelisted.\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public notPaused isWhitelistedOrFreeTransferAllowed(_from) isWhitelistedOrFreeTransferAllowed(_to) returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '}\n', '\n', '// File: contracts/PentacoreDistributedAutonomousExchange.sol\n', '\n', '/**\n', ' * @title Simple distributed autonomous exchange for PENT tokens.\n', ' * @author Jordan Stojanovski\n', ' * @dev It does not keep an Order Book.  The buyer and seller must meet\n', ' * outside of this contract.  Then the buyer must set allowance to this exchange\n', ' * to transfer the appropriate amount of tokens.  Then the buyer must send an\n', ' * offer which names the seller.  If the amounts match and the amount of Wei sent\n', ' * matches the amount of tokens offered multiplied by the price, the buyer and\n', ' * the seller of the tokens complete the transaction.\n', ' * Q & A:\n', ' * Q: What is the commission?\n', ' * A: There is no commission.  The buyer and the seller just pay for the gas\n', ' *    they use.\n', ' * Q: Who owns this exchange.\n', ' * A: No one owns it.  It is Autonomous and no one is (legally) responsible for it.\n', ' * Q: How do the buyer and the seller find each other and agree on a price?\n', ' * A: This exchange does not care.  Bulletin boards, social networks, whatever.\n', ' * Q: Is this exchange trustworthy?\n', ' * A: More than anything else.  It is governed by the Smart Contract which\n', ' *    behavior is described in Solidity code.  It serves as Trustless Escrow,\n', ' *    meaning that there is no need to entrust ETH funds or PENT tokens to anyone.\n', ' *    This exchange simply does its job without any counterparty, credit or\n', ' *    trust risk.\n', ' */\n', 'contract PentacoreDistributedAutonomousExchange {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  PentacoreToken public token;\n', '\n', '  struct Offer {\n', '    uint256 amountTokens;\n', '    uint256 priceWeiPerToken;\n', '  }\n', '\n', '  mapping (address => mapping (address => Offer)) public offers;\n', '\n', '  /**\n', '   * @param _token address of the PENT token Smart Contract.\n', '   */\n', '  function PentacoreDistributedAutonomousExchange(PentacoreToken _token) public {\n', '    require(_token != address(0));\n', '\n', '    token = _token;\n', '  }\n', '\n', '  /**\n', '   * @param _buyer address of the buyer\n', '   * @param _amountTokens amount of tokens being offered.  If zero - retract offer.\n', '   * @param _priceWeiPerToken the agreed price\n', '   * @dev Make an offer to sell a specified amount of tokens to a specific buyer at an already agreed price.\n', '   * @dev Subsequent calls override the previous offers.\n', '   */\n', '  function offer(address _buyer, uint256 _amountTokens, uint256 _priceWeiPerToken) external {\n', '    require (token.allowance(msg.sender, address(this)) >= _amountTokens); // Exchange must have allowance\n', '    if (_amountTokens == uint256(0)) delete offers[msg.sender][_buyer]; // Retract offer\n', '    else offers[msg.sender][_buyer] = Offer(_amountTokens, _priceWeiPerToken); // Make offer\n', '  }\n', '\n', '  /**\n', '   * @param _seller address of the seller\n', '   * @param _amountTokens amount of tokens being bought. Must match amount of tokens in offer bu the specified seller\n', '   * @dev Buy agreed amount of tokens from the specific seller at the agreed price.\n', '   * @dev If the payment does not match the exact amount this function reverts.\n', '   */\n', '  function buy(address _seller, uint256 _amountTokens) external payable /* implicitly in transferFrom: isWhitelisted(msg.sender) */ {\n', '    require (token.allowance(_seller, address(this)) >= _amountTokens); // Exchange must have allowance\n', '    require(_amountTokens == offers[_seller][msg.sender].amountTokens); // Must match amounts\n', '    require (_amountTokens.mul(offers[_seller][msg.sender].priceWeiPerToken) == msg.value); // Must send exact amount\n', '    if (! token.transferFrom(_seller, msg.sender, _amountTokens)) revert();\n', '    else delete offers[_seller][msg.sender];\n', '  }\n', '\n', '  /**\n', '   * @dev Cannot just send ETH to the contract - it will refund it.\n', '   */\n', '  function () public payable {\n', '     revert();\n', '  }\n', '}']