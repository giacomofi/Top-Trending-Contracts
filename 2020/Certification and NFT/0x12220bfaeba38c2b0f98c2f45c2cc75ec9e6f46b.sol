['/***\n', ' *    ██████╗ ███████╗ ██████╗  ██████╗ \n', ' *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗\n', ' *    ██║  ██║█████╗  ██║  ███╗██║   ██║\n', ' *    ██║  ██║██╔══╝  ██║   ██║██║   ██║\n', ' *    ██████╔╝███████╗╚██████╔╝╚██████╔╝\n', ' *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ \n', ' *    \n', ' * https://dego.finance\n', '                                  \n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2020 dego\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '// File: @openzeppelin/contracts/math/Math.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Standard math utilities missing in the Solidity language.\n', ' */\n', 'library Math {\n', '    /**\n', '     * @dev Returns the largest of two numbers.\n', '     */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/interface/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function mint(address account, uint amount) external;\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/interface/IPlayerBook.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'interface IPlayerBook {\n', '    function settleReward( address from,uint256 amount ) external returns (uint256);\n', '    function bindRefer( address from,string calldata  affCode )  external returns (bool);\n', '    function hasRefer(address from) external returns(bool);\n', '\n', '}\n', '\n', '// File: contracts/interface/IPool.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'interface IPool {\n', '    function totalSupply( ) external view returns (uint256);\n', '    function balanceOf( address player ) external view returns (uint256);\n', '    function updateStrategyPower( address player ) external;\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: contracts/library/SafeERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', "    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SELECTOR, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'SafeERC20: TRANSFER_FAILED');\n", '    }\n', '    // function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '    //     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    // }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/library/DegoMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'library DegoMath {\n', '  /**\n', '   * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer\n', '   * number.\n', '   *\n', '   * @param x unsigned 256-bit integer number\n', '   * @return unsigned 128-bit integer number\n', '   */\n', '    function sqrt(uint256 x) public pure returns (uint256 y)  {\n', '        uint256 z = (x + 1) / 2;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/library/Governance.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract Governance {\n', '\n', '    address public _governance;\n', '\n', '    constructor() public {\n', '        _governance = tx.origin;\n', '    }\n', '\n', '    event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyGovernance {\n', '        require(msg.sender == _governance, "not governance");\n', '        _;\n', '    }\n', '\n', '    function setGovernance(address governance)  public  onlyGovernance\n', '    {\n', '        require(governance != address(0), "new governance the zero address");\n', '        emit GovernanceTransferred(_governance, governance);\n', '        _governance = governance;\n', '    }\n', '\n', '\n', '}\n', '\n', '// File: contracts/interface/IPowerStrategy.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'interface IPowerStrategy {\n', '    function lpIn(address sender, uint256 amount) external;\n', '    function lpOut(address sender, uint256 amount) external;\n', '    \n', '    function getPower(address sender) view  external returns (uint256);\n', '}\n', '\n', '// File: contracts/library/LPTokenWrapper.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract LPTokenWrapper is IPool,Governance {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IERC20 public _lpToken = IERC20(0x9ea4AFd63cD4264FF237a297B55f63a86aF55607);\n', '\n', '    address public _playerBook = address(0xA96E5CFed88734E60BC6c74c45ec722f917fc615);\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    uint256 private _totalPower;\n', '    mapping(address => uint256) private _powerBalances;\n', '    \n', '    address public _powerStrategy = address(0x0);\n', '\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function setPowerStragegy(address strategy)  public  onlyGovernance{\n', '        _powerStrategy = strategy;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function balanceOfPower(address account) public view returns (uint256) {\n', '        return _powerBalances[account];\n', '    }\n', '\n', '    function totalPower() public view returns (uint256) {\n', '        return _totalPower;\n', '    }\n', '\n', '    function updateStrategyPower( address player ) public{\n', '\n', '        if( _powerStrategy != address(0x0)){ \n', '            _totalPower = _totalPower.sub(_powerBalances[player]);\n', '            _powerBalances[player] = IPowerStrategy(_powerStrategy).getPower(player);\n', '            _totalPower = _totalPower.add(_powerBalances[player]);\n', '        }\n', '    }\n', '\n', '    function stake(uint256 amount, string memory affCode) public {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '\n', '        if( _powerStrategy != address(0x0)){ \n', '            IPowerStrategy(_powerStrategy).lpIn(msg.sender, amount);\n', '            // _totalPower = _totalPower.sub(_powerBalances[msg.sender]);\n', '            // _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);\n', '            // _totalPower = _totalPower.add(_powerBalances[msg.sender]);\n', '        }else{\n', '            _totalPower = _totalSupply;\n', '            _powerBalances[msg.sender] = _balances[msg.sender];\n', '        }\n', '\n', '        _lpToken.safeTransferFrom(msg.sender, address(this), amount);\n', '\n', '        if (!IPlayerBook(_playerBook).hasRefer(msg.sender)) {\n', '            IPlayerBook(_playerBook).bindRefer(msg.sender, affCode);\n', '        }\n', '        \n', '    }\n', '\n', '    function withdraw(uint256 amount) public {\n', '        require(amount > 0, "amout > 0");\n', '\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        \n', '        if( _powerStrategy != address(0x0)){ \n', '            IPowerStrategy(_powerStrategy).lpOut(msg.sender, amount);\n', '            // _totalPower = _totalPower.sub(_powerBalances[msg.sender]);\n', '            // _powerBalances[msg.sender] = IPowerStrategy(_powerStrategy).getPower(msg.sender);\n', '            // _totalPower = _totalPower.add(_powerBalances[msg.sender]);\n', '\n', '        }else{\n', '            _totalPower = _totalSupply;\n', '            _powerBalances[msg.sender] = _balances[msg.sender];\n', '        }\n', '\n', '        _lpToken.safeTransfer( msg.sender, amount);\n', '    }\n', '\n', '    \n', '}\n', '\n', '// File: contracts/reward/UniswapReward.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract UniswapReward is LPTokenWrapper{\n', '    using SafeERC20 for IERC20;\n', '\n', '    IERC20 public _dego = IERC20(0xEE5C75c2f1e8892c84d6d32B730Eff5C4181Bd10);\n', '    address public _teamWallet = 0x3D0a845C5ef9741De999FC068f70E2048A489F2b;\n', '    address public _rewardPool = 0xEA6dEc98e137a87F78495a8386f7A137408f7722;\n', '\n', '    uint256 public constant DURATION = 7 days;\n', '\n', '    uint256 public _initReward = 262500 * 1e18;\n', '    uint256 public _startTime =  now + 365 days;\n', '    uint256 public _periodFinish = 0;\n', '    uint256 public _rewardRate = 0;\n', '    uint256 public _lastUpdateTime;\n', '    uint256 public _rewardPerTokenStored;\n', '\n', '    uint256 public _teamRewardRate = 500;\n', '    uint256 public _poolRewardRate = 1000;\n', '    uint256 public _baseRate = 10000;\n', '    uint256 public _punishTime = 3 days;\n', '\n', '    mapping(address => uint256) public _userRewardPerTokenPaid;\n', '    mapping(address => uint256) public _rewards;\n', '    mapping(address => uint256) public _lastStakedTime;\n', '\n', '    bool public _hasStart = false;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '\n', '\n', '    modifier updateReward(address account) {\n', '        _rewardPerTokenStored = rewardPerToken();\n', '        _lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            _rewards[account] = earned(account);\n', '            _userRewardPerTokenPaid[account] = _rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    /* Fee collection for any other token */\n', '    function seize(IERC20 token, uint256 amount) external onlyGovernance{\n', '        require(token != _dego, "reward");\n', '        require(token != _lpToken, "stake");\n', '        token.safeTransfer(_governance, amount);\n', '    }\n', '\n', '    function setTeamRewardRate( uint256 teamRewardRate ) public onlyGovernance{\n', '        _teamRewardRate = teamRewardRate;\n', '    }\n', '\n', '    function setPoolRewardRate( uint256  poolRewardRate ) public onlyGovernance{\n', '        _poolRewardRate = poolRewardRate;\n', '    }\n', '\n', '    function setWithDrawPunishTime( uint256  punishTime ) public onlyGovernance{\n', '        _punishTime = punishTime;\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, _periodFinish);\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (totalPower() == 0) {\n', '            return _rewardPerTokenStored;\n', '        }\n', '        return\n', '            _rewardPerTokenStored.add(\n', '                lastTimeRewardApplicable()\n', '                    .sub(_lastUpdateTime)\n', '                    .mul(_rewardRate)\n', '                    .mul(1e18)\n', '                    .div(totalPower())\n', '            );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        return\n', '            balanceOfPower(account)\n', '                .mul(rewardPerToken().sub(_userRewardPerTokenPaid[account]))\n', '                .div(1e18)\n', '                .add(_rewards[account]);\n', '    }\n', '\n', "    // stake visibility is public as overriding LPTokenWrapper's stake() function\n", '    function stake(uint256 amount, string memory affCode)\n', '        public\n', '        updateReward(msg.sender)\n', '        checkHalve\n', '        checkStart\n', '    {\n', '        require(amount > 0, "Cannot stake 0");\n', '        super.stake(amount, affCode);\n', '\n', '        _lastStakedTime[msg.sender] = now;\n', '\n', '        emit Staked(msg.sender, amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount)\n', '        public\n', '        updateReward(msg.sender)\n', '        checkHalve\n', '        checkStart\n', '    {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        super.withdraw(amount);\n', '        emit Withdrawn(msg.sender, amount);\n', '    }\n', '\n', '    function exit() external {\n', '        withdraw(balanceOf(msg.sender));\n', '        getReward();\n', '    }\n', '\n', '    function getReward() public updateReward(msg.sender) checkHalve checkStart {\n', '        uint256 reward = earned(msg.sender);\n', '        if (reward > 0) {\n', '            _rewards[msg.sender] = 0;\n', '\n', '            uint256 fee = IPlayerBook(_playerBook).settleReward(msg.sender, reward);\n', '            if(fee > 0){\n', '                _dego.safeTransfer(_playerBook, fee);\n', '            }\n', '            \n', '            uint256 teamReward = reward.mul(_teamRewardRate).div(_baseRate);\n', '            if(teamReward>0){\n', '                _dego.safeTransfer(_teamWallet, teamReward);\n', '            }\n', '            uint256 leftReward = reward.sub(fee).sub(teamReward);\n', '            uint256 poolReward = 0;\n', '\n', '            //withdraw time check\n', '\n', '            if(now  < (_lastStakedTime[msg.sender] + _punishTime) ){\n', '                poolReward = leftReward.mul(_poolRewardRate).div(_baseRate);\n', '            }\n', '            if(poolReward>0){\n', '                _dego.safeTransfer(_rewardPool, poolReward);\n', '                leftReward = leftReward.sub(poolReward);\n', '            }\n', '\n', '            if(leftReward>0){\n', '                _dego.safeTransfer(msg.sender, leftReward );\n', '            }\n', '      \n', '            emit RewardPaid(msg.sender, leftReward);\n', '        }\n', '    }\n', '\n', '    modifier checkHalve() {\n', '        if (block.timestamp >= _periodFinish) {\n', '            _initReward = _initReward.mul(50).div(100);\n', '\n', '            _dego.mint(address(this), _initReward);\n', '\n', '            _rewardRate = _initReward.div(DURATION);\n', '            _periodFinish = block.timestamp.add(DURATION);\n', '            emit RewardAdded(_initReward);\n', '        }\n', '        _;\n', '    }\n', '    \n', '    modifier checkStart() {\n', '        require(block.timestamp > _startTime, "not start");\n', '        _;\n', '    }\n', '\n', '    // set fix time to start reward\n', '    function startReward(uint256 startTime)\n', '        external\n', '        onlyGovernance\n', '        updateReward(address(0))\n', '    {\n', '        require(_hasStart == false, "has started");\n', '        _hasStart = true;\n', '        \n', '        _startTime = startTime;\n', '\n', '        _rewardRate = _initReward.div(DURATION); \n', '        _dego.mint(address(this), _initReward);\n', '\n', '        _lastUpdateTime = _startTime;\n', '        _periodFinish = _startTime.add(DURATION);\n', '\n', '        emit RewardAdded(_initReward);\n', '    }\n', '\n', '    //\n', '\n', '    //for extra reward\n', '    function notifyRewardAmount(uint256 reward)\n', '        external\n', '        onlyGovernance\n', '        updateReward(address(0))\n', '    {\n', '        IERC20(_dego).safeTransferFrom(msg.sender, address(this), reward);\n', '        if (block.timestamp >= _periodFinish) {\n', '            _rewardRate = reward.div(DURATION);\n', '        } else {\n', '            uint256 remaining = _periodFinish.sub(block.timestamp);\n', '            uint256 leftover = remaining.mul(_rewardRate);\n', '            _rewardRate = reward.add(leftover).div(DURATION);\n', '        }\n', '        _lastUpdateTime = block.timestamp;\n', '        _periodFinish = block.timestamp.add(DURATION);\n', '        emit RewardAdded(reward);\n', '    }\n', '}']