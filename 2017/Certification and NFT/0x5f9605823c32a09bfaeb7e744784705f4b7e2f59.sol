['/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description\tAccessControllerInterface\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', 'contract FlightDelayAccessControllerInterface {\n', '\n', '    function setPermissionById(uint8 _perm, bytes32 _id) public;\n', '\n', '    function setPermissionById(uint8 _perm, bytes32 _id, bool _access) public;\n', '\n', '    function setPermissionByAddress(uint8 _perm, address _addr) public;\n', '\n', '    function setPermissionByAddress(uint8 _perm, address _addr, bool _access) public;\n', '\n', '    function checkPermission(uint8 _perm, address _addr) public returns (bool _success);\n', '}\n', '\n', '// File: contracts/FlightDelayConstants.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description\tEvents and Constants\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', 'contract FlightDelayConstants {\n', '\n', '    /*\n', '    * General events\n', '    */\n', '\n', '// --> test-mode\n', '//        event LogUint(string _message, uint _uint);\n', '//        event LogUintEth(string _message, uint ethUint);\n', '//        event LogUintTime(string _message, uint timeUint);\n', '//        event LogInt(string _message, int _int);\n', '//        event LogAddress(string _message, address _address);\n', '//        event LogBytes32(string _message, bytes32 hexBytes32);\n', '//        event LogBytes(string _message, bytes hexBytes);\n', '//        event LogBytes32Str(string _message, bytes32 strBytes32);\n', '//        event LogString(string _message, string _string);\n', '//        event LogBool(string _message, bool _bool);\n', '//        event Log(address);\n', '// <-- test-mode\n', '\n', '    event LogPolicyApplied(\n', '        uint _policyId,\n', '        address _customer,\n', '        bytes32 strCarrierFlightNumber,\n', '        uint ethPremium\n', '    );\n', '    event LogPolicyAccepted(\n', '        uint _policyId,\n', '        uint _statistics0,\n', '        uint _statistics1,\n', '        uint _statistics2,\n', '        uint _statistics3,\n', '        uint _statistics4,\n', '        uint _statistics5\n', '    );\n', '    event LogPolicyPaidOut(\n', '        uint _policyId,\n', '        uint ethAmount\n', '    );\n', '    event LogPolicyExpired(\n', '        uint _policyId\n', '    );\n', '    event LogPolicyDeclined(\n', '        uint _policyId,\n', '        bytes32 strReason\n', '    );\n', '    event LogPolicyManualPayout(\n', '        uint _policyId,\n', '        bytes32 strReason\n', '    );\n', '    event LogSendFunds(\n', '        address _recipient,\n', '        uint8 _from,\n', '        uint ethAmount\n', '    );\n', '    event LogReceiveFunds(\n', '        address _sender,\n', '        uint8 _to,\n', '        uint ethAmount\n', '    );\n', '    event LogSendFail(\n', '        uint _policyId,\n', '        bytes32 strReason\n', '    );\n', '    event LogOraclizeCall(\n', '        uint _policyId,\n', '        bytes32 hexQueryId,\n', '        string _oraclizeUrl,\n', '        uint256 _oraclizeTime\n', '    );\n', '    event LogOraclizeCallback(\n', '        uint _policyId,\n', '        bytes32 hexQueryId,\n', '        string _result,\n', '        bytes hexProof\n', '    );\n', '    event LogSetState(\n', '        uint _policyId,\n', '        uint8 _policyState,\n', '        uint _stateTime,\n', '        bytes32 _stateMessage\n', '    );\n', '    event LogExternal(\n', '        uint256 _policyId,\n', '        address _address,\n', '        bytes32 _externalId\n', '    );\n', '\n', '    /*\n', '    * General constants\n', '    */\n', '\n', '    // minimum observations for valid prediction\n', '    uint constant MIN_OBSERVATIONS = 10;\n', '    // minimum premium to cover costs\n', '    uint constant MIN_PREMIUM = 50 finney;\n', '    // maximum premium\n', '    uint constant MAX_PREMIUM = 1 ether;\n', '    // maximum payout\n', '    uint constant MAX_PAYOUT = 1100 finney;\n', '\n', '    uint constant MIN_PREMIUM_EUR = 1500 wei;\n', '    uint constant MAX_PREMIUM_EUR = 29000 wei;\n', '    uint constant MAX_PAYOUT_EUR = 30000 wei;\n', '\n', '    uint constant MIN_PREMIUM_USD = 1700 wei;\n', '    uint constant MAX_PREMIUM_USD = 34000 wei;\n', '    uint constant MAX_PAYOUT_USD = 35000 wei;\n', '\n', '    uint constant MIN_PREMIUM_GBP = 1300 wei;\n', '    uint constant MAX_PREMIUM_GBP = 25000 wei;\n', '    uint constant MAX_PAYOUT_GBP = 270 wei;\n', '\n', '    // maximum cumulated weighted premium per risk\n', '    uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;\n', '    // 1 percent for DAO, 1 percent for maintainer\n', '    uint8 constant REWARD_PERCENT = 2;\n', '    // reserve for tail risks\n', '    uint8 constant RESERVE_PERCENT = 1;\n', '    // the weight pattern; in future versions this may become part of the policy struct.\n', "    // currently can't be constant because of compiler restrictions\n", '    // WEIGHT_PATTERN[0] is not used, just to be consistent\n', '    uint8[6] WEIGHT_PATTERN = [\n', '        0,\n', '        10,\n', '        20,\n', '        30,\n', '        50,\n', '        50\n', '    ];\n', '\n', '// --> prod-mode\n', '    // DEFINITIONS FOR ROPSTEN AND MAINNET\n', '    // minimum time before departure for applying\n', '    uint constant MIN_TIME_BEFORE_DEPARTURE\t= 24 hours; // for production\n', '    // check for delay after .. minutes after scheduled arrival\n', '    uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production\n', '// <-- prod-mode\n', '\n', '// --> test-mode\n', '//        // DEFINITIONS FOR LOCAL TESTNET\n', '//        // minimum time before departure for applying\n', '//        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing\n', '//        // check for delay after .. minutes after scheduled arrival\n', '//        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing\n', '// <-- test-mode\n', '\n', '    // maximum duration of flight\n', '    uint constant MAX_FLIGHT_DURATION = 2 days;\n', '    // Deadline for acceptance of policies: 31.12.2030 (Testnet)\n', '    uint constant CONTRACT_DEAD_LINE = 1922396399;\n', '\n', '    // gas Constants for oraclize\n', '    uint constant ORACLIZE_GAS = 700000;\n', '    uint constant ORACLIZE_GASPRICE = 4000000000;\n', '\n', '\n', '    /*\n', '    * URLs and query strings for oraclize\n', '    */\n', '\n', '// --> prod-mode\n', '    // DEFINITIONS FOR ROPSTEN AND MAINNET\n', '    string constant ORACLIZE_RATINGS_BASE_URL =\n', '        // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1\n', '        "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";\n', '    string constant ORACLIZE_RATINGS_QUERY =\n', '        "?${[decrypt] BAr6Z9QolM2PQimF/pNC6zXldOvZ2qquOSKm/qJkJWnSGgAeRw21wBGnBbXiamr/ISC5SlcJB6wEPKthdc6F+IpqM/iXavKsalRUrGNuBsGfaMXr8fRQw6gLzqk0ecOFNeCa48/yqBvC/kas+jTKHiYxA3wTJrVZCq76Y03lZI2xxLaoniRk}).ratings[0][\'observations\',\'late15\',\'late30\',\'late45\',\'cancelled\',\'diverted\',\'arrivalAirportFsCode\',\'departureAirportFsCode\']";\n', '    string constant ORACLIZE_STATUS_BASE_URL =\n', '        // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight\n', '        "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";\n', '    string constant ORACLIZE_STATUS_QUERY =\n', '        // pattern:\n', '        "?${[decrypt] BJxpwRaHujYTT98qI5slQJplj/VbfV7vYkMOp/Mr5D/5+gkgJQKZb0gVSCa6aKx2Wogo/cG7yaWINR6vnuYzccQE5yVJSr7RQilRawxnAtZXt6JB70YpX4xlfvpipit4R+OmQTurJGGwb8Pgnr4LvotydCjup6wv2Bk/z3UdGA7Sl+FU5a+0}&utc=true).flightStatuses[0][\'status\',\'delays\',\'operationalTimes\']";\n', '// <-- prod-mode\n', '\n', '// --> test-mode\n', '//        // DEFINITIONS FOR LOCAL TESTNET\n', '//        string constant ORACLIZE_RATINGS_BASE_URL =\n', '//            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1\n', '//            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";\n', '//        string constant ORACLIZE_RATINGS_QUERY =\n', '//            // for testrpc:\n', '//            ").ratings[0][\'observations\',\'late15\',\'late30\',\'late45\',\'cancelled\',\'diverted\',\'arrivalAirportFsCode\',\'departureAirportFsCode\']";\n', '//        string constant ORACLIZE_STATUS_BASE_URL =\n', '//            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight\n', '//            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";\n', '//        string constant ORACLIZE_STATUS_QUERY =\n', '//            // for testrpc:\n', '//            "?utc=true).flightStatuses[0][\'status\',\'delays\',\'operationalTimes\']";\n', '// <-- test-mode\n', '}\n', '\n', '// File: contracts/FlightDelayControllerInterface.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description Contract interface\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock, Stephan Karpischek\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', 'contract FlightDelayControllerInterface {\n', '\n', '    function isOwner(address _addr) public returns (bool _isOwner);\n', '\n', '    function selfRegister(bytes32 _id) public returns (bool result);\n', '\n', '    function getContract(bytes32 _id) public returns (address _addr);\n', '}\n', '\n', '// File: contracts/FlightDelayDatabaseModel.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description Database model\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock, Stephan Karpischek\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', 'contract FlightDelayDatabaseModel {\n', '\n', '    // Ledger accounts.\n', '    enum Acc {\n', '        Premium,      // 0\n', '        RiskFund,     // 1\n', '        Payout,       // 2\n', '        Balance,      // 3\n', '        Reward,       // 4\n', '        OraclizeCosts // 5\n', '    }\n', '\n', '    // policy Status Codes and meaning:\n', '    //\n', '    // 00 = Applied:\t  the customer has payed a premium, but the oracle has\n', '    //\t\t\t\t\t        not yet checked and confirmed.\n', '    //\t\t\t\t\t        The customer can still revoke the policy.\n', '    // 01 = Accepted:\t  the oracle has checked and confirmed.\n', '    //\t\t\t\t\t        The customer can still revoke the policy.\n', '    // 02 = Revoked:\t  The customer has revoked the policy.\n', '    //\t\t\t\t\t        The premium minus cancellation fee is payed back to the\n', '    //\t\t\t\t\t        customer by the oracle.\n', '    // 03 = PaidOut:\t  The flight has ended with delay.\n', '    //\t\t\t\t\t        The oracle has checked and payed out.\n', '    // 04 = Expired:\t  The flight has endet with <15min. delay.\n', '    //\t\t\t\t\t        No payout.\n', '    // 05 = Declined:\t  The application was invalid.\n', '    //\t\t\t\t\t        The premium minus cancellation fee is payed back to the\n', '    //\t\t\t\t\t        customer by the oracle.\n', '    // 06 = SendFailed:\tDuring Revoke, Decline or Payout, sending ether failed\n', '    //\t\t\t\t\t        for unknown reasons.\n', '    //\t\t\t\t\t        The funds remain in the contracts RiskFund.\n', '\n', '\n', '    //                   00       01        02       03        04      05           06\n', '    enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }\n', '\n', '    // oraclize callback types:\n', '    enum oraclizeState { ForUnderwriting, ForPayout }\n', '\n', '    //               00   01   02   03\n', '    enum Currency { ETH, EUR, USD, GBP }\n', '\n', '    // the policy structure: this structure keeps track of the individual parameters of a policy.\n', '    // typically customer address, premium and some status information.\n', '    struct Policy {\n', '        // 0 - the customer\n', '        address customer;\n', '\n', '        // 1 - premium\n', '        uint premium;\n', '        // risk specific parameters:\n', '        // 2 - pointer to the risk in the risks mapping\n', '        bytes32 riskId;\n', '        // custom payout pattern\n', '        // in future versions, customer will be able to tamper with this array.\n', '        // to keep things simple, we have decided to hard-code the array for all policies.\n', '        // uint8[5] pattern;\n', '        // 3 - probability weight. this is the central parameter\n', '        uint weight;\n', '        // 4 - calculated Payout\n', '        uint calculatedPayout;\n', '        // 5 - actual Payout\n', '        uint actualPayout;\n', '\n', '        // status fields:\n', '        // 6 - the state of the policy\n', '        policyState state;\n', '        // 7 - time of last state change\n', '        uint stateTime;\n', '        // 8 - state change message/reason\n', '        bytes32 stateMessage;\n', '        // 9 - TLSNotary Proof\n', '        bytes proof;\n', '        // 10 - Currency\n', '        Currency currency;\n', '        // 10 - External customer id\n', '        bytes32 customerExternalId;\n', '    }\n', '\n', '    // the risk structure; this structure keeps track of the risk-\n', '    // specific parameters.\n', '    // several policies can share the same risk structure (typically\n', '    // some people flying with the same plane)\n', '    struct Risk {\n', '        // 0 - Airline Code + FlightNumber\n', '        bytes32 carrierFlightNumber;\n', '        // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD\n', '        bytes32 departureYearMonthDay;\n', '        // 2 - the inital arrival time\n', '        uint arrivalTime;\n', '        // 3 - the final delay in minutes\n', '        uint delayInMinutes;\n', '        // 4 - the determined delay category (0-5)\n', '        uint8 delay;\n', '        // 5 - we limit the cumulated weighted premium to avoid cluster risks\n', '        uint cumulatedWeightedPremium;\n', '        // 6 - max cumulated Payout for this risk\n', '        uint premiumMultiplier;\n', '    }\n', '\n', '    // the oraclize callback structure: we use several oraclize calls.\n', '    // all oraclize calls will result in a common callback to __callback(...).\n', '    // to keep track of the different querys we have to introduce this struct.\n', '    struct OraclizeCallback {\n', '        // for which policy have we called?\n', '        uint policyId;\n', '        // for which purpose did we call? {ForUnderwrite | ForPayout}\n', '        oraclizeState oState;\n', '        // time\n', '        uint oraclizeTime;\n', '    }\n', '\n', '    struct Customer {\n', '        bytes32 customerExternalId;\n', '        bool identityConfirmed;\n', '    }\n', '}\n', '\n', '// File: contracts/FlightDelayControlledContract.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description Controlled contract Interface\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '\n', '\n', 'contract FlightDelayControlledContract is FlightDelayDatabaseModel {\n', '\n', '    address public controller;\n', '    FlightDelayControllerInterface FD_CI;\n', '\n', '    modifier onlyController() {\n', '        require(msg.sender == controller);\n', '        _;\n', '    }\n', '\n', '    function setController(address _controller) internal returns (bool _result) {\n', '        controller = _controller;\n', '        FD_CI = FlightDelayControllerInterface(_controller);\n', '        _result = true;\n', '    }\n', '\n', '    function destruct() public onlyController {\n', '        selfdestruct(controller);\n', '    }\n', '\n', '    function setContracts() public onlyController {}\n', '\n', '    function getContract(bytes32 _id) internal returns (address _addr) {\n', '        _addr = FD_CI.getContract(_id);\n', '    }\n', '}\n', '\n', '// File: contracts/FlightDelayDatabaseInterface.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description Database contract interface\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock, Stephan Karpischek\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '\n', 'contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {\n', '\n', '    uint public MIN_DEPARTURE_LIM;\n', '\n', '    uint public MAX_DEPARTURE_LIM;\n', '\n', '    bytes32[] public validOrigins;\n', '\n', '    bytes32[] public validDestinations;\n', '\n', '    function countOrigins() public constant returns (uint256 _length);\n', '\n', '    function getOriginByIndex(uint256 _i) public constant returns (bytes32 _origin);\n', '\n', '    function countDestinations() public constant returns (uint256 _length);\n', '\n', '    function getDestinationByIndex(uint256 _i) public constant returns (bytes32 _destination);\n', '\n', '    function setAccessControl(address _contract, address _caller, uint8 _perm) public;\n', '\n', '    function setAccessControl(\n', '        address _contract,\n', '        address _caller,\n', '        uint8 _perm,\n', '        bool _access\n', '    ) public;\n', '\n', '    function getAccessControl(address _contract, address _caller, uint8 _perm) public returns (bool _allowed) ;\n', '\n', '    function setLedger(uint8 _index, int _value) public;\n', '\n', '    function getLedger(uint8 _index) public returns (int _value) ;\n', '\n', '    function getCustomerPremium(uint _policyId) public returns (address _customer, uint _premium) ;\n', '\n', '    function getPolicyData(uint _policyId) public returns (address _customer, uint _premium, uint _weight) ;\n', '\n', '    function getPolicyState(uint _policyId) public returns (policyState _state) ;\n', '\n', '    function getRiskId(uint _policyId) public returns (bytes32 _riskId);\n', '\n', '    function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) public returns (uint _policyId) ;\n', '\n', '    function setState(\n', '        uint _policyId,\n', '        policyState _state,\n', '        uint _stateTime,\n', '        bytes32 _stateMessage\n', '    ) public;\n', '\n', '    function setWeight(uint _policyId, uint _weight, bytes _proof) public;\n', '\n', '    function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout) public;\n', '\n', '    function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes) public;\n', '\n', '    function getRiskParameters(bytes32 _riskId)\n', '        public returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) ;\n', '\n', '    function getPremiumFactors(bytes32 _riskId)\n', '        public returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);\n', '\n', '    function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)\n', '        public returns (bytes32 _riskId);\n', '\n', '    function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier) public;\n', '\n', '    function getOraclizeCallback(bytes32 _queryId)\n', '        public returns (uint _policyId, uint _oraclizeTime) ;\n', '\n', '    function getOraclizePolicyId(bytes32 _queryId)\n', '        public returns (uint _policyId) ;\n', '\n', '    function createOraclizeCallback(\n', '        bytes32 _queryId,\n', '        uint _policyId,\n', '        oraclizeState _oraclizeState,\n', '        uint _oraclizeTime\n', '    ) public;\n', '\n', '    function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)\n', '        public returns (bool _result) ;\n', '}\n', '\n', '// File: contracts/FlightDelayLedgerInterface.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description\tLedger contract interface\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock, Stephan Karpischek\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '\n', 'contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {\n', '\n', '    function receiveFunds(Acc _to) public payable;\n', '\n', '    function sendFunds(address _recipient, Acc _from, uint _amount) public returns (bool _success);\n', '\n', '    function bookkeeping(Acc _from, Acc _to, uint amount) public;\n', '}\n', '\n', '// File: contracts/FlightDelayUnderwriteInterface.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description\tUnderwrite contract interface\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock, Stephan Karpischek\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', 'contract FlightDelayUnderwriteInterface {\n', '\n', '    function scheduleUnderwriteOraclizeCall(uint _policyId, bytes32 _carrierFlightNumber) public;\n', '}\n', '\n', '// File: contracts/convertLib.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description\tConversions\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', 'contract ConvertLib {\n', '\n', '    // .. since beginning of the year\n', '    uint16[12] days_since = [\n', '        11,\n', '        42,\n', '        70,\n', '        101,\n', '        131,\n', '        162,\n', '        192,\n', '        223,\n', '        254,\n', '        284,\n', '        315,\n', '        345\n', '    ];\n', '\n', '    function b32toString(bytes32 x) internal returns (string) {\n', '        // gas usage: about 1K gas per char.\n', '        bytes memory bytesString = new bytes(32);\n', '        uint charCount = 0;\n', '\n', '        for (uint j = 0; j < 32; j++) {\n', '            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));\n', '            if (char != 0) {\n', '                bytesString[charCount] = char;\n', '                charCount++;\n', '            }\n', '        }\n', '\n', '        bytes memory bytesStringTrimmed = new bytes(charCount);\n', '\n', '        for (j = 0; j < charCount; j++) {\n', '            bytesStringTrimmed[j] = bytesString[j];\n', '        }\n', '\n', '        return string(bytesStringTrimmed);\n', '    }\n', '\n', '    function b32toHexString(bytes32 x) returns (string) {\n', '        bytes memory b = new bytes(64);\n', '        for (uint i = 0; i < 32; i++) {\n', '            uint8 by = uint8(uint(x) / (2**(8*(31 - i))));\n', '            uint8 high = by/16;\n', '            uint8 low = by - 16*high;\n', '            if (high > 9) {\n', '                high += 39;\n', '            }\n', '            if (low > 9) {\n', '                low += 39;\n', '            }\n', '            b[2*i] = byte(high+48);\n', '            b[2*i+1] = byte(low+48);\n', '        }\n', '\n', '        return string(b);\n', '    }\n', '\n', '    function parseInt(string _a) internal returns (uint) {\n', '        return parseInt(_a, 0);\n', '    }\n', '\n', '    // parseInt(parseFloat*10^_b)\n', '    function parseInt(string _a, uint _b) internal returns (uint) {\n', '        bytes memory bresult = bytes(_a);\n', '        uint mint = 0;\n', '        bool decimals = false;\n', '        for (uint i = 0; i<bresult.length; i++) {\n', '            if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {\n', '                if (decimals) {\n', '                    if (_b == 0) {\n', '                        break;\n', '                    } else {\n', '                        _b--;\n', '                    }\n', '                }\n', '                mint *= 10;\n', '                mint += uint(bresult[i]) - 48;\n', '            } else if (bresult[i] == 46) {\n', '                decimals = true;\n', '            }\n', '        }\n', '        if (_b > 0) {\n', '            mint *= 10**_b;\n', '        }\n', '        return mint;\n', '    }\n', '\n', '    // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,\n', '    // so within the validity of the contract its correct.\n', '    function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {\n', '        // _day_month_year = /dep/2016/09/10\n', '        bytes memory bDmy = bytes(b32toString(_dayMonthYear));\n', '        bytes memory temp2 = bytes(new string(2));\n', '        bytes memory temp4 = bytes(new string(4));\n', '\n', '        temp4[0] = bDmy[5];\n', '        temp4[1] = bDmy[6];\n', '        temp4[2] = bDmy[7];\n', '        temp4[3] = bDmy[8];\n', '        uint year = parseInt(string(temp4));\n', '\n', '        temp2[0] = bDmy[10];\n', '        temp2[1] = bDmy[11];\n', '        uint month = parseInt(string(temp2));\n', '\n', '        temp2[0] = bDmy[13];\n', '        temp2[1] = bDmy[14];\n', '        uint day = parseInt(string(temp2));\n', '\n', '        unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;\n', '    }\n', '}\n', '\n', '// File: contracts/FlightDelayNewPolicy.sol\n', '\n', '/**\n', ' * FlightDelay with Oraclized Underwriting and Payout\n', ' *\n', ' * @description NewPolicy contract.\n', ' * @copyright (c) 2017 etherisc GmbH\n', ' * @author Christoph Mussenbrock\n', ' */\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract FlightDelayNewPolicy is FlightDelayControlledContract, FlightDelayConstants, ConvertLib {\n', '\n', '    FlightDelayAccessControllerInterface FD_AC;\n', '    FlightDelayDatabaseInterface FD_DB;\n', '    FlightDelayLedgerInterface FD_LG;\n', '    FlightDelayUnderwriteInterface FD_UW;\n', '\n', '    function FlightDelayNewPolicy(address _controller) public {\n', '        setController(_controller);\n', '    }\n', '\n', '    function setContracts() public onlyController {\n', '        FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));\n', '        FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));\n', '        FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));\n', '        FD_UW = FlightDelayUnderwriteInterface(getContract("FD.Underwrite"));\n', '\n', '        FD_AC.setPermissionByAddress(101, 0x0);\n', '        FD_AC.setPermissionById(102, "FD.Controller");\n', '        FD_AC.setPermissionById(103, "FD.Owner");\n', '    }\n', '\n', '    function bookAndCalcRemainingPremium() internal returns (uint) {\n', '        uint v = msg.value;\n', '        uint reserve = v * RESERVE_PERCENT / 100;\n', '        uint remain = v - reserve;\n', '        uint reward = remain * REWARD_PERCENT / 100;\n', '\n', '        // FD_LG.bookkeeping(Acc.Balance, Acc.Premium, v);\n', '        FD_LG.bookkeeping(Acc.Premium, Acc.RiskFund, reserve);\n', '        FD_LG.bookkeeping(Acc.Premium, Acc.Reward, reward);\n', '\n', '        return (uint(remain - reward));\n', '    }\n', '\n', '    function maintenanceMode(bool _on) public {\n', '        if (FD_AC.checkPermission(103, msg.sender)) {\n', '            FD_AC.setPermissionByAddress(101, 0x0, !_on);\n', '        }\n', '    }\n', '\n', '    // create new policy\n', '    function newPolicy(\n', '        bytes32 _carrierFlightNumber,\n', '        bytes32 _departureYearMonthDay,\n', '        uint256 _departureTime,\n', '        uint256 _arrivalTime,\n', '        Currency _currency,\n', '        bytes32 _customerExternalId) public payable\n', '    {\n', '        // here we can switch it off.\n', '        require(FD_AC.checkPermission(101, 0x0));\n', '\n', '        // solidity checks for valid _currency parameter\n', '        if (_currency == Currency.ETH) {\n', '            // ETH\n', '            if (msg.value < MIN_PREMIUM || msg.value > MAX_PREMIUM) {\n', '                LogPolicyDeclined(0, "Invalid premium value ETH");\n', '                FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);\n', '                return;\n', '            }\n', '        } else {\n', '            require(msg.sender == getContract("FD.CustomersAdmin"));\n', '\n', '            if (_currency == Currency.EUR) {\n', '                // EUR\n', '                if (msg.value < MIN_PREMIUM_EUR || msg.value > MAX_PREMIUM_EUR) {\n', '                    LogPolicyDeclined(0, "Invalid premium value EUR");\n', '                    FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);\n', '                    return;\n', '                }\n', '            }\n', '\n', '            if (_currency == Currency.USD) {\n', '                // USD\n', '                if (msg.value < MIN_PREMIUM_USD || msg.value > MAX_PREMIUM_USD) {\n', '                    LogPolicyDeclined(0, "Invalid premium value USD");\n', '                    FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);\n', '                    return;\n', '                }\n', '            }\n', '\n', '            if (_currency == Currency.GBP) {\n', '                // GBP\n', '                if (msg.value < MIN_PREMIUM_GBP || msg.value > MAX_PREMIUM_GBP) {\n', '                    LogPolicyDeclined(0, "Invalid premium value GBP");\n', '                    FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);\n', '                    return;\n', '                }\n', '            }\n', '        }\n', '\n', '        // forward premium\n', '        FD_LG.receiveFunds.value(msg.value)(Acc.Premium);\n', '\n', '\n', "        // don't Accept flights with departure time earlier than in 24 hours,\n", '        // or arrivalTime before departureTime,\n', '        // or departureTime after Mon, 26 Sep 2016 12:00:00 GMT\n', '        uint dmy = toUnixtime(_departureYearMonthDay);\n', '\n', '// --> debug-mode\n', '//            LogUintTime("NewPolicy: dmy: ", dmy);\n', '//            LogUintTime("NewPolicy: _departureTime: ", _departureTime);\n', '// <-- debug-mode\n', '\n', '        if (\n', '            _arrivalTime < _departureTime ||\n', '            _arrivalTime > _departureTime + MAX_FLIGHT_DURATION ||\n', '            _departureTime < now + MIN_TIME_BEFORE_DEPARTURE ||\n', '            _departureTime > CONTRACT_DEAD_LINE ||\n', '            _departureTime < dmy ||\n', '            _departureTime > dmy + 24 hours ||\n', '            _departureTime < FD_DB.MIN_DEPARTURE_LIM() ||\n', '            _departureTime > FD_DB.MAX_DEPARTURE_LIM()\n', '        ) {\n', '            LogPolicyDeclined(0, "Invalid arrival/departure time");\n', '            FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);\n', '            return;\n', '        }\n', '\n', '        bytes32 riskId = FD_DB.createUpdateRisk(_carrierFlightNumber, _departureYearMonthDay, _arrivalTime);\n', '\n', '        var (cumulatedWeightedPremium, premiumMultiplier) = FD_DB.getPremiumFactors(riskId);\n', '\n', '        // roughly check, whether MAX_CUMULATED_WEIGHTED_PREMIUM will be exceeded\n', '        // (we Accept the inAccuracy that the real remaining premium is 3% lower),\n', '        // but we are conservative;\n', '        // if this is the first policy, the left side will be 0\n', '        if (msg.value * premiumMultiplier + cumulatedWeightedPremium >= MAX_CUMULATED_WEIGHTED_PREMIUM) {\n', '            LogPolicyDeclined(0, "Cluster risk");\n', '            FD_LG.sendFunds(msg.sender, Acc.Premium, msg.value);\n', '            return;\n', '        } else if (cumulatedWeightedPremium == 0) {\n', '            // at the first police, we set r.cumulatedWeightedPremium to the max.\n', '            // this prevents further polices to be Accepted, until the correct\n', '            // value is calculated after the first callback from the oracle.\n', '            FD_DB.setPremiumFactors(riskId, MAX_CUMULATED_WEIGHTED_PREMIUM, premiumMultiplier);\n', '        }\n', '\n', '        uint premium = bookAndCalcRemainingPremium();\n', '        uint policyId = FD_DB.createPolicy(msg.sender, premium, _currency, _customerExternalId, riskId);\n', '\n', '        if (premiumMultiplier > 0) {\n', '            FD_DB.setPremiumFactors(\n', '                riskId,\n', '                cumulatedWeightedPremium + premium * premiumMultiplier,\n', '                premiumMultiplier\n', '            );\n', '        }\n', '\n', '        // now we have successfully applied\n', '        FD_DB.setState(\n', '            policyId,\n', '            policyState.Applied,\n', '            now,\n', '            "Policy applied by customer"\n', '        );\n', '\n', '        LogPolicyApplied(\n', '            policyId,\n', '            msg.sender,\n', '            _carrierFlightNumber,\n', '            premium\n', '        );\n', '\n', '        LogExternal(\n', '            policyId,\n', '            msg.sender,\n', '            _customerExternalId\n', '        );\n', '\n', '        FD_UW.scheduleUnderwriteOraclizeCall(policyId, _carrierFlightNumber);\n', '    }\n', '}']