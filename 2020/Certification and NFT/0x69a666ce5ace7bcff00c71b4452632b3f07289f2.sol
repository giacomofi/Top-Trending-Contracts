['// File: smartcontract/chefInOne.sol\n', '\n', '/*\n', '\n', 'website: http://yfgyoza.money/\n', '\n', 'forked from SUSHI and YUNO and Kimchi\n', '\n', '*/\n', '\n', 'pragma solidity ^0.6.6;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal virtual view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal virtual view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    function mint(address _to, uint256 _amount) external;\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'interface IMigratorChef {\n', '    function migrate(IERC20 token) external returns (IERC20);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            size := extcodesize(account)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data)\n', '        internal\n', '        returns (bytes memory)\n', '    {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return\n', '            functionCallWithValue(\n', '                target,\n', '                data,\n', '                value,\n', '                "Address: low-level call with value failed"\n', '            );\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(\n', '            address(this).balance >= value,\n', '            "Address: insufficient balance for call"\n', '        );\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 weiValue,\n', '        string memory errorMessage\n', '    ) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{value: weiValue}(\n', '            data\n', '        );\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transfer.selector, to, value)\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, value)\n', '        );\n', '    }\n', '\n', '    function safeIncreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(\n', '            value\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    function safeDecreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(\n', '            value,\n', '            "SafeERC20: decreased allowance below zero"\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(\n', '            data,\n', '            "SafeERC20: low-level call failed"\n', '        );\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(\n', '                abi.decode(returndata, (bool)),\n', '                "SafeERC20: ERC20 operation did not succeed"\n', '            );\n', '        }\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract GYOZAChef is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    // Info of each user.\n', '    struct UserInfo {\n', '        uint256 amount; // How many LP tokens the user has provided.\n', '        uint256 rewardDebt; // Reward debt. See explanation below.\n', '        //\n', '        // We do some fancy math here. Basically, any point in time, the amount of GYOZAs\n', '        // entitled to a user but is pending to be distributed is:\n', '        //\n', '        //   pending reward = (user.amount * pool.accGYOZAPerShare) - user.rewardDebt\n', '    }\n', '\n', '    // Info of each pool.\n', '    struct PoolInfo {\n', '        IERC20 lpToken; // Address of LP token contract.\n', '        uint256 allocPoint; // How many allocation points assigned to this pool. GYOZAs to distribute per block.\n', '        uint256 lastRewardBlock; // Last block number that GYOZAs distribution occurs.\n', '        uint256 accGYOZAPerShare; // Accumulated GYOZAs per share, times 1e12. See below.\n', '    }\n', '\n', '    // The GYOZA TOKEN!\n', '    IERC20 public gyoza;\n', '    // Dev address.\n', '    address public devaddr;\n', '    // Community address.\n', '    address public communityaddr;\n', '    // Block number when bonus GYOZA period ends.\n', '    uint256 public bonusEndBlock;\n', '    // GYOZA tokens created per block.\n', '    uint256 public gyozaPerBlock;\n', '    // Bonus muliplier for early gyoza makers.\n', '    // no bonus\n', '    IMigratorChef public migrator;\n', '\n', '    // Info of each pool.\n', '    PoolInfo[] public poolInfo;\n', '    mapping(address => bool) public lpTokenExistsInPool;\n', '    // Info of each user that stakes LP tokens.\n', '    mapping(uint256 => mapping(address => UserInfo)) public userInfo;\n', '    // Total allocation poitns. Must be the sum of all allocation points in all pools.\n', '    uint256 public totalAllocPoint = 0;\n', '    // The block number when GYOZA mining starts.\n', '    uint256 public startBlock;\n', '\n', '    uint256 public blockInADay = 5760; // Assume 15s per block\n', '    uint256 public blockInAMonth = 172800;\n', '    uint256 public halvePeriod = blockInAMonth;\n', '    uint256 public minimumGYOZAPerBlock = 125 ether; // Start at 1000, halve 3 times, 500 > 250 > 125.\n', '    uint256 public lastHalveBlock ;\n', '\n', '    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);\n', '    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);\n', '    event EmergencyWithdraw(\n', '        address indexed user,\n', '        uint256 indexed pid,\n', '        uint256 amount\n', '    );\n', '    event Halve(uint256 newGYOZAPerBlock, uint256 nextHalveBlockNumber);\n', '\n', '    constructor(\n', '        IERC20 _gyoza,\n', '        address _devaddr,\n', '        address _communityaddr\n', '    ) public {\n', '        gyoza = _gyoza;\n', '        devaddr = _devaddr;\n', '        communityaddr = _communityaddr;\n', '        gyozaPerBlock = 1000 ether;\n', '        \n', '        startBlock = 9999999999999999;\n', '        lastHalveBlock = 9999999999999999;\n', '    }\n', '    \n', '    function initializeStartBlock(uint256 _startBlock) public onlyOwner {\n', '        if(startBlock == 9999999999999999) {\n', '            startBlock = _startBlock;\n', '            lastHalveBlock = _startBlock;\n', '        }\n', '    }\n', '\n', '    function doHalvingCheck(bool _withUpdate) public {\n', '        if (gyozaPerBlock <= minimumGYOZAPerBlock) {\n', '            return;\n', '        }\n', '        bool doHalve = block.number > lastHalveBlock + halvePeriod;\n', '        if (!doHalve) {\n', '            return;\n', '        }\n', '        uint256 newGYOZAPerBlock = gyozaPerBlock.div(2);\n', '        if (newGYOZAPerBlock >= minimumGYOZAPerBlock) {\n', '            gyozaPerBlock = newGYOZAPerBlock;\n', '            lastHalveBlock = block.number;\n', '            emit Halve(newGYOZAPerBlock, block.number + halvePeriod);\n', '\n', '            if (_withUpdate) {\n', '                massUpdatePools();\n', '            }\n', '        }\n', '    }\n', '\n', '    function poolLength() external view returns (uint256) {\n', '        return poolInfo.length;\n', '    }\n', '\n', '    // Add a new lp to the pool. Can only be called by the owner.\n', '    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.\n', '    function add(\n', '        uint256 _allocPoint,\n', '        IERC20 _lpToken,\n', '        bool _withUpdate\n', '    ) public onlyOwner {\n', '        require(\n', '            !lpTokenExistsInPool[address(_lpToken)],\n', '            "GYOZAChef: LP Token Address already exists in pool"\n', '        );\n', '        if (_withUpdate) {\n', '            massUpdatePools();\n', '        }\n', '        uint256 lastRewardBlock = block.number > startBlock\n', '            ? block.number\n', '            : startBlock;\n', '        totalAllocPoint = totalAllocPoint.add(_allocPoint);\n', '        poolInfo.push(\n', '            PoolInfo({\n', '                lpToken: _lpToken,\n', '                allocPoint: _allocPoint,\n', '                lastRewardBlock: lastRewardBlock,\n', '                accGYOZAPerShare: 0\n', '            })\n', '        );\n', '        lpTokenExistsInPool[address(_lpToken)] = true;\n', '    }\n', '\n', '    function updateLpTokenExists(address _lpTokenAddr, bool _isExists)\n', '        external\n', '        onlyOwner\n', '    {\n', '        lpTokenExistsInPool[_lpTokenAddr] = _isExists;\n', '    }\n', '\n', "    // Update the given pool's GYOZA allocation point. Can only be called by the owner.\n", '    function set(\n', '        uint256 _pid,\n', '        uint256 _allocPoint,\n', '        bool _withUpdate\n', '    ) public onlyOwner {\n', '        if (_withUpdate) {\n', '            massUpdatePools();\n', '        }\n', '        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(\n', '            _allocPoint\n', '        );\n', '        poolInfo[_pid].allocPoint = _allocPoint;\n', '    }\n', '\n', '    function setMigrator(IMigratorChef _migrator) public onlyOwner {\n', '        migrator = _migrator;\n', '    }\n', '\n', '    function migrate(uint256 _pid) public onlyOwner {\n', '        require(\n', '            address(migrator) != address(0),\n', '            "GYOZAChef: Address of migrator is null"\n', '        );\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        IERC20 lpToken = pool.lpToken;\n', '        uint256 bal = lpToken.balanceOf(address(this));\n', '        lpToken.safeApprove(address(migrator), bal);\n', '        IERC20 newLpToken = migrator.migrate(lpToken);\n', '        require(\n', '            !lpTokenExistsInPool[address(newLpToken)],\n', '            "GYOZAChef: New LP Token Address already exists in pool"\n', '        );\n', '        require(\n', '            bal == newLpToken.balanceOf(address(this)),\n', '            "GYOZAChef: New LP Token balance incorrect"\n', '        );\n', '        pool.lpToken = newLpToken;\n', '        lpTokenExistsInPool[address(newLpToken)] = true;\n', '    }\n', '\n', '    // View function to see pending GYOZAs on frontend.\n', '    function pendingGYOZA(uint256 _pid, address _user)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][_user];\n', '        uint256 accGYOZAPerShare = pool.accGYOZAPerShare;\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '        if (block.number > pool.lastRewardBlock && lpSupply != 0) {\n', '            uint256 blockPassed = block.number.sub(pool.lastRewardBlock);\n', '            uint256 gyozaReward = blockPassed\n', '                .mul(gyozaPerBlock)\n', '                .mul(pool.allocPoint)\n', '                .div(totalAllocPoint);\n', '            accGYOZAPerShare = accGYOZAPerShare.add(\n', '                gyozaReward.mul(1e12).div(lpSupply)\n', '            );\n', '        }\n', '        return\n', '            user.amount.mul(accGYOZAPerShare).div(1e12).sub(user.rewardDebt);\n', '    }\n', '\n', '    // Update reward vairables for all pools. Be careful of gas spending!\n', '    function massUpdatePools() public {\n', '        uint256 length = poolInfo.length;\n', '        for (uint256 pid = 0; pid < length; ++pid) {\n', '            updatePool(pid);\n', '        }\n', '    }\n', '\n', '    // Update reward variables of the given pool to be up-to-date.\n', '    function updatePool(uint256 _pid) public {\n', '        doHalvingCheck(false);\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        if (block.number <= pool.lastRewardBlock) {\n', '            return;\n', '        }\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '        if (lpSupply == 0) {\n', '            pool.lastRewardBlock = block.number;\n', '            return;\n', '        }\n', '        uint256 blockPassed = block.number.sub(pool.lastRewardBlock);\n', '        uint256 gyozaReward = blockPassed\n', '            .mul(gyozaPerBlock)\n', '            .mul(pool.allocPoint)\n', '            .div(totalAllocPoint);\n', '        gyoza.mint(devaddr, gyozaReward.div(50)); // 2%\n', '        gyoza.mint(communityaddr, gyozaReward.div(50)); // 2%\n', '        gyoza.mint(address(this), gyozaReward);\n', '        pool.accGYOZAPerShare = pool.accGYOZAPerShare.add(\n', '            gyozaReward.mul(1e12).div(lpSupply)\n', '        );\n', '        pool.lastRewardBlock = block.number;\n', '    }\n', '\n', '    // Deposit LP tokens to MasterChef for GYOZA allocation.\n', '    function deposit(uint256 _pid, uint256 _amount) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][msg.sender];\n', '        updatePool(_pid);\n', '        if (user.amount > 0) {\n', '            uint256 pending = user\n', '                .amount\n', '                .mul(pool.accGYOZAPerShare)\n', '                .div(1e12)\n', '                .sub(user.rewardDebt);\n', '            safeGYOZATransfer(msg.sender, pending);\n', '        }\n', '        pool.lpToken.safeTransferFrom(\n', '            address(msg.sender),\n', '            address(this),\n', '            _amount\n', '        );\n', '        user.amount = user.amount.add(_amount);\n', '        user.rewardDebt = user.amount.mul(pool.accGYOZAPerShare).div(1e12);\n', '        emit Deposit(msg.sender, _pid, _amount);\n', '    }\n', '\n', '    // Withdraw LP tokens from MasterChef.\n', '    function withdraw(uint256 _pid, uint256 _amount) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][msg.sender];\n', '        require(\n', '            user.amount >= _amount,\n', '            "GYOZAChef: Insufficient Amount to withdraw"\n', '        );\n', '        updatePool(_pid);\n', '        uint256 pending = user.amount.mul(pool.accGYOZAPerShare).div(1e12).sub(\n', '            user.rewardDebt\n', '        );\n', '        safeGYOZATransfer(msg.sender, pending);\n', '        user.amount = user.amount.sub(_amount);\n', '        user.rewardDebt = user.amount.mul(pool.accGYOZAPerShare).div(1e12);\n', '        pool.lpToken.safeTransfer(address(msg.sender), _amount);\n', '        emit Withdraw(msg.sender, _pid, _amount);\n', '    }\n', '\n', '    // Withdraw without caring about rewards. EMERGENCY ONLY.\n', '    function emergencyWithdraw(uint256 _pid) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][msg.sender];\n', '        pool.lpToken.safeTransfer(address(msg.sender), user.amount);\n', '        emit EmergencyWithdraw(msg.sender, _pid, user.amount);\n', '        user.amount = 0;\n', '        user.rewardDebt = 0;\n', '    }\n', '\n', '    // Safe gyoza transfer function, just in case if rounding error causes pool to not have enough GYOZAs.\n', '    function safeGYOZATransfer(address _to, uint256 _amount) internal {\n', '        uint256 gyozaBal = gyoza.balanceOf(address(this));\n', '        if (_amount > gyozaBal) {\n', '            gyoza.transfer(_to, gyozaBal);\n', '        } else {\n', '            gyoza.transfer(_to, _amount);\n', '        }\n', '    }\n', '\n', '    // Update dev address by the previous dev.\n', '    function dev(address _devaddr) public {\n', '        require(\n', '            msg.sender == devaddr,\n', '            "GYOZAChef: Sender is not the developer"\n', '        );\n', '        devaddr = _devaddr;\n', '    }\n', '}']