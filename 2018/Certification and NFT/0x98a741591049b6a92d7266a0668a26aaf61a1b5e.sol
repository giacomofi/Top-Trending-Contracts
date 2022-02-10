['pragma solidity ^0.4.24;\n', '\n', '// File: contracts/bancorx/interfaces/IBancorXUpgrader.sol\n', '\n', '/*\n', '    Bancor X Upgrader interface\n', '*/\n', 'contract IBancorXUpgrader {\n', '    function upgrade(uint16 _version, address[] _reporters) public;\n', '}\n', '\n', '// File: contracts/ContractIds.sol\n', '\n', '/**\n', '    Id definitions for bancor contracts\n', '\n', '    Can be used in conjunction with the contract registry to get contract addresses\n', '*/\n', 'contract ContractIds {\n', '    // generic\n', '    bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";\n', '    bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";\n', '\n', '    // bancor logic\n', '    bytes32 public constant BANCOR_NETWORK = "BancorNetwork";\n', '    bytes32 public constant BANCOR_FORMULA = "BancorFormula";\n', '    bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";\n', '    bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";\n', '    bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";\n', '\n', '    // BNT core\n', '    bytes32 public constant BNT_TOKEN = "BNTToken";\n', '    bytes32 public constant BNT_CONVERTER = "BNTConverter";\n', '\n', '    // BancorX\n', '    bytes32 public constant BANCOR_X = "BancorX";\n', '    bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";\n', '}\n', '\n', '// File: contracts/token/interfaces/IERC20Token.sol\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// File: contracts/utility/interfaces/IWhitelist.sol\n', '\n', '/*\n', '    Whitelist interface\n', '*/\n', 'contract IWhitelist {\n', '    function isWhitelisted(address _address) public view returns (bool);\n', '}\n', '\n', '// File: contracts/converter/interfaces/IBancorConverter.sol\n', '\n', '/*\n', '    Bancor Converter interface\n', '*/\n', 'contract IBancorConverter {\n', '    function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);\n', '    function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);\n', '    function conversionWhitelist() public view returns (IWhitelist) {}\n', '    function conversionFee() public view returns (uint32) {}\n', '    function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }\n', '    function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);\n', '    function claimTokens(address _from, uint256 _amount) public;\n', '    // deprecated, backward compatibility\n', '    function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);\n', '}\n', '\n', '// File: contracts/utility/interfaces/IContractRegistry.sol\n', '\n', '/*\n', '    Contract Registry interface\n', '*/\n', 'contract IContractRegistry {\n', '    function addressOf(bytes32 _contractName) public view returns (address);\n', '\n', '    // deprecated, backward compatibility\n', '    function getAddress(bytes32 _contractName) public view returns (address);\n', '}\n', '\n', '// File: contracts/utility/interfaces/IOwned.sol\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', "    // this function isn't abstract since the compiler emits automatically generated getter functions as external\n", '    function owner() public view returns (address) {}\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '// File: contracts/utility/Owned.sol\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/utility/SafeMath.sol\n', '\n', '/*\n', '    Library for basic math operations with overflow/underflow protection\n', '*/\n', 'library SafeMath {\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function add(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the calculation underflows\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        // gas optimization\n', '        if (_x == 0)\n', '            return 0;\n', '\n', '        uint256 z = _x * _y;\n', '        assert(z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '// File: contracts/utility/Utils.sol\n', '\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '    /**\n', '        constructor\n', '    */\n', '    constructor() public {\n', '    }\n', '\n', '    // verifies that an amount is greater than zero\n', '    modifier greaterThanZero(uint256 _amount) {\n', '        require(_amount > 0);\n', '        _;\n', '    }\n', '\n', "    // validates an address - currently only checks that it isn't null\n", '    modifier validAddress(address _address) {\n', '        require(_address != address(0));\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '// File: contracts/utility/interfaces/ITokenHolder.sol\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '// File: contracts/utility/TokenHolder.sol\n', '\n', '/*\n', "    We consider every contract to be a 'token holder' since it's currently not possible\n", '    for a contract to deny receiving tokens.\n', '\n', "    The TokenHolder's contract sole purpose is to provide a safety mechanism that allows\n", '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned, Utils {\n', '    /**\n', '        @dev constructor\n', '    */\n', '    constructor() public {\n', '    }\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '// File: contracts/token/interfaces/ISmartToken.sol\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract ISmartToken is IOwned, IERC20Token {\n', '    function disableTransfers(bool _disable) public;\n', '    function issue(address _to, uint256 _amount) public;\n', '    function destroy(address _from, uint256 _amount) public;\n', '}\n', '\n', '// File: contracts/bancorx/BancorX.sol\n', '\n', '/*\n', '    The BancorX contract allows cross chain token transfers.\n', '\n', '    There are two processes that take place in the contract -\n', '    - Initiate a cross chain transfer to a target blockchain (locks tokens from the caller account on Ethereum)\n', '    - Report a cross chain transfer initiated on a source blockchain (releases tokens to an account on Ethereum)\n', '\n', '    Reporting cross chain transfers works similar to standard multisig contracts, meaning that multiple\n', '    callers are required to report a transfer before tokens are released to the target account.\n', '*/\n', 'contract BancorX is Owned, TokenHolder, ContractIds {\n', '    using SafeMath for uint256;\n', '\n', '    // represents a transaction on another blockchain where BNT was destroyed/locked\n', '    struct Transaction {\n', '        uint256 amount;\n', '        bytes32 fromBlockchain;\n', '        address to;\n', '        uint8 numOfReports;\n', '        bool completed;\n', '    }\n', '\n', '    uint16 public version = 1;\n', '\n', '    uint256 public maxLockLimit;            // the maximum amount of BNT that can be locked in one transaction\n', '    uint256 public maxReleaseLimit;         // the maximum amount of BNT that can be released in one transaction\n', '    uint256 public minLimit;                // the minimum amount of BNT that can be transferred in one transaction\n', '    uint256 public prevLockLimit;           // the lock limit *after* the last transaction\n', '    uint256 public prevReleaseLimit;        // the release limit *after* the last transaction\n', '    uint256 public limitIncPerBlock;        // how much the limit increases per block\n', '    uint256 public prevLockBlockNumber;     // the block number of the last lock transaction\n', '    uint256 public prevReleaseBlockNumber;  // the block number of the last release transaction\n', '    uint256 public minRequiredReports;      // minimum number of required reports to release tokens\n', '    \n', '    IContractRegistry public registry;      // contract registry\n', '    IContractRegistry public prevRegistry;  // address of previous registry as security mechanism\n', '    IBancorConverter public bntConverter;   // BNT converter\n', '    ISmartToken public bntToken;            // BNT token\n', '\n', '    bool public xTransfersEnabled = true;   // true if x transfers are enabled, false if not\n', '    bool public reportingEnabled = true;    // true if reporting is enabled, false if not\n', '    bool public allowRegistryUpdate = true; // allows the owner to prevent/allow the registry to be updated\n', '\n', '    // txId -> Transaction\n', '    mapping (uint256 => Transaction) public transactions;\n', '\n', '    // txId -> reporter -> true if reporter already reported txId\n', '    mapping (uint256 => mapping (address => bool)) public reportedTxs;\n', '\n', '    // address -> true if address is reporter\n', '    mapping (address => bool) public reporters;\n', '\n', '    // triggered when BNT is locked in smart contract\n', '    event TokensLock(\n', '        address indexed _from,\n', '        uint256 _amount\n', '    );\n', '\n', '    // triggered when BNT is released by the smart contract\n', '    event TokensRelease(\n', '        address indexed _to,\n', '        uint256 _amount\n', '    );\n', '\n', '    // triggered when xTransfer is successfully called\n', '    event XTransfer(\n', '        address indexed _from,\n', '        bytes32 _toBlockchain,\n', '        bytes32 indexed _to,\n', '        uint256 _amount\n', '    );\n', '\n', '    // triggered when report is successfully submitted\n', '    event TxReport(\n', '        address indexed _reporter,\n', '        bytes32 _fromBlockchain,\n', '        uint256 _txId,\n', '        address _to,\n', '        uint256 _amount\n', '    );\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _maxLockLimit          maximum amount of BNT that can be locked in one transaction\n', '        @param _maxReleaseLimit       maximum amount of BNT that can be released in one transaction\n', '        @param _minLimit              minimum amount of BNT that can be transferred in one transaction\n', '        @param _limitIncPerBlock      how much the limit increases per block\n', '        @param _minRequiredReports    minimum number of reporters to report transaction before tokens can be released\n', '        @param _registry              address of contract registry\n', '     */\n', '    constructor(\n', '        uint256 _maxLockLimit,\n', '        uint256 _maxReleaseLimit,\n', '        uint256 _minLimit,\n', '        uint256 _limitIncPerBlock,\n', '        uint256 _minRequiredReports,\n', '        address _registry\n', '    )\n', '        public\n', '    {\n', '        // the maximum limits, minimum limit, and limit increase per block\n', '        maxLockLimit = _maxLockLimit;\n', '        maxReleaseLimit = _maxReleaseLimit;\n', '        minLimit = _minLimit;\n', '        limitIncPerBlock = _limitIncPerBlock;\n', '        minRequiredReports = _minRequiredReports;\n', '\n', '        // previous limit is _maxLimit, and previous block number is current block number\n', '        prevLockLimit = _maxLockLimit;\n', '        prevReleaseLimit = _maxReleaseLimit;\n', '        prevLockBlockNumber = block.number;\n', '        prevReleaseBlockNumber = block.number;\n', '\n', '        registry = IContractRegistry(_registry);\n', '        prevRegistry = IContractRegistry(_registry);\n', '        bntToken = ISmartToken(registry.addressOf(ContractIds.BNT_TOKEN));\n', '        bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));\n', '    }\n', '\n', '    // validates that the caller is a reporter\n', '    modifier isReporter {\n', '        require(reporters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    // allows execution only when x transfers are enabled\n', '    modifier whenXTransfersEnabled {\n', '        require(xTransfersEnabled);\n', '        _;\n', '    }\n', '\n', '    // allows execution only when reporting is enabled\n', '    modifier whenReportingEnabled {\n', '        require(reportingEnabled);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev setter\n', '\n', '        @param _maxLockLimit    new maxLockLimit\n', '     */\n', '    function setMaxLockLimit(uint256 _maxLockLimit) public ownerOnly {\n', '        maxLockLimit = _maxLockLimit;\n', '    }\n', '    \n', '    /**\n', '        @dev setter\n', '\n', '        @param _maxReleaseLimit    new maxReleaseLimit\n', '     */\n', '    function setMaxReleaseLimit(uint256 _maxReleaseLimit) public ownerOnly {\n', '        maxReleaseLimit = _maxReleaseLimit;\n', '    }\n', '    \n', '    /**\n', '        @dev setter\n', '\n', '        @param _minLimit    new minLimit\n', '     */\n', '    function setMinLimit(uint256 _minLimit) public ownerOnly {\n', '        minLimit = _minLimit;\n', '    }\n', '\n', '    /**\n', '        @dev setter\n', '\n', '        @param _limitIncPerBlock    new limitIncPerBlock\n', '     */\n', '    function setLimitIncPerBlock(uint256 _limitIncPerBlock) public ownerOnly {\n', '        limitIncPerBlock = _limitIncPerBlock;\n', '    }\n', '\n', '    /**\n', '        @dev setter\n', '\n', '        @param _minRequiredReports    new minRequiredReports\n', '     */\n', '    function setMinRequiredReports(uint256 _minRequiredReports) public ownerOnly {\n', '        minRequiredReports = _minRequiredReports;\n', '    }\n', '\n', '    /**\n', '        @dev allows the owner to set/remove reporters\n', '\n', '        @param _reporter    reporter whos status is to be set\n', '        @param _active      true if the reporter is approved, false otherwise\n', '     */\n', '    function setReporter(address _reporter, bool _active) public ownerOnly {\n', '        reporters[_reporter] = _active;\n', '    }\n', '\n', '    /**\n', '        @dev allows the owner enable/disable the xTransfer method\n', '\n', '        @param _enable     true to enable, false to disable\n', '     */\n', '    function enableXTransfers(bool _enable) public ownerOnly {\n', '        xTransfersEnabled = _enable;\n', '    }\n', '\n', '    /**\n', '        @dev allows the owner enable/disable the reportTransaction method\n', '\n', '        @param _enable     true to enable, false to disable\n', '     */\n', '    function enableReporting(bool _enable) public ownerOnly {\n', '        reportingEnabled = _enable;\n', '    }\n', '\n', '    /**\n', '        @dev disables the registry update functionality\n', '        this is a safety mechanism in case of a emergency\n', '        can only be called by the manager or owner\n', '\n', '        @param _disable    true to disable registry updates, false to re-enable them\n', '    */\n', '    function disableRegistryUpdate(bool _disable) public ownerOnly {\n', '        allowRegistryUpdate = !_disable;\n', '    }\n', '\n', '    /**\n', '        @dev allows the owner to set the BNT converters address to wherever the\n', '        contract registry currently points to\n', '     */\n', '    function setBNTConverterAddress() public ownerOnly {\n', '        bntConverter = IBancorConverter(registry.addressOf(ContractIds.BNT_CONVERTER));\n', '    }\n', '\n', '    /**\n', '        @dev sets the contract registry to whichever address the current registry is pointing to\n', '     */\n', '    function updateRegistry() public {\n', '        // require that upgrading is allowed or that the caller is the owner\n', '        require(allowRegistryUpdate || msg.sender == owner);\n', '\n', '        // get the address of whichever registry the current registry is pointing to\n', '        address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);\n', '\n', "        // if the new registry hasn't changed or is the zero address, revert\n", '        require(newRegistry != address(registry) && newRegistry != address(0));\n', '\n', '        // set the previous registry as current registry and current registry as newRegistry\n', '        prevRegistry = registry;\n', '        registry = IContractRegistry(newRegistry);\n', '    }\n', '\n', '    /**\n', '        @dev security mechanism allowing the converter owner to revert to the previous registry,\n', '        to be used in emergency scenario\n', '    */\n', '    function restoreRegistry() public ownerOnly {\n', '        // set the registry as previous registry\n', '        registry = prevRegistry;\n', '\n', '        // after a previous registry is restored, only the owner can allow future updates\n', '        allowRegistryUpdate = false;\n', '    }\n', '\n', '    /**\n', '        @dev upgrades the contract to the latest version\n', '        can only be called by the owner\n', '        note that the owner needs to call acceptOwnership on the new contract after the upgrade\n', '\n', '        @param _reporters    new list of reporters\n', '    */\n', '    function upgrade(address[] _reporters) public ownerOnly {\n', '        IBancorXUpgrader bancorXUpgrader = IBancorXUpgrader(registry.addressOf(ContractIds.BANCOR_X_UPGRADER));\n', '\n', '        transferOwnership(bancorXUpgrader);\n', '        bancorXUpgrader.upgrade(version, _reporters);\n', '        acceptOwnership();\n', '    }\n', '\n', '    /**\n', '        @dev claims BNT from msg.sender to be converted to BNT on another blockchain\n', '\n', '        @param _toBlockchain    blockchain BNT will be issued on\n', '        @param _to              address to send the BNT to\n', '        @param _amount          the amount to transfer\n', '     */\n', '    function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount) public whenXTransfersEnabled {\n', '        // get the current lock limit\n', '        uint256 currentLockLimit = getCurrentLockLimit();\n', '\n', '        // require that; minLimit <= _amount <= currentLockLimit\n', '        require(_amount >= minLimit && _amount <= currentLockLimit);\n', '        \n', '        lockTokens(_amount);\n', '\n', '        // set the previous lock limit and block number\n', '        prevLockLimit = currentLockLimit.sub(_amount);\n', '        prevLockBlockNumber = block.number;\n', '\n', '        emit XTransfer(msg.sender, _toBlockchain, _to, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev allows reporter to report transaction which occured on another blockchain\n', '\n', '        @param _fromBlockchain  blockchain BNT was destroyed in\n', '        @param _txId            transactionId of transaction thats being reported\n', '        @param _to              address to receive BNT\n', '        @param _amount          amount of BNT destroyed on another blockchain\n', '     */\n', '    function reportTx(\n', '        bytes32 _fromBlockchain,\n', '        uint256 _txId,\n', '        address _to,\n', '        uint256 _amount    \n', '    )\n', '        public\n', '        isReporter\n', '        whenReportingEnabled\n', '    {\n', '        // require that the transaction has not been reported yet by the reporter\n', '        require(!reportedTxs[_txId][msg.sender]);\n', '\n', '        // set reported as true\n', '        reportedTxs[_txId][msg.sender] = true;\n', '\n', '        Transaction storage txn = transactions[_txId];\n', '\n', '        // If the caller is the first reporter, set the transaction details\n', '        if (txn.numOfReports == 0) {\n', '            txn.to = _to;\n', '            txn.amount = _amount;\n', '            txn.fromBlockchain = _fromBlockchain;\n', '        } else {\n', '            // otherwise, verify transaction details\n', '            require(txn.to == _to && txn.amount == _amount && txn.fromBlockchain == _fromBlockchain);\n', '        }\n', '        \n', '        // increment the number of reports\n', '        txn.numOfReports++;\n', '\n', '        emit TxReport(msg.sender, _fromBlockchain, _txId, _to, _amount);\n', '\n', '        // if theres enough reports, try to release tokens\n', '        if (txn.numOfReports >= minRequiredReports) {\n', '            require(!transactions[_txId].completed);\n', '\n', '            // set the transaction as completed\n', '            transactions[_txId].completed = true;\n', '\n', '            releaseTokens(_to, _amount);\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev method for calculating current lock limit\n', '\n', '        @return the current maximum limit of BNT that can be locked\n', '     */\n', '    function getCurrentLockLimit() public view returns (uint256) {\n', '        // prevLockLimit + ((currBlockNumber - prevLockBlockNumber) * limitIncPerBlock)\n', '        uint256 currentLockLimit = prevLockLimit.add(((block.number).sub(prevLockBlockNumber)).mul(limitIncPerBlock));\n', '        if (currentLockLimit > maxLockLimit)\n', '            return maxLockLimit;\n', '        return currentLockLimit;\n', '    }\n', ' \n', '    /**\n', '        @dev method for calculating current release limit\n', '\n', '        @return the current maximum limit of BNT that can be released\n', '     */\n', '    function getCurrentReleaseLimit() public view returns (uint256) {\n', '        // prevReleaseLimit + ((currBlockNumber - prevReleaseBlockNumber) * limitIncPerBlock)\n', '        uint256 currentReleaseLimit = prevReleaseLimit.add(((block.number).sub(prevReleaseBlockNumber)).mul(limitIncPerBlock));\n', '        if (currentReleaseLimit > maxReleaseLimit)\n', '            return maxReleaseLimit;\n', '        return currentReleaseLimit;\n', '    }\n', '\n', '    /**\n', '        @dev claims and locks BNT from msg.sender to be converted to BNT on another blockchain\n', '\n', '        @param _amount  the amount to lock\n', '     */\n', '    function lockTokens(uint256 _amount) private {\n', '        // lock the BNT from msg.sender in this contract\n', '        bntConverter.claimTokens(msg.sender, _amount);\n', '\n', '        emit TokensLock(msg.sender, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev private method to release BNT the contract holds\n', '\n', '        @param _to      the address to release BNT to\n', '        @param _amount  the amount to release\n', '     */\n', '    function releaseTokens(address _to, uint256 _amount) private {\n', '        // get the current release limit\n', '        uint256 currentReleaseLimit = getCurrentReleaseLimit();\n', '\n', '        require(_amount >= minLimit && _amount <= currentReleaseLimit);\n', '        \n', '        // update the previous release limit and block number\n', '        prevReleaseLimit = currentReleaseLimit.sub(_amount);\n', '        prevReleaseBlockNumber = block.number;\n', '\n', '        // no need to require, reverts on failure\n', '        bntToken.transfer(_to, _amount);\n', '\n', '        emit TokensRelease(_to, _amount);\n', '    }\n', '}']