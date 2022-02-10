['// SPDX-License-Identifier: BUSL-1.1\n', 'pragma solidity 0.7.6;\n', '\n', 'import "./../abstract/PendleYieldTokenHolderBase.sol";\n', 'import "../../interfaces/IComptroller.sol";\n', '\n', 'contract PendleCompoundYieldTokenHolder is PendleYieldTokenHolderBase {\n', '    IComptroller private immutable comptroller;\n', '\n', '    constructor(\n', '        address _governanceManager,\n', '        address _forge,\n', '        address _yieldToken,\n', '        address _rewardToken,\n', '        address _rewardManager,\n', '        address _comptroller,\n', '        uint256 _expiry\n', '    )\n', '        PendleYieldTokenHolderBase(\n', '            _governanceManager,\n', '            _forge,\n', '            _yieldToken,\n', '            _rewardToken,\n', '            _rewardManager,\n', '            _expiry\n', '        )\n', '    {\n', '        require(_comptroller != address(0), "ZERO_ADDRESS");\n', '        comptroller = IComptroller(_comptroller);\n', '    }\n', '\n', '    function redeemRewards() external override {\n', '        address[] memory cTokens = new address[](1);\n', '        address[] memory holders = new address[](1);\n', '        cTokens[0] = yieldToken;\n', '        holders[0] = address(this);\n', '        comptroller.claimComp(holders, cTokens, false, true);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: BUSL-1.1\n', 'pragma solidity 0.7.6;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";\n', 'import "../../interfaces/IPendleYieldTokenHolder.sol";\n', 'import "../../periphery/WithdrawableV2.sol";\n', '\n', 'abstract contract PendleYieldTokenHolderBase is IPendleYieldTokenHolder, WithdrawableV2 {\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public immutable override yieldToken;\n', '    address public immutable override forge;\n', '    address public immutable override rewardToken;\n', '    uint256 public immutable override expiry;\n', '\n', '    constructor(\n', '        address _governanceManager,\n', '        address _forge,\n', '        address _yieldToken,\n', '        address _rewardToken,\n', '        address _rewardManager,\n', '        uint256 _expiry\n', '    ) PermissionsV2(_governanceManager) {\n', '        require(_yieldToken != address(0) && _rewardToken != address(0), "ZERO_ADDRESS");\n', '        yieldToken = _yieldToken;\n', '        forge = _forge;\n', '        rewardToken = _rewardToken;\n', '        expiry = _expiry;\n', '\n', '        IERC20(_yieldToken).safeApprove(_forge, type(uint256).max);\n', '        IERC20(_rewardToken).safeApprove(_rewardManager, type(uint256).max);\n', '    }\n', '\n', '    function redeemRewards() external virtual override;\n', '\n', '    // Only forge can call this function\n', '    // this will allow a spender to spend the whole balance of the specified tokens\n', '    // the spender should ideally be a contract with logic for users to withdraw out their funds.\n', '    function setUpEmergencyMode(address spender) external override {\n', '        require(msg.sender == forge, "NOT_FROM_FORGE");\n', '        IERC20(yieldToken).safeApprove(spender, type(uint256).max);\n', '        IERC20(rewardToken).safeApprove(spender, type(uint256).max);\n', '    }\n', '\n', '    // The governance address will be able to withdraw any tokens except for\n', '    // the yieldToken and the rewardToken\n', '    function _allowedToWithdraw(address _token) internal view override returns (bool allowed) {\n', '        allowed = _token != yieldToken && _token != rewardToken;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '/*\n', ' * MIT License\n', ' * ===========\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy\n', ' * of this software and associated documentation files (the "Software"), to deal\n', ' * in the Software without restriction, including without limitation the rights\n', ' * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', ' * copies of the Software, and to permit persons to whom the Software is\n', ' * furnished to do so, subject to the following conditions:\n', ' *\n', ' * The above copyright notice and this permission notice shall be included in all\n', ' * copies or substantial portions of the Software.\n', ' *\n', ' * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', ' */\n', 'pragma solidity 0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'interface IComptroller {\n', '    struct Market {\n', '        bool isListed;\n', '        uint256 collateralFactorMantissa;\n', '    }\n', '\n', '    function markets(address) external view returns (Market memory);\n', '\n', '    function claimComp(\n', '        address[] memory holders,\n', '        address[] memory cTokens,\n', '        bool borrowers,\n', '        bool suppliers\n', '    ) external;\n', '\n', '    function getAccountLiquidity(address account)\n', '        external\n', '        view\n', '        returns (\n', '            uint256 error,\n', '            uint256 liquidity,\n', '            uint256 shortfall\n', '        );\n', '    function getAssetsIn(address account) external view returns (address[] memory);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./IERC20.sol";\n', 'import "../../math/SafeMath.sol";\n', 'import "../../utils/Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '/*\n', ' * MIT License\n', ' * ===========\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy\n', ' * of this software and associated documentation files (the "Software"), to deal\n', ' * in the Software without restriction, including without limitation the rights\n', ' * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', ' * copies of the Software, and to permit persons to whom the Software is\n', ' * furnished to do so, subject to the following conditions:\n', ' *\n', ' * The above copyright notice and this permission notice shall be included in all\n', ' * copies or substantial portions of the Software.\n', ' *\n', ' * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', ' */\n', 'pragma solidity 0.7.6;\n', '\n', 'interface IPendleYieldTokenHolder {\n', '    function redeemRewards() external;\n', '\n', '    function setUpEmergencyMode(address spender) external;\n', '\n', '    function yieldToken() external returns (address);\n', '\n', '    function forge() external returns (address);\n', '\n', '    function rewardToken() external returns (address);\n', '\n', '    function expiry() external returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: BUSL-1.1\n', 'pragma solidity 0.7.6;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";\n', 'import "./PermissionsV2.sol";\n', '\n', 'abstract contract WithdrawableV2 is PermissionsV2 {\n', '    using SafeERC20 for IERC20;\n', '\n', '    event EtherWithdraw(uint256 amount, address sendTo);\n', '    event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Allows governance to withdraw Ether in a Pendle contract\n', '     *      in case of accidental ETH transfer into the contract.\n', '     * @param amount The amount of Ether to withdraw.\n', '     * @param sendTo The recipient address.\n', '     */\n', '    function withdrawEther(uint256 amount, address payable sendTo) external onlyGovernance {\n', '        (bool success, ) = sendTo.call{value: amount}("");\n', '        require(success, "WITHDRAW_FAILED");\n', '        emit EtherWithdraw(amount, sendTo);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows governance to withdraw all IERC20 compatible tokens in a Pendle\n', '     *      contract in case of accidental token transfer into the contract.\n', '     * @param token IERC20 The address of the token contract.\n', '     * @param amount The amount of IERC20 tokens to withdraw.\n', '     * @param sendTo The recipient address.\n', '     */\n', '    function withdrawToken(\n', '        IERC20 token,\n', '        uint256 amount,\n', '        address sendTo\n', '    ) external onlyGovernance {\n', '        require(_allowedToWithdraw(address(token)), "TOKEN_NOT_ALLOWED");\n', '        token.safeTransfer(sendTo, amount);\n', '        emit TokenWithdraw(token, amount, sendTo);\n', '    }\n', '\n', '    // must be overridden by the sub contracts, so we must consider explicitly\n', '    // in each and every contract which tokens are allowed to be withdrawn\n', '    function _allowedToWithdraw(address) internal view virtual returns (bool allowed);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: BUSL-1.1\n', 'pragma solidity 0.7.6;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "../core/PendleGovernanceManager.sol";\n', 'import "../interfaces/IPermissionsV2.sol";\n', '\n', 'abstract contract PermissionsV2 is IPermissionsV2 {\n', '    PendleGovernanceManager public immutable override governanceManager;\n', '    address internal initializer;\n', '\n', '    constructor(address _governanceManager) {\n', '        require(_governanceManager != address(0), "ZERO_ADDRESS");\n', '        initializer = msg.sender;\n', '        governanceManager = PendleGovernanceManager(_governanceManager);\n', '    }\n', '\n', '    modifier initialized() {\n', '        require(initializer == address(0), "NOT_INITIALIZED");\n', '        _;\n', '    }\n', '\n', '    modifier onlyGovernance() {\n', '        require(msg.sender == _governance(), "ONLY_GOVERNANCE");\n', '        _;\n', '    }\n', '\n', '    function _governance() internal view returns (address) {\n', '        return governanceManager.governance();\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: BUSL-1.1\n', 'pragma solidity 0.7.6;\n', '\n', 'contract PendleGovernanceManager {\n', '    address public governance;\n', '    address public pendingGovernance;\n', '\n', '    event GovernanceClaimed(address newGovernance, address previousGovernance);\n', '\n', '    event TransferGovernancePending(address pendingGovernance);\n', '\n', '    constructor(address _governance) {\n', '        require(_governance != address(0), "ZERO_ADDRESS");\n', '        governance = _governance;\n', '    }\n', '\n', '    modifier onlyGovernance() {\n', '        require(msg.sender == governance, "ONLY_GOVERNANCE");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingGovernance address to finalize the change governance process.\n', '     */\n', '    function claimGovernance() external {\n', '        require(pendingGovernance == msg.sender, "WRONG_GOVERNANCE");\n', '        emit GovernanceClaimed(pendingGovernance, governance);\n', '        governance = pendingGovernance;\n', '        pendingGovernance = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current governance to set the pendingGovernance address.\n', '     * @param _governance The address to transfer ownership to.\n', '     */\n', '    function transferGovernance(address _governance) external onlyGovernance {\n', '        require(_governance != address(0), "ZERO_ADDRESS");\n', '        pendingGovernance = _governance;\n', '\n', '        emit TransferGovernancePending(pendingGovernance);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '/*\n', ' * MIT License\n', ' * ===========\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy\n', ' * of this software and associated documentation files (the "Software"), to deal\n', ' * in the Software without restriction, including without limitation the rights\n', ' * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', ' * copies of the Software, and to permit persons to whom the Software is\n', ' * furnished to do so, subject to the following conditions:\n', ' *\n', ' * The above copyright notice and this permission notice shall be included in all\n', ' * copies or substantial portions of the Software.\n', ' *\n', ' * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', ' */\n', '\n', 'pragma solidity 0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'import "../core/PendleGovernanceManager.sol";\n', '\n', 'interface IPermissionsV2 {\n', '    function governanceManager() external returns (PendleGovernanceManager);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']