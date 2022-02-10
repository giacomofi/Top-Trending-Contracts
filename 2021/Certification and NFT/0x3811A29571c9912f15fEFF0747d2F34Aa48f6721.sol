['// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../oracle/interfaces/FinderInterface.sol";\n', 'import "./IBridge.sol";\n', 'import "../oracle/implementation/Constants.sol";\n', '\n', '/**\n', ' * @title Simple implementation of the OracleInterface used to communicate price request data cross-chain between\n', ' * EVM networks. Can be extended either into a "Source" or "Sink" oracle that specializes in making and resolving\n', ' * cross-chain price requests, respectivly. The "Source" Oracle is the originator or source of price resolution data\n', ' * and can only resolve prices already published by the DVM. The "Sink" Oracle receives the price resolution data\n', ' * from the Source Oracle and makes it available on non-Mainnet chains. The "Sink" Oracle can also be used to trigger\n', ' * price requests from the DVM on Mainnet.\n', ' */\n', 'abstract contract BeaconOracle {\n', '    enum RequestState { NeverRequested, Requested, Resolved }\n', '\n', '    struct Price {\n', '        RequestState state;\n', '        int256 price;\n', '    }\n', '\n', '    // Chain ID for this Oracle.\n', '    uint8 public currentChainID;\n', '\n', '    // Mapping of encoded price requests {identifier, time, ancillaryData} to Price objects.\n', '    mapping(bytes32 => Price) internal prices;\n', '\n', '    // Finder to provide addresses for DVM system contracts.\n', '    FinderInterface public finder;\n', '\n', '    event PriceRequestAdded(\n', '        address indexed requester,\n', '        uint8 indexed chainID,\n', '        bytes32 indexed identifier,\n', '        uint256 time,\n', '        bytes ancillaryData\n', '    );\n', '    event PushedPrice(\n', '        address indexed pusher,\n', '        uint8 indexed chainID,\n', '        bytes32 indexed identifier,\n', '        uint256 time,\n', '        bytes ancillaryData,\n', '        int256 price\n', '    );\n', '\n', '    /**\n', '     * @notice Constructor.\n', '     * @param _finderAddress finder to use to get addresses of DVM contracts.\n', '     */\n', '    constructor(address _finderAddress, uint8 _chainID) {\n', '        finder = FinderInterface(_finderAddress);\n', '        currentChainID = _chainID;\n', '    }\n', '\n', '    // We assume that there is only one GenericHandler for this network.\n', '    modifier onlyGenericHandlerContract() {\n', '        require(\n', '            msg.sender == finder.getImplementationAddress(OracleInterfaces.GenericHandler),\n', '            "Caller must be GenericHandler"\n', '        );\n', '        _;\n', '    }\n', '\n', '    /**\n', "     * @notice Enqueues a request (if a request isn't already present) for the given (identifier, time, ancillary data)\n", '     * pair. Will revert if request has been requested already.\n', '     */\n', '    function _requestPrice(\n', '        uint8 chainID,\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData\n', '    ) internal {\n', '        bytes32 priceRequestId = _encodePriceRequest(chainID, identifier, time, ancillaryData);\n', '        Price storage lookup = prices[priceRequestId];\n', '        if (lookup.state == RequestState.NeverRequested) {\n', '            // New query, change state to Requested:\n', '            lookup.state = RequestState.Requested;\n', '            emit PriceRequestAdded(msg.sender, chainID, identifier, time, ancillaryData);\n', '        }\n', '    }\n', '\n', '    /**\n', "     * @notice Publishes price for a requested query. Will revert if request hasn't been requested yet or has been\n", '     * resolved already.\n', '     */\n', '    function _publishPrice(\n', '        uint8 chainID,\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData,\n', '        int256 price\n', '    ) internal {\n', '        bytes32 priceRequestId = _encodePriceRequest(chainID, identifier, time, ancillaryData);\n', '        Price storage lookup = prices[priceRequestId];\n', '        require(lookup.state == RequestState.Requested, "Price request is not currently pending");\n', '        lookup.price = price;\n', '        lookup.state = RequestState.Resolved;\n', '        emit PushedPrice(msg.sender, chainID, identifier, time, ancillaryData, lookup.price);\n', '    }\n', '\n', '    /**\n', '     * @notice Returns Bridge contract on network.\n', '     */\n', '    function _getBridge() internal view returns (IBridge) {\n', '        return IBridge(finder.getImplementationAddress(OracleInterfaces.Bridge));\n', '    }\n', '\n', '    /**\n', '     * @notice Returns the convenient way to store price requests, uniquely identified by {chainID, identifier, time,\n', '     * ancillaryData }.\n', '     */\n', '    function _encodePriceRequest(\n', '        uint8 chainID,\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData\n', '    ) internal pure returns (bytes32) {\n', '        return keccak256(abi.encode(chainID, identifier, time, ancillaryData));\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', '    @title Interface for Bridge contract.\n', '    @dev Copied directly from here: https://github.com/ChainSafe/chainbridge-solidity/releases/tag/v1.0.0 except for \n', '         the addition of `deposit()` so that this contract can be called from Sink and Source Oracle contracts.\n', '    @author ChainSafe Systems.\n', ' */\n', 'interface IBridge {\n', '    /**\n', '        @notice Exposing getter for {_chainID} instead of forcing the use of call.\n', '        @return uint8 The {_chainID} that is currently set for the Bridge contract.\n', '     */\n', '    function _chainID() external returns (uint8);\n', '\n', '    function deposit(\n', '        uint8 destinationChainID,\n', '        bytes32 resourceID,\n', '        bytes calldata data\n', '    ) external;\n', '}\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./BeaconOracle.sol";\n', 'import "../oracle/interfaces/OracleAncillaryInterface.sol";\n', '\n', '/**\n', ' * @title Extension of BeaconOracle that is intended to be deployed on Mainnet to give financial\n', ' * contracts on non-Mainnet networks the ability to trigger cross-chain price requests to the Mainnet DVM. This contract\n', ' * is responsible for triggering price requests originating from non-Mainnet, and broadcasting resolved price data\n', ' * back to those networks. Technically, this contract is more of a Proxy than an Oracle, because it does not implement\n', " * the full Oracle interface including the getPrice and requestPrice methods. It's goal is to shuttle price request\n", ' * functionality between L2 and L1.\n', ' * @dev The intended client of this contract is some off-chain bot watching for resolved price events on the DVM. Once\n', ' * that bot sees a price has resolved, it can call `publishPrice()` on this contract which will call the local Bridge\n', ' * contract to signal to an off-chain relayer to bridge a price request to another network.\n', ' * @dev This contract must be a registered financial contract in order to call DVM methods.\n', ' */\n', 'contract SourceOracle is BeaconOracle {\n', '    constructor(address _finderAddress, uint8 _chainID) BeaconOracle(_finderAddress, _chainID) {}\n', '\n', '    /***************************************************************\n', '     * Publishing Price Request Data to L2:\n', '     ***************************************************************/\n', '\n', '    /**\n', '     * @notice This is the first method that should be called in order to publish a price request to another network\n', '     * marked by `sinkChainID`.\n', '     * @dev Publishes the DVM resolved price for the price request, or reverts if not resolved yet. Will call the\n', "     * local Bridge's deposit() method which will emit a Deposit event in order to signal to an off-chain\n", '     * relayer to begin the cross-chain process.\n', '     */\n', '    function publishPrice(\n', '        uint8 sinkChainID,\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData\n', '    ) public {\n', '        require(_getOracle().hasPrice(identifier, time, ancillaryData), "DVM has not resolved price");\n', '        int256 price = _getOracle().getPrice(identifier, time, ancillaryData);\n', '        _publishPrice(sinkChainID, identifier, time, ancillaryData, price);\n', '\n', '        // Call Bridge.deposit() to initiate cross-chain publishing of price request.\n', '        _getBridge().deposit(\n', '            sinkChainID,\n', '            getResourceId(),\n', '            formatMetadata(sinkChainID, identifier, time, ancillaryData, price)\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @notice This method will ultimately be called after `publishPrice` calls `Bridge.deposit()`, which will call\n', '     * `GenericHandler.deposit()` and ultimately this method.\n', '     * @dev This method should basically check that the `Bridge.deposit()` was triggered by a valid publish event.\n', '     */\n', '    function validateDeposit(\n', '        uint8 sinkChainID,\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData,\n', '        int256 price\n', '    ) public view {\n', '        bytes32 priceRequestId = _encodePriceRequest(sinkChainID, identifier, time, ancillaryData);\n', '        Price storage lookup = prices[priceRequestId];\n', '        require(lookup.state == RequestState.Resolved, "Price has not been published");\n', '        require(lookup.price == price, "Unexpected price published");\n', '    }\n', '\n', '    /***************************************************************\n', '     * Responding to a Price Request from L2:\n', '     ***************************************************************/\n', '\n', '    /**\n', '     * @notice This method will ultimately be called after a `requestPrice` has been bridged cross-chain from\n', '     * non-Mainnet to this network via an off-chain relayer. The relayer will call `Bridge.executeProposal` on this\n', '     * local network, which call `GenericHandler.executeProposal()` and ultimately this method.\n', '     * @dev This method should prepare this oracle to receive a published price and then forward the price request\n', '     * to the DVM. Can only be called by the `GenericHandler`.\n', '     */\n', '\n', '    function executeRequestPrice(\n', '        uint8 sinkChainID,\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData\n', '    ) public onlyGenericHandlerContract() {\n', '        _requestPrice(sinkChainID, identifier, time, ancillaryData);\n', '        _getOracle().requestPrice(identifier, time, ancillaryData);\n', '    }\n', '\n', '    /**\n', '     * @notice Convenience method to get cross-chain Bridge resource ID linking this contract with its SinkOracles.\n', "     * @dev More details about Resource ID's here: https://chainbridge.chainsafe.io/spec/#resource-id\n", '     * @return bytes32 Hash containing this stored chain ID.\n', '     */\n', '    function getResourceId() public view returns (bytes32) {\n', '        return keccak256(abi.encode("Oracle", currentChainID));\n', '    }\n', '\n', '    /**\n', '     * @notice Return DVM for this network.\n', '     */\n', '    function _getOracle() internal view returns (OracleAncillaryInterface) {\n', '        return OracleAncillaryInterface(finder.getImplementationAddress(OracleInterfaces.Oracle));\n', '    }\n', '\n', '    /**\n', '     * @notice This helper method is useful for calling Bridge.deposit().\n', '     * @dev GenericHandler.deposit() expects data to be formatted as:\n', '     *     len(data)                              uint256     bytes  0  - 64\n', '     *     data                                   bytes       bytes  64 - END\n', '     */\n', '    function formatMetadata(\n', '        uint8 chainID,\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData,\n', '        int256 price\n', '    ) public pure returns (bytes memory) {\n', '        bytes memory metadata = abi.encode(chainID, identifier, time, ancillaryData, price);\n', '        return abi.encodePacked(metadata.length, metadata);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title Stores common interface names used throughout the DVM by registration in the Finder.\n', ' */\n', 'library OracleInterfaces {\n', '    bytes32 public constant Oracle = "Oracle";\n', '    bytes32 public constant IdentifierWhitelist = "IdentifierWhitelist";\n', '    bytes32 public constant Store = "Store";\n', '    bytes32 public constant FinancialContractsAdmin = "FinancialContractsAdmin";\n', '    bytes32 public constant Registry = "Registry";\n', '    bytes32 public constant CollateralWhitelist = "CollateralWhitelist";\n', '    bytes32 public constant OptimisticOracle = "OptimisticOracle";\n', '    bytes32 public constant Bridge = "Bridge";\n', '    bytes32 public constant GenericHandler = "GenericHandler";\n', '}\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title Provides addresses of the live contracts implementing certain interfaces.\n', ' * @dev Examples are the Oracle or Store interfaces.\n', ' */\n', 'interface FinderInterface {\n', '    /**\n', '     * @notice Updates the address of the contract that implements `interfaceName`.\n', '     * @param interfaceName bytes32 encoding of the interface name that is either changed or registered.\n', '     * @param implementationAddress address of the deployed contract that implements the interface.\n', '     */\n', '    function changeImplementationAddress(bytes32 interfaceName, address implementationAddress) external;\n', '\n', '    /**\n', '     * @notice Gets the address of the contract that implements the given `interfaceName`.\n', '     * @param interfaceName queried interface.\n', '     * @return implementationAddress address of the deployed contract that implements the interface.\n', '     */\n', '    function getImplementationAddress(bytes32 interfaceName) external view returns (address);\n', '}\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title Financial contract facing Oracle interface.\n', ' * @dev Interface used by financial contracts to interact with the Oracle. Voters will use a different interface.\n', ' */\n', 'abstract contract OracleAncillaryInterface {\n', '    /**\n', "     * @notice Enqueues a request (if a request isn't already present) for the given `identifier`, `time` pair.\n", '     * @dev Time must be in the past and the identifier must be supported.\n', '     * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.\n', '     * @param ancillaryData arbitrary data appended to a price request to give the voters more info from the caller.\n', '     * @param time unix timestamp for the price request.\n', '     */\n', '\n', '    function requestPrice(\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData\n', '    ) public virtual;\n', '\n', '    /**\n', '     * @notice Whether the price for `identifier` and `time` is available.\n', '     * @dev Time must be in the past and the identifier must be supported.\n', '     * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.\n', '     * @param time unix timestamp for the price request.\n', '     * @param ancillaryData arbitrary data appended to a price request to give the voters more info from the caller.\n', '     * @return bool if the DVM has resolved to a price for the given identifier and timestamp.\n', '     */\n', '    function hasPrice(\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData\n', '    ) public view virtual returns (bool);\n', '\n', '    /**\n', '     * @notice Gets the price for `identifier` and `time` if it has already been requested and resolved.\n', '     * @dev If the price is not available, the method reverts.\n', '     * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.\n', '     * @param time unix timestamp for the price request.\n', '     * @param ancillaryData arbitrary data appended to a price request to give the voters more info from the caller.\n', '     * @return int256 representing the resolved price for the given identifier and timestamp.\n', '     */\n', '\n', '    function getPrice(\n', '        bytes32 identifier,\n', '        uint256 time,\n', '        bytes memory ancillaryData\n', '    ) public view virtual returns (int256);\n', '}\n', '\n', '{\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "metadata": {\n', '    "bytecodeHash": "ipfs",\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 199\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']