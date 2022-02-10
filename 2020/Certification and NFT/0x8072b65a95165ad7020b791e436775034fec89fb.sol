['// SPDX-License-Identifier: MIT\n', '\n', '/*\n', ' \n', '\n', '_________  ________ ________________________   ____________  \n', '\\_   ___ \\ \\_____  \\\\______   \\______   \\   \\ /   /\\_____  \\ \n', '/    \\  \\/  /   |   \\|       _/|    |  _/\\   Y   /  /  ____/ \n', '\\     \\____/    |    \\    |   \\|    |   \\ \\     /  /       \\ \n', ' \\______  /\\_______  /____|_  /|______  /  \\___/   \\_______ \\\n', '\n', '      \n', '\n', 'forked from Orb + Core\n', '\n', 'LP tokens are staked forever!\n', '\n', 'Website: corb.finance\n', '\n', '*/\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '\n', '    function mint(address account, uint256 amount) external;\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'interface Uniswap{\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);\n', '    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function WETH() external pure returns (address);\n', '}\n', '\n', 'interface Pool{\n', '    function owner() external view returns (address);\n', '}\n', '\n', 'contract Poolable{\n', '    \n', '    address payable internal constant _POOLADDRESS = 0x78c883EB7A1C2b11129D8113A5e40d815e1Cb33d;\n', ' \n', '    function primary() private view returns (address) {\n', '        return Pool(_POOLADDRESS).owner();\n', '    }\n', '    \n', '    modifier onlyPrimary() {\n', '        require(msg.sender == primary(), "Caller is not primary");\n', '        _;\n', '    }\n', '}\n', '\n', 'contract Staker is Poolable{\n', '    \n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '\n', '    uint constant internal DECIMAL = 10**18;\n', '    uint constant public INF = 33136721748;\n', '\n', '    uint private _rewardValue = 10**21;\n', '    uint private _stakerRewardValue = 10**20;    \n', '\n', '    \n', '    mapping (address => uint256) private internalTime;\n', '    mapping (address => uint256) private LPTokenBalance;\n', '    mapping (address => uint256) private rewards;\n', '\n', '\n', '    mapping (address => uint256) private stakerInternalTime;\n', '    mapping (address => uint256) private stakerTokenBalance;\n', '    mapping (address => uint256) private stakerRewards;    \n', '\n', '    address public orbAddress;\n', '    \n', '    address constant public UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '    address constant public FACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '    address          public WETHAddress       = Uniswap(UNIROUTER).WETH();\n', '    \n', '    bool private _unchangeable = false;\n', '    bool private _tokenAddressGiven = false;\n', '    bool public priceCapped = true;\n', '    \n', '    uint public creationTime = now;\n', '    \n', '    receive() external payable {\n', '        \n', '       if(msg.sender != UNIROUTER){\n', '           stake();\n', '       }\n', '    }\n', '    \n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        (bool success, ) = recipient.call{ value: amount }(""); \n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '    \n', '    //If true, no changes can be made\n', '    function unchangeable() public view returns (bool){\n', '        return _unchangeable;\n', '    }\n', '    \n', '    function rewardValue() public view returns (uint){\n', '        return _rewardValue;\n', '    }\n', '    \n', '    //THE ONLY ADMIN FUNCTIONS vvvv\n', '    //After this is called, no changes can be made\n', '    function makeUnchangeable() public onlyPrimary{\n', '        _unchangeable = true;\n', '    }\n', '    \n', '    //Can only be called once to set token address\n', '    function setTokenAddress(address input) public onlyPrimary{\n', '        require(!_tokenAddressGiven, "Function was already called");\n', '        _tokenAddressGiven = true;\n', '        orbAddress = input;\n', '    }\n', '    \n', "    //Set reward value that has high APY, can't be called if makeUnchangeable() was called\n", '    function updateRewardValue(uint input) public onlyPrimary {\n', '        require(!unchangeable(), "makeUnchangeable() function was already called");\n', '        _rewardValue = input;\n', '    }\n', "    //Cap token price at 1 eth, can't be called if makeUnchangeable() was called\n", '    function capPrice(bool input) public onlyPrimary {\n', '        require(!unchangeable(), "makeUnchangeable() function was already called");\n', '        priceCapped = input;\n', '    }\n', '    //THE ONLY ADMIN FUNCTIONS ^^^^\n', '    \n', '    function sqrt(uint y) public pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '  \n', '    function stake() public payable{\n', '        require(creationTime + 2 hours <= now, "It has not been 2 hours since contract creation yet");\n', '\n', '        address staker = msg.sender;\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);\n', '        \n', '        if(price() >= (1.05 * 10**18) && priceCapped){\n', '           \n', '            uint t = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap\n', '            uint a = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '            uint x = (sqrt(9*t*t + 3988000*a*t) - 1997*t)/1994;\n', '            \n', '            IERC20(orbAddress).mint(address(this), x);\n', '            \n', '            address[] memory path = new address[](2);\n', '            path[0] = orbAddress;\n', '            path[1] = WETHAddress;\n', '            IERC20(orbAddress).approve(UNIROUTER, x);\n', '            Uniswap(UNIROUTER).swapExactTokensForETH(x, 1, path, _POOLADDRESS, INF);\n', '        }\n', '        \n', '        sendValue(_POOLADDRESS, address(this).balance/2);\n', '        \n', '        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap\n', '      \n', '        uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);\n', '        IERC20(orbAddress).mint(address(this), toMint);\n', '        \n', '        uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));\n', '        \n', '        uint amountTokenDesired = IERC20(orbAddress).balanceOf(address(this));\n', '        IERC20(orbAddress).approve(UNIROUTER, amountTokenDesired ); //allow pool to get tokens\n', '        Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(orbAddress, amountTokenDesired, 1, 1, address(this), INF);\n', '        \n', '        uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));\n', '        uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);\n', '        \n', '        rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));\n', '        internalTime[staker] = now;\n', '    \n', '        LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);\n', '    }\n', '    \n', '    function withdrawRewardTokens(uint amount) public {\n', '        \n', '        rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));\n', '        internalTime[msg.sender] = now;\n', '        \n', '        uint removeAmount = ethtimeCalc(amount);\n', '        rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);\n', '\n', '        // TETHERED\n', '        uint256 withdrawable = tetheredReward(amount);        \n', '       \n', '        IERC20(orbAddress).mint(msg.sender, withdrawable);\n', '    }\n', '    \n', '    function viewRecentRewardTokenAmount(address who) internal view returns (uint){\n', '        return (viewLPTokenAmount(who).mul( now.sub(internalTime[who]) ));\n', '    }\n', '    \n', '    function viewRewardTokenAmount(address who) public view returns (uint){\n', '        return earnCalc( rewards[who].add(viewRecentRewardTokenAmount(who)) );\n', '    }\n', '    \n', '    function viewLPTokenAmount(address who) public view returns (uint){\n', '        return LPTokenBalance[who];\n', '    }\n', '    \n', '    function viewPooledEthAmount(address who) public view returns (uint){\n', '      \n', '        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);\n', '        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        \n', '        return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());\n', '    }\n', '    \n', '    function viewPooledTokenAmount(address who) public view returns (uint){\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);\n', '        uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap\n', '        \n', '        return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());\n', '    }\n', '    \n', '    function price() public view returns (uint){\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);\n', '        \n', '        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap\n', '        \n', '        return (DECIMAL.mul(ethAmount)).div(tokenAmount);\n', '    }\n', '    \n', '    function ethEarnCalc(uint eth, uint time) public view returns(uint){\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);\n', '        uint totalEth = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        uint totalLP = IERC20(poolAddress).totalSupply();\n', '        \n', '        uint LP = ((eth/2)*totalLP)/totalEth;\n', '        \n', '        return earnCalc(LP * time);\n', '    }\n', '\n', '    function earnCalc(uint LPTime) public view returns(uint){\n', '        return ( rewardValue().mul(LPTime)  ) / ( 31557600 * DECIMAL );\n', '    }\n', '    \n', '    function ethtimeCalc(uint orb) internal view returns(uint){\n', '        return ( orb.mul(31557600 * DECIMAL) ).div( rewardValue() );\n', '    }\n', '\n', '\n', '    //Attribute LPV1 rewards, only during the first hour.\n', '    function setLPrewards(address lp, uint reward) public onlyPrimary{\n', '        require(creationTime + 1 hours >= now, "Too late");\n', '        rewards[lp] = reward;\n', '    } \n', '\n', '    // Get amount of tethered rewards\n', '    function tetheredReward(uint256 _amount) public view returns (uint256) {\n', '        if (now >= creationTime + 48 hours) {\n', '            return _amount;\n', '        } else {\n', '            uint256 progress = now - creationTime;\n', '            uint256 total = 48 hours;\n', '            uint256 ratio = progress.mul(1e6).div(total);\n', '            return _amount.mul(ratio).div(1e6);\n', '        }\n', '    }       \n', '\n', '    // Corb staking\n', '    function deposit(uint256 _amount) public {\n', '        require(creationTime + 2 hours <= now, "It has not been 2 hours since contract creation yet");\n', '\n', '        address staker = msg.sender;\n', '\n', '        IERC20(orbAddress).safeTransferFrom(staker, address(this), _amount);\n', '\n', '        stakerRewards[staker] = stakerRewards[staker].add(viewRecentStakerRewardTokenAmount(staker));\n', '        stakerInternalTime[staker] = now;\n', '    \n', '        stakerTokenBalance[staker] = stakerTokenBalance[staker].add(_amount);\n', '    }\n', '\n', '    function withdraw(uint256 _amount) public {\n', '\n', '        address staker = msg.sender;\n', '\n', '        stakerRewards[staker] = stakerRewards[staker].add(viewRecentStakerRewardTokenAmount(staker));\n', '        stakerInternalTime[staker] = now;\n', '\n', '        stakerTokenBalance[staker] = stakerTokenBalance[staker].sub(_amount);\n', '        IERC20(orbAddress).safeTransfer(staker, _amount);\n', '\n', '    }\n', '    \n', '    function withdrawStakerRewardTokens(uint amount) public {   \n', '\n', '        address staker = msg.sender;\n', '\n', '        stakerRewards[staker] = stakerRewards[staker].add(viewRecentStakerRewardTokenAmount(staker));\n', '        stakerInternalTime[staker] = now;    \n', '        \n', '        uint removeAmount = stakerEthtimeCalc(amount);\n', '        stakerRewards[staker] = stakerRewards[staker].sub(removeAmount);\n', '    \n', '        // TETHERED\n', '        uint256 withdrawable = tetheredReward(amount);\n', '\n', '        IERC20(orbAddress).mint(staker, withdrawable);\n', '    }\n', '\n', '\n', '    function stakerRewardValue() public view returns (uint){\n', '        return _stakerRewardValue;\n', '    }  \n', '\n', '    function viewRecentStakerRewardTokenAmount(address who) internal view returns (uint){\n', '        return (viewStakerTokenAmount(who).mul( now.sub(stakerInternalTime[who]) ));\n', '    }\n', '\n', '    function viewStakerTokenAmount(address who) public view returns (uint){\n', '        return stakerTokenBalance[who];\n', '    }\n', '\n', '    function viewStakerRewardTokenAmount(address who) public view returns (uint){\n', '        return stakerEarnCalc( stakerRewards[who].add(viewRecentStakerRewardTokenAmount(who)) );\n', '    }   \n', '\n', '    function stakerEarnCalc(uint LPTime) public view returns(uint){\n', '        return ( stakerRewardValue().mul(LPTime)  ) / ( 31557600 * DECIMAL );\n', '    }\n', '\n', '    function stakerEthtimeCalc(uint orb) internal view returns(uint){\n', '        return ( orb.mul(31557600 * DECIMAL) ).div( stakerRewardValue() );\n', '    }\n', '\n', '}']