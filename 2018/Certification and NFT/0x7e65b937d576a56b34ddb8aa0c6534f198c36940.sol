['/**\n', ' * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.\n', ' * Licensed under the Apache License, Version 2.0.\n', ' */\n', ' \n', 'pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="fb899e969894bbc9">[email&#160;protected]</a>π.com>, Eenae <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="33525f564b564a735e5a4b514a4756401d5a5c">[email&#160;protected]</a>>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '\n', '  /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.\n', '  /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056\n', '  uint private constant REENTRANCY_GUARD_FREE = 1;\n', '\n', '  /// @dev Constant for locked guard state\n', '  uint private constant REENTRANCY_GUARD_LOCKED = 2;\n', '\n', '  /**\n', '   * @dev We use a single lock for the whole contract.\n', '   */\n', '  uint private reentrancyLock = REENTRANCY_GUARD_FREE;\n', '\n', '  /**\n', '   * @dev Prevents a contract from calling itself, directly or indirectly.\n', '   * If you mark a function `nonReentrant`, you should also\n', '   * mark it `external`. Calling one `nonReentrant` function from\n', '   * another is not supported. Instead, you can implement a\n', '   * `private` function doing the actual work, and an `external`\n', '   * wrapper marked as `nonReentrant`.\n', '   */\n', '  modifier nonReentrant() {\n', '    require(reentrancyLock == REENTRANCY_GUARD_FREE);\n', '    reentrancyLock = REENTRANCY_GUARD_LOCKED;\n', '    _;\n', '    reentrancyLock = REENTRANCY_GUARD_FREE;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract GasTracker {\n', '    uint internal gasUsed;\n', '\n', '    modifier tracksGas() {\n', '        // tx call 21k gas\n', '        gasUsed = gasleft() + 21000;\n', '\n', '        _; // modified function body inserted here\n', '\n', '        gasUsed = 0; // zero out the storage so we don&#39;t persist anything\n', '    }\n', '}\n', '\n', 'contract BZxEvents {\n', '\n', '    event LogLoanAdded (\n', '        bytes32 indexed loanOrderHash,\n', '        address adder,\n', '        address indexed maker,\n', '        address indexed feeRecipientAddress,\n', '        uint lenderRelayFee,\n', '        uint traderRelayFee,\n', '        uint maxDuration,\n', '        uint makerRole\n', '    );\n', '\n', '    event LogLoanTaken (\n', '        address indexed lender,\n', '        address indexed trader,\n', '        address collateralTokenAddressFilled,\n', '        address positionTokenAddressFilled,\n', '        uint loanTokenAmountFilled,\n', '        uint collateralTokenAmountFilled,\n', '        uint positionTokenAmountFilled,\n', '        uint loanStartUnixTimestampSec,\n', '        bool active,\n', '        bytes32 indexed loanOrderHash\n', '    );\n', '\n', '    event LogLoanCancelled(\n', '        address indexed maker,\n', '        uint cancelLoanTokenAmount,\n', '        uint remainingLoanTokenAmount,\n', '        bytes32 indexed loanOrderHash\n', '    );\n', '\n', '    event LogLoanClosed(\n', '        address indexed lender,\n', '        address indexed trader,\n', '        address loanCloser,\n', '        bool isLiquidation,\n', '        bytes32 indexed loanOrderHash\n', '    );\n', '\n', '    event LogPositionTraded(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed trader,\n', '        address sourceTokenAddress,\n', '        address destTokenAddress,\n', '        uint sourceTokenAmount,\n', '        uint destTokenAmount\n', '    );\n', '\n', '    event LogMarginLevels(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed trader,\n', '        uint initialMarginAmount,\n', '        uint maintenanceMarginAmount,\n', '        uint currentMarginAmount\n', '    );\n', '\n', '    event LogWithdrawProfit(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed trader,\n', '        uint profitWithdrawn,\n', '        uint remainingPosition\n', '    );\n', '\n', '    event LogPayInterestForOrder(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed lender,\n', '        uint amountPaid,\n', '        uint totalAccrued,\n', '        uint loanCount\n', '    );\n', '\n', '    event LogPayInterestForPosition(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed lender,\n', '        address indexed trader,\n', '        uint amountPaid,\n', '        uint totalAccrued\n', '    );\n', '\n', '    event LogChangeTraderOwnership(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed oldOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    event LogChangeLenderOwnership(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed oldOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    event LogIncreasedLoanableAmount(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed lender,\n', '        uint loanTokenAmountAdded,\n', '        uint loanTokenAmountFillable\n', '    );\n', '}\n', '\n', 'contract BZxObjects {\n', '\n', '    struct ListIndex {\n', '        uint index;\n', '        bool isSet;\n', '    }\n', '\n', '    struct LoanOrder {\n', '        address loanTokenAddress;\n', '        address interestTokenAddress;\n', '        address collateralTokenAddress;\n', '        address oracleAddress;\n', '        uint loanTokenAmount;\n', '        uint interestAmount;\n', '        uint initialMarginAmount;\n', '        uint maintenanceMarginAmount;\n', '        uint maxDurationUnixTimestampSec;\n', '        bytes32 loanOrderHash;\n', '    }\n', '\n', '    struct LoanOrderAux {\n', '        address maker;\n', '        address feeRecipientAddress;\n', '        uint lenderRelayFee;\n', '        uint traderRelayFee;\n', '        uint makerRole;\n', '        uint expirationUnixTimestampSec;\n', '    }\n', '\n', '    struct LoanPosition {\n', '        address trader;\n', '        address collateralTokenAddressFilled;\n', '        address positionTokenAddressFilled;\n', '        uint loanTokenAmountFilled;\n', '        uint loanTokenAmountUsed;\n', '        uint collateralTokenAmountFilled;\n', '        uint positionTokenAmountFilled;\n', '        uint loanStartUnixTimestampSec;\n', '        uint loanEndUnixTimestampSec;\n', '        bool active;\n', '    }\n', '\n', '    struct PositionRef {\n', '        bytes32 loanOrderHash;\n', '        uint positionId;\n', '    }\n', '\n', '    struct InterestData {\n', '        address lender;\n', '        address interestTokenAddress;\n', '        uint interestTotalAccrued;\n', '        uint interestPaidSoFar;\n', '    }\n', '\n', '}\n', '\n', 'contract BZxStorage is BZxObjects, BZxEvents, ReentrancyGuard, Ownable, GasTracker {\n', '    uint internal constant MAX_UINT = 2**256 - 1;\n', '\n', '    address public bZRxTokenContract;\n', '    address public vaultContract;\n', '    address public oracleRegistryContract;\n', '    address public bZxTo0xContract;\n', '    address public bZxTo0xV2Contract;\n', '    bool public DEBUG_MODE = false;\n', '\n', '    // Loan Orders\n', '    mapping (bytes32 => LoanOrder) public orders; // mapping of loanOrderHash to on chain loanOrders\n', '    mapping (bytes32 => LoanOrderAux) public orderAux; // mapping of loanOrderHash to on chain loanOrder auxiliary parameters\n', '    mapping (bytes32 => uint) public orderFilledAmounts; // mapping of loanOrderHash to loanTokenAmount filled\n', '    mapping (bytes32 => uint) public orderCancelledAmounts; // mapping of loanOrderHash to loanTokenAmount cancelled\n', '    mapping (bytes32 => address) public orderLender; // mapping of loanOrderHash to lender (only one lender per order)\n', '\n', '    // Loan Positions\n', '    mapping (uint => LoanPosition) public loanPositions; // mapping of position ids to loanPositions\n', '    mapping (bytes32 => mapping (address => uint)) public loanPositionsIds; // mapping of loanOrderHash to mapping of trader address to position id\n', '\n', '    // Lists\n', '    mapping (address => bytes32[]) public orderList; // mapping of lenders and trader addresses to array of loanOrderHashes\n', '    mapping (bytes32 => mapping (address => ListIndex)) public orderListIndex; // mapping of loanOrderHash to mapping of lenders and trader addresses to ListIndex objects\n', '\n', '    mapping (bytes32 => uint[]) public orderPositionList; // mapping of loanOrderHash to array of order position ids\n', '\n', '    PositionRef[] public positionList; // array of loans that need to be checked for liquidation or expiration\n', '    mapping (uint => ListIndex) public positionListIndex; // mapping of position ids to ListIndex objects\n', '\n', '    // Other Storage\n', '    mapping (bytes32 => mapping (uint => uint)) public interestPaid; // mapping of loanOrderHash to mapping of position ids to amount of interest paid so far to a lender\n', '    mapping (address => address) public oracleAddresses; // mapping of oracles to their current logic contract\n', '    mapping (bytes32 => mapping (address => bool)) public preSigned; // mapping of hash => signer => signed\n', '    mapping (address => mapping (address => bool)) public allowedValidators; // mapping of signer => validator => approved\n', '}\n', '\n', 'contract BZxProxiable {\n', '    mapping (bytes4 => address) public targets;\n', '\n', '    mapping (bytes4 => bool) public targetIsPaused;\n', '\n', '    function initialize(address _target) public;\n', '}\n', '\n', 'contract BZxProxy is BZxStorage, BZxProxiable {\n', '    \n', '    constructor(\n', '        address _settings) \n', '        public\n', '    {\n', '        require(_settings.delegatecall(bytes4(keccak256("initialize(address)")), _settings), "BZxProxy::constructor: failed");\n', '    }\n', '    \n', '    function() \n', '        public\n', '        payable \n', '    {\n', '        require(!targetIsPaused[msg.sig], "BZxProxy::Function temporarily paused");\n', '\n', '        address target = targets[msg.sig];\n', '        require(target != address(0), "BZxProxy::Target not found");\n', '\n', '        bytes memory data = msg.data;\n', '        assembly {\n', '            let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)\n', '            let size := returndatasize\n', '            let ptr := mload(0x40)\n', '            returndatacopy(ptr, 0, size)\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '\n', '    function initialize(\n', '        address)\n', '        public\n', '    {\n', '        revert();\n', '    }\n', '}']
['/**\n', ' * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.\n', ' * Licensed under the Apache License, Version 2.0.\n', ' */\n', ' \n', 'pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '\n', '  /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.\n', '  /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056\n', '  uint private constant REENTRANCY_GUARD_FREE = 1;\n', '\n', '  /// @dev Constant for locked guard state\n', '  uint private constant REENTRANCY_GUARD_LOCKED = 2;\n', '\n', '  /**\n', '   * @dev We use a single lock for the whole contract.\n', '   */\n', '  uint private reentrancyLock = REENTRANCY_GUARD_FREE;\n', '\n', '  /**\n', '   * @dev Prevents a contract from calling itself, directly or indirectly.\n', '   * If you mark a function `nonReentrant`, you should also\n', '   * mark it `external`. Calling one `nonReentrant` function from\n', '   * another is not supported. Instead, you can implement a\n', '   * `private` function doing the actual work, and an `external`\n', '   * wrapper marked as `nonReentrant`.\n', '   */\n', '  modifier nonReentrant() {\n', '    require(reentrancyLock == REENTRANCY_GUARD_FREE);\n', '    reentrancyLock = REENTRANCY_GUARD_LOCKED;\n', '    _;\n', '    reentrancyLock = REENTRANCY_GUARD_FREE;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract GasTracker {\n', '    uint internal gasUsed;\n', '\n', '    modifier tracksGas() {\n', '        // tx call 21k gas\n', '        gasUsed = gasleft() + 21000;\n', '\n', '        _; // modified function body inserted here\n', '\n', "        gasUsed = 0; // zero out the storage so we don't persist anything\n", '    }\n', '}\n', '\n', 'contract BZxEvents {\n', '\n', '    event LogLoanAdded (\n', '        bytes32 indexed loanOrderHash,\n', '        address adder,\n', '        address indexed maker,\n', '        address indexed feeRecipientAddress,\n', '        uint lenderRelayFee,\n', '        uint traderRelayFee,\n', '        uint maxDuration,\n', '        uint makerRole\n', '    );\n', '\n', '    event LogLoanTaken (\n', '        address indexed lender,\n', '        address indexed trader,\n', '        address collateralTokenAddressFilled,\n', '        address positionTokenAddressFilled,\n', '        uint loanTokenAmountFilled,\n', '        uint collateralTokenAmountFilled,\n', '        uint positionTokenAmountFilled,\n', '        uint loanStartUnixTimestampSec,\n', '        bool active,\n', '        bytes32 indexed loanOrderHash\n', '    );\n', '\n', '    event LogLoanCancelled(\n', '        address indexed maker,\n', '        uint cancelLoanTokenAmount,\n', '        uint remainingLoanTokenAmount,\n', '        bytes32 indexed loanOrderHash\n', '    );\n', '\n', '    event LogLoanClosed(\n', '        address indexed lender,\n', '        address indexed trader,\n', '        address loanCloser,\n', '        bool isLiquidation,\n', '        bytes32 indexed loanOrderHash\n', '    );\n', '\n', '    event LogPositionTraded(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed trader,\n', '        address sourceTokenAddress,\n', '        address destTokenAddress,\n', '        uint sourceTokenAmount,\n', '        uint destTokenAmount\n', '    );\n', '\n', '    event LogMarginLevels(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed trader,\n', '        uint initialMarginAmount,\n', '        uint maintenanceMarginAmount,\n', '        uint currentMarginAmount\n', '    );\n', '\n', '    event LogWithdrawProfit(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed trader,\n', '        uint profitWithdrawn,\n', '        uint remainingPosition\n', '    );\n', '\n', '    event LogPayInterestForOrder(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed lender,\n', '        uint amountPaid,\n', '        uint totalAccrued,\n', '        uint loanCount\n', '    );\n', '\n', '    event LogPayInterestForPosition(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed lender,\n', '        address indexed trader,\n', '        uint amountPaid,\n', '        uint totalAccrued\n', '    );\n', '\n', '    event LogChangeTraderOwnership(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed oldOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    event LogChangeLenderOwnership(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed oldOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    event LogIncreasedLoanableAmount(\n', '        bytes32 indexed loanOrderHash,\n', '        address indexed lender,\n', '        uint loanTokenAmountAdded,\n', '        uint loanTokenAmountFillable\n', '    );\n', '}\n', '\n', 'contract BZxObjects {\n', '\n', '    struct ListIndex {\n', '        uint index;\n', '        bool isSet;\n', '    }\n', '\n', '    struct LoanOrder {\n', '        address loanTokenAddress;\n', '        address interestTokenAddress;\n', '        address collateralTokenAddress;\n', '        address oracleAddress;\n', '        uint loanTokenAmount;\n', '        uint interestAmount;\n', '        uint initialMarginAmount;\n', '        uint maintenanceMarginAmount;\n', '        uint maxDurationUnixTimestampSec;\n', '        bytes32 loanOrderHash;\n', '    }\n', '\n', '    struct LoanOrderAux {\n', '        address maker;\n', '        address feeRecipientAddress;\n', '        uint lenderRelayFee;\n', '        uint traderRelayFee;\n', '        uint makerRole;\n', '        uint expirationUnixTimestampSec;\n', '    }\n', '\n', '    struct LoanPosition {\n', '        address trader;\n', '        address collateralTokenAddressFilled;\n', '        address positionTokenAddressFilled;\n', '        uint loanTokenAmountFilled;\n', '        uint loanTokenAmountUsed;\n', '        uint collateralTokenAmountFilled;\n', '        uint positionTokenAmountFilled;\n', '        uint loanStartUnixTimestampSec;\n', '        uint loanEndUnixTimestampSec;\n', '        bool active;\n', '    }\n', '\n', '    struct PositionRef {\n', '        bytes32 loanOrderHash;\n', '        uint positionId;\n', '    }\n', '\n', '    struct InterestData {\n', '        address lender;\n', '        address interestTokenAddress;\n', '        uint interestTotalAccrued;\n', '        uint interestPaidSoFar;\n', '    }\n', '\n', '}\n', '\n', 'contract BZxStorage is BZxObjects, BZxEvents, ReentrancyGuard, Ownable, GasTracker {\n', '    uint internal constant MAX_UINT = 2**256 - 1;\n', '\n', '    address public bZRxTokenContract;\n', '    address public vaultContract;\n', '    address public oracleRegistryContract;\n', '    address public bZxTo0xContract;\n', '    address public bZxTo0xV2Contract;\n', '    bool public DEBUG_MODE = false;\n', '\n', '    // Loan Orders\n', '    mapping (bytes32 => LoanOrder) public orders; // mapping of loanOrderHash to on chain loanOrders\n', '    mapping (bytes32 => LoanOrderAux) public orderAux; // mapping of loanOrderHash to on chain loanOrder auxiliary parameters\n', '    mapping (bytes32 => uint) public orderFilledAmounts; // mapping of loanOrderHash to loanTokenAmount filled\n', '    mapping (bytes32 => uint) public orderCancelledAmounts; // mapping of loanOrderHash to loanTokenAmount cancelled\n', '    mapping (bytes32 => address) public orderLender; // mapping of loanOrderHash to lender (only one lender per order)\n', '\n', '    // Loan Positions\n', '    mapping (uint => LoanPosition) public loanPositions; // mapping of position ids to loanPositions\n', '    mapping (bytes32 => mapping (address => uint)) public loanPositionsIds; // mapping of loanOrderHash to mapping of trader address to position id\n', '\n', '    // Lists\n', '    mapping (address => bytes32[]) public orderList; // mapping of lenders and trader addresses to array of loanOrderHashes\n', '    mapping (bytes32 => mapping (address => ListIndex)) public orderListIndex; // mapping of loanOrderHash to mapping of lenders and trader addresses to ListIndex objects\n', '\n', '    mapping (bytes32 => uint[]) public orderPositionList; // mapping of loanOrderHash to array of order position ids\n', '\n', '    PositionRef[] public positionList; // array of loans that need to be checked for liquidation or expiration\n', '    mapping (uint => ListIndex) public positionListIndex; // mapping of position ids to ListIndex objects\n', '\n', '    // Other Storage\n', '    mapping (bytes32 => mapping (uint => uint)) public interestPaid; // mapping of loanOrderHash to mapping of position ids to amount of interest paid so far to a lender\n', '    mapping (address => address) public oracleAddresses; // mapping of oracles to their current logic contract\n', '    mapping (bytes32 => mapping (address => bool)) public preSigned; // mapping of hash => signer => signed\n', '    mapping (address => mapping (address => bool)) public allowedValidators; // mapping of signer => validator => approved\n', '}\n', '\n', 'contract BZxProxiable {\n', '    mapping (bytes4 => address) public targets;\n', '\n', '    mapping (bytes4 => bool) public targetIsPaused;\n', '\n', '    function initialize(address _target) public;\n', '}\n', '\n', 'contract BZxProxy is BZxStorage, BZxProxiable {\n', '    \n', '    constructor(\n', '        address _settings) \n', '        public\n', '    {\n', '        require(_settings.delegatecall(bytes4(keccak256("initialize(address)")), _settings), "BZxProxy::constructor: failed");\n', '    }\n', '    \n', '    function() \n', '        public\n', '        payable \n', '    {\n', '        require(!targetIsPaused[msg.sig], "BZxProxy::Function temporarily paused");\n', '\n', '        address target = targets[msg.sig];\n', '        require(target != address(0), "BZxProxy::Target not found");\n', '\n', '        bytes memory data = msg.data;\n', '        assembly {\n', '            let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)\n', '            let size := returndatasize\n', '            let ptr := mload(0x40)\n', '            returndatacopy(ptr, 0, size)\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '        }\n', '    }\n', '\n', '    function initialize(\n', '        address)\n', '        public\n', '    {\n', '        revert();\n', '    }\n', '}']
