['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-08\n', '*/\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '\n', '/**\n', "  * @title Bird's BController Interface\n", '  */\n', 'contract BControllerInterface {\n', '    /// @notice Indicator that this is a BController contract (for inspection)\n', '    bool public constant isBController = true;\n', '\n', '    /*** Assets You Are In ***/\n', '\n', '    function enterMarkets(address[] calldata bTokens) external returns (uint[] memory);\n', '    function exitMarket(address bToken) external returns (uint);\n', '\n', '    /*** Policy Hooks ***/\n', '\n', '    function mintAllowed(address bToken, address minter, uint mintAmount) external returns (uint);\n', '    function mintVerify(address bToken, address minter, uint mintAmount, uint mintTokens) external;\n', '\n', '    function redeemAllowed(address bToken, address redeemer, uint redeemTokens) external returns (uint);\n', '    function redeemVerify(address bToken, address redeemer, uint redeemAmount, uint redeemTokens) external;\n', '\n', '    function borrowAllowed(address bToken, address borrower, uint borrowAmount) external returns (uint);\n', '    function borrowVerify(address bToken, address borrower, uint borrowAmount) external;\n', '\n', '    function repayBorrowAllowed(address bToken, address payer, address borrower, uint repayAmount) external returns (uint);\n', '    function repayBorrowVerify(address bToken, address payer, address borrower, uint repayAmount, uint borrowerIndex) external;\n', '\n', '    function liquidateBorrowAllowed(address bTokenBorrowed, address bTokenCollateral, address liquidator, address borrower, uint repayAmount) external returns (uint);\n', '    function liquidateBorrowVerify(address bTokenBorrowed, address bTokenCollateral, address liquidator, address borrower, uint repayAmount, uint seizeTokens) external;\n', '\n', '    function seizeAllowed(address bTokenCollateral, address bTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external returns (uint);\n', '    function seizeVerify(address bTokenCollateral, address bTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external;\n', '\n', '    function transferAllowed(address bToken, address src, address dst, uint transferTokens) external returns (uint);\n', '    function transferVerify(address bToken, address src, address dst, uint transferTokens) external;\n', '\n', '    /*** Liquidity/Liquidation Calculations ***/\n', '\n', '    function liquidateCalculateSeizeTokens(address bTokenBorrowed, address bTokenCollateral, uint repayAmount) external view returns (uint, uint);\n', '}\n', '\n', '/**\n', "  * @title Bird's InterestRateModel Interface\n", '  */\n', 'contract InterestRateModel {\n', '    /// @notice Indicator that this is an InterestRateModel contract (for inspection)\n', '    bool public constant isInterestRateModel = true;\n', '\n', '    /**\n', '      * @notice Calculates the current borrow interest rate per block\n', '      * @param cash The total amount of cash the market has\n', '      * @param borrows The total amount of borrows the market has outstanding\n', '      * @param reserves The total amount of reserves the market has\n', '      * @return The borrow rate per block (as a percentage, and scaled by 1e18)\n', '      */\n', '    function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);\n', '\n', '    /**\n', '      * @notice Calculates the current supply interest rate per block\n', '      * @param cash The total amount of cash the market has\n', '      * @param borrows The total amount of borrows the market has outstanding\n', '      * @param reserves The total amount of reserves the market has\n', '      * @param reserveFactorMantissa The current reserve factor the market has\n', '      * @return The supply rate per block (as a percentage, and scaled by 1e18)\n', '      */\n', '    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);\n', '\n', '}\n', '\n', '/**\n', "  * @title Bird's BToken Storage\n", '  */\n', 'contract BTokenStorage {\n', '    /**\n', '     * @dev Guard variable for re-entrancy checks\n', '     */\n', '    bool internal _notEntered;\n', '\n', '    /**\n', '     * @notice EIP-20 token name for this token\n', '     */\n', '    string public name;\n', '\n', '    /**\n', '     * @notice EIP-20 token symbol for this token\n', '     */\n', '    string public symbol;\n', '\n', '    /**\n', '     * @notice EIP-20 token decimals for this token\n', '     */\n', '    uint8 public decimals;\n', '\n', '    /**\n', '     * @notice Maximum borrow rate that can ever be applied (.0005% / block)\n', '     */\n', '\n', '    uint internal constant borrowRateMaxMantissa = 0.0005e16;\n', '\n', '    /**\n', '     * @notice Maximum fraction of interest that can be set aside for reserves\n', '     */\n', '    uint internal constant reserveFactorMaxMantissa = 1e18;\n', '\n', '    /**\n', '     * @notice Administrator for this contract\n', '     */\n', '    address payable public admin;\n', '\n', '    /**\n', '     * @notice Pending administrator for this contract\n', '     */\n', '    address payable public pendingAdmin;\n', '\n', '    /**\n', '     * @notice Contract which oversees inter-bToken operations\n', '     */\n', '    BControllerInterface public bController;\n', '\n', '    /**\n', '     * @notice Model which tells what the current interest rate should be\n', '     */\n', '    InterestRateModel public interestRateModel;\n', '\n', '    /**\n', '     * @notice Initial exchange rate used when minting the first BTokens (used when totalSupply = 0)\n', '     */\n', '    uint internal initialExchangeRateMantissa;\n', '\n', '    /**\n', '     * @notice Fraction of interest currently set aside for reserves\n', '     */\n', '    uint public reserveFactorMantissa;\n', '\n', '    /**\n', '     * @notice Block number that interest was last accrued at\n', '     */\n', '    uint public accrualBlockNumber;\n', '\n', '    /**\n', '     * @notice Accumulator of the total earned interest rate since the opening of the market\n', '     */\n', '    uint public borrowIndex;\n', '\n', '    /**\n', '     * @notice Total amount of outstanding borrows of the underlying in this market\n', '     */\n', '    uint public totalBorrows;\n', '\n', '    /**\n', '     * @notice Total amount of reserves of the underlying held in this market\n', '     */\n', '    uint public totalReserves;\n', '\n', '    /**\n', '     * @notice Total number of tokens in circulation\n', '     */\n', '    uint public totalSupply;\n', '\n', '    /**\n', '     * @notice Official record of token balances for each account\n', '     */\n', '    mapping (address => uint) internal accountTokens;\n', '\n', '    /**\n', '     * @notice Approved token transfer amounts on behalf of others\n', '     */\n', '    mapping (address => mapping (address => uint)) internal transferAllowances;\n', '\n', '    /**\n', '     * @notice Container for borrow balance information\n', '     * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action\n', '     * @member interestIndex Global borrowIndex as of the most recent balance-changing action\n', '     */\n', '    struct BorrowSnapshot {\n', '        uint principal;\n', '        uint interestIndex;\n', '    }\n', '\n', '    /**\n', '     * @notice Mapping of account addresses to outstanding borrow balances\n', '     */\n', '    mapping(address => BorrowSnapshot) internal accountBorrows;\n', '}\n', '\n', '/**\n', "  * @title Bird's BToken Interface\n", '  */\n', 'contract BTokenInterface is BTokenStorage {\n', '    /**\n', '     * @notice Indicator that this is a BToken contract (for inspection)\n', '     */\n', '    bool public constant isBToken = true;\n', '\n', '\n', '    /*** Market Events ***/\n', '\n', '    /**\n', '     * @notice Event emitted when interest is accrued\n', '     */\n', '    event AccrueInterestToken(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);\n', '\n', '    /**\n', '     * @notice Event emitted when tokens are minted\n', '     */\n', '    event MintToken(address minter, uint mintAmount, uint mintTokens);\n', '\n', '    /**\n', '     * @notice Event emitted when tokens are redeemed\n', '     */\n', '    event RedeemToken(address redeemer, uint redeemAmount, uint redeemTokens);\n', '\n', '    /**\n', '     * @notice Event emitted when underlying is borrowed\n', '     */\n', '    event BorrowToken(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);\n', '\n', '    /**\n', '     * @notice Event emitted when a borrow is repaid\n', '     */\n', '    event RepayBorrowToken(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);\n', '\n', '    /**\n', '     * @notice Event emitted when a borrow is liquidated\n', '     */\n', '    event LiquidateBorrowToken(address liquidator, address borrower, uint repayAmount, address bTokenCollateral, uint seizeTokens);\n', '\n', '\n', '    /*** Admin Events ***/\n', '\n', '    /**\n', '     * @notice Event emitted when pendingAdmin is changed\n', '     */\n', '    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);\n', '\n', '    /**\n', '     * @notice Event emitted when pendingAdmin is accepted, which means admin is updated\n', '     */\n', '    event NewAdmin(address oldAdmin, address newAdmin);\n', '\n', '    /**\n', '     * @notice Event emitted when bController is changed\n', '     */\n', '    event NewBController(BControllerInterface oldBController, BControllerInterface newBController);\n', '\n', '    /**\n', '     * @notice Event emitted when interestRateModel is changed\n', '     */\n', '    event NewMarketTokenInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);\n', '\n', '    /**\n', '     * @notice Event emitted when the reserve factor is changed\n', '     */\n', '    event NewTokenReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);\n', '\n', '    /**\n', '     * @notice Event emitted when the reserves are added\n', '     */\n', '    event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);\n', '\n', '    /**\n', '     * @notice Event emitted when the reserves are reduced\n', '     */\n', '    event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);\n', '\n', '    /**\n', '     * @notice EIP20 Transfer event\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint amount);\n', '\n', '    /**\n', '     * @notice EIP20 Approval event\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint amount);\n', '\n', '    /**\n', '     * @notice Failure event\n', '     */\n', '    event Failure(uint error, uint info, uint detail);\n', '\n', '\n', '    /*** User Interface ***/\n', '\n', '    function transfer(address dst, uint amount) external returns (bool);\n', '    function transferFrom(address src, address dst, uint amount) external returns (bool);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function balanceOfUnderlying(address owner) external returns (uint);\n', '    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);\n', '    function borrowRatePerBlock() external view returns (uint);\n', '    function supplyRatePerBlock() external view returns (uint);\n', '    function totalBorrowsCurrent() external returns (uint);\n', '    function borrowBalanceCurrent(address account) external returns (uint);\n', '    function borrowBalanceStored(address account) public view returns (uint);\n', '    function exchangeRateCurrent() public returns (uint);\n', '    function exchangeRateStored() public view returns (uint);\n', '    function getCash() external view returns (uint);\n', '    function accrueInterest() public returns (uint);\n', '    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);\n', '\n', '    /*** Admin Functions ***/\n', '\n', '    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);\n', '    function _acceptAdmin() external returns (uint);\n', '    function _setBController(BControllerInterface newBController) public returns (uint);\n', '    function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);\n', '    function _reduceReserves(uint reduceAmount) external returns (uint);\n', '    function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);\n', '}\n', '\n', '/**\n', "  * @title Bird's BErc20 Storage\n", '  */\n', 'contract BErc20Storage {\n', '    /**\n', '     * @notice Underlying asset for this BToken\n', '     */\n', '    address public underlying;\n', '}\n', '\n', '/**\n', "  * @title Bird's BErc20 Interface\n", '  */\n', 'contract BErc20Interface is BErc20Storage {\n', '\n', '    /*** User Interface ***/\n', '\n', '    function mint(uint mintAmount) external returns (uint);\n', '    function redeem(uint redeemTokens) external returns (uint);\n', '    function redeemUnderlying(uint redeemAmount) external returns (uint);\n', '    function borrow(uint borrowAmount) external returns (uint);\n', '    function repayBorrow(uint repayAmount) external returns (uint);\n', '    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);\n', '    function liquidateBorrow(address borrower, uint repayAmount, BTokenInterface bTokenCollateral) external returns (uint);\n', '\n', '\n', '    /*** Admin Functions ***/\n', '\n', '    function _addReserves(uint addAmount) external returns (uint);\n', '}\n', '\n', '/**\n', "  * @title Bird's BDelegation Storage\n", '  */\n', 'contract BDelegationStorage {\n', '    /**\n', '     * @notice Implementation address for this contract\n', '     */\n', '    address public implementation;\n', '}\n', '\n', '/**\n', "  * @title Bird's BDelegator Interface\n", '  */\n', 'contract BDelegatorInterface is BDelegationStorage {\n', '    /**\n', '     * @notice Emitted when implementation is changed\n', '     */\n', '    event NewImplementation(address oldImplementation, address newImplementation);\n', '\n', '    /**\n', '     * @notice Called by the admin to update the implementation of the delegator\n', '     * @param implementation_ The address of the new implementation for delegation\n', '     * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation\n', '     * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation\n', '     */\n', '    function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;\n', '}\n', '\n', '/**\n', "  * @title Bird's BDelegate Interface\n", '  */\n', 'contract BDelegateInterface is BDelegationStorage {\n', '    /**\n', '     * @notice Called by the delegator on a delegate to initialize it for duty\n', '     * @dev Should revert if any issues arise which make it unfit for delegation\n', '     * @param data The encoded bytes data for any initialization\n', '     */\n', '    function _becomeImplementation(bytes memory data) public;\n', '\n', '    /**\n', '     * @notice Called by the delegator on a delegate to forfeit its responsibility\n', '     */\n', '    function _resignImplementation() public;\n', '}\n', '\n', '/**\n', " * @title Bird's BErc20Delegator Contract\n", ' * @notice BTokens which wrap an EIP-20 underlying and delegate to an implementation\n', ' */\n', 'contract BErc20Delegator is BTokenInterface, BErc20Interface, BDelegatorInterface {\n', '    /**\n', '     * @notice Construct a new money market\n', '     * @param underlying_ The address of the underlying asset\n', '     * @param bController_ The address of the BController\n', '     * @param interestRateModel_ The address of the interest rate model\n', '     * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18\n', '     * @param name_ ERC-20 name of this token\n', '     * @param symbol_ ERC-20 symbol of this token\n', '     * @param decimals_ ERC-20 decimal precision of this token\n', '     * @param admin_ Address of the administrator of this token\n', '     * @param implementation_ The address of the implementation the contract delegates to\n', '     * @param becomeImplementationData The encoded args for becomeImplementation\n', '     */\n', '    constructor(address underlying_,\n', '                BControllerInterface bController_,\n', '                InterestRateModel interestRateModel_,\n', '                uint initialExchangeRateMantissa_,\n', '                string memory name_,\n', '                string memory symbol_,\n', '                uint8 decimals_,\n', '                address payable admin_,\n', '                address implementation_,\n', '                bytes memory becomeImplementationData) public {\n', '        // Creator of the contract is admin during initialization\n', '        admin = msg.sender;\n', '\n', '        // First delegate gets to initialize the delegator (i.e. storage contract)\n', '        delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,address,uint256,string,string,uint8)",\n', '                                                            underlying_,\n', '                                                            bController_,\n', '                                                            interestRateModel_,\n', '                                                            initialExchangeRateMantissa_,\n', '                                                            name_,\n', '                                                            symbol_,\n', '                                                            decimals_));\n', '\n', '        // New implementations always get set via the settor (post-initialize)\n', '        _setImplementation(implementation_, false, becomeImplementationData);\n', '\n', '        // Set the proper admin now that initialization is done\n', '        admin = admin_;\n', '    }\n', '\n', '    /**\n', '     * @notice Called by the admin to update the implementation of the delegator\n', '     * @param implementation_ The address of the new implementation for delegation\n', '     * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation\n', '     * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation\n', '     */\n', '    function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {\n', '        require(msg.sender == admin, "BErc20Delegator::_setImplementation: Caller must be admin");\n', '\n', '        if (allowResign) {\n', '            delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));\n', '        }\n', '\n', '        address oldImplementation = implementation;\n', '        implementation = implementation_;\n', '\n', '        delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));\n', '\n', '        emit NewImplementation(oldImplementation, implementation);\n', '    }\n', '\n', '    /**\n', '     * @notice Sender supplies assets into the market and receives bTokens in exchange\n', '     * @dev Accrues interest whether or not the operation succeeds, unless reverted\n', '     * @param mintAmount The amount of the underlying asset to supply\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function mint(uint mintAmount) external returns (uint) {\n', '        mintAmount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Sender redeems bTokens in exchange for the underlying asset\n', '     * @dev Accrues interest whether or not the operation succeeds, unless reverted\n', '     * @param redeemTokens The number of bTokens to redeem into underlying\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function redeem(uint redeemTokens) external returns (uint) {\n', '        redeemTokens; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Sender redeems bTokens in exchange for a specified amount of underlying asset\n', '     * @dev Accrues interest whether or not the operation succeeds, unless reverted\n', '     * @param redeemAmount The amount of underlying to redeem\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function redeemUnderlying(uint redeemAmount) external returns (uint) {\n', '        redeemAmount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '      * @notice Sender borrows assets from the protocol to their own address\n', '      * @param borrowAmount The amount of the underlying asset to borrow\n', '      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '      */\n', '    function borrow(uint borrowAmount) external returns (uint) {\n', '        borrowAmount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Sender repays their own borrow\n', '     * @param repayAmount The amount to repay\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function repayBorrow(uint repayAmount) external returns (uint) {\n', '        repayAmount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Sender repays a borrow belonging to borrower\n', '     * @param borrower the account with the debt being payed off\n', '     * @param repayAmount The amount to repay\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {\n', '        borrower; repayAmount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice The sender liquidates the borrowers collateral.\n', '     *  The collateral seized is transferred to the liquidator.\n', '     * @param borrower The borrower of this bToken to be liquidated\n', '     * @param bTokenCollateral The market in which to seize collateral from the borrower\n', '     * @param repayAmount The amount of the underlying borrowed asset to repay\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function liquidateBorrow(address borrower, uint repayAmount, BTokenInterface bTokenCollateral) external returns (uint) {\n', '        borrower; repayAmount; bTokenCollateral; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `msg.sender` to `dst`\n', '     * @param dst The address of the destination account\n', '     * @param amount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transfer(address dst, uint amount) external returns (bool) {\n', '        dst; amount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `src` to `dst`\n', '     * @param src The address of the source account\n', '     * @param dst The address of the destination account\n', '     * @param amount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transferFrom(address src, address dst, uint256 amount) external returns (bool) {\n', '        src; dst; amount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Approve `spender` to transfer up to `amount` from `src`\n', '     * @dev This will overwrite the approval amount for `spender`\n', '     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)\n', '     * @param spender The address of the account which may transfer tokens\n', '     * @param amount The number of tokens that are approved (-1 means infinite)\n', '     * @return Whether or not the approval succeeded\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool) {\n', '        spender; amount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Get the current allowance from `owner` for `spender`\n', '     * @param owner The address of the account which owns the tokens to be spent\n', '     * @param spender The address of the account which may transfer tokens\n', '     * @return The number of tokens allowed to be spent (-1 means infinite)\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint) {\n', '        owner; spender; // Shh\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Get the token balance of the `owner`\n', '     * @param owner The address of the account to query\n', '     * @return The number of tokens owned by `owner`\n', '     */\n', '    function balanceOf(address owner) external view returns (uint) {\n', '        owner; // Shh\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Get the underlying balance of the `owner`\n', '     * @dev This also accrues interest in a transaction\n', '     * @param owner The address of the account to query\n', '     * @return The amount of underlying owned by `owner`\n', '     */\n', '    function balanceOfUnderlying(address owner) external returns (uint) {\n', '        owner; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', "     * @notice Get a snapshot of the account's balances, and the cached exchange rate\n", '     * @dev This is used by bController to more efficiently perform liquidity checks.\n', '     * @param account Address of the account to snapshot\n', '     * @return (possible error, token balance, borrow balance, exchange rate mantissa)\n', '     */\n', '    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {\n', '        account; // Shh\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Returns the current per-block borrow interest rate for this bToken\n', '     * @return The borrow interest rate per block, scaled by 1e18\n', '     */\n', '    function borrowRatePerBlock() external view returns (uint) {\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Returns the current per-block supply interest rate for this bToken\n', '     * @return The supply interest rate per block, scaled by 1e18\n', '     */\n', '    function supplyRatePerBlock() external view returns (uint) {\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Returns the current total borrows plus accrued interest\n', '     * @return The total borrows with interest\n', '     */\n', '    function totalBorrowsCurrent() external returns (uint) {\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', "     * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex\n", '     * @param account The address whose balance should be calculated after updating borrowIndex\n', '     * @return The calculated balance\n', '     */\n', '    function borrowBalanceCurrent(address account) external returns (uint) {\n', '        account; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Return the borrow balance of account based on stored data\n', '     * @param account The address whose balance should be calculated\n', '     * @return The calculated balance\n', '     */\n', '    function borrowBalanceStored(address account) public view returns (uint) {\n', '        account; // Shh\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '   /**\n', '     * @notice Accrue interest then return the up-to-date exchange rate\n', '     * @return Calculated exchange rate scaled by 1e18\n', '     */\n', '    function exchangeRateCurrent() public returns (uint) {\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Calculates the exchange rate from the underlying to the BToken\n', '     * @dev This function does not accrue interest before calculating the exchange rate\n', '     * @return Calculated exchange rate scaled by 1e18\n', '     */\n', '    function exchangeRateStored() public view returns (uint) {\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Get cash balance of this bToken in the underlying asset\n', '     * @return The quantity of underlying asset owned by this contract\n', '     */\n', '    function getCash() external view returns (uint) {\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '      * @notice Applies accrued interest to total borrows and reserves.\n', '      * @dev This calculates interest accrued from the last checkpointed block\n', '      *      up to the current block and writes new checkpoint to storage.\n', '      */\n', '    function accrueInterest() public returns (uint) {\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers collateral tokens (this market) to the liquidator.\n', '     * @dev Will fail unless called by another bToken during the process of liquidation.\n', '     *  Its absolutely critical to use msg.sender as the borrowed bToken and not a parameter.\n', '     * @param liquidator The account receiving seized collateral\n', '     * @param borrower The account having collateral seized\n', '     * @param seizeTokens The number of bTokens to seize\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint) {\n', '        liquidator; borrower; seizeTokens; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /*** Admin Functions ***/\n', '\n', '    /**\n', '      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.\n', '      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.\n', '      * @param newPendingAdmin New pending admin.\n', '      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '      */\n', '    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {\n', '        newPendingAdmin; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '      * @notice Sets a new bController for the market\n', '      * @dev Admin function to set a new bController\n', '      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '      */\n', '    function _setBController(BControllerInterface newBController) public returns (uint) {\n', '        newBController; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh\n', '      * @dev Admin function to accrue interest and set a new reserve factor\n', '      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '      */\n', '    function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint) {\n', '        newReserveFactorMantissa; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin\n', '      * @dev Admin function for pending admin to accept role and update admin\n', '      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '      */\n', '    function _acceptAdmin() external returns (uint) {\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Accrues interest and adds reserves by transferring from admin\n', '     * @param addAmount Amount of reserves to add\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function _addReserves(uint addAmount) external returns (uint) {\n', '        addAmount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Accrues interest and reduces reserves by transferring to admin\n', '     * @param reduceAmount Amount of reduction to reserves\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function _reduceReserves(uint reduceAmount) external returns (uint) {\n', '        reduceAmount; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh\n', '     * @dev Admin function to accrue interest and update the interest rate model\n', '     * @param newInterestRateModel the new interest rate model to use\n', '     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)\n', '     */\n', '    function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {\n', '        newInterestRateModel; // Shh\n', '        delegateAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @notice Internal method to delegate execution to another contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     * @param callee The contract to delegatecall\n', '     * @param data The raw data to delegatecall\n', '     * @return The returned bytes from the delegatecall\n', '     */\n', '    function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {\n', '        (bool success, bytes memory returnData) = callee.delegatecall(data);\n', '        assembly {\n', '            if eq(success, 0) {\n', '                revert(add(returnData, 0x20), returndatasize)\n', '            }\n', '        }\n', '        return returnData;\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates execution to the implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     * @param data The raw data to delegatecall\n', '     * @return The returned bytes from the delegatecall\n', '     */\n', '    function delegateToImplementation(bytes memory data) public returns (bytes memory) {\n', '        return delegateTo(implementation, data);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates execution to an implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.\n', '     * @param data The raw data to delegatecall\n', '     * @return The returned bytes from the delegatecall\n', '     */\n', '    function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {\n', '        (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));\n', '        assembly {\n', '            if eq(success, 0) {\n', '                revert(add(returnData, 0x20), returndatasize)\n', '            }\n', '        }\n', '        return abi.decode(returnData, (bytes));\n', '    }\n', '\n', '    function delegateToViewAndReturn() private view returns (bytes memory) {\n', '        (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));\n', '\n', '        assembly {\n', '            let free_mem_ptr := mload(0x40)\n', '            returndatacopy(free_mem_ptr, 0, returndatasize)\n', '\n', '            switch success\n', '            case 0 { revert(free_mem_ptr, returndatasize) }\n', '            default { return(add(free_mem_ptr, 0x40), returndatasize) }\n', '        }\n', '    }\n', '\n', '    function delegateAndReturn() private returns (bytes memory) {\n', '        (bool success, ) = implementation.delegatecall(msg.data);\n', '\n', '        assembly {\n', '            let free_mem_ptr := mload(0x40)\n', '            returndatacopy(free_mem_ptr, 0, returndatasize)\n', '\n', '            switch success\n', '            case 0 { revert(free_mem_ptr, returndatasize) }\n', '            default { return(free_mem_ptr, returndatasize) }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates execution to an implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     */\n', '    function () external payable {\n', '        require(msg.value == 0,"BErc20Delegator:fallback: cannot send value to fallback");\n', '\n', '        // delegate all other functions to current implementation\n', '        delegateAndReturn();\n', '    }\n', '}']