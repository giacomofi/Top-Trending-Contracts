['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '/*\n', ' * Pausable\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism.\n', ' */\n', '\n', 'contract Pausable is Ownable {\n', '  bool public stopped;\n', '\n', '  modifier stopInEmergency {\n', '    if (stopped) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '  \n', '  modifier onlyInEmergency {\n', '    if (!stopped) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function emergencyStop() external onlyOwner {\n', '    stopped = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function release() external onlyOwner onlyInEmergency {\n', '    stopped = false;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/*\n', ' * PullPayment\n', ' * Base contract supporting async send for pull payments.\n', ' * Inherit from this contract and use asyncSend instead of send.\n', ' */\n', 'contract PullPayment {\n', '\n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) public payments;\n', '\n', '  event LogRefundETH(address to, uint value);\n', '\n', '\n', '  /**\n', '  *  Store sent amount as credit to be pulled, called by payer \n', '  **/\n', '  function asyncSend(address dest, uint amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '  }\n', '\n', '  // withdraw accumulated balance, called by payee\n', '  function withdrawPayments() {\n', '    address payee = msg.sender;\n', '    uint payment = payments[payee];\n', '    \n', '    if (payment == 0) {\n', '      throw;\n', '    }\n', '\n', '    if (this.balance < payment) {\n', '      throw;\n', '    }\n', '\n', '    payments[payee] = 0;\n', '\n', '    if (!payee.send(payment)) {\n', '      throw;\n', '    }\n', '    LogRefundETH(payee,payment);\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) balances;\n', '  \n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '  */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' *  Red Pill Token token contract. Implements\n', ' */\n', 'contract RedPillToken is StandardToken, Ownable {\n', '  string public constant name = "RedPill";\n', '  string public constant symbol = "RPIL";\n', '  uint public constant decimals = 8;\n', '\n', '\n', '  // Constructor\n', '  function RedPillToken() {\n', '      totalSupply = 20000000000000000;\n', '      balances[msg.sender] = totalSupply; // Send all tokens to owner\n', '  }\n', '\n', '  /**\n', '   *  Burn away the specified amount of Red Pill Token tokens\n', '   */\n', '  function burn(uint _value) onlyOwner returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Transfer(msg.sender, 0x0, _value);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/*\n', '  Crowdsale Smart Contract for the RedPillToken.org project\n', '  This smart contract collects ETH, and in return emits RedPillToken tokens to the backers\n', '*/\n', 'contract Crowdsale is Pausable, PullPayment {\n', '    \n', '    using SafeMath for uint;\n', '\n', '  \tstruct Backer {\n', '\t\tuint weiReceived; // Amount of Ether given\n', '\t\tuint coinSent;\n', '\t}\n', '\n', '\t/*\n', '\t* Constants\n', '\t*/\n', '\t/* Minimum number of RedPillToken to sell */\n', '\t/*uint public constant MIN_CAP = 1000000000000000; // 10,000,000 RedPillTokens (10 millions)*/\n', ' uint public constant MIN_CAP = 0; // no minimum cap\n', '\t/* Maximum number of RedPillToken to sell */\n', '\tuint public constant MAX_CAP = 10000000000000000; // 100,000,000 RedPillTokens (100 millions)\n', '\t/* Minimum amount to invest */\n', '\tuint public constant MIN_INVEST_ETHER = 40 finney; //0.04 ether\n', '\t/* Crowdsale period */\n', '\tuint private constant CROWDSALE_PERIOD = 34 days;\n', ' /*uint private constant CROWDSALE_PERIOD = 1 seconds;*/\n', '\t/* Number of RedPillTokens per Ether */\n', '\tuint public constant COIN_PER_ETHER = 536100000000; // 5,361 RedPillTokens  1 eth=5361 RedPillTokens\n', '                                        \n', '\n', '\t/*\n', '\t* Variables\n', '\t*/\n', '\t/* RedPillToken contract reference */\n', '\tRedPillToken public coin;\n', '    /* Multisig contract that will receive the Ether */\n', '\taddress public multisigEther;\n', '\t/* Number of Ether received */\n', '\tuint public etherReceived;\n', '\t/* Number of RedPillTokens sent to Ether contributors */\n', '\tuint public coinSentToEther;\n', '\t/* Crowdsale start time */\n', '\tuint public startTime;\n', '\t/* Crowdsale end time */\n', '\tuint public endTime;\n', ' \t/* Is crowdsale still on going */\n', '\tbool public crowdsaleClosed;\n', '\n', '\t/* Backers Ether indexed by their Ethereum address */\n', '\tmapping(address => Backer) public backers;\n', '\n', '\n', '\t/*\n', '\t* Modifiers\n', '\t*/\n', '\tmodifier minCapNotReached() {\n', '\t\tif ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier respectTimeFrame() {\n', '\t\tif ((now < startTime) || (now > endTime )) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\t/*\n', '\t * Event\n', '\t*/\n', '\tevent LogReceivedETH(address addr, uint value);\n', '\tevent LogCoinsEmited(address indexed from, uint amount);\n', '\n', '\t/*\n', '\t * Constructor\n', '\t*/\n', '\tfunction Crowdsale(address _RedPillTokenAddress, address _to) {\n', '\t\tcoin = RedPillToken(_RedPillTokenAddress);\n', '\t\tmultisigEther = _to;\n', '\t}\n', '\n', '\t/* \n', '\t * The fallback function corresponds to a donation in ETH\n', '\t */\n', '\tfunction() stopInEmergency respectTimeFrame payable {\n', '\t\treceiveETH(msg.sender);\n', '\t}\n', '\n', '\t/* \n', '\t * To call to start the crowdsale\n', '\t */\n', '\tfunction start() onlyOwner {\n', '\t\tif (startTime != 0) throw; // Crowdsale was already started\n', '\n', '\t\t/*startTime = now ;*/           \n', '\t\t/*endTime =  now + CROWDSALE_PERIOD; */   \n', '   \n', '  startTime = 1506484800;            \n', '  endTime =  1506484800 + CROWDSALE_PERIOD;   \n', '   \n', '\t}\n', '\n', '\t/*\n', '\t *\tReceives a donation in Ether\n', '\t*/\n', '\tfunction receiveETH(address beneficiary) internal {\n', '\t\tif (msg.value < MIN_INVEST_ETHER) throw; // Don&#39;t accept funding under a predefined threshold\n', '\t\t\n', '\t\tuint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of RedPillToken to send\n', '\t\tif (coinToSend.add(coinSentToEther) > MAX_CAP) throw;\t\n', '\n', '\t\tBacker backer = backers[beneficiary];\n', '\t\tcoin.transfer(beneficiary, coinToSend); // Transfer RedPillTokens right now \n', '\n', '\t\tbacker.coinSent = backer.coinSent.add(coinToSend);\n', '\t\tbacker.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    \n', '\n', '\t\tetherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding\n', '\t\tcoinSentToEther = coinSentToEther.add(coinToSend);\n', '\n', '\t\t// Send events\n', '\t\tLogCoinsEmited(msg.sender ,coinToSend);\n', '\t\tLogReceivedETH(beneficiary, etherReceived); \n', '\t}\n', '\t\n', '\n', '\t/*\n', '\t *Compute the RedPillToken bonus according to the investment period\n', '\t */\n', '\tfunction bonus(uint amount) internal constant returns (uint) {\n', '\t\t/*if (now < startTime.add(2 days)) return amount.add(amount.div(5)); */   // bonus 20%\n', '\t\treturn amount;\n', '\t}\n', '\n', '\t/*\t\n', '\t * Finalize the crowdsale, should be called after the refund period\n', '\t*/\n', '\tfunction finalize() onlyOwner public {\n', '\n', '\t\tif (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins\n', '\t\t\tif (coinSentToEther == MAX_CAP) {\n', '\t\t\t} else {\n', '\t\t\t\tthrow;\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tif (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise\n', '\n', '\t\tif (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address\n', '\t\t\n', '\t\tuint remains = coin.balanceOf(this);\n', '\t\tif (remains > 0) { // Burn the rest of RedPillTokens\n', '\t\t\tif (!coin.burn(remains)) throw ;\n', '\t\t}\n', '\t\tcrowdsaleClosed = true;\n', '\t}\n', '\n', '\t/*\t\n', '\t* Failsafe drain\n', '\t*/\n', '\tfunction drain() onlyOwner {\n', '\t\tif (!owner.send(this.balance)) throw;\n', '\t}\n', '\n', '\t/**\n', '\t * Allow to change the team multisig address in the case of emergency.\n', '\t */\n', '\tfunction setMultisig(address addr) onlyOwner public {\n', '\t\tif (addr == address(0)) throw;\n', '\t\tmultisigEther = addr;\n', '\t}\n', '\n', '\t/**\n', '\t * Manually back RedPillToken owner address.\n', '\t */\n', '\tfunction backRedPillTokenOwner() onlyOwner public {\n', '\t\tcoin.transferOwnership(owner);\n', '\t}\n', '\n', '\t/**\n', '\t * Transfer remains to owner in case if impossible to do min invest\n', '\t */\n', '\tfunction getRemainCoins() onlyOwner public {\n', '\t\tvar remains = MAX_CAP - coinSentToEther;\n', '\t\tuint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));\n', '\n', '\t\tif(remains > minCoinsToSell) throw;\n', '\n', '\t\tBacker backer = backers[owner];\n', '\t\tcoin.transfer(owner, remains); // Transfer RedPillTokens right now \n', '\n', '\t\tbacker.coinSent = backer.coinSent.add(remains);\n', '\n', '\t\tcoinSentToEther = coinSentToEther.add(remains);\n', '\n', '\t\t// Send events\n', '\t\tLogCoinsEmited(this ,remains);\n', '\t\tLogReceivedETH(owner, etherReceived); \n', '\t}\n', '\n', '\n', '\t/* \n', '  \t * When MIN_CAP is not reach:\n', '  \t * 1) backer call the "approve" function of the RedPillToken token contract with the amount of all RedPillTokens they got in order to be refund\n', '  \t * 2) backer call the "refund" function of the Crowdsale contract with the same amount of RedPillTokens\n', '   \t * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH\n', '   \t */\n', '\tfunction refund(uint _value) minCapNotReached public {\n', '\t\t\n', '\t\tif (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance\n', '\n', '\t\tcoin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract\n', '\n', '\t\tif (!coin.burn(_value)) throw ; // token sent for refund are burnt\n', '\n', '\t\tuint ETHToSend = backers[msg.sender].weiReceived;\n', '\t\tbackers[msg.sender].weiReceived=0;\n', '\n', '\t\tif (ETHToSend > 0) {\n', '\t\t\tasyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH\n', '\t\t}\n', '\t}\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '/*\n', ' * Pausable\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism.\n', ' */\n', '\n', 'contract Pausable is Ownable {\n', '  bool public stopped;\n', '\n', '  modifier stopInEmergency {\n', '    if (stopped) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '  \n', '  modifier onlyInEmergency {\n', '    if (!stopped) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function emergencyStop() external onlyOwner {\n', '    stopped = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function release() external onlyOwner onlyInEmergency {\n', '    stopped = false;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '/*\n', ' * PullPayment\n', ' * Base contract supporting async send for pull payments.\n', ' * Inherit from this contract and use asyncSend instead of send.\n', ' */\n', 'contract PullPayment {\n', '\n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) public payments;\n', '\n', '  event LogRefundETH(address to, uint value);\n', '\n', '\n', '  /**\n', '  *  Store sent amount as credit to be pulled, called by payer \n', '  **/\n', '  function asyncSend(address dest, uint amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '  }\n', '\n', '  // withdraw accumulated balance, called by payee\n', '  function withdrawPayments() {\n', '    address payee = msg.sender;\n', '    uint payment = payments[payee];\n', '    \n', '    if (payment == 0) {\n', '      throw;\n', '    }\n', '\n', '    if (this.balance < payment) {\n', '      throw;\n', '    }\n', '\n', '    payments[payee] = 0;\n', '\n', '    if (!payee.send(payment)) {\n', '      throw;\n', '    }\n', '    LogRefundETH(payee,payment);\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  mapping(address => uint) balances;\n', '  \n', '  /*\n', '   * Fix for the ERC20 short address attack  \n', '  */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', '\n', 'contract StandardToken is BasicToken, ERC20 {\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) {\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' *  Red Pill Token token contract. Implements\n', ' */\n', 'contract RedPillToken is StandardToken, Ownable {\n', '  string public constant name = "RedPill";\n', '  string public constant symbol = "RPIL";\n', '  uint public constant decimals = 8;\n', '\n', '\n', '  // Constructor\n', '  function RedPillToken() {\n', '      totalSupply = 20000000000000000;\n', '      balances[msg.sender] = totalSupply; // Send all tokens to owner\n', '  }\n', '\n', '  /**\n', '   *  Burn away the specified amount of Red Pill Token tokens\n', '   */\n', '  function burn(uint _value) onlyOwner returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    Transfer(msg.sender, 0x0, _value);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '/*\n', '  Crowdsale Smart Contract for the RedPillToken.org project\n', '  This smart contract collects ETH, and in return emits RedPillToken tokens to the backers\n', '*/\n', 'contract Crowdsale is Pausable, PullPayment {\n', '    \n', '    using SafeMath for uint;\n', '\n', '  \tstruct Backer {\n', '\t\tuint weiReceived; // Amount of Ether given\n', '\t\tuint coinSent;\n', '\t}\n', '\n', '\t/*\n', '\t* Constants\n', '\t*/\n', '\t/* Minimum number of RedPillToken to sell */\n', '\t/*uint public constant MIN_CAP = 1000000000000000; // 10,000,000 RedPillTokens (10 millions)*/\n', ' uint public constant MIN_CAP = 0; // no minimum cap\n', '\t/* Maximum number of RedPillToken to sell */\n', '\tuint public constant MAX_CAP = 10000000000000000; // 100,000,000 RedPillTokens (100 millions)\n', '\t/* Minimum amount to invest */\n', '\tuint public constant MIN_INVEST_ETHER = 40 finney; //0.04 ether\n', '\t/* Crowdsale period */\n', '\tuint private constant CROWDSALE_PERIOD = 34 days;\n', ' /*uint private constant CROWDSALE_PERIOD = 1 seconds;*/\n', '\t/* Number of RedPillTokens per Ether */\n', '\tuint public constant COIN_PER_ETHER = 536100000000; // 5,361 RedPillTokens  1 eth=5361 RedPillTokens\n', '                                        \n', '\n', '\t/*\n', '\t* Variables\n', '\t*/\n', '\t/* RedPillToken contract reference */\n', '\tRedPillToken public coin;\n', '    /* Multisig contract that will receive the Ether */\n', '\taddress public multisigEther;\n', '\t/* Number of Ether received */\n', '\tuint public etherReceived;\n', '\t/* Number of RedPillTokens sent to Ether contributors */\n', '\tuint public coinSentToEther;\n', '\t/* Crowdsale start time */\n', '\tuint public startTime;\n', '\t/* Crowdsale end time */\n', '\tuint public endTime;\n', ' \t/* Is crowdsale still on going */\n', '\tbool public crowdsaleClosed;\n', '\n', '\t/* Backers Ether indexed by their Ethereum address */\n', '\tmapping(address => Backer) public backers;\n', '\n', '\n', '\t/*\n', '\t* Modifiers\n', '\t*/\n', '\tmodifier minCapNotReached() {\n', '\t\tif ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier respectTimeFrame() {\n', '\t\tif ((now < startTime) || (now > endTime )) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\t/*\n', '\t * Event\n', '\t*/\n', '\tevent LogReceivedETH(address addr, uint value);\n', '\tevent LogCoinsEmited(address indexed from, uint amount);\n', '\n', '\t/*\n', '\t * Constructor\n', '\t*/\n', '\tfunction Crowdsale(address _RedPillTokenAddress, address _to) {\n', '\t\tcoin = RedPillToken(_RedPillTokenAddress);\n', '\t\tmultisigEther = _to;\n', '\t}\n', '\n', '\t/* \n', '\t * The fallback function corresponds to a donation in ETH\n', '\t */\n', '\tfunction() stopInEmergency respectTimeFrame payable {\n', '\t\treceiveETH(msg.sender);\n', '\t}\n', '\n', '\t/* \n', '\t * To call to start the crowdsale\n', '\t */\n', '\tfunction start() onlyOwner {\n', '\t\tif (startTime != 0) throw; // Crowdsale was already started\n', '\n', '\t\t/*startTime = now ;*/           \n', '\t\t/*endTime =  now + CROWDSALE_PERIOD; */   \n', '   \n', '  startTime = 1506484800;            \n', '  endTime =  1506484800 + CROWDSALE_PERIOD;   \n', '   \n', '\t}\n', '\n', '\t/*\n', '\t *\tReceives a donation in Ether\n', '\t*/\n', '\tfunction receiveETH(address beneficiary) internal {\n', "\t\tif (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold\n", '\t\t\n', '\t\tuint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of RedPillToken to send\n', '\t\tif (coinToSend.add(coinSentToEther) > MAX_CAP) throw;\t\n', '\n', '\t\tBacker backer = backers[beneficiary];\n', '\t\tcoin.transfer(beneficiary, coinToSend); // Transfer RedPillTokens right now \n', '\n', '\t\tbacker.coinSent = backer.coinSent.add(coinToSend);\n', '\t\tbacker.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    \n', '\n', '\t\tetherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding\n', '\t\tcoinSentToEther = coinSentToEther.add(coinToSend);\n', '\n', '\t\t// Send events\n', '\t\tLogCoinsEmited(msg.sender ,coinToSend);\n', '\t\tLogReceivedETH(beneficiary, etherReceived); \n', '\t}\n', '\t\n', '\n', '\t/*\n', '\t *Compute the RedPillToken bonus according to the investment period\n', '\t */\n', '\tfunction bonus(uint amount) internal constant returns (uint) {\n', '\t\t/*if (now < startTime.add(2 days)) return amount.add(amount.div(5)); */   // bonus 20%\n', '\t\treturn amount;\n', '\t}\n', '\n', '\t/*\t\n', '\t * Finalize the crowdsale, should be called after the refund period\n', '\t*/\n', '\tfunction finalize() onlyOwner public {\n', '\n', '\t\tif (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins\n', '\t\t\tif (coinSentToEther == MAX_CAP) {\n', '\t\t\t} else {\n', '\t\t\t\tthrow;\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tif (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise\n', '\n', '\t\tif (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address\n', '\t\t\n', '\t\tuint remains = coin.balanceOf(this);\n', '\t\tif (remains > 0) { // Burn the rest of RedPillTokens\n', '\t\t\tif (!coin.burn(remains)) throw ;\n', '\t\t}\n', '\t\tcrowdsaleClosed = true;\n', '\t}\n', '\n', '\t/*\t\n', '\t* Failsafe drain\n', '\t*/\n', '\tfunction drain() onlyOwner {\n', '\t\tif (!owner.send(this.balance)) throw;\n', '\t}\n', '\n', '\t/**\n', '\t * Allow to change the team multisig address in the case of emergency.\n', '\t */\n', '\tfunction setMultisig(address addr) onlyOwner public {\n', '\t\tif (addr == address(0)) throw;\n', '\t\tmultisigEther = addr;\n', '\t}\n', '\n', '\t/**\n', '\t * Manually back RedPillToken owner address.\n', '\t */\n', '\tfunction backRedPillTokenOwner() onlyOwner public {\n', '\t\tcoin.transferOwnership(owner);\n', '\t}\n', '\n', '\t/**\n', '\t * Transfer remains to owner in case if impossible to do min invest\n', '\t */\n', '\tfunction getRemainCoins() onlyOwner public {\n', '\t\tvar remains = MAX_CAP - coinSentToEther;\n', '\t\tuint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));\n', '\n', '\t\tif(remains > minCoinsToSell) throw;\n', '\n', '\t\tBacker backer = backers[owner];\n', '\t\tcoin.transfer(owner, remains); // Transfer RedPillTokens right now \n', '\n', '\t\tbacker.coinSent = backer.coinSent.add(remains);\n', '\n', '\t\tcoinSentToEther = coinSentToEther.add(remains);\n', '\n', '\t\t// Send events\n', '\t\tLogCoinsEmited(this ,remains);\n', '\t\tLogReceivedETH(owner, etherReceived); \n', '\t}\n', '\n', '\n', '\t/* \n', '  \t * When MIN_CAP is not reach:\n', '  \t * 1) backer call the "approve" function of the RedPillToken token contract with the amount of all RedPillTokens they got in order to be refund\n', '  \t * 2) backer call the "refund" function of the Crowdsale contract with the same amount of RedPillTokens\n', '   \t * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH\n', '   \t */\n', '\tfunction refund(uint _value) minCapNotReached public {\n', '\t\t\n', '\t\tif (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance\n', '\n', '\t\tcoin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract\n', '\n', '\t\tif (!coin.burn(_value)) throw ; // token sent for refund are burnt\n', '\n', '\t\tuint ETHToSend = backers[msg.sender].weiReceived;\n', '\t\tbackers[msg.sender].weiReceived=0;\n', '\n', '\t\tif (ETHToSend > 0) {\n', '\t\t\tasyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH\n', '\t\t}\n', '\t}\n', '\n', '}']
