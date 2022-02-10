['// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/IAUSC.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface IAUSC {\n', '  function rebase(uint256 epoch, uint256 supplyDelta, bool positive) external;\n', '  function mint(address to, uint256 amount) external;\n', '}\n', '\n', '// File: contracts/IPoolEscrow.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface IPoolEscrow {\n', '  function notifySecondaryTokens(uint256 number) external;\n', '}\n', '\n', '// File: contracts/BasicRebaser.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract BasicRebaser {\n', '\n', '  using SafeMath for uint256;\n', '  using SafeERC20 for IERC20;\n', '\n', '  event Updated(uint256 xau, uint256 ausc);\n', '  event NoUpdateXAU();\n', '  event NoUpdateAUSC();\n', '  event NoSecondaryMint();\n', '  event NoRebaseNeeded();\n', '\n', '  uint256 public constant BASE = 1e18;\n', '  uint256 public constant WINDOW_SIZE = 12;\n', '\n', '  address public ausc;\n', '  uint256[] public pricesXAU = new uint256[](12);\n', '  uint256[] public pricesAUSC = new uint256[](12);\n', '  uint256 public pendingXAUPrice = 0;\n', '  uint256 public pendingAUSCPrice = 0;\n', '  bool public noPending = true;\n', '  uint256 public averageXAU;\n', '  uint256 public averageAUSC;\n', '  uint256 public lastUpdate;\n', '  uint256 public frequency = 1 hours;\n', '  uint256 public counter = 0;\n', '  uint256 public epoch = 1;\n', '  address public secondaryPool;\n', '  address public governance;\n', '\n', '  uint256 public nextRebase = 0;\n', '  uint256 public constant REBASE_DELAY = 12 hours;\n', '\n', '  modifier onlyGov() {\n', '    require(msg.sender == governance, "only gov");\n', '    _;\n', '  }\n', '\n', '  constructor (address token, address _secondaryPool) public {\n', '    ausc = token;\n', '    secondaryPool = _secondaryPool;\n', '    governance = msg.sender;\n', '  }\n', '\n', '  function setNextRebase(uint256 next) external onlyGov {\n', '    require(nextRebase == 0, "Only one time activation");\n', '    nextRebase = next;\n', '  }\n', '\n', '  function setGovernance(address account) external onlyGov {\n', '    governance = account;\n', '  }\n', '\n', '  function setSecondaryPool(address pool) external onlyGov {\n', '    secondaryPool = pool;\n', '  }\n', '\n', '  function checkRebase() external {\n', '    // ausc ensures that we do not have smart contracts rebasing\n', '    require (msg.sender == address(ausc), "only through ausc");\n', '    rebase();\n', '    recordPrice();\n', '  }\n', '\n', '  function recordPrice() public {\n', '    if (msg.sender != tx.origin && msg.sender != address(ausc)) {\n', '      // smart contracts could manipulate data via flashloans,\n', '      // thus we forbid them from updating the price\n', '      return;\n', '    }\n', '\n', '    if (block.timestamp < lastUpdate + frequency) {\n', '      // addition is running on timestamps, this will never overflow\n', '      // we leave at least the specified period between two updates\n', '      return;\n', '    }\n', '\n', '    (bool successXAU, uint256 priceXAU) = getPriceXAU();\n', '    (bool successAUSC, uint256 priceAUSC) = getPriceAUSC();\n', '    if (!successAUSC) {\n', '      // price of AUSC was not returned properly\n', '      emit NoUpdateAUSC();\n', '      return;\n', '    }\n', '    if (!successXAU) {\n', '      // price of XAU was not returned properly\n', '      emit NoUpdateXAU();\n', '      return;\n', '    }\n', '    lastUpdate = block.timestamp;\n', '\n', '    if (noPending) {\n', '      // we start recording with 1 hour delay\n', '      pendingXAUPrice = priceXAU;\n', '      pendingAUSCPrice = priceAUSC;\n', '      noPending = false;\n', '    } else if (counter < WINDOW_SIZE) {\n', '      // still in the warming up phase\n', '      averageXAU = averageXAU.mul(counter).add(pendingXAUPrice).div(counter.add(1));\n', '      averageAUSC = averageAUSC.mul(counter).add(pendingAUSCPrice).div(counter.add(1));\n', '      pricesXAU[counter] = pendingXAUPrice;\n', '      pricesAUSC[counter] = pendingAUSCPrice;\n', '      pendingXAUPrice = priceXAU;\n', '      pendingAUSCPrice = priceAUSC;\n', '      counter++;\n', '    } else {\n', '      uint256 index = counter % WINDOW_SIZE;\n', '      averageXAU = averageXAU.mul(WINDOW_SIZE).sub(pricesXAU[index]).add(pendingXAUPrice).div(WINDOW_SIZE);\n', '      averageAUSC = averageAUSC.mul(WINDOW_SIZE).sub(pricesAUSC[index]).add(pendingAUSCPrice).div(WINDOW_SIZE);\n', '      pricesXAU[index] = pendingXAUPrice;\n', '      pricesAUSC[index] = pendingAUSCPrice;\n', '      pendingXAUPrice = priceXAU;\n', '      pendingAUSCPrice = priceAUSC;\n', '      counter++;\n', '    }\n', '    emit Updated(pendingXAUPrice, pendingAUSCPrice);\n', '  }\n', '\n', '  function rebase() public {\n', '    // We want to rebase only at 1pm UTC and 12 hours later\n', '    if (block.timestamp < nextRebase) {\n', '      return;\n', '    } else {\n', '      nextRebase = nextRebase + REBASE_DELAY;\n', '    }\n', '\n', '    // only rebase if there is a 5% difference between the price of XAU and AUSC\n', '    uint256 highThreshold = averageXAU.mul(105).div(100);\n', '    uint256 lowThreshold = averageXAU.mul(95).div(100);\n', '\n', '    if (averageAUSC > highThreshold) {\n', '      // AUSC is too expensive, this is a positive rebase increasing the supply\n', '      uint256 currentSupply = IERC20(ausc).totalSupply();\n', '      uint256 desiredSupply = currentSupply.mul(averageAUSC).div(averageXAU);\n', '      uint256 secondaryPoolBudget = desiredSupply.sub(currentSupply).mul(10).div(100);\n', '      desiredSupply = desiredSupply.sub(secondaryPoolBudget);\n', '\n', '      // Cannot underflow as desiredSupply > currentSupply, the result is positive\n', '      // delta = (desiredSupply / currentSupply) * 100 - 100\n', '      uint256 delta = desiredSupply.mul(BASE).div(currentSupply).sub(BASE);\n', '      IAUSC(ausc).rebase(epoch, delta, true);\n', '\n', '      if (secondaryPool != address(0)) {\n', '        // notify the pool escrow that tokens are available\n', '        IAUSC(ausc).mint(address(this), secondaryPoolBudget);\n', '        IERC20(ausc).safeApprove(secondaryPool, 0);\n', '        IERC20(ausc).safeApprove(secondaryPool, secondaryPoolBudget);\n', '        IPoolEscrow(secondaryPool).notifySecondaryTokens(secondaryPoolBudget);\n', '      } else {\n', '        emit NoSecondaryMint();\n', '      }\n', '      epoch++;\n', '    } else if (averageAUSC < lowThreshold) {\n', '      // AUSC is too cheap, this is a negative rebase decreasing the supply\n', '      uint256 currentSupply = IERC20(ausc).totalSupply();\n', '      uint256 desiredSupply = currentSupply.mul(averageAUSC).div(averageXAU);\n', '\n', '      // Cannot overflow as desiredSupply > currentSupply\n', '      // delta = 100 - (desiredSupply / currentSupply) * 100\n', '      uint256 delta = uint256(BASE).sub(desiredSupply.mul(BASE).div(currentSupply));\n', '      IAUSC(ausc).rebase(epoch, delta, false);\n', '      epoch++;\n', '    } else {\n', '      // else the price is within bounds\n', '      emit NoRebaseNeeded();\n', '    }\n', '  }\n', '\n', '  /**\n', '  * Calculates how a rebase would look if it was triggered now.\n', '  */\n', '  function calculateRealTimeRebase() public view returns (uint256, uint256) {\n', '    // only rebase if there is a 5% difference between the price of XAU and AUSC\n', '    uint256 highThreshold = averageXAU.mul(105).div(100);\n', '    uint256 lowThreshold = averageXAU.mul(95).div(100);\n', '\n', '    if (averageAUSC > highThreshold) {\n', '      // AUSC is too expensive, this is a positive rebase increasing the supply\n', '      uint256 currentSupply = IERC20(ausc).totalSupply();\n', '      uint256 desiredSupply = currentSupply.mul(averageAUSC).div(averageXAU);\n', '      uint256 secondaryPoolBudget = desiredSupply.sub(currentSupply).mul(10).div(100);\n', '      desiredSupply = desiredSupply.sub(secondaryPoolBudget);\n', '\n', '      // Cannot underflow as desiredSupply > currentSupply, the result is positive\n', '      // delta = (desiredSupply / currentSupply) * 100 - 100\n', '      uint256 delta = desiredSupply.mul(BASE).div(currentSupply).sub(BASE);\n', '      return (delta, secondaryPool == address(0) ? 0 : secondaryPoolBudget);\n', '    } else if (averageAUSC < lowThreshold) {\n', '      // AUSC is too cheap, this is a negative rebase decreasing the supply\n', '      uint256 currentSupply = IERC20(ausc).totalSupply();\n', '      uint256 desiredSupply = currentSupply.mul(averageAUSC).div(averageXAU);\n', '\n', '      // Cannot overflow as desiredSupply > currentSupply\n', '      // delta = 100 - (desiredSupply / currentSupply) * 100\n', '      uint256 delta = uint256(BASE).sub(desiredSupply.mul(BASE).div(currentSupply));\n', '      return (delta, 0);\n', '    } else {\n', '      return (0,0);\n', '    }\n', '  }\n', '\n', '  function getPriceXAU() public view returns (bool, uint256);\n', '  function getPriceAUSC() public view returns (bool, uint256);\n', '}\n', '\n', '// File: @chainlink/contracts/src/v0.5/interfaces/AggregatorV3Interface.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface AggregatorV3Interface {\n', '\n', '  function decimals() external view returns (uint8);\n', '  function description() external view returns (string memory);\n', '  function version() external view returns (uint256);\n', '\n', '  // getRoundData and latestRoundData should both raise "No data present"\n', '  // if they do not have data to report, instead of returning unset values\n', '  // which could be misinterpreted as actual reported values.\n', '  function getRoundData(uint80 _roundId)\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '  function latestRoundData()\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '\n', '}\n', '\n', '// File: contracts/ChainlinkOracle.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', 'contract ChainlinkOracle {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  address public constant oracle = 0x214eD9Da11D2fbe465a6fc601a91E62EbEc1a0D6;\n', '  uint256 public constant ozToMg = 311035000;\n', '  uint256 public constant ozToMgPrecision = 1e4;\n', '\n', '  constructor () public {\n', '  }\n', '\n', '  function getPriceXAU() public view returns (bool, uint256) {\n', '    // answer has 8 decimals, it is the price of 1 oz of gold in USD\n', '    // if the round is not completed, updated at is 0\n', '    (,int256 answer,,uint256 updatedAt,) = AggregatorV3Interface(oracle).latestRoundData();\n', '    // add 10 decimals at the end\n', '    return (updatedAt != 0, uint256(answer).mul(10).mul(ozToMgPrecision).div(ozToMg).mul(1e10));\n', '  }\n', '}\n', '\n', '// File: contracts/UniswapOracle.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', 'contract IUniswapRouterV2 {\n', '  function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts);\n', '}\n', '\n', 'contract UniswapOracle {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  address public constant oracle = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '  address public constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;\n', '  address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '  address public ausc;\n', '  address[] public path;\n', '\n', '  constructor (address token) public {\n', '    ausc = token;\n', '    path = [ausc, weth, usdc];\n', '  }\n', '\n', '  function getPriceAUSC() public view returns (bool, uint256) {\n', '    // returns the price with 6 decimals, but we want 18\n', '    uint256[] memory amounts = IUniswapRouterV2(oracle).getAmountsOut(1e18, path);\n', '    return (ausc != address(0), amounts[2].mul(1e12));\n', '  }\n', '}\n', '\n', '// File: contracts/Rebaser.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', 'contract Rebaser is BasicRebaser, UniswapOracle, ChainlinkOracle {\n', '\n', '  constructor (address token, address _treasury)\n', '  BasicRebaser(token, _treasury)\n', '  UniswapOracle(token) public {\n', '  }\n', '\n', '}']