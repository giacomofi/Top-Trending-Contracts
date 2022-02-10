['// DELTA-BUG-BOUNTY\n', 'pragma solidity ^0.7.6;\n', 'pragma abicoder v2;\n', '\n', '\n', 'import "../../../../common/OVLTokenTypes.sol";\n', 'import "../../Common/OVLVestingCalculator.sol";\n', 'import "../../../../interfaces/IOVLBalanceHandler.sol";\n', 'import "../../../../interfaces/IOVLTransferHandler.sol";\n', 'import "../../../../interfaces/IRebasingLiquidityToken.sol";\n', 'import "../../../../interfaces/IDeltaToken.sol";\n', '\n', 'contract OVLBalanceHandler is OVLVestingCalculator, IOVLBalanceHandler {\n', '    using SafeMath for uint256;\n', '\n', '    IDeltaToken private immutable DELTA_TOKEN;\n', '    IERC20 private immutable DELTA_X_WETH_PAIR;\n', '    IOVLTransferHandler private immutable TRANSFER_HANDLER;\n', '    address private constant UNI_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '\n', '\n', '    constructor(IOVLTransferHandler transactionHandler, IERC20 pair) {\n', '        DELTA_TOKEN = IDeltaToken(msg.sender);\n', '        TRANSFER_HANDLER = transactionHandler;\n', '        DELTA_X_WETH_PAIR = pair;\n', '    }\n', '\n', '    function handleBalanceCalculations(address account, address sender) external view override returns (uint256) {\n', '        UserInformation memory ui = DELTA_TOKEN.userInformation(account);\n', '        // LP Removal protection\n', '        if(sender == address(DELTA_X_WETH_PAIR) && !DELTA_TOKEN.liquidityRebasingPermitted()) { // This guaranteed liquidity rebasing is not permitted and the sender whos calling is uniswap.\n', '            // If the sender is uniswap and is querying balanceOf, this only happens first inside the burn function\n', '            // This means if the balance of LP tokens here went up\n', '            // We should revert\n', '            // LP tokens supply can raise but it can never get lower with this method, if we detect a raise here we should revert\n', '            // Rest of this code is inside the _transfer function\n', '            require(DELTA_X_WETH_PAIR.balanceOf(address(DELTA_X_WETH_PAIR)) == DELTA_TOKEN.lpTokensInPair(), "DELTAToken: Liquidity removal is forbidden");\n', '            return ui.maxBalance;\n', '        }\n', '        // We trick the uniswap router path revert by returning the whole balance\n', '        // As well as saving gas in noVesting callers like uniswap\n', '        if(ui.noVestingWhitelisted || sender == UNI_ROUTER) {\n', '            return ui.maxBalance;\n', '        } \n', '        // potentially do i + 1 % epochs\n', '        while (true) {\n', '            uint256 mature = getMatureBalance(DELTA_TOKEN.vestingTransactions(account, ui.mostMatureTxIndex), block.timestamp); \n', '            ui.maturedBalance = ui.maturedBalance.add(mature);\n', '    \n', '            // We go until we encounter a empty above most mature tx\n', '            if(ui.mostMatureTxIndex == ui.lastInTxIndex) { \n', '                break;\n', '            }\n', '            ui.mostMatureTxIndex++;\n', '            if(ui.mostMatureTxIndex == QTY_EPOCHS) { ui.mostMatureTxIndex = 0; }\n', '        }\n', '\n', '        return ui.maturedBalance;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '// DELTA-BUG-BOUNTY\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'struct VestingTransaction {\n', '    uint256 amount;\n', '    uint256 fullVestingTimestamp;\n', '}\n', '\n', 'struct WalletTotals {\n', '    uint256 mature;\n', '    uint256 immature;\n', '    uint256 total;\n', '}\n', '\n', 'struct UserInformation {\n', '    // This is going to be read from only [0]\n', '    uint256 mostMatureTxIndex;\n', '    uint256 lastInTxIndex;\n', '    uint256 maturedBalance;\n', '    uint256 maxBalance;\n', '    bool fullSenderWhitelisted;\n', '    // Note that recieving immature balances doesnt mean they recieve them fully vested just that senders can do it\n', '    bool immatureReceiverWhitelisted;\n', '    bool noVestingWhitelisted;\n', '}\n', '\n', 'struct UserInformationLite {\n', '    uint256 maturedBalance;\n', '    uint256 maxBalance;\n', '    uint256 mostMatureTxIndex;\n', '    uint256 lastInTxIndex;\n', '}\n', '\n', 'struct VestingTransactionDetailed {\n', '    uint256 amount;\n', '    uint256 fullVestingTimestamp;\n', '    // uint256 percentVestedE4;\n', '    uint256 mature;\n', '    uint256 immature;\n', '}\n', '\n', '\n', 'uint256 constant QTY_EPOCHS = 7;\n', '\n', 'uint256 constant SECONDS_PER_EPOCH = 172800; // About 2days\n', '\n', 'uint256 constant FULL_EPOCH_TIME = SECONDS_PER_EPOCH * QTY_EPOCHS;\n', '\n', '// Precision Multiplier -- this many zeros (23) seems to get all the precision needed for all 18 decimals to be only off by a max of 1 unit\n', 'uint256 constant PM = 1e23;\n', '\n', '// DELTA-BUG-BOUNTY\n', 'pragma solidity ^0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'import "./../../../common/OVLTokenTypes.sol";\n', 'import "../../../interfaces/IOVLVestingCalculator.sol";\n', 'import "../../libs/SafeMath.sol";\n', '\n', 'contract OVLVestingCalculator is IOVLVestingCalculator {\n', '    using SafeMath for uint256;\n', '\n', '    function getTransactionDetails(VestingTransaction memory _tx) public view override returns (VestingTransactionDetailed memory dtx) {\n', '        return getTransactionDetails(_tx, block.timestamp);\n', '    }\n', '\n', '    function getTransactionDetails(VestingTransaction memory _tx, uint256 _blockTimestamp) public pure override returns (VestingTransactionDetailed memory dtx) {\n', '        if(_tx.fullVestingTimestamp == 0) {\n', '            return dtx;\n', '        }\n', '\n', '        dtx.amount = _tx.amount;\n', '        dtx.fullVestingTimestamp = _tx.fullVestingTimestamp;\n', '\n', '        // at precision E4, 1000 is 10%\n', '        uint256 timeRemaining;\n', '        if(_blockTimestamp >= dtx.fullVestingTimestamp) {\n', '            // Fully vested\n', '            dtx.mature = _tx.amount;\n', '            return dtx;\n', '        } else {\n', '            timeRemaining = dtx.fullVestingTimestamp - _blockTimestamp;\n', '        }\n', '\n', '        uint256 percentWaitingToVestE4 = timeRemaining.mul(1e4) / FULL_EPOCH_TIME;\n', '        uint256 percentWaitingToVestE4Scaled = percentWaitingToVestE4.mul(90) / 100;\n', '\n', '        dtx.immature = _tx.amount.mul(percentWaitingToVestE4Scaled) / 1e4;\n', '        dtx.mature = _tx.amount.sub(dtx.immature);\n', '    }\n', '\n', '    function getMatureBalance(VestingTransaction memory _tx, uint256 _blockTimestamp) public pure override returns (uint256 mature) {\n', '        if(_tx.fullVestingTimestamp == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        uint256 timeRemaining;\n', '        if(_blockTimestamp >= _tx.fullVestingTimestamp) {\n', '            // Fully vested\n', '            return _tx.amount;\n', '        } else {\n', '            timeRemaining = _tx.fullVestingTimestamp - _blockTimestamp;\n', '        }\n', '\n', '        uint256 percentWaitingToVestE4 = timeRemaining.mul(1e4) / FULL_EPOCH_TIME;\n', '        uint256 percentWaitingToVestE4Scaled = percentWaitingToVestE4.mul(90) / 100;\n', '\n', '        mature = _tx.amount.mul(percentWaitingToVestE4Scaled) / 1e4;\n', '        mature = _tx.amount.sub(mature); // the subtracted value represents the immature balance at this point\n', '    }\n', '\n', '    function calculateTransactionDebit(VestingTransactionDetailed memory dtx, uint256 matureAmountNeeded, uint256 currentTimestamp) public pure override returns (uint256 outputDebit) {\n', '        if(dtx.fullVestingTimestamp > currentTimestamp) {\n', '            // This will be between 0 and 100*pm representing how much of the mature pool is needed\n', '            uint256 percentageOfMatureCoinsConsumed = matureAmountNeeded.mul(PM).div(dtx.mature);\n', '            require(percentageOfMatureCoinsConsumed <= PM, "OVLTransferHandler: Insufficient funds");\n', '\n', '            // Calculate the number of immature coins that need to be debited based on this ratio\n', '            outputDebit = dtx.immature.mul(percentageOfMatureCoinsConsumed) / PM;\n', '        }\n', '\n', '        // shouldnt this use outputDebit\n', '        require(dtx.amount <= dtx.mature.add(dtx.immature), "DELTAToken: Balance maximum problem"); // Just in case\n', '    }\n', '}\n', '\n', 'pragma experimental ABIEncoderV2;\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IOVLBalanceHandler {\n', '    function handleBalanceCalculations(address, address) external view returns (uint256);\n', '}\n', '\n', 'pragma experimental ABIEncoderV2;\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IOVLTransferHandler {\n', '    function handleTransfer(address sender, address recipient, uint256 amount) external;\n', '}\n', '\n', 'pragma experimental ABIEncoderV2;\n', 'pragma solidity ^0.7.6;\n', 'import "./IERC20Upgradeable.sol";\n', 'interface IRebasingLiquidityToken is IERC20Upgradeable {\n', '    function tokenCaller() external;\n', '    function reserveCaller(uint256,uint256) external;\n', '    function wrapWithReturn() external returns (uint256);\n', '    function wrap() external;\n', '    function rlpPerLP() external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma experimental ABIEncoderV2;\n', 'pragma solidity ^0.7.6;\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; \n', '\n', 'import "../common/OVLTokenTypes.sol";\n', '\n', 'interface IDeltaToken is IERC20 {\n', '    function vestingTransactions(address, uint256) external view returns (VestingTransaction memory);\n', '    function getUserInfo(address) external view returns (UserInformationLite memory);\n', '    function getMatureBalance(address, uint256) external view returns (uint256);\n', '    function liquidityRebasingPermitted() external view returns (bool);\n', '    function lpTokensInPair() external view returns (uint256);\n', '    function governance() external view returns (address);\n', '    function performLiquidityRebasing() external;\n', '    function distributor() external view returns (address);\n', '    function totalsForWallet(address ) external view returns (WalletTotals memory totals);\n', '    function adjustBalanceOfNoVestingAccount(address, uint256,bool) external;\n', '    function userInformation(address user) external view returns (UserInformation memory);\n', '\n', '}\n', '\n', 'pragma solidity ^0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'import "../common/OVLTokenTypes.sol";\n', '\n', 'interface IOVLVestingCalculator {\n', '    function getTransactionDetails(VestingTransaction memory _tx) external view returns (VestingTransactionDetailed memory dtx);\n', '\n', '    function getTransactionDetails(VestingTransaction memory _tx, uint256 _blockTimestamp) external pure returns (VestingTransactionDetailed memory dtx);\n', '\n', '    function getMatureBalance(VestingTransaction memory _tx, uint256 _blockTimestamp) external pure returns (uint256 mature);\n', '\n', '    function calculateTransactionDebit(VestingTransactionDetailed memory dtx, uint256 matureAmountNeeded, uint256 currentTimestamp) external pure returns (uint256 outputDebit);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20Upgradeable {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']