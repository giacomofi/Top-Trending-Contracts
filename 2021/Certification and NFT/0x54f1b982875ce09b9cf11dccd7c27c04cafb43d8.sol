['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-04\n', '*/\n', '\n', 'pragma solidity 0.6.7;\n', '\n', 'abstract contract DSValueLike {\n', '    function getResultWithValidity() virtual external view returns (uint256, bool);\n', '}\n', 'abstract contract FSMWrapperLike {\n', '    function renumerateCaller(address) virtual external;\n', '}\n', '\n', 'contract OSM {\n', '    // --- Auth ---\n', '    mapping (address => uint) public authorizedAccounts;\n', '    /**\n', '     * @notice Add auth to an account\n', '     * @param account Account to add auth to\n', '     */\n', '    function addAuthorization(address account) virtual external isAuthorized {\n', '        authorizedAccounts[account] = 1;\n', '        emit AddAuthorization(account);\n', '    }\n', '    /**\n', '     * @notice Remove auth from an account\n', '     * @param account Account to remove auth from\n', '     */\n', '    function removeAuthorization(address account) virtual external isAuthorized {\n', '        authorizedAccounts[account] = 0;\n', '        emit RemoveAuthorization(account);\n', '    }\n', '    /**\n', '    * @notice Checks whether msg.sender can call an authed function\n', '    **/\n', '    modifier isAuthorized {\n', '        require(authorizedAccounts[msg.sender] == 1, "OSM/account-not-authorized");\n', '        _;\n', '    }\n', '\n', '    // --- Stop ---\n', '    uint256 public stopped;\n', '    modifier stoppable { require(stopped == 0, "OSM/is-stopped"); _; }\n', '\n', '    // --- Variables ---\n', '    address public priceSource;\n', '    uint16  constant ONE_HOUR = uint16(3600);\n', '    uint16  public updateDelay = ONE_HOUR;\n', '    uint64  public lastUpdateTime;\n', '\n', '    // --- Structs ---\n', '    struct Feed {\n', '        uint128 value;\n', '        uint128 isValid;\n', '    }\n', '\n', '    Feed currentFeed;\n', '    Feed nextFeed;\n', '\n', '    // --- Events ---\n', '    event AddAuthorization(address account);\n', '    event RemoveAuthorization(address account);\n', '    event ModifyParameters(bytes32 parameter, uint256 val);\n', '    event ModifyParameters(bytes32 parameter, address val);\n', '    event Start();\n', '    event Stop();\n', '    event ChangePriceSource(address priceSource);\n', '    event ChangeDelay(uint16 delay);\n', '    event RestartValue();\n', '    event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);\n', '\n', '    constructor (address priceSource_) public {\n', '        authorizedAccounts[msg.sender] = 1;\n', '        priceSource = priceSource_;\n', '        if (priceSource != address(0)) {\n', '          (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();\n', '          if (hasValidValue) {\n', '            nextFeed = Feed(uint128(uint(priceFeedValue)), 1);\n', '            currentFeed = nextFeed;\n', '            lastUpdateTime = latestUpdateTime(currentTime());\n', '            emit UpdateResult(uint(currentFeed.value), lastUpdateTime);\n', '          }\n', '        }\n', '        emit AddAuthorization(msg.sender);\n', '        emit ChangePriceSource(priceSource);\n', '    }\n', '\n', '    // --- Math ---\n', '    function addition(uint64 x, uint64 y) internal pure returns (uint64 z) {\n', '        z = x + y;\n', '        require(z >= x);\n', '    }\n', '\n', '    // --- Core Logic ---\n', '    /*\n', '    * @notify Stop the OSM\n', '    */\n', '    function stop() external isAuthorized {\n', '        stopped = 1;\n', '        emit Stop();\n', '    }\n', '    /*\n', '    * @notify Start the OSM\n', '    */\n', '    function start() external isAuthorized {\n', '        stopped = 0;\n', '        emit Start();\n', '    }\n', '\n', '    /*\n', '    * @notify Change the oracle from which the OSM reads\n', '    * @param priceSource_ The address of the oracle from which the OSM reads\n', '    */\n', '    function changePriceSource(address priceSource_) external isAuthorized {\n', '        priceSource = priceSource_;\n', '        emit ChangePriceSource(priceSource);\n', '    }\n', '\n', '    /*\n', '    * @notify Helper that returns the current block timestamp\n', '    */\n', '    function currentTime() internal view returns (uint) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    /*\n', '    * @notify Return the latest update time\n', '    * @param timestamp Custom reference timestamp to determine the latest update time from\n', '    */\n', '    function latestUpdateTime(uint timestamp) internal view returns (uint64) {\n', '        require(updateDelay != 0, "OSM/update-delay-is-zero");\n', '        return uint64(timestamp - (timestamp % updateDelay));\n', '    }\n', '\n', '    /*\n', '    * @notify Change the delay between updates\n', '    * @param delay The new delay\n', '    */\n', '    function changeDelay(uint16 delay) external isAuthorized {\n', '        require(delay > 0, "OSM/delay-is-zero");\n', '        updateDelay = delay;\n', '        emit ChangeDelay(updateDelay);\n', '    }\n', '\n', '    /*\n', '    * @notify Restart/set to zero the feeds stored in the OSM\n', '    */\n', '    function restartValue() external isAuthorized {\n', '        currentFeed = nextFeed = Feed(0, 0);\n', '        stopped = 1;\n', '        emit RestartValue();\n', '    }\n', '\n', '    /*\n', '    * @notify View function that returns whether the delay between calls has been passed\n', '    */\n', '    function passedDelay() public view returns (bool ok) {\n', '        return currentTime() >= uint(addition(lastUpdateTime, uint64(updateDelay)));\n', '    }\n', '\n', '    /*\n', '    * @notify Update the price feeds inside the OSM\n', '    */\n', '    function updateResult() virtual external stoppable {\n', '        // Check if the delay passed\n', '        require(passedDelay(), "OSM/not-passed");\n', '        // Read the price from the median\n', '        (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();\n', '        // If the value is valid, update storage\n', '        if (hasValidValue) {\n', '            // Update state\n', '            currentFeed    = nextFeed;\n', '            nextFeed       = Feed(uint128(uint(priceFeedValue)), 1);\n', '            lastUpdateTime = latestUpdateTime(currentTime());\n', '            // Emit event\n', '            emit UpdateResult(uint(currentFeed.value), lastUpdateTime);\n', '        }\n', '    }\n', '\n', '    // --- Getters ---\n', '    /*\n', '    * @notify Internal helper that reads a price and its validity from the priceSource\n', '    */\n', '    function getPriceSourceUpdate() internal view returns (uint256, bool) {\n', '        try DSValueLike(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {\n', '          return (priceFeedValue, hasValidValue);\n', '        }\n', '        catch(bytes memory) {\n', '          return (0, false);\n', '        }\n', '    }\n', '    /*\n', '    * @notify Return the current feed value and its validity\n', '    */\n', '    function getResultWithValidity() external view returns (uint256,bool) {\n', '        return (uint(currentFeed.value), currentFeed.isValid == 1);\n', '    }\n', '    /*\n', "    * @notify Return the next feed's value and its validity\n", '    */\n', '    function getNextResultWithValidity() external view returns (uint256,bool) {\n', '        return (nextFeed.value, nextFeed.isValid == 1);\n', '    }\n', '    /*\n', "    * @notify Return the current feed's value only if it's valid, otherwise revert\n", '    */\n', '    function read() external view returns (uint256) {\n', '        require(currentFeed.isValid == 1, "OSM/no-current-value");\n', '        return currentFeed.value;\n', '    }\n', '}\n', '\n', 'contract ExternallyFundedOSM is OSM {\n', '    // --- Variables ---\n', '    FSMWrapperLike public fsmWrapper;\n', '\n', '    // --- Evemts ---\n', '    event FailRenumerateCaller(address wrapper, address caller);\n', '\n', '    constructor (address priceSource_) public OSM(priceSource_) {}\n', '\n', '    // --- Administration ---\n', '    /*\n', '    * @notify Modify an address parameter\n', '    * @param parameter The parameter name\n', '    * @param val The new value for the parameter\n', '    */\n', '    function modifyParameters(bytes32 parameter, address val) external isAuthorized {\n', '        if (parameter == "fsmWrapper") {\n', '          require(val != address(0), "ExternallyFundedOSM/invalid-fsm-wrapper");\n', '          fsmWrapper = FSMWrapperLike(val);\n', '        }\n', '        else revert("ExternallyFundedOSM/modify-unrecognized-param");\n', '        emit ModifyParameters(parameter, val);\n', '    }\n', '\n', '    /*\n', '    * @notify Update the price feeds inside the OSM\n', '    */\n', '    function updateResult() override external stoppable {\n', '        // Check if the delay passed\n', '        require(passedDelay(), "ExternallyFundedOSM/not-passed");\n', '        // Check that the wrapper is set\n', '        require(address(fsmWrapper) != address(0), "ExternallyFundedOSM/null-wrapper");\n', '        // Read the price from the median\n', '        (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();\n', '        // If the value is valid, update storage\n', '        if (hasValidValue) {\n', '            // Update state\n', '            currentFeed    = nextFeed;\n', '            nextFeed       = Feed(uint128(uint(priceFeedValue)), 1);\n', '            lastUpdateTime = latestUpdateTime(currentTime());\n', '            // Emit event\n', '            emit UpdateResult(uint(currentFeed.value), lastUpdateTime);\n', '            // Pay the caller\n', '            try fsmWrapper.renumerateCaller(msg.sender) {}\n', '            catch(bytes memory revertReason) {\n', '              emit FailRenumerateCaller(address(fsmWrapper), msg.sender);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract GebMath {\n', '    uint256 public constant RAY = 10 ** 27;\n', '    uint256 public constant WAD = 10 ** 18;\n', '\n', '    function ray(uint x) public pure returns (uint z) {\n', '        z = multiply(x, 10 ** 9);\n', '    }\n', '    function rad(uint x) public pure returns (uint z) {\n', '        z = multiply(x, 10 ** 27);\n', '    }\n', '    function minimum(uint x, uint y) public pure returns (uint z) {\n', '        z = (x <= y) ? x : y;\n', '    }\n', '    function addition(uint x, uint y) public pure returns (uint z) {\n', '        z = x + y;\n', '        require(z >= x, "uint-uint-add-overflow");\n', '    }\n', '    function subtract(uint x, uint y) public pure returns (uint z) {\n', '        z = x - y;\n', '        require(z <= x, "uint-uint-sub-underflow");\n', '    }\n', '    function multiply(uint x, uint y) public pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");\n', '    }\n', '    function rmultiply(uint x, uint y) public pure returns (uint z) {\n', '        z = multiply(x, y) / RAY;\n', '    }\n', '    function rdivide(uint x, uint y) public pure returns (uint z) {\n', '        z = multiply(x, RAY) / y;\n', '    }\n', '    function wdivide(uint x, uint y) public pure returns (uint z) {\n', '        z = multiply(x, WAD) / y;\n', '    }\n', '    function wmultiply(uint x, uint y) public pure returns (uint z) {\n', '        z = multiply(x, y) / WAD;\n', '    }\n', '    function rpower(uint x, uint n, uint base) public pure returns (uint z) {\n', '        assembly {\n', '            switch x case 0 {switch n case 0 {z := base} default {z := 0}}\n', '            default {\n', '                switch mod(n, 2) case 0 { z := base } default { z := x }\n', '                let half := div(base, 2)  // for rounding.\n', '                for { n := div(n, 2) } n { n := div(n,2) } {\n', '                    let xx := mul(x, x)\n', '                    if iszero(eq(div(xx, x), x)) { revert(0,0) }\n', '                    let xxRound := add(xx, half)\n', '                    if lt(xxRound, xx) { revert(0,0) }\n', '                    x := div(xxRound, base)\n', '                    if mod(n,2) {\n', '                        let zx := mul(z, x)\n', '                        if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }\n', '                        let zxRound := add(zx, half)\n', '                        if lt(zxRound, zx) { revert(0,0) }\n', '                        z := div(zxRound, base)\n', '                    }\n', '                }\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'abstract contract StabilityFeeTreasuryLike {\n', '    function getAllowance(address) virtual external view returns (uint, uint);\n', '    function systemCoin() virtual external view returns (address);\n', '    function pullFunds(address, address, uint) virtual external;\n', '    function setTotalAllowance(address, uint256) external virtual;\n', '    function setPerBlockAllowance(address, uint256) external virtual;\n', '}\n', '\n', 'contract NoSetupIncreasingTreasuryReimbursement is GebMath {\n', '    // --- Auth ---\n', '    mapping (address => uint) public authorizedAccounts;\n', '    /**\n', '     * @notice Add auth to an account\n', '     * @param account Account to add auth to\n', '     */\n', '    function addAuthorization(address account) virtual external isAuthorized {\n', '        authorizedAccounts[account] = 1;\n', '        emit AddAuthorization(account);\n', '    }\n', '    /**\n', '     * @notice Remove auth from an account\n', '     * @param account Account to remove auth from\n', '     */\n', '    function removeAuthorization(address account) virtual external isAuthorized {\n', '        authorizedAccounts[account] = 0;\n', '        emit RemoveAuthorization(account);\n', '    }\n', '    /**\n', '    * @notice Checks whether msg.sender can call an authed function\n', '    **/\n', '    modifier isAuthorized {\n', '        require(authorizedAccounts[msg.sender] == 1, "NoSetupIncreasingTreasuryReimbursement/account-not-authorized");\n', '        _;\n', '    }\n', '\n', '    // --- Variables ---\n', '    // Starting reward for the fee receiver/keeper\n', '    uint256 public baseUpdateCallerReward;          // [wad]\n', '    // Max possible reward for the fee receiver/keeper\n', '    uint256 public maxUpdateCallerReward;           // [wad]\n', '    // Max delay taken into consideration when calculating the adjusted reward\n', '    uint256 public maxRewardIncreaseDelay;          // [seconds]\n', '    // Rate applied to baseUpdateCallerReward every extra second passed beyond a certain point (e.g next time when a specific function needs to be called)\n', '    uint256 public perSecondCallerRewardIncrease;   // [ray]\n', '\n', '    // SF treasury\n', '    StabilityFeeTreasuryLike  public treasury;\n', '\n', '    // --- Events ---\n', '    event AddAuthorization(address account);\n', '    event RemoveAuthorization(address account);\n', '    event ModifyParameters(\n', '      bytes32 parameter,\n', '      address addr\n', '    );\n', '    event ModifyParameters(\n', '      bytes32 parameter,\n', '      uint256 val\n', '    );\n', '    event FailRewardCaller(bytes revertReason, address feeReceiver, uint256 amount);\n', '\n', '    constructor() public {\n', '        authorizedAccounts[msg.sender] = 1;\n', '        maxRewardIncreaseDelay         = uint(-1);\n', '\n', '        emit AddAuthorization(msg.sender);\n', '    }\n', '\n', '    // --- Boolean Logic ---\n', '    function either(bool x, bool y) internal pure returns (bool z) {\n', '        assembly{ z := or(x, y)}\n', '    }\n', '    function both(bool x, bool y) internal pure returns (bool z) {\n', '        assembly{ z := and(x, y)}\n', '    }\n', '\n', '    // --- Treasury ---\n', '    /**\n', '    * @notice This returns the stability fee treasury allowance for this contract by taking the minimum between the per block and the total allowances\n', '    **/\n', '    function treasuryAllowance() public view returns (uint256) {\n', '        (uint total, uint perBlock) = treasury.getAllowance(address(this));\n', '        return minimum(total, perBlock);\n', '    }\n', '    /*\n', '    * @notice Get the SF reward that can be sent to a function caller right now\n', '    * @param timeOfLastUpdate The last time when the function that the treasury pays for has been updated\n', '    * @param defaultDelayBetweenCalls Enforced delay between calls to the function for which the treasury reimburses callers\n', '    */\n', '    function getCallerReward(uint256 timeOfLastUpdate, uint256 defaultDelayBetweenCalls) public view returns (uint256) {\n', '        // If the rewards are null or if the time of the last update is in the future or present, return 0\n', '        bool nullRewards = (baseUpdateCallerReward == 0 && maxUpdateCallerReward == 0);\n', '        if (either(timeOfLastUpdate >= now, nullRewards)) return 0;\n', '\n', '        // If the time elapsed is smaller than defaultDelayBetweenCalls or if the base reward is zero, return 0\n', '        uint256 timeElapsed = (timeOfLastUpdate == 0) ? defaultDelayBetweenCalls : subtract(now, timeOfLastUpdate);\n', '        if (either(timeElapsed < defaultDelayBetweenCalls, baseUpdateCallerReward == 0)) {\n', '            return 0;\n', '        }\n', '\n', '        // If too much time elapsed, return the max reward\n', '        uint256 adjustedTime      = subtract(timeElapsed, defaultDelayBetweenCalls);\n', '        uint256 maxPossibleReward = minimum(maxUpdateCallerReward, treasuryAllowance() / RAY);\n', '        if (adjustedTime > maxRewardIncreaseDelay) {\n', '            return maxPossibleReward;\n', '        }\n', '\n', '        // Calculate the reward\n', '        uint256 calculatedReward = baseUpdateCallerReward;\n', '        if (adjustedTime > 0) {\n', '            calculatedReward = rmultiply(rpower(perSecondCallerRewardIncrease, adjustedTime, RAY), calculatedReward);\n', '        }\n', '\n', '        // If the reward is higher than max, set it to max\n', '        if (calculatedReward > maxPossibleReward) {\n', '            calculatedReward = maxPossibleReward;\n', '        }\n', '        return calculatedReward;\n', '    }\n', '    /**\n', '    * @notice Send a stability fee reward to an address\n', '    * @param proposedFeeReceiver The SF receiver\n', '    * @param reward The system coin amount to send\n', '    **/\n', '    function rewardCaller(address proposedFeeReceiver, uint256 reward) internal {\n', '        // If the receiver is the treasury itself or if the treasury is null or if the reward is zero, return\n', '        if (address(treasury) == proposedFeeReceiver) return;\n', '        if (either(address(treasury) == address(0), reward == 0)) return;\n', '\n', '        // Determine the actual receiver and send funds\n', '        address finalFeeReceiver = (proposedFeeReceiver == address(0)) ? msg.sender : proposedFeeReceiver;\n', '        try treasury.pullFunds(finalFeeReceiver, treasury.systemCoin(), reward) {}\n', '        catch(bytes memory revertReason) {\n', '            emit FailRewardCaller(revertReason, finalFeeReceiver, reward);\n', '        }\n', '    }\n', '}\n', '\n', 'abstract contract FSMLike {\n', '    function stopped() virtual public view returns (uint256);\n', '    function priceSource() virtual public view returns (address);\n', '    function updateDelay() virtual public view returns (uint16);\n', '    function lastUpdateTime() virtual public view returns (uint64);\n', '    function newPriceDeviation() virtual public view returns (uint256);\n', '    function passedDelay() virtual public view returns (bool);\n', '    function getNextBoundedPrice() virtual public view returns (uint128);\n', '    function getNextPriceLowerBound() virtual public view returns (uint128);\n', '    function getNextPriceUpperBound() virtual public view returns (uint128);\n', '    function getResultWithValidity() virtual external view returns (uint256, bool);\n', '    function getNextResultWithValidity() virtual external view returns (uint256, bool);\n', '    function read() virtual external view returns (uint256);\n', '}\n', '\n', 'contract FSMWrapper is NoSetupIncreasingTreasuryReimbursement {\n', '    // --- Vars ---\n', '    // When the rate has last been relayed\n', '    uint256 public lastReimburseTime;       // [timestamp]\n', '    // Enforced gap between reimbursements\n', '    uint256 public reimburseDelay;          // [seconds]\n', '\n', '    FSMLike public fsm;\n', '\n', '    constructor(address fsm_, uint256 reimburseDelay_) public NoSetupIncreasingTreasuryReimbursement() {\n', '        require(fsm_ != address(0), "FSMWrapper/null-fsm");\n', '\n', '        fsm            = FSMLike(fsm_);\n', '        reimburseDelay = reimburseDelay_;\n', '\n', '        emit ModifyParameters("reimburseDelay", reimburseDelay);\n', '    }\n', '\n', '    // --- Administration ---\n', '    /*\n', '    * @notice Change the addresses of contracts that this wrapper is connected to\n', '    * @param parameter The contract whose address is changed\n', '    * @param addr The new contract address\n', '    */\n', '    function modifyParameters(bytes32 parameter, address addr) external isAuthorized {\n', '        require(addr != address(0), "FSMWrapper/null-addr");\n', '        if (parameter == "fsm") {\n', '          fsm = FSMLike(addr);\n', '        }\n', '        else if (parameter == "treasury") {\n', '          require(StabilityFeeTreasuryLike(addr).systemCoin() != address(0), "FSMWrapper/treasury-coin-not-set");\n', '          treasury = StabilityFeeTreasuryLike(addr);\n', '        }\n', '        else revert("FSMWrapper/modify-unrecognized-param");\n', '        emit ModifyParameters(\n', '          parameter,\n', '          addr\n', '        );\n', '    }\n', '    /*\n', '    * @notify Modify a uint256 parameter\n', '    * @param parameter The parameter name\n', '    * @param val The new parameter value\n', '    */\n', '    function modifyParameters(bytes32 parameter, uint256 val) external isAuthorized {\n', '        if (parameter == "baseUpdateCallerReward") {\n', '          require(val <= maxUpdateCallerReward, "FSMWrapper/invalid-base-caller-reward");\n', '          baseUpdateCallerReward = val;\n', '        }\n', '        else if (parameter == "maxUpdateCallerReward") {\n', '          require(val >= baseUpdateCallerReward, "FSMWrapper/invalid-max-caller-reward");\n', '          maxUpdateCallerReward = val;\n', '        }\n', '        else if (parameter == "perSecondCallerRewardIncrease") {\n', '          require(val >= RAY, "FSMWrapper/invalid-caller-reward-increase");\n', '          perSecondCallerRewardIncrease = val;\n', '        }\n', '        else if (parameter == "maxRewardIncreaseDelay") {\n', '          require(val > 0, "FSMWrapper/invalid-max-increase-delay");\n', '          maxRewardIncreaseDelay = val;\n', '        }\n', '        else if (parameter == "reimburseDelay") {\n', '          reimburseDelay = val;\n', '        }\n', '        else revert("FSMWrapper/modify-unrecognized-param");\n', '        emit ModifyParameters(\n', '          parameter,\n', '          val\n', '        );\n', '    }\n', '\n', '    // --- Renumeration Logic ---\n', '    /*\n', '    * @notice Renumerate the caller that updates the connected FSM\n', '    * @param feeReceiver The address that will receive the reward for the update\n', '    */\n', '    function renumerateCaller(address feeReceiver) external {\n', '        // Perform checks\n', '        require(address(fsm) == msg.sender, "FSMWrapper/invalid-caller");\n', '        require(feeReceiver != address(0), "FSMWrapper/null-fee-receiver");\n', '        // Check delay between calls\n', '        require(either(subtract(now, lastReimburseTime) >= reimburseDelay, lastReimburseTime == 0), "FSMWrapper/wait-more");\n', "        // Get the caller's reward\n", '        uint256 callerReward = getCallerReward(lastReimburseTime, reimburseDelay);\n', '        // Store the timestamp of the update\n', '        lastReimburseTime = now;\n', '        // Pay the caller for updating the FSM\n', '        rewardCaller(feeReceiver, callerReward);\n', '    }\n', '\n', '    // --- Wrapped Functionality ---\n', '    /*\n', '    * @notify Return whether the FSM is stopped\n', '    */\n', '    function stopped() public view returns (uint256) {\n', '        return fsm.stopped();\n', '    }\n', '    /*\n', '    * @notify Return the FSM price source\n', '    */\n', '    function priceSource() public view returns (address) {\n', '        return fsm.priceSource();\n', '    }\n', '    /*\n', '    * @notify Return the FSM update delay\n', '    */\n', '    function updateDelay() public view returns (uint16) {\n', '        return fsm.updateDelay();\n', '    }\n', '    /*\n', '    * @notify Return the FSM last update time\n', '    */\n', '    function lastUpdateTime() public view returns (uint64) {\n', '        return fsm.lastUpdateTime();\n', '    }\n', '    /*\n', "    * @notify Return the FSM's next price deviation\n", '    */\n', '    function newPriceDeviation() public view returns (uint256) {\n', '        return fsm.newPriceDeviation();\n', '    }\n', '    /*\n', '    * @notify Return whether the update delay has been passed in the FSM\n', '    */\n', '    function passedDelay() public view returns (bool) {\n', '        return fsm.passedDelay();\n', '    }\n', '    /*\n', '    * @notify Return the next bounded price from the FSM\n', '    */\n', '    function getNextBoundedPrice() public view returns (uint128) {\n', '        return fsm.getNextBoundedPrice();\n', '    }\n', '    /*\n', '    * @notify Return the next lower bound price from the FSM\n', '    */\n', '    function getNextPriceLowerBound() public view returns (uint128) {\n', '        return fsm.getNextPriceLowerBound();\n', '    }\n', '    /*\n', '    * @notify Return the next upper bound price from the FSM\n', '    */\n', '    function getNextPriceUpperBound() public view returns (uint128) {\n', '        return fsm.getNextPriceUpperBound();\n', '    }\n', '    /*\n', '    * @notify Return the result with its validity from the FSM\n', '    */\n', '    function getResultWithValidity() external view returns (uint256, bool) {\n', '        (uint256 price, bool valid) = fsm.getResultWithValidity();\n', '        return (price, valid);\n', '    }\n', '    /*\n', '    * @notify Return the next result with its validity from the FSM\n', '    */\n', '    function getNextResultWithValidity() external view returns (uint256, bool) {\n', '        (uint256 price, bool valid) = fsm.getNextResultWithValidity();\n', '        return (price, valid);\n', '    }\n', '    /*\n', "    * @notify Return the result from the FSM if it's valid\n", '    */\n', '    function read() external view returns (uint256) {\n', '        return fsm.read();\n', '    }\n', '}\n', '\n', '\n', 'abstract contract LiquidationEngineLike {\n', '    function addAuthorization(address) external virtual;\n', '}\n', '\n', 'abstract contract FsmGovernanceInterfaceLike {\n', '    function setFsm(bytes32, address) external virtual;\n', '}\n', '\n', 'abstract contract OracleRelayerLike {\n', '    function modifyParameters(bytes32, bytes32, address) external virtual;\n', '}\n', '\n', '// @notice Proposal to deploy and setup new OSM and wrapper\n', '// Missing steps:\n', '// - Change orcl for the targeted collateral in the OracleRelayer\n', "// - Change collateralFSM in the collateral's auction house\n", 'contract DeployOSMandWrapper {\n', '    // --- Variables ---\n', '    uint256 public constant RAY = 10**27;\n', '\n', '    function execute(address _treasury, address ethMedianizer, address fsmGovernanceInterface) public returns (address) {\n', '        // Define params (kovan 1.3)\n', '        StabilityFeeTreasuryLike treasury     = StabilityFeeTreasuryLike(_treasury);\n', '        bytes32 collateralType                = bytes32("ETH-A");\n', '        uint256 reimburseDelay                = 3600;\n', '        uint256 maxRewardIncreaseDelay        = 10800;\n', '        uint256 baseUpdateCallerReward        = 0.0001 ether;\n', '        uint256 maxUpdateCallerReward         = 0.0001 ether;\n', '        uint256 perSecondCallerRewardIncrease = 1 * RAY;\n', '\n', '        // deploy new OSM\n', '        ExternallyFundedOSM osm = new ExternallyFundedOSM(ethMedianizer);\n', '\n', '        // deploy OSM Wrapper\n', '        FSMWrapper osmWrapper = new FSMWrapper(\n', '            address(osm),\n', '            reimburseDelay\n', '        );\n', '\n', '        // set the wrapper on the OSM\n', '        osm.modifyParameters("fsmWrapper", address(osmWrapper));\n', '\n', '        FsmGovernanceInterfaceLike(fsmGovernanceInterface).setFsm(collateralType, address(osmWrapper));\n', '\n', '        // Setup treasury allowance\n', '        treasury.setTotalAllowance(address(osmWrapper), uint(-1));\n', '        treasury.setPerBlockAllowance(address(osmWrapper), 0.0001 ether * RAY);\n', '\n', '        // Set the remaining params\n', '        osmWrapper.modifyParameters("treasury", address(treasury));\n', '        osmWrapper.modifyParameters("maxUpdateCallerReward", maxUpdateCallerReward);\n', '        osmWrapper.modifyParameters("baseUpdateCallerReward", baseUpdateCallerReward);\n', '        osmWrapper.modifyParameters("perSecondCallerRewardIncrease", perSecondCallerRewardIncrease);\n', '        osmWrapper.modifyParameters("maxRewardIncreaseDelay", maxRewardIncreaseDelay);\n', '\n', '        return address(osm);\n', '    }\n', '}']