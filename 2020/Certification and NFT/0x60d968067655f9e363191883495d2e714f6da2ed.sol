['/**\n', ' *  @authors: [@mtsalenc]\n', ' *  @reviewers: []\n', ' *  @auditors: []\n', ' *  @bounties: []\n', ' *  @deployments: []\n', ' */\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', 'interface IArbitrableTCR {\n', '\n', '    enum Party {\n', '        None,      // Party per default when there is no challenger or requester. Also used for unconclusive ruling.\n', '        Requester, // Party that made the request to change an address status.\n', '        Challenger // Party that challenges the request to change an address status.\n', '    }\n', '\n', '    function governor() external view returns(address);\n', '    function arbitrator() external view returns(address);\n', '    function arbitratorExtraData() external view returns(bytes memory);\n', '    function requesterBaseDeposit() external view returns(uint);\n', '    function challengerBaseDeposit() external view returns(uint);\n', '    function challengePeriodDuration() external view returns(uint);\n', '    function metaEvidenceUpdates() external view returns(uint);\n', '    function winnerStakeMultiplier() external view returns(uint);\n', '    function loserStakeMultiplier() external view returns(uint);\n', '    function sharedStakeMultiplier() external view returns(uint);\n', '    function MULTIPLIER_DIVISOR() external view returns(uint);\n', '    function countByStatus()\n', '        external\n', '        view\n', '        returns(\n', '            uint absent,\n', '            uint registered,\n', '            uint registrationRequest,\n', '            uint clearingRequest,\n', '            uint challengedRegistrationRequest,\n', '            uint challengedClearingRequest\n', '        );\n', '}\n', '\n', 'interface IArbitrableAddressTCR {\n', '    enum AddressStatus {\n', '        Absent, // The address is not in the registry.\n', '        Registered, // The address is in the registry.\n', '        RegistrationRequested, // The address has a request to be added to the registry.\n', '        ClearingRequested // The address has a request to be removed from the registry.\n', '    }\n', '\n', '    function addressCount() external view returns(uint);\n', '    function addressList(uint index) external view returns(address);\n', '    function getAddressInfo(address _address)\n', '        external\n', '        view\n', '        returns (\n', '            AddressStatus status,\n', '            uint numberOfRequests\n', '        );\n', '\n', '    function getRequestInfo(address _address, uint _request)\n', '        external\n', '        view\n', '        returns (\n', '            bool disputed,\n', '            uint disputeID,\n', '            uint submissionTime,\n', '            bool resolved,\n', '            address[3] memory parties,\n', '            uint numberOfRounds,\n', '            IArbitrableTCR.Party ruling,\n', '            address arbitrator,\n', '            bytes memory arbitratorExtraData\n', '        );\n', '\n', '    function getRoundInfo(address _address, uint _request, uint _round)\n', '        external\n', '        view\n', '        returns (\n', '            bool appealed,\n', '            uint[3] memory paidFees,\n', '            bool[3] memory hasPaid,\n', '            uint feeRewards\n', '        );\n', '}\n', '\n', 'interface IArbitrableTokenTCR {\n', '\n', '    enum TokenStatus {\n', '        Absent, // The address is not in the registry.\n', '        Registered, // The address is in the registry.\n', '        RegistrationRequested, // The address has a request to be added to the registry.\n', '        ClearingRequested // The address has a request to be removed from the registry.\n', '    }\n', '\n', '    function tokenCount() external view returns(uint);\n', '    function tokensList(uint index) external view returns(bytes32);\n', '    function getTokenInfo(bytes32 _tokenID)\n', '        external\n', '        view\n', '        returns (\n', '            string memory name,\n', '            string memory ticker,\n', '            address addr,\n', '            string memory symbolMultihash,\n', '            TokenStatus status,\n', '            uint numberOfRequests\n', '        );\n', '\n', '    function getRequestInfo(bytes32 _tokenID, uint _request)\n', '        external\n', '        view\n', '        returns (\n', '            bool disputed,\n', '            uint disputeID,\n', '            uint submissionTime,\n', '            bool resolved,\n', '            address[3] memory parties,\n', '            uint numberOfRounds,\n', '            IArbitrableTCR.Party ruling,\n', '            address arbitrator,\n', '            bytes memory arbitratorExtraData\n', '        );\n', '\n', '    function getRoundInfo(bytes32 _tokenID, uint _request, uint _round)\n', '        external\n', '        view\n', '        returns (\n', '            bool appealed,\n', '            uint[3] memory paidFees,\n', '            bool[3] memory hasPaid,\n', '            uint feeRewards\n', '        );\n', '\n', '    function addressToSubmissions(address _addr, uint _index) external view returns (bytes32);\n', '}\n', '\n', 'interface IArbitrator {\n', '    enum DisputeStatus {Waiting, Appealable, Solved}\n', '\n', '    function createDispute(uint _choices, bytes calldata _extraData) external payable returns(uint disputeID);\n', '    function arbitrationCost(bytes calldata _extraData) external view returns(uint cost);\n', '    function appeal(uint _disputeID, bytes calldata _extraData) external payable;\n', '    function appealCost(uint _disputeID, bytes calldata _extraData) external view returns(uint cost);\n', '    function appealPeriod(uint _disputeID) external view returns(uint start, uint end);\n', '    function disputeStatus(uint _disputeID) external view returns(DisputeStatus status);\n', '    function currentRuling(uint _disputeID) external view returns(uint ruling);\n', '}\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'contract ArbitrableTCRViewV2 {\n', '\n', '    struct CountByStatus {\n', '        uint absent;\n', '        uint registered;\n', '        uint registrationRequest;\n', '        uint clearingRequest;\n', '        uint challengedRegistrationRequest;\n', '        uint challengedClearingRequest;\n', '    }\n', '\n', '    struct ArbitrableTCRData {\n', '        address governor;\n', '        address arbitrator;\n', '        bytes arbitratorExtraData;\n', '        uint requesterBaseDeposit;\n', '        uint challengerBaseDeposit;\n', '        uint challengePeriodDuration;\n', '        uint metaEvidenceUpdates;\n', '        uint winnerStakeMultiplier;\n', '        uint loserStakeMultiplier;\n', '        uint sharedStakeMultiplier;\n', '        uint MULTIPLIER_DIVISOR;\n', '        CountByStatus countByStatus;\n', '        uint arbitrationCost;\n', '    }\n', '\n', '    struct Token {\n', '        bytes32 ID;\n', '        string name;\n', '        string ticker;\n', '        address addr;\n', '        string symbolMultihash;\n', '        IArbitrableTokenTCR.TokenStatus status;\n', '        uint decimals;\n', '    }\n', '\n', '    // Some arrays below have 3 elements to map with the Party enums for better readability:\n', '    // - 0: is unused, matches `Party.None`.\n', '    // - 1: for `Party.Requester`.\n', '    // - 2: for `Party.Challenger`.\n', '    struct Request {\n', '        bool disputed;\n', '        uint disputeID;\n', '        uint submissionTime;\n', '        bool resolved;\n', '        address[3] parties;\n', '        uint numberOfRounds;\n', '        IArbitrableTCR.Party ruling;\n', '        address arbitrator;\n', '        bytes arbitratorExtraData;\n', '        IArbitrator.DisputeStatus disputeStatus;\n', '        uint currentRuling;\n', '        uint appealCost;\n', '        uint[3] requiredForSide;\n', '        uint[2] appealPeriod;\n', '    }\n', '\n', '    struct Round {\n', '        uint[3] paidFees; // Tracks the fees paid by each side on this round.\n', '        bool[3] hasPaid; // True when the side has fully paid its fee. False otherwise.\n', '        uint feeRewards; // Sum of reimbursable fees and stake rewards available to the parties that made contributions to the side that ultimately wins a dispute.\n', '    }\n', '\n', '    struct AppealableToken {\n', '        uint disputeID;\n', '        address arbitrator;\n', '        bytes32 tokenID;\n', '        bool inAppealPeriod;\n', '    }\n', '\n', '    struct AppealableAddress {\n', '        uint disputeID;\n', '        address arbitrator;\n', '        address addr;\n', '        bool inAppealPeriod;\n', '    }\n', '\n', '    /** @dev Fetch arbitrable TCR data in a single call.\n', '     *  @param _address The address of the Generalized TCR to query.\n', '     *  @return The latest data on an arbitrable TCR contract.\n', '     */\n', '    function fetchArbitrable(address _address) public view returns (ArbitrableTCRData memory result) {\n', '        IArbitrableTCR tcr = IArbitrableTCR(_address);\n', '        result.governor = tcr.governor();\n', '        result.arbitrator = tcr.arbitrator();\n', '        result.arbitratorExtraData = tcr.arbitratorExtraData();\n', '        result.requesterBaseDeposit = tcr.requesterBaseDeposit();\n', '        result.challengerBaseDeposit = tcr.challengerBaseDeposit();\n', '        result.challengePeriodDuration = tcr.challengePeriodDuration();\n', '        result.metaEvidenceUpdates = tcr.metaEvidenceUpdates();\n', '        result.winnerStakeMultiplier = tcr.winnerStakeMultiplier();\n', '        result.loserStakeMultiplier = tcr.loserStakeMultiplier();\n', '        result.sharedStakeMultiplier = tcr.sharedStakeMultiplier();\n', '        result.MULTIPLIER_DIVISOR = tcr.MULTIPLIER_DIVISOR();\n', '\n', '        {\n', '            (\n', '                uint absent,\n', '                uint registered,\n', '                uint registrationRequest,\n', '                uint clearingRequest,\n', '                uint challengedRegistrationRequest,\n', '                uint challengedClearingRequest\n', '            ) = tcr.countByStatus();\n', '            result.countByStatus = CountByStatus({\n', '                absent: absent,\n', '                registered: registered,\n', '                registrationRequest: registrationRequest,\n', '                clearingRequest: clearingRequest,\n', '                challengedRegistrationRequest: challengedRegistrationRequest,\n', '                challengedClearingRequest: challengedClearingRequest\n', '            });\n', '        }\n', '\n', '        IArbitrator arbitrator = IArbitrator(result.arbitrator);\n', '        result.arbitrationCost = arbitrator.arbitrationCost(result.arbitratorExtraData);\n', '    }\n', '\n', '    function fetchAppealableAddresses(address _addressTCR, uint _cursor, uint _count) external view returns (AppealableAddress[] memory results) {\n', '        IArbitrableAddressTCR tcr = IArbitrableAddressTCR(_addressTCR);\n', '        results = new AppealableAddress[]( tcr.addressCount() < _count ?  tcr.addressCount() : _count);\n', '\n', '        for (uint i = _cursor; i < tcr.addressCount() && _count - i > 0; i++) {\n', '            address itemAddr = tcr.addressList(i);\n', '            (\n', '                IArbitrableAddressTCR.AddressStatus status,\n', '                uint numberOfRequests\n', '            ) = tcr.getAddressInfo(itemAddr);\n', '\n', '            if (status == IArbitrableAddressTCR.AddressStatus.Absent || status == IArbitrableAddressTCR.AddressStatus.Registered) continue;\n', '\n', '            // Using arrays to get around stack limit.\n', '            bool[] memory disputedResolved = new bool[](2);\n', '            uint[] memory disputeIDNumberOfRounds = new uint[](2);\n', '            address arbitrator;\n', '            (\n', '                disputedResolved[0],\n', '                disputeIDNumberOfRounds[0],\n', '                ,\n', '                disputedResolved[1],\n', '                ,\n', '                disputeIDNumberOfRounds[1],\n', '                ,\n', '                arbitrator,\n', '            ) = tcr.getRequestInfo(itemAddr, numberOfRequests - 1);\n', '\n', '            if (!disputedResolved[0] || disputedResolved[1]) continue;\n', '\n', '            IArbitrator arbitratorContract = IArbitrator(arbitrator);\n', '            uint[] memory appealPeriod = new uint[](2);\n', '            (appealPeriod[0], appealPeriod[1]) = arbitratorContract.appealPeriod(disputeIDNumberOfRounds[0]);\n', '            if (appealPeriod[0] > 0 && appealPeriod[1] > 0) {\n', '                results[i] = AppealableAddress({\n', '                    disputeID: disputeIDNumberOfRounds[0],\n', '                    arbitrator: arbitrator,\n', '                    addr: itemAddr,\n', '                    inAppealPeriod: now < appealPeriod[1]\n', '                });\n', '\n', '                // If the arbitrator gave a decisive ruling (i.e. did not rule for Party.None)\n', '                // we must check if the loser fully funded and the dispute is in the second half\n', '                // of the appeal period. If the dispute is in the second half, and the loser is not\n', '                // funded the appeal period is over.\n', '                IArbitrableTCR.Party currentRuling = IArbitrableTCR.Party(arbitratorContract.currentRuling(disputeIDNumberOfRounds[0]));\n', '                if (\n', '                    currentRuling != IArbitrableTCR.Party.None &&\n', '                    now > (appealPeriod[1] - appealPeriod[0]) / 2 + appealPeriod[0]\n', '                ) {\n', '                    IArbitrableTCR.Party loser = currentRuling == IArbitrableTCR.Party.Requester\n', '                        ? IArbitrableTCR.Party.Challenger\n', '                        : IArbitrableTCR.Party.Requester;\n', '\n', '                    (\n', '                        ,\n', '                        ,\n', '                        bool[3] memory hasPaid,\n', '                    ) = tcr.getRoundInfo(itemAddr, numberOfRequests - 1, disputeIDNumberOfRounds[1] - 1);\n', '\n', '                    if(!hasPaid[uint(loser)]) results[i].inAppealPeriod = false;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function fetchAppealableToken(address _addressTCR, uint _cursor, uint _count) external view returns (AppealableToken[] memory results) {\n', '        IArbitrableTokenTCR tcr = IArbitrableTokenTCR(_addressTCR);\n', '        results = new AppealableToken[](tcr.tokenCount() < _count ? tcr.tokenCount() : _count);\n', '\n', '        for (uint i = _cursor; i < tcr.tokenCount() && _count - i > 0; i++) {\n', '            bytes32 tokenID = tcr.tokensList(i);\n', '            (\n', '                ,\n', '                ,\n', '                ,\n', '                ,\n', '                IArbitrableTokenTCR.TokenStatus status,\n', '                uint numberOfRequests\n', '            ) = tcr.getTokenInfo(tokenID);\n', '\n', '            if (status == IArbitrableTokenTCR.TokenStatus.Absent || status == IArbitrableTokenTCR.TokenStatus.Registered) continue;\n', '\n', '            // Using arrays to get around stack limit.\n', '            bool[] memory disputedResolved = new bool[](2);\n', '            uint[] memory disputeIDNumberOfRounds = new uint[](2);\n', '            address arbitrator;\n', '            (\n', '                disputedResolved[0],\n', '                disputeIDNumberOfRounds[0],\n', '                ,\n', '                disputedResolved[1],\n', '                ,\n', '                disputeIDNumberOfRounds[1],\n', '                ,\n', '                arbitrator,\n', '            ) = tcr.getRequestInfo(tokenID, numberOfRequests - 1);\n', '\n', '            if (!disputedResolved[0] || disputedResolved[1]) continue;\n', '\n', '            IArbitrator arbitratorContract = IArbitrator(arbitrator);\n', '            uint[] memory appealPeriod = new uint[](2);\n', '            (appealPeriod[0], appealPeriod[1]) = arbitratorContract.appealPeriod(disputeIDNumberOfRounds[0]);\n', '            if (appealPeriod[0] > 0 && appealPeriod[1] > 0) {\n', '                results[i] = AppealableToken({\n', '                    disputeID: disputeIDNumberOfRounds[0],\n', '                    arbitrator: arbitrator,\n', '                    tokenID: tokenID,\n', '                    inAppealPeriod: now < appealPeriod[1]\n', '                });\n', '\n', '                // If the arbitrator gave a decisive ruling (i.e. did not rule for Party.None)\n', '                // we must check if the loser fully funded and the dispute is in the second half\n', '                // of the appeal period. If the dispute is in the second half, and the loser is not\n', '                // funded the appeal period is over.\n', '                IArbitrableTCR.Party currentRuling = IArbitrableTCR.Party(arbitratorContract.currentRuling(disputeIDNumberOfRounds[0]));\n', '                if (\n', '                    currentRuling != IArbitrableTCR.Party.None &&\n', '                    now > (appealPeriod[1] - appealPeriod[0]) / 2 + appealPeriod[0]\n', '                ) {\n', '                    IArbitrableTCR.Party loser = currentRuling == IArbitrableTCR.Party.Requester\n', '                        ? IArbitrableTCR.Party.Challenger\n', '                        : IArbitrableTCR.Party.Requester;\n', '\n', '                    (\n', '                        ,\n', '                        ,\n', '                        bool[3] memory hasPaid,\n', '                    ) = tcr.getRoundInfo(tokenID, numberOfRequests - 1, disputeIDNumberOfRounds[1] - 1);\n', '\n', '                    if(!hasPaid[uint(loser)]) results[i].inAppealPeriod = false;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    /** @dev Fetch token IDs of the first tokens present on the tcr for the addresses.\n', '     *  @param _t2crAddress The address of the t2cr contract from where to fetch token information.\n', '     *  @param _tokenAddresses The address of each token.\n', '     */\n', '    function getTokensIDsForAddresses(\n', '        address _t2crAddress,\n', '        address[] calldata _tokenAddresses\n', '    ) external view returns (bytes32[] memory result) {\n', '        IArbitrableTokenTCR t2cr = IArbitrableTokenTCR(_t2crAddress);\n', '        result = new bytes32[](_tokenAddresses.length);\n', '        for (uint i = 0; i < _tokenAddresses.length;  i++){\n', '            // Count how many submissions were made for an address.\n', '            address tokenAddr = _tokenAddresses[i];\n', '            bool counting = true;\n', '            bytes4 sig = bytes4(keccak256("addressToSubmissions(address,uint256)"));\n', '            uint submissions = 0;\n', '            while(counting) {\n', '                assembly {\n', '                    let x := mload(0x40)   // Find empty storage location using "free memory pointer"\n', '                    mstore(x, sig)         // Set the signature to the first call parameter.\n', '                    mstore(add(x, 0x04), tokenAddr)\n', '                    mstore(add(x, 0x24), submissions)\n', '                    counting := staticcall( // `counting` will be set to false if the call reverts (which will happen if we reached the end of the array.)\n', '                        30000,              // 30k gas\n', '                        _t2crAddress,       // The call target.\n', '                        x,                  // Inputs are stored at location x\n', '                        0x44,               // Input is 44 bytes long (signature (4B) + address (20B) + index(20B))\n', '                        x,                  // Overwrite x with output\n', '                        0x20                // The output length\n', '                    )\n', '                }\n', '\n', '                if (counting) {\n', '                    submissions++;\n', '                }\n', '            }\n', '\n', '            // Search for the oldest submission currently in the registry.\n', '            for(uint j = 0; j < submissions; j++) {\n', '                bytes32 tokenID = t2cr.addressToSubmissions(tokenAddr, j);\n', '                (,,,,IArbitrableTokenTCR.TokenStatus status,) = t2cr.getTokenInfo(tokenID);\n', '                if (status == IArbitrableTokenTCR.TokenStatus.Registered || status == IArbitrableTokenTCR.TokenStatus.ClearingRequested)\n', '                {\n', '                    result[i] = tokenID;\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    /** @dev Fetch token information with token IDs. If a token contract does not implement the decimals() function, its decimals field will be 0.\n', '     *  @param _t2crAddress The address of the t2cr contract from where to fetch token information.\n', '     *  @param _tokenIDs The IDs of the tokens we want to query.\n', '     *  @return tokens The tokens information.\n', '     */\n', '    function getTokens(address _t2crAddress, bytes32[] calldata _tokenIDs)\n', '        external\n', '        view\n', '        returns (Token[] memory tokens)\n', '    {\n', '        IArbitrableTokenTCR t2cr = IArbitrableTokenTCR(_t2crAddress);\n', '        tokens = new Token[](_tokenIDs.length);\n', '        for (uint i = 0; i < _tokenIDs.length ; i++){\n', '            string[] memory strings = new string[](3); // name, ticker and symbolMultihash respectively.\n', '            address tokenAddress;\n', '            IArbitrableTokenTCR.TokenStatus status;\n', '            (\n', '                strings[0],\n', '                strings[1],\n', '                tokenAddress,\n', '                strings[2],\n', '                status,\n', '            ) = t2cr.getTokenInfo(_tokenIDs[i]);\n', '\n', '            tokens[i] = Token(\n', '                _tokenIDs[i],\n', '                strings[0],\n', '                strings[1],\n', '                tokenAddress,\n', '                strings[2],\n', '                status,\n', '                0\n', '            );\n', '\n', "            // Call the contract's decimals() function without reverting when\n", '            // the contract does not implement it.\n', '            //\n', '            // Two things should be noted: if the contract does not implement the function\n', '            // and does not implement the contract fallback function, `success` will be set to\n', "            // false and decimals won't be set. However, in some cases (such as old contracts)\n", '            // the fallback function is implemented, and so staticcall will return true\n', '            // even though the value returned will not be correct (the number below):\n', '            //\n', '            // 22270923699561257074107342068491755213283769984150504402684791726686939079929\n', '            //\n', '            // We handle that edge case by also checking against this value.\n', '            uint decimals;\n', '            bool success;\n', '            bytes4 sig = bytes4(keccak256("decimals()"));\n', '            assembly {\n', '                let x := mload(0x40)   // Find empty storage location using "free memory pointer"\n', '                mstore(x, sig)          // Set the signature to the first call parameter. 0x313ce567 === bytes4(keccak256("decimals()")\n', '                success := staticcall(\n', '                    30000,              // 30k gas\n', '                    tokenAddress,       // The call target.\n', '                    x,                  // Inputs are stored at location x\n', '                    0x04,               // Input is 4 bytes long\n', '                    x,                  // Overwrite x with output\n', '                    0x20                // The output length\n', '                )\n', '\n', '                decimals := mload(x)\n', '            }\n', '            if (success && decimals != 22270923699561257074107342068491755213283769984150504402684791726686939079929) {\n', '                tokens[i].decimals = decimals;\n', '            }\n', '        }\n', '    }\n', '\n', '    /** @dev Fetch token information in batches\n', '     *  @param _t2crAddress The address of the t2cr contract from where to fetch token information.\n', '     *  @param _cursor The index from where to start iterating.\n', '     *  @param _count The number of items to iterate. If 0 is given, defaults to t2cr.tokenCount().\n', '     *  @param _filter The filter to use. Each element of the array in sequence means:\n', '     *  - Include absent addresses in result.\n', '     *  - Include registered addresses in result.\n', '     *  - Include addresses with registration requests that are not disputed in result.\n', '     *  - Include addresses with clearing requests that are not disputed in result.\n', '     *  - Include disputed addresses with registration requests in result.\n', '     *  - Include disputed addresses with clearing requests in result.\n', '     *  @return tokens The tokens information.\n', '     */\n', '    function getTokensCursor(address _t2crAddress, uint _cursor, uint _count, bool[6] calldata _filter)\n', '        external\n', '        view\n', '        returns (Token[] memory tokens, bool hasMore)\n', '    {\n', '        IArbitrableTokenTCR t2cr = IArbitrableTokenTCR(_t2crAddress);\n', '        if (_count == 0) _count = t2cr.tokenCount();\n', '        if (_cursor >= t2cr.tokenCount()) _cursor = t2cr.tokenCount() - 1;\n', '        if (_cursor + _count > t2cr.tokenCount() - 1) _count = t2cr.tokenCount() - _cursor - 1;\n', '        if (_cursor + _count < t2cr.tokenCount() - 1) hasMore = true;\n', '\n', '        tokens = new Token[](_count);\n', '        uint index = 0;\n', '\n', '\n', '        for (uint i = _cursor; i < t2cr.tokenCount() && i < _cursor + _count ; i++){\n', '            bytes32 tokenID = t2cr.tokensList(i);\n', '            string[] memory strings = new string[](3); // name, ticker and symbolMultihash respectively.\n', '            address tokenAddress;\n', '            IArbitrableTokenTCR.TokenStatus status;\n', '            uint numberOfRequests;\n', '            (\n', '                strings[0],\n', '                strings[1],\n', '                tokenAddress,\n', '                strings[2],\n', '                status,\n', '                numberOfRequests\n', '            ) = t2cr.getTokenInfo(tokenID);\n', '\n', '            tokens[index] = Token(\n', '                tokenID,\n', '                strings[0],\n', '                strings[1],\n', '                tokenAddress,\n', '                strings[2],\n', '                status,\n', '                0\n', '            );\n', '\n', '            (bool disputed,,,,,,,,) = t2cr.getRequestInfo(tokenID, numberOfRequests - 1);\n', '\n', '            if (\n', '                /* solium-disable operator-whitespace */\n', '                (_filter[0] && status == IArbitrableTokenTCR.TokenStatus.Absent) ||\n', '                (_filter[1] && status == IArbitrableTokenTCR.TokenStatus.Registered) ||\n', '                (_filter[2] && status == IArbitrableTokenTCR.TokenStatus.RegistrationRequested && !disputed) ||\n', '                (_filter[3] && status == IArbitrableTokenTCR.TokenStatus.ClearingRequested && !disputed) ||\n', '                (_filter[4] && status == IArbitrableTokenTCR.TokenStatus.RegistrationRequested && disputed) ||\n', '                (_filter[5] && status == IArbitrableTokenTCR.TokenStatus.ClearingRequested && disputed)\n', '                /* solium-enable operator-whitespace */\n', '            ) {\n', '                if (index < _count) {\n', "                    // Call the contract's decimals() function without reverting when\n", '                    // the contract does not implement it.\n', '                    //\n', '                    // Two things should be noted: if the contract does not implement the function\n', '                    // and does not implement the contract fallback function, `success` will be set to\n', "                    // false and decimals won't be set. However, in some cases (such as old contracts)\n", '                    // the fallback function is implemented, and so staticcall will return true\n', '                    // even though the value returned will not be correct (the number below):\n', '                    //\n', '                    // 22270923699561257074107342068491755213283769984150504402684791726686939079929\n', '                    //\n', '                    // We handle that edge case by also checking against this value.\n', '                    uint decimals;\n', '                    bool success;\n', '                    bytes4 sig = bytes4(keccak256("decimals()"));\n', '                    assembly {\n', '                        let x := mload(0x40)   // Find empty storage location using "free memory pointer"\n', '                        mstore(x, sig)          // Set the signature to the first call parameter. 0x313ce567 === bytes4(keccak256("decimals()")\n', '                        success := staticcall(\n', '                            30000,              // 30k gas\n', '                            tokenAddress,       // The call target.\n', '                            x,                  // Inputs are stored at location x\n', '                            0x04,               // Input is 4 bytes long\n', '                            x,                  // Overwrite x with output\n', '                            0x20                // The output length\n', '                        )\n', '\n', '                        decimals := mload(x)\n', '                    }\n', '                    if (success && decimals != 22270923699561257074107342068491755213283769984150504402684791726686939079929) {\n', '                        tokens[index].decimals = decimals;\n', '                    }\n', '                    index++;\n', '                } else {\n', '                    hasMore = true;\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function getRequestDetails(address _t2crAddress, bytes32 _tokenID, uint _requestID) public view returns (Request memory request) {\n', '        IArbitrableTokenTCR t2cr = IArbitrableTokenTCR(_t2crAddress);\n', '        (\n', '            bool disputed,\n', '            uint disputeID,\n', '            uint submissionTime,\n', '            bool resolved,\n', '            address[3] memory parties,\n', '            uint numberOfRounds,\n', '            IArbitrableTCR.Party ruling,\n', '            address arbitrator,\n', '            bytes memory arbitratorExtraData\n', '        ) = t2cr.getRequestInfo(_tokenID, _requestID);\n', '\n', '        request = Request(\n', '            disputed,\n', '            disputeID,\n', '            submissionTime,\n', '            resolved,\n', '            parties,\n', '            numberOfRounds,\n', '            ruling,\n', '            arbitrator,\n', '            arbitratorExtraData,\n', '            IArbitrator.DisputeStatus.Waiting,\n', '            0,\n', '            0,\n', '            [uint(0),uint(0),uint(0)],\n', '            [uint(0),uint(0)]\n', '        );\n', '    }\n', '\n', '    function getRequestsDetails(address _t2crAddress, bytes32 _tokenID) public view returns (\n', '       Request[10] memory requests // Ideally this should be resizable. In practice it is unlikely submissions will have more than 2 or 3 requests.\n', '    ) {\n', '        IArbitrableTokenTCR t2cr = IArbitrableTokenTCR(_t2crAddress);\n', '        (,,,,, uint numberOfRequests) = t2cr.getTokenInfo(_tokenID);\n', '\n', '\n', '        for (uint256 i = 0; i < numberOfRequests; i++) {\n', '            Request memory request = getRequestDetails(_t2crAddress, _tokenID, i);\n', '\n', '            IArbitrator arbitrator = IArbitrator(request.arbitrator);\n', '\n', '            if (request.disputed) {\n', '                request.disputeStatus = arbitrator.disputeStatus(request.disputeID);\n', '                request.currentRuling = arbitrator.currentRuling(request.disputeID);\n', '\n', '                if (request.disputeStatus == IArbitrator.DisputeStatus.Appealable) {\n', '                    request.appealCost = arbitrator.appealCost(request.disputeID, request.arbitratorExtraData);\n', '\n', '                    ArbitrableTCRData memory arbitrableTCRData = fetchArbitrable(_t2crAddress);\n', '\n', '                    if (request.ruling == IArbitrableTCR.Party.None) {\n', '                        request.requiredForSide[1] = request.appealCost + request.appealCost * arbitrableTCRData.sharedStakeMultiplier / arbitrableTCRData.MULTIPLIER_DIVISOR;\n', '                        request.requiredForSide[2] = request.appealCost + request.appealCost * arbitrableTCRData.sharedStakeMultiplier / arbitrableTCRData.MULTIPLIER_DIVISOR;\n', '                    } else if (request.ruling == IArbitrableTCR.Party.Requester) {\n', '                        request.requiredForSide[1] = request.appealCost + request.appealCost * arbitrableTCRData.winnerStakeMultiplier / arbitrableTCRData.MULTIPLIER_DIVISOR;\n', '                        request.requiredForSide[2] = request.appealCost + request.appealCost * arbitrableTCRData.loserStakeMultiplier / arbitrableTCRData.MULTIPLIER_DIVISOR;\n', '                    } else {\n', '                        request.requiredForSide[1] = request.appealCost + request.appealCost * arbitrableTCRData.loserStakeMultiplier / arbitrableTCRData.MULTIPLIER_DIVISOR;\n', '                        request.requiredForSide[2] = request.appealCost + request.appealCost * arbitrableTCRData.winnerStakeMultiplier / arbitrableTCRData.MULTIPLIER_DIVISOR;\n', '                    }\n', '\n', '                    (request.appealPeriod[0], request.appealPeriod[1]) = arbitrator.appealPeriod(request.disputeID);\n', '                }\n', '            }\n', '            requests[i] = request;\n', '        }\n', '    }\n', '}']