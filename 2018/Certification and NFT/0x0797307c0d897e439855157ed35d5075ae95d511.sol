['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * Libraries\n', ' */\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * Helper contracts\n', ' */\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  address public coowner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    coowner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner || msg.sender == coowner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '\n', '    function setOwner(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(coowner, newOwner);\n', '        coowner = newOwner;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract CrowdsaleToken is ERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', ' constructor(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 public totalSupply_;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_.sub(balances[address(0)]);\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract Burnable is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function burn(address account, uint256 value) internal {\n', '    require(account != address(0));\n', '    totalSupply_ = totalSupply_.sub(value);\n', '    balances[account] = balances[account].sub(value);\n', '    emit Transfer(account, address(0), value);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param value The amount that will be burnt.\n', '   */\n', '   \n', '  function burnFrom(address account, uint256 value) internal {\n', '    allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);\n', '    burn(account, value);\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * MSG Token / Crowdsale\n', ' */\n', '\n', 'contract MSG is Ownable, Pausable, Burnable, CrowdsaleToken {\n', '    using SafeMath for uint256;\n', '\n', '    string name = "MoreStamps Global Token";\n', '    string symbol = "MSG";\n', '    uint8 decimals = 18;\n', '\n', '    // Manual kill switch\n', '    bool crowdsaleConcluded = false;\n', '\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public startTime;\n', '    uint256 public switchTime;\n', '    uint256 public endTime;\n', '\n', '    // minimum investment\n', '    uint256 minimumInvestPreSale = 10E17;\n', '    uint256 minimumInvestCrowdSale = 5E17;\n', '\n', '    // custom bonus amounts\n', '    uint256 public preSaleBonus = 15;\n', '    uint256 public crowdSaleBonus = 10;\n', '\n', '    // address where funds are collected\n', '    address public wallet;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 public preSaleRate = 1986;\n', '    uint256 public crowdSaleRate = 1420;\n', '\n', '    // how many token per each round\n', '    uint256 public preSaleLimit = 20248800E18;\n', '    uint256 public crowdSaleLimit = 73933200E18;\n', '\n', '    // amount of raised in wei\n', '    uint256 public weiRaised;\n', '    uint256 public tokensSold;\n', '    \n', '    //token allocation addresses\n', '    address STRATEGIC_PARTNERS_WALLET = 0x19CFB0E3F83831b726273b81760AE556600785Ec;\n', '\n', '    // Initial token allocation (40%)\n', '    bool tokensAllocated = false;\n', '\n', '    uint256 public contributors = 0;\n', '    mapping(address => uint256) public contributions;\n', '    \n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    constructor() \n', '        CrowdsaleToken(name, symbol, decimals) public {\n', '    \n', '        totalSupply_ = 156970000E18;\n', '        \n', '        //crowdsale allocation \n', '        balances[this] = totalSupply_;\n', '\n', '        startTime = 1543622400;\n', '        switchTime = 1547596800;\n', '        endTime = 1550275200;\n', '\n', '        wallet = msg.sender;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () external whenNotPaused payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function envokeTokenAllocation() public onlyOwner {\n', '        require(!tokensAllocated);\n', '        this.transfer(STRATEGIC_PARTNERS_WALLET, 62788000E18); //40% of totalSupply_\n', '        tokensAllocated = true;\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address _beneficiary) public whenNotPaused payable returns (uint256) {\n', '        require(!hasEnded());\n', '        require(_beneficiary != address(0));\n', '        require(validPurchase());\n', '        require(minimumInvest(msg.value));\n', '\n', '        address beneficiary = _beneficiary;\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be sent\n', '        uint256 tokens = getTokenAmount(weiAmount);\n', '\n', '        // if we run out of tokens\n', '        bool isLess = false;\n', '        if (!hasEnoughTokensLeft(weiAmount)) {\n', '            isLess = true;\n', '\n', '            uint256 percentOfValue = tokensLeft().mul(100).div(tokens);\n', '            require(percentOfValue <= 100);\n', '\n', '            tokens = tokens.mul(percentOfValue).div(100);\n', '            weiAmount = weiAmount.mul(percentOfValue).div(100);\n', '\n', '            // send back unused ethers\n', '            beneficiary.transfer(msg.value.sub(weiAmount));\n', '        }\n', '\n', '        // update raised ETH amount\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokensSold = tokensSold.add(tokens);\n', '\n', '        //check if new beneficiary\n', '        if(contributions[beneficiary] == 0) {\n', '            contributors = contributors.add(1);\n', '        }\n', '\n', '        //keep track of purchases per beneficiary;\n', '        contributions[beneficiary] = contributions[beneficiary].add(weiAmount);\n', '\n', '        //transfer purchased tokens\n', '        this.transfer(beneficiary, tokens);\n', '\n', '        //forwardFunds(weiAmount); //manual withdraw \n', '        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '        return (tokens);\n', '    }\n', '\n', '    /**\n', '     * Editors\n', '     */\n', '\n', '\n', '    function setRate(uint256 _preSaleRate, uint256 _crowdSaleRate) onlyOwner public {\n', '      require(_preSaleRate >= 0);\n', '      require(_crowdSaleRate >= 0);\n', '      preSaleRate = _preSaleRate;\n', '      crowdSaleRate = _crowdSaleRate;\n', '    }\n', '\n', '    function setBonus(uint256 _preSaleBonus, uint256 _crowdSaleBonus) onlyOwner public {\n', '      require(_preSaleBonus >= 0);\n', '      require(_crowdSaleBonus >= 0);\n', '      preSaleBonus = _preSaleBonus;\n', '      crowdSaleBonus = _crowdSaleBonus;\n', '    }\n', '\n', '    function setMinInvestment(uint256 _investmentPreSale, uint256 _investmentCrowdSale) onlyOwner public {\n', '      require(_investmentPreSale > 0);\n', '      require(_investmentCrowdSale > 0);\n', '      minimumInvestPreSale = _investmentPreSale;\n', '      minimumInvestCrowdSale = _investmentCrowdSale;\n', '    }\n', '\n', '    function changeEndTime(uint256 _endTime) onlyOwner public {\n', '        require(_endTime > startTime);\n', '        endTime = _endTime;\n', '    }\n', '\n', '    function changeSwitchTime(uint256 _switchTime) onlyOwner public {\n', '        require(endTime > _switchTime);\n', '        require(_switchTime > startTime);\n', '        switchTime = _switchTime;\n', '    }\n', '\n', '    function changeStartTime(uint256 _startTime) onlyOwner public {\n', '        require(endTime > _startTime);\n', '        startTime = _startTime;\n', '    }\n', '\n', '    function setWallet(address _wallet) onlyOwner public {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '    }\n', '\n', '    /**\n', '     * End crowdsale manually\n', '     */\n', '\n', '    function endSale() onlyOwner public {\n', '      // close crowdsale\n', '      crowdsaleConcluded = true;\n', '    }\n', '\n', '    function resumeSale() onlyOwner public {\n', '      // close crowdsale\n', '      crowdsaleConcluded = false;\n', '    }\n', '\n', '    /**\n', '     * When at risk, evacuate tokens\n', '     */\n', '\n', '    function evacuateTokens(uint256 _amount) external onlyOwner {\n', '        owner.transfer(_amount);\n', '    }\n', '\n', '    function manualTransfer(ERC20 _tokenInstance, uint256 _tokens, address beneficiary) external onlyOwner returns (bool success) {\n', '        tokensSold = tokensSold.add(_tokens);\n', '        _tokenInstance.transfer(beneficiary, _tokens);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Calculations\n', '     */\n', '\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() public view returns (bool) {\n', '        return now > endTime || this.balanceOf(this) == 0 || crowdsaleConcluded;\n', '    }\n', '\n', '    function getBaseAmount(uint256 _weiAmount) public view returns (uint256) {\n', '        uint256 currentRate = getCurrentRate();\n', '        return _weiAmount.mul(currentRate);\n', '    }\n', '\n', '    function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '        uint256 tokens = getBaseAmount(_weiAmount);\n', '        uint256 percentage = getCurrentBonus();\n', '        if (percentage > 0) {\n', '            tokens = tokens.add(tokens.mul(percentage).div(100));\n', '        }\n', '\n', '        assert(tokens > 0);\n', '        return (tokens);\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    function forwardFunds(uint256 _amount) external onlyOwner {\n', '        wallet.transfer(_amount);\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase() internal view returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '        return withinPeriod && nonZeroPurchase;\n', '    }\n', '\n', '    function minimumInvest(uint256 _weiAmount) internal view returns (bool) {\n', '        uint256 currentMinimum = getCurrentMinimum();\n', '        if(_weiAmount >= currentMinimum) return true;\n', '        return false;\n', '    }\n', '\n', '    function getCurrentMinimum() public view returns (uint256) {\n', '        if(now >= startTime && now <= switchTime) return minimumInvestPreSale;\n', '        if(now >= switchTime && now <= endTime) return minimumInvestCrowdSale;        \n', '        return 0;        \n', '    }\n', '\n', '    function getCurrentRate() public view returns (uint256) {\n', '        if(now >= startTime && now <= switchTime) return preSaleRate;\n', '        if(now >= switchTime && now <= endTime) return crowdSaleRate;        \n', '        return 0;\n', '    }\n', '\n', '    function getCurrentBonus() public view returns (uint256) {\n', '        if(now >= startTime && now <= switchTime) return preSaleBonus;\n', '        if(now >= switchTime && now <= endTime) return crowdSaleBonus;        \n', '        return 0;\n', '    }\n', '\n', '    function tokensLeft() public view returns (uint256) {\n', '        if(now >= startTime && now <= switchTime) return this.balanceOf(this).sub(crowdSaleLimit);\n', '        if(now >= switchTime && now <= endTime) return this.balanceOf(this);\n', '        return 0;\n', '    }\n', '\n', '    function hasEnoughTokensLeft(uint256 _weiAmount) public payable returns (bool) {\n', '        return tokensLeft().sub(_weiAmount) >= getBaseAmount(_weiAmount);\n', '    }\n', '}']