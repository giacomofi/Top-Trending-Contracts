['//! Copyright Parity Technologies, 2017.\n', '//! Released under the Apache Licence 2.\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', '/// Stripped down ERC20 standard token interface.\n', 'contract Token {\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// From Certifier.sol\n', 'contract Certifier {\n', '\tevent Confirmed(address indexed who);\n', '\tevent Revoked(address indexed who);\n', '\tfunction certified(address) public constant returns (bool);\n', '\tfunction get(address, string) public constant returns (bytes32);\n', '\tfunction getAddress(address, string) public constant returns (address);\n', '\tfunction getUint(address, string) public constant returns (uint);\n', '}\n', '\n', '/// Simple modified second price auction contract. Price starts high and monotonically decreases\n', '/// until all tokens are sold at the current price with currently received funds.\n', '/// The price curve has been chosen to resemble a logarithmic curve\n', '/// and produce a reasonable auction timeline.\n', 'contract SecondPriceAuction {\n', '\t// Events:\n', '\n', '\t/// Someone bought in at a particular max-price.\n', '\tevent Buyin(address indexed who, uint accounted, uint received, uint price);\n', '\n', '\t/// Admin injected a purchase.\n', '\tevent Injected(address indexed who, uint accounted, uint received);\n', '\n', '\t/// Admin uninjected a purchase.\n', '\tevent Uninjected(address indexed who);\n', '\n', '\t/// At least 5 minutes has passed since last Ticked event.\n', '\tevent Ticked(uint era, uint received, uint accounted);\n', '\n', '\t/// The sale just ended with the current price.\n', '\tevent Ended(uint price);\n', '\n', '\t/// Finalised the purchase for `who`, who has been given `tokens` tokens.\n', '\tevent Finalised(address indexed who, uint tokens);\n', '\n', '\t/// Auction is over. All accounts finalised.\n', '\tevent Retired();\n', '\n', '\t// Constructor:\n', '\n', '\t/// Simple constructor.\n', '\t/// Token cap should take be in whole tokens, not smallest divisible units.\n', '\tfunction SecondPriceAuction(\n', '\t\taddress _certifierContract,\n', '\t\taddress _tokenContract,\n', '\t\taddress _treasury,\n', '\t\taddress _admin,\n', '\t\tuint _beginTime,\n', '\t\tuint _tokenCap\n', '\t)\n', '\t\tpublic\n', '\t{\n', '\t\tcertifier = Certifier(_certifierContract);\n', '\t\ttokenContract = Token(_tokenContract);\n', '\t\ttreasury = _treasury;\n', '\t\tadmin = _admin;\n', '\t\tbeginTime = _beginTime;\n', '\t\ttokenCap = _tokenCap;\n', '\t\tendTime = beginTime + 28 days;\n', '\t}\n', '\n', '\t// No default function, entry-level users\n', '\tfunction() public { assert(false); }\n', '\n', '\t// Public interaction:\n', '\n', '\t/// Buyin function. Throws if the sale is not active and when refund would be needed.\n', '\tfunction buyin(uint8 v, bytes32 r, bytes32 s)\n', '\t\tpublic\n', '\t\tpayable\n', '\t\twhen_not_halted\n', '\t\twhen_active\n', '\t\tonly_eligible(msg.sender, v, r, s)\n', '\t{\n', '\t\tflushEra();\n', '\n', '\t\t// Flush bonus period:\n', '\t\tif (currentBonus > 0) {\n', '\t\t\t// Bonus is currently active...\n', '\t\t\tif (now >= beginTime + BONUS_MIN_DURATION\t\t\t\t// ...but outside the automatic bonus period\n', '\t\t\t\t&& lastNewInterest + BONUS_LATCH <= block.number\t// ...and had no new interest for some blocks\n', '\t\t\t) {\n', '\t\t\t\tcurrentBonus--;\n', '\t\t\t}\n', '\t\t\tif (now >= beginTime + BONUS_MAX_DURATION) {\n', '\t\t\t\tcurrentBonus = 0;\n', '\t\t\t}\n', '\t\t\tif (buyins[msg.sender].received == 0) {\t// We have new interest\n', '\t\t\t\tlastNewInterest = uint32(block.number);\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tuint accounted;\n', '\t\tbool refund;\n', '\t\tuint price;\n', '\t\t(accounted, refund, price) = theDeal(msg.value);\n', '\n', '\t\t/// No refunds allowed.\n', '\t\trequire (!refund);\n', '\n', '\t\t// record the acceptance.\n', '\t\tbuyins[msg.sender].accounted += uint128(accounted);\n', '\t\tbuyins[msg.sender].received += uint128(msg.value);\n', '\t\ttotalAccounted += accounted;\n', '\t\ttotalReceived += msg.value;\n', '\t\tendTime = calculateEndTime();\n', '\t\tBuyin(msg.sender, accounted, msg.value, price);\n', '\n', '\t\t// send to treasury\n', '\t\ttreasury.transfer(msg.value);\n', '\t}\n', '\n', '\t/// Like buyin except no payment required and bonus automatically given.\n', '\tfunction inject(address _who, uint128 _received)\n', '\t\tpublic\n', '\t\tonly_admin\n', '\t\tonly_basic(_who)\n', '\t\tbefore_beginning\n', '\t{\n', '\t\tuint128 bonus = _received * uint128(currentBonus) / 100;\n', '\t\tuint128 accounted = _received + bonus;\n', '\n', '\t\tbuyins[_who].accounted += accounted;\n', '\t\tbuyins[_who].received += _received;\n', '\t\ttotalAccounted += accounted;\n', '\t\ttotalReceived += _received;\n', '\t\tendTime = calculateEndTime();\n', '\t\tInjected(_who, accounted, _received);\n', '\t}\n', '\n', '\t/// Reverses a previous `inject` command.\n', '\tfunction uninject(address _who)\n', '\t\tpublic\n', '\t\tonly_admin\n', '\t\tbefore_beginning\n', '\t{\n', '\t\ttotalAccounted -= buyins[_who].accounted;\n', '\t\ttotalReceived -= buyins[_who].received;\n', '\t\tdelete buyins[_who];\n', '\t\tendTime = calculateEndTime();\n', '\t\tUninjected(_who);\n', '\t}\n', '\n', '\t/// Mint tokens for a particular participant.\n', '\tfunction finalise(address _who)\n', '\t\tpublic\n', '\t\twhen_not_halted\n', '\t\twhen_ended\n', '\t\tonly_buyins(_who)\n', '\t{\n', "\t\t// end the auction if we're the first one to finalise.\n", '\t\tif (endPrice == 0) {\n', '\t\t\tendPrice = totalAccounted / tokenCap;\n', '\t\t\tEnded(endPrice);\n', '\t\t}\n', '\n', '\t\t// enact the purchase.\n', '\t\tuint total = buyins[_who].accounted;\n', '\t\tuint tokens = total / endPrice;\n', '\t\ttotalFinalised += total;\n', '\t\tdelete buyins[_who];\n', '\t\trequire (tokenContract.transfer(_who, tokens));\n', '\n', '\t\tFinalised(_who, tokens);\n', '\n', '\t\tif (totalFinalised == totalAccounted) {\n', '\t\t\tRetired();\n', '\t\t}\n', '\t}\n', '\n', '\t// Prviate utilities:\n', '\n', '\t/// Ensure the era tracker is prepared in case the current changed.\n', '\tfunction flushEra() private {\n', '\t\tuint currentEra = (now - beginTime) / ERA_PERIOD;\n', '\t\tif (currentEra > eraIndex) {\n', '\t\t\tTicked(eraIndex, totalReceived, totalAccounted);\n', '\t\t}\n', '\t\teraIndex = currentEra;\n', '\t}\n', '\n', '\t// Admin interaction:\n', '\n', '\t/// Emergency function to pause buy-in and finalisation.\n', '\tfunction setHalted(bool _halted) public only_admin { halted = _halted; }\n', '\n', '\t/// Emergency function to drain the contract of any funds.\n', '\tfunction drain() public only_admin { treasury.transfer(this.balance); }\n', '\n', '\t// Inspection:\n', '\n', '\t/**\n', '\t * The formula for the price over time.\n', '\t *\n', '\t * This is a hand-crafted formula (no named to the constants) in order to\n', '\t * provide the following requirements:\n', '\t *\n', '\t * - Simple reciprocal curve (of the form y = a + b / (x + c));\n', '\t * - Would be completely unreasonable to end in the first 48 hours;\n', '\t * - Would reach $65m effective cap in 4 weeks.\n', '\t *\n', '\t * The curve begins with an effective cap (EC) of over $30b, more ether\n', '\t * than is in existance. After 48 hours, the EC reduces to approx. $1b.\n', '\t * At just over 10 days, the EC has reduced to $200m, and half way through\n', '\t * the 19th day it has reduced to $100m.\n', '\t *\n', "\t * Here's the curve: https://www.desmos.com/calculator/k6iprxzcrg?embed\n", '\t */\n', '\n', '\t/// The current end time of the sale assuming that nobody else buys in.\n', '\tfunction calculateEndTime() public constant returns (uint) {\n', '\t\tvar factor = tokenCap / DIVISOR * USDWEI;\n', '\t\treturn beginTime + 40000000 * factor / (totalAccounted + 5 * factor) - 5760;\n', '\t}\n', '\n', '\t/// The current price for a single indivisible part of a token. If a buyin happens now, this is\n', "\t/// the highest price per indivisible token part that the buyer will pay. This doesn't\n", '\t/// include the discount which may be available.\n', '\tfunction currentPrice() public constant when_active returns (uint weiPerIndivisibleTokenPart) {\n', '\t\treturn (USDWEI * 40000000 / (now - beginTime + 5760) - USDWEI * 5) / DIVISOR;\n', '\t}\n', '\n', '\t/// Returns the total indivisible token parts available for purchase right now.\n', '\tfunction tokensAvailable() public constant when_active returns (uint tokens) {\n', '\t\tuint _currentCap = totalAccounted / currentPrice();\n', '\t\tif (_currentCap >= tokenCap) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\treturn tokenCap - _currentCap;\n', '\t}\n', '\n', '\t/// The largest purchase than can be made at present, not including any\n', '\t/// discount.\n', '\tfunction maxPurchase() public constant when_active returns (uint spend) {\n', '\t\treturn tokenCap * currentPrice() - totalAccounted;\n', '\t}\n', '\n', '\t/// Get the number of `tokens` that would be given if the sender were to\n', '\t/// spend `_value` now. Also tell you what `refund` would be given, if any.\n', '\tfunction theDeal(uint _value)\n', '\t\tpublic\n', '\t\tconstant\n', '\t\twhen_active\n', '\t\treturns (uint accounted, bool refund, uint price)\n', '\t{\n', '\t\tuint _bonus = bonus(_value);\n', '\n', '\t\tprice = currentPrice();\n', '\t\taccounted = _value + _bonus;\n', '\n', '\t\tuint available = tokensAvailable();\n', '\t\tuint tokens = accounted / price;\n', '\t\trefund = (tokens > available);\n', '\t}\n', '\n', '\t/// Any applicable bonus to `_value`.\n', '\tfunction bonus(uint _value)\n', '\t\tpublic\n', '\t\tconstant\n', '\t\twhen_active\n', '\t\treturns (uint extra)\n', '\t{\n', '\t\treturn _value * uint(currentBonus) / 100;\n', '\t}\n', '\n', '\t/// True if the sale is ongoing.\n', '\tfunction isActive() public constant returns (bool) { return now >= beginTime && now < endTime; }\n', '\n', '\t/// True if all buyins have finalised.\n', '\tfunction allFinalised() public constant returns (bool) { return now >= endTime && totalAccounted == totalFinalised; }\n', '\n', '\t/// Returns true if the sender of this transaction is a basic account.\n', '\tfunction isBasicAccount(address _who) internal constant returns (bool) {\n', '\t\tuint senderCodeSize;\n', '\t\tassembly {\n', '\t\t\tsenderCodeSize := extcodesize(_who)\n', '\t\t}\n', '\t    return senderCodeSize == 0;\n', '\t}\n', '\n', '\t// Modifiers:\n', '\n', '\t/// Ensure the sale is ongoing.\n', '\tmodifier when_active { require (isActive()); _; }\n', '\n', '\t/// Ensure the sale has not begun.\n', '\tmodifier before_beginning { require (now < beginTime); _; }\n', '\n', '\t/// Ensure the sale is ended.\n', '\tmodifier when_ended { require (now >= endTime); _; }\n', '\n', "\t/// Ensure we're not halted.\n", '\tmodifier when_not_halted { require (!halted); _; }\n', '\n', '\t/// Ensure `_who` is a participant.\n', '\tmodifier only_buyins(address _who) { require (buyins[_who].accounted != 0); _; }\n', '\n', '\t/// Ensure sender is admin.\n', '\tmodifier only_admin { require (msg.sender == admin); _; }\n', '\n', '\t/// Ensure that the signature is valid, `who` is a certified, basic account,\n', '\t/// the gas price is sufficiently low and the value is sufficiently high.\n', '\tmodifier only_eligible(address who, uint8 v, bytes32 r, bytes32 s) {\n', '\t\trequire (\n', '\t\t\tecrecover(STATEMENT_HASH, v, r, s) == who &&\n', '\t\t\tcertifier.certified(who) &&\n', '\t\t\tisBasicAccount(who) &&\n', '\t\t\tmsg.value >= DUST_LIMIT\n', '\t\t);\n', '\t\t_;\n', '\t}\n', '\n', '\t/// Ensure sender is not a contract.\n', '\tmodifier only_basic(address who) { require (isBasicAccount(who)); _; }\n', '\n', '\t// State:\n', '\n', '\tstruct Account {\n', '\t\tuint128 accounted;\t// including bonus & hit\n', '\t\tuint128 received;\t// just the amount received, without bonus & hit\n', '\t}\n', '\n', '\t/// Those who have bought in to the auction.\n', '\tmapping (address => Account) public buyins;\n', '\n', '\t/// Total amount of ether received, excluding phantom "bonus" ether.\n', '\tuint public totalReceived = 0;\n', '\n', '\t/// Total amount of ether accounted for, including phantom "bonus" ether.\n', '\tuint public totalAccounted = 0;\n', '\n', '\t/// Total amount of ether which has been finalised.\n', '\tuint public totalFinalised = 0;\n', '\n', '\t/// The current end time. Gets updated when new funds are received.\n', '\tuint public endTime;\n', '\n', '\t/// The price per token; only valid once the sale has ended and at least one\n', '\t/// participant has finalised.\n', '\tuint public endPrice;\n', '\n', '\t/// Must be false for any public function to be called.\n', '\tbool public halted;\n', '\n', '\t/// The current percentage of bonus that purchasers get.\n', '\tuint8 public currentBonus = 15;\n', '\n', '\t/// The last block that had a new participant.\n', '\tuint32 public lastNewInterest;\n', '\n', '\t// Constants after constructor:\n', '\n', '\t/// The tokens contract.\n', '\tToken public tokenContract;\n', '\n', '\t/// The certifier.\n', '\tCertifier public certifier;\n', '\n', '\t/// The treasury address; where all the Ether goes.\n', '\taddress public treasury;\n', '\n', '\t/// The admin address; auction can be paused or halted at any time by this.\n', '\taddress public admin;\n', '\n', '\t/// The time at which the sale begins.\n', '\tuint public beginTime;\n', '\n', '\t/// Maximum amount of tokens to mint. Once totalAccounted / currentPrice is\n', '\t/// greater than this, the sale ends.\n', '\tuint public tokenCap;\n', '\n', '\t// Era stuff (isolated)\n', '\t/// The era for which the current consolidated data represents.\n', '\tuint public eraIndex;\n', '\n', '\t/// The size of the era in seconds.\n', '\tuint constant public ERA_PERIOD = 5 minutes;\n', '\n', '\t// Static constants:\n', '\n', '\t/// Anything less than this is considered dust and cannot be used to buy in.\n', '\tuint constant public DUST_LIMIT = 5 finney;\n', '\n', '\t/// The hash of the statement which must be signed in order to buyin.\n', '\t/// The meaning of this hash is:\n', '\t///\n', '\t/// parity.api.util.sha3(parity.api.util.asciiToHex("\\x19Ethereum Signed Message:\\n" + tscs.length + tscs))\n', '\t/// where `toUTF8 = x => unescape(encodeURIComponent(x))`\n', '\t/// and `tscs` is the toUTF8 called on the contents of https://gist.githubusercontent.com/gavofyork/5a530cad3b19c1cafe9148f608d729d2/raw/a116b507fd6d96036037f3affd393994b307c09a/gistfile1.txt\n', '\tbytes32 constant public STATEMENT_HASH = 0x2cedb9c5443254bae6c4f44a31abcb33ec27a0bd03eb58e22e38cdb8b366876d;\n', '\n', '\t/// Minimum duration after sale begins that bonus is active.\n', '\tuint constant public BONUS_MIN_DURATION = 1 hours;\n', '\n', '\t/// Minimum duration after sale begins that bonus is active.\n', '\tuint constant public BONUS_MAX_DURATION = 24 hours;\n', '\n', '\t/// Number of consecutive blocks where there must be no new interest before bonus ends.\n', '\tuint constant public BONUS_LATCH = 2;\n', '\n', '\t/// Number of Wei in one USD, constant.\n', '\tuint constant public USDWEI = 3226 szabo;\n', '\n', '\t/// Divisor of the token.\n', '\tuint constant public DIVISOR = 1000;\n', '}']