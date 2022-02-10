['pragma solidity 0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract PlayBetsToken is StandardToken {\n', '\n', '  string public constant name = "Play Bets Token";\n', '  string public constant symbol = "PLT";\n', '  uint256 public constant decimals = 18;\n', '  uint256 public constant INITIAL_SUPPLY = 300 * 1e6 * 1 ether;\n', '\n', '  function PlayBetsToken() public {\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract PlayBetsPreSale is Ownable {\n', '    string public constant name = "PlayBets Closed Pre-Sale";\n', '\n', '    using SafeMath for uint256;\n', '\n', '    PlayBetsToken public token;\n', '    address public beneficiary;\n', '\n', '    uint256 public tokensPerEth;\n', '\n', '    uint256 public weiRaised = 0;\n', '    uint256 public tokensSold = 0;\n', '    uint256 public investorCount = 0;\n', '\n', '    uint public startTime;\n', '    uint public endTime;\n', '\n', '    bool public crowdsaleFinished = false;\n', '\n', '    event GoalReached(uint256 raised, uint256 tokenAmount);\n', '    event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);\n', '\n', '    modifier onlyAfter(uint time) {\n', '        require(currentTime() > time);\n', '        _;\n', '    }\n', '\n', '    modifier onlyBefore(uint time) {\n', '        require(currentTime() < time);\n', '        _;\n', '    }\n', '\n', '    function PlayBetsPreSale (\n', '        address _tokenAddr,\n', '        address _beneficiary,\n', '\n', '        uint256 _tokensPerEth,\n', '\n', '        uint _startTime,\n', '        uint _duration\n', '    ) {\n', '        token = PlayBetsToken(_tokenAddr);\n', '        beneficiary = _beneficiary;\n', '\n', '        tokensPerEth = _tokensPerEth;\n', '\n', '        startTime = _startTime;\n', '        endTime = _startTime + _duration * 1 days;\n', '    }\n', '\n', '    function () payable {\n', '        require(msg.value >= 0.01 * 1 ether);\n', '        doPurchase();\n', '    }\n', '\n', '    function withdraw(uint256 _value) onlyOwner {\n', '        beneficiary.transfer(_value);\n', '    }\n', '\n', '    function finishCrowdsale() onlyOwner {\n', '        token.transfer(beneficiary, token.balanceOf(this));\n', '        crowdsaleFinished = true;\n', '    }\n', '\n', '    function doPurchase() private onlyAfter(startTime) onlyBefore(endTime) {\n', '        \n', '        require(!crowdsaleFinished);\n', '        require(msg.sender != address(0));\n', '\n', '        uint256[5] memory _bonusPattern = [ uint256(120), 115, 110, 105, 100];\n', '        uint[4] memory _periodPattern = [ uint(24), 24 * 2, 24 * 7, 24 * 14];\n', '\n', '        uint256 tokenCount = tokensPerEth * msg.value;\n', '\n', '        uint calcPeriod = startTime;\n', '        uint prevPeriod = 0;\n', '        uint256 _now = currentTime();\n', '\n', '        for(uint8 i = 0; i < _periodPattern.length; ++i) {\n', '            calcPeriod = startTime.add(_periodPattern[i] * 1 hours);\n', '\n', '            if (prevPeriod < _now && _now <= calcPeriod) {\n', '                tokenCount = tokenCount.mul(_bonusPattern[i]).div(100);\n', '                break;\n', '            }\n', '            prevPeriod = calcPeriod;\n', '        }\n', '\n', '        uint256 _wei = msg.value;\n', '        uint256 _availableTokens = token.balanceOf(this);\n', '\n', '        if (_availableTokens < tokenCount) {\n', '          uint256 expectingTokenCount = tokenCount;\n', '          tokenCount = _availableTokens;\n', '          _wei = msg.value.mul(tokenCount).div(expectingTokenCount);\n', '          msg.sender.transfer(msg.value.sub(_wei));\n', '        }\n', '\n', '        if (token.balanceOf(msg.sender) == 0) {\n', '            investorCount++;\n', '        }\n', '        token.transfer(msg.sender, tokenCount);\n', '\n', '        weiRaised = weiRaised.add(_wei);\n', '        tokensSold = tokensSold.add(tokenCount);\n', '\n', '\n', '        NewContribution(msg.sender, tokenCount, _wei);\n', '\n', '        if (token.balanceOf(this) == 0) {\n', '            GoalReached(weiRaised, tokensSold);\n', '        }\n', '    }\n', '\n', '    function manualSell(address _sender, uint256 _value) external onlyOwner {\n', '        token.transfer(_sender, _value);\n', '        tokensSold = tokensSold.add(_value);\n', '    }\n', '\n', '    function currentTime() internal constant returns(uint256) {\n', '        return now;\n', '    }\n', '}']