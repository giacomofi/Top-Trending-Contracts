['pragma solidity 0.4.25;\n', '\n', '// File: contracts/wallet_trading_limiter/interfaces/IWalletsTradingLimiter.sol\n', '\n', '/**\n', ' * @title Wallets Trading Limiter Interface.\n', ' */\n', 'interface IWalletsTradingLimiter {\n', '    /**\n', '     * @dev Increment the limiter value of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @param _value The amount to be updated.\n', '     */\n', '    function updateWallet(address _wallet, uint256 _value) external;\n', '}\n', '\n', '// File: contracts/wallet_trading_limiter/interfaces/IWalletsTradingDataSource.sol\n', '\n', '/**\n', ' * @title Wallets Trading Data Source Interface.\n', ' */\n', 'interface IWalletsTradingDataSource {\n', '    /**\n', '     * @dev Increment the value of a given wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @param _value The value to increment by.\n', '     * @param _limit The limit of the wallet.\n', '     */\n', '    function updateWallet(address _wallet, uint256 _value, uint256 _limit) external;\n', '}\n', '\n', '// File: contracts/wallet_trading_limiter/interfaces/IWalletsTradingLimiterValueConverter.sol\n', '\n', '/**\n', ' * @title Wallets Trading Limiter Value Converter Interface.\n', ' */\n', 'interface IWalletsTradingLimiterValueConverter {\n', '    /**\n', '     * @dev Get the current limiter currency worth of a given SGR amount.\n', '     * @param _sgrAmount The amount of SGR to convert.\n', '     * @return The equivalent amount of the limiter currency.\n', '     */\n', '    function toLimiterValue(uint256 _sgrAmount) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/wallet_trading_limiter/interfaces/ITradingClasses.sol\n', '\n', '/**\n', ' * @title Trading Classes Interface.\n', ' */\n', 'interface ITradingClasses {\n', '    /**\n', '     * @dev Get the complete info of a class.\n', '     * @param _id The id of the class.\n', '     * @return complete info of a class.\n', '     */\n', '    function getInfo(uint256 _id) external view returns (uint256, uint256, uint256);\n', '\n', '    /**\n', '     * @dev Get the action-role of a class.\n', '     * @param _id The id of the class.\n', '     * @return The action-role of the class.\n', '     */\n', '    function getActionRole(uint256 _id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the sell limit of a class.\n', '     * @param _id The id of the class.\n', '     * @return The sell limit of the class.\n', '     */\n', '    function getSellLimit(uint256 _id) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the buy limit of a class.\n', '     * @param _id The id of the class.\n', '     * @return The buy limit of the class.\n', '     */\n', '    function getBuyLimit(uint256 _id) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Interface.\n', ' */\n', 'interface IContractAddressLocator {\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) external view returns (address);\n', '\n', '    /**\n', '     * @dev Determine whether or not a contract address relates to one of the identifiers.\n', '     * @param _contractAddress The contract address to look for.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the contract address relates to one of the identifiers.\n', '     */\n', '    function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);\n', '}\n', '\n', '// File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol\n', '\n', '/**\n', ' * @title Contract Address Locator Holder.\n', ' * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.\n', ' * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.\n', ' * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.\n', ' * @dev In addition to that, any function in any contract can be restricted to a specific caller.\n', ' */\n', 'contract ContractAddressLocatorHolder {\n', '    bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";\n', '    bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;\n', '    bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;\n', '    bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;\n', '    bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;\n', '    bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;\n', '    bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;\n', '    bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;\n', '    bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;\n', '    bytes32 internal constant _IMintListener_            = "IMintListener"           ;\n', '    bytes32 internal constant _IMintManager_             = "IMintManager"            ;\n', '    bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;\n', '    bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;\n', '    bytes32 internal constant _IRedButton_               = "IRedButton"              ;\n', '    bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;\n', '    bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;\n', '    bytes32 internal constant _ISogurExchanger_           = "ISogurExchanger"          ;\n', '    bytes32 internal constant _SgnToSgrExchangeInitiator_ = "SgnToSgrExchangeInitiator"          ;\n', '    bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;\n', '    bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;\n', '    bytes32 internal constant _ISGRAuthorizationManager_ = "ISGRAuthorizationManager";\n', '    bytes32 internal constant _ISGRToken_                = "ISGRToken"               ;\n', '    bytes32 internal constant _ISGRTokenManager_         = "ISGRTokenManager"        ;\n', '    bytes32 internal constant _ISGRTokenInfo_         = "ISGRTokenInfo"        ;\n', '    bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";\n', '    bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;\n', '    bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;\n', '    bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;\n', '    bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;\n', '    bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;\n', '    bytes32 internal constant _BuyWalletsTradingDataSource_       = "BuyWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _SellWalletsTradingDataSource_       = "SellWalletsTradingDataSource"      ;\n', '    bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;\n', '    bytes32 internal constant _BuyWalletsTradingLimiter_SGRTokenManager_          = "BuyWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _SellWalletsTradingLimiter_SGRTokenManager_          = "SellWalletsTLSGRTokenManager"         ;\n', '    bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;\n', '    bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;\n', '    bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;\n', '    bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;\n', '    bytes32 internal constant _SGAToSGRInitializer_      = "SGAToSGRInitializer"     ;\n', '\n', '    IContractAddressLocator private contractAddressLocator;\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) internal {\n', '        require(_contractAddressLocator != address(0), "locator is illegal");\n', '        contractAddressLocator = _contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address locator.\n', '     * @return The contract address locator.\n', '     */\n', '    function getContractAddressLocator() external view returns (IContractAddressLocator) {\n', '        return contractAddressLocator;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract address mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     * @return The contract address.\n', '     */\n', '    function getContractAddress(bytes32 _identifier) internal view returns (address) {\n', '        return contractAddressLocator.getContractAddress(_identifier);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '     * @dev Determine whether or not the sender relates to one of the identifiers.\n', '     * @param _identifiers The identifiers.\n', '     * @return A boolean indicating if the sender relates to one of the identifiers.\n', '     */\n', '    function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {\n', '        return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);\n', '    }\n', '\n', '    /**\n', '     * @dev Verify that the caller is mapped to a given identifier.\n', '     * @param _identifier The identifier.\n', '     */\n', '    modifier only(bytes32 _identifier) {\n', '        require(msg.sender == getContractAddress(_identifier), "caller is illegal");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/authorization/interfaces/IAuthorizationDataSource.sol\n', '\n', '/**\n', ' * @title Authorization Data Source Interface.\n', ' */\n', 'interface IAuthorizationDataSource {\n', '    /**\n', '     * @dev Get the authorized action-role of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The authorized action-role of the wallet.\n', '     */\n', '    function getAuthorizedActionRole(address _wallet) external view returns (bool, uint256);\n', '\n', '    /**\n', '     * @dev Get the authorized action-role and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The authorized action-role and class of the wallet.\n', '     */\n', '    function getAuthorizedActionRoleAndClass(address _wallet) external view returns (bool, uint256, uint256);\n', '\n', '    /**\n', '     * @dev Get all the trade-limits and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The trade-limits and trade-class of the wallet.\n', '     */\n', '    function getTradeLimitsAndClass(address _wallet) external view returns (uint256, uint256, uint256);\n', '\n', '\n', '    /**\n', '     * @dev Get the buy trade-limit and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The buy trade-limit and trade-class of the wallet.\n', '     */\n', '    function getBuyTradeLimitAndClass(address _wallet) external view returns (uint256, uint256);\n', '\n', '    /**\n', '     * @dev Get the sell trade-limit and trade-class of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @return The sell trade-limit and trade-class of the wallet.\n', '     */\n', '    function getSellTradeLimitAndClass(address _wallet) external view returns (uint256, uint256);\n', '}\n', '\n', '// File: openzeppelin-solidity-v1.12.0/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity-v1.12.0/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() public onlyPendingOwner {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '// File: contracts/wallet_trading_limiter/WalletsTradingLimiterBase.sol\n', '\n', '/**\n', ' * Details of usage of licenced software see here: https://www.sogur.com/software/readme_v1\n', ' */\n', '\n', '/**\n', ' * @title Wallets Trading Limiter Base.\n', ' */\n', 'contract WalletsTradingLimiterBase is IWalletsTradingLimiter, ContractAddressLocatorHolder, Claimable {\n', '    string public constant VERSION = "1.1.0";\n', '\n', '    bytes32 public walletsTradingDataSourceIdentifier;\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator, bytes32 _walletsTradingDataSourceIdentifier) ContractAddressLocatorHolder(_contractAddressLocator) public {\n', '        walletsTradingDataSourceIdentifier = _walletsTradingDataSourceIdentifier;\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IAuthorizationDataSource interface.\n', '     */\n', '    function getAuthorizationDataSource() public view returns (IAuthorizationDataSource) {\n', '        return IAuthorizationDataSource(getContractAddress(_IAuthorizationDataSource_));\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the ITradingClasses interface.\n', '     */\n', '    function getTradingClasses() public view returns (ITradingClasses) {\n', '        return ITradingClasses(getContractAddress(_ITradingClasses_));\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IWalletsTradingDataSource interface.\n', '     */\n', '    function getWalletsTradingDataSource() public view returns (IWalletsTradingDataSource) {\n', '        return IWalletsTradingDataSource(getContractAddress(walletsTradingDataSourceIdentifier));\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IWalletsTradingLimiterValueConverter interface.\n', '     */\n', '    function getWalletsTradingLimiterValueConverter() public view returns (IWalletsTradingLimiterValueConverter) {\n', '        return IWalletsTradingLimiterValueConverter(getContractAddress(_IWalletsTradingLimiterValueConverter_));\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract locator identifier that is permitted to perform update wallet.\n', '     * @return The contract locator identifier.\n', '     */\n', '    function getUpdateWalletPermittedContractLocatorIdentifier() public pure returns (bytes32);\n', '\n', '    /**\n', '     * @dev Get the wallet override trade-limit and class.\n', '     * @return The wallet override trade-limit and class.\n', '     */\n', '    function getOverrideTradeLimitAndClass(address _wallet) public view returns (uint256, uint256);\n', '\n', '    /**\n', '     * @dev Get the wallet trade-limit.\n', '     * @return The wallet trade-limit.\n', '     */\n', '    function getTradeLimit(uint256 _tradeClassId) public view returns (uint256);\n', '\n', '    /**\n', '     * @dev Get the limiter value.\n', '     * @param _value The amount to be converted to the limiter value.\n', '     * @return The limiter value worth of the given amount.\n', '     */\n', '    function getLimiterValue(uint256 _value) public view returns (uint256);\n', '\n', '\n', '    /**\n', '     * @dev Increment the limiter value of a wallet.\n', '     * @param _wallet The address of the wallet.\n', '     * @param _value The amount to be updated.\n', '     */\n', '    function updateWallet(address _wallet, uint256 _value) external only(getUpdateWalletPermittedContractLocatorIdentifier()) {\n', '        uint256 limiterValue = getLimiterValue(_value);\n', '\n', '        (uint256 overrideTradeLimit, uint256 tradeClassId) = getOverrideTradeLimitAndClass(_wallet);\n', '\n', '        uint256 tradeLimit = overrideTradeLimit > 0 ? overrideTradeLimit : getTradeLimit(tradeClassId);\n', '\n', '        getWalletsTradingDataSource().updateWallet(_wallet, limiterValue, tradeLimit);\n', '    }\n', '}\n', '\n', '// File: contracts/saga-genesis/interfaces/IMintManager.sol\n', '\n', '/**\n', ' * @title Mint Manager Interface.\n', ' */\n', 'interface IMintManager {\n', '    /**\n', '     * @dev Return the current minting-point index.\n', '     */\n', '    function getIndex() external view returns (uint256);\n', '}\n', '\n', '// File: contracts/saga-genesis/interfaces/ISGNConversionManager.sol\n', '\n', '/**\n', ' * @title SGN Conversion Manager Interface.\n', ' */\n', 'interface ISGNConversionManager {\n', '    /**\n', '     * @dev Compute the SGR worth of a given SGN amount at a given minting-point.\n', '     * @param _amount The amount of SGN.\n', '     * @param _index The minting-point index.\n', '     * @return The equivalent amount of SGR.\n', '     */\n', '    function sgn2sgr(uint256 _amount, uint256 _index) external view returns (uint256);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/Math.sol\n', '\n', '/**\n', ' * @title Math\n', ' * @dev Assorted math operations\n', ' */\n', 'library Math {\n', '  /**\n', '  * @dev Returns the largest of two numbers.\n', '  */\n', '  function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  /**\n', '  * @dev Returns the smallest of two numbers.\n', '  */\n', '  function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  /**\n', '  * @dev Calculates the average of two numbers. Since these are integers,\n', '  * averages of an even and odd number cannot be represented, and will be\n', '  * rounded down.\n', '  */\n', '  function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // (a + b) / 2 can overflow, so we distribute\n', '    return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: contracts/saga-genesis/SGNWalletsTradingLimiter.sol\n', '\n', '/**\n', ' * Details of usage of licenced software see here: https://www.sogur.com/software/readme_v1\n', ' */\n', '\n', '/**\n', ' * @title SGN Wallets Trading Limiter.\n', ' */\n', 'contract SGNWalletsTradingLimiter is WalletsTradingLimiterBase {\n', '    string public constant VERSION = "1.1.1";\n', '\n', '    using SafeMath for uint256;\n', '    using Math for uint256;\n', '\n', '    /**\n', '     * @dev SGN minimum limiter value maximum resolution.\n', '     * @notice Allow for sufficiently-high resolution.\n', '     * @notice Prevents multiplication-overflow.\n', '     */\n', '    uint256 public constant MAX_RESOLUTION = 0x10000000000000000;\n', '\n', '    uint256 public sequenceNum = 0;\n', '    uint256 public sgnMinimumLimiterValueN = 0;\n', '    uint256 public sgnMinimumLimiterValueD = 0;\n', '\n', '    event SGNMinimumLimiterValueSaved(uint256 _sgnMinimumLimiterValueN, uint256 _sgnMinimumLimiterValueD);\n', '    event SGNMinimumLimiterValueNotSaved(uint256 _sgnMinimumLimiterValueN, uint256 _sgnMinimumLimiterValueD);\n', '\n', '    /**\n', '     * @dev Create the contract.\n', '     * @param _contractAddressLocator The contract address locator.\n', '     */\n', '    constructor(IContractAddressLocator _contractAddressLocator) WalletsTradingLimiterBase(_contractAddressLocator, _BuyWalletsTradingDataSource_) public {}\n', '\n', '    /**\n', '     * @dev Return the contract which implements the ISGNConversionManager interface.\n', '     */\n', '    function getSGNConversionManager() public view returns (ISGNConversionManager) {\n', '        return ISGNConversionManager(getContractAddress(_ISGNConversionManager_));\n', '    }\n', '\n', '    /**\n', '     * @dev Return the contract which implements the IMintManager interface.\n', '     */\n', '    function getMintManager() public view returns (IMintManager) {\n', '        return IMintManager(getContractAddress(_IMintManager_));\n', '    }\n', '\n', '    /**\n', '     * @dev Get the limiter value.\n', '     * @param _value The SGN amount to convert to limiter value.\n', '     * @return The limiter value worth of the given SGN amount.\n', '     */\n', '    function getLimiterValue(uint256 _value) public view returns (uint256){\n', '        uint256 sgnMinimumLimiterValue = calcSGNMinimumLimiterValue(_value);\n', '        uint256 sgnConversionValue = calcSGNConversionValue(_value);\n', '\n', '        return sgnConversionValue.max(sgnMinimumLimiterValue);\n', '    }\n', '\n', '    /**\n', '     * @dev Get the contract locator identifier that is permitted to perform update wallet.\n', '     * @return The contract locator identifier.\n', '     */\n', '    function getUpdateWalletPermittedContractLocatorIdentifier() public pure returns (bytes32){\n', '        return _ISGNTokenManager_;\n', '    }\n', '\n', '    /**\n', '     * @dev Get the wallet override trade-limit and class.\n', '     * @return The wallet override trade-limit and class.\n', '     */\n', '    function getOverrideTradeLimitAndClass(address _wallet) public view returns (uint256, uint256){\n', '        return getAuthorizationDataSource().getBuyTradeLimitAndClass(_wallet);\n', '    }\n', '\n', '    /**\n', '     * @dev Get the wallet trade-limit.\n', '     * @return The wallet trade-limit.\n', '     */\n', '    function getTradeLimit(uint256 _tradeClassId) public view returns (uint256){\n', '        return getTradingClasses().getBuyLimit(_tradeClassId);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate SGN minimum limiter value.\n', '     * @param _sgnAmount The given SGN amount.\n', '     * @return The calculated SGN minimum limiter value.\n', '     */\n', '    function calcSGNMinimumLimiterValue(uint256 _sgnAmount) public view returns (uint256) {\n', '        assert(sgnMinimumLimiterValueN > 0 && sgnMinimumLimiterValueD > 0);\n', '        return _sgnAmount.mul(sgnMinimumLimiterValueN) / sgnMinimumLimiterValueD;\n', '    }\n', '\n', '    /**\n', '     * @dev Set SGN minimum value.\n', '     * @param _sequenceNum The sequence-number of the operation.\n', '     * @param _sgnMinimumLimiterValueN The numerator of the SGN minimum limiter value.\n', '     * @param _sgnMinimumLimiterValueD The denominator of the SGN minimum limiter value.\n', '     */\n', '    function setSGNMinimumLimiterValue(uint256 _sequenceNum, uint256 _sgnMinimumLimiterValueN, uint256 _sgnMinimumLimiterValueD) external onlyOwner {\n', '        require(1 <= _sgnMinimumLimiterValueN && _sgnMinimumLimiterValueN <= MAX_RESOLUTION, "SGN minimum limiter value numerator is out of range");\n', '        require(1 <= _sgnMinimumLimiterValueD && _sgnMinimumLimiterValueD <= MAX_RESOLUTION, "SGN minimum limiter value denominator is out of range");\n', '\n', '        if (sequenceNum < _sequenceNum) {\n', '            sequenceNum = _sequenceNum;\n', '            sgnMinimumLimiterValueN = _sgnMinimumLimiterValueN;\n', '            sgnMinimumLimiterValueD = _sgnMinimumLimiterValueD;\n', '            emit SGNMinimumLimiterValueSaved(_sgnMinimumLimiterValueN, _sgnMinimumLimiterValueD);\n', '        }\n', '        else {\n', '            emit SGNMinimumLimiterValueNotSaved(_sgnMinimumLimiterValueN, _sgnMinimumLimiterValueD);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate SGN conversion value.\n', '     * @param _sgnAmount The SGN amount to convert to limiter value.\n', '     * @return The limiter value worth of the given SGN.\n', '     */\n', '    function calcSGNConversionValue(uint256 _sgnAmount) private view returns (uint256) {\n', '        uint256 sgrAmount = getSGNConversionManager().sgn2sgr(_sgnAmount, getMintManager().getIndex());\n', '        return getWalletsTradingLimiterValueConverter().toLimiterValue(sgrAmount);\n', '    }\n', '\n', '\n', '}']