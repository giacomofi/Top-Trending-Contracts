['pragma solidity 0.4.25;\n', '\n', '// File: contracts/sogur/interfaces/IMonetaryModel.sol\n', '\n', '/**\n', ' * @title Monetary Model Interface.\n', ' */\n', 'interface IMonetaryModel {\n', '    /**\n', '     * @dev Buy SGR in exchange for SDR.\n', '     * @param _sdrAmount The amount of SDR received from the buyer.\n', '     * @return The amount of SGR that the buyer is entitled to receive.\n', '     */\n', '    function buy(uint256 _sdrAmount) external returns (uint256);\n', '\n', '    /**\n', '     * @dev Sell SGR in exchange for SDR.\n', '     * @param _sgrAmount The amount of SGR received from the seller.\n', '     * @return The amount of SDR that the seller is entitled to receive.\n', '     */\n', '    function sell(uint256 _sgrAmount) external returns (uint256);\n', '}\n', '\n', '// File: contracts/sogur/interfaces/IReconciliationAdjuster.sol\n', '\n', '/**\n', ' * @title Reconciliation Adjuster Interface.\n', ' */\n', 'interface IReconciliationAdjuster {\n', '    /**\n', '     * @dev Get the buy-adjusted value of a given SDR amount.\n', '     * @param _sdrAmount The amount of SDR to adjust.\n', '     * @return The adjusted amount of SDR.\n', '     */\n', '    function adjustBuy(uint256 _sdrAmount) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the sell-adjusted value of a given SDR amount.\n', '     * @param _sdrAmount The amount of SDR to adjust.\n', '     * @return The adjusted amount of SDR.\n', '     */\n', '    function adjustSell(uint256 _sdrAmount) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/sogur/interfaces/ITransactionManager.sol\n', '\n', '/**\n', ' * @title Transaction Manager Interface.\n', ' */\n', 'interface ITransactionManager {\n', '    /**\n', '     * @dev Buy SGR in exchange for ETH.\n', '     * @param _ethAmount The amount of ETH received from the buyer.\n', '     * @return The amount of SGR that the buyer is entitled to receive.\n', '     */\n', '    function buy(uint256 _ethAmount) external returns (uint256);\n', '\n', '    /**\n', '     * @dev Sell SGR in exchange for ETH.\n', '     * @param _sgrAmount The amount of SGR received from the seller.\n', '     * @return The amount of ETH that the seller is entitled to receive.\n', '     */\n', '    function sell(uint256 _sgrAmount) external returns (uint256);\n', '}\n', '\n', '// File: contracts/sogur/interfaces/ITransactionLimiter.sol\n', '\n', '/**\n', ' * @title Transaction Limiter Interface.\n', ' */\n', 'interface ITransactionLimiter {\n', '    /**\n', '     * @dev Reset the total buy-amount and the total sell-amount.\n', '     */\n', '    function resetTotal() external;\n', '\n', '    /**\n', '     * @dev Increment the total buy-amount.\n', '     * @param _amount The amount to increment by.\n', '     */\n', '    function incTotalBuy(uint256 _amount) external;\n', '\n', '    /**\n', '     * @dev Increment the total sell-amount.\n', '     * @param _amount The amount to increment by.\n', '     */\n', '    function incTotalSell(uint256 _amount) external;\n', '}\n', '\n', '// File: contracts/sogur/interfaces/IETHConverter.sol\n', '\n', '/**\n', ' * @title ETH Converter Interface.\n', ' */\n', 'interface IETHConverter {\n', '    /**\n', '     * @dev Get the current SDR worth of a given ETH amount.\n', '     * @param _ethAmount The amount of ETH to convert.\n', '     * @return The equivalent amount of SDR.\n', '     */\n', '    function toSdrAmount(uint256 _ethAmount) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the current ETH worth of a given SDR amount.\n', '     * @param _sdrAmount The amount of SDR to convert.\n', '     * @return The equivalent amount of ETH.\n', '     */\n', '    function toEthAmount(uint256 _sdrAmount) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the original SDR worth of a converted ETH amount.\n', '     * @param _ethAmount The amount of ETH converted.\n', '     * @return The original amount of SDR.\n', '     */\n', '    function fromEthAmount(uint256 _ethAmount) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Interface.\n', ' */\n', 'interface IContractAddressLocator {\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) external view returns (address);\n', '\n', '    /**\n', '     * @dev Determine whether or not a contract address relates to one of the identifiers.\n', '     * @param _contractAddress The contract address to look for.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the contract address relates to one of the identifiers.\n', '     */\n', '    function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);\n', '}\n', '\n', '// File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Holder.\n', ' * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.\n', ' * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.\n', ' * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.\n', ' * @dev In addition to that, any function in any contract can be restricted to a specific caller.\n', ' */\n', 'contract ContractAddressLocatorHolder {\n', '    bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";\n', '    bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;\n', '    bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;\n', '    bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;\n', '    bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;\n', '    bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;\n', '    bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;\n', '    bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;\n', '    bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;\n', '    bytes32 internal constant _IMintListener_            = "IMintListener"           ;\n', '    bytes32 internal constant _IMintManager_             = "IMintManager"            ;\n', '    bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;\n', '    bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;\n', '    bytes32 internal constant _IRedButton_               = "IRedButton"              ;\n', '    bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;\n', '    bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;\n', '    bytes32 internal constant _ISogurExchanger_           = "ISogurExchanger"          ;\n', '    bytes32 internal constant _SgnToSgrExchangeInitiator_ = "SgnToSgrExchangeInitiator"          ;\n', '    bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;\n', '    bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;\n', '    bytes32 internal constant _ISGRAuthorizationManager_ = "ISGRAuthorizationManager";\n', '    bytes32 internal constant _ISGRToken_                = "ISGRToken"               ;\n', '    bytes32 internal constant _ISGRTokenManager_         = "ISGRTokenManager"        ;\n', '    bytes32 internal constant _ISGRTokenInfo_         = "ISGRTokenInfo"        ;\n', '    bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";\n', '    bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;\n', '    bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;\n', '    bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;\n', '    bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;\n', '    bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;\n', '    bytes32 internal constant _BuyWalletsTradingDataSource_       = "BuyWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _SellWalletsTradingDataSource_       = "SellWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;\n', '    bytes32 internal constant _BuyWalletsTradingLimiter_SGRTokenManager_          = "BuyWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _SellWalletsTradingLimiter_SGRTokenManager_          = "SellWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;\n', '    bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;\n', '    bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;\n', '    bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;\n', '    bytes32 internal constant _SGAToSGRInitializer_      = "SGAToSGRInitializer"     ;\n', '\n', '    IContractAddressLocator private contractAddressLocator;\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) internal {\n', '        require(_contractAddressLocator != address(0), "locator is illegal");\n', '        contractAddressLocator = _contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address locator.\n', '     * @return The contract address locator.\n', '     */\n', '    function getContractAddressLocator() external view returns (IContractAddressLocator) {\n', '        return contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) internal view returns (address) {\n', '        return contractAddressLocator.getContractAddress(_identifier);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Determine whether or not the sender relates to one of the identifiers.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the sender relates to one of the identifiers.\n', '     */\n', '    function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {\n', '        return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);\n', '    }\n', '\n', '    /**\n', '     * @dev Verify that the caller is mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     */\n', '    modifier only(bytes32 _identifier) {\n', '        require(msg.sender == getContractAddress(_identifier), "caller is illegal");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/sogur/TransactionManager.sol\n', '\n', '/**\n', ' * Details of usage of licenced software see here: https://www.sogur.com/software/readme_v1\n', ' */\n', '\n', '/**\n', ' * @title Transaction Manager.\n', ' */\n', 'contract TransactionManager is ITransactionManager, ContractAddressLocatorHolder {\n', '    string public constant VERSION = "1.0.1";\n', '\n', '    event TransactionManagerBuyCompleted(uint256 _amount);\n', '    event TransactionManagerSellCompleted(uint256 _amount);\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IMonetaryModel interface.\n', '     */\n', '    function getMonetaryModel() public view returns (IMonetaryModel) {\n', '        return IMonetaryModel(getContractAddress(_IMonetaryModel_));\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IReconciliationAdjuster interface.\n', '     */\n', '    function getReconciliationAdjuster() public view returns (IReconciliationAdjuster) {\n', '        return IReconciliationAdjuster(getContractAddress(_IReconciliationAdjuster_));\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the ITransactionLimiter interface.\n', '     */\n', '    function getTransactionLimiter() public view returns (ITransactionLimiter) {\n', '        return ITransactionLimiter(getContractAddress(_ITransactionLimiter_));\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IETHConverter interface.\n', '     */\n', '    function getETHConverter() public view returns (IETHConverter) {\n', '        return IETHConverter(getContractAddress(_IETHConverter_));\n', '    }\n', '\n', '    /**\n', '     * @dev Buy SGR in exchange for ETH.\n', '     * @param _ethAmount The amount of ETH received from the buyer.\n', '     * @return The amount of SGR that the buyer is entitled to receive.\n', '     */\n', '    function buy(uint256 _ethAmount) external only(_ISGRTokenManager_) returns (uint256) {\n', '        uint256 sdrAmount = getETHConverter().toSdrAmount(_ethAmount);\n', '        uint256 newAmount = getReconciliationAdjuster().adjustBuy(sdrAmount);\n', '        uint256 sgrAmount = getMonetaryModel().buy(newAmount);\n', '        getTransactionLimiter().incTotalBuy(sdrAmount);\n', '        emit TransactionManagerBuyCompleted(sdrAmount);\n', '        return sgrAmount;\n', '    }\n', '\n', '    /**\n', '     * @dev Sell SGR in exchange for ETH.\n', '     * @param _sgrAmount The amount of SGR received from the seller.\n', '     * @return The amount of ETH that the seller is entitled to receive.\n', '     */\n', '    function sell(uint256 _sgrAmount) external only(_ISGRTokenManager_) returns (uint256) {\n', '        uint256 sdrAmount = getMonetaryModel().sell(_sgrAmount);\n', '        uint256 newAmount = getReconciliationAdjuster().adjustSell(sdrAmount);\n', '        uint256 ethAmount = getETHConverter().toEthAmount(newAmount);\n', '        getTransactionLimiter().incTotalSell(sdrAmount);\n', '        emit TransactionManagerSellCompleted(newAmount);\n', '        return ethAmount;\n', '    }\n', '}']