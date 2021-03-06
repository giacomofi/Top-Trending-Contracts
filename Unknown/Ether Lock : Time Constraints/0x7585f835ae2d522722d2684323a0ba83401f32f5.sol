['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract DoNotDeployThisGetTheRightOneCosParityPutsThisOnTop {\n', '    uint256 nothing;\n', '\n', '    function DoNotDeployThisGetTheRightOneCosParityPutsThisOnTop() {\n', '        nothing = 27;\n', '    }\n', '}\n', '\n', '\n', '//*************** Ownable\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    \n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '//***********Pausible\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require (!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require (paused) ;\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '//*************ERC20\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '//*************** SafeMath\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '}\n', '\n', '//**************** StandardToken\n', '\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     require(msg.data.length >= size + 4);\n', '     _;\n', '  }\n', '\n', '  mapping(address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  returns (bool success){\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract GBT {\n', '  function parentChange(address,uint);\n', '  function parentFees(address);\n', '  function setHGT(address _hgt);\n', '}\n', '\n', '//************ HELLOGOLDTOKEN\n', '\n', 'contract HelloGoldToken is ERC20, SafeMath, Pausable, StandardToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint8  public decimals;\n', '\n', '  GBT  goldtoken;\n', '  \n', '\n', '  function setGBT(address gbt_) onlyOwner {\n', '    goldtoken = GBT(gbt_);\n', '  }\n', '\n', '  function GBTAddress() constant returns (address) {\n', '    return address(goldtoken);\n', '  }\n', '\n', '  function HelloGoldToken(address _reserve) {\n', '    name = "HelloGold Token";\n', '    symbol = "HGT";\n', '    decimals = 8;\n', ' \n', '    totalSupply = 1 * 10 ** 9 * 10 ** uint256(decimals);\n', '    balances[_reserve] = totalSupply;\n', '  }\n', '\n', '\n', '  function parentChange(address _to) internal {\n', '    require(address(goldtoken) != 0x0);\n', '    goldtoken.parentChange(_to,balances[_to]);\n', '  }\n', '  function parentFees(address _to) internal {\n', '    require(address(goldtoken) != 0x0);\n', '    goldtoken.parentFees(_to);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success){\n', '    parentFees(_from);\n', '    parentFees(_to);\n', '    success = super.transferFrom(_from,_to,_value);\n', '    parentChange(_from);\n', '    parentChange(_to);\n', '    return;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) whenNotPaused returns (bool success)  {\n', '    parentFees(msg.sender);\n', '    parentFees(_to);\n', '    success = super.transfer(_to,_value);\n', '    parentChange(msg.sender);\n', '    parentChange(_to);\n', '    return;\n', '  }\n', '\n', '  function approve(address _spender, uint _value) whenNotPaused returns (bool success)  {\n', '    return super.approve(_spender,_value);\n', '  }\n', '}\n', '\n', '//********* GOLDFEES ************************\n', '\n', 'contract GoldFees is SafeMath,Ownable {\n', '    // e.g. if rate = 0.0054\n', '    //uint rateN = 9999452055;\n', '    uint rateN = 9999452054794520548;\n', '    uint rateD = 19;\n', '    uint public maxDays;\n', '    uint public maxRate;\n', '\n', '    \n', '    function GoldFees() {\n', '        calcMax();\n', '    }\n', '\n', '    function calcMax() {\n', '        maxDays = 1;\n', '        maxRate = rateN;\n', '        \n', '        \n', '        uint pow = 2;\n', '        do {\n', '            uint newN = rateN ** pow;\n', '            if (newN / maxRate != maxRate) {\n', '                maxDays = pow / 2;\n', '                break;\n', '            }\n', '            maxRate = newN;\n', '            pow *= 2;\n', '        } while (pow < 2000);\n', '        \n', '    }\n', '\n', '    function updateRate(uint256 _n, uint256 _d) onlyOwner{\n', '        rateN = _n;\n', '        rateD = _d;\n', '        calcMax();\n', '    }\n', '    \n', '    function rateForDays(uint256 numDays) constant returns (uint256 rate) {\n', '        if (numDays <= maxDays) {\n', '            uint r = rateN ** numDays;\n', '            uint d = rateD * numDays;\n', '            if (d > 18) {\n', '                uint div =  10 ** (d-18);\n', '                rate = r / div;\n', '            } else {\n', '                div = 10 ** (18 - d);\n', '                rate = r * div;\n', '            }\n', '        } else {\n', '            uint256 md1 = numDays / 2;\n', '            uint256 md2 = numDays - md1;\n', '             uint256 r2;\n', '\n', '            uint256 r1 = rateForDays(md1);\n', '            if (md1 == md2) {\n', '                r2 = r1;\n', '            } else {\n', '                r2 = rateForDays(md2);\n', '            }\n', '           \n', '\n', '            //uint256 r1 = rateForDays(maxDays);\n', '            //uint256 r2 = rateForDays(numDays-maxDays);\n', '            rate  = safeMul( r1 , r2)  / 10 ** 18;\n', '        }\n', '        return; \n', '        \n', '    }\n', '\n', '    uint256 constant public UTC2MYT = 1483200000;\n', '\n', '    function wotDay(uint256 time) returns (uint256) {\n', '        return (time - UTC2MYT) / (1 days);\n', '    }\n', '\n', '    // minimum fee is 1 unless same day\n', '    function calcFees(uint256 start, uint256 end, uint256 startAmount) constant returns (uint256 amount, uint256 fee) {\n', '        if (startAmount == 0) return;\n', '        uint256 numberOfDays = wotDay(end) - wotDay(start);\n', '        if (numberOfDays == 0) {\n', '            amount = startAmount;\n', '            return;\n', '        }\n', '        amount = (rateForDays(numberOfDays) * startAmount) / (1 ether);\n', '        if ((fee == 0) && (amount !=  0)) amount--;\n', '        fee = safeSub(startAmount,amount);\n', '    }\n', '}\n', '\n', '//******************** GoldBackedToken\n', '\n', 'contract GoldBackedToken is Ownable, SafeMath, ERC20, Pausable {\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '  event DeductFees(address indexed owner,uint256 amount);\n', '\n', '  event TokenMinted(address destination, uint256 amount);\n', '  event TokenBurned(address source, uint256 amount);\n', '  \n', '\tstring public name = "HelloGold Gold Backed Token";\n', '\tstring public symbol = "GBT";\n', '\tuint256 constant public  decimals = 18;  // same as ETH\n', '\tuint256 constant public  hgtDecimals = 8;\n', '\t\t\n', '\tuint256 constant public allocationPool = 1 *  10**9 * 10**hgtDecimals;      // total HGT holdings\n', '\tuint256\tconstant public\tmaxAllocation  = 38 * 10**5 * 10**decimals;\t\t\t// max GBT that can ever ever be given out\n', '\tuint256\t         public\ttotAllocation;\t\t\t// amount of GBT so far\n', '\t\n', '\taddress\t\t\t public feeCalculator;\n', '\taddress\t\t     public HGT;\t\t\t\t\t// HGT contract address\n', '\n', '\n', '\n', '\tfunction setFeeCalculator(address newFC) onlyOwner {\n', '\t\tfeeCalculator = newFC;\n', '\t}\n', '\n', '\n', '\tfunction calcFees(uint256 from, uint256 to, uint256 amount) returns (uint256 val, uint256 fee) {\n', '\t\treturn GoldFees(feeCalculator).calcFees(from,to,amount);\n', '\t}\n', '\n', '\tfunction GoldBackedToken(address feeCalc) {\n', '\t\tfeeCalculator = feeCalc;\n', '\t}\n', '\n', '    struct allocation { \n', '        uint256     amount;\n', '        uint256     date;\n', '    }\n', '\t\n', '\tallocation[]   public allocationsOverTime;\n', '\tallocation[]   public currentAllocations;\n', '\n', '\tfunction currentAllocationLength() constant returns (uint256) {\n', '\t\treturn currentAllocations.length;\n', '\t}\n', '\n', '\tfunction aotLength() constant returns (uint256) {\n', '\t\treturn allocationsOverTime.length;\n', '\t}\n', '\n', '\t\n', '    struct Balance {\n', '        uint256 amount;                 // amount through update or transfer\n', '        uint256 lastUpdated;            // DATE last updated\n', '        uint256 nextAllocationIndex;    // which allocationsOverTime record contains next update\n', '        uint256 allocationShare;        // the share of allocationPool that this holder gets (means they hold HGT)\n', '    }\n', '\n', '\t/*Creates an array with all balances*/\n', '\tmapping (address => Balance) public balances;\n', '\tmapping (address => mapping (address => uint)) allowed;\n', '\t\n', '\tfunction update(address where) internal {\n', '        uint256 pos;\n', '\t\tuint256 fees;\n', '\t\tuint256 val;\n', '        (val,fees,pos) = updatedBalance(where);\n', '\t    balances[where].nextAllocationIndex = pos;\n', '\t    balances[where].amount = val;\n', '        balances[where].lastUpdated = now;\n', '\t}\n', '\t\n', '\tfunction updatedBalance(address where) constant public returns (uint val, uint fees, uint pos) {\n', '\t\tuint256 c_val;\n', '\t\tuint256 c_fees;\n', '\t\tuint256 c_amount;\n', '\n', '\t\t(val, fees) = calcFees(balances[where].lastUpdated,now,balances[where].amount);\n', '\n', '\t    pos = balances[where].nextAllocationIndex;\n', '\t\tif ((pos < currentAllocations.length) &&  (balances[where].allocationShare != 0)) {\n', '\n', '\t\t\tc_amount = currentAllocations[balances[where].nextAllocationIndex].amount * balances[where].allocationShare / allocationPool;\n', '\n', '\t\t\t(c_val,c_fees)   = calcFees(currentAllocations[balances[where].nextAllocationIndex].date,now,c_amount);\n', '\n', '\t\t} \n', '\n', '\t    val  += c_val;\n', '\t\tfees += c_fees;\n', '\t\tpos   = currentAllocations.length;\n', '\t}\n', '\n', '    function balanceOf(address where) constant returns (uint256 val) {\n', '        uint256 fees;\n', '\t\tuint256 pos;\n', '        (val,fees,pos) = updatedBalance(where);\n', '        return ;\n', '    }\n', '\n', '\tevent Allocation(uint256 amount, uint256 date);\n', '\tevent FeeOnAllocation(uint256 fees, uint256 date);\n', '\n', '\tevent PartComplete();\n', '\tevent StillToGo(uint numLeft);\n', '\tuint256 public partPos;\n', '\tuint256 public partFees;\n', '\tuint256 partL;\n', '\tallocation[]   public partAllocations;\n', '\n', '\tfunction partAllocationLength() constant returns (uint) {\n', '\t\treturn partAllocations.length;\n', '\t}\n', '\n', '\tfunction addAllocationPartOne(uint newAllocation,uint numSteps) onlyOwner{\n', '\t\tuint256 thisAllocation = newAllocation;\n', '\n', '\t\trequire(totAllocation < maxAllocation);\t\t// cannot allocate more than this;\n', '\n', '\t\tif (currentAllocations.length > partAllocations.length) {\n', '\t\t\tpartAllocations = currentAllocations;\n', '\t\t}\n', '\n', '\t\tif (totAllocation + thisAllocation > maxAllocation) {\n', '\t\t\tthisAllocation = maxAllocation - totAllocation;\n', '\t\t\tlog0("max alloc reached");\n', '\t\t}\n', '\t\ttotAllocation += thisAllocation;\n', '\n', '\t\tAllocation(thisAllocation,now);\n', '\n', '        allocation memory newDiv;\n', '        newDiv.amount = thisAllocation;\n', '        newDiv.date = now;\n', '\t\t// store into history\n', '\t    allocationsOverTime.push(newDiv);\n', '\t\t// add this record to the end of currentAllocations\n', '\t\tpartL = partAllocations.push(newDiv);\n', '\t\t// update all other records with calcs from last record\n', '\t\tif (partAllocations.length < 2) { // no fees to consider\n', '\t\t\tPartComplete();\n', '\t\t\tcurrentAllocations = partAllocations;\n', '\t\t\tFeeOnAllocation(0,now);\n', '\t\t\treturn;\n', '\t\t}\n', '\t\t//\n', '\t\t// The only fees that need to be collected are the fees on location zero.\n', '\t\t// Since they are the last calculated = they come out with the break\n', '\t\t//\n', '\t\tfor (partPos = partAllocations.length - 2; partPos >= 0; partPos-- ){\n', '\t\t\t(partAllocations[partPos].amount,partFees) = calcFees(partAllocations[partPos].date,now,partAllocations[partPos].amount);\n', '\n', '\t\t\tpartAllocations[partPos].amount += partAllocations[partL - 1].amount;\n', '\t\t\tpartAllocations[partPos].date    = now;\n', '\t\t\tif ((partPos == 0) || (partPos == partAllocations.length-numSteps)){\n', '\t\t\t\tbreak; \n', '\t\t\t}\n', '\t\t}\n', '\t\tif (partPos != 0) {\n', '\t\t\tStillToGo(partPos);\n', '\t\t\treturn; // not done yet\n', '\t\t}\n', '\t\tPartComplete();\n', '\t\tFeeOnAllocation(partFees,now);\n', '\t\tcurrentAllocations = partAllocations;\n', '\t}\n', '\n', '\tfunction addAllocationPartTwo(uint numSteps) onlyOwner {\n', '\t\trequire(numSteps > 0);\n', '\t\trequire(partPos > 0);\n', '\t\tfor (uint i = 0; i < numSteps; i++ ){\n', '\t\t\tpartPos--;\n', '\t\t\t(partAllocations[partPos].amount,partFees) = calcFees(partAllocations[partPos].date,now,partAllocations[partPos].amount);\n', '\n', '\t\t\tpartAllocations[partPos].amount += partAllocations[partL - 1].amount;\n', '\t\t\tpartAllocations[partPos].date    = now;\n', '\t\t\tif (partPos == 0) {\n', '\t\t\t\tbreak; \n', '\t\t\t}\n', '\t\t}\n', '\t\tif (partPos != 0) {\n', '\t\t\tStillToGo(partPos);\n', '\t\t\treturn; // not done yet\n', '\t\t}\n', '\t\tPartComplete();\n', '\t\tFeeOnAllocation(partFees,now);\n', '\t\tcurrentAllocations = partAllocations;\n', '\t}\n', '\n', '\n', '\tfunction setHGT(address _hgt) onlyOwner {\n', '\t\tHGT = _hgt;\n', '\t}\n', '\n', '\tfunction parentFees(address where) whenNotPaused {\n', '\t\trequire(msg.sender == HGT);\n', '\t    update(where);\t\t\n', '\t}\n', '\t\n', '\tfunction parentChange(address where, uint newValue) whenNotPaused { // called when HGT balance changes\n', '\t\trequire(msg.sender == HGT);\n', '\t    balances[where].allocationShare = newValue;\n', '\t}\n', '\t\n', '\t/* send GBT */\n', '\tfunction transfer(address _to, uint256 _value) whenNotPaused returns (bool ok) {\n', '\t    update(msg.sender);              // Do this to ensure sender has enough funds.\n', '\t\tupdate(_to); \n', '\n', '        balances[msg.sender].amount = safeSub(balances[msg.sender].amount, _value);\n', '        balances[_to].amount = safeAdd(balances[_to].amount, _value);\n', '\n', '\t\tTransfer(msg.sender, _to, _value); //Notify anyone listening that this transfer took place\n', '        return true;\n', '\t}\n', '\n', '\tfunction transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool success) {\n', '\t\tvar _allowance = allowed[_from][msg.sender];\n', '\n', '\t    update(_from);              // Do this to ensure sender has enough funds.\n', '\t\tupdate(_to); \n', '\n', '\t\tbalances[_to].amount = safeAdd(balances[_to].amount, _value);\n', '\t\tbalances[_from].amount = safeSub(balances[_from].amount, _value);\n', '\t\tallowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '\t\tTransfer(_from, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '  \tfunction approve(address _spender, uint _value) whenNotPaused returns (bool success) {\n', '\t\trequire((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '    \tallowed[msg.sender][_spender] = _value;\n', '    \tApproval(msg.sender, _spender, _value);\n', '    \treturn true;\n', '  \t}\n', '\n', '  \tfunction allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    \treturn allowed[_owner][_spender];\n', '  \t}\n', '\n', '\t// Minting Functions \n', '\taddress public authorisedMinter;\n', '\n', '\tfunction setMinter(address minter) onlyOwner {\n', '\t\tauthorisedMinter = minter;\n', '\t}\n', '\t\n', '\tfunction mintTokens(address destination, uint256 amount) {\n', '\t\trequire(msg.sender == authorisedMinter);\n', '\t\tupdate(destination);\n', '\t\tbalances[destination].amount = safeAdd(balances[destination].amount, amount);\n', '\t\tbalances[destination].lastUpdated = now;\n', '\t\tbalances[destination].nextAllocationIndex = currentAllocations.length;\n', '\t\tTokenMinted(destination,amount);\n', '\t}\n', '\n', '\tfunction burnTokens(address source, uint256 amount) {\n', '\t\trequire(msg.sender == authorisedMinter);\n', '\t\tupdate(source);\n', '\t\tbalances[source].amount = safeSub(balances[source].amount,amount);\n', '\t\tbalances[source].lastUpdated = now;\n', '\t\tbalances[source].nextAllocationIndex = currentAllocations.length;\n', '\t\tTokenBurned(source,amount);\n', '\t}\n', '}\n', '\n', '//**************** HelloGoldSale\n', '\n', 'contract HelloGoldSale is Pausable, SafeMath {\n', '\n', '  uint256 public decimals = 8;\n', '\n', '  uint256 public startDate = 1503892800;      // Monday, August 28, 2017 12:00:00 PM GMT+08:00\n', '  uint256 public endDate   = 1504497600;      // Monday, September 4, 2017 12:00:00 PM GMT+08:00\n', '\n', '  uint256 tranchePeriod = 1 weeks;\n', '\n', '  // address of HGT Token. HGT must Approve this contract to disburse 300M tokens\n', '  HelloGoldToken          token;\n', '\n', '  uint256 constant MaxCoinsR1      = 180 * 10**6 * 10**8;   // 180M HGT\n', '  uint256 public coinsRemaining    = 180 * 10**6 * 10**8; \n', '  uint256 coinsPerTier             =  20 * 10**6 * 10**8;   // 20M HGT\n', '  uint256 public coinsLeftInTier   =  20 * 10**6 * 10**8;\n', '\n', '  uint256 public minimumCap        =  0;   // 40M HGT\n', '\n', '  uint256 numTiers                  = 5;\n', '  uint16  public tierNo;\n', '  uint256 public preallocCoins;   // used for testing against cap (inc placement)\n', '  uint256 public purchasedCoins;  // used for testing against tier pricing\n', '  uint256 public ethRaised;\n', '  uint256 public personalMax        = 10 * 1 ether;     // max ether per person during public sale\n', '  uint256 public contributors;\n', '\n', '  address public cs;\n', '  address public multiSig;\n', '  address public HGT_Reserve;\n', '  \n', '  struct csAction  {\n', '      bool        passedKYC;\n', '      bool        blocked;\n', '  }\n', '\n', '  /* This creates an array with all balances */\n', '  mapping (address => csAction) public permissions;\n', '  mapping (address => uint256)  public deposits;\n', '\n', '  modifier MustBeEnabled(address x) {\n', '      require (!permissions[x].blocked) ;\n', '      require (permissions[x].passedKYC) ;\n', '      \n', '      _;\n', '  }\n', '\n', '  function HelloGoldSale(address _cs, address _hgt, address _multiSig, address _reserve) {\n', '    cs          = _cs;\n', '    token       = HelloGoldToken(_hgt);\n', '    multiSig    = _multiSig;\n', '    HGT_Reserve = _reserve;\n', '  }\n', '\n', '  // We only expect to use this to set/reset the start of the contract under exceptional circumstances\n', '  function setStart(uint256 when_) onlyOwner {\n', '      startDate = when_;\n', '      endDate = when_ + tranchePeriod;\n', '  }\n', '\n', '  modifier MustBeCs() {\n', '      require (msg.sender == cs) ;\n', '      \n', '      _;\n', '  }\n', '\n', '\n', '  // 1 ether = N HGT tokens \n', '  uint256[5] public hgtRates = [1248900000000,1196900000000,1144800000000,1092800000000,1040700000000];\n', '                      \n', '\n', '    /* Approve the account for operation */\n', '    function approve(address user) MustBeCs {\n', '        permissions[user].passedKYC = true;\n', '    }\n', '    \n', '    function block(address user) MustBeCs {\n', '        permissions[user].blocked = true;\n', '    }\n', '\n', '    function unblock(address user) MustBeCs {\n', '         permissions[user].blocked = false;\n', '    }\n', '\n', '    function newCs(address newCs) onlyOwner {\n', '        cs = newCs;\n', '    }\n', '\n', '    function setPeriod(uint256 period_) onlyOwner {\n', '        require (!funding()) ;\n', '        tranchePeriod = period_;\n', '        endDate = startDate + tranchePeriod;\n', '        if (endDate < now + tranchePeriod) {\n', '            endDate = now + tranchePeriod;\n', '        }\n', '    }\n', '\n', '    function when()  constant returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '  function funding() constant returns (bool) {     \n', '    if (paused) return false;               // frozen\n', '    if (now < startDate) return false;      // too early\n', '    if (now > endDate) return false;        // too late\n', '    if (coinsRemaining == 0) return false;  // no more coins\n', '    if (tierNo >= numTiers ) return false;  // passed end of top tier. Tiers start at zero\n', '    return true;\n', '  }\n', '\n', '  function success() constant returns (bool succeeded) {\n', '    if (coinsRemaining == 0) return true;\n', '    bool complete = (now > endDate) ;\n', '    bool didOK = (coinsRemaining <= (MaxCoinsR1 - minimumCap)); // not even 40M Gone?? Aargh.\n', '    succeeded = (complete && didOK)  ;  // (out of steam but enough sold) \n', '    return ;\n', '  }\n', '\n', '  function failed() constant returns (bool didNotSucceed) {\n', '    bool complete = (now > endDate  );\n', '    bool didBad = (coinsRemaining > (MaxCoinsR1 - minimumCap));\n', '    didNotSucceed = (complete && didBad);\n', '    return;\n', '  }\n', '\n', '  \n', '  function () payable MustBeEnabled(msg.sender) whenNotPaused {    \n', '    createTokens(msg.sender,msg.value);\n', '  }\n', '\n', '  function linkCoin(address coin) onlyOwner {\n', '    token = HelloGoldToken(coin);\n', '  }\n', '\n', '  function coinAddress() constant returns (address) {\n', '      return address(token);\n', '  }\n', '\n', '  // hgtRates in whole tokens per ETH\n', '  // max individual contribution in whole ETH\n', '  function setHgtRates(uint256 p0,uint256 p1,uint256 p2,uint256 p3,uint256 p4, uint256 _max ) onlyOwner {\n', '              require (now < startDate) ;\n', '              hgtRates[0]   = p0 * 10**8;\n', '              hgtRates[1]   = p1 * 10**8;\n', '              hgtRates[2]   = p2 * 10**8;\n', '              hgtRates[3]   = p3 * 10**8;\n', '              hgtRates[4]   = p4 * 10**8;\n', '              personalMax = _max * 1 ether;           // max ETH per person\n', '  }\n', '\n', '  \n', '  event Purchase(address indexed buyer, uint256 level,uint256 value, uint256 tokens);\n', '  event Reduction(string msg, address indexed buyer, uint256 wanted, uint256 allocated);\n', '  \n', '  function createTokens(address recipient, uint256 value) private {\n', '    uint256 totalTokens;\n', '    uint256 hgtRate;\n', '    require (funding()) ;\n', '    require (value > 1 finney) ;\n', '    require (deposits[recipient] < personalMax);\n', '\n', '    uint256 maxRefund = 0;\n', '    if ((deposits[msg.sender] + value) > personalMax) {\n', '        maxRefund = deposits[msg.sender] + value - personalMax;\n', '        value -= maxRefund;\n', '        log0("maximum funds exceeded");\n', '    }  \n', '\n', '    uint256 val = value;\n', '\n', '    ethRaised = safeAdd(ethRaised,value);\n', '    if (deposits[recipient] == 0) contributors++;\n', '    \n', '    \n', '    do {\n', '      hgtRate = hgtRates[tierNo];                 // hgtRate must include the 10^8\n', '      uint tokens = safeMul(val, hgtRate);      // (val in eth * 10^18) * #tokens per eth\n', '      tokens = safeDiv(tokens, 1 ether);      // val is in ether, msg.value is in wei\n', '   \n', '      if (tokens <= coinsLeftInTier) {\n', '        uint256 actualTokens = tokens;\n', '        uint refund = 0;\n', '        if (tokens > coinsRemaining) { //can&#39;t sell desired # tokens\n', '            Reduction("in tier",recipient,tokens,coinsRemaining);\n', '            actualTokens = coinsRemaining;\n', '            refund = safeSub(tokens, coinsRemaining ); // refund amount in tokens\n', '            refund = safeDiv(refund*1 ether,hgtRate );  // refund amount in ETH\n', '            // need a refund mechanism here too\n', '            coinsRemaining = 0;\n', '            val = safeSub( val,refund);\n', '        } else {\n', '            coinsRemaining  = safeSub(coinsRemaining,  actualTokens);\n', '        }\n', '        purchasedCoins  = safeAdd(purchasedCoins, actualTokens);\n', '\n', '        totalTokens = safeAdd(totalTokens,actualTokens);\n', '\n', '        require (token.transferFrom(HGT_Reserve, recipient,totalTokens)) ;\n', '\n', '        Purchase(recipient,tierNo,val,actualTokens); // event\n', '\n', '        deposits[recipient] = safeAdd(deposits[recipient],val); // in case of refund - could pull off etherscan\n', '        refund += maxRefund;\n', '        if (refund > 0) {\n', '            ethRaised = safeSub(ethRaised,refund);\n', '            recipient.transfer(refund);\n', '        }\n', '        if (coinsRemaining <= (MaxCoinsR1 - minimumCap)){ // has passed success criteria\n', '            if (!multiSig.send(this.balance)) {                // send funds to HGF\n', '                log0("cannot forward funds to owner");\n', '            }\n', '        }\n', '        coinsLeftInTier = safeSub(coinsLeftInTier,actualTokens);\n', '        if ((coinsLeftInTier == 0) && (coinsRemaining != 0)) { // exact sell out of non final tier\n', '            coinsLeftInTier = coinsPerTier;\n', '            tierNo++;\n', '            endDate = now + tranchePeriod;\n', '        }\n', '        return;\n', '      }\n', '      // check that coinsLeftInTier >= coinsRemaining\n', '\n', '      uint256 coins2buy = min256(coinsLeftInTier , coinsRemaining); \n', '\n', '      endDate = safeAdd( now, tranchePeriod);\n', '      // Have bumped levels - need to modify end date here\n', '      purchasedCoins = safeAdd(purchasedCoins, coins2buy);  // give all coins remaining in this tier\n', '      totalTokens    = safeAdd(totalTokens,coins2buy);\n', '      coinsRemaining = safeSub(coinsRemaining,coins2buy);\n', '\n', '      uint weiCoinsLeftInThisTier = safeMul(coins2buy,1 ether);\n', '      uint costOfTheseCoins = safeDiv(weiCoinsLeftInThisTier, hgtRate);  // how much did that cost?\n', '\n', '      Purchase(recipient, tierNo,costOfTheseCoins,coins2buy); // event\n', '\n', '      deposits[recipient] = safeAdd(deposits[recipient],costOfTheseCoins);\n', '      val    = safeSub(val,costOfTheseCoins);\n', '      tierNo = tierNo + 1;\n', '      coinsLeftInTier = coinsPerTier;\n', '    } while ((val > 0) && funding());\n', '\n', '    // escaped because we passed the end of the universe.....\n', '    // so give them their tokens\n', '    require (token.transferFrom(HGT_Reserve, recipient,totalTokens)) ;\n', '\n', '    if ((val > 0) || (maxRefund > 0)){\n', '        Reduction("finished crowdsale, returning ",recipient,value,totalTokens);\n', '        // return the remainder !\n', '        recipient.transfer(val+maxRefund); // if you can&#39;t return the balance, abort whole process\n', '    }\n', '    if (!multiSig.send(this.balance)) {\n', '        ethRaised = safeSub(ethRaised,this.balance);\n', '        log0("cannot send at tier jump");\n', '    }\n', '  }\n', '  \n', '  function allocatedTokens(address grantee, uint256 numTokens) onlyOwner {\n', '    require (now < startDate) ;\n', '    if (numTokens < coinsRemaining) {\n', '        coinsRemaining = safeSub(coinsRemaining, numTokens);\n', '       \n', '    } else {\n', '        numTokens = coinsRemaining;\n', '        coinsRemaining = 0;\n', '    }\n', '    preallocCoins = safeAdd(preallocCoins,numTokens);\n', '    require (token.transferFrom(HGT_Reserve,grantee,numTokens));\n', '  }\n', '\n', '  function withdraw() { // it failed. Come and get your ether.\n', '      if (failed()) {\n', '          if (deposits[msg.sender] > 0) {\n', '              uint256 val = deposits[msg.sender];\n', '              deposits[msg.sender] = 0;\n', '              msg.sender.transfer(val);\n', '          }\n', '      }\n', '  }\n', '\n', '  function complete() onlyOwner {  // this should not have to be called. Extreme measures.\n', '      if (success()) {\n', '          uint256 val = this.balance;\n', '          if (val > 0) {\n', '            if (!multiSig.send(val)) {\n', '                log0("cannot withdraw");\n', '            } else {\n', '                log0("funds withdrawn");\n', '            }\n', '          } else {\n', '              log0("nothing to withdraw");\n', '          }\n', '      }\n', '  }\n', '\n', '}']