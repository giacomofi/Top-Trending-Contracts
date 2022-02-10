['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '   mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '   /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amout of tokens to be transfered\n', '    */\n', '   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '     var _allowance = allowed[_from][msg.sender];\n', '\n', '     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '     // require (_value <= _allowance);\n', '\n', '     balances[_to] = balances[_to].add(_value);\n', '     balances[_from] = balances[_from].sub(_value);\n', '     allowed[_from][msg.sender] = _allowance.sub(_value);\n', '     Transfer(_from, _to, _value);\n', '     return true;\n', '   }\n', '\n', '   /**\n', '    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '   function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '     // To change the approve amount you first have to reduce the addresses`\n', '     //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '     //  already 0 to mitigate the race condition described here:\n', '     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '     allowed[msg.sender][_spender] = _value;\n', '     Approval(msg.sender, _spender, _value);\n', '     return true;\n', '   }\n', '\n', '   /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '    */\n', '   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '     return allowed[_owner][_spender];\n', '   }\n', '\n', ' }\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Transfer(0X0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract WisePlat is MintableToken {\n', '  string public name = "WisePlat Token";\n', '  string public symbol = "WISE";\n', '  uint256 public decimals = 18;\n', '  address public bountyWallet = 0x0;\n', '\n', '  bool public transferStatus = false;\n', '\n', '  /**\n', '   * @dev modifier that throws if trading has not started yet\n', '   */\n', '  modifier hasStartedTransfer() {\n', '    require(transferStatus || msg.sender == bountyWallet);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to enable transfer.\n', '   */\n', '  function startTransfer() public onlyOwner {\n', '    transferStatus = true;\n', '  }\n', '  /**\n', '   * @dev Allows the owner to stop transfer.\n', '   */\n', '  function stopTransfer() public onlyOwner {\n', '    transferStatus = false;\n', '  }\n', '\n', '  function setbountyWallet(address _bountyWallet) public onlyOwner {\n', '    bountyWallet = _bountyWallet;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows anyone to transfer the WISE tokens once transfer has started\n', '   * @param _to the recipient address of the tokens.\n', '   * @param _value number of tokens to be transfered.\n', '   */\n', '  function transfer(address _to, uint _value) hasStartedTransfer returns (bool){\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows anyone to transfer the WISE tokens once transfer has started\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) hasStartedTransfer returns (bool){\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '}\n', '\n', 'contract WisePlatSale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being offered\n', '  WisePlat public token;\n', '\n', '  // start and end block where investments are allowed (both inclusive)\n', '  uint256 public constant startTimestamp\t= 1509274800;\t\t//Pre-ICO start\t\t\t\t\t\t2017/10/29 @ 11:00:00 (UTC)\n', '  uint256 public constant middleTimestamp\t= 1511607601;\t\t//Pre-ICO finish and ICO start\t\t2017/11/25 @ 11:00:01 (UTC)\n', '  uint256 public constant endTimestamp\t\t= 1514764799;\t\t//ICO finish\t\t\t\t\t\t2017/12/31 @ 23:59:59 (UTC)\n', '\n', '  // address where funds are collected\n', '  address public constant devWallet \t\t= 0x00d6F1eA4238e8d9f1C33B7500CB89EF3e91190c;\n', '  address public constant proWallet \t\t= 0x6501BDA688e8AC6C9cD96dc2DFBd6bDF3e886C05;\n', '  address public constant bountyWallet \t\t= 0x354FFa86F138883b880C282000B5005E867E8eE4;\n', '  address public constant remainderWallet\t= 0x656C64D5C8BADe2a56A564B12706eE89bbe486EA;\n', '  address public constant fundsWallet\t\t= 0x06D49e8aA90b1413A641D69c6B8AC154f5c9FE92;\n', ' \n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate\t\t\t\t\t\t= 10;\n', '  uint256 public constant ratePreICO\t\t= 20;\t//on Pre-ICO it is 20 WISE for 1 ETH\n', '  uint256 public constant rateICO\t\t\t= 15;\t//on ICO it is 15 WISE for 1 ETH\n', '  \n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  // minimum contribution to participate in token offer\n', '  uint256 public constant minContribution \t\t= 0.1 ether;\n', '  uint256 public constant minContribution_mBTC \t= 10;\n', '  uint256 public rateBTCxETH \t\t\t\t\t= 17;\n', '\n', '  // WISE tokens\n', '  uint256 public constant tokensTotal\t\t=\t 10000000 * 1e18;\t\t//WISE Total tokens\t\t\t\t10,000,000.00\n', '  uint256 public constant tokensCrowdsale\t=\t  7000000 * 1e18;\t\t//WISE tokens for Crowdsale\t\t 7,000,000.00\n', '  uint256 public constant tokensDevelopers  =\t  1900000 * 1e18;\t\t//WISE tokens for Developers\t 1,900,000.00\n', '  uint256 public constant tokensPromotion\t=\t  1000000 * 1e18;\t\t//WISE tokens for Promotion\t\t 1,000,000.00\n', '  uint256 public constant tokensBounty      = \t   100000 * 1e18;\t\t//WISE tokens for Bounty\t\t   100,000.00\n', '  uint256 public tokensRemainder;  \n', '  \n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '  event TokenClaim4BTC(address indexed purchaser_evt, address indexed beneficiary_evt, uint256 value_evt, uint256 amount_evt, uint256 btc_evt, uint256 rateBTCxETH_evt);\n', '  event SaleClosed();\n', '\n', '  function WisePlatSale() {\n', '    token = new WisePlat();\n', '\ttoken.mint(devWallet, tokensDevelopers);\n', '\ttoken.mint(proWallet, tokensPromotion);\n', '\ttoken.mint(bountyWallet, tokensBounty);\n', '\ttoken.setbountyWallet(bountyWallet);\t\t//allow transfer for bountyWallet\n', '    require(startTimestamp >= now);\n', '    require(endTimestamp >= startTimestamp);\n', '  }\n', '\n', '  // check if valid purchase\n', '  modifier validPurchase {\n', '    require(now >= startTimestamp);\n', '    require(now <= endTimestamp);\n', '    require(msg.value >= minContribution);\n', '    require(tokensTotal > token.totalSupply());\n', '    _;\n', '  }\n', '  // check if valid claim for BTC\n', '  modifier validPurchase4BTC {\n', '    require(now >= startTimestamp);\n', '    require(now <= endTimestamp);\n', '    require(tokensTotal > token.totalSupply());\n', '    _;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool timeLimitReached = now > endTimestamp;\n', '    bool allOffered = tokensTotal <= token.totalSupply();\n', '    return timeLimitReached || allOffered;\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) payable validPurchase {\n', '    require(beneficiary != 0x0);\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '\tif (now < middleTimestamp) {rate = ratePreICO;} else {rate = rateICO;}\n', '    uint256 tokens = weiAmount.mul(rate);\n', '    \n', '\trequire(token.totalSupply().add(tokens) <= tokensTotal);\n', '\t\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    \n', '    token.mint(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '    fundsWallet.transfer(msg.value);\t//transfer funds to fundsWallet\n', '  }\n', '  \n', '  //claim tokens buyed for mBTC\n', '  function claimTokens4mBTC(address beneficiary, uint256 mBTC) validPurchase4BTC public onlyOwner {\n', '    require(beneficiary != 0x0);\n', '\trequire(mBTC >= minContribution_mBTC);\n', '\n', '\t//uint256 _BTC = mBTC.div(1000);\t\t\t//convert mBTC\tto BTC\n', '\t//uint256 _ETH = _BTC.mul(rateBTCxETH);\t\t//convert BTC\tto ETH\n', '    //uint256 weiAmount = _ETH * 1e18;\t\t\t//convert ETH\tto wei\n', '\tuint256 weiAmount = mBTC.mul(rateBTCxETH) * 1e15;\t//all convert in one line mBTC->BTC->ETH->wei\n', '\n', '    // calculate token amount to be created\n', '\tif (now < middleTimestamp) {rate = ratePreICO;} else {rate = rateICO;}\n', '    uint256 tokens = weiAmount.mul(rate);\n', '    \n', '\trequire(token.totalSupply().add(tokens) <= tokensTotal);\n', '\t\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    \n', '    token.mint(beneficiary, tokens);\n', '    TokenClaim4BTC(msg.sender, beneficiary, weiAmount, tokens, mBTC, rateBTCxETH);\n', '    //fundsWallet.transfer(msg.value);\t//transfer funds to fundsWallet\t- already should be transfered to BTC wallet\n', '  }\n', '\n', '  // to enable transfer\n', '  function startTransfers() public onlyOwner {\n', '\ttoken.startTransfer();\n', '  }\n', '  \n', '  // to stop transfer\n', '  function stopTransfers() public onlyOwner {\n', '\ttoken.stopTransfer();\n', '  }\n', '  \n', '  // to correct exchange rate ETH for BTC\n', '  function correctExchangeRateBTCxETH(uint256 _rateBTCxETH) public onlyOwner {\n', '\trequire(_rateBTCxETH != 0);\n', '\trateBTCxETH = _rateBTCxETH;\n', '  }\n', '  \n', '  // finish mining coins and transfer ownership of WISE token to owner\n', '  function finishMinting() public onlyOwner {\n', '    require(hasEnded());\n', '    uint issuedTokenSupply = token.totalSupply();\t\t\t\n', '\ttokensRemainder = tokensTotal.sub(issuedTokenSupply);\n', '\tif (tokensRemainder > 0) {token.mint(remainderWallet, tokensRemainder);}\n', '    token.finishMinting();\n', '    token.transferOwnership(owner);\n', '    SaleClosed();\n', '  }\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '  \n', '  /**\n', '  * @dev Reclaim all ERC20Basic compatible tokens\n', '  * @param tokenAddr address The address of the token contract\n', '  */\n', '  function reclaimToken(address tokenAddr) external onlyOwner {\n', '\trequire(!isTokenOfferedToken(tokenAddr));\n', '    ERC20Basic tokenInst = ERC20Basic(tokenAddr);\n', '    uint256 balance = tokenInst.balanceOf(this);\n', '    tokenInst.transfer(msg.sender, balance);\n', '  }\n', '  function isTokenOfferedToken(address tokenAddr) returns(bool) {\n', '        return token == tokenAddr;\n', '  }\n', ' \n', '}']