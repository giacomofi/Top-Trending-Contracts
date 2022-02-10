['// File: contracts/IERC20.sol\n', '\n', '//SPDX-License-Identifier: GPL-3.0-only\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/ITreasury.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', 'interface ITreasury {\n', '    function defaultToken() external view returns (IERC20);\n', '    function deposit(IERC20 token, uint256 amount) external;\n', '    function withdraw(uint256 amount, address withdrawAddress) external;\n', '}\n', '\n', '// File: contracts/vaults/IVault.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', 'interface IVault {\n', '    function want() external view returns (IERC20);\n', '    function transferFundsToStrategy(address strategy, uint256 amount) external;\n', '    function availableFunds() external view returns (uint256);\n', '}\n', '\n', '// File: contracts/vaults/IVaultRewards.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', 'interface IVaultRewards {\n', '    function want() external view returns (IERC20);\n', '    function notifyRewardAmount(uint256 reward) external;\n', '}\n', '\n', '// File: contracts/vaults/IController.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'interface IController {\n', '    function currentEpochTime() external view returns (uint256);\n', '    function balanceOf(address) external view returns (uint256);\n', '    function rewards(address token) external view returns (IVaultRewards);\n', '    function vault(address token) external view returns (IVault);\n', '    function allowableAmount(address) external view returns (uint256);\n', '    function treasury() external view returns (ITreasury);\n', '    function approvedStrategies(address, address) external view returns (bool);\n', '    function getHarvestInfo(address strategy, address user)\n', '        external view returns (\n', '        uint256 vaultRewardPercentage,\n', '        uint256 hurdleAmount,\n', '        uint256 harvestPercentage\n', '    );\n', '    function withdraw(address, uint256) external;\n', '    function earn(address, uint256) external;\n', '    function increaseHurdleRate(address token) external;\n', '}\n', '\n', '// File: contracts/vaults/IStrategy.sol\n', '\n', '/*\n', ' A strategy must implement the following functions:\n', ' - getName(): Name of strategy\n', ' - want(): Desired token for investment. Should be same as underlying vault token (Eg. USDC)\n', ' - deposit function that will calls controller.earn()\n', ' - withdraw(address): For miscellaneous tokens, must exclude any tokens used in the yield\n', '    - Should return to Controller\n', ' - withdraw(uint): Controller | Vault role - withdraw should always return to vault\n', ' - withdrawAll(): Controller | Vault role - withdraw should always return to vault\n', ' - balanceOf(): Should return underlying vault token amount\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'interface IStrategy {\n', '    function getName() external pure returns (string memory);\n', '    function want() external view returns (address);\n', '    function withdraw(address) external;\n', '    function withdraw(uint256) external;\n', '    function withdrawAll() external returns (uint256);\n', '    function balanceOf() external view returns (uint256);\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '// Note: This file has been modified to include the sqrt function for quadratic voting\n', '/**\n', ' * @dev Standard math utilities missing in the Solidity language.\n', ' */\n', 'library Math {\n', '    /**\n', '     * @dev Returns the largest of two numbers.\n', '     */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '\n', '    /**\n', '    * Imported from: https://github.com/alianse777/solidity-standard-library/blob/master/Math.sol\n', '    * @dev Compute square root of x\n', '    * @return sqrt(x)\n', '    */\n', '   function sqrt(uint256 x) internal pure returns (uint256) {\n', '       uint256 n = x / 2;\n', '       uint256 lstX = 0;\n', '       while (n != lstX){\n', '           lstX = n;\n', '           n = (n + x/n) / 2;\n', '       }\n', '       return uint256(n);\n', '   }\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/zeppelin/Address.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * IMPORTANT: It is unsafe to assume that an address for which this\n', '     * function returns false is an externally-owned account (EOA) and not a\n', '     * contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: contracts/zeppelin/SafeERC20.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/vaults/BoostController.sol\n', '\n', '//SPDX-License-Identifier: MIT\n', '/*\n', '* MIT License\n', '* ===========\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract BoostController is IController {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint256;\n', '\n', '    struct TokenStratInfo {\n', '        IVault vault;\n', '        IVaultRewards rewards;\n', '        IStrategy[] strategies;\n', '        uint256 currentHurdleRate;\n', '        uint256 nextHurdleRate;\n', '        uint256 hurdleLastUpdateTime;\n', '        uint256 harvestPrice;\n', '        uint256 globalHarvestLastUpdateTime;\n', '        mapping(address => uint256) harvestPercentages;\n', '        mapping(address => uint256) harvestLastUpdateTime;\n', '    }\n', '\n', '    address public gov;\n', '    address public strategist;\n', '    ITreasury public treasury;\n', '    IERC20 public boostToken;\n', '\n', '    mapping(address => TokenStratInfo) public tokenStratsInfo;\n', '    mapping(address => uint256) public capAmounts;\n', '    mapping(address => uint256) public investedAmounts;\n', '    mapping(address => mapping(address => bool)) public approvedStrategies;\n', '\n', '    uint256 public currentEpochTime;\n', '    uint256 public constant EPOCH_DURATION = 1 weeks;\n', '    uint256 internal constant DENOM = 10000;\n', '    uint256 internal constant HURDLE_RATE_MAX = 500; // max 5%\n', '    uint256 internal constant BASE_HARVEST_PERCENTAGE = 50; // 0.5%\n', '    uint256 internal constant BASE_REWARD_PERCENTAGE = 5000; // 50%\n', '    uint256 internal constant HARVEST_PERCENTAGE_MAX = 100; // max 1% extra\n', '    uint256 internal constant PRICE_INCREASE = 10100; // 1.01x\n', '    uint256 internal constant EPOCH_PRICE_REDUCTION = 8000; // 0.8x\n', '\n', '    uint256 vaultRewardChangePrice = 10e18; // initial cost of 10 boosts\n', '    uint256 public globalVaultRewardPercentage = BASE_REWARD_PERCENTAGE;\n', '    uint256 vaultRewardLastUpdateTime;\n', '\n', '    constructor(\n', '        address _gov,\n', '        address _strategist,\n', '        ITreasury _treasury,\n', '        IERC20 _boostToken,\n', '        uint256 _epochStart\n', '    ) public {\n', '        gov = _gov;\n', '        strategist = _strategist;\n', '        treasury = _treasury;\n', '        boostToken = _boostToken;\n', '        currentEpochTime = _epochStart;\n', '    }\n', '\n', '    modifier updateEpoch() {\n', '        if (block.timestamp > currentEpochTime.add(EPOCH_DURATION)) {\n', '            currentEpochTime = currentEpochTime.add(EPOCH_DURATION);\n', '        }\n', '        _;\n', '    }\n', '\n', '    function rewards(address token) external view returns (IVaultRewards) {\n', '        return tokenStratsInfo[token].rewards;\n', '    }\n', '\n', '    function vault(address token) external view returns (IVault) {\n', '        return tokenStratsInfo[token].vault;\n', '    }\n', '\n', '    function balanceOf(address token) external view returns (uint256) {\n', '        IStrategy[] storage strategies = tokenStratsInfo[token].strategies;\n', '        uint256 totalBalance;\n', '        for (uint256 i = 0; i < strategies.length; i++) {\n', '            totalBalance = totalBalance.add(strategies[i].balanceOf());\n', '        }\n', '        return totalBalance;\n', '    }\n', '\n', '    function allowableAmount(address strategy) external view returns(uint256) {\n', '        return capAmounts[strategy].sub(investedAmounts[strategy]);\n', '    }\n', '\n', '    function getHarvestInfo(\n', '        address strategy,\n', '        address user\n', '    ) external view returns (\n', '        uint256 vaultRewardPercentage,\n', '        uint256 hurdleAmount,\n', '        uint256 harvestPercentage\n', '    ) {\n', '        address token = IStrategy(strategy).want();\n', '        vaultRewardPercentage = globalVaultRewardPercentage;\n', '        hurdleAmount = getHurdleAmount(strategy, token);\n', '        harvestPercentage = getHarvestPercentage(user, token);\n', '    }\n', '\n', '    function getHarvestUserInfo(address user, address token)\n', '        external\n', '        view\n', '        returns (uint256 harvestPercentage, uint256 lastUpdateTime)\n', '    {\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        harvestPercentage = info.harvestPercentages[user];\n', '        lastUpdateTime = info.harvestLastUpdateTime[user];\n', '    }\n', '\n', '    function getStrategies(address token) external view returns (IStrategy[] memory strategies) {\n', '        return tokenStratsInfo[token].strategies;\n', '    }\n', '\n', '    function setTreasury(ITreasury _treasury) external updateEpoch {\n', '        require(msg.sender == gov, "!gov");\n', '        treasury = _treasury;\n', '    }\n', '\n', '    function setStrategist(address _strategist) external updateEpoch {\n', '        require(msg.sender == gov, "!gov");\n', '        strategist = _strategist;\n', '    }\n', '\n', '    function setGovernance(address _gov) external updateEpoch {\n', '        require(msg.sender == gov, "!gov");\n', '        gov = _gov;\n', '    }\n', '\n', '    function setRewards(IVaultRewards _rewards) external updateEpoch {\n', '        require(msg.sender == strategist || msg.sender == gov, "!authorized");\n', '        address token = address(_rewards.want());\n', '        require(tokenStratsInfo[token].rewards == IVaultRewards(0), "rewards exists");\n', '        tokenStratsInfo[token].rewards = _rewards;\n', '    }\n', '\n', '    function setVaultAndInitHarvestInfo(IVault _vault) external updateEpoch {\n', '        require(msg.sender == strategist || msg.sender == gov, "!authorized");\n', '        address token = address(_vault.want());\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        require(info.vault == IVault(0), "vault exists");\n', '        info.vault = _vault;\n', '        // initial harvest booster price of 1 boost\n', '        info.harvestPrice = 1e18;\n', '        info.globalHarvestLastUpdateTime = currentEpochTime;\n', '    }\n', '\n', '    function approveStrategy(address _strategy, uint256 _cap) external updateEpoch {\n', '        require(msg.sender == gov, "!gov");\n', '        address token = IStrategy(_strategy).want();\n', '        require(!approvedStrategies[token][_strategy], "strat alr approved");\n', '        require(tokenStratsInfo[token].vault.want() == IERC20(token), "unequal wants");\n', '        capAmounts[_strategy] = _cap;\n', '        tokenStratsInfo[token].strategies.push(IStrategy(_strategy));\n', '        approvedStrategies[token][_strategy] = true;\n', '    }\n', '\n', '    function changeCap(address strategy, uint256 _cap) external updateEpoch {\n', '        require(msg.sender == gov, "!gov");\n', '        capAmounts[strategy] = _cap;\n', '    }\n', '\n', '    function revokeStrategy(address _strategy, uint256 _index) external updateEpoch {\n', '        require(msg.sender == gov, "!gov");\n', '        address token = IStrategy(_strategy).want();\n', '        require(approvedStrategies[token][_strategy], "strat alr revoked");\n', '        IStrategy[] storage tokenStrategies = tokenStratsInfo[token].strategies;\n', '        require(address(tokenStrategies[_index]) == _strategy, "wrong index");\n', '\n', '        // replace revoked strategy with last element in array\n', '        tokenStrategies[_index] = tokenStrategies[tokenStrategies.length - 1];\n', '        delete tokenStrategies[tokenStrategies.length - 1];\n', '        tokenStrategies.length--;\n', '        capAmounts[_strategy] = 0;\n', '        approvedStrategies[token][_strategy] = false;\n', '    }\n', '\n', '    function getHurdleAmount(address strategy, address token) public view returns (uint256) {\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        return (info.hurdleLastUpdateTime < currentEpochTime ||\n', '        (block.timestamp > currentEpochTime.add(EPOCH_DURATION))) ?\n', '            0 :\n', '            info.currentHurdleRate\n', '            .mul(investedAmounts[strategy])\n', '            .div(DENOM);\n', '    }\n', '\n', '    function getHarvestPercentage(address user, address token) public view returns (uint256) {\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        return (info.harvestLastUpdateTime[user] < currentEpochTime ||\n', '            (block.timestamp > currentEpochTime.add(EPOCH_DURATION))) ?\n', '            BASE_HARVEST_PERCENTAGE :\n', '            info.harvestPercentages[user];\n', '    }\n', '\n', '    /// @dev check that vault has sufficient funds is done by the call to vault\n', '    function earn(address strategy, uint256 amount) public updateEpoch {\n', '        require(msg.sender == strategy, "!strategy");\n', '        address token = IStrategy(strategy).want();\n', '        require(approvedStrategies[token][strategy], "strat !approved");\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        uint256 newInvestedAmount = investedAmounts[strategy].add(amount);\n', '        require(newInvestedAmount <= capAmounts[strategy], "hit strategy cap");\n', '        // update invested amount\n', '        investedAmounts[strategy] = newInvestedAmount;\n', '        // transfer funds to strategy\n', '        info.vault.transferFundsToStrategy(strategy, amount);\n', '    }\n', '\n', '    // Anyone can withdraw non-core strategy tokens => sent to treasury\n', '    function earnMiscTokens(IStrategy strategy, IERC20 token) external updateEpoch {\n', '        // should send tokens to this contract\n', '        strategy.withdraw(address(token));\n', '        uint256 bal = token.balanceOf(address(this));\n', '        token.safeApprove(address(treasury), bal);\n', '        // send funds to treasury\n', '        treasury.deposit(token, bal);\n', '    }\n', '\n', '    function increaseHarvestPercentageHurdleRate(address token) external updateEpoch {\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        // first, handle vault global price and update time\n', '        // if new epoch, reduce price by 20%\n', '        if (info.globalHarvestLastUpdateTime < currentEpochTime) {\n', '            info.harvestPrice = info.harvestPrice.mul(EPOCH_PRICE_REDUCTION).div(DENOM);\n', '        }\n', '\n', '        // get funds from user, send to treasury\n', '        boostToken.safeTransferFrom(msg.sender, address(this), info.harvestPrice);\n', '        boostToken.safeApprove(address(treasury), info.harvestPrice);\n', '        treasury.deposit(boostToken, info.harvestPrice);\n', '\n', '        // increase price\n', '        info.harvestPrice = info.harvestPrice.mul(PRICE_INCREASE).div(DENOM);\n', '        // update globalHarvestLastUpdateTime\n', '        info.globalHarvestLastUpdateTime = block.timestamp;\n', '\n', "        // next, handle effect on harvest percentage and update user's harvest time\n", '        // see if percentage needs to be reset\n', '        if (info.harvestLastUpdateTime[msg.sender] < currentEpochTime) {\n', '            info.harvestPercentages[msg.sender] = BASE_HARVEST_PERCENTAGE;\n', '        }\n', '        info.harvestLastUpdateTime[msg.sender] = block.timestamp;\n', '\n', '        // increase harvest percentage by 0.25%\n', '        info.harvestPercentages[msg.sender] = Math.min(\n', '            HARVEST_PERCENTAGE_MAX,\n', '            info.harvestPercentages[msg.sender].add(25)\n', '        );\n', '        increaseHurdleRateInternal(info);\n', '    }\n', '\n', '    function changeVaultRewardPercentage(bool isIncrease) external updateEpoch {\n', '        // if new epoch, reduce price by 20%\n', '        if ((vaultRewardLastUpdateTime != 0) && (vaultRewardLastUpdateTime < currentEpochTime)) {\n', '            vaultRewardChangePrice = vaultRewardChangePrice.mul(EPOCH_PRICE_REDUCTION).div(DENOM);\n', '        }\n', '\n', '        // get funds from user, send to treasury\n', '        boostToken.safeTransferFrom(msg.sender, address(this), vaultRewardChangePrice);\n', '        boostToken.safeApprove(address(treasury), vaultRewardChangePrice);\n', '        treasury.deposit(boostToken, vaultRewardChangePrice);\n', '\n', '        // increase price\n', '        vaultRewardChangePrice = vaultRewardChangePrice.mul(PRICE_INCREASE).div(DENOM);\n', '        // update vaultRewardLastUpdateTime\n', '        vaultRewardLastUpdateTime = block.timestamp;\n', '        if (isIncrease) {\n', '            globalVaultRewardPercentage = Math.min(DENOM, globalVaultRewardPercentage.add(25));\n', '        } else {\n', '            globalVaultRewardPercentage = globalVaultRewardPercentage.sub(25);\n', '        }\n', '    }\n', '\n', '    // handle vault withdrawal\n', '    function withdraw(address token, uint256 withdrawAmount) external updateEpoch {\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        require(msg.sender == (address(info.vault)), "!vault");\n', '        uint256 remainingWithdrawAmount = withdrawAmount;\n', '\n', '        for (uint256 i = 0; i < info.strategies.length; i++) {\n', '            if (remainingWithdrawAmount == 0) break;\n', '            IStrategy strategy = info.strategies[i];\n', '            // withdraw maximum amount possible\n', '            uint256 actualWithdrawAmount = Math.min(\n', '                investedAmounts[address(strategy)], remainingWithdrawAmount\n', '            );\n', '            // update remaining withdraw amt\n', '            remainingWithdrawAmount = remainingWithdrawAmount.sub(actualWithdrawAmount);\n', '            // update strat invested amt\n', '            investedAmounts[address(strategy)] = investedAmounts[address(strategy)]\n', '                    .sub(actualWithdrawAmount);\n', '            // do the actual withdrawal\n', '            strategy.withdraw(actualWithdrawAmount);\n', '        }\n', '    }\n', '\n', '    function withdrawAll(address strategy) external updateEpoch {\n', '        require(\n', '            msg.sender == strategist ||\n', '            msg.sender == gov,\n', '            "!authorized"\n', '        );\n', '        investedAmounts[strategy] = 0;\n', '        IStrategy(strategy).withdrawAll();\n', '    }\n', '\n', '    function increaseHurdleRate(address token) external updateEpoch {\n', '        TokenStratInfo storage info = tokenStratsInfo[token];\n', '        require(msg.sender == address(info.rewards), "!authorized");\n', '        increaseHurdleRateInternal(info);\n', '    }\n', '\n', '    function increaseHurdleRateInternal(TokenStratInfo storage info) internal {\n', '        // see if hurdle rate has to update\n', '        if (info.hurdleLastUpdateTime < currentEpochTime) {\n', '            info.currentHurdleRate = info.nextHurdleRate;\n', '            info.nextHurdleRate = 0;\n', '        }\n', '        info.hurdleLastUpdateTime = block.timestamp;\n', '        // increase hurdle rate by 0.01%\n', '        info.nextHurdleRate = Math.min(HURDLE_RATE_MAX, info.nextHurdleRate.add(1));\n', '    }\n', '\n', '    function inCaseTokensGetStuck(address token, uint amount) public updateEpoch {\n', '        require(msg.sender == strategist || msg.sender == gov, "!authorized");\n', '        IERC20(token).safeTransfer(msg.sender, amount);\n', '    }\n', '\n', '    function inCaseStrategyTokenGetStuck(IStrategy strategy, address token) public updateEpoch {\n', '        require(msg.sender == strategist || msg.sender == gov, "!authorized");\n', '        strategy.withdraw(token);\n', '    }\n', '}']