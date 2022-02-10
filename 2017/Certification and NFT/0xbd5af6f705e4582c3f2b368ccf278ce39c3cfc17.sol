['pragma solidity ^0.4.11;\n', '\n', 'contract FlightDelayControllerInterface {\n', '\n', '    function isOwner(address _addr) returns (bool _isOwner);\n', '\n', '    function selfRegister(bytes32 _id) returns (bool result);\n', '\n', '    function getContract(bytes32 _id) returns (address _addr);\n', '}\n', '\n', 'contract FlightDelayDatabaseModel {\n', '\n', '    // Ledger accounts.\n', '    enum Acc {\n', '        Premium,      // 0\n', '        RiskFund,     // 1\n', '        Payout,       // 2\n', '        Balance,      // 3\n', '        Reward,       // 4\n', '        OraclizeCosts // 5\n', '    }\n', '\n', '    // policy Status Codes and meaning:\n', '    //\n', '    // 00 = Applied:\t  the customer has payed a premium, but the oracle has\n', '    //\t\t\t\t\t        not yet checked and confirmed.\n', '    //\t\t\t\t\t        The customer can still revoke the policy.\n', '    // 01 = Accepted:\t  the oracle has checked and confirmed.\n', '    //\t\t\t\t\t        The customer can still revoke the policy.\n', '    // 02 = Revoked:\t  The customer has revoked the policy.\n', '    //\t\t\t\t\t        The premium minus cancellation fee is payed back to the\n', '    //\t\t\t\t\t        customer by the oracle.\n', '    // 03 = PaidOut:\t  The flight has ended with delay.\n', '    //\t\t\t\t\t        The oracle has checked and payed out.\n', '    // 04 = Expired:\t  The flight has endet with <15min. delay.\n', '    //\t\t\t\t\t        No payout.\n', '    // 05 = Declined:\t  The application was invalid.\n', '    //\t\t\t\t\t        The premium minus cancellation fee is payed back to the\n', '    //\t\t\t\t\t        customer by the oracle.\n', '    // 06 = SendFailed:\tDuring Revoke, Decline or Payout, sending ether failed\n', '    //\t\t\t\t\t        for unknown reasons.\n', '    //\t\t\t\t\t        The funds remain in the contracts RiskFund.\n', '\n', '\n', '    //                   00       01        02       03        04      05           06\n', '    enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }\n', '\n', '    // oraclize callback types:\n', '    enum oraclizeState { ForUnderwriting, ForPayout }\n', '\n', '    //               00   01   02   03\n', '    enum Currency { ETH, EUR, USD, GBP }\n', '\n', '    // the policy structure: this structure keeps track of the individual parameters of a policy.\n', '    // typically customer address, premium and some status information.\n', '    struct Policy {\n', '        // 0 - the customer\n', '        address customer;\n', '\n', '        // 1 - premium\n', '        uint premium;\n', '        // risk specific parameters:\n', '        // 2 - pointer to the risk in the risks mapping\n', '        bytes32 riskId;\n', '        // custom payout pattern\n', '        // in future versions, customer will be able to tamper with this array.\n', '        // to keep things simple, we have decided to hard-code the array for all policies.\n', '        // uint8[5] pattern;\n', '        // 3 - probability weight. this is the central parameter\n', '        uint weight;\n', '        // 4 - calculated Payout\n', '        uint calculatedPayout;\n', '        // 5 - actual Payout\n', '        uint actualPayout;\n', '\n', '        // status fields:\n', '        // 6 - the state of the policy\n', '        policyState state;\n', '        // 7 - time of last state change\n', '        uint stateTime;\n', '        // 8 - state change message/reason\n', '        bytes32 stateMessage;\n', '        // 9 - TLSNotary Proof\n', '        bytes proof;\n', '        // 10 - Currency\n', '        Currency currency;\n', '        // 10 - External customer id\n', '        bytes32 customerExternalId;\n', '    }\n', '\n', '    // the risk structure; this structure keeps track of the risk-\n', '    // specific parameters.\n', '    // several policies can share the same risk structure (typically\n', '    // some people flying with the same plane)\n', '    struct Risk {\n', '        // 0 - Airline Code + FlightNumber\n', '        bytes32 carrierFlightNumber;\n', '        // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD\n', '        bytes32 departureYearMonthDay;\n', '        // 2 - the inital arrival time\n', '        uint arrivalTime;\n', '        // 3 - the final delay in minutes\n', '        uint delayInMinutes;\n', '        // 4 - the determined delay category (0-5)\n', '        uint8 delay;\n', '        // 5 - we limit the cumulated weighted premium to avoid cluster risks\n', '        uint cumulatedWeightedPremium;\n', '        // 6 - max cumulated Payout for this risk\n', '        uint premiumMultiplier;\n', '    }\n', '\n', '    // the oraclize callback structure: we use several oraclize calls.\n', '    // all oraclize calls will result in a common callback to __callback(...).\n', '    // to keep track of the different querys we have to introduce this struct.\n', '    struct OraclizeCallback {\n', '        // for which policy have we called?\n', '        uint policyId;\n', '        // for which purpose did we call? {ForUnderwrite | ForPayout}\n', '        oraclizeState oState;\n', '        // time\n', '        uint oraclizeTime;\n', '    }\n', '\n', '    struct Customer {\n', '        bytes32 customerExternalId;\n', '        bool identityConfirmed;\n', '    }\n', '}\n', '\n', 'contract FlightDelayControlledContract is FlightDelayDatabaseModel {\n', '\n', '    address public controller;\n', '    FlightDelayControllerInterface FD_CI;\n', '\n', '    modifier onlyController() {\n', '        require(msg.sender == controller);\n', '        _;\n', '    }\n', '\n', '    function setController(address _controller) internal returns (bool _result) {\n', '        controller = _controller;\n', '        FD_CI = FlightDelayControllerInterface(_controller);\n', '        _result = true;\n', '    }\n', '\n', '    function destruct() onlyController {\n', '        selfdestruct(controller);\n', '    }\n', '\n', '    function setContracts() onlyController {}\n', '\n', '    function getContract(bytes32 _id) internal returns (address _addr) {\n', '        _addr = FD_CI.getContract(_id);\n', '    }\n', '}\n', '\n', 'contract FlightDelayAccessControllerInterface {\n', '\n', '    function setPermissionById(uint8 _perm, bytes32 _id);\n', '\n', '    function setPermissionById(uint8 _perm, bytes32 _id, bool _access);\n', '\n', '    function setPermissionByAddress(uint8 _perm, address _addr);\n', '\n', '    function setPermissionByAddress(uint8 _perm, address _addr, bool _access);\n', '\n', '    function checkPermission(uint8 _perm, address _addr) returns (bool _success);\n', '}\n', '\n', 'contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {\n', '\n', '    function setAccessControl(address _contract, address _caller, uint8 _perm);\n', '\n', '    function setAccessControl(\n', '        address _contract,\n', '        address _caller,\n', '        uint8 _perm,\n', '        bool _access\n', '    );\n', '\n', '    function getAccessControl(address _contract, address _caller, uint8 _perm) returns (bool _allowed);\n', '\n', '    function setLedger(uint8 _index, int _value);\n', '\n', '    function getLedger(uint8 _index) returns (int _value);\n', '\n', '    function getCustomerPremium(uint _policyId) returns (address _customer, uint _premium);\n', '\n', '    function getPolicyData(uint _policyId) returns (address _customer, uint _premium, uint _weight);\n', '\n', '    function getPolicyState(uint _policyId) returns (policyState _state);\n', '\n', '    function getRiskId(uint _policyId) returns (bytes32 _riskId);\n', '\n', '    function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) returns (uint _policyId);\n', '\n', '    function setState(\n', '        uint _policyId,\n', '        policyState _state,\n', '        uint _stateTime,\n', '        bytes32 _stateMessage\n', '    );\n', '\n', '    function setWeight(uint _policyId, uint _weight, bytes _proof);\n', '\n', '    function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout);\n', '\n', '    function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes);\n', '\n', '    function getRiskParameters(bytes32 _riskId)\n', '        returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime);\n', '\n', '    function getPremiumFactors(bytes32 _riskId)\n', '        returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);\n', '\n', '    function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)\n', '        returns (bytes32 _riskId);\n', '\n', '    function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier);\n', '\n', '    function getOraclizeCallback(bytes32 _queryId)\n', '        returns (uint _policyId, uint _arrivalTime);\n', '\n', '    function getOraclizePolicyId(bytes32 _queryId)\n', '    returns (uint _policyId);\n', '\n', '    function createOraclizeCallback(\n', '        bytes32 _queryId,\n', '        uint _policyId,\n', '        oraclizeState _oraclizeState,\n', '        uint _oraclizeTime\n', '    );\n', '\n', '    function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)\n', '        returns (bool _result);\n', '}\n', '\n', 'contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {\n', '\n', '    function receiveFunds(Acc _to) payable;\n', '\n', '    function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success);\n', '\n', '    function bookkeeping(Acc _from, Acc _to, uint amount);\n', '}\n', '\n', 'contract FlightDelayConstants {\n', '\n', '    /*\n', '    * General events\n', '    */\n', '\n', '// --> test-mode\n', '//        event LogUint(string _message, uint _uint);\n', '//        event LogUintEth(string _message, uint ethUint);\n', '//        event LogUintTime(string _message, uint timeUint);\n', '//        event LogInt(string _message, int _int);\n', '//        event LogAddress(string _message, address _address);\n', '//        event LogBytes32(string _message, bytes32 hexBytes32);\n', '//        event LogBytes(string _message, bytes hexBytes);\n', '//        event LogBytes32Str(string _message, bytes32 strBytes32);\n', '//        event LogString(string _message, string _string);\n', '//        event LogBool(string _message, bool _bool);\n', '//        event Log(address);\n', '// <-- test-mode\n', '\n', '    event LogPolicyApplied(\n', '        uint _policyId,\n', '        address _customer,\n', '        bytes32 strCarrierFlightNumber,\n', '        uint ethPremium\n', '    );\n', '    event LogPolicyAccepted(\n', '        uint _policyId,\n', '        uint _statistics0,\n', '        uint _statistics1,\n', '        uint _statistics2,\n', '        uint _statistics3,\n', '        uint _statistics4,\n', '        uint _statistics5\n', '    );\n', '    event LogPolicyPaidOut(\n', '        uint _policyId,\n', '        uint ethAmount\n', '    );\n', '    event LogPolicyExpired(\n', '        uint _policyId\n', '    );\n', '    event LogPolicyDeclined(\n', '        uint _policyId,\n', '        bytes32 strReason\n', '    );\n', '    event LogPolicyManualPayout(\n', '        uint _policyId,\n', '        bytes32 strReason\n', '    );\n', '    event LogSendFunds(\n', '        address _recipient,\n', '        uint8 _from,\n', '        uint ethAmount\n', '    );\n', '    event LogReceiveFunds(\n', '        address _sender,\n', '        uint8 _to,\n', '        uint ethAmount\n', '    );\n', '    event LogSendFail(\n', '        uint _policyId,\n', '        bytes32 strReason\n', '    );\n', '    event LogOraclizeCall(\n', '        uint _policyId,\n', '        bytes32 hexQueryId,\n', '        string _oraclizeUrl,\n', '        uint256 _oraclizeTime\n', '    );\n', '    event LogOraclizeCallback(\n', '        uint _policyId,\n', '        bytes32 hexQueryId,\n', '        string _result,\n', '        bytes hexProof\n', '    );\n', '    event LogSetState(\n', '        uint _policyId,\n', '        uint8 _policyState,\n', '        uint _stateTime,\n', '        bytes32 _stateMessage\n', '    );\n', '    event LogExternal(\n', '        uint256 _policyId,\n', '        address _address,\n', '        bytes32 _externalId\n', '    );\n', '\n', '    /*\n', '    * General constants\n', '    */\n', '\n', '    // minimum observations for valid prediction\n', '    uint constant MIN_OBSERVATIONS = 10;\n', '    // minimum premium to cover costs\n', '    uint constant MIN_PREMIUM = 50 finney;\n', '    // maximum premium\n', '    uint constant MAX_PREMIUM = 1 ether;\n', '    // maximum payout\n', '    uint constant MAX_PAYOUT = 1100 finney;\n', '\n', '    uint constant MIN_PREMIUM_EUR = 1500 wei;\n', '    uint constant MAX_PREMIUM_EUR = 29000 wei;\n', '    uint constant MAX_PAYOUT_EUR = 30000 wei;\n', '\n', '    uint constant MIN_PREMIUM_USD = 1700 wei;\n', '    uint constant MAX_PREMIUM_USD = 34000 wei;\n', '    uint constant MAX_PAYOUT_USD = 35000 wei;\n', '\n', '    uint constant MIN_PREMIUM_GBP = 1300 wei;\n', '    uint constant MAX_PREMIUM_GBP = 25000 wei;\n', '    uint constant MAX_PAYOUT_GBP = 270 wei;\n', '\n', '    // maximum cumulated weighted premium per risk\n', '    uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;\n', '    // 1 percent for DAO, 1 percent for maintainer\n', '    uint8 constant REWARD_PERCENT = 2;\n', '    // reserve for tail risks\n', '    uint8 constant RESERVE_PERCENT = 1;\n', '    // the weight pattern; in future versions this may become part of the policy struct.\n', "    // currently can't be constant because of compiler restrictions\n", '    // WEIGHT_PATTERN[0] is not used, just to be consistent\n', '    uint8[6] WEIGHT_PATTERN = [\n', '        0,\n', '        10,\n', '        20,\n', '        30,\n', '        50,\n', '        50\n', '    ];\n', '\n', '// --> prod-mode\n', '    // DEFINITIONS FOR ROPSTEN AND MAINNET\n', '    // minimum time before departure for applying\n', '    uint constant MIN_TIME_BEFORE_DEPARTURE\t= 24 hours; // for production\n', '    // check for delay after .. minutes after scheduled arrival\n', '    uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production\n', '// <-- prod-mode\n', '\n', '// --> test-mode\n', '//        // DEFINITIONS FOR LOCAL TESTNET\n', '//        // minimum time before departure for applying\n', '//        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing\n', '//        // check for delay after .. minutes after scheduled arrival\n', '//        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing\n', '// <-- test-mode\n', '\n', '    // maximum duration of flight\n', '    uint constant MAX_FLIGHT_DURATION = 2 days;\n', '    // Deadline for acceptance of policies: 31.12.2030 (Testnet)\n', '    uint constant CONTRACT_DEAD_LINE = 1922396399;\n', '\n', '    uint constant MIN_DEPARTURE_LIM = 1508198400;\n', '\n', '    uint constant MAX_DEPARTURE_LIM = 1509840000;\n', '\n', '    // gas Constants for oraclize\n', '    uint constant ORACLIZE_GAS = 1000000;\n', '\n', '\n', '    /*\n', '    * URLs and query strings for oraclize\n', '    */\n', '\n', '// --> prod-mode\n', '    // DEFINITIONS FOR ROPSTEN AND MAINNET\n', '    string constant ORACLIZE_RATINGS_BASE_URL =\n', '        // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1\n', '        "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";\n', '    string constant ORACLIZE_RATINGS_QUERY =\n', '        "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }).ratings[0][\'observations\',\'late15\',\'late30\',\'late45\',\'cancelled\',\'diverted\',\'arrivalAirportFsCode\']";\n', '    string constant ORACLIZE_STATUS_BASE_URL =\n', '        // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight\n', '        "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";\n', '    string constant ORACLIZE_STATUS_QUERY =\n', '        // pattern:\n', '        "?${[decrypt] <!--PUT ENCRYPTED_QUERY HERE--> }&utc=true).flightStatuses[0][\'status\',\'delays\',\'operationalTimes\']";\n', '// <-- prod-mode\n', '\n', '// --> test-mode\n', '//        // DEFINITIONS FOR LOCAL TESTNET\n', '//        string constant ORACLIZE_RATINGS_BASE_URL =\n', '//            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1\n', '//            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";\n', '//        string constant ORACLIZE_RATINGS_QUERY =\n', '//            // for testrpc:\n', '//            ").ratings[0][\'observations\',\'late15\',\'late30\',\'late45\',\'cancelled\',\'diverted\',\'arrivalAirportFsCode\']";\n', '//        string constant ORACLIZE_STATUS_BASE_URL =\n', '//            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight\n', '//            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";\n', '//        string constant ORACLIZE_STATUS_QUERY =\n', '//            // for testrpc:\n', '//            "?utc=true).flightStatuses[0][\'status\',\'delays\',\'operationalTimes\']";\n', '// <-- test-mode\n', '}\n', '\n', 'contract FlightDelayLedger is FlightDelayControlledContract, FlightDelayLedgerInterface, FlightDelayConstants {\n', '\n', '    FlightDelayDatabaseInterface FD_DB;\n', '    FlightDelayAccessControllerInterface FD_AC;\n', '\n', '    function FlightDelayLedger(address _controller) {\n', '        setController(_controller);\n', '    }\n', '\n', '    function setContracts() onlyController {\n', '        FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));\n', '        FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));\n', '\n', '        FD_AC.setPermissionById(101, "FD.NewPolicy");\n', '        FD_AC.setPermissionById(101, "FD.Controller"); // todo: check!\n', '\n', '        FD_AC.setPermissionById(102, "FD.Payout");\n', '        FD_AC.setPermissionById(102, "FD.NewPolicy");\n', '        FD_AC.setPermissionById(102, "FD.Controller"); // todo: check!\n', '        FD_AC.setPermissionById(102, "FD.Underwrite");\n', '        FD_AC.setPermissionById(102, "FD.Owner");\n', '\n', '        FD_AC.setPermissionById(103, "FD.Funder");\n', '        FD_AC.setPermissionById(103, "FD.Underwrite");\n', '        FD_AC.setPermissionById(103, "FD.Payout");\n', '        FD_AC.setPermissionById(103, "FD.Ledger");\n', '        FD_AC.setPermissionById(103, "FD.NewPolicy");\n', '        FD_AC.setPermissionById(103, "FD.Controller");\n', '        FD_AC.setPermissionById(103, "FD.Owner");\n', '\n', '        FD_AC.setPermissionById(104, "FD.Funder");\n', '    }\n', '\n', '    /*\n', '     * @dev Fund contract\n', '     */\n', '    function fund() payable {\n', '        require(FD_AC.checkPermission(104, msg.sender));\n', '\n', '        bookkeeping(Acc.Balance, Acc.RiskFund, msg.value);\n', '\n', '        // todo: fire funding event\n', '    }\n', '\n', '    function receiveFunds(Acc _to) payable {\n', '        require(FD_AC.checkPermission(101, msg.sender));\n', '\n', '        LogReceiveFunds(msg.sender, uint8(_to), msg.value);\n', '\n', '        bookkeeping(Acc.Balance, _to, msg.value);\n', '    }\n', '\n', '    function sendFunds(address _recipient, Acc _from, uint _amount) returns (bool _success) {\n', '        require(FD_AC.checkPermission(102, msg.sender));\n', '\n', '        if (this.balance < _amount) {\n', '            return false; // unsufficient funds\n', '        }\n', '\n', '        LogSendFunds(_recipient, uint8(_from), _amount);\n', '\n', '        bookkeeping(_from, Acc.Balance, _amount); // cash out payout\n', '\n', '        if (!_recipient.send(_amount)) {\n', '            bookkeeping(Acc.Balance, _from, _amount);\n', '            _success = false;\n', '        } else {\n', '            _success = true;\n', '        }\n', '    }\n', '\n', '    // invariant: acc_Premium + acc_RiskFund + acc_Payout + acc_Balance + acc_Reward + acc_OraclizeCosts == 0\n', '\n', '    function bookkeeping(Acc _from, Acc _to, uint256 _amount) {\n', '        require(FD_AC.checkPermission(103, msg.sender));\n', '\n', '        // check against type cast overflow\n', '        assert(int256(_amount) > 0);\n', '\n', '        // overflow check is done in FD_DB\n', '        FD_DB.setLedger(uint8(_from), -int(_amount));\n', '        FD_DB.setLedger(uint8(_to), int(_amount));\n', '    }\n', '}']