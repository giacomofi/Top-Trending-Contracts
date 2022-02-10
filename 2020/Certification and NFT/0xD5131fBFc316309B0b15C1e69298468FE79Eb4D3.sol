['// File: contracts/SafeMath.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '// Note: This file has been modified to include the sqrt function for quadratic voting\n', '/**\n', '* @dev Standard math utilities missing in the Solidity language.\n', '*/\n', 'library Math {\n', '    /**\n', '     * @dev Returns the largest of two numbers.\n', '     */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '\n', '    /**\n', '    * Imported from: https://github.com/alianse777/solidity-standard-library/blob/master/Math.sol\n', '    * @dev Compute square root of x\n', '    * @return sqrt(x)\n', '    */\n', '   function sqrt(uint256 x) internal pure returns (uint256) {\n', '       uint256 n = x / 2;\n', '       uint256 lstX = 0;\n', '       while (n != lstX){\n', '           lstX = n;\n', '           n = (n + x/n) / 2;\n', '       }\n', '       return uint256(n);\n', '   }\n', '}\n', '\n', '/**\n', "* @dev Wrappers over Solidity's arithmetic operations with added overflow\n", '* checks.\n', '*\n', '* Arithmetic operations in Solidity wrap on overflow. This can easily result\n', '* in bugs, because programmers usually assume that an overflow raises an\n', '* error, which is the standard behavior in high level programming languages.\n', '* `SafeMath` restores this intuition by reverting the transaction when an\n', '* operation overflows.\n', '*\n', '* Using this library instead of the unchecked operations eliminates an entire\n', "* class of bugs, so it's recommended to use it always.\n", '*/\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/zeppelin/Ownable.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '/*\n', '* @dev Provides information about the current execution context, including the\n', '* sender of the transaction and its data. While these are generally available\n', '* via msg.sender and msg.data, they should not be accessed in such a direct\n', '* manner, since when dealing with GSN meta-transactions the account sending and\n', '* paying for execution may not be the actual sender (as far as an application\n', '* is concerned).\n', '*\n', '* This contract is only required for intermediate, library-like contracts.\n', '*/\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', '* @dev Contract module which provides a basic access control mechanism, where\n', '* there is an account (an owner) that can be granted exclusive access to\n', '* specific functions.\n', '*\n', '* This module is used through inheritance. It will make available the modifier\n', '* `onlyOwner`, which can be applied to your functions to restrict their use to\n', '* the owner.\n', '*/\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/zeppelin/Address.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '/**\n', '* @dev Collection of functions related to the address type\n', '*/\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * IMPORTANT: It is unsafe to assume that an address for which this\n', '     * function returns false is an externally-owned account (EOA) and not a\n', '     * contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: contracts/IERC20.sol\n', '\n', '//SPDX-License-Identifier: GPL-3.0-only\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '/**\n', '* @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', '* the optional functions; to access them see {ERC20Detailed}.\n', '*/\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/zeppelin/SafeERC20.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', '\n', '/**\n', '* @title SafeERC20\n', '* @dev Wrappers around ERC20 operations that throw on failure (when the token\n', '* contract returns false). Tokens that return no value (and instead revert or\n', '* throw on failure) are also supported, non-reverting calls are assumed to be\n', '* successful.\n', '* To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', '* which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', '*/\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/IERC20Burnable.sol\n', '\n', '//SPDX-License-Identifier: GPL-3.0-only\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'interface IERC20Burnable {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function burn(uint256 amount) external;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', 'interface IGovernance {\n', '    function getStablecoin() external view returns (address);\n', '}\n', '\n', '\n', '// File: contracts/ISwapRouter.sol\n', '\n', '//SPDX-License-Identifier: GPL-3.0-only\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'interface SwapRouter {\n', '    function WETH() external pure returns (address);\n', '    function swapExactTokensForTokens(\n', '      uint amountIn,\n', '      uint amountOutMin,\n', '      address[] calldata path,\n', '      address to,\n', '      uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '}\n', '\n', '// File: contracts/LPTokenWrapper.sol\n', '\n', '//SPDX-License-Identifier: GPL-3.0-only\n', '\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', '\n', '\n', '\n', 'contract LPTokenWrapper {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IERC20 public stakeToken;\n', '\n', '    uint256 private _totalSupply;\n', '    mapping(address => uint256) private _balances;\n', '\n', '    constructor(IERC20 _stakeToken) public {\n', '        stakeToken = _stakeToken;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function stake(uint256 amount) public {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(amount);\n', '        // safeTransferFrom shifted to overriden method\n', '    }\n', '\n', '    function withdraw(uint256 amount) public {\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        // safeTransferFrom shifted to overriden method\n', '    }\n', '}\n', '\n', '// File: contracts/BoostRewardsV2.sol\n', '\n', '//SPDX-License-Identifier: MIT\n', '/*\n', '* MIT License\n', '* ===========\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract BoostRewardsV2YFU is LPTokenWrapper, Ownable {\n', '    IERC20 public boostToken;\n', '    address public governance;\n', '    address public governanceSetter;\n', '    address public devEscrow = 0xe8Fa1bA4dC7744275F4C061e3FE7923DbaD73eCe;\n', '    SwapRouter public swapRouter;\n', '    address public stablecoin;\n', '    address public rewardToken = 0xa279dab6ec190eE4Efce7Da72896EB58AD533262;\n', '    uint256 public tokenCapAmount;\n', '    uint256 public starttime;\n', '    uint256 public duration;\n', '    uint256 public periodFinish = 0;\n', '    uint256 public rewardRate = 0;\n', '    uint256 public lastUpdateTime;\n', '    uint256 public rewardPerTokenStored;\n', '    mapping(address => uint256) public userRewardPerTokenPaid;\n', '    mapping(address => uint256) public rewards;\n', '\n', '    // booster variables\n', '    // variables to keep track of totalSupply and balances (after accounting for multiplier)\n', '    uint256 public boostedTotalSupply;\n', '    uint256 public lastBoostPurchase; // timestamp of lastBoostPurchase\n', '    mapping(address => uint256) public boostedBalances;\n', '    mapping(address => uint256) public numBoostersBought; // each booster = 5% increase in stake amt\n', '    mapping(address => uint256) public nextBoostPurchaseTime; // timestamp for which user is eligible to purchase another booster\n', '    uint256 public globalBoosterPrice = 1e18;\n', '    uint256 public boostThreshold = 10;\n', '    uint256 public boostScaleFactor = 20;\n', '    uint256 public scaleFactor = 320;\n', '\n', '    event RewardAdded(uint256 reward);\n', '    event RewardPaid(address indexed user, uint256 reward);\n', '\n', '    modifier checkStart() {\n', '        require(block.timestamp >= starttime,"not start");\n', '        _;\n', '    }\n', '\n', '    modifier updateReward(address account) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdateTime = lastTimeRewardApplicable();\n', '        if (account != address(0)) {\n', '            rewards[account] = earned(account);\n', '            userRewardPerTokenPaid[account] = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor(\n', '        uint256 _tokenCapAmount,\n', '        IERC20 _stakeToken,\n', '        IERC20 _boostToken,\n', '        address _governanceSetter,\n', '        SwapRouter _swapRouter,\n', '        uint256 _starttime,\n', '        uint256 _duration\n', '    ) public LPTokenWrapper(_stakeToken) {\n', '        tokenCapAmount = _tokenCapAmount;\n', '        boostToken = _boostToken;\n', '        governanceSetter = _governanceSetter;\n', '        swapRouter = _swapRouter;\n', '        starttime = _starttime;\n', '        lastBoostPurchase = _starttime;\n', '        duration = _duration;\n', '        boostToken.safeApprove(address(_swapRouter), uint256(-1));\n', '    }\n', '\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        return Math.min(block.timestamp, periodFinish);\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (boostedTotalSupply == 0) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '            rewardPerTokenStored.add(\n', '                lastTimeRewardApplicable()\n', '                    .sub(lastUpdateTime)\n', '                    .mul(rewardRate)\n', '                    .mul(1e18)\n', '                    .div(boostedTotalSupply)\n', '            );\n', '    }\n', '\n', '    function earned(address account) public view returns (uint256) {\n', '        return\n', '            boostedBalances[account]\n', '                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))\n', '                .div(1e18)\n', '                .add(rewards[account]);\n', '    }\n', '\n', '    function getBoosterPrice(address user)\n', '        public view returns (uint256 boosterPrice, uint256 newBoostBalance)\n', '    {\n', '        if (boostedTotalSupply == 0) return (0,0);\n', '\n', '        // 5% increase for each previously user-purchased booster\n', '        uint256 boostersBought = numBoostersBought[user];\n', '        boosterPrice = globalBoosterPrice.mul(boostersBought.mul(5).add(100)).div(100);\n', '\n', '        // increment boostersBought by 1\n', '        boostersBought = boostersBought.add(1);\n', '\n', '        // if no. of boosters exceed threshold, increase booster price by boostScaleFactor;\n', '        if (boostersBought >= boostThreshold) {\n', '            boosterPrice = boosterPrice\n', '                .mul((boostersBought.sub(boostThreshold)).mul(boostScaleFactor).add(100))\n', '                .div(100);\n', '        }\n', '\n', '        // 2.5% decrease for every 2 hour interval since last global boost purchase\n', '        boosterPrice = pow(boosterPrice, 975, 1000, (block.timestamp.sub(lastBoostPurchase)).div(2 hours));\n', '\n', '        // adjust price based on expected increase in boost supply\n', '        // boostersBought has been incremented by 1 already\n', '        newBoostBalance = balanceOf(user)\n', '            .mul(boostersBought.mul(5).add(100))\n', '            .div(100);\n', '        uint256 boostBalanceIncrease = newBoostBalance.sub(boostedBalances[user]);\n', '        boosterPrice = boosterPrice\n', '            .mul(boostBalanceIncrease)\n', '            .mul(scaleFactor)\n', '            .div(boostedTotalSupply);\n', '    }\n', '\n', "    // stake visibility is public as overriding LPTokenWrapper's stake() function\n", '    function stake(uint256 amount) public updateReward(msg.sender) checkStart {\n', '        require(amount > 0, "Cannot stake 0");\n', '        super.stake(amount);\n', '\n', '        // check user cap\n', '        // require(\n', '        //     balanceOf(msg.sender) <= tokenCapAmount || block.timestamp >= starttime.add(86400),\n', '        //     "token cap exceeded"\n', '        // );\n', '\n', '        // boosters do not affect new amounts\n', '        boostedBalances[msg.sender] = boostedBalances[msg.sender].add(amount);\n', '        boostedTotalSupply = boostedTotalSupply.add(amount);\n', '\n', '        _getReward(msg.sender);\n', '\n', '        // transfer token last, to follow CEI pattern\n', '        stakeToken.safeTransferFrom(msg.sender, address(this), amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {\n', '        require(amount > 0, "Cannot withdraw 0");\n', '        super.withdraw(amount);\n', '\n', '        // reset boosts :(\n', '        numBoostersBought[msg.sender] = 0;\n', '\n', '        // update boosted balance and supply\n', '        updateBoostBalanceAndSupply(msg.sender, 0);\n', '\n', '        // in case _getReward function fails, continue\n', '        (bool success, ) = address(this).call(\n', '            abi.encodeWithSignature(\n', '                "_getReward(address)",\n', '                msg.sender\n', '            )\n', '        );\n', '        // to remove compiler warning\n', '        success;\n', '\n', '        // transfer token last, to follow CEI pattern\n', '        stakeToken.safeTransfer(msg.sender, amount);\n', '    }\n', '\n', '    function getReward() public updateReward(msg.sender) checkStart {\n', '        _getReward(msg.sender);\n', '    }\n', '\n', '    function exit() external {\n', '        withdraw(balanceOf(msg.sender));\n', '        _getReward(msg.sender);\n', '    }\n', '\n', '    function setScaleFactorsAndThreshold(\n', '        uint256 _boostThreshold,\n', '        uint256 _boostScaleFactor,\n', '        uint256 _scaleFactor\n', '    ) external onlyOwner\n', '    {\n', '        boostThreshold = _boostThreshold;\n', '        boostScaleFactor = _boostScaleFactor;\n', '        scaleFactor = _scaleFactor;\n', '    }\n', '\n', '    function boost() external updateReward(msg.sender) checkStart {\n', '        require(\n', '            block.timestamp > nextBoostPurchaseTime[msg.sender],\n', '            "early boost purchase"\n', '        );\n', '\n', '        // save current booster price, since transfer is done last\n', '        // since getBoosterPrice() returns new boost balance, avoid re-calculation\n', '        (uint256 boosterAmount, uint256 newBoostBalance) = getBoosterPrice(msg.sender);\n', "        // user's balance and boostedSupply will be changed in this function\n", '        applyBoost(msg.sender, newBoostBalance);\n', '\n', '        _getReward(msg.sender);\n', '\n', '        boostToken.safeTransferFrom(msg.sender, address(this), boosterAmount);\n', '\n', '        //IERC20Burnable burnableBoostToken = IERC20Burnable(address(boostToken));\n', '\n', '        // Transfer 50% to UNI YFU treasury\n', '        // NOT Burnt\n', '        uint256 burnAmount = boosterAmount.div(2);\n', '        boostToken.safeTransfer(governance, burnAmount);\n', '        //burnableBoostToken.burn(burnAmount);\n', '        boosterAmount = boosterAmount.sub(burnAmount);\n', '\n', '        // swap to YFU and send to DevEscrow\n', '        address[] memory routeDetails = new address[](3);\n', '        routeDetails[0] = address(boostToken);\n', '        routeDetails[1] = swapRouter.WETH();\n', '        routeDetails[2] = address(rewardToken);\n', '        uint[] memory amounts = swapRouter.swapExactTokensForTokens(\n', '            boosterAmount,\n', '            0,\n', '            routeDetails,\n', '            devEscrow,\n', '            block.timestamp + 100\n', '        );\n', '\n', '        // transfer to treasury\n', '        // index 2 = final output amt\n', '        //treasury.deposit(stablecoin, amounts[2]);\n', '    }\n', '\n', '    function notifyRewardAmount(uint256 reward)\n', '        external\n', '        onlyOwner\n', '        updateReward(address(0))\n', '    {\n', '        rewardRate = reward.div(duration);\n', '        lastUpdateTime = starttime;\n', '        periodFinish = starttime.add(duration);\n', '        emit RewardAdded(reward);\n', '    }\n', '\n', '    function setGovernance(address _governance)\n', '        external\n', '    {\n', '        require(msg.sender == governanceSetter, "only setter");\n', '        governance = _governance;\n', '        stablecoin = IGovernance(governance).getStablecoin();\n', '        governanceSetter = address(0);\n', '    }\n', '\n', '    function updateBoostBalanceAndSupply(address user, uint256 newBoostBalance) internal {\n', '        // subtract existing balance from boostedSupply\n', '        boostedTotalSupply = boostedTotalSupply.sub(boostedBalances[user]);\n', '\n', '        // when applying boosts,\n', '        // newBoostBalance has already been calculated in getBoosterPrice()\n', '        if (newBoostBalance == 0) {\n', '            // each booster adds 5% to current stake amount\n', '            newBoostBalance = balanceOf(user).mul(numBoostersBought[user].mul(5).add(100)).div(100);\n', '        }\n', '\n', "        // update user's boosted balance\n", '        boostedBalances[user] = newBoostBalance;\n', '\n', '        // update boostedSupply\n', '        boostedTotalSupply = boostedTotalSupply.add(newBoostBalance);\n', '    }\n', '\n', '    function applyBoost(address user, uint256 newBoostBalance) internal {\n', '        // increase no. of boosters bought\n', '        numBoostersBought[user] = numBoostersBought[user].add(1);\n', '\n', '        updateBoostBalanceAndSupply(user, newBoostBalance);\n', '\n', '        // increase next purchase eligibility by an hour\n', '\n', '        // increase next boost wait period by 5%\n', '        nextBoostPurchaseTime[user] = pow(block.timestamp.add(3600), 105, 100, numBoostersBought[user]);\n', '\n', '        // increase global booster price by 1%\n', '        globalBoosterPrice = globalBoosterPrice.mul(101).div(100);\n', '\n', '        lastBoostPurchase = block.timestamp;\n', '    }\n', '\n', '    function _getReward(address user) internal {\n', '        uint256 reward = earned(user);\n', '        if (reward > 0) {\n', '            rewards[user] = 0;\n', '            IERC20(rewardToken).safeTransfer(user, reward);\n', '            emit RewardPaid(user, reward);\n', '        }\n', '    }\n', '\n', '   /// Imported from: https://forum.openzeppelin.com/t/does-safemath-library-need-a-safe-power-function/871/7\n', '   /// Modified so that it takes in 3 arguments for base\n', '   /// @return a * (b / c)^exponent\n', '   function pow(uint256 a, uint256 b, uint256 c, uint256 exponent) internal pure returns (uint256) {\n', '        if (exponent == 0) {\n', '            return a;\n', '        }\n', '        else if (exponent == 1) {\n', '            return a.mul(b).div(c);\n', '        }\n', '        else if (a == 0 && exponent != 0) {\n', '            return 0;\n', '        }\n', '        else {\n', '            uint256 z = a.mul(b).div(c);\n', '            for (uint256 i = 1; i < exponent; i++)\n', '                z = z.mul(b).div(c);\n', '            return z;\n', '        }\n', '    }\n', '}']