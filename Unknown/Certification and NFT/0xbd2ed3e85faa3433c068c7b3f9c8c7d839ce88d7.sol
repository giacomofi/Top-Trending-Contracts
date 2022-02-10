['pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner {\n', '    owner = pendingOwner;\n', '    pendingOwner = 0x0;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '/*\n', '* Horizon State Decision Token Contract\n', '*\n', '* Version 0.9\n', '*\n', '* Author Nimo Naamani\n', '*\n', '* This smart contract code is Copyright 2017 Horizon State (https://Horizonstate.com)\n', '*\n', '* Licensed under the Apache License, version 2.0: http://www.apache.org/licenses/LICENSE-2.0\n', '*\n', '* @title Horizon State Token\n', '* @dev ERC20 Decision Token (HST)\n', '* @author Nimo Naamani\n', '*\n', '* HST tokens have 18 decimal places. The smallest meaningful (and transferable)\n', '* unit is therefore 0.000000000000000001 HST. This unit is called a &#39;danni&#39;.\n', '*\n', '* 1 HST = 1 * 10**18 = 1000000000000000000 dannis.\n', '*\n', '* Maximum total HST supply is 1 Billion.\n', '* This is equivalent to 1000000000 * 10**18 = 1e27 dannis.\n', '*\n', '* HST are mintable on demand (as they are being purchased), which means that\n', '* 1 Billion is the maximum.\n', '*/\n', '\n', '// @title The Horizon State Decision Token (HST)\n', 'contract DecisionToken is MintableToken, Claimable {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  // Name to appear in ERC20 wallets\n', '  string public constant name = "Decision Token";\n', '\n', '  // Symbol for the Decision Token to appear in ERC20 wallets\n', '  string public constant symbol = "HST";\n', '\n', '  // Version of the source contract\n', '  string public constant version = "1.0";\n', '\n', '  // Number of decimals for token display\n', '  uint8 public constant decimals = 18;\n', '\n', '  // Release timestamp. As part of the contract, tokens can only be transfered\n', '  // 10 days after this trigger is set\n', '  uint256 public triggerTime = 0;\n', '\n', '  // @title modifier to allow actions only when the token can be released\n', '  modifier onlyWhenReleased() {\n', '    require(now >= triggerTime);\n', '    _;\n', '  }\n', '\n', '\n', '  // @dev Constructor for the DecisionToken.\n', '  // Initialise the trigger (the sale contract will init this to the expected end time)\n', '  function DecisionToken() MintableToken() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  // @title Transfer tokens.\n', '  // @dev This contract overrides the transfer() function to only work when released\n', '  function transfer(address _to, uint256 _value) onlyWhenReleased returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  // @title Allow transfers from\n', '  // @dev This contract overrides the transferFrom() function to only work when released\n', '  function transferFrom(address _from, address _to, uint256 _value) onlyWhenReleased returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  // @title finish minting of the token.\n', '  // @dev This contract overrides the finishMinting function to trigger the token lock countdown\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    require(triggerTime==0);\n', '    triggerTime = now.add(10 days);\n', '    return super.finishMinting();\n', '  }\n', '}\n', '\n', '/**\n', '* Horizon State Token Sale Contract\n', '*\n', '* Version 0.9\n', '*\n', '* @author Nimo Naamani\n', '*\n', '* This smart contract code is Copyright 2017 Horizon State (https://Horizonstate.com)\n', '*\n', '* Licensed under the Apache License, version 2.0: http://www.apache.org/licenses/LICENSE-2.0\n', '*\n', '*/\n', '\n', '// @title The DC Token Sale contract\n', '// @dev A crowdsale contract with stages of tokens-per-eth based on time elapsed\n', '// Capped by maximum number of tokens; Time constrained\n', 'contract DecisionTokenSale is Claimable {\n', '  using SafeMath for uint256;\n', '\n', '  // Start timestamp where investments are open to the public.\n', '  // Before this timestamp - only whitelisted addresses allowed to buy.\n', '  uint256 public startTime;\n', '\n', '  // End time. investments can only go up to this timestamp.\n', '  // Note that the sale can end before that, if the token cap is reached.\n', '  uint256 public endTime;\n', '\n', '  // Presale (whitelist only) buyers receive this many tokens per ETH\n', '  uint256 public constant presaleTokenRate = 3750;\n', '\n', '  // 1st day buyers receive this many tokens per ETH\n', '  uint256 public constant earlyBirdTokenRate = 3500;\n', '\n', '  // Day 2-8 buyers receive this many tokens per ETH\n', '  uint256 public constant secondStageTokenRate = 3250;\n', '\n', '  // Day 9-16 buyers receive this many tokens per ETH\n', '  uint256 public constant thirdStageTokenRate = 3000;\n', '\n', '  // Maximum total number of tokens ever created, taking into account 18 decimals.\n', '  uint256 public constant tokenCap =  10**9 * 10**18;\n', '\n', '  // Initial HorizonState allocation (reserve), taking into account 18 decimals.\n', '  uint256 public constant tokenReserve = 4 * (10**8) * 10**18;\n', '\n', '  // The Decision Token that is sold with this token sale\n', '  DecisionToken public token;\n', '\n', '  // The address where the funds are kept\n', '  address public wallet;\n', '\n', '  // Holds the addresses that are whitelisted to participate in the presale.\n', '  // Sales to these addresses are allowed before saleStart\n', '  mapping (address => bool) whiteListedForPresale;\n', '\n', '  // @title Event for token purchase logging\n', '  event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '\n', '  // @title Event to log user added to whitelist\n', '  event LogUserAddedToWhiteList(address indexed user);\n', '\n', '  //@title Event to log user removed from whitelist\n', '  event LogUserUserRemovedFromWhiteList(address indexed user);\n', '\n', '\n', '  // @title Constructor\n', '  // @param _startTime: A timestamp for when the sale is to start.\n', '  // @param _wallet - The wallet where the token sale proceeds are to be stored\n', '  function DecisionTokenSale(uint256 _startTime, address _wallet) {\n', '    require(_startTime >= now);\n', '    require(_wallet != 0x0);\n', '    startTime = _startTime;\n', '    endTime = startTime.add(14 days);\n', '    wallet = _wallet;\n', '\n', '    // Create the token contract itself.\n', '    token = createTokenContract();\n', '\n', '    // Mint the reserve tokens to the owner of the sale contract.\n', '    token.mint(owner, tokenReserve);\n', '  }\n', '\n', '  // @title Create the token contract from this sale\n', '  // @dev Creates the contract for token to be sold.\n', '  function createTokenContract() internal returns (DecisionToken) {\n', '    return new DecisionToken();\n', '  }\n', '\n', '  // @title Buy Decision Tokens\n', '  // @dev Use this function to buy tokens through the sale\n', '  function buyTokens() payable {\n', '    require(msg.sender != 0x0);\n', '    require(msg.value != 0);\n', '    require(whiteListedForPresale[msg.sender] || now >= startTime);\n', '    require(!hasEnded());\n', '\n', '    // Calculate token amount to be created\n', '    uint256 tokens = calculateTokenAmount(msg.value);\n', '\n', '    if (token.totalSupply().add(tokens) > tokenCap) {\n', '      revert();\n', '    }\n', '\n', '    // Add the new tokens to the beneficiary\n', '    token.mint(msg.sender, tokens);\n', '\n', '    // Notify that a token purchase was performed\n', '    TokenPurchase(msg.sender, msg.value, tokens);\n', '\n', '    // Put the funds in the token sale wallet\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @dev This is fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens();\n', '  }\n', '\n', '  // @title Calculate how many tokens per Ether\n', '  // The token sale has different rates based on time of purchase, as per the token\n', '  // sale whitepaper and Horizon State&#39;s Token Sale page.\n', '  // Presale:  : 3750 tokens per Ether\n', '  // Day 1     : 3500 tokens per Ether\n', '  // Days 2-8  : 3250 tokens per Ether\n', '  // Days 9-16 : 3000 tokens per Ether\n', '  //\n', '  // A note for calculation: As the number of decimals on the token is 18, which\n', '  // is identical to the wei per eth - the calculation performed here can use the\n', '  // number of tokens per ETH with no further modification.\n', '  //\n', '  // @param _weiAmount : How much wei the buyer wants to spend on tokens\n', '  // @return the number of tokens for this purchase.\n', '  function calculateTokenAmount(uint256 _weiAmount) internal constant returns (uint256) {\n', '    if (now >= startTime + 8 days) {\n', '      return _weiAmount.mul(thirdStageTokenRate);\n', '    }\n', '    if (now >= startTime + 1 days) {\n', '      return _weiAmount.mul(secondStageTokenRate);\n', '    }\n', '    if (now >= startTime) {\n', '      return _weiAmount.mul(earlyBirdTokenRate);\n', '    }\n', '    return _weiAmount.mul(presaleTokenRate);\n', '  }\n', '\n', '  // @title Check whether this sale has ended.\n', '  // @dev This is a utility function to help consumers figure out whether the sale\n', '  // has already ended.\n', '  // The sale is considered done when the token&#39;s minting finished, or when the current\n', '  // time has passed the sale&#39;s end time\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '  // @title White list a buyer for the presale.\n', '  // @dev Allow the owner of this contract to whitelist a buyer.\n', '  // Whitelisted buyers may buy in the presale, i.e before the sale starts.\n', '  // @param _buyer : The buyer address to whitelist\n', '  function whiteListAddress(address _buyer) onlyOwner {\n', '    require(_buyer != 0x0);\n', '    whiteListedForPresale[_buyer] = true;\n', '    LogUserAddedToWhiteList(_buyer);\n', '  }\n', '\n', '  // @title Whitelist an list of buyers for the presale\n', '  // @dev Allow the owner of this contract to whitelist multiple buyers in batch.\n', '  // Whitelisted buyers may buy in the presale, i.e before the sale starts.\n', '  // @param _buyers : The buyer addresses to whitelist\n', '  function addWhiteListedAddressesInBatch(address[] _buyers) onlyOwner {\n', '    require(_buyers.length < 1000);\n', '    for (uint i = 0; i < _buyers.length; i++) {\n', '      whiteListAddress(_buyers[i]);\n', '    }\n', '  }\n', '\n', '  // @title Remove a buyer from the whitelist.\n', '  // @dev Allow the owner of this contract to remove a buyer from the white list.\n', '  // @param _buyer : The buyer address to remove from the whitelist\n', '  function removeWhiteListedAddress(address _buyer) onlyOwner {\n', '    whiteListedForPresale[_buyer] = false;\n', '  }\n', '\n', '  // @title Terminate the contract\n', '  // @dev Allow the owner of this contract to terminate it\n', '  // It also transfers the token ownership to the owner of the sale contract.\n', '  function destroy() onlyOwner {\n', '    token.finishMinting();\n', '    token.transferOwnership(msg.sender);\n', '    selfdestruct(owner);\n', '  }\n', '}']