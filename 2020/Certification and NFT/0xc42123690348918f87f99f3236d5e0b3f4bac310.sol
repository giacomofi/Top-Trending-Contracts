['pragma solidity 0.4.25;\n', '\n', '// File: contracts/sogur/interfaces/ISGRAuthorizationManager.sol\n', '\n', '/**\n', ' * @title SGR Authorization Manager Interface.\n', ' */\n', 'interface ISGRAuthorizationManager {\n', '    /**\n', '     * @dev Determine whether or not a user is authorized to buy SGR.\n', '     * @param _sender The address of the user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToBuy(address _sender) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Determine whether or not a user is authorized to sell SGR.\n', '     * @param _sender The address of the user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToSell(address _sender) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Determine whether or not a user is authorized to transfer SGR to another user.\n', '     * @param _sender The address of the source user.\n', '     * @param _target The address of the target user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToTransfer(address _sender, address _target) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Determine whether or not a user is authorized to transfer SGR from one user to another user.\n', '     * @param _sender The address of the custodian user.\n', '     * @param _source The address of the source user.\n', '     * @param _target The address of the target user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToTransferFrom(address _sender, address _source, address _target) external view returns (bool);\n', '\n', '    /**\n', '     * @dev Determine whether or not a user is authorized for public operation.\n', '     * @param _sender The address of the user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedForPublicOperation(address _sender) external view returns (bool);\n', '}\n', '\n', '// File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Interface.\n', ' */\n', 'interface IContractAddressLocator {\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) external view returns (address);\n', '\n', '    /**\n', '     * @dev Determine whether or not a contract address relates to one of the identifiers.\n', '     * @param _contractAddress The contract address to look for.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the contract address relates to one of the identifiers.\n', '     */\n', '    function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);\n', '}\n', '\n', '// File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Holder.\n', ' * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.\n', ' * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.\n', ' * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.\n', ' * @dev In addition to that, any function in any contract can be restricted to a specific caller.\n', ' */\n', 'contract ContractAddressLocatorHolder {\n', '    bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";\n', '    bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;\n', '    bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;\n', '    bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;\n', '    bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;\n', '    bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;\n', '    bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;\n', '    bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;\n', '    bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;\n', '    bytes32 internal constant _IMintListener_            = "IMintListener"           ;\n', '    bytes32 internal constant _IMintManager_             = "IMintManager"            ;\n', '    bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;\n', '    bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;\n', '    bytes32 internal constant _IRedButton_               = "IRedButton"              ;\n', '    bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;\n', '    bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;\n', '    bytes32 internal constant _ISogurExchanger_           = "ISogurExchanger"          ;\n', '    bytes32 internal constant _SgnToSgrExchangeInitiator_ = "SgnToSgrExchangeInitiator"          ;\n', '    bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;\n', '    bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;\n', '    bytes32 internal constant _ISGRAuthorizationManager_ = "ISGRAuthorizationManager";\n', '    bytes32 internal constant _ISGRToken_                = "ISGRToken"               ;\n', '    bytes32 internal constant _ISGRTokenManager_         = "ISGRTokenManager"        ;\n', '    bytes32 internal constant _ISGRTokenInfo_         = "ISGRTokenInfo"        ;\n', '    bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";\n', '    bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;\n', '    bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;\n', '    bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;\n', '    bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;\n', '    bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;\n', '    bytes32 internal constant _BuyWalletsTradingDataSource_       = "BuyWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _SellWalletsTradingDataSource_       = "SellWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;\n', '    bytes32 internal constant _BuyWalletsTradingLimiter_SGRTokenManager_          = "BuyWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _SellWalletsTradingLimiter_SGRTokenManager_          = "SellWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;\n', '    bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;\n', '    bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;\n', '    bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;\n', '    bytes32 internal constant _SGAToSGRInitializer_      = "SGAToSGRInitializer"     ;\n', '\n', '    IContractAddressLocator private contractAddressLocator;\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) internal {\n', '        require(_contractAddressLocator != address(0), "locator is illegal");\n', '        contractAddressLocator = _contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address locator.\n', '     * @return The contract address locator.\n', '     */\n', '    function getContractAddressLocator() external view returns (IContractAddressLocator) {\n', '        return contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) internal view returns (address) {\n', '        return contractAddressLocator.getContractAddress(_identifier);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Determine whether or not the sender relates to one of the identifiers.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the sender relates to one of the identifiers.\n', '     */\n', '    function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {\n', '        return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);\n', '    }\n', '\n', '    /**\n', '     * @dev Verify that the caller is mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     */\n', '    modifier only(bytes32 _identifier) {\n', '        require(msg.sender == getContractAddress(_identifier), "caller is illegal");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/authorization/AuthorizationActionRoles.sol\n', '\n', '/**\n', ' * @title Authorization Action Roles.\n', ' */\n', 'library AuthorizationActionRoles {\n', '    string public constant VERSION = "1.1.0";\n', '\n', '    enum Flag {\n', '        BuySgr         ,\n', '        SellSgr        ,\n', '        SellSgn        ,\n', '        ReceiveSgn     ,\n', '        TransferSgn    ,\n', '        TransferFromSgn\n', '    }\n', '\n', '    function isAuthorizedToBuySgr         (uint256 _flags) internal pure returns (bool) {return isAuthorized(_flags, Flag.BuySgr         );}\n', '    function isAuthorizedToSellSgr        (uint256 _flags) internal pure returns (bool) {return isAuthorized(_flags, Flag.SellSgr        );}\n', '    function isAuthorizedToSellSgn        (uint256 _flags) internal pure returns (bool) {return isAuthorized(_flags, Flag.SellSgn        );}\n', '    function isAuthorizedToReceiveSgn     (uint256 _flags) internal pure returns (bool) {return isAuthorized(_flags, Flag.ReceiveSgn     );}\n', '    function isAuthorizedToTransferSgn    (uint256 _flags) internal pure returns (bool) {return isAuthorized(_flags, Flag.TransferSgn    );}\n', '    function isAuthorizedToTransferFromSgn(uint256 _flags) internal pure returns (bool) {return isAuthorized(_flags, Flag.TransferFromSgn);}\n', '    function isAuthorized(uint256 _flags, Flag _flag) private pure returns (bool) {return ((_flags >> uint256(_flag)) & 1) == 1;}\n', '}\n', '\n', '// File: contracts/authorization/interfaces/IAuthorizationDataSource.sol\n', '\n', '/**\n', ' * @title Authorization Data Source Interface.\n', ' */\n', 'interface IAuthorizationDataSource {\n', '    /**\n', '     * @dev Get the authorized action-role of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The authorized action-role of the wallet.\n', '     */\n', '    function getAuthorizedActionRole(address _wallet) external view returns (bool, uint256);\n', '\n', '    /**\n', '     * @dev Get the authorized action-role and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The authorized action-role and class of the wallet.\n', '     */\n', '    function getAuthorizedActionRoleAndClass(address _wallet) external view returns (bool, uint256, uint256);\n', '\n', '    /**\n', '     * @dev Get all the trade-limits and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The trade-limits and trade-class of the wallet.\n', '     */\n', '    function getTradeLimitsAndClass(address _wallet) external view returns (uint256, uint256, uint256);\n', '\n', '\n', '    /**\n', '     * @dev Get the buy trade-limit and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The buy trade-limit and trade-class of the wallet.\n', '     */\n', '    function getBuyTradeLimitAndClass(address _wallet) external view returns (uint256, uint256);\n', '\n', '    /**\n', '     * @dev Get the sell trade-limit and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The sell trade-limit and trade-class of the wallet.\n', '     */\n', '    function getSellTradeLimitAndClass(address _wallet) external view returns (uint256, uint256);\n', '}\n', '\n', '// File: contracts/wallet_trading_limiter/interfaces/ITradingClasses.sol\n', '\n', '/**\n', ' * @title Trading Classes Interface.\n', ' */\n', 'interface ITradingClasses {\n', '    /**\n', '     * @dev Get the complete info of a class.\n', '     * @param _id The id of the class.\n', '     * @return complete info of a class.\n', '     */\n', '    function getInfo(uint256 _id) external view returns (uint256, uint256, uint256);\n', '\n', '    /**\n', '     * @dev Get the action-role of a class.\n', '     * @param _id The id of the class.\n', '     * @return The action-role of the class.\n', '     */\n', '    function getActionRole(uint256 _id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the sell limit of a class.\n', '     * @param _id The id of the class.\n', '     * @return The sell limit of the class.\n', '     */\n', '    function getSellLimit(uint256 _id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the buy limit of a class.\n', '     * @param _id The id of the class.\n', '     * @return The buy limit of the class.\n', '     */\n', '    function getBuyLimit(uint256 _id) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/sogur/SGRAuthorizationManager.sol\n', '\n', '/**\n', ' * Details of usage of licenced software see here: https://www.sogur.com/software/readme_v1\n', ' */\n', '\n', '/**\n', ' * @title SGR Authorization Manager.\n', ' */\n', 'contract SGRAuthorizationManager is ISGRAuthorizationManager, ContractAddressLocatorHolder {\n', '    string public constant VERSION = "2.0.0";\n', '\n', '    using AuthorizationActionRoles for uint256;\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IAuthorizationDataSource interface.\n', '     */\n', '    function getAuthorizationDataSource() public view returns (IAuthorizationDataSource) {\n', '        return IAuthorizationDataSource(getContractAddress(_IAuthorizationDataSource_));\n', '    }\n', '\n', '    /**\n', '    * @dev Return the contract which implements the ITradingClasses interface.\n', '    */\n', '    function getTradingClasses() public view returns (ITradingClasses) {\n', '        return ITradingClasses(getContractAddress(_ITradingClasses_));\n', '    }\n', '\n', '    /**\n', '     * @dev Determine whether or not a user is authorized to buy SGR.\n', '     * @param _sender The address of the user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToBuy(address _sender) external view returns (bool) {\n', '        (bool senderIsWhitelisted, uint256 senderActionRole, uint256 tradeClassId) = getAuthorizationDataSource().getAuthorizedActionRoleAndClass(_sender);\n', '\n', '        return senderIsWhitelisted && getActionRole(senderActionRole, tradeClassId).isAuthorizedToBuySgr();\n', '    }\n', '\n', '    /**\n', '     * @dev Determine whether or not a user is authorized to sell SGR.\n', '     * @param _sender The address of the user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToSell(address _sender) external view returns (bool) {\n', '        (bool senderIsWhitelisted, uint256 senderActionRole, uint256 tradeClassId) = getAuthorizationDataSource().getAuthorizedActionRoleAndClass(_sender);\n', '\n', '        return senderIsWhitelisted && getActionRole(senderActionRole, tradeClassId).isAuthorizedToSellSgr();\n', '    }\n', '\n', '    /**\n', '     * @dev User is always authorized to transfer SGR to another user.\n', '     * @param _sender The address of the source user.\n', '     * @param _target The address of the target user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToTransfer(address _sender, address _target) external view returns (bool) {\n', '        _sender;\n', '        _target;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev User is always authorized to transfer SGR from one user to another user.\n', '     * @param _sender The address of the custodian user.\n', '     * @param _source The address of the source user.\n', '     * @param _target The address of the target user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedToTransferFrom(address _sender, address _source, address _target) external view returns (bool) {\n', '        _sender;\n', '        _source;\n', '        _target;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Determine whether or not a user is authorized for public operation.\n', '     * @param _sender The address of the user.\n', '     * @return Authorization status.\n', '     */\n', '    function isAuthorizedForPublicOperation(address _sender) external view returns (bool) {\n', '        IAuthorizationDataSource authorizationDataSource = getAuthorizationDataSource();\n', '        (bool senderIsWhitelisted,) = authorizationDataSource.getAuthorizedActionRole(_sender);\n', '        return senderIsWhitelisted;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the relevant action-role.\n', '     * @return The relevant action-role.\n', '     */\n', '    function getActionRole(uint256 _actionRole, uint256 _tradeClassId) private view returns (uint256) {\n', '        return  _actionRole > 0 ? _actionRole : getTradingClasses().getActionRole(_tradeClassId);\n', '    }\n', '}']