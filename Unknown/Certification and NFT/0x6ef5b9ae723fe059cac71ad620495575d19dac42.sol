['pragma solidity ^0.4.7;\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    //assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    //assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    //assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply=100000000; \n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value);\n', '  function approve(address spender, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract owned {\n', '     function owned() { owner = msg.sender; }\n', '     address owner;\n', '\n', '     // This contract only defines a modifier but does not use\n', '     // it - it will be used in derived contracts.\n', '     // The function body is inserted where the special symbol\n', '     // "_;" in the definition of a modifier appears.\n', '     // This means that if the owner calls this function, the\n', '     // function is executed and otherwise, an exception is\n', '     // thrown.\n', '     modifier onlyOwner {\n', '         if(msg.sender != owner)\n', '         {\n', '         throw;\n', '         }\n', '         _;\n', '     }\n', ' }\n', '\n', '\n', 'contract UniContract is StandardToken, owned {\n', '\n', '\n', '   string public constant name = "SaveUNICOINs";\n', '   string public constant symbol = "UCN";\n', '   uint256 public constant decimals = 0;\n', '   \n', '   //founder & fund collector\n', '   address public multisig;\n', '   address public founder; \n', '   \n', '   \n', '   //Timings\n', '   uint public start;  \n', '   uint public end;\n', '   uint public launch;\n', '   \n', '   //Dynamic Pricing PRICE IN UCN\n', '   uint256 public PRICE = 300000;  \n', '   \n', '   //Dynamic Status of sold UCN Tokens\n', '   uint256 public OVERALLSOLD = 0;  \n', '   \n', '   //Maximum of Tokens to be sold 85.000.000\n', '   uint256 public MAXTOKENSOLD = 85000000;  \n', '   \n', '   \n', '   \n', '   \n', '  \n', '   function UniContract() onlyOwner { \n', '       founder = 0x204244062B04089b6Ef55981Ad82119cEBf54F88; \n', '       multisig= 0x9FA2d2231FE8ac207831B376aa4aE35671619960; \n', '       start = 1507543200;\n', '       end = 1509098400; \n', ' \t   launch = 1509534000;\n', '       balances[founder] = balances[founder].add(15000000); // Founder (15% = 15.000.000 UCN)\n', '   }\n', '   \n', '   \n', '   \n', '   //Stage Pre-Sale Variables\n', '   \n', '   uint256 public constant PRICE_PRESALE = 300000;  \n', '   uint256 public constant FACTOR_PRESALE = 38;\n', '   uint256 public constant RANGESTART_PRESALE = 0; \n', '   uint256 public constant RANGEEND_PRESALE = 10000000; \n', '   \n', '   \n', '   //Stage 1\n', '   uint256 public constant PRICE_1 = 30000;  \n', '   uint256 public constant FACTOR_1 = 460;\n', '   uint256 public constant RANGESTART_1 = 10000001; \n', '   uint256 public constant RANGEEND_1 = 10100000;\n', '   \n', '   //Stage 2\n', '   uint256 public constant PRICE_2 = 29783;  \n', '   uint256 public constant FACTOR_2 = 495;\n', '   uint256 public constant RANGESTART_2 = 10100001; \n', '   uint256 public constant RANGEEND_2 = 11000000;\n', '   \n', '   //Stage 3\n', '   uint256 public constant PRICE_3 = 27964;  \n', '   uint256 public constant FACTOR_3 = 580;\n', '   uint256 public constant RANGESTART_3 = 11000001; \n', '   uint256 public constant RANGEEND_3 = 15000000;\n', '   \n', '   //Stage 4\n', '   uint256 public constant PRICE_4 = 21068;  \n', '   uint256 public constant FACTOR_4 = 800;\n', '   uint256 public constant RANGESTART_4 = 15000001; \n', '   uint256 public constant RANGEEND_4 = 20000000;\n', '   \n', '   //Stage 5\n', '   uint256 public constant PRICE_5 = 14818;  \n', '   uint256 public constant FACTOR_5 = 1332;\n', '   uint256 public constant RANGESTART_5 = 20000001; \n', '   uint256 public constant RANGEEND_5 = 30000000;\n', '   \n', '   //Stage 6\n', '   uint256 public constant PRICE_6 = 7310;  \n', '   uint256 public constant FACTOR_6 = 2700;\n', '   uint256 public constant RANGESTART_6 = 30000001; \n', '   uint256 public constant RANGEEND_6 = 40000000;\n', '   \n', '   //Stage 7\n', '   uint256 public constant PRICE_7 = 3607;  \n', '   uint256 public constant FACTOR_7 = 5450;\n', '   uint256 public constant RANGESTART_7 = 40000001; \n', '   uint256 public constant RANGEEND_7 = 50000000;\n', '   \n', '   //Stage 8\n', '   uint256 public constant PRICE_8 = 1772;  \n', '   uint256 public constant FACTOR_8 = 11000;\n', '   uint256 public constant RANGESTART_8 = 50000001; \n', '   uint256 public constant RANGEEND_8 = 60000000;\n', '   \n', '   //Stage 9\n', '   uint256 public constant PRICE_9 = 863;  \n', '   uint256 public constant FACTOR_9 = 23200;\n', '   uint256 public constant RANGESTART_9 = 60000001; \n', '   uint256 public constant RANGEEND_9 = 70000000;\n', '   \n', '   //Stage 10\n', '   uint256 public constant PRICE_10 = 432;  \n', '   uint256 public constant FACTOR_10 = 46000;\n', '   uint256 public constant RANGESTART_10 = 70000001; \n', '   uint256 public constant RANGEEND_10 = 80000000;\n', '   \n', '   //Stage 11\n', '   uint256 public constant PRICE_11 = 214;  \n', '   uint256 public constant FACTOR_11 = 78000;\n', '   uint256 public constant RANGESTART_11 = 80000001; \n', '   uint256 public constant RANGEEND_11 = 85000000;\n', '   \n', '\n', '   uint256 public UniCoinSize=0;\n', '\n', ' \n', '   function () payable {\n', '     submitTokens(msg.sender);\n', '   }\n', '\n', '   /**\n', '    * @dev Creates tokens and send to the specified address.\n', '    * @param recipient The address which will recieve the new tokens.\n', '    */\n', '   function submitTokens(address recipient) payable {\n', '     \tif (msg.value == 0) {\n', '       \t\tthrow;\n', '     \t}\n', '\t\t\n', '   \t \t//Permit buying only between 10/09/17 - 10/27/2017 and after 11/01/2017\n', '   \t \tif((now > start && now < end) || now > launch)\n', '   \t \t\t{\t\t\t\t\n', '        \t\tuint256 tokens = msg.value.mul(PRICE).div( 1 ether);\n', '        \t\tif(tokens.add(OVERALLSOLD) > MAXTOKENSOLD)\n', '   \t \t\t\t\t{\n', '   \t\t\t\t\tthrow;\n', '   \t\t\t\t\t}\n', '\t\t\n', '   \t\t\t\t//Pre-Sale CAP 10,000,000 check\n', '   \t\t\t\tif(((tokens.add(OVERALLSOLD)) > RANGEEND_PRESALE) && (now > start && now < end))\n', '   \t\t\t\t\t{\n', '   \t\t\t\t\tthrow;\n', '   \t\t\t\t\t}\n', '\t\t\n', ' \t\t\t\t   \n', '        \t\tOVERALLSOLD = OVERALLSOLD.add(tokens);\t\n', '\t\n', '   \t\t \t    // Send UCN to Recipient\t\n', '        \t\tbalances[recipient] = balances[recipient].add(tokens);\n', '\t \n', '   \t \t\t\t// Send Funds to MultiSig\n', '        \t\tif (!multisig.send(msg.value)) {\n', '          \t\t\tthrow;\n', '        \t\t\t}\n', '       \t\t}\n', '   \t  \t  else\n', '   \t  \t\t\t{\n', '   \t  \t  \t\tthrow;\n', '   \t \t\t   \t}\n', '\t\t\n', '\t\t\n', '\t\t//TIMING 10/09/17 - 10/27/17 OR CAP 10,000,000 reached\n', '\t\t\n', '\t\tif(now>start && now <end)\n', '\t\t{\n', '\t\t\t//Stage Pre-Sale Range 0 - 10,000,000 \n', '\t\t\tif(OVERALLSOLD >= RANGESTART_PRESALE && OVERALLSOLD <= RANGEEND_PRESALE) \n', '\t\t\t\t{\n', '\t\t\t\tPRICE = PRICE_PRESALE - (1 + OVERALLSOLD - RANGESTART_PRESALE).div(FACTOR_PRESALE);\n', '\t\t\t\t}\n', '\t\t}\n', '\t\t\n', '\t\t//TIMING 11/01/17 Start Token Sale\n', '\t\tif(now>launch)\n', '\t\t{\n', '\t\t//Stage Post-Pre-Sale Range 0 - 10,000,000 \n', '\t\tif(OVERALLSOLD >= RANGESTART_PRESALE && OVERALLSOLD <= RANGEEND_PRESALE) \n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_PRESALE - (1 + OVERALLSOLD - RANGESTART_PRESALE).div(FACTOR_PRESALE);\n', '\t\t\t}\n', '\t\t\n', '\t\t//Stage One 10,000,001 - 10,100,000 \n', '\t\tif(OVERALLSOLD >= RANGESTART_1 && OVERALLSOLD <= RANGEEND_1)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_1 - (1 + OVERALLSOLD - RANGESTART_1).div(FACTOR_1);\n', '\t\t\t}\n', '\n', '\t\t//Stage Two 10,100,001 - 11,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_2 && OVERALLSOLD <= RANGEEND_2)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_2 - (1 + OVERALLSOLD - RANGESTART_2).div(FACTOR_2);\n', '\t\t\t}\n', '\n', '\t\t//Stage Three 11,000,001 - 15,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_3 && OVERALLSOLD <= RANGEEND_3)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_3 - (1 + OVERALLSOLD - RANGESTART_3).div(FACTOR_3);\n', '\t\t\t}\n', '\t\t\t\n', '\t\t//Stage Four 15,000,001 - 20,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_4 && OVERALLSOLD <= RANGEEND_4)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_4 - (1 + OVERALLSOLD - RANGESTART_4).div(FACTOR_4);\n', '\t\t\t}\n', '\t\t\t\n', '\t\t//Stage Five 20,000,001 - 30,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_5 && OVERALLSOLD <= RANGEEND_5)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_5 - (1 + OVERALLSOLD - RANGESTART_5).div(FACTOR_5);\n', '\t\t\t}\n', '\t\t\n', '\t\t//Stage Six 30,000,001 - 40,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_6 && OVERALLSOLD <= RANGEEND_6)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_6 - (1 + OVERALLSOLD - RANGESTART_6).div(FACTOR_6);\n', '\t\t\t}\t\n', '\t\t\n', '\t\t//Stage Seven 40,000,001 - 50,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_7 && OVERALLSOLD <= RANGEEND_7)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_7 - (1 + OVERALLSOLD - RANGESTART_7).div(FACTOR_7);\n', '\t\t\t}\n', '\t\t\t\n', '\t\t//Stage Eight 50,000,001 - 60,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_8 && OVERALLSOLD <= RANGEEND_8)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_8 - (1 + OVERALLSOLD - RANGESTART_8).div(FACTOR_8);\n', '\t\t\t}\n', '\t\t\n', '\t\t//Stage Nine 60,000,001 - 70,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_9 && OVERALLSOLD <= RANGEEND_9)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_9 - (1 + OVERALLSOLD - RANGESTART_9).div(FACTOR_9);\n', '\t\t\t}\n', '\t\t\n', '\t\t//Stage Ten 70,000,001 - 80,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_10 && OVERALLSOLD <= RANGEEND_10)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_10 - (1 + OVERALLSOLD - RANGESTART_10).div(FACTOR_10);\n', '\t\t\t}\t\n', '\t\t\n', '\t\t//Stage Eleven 80,000,001 - 85,000,000\n', '\t\tif(OVERALLSOLD >= RANGESTART_11 && OVERALLSOLD <= RANGEEND_11)\n', '\t\t\t{\n', '\t\t\tPRICE = PRICE_11 - (1 + OVERALLSOLD - RANGESTART_11).div(FACTOR_11);\n', '\t\t\t}\n', '\t\t}\n', '\t\t\n', '\t\n', '   }\n', '\n', '\t \n', '   function submitEther(address recipient) payable {\n', '     if (msg.value == 0) {\n', '       throw;\n', '     }\n', '\n', '     if (!recipient.send(msg.value)) {\n', '       throw;\n', '     }\n', '    \n', '   }\n', '\n', '\n', '  //Unicorn Shoutbox\n', '\n', '  struct MessageQueue {\n', '           string message; \n', '  \t\t   string from;\n', '           uint expireTimestamp;  \n', '           uint startTimestamp;\n', '           address sender; \n', '       }\n', '\n', '\t \n', '     uint256 public constant maxSpendToken = 3600; //Message should last approx. 1 hour max\n', '\n', '     MessageQueue[] public mQueue;\n', ' \n', '\t\n', ' \n', '      function addMessageToQueue(string msg_from, string name_from, uint spendToken) {\n', '        if(balances[msg.sender]>spendToken && spendToken>=10)\n', '        {\n', '           if(spendToken>maxSpendToken) \n', '               {\n', '                   spendToken=maxSpendToken;\n', '               }\n', '           \n', '\t\t   UniCoinSize=UniCoinSize+spendToken;\n', '           \n', '           balances[msg.sender] = balances[msg.sender].sub(spendToken);\n', '          \n', '\t\t  //If first message or last message already expired set newest timestamp\n', '  \t\t  uint expireTimestamp=now;\n', '\t\t  if(mQueue.length>0)\n', '\t\t\t{\n', '\t\t\t if(mQueue[mQueue.length-1].expireTimestamp>now)\n', '\t\t\t \t{\n', '\t\t\t \texpireTimestamp = mQueue[mQueue.length-1].expireTimestamp;\n', '\t\t\t\t}\n', '\t\t\t} \n', '\t\t\n', '\t\t \n', '\t\t \n', '           mQueue.push(MessageQueue({\n', '                   message: msg_from, \n', '  \t\t\t\t   from: name_from,\n', '                   expireTimestamp: expireTimestamp.add(spendToken)+60,  //give at least approx 60 seconds per msg\n', '                   startTimestamp: expireTimestamp,\n', '                   sender: msg.sender\n', '               }));\n', '    \n', '        \n', '\t\t \n', '        }\n', '\t\telse {\n', '\t\t      throw;\n', '\t\t      }\n', '      }\n', '\t  \n', '\t\n', '    function feedUnicorn(uint spendToken) {\n', '\t\n', '   \t \tif(balances[msg.sender]>spendToken)\n', '        \t{\n', '       \t \tUniCoinSize=UniCoinSize.add(spendToken);\n', '        \tbalances[msg.sender] = balances[msg.sender].sub(spendToken);\n', '\t\t\t}\n', '\t\t\n', '\t } \n', '\t\n', '\t\n', '   function getQueueLength() public constant returns (uint256 result) {\n', '\t return mQueue.length;\n', '   }\n', '   function getMessage(uint256 i) public constant returns (string, string, uint, uint, address){\n', '     return (mQueue[i].message,mQueue[i].from,mQueue[i].expireTimestamp,mQueue[i].startTimestamp,mQueue[i].sender );\n', '   }\n', '   function getPrice() constant returns (uint256 result) {\n', '     return PRICE;\n', '   }\n', '   function getSupply() constant returns (uint256 result) {\n', '     return totalSupply;\n', '   }\n', '   function getSold() constant returns (uint256 result) {\n', '     return OVERALLSOLD;\n', '   }\n', '   function getUniCoinSize() constant returns (uint256 result) {    \n', '     return UniCoinSize; \n', '   } \n', '    function getAddress() constant returns (address) {\n', '     return this;\n', '   }\n', '    \n', '\n', '\n', '  \n', '   // ADMIN Functions\n', '\n', '   \n', '   //In emergency cases to stop or change timings \n', '   function aSetStart(uint256 nstart) onlyOwner {\n', '     start=nstart;\n', '   }\n', '   function aSetEnd(uint256 nend) onlyOwner {\n', '     end=nend;\n', '   }\n', '   function aSetLaunch(uint256 nlaunch) onlyOwner {\n', '     launch=nlaunch;\n', '   }\n', '    \n', '\n', "   //We don't want the Unicorn to spread hateful messages \n", '   function aDeleteMessage(uint256 i,string f,string m) onlyOwner{\n', '     mQueue[i].message=m;\n', '\t mQueue[i].from=f; \n', '\t\t }\n', '   \n', '   //Clean house from time to time\n', '   function aPurgeMessages() onlyOwner{\n', '   delete mQueue; \n', '   }\n', '\n', ' }']