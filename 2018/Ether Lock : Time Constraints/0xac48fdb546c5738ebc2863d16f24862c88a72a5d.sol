['pragma solidity ^0.4.24;\n', '\n', '// File: contracts/PeriodUtil.sol\n', '\n', '/**\n', ' * @title PeriodUtil\n', ' * \n', ' * Interface used for Period calculation to allow better automated testing of Fees Contract\n', ' *\n', ' * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.\n', ' */\n', 'contract PeriodUtil {\n', '    /**\n', '    * @dev calculates the Period index for the given timestamp\n', '    * @return Period count since EPOCH\n', '    * @param timestamp The time in seconds since EPOCH (blocktime)\n', '    */\n', '    function getPeriodIdx(uint256 timestamp) public pure returns (uint256);\n', '    \n', '    /**\n', '    * @dev Timestamp of the period start\n', '    * @return Time in seconds since EPOCH of the Period Start\n', '    * @param periodIdx Period Index to find the start timestamp of\n', '    */\n', '    function getPeriodStartTimestamp(uint256 periodIdx) public pure returns (uint256);\n', '\n', '    /**\n', '    * @dev Returns the Cycle count of the given Periods. A set of time creates a cycle, eg. If period is weeks the cycle can be years.\n', '    * @return The Cycle Index\n', '    * @param timestamp The time in seconds since EPOCH (blocktime)\n', '    */\n', '    function getPeriodCycle(uint256 timestamp) public pure returns (uint256);\n', '\n', '    /**\n', '    * @dev Amount of Tokens per time unit since the start of the given periodIdx\n', '    * @return Tokens per Time Unit from the given periodIdx start till now\n', '    * @param tokens Total amount of tokens from periodIdx start till now (blocktime)\n', '    * @param periodIdx Period IDX to use for time start\n', '    */\n', '    function getRatePerTimeUnits(uint256 tokens, uint256 periodIdx) public view returns (uint256);\n', '\n', '    /**\n', '    * @dev Amount of time units in each Period, for exampe if units is hour and period is week it will be 168\n', '    * @return Amount of time units per period\n', '    */\n', '    function getUnitsPerPeriod() public pure returns (uint256);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/ERC20Burnable.sol\n', '\n', '/**\n', ' * @title BurnableToken\n', ' * \n', ' * Interface for Basic ERC20 interactions and allowing burning  of tokens\n', ' *\n', ' * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.\n', ' */\n', 'contract ERC20Burnable is ERC20Basic {\n', '\n', '    function burn(uint256 _value) public;\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/ZCFees.sol\n', '\n', '/**\n', ' * @title ZCFees\n', ' * \n', ' * Used to process transaction\n', ' *\n', ' * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.\n', ' */\n', 'contract ZCFees {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    struct PaymentHistory {\n', '        // If set \n', '        bool paid;\n', '        // Payment to Fees\n', '        uint256 fees;\n', '        // Payment to Reward\n', '        uint256 reward;\n', '        // End of period token balance\n', '        uint256 endBalance;\n', '    }\n', '\n', '    mapping (uint256 => PaymentHistory) payments;\n', '    address public tokenAddress;\n', '    PeriodUtil public periodUtil;\n', '    // Last week that has been executed\n', '    uint256 public lastPeriodExecIdx;\n', '    // Last Year that has been processed\n', '    uint256 public lastPeriodCycleExecIdx;\n', '    // Amount of time in seconds grase processing time\n', '    uint256 grasePeriod;\n', '\n', '    // Wallet for Fees payments\n', '    address public feesWallet;\n', '    // Wallet for Reward payments\n', '    address public rewardWallet;\n', '    \n', '    // Fees 1 : % tokens taken per week\n', '    uint256 internal constant FEES1_PER = 10;\n', '    // Fees 1 : Max token payout per week\n', '    uint256 internal constant FEES1_MAX_AMOUNT = 400000 * (10**18);\n', '    // Fees 2 : % tokens taken per week\n', '    uint256 internal constant FEES2_PER = 10;\n', '    // Fees 2 : Max token payout per week\n', '    uint256 internal constant FEES2_MAX_AMOUNT = 800000 * (10**18);\n', '    // Min Amount of Fees to pay out per week\n', '    uint256 internal constant FEES_TOKEN_MIN_AMOUNT = 24000 * (10**18);\n', '    // Min Percentage Prev Week to pay out per week\n', '    uint256 internal constant FEES_TOKEN_MIN_PERPREV = 95;\n', '    // Rewards Percentage of Period Received\n', '    uint256 internal constant REWARD_PER = 70;\n', '    // % Amount of remaining tokens to burn at end of year\n', '    uint256 internal constant BURN_PER = 25;\n', '    \n', '    /**\n', '     * @param _tokenAdr The Address of the Token\n', '     * @param _periodUtilAdr The Address of the PeriodUtil\n', '     * @param _grasePeriod The time in seconds you allowed to process payments before avg is calculated into next period(s)\n', '     * @param _feesWallet Where the fees are sent in tokens\n', '     * @param _rewardWallet Where the rewards are sent in tokens\n', '     */\n', '    constructor (address _tokenAdr, address _periodUtilAdr, uint256 _grasePeriod, address _feesWallet, address _rewardWallet) public {\n', '        assert(_tokenAdr != address(0));\n', '        assert(_feesWallet != address(0));\n', '        assert(_rewardWallet != address(0));\n', '        assert(_periodUtilAdr != address(0));\n', '        tokenAddress = _tokenAdr;\n', '        feesWallet = _feesWallet;\n', '        rewardWallet = _rewardWallet;\n', '        periodUtil = PeriodUtil(_periodUtilAdr);\n', '\n', '        grasePeriod = _grasePeriod;\n', '        assert(grasePeriod > 0);\n', '        // GrasePeriod must be less than period\n', '        uint256 va1 = periodUtil.getPeriodStartTimestamp(1);\n', '        uint256 va2 = periodUtil.getPeriodStartTimestamp(0);\n', '        assert(grasePeriod < (va1 - va2));\n', '\n', '        // Set the previous period values;\n', '        lastPeriodExecIdx = getWeekIdx() - 1;\n', '        lastPeriodCycleExecIdx = getYearIdx();\n', '        PaymentHistory storage prevPayment = payments[lastPeriodExecIdx];\n', '        prevPayment.fees = 0;\n', '        prevPayment.reward = 0;\n', '        prevPayment.paid = true;\n', '        prevPayment.endBalance = 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Call when Fees processing needs to happen. Can only be called by the contract Owner\n', '     */\n', '    function process() public {\n', '        uint256 currPeriodIdx = getWeekIdx();\n', '\n', '        // Has the previous period been calculated?\n', '        if (lastPeriodExecIdx == (currPeriodIdx - 1)) {\n', '            // Nothing to do previous week has Already been processed\n', '            return;\n', '        }\n', '\n', '        if ((currPeriodIdx - lastPeriodExecIdx) == 2) {\n', '            paymentOnTime(currPeriodIdx);\n', '            // End Of Year Payment\n', '            if (lastPeriodCycleExecIdx < getYearIdx()) {\n', '                processEndOfYear(currPeriodIdx - 1);\n', '            }\n', '        }\n', '        else {\n', '            uint256 availableTokens = currentBalance();\n', '            // Missed Full Period! Very Bad!\n', '            PaymentHistory memory lastExecPeriod = payments[lastPeriodExecIdx];\n', '            uint256 tokensReceived = availableTokens.sub(lastExecPeriod.endBalance);\n', '            // Average amount of tokens received per hour till now\n', '            uint256 tokenHourlyRate = periodUtil.getRatePerTimeUnits(tokensReceived, lastPeriodExecIdx + 1);\n', '\n', '            PaymentHistory memory prePeriod;\n', '\n', '            for (uint256 calcPeriodIdx = lastPeriodExecIdx + 1; calcPeriodIdx < currPeriodIdx; calcPeriodIdx++) {\n', '                prePeriod = payments[calcPeriodIdx - 1];\n', '                uint256 periodTokenReceived = periodUtil.getUnitsPerPeriod().mul(tokenHourlyRate);\n', '                makePayments(prePeriod, payments[calcPeriodIdx], periodTokenReceived, prePeriod.endBalance.add(periodTokenReceived), calcPeriodIdx);\n', '\n', '                if (periodUtil.getPeriodCycle(periodUtil.getPeriodStartTimestamp(calcPeriodIdx + 1)) > lastPeriodCycleExecIdx) {\n', '                    processEndOfYear(calcPeriodIdx);\n', '                }\n', '            }\n', '        }\n', '\n', '        assert(payments[currPeriodIdx - 1].paid);\n', '        lastPeriodExecIdx = currPeriodIdx - 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to process end of year Clearance\n', '     * @param yearEndPeriodCycle The Last Period Idx (Week Idx) of the year\n', '     */\n', '    function processEndOfYear(uint256 yearEndPeriodCycle) internal {\n', '        PaymentHistory storage lastYearPeriod = payments[yearEndPeriodCycle];\n', '        uint256 availableTokens = currentBalance();\n', '        uint256 tokensToClear = min256(availableTokens,lastYearPeriod.endBalance);\n', '\n', '        // Burn some of tokens\n', '        uint256 tokensToBurn = tokensToClear.mul(BURN_PER).div(100);\n', '        ERC20Burnable(tokenAddress).burn(tokensToBurn);\n', '\n', '        assert(ERC20Burnable(tokenAddress).transfer(feesWallet, tokensToClear.sub(tokensToBurn)));\n', '        lastPeriodCycleExecIdx = lastPeriodCycleExecIdx + 1;\n', '        lastYearPeriod.endBalance = 0;\n', '\n', '        emit YearEndClearance(lastPeriodCycleExecIdx, tokensToClear);\n', '    }\n', '\n', '    /**\n', '     * @dev Called when Payments are call within a week of last payment\n', '     * @param currPeriodIdx Current Period Idx (Week)\n', '     */\n', '    function paymentOnTime(uint256 currPeriodIdx) internal {\n', '    \n', '        uint256 availableTokens = currentBalance();\n', '        PaymentHistory memory prePeriod = payments[currPeriodIdx - 2];\n', '\n', '        uint256 tokensRecvInPeriod = availableTokens.sub(prePeriod.endBalance);\n', '\n', '        if (tokensRecvInPeriod <= 0) {\n', '            tokensRecvInPeriod = 0;\n', '        }\n', '        else if ((now - periodUtil.getPeriodStartTimestamp(currPeriodIdx)) > grasePeriod) {\n', '            tokensRecvInPeriod = periodUtil.getRatePerTimeUnits(tokensRecvInPeriod, currPeriodIdx - 1).mul(periodUtil.getUnitsPerPeriod());\n', '            if (tokensRecvInPeriod <= 0) {\n', '                tokensRecvInPeriod = 0;\n', '            }\n', '            assert(availableTokens >= tokensRecvInPeriod);\n', '        }   \n', '\n', '        makePayments(prePeriod, payments[currPeriodIdx - 1], tokensRecvInPeriod, prePeriod.endBalance + tokensRecvInPeriod, currPeriodIdx - 1);\n', '    }\n', '\n', '    /**\n', '    * @dev Process a payment period\n', '    * @param prevPayment Previous periods payment records\n', '    * @param currPayment Current periods payment records to be updated\n', '    * @param tokensRaised Tokens received for the period\n', '    * @param availableTokens Contract available balance including the tokens received for the period\n', '    */\n', '    function makePayments(PaymentHistory memory prevPayment, PaymentHistory storage currPayment, uint256 tokensRaised, uint256 availableTokens, uint256 weekIdx) internal {\n', '\n', '        assert(prevPayment.paid);\n', '        assert(!currPayment.paid);\n', '        assert(availableTokens >= tokensRaised);\n', '\n', '        // Fees 1 Payment\n', '        uint256 fees1Pay = tokensRaised == 0 ? 0 : tokensRaised.mul(FEES1_PER).div(100);\n', '        if (fees1Pay >= FEES1_MAX_AMOUNT) {\n', '            fees1Pay = FEES1_MAX_AMOUNT;\n', '        }\n', '        // Fees 2 Payment\n', '        uint256 fees2Pay = tokensRaised == 0 ? 0 : tokensRaised.mul(FEES2_PER).div(100);\n', '        if (fees2Pay >= FEES2_MAX_AMOUNT) {\n', '            fees2Pay = FEES2_MAX_AMOUNT;\n', '        }\n', '\n', '        uint256 feesPay = fees1Pay.add(fees2Pay);\n', '        if (feesPay >= availableTokens) {\n', '            feesPay = availableTokens;\n', '        } else {\n', '            // Calculates the Min percentage of previous month to pay\n', '            uint256 prevFees95 = prevPayment.fees.mul(FEES_TOKEN_MIN_PERPREV).div(100);\n', '            // Minimum amount of fees that is required\n', '            uint256 minFeesPay = max256(FEES_TOKEN_MIN_AMOUNT, prevFees95);\n', '            feesPay = max256(feesPay, minFeesPay);\n', '            feesPay = min256(feesPay, availableTokens);\n', '        }\n', '\n', '        // Rewards Payout\n', '        uint256 rewardPay = 0;\n', '        if (feesPay < tokensRaised) {\n', '            // There is money left for reward pool\n', '            rewardPay = tokensRaised.mul(REWARD_PER).div(100);\n', '            rewardPay = min256(rewardPay, availableTokens.sub(feesPay));\n', '        }\n', '\n', '        currPayment.fees = feesPay;\n', '        currPayment.reward = rewardPay;\n', '\n', '        assert(ERC20Burnable(tokenAddress).transfer(rewardWallet, rewardPay));\n', '        assert(ERC20Burnable(tokenAddress).transfer(feesWallet, feesPay));\n', '\n', '        currPayment.endBalance = availableTokens - feesPay - rewardPay;\n', '        currPayment.paid = true;\n', '\n', '        emit Payment(weekIdx, rewardPay, feesPay);\n', '    }\n', '\n', '    /**\n', '    * @dev Event when payment was made\n', '    * @param weekIdx Week Idx since EPOCH for payment\n', '    * @param rewardPay Amount of tokens paid to the reward pool\n', '    * @param feesPay Amount of tokens paid in fees\n', '    */\n', '    event Payment(uint256 weekIdx, uint256 rewardPay, uint256 feesPay);\n', '\n', '    /**\n', '    * @dev Event when year end clearance happens\n', '    * @param yearIdx Year the clearance happend for\n', '    * @param feesPay Amount of tokens paid in fees\n', '    */\n', '    event YearEndClearance(uint256 yearIdx, uint256 feesPay);\n', '\n', '\n', '    /**\n', '    * @dev Returns the token balance of the Fees contract\n', '    */\n', '    function currentBalance() internal view returns (uint256) {\n', '        return ERC20Burnable(tokenAddress).balanceOf(address(this));\n', '    }\n', '\n', '    /**\n', '    * @dev Returns the amount of weeks since EPOCH\n', '    * @return Week count since EPOCH\n', '    */\n', '    function getWeekIdx() public view returns (uint256) {\n', '        return periodUtil.getPeriodIdx(now);\n', '    }\n', '\n', '    /**\n', '    * @dev Returns the Year\n', '    */\n', '    function getYearIdx() public view returns (uint256) {\n', '        return periodUtil.getPeriodCycle(now);\n', '    }\n', '\n', '    /**\n', '    * @dev Returns true if the week has been processed and paid out\n', '    * @param weekIdx Weeks since EPOCH\n', '    * @return true if week has been paid out\n', '    */\n', '    function weekProcessed(uint256 weekIdx) public view returns (bool) {\n', '        return payments[weekIdx].paid;\n', '    }\n', '\n', '    /**\n', '    * @dev Returns the amounts paid out for the given week\n', '    * @param weekIdx Weeks since EPOCH\n', '    */\n', '    function paymentForWeek(uint256 weekIdx) public view returns (uint256 fees, uint256 reward) {\n', '        PaymentHistory storage history = payments[weekIdx];\n', '        fees = history.fees;\n', '        reward = history.reward;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}']