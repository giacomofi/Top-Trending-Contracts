['pragma solidity ^0.6.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library Account {\n', '    enum Status {Normal, Liquid, Vapor}\n', '    struct Info {\n', '        address owner; // The address that owns the account\n', '        uint256 number; // A nonce that allows a single address to control many accounts\n', '    }\n', '    struct Storage {\n', '        mapping(uint256 => Types.Par) balances; // Mapping from marketId to principal\n', '        Status status;\n', '    }\n', '}\n', '\n', '\n', 'library Actions {\n', '    enum ActionType {\n', '        Deposit, // supply tokens\n', '        Withdraw, // borrow tokens\n', '        Transfer, // transfer balance between accounts\n', '        Buy, // buy an amount of some token (publicly)\n', '        Sell, // sell an amount of some token (publicly)\n', '        Trade, // trade tokens against another account\n', '        Liquidate, // liquidate an undercollateralized or expiring account\n', '        Vaporize, // use excess tokens to zero-out a completely negative account\n', '        Call // send arbitrary data to an address\n', '    }\n', '\n', '    enum AccountLayout {OnePrimary, TwoPrimary, PrimaryAndSecondary}\n', '\n', '    enum MarketLayout {ZeroMarkets, OneMarket, TwoMarkets}\n', '\n', '    struct ActionArgs {\n', '        ActionType actionType;\n', '        uint256 accountId;\n', '        Types.AssetAmount amount;\n', '        uint256 primaryMarketId;\n', '        uint256 secondaryMarketId;\n', '        address otherAddress;\n', '        uint256 otherAccountId;\n', '        bytes data;\n', '    }\n', '\n', '    struct DepositArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info account;\n', '        uint256 market;\n', '        address from;\n', '    }\n', '\n', '    struct WithdrawArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info account;\n', '        uint256 market;\n', '        address to;\n', '    }\n', '\n', '    struct TransferArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info accountOne;\n', '        Account.Info accountTwo;\n', '        uint256 market;\n', '    }\n', '\n', '    struct BuyArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info account;\n', '        uint256 makerMarket;\n', '        uint256 takerMarket;\n', '        address exchangeWrapper;\n', '        bytes orderData;\n', '    }\n', '\n', '    struct SellArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info account;\n', '        uint256 takerMarket;\n', '        uint256 makerMarket;\n', '        address exchangeWrapper;\n', '        bytes orderData;\n', '    }\n', '\n', '    struct TradeArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info takerAccount;\n', '        Account.Info makerAccount;\n', '        uint256 inputMarket;\n', '        uint256 outputMarket;\n', '        address autoTrader;\n', '        bytes tradeData;\n', '    }\n', '\n', '    struct LiquidateArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info solidAccount;\n', '        Account.Info liquidAccount;\n', '        uint256 owedMarket;\n', '        uint256 heldMarket;\n', '    }\n', '\n', '    struct VaporizeArgs {\n', '        Types.AssetAmount amount;\n', '        Account.Info solidAccount;\n', '        Account.Info vaporAccount;\n', '        uint256 owedMarket;\n', '        uint256 heldMarket;\n', '    }\n', '\n', '    struct CallArgs {\n', '        Account.Info account;\n', '        address callee;\n', '        bytes data;\n', '    }\n', '}\n', '\n', '\n', 'library Decimal {\n', '    struct D256 {\n', '        uint256 value;\n', '    }\n', '}\n', '\n', '\n', 'library Interest {\n', '    struct Rate {\n', '        uint256 value;\n', '    }\n', '\n', '    struct Index {\n', '        uint96 borrow;\n', '        uint96 supply;\n', '        uint32 lastUpdate;\n', '    }\n', '}\n', '\n', '\n', 'library Monetary {\n', '    struct Price {\n', '        uint256 value;\n', '    }\n', '    struct Value {\n', '        uint256 value;\n', '    }\n', '}\n', '\n', '\n', 'library Storage {\n', '    // All information necessary for tracking a market\n', '    struct Market {\n', '        // Contract address of the associated ERC20 token\n', '        address token;\n', '        // Total aggregated supply and borrow amount of the entire market\n', '        Types.TotalPar totalPar;\n', '        // Interest index of the market\n', '        Interest.Index index;\n', '        // Contract address of the price oracle for this market\n', '        address priceOracle;\n', '        // Contract address of the interest setter for this market\n', '        address interestSetter;\n', '        // Multiplier on the marginRatio for this market\n', '        Decimal.D256 marginPremium;\n', '        // Multiplier on the liquidationSpread for this market\n', '        Decimal.D256 spreadPremium;\n', '        // Whether additional borrows are allowed for this market\n', '        bool isClosing;\n', '    }\n', '\n', '    // The global risk parameters that govern the health and security of the system\n', '    struct RiskParams {\n', '        // Required ratio of over-collateralization\n', '        Decimal.D256 marginRatio;\n', '        // Percentage penalty incurred by liquidated accounts\n', '        Decimal.D256 liquidationSpread;\n', "        // Percentage of the borrower's interest fee that gets passed to the suppliers\n", '        Decimal.D256 earningsRate;\n', '        // The minimum absolute borrow value of an account\n', '        // There must be sufficient incentivize to liquidate undercollateralized accounts\n', '        Monetary.Value minBorrowedValue;\n', '    }\n', '\n', '    // The maximum RiskParam values that can be set\n', '    struct RiskLimits {\n', '        uint64 marginRatioMax;\n', '        uint64 liquidationSpreadMax;\n', '        uint64 earningsRateMax;\n', '        uint64 marginPremiumMax;\n', '        uint64 spreadPremiumMax;\n', '        uint128 minBorrowedValueMax;\n', '    }\n', '\n', '    // The entire storage state of Solo\n', '    struct State {\n', '        // number of markets\n', '        uint256 numMarkets;\n', '        // marketId => Market\n', '        mapping(uint256 => Market) markets;\n', '        // owner => account number => Account\n', '        mapping(address => mapping(uint256 => Account.Storage)) accounts;\n', '        // Addresses that can control other users accounts\n', '        mapping(address => mapping(address => bool)) operators;\n', '        // Addresses that can control all users accounts\n', '        mapping(address => bool) globalOperators;\n', '        // mutable risk parameters of the system\n', '        RiskParams riskParams;\n', '        // immutable risk limits of the system\n', '        RiskLimits riskLimits;\n', '    }\n', '}\n', '\n', '\n', 'library Types {\n', '    enum AssetDenomination {\n', '        Wei, // the amount is denominated in wei\n', '        Par // the amount is denominated in par\n', '    }\n', '\n', '    enum AssetReference {\n', '        Delta, // the amount is given as a delta from the current value\n', '        Target // the amount is given as an exact number to end up at\n', '    }\n', '\n', '    struct AssetAmount {\n', '        bool sign; // true if positive\n', '        AssetDenomination denomination;\n', '        AssetReference ref;\n', '        uint256 value;\n', '    }\n', '\n', '    struct TotalPar {\n', '        uint128 borrow;\n', '        uint128 supply;\n', '    }\n', '\n', '    struct Par {\n', '        bool sign; // true if positive\n', '        uint128 value;\n', '    }\n', '\n', '    struct Wei {\n', '        bool sign; // true if positive\n', '        uint256 value;\n', '    }\n', '}\n', '\n', '\n', 'interface ISoloMargin {\n', '    struct OperatorArg {\n', '        address operator;\n', '        bool trusted;\n', '    }\n', '\n', '    function getMarketTokenAddress(uint256 marketId)\n', '        external\n', '        view\n', '        returns (address);\n', '\n', '    function getNumMarkets() external view returns (uint256);\n', '\n', '\n', '    function operate(\n', '        Account.Info[] calldata accounts,\n', '        Actions.ActionArgs[] calldata actions\n', '    ) external;\n', '\n', '    function getMarketWithInfo(uint256 marketId)\n', '        external\n', '        view\n', '        returns (\n', '            Storage.Market memory,\n', '            Interest.Index memory,\n', '            Monetary.Price memory,\n', '            Interest.Rate memory\n', '        );\n', '\n', '    function getAccountWei(Account.Info calldata account, uint256 marketId)\n', '        external\n', '        view\n', '        returns (Types.Wei memory);\n', '\n', '    function getMarket(uint256 marketId)\n', '        external\n', '        view\n', '        returns (Storage.Market memory);\n', '}\n', '\n', 'contract DydxFlashloanBase {\n', '    using SafeMath for uint256;\n', '\n', '    // -- Internal Helper functions -- //\n', '\n', '    function _getMarketIdFromTokenAddress(address _solo, address token)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        ISoloMargin solo = ISoloMargin(_solo);\n', '\n', '        uint256 numMarkets = solo.getNumMarkets();\n', '\n', '        address curToken;\n', '        for (uint256 i = 0; i < numMarkets; i++) {\n', '            curToken = solo.getMarketTokenAddress(i);\n', '\n', '            if (curToken == token) {\n', '                return i;\n', '            }\n', '        }\n', '\n', '        revert("No marketId found for provided token");\n', '    }\n', '\n', '    function _getAccountInfo() internal view returns (Account.Info memory) {\n', '        return Account.Info({owner: address(this), number: 1});\n', '    }\n', '\n', '    function _getWithdrawAction(uint marketId, uint256 amount)\n', '        internal\n', '        view\n', '        returns (Actions.ActionArgs memory)\n', '    {\n', '        return\n', '            Actions.ActionArgs({\n', '                actionType: Actions.ActionType.Withdraw,\n', '                accountId: 0,\n', '                amount: Types.AssetAmount({\n', '                    sign: false,\n', '                    denomination: Types.AssetDenomination.Wei,\n', '                    ref: Types.AssetReference.Delta,\n', '                    value: amount\n', '                }),\n', '                primaryMarketId: marketId,\n', '                secondaryMarketId: 0,\n', '                otherAddress: address(this),\n', '                otherAccountId: 0,\n', '                data: ""\n', '            });\n', '    }\n', '\n', '    function _getCallAction(bytes memory data)\n', '        internal\n', '        view\n', '        returns (Actions.ActionArgs memory)\n', '    {\n', '        return\n', '            Actions.ActionArgs({\n', '                actionType: Actions.ActionType.Call,\n', '                accountId: 0,\n', '                amount: Types.AssetAmount({\n', '                    sign: false,\n', '                    denomination: Types.AssetDenomination.Wei,\n', '                    ref: Types.AssetReference.Delta,\n', '                    value: 0\n', '                }),\n', '                primaryMarketId: 0,\n', '                secondaryMarketId: 0,\n', '                otherAddress: address(this),\n', '                otherAccountId: 0,\n', '                data: data\n', '            });\n', '    }\n', '\n', '    function _getDepositAction(uint marketId, uint256 amount)\n', '        internal\n', '        view\n', '        returns (Actions.ActionArgs memory)\n', '    {\n', '        return\n', '            Actions.ActionArgs({\n', '                actionType: Actions.ActionType.Deposit,\n', '                accountId: 0,\n', '                amount: Types.AssetAmount({\n', '                    sign: true,\n', '                    denomination: Types.AssetDenomination.Wei,\n', '                    ref: Types.AssetReference.Delta,\n', '                    value: amount\n', '                }),\n', '                primaryMarketId: marketId,\n', '                secondaryMarketId: 0,\n', '                otherAddress: address(this),\n', '                otherAccountId: 0,\n', '                data: ""\n', '            });\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ICallee\n', ' * @author dYdX\n', ' *\n', ' * Interface that Callees for Solo must implement in order to ingest data.\n', ' */\n', 'interface ICallee {\n', '\n', '    // ============ Public Functions ============\n', '\n', '    /**\n', '     * Allows users to send this contract arbitrary data.\n', '     *\n', '     * @param  sender       The msg.sender to Solo\n', '     * @param  accountInfo  The account from which the data is being sent\n', '     * @param  data         Arbitrary data given by the sender\n', '     */\n', '    function callFunction(\n', '        address sender,\n', '        Account.Info calldata accountInfo,\n', '        bytes calldata data\n', '    )\n', '        external;\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call.value(weiValue)(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract DSMath {\n', '  uint constant WAD = 10 ** 18;\n', '  uint constant RAY = 10 ** 27;\n', '\n', '  function add(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(x, y);\n', '  }\n', '\n', '  function sub(uint x, uint y) internal virtual pure returns (uint z) {\n', '    z = SafeMath.sub(x, y);\n', '  }\n', '\n', '  function mul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.mul(x, y);\n', '  }\n', '\n', '  function div(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.div(x, y);\n', '  }\n', '\n', '  function wmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), WAD / 2) / WAD;\n', '  }\n', '\n', '  function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, WAD), y / 2) / y;\n', '  }\n', '\n', '  function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, RAY), y / 2) / y;\n', '  }\n', '\n', '  function rmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), RAY / 2) / RAY;\n', '  }\n', '\n', '}\n', '\n', 'interface DSAInterface {\n', '    function cast(address[] calldata _targets, bytes[] calldata _datas, address _origin) external payable;\n', '}\n', '\n', 'contract Helper {\n', '    struct CastData {\n', '        address dsa;\n', '        address token;\n', '        uint amount;\n', '        address[] targets;\n', '        bytes[] data;\n', '    }\n', '\n', '    function encodeDsaAddr(address dsa, bytes memory data) internal pure returns (bytes memory _data) {\n', '        CastData memory cd;\n', '        (cd.token, cd.amount, cd.targets, cd.data) = abi.decode(data, (address, uint256, address[], bytes[]));\n', '        _data = abi.encode(dsa, cd.token, cd.amount, cd.targets, cd.data);\n', '    }\n', '}\n', '\n', 'contract DydxFlashloaner is ICallee, DydxFlashloanBase, DSMath, Helper {\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public constant soloAddr = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;\n', '    address public constant wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address public constant ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    event LogDydxFlashLoan(\n', '        address indexed sender,\n', '        address indexed token,\n', '        uint amount\n', '    );\n', '\n', '    function callFunction(\n', '        address sender,\n', '        Account.Info memory account,\n', '        bytes memory data\n', '    ) public override {\n', '        require(sender == address(this), "not-same-sender");\n', '        CastData memory cd;\n', '        (cd.dsa, cd.token, cd.amount, cd.targets, cd.data) = abi.decode(\n', '            data,\n', '            (address, address, uint256, address[], bytes[])\n', '        );\n', '\n', '        IERC20 tokenContract;\n', '        if (cd.token == ethAddr) {\n', '            tokenContract = IERC20(wethAddr);\n', '            tokenContract.approve(wethAddr, cd.amount);\n', '            tokenContract.withdraw(cd.amount);\n', '            payable(cd.dsa).transfer(cd.amount);\n', '        } else {\n', '            tokenContract = IERC20(cd.token);\n', '            tokenContract.safeTransfer(cd.dsa, cd.amount);\n', '        }\n', '\n', '        DSAInterface(cd.dsa).cast(cd.targets, cd.data, 0xB7fA44c2E964B6EB24893f7082Ecc08c8d0c0F87);\n', '\n', '        if (cd.token == ethAddr) {\n', '            tokenContract.deposit.value(cd.amount)();\n', '        }\n', '\n', '    }\n', '\n', '    function initiateFlashLoan(address _token, uint256 _amount, bytes calldata data) external {\n', '        ISoloMargin solo = ISoloMargin(soloAddr);\n', '\n', '        uint256 marketId = _getMarketIdFromTokenAddress(soloAddr, _token);\n', '\n', '        IERC20(_token).approve(soloAddr, _amount + 2);\n', '\n', '        Actions.ActionArgs[] memory operations = new Actions.ActionArgs[](3);\n', '\n', '        operations[0] = _getWithdrawAction(marketId, _amount);\n', '        operations[1] = _getCallAction(encodeDsaAddr(msg.sender, data));\n', '        operations[2] = _getDepositAction(marketId, _amount + 2);\n', '\n', '        Account.Info[] memory accountInfos = new Account.Info[](1);\n', '        accountInfos[0] = _getAccountInfo();\n', '\n', '        IERC20 _tokenContract = IERC20(_token);\n', '        uint iniBal = _tokenContract.balanceOf(address(this));\n', '\n', '        solo.operate(accountInfos, operations);\n', '\n', '        uint finBal = _tokenContract.balanceOf(address(this));\n', '        require(sub(iniBal, finBal) < 5, "amount-paid-less");\n', '    }\n', '\n', '}\n', '\n', 'contract InstaDydxFlashLoan is DydxFlashloaner {\n', '\n', '    receive() external payable {}\n', '}']