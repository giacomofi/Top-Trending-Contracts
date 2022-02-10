['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-13\n', '*/\n', '\n', '// SPDX-License-Identifier:  AGPL-3.0-or-later // hevm: flattened sources of contracts/MapleGlobals.sol\n', 'pragma solidity =0.6.11 >=0.6.0 <0.8.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol\n', '/* pragma solidity >=0.6.0 <0.8.0; */\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '////// contracts/interfaces/IERC20Details.sol\n', '/* pragma solidity 0.6.11; */\n', '\n', '/* import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */\n', '\n', 'interface IERC20Details is IERC20 {\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint256);\n', '\n', '}\n', '\n', '////// contracts/interfaces/IOracle.sol\n', '/* pragma solidity 0.6.11; */\n', '\n', 'interface IOracle {\n', '\n', '    function priceFeed() external view returns (address);\n', '\n', '    function globals() external view returns (address);\n', '\n', '    function assetAddress() external view returns (address);\n', '\n', '    function manualOverride() external view returns (bool);\n', '\n', '    function manualPrice() external view returns (int256);\n', '\n', '    function getLatestPrice() external view returns (int256);\n', '    \n', '    function changeAggregator(address) external;\n', '\n', '    function getAssetAddress() external view returns (address);\n', '    \n', '    function getDenomination() external view returns (bytes32);\n', '    \n', '    function setManualPrice(int256) external;\n', '    \n', '    function setManualOverride(bool) external;\n', '\n', '}\n', '\n', '////// contracts/interfaces/ISubFactory.sol\n', '/* pragma solidity 0.6.11; */\n', '\n', 'interface ISubFactory {\n', '\n', '    function factoryType() external view returns (uint8);\n', '\n', '}\n', '\n', '////// lib/openzeppelin-contracts/contracts/math/SafeMath.sol\n', '/* pragma solidity >=0.6.0 <0.8.0; */\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '////// contracts/MapleGlobals.sol\n', '/* pragma solidity 0.6.11; */\n', '/* pragma experimental ABIEncoderV2; */\n', '\n', '/* import "lib/openzeppelin-contracts/contracts/math/SafeMath.sol"; */\n', '\n', '/* import "./interfaces/IERC20Details.sol"; */\n', '/* import "./interfaces/IOracle.sol"; */\n', '/* import "./interfaces/ISubFactory.sol"; */\n', '\n', 'interface ICalc { function calcType() external view returns (uint8); }\n', '\n', '/// @title MapleGlobals maintains a central source of parameters and allowlists for the Maple protocol.\n', 'contract MapleGlobals {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    address public immutable mpl;         // The ERC-2222 Maple Token for the Maple protocol.\n', '\n', '    address public pendingGovernor;       // The Governor that is declared for governorship transfer. Must be accepted for transfer to take effect.\n', '    address public governor;              // The Governor responsible for management of global Maple variables.\n', '    address public mapleTreasury;         // The MapleTreasury is the Treasury where all fees pass through for conversion, prior to distribution.\n', '    address public globalAdmin;           // The Global Admin of the whole network. Has the power to switch off/on the functionality of entire protocol.\n', '\n', '    uint256 public defaultGracePeriod;    // Represents the amount of time a Borrower has to make a missed payment before a default can be triggered.\n', '    uint256 public swapOutRequired;       // Represents minimum amount of Pool cover that a Pool Delegate has to provide before they can finalize a Pool.\n', '    uint256 public fundingPeriod;         // Amount of time to allow a Borrower to drawdown on their Loan after funding period ends.\n', '    uint256 public investorFee;           // Portion of drawdown that goes to the Pool Delegates and individual Lenders.\n', '    uint256 public treasuryFee;           // Portion of drawdown that goes to the MapleTreasury.\n', '    uint256 public maxSwapSlippage;       // Maximum amount of slippage for Uniswap transactions.\n', '    uint256 public minLoanEquity;         // Minimum amount of LoanFDTs required to trigger liquidations (basis points percentage of totalSupply).\n', '    uint256 public stakerCooldownPeriod;  // Period (in secs) after which Stakers are allowed to unstake  their BPTs  from a StakeLocker.\n', '    uint256 public lpCooldownPeriod;      // Period (in secs) after which LPs     are allowed to withdraw their funds from a Pool.\n', '    uint256 public stakerUnstakeWindow;   // Window of time (in secs) after `stakerCooldownPeriod` that an account has to withdraw before their intent to unstake  is invalidated.\n', '    uint256 public lpWithdrawWindow;      // Window of time (in secs) after `lpCooldownPeriod`     that an account has to withdraw before their intent to withdraw is invalidated.\n', '\n', '    bool public protocolPaused;  // Switch to pause the functionality of the entire protocol.\n', '\n', '    mapping(address => bool) public isValidLiquidityAsset;            // Mapping of valid Liquidity Assets.\n', '    mapping(address => bool) public isValidCollateralAsset;           // Mapping of valid Collateral Assets.\n', '    mapping(address => bool) public validCalcs;                       // Mapping of valid Calculators\n', '    mapping(address => bool) public isValidPoolDelegate;              // Mapping of valid Pool Delegates (prevent unauthorized/unknown addresses from creating Pools).\n', '    mapping(address => bool) public isValidBalancerPool;              // Mapping of valid Balancer Pools that Maple has approved for BPT staking.\n', '\n', '    // Determines the liquidation path of various assets in Loans and the Treasury.\n', '    // The value provided will determine whether or not to perform a bilateral or triangular swap on Uniswap.\n', '    // For example, `defaultUniswapPath[WBTC][USDC]` value would indicate what asset to convert WBTC into before conversion to USDC.\n', '    // If `defaultUniswapPath[WBTC][USDC] == USDC`, then the swap is bilateral and no middle asset is swapped.\n', '    // If `defaultUniswapPath[WBTC][USDC] == WETH`, then swap WBTC for WETH, then WETH for USDC.\n', '    mapping(address => mapping(address => address)) public defaultUniswapPath;\n', '\n', '    mapping(address => address) public oracleFor;  // Chainlink oracle for a given asset.\n', '\n', '    mapping(address => bool)                     public isValidPoolFactory;  // Mapping of valid Pool Factories.\n', '    mapping(address => bool)                     public isValidLoanFactory;  // Mapping of valid Loan Factories.\n', '    mapping(address => mapping(address => bool)) public validSubFactories;   // Mapping of valid sub factories.\n', '\n', '    event                     Initialized();\n', '    event              CollateralAssetSet(address asset, uint256 decimals, string symbol, bool valid);\n', '    event               LiquidityAssetSet(address asset, uint256 decimals, string symbol, bool valid);\n', '    event                       OracleSet(address asset, address oracle);\n', '    event TransferRestrictionExemptionSet(address indexed exemptedContract, bool valid);\n', '    event                 BalancerPoolSet(address balancerPool, bool valid);\n', '    event              PendingGovernorSet(address indexed pendingGovernor);\n', '    event                GovernorAccepted(address indexed governor);\n', '    event                 GlobalsParamSet(bytes32 indexed which, uint256 value);\n', '    event               GlobalsAddressSet(bytes32 indexed which, address addr);\n', '    event                  ProtocolPaused(bool pause);\n', '    event                  GlobalAdminSet(address indexed newGlobalAdmin);\n', '    event                 PoolDelegateSet(address indexed delegate, bool valid);\n', '\n', '    /**\n', '        @dev Checks that `msg.sender` is the Governor.\n', '    */\n', '    modifier isGovernor() {\n', '        require(msg.sender == governor, "MG:NOT_GOV");\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev   Constructor function.\n', '        @dev   It emits an `Initialized` event.\n', '        @param _governor    Address of Governor.\n', '        @param _mpl         Address of the ERC-2222 Maple Token for the Maple protocol.\n', '        @param _globalAdmin Address the Global Admin.\n', '    */\n', '    constructor(address _governor, address _mpl, address _globalAdmin) public {\n', '        governor             = _governor;\n', '        mpl                  = _mpl;\n', '        swapOutRequired      = 10_000;     // $10,000 of Pool cover\n', '        fundingPeriod        = 10 days;\n', '        defaultGracePeriod   = 5 days;\n', '        investorFee          = 50;         // 0.5 %\n', '        treasuryFee          = 50;         // 0.5 %\n', '        maxSwapSlippage      = 1000;       // 10 %\n', '        minLoanEquity        = 2000;       // 20 %\n', '        globalAdmin          = _globalAdmin;\n', '        stakerCooldownPeriod = 10 days;\n', '        lpCooldownPeriod     = 10 days;\n', '        stakerUnstakeWindow  = 2 days;\n', '        lpWithdrawWindow     = 2 days;\n', '        emit Initialized();\n', '    }\n', '\n', '    /************************/\n', '    /*** Setter Functions ***/\n', '    /************************/\n', '\n', '    /**\n', '        @dev  Sets the Staker cooldown period. This change will affect the existing cool down period for the Stakers that already intended to unstake.\n', '              Only the Governor can call this function.\n', '        @dev  It emits a `GlobalsParamSet` event.\n', '        @param newCooldownPeriod New value for the cool down period.\n', '    */\n', '    function setStakerCooldownPeriod(uint256 newCooldownPeriod) external isGovernor {\n', '        stakerCooldownPeriod = newCooldownPeriod;\n', '        emit GlobalsParamSet("STAKER_COOLDOWN_PERIOD", newCooldownPeriod);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the Liquidity Pool cooldown period. This change will affect the existing cool down period for the LPs that already intended to withdraw.\n', '               Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param newCooldownPeriod New value for the cool down period.\n', '    */\n', '    function setLpCooldownPeriod(uint256 newCooldownPeriod) external isGovernor {\n', '        lpCooldownPeriod = newCooldownPeriod;\n', '        emit GlobalsParamSet("LP_COOLDOWN_PERIOD", newCooldownPeriod);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the Staker unstake window. This change will affect the existing window for the Stakers that already intended to unstake.\n', '               Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param newUnstakeWindow New value for the unstake window.\n', '    */\n', '    function setStakerUnstakeWindow(uint256 newUnstakeWindow) external isGovernor {\n', '        stakerUnstakeWindow = newUnstakeWindow;\n', '        emit GlobalsParamSet("STAKER_UNSTAKE_WINDOW", newUnstakeWindow);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the Liquidity Pool withdraw window. This change will affect the existing window for the LPs that already intended to withdraw.\n', '               Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param newLpWithdrawWindow New value for the withdraw window.\n', '    */\n', '    function setLpWithdrawWindow(uint256 newLpWithdrawWindow) external isGovernor {\n', '        lpWithdrawWindow = newLpWithdrawWindow;\n', '        emit GlobalsParamSet("LP_WITHDRAW_WINDOW", newLpWithdrawWindow);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the allowed Uniswap slippage percentage, in basis points. Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param newMaxSlippage New max slippage percentage (in basis points)\n', '    */\n', '    function setMaxSwapSlippage(uint256 newMaxSlippage) external isGovernor {\n', '        _checkPercentageRange(newMaxSlippage);\n', '        maxSwapSlippage = newMaxSlippage;\n', '        emit GlobalsParamSet("MAX_SWAP_SLIPPAGE", newMaxSlippage);\n', '    }\n', '\n', '    /**\n', '      @dev   Sets the Global Admin. Only the Governor can call this function.\n', '      @dev   It emits a `GlobalAdminSet` event.\n', '      @param newGlobalAdmin New global admin address.\n', '    */\n', '    function setGlobalAdmin(address newGlobalAdmin) external {\n', '        require(msg.sender == governor && newGlobalAdmin != address(0), "MG:NOT_GOV_OR_ADMIN");\n', '        require(!protocolPaused, "MG:PROTO_PAUSED");\n', '        globalAdmin = newGlobalAdmin;\n', '        emit GlobalAdminSet(newGlobalAdmin);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of a Balancer Pool. Only the Governor can call this function.\n', '        @dev   It emits a `BalancerPoolSet` event.\n', '        @param balancerPool Address of Balancer Pool contract.\n', '        @param valid        The new validity status of a Balancer Pool.\n', '    */\n', '    function setValidBalancerPool(address balancerPool, bool valid) external isGovernor {\n', '        isValidBalancerPool[balancerPool] = valid;\n', '        emit BalancerPoolSet(balancerPool, valid);\n', '    }\n', '\n', '    /**\n', '      @dev   Sets the paused/unpaused state of the protocol. Only the Global Admin can call this function.\n', '      @dev   It emits a `ProtocolPaused` event.\n', '      @param pause Boolean flag to switch externally facing functionality in the protocol on/off.\n', '    */\n', '    function setProtocolPause(bool pause) external {\n', '        require(msg.sender == globalAdmin, "MG:NOT_ADMIN");\n', '        protocolPaused = pause;\n', '        emit ProtocolPaused(pause);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of a PoolFactory. Only the Governor can call this function.\n', '        @param poolFactory Address of PoolFactory.\n', '        @param valid       The new validity status of a PoolFactory.\n', '    */\n', '    function setValidPoolFactory(address poolFactory, bool valid) external isGovernor {\n', '        isValidPoolFactory[poolFactory] = valid;\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of a LoanFactory. Only the Governor can call this function.\n', '        @param loanFactory Address of LoanFactory.\n', '        @param valid       The new validity status of a LoanFactory.\n', '    */\n', '    function setValidLoanFactory(address loanFactory, bool valid) external isGovernor {\n', '        isValidLoanFactory[loanFactory] = valid;\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of a sub factory as it relates to a super factory. Only the Governor can call this function.\n', '        @param superFactory The core factory (e.g. PoolFactory, LoanFactory).\n', '        @param subFactory   The sub factory used by core factory (e.g. LiquidityLockerFactory).\n', '        @param valid        The new validity status of a subFactory within context of super factory.\n', '    */\n', '    function setValidSubFactory(address superFactory, address subFactory, bool valid) external isGovernor {\n', '        require(isValidLoanFactory[superFactory] || isValidPoolFactory[superFactory], "MG:INVALID_SUPER_F");\n', '        validSubFactories[superFactory][subFactory] = valid;\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the path to swap an asset through Uniswap. Only the Governor can call this function.\n', '        @param from Asset being swapped.\n', '        @param to   Final asset to receive. **\n', '        @param mid  Middle asset.\n', '\n', '        ** Set to == mid to enable a bilateral swap (single path swap).\n', '           Set to != mid to enable a triangular swap (multi path swap).\n', '    */\n', '    function setDefaultUniswapPath(address from, address to, address mid) external isGovernor {\n', '        defaultUniswapPath[from][to] = mid;\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of a Pool Delegate (those allowed to create Pools). Only the Governor can call this function.\n', '        @dev   It emits a `PoolDelegateSet` event.\n', '        @param delegate Address to manage permissions for.\n', '        @param valid    The new validity status of a Pool Delegate.\n', '    */\n', '    function setPoolDelegateAllowlist(address delegate, bool valid) external isGovernor {\n', '        isValidPoolDelegate[delegate] = valid;\n', '        emit PoolDelegateSet(delegate, valid);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of an asset for collateral. Only the Governor can call this function.\n', '        @dev   It emits a `CollateralAssetSet` event.\n', '        @param asset The asset to assign validity to.\n', '        @param valid The new validity status of a Collateral Asset.\n', '    */\n', '    function setCollateralAsset(address asset, bool valid) external isGovernor {\n', '        isValidCollateralAsset[asset] = valid;\n', '        emit CollateralAssetSet(asset, IERC20Details(asset).decimals(), IERC20Details(asset).symbol(), valid);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of an asset for liquidity in Pools. Only the Governor can call this function.\n', '        @dev   It emits a `LiquidityAssetSet` event.\n', '        @param asset Address of the valid asset.\n', '        @param valid The new validity status a Liquidity Asset in Pools.\n', '    */\n', '    function setLiquidityAsset(address asset, bool valid) external isGovernor {\n', '        isValidLiquidityAsset[asset] = valid;\n', '        emit LiquidityAssetSet(asset, IERC20Details(asset).decimals(), IERC20Details(asset).symbol(), valid);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the validity of a calculator contract. Only the Governor can call this function.\n', '        @param calc  Calculator address.\n', '        @param valid The new validity status of a Calculator.\n', '    */\n', '    function setCalc(address calc, bool valid) external isGovernor {\n', '        validCalcs[calc] = valid;\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the investor fee (in basis points). Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param _fee The fee, e.g., 50 = 0.50%.\n', '    */\n', '    function setInvestorFee(uint256 _fee) external isGovernor {\n', '        _checkPercentageRange(treasuryFee.add(_fee));\n', '        investorFee = _fee;\n', '        emit GlobalsParamSet("INVESTOR_FEE", _fee);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the treasury fee (in basis points). Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param _fee The fee, e.g., 50 = 0.50%.\n', '    */\n', '    function setTreasuryFee(uint256 _fee) external isGovernor {\n', '        _checkPercentageRange(investorFee.add(_fee));\n', '        treasuryFee = _fee;\n', '        emit GlobalsParamSet("TREASURY_FEE", _fee);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the MapleTreasury. Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param _mapleTreasury New MapleTreasury address.\n', '    */\n', '    function setMapleTreasury(address _mapleTreasury) external isGovernor {\n', '        require(_mapleTreasury != address(0), "MG:ZERO_ADDR");\n', '        mapleTreasury = _mapleTreasury;\n', '        emit GlobalsAddressSet("MAPLE_TREASURY", _mapleTreasury);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the default grace period. Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param _defaultGracePeriod Number of seconds to set the grace period to.\n', '    */\n', '    function setDefaultGracePeriod(uint256 _defaultGracePeriod) external isGovernor {\n', '        defaultGracePeriod = _defaultGracePeriod;\n', '        emit GlobalsParamSet("DEFAULT_GRACE_PERIOD", _defaultGracePeriod);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the minimum Loan equity. Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param _minLoanEquity Min percentage of Loan equity an account must have to trigger liquidations.\n', '    */\n', '    function setMinLoanEquity(uint256 _minLoanEquity) external isGovernor {\n', '        _checkPercentageRange(_minLoanEquity);\n', '        minLoanEquity = _minLoanEquity;\n', '        emit GlobalsParamSet("MIN_LOAN_EQUITY", _minLoanEquity);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the funding period. Only the Governor can call this function.\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param _fundingPeriod Number of seconds to set the drawdown grace period to.\n', '    */\n', '    function setFundingPeriod(uint256 _fundingPeriod) external isGovernor {\n', '        fundingPeriod = _fundingPeriod;\n', '        emit GlobalsParamSet("FUNDING_PERIOD", _fundingPeriod);\n', '    }\n', '\n', '    /**\n', '        @dev   Sets the the minimum Pool cover required to finalize a Pool. Only the Governor can call this function. FIX\n', '        @dev   It emits a `GlobalsParamSet` event.\n', '        @param amt The new minimum swap out required.\n', '    */\n', '    function setSwapOutRequired(uint256 amt) external isGovernor {\n', '        require(amt >= uint256(10_000), "MG:SWAP_OUT_TOO_LOW");\n', '        swapOutRequired = amt;\n', '        emit GlobalsParamSet("SWAP_OUT_REQUIRED", amt);\n', '    }\n', '\n', '    /**\n', "        @dev   Sets a price feed's oracle. Only the Governor can call this function.\n", '        @dev   It emits a `OracleSet` event.\n', '        @param asset  Asset to update price for.\n', '        @param oracle New oracle to use.\n', '    */\n', '    function setPriceOracle(address asset, address oracle) external isGovernor {\n', '        oracleFor[asset] = oracle;\n', '        emit OracleSet(asset, oracle);\n', '    }\n', '\n', '    /************************************/\n', '    /*** Transfer Ownership Functions ***/\n', '    /************************************/\n', '\n', '    /**\n', '        @dev   Sets a new Pending Governor. This address can become Governor if they accept. Only the Governor can call this function.\n', '        @dev   It emits a `PendingGovernorSet` event.\n', '        @param _pendingGovernor Address of new Pending Governor.\n', '    */\n', '    function setPendingGovernor(address _pendingGovernor) external isGovernor {\n', '        require(_pendingGovernor != address(0), "MG:ZERO_ADDR");\n', '        pendingGovernor = _pendingGovernor;\n', '        emit PendingGovernorSet(_pendingGovernor);\n', '    }\n', '\n', '    /**\n', '        @dev Accept the Governor position. Only the Pending Governor can call this function.\n', '        @dev It emits a `GovernorAccepted` event.\n', '    */\n', '    function acceptGovernor() external {\n', '        require(msg.sender == pendingGovernor, "MG:NOT_PENDING_GOV");\n', '        governor        = msg.sender;\n', '        pendingGovernor = address(0);\n', '        emit GovernorAccepted(msg.sender);\n', '    }\n', '\n', '    /************************/\n', '    /*** Getter Functions ***/\n', '    /************************/\n', '\n', '    /**\n', '        @dev    Fetch price for asset from Chainlink oracles.\n', '        @param  asset Asset to fetch price of.\n', '        @return Price of asset in USD.\n', '    */\n', '    function getLatestPrice(address asset) external view returns (uint256) {\n', '        return uint256(IOracle(oracleFor[asset]).getLatestPrice());\n', '    }\n', '\n', '    /**\n', '        @dev   Checks that a subFactory is valid as it relates to a super factory.\n', '        @param superFactory The core factory (e.g. PoolFactory, LoanFactory).\n', '        @param subFactory   The sub factory used by core factory (e.g. LiquidityLockerFactory).\n', '        @param factoryType  The type expected for the subFactory. References listed below.\n', '                                0 = COLLATERAL_LOCKER_FACTORY\n', '                                1 = DEBT_LOCKER_FACTORY\n', '                                2 = FUNDING_LOCKER_FACTORY\n', '                                3 = LIQUIDITY_LOCKER_FACTORY\n', '                                4 = STAKE_LOCKER_FACTORY\n', '    */\n', '    function isValidSubFactory(address superFactory, address subFactory, uint8 factoryType) external view returns (bool) {\n', '        return validSubFactories[superFactory][subFactory] && ISubFactory(subFactory).factoryType() == factoryType;\n', '    }\n', '\n', '    /**\n', '        @dev   Checks that a Calculator is valid.\n', '        @param calc     Calculator address.\n', '        @param calcType Calculator type.\n', '    */\n', '    function isValidCalc(address calc, uint8 calcType) external view returns (bool) {\n', '        return validCalcs[calc] && ICalc(calc).calcType() == calcType;\n', '    }\n', '\n', '    /**\n', '        @dev    Returns the `lpCooldownPeriod` and `lpWithdrawWindow` as a tuple, for convenience.\n', '        @return [0] = lpCooldownPeriod\n', '                [1] = lpWithdrawWindow\n', '    */\n', '    function getLpCooldownParams() external view returns (uint256, uint256) {\n', '        return (lpCooldownPeriod, lpWithdrawWindow);\n', '    }\n', '\n', '    /************************/\n', '    /*** Helper Functions ***/\n', '    /************************/\n', '\n', '    /**\n', '        @dev Checks that percentage is less than 100%.\n', '    */\n', '    function _checkPercentageRange(uint256 percentage) internal pure {\n', '        require(percentage <= uint256(10_000), "MG:PCT_OOB");\n', '    }\n', '\n', '}']