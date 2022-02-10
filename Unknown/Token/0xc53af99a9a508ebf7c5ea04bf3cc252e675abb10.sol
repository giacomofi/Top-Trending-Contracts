['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\tfunction mul(uint a, uint b) internal returns (uint) {\n', '\t\tuint c = a * b;\n', '\t\tassert(a == 0 || c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\tfunction safeSub(uint a, uint b) internal returns (uint) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\tfunction div(uint a, uint b) internal returns (uint) {\n', '\t\tassert(b > 0);\n', '\t\tuint c = a / b;\n', '\t\tassert(a == b * c + a % b);\n', '\t\treturn c;\n', '\t}\n', '\tfunction sub(uint a, uint b) internal returns (uint) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\tfunction add(uint a, uint b) internal returns (uint) {\n', '\t\tuint c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '\tfunction max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '\t\treturn a >= b ? a : b;\n', '\t}\n', '\tfunction min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '\t\treturn a < b ? a : b;\n', '\t}\n', '\tfunction max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\t\treturn a >= b ? a : b;\n', '\t}\n', '\tfunction min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '\t\treturn a < b ? a : b;\n', '\t}\n', '\tfunction assert(bool assertion) internal {\n', '\t\tif (!assertion) {\n', '\t\t\tthrow;\n', '\t\t}\n', '\t}\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '\tbool public stopped;\n', '\tmodifier stopInEmergency {\n', '\t\tif (stopped) {\n', '\t\t\tthrow;\n', '\t\t}\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier onlyInEmergency {\n', '\t\tif (!stopped) {\n', '\t\t  throw;\n', '\t\t}\n', '\t_;\n', '\t}\n', '\t// called by the owner on emergency, triggers stopped state\n', '\tfunction emergencyStop() external onlyOwner {\n', '\t\tstopped = true;\n', '\t}\n', '\t// called by the owner on end of emergency, returns to normal state\n', '\tfunction release() external onlyOwner onlyInEmergency {\n', '\t\tstopped = false;\n', '\t}\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title PullPayment\n', ' * @dev Base contract supporting async send for pull payments. Inherit from this\n', ' * contract and use asyncSend instead of send.\n', ' */\n', 'contract PullPayment {\n', '\tusing SafeMath for uint;\n', '\n', '\tmapping(address => uint) public payments;\n', '\tevent LogRefundETH(address to, uint value);\n', '\t/**\n', '\t*  Store sent amount as credit to be pulled, called by payer \n', '\t**/\n', '\tfunction asyncSend(address dest, uint amount) internal {\n', '\t\tpayments[dest] = payments[dest].add(amount);\n', '\t}\n', '\t// withdraw accumulated balance, called by payee\n', '\tfunction withdrawPayments() {\n', '\t\taddress payee = msg.sender;\n', '\t\tuint payment = payments[payee];\n', '\n', '\t\tif (payment == 0) {\n', '\t\t\tthrow;\n', '\t\t}\n', '\t\tif (this.balance < payment) {\n', '\t\t    throw;\n', '\t\t}\n', '\t\tpayments[payee] = 0;\n', '\t\tif (!payee.send(payment)) {\n', '\t\t    throw;\n', '\t\t}\n', '\t\tLogRefundETH(payee,payment);\n', '\t}\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '\tuint public totalSupply;\n', '\tfunction balanceOf(address who) constant returns (uint);\n', '\tfunction transfer(address to, uint value);\n', '\tevent Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '\tfunction allowance(address owner, address spender) constant returns (uint);\n', '\tfunction transferFrom(address from, address to, uint value);\n', '\tfunction approve(address spender, uint value);\n', '\tevent Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  \n', '\tusing SafeMath for uint;\n', '\n', '\tmapping(address => uint) balances;\n', '\n', '\t/*\n', '\t* Fix for the ERC20 short address attack  \n', '\t*/\n', '\tmodifier onlyPayloadSize(uint size) {\n', '\t   if(msg.data.length < size + 4) {\n', '\t     throw;\n', '\t   }\n', '\t _;\n', '\t}\n', '\tfunction transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tTransfer(msg.sender, _to, _value);\n', '\t}\n', '\tfunction balanceOf(address _owner) constant returns (uint balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\tmapping (address => mapping (address => uint)) allowed;\n', '\tfunction transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '\t\tvar _allowance = allowed[_from][msg.sender];\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tallowed[_from][msg.sender] = _allowance.sub(_value);\n', '\t\tTransfer(_from, _to, _value);\n', '    }\n', '\tfunction approve(address _spender, uint _value) {\n', '\t\tif ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t}\n', '\tfunction allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '}\n', '\n', '\n', '/**\n', ' *  Devvote tokens contract.\n', ' */\n', 'contract DevotteToken is StandardToken, Ownable {\n', '\t\n', '  using SafeMath for uint;\n', '  \n', '\n', '    /**\n', '     * Variables\n', '    */\n', '    string public constant name = "DEVVOTE";\n', '    string public constant symbol = "VVE";\n', '    uint256 public constant decimals = 0;\n', '\n', '   \n', '    /**\n', '     * @dev Contract constructor\n', '     */ \n', '    function DevotteToken() {\n', '    totalSupply = 100000000;\n', '    balances[msg.sender] = totalSupply;\n', '    }\n', '    \n', '    \n', '    /**\n', '    *  Burn away the specified amount of ClusterToken tokens.\n', '    * @return Returns success boolean.\n', '    */\n', '    function burn(uint _value) onlyOwner returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Transfer(msg.sender, 0x0, _value);\n', '        return true;\n', '    }\n', '    \n', '}\n', '\n', '\n', 'contract DevvotePrefund is Pausable, PullPayment {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    \n', '    enum memberRanking { Executive, boardMember, ActiveMember, supportingMember }\n', '    memberRanking ranking;\n', '\n', '\n', '  \tstruct Backer {\n', '\t\tuint weiReceived;\n', '\t\tuint coinSent;\n', '\t\tmemberRanking userRank;\n', '\t}\n', '\n', '\t/*\n', '\t* Constants\n', '\t*/\n', '\n', '\tuint public constant MIN_CAP = 5000; // \n', '\tuint public constant MAX_CAP = 250000; // \n', '\t\n', '\t/* Minimum amount to invest */\n', '\tuint public constant MIN_INVEST_ETHER = 100 finney;\n', '\tuint public constant MIN_INVEST_BOARD = 10 ether ;\n', '\tuint public constant MIN_INVEST_ACTIVE = 3 ether;\n', '\tuint public constant MIN_INVEST_SUPPORT = 100 finney;\n', '\n', '\tuint private constant DevvotePrefund_PERIOD = 30 days;\n', '\n', '\tuint public constant COIN_PER_ETHER = 1000;\n', '\tuint public constant COIN_PER_ETHER_BOARD = 2500;\n', '\tuint public constant COIN_PER_ETHER_ACTIVE = 1500;\n', '\tuint public constant COIN_PER_ETHER_SUPPORT = 1000;\n', '\n', '\n', '\t/*\n', '\t* Variables\n', '\t*/\n', '\n', '\tDevotteToken public coin;\n', '\taddress public multisigEther;\n', '\tuint public etherReceived;\n', '\tuint public coinSentToEther;\n', '\n', '\tuint public startTime;\n', '\tuint public endTime;\n', '\tbool public DevvotePrefundClosed;\n', '\n', '\t/* Backers Ether indexed by their Ethereum address */\n', '\tmapping(address => Backer) public backers;\n', '\n', '\n', '\t/*\n', '\t* Modifiers\n', '\t*/\n', '\tmodifier minCapNotReached() {\n', '\t\tif ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier respectTimeFrame() {\n', '\t\tif ((now < startTime) || (now > endTime )) throw;\n', '\t\t_;\n', '\t}\n', '\n', '\t/*\n', '\t * Event\n', '\t*/\n', '\tevent LogReceivedETH(address addr, uint value);\n', '\tevent LogCoinsEmited(address indexed from, uint amount);\n', '\n', '\t/*\n', '\t * Constructor\n', '\t*/\n', '\tfunction DevvotePrefund(address _devvoteAddress, address _to) {\n', '\t\tcoin = DevotteToken(_devvoteAddress);\n', '\t\tmultisigEther = _to;\n', '\t\tstart();\n', '\t}\n', '\n', '\t/* \n', '\t * The fallback function corresponds to a donation in ETH\n', '\t */\n', '\tfunction() stopInEmergency respectTimeFrame payable {\n', '\t\treceiveETH(msg.sender);\n', '\t}\n', '\n', '\t/* \n', '\t * To call to start the DevvotePrefund\n', '\t */\n', '\tfunction start() onlyOwner {\n', '\t\tif (startTime != 0) throw; // DevvotePrefund was already started\n', '\n', '\t\tstartTime = now ;            \n', '\t\tendTime =  now + DevvotePrefund_PERIOD;    \n', '\t}\n', '\n', '\t/*\n', '\t *\tReceives a donation in Ether\n', '\t*/\n', '\tfunction receiveETH(address beneficiary) internal {\n', '\t    \n', '\t    memberRanking setRank;\n', '\t    uint coinToSend;\n', '\t    \n', '\t\tif (msg.value < MIN_INVEST_ETHER) throw; \n', '\t\t\n', '\t\t\n', '\t\tif (msg.value < MIN_INVEST_ACTIVE && msg.value >= MIN_INVEST_ETHER ) { \n', '\t\t    setRank = memberRanking.supportingMember;\n', '\t\t    coinToSend = bonus(msg.value.mul(COIN_PER_ETHER_SUPPORT).div(1 ether));\n', '\t\t}\n', '\t\tif (msg.value < MIN_INVEST_BOARD  && msg.value >= MIN_INVEST_ACTIVE) {\n', '\t\t    setRank = memberRanking.ActiveMember;\n', '\t\t    coinToSend = bonus(msg.value.mul(COIN_PER_ETHER_ACTIVE).div(1 ether));\n', '\t\t}\n', '\t\tif (msg.value >= MIN_INVEST_BOARD ) {\n', '\t\t    setRank = memberRanking.boardMember;\n', '\t\t    coinToSend = bonus(msg.value.mul(COIN_PER_ETHER_BOARD).div(1 ether));\n', '\t\t}\n', '\t\t\n', '\t\t\n', '\t\tif (coinToSend.add(coinSentToEther) > MAX_CAP) throw;\t\n', '\n', '\t\tBacker backer = backers[beneficiary];\n', '\t\tcoin.transfer(beneficiary, coinToSend); \n', '\t\tbacker.coinSent = backer.coinSent.add(coinToSend);\n', '\t\tbacker.weiReceived = backer.weiReceived.add(msg.value);    \n', '\t\tbacker.userRank = setRank;\n', '\n', '\t\tetherReceived = etherReceived.add(msg.value);\n', '\t\tcoinSentToEther = coinSentToEther.add(coinToSend);\n', '\n', '\t\tLogCoinsEmited(msg.sender ,coinToSend);\n', '\t\tLogReceivedETH(beneficiary, etherReceived); \n', '\t}\n', '\t\n', '\n', '\t/*\n', '\t *Compute the Devvote bonus according to the investment period\n', '\t */\n', '\tfunction bonus(uint amount) internal constant returns (uint) {\n', '\t\treturn amount.add(amount.div(5));   // bonus 20%\n', '\t}\n', '\n', '\t/*\t\n', '\t * Finalize the DevvotePrefund, should be called after the refund period\n', '\t*/\n', '\tfunction finalize() onlyOwner public {\n', '\n', '\t\tif (now < endTime) { // Cannot finalise before DevvotePrefund_PERIOD or before selling all coins\n', '\t\t\tif (coinSentToEther == MAX_CAP) {\n', '\t\t\t} else {\n', '\t\t\t\tthrow;\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tif (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise\n', '\n', '\t\tif (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address\n', '\t\t\n', '\t\tuint remains = coin.balanceOf(this);\n', '\t\tif (remains > 0) { // Burn the rest of Devvotes\n', '\t\t\tif (!coin.burn(remains)) throw ;\n', '\t\t}\n', '\t\tDevvotePrefundClosed = true;\n', '\t}\n', '\n', '\t/*\t\n', '\t* Failsafe drain\n', '\t*/\n', '\tfunction drain() onlyOwner {\n', '\t\tif (!owner.send(this.balance)) throw;\n', '\t}\n', '\n', '\t/**\n', '\t * Allow to change the team multisig address in the case of emergency.\n', '\t */\n', '\tfunction setMultisig(address addr) onlyOwner public {\n', '\t\tif (addr == address(0)) throw;\n', '\t\tmultisigEther = addr;\n', '\t}\n', '\n', '\t/**\n', '\t * Manually back Devvote owner address.\n', '\t */\n', '\tfunction backDevvoteOwner() onlyOwner public {\n', '\t\tcoin.transferOwnership(owner);\n', '\t}\n', '\n', '\t/**\n', '\t * Transfer remains to owner in case if impossible to do min invest\n', '\t */\n', '\tfunction getRemainCoins() onlyOwner public {\n', '\t\tvar remains = MAX_CAP - coinSentToEther;\n', '\t\tuint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));\n', '\n', '\t\tif(remains > minCoinsToSell) throw;\n', '\n', '\t\tBacker backer = backers[owner];\n', '\t\tcoin.transfer(owner, remains); // Transfer Devvotes right now \n', '\n', '\t\tbacker.coinSent = backer.coinSent.add(remains);\n', '\n', '\t\tcoinSentToEther = coinSentToEther.add(remains);\n', '\n', '\t\t// Send events\n', '\t\tLogCoinsEmited(this ,remains);\n', '\t\tLogReceivedETH(owner, etherReceived); \n', '\t}\n', '\n', '\n', '\t/* \n', '  \t * When MIN_CAP is not reach:\n', '  \t * 1) backer call the "approve" function of the Devvote token contract with the amount of all Devvotes they got in order to be refund\n', '  \t * 2) backer call the "refund" function of the DevvotePrefund contract with the same amount of Devvotes\n', '   \t * 3) backer call the "withdrawPayments" function of the DevvotePrefund contract to get a refund in ETH\n', '   \t */\n', '\tfunction refund(uint _value) minCapNotReached public {\n', '\t\t\n', '\t\tif (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance\n', '\n', '\t\tcoin.transferFrom(msg.sender, address(this), _value); // get the token back to the DevvotePrefund contract\n', '\n', '\t\tif (!coin.burn(_value)) throw ; // token sent for refund are burnt\n', '\n', '\t\tuint ETHToSend = backers[msg.sender].weiReceived;\n', '\t\tbackers[msg.sender].weiReceived=0;\n', '\n', '\t\tif (ETHToSend > 0) {\n', '\t\t\tasyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH\n', '\t\t}\n', '\t}\n', '\n', '}']