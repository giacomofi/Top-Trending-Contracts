['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-09\n', '*/\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev Give an account access to this role.\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(!has(role, account), "Roles: account already has role");\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev Remove an account's access to this role.\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(has(role, account), "Roles: account does not have role");\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Check if an account has this role.\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0), "Roles: account is the zero address");\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', 'contract PauserRole is Context {\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '\n', '    constructor () internal {\n', '        _addPauser(_msgSender());\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '\n', '    function renouncePauser() public {\n', '        _removePauser(_msgSender());\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {\n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'contract Pausable is Context, PauserRole {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by a pauser (`account`).\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by a pauser (`account`).\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state. Assigns the Pauser role\n', '     * to the deployer.\n', '     */\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Called by a pauser to pause, triggers stopped state.\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Called by a pauser to unpause, returns to normal state.\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier\n', ' * available, which can be applied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' *\n', ' * TIP: If you would like to learn more about reentrancy and alternative ways\n', ' * to protect against it, check out our blog post\n', ' * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].\n', ' *\n', ' * _Since v2.5.0:_ this module is now much more gas efficient, given net gas\n', ' * metering changes introduced in the Istanbul hardfork.\n', ' */\n', 'contract ReentrancyGuard {\n', '    bool private _notEntered;\n', '\n', '    constructor () internal {\n', '        // Storing an initial non-zero value makes deployment a bit more\n', '        // expensive, but in exchange the refund on every call to nonReentrant\n', '        // will be lower in amount. Since refunds are capped to a percetange of\n', "        // the total transaction's gas, it is best to keep them low in cases\n", '        // like this one, to increase the likelihood of the full refund coming\n', '        // into effect.\n', '        _notEntered = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(_notEntered, "ReentrancyGuard: reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        _notEntered = false;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        _notEntered = true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface IERC1155 {\n', '\tfunction lcpMint(\n', '\t\tuint256 id,\n', '\t\taddress to,\n', '\t\tuint256 amount,\n', '\t\tbytes calldata data\n', '\t) external;\n', '}\n', '\n', 'contract LORTokenWrapper {\n', '\tusing SafeMath for uint256;\n', '\tusing SafeERC20 for IERC20;\n', '\n', '\tIERC20 public lorToken;\n', '\n', '\tuint256 private _totalSupply;\n', '\t// Objects balances [id][address] => balance\n', '\tmapping(uint256 => mapping(address => uint256)) internal _balances;\n', '\tmapping(uint256 => uint256) private _totalDeposits;\n', '\n', '\tfunction totalSupply() public view returns (uint256) {\n', '\t\treturn _totalSupply;\n', '\t}\n', '\n', '\tfunction totalDeposits(uint256 id) public view returns (uint256) {\n', '\t\treturn _totalDeposits[id];\n', '\t}\n', '\n', '\tfunction balanceOf(address account, uint256 id) public view returns (uint256) {\n', '\t\treturn _balances[id][account];\n', '\t}\n', '\n', '\tfunction deposit(uint256 id, uint256 amount) public {\n', '\t\t_totalSupply = _totalSupply.add(amount);\n', '\t\t_totalDeposits[id] = _totalDeposits[id].add(amount);\n', '\t\t_balances[id][msg.sender] = _balances[id][msg.sender].add(amount);\n', '\t\tlorToken.transferFrom(msg.sender, address(this), amount);\n', '\t}\n', '\n', '\tfunction withdraw(uint256 id, uint256 amount) public {\n', '\t\t_totalSupply = _totalSupply.sub(amount);\n', '\t\t_totalDeposits[id] = _totalDeposits[id].sub(amount);\n', '\t\t_balances[id][msg.sender] = _balances[id][msg.sender].sub(amount);\n', '\t\tlorToken.transfer(msg.sender, amount);\n', '\t}\n', '\n', '\tfunction claim(uint256 id, address account) internal {\n', '\t\tuint256 amount = balanceOf(account, id);\n', '\t\t_totalSupply = _totalSupply.sub(amount);\n', '\t\t_totalDeposits[id] = _totalDeposits[id].sub(amount);\n', '\t\t_balances[id][account] = _balances[id][account].sub(amount);\n', '\t}\n', '}\n', '\n', 'contract LCPSignaling is LORTokenWrapper, ReentrancyGuard, Pausable, Ownable {\n', '\taddress public lotAddress;\n', '\tuint256 public lcpEndEpoch;\n', '\tbool private allowWithdraw;\n', '\n', '\tmapping(address => bool) public protectedTokens;\n', '\tmapping(uint256 => bool) private _generated;\n', '\tmapping(uint256 => bool) private _winner;\n', '\n', '\tevent Deposited(address indexed user, uint256 id, uint256 amount);\n', '\tevent Withdrawn(address indexed user, uint256 id, uint256 amount);\n', '\tevent Claimed(address indexed user, uint256 id, uint256 amount);\n', '\tevent Generated(address indexed user, uint256 id);\n', '\n', '\tconstructor(address _lotAddress, address _lorAddress) public {\n', '\t\tlotAddress = _lotAddress;\n', '\t\tlorToken = IERC20(_lorAddress);\n', '\t\tprotectedTokens[_lorAddress] = true;\n', '\n', '\t\tlorToken.safeApprove(_lotAddress, (2**256 - 1));\n', '\t}\n', '\n', '\tmodifier onlyLOT() {\n', '\t\trequire(msg.sender == lotAddress, "only LOT allowed");\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction resetLcp(uint256 endEpoch) public onlyOwner {\n', '\t\tlcpEndEpoch = endEpoch;\n', '\t\tallowWithdraw = false;\n', '\t}\n', '\n', '\tfunction addWinners(uint256[] memory ids) public onlyOwner {\n', '\t\tfor (uint256 i = 0; i < ids.length; i++) _winner[ids[i]] = true;\n', '\t\tallowWithdraw = true;\n', '\t}\n', '\n', '\tfunction deposit(uint256 id, uint256 amount) public nonReentrant whenNotPaused() {\n', '\t\trequire(block.timestamp <= lcpEndEpoch, "LCP is over. Check den.social for the lastest.");\n', '\t\trequire(amount % 1 ether == 0, "Deposit only increments of 1");\n', '\t\trequire(!_generated[id] || !_winner[id], "Lair previously won; no new deposits");\n', '\t\tsuper.deposit(id, amount);\n', '\t\temit Deposited(msg.sender, id, amount);\n', '\t}\n', '\n', '\tfunction withdraw(uint256 id, uint256 amount) public nonReentrant {\n', '\t\trequire(amount > 0, "Cannot withdraw 0");\n', '\t\trequire(allowWithdraw || block.timestamp <= lcpEndEpoch, "Winners being tabulated. Withdraws open soon.");\n', '\t\trequire(!_winner[id] && !_generated[id], "Lair won LCP but not generated; claim to open soon");\n', '\t\trequire(!_generated[id], "LOT generated; did you intend to claim?");\n', '\t\trequire(amount % 1 ether == 0, "Withdraw only increments of 1");\n', '\n', '\t\tsuper.withdraw(id, amount);\n', '\t\temit Withdrawn(msg.sender, id, amount);\n', '\t}\n', '\n', '\tfunction claim(uint256 id) public nonReentrant {\n', '\t\trequire(_generated[id], "LOT not generated; did you intend to withdraw?");\n', '\t\trequire(super.balanceOf(msg.sender, id) > 0, "Nothing to claim");\n', '\n', '\t\tuint256 amount = super.balanceOf(msg.sender, id);\n', '\t\tsuper.claim(id, msg.sender);\n', '\t\tIERC1155(lotAddress).lcpMint(id, msg.sender, _toEther(amount), "");\n', '\t\temit Claimed(msg.sender, id, _toEther(amount));\n', '\t}\n', '\n', '\tfunction claimable(address account, uint256 id) public view returns (uint256) {\n', '\t\tif (!_generated[id]) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\treturn _toEther(super.balanceOf(account, id));\n', '\t}\n', '\n', '\tfunction generate(uint256 id) public onlyLOT returns (uint256) {\n', '\t\t_generated[id] = true;\n', '\t\temit Generated(msg.sender, id);\n', '\t\treturn totalDeposits(id);\n', '\t}\n', '\n', '\tfunction sweep(address token) external onlyOwner {\n', '\t\trequire(!protectedTokens[token], "token is protected");\n', '\t\tIERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));\n', '\t}\n', '\n', '\t// Internal functions\n', '\tfunction _toEther(uint256 _amount) internal pure returns (uint256) {\n', '\t\treturn _amount / (1 ether);\n', '\t}\n', '}']