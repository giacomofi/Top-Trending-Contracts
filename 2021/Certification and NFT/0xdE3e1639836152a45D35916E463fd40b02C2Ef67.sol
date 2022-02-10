['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-03\n', '*/\n', '\n', '// Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '// pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * // importANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// Dependency file: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '// pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: @openzeppelin/contracts/utils/Address.sol\n', '\n', '// pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [// importANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * // importANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', '// pragma solidity ^0.5.0;\n', '\n', '// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '// import "@openzeppelin/contracts/math/SafeMath.sol";\n', '// import "@openzeppelin/contracts/utils/Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/interfaces/IPOWToken.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IPOWToken {\n', '    function updateIncomeRate() external;\n', '    function incomeToken() external view returns(uint256);\n', '    function incomeRate() external view returns(uint256);\n', '    function startMiningTime() external view returns (uint256);\n', '    function mint(address to, uint value) external;\n', '    function remainingAmount() external view returns(uint256);\n', '    function rewardToken() external view returns(uint256);\n', '    function stakingRewardRate() external view returns(uint256);\n', '    function lpStakingRewardRate() external view returns(uint256);\n', '    function lpStaking2RewardRate() external view returns(uint256);\n', '    function rewardPeriodFinish() external view returns(uint256);\n', '    function claimIncome(address to, uint256 amount) external;\n', '    function claimReward(address to, uint256 amount) external;\n', '    function weiToIncomeTokenValue(uint256 amount) external view returns (uint256);\n', '    function lpStakingSupply() external view returns(uint256);\n', '    function lpStaking2Supply() external view returns(uint256);\n', '    function updateStakingPoolsIncome() external;\n', '    function updateStakingPoolsReward() external;\n', '    function getStakingRewardRate(address _pool) external view returns(uint256);\n', '    function getLpStakingSupply(address _pool) external view returns(uint256);\n', '    function isStakingPool(address _pool) external view  returns (bool);\n', '    function minter() external view returns(address);\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IERC20Detail.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IERC20Detail {\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '}\n', '\n', '// Dependency file: contracts/modules/ReentrancyGuard.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier\n', ' * available, which can be applied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' *\n', ' * TIP: If you would like to learn more about reentrancy and alternative ways\n', ' * to protect against it, check out our blog post\n', ' * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].\n', ' *\n', ' * _Since v2.5.0:_ this module is now much more gas efficient, given net gas\n', ' * metering changes introduced in the Istanbul hardfork.\n', ' */\n', 'contract ReentrancyGuard {\n', '    bool private _notEntered;\n', '\n', '    function initialize() internal {\n', '        // Storing an initial non-zero value makes deployment a bit more\n', '        // expensive, but in exchange the refund on every call to nonReentrant\n', '        // will be lower in amount. Since refunds are capped to a percetange of\n', "        // the total transaction's gas, it is best to keep them low in cases\n", '        // like this one, to increase the likelihood of the full refund coming\n', '        // into effect.\n', '        _notEntered = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(_notEntered, "ReentrancyGuard: reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        _notEntered = false;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        _notEntered = true;\n', '    }\n', '}\n', '\n', '// Dependency file: contracts/modules/Ownable.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', "        require(msg.sender == owner, 'Ownable: FORBIDDEN');\n", '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0), "new owner is the zero address");\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '// Dependency file: contracts/modules/Paramable.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', "// import 'contracts/modules/Ownable.sol';\n", '\n', 'contract Paramable is Ownable {\n', '    address public paramSetter;\n', '\n', '    event ParamSetterChanged(address indexed previousSetter, address indexed newSetter);\n', '\n', '    constructor() public {\n', '        paramSetter = msg.sender;\n', '    }\n', '\n', '    modifier onlyParamSetter() {\n', '        require(msg.sender == owner || msg.sender == paramSetter, "!paramSetter");\n', '        _;\n', '    }\n', '\n', '    function setParamSetter(address _paramSetter) external onlyOwner {\n', '        require(_paramSetter != address(0), "param setter is the zero address");\n', '        emit ParamSetterChanged(paramSetter, _paramSetter);\n', '        paramSetter = _paramSetter;\n', '    }\n', '\n', '}\n', '\n', '\n', '// Root file: contracts/TokenExchange.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', "// import '/Users/tercel/work/bmining/bmining-protocol/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol';\n", '// import "@openzeppelin/contracts/math/SafeMath.sol";\n', "// import '/Users/tercel/work/bmining/bmining-protocol/node_modules/@openzeppelin/contracts/token/ERC20/SafeERC20.sol';\n", '// import "contracts/interfaces/IPOWToken.sol";\n', '// import "contracts/interfaces/IERC20Detail.sol";\n', '// import "contracts/modules/ReentrancyGuard.sol";\n', "// import 'contracts/modules/Paramable.sol';\n", '\n', 'contract TokenExchange is Paramable, ReentrancyGuard{\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    bool private initialized;\n', '    uint256 public constant exchangeRateAmplifier = 1000;\n', '    address public hashRateToken;\n', '    address[] public exchangeTokens;\n', '    mapping (address => uint256) public exchangeRates;\n', '    mapping (address => bool) public isWhiteListed;\n', '\n', '    function initialize(address _hashRateToken) public {\n', '        require(!initialized, "already initialized");\n', "        require(IPOWToken(_hashRateToken).minter() == address(this), 'invalid hashRateToken');\n", '        super.initialize();\n', '        initialized = true;\n', '        hashRateToken = _hashRateToken;\n', '    }\n', '\n', '    function setWhiteLists (address[] calldata _users, bool[] calldata _values) external onlyOwner {\n', "        require(_users.length == _values.length, 'invalid parameters');\n", '        for (uint i=0; i<_users.length; i++){\n', '            _setWhiteList(_users[i], _values[i]);\n', '        }\n', '    }\n', '\n', '    function setWhiteList (address _user, bool _value) external onlyOwner {\n', "        require(isWhiteListed[_user] != _value, 'no change');\n", '        _setWhiteList(_user, _value);\n', '    }\n', '\n', '    function _setWhiteList (address _user, bool _value) internal {\n', '        emit ChangedWhiteList(_user, isWhiteListed[_user], _value);\n', '        isWhiteListed[_user] = _value;\n', '    }\n', '\n', '    function countExchangeTokens() public view returns (uint256) {\n', '        return exchangeTokens.length;\n', '    }\n', '\n', '    function setExchangeRate(address _exchangeToken, uint256 _exchangeRate) external onlyParamSetter {\n', '        exchangeRates[_exchangeToken] = _exchangeRate;\n', '        bool found = false;\n', '        for(uint256 i; i<exchangeTokens.length; i++) {\n', '            if(exchangeTokens[i] == _exchangeToken) {\n', '                found = true;\n', '                break;\n', '            }\n', '        }\n', '        if(!found) {\n', '            exchangeTokens.push(_exchangeToken);\n', '        }\n', '    }\n', '\n', '    function remainingAmount() public view returns(uint256) {\n', '        return IPOWToken(hashRateToken).remainingAmount();\n', '    }\n', '\n', '    function needAmount(address exchangeToken, uint256 amount) public view returns (uint256) {\n', '        uint256 hashRateTokenDecimal = IERC20Detail(hashRateToken).decimals();\n', '        uint256 exchangeTokenDecimal = IERC20Detail(exchangeToken).decimals();\n', '        uint256 hashRateTokenAmplifier = 10**hashRateTokenDecimal;\n', '        uint256 exchangeTokenAmplifier = 10**exchangeTokenDecimal;\n', '\n', '        return amount.mul(exchangeRates[exchangeToken]).mul(exchangeTokenAmplifier).div(hashRateTokenAmplifier).div(exchangeRateAmplifier);\n', '    }\n', '\n', '    function exchange(address exchangeToken, uint256 amount, address to) external nonReentrant {\n', '        require(amount > 0, "Cannot exchange 0");\n', '        require(exchangeRates[exchangeToken] > 0, "exchangeRates is 0");\n', '        require(amount <= remainingAmount(), "not sufficient supply");\n', '\n', '        uint256 token_amount = needAmount(exchangeToken, amount);\n', '        IERC20(exchangeToken).safeTransferFrom(msg.sender, address(this), token_amount);\n', '        IPOWToken(hashRateToken).mint(to, amount);\n', '\n', '        emit Exchanged(msg.sender, exchangeToken, amount, token_amount);\n', '    }\n', '\n', '    function ownerMint(uint256 amount, address to) external onlyOwner {\n', '        IPOWToken(hashRateToken).mint(to, amount);\n', '    }\n', '\n', '    function claim(address _token, uint256 _amount) external {\n', '        require(isWhiteListed[msg.sender], "sender is not in whitelist");\n', '        if (_token == address(0)) {\n', '            safeTransferETH(msg.sender, _amount);\n', '        } else {\n', '            IERC20(_token).safeTransfer(msg.sender, _amount);\n', '        }\n', '    }\n', '\n', '    function safeTransferETH(address to, uint amount) internal {\n', '        address(uint160(to)).transfer(amount);\n', '    }\n', '\n', '    event Exchanged(address indexed user, address indexed token, uint256 amount, uint256 token_amount);\n', '    event ChangedWhiteList(address indexed _user, bool _old, bool _new);\n', '}']