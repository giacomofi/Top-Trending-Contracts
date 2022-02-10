['// File: zeppelin-solidity\\contracts\\ownership\\Ownable.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: node_modules\\zeppelin-solidity\\contracts\\token\\ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: node_modules\\zeppelin-solidity\\contracts\\math\\SafeMath.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: node_modules\\zeppelin-solidity\\contracts\\token\\BasicToken.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: node_modules\\zeppelin-solidity\\contracts\\token\\ERC20.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: node_modules\\zeppelin-solidity\\contracts\\token\\StandardToken.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken, Ownable {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '  \n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '// File: contracts\\OdinalaToken.sol\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * Final token\n', ' */\n', 'contract OdinalaToken is StandardToken {\n', '\n', '    string public constant name = "Odinala Token";\n', '    string public constant symbol = "ODN";\n', '    uint8 public constant decimals = 18;\n', '\n', '    function OdinalaToken()\n', '        public\n', '         { }\n', '}\n', '\n', '\n', '// File: node_modules\\zeppelin-solidity\\contracts\\crowdsale\\Crowdsale.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  StandardToken public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '  uint256 public startTime;\n', '  uint256 public endTime;\n', '\n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets per wei\n', '  uint256 public rate;\n', '\n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {\n', '    require(_endTime >= _startTime);\n', '    require(_rate > 0);\n', '    require(_wallet != 0x0);\n', '\n', '    token = createTokenContract();\n', '    startTime = _startTime;\n', '    endTime = _endTime;\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '  }\n', '\n', '  // creates the token to be sold.\n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (StandardToken) {\n', '    return new StandardToken();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(rate);\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.approve(this,tokens);\n', '    token.transferFrom(this,beneficiary,tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '\n', '\n', '}\n', '\n', '// File: zeppelin-solidity\\contracts\\crowdsale\\CappedCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title CappedCrowdsale\n', ' * @dev Extension of Crowdsale with a max amount of funds raised\n', ' */\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '  bool private circuitBreaker;\n', '\n', '  function CappedCrowdsale(uint256 _cap) {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '    circuitBreaker = false;\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return super.validPurchase() && withinCap && !circuitBreaker;\n', '  }\n', '\n', '  // overriding Crowdsale#hasEnded to add cap logic\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return super.hasEnded() || capReached || circuitBreaker;\n', '  }\n', '  \n', '  function triggerCircuitBreaker() internal{\n', '      require(circuitBreaker == false);\n', '      circuitBreaker = true;\n', '  }\n', '\n', '}\n', '\n', '\n', '// File: contracts\\ExternalTokenCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title ExternalTokenCrowdsale\n', ' * @dev Extension of Crowdsale with an externally provided token\n', ' * with implicit ownership grant over it\n', ' */\n', 'contract ExternalTokenCrowdsale is Crowdsale {\n', '    function ExternalTokenCrowdsale(StandardToken _token) public {\n', '        require(_token != address(0));\n', '        // Modify underlying token variable \n', '        // (createTokenContract has already been called)\n', '        token = _token;\n', '    }\n', '\n', '    function createTokenContract() internal returns (StandardToken) {\n', '        return StandardToken(0x0); // Placeholder\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract DevTimeLock is Ownable{\n', '    \n', '    uint256 private _count1 = 0;\n', '    uint256 private _count2 = 0;\n', '    uint256 private _count3 = 0;\n', '    \n', '    uint256 private _releaseTime1;\n', '    uint256 private _releaseTime2;\n', '    uint256 private _releaseTime3;\n', '    \n', '     StandardToken _token;\n', '    address private _wallet;\n', '    \n', '    function DevTimeLock(\n', '        address wallet,\n', '        StandardToken token,\n', '        uint256 releaseTime1,\n', '        uint256 releaseTime2,\n', '        uint256 releaseTime3 ){\n', '            \n', '        _wallet = wallet;\n', '        _token = token;\n', '        _releaseTime1 = releaseTime1;\n', '        _releaseTime2 = releaseTime2;\n', '        _releaseTime3 = releaseTime3;\n', '        \n', '    }\n', '    \n', '     function release1() onlyOwner public  {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= _releaseTime1);\n', '        require(_count1 == 0);\n', '        uint256 amount = 400000000000000000000000;\n', '        _token.approve(this,amount);\n', '        _token.transferFrom(this,_wallet,amount);\n', '        _count1 = 1;\n', '    }\n', '    \n', '     function release2() onlyOwner public  {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= _releaseTime2);\n', '        require(_count2 == 0);\n', '        uint256 amount = 400000000000000000000000;\n', '        _token.approve(this,amount);\n', '        _token.transferFrom(this,_wallet,amount);\n', '        _count2 = 1;\n', '    }\n', '    \n', '    function release3() onlyOwner public  {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= _releaseTime3);\n', '        require(_count3 == 0);\n', '        uint256 amount = 400000000000000000000000;\n', '        _token.approve(this,amount);\n', '        _token.transferFrom(this,_wallet,amount);\n', '        _count3 = 1;\n', '    }\n', '}\n', '\n', 'contract StakingTimeLock is Ownable{\n', '    \n', '    uint256 private _count1 = 0;\n', '\n', '    \n', '    uint256 private _releaseTime1;\n', '\n', '    \n', '     StandardToken _token;\n', '    address private _wallet;\n', '    \n', '    function StakingTimeLock(\n', '        address wallet,\n', '        StandardToken token,\n', '        uint256 releaseTime1 ){\n', '            \n', '        _wallet = wallet;\n', '        _token = token;\n', '        _releaseTime1 = releaseTime1;\n', '        \n', '    }\n', '    \n', '     function release1() onlyOwner public  {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= _releaseTime1);\n', '        require(_count1 == 0);\n', '        uint256 amount = 1500000000000000000000000;\n', '        _token.approve(this,amount);\n', '        _token.transferFrom(this,_wallet,amount);\n', '        _count1 = 1;\n', '    }\n', '    \n', '}\n', '\n', 'contract DexTimeLock is Ownable{\n', '    \n', '    uint256 private _count1 = 0;\n', '\n', '    \n', '    uint256 private _releaseTime1;\n', '\n', '    \n', '     StandardToken _token;\n', '    address private _wallet;\n', '    \n', '    function DexTimeLock(\n', '        address wallet,\n', '        StandardToken token,\n', '        uint256 releaseTime1 ){\n', '            \n', '        _wallet = wallet;\n', '        _token = token;\n', '        _releaseTime1 = releaseTime1;\n', '        \n', '    }\n', '    \n', '     function release1() onlyOwner public  {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= _releaseTime1);\n', '        require(_count1 == 0);\n', '        uint256 amount = 1000000000000000000000000;\n', '        _token.approve(this,amount);\n', '        _token.transferFrom(this,_wallet,amount);\n', '        _count1 = 1;\n', '    }\n', '    \n', '}\n', '\n', 'contract UniswapTimeLock is Ownable{\n', '    \n', '    uint256 private _count1 = 0;\n', '\n', '    \n', '    uint256 private _releaseTime1;\n', '\n', '    \n', '     StandardToken _token;\n', '    address private _wallet;\n', '    \n', '    function UniswapTimeLock(\n', '        address wallet,\n', '        StandardToken token,\n', '        uint256 releaseTime1 ){\n', '            \n', '        _wallet = wallet;\n', '        _token = token;\n', '        _releaseTime1 = releaseTime1;\n', '        \n', '    }\n', '    \n', '     function release1() onlyOwner public  {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= _releaseTime1);\n', '        require(_count1 == 0);\n', '        uint256 amount = 1000000000000000000000000;\n', '        _token.approve(this,amount);\n', '        _token.transferFrom(this,_wallet,amount);\n', '        _count1 = 1;\n', '    }\n', '    \n', '}\n', '\n', '\n', '\n', '\n', '\n', '// File: contracts\\PreICOCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '\n', '/**\n', ' * Crowdsale with injected token, permissions have to be ensured by creator\n', ' */\n', 'contract PreICOCrowdsale is Ownable, CappedCrowdsale, ExternalTokenCrowdsale {\n', '\n', '\n', '    \n', '    function PreICOCrowdsale(\n', '        address _wallet,\n', '        StandardToken _token,\n', '        uint256 start,\n', '        uint256 end,\n', '        uint256 rate,\n', '        uint256 cap\n', '    )\n', '        public\n', '        CappedCrowdsale(cap) // Cap\n', '        Crowdsale(\n', '            start, \n', '            end, \n', '            rate, \n', '            _wallet\n', '        )\n', '        ExternalTokenCrowdsale(_token)\n', '    { \n', '      \n', '    }\n', '    \n', '     function stopSale() onlyOwner public{\n', '       triggerCircuitBreaker();\n', '    }\n', '    \n', '}\n', '\n', '\n', '// File: contracts\\TwoStageCrowdsale.sol\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title TwoStageCrowdsale\n', ' * @dev Dual crowdsale deployment contract\n', ' * Finalization functions are separated due to potentially different requirements\n', ' */\n', 'contract MultiStageCrowdsale is Ownable {\n', '    PreICOCrowdsale public _preICOCrowdsale1;\n', '    PreICOCrowdsale public _preICOCrowdsale2;\n', '    PreICOCrowdsale public _preICOCrowdsale3;\n', '    StandardToken public _token;\n', '    DevTimeLock public  _devTimeLock;\n', '    StakingTimeLock public _stakingTimeLock;\n', '    UniswapTimeLock public _uniswapTimeLock;\n', '    DexTimeLock public _dexTimeLock;\n', '\n', '    function MultiStageCrowdsale(address wallet) public {\n', '\n', '        //wallet = 0xc34C80406aAE250B53edba7C183377CD0bcb8949\n', '        \n', '        _token = createTokenContract();\n', '        \n', '        _stakingTimeLock = new StakingTimeLock(wallet, _token, 1609459200); //jan 1st 2021\n', '        \n', '        _uniswapTimeLock = new UniswapTimeLock(wallet, _token, 1601769600000); //4th October\n', '        \n', '        _dexTimeLock = new DexTimeLock(wallet, _token, 1612137600); // 1 Feb 2021\n', '        \n', '        _preICOCrowdsale1 = new PreICOCrowdsale(wallet, _token, 1599430994, 1614556800, 4053, 370 ether);\n', '        \n', '        _preICOCrowdsale2 = new PreICOCrowdsale(wallet, _token, 1599430994, 1614556800, 3695, 135 ether);\n', '        \n', '        _preICOCrowdsale3 = new PreICOCrowdsale(wallet, _token, 1599430994, 1614556800, 3359, 140 ether);\n', '        \n', '        _devTimeLock = new DevTimeLock(wallet, _token, 1630454400, 1661990400, 1696118399);\n', '        \n', '        _token.mint(wallet, 800000000000000000000000);\n', '        _token.mint(_preICOCrowdsale1, 1500000000000000000000000);\n', '        _token.mint(_preICOCrowdsale2, 500000000000000000000000);\n', '        _token.mint(_preICOCrowdsale3, 500000000000000000000000);\n', '        _token.mint(_devTimeLock, 1200000000000000000000000);\n', '        _token.mint(_stakingTimeLock, 1500000000000000000000000);\n', '        _token.mint(_uniswapTimeLock, 1000000000000000000000000);\n', '        _token.mint(_dexTimeLock, 1000000000000000000000000);\n', '        \n', '        _token.finishMinting();\n', '    }\n', '    \n', '\n', '    function createTokenContract() internal returns (StandardToken) {\n', '        return new OdinalaToken();\n', '    }\n', '    \n', '    function devRelease1() onlyOwner public{\n', '        _devTimeLock.release1();\n', '    }\n', '    \n', '    function devRelease2() onlyOwner public{\n', '        _devTimeLock.release2();\n', '    }\n', '    \n', '    function devRelease3() onlyOwner public{\n', '        _devTimeLock.release3();\n', '    }\n', '    \n', '     function stakingRelease() onlyOwner public{\n', '        _stakingTimeLock.release1();\n', '    }\n', '    \n', '     function uniswapRelease() onlyOwner public{\n', '        _uniswapTimeLock.release1();\n', '    }\n', '    \n', '    function dexRelease() onlyOwner public{\n', '        _dexTimeLock.release1();\n', '    }\n', '    \n', '    function stopPreSale1() onlyOwner public{\n', '       _preICOCrowdsale1.stopSale();\n', '    }\n', '    \n', '    function stopPreSale2() onlyOwner public{\n', '       _preICOCrowdsale2.stopSale();\n', '    }\n', '    \n', '    function stopPreSale3() onlyOwner public{\n', '       _preICOCrowdsale3.stopSale();\n', '    }\n', '}']