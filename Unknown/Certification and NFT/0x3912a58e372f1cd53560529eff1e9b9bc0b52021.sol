['pragma solidity ^0.4.13;\n', '/* \n', '* From OpenZeppelin project: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool);\n', '  function transferFrom(address from, address to, uint value) returns (bool);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20 {\n', '\n', '  using SafeMath for uint;\n', '\n', '  /* Actual balances of token holders */\n', '  mapping (address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   *\n', '   * Fix for the ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '    assert(msg.data.length >= size + 4);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool) {\n', '    require(balances[msg.sender] >= _value);\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool) {\n', '    require(balances[_from] >= _value && allowed[_from][_to] >= _value);\n', '    allowed[_from][_to] = allowed[_from][_to].sub(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner = msg.sender;\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract EmeraldToken is StandardToken, Ownable {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '\n', '  mapping (address => bool) public producers;\n', '\n', '  bool public released = false;\n', '\n', '  /*\n', '  * Only producer allowed\n', '  */\n', '  modifier onlyProducer() {\n', '    require(producers[msg.sender] == true);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Limit token transfer until the distribution is over.\n', '   * Owner can transfer tokens anytime\n', '   */\n', '  modifier canTransfer(address _sender) {\n', '    if (_sender != owner)\n', '      require(released);\n', '    _;\n', '  }\n', '\n', '  modifier inProduction() {\n', '    require(!released);\n', '    _;\n', '  }\n', '\n', '  function EmeraldToken(string _name, string _symbol, uint _decimals) {\n', '    require(_decimals > 0);\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '\n', '    // Make owner a producer of Emeralds\n', '    producers[msg.sender] = true;\n', '  }\n', '\n', '  /*\n', '  * Sets a producer&#39;s status\n', '  * Distribution contract can be a producer\n', '  */\n', '  function setProducer(address _addr, bool _status) onlyOwner {\n', '    producers[_addr] = _status;\n', '  }\n', '\n', '  /*\n', '  * Creates new Emeralds\n', '  */\n', '  function produceEmeralds(address _receiver, uint _amount) onlyProducer inProduction {\n', '    balances[_receiver] = balances[_receiver].add(_amount);\n', '    totalSupply = totalSupply.add(_amount);\n', '    Transfer(0, _receiver, _amount);\n', '  }\n', '\n', '  /**\n', '   * One way function to release the tokens to the wild. No more tokens can be created.\n', '   */\n', '  function releaseTokenTransfer() onlyOwner {\n', '    released = true;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool) {\n', '    // Call StandardToken.transfer()\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool) {\n', '    // Call StandardToken.transferForm()\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '}\n', '\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', 'contract Haltable is Ownable {\n', '  bool public halted = false;\n', '\n', '  modifier stopInEmergency {\n', '    require(!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    require(halted);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', '/*\n', '* The main contract for the Token Distribution Event\n', '*/\n', '\n', 'contract TokenDistribution is Haltable {\n', '\n', '  using SafeMath for uint;\n', '\n', '  address public wallet;                // an account for withdrow\n', '  uint public presaleStart;             // presale start time\n', '  uint public start;                    // distribution start time\n', '  uint public end;                      // distribution end time\n', '  EmeraldToken public token;            // token contract address\n', '  uint public weiGoal;                  // minimum wei amount we want to get during token distribution\n', '  uint public weiPresaleMax;            // maximum wei amount we can get during presale\n', '  uint public contributorsCount = 0;    // number of contributors\n', '  uint public weiTotal = 0;             // total wei amount we have received\n', '  uint public weiDistributed = 0;       // total wei amount we have received in Distribution state\n', '  uint public maxCap;                   // maximum token supply\n', '  uint public tokensSold = 0;           // tokens sold\n', '  uint public loadedRefund = 0;         // wei amount for refund\n', '  uint public weiRefunded = 0;          // wei amount refunded\n', '  mapping (address => uint) public contributors;        // list of contributors\n', '  mapping (address => uint) public presale;             // list of presale contributors\n', '\n', '  enum States {Preparing, Presale, Waiting, Distribution, Success, Failure, Refunding}\n', '\n', '  event Contributed(address _contributor, uint _weiAmount, uint _tokenAmount);\n', '  event GoalReached(uint _weiAmount);\n', '  event LoadedRefund(address _address, uint _loadedRefund);\n', '  event Refund(address _contributor, uint _weiAmount);\n', '\n', '  modifier inState(States _state) {\n', '    require(getState() == _state);\n', '    _;\n', '  }\n', '\n', '  function TokenDistribution(EmeraldToken _token, address _wallet, uint _presaleStart, uint _start, uint _end, \n', '    uint _ethPresaleMaxNoDecimals, uint _ethGoalNoDecimals, uint _maxTokenCapNoDecimals) {\n', '    \n', '    require(_token != address(0) && _wallet != address(0) && _presaleStart > 0 && _start > _presaleStart && _end > _start && _ethPresaleMaxNoDecimals > 0 \n', '      && _ethGoalNoDecimals > _ethPresaleMaxNoDecimals && _maxTokenCapNoDecimals > 0);\n', '    require(_token.isToken());\n', '\n', '    token = _token;\n', '    wallet = _wallet;\n', '    presaleStart = _presaleStart;\n', '    start = _start;\n', '    end = _end;\n', '    weiPresaleMax = _ethPresaleMaxNoDecimals * 1 ether;\n', '    weiGoal = _ethGoalNoDecimals * 1 ether;\n', '    maxCap = _maxTokenCapNoDecimals * 10 ** token.decimals();\n', '  }\n', '\n', '  function() payable {\n', '    buy();\n', '  }\n', '\n', '  /*\n', '  * Contributors can make payment and receive their tokens\n', '  */\n', '  function buy() payable stopInEmergency {\n', '    require(getState() == States.Presale || getState() == States.Distribution);\n', '    require(msg.value > 0);\n', '    if (getState() == States.Presale)\n', '      presale[msg.sender] = presale[msg.sender].add(msg.value);\n', '    else {\n', '      contributors[msg.sender] = contributors[msg.sender].add(msg.value);\n', '      weiDistributed = weiDistributed.add(msg.value);\n', '    }\n', '    contributeInternal(msg.sender, msg.value, getTokenAmount(msg.value));\n', '  }\n', '\n', '  /*\n', '  * Preallocate tokens for reserve, bounties etc.\n', '  */\n', '  function preallocate(address _receiver, uint _tokenAmountNoDecimals) onlyOwner stopInEmergency {\n', '    require(getState() != States.Failure && getState() != States.Refunding && !token.released());\n', '    uint tokenAmount = _tokenAmountNoDecimals * 10 ** token.decimals();\n', '    contributeInternal(_receiver, 0, tokenAmount);\n', '  }\n', '\n', '  /*\n', '   * Allow load refunds back on the contract for the refunding.\n', '   */\n', '  function loadRefund() payable {\n', '    require(getState() == States.Failure || getState() == States.Refunding);\n', '    require(msg.value > 0);\n', '    loadedRefund = loadedRefund.add(msg.value);\n', '    LoadedRefund(msg.sender, msg.value);\n', '  }\n', '\n', '  /*\n', '  * Changes dates of token distribution event\n', '  */\n', '  function setDates(uint _presaleStart, uint _start, uint _end) onlyOwner {\n', '    require(_presaleStart > 0 && _start > _presaleStart && _end > _start);\n', '    presaleStart = _presaleStart;\n', '    start = _start;\n', '    end = _end;\n', '  }\n', '\n', '  /*\n', '  * Internal function that creates and distributes tokens\n', '  */\n', '  function contributeInternal(address _receiver, uint _weiAmount, uint _tokenAmount) internal {\n', '    require(token.totalSupply().add(_tokenAmount) <= maxCap);\n', '    token.produceEmeralds(_receiver, _tokenAmount);\n', '    if (_weiAmount > 0) \n', '      wallet.transfer(_weiAmount);\n', '    if (contributors[_receiver] == 0) contributorsCount++;\n', '    tokensSold = tokensSold.add(_tokenAmount);\n', '    weiTotal = weiTotal.add(_weiAmount);\n', '    Contributed(_receiver, _weiAmount, _tokenAmount);\n', '  }\n', '\n', '  /*\n', '   * Contributors can claim refund.\n', '   */\n', '  function refund() inState(States.Refunding) {\n', '    uint weiValue = contributors[msg.sender];\n', '    require(weiValue <= loadedRefund && weiValue <= this.balance);\n', '    msg.sender.transfer(weiValue);\n', '    contributors[msg.sender] = 0;\n', '    weiRefunded = weiRefunded.add(weiValue);\n', '    loadedRefund = loadedRefund.sub(weiValue);\n', '    Refund(msg.sender, weiValue);\n', '  }\n', '\n', '  /*\n', '  * State machine\n', '  */\n', '  function getState() constant returns (States) {\n', '    if (now < presaleStart) return States.Preparing;\n', '    if (now >= presaleStart && now < start && weiTotal < weiPresaleMax) return States.Presale;\n', '    if (now < start && weiTotal >= weiPresaleMax) return States.Waiting;\n', '    if (now >= start && now < end) return States.Distribution;\n', '    if (weiTotal >= weiGoal) return States.Success;\n', '    if (now >= end && weiTotal < weiGoal && loadedRefund == 0) return States.Failure;\n', '    if (loadedRefund > 0) return States.Refunding;\n', '  }\n', '\n', '  /*\n', '  * Calculating token price\n', '  */\n', '  function getTokenAmount(uint _weiAmount) internal constant returns (uint) {\n', '    uint rate = 1000 * 10 ** 18 / 10 ** token.decimals(); // 1000 EMR = 1 ETH\n', '    uint tokenAmount = _weiAmount * rate;\n', '    if (getState() == States.Presale)\n', '      tokenAmount *= 2;\n', '    return tokenAmount;\n', '  }\n', '\n', '}']