['//SPDX-License-Identifier: Unlicense\n', 'pragma solidity ^0.6.10;\n', '\n', 'import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";\n', 'import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', 'import { Vesting } from "./Vesting.sol";\n', '\n', '/**\n', ' * @title OtcEscrow\n', ' * @author Badger DAO (Modified by Set Protocol)\n', ' * \n', ' * A simple OTC swap contract allowing two users to set the parameters of an OTC\n', ' * deal in the constructor arguments, and deposits the sold tokens into a vesting\n', ' * contract when a swap is completed.\n', ' */\n', 'contract OtcEscrow {\n', '\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    /* ========== Events =========== */\n', '\n', '    event VestingDeployed(address vesting);\n', '    \n', '    /* ====== Modifiers ======== */\n', '\n', '    /**\n', '     * Throws if the sender is not Index Gov\n', '     */\n', '    modifier onlyIndexGov() {\n', '        require(msg.sender == indexGov, "unauthorized");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Throws if run more than once\n', '     */\n', '    modifier onlyOnce() {\n', '        require(!hasRun, "swap already executed");\n', '        hasRun = true;\n', '        _;\n', '    }\n', '\n', '    /* ======== State Variables ======= */\n', '\n', '    address public usdc;\n', '    address public index;\n', '\n', '    address public indexGov;\n', '    address public beneficiary;\n', '\n', '    uint256 public vestingStart;\n', '    uint256 public vestingEnd;\n', '    uint256 public vestingCliff;\n', '\n', '    uint256 public usdcAmount;\n', '    uint256 public indexAmount;\n', '\n', '    bool hasRun;\n', '\n', '\n', '\n', '    /* ====== Constructor ======== */\n', '\n', '    /**\n', '     * Sets the state variables that encode the terms of the OTC sale\n', '     *\n', '     * @param _beneficiary  Address that will purchase INDEX\n', '     * @param _indexGov     Address that will receive USDC\n', '     * @param _vestingStart Timestamp of vesting start\n', '     * @param _vestingCliff Timestamp of vesting cliff\n', '     * @param _vestingEnd   Timestamp of vesting end\n', '     * @param _usdcAmount   Amount of USDC swapped for the sale\n', '     * @param _indexAmount  Amount of INDEX swapped for the sale\n', '     * @param _usdcAddress  Address of the USDC token\n', '     * @param _indexAddress Address of the Index token\n', '     */\n', '    constructor(\n', '        address _beneficiary,\n', '        address _indexGov,\n', '        uint256 _vestingStart,\n', '        uint256 _vestingCliff,\n', '        uint256 _vestingEnd,\n', '        uint256 _usdcAmount,\n', '        uint256 _indexAmount,\n', '        address _usdcAddress,\n', '        address _indexAddress\n', '    ) public {\n', '        beneficiary = _beneficiary;\n', '        indexGov =  _indexGov;\n', '\n', '        vestingStart = _vestingStart;\n', '        vestingCliff = _vestingCliff;\n', '        vestingEnd = _vestingEnd;\n', '\n', '        usdcAmount = _usdcAmount;\n', '        indexAmount = _indexAmount;\n', '\n', '        usdc = _usdcAddress;\n', '        index = _indexAddress;\n', '        hasRun = false;\n', '    }\n', '    \n', '    /* ======= External Functions ======= */\n', '\n', '    /**\n', '     * Executes the OTC deal. Sends the USDC from the beneficiary to Index Governance, and\n', '     * locks the INDEX in the vesting contract. Can only be called once.\n', '     */\n', '    function swap() external onlyOnce {\n', '\n', '        require(IERC20(index).balanceOf(address(this)) >= indexAmount, "insufficient INDEX");\n', '\n', '        // Transfer expected USDC from beneficiary\n', '        IERC20(usdc).safeTransferFrom(beneficiary, address(this), usdcAmount);\n', '\n', '        // Create Vesting contract\n', '        Vesting vesting = new Vesting(index, beneficiary, indexAmount, vestingStart, vestingCliff, vestingEnd);\n', '\n', '        // Transfer index to vesting contract\n', '        IERC20(index).safeTransfer(address(vesting), indexAmount);\n', '\n', '        // Transfer USDC to index governance\n', '        IERC20(usdc).safeTransfer(indexGov, usdcAmount);\n', '\n', '        emit VestingDeployed(address(vesting));\n', '    }\n', '\n', '    /**\n', '     * Return INDEX to Index Governance to revoke the deal\n', '     */\n', '    function revoke() external onlyIndexGov {\n', '        uint256 indexBalance = IERC20(index).balanceOf(address(this));\n', '        IERC20(index).safeTransfer(indexGov, indexBalance);\n', '    }\n', '\n', '    /**\n', '     * Recovers USDC accidentally sent to the contract\n', '     */\n', '    function recoverUsdc() external {\n', '        uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));\n', '        IERC20(usdc).safeTransfer(beneficiary, usdcBalance);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./IERC20.sol";\n', 'import "../../math/SafeMath.sol";\n', 'import "../../utils/Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.10;\n', '\n', 'import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', '\n', 'contract Vesting {\n', '    using SafeMath for uint256;\n', '\n', '    address public index;\n', '    address public recipient;\n', '\n', '    uint256 public vestingAmount;\n', '    uint256 public vestingBegin;\n', '    uint256 public vestingCliff;\n', '    uint256 public vestingEnd;\n', '\n', '    uint256 public lastUpdate;\n', '\n', '    constructor(\n', '        address index_,\n', '        address recipient_,\n', '        uint256 vestingAmount_,\n', '        uint256 vestingBegin_,\n', '        uint256 vestingCliff_,\n', '        uint256 vestingEnd_\n', '    ) public {\n', '        require(vestingBegin_ >= block.timestamp, "TreasuryVester.constructor: vesting begin too early");\n', '        require(vestingCliff_ >= vestingBegin_, "TreasuryVester.constructor: cliff is too early");\n', '        require(vestingEnd_ > vestingCliff_, "TreasuryVester.constructor: end is too early");\n', '\n', '        index = index_;\n', '        recipient = recipient_;\n', '\n', '        vestingAmount = vestingAmount_;\n', '        vestingBegin = vestingBegin_;\n', '        vestingCliff = vestingCliff_;\n', '        vestingEnd = vestingEnd_;\n', '\n', '        lastUpdate = vestingBegin;\n', '    }\n', '\n', '    function setRecipient(address recipient_) public {\n', '        require(msg.sender == recipient, "TreasuryVester.setRecipient: unauthorized");\n', '        recipient = recipient_;\n', '    }\n', '\n', '    function claim() public {\n', '        require(block.timestamp >= vestingCliff, "TreasuryVester.claim: not time yet");\n', '        uint256 amount;\n', '        if (block.timestamp >= vestingEnd) {\n', '            amount = IERC20(index).balanceOf(address(this));\n', '        } else {\n', '            amount = vestingAmount.mul(block.timestamp.sub(lastUpdate)).div(vestingEnd.sub(vestingBegin));\n', '            lastUpdate = block.timestamp;\n', '        }\n', '        IERC20(index).transfer(recipient, amount);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']