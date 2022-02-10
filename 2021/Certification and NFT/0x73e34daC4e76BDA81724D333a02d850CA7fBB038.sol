['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.4;\n', 'import "./SafeMath.sol";\n', 'import "./TellorStorage.sol";\n', 'import "./TellorVariables.sol";\n', 'import "./Utilities.sol";\n', '\n', '/**\n', ' * @title Tellor Getters\n', ' * @dev Oracle contract with all tellor getter functions\n', ' */\n', 'contract TellorGetters is TellorStorage, TellorVariables, Utilities {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @dev This function tells you if a given challenge has been completed by a given miner\n', '     * @param _challenge the challenge to search for\n', '     * @param _miner address that you want to know if they solved the challenge\n', '     * @return true if the _miner address provided solved the\n', '     */\n', '    function didMine(bytes32 _challenge, address _miner)\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        return minersByChallenge[_challenge][_miner];\n', '    }\n', '\n', '    /**\n', '     * @dev Checks if an address voted in a given dispute\n', '     * @param _disputeId to look up\n', '     * @param _address to look up\n', '     * @return bool of whether or not party voted\n', '     */\n', '    function didVote(uint256 _disputeId, address _address)\n', '        external\n', '        view\n', '        returns (bool)\n', '    {\n', '        return disputesById[_disputeId].voted[_address];\n', '    }\n', '\n', '    /**\n', '     * @dev allows Tellor to read data from the addressVars mapping\n', '     * @param _data is the keccak256("variable_name") of the variable that is being accessed.\n', '     * These are examples of how the variables are saved within other functions:\n', '     * addressVars[keccak256("_owner")]\n', '     * addressVars[keccak256("tellorContract")]\n', '     * @return address of the requested variable\n', '     */\n', '    function getAddressVars(bytes32 _data) external view returns (address) {\n', '        return addresses[_data];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets all dispute variables\n', '     * @param _disputeId to look up\n', '     * @return bytes32 hash of dispute\n', '     * bool executed where true if it has been voted on\n', '     * bool disputeVotePassed\n', '     * bool isPropFork true if the dispute is a proposed fork\n', '     * address of reportedMiner\n', '     * address of reportingParty\n', '     * address of proposedForkAddress\n', '     * uint of requestId\n', '     * uint of timestamp\n', '     * uint of value\n', '     * uint of minExecutionDate\n', '     * uint of numberOfVotes\n', '     * uint of blocknumber\n', '     * uint of minerSlot\n', '     * uint of quorum\n', '     * uint of fee\n', '     * int count of the current tally\n', '     */\n', '    function getAllDisputeVars(uint256 _disputeId)\n', '        public\n', '        view\n', '        returns (\n', '            bytes32,\n', '            bool,\n', '            bool,\n', '            bool,\n', '            address,\n', '            address,\n', '            address,\n', '            uint256[9] memory,\n', '            int256\n', '        )\n', '    {\n', '        Dispute storage disp = disputesById[_disputeId];\n', '        return (\n', '            disp.hash,\n', '            disp.executed,\n', '            disp.disputeVotePassed,\n', '            disp.isPropFork,\n', '            disp.reportedMiner,\n', '            disp.reportingParty,\n', '            disp.proposedForkAddress,\n', '            [\n', '                disp.disputeUintVars[_REQUEST_ID],\n', '                disp.disputeUintVars[_TIMESTAMP],\n', '                disp.disputeUintVars[_VALUE],\n', '                disp.disputeUintVars[_MIN_EXECUTION_DATE],\n', '                disp.disputeUintVars[_NUM_OF_VOTES],\n', '                disp.disputeUintVars[_BLOCK_NUMBER],\n', '                disp.disputeUintVars[_MINER_SLOT],\n', '                disp.disputeUintVars[keccak256("quorum")],\n', '                disp.disputeUintVars[_FEE]\n', '            ],\n', '            disp.tally\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Checks if a given hash of miner,requestId has been disputed\n', '     * @param _hash is the sha256(abi.encodePacked(_miners[2],_requestId,_timestamp));\n', '     * @return uint disputeId\n', '     */\n', '    function getDisputeIdByDisputeHash(bytes32 _hash)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return disputeIdByDisputeHash[_hash];\n', '    }\n', '\n', '    /**\n', '     * @dev Checks for uint variables in the disputeUintVars mapping based on the disputeId\n', '     * @param _disputeId is the dispute id;\n', '     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is\n', '     * the variables/strings used to save the data in the mapping. The variables names are\n', '     * commented out under the disputeUintVars under the Dispute struct\n', '     * @return uint value for the bytes32 data submitted\n', '     */\n', '    function getDisputeUintVars(uint256 _disputeId, bytes32 _data)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return disputesById[_disputeId].disputeUintVars[_data];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the a value for the latest timestamp available\n', '     * @return value for timestamp of last proof of work submitted\n', '     * @return true if the is a timestamp for the lastNewValue\n', '     */\n', '    function getLastNewValue() external view returns (uint256, bool) {\n', '        return (\n', '            retrieveData(\n', '                requestIdByTimestamp[uints[_TIME_OF_LAST_NEW_VALUE]],\n', '                uints[_TIME_OF_LAST_NEW_VALUE]\n', '            ),\n', '            true\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the a value for the latest timestamp available\n', '     * @param _requestId being requested\n', "     * @return value for timestamp of last proof of work submitted and if true if it exist or 0 and false if it doesn't\n", '     */\n', '    function getLastNewValueById(uint256 _requestId)\n', '        external\n', '        view\n', '        returns (uint256, bool)\n', '    {\n', '        Request storage _request = requestDetails[_requestId];\n', '        if (_request.requestTimestamps.length != 0) {\n', '            return (\n', '                retrieveData(\n', '                    _requestId,\n', '                    _request.requestTimestamps[\n', '                        _request.requestTimestamps.length - 1\n', '                    ]\n', '                ),\n', '                true\n', '            );\n', '        } else {\n', '            return (0, false);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Gets blocknumber for mined timestamp\n', '     * @param _requestId to look up\n', '     * @param _timestamp is the timestamp to look up blocknumber\n', '     * @return uint of the blocknumber which the dispute was mined\n', '     */\n', '    function getMinedBlockNum(uint256 _requestId, uint256 _timestamp)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return requestDetails[_requestId].minedBlockNum[_timestamp];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp\n', '     * @param _requestId to look up\n', '     * @param _timestamp is the timestamp to look up miners for\n', "     * @return the 5 miners' addresses\n", '     */\n', '    function getMinersByRequestIdAndTimestamp(\n', '        uint256 _requestId,\n', '        uint256 _timestamp\n', '    ) external view returns (address[5] memory) {\n', '        return requestDetails[_requestId].minersByValue[_timestamp];\n', '    }\n', '\n', '    /**\n', '     * @dev Counts the number of values that have been submitted for the request\n', '     * if called for the currentRequest being mined it can tell you how many miners have submitted a value for that\n', '     * request so far\n', '     * @param _requestId the requestId to look up\n', '     * @return uint count of the number of values received for the requestId\n', '     */\n', '    function getNewValueCountbyRequestId(uint256 _requestId)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return requestDetails[_requestId].requestTimestamps.length;\n', '    }\n', '\n', '    /**\n', '     * @dev Getter function for the specified requestQ index\n', '     * @param _index to look up in the requestQ array\n', '     * @return uint of requestId\n', '     */\n', '    function getRequestIdByRequestQIndex(uint256 _index)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(_index <= 50, "RequestQ index is above 50");\n', '        return requestIdByRequestQIndex[_index];\n', '    }\n', '\n', '    /**\n', '     * @dev Getter function for requestId based on timestamp\n', '     * @param _timestamp to check requestId\n', '     * @return uint of requestId\n', '     */\n', '    function getRequestIdByTimestamp(uint256 _timestamp)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return requestIdByTimestamp[_timestamp];\n', '    }\n', '\n', '    /**\n', '     * @dev Getter function for the requestQ array\n', '     * @return the requestQ array\n', '     */\n', '    function getRequestQ() public view returns (uint256[51] memory) {\n', '        return requestQ;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows access to the uint variables saved in the apiUintVars under the requestDetails struct\n', '     * for the requestId specified\n', '     * @param _requestId to look up\n', '     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is\n', '     * the variables/strings used to save the data in the mapping. The variables names are\n', '     * commented out under the apiUintVars under the requestDetails struct\n', '     * @return uint value of the apiUintVars specified in _data for the requestId specified\n', '     */\n', '    function getRequestUintVars(uint256 _requestId, bytes32 _data)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return requestDetails[_requestId].apiUintVars[_data];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the API struct variables that are not mappings\n', '     * @param _requestId to look up\n', '     * @return uint of index in requestQ array\n', '     * @return uint of current payout/tip for this requestId\n', '     */\n', '    function getRequestVars(uint256 _requestId)\n', '        external\n', '        view\n', '        returns (uint256, uint256)\n', '    {\n', '        Request storage _request = requestDetails[_requestId];\n', '        return (\n', '            _request.apiUintVars[_REQUEST_Q_POSITION],\n', '            _request.apiUintVars[_TOTAL_TIP]\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev This function allows users to retrieve all information about a staker\n', '     * @param _staker address of staker inquiring about\n', '     * @return uint current state of staker\n', '     * @return uint startDate of staking\n', '     */\n', '    function getStakerInfo(address _staker)\n', '        external\n', '        view\n', '        returns (uint256, uint256)\n', '    {\n', '        return (\n', '            stakerDetails[_staker].currentStatus,\n', '            stakerDetails[_staker].startDate\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp\n', '     * @param _requestId to look up\n', '     * @param _timestamp is the timestamp to look up miners for\n', '     * @return address[5] array of 5 addresses of miners that mined the requestId\n', '     */\n', '    function getSubmissionsByTimestamp(uint256 _requestId, uint256 _timestamp)\n', '        external\n', '        view\n', '        returns (uint256[5] memory)\n', '    {\n', '        return requestDetails[_requestId].valuesByTimestamp[_timestamp];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the timestamp for the value based on their index\n', '     * @param _requestID is the requestId to look up\n', '     * @param _index is the value index to look up\n', '     * @return uint timestamp\n', '     */\n', '    function getTimestampbyRequestIDandIndex(uint256 _requestID, uint256 _index)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return requestDetails[_requestID].requestTimestamps[_index];\n', '    }\n', '\n', '    /**\n', '     * @dev Getter for the variables saved under the TellorStorageStruct uints variable\n', '     * @param _data the variable to pull from the mapping. _data = keccak256("variable_name")\n', '     * where variable_name is the variables/strings used to save the data in the mapping.\n', '     * The variables names in the TellorVariables contract\n', '     * @return uint of specified variable\n', '     */\n', '    function getUintVar(bytes32 _data) public view returns (uint256) {\n', '        return uints[_data];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp\n', '     * @param _requestId to look up\n', '     * @param _timestamp is the timestamp to look up miners for\n', '     * @return bool true if requestId/timestamp is under dispute\n', '     */\n', '    function isInDispute(uint256 _requestId, uint256 _timestamp)\n', '        external\n', '        view\n', '        returns (bool)\n', '    {\n', '        return requestDetails[_requestId].inDispute[_timestamp];\n', '    }\n', '\n', '    /**\n', '     * @dev Retrieve value from oracle based on timestamp\n', '     * @param _requestId being requested\n', '     * @param _timestamp to retrieve data/value from\n', '     * @return value for timestamp submitted\n', '     */\n', '    function retrieveData(uint256 _requestId, uint256 _timestamp)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return requestDetails[_requestId].finalValues[_timestamp];\n', '    }\n', '\n', '    /**\n', '     * @dev Getter for the total_supply of oracle tokens\n', '     * @return uint total supply\n', '     */\n', '    function totalSupply() external view returns (uint256) {\n', '        return uints[_TOTAL_SUPPLY];\n', '    }\n', '\n', '    /**\n', "     * @dev Allows users to access the token's name\n", '     */\n', '    function name() external pure returns (string memory) {\n', '        return "Tellor Tributes";\n', '    }\n', '\n', '    /**\n', "     * @dev Allows users to access the token's symbol\n", '     */\n', '    function symbol() external pure returns (string memory) {\n', '        return "TRB";\n', '    }\n', '\n', '    /**\n', '     * @dev Allows users to access the number of decimals\n', '     */\n', '    function decimals() external pure returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    /**\n', '     * @dev Getter function for the requestId being mined\n', '     * returns the currentChallenge, array of requestIDs, difficulty, and the current Tip of the 5 IDs\n', '     */\n', '    function getNewCurrentVariables()\n', '        external\n', '        view\n', '        returns (\n', '            bytes32 _challenge,\n', '            uint256[5] memory _requestIds,\n', '            uint256 _diff,\n', '            uint256 _tip\n', '        )\n', '    {\n', '        for (uint256 i = 0; i < 5; i++) {\n', '            _requestIds[i] = currentMiners[i].value;\n', '        }\n', '        return (\n', '            bytesVars[_CURRENT_CHALLENGE],\n', '            _requestIds,\n', '            uints[_DIFFICULTY],\n', '            uints[_CURRENT_TOTAL_TIPS]\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Getter function for next requestIds on queue/request with highest payouts at time the function is called\n', '     */\n', '    function getNewVariablesOnDeck()\n', '        external\n', '        view\n', '        returns (uint256[5] memory idsOnDeck, uint256[5] memory tipsOnDeck)\n', '    {\n', '        idsOnDeck = getTopRequestIDs();\n', '        for (uint256 i = 0; i < 5; i++) {\n', '            tipsOnDeck[i] = requestDetails[idsOnDeck[i]].apiUintVars[\n', '                _TOTAL_TIP\n', '            ];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Getter function for the top 5 requests with highest payouts. This function is used within the getNewVariablesOnDeck function\n', '     */\n', '    function getTopRequestIDs()\n', '        public\n', '        view\n', '        returns (uint256[5] memory _requestIds)\n', '    {\n', '        uint256[5] memory _max;\n', '        uint256[5] memory _index;\n', '        (_max, _index) = getMax5(requestQ);\n', '        for (uint256 i = 0; i < 5; i++) {\n', '            if (_max[i] != 0) {\n', '                _requestIds[i] = requestIdByRequestQIndex[_index[i]];\n', '            } else {\n', '                _requestIds[i] = currentMiners[4 - i].value;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.4;\n', '\n', '//Slightly modified SafeMath library - includes a min and max function, removes useless div function\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function add(int256 a, int256 b) internal pure returns (int256 c) {\n', '        if (b > 0) {\n', '            c = a + b;\n', '            assert(c >= a);\n', '        } else {\n', '            c = a + b;\n', '            assert(c <= a);\n', '        }\n', '    }\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a > b ? a : b;\n', '    }\n', '\n', '    function max(int256 a, int256 b) internal pure returns (uint256) {\n', '        return a > b ? uint256(a) : uint256(b);\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function sub(int256 a, int256 b) internal pure returns (int256 c) {\n', '        if (b > 0) {\n', '            c = a - b;\n', '            assert(c <= a);\n', '        } else {\n', '            c = a - b;\n', '            assert(c >= a);\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.4;\n', '\n', '/**\n', ' * @title Tellor Oracle Storage Library\n', ' * @dev Contains all the variables/structs used by Tellor\n', ' */\n', '\n', 'contract TellorStorage {\n', '    //Internal struct for use in proof-of-work submission\n', '    struct Details {\n', '        uint256 value;\n', '        address miner;\n', '    }\n', '\n', '    struct Dispute {\n', '        bytes32 hash; //unique hash of dispute: keccak256(_miner,_requestId,_timestamp)\n', '        int256 tally; //current tally of votes for - against measure\n', '        bool executed; //is the dispute settled\n', '        bool disputeVotePassed; //did the vote pass?\n', '        bool isPropFork; //true for fork proposal NEW\n', "        address reportedMiner; //miner who submitted the 'bad value' will get disputeFee if dispute vote fails\n", "        address reportingParty; //miner reporting the 'bad value'-pay disputeFee will get reportedMiner's stake if dispute vote passes\n", '        address proposedForkAddress; //new fork address (if fork proposal)\n', '        mapping(bytes32 => uint256) disputeUintVars;\n', '        //Each of the variables below is saved in the mapping disputeUintVars for each disputeID\n', '        //e.g. TellorStorageStruct.DisputeById[disputeID].disputeUintVars[keccak256("requestId")]\n', '        //These are the variables saved in this mapping:\n', '        // uint keccak256("requestId");//apiID of disputed value\n', '        // uint keccak256("timestamp");//timestamp of disputed value\n', '        // uint keccak256("value"); //the value being disputed\n', '        // uint keccak256("minExecutionDate");//7 days from when dispute initialized\n', '        // uint keccak256("numberOfVotes");//the number of parties who have voted on the measure\n', '        // uint keccak256("blockNumber");// the blocknumber for which votes will be calculated from\n', '        // uint keccak256("minerSlot"); //index in dispute array\n', '        // uint keccak256("fee"); //fee paid corresponding to dispute\n', '        mapping(address => bool) voted; //mapping of address to whether or not they voted\n', '    }\n', '\n', '    struct StakeInfo {\n', '        uint256 currentStatus; //0-not Staked, 1=Staked, 2=LockedForWithdraw 3= OnDispute 4=ReadyForUnlocking 5=Unlocked\n', '        uint256 startDate; //stake start date\n', '    }\n', '\n', '    //Internal struct to allow balances to be queried by blocknumber for voting purposes\n', '    struct Checkpoint {\n', '        uint128 fromBlock; // fromBlock is the block number that the value was generated from\n', '        uint128 value; // value is the amount of tokens at a specific block number\n', '    }\n', '\n', '    struct Request {\n', '        uint256[] requestTimestamps; //array of all newValueTimestamps requested\n', '        mapping(bytes32 => uint256) apiUintVars;\n', '        //Each of the variables below is saved in the mapping apiUintVars for each api request\n', '        //e.g. requestDetails[_requestId].apiUintVars[keccak256("totalTip")]\n', '        //These are the variables saved in this mapping:\n', '        // uint keccak256("requestQPosition"); //index in requestQ\n', '        // uint keccak256("totalTip");//bonus portion of payout\n', '        mapping(uint256 => uint256) minedBlockNum; //[apiId][minedTimestamp]=>block.number\n', '        //This the time series of finalValues stored by the contract where uint UNIX timestamp is mapped to value\n', '        mapping(uint256 => uint256) finalValues;\n', '        mapping(uint256 => bool) inDispute; //checks if API id is in dispute or finalized.\n', '        mapping(uint256 => address[5]) minersByValue;\n', '        mapping(uint256 => uint256[5]) valuesByTimestamp;\n', '    }\n', '\n', '    uint256[51] requestQ; //uint50 array of the top50 requests by payment amount\n', '    uint256[] public newValueTimestamps; //array of all timestamps requested\n', '    //Address fields in the Tellor contract are saved the addressVars mapping\n', '    //e.g. addressVars[keccak256("tellorContract")] = address\n', '    //These are the variables saved in this mapping:\n', '    // address keccak256("tellorContract");//Tellor address\n', '    // address  keccak256("_owner");//Tellor Owner address\n', '    // address  keccak256("_deity");//Tellor Owner that can do things at will\n', '    // address  keccak256("pending_owner"); // The proposed new owner\n', '    //uint fields in the Tellor contract are saved the uintVars mapping\n', '    //e.g. uintVars[keccak256("decimals")] = uint\n', '    //These are the variables saved in this mapping:\n', '    // keccak256("decimals");    //18 decimal standard ERC20\n', '    // keccak256("disputeFee");//cost to dispute a mined value\n', '    // keccak256("disputeCount");//totalHistoricalDisputes\n', '    // keccak256("total_supply"); //total_supply of the token in circulation\n', '    // keccak256("stakeAmount");//stakeAmount for miners (we can cut gas if we just hardcoded it in...or should it be variable?)\n', '    // keccak256("stakerCount"); //number of parties currently staked\n', '    // keccak256("timeOfLastNewValue"); // time of last challenge solved\n', '    // keccak256("difficulty"); // Difficulty of current block\n', '    // keccak256("currentTotalTips"); //value of highest api/timestamp PayoutPool\n', '    // keccak256("currentRequestId"); //API being mined--updates with the ApiOnQ Id\n', '    // keccak256("requestCount"); // total number of requests through the system\n', '    // keccak256("slotProgress");//Number of miners who have mined this value so far\n', '    // keccak256("miningReward");//Mining Reward in PoWo tokens given to all miners per value\n', '    // keccak256("timeTarget"); //The time between blocks (mined Oracle values)\n', '    // keccak256("_tblock"); //\n', '    // keccak256("runningTips"); // VAriable to track running tips\n', '    // keccak256("currentReward"); // The current reward\n', '    // keccak256("devShare"); // The amount directed towards th devShare\n', '    // keccak256("currentTotalTips"); //\n', '\n', '    //This is a boolean that tells you if a given challenge has been completed by a given miner\n', '    mapping(uint256 => uint256) requestIdByTimestamp; //minedTimestamp to apiId\n', '    mapping(uint256 => uint256) requestIdByRequestQIndex; //link from payoutPoolIndex (position in payout pool array) to apiId\n', '    mapping(uint256 => Dispute) public disputesById; //disputeId=> Dispute details\n', '    mapping(bytes32 => uint256) public requestIdByQueryHash; // api bytes32 gets an id = to count of requests array\n', '    mapping(bytes32 => uint256) public disputeIdByDisputeHash; //maps a hash to an ID for each dispute\n', '    mapping(bytes32 => mapping(address => bool)) public minersByChallenge;\n', '    Details[5] public currentMiners; //This struct is for organizing the five mined values to find the median\n', '    mapping(address => StakeInfo) stakerDetails; //mapping from a persons address to their staking info\n', '    mapping(uint256 => Request) requestDetails;\n', '\n', '    mapping(bytes32 => uint256) public uints;\n', '    mapping(bytes32 => address) public addresses;\n', '    mapping(bytes32 => bytes32) public bytesVars;\n', '\n', '    //ERC20 storage\n', '    mapping(address => Checkpoint[]) public balances;\n', '    mapping(address => mapping(address => uint256)) public _allowances;\n', '\n', '    //Migration storage\n', '    mapping(address => bool) public migrated;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.4;\n', '\n', '// Helper contract to store hashes of variables\n', 'contract TellorVariables {\n', '    bytes32 constant _BLOCK_NUMBER =\n', '        0x4b4cefd5ced7569ef0d091282b4bca9c52a034c56471a6061afd1bf307a2de7c; //keccak256("_BLOCK_NUMBER");\n', '    bytes32 constant _CURRENT_CHALLENGE =\n', '        0xd54702836c9d21d0727ffacc3e39f57c92b5ae0f50177e593bfb5ec66e3de280; //keccak256("_CURRENT_CHALLENGE");\n', '    bytes32 constant _CURRENT_REQUESTID =\n', '        0xf5126bb0ac211fbeeac2c0e89d4c02ac8cadb2da1cfb27b53c6c1f4587b48020; //keccak256("_CURRENT_REQUESTID");\n', '    bytes32 constant _CURRENT_REWARD =\n', '        0xd415862fd27fb74541e0f6f725b0c0d5b5fa1f22367d9b78ec6f61d97d05d5f8; //keccak256("_CURRENT_REWARD");\n', '    bytes32 constant _CURRENT_TOTAL_TIPS =\n', '        0x09659d32f99e50ac728058418d38174fe83a137c455ff1847e6fb8e15f78f77a; //keccak256("_CURRENT_TOTAL_TIPS");\n', '    bytes32 constant _DEITY =\n', '        0x5fc094d10c65bc33cc842217b2eccca0191ff24148319da094e540a559898961; //keccak256("_DEITY");\n', '    bytes32 constant _DIFFICULTY =\n', '        0xf758978fc1647996a3d9992f611883adc442931dc49488312360acc90601759b; //keccak256("_DIFFICULTY");\n', '    bytes32 constant _DISPUTE_COUNT =\n', '        0x310199159a20c50879ffb440b45802138b5b162ec9426720e9dd3ee8bbcdb9d7; //keccak256("_DISPUTE_COUNT");\n', '    bytes32 constant _DISPUTE_FEE =\n', '        0x675d2171f68d6f5545d54fb9b1fb61a0e6897e6188ca1cd664e7c9530d91ecfc; //keccak256("_DISPUTE_FEE");\n', '    bytes32 constant _DISPUTE_ROUNDS =\n', '        0x6ab2b18aafe78fd59c6a4092015bddd9fcacb8170f72b299074f74d76a91a923; //keccak256("_DISPUTE_ROUNDS");\n', '    bytes32 constant _FEE =\n', '        0x1da95f11543c9b03927178e07951795dfc95c7501a9d1cf00e13414ca33bc409; //keccak256("FEE");\n', '    bytes32 constant _MIN_EXECUTION_DATE =\n', '        0x46f7d53798d31923f6952572c6a19ad2d1a8238d26649c2f3493a6d69e425d28; //keccak256("_MIN_EXECUTION_DATE");\n', '    bytes32 constant _MINER_SLOT =\n', '        0x6de96ee4d33a0617f40a846309c8759048857f51b9d59a12d3c3786d4778883d; //keccak256("_MINER_SLOT");\n', '    bytes32 constant _NUM_OF_VOTES =\n', '        0x1da378694063870452ce03b189f48e04c1aa026348e74e6c86e10738514ad2c4; //keccak256("_NUM_OF_VOTES");\n', '    bytes32 constant _OLD_TELLOR =\n', '        0x56e0987db9eaec01ed9e0af003a0fd5c062371f9d23722eb4a3ebc74f16ea371; //keccak256("_OLD_TELLOR");\n', '    bytes32 constant _ORIGINAL_ID =\n', '        0xed92b4c1e0a9e559a31171d487ecbec963526662038ecfa3a71160bd62fb8733; //keccak256("_ORIGINAL_ID");\n', '    bytes32 constant _OWNER =\n', '        0x7a39905194de50bde334d18b76bbb36dddd11641d4d50b470cb837cf3bae5def; //keccak256("_OWNER");\n', '    bytes32 constant _PAID =\n', '        0x29169706298d2b6df50a532e958b56426de1465348b93650fca42d456eaec5fc; //keccak256("_PAID");\n', '    bytes32 constant _PENDING_OWNER =\n', '        0x7ec081f029b8ac7e2321f6ae8c6a6a517fda8fcbf63cabd63dfffaeaafa56cc0; //keccak256("_PENDING_OWNER");\n', '    bytes32 constant _REQUEST_COUNT =\n', '        0x3f8b5616fa9e7f2ce4a868fde15c58b92e77bc1acd6769bf1567629a3dc4c865; //keccak256("_REQUEST_COUNT");\n', '    bytes32 constant _REQUEST_ID =\n', '        0x9f47a2659c3d32b749ae717d975e7962959890862423c4318cf86e4ec220291f; //keccak256("_REQUEST_ID");\n', '    bytes32 constant _REQUEST_Q_POSITION =\n', '        0xf68d680ab3160f1aa5d9c3a1383c49e3e60bf3c0c031245cbb036f5ce99afaa1; //keccak256("_REQUEST_Q_POSITION");\n', '    bytes32 constant _SLOT_PROGRESS =\n', '        0xdfbec46864bc123768f0d134913175d9577a55bb71b9b2595fda21e21f36b082; //keccak256("_SLOT_PROGRESS");\n', '    bytes32 constant _STAKE_AMOUNT =\n', '        0x5d9fadfc729fd027e395e5157ef1b53ef9fa4a8f053043c5f159307543e7cc97; //keccak256("_STAKE_AMOUNT");\n', '    bytes32 constant _STAKE_COUNT =\n', '        0x10c168823622203e4057b65015ff4d95b4c650b308918e8c92dc32ab5a0a034b; //keccak256("_STAKE_COUNT");\n', '    bytes32 constant _T_BLOCK =\n', '        0xf3b93531fa65b3a18680d9ea49df06d96fbd883c4889dc7db866f8b131602dfb; //keccak256("_T_BLOCK");\n', '    bytes32 constant _TALLY_DATE =\n', '        0xf9e1ae10923bfc79f52e309baf8c7699edb821f91ef5b5bd07be29545917b3a6; //keccak256("_TALLY_DATE");\n', '    bytes32 constant _TARGET_MINERS =\n', '        0x0b8561044b4253c8df1d9ad9f9ce2e0f78e4bd42b2ed8dd2e909e85f750f3bc1; //keccak256("_TARGET_MINERS");\n', '    bytes32 constant _TELLOR_CONTRACT =\n', '        0x0f1293c916694ac6af4daa2f866f0448d0c2ce8847074a7896d397c961914a08; //keccak256("_TELLOR_CONTRACT");\n', '    bytes32 constant _TELLOR_GETTERS =\n', '        0xabd9bea65759494fe86471c8386762f989e1f2e778949e94efa4a9d1c4b3545a; //keccak256("_TELLOR_GETTERS");\n', '    bytes32 constant _TIME_OF_LAST_NEW_VALUE =\n', '        0x2c8b528fbaf48aaf13162a5a0519a7ad5a612da8ff8783465c17e076660a59f1; //keccak256("_TIME_OF_LAST_NEW_VALUE");\n', '    bytes32 constant _TIME_TARGET =\n', '        0xd4f87b8d0f3d3b7e665df74631f6100b2695daa0e30e40eeac02172e15a999e1; //keccak256("_TIME_TARGET");\n', '    bytes32 constant _TIMESTAMP =\n', '        0x2f9328a9c75282bec25bb04befad06926366736e0030c985108445fa728335e5; //keccak256("_TIMESTAMP");\n', '    bytes32 constant _TOTAL_SUPPLY =\n', '        0xe6148e7230ca038d456350e69a91b66968b222bfac9ebfbea6ff0a1fb7380160; //keccak256("_TOTAL_SUPPLY");\n', '    bytes32 constant _TOTAL_TIP =\n', '        0x1590276b7f31dd8e2a06f9a92867333eeb3eddbc91e73b9833e3e55d8e34f77d; //keccak256("_TOTAL_TIP");\n', '    bytes32 constant _VALUE =\n', '        0x9147231ab14efb72c38117f68521ddef8de64f092c18c69dbfb602ffc4de7f47; //keccak256("_VALUE");\n', '    bytes32 constant _EIP_SLOT =\n', '        0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.4;\n', '\n', '//Functions for retrieving min and Max in 51 length array (requestQ)\n', '//Taken partly from: https://github.com/modular-network/ethereum-libraries-array-utils/blob/master/contracts/Array256Lib.sol\n', '\n', 'contract Utilities {\n', '    /**\n', '     * @dev This is an internal function called by updateOnDeck that gets the top 5 values\n', '     * @param data is an array [51] to determine the top 5 values from\n', '     * @return max the top 5 values and their index values in the data array\n', '     */\n', '    function getMax5(uint256[51] memory data)\n', '        public\n', '        view\n', '        returns (uint256[5] memory max, uint256[5] memory maxIndex)\n', '    {\n', '        uint256 min5 = data[1];\n', '        uint256 minI = 0;\n', '        for (uint256 j = 0; j < 5; j++) {\n', '            max[j] = data[j + 1]; //max[0]=data[1]\n', '            maxIndex[j] = j + 1; //maxIndex[0]= 1\n', '            if (max[j] < min5) {\n', '                min5 = max[j];\n', '                minI = j;\n', '            }\n', '        }\n', '        for (uint256 i = 6; i < data.length; i++) {\n', '            if (data[i] > min5) {\n', '                max[minI] = data[i];\n', '                maxIndex[minI] = i;\n', '                min5 = data[i];\n', '                for (uint256 j = 0; j < 5; j++) {\n', '                    if (max[j] < min5) {\n', '                        min5 = max[j];\n', '                        minI = j;\n', '                    }\n', '                }\n', '            }\n', '        }\n', '    }\n', '}']