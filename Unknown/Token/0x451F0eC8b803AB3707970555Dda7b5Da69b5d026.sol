['pragma solidity ^0.4.13;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', ' contract StandardToken is ERC20, BasicToken {\n', '\n', '   mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '   /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amout of tokens to be transfered\n', '    */\n', '   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '     var _allowance = allowed[_from][msg.sender];\n', '\n', '     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '     // require (_value <= _allowance);\n', '\n', '     balances[_to] = balances[_to].add(_value);\n', '     balances[_from] = balances[_from].sub(_value);\n', '     allowed[_from][msg.sender] = _allowance.sub(_value);\n', '     Transfer(_from, _to, _value);\n', '     return true;\n', '   }\n', '\n', '   /**\n', '    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '   function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '     // To change the approve amount you first have to reduce the addresses`\n', '     //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '     //  already 0 to mitigate the race condition described here:\n', '     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '     allowed[msg.sender][_spender] = _value;\n', '     Approval(msg.sender, _spender, _value);\n', '     return true;\n', '   }\n', '\n', '   /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '    */\n', '   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '     return allowed[_owner][_spender];\n', '   }\n', '\n', ' }\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will recieve the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract ChangeCoin is MintableToken {\n', '  string public name = "Change COIN";\n', '  string public symbol = "CAG";\n', '  uint256 public decimals = 18;\n', '\n', '  bool public tradingStarted = false;\n', '\n', '  /**\n', '   * @dev modifier that throws if trading has not started yet\n', '   */\n', '  modifier hasStartedTrading() {\n', '    require(tradingStarted);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the owner to enable the trading. This can not be undone\n', '   */\n', '  function startTrading() onlyOwner {\n', '    tradingStarted = true;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows anyone to transfer the Simis tokens once trading has started\n', '   * @param _to the recipient address of the tokens.\n', '   * @param _value number of tokens to be transfered.\n', '   */\n', '  function transfer(address _to, uint _value) hasStartedTrading returns (bool){\n', '    super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows anyone to transfer the PAY tokens once trading has started\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns (bool){\n', '    super.transferFrom(_from, _to, _value);\n', '  }\n', '}\n', '\n', 'contract ChangeCoinCrowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    ChangeCoin public token;\n', '\n', '    // start and end block where investments are allowed (both inclusive)\n', '    uint256 public startBlock;\n', '    uint256 public endBlock;\n', '\n', '    // address where funds are collected\n', '    address public multiSigWallet;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 public rate;\n', '\n', '    // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '\n', '    uint256 public minContribution;\n', '\n', '    uint256 public hardcap;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event MainSaleClosed();\n', '\n', '    uint256 public raisedInPresale = 0.5 ether;\n', '\n', '    function ChangeCoinCrowdsale() {\n', '      startBlock = 4204545;\n', '      endBlock = 4215000;\n', '      rate = 500;\n', '      multiSigWallet = 0xCe5574fF9d1fD16A411c09c488935F4fc613498c;\n', '      token = ChangeCoin(0x9C3386DeBA43A24B3653F35926D9DA8CBABC3FEC);\n', '\n', '      minContribution = 0 ether;\n', '      hardcap = 2 ether;\n', '      //minContribution = 0.5 ether;\n', '      //hardcap = 250000 ether;\n', '\n', '      require(startBlock >= block.number);\n', '      require(endBlock >= startBlock);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculates the amount of bonus coins the buyer gets\n', '     * @param tokens uint the amount of tokens you get according to current rate\n', '     * @return uint the amount of bonus tokens the buyer gets\n', '     */\n', '    function bonusAmmount(uint256 tokens) internal returns(uint256) {\n', '      uint256 bonus5 = tokens.div(20);\n', '      // add bonus 20% in first 48hours, 15% in next 24h, 5% in next 24h\n', '      if (block.number < startBlock.add(10160)) { // 5080 is aprox 24h\n', '        return tokens.add(bonus5.mul(4));\n', '      } else if (block.number < startBlock.add(15240)) {\n', '        return tokens.add(bonus5.mul(3));\n', '      } else if (block.number < startBlock.add(20320)) {\n', '        return tokens.add(bonus5);\n', '      } else {\n', '        return 0;\n', '      }\n', '    }\n', '\n', '    // @return true if valid purchase\n', '    function validPurchase() internal constant returns (bool) {\n', '      uint256 current = block.number;\n', '      bool withinPeriod = current >= startBlock && current <= endBlock;\n', '      bool nonZeroPurchase = msg.value >= minContribution;\n', '      bool withinCap = weiRaised.add(msg.value).add(raisedInPresale) <= hardcap;\n', '      return withinPeriod && nonZeroPurchase && withinCap;\n', '    }\n', '\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '      bool timeLimitReached = block.number > endBlock;\n', '      bool capReached = weiRaised.add(raisedInPresale) >= hardcap;\n', '      return timeLimitReached || capReached;\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) payable {\n', '      require(beneficiary != 0x0);\n', '      require(validPurchase());\n', '\n', '      uint256 weiAmount = msg.value;\n', '\n', '      // calculate token amount to be created\n', '      uint256 tokens = weiAmount.mul(rate);\n', '      tokens = tokens + bonusAmmount(tokens);\n', '\n', '      // update state\n', '      weiRaised = weiRaised.add(weiAmount);\n', '\n', '      token.mint(beneficiary, tokens);\n', '      TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '      multiSigWallet.transfer(msg.value);\n', '    }\n', '\n', '    // finish mining coins and transfer ownership of Change coin to owner\n', '    function finishMinting() public onlyOwner {\n', '      uint issuedTokenSupply = token.totalSupply();\n', '      uint restrictedTokens = issuedTokenSupply.mul(60).div(40);\n', '      token.mint(multiSigWallet, restrictedTokens);\n', '      token.finishMinting();\n', '      token.transferOwnership(owner);\n', '      MainSaleClosed();\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () payable {\n', '      buyTokens(msg.sender);\n', '    }\n', '\n', '  }']