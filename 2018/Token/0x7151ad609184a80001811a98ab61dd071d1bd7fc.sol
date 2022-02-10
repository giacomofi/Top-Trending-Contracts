['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '  modifier onlyPayloadSize(uint256 numwords) {\n', '    assert(msg.data.length >= numwords * 32 + 4);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' * @dev Implementation of the basic standard token.\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' */\n', 'contract MintableToken is PausableToken {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '  \n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  address public saleAgent = address(0);\n', '  address public saleAgent2 = address(0);\n', '\n', '  function setSaleAgent(address newSaleAgent) onlyOwner public {\n', '    saleAgent = newSaleAgent;\n', '  }\n', '\n', '  function setSaleAgent2(address newSaleAgent) onlyOwner public {\n', '    saleAgent2 = newSaleAgent;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) canMint public returns (bool) {\n', '    require(msg.sender == saleAgent || msg.sender == saleAgent2 || msg.sender == owner);\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(this), _to, _amount);\n', '    \n', '    return true;\n', '  }   \n', '  \n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', 'contract LEAD is MintableToken, Claimable {\n', '    string public constant name = "LEADEX"; \n', '    string public constant symbol = "LEAD";\n', '    uint public constant decimals = 8;\n', '}\n', '\n', 'contract PreSale is Ownable {\n', '    \n', '    using SafeMath for uint;\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '    uint256 constant dec = 10 ** 8;\n', '    uint256 public tokensToSale = 500000000 * 10 ** 8;\n', '    // address where funds are collected\n', '    address public wallet;\n', '    // one token per one rate\n', '    uint256 public rate = 800;\n', '    LEAD public token;\n', '    // Amount of raised money in wei\n', '    uint256 public weiRaised;\n', '    uint256 public minTokensToSale = 200 * dec;\n', '\n', '    // Round bonuses\n', '    uint256 bonus1 = 20;\n', '    uint256 bonus2 = 30;\n', '    uint256 bonus3 = 40;\n', '    uint256 bonus4 = 50;\n', '\n', '    // Amount bonuses\n', '    uint256 amount1 = 0 * dec;\n', '    uint256 amount2 = 2 * dec;\n', '    uint256 amount3 = 3 * dec;\n', '    uint256 amount4 = 5 * dec;\n', '\n', '\n', '    constructor(\n', '        address _token,\n', '        uint256 _startTime,\n', '        uint256 _endTime,\n', '        address _wallet) public {\n', '        require(_token != address(0));\n', '        require(_endTime > _startTime);\n', '        require(_wallet != address(0));\n', '        token = LEAD(_token);\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        wallet = _wallet;\n', '    }\n', '\n', '    modifier saleIsOn() {\n', '        uint tokenSupply = token.totalSupply();\n', '        require(now > startTime && now < endTime);\n', '        require(tokenSupply <= tokensToSale);\n', '        _;\n', '    }\n', '\n', '    function setMinTokensToSale(\n', '        uint256 _newMinTokensToSale) onlyOwner public {\n', '        minTokensToSale = _newMinTokensToSale;\n', '    }\n', '\n', '    function setAmount(\n', '        uint256 _newAmount1,\n', '        uint256 _newAmount2,\n', '        uint256 _newAmount3,\n', '        uint256 _newAmount4) onlyOwner public {\n', '        amount1 = _newAmount1;\n', '        amount2 = _newAmount2;\n', '        amount3 = _newAmount3;\n', '        amount4 = _newAmount4;\n', '    }\n', '\n', '    function setBonuses(\n', '        uint256 _newBonus1,\n', '        uint256 _newBonus2,\n', '        uint256 _newBonus3,\n', '        uint256 _newBonus4) onlyOwner public {\n', '        bonus1 = _newBonus1;\n', '        bonus2 = _newBonus2;\n', '        bonus3 = _newBonus3;\n', '        bonus4 = _newBonus4;\n', '    }\n', '\n', '\n', '    function getBonus(uint256 _value) internal view returns (uint256) {\n', '        if(_value > amount1 && _value <= amount2) { \n', '            return bonus1;\n', '        } else if(_value > amount2 && _value <= amount3) {\n', '            return bonus2;\n', '        } else if(_value > amount3 && _value <= amount4) {\n', '            return bonus3;\n', '        } else if(_value > amount4) {\n', '            return bonus4;\n', '        }\n', '    }\n', '\n', '    function setEndTime(uint256 _newEndTime) onlyOwner public {\n', '        require(now < _newEndTime);\n', '        endTime = _newEndTime;\n', '    }\n', '\n', '    function setRate(uint256 _newRate) public onlyOwner {\n', '        rate = _newRate;\n', '    }\n', '\n', '    function setTeamAddress(address _newWallet) onlyOwner public {\n', '        require(_newWallet != address(0));\n', '        wallet = _newWallet;\n', '    }\n', '\n', '    /**\n', '    * events for token purchase logging\n', '    * @param purchaser who paid for the tokens\n', '    * @param beneficiary who got the tokens\n', '    * @param value weis paid for purchase\n', '    * @param amount amount of tokens purchased\n', '    */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenPartners(address indexed purchaser, address indexed beneficiary, uint256 amount);\n', '\n', '    function buyTokens(address beneficiary) saleIsOn public payable {\n', '        require(beneficiary != address(0));\n', '        uint256 weiAmount = (msg.value).div(10 ** 10);\n', '        uint256 all = 100;\n', '        // calculate token amount to be created\n', '        uint256 tokens = weiAmount.mul(rate);\n', '        require(tokens >= minTokensToSale);\n', '        uint256 bonusNow = getBonus(tokens);\n', '        tokens = tokens.mul(bonusNow).div(all);\n', '        require(tokensToSale > tokens.add(token.totalSupply()));\n', '        weiRaised = weiRaised.add(msg.value);\n', '        token.mint(beneficiary, tokens);\n', '        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // @return true if tokensale event has ended\n', '    function hasEnded() public view returns (bool) {\n', '        return now > endTime;\n', '    }\n', '\n', '    function kill() onlyOwner public { selfdestruct(owner); }\n', '    \n', '}']