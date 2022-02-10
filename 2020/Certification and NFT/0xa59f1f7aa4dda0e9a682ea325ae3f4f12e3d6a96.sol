['pragma solidity 0.4.25;\n', '\n', '// File: contracts/sogur/interfaces/IMonetaryModelState.sol\n', '\n', '/**\n', ' * @title Monetary Model State Interface.\n', ' */\n', 'interface IMonetaryModelState {\n', '    /**\n', '     * @dev Set the total amount of SDR in the model.\n', '     * @param _amount The total amount of SDR in the model.\n', '     */\n', '    function setSdrTotal(uint256 _amount) external;\n', '\n', '    /**\n', '     * @dev Set the total amount of SGR in the model.\n', '     * @param _amount The total amount of SGR in the model.\n', '     */\n', '    function setSgrTotal(uint256 _amount) external;\n', '\n', '    /**\n', '     * @dev Get the total amount of SDR in the model.\n', '     * @return The total amount of SDR in the model.\n', '     */\n', '    function getSdrTotal() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the total amount of SGR in the model.\n', '     * @return The total amount of SGR in the model.\n', '     */\n', '    function getSgrTotal() external view returns (uint256);\n', '}\n', '\n', '// File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Interface.\n', ' */\n', 'interface IContractAddressLocator {\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) external view returns (address);\n', '\n', '    /**\n', '     * @dev Determine whether or not a contract address relates to one of the identifiers.\n', '     * @param _contractAddress The contract address to look for.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the contract address relates to one of the identifiers.\n', '     */\n', '    function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);\n', '}\n', '\n', '// File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Holder.\n', ' * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.\n', ' * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.\n', ' * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.\n', ' * @dev In addition to that, any function in any contract can be restricted to a specific caller.\n', ' */\n', 'contract ContractAddressLocatorHolder {\n', '    bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";\n', '    bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;\n', '    bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;\n', '    bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;\n', '    bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;\n', '    bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;\n', '    bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;\n', '    bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;\n', '    bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;\n', '    bytes32 internal constant _IMintListener_            = "IMintListener"           ;\n', '    bytes32 internal constant _IMintManager_             = "IMintManager"            ;\n', '    bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;\n', '    bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;\n', '    bytes32 internal constant _IRedButton_               = "IRedButton"              ;\n', '    bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;\n', '    bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;\n', '    bytes32 internal constant _ISogurExchanger_           = "ISogurExchanger"          ;\n', '    bytes32 internal constant _SgnToSgrExchangeInitiator_ = "SgnToSgrExchangeInitiator"          ;\n', '    bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;\n', '    bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;\n', '    bytes32 internal constant _ISGRAuthorizationManager_ = "ISGRAuthorizationManager";\n', '    bytes32 internal constant _ISGRToken_                = "ISGRToken"               ;\n', '    bytes32 internal constant _ISGRTokenManager_         = "ISGRTokenManager"        ;\n', '    bytes32 internal constant _ISGRTokenInfo_         = "ISGRTokenInfo"        ;\n', '    bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";\n', '    bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;\n', '    bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;\n', '    bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;\n', '    bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;\n', '    bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;\n', '    bytes32 internal constant _BuyWalletsTradingDataSource_       = "BuyWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _SellWalletsTradingDataSource_       = "SellWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;\n', '    bytes32 internal constant _BuyWalletsTradingLimiter_SGRTokenManager_          = "BuyWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _SellWalletsTradingLimiter_SGRTokenManager_          = "SellWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;\n', '    bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;\n', '    bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;\n', '    bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;\n', '    bytes32 internal constant _SGAToSGRInitializer_      = "SGAToSGRInitializer"     ;\n', '\n', '    IContractAddressLocator private contractAddressLocator;\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) internal {\n', '        require(_contractAddressLocator != address(0), "locator is illegal");\n', '        contractAddressLocator = _contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address locator.\n', '     * @return The contract address locator.\n', '     */\n', '    function getContractAddressLocator() external view returns (IContractAddressLocator) {\n', '        return contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) internal view returns (address) {\n', '        return contractAddressLocator.getContractAddress(_identifier);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Determine whether or not the sender relates to one of the identifiers.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the sender relates to one of the identifiers.\n', '     */\n', '    function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {\n', '        return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);\n', '    }\n', '\n', '    /**\n', '     * @dev Verify that the caller is mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     */\n', '    modifier only(bytes32 _identifier) {\n', '        require(msg.sender == getContractAddress(_identifier), "caller is illegal");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/sogur/MonetaryModelState.sol\n', '\n', '/**\n', ' * Details of usage of licenced software see here: https://www.sogur.com/software/readme_v1\n', ' */\n', '\n', '/**\n', ' * @title Monetary Model State.\n', ' */\n', 'contract MonetaryModelState is IMonetaryModelState, ContractAddressLocatorHolder {\n', '    string public constant VERSION = "1.1.0";\n', '\n', '    bool public initialized;\n', '\n', '    uint256 public sdrTotal;\n', '    uint256 public sgrTotal;\n', '\n', '    event MonetaryModelStateInitialized(address indexed _initializer, uint256 _sdrTotal, uint256 _sgrTotal);\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}\n', '\n', '    /**\n', '    * @dev Reverts if called when the contract is already initialized.\n', '    */\n', '    modifier onlyIfNotInitialized() {\n', '        require(!initialized, "contract already initialized");\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Initialize the contract.\n', '    * @param _sdrTotal The total amount of SDR in the model.\n', '    * @param _sgrTotal The total amount of SGR in the model.\n', '    */\n', '    function init(uint256 _sdrTotal, uint256 _sgrTotal) external onlyIfNotInitialized only(_SGAToSGRInitializer_) {\n', '        initialized = true;\n', '        sdrTotal = _sdrTotal;\n', '        sgrTotal = _sgrTotal;\n', '        emit MonetaryModelStateInitialized(msg.sender, _sdrTotal, _sgrTotal);\n', '    }\n', '\n', '    /**\n', '     * @dev Set the total amount of SDR in the model.\n', '     * @param _amount The total amount of SDR in the model.\n', '     */\n', '    function setSdrTotal(uint256 _amount) external only(_IMonetaryModel_) {\n', '        sdrTotal = _amount;\n', '    }\n', '\n', '    /**\n', '     * @dev Set the total amount of SGR in the model.\n', '     * @param _amount The total amount of SGR in the model.\n', '     */\n', '    function setSgrTotal(uint256 _amount) external only(_IMonetaryModel_) {\n', '        sgrTotal = _amount;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the total amount of SDR in the model.\n', '     * @return The total amount of SDR in the model.\n', '     */\n', '    function getSdrTotal() external view returns (uint256) {\n', '        return sdrTotal;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the total amount of SGR in the model.\n', '     * @return The total amount of SGR in the model.\n', '     */\n', '    function getSgrTotal() external view returns (uint256) {\n', '        return sgrTotal;\n', '    }\n', '}']