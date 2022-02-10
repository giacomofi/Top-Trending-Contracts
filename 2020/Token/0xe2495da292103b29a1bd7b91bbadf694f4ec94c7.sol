['// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/StrategySwerveUSD.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', '\n', '\n', '/*\n', ' A strategy must implement the following calls;\n', '\n', ' - deposit()\n', ' - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller\n', ' - withdraw(uint) - Controller | Vault role - withdraw should always return to vault\n', ' - withdrawAll() - Controller | Vault role - withdraw should always return to vault\n', ' - balanceOf()\n', ' - riskAnalysis()\n', '\n', ' Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller\n', '*/\n', '\n', 'interface SSUSDController {\n', '  function vaults(address) external view returns (address);\n', '  function rewards() external view returns (address);\n', '}\n', '\n', 'interface SSUSDGauge {\n', '  function deposit(uint) external;\n', '  function balanceOf(address) external view returns (uint);\n', '  function withdraw(uint) external;\n', '}\n', '\n', 'interface SSUSDMintr {\n', '  function mint(address) external;\n', '}\n', '\n', 'interface SSUSDUniswapRouter {\n', '  function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;\n', '}\n', '\n', 'interface ISwerveFi {\n', '  function get_virtual_price() external view returns (uint);\n', '  function add_liquidity(\n', '    uint256[4] calldata amounts,\n', '    uint256 min_mint_amount\n', '  ) external;\n', '  function remove_liquidity_imbalance(\n', '    uint256[4] calldata amounts,\n', '    uint256 max_burn_amount\n', '  ) external;\n', '  function remove_liquidity(\n', '    uint256 _amount,\n', '    uint256[4] calldata amounts\n', '  ) external;\n', '  function exchange(\n', '    int128 from,\n', '    int128 to,\n', '    uint256 _from_amount,\n', '    uint256 _min_to_amount\n', '  ) external;\n', '  function calc_token_amount(\n', '    uint256[4] calldata amounts,\n', '    bool deposit\n', '  ) external view returns(uint);\n', '  function calc_withdraw_one_coin(\n', '    uint256 _token_amount,\n', '    int128 i) external view returns (uint256);\n', '  function remove_liquidity_one_coin(\n', '    uint256 _token_amount,\n', '    int128 i,\n', '    uint256 min_amount) external;\n', '}\n', '\n', 'contract StrategySwerveUSD {\n', '  using Address for address;\n', '  using SafeERC20 for IERC20;\n', '  using SafeMath for uint256;\n', '\n', '  enum TokenIndex {\n', '    DAI,\n', '    USDC,\n', '    USDT,\n', '    TUSD\n', '  }\n', '\n', '  mapping(uint256 => address) public tokenIndexAddress;\n', '  address public want;\n', '  // the matching enum record used to determine the index\n', '  TokenIndex tokenIndex;\n', '  address constant public swusd = address(0x77C6E4a580c0dCE4E5c7a17d0bc077188a83A059); // (swerve combo Swerve.fi DAI/USDC/USDT/TUSD (swUSD))\n', '  address constant public curve = address(0xa746c67eB7915Fa832a4C2076D403D4B68085431);\n', '  address constant public gauge = address(0xb4d0C929cD3A1FbDc6d57E7D3315cF0C4d6B4bFa);\n', '  address constant public mintr = address(0x2c988c3974AD7E604E276AE0294a7228DEf67974);\n', '  address constant public swrv = address(0xB8BAa0e4287890a5F79863aB62b7F175ceCbD433);\n', '  address constant public uni = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '  address constant public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // used for swrv <> weth <> want route\n', '  // liquidation path to be used\n', '  address[] public uniswap_swrv2want;\n', '\n', '  uint public performanceFee = 1000;\n', '  uint constant public performanceMax = 10000;\n', '\n', '  uint public arbMin = 995000;\n', '  uint public arbMax = 1010000;\n', '\n', '  address public governance;\n', '  address public controller;\n', '\n', '  constructor(uint256 _tokenIndex, address _controller) public {\n', '    tokenIndexAddress[0] = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);\n', '    tokenIndexAddress[1] = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);\n', '    tokenIndexAddress[2] = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);\n', '    tokenIndexAddress[3] = address(0x0000000000085d4780B73119b644AE5ecd22b376);\n', '    tokenIndex = TokenIndex(_tokenIndex);\n', '    want = tokenIndexAddress[_tokenIndex];\n', '    uniswap_swrv2want = [swrv, weth, want];\n', '    governance = tx.origin;\n', '    controller = _controller;\n', '  }\n', '\n', '  function getName() external pure returns (string memory) {\n', '    return "StrategySwerveUSD";\n', '  }\n', '\n', '  function setPerformanceFee(uint _performanceFee) external {\n', '    require(msg.sender == governance, "!governance");\n', '    performanceFee = _performanceFee;\n', '  }\n', '\n', '  function setArbMin(uint _arbMin) external {\n', '    require(msg.sender == governance, "!governance");\n', '    arbMin = _arbMin;\n', '  }\n', '\n', '  function setArbMax(uint _arbMax) external {\n', '    require(msg.sender == governance, "!governance");\n', '    arbMax = _arbMax;\n', '  }\n', '\n', '  function wrapCoinAmount(uint256 amount) internal view returns (uint256[4] memory) {\n', '    uint256[4] memory amounts = [uint256(0), uint256(0), uint256(0), uint256(0)];\n', '    amounts[uint56(tokenIndex)] = amount;\n', '    return amounts;\n', '  }\n', '\n', '  function swusdFromWant() internal {\n', '    uint256 wantBalance = IERC20(want).balanceOf(address(this));\n', '    if (wantBalance > 0) {\n', '      IERC20(want).safeApprove(curve, 0);\n', '      IERC20(want).safeApprove(curve, wantBalance);\n', '      // we can accept 0 as minimum because this is called only by a trusted role\n', '      uint256 minimum = 0;\n', '      uint256[4] memory coinAmounts = wrapCoinAmount(wantBalance);\n', '      ISwerveFi(curve).add_liquidity(coinAmounts, minimum);\n', '    }\n', '    // now we have the swusd token\n', '  }\n', '\n', '  function deposit() public {\n', "    require(riskAnalysis(), 'risk!');\n", '\n', '    // convert the entire balance not yet invested into swusd first\n', '    swusdFromWant();\n', '\n', '    // then deposit into the swusd vault\n', '    uint256 swusdBalance = IERC20(swusd).balanceOf(address(this));\n', '    if (swusdBalance > 0) {\n', '      IERC20(swusd).safeApprove(gauge, 0);\n', '      IERC20(swusd).safeApprove(gauge, swusdBalance);\n', '      SSUSDGauge(gauge).deposit(swusdBalance);\n', '    }\n', '  }\n', '\n', '  // Controller only function for creating additional rewards from dust\n', '  function withdraw(IERC20 _asset) external returns (uint balance) {\n', '    require(msg.sender == controller, "!controller");\n', '    require(want != address(_asset), "want");\n', '    require(swusd != address(_asset), "swusd");\n', '    require(swrv != address(_asset), "swrv");\n', '    balance = _asset.balanceOf(address(this));\n', '    _asset.safeTransfer(controller, balance);\n', '  }\n', '\n', '  function wantValueFromSWUSD(uint256 swusdBalance) public view returns (uint256) {\n', '    return ISwerveFi(curve).calc_withdraw_one_coin(swusdBalance, int128(tokenIndex));\n', '  }\n', '\n', '  function swusdToWant(uint256 wantLimit) internal {\n', '    uint256 swusdBalance = IERC20(swusd).balanceOf(address(this));\n', '\n', '    // this is the maximum number of want we can get for our swusd token\n', '    uint256 wantMaximumAmount = wantValueFromSWUSD(swusdBalance);\n', '    if (wantMaximumAmount == 0) {\n', '      return;\n', '    }\n', '\n', '    if (wantLimit < wantMaximumAmount) {\n', '      // we want less than what we can get, we ask for the exact amount\n', '      // now we can remove the liquidity\n', '      uint256[4] memory tokenAmounts = wrapCoinAmount(wantLimit);\n', '      IERC20(swusd).safeApprove(curve, 0);\n', '      IERC20(swusd).safeApprove(curve, swusdBalance);\n', '      ISwerveFi(curve).remove_liquidity_imbalance(tokenAmounts, swusdBalance);\n', '    } else {\n', '      // we want more than we can get, so we withdraw everything\n', '      IERC20(swusd).safeApprove(curve, 0);\n', '      IERC20(swusd).safeApprove(curve, swusdBalance);\n', '      ISwerveFi(curve).remove_liquidity_one_coin(swusdBalance, int128(tokenIndex), 0);\n', '    }\n', '    // now we have want asset\n', '  }\n', '\n', '  // Withdraw partial funds, normally used with a vault withdrawal\n', '  function withdraw(uint _amount) external {\n', '    require(msg.sender == controller, "!controller");\n', '    uint _balance = IERC20(want).balanceOf(address(this));\n', '    if (_balance < _amount) {\n', '      _amount = _withdrawSome(_amount.sub(_balance));\n', '      _amount = _amount.add(_balance);\n', '    }\n', '\n', '    address _vault = SSUSDController(controller).vaults(address(want));\n', '    require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '\n', '    IERC20(want).safeTransfer(_vault, _amount);\n', '\n', '    // invest back the rest\n', '    deposit();\n', '  }\n', '\n', '  // Withdraw all funds, normally used when migrating strategies\n', '  function withdrawAll() external returns (uint balance) {\n', '    require(msg.sender == controller, "!controller");\n', '    _withdrawAll();\n', '\n', '    // we can transfer the asset to the vault\n', '    balance = IERC20(want).balanceOf(address(this));\n', '\n', '    if (balance > 0) {\n', '      address _vault = SSUSDController(controller).vaults(address(want));\n', '      require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '      IERC20(want).safeTransfer(_vault, balance);\n', '    }\n', '  }\n', '\n', '  function _withdrawAll() internal {\n', '    // withdraw all from gauge\n', '    uint _balance = SSUSDGauge(gauge).balanceOf(address(this));\n', '    if (_balance > 0) {\n', '      SSUSDGauge(gauge).withdraw(_balance);\n', '    }\n', '    // convert the swusd to want, we want the entire balance\n', '    swusdToWant(uint256(~0));\n', '  }\n', '\n', '  function harvest() public {\n', '    require(msg.sender == governance, "!authorized");\n', '    SSUSDMintr(mintr).mint(gauge);\n', '    uint _before = IERC20(want).balanceOf(address(this));\n', '    // claiming rewards and liquidating them\n', '    uint256 swrvBalance = IERC20(swrv).balanceOf(address(this));\n', '    if (swrvBalance > 0) {\n', '      IERC20(swrv).safeApprove(uni, 0);\n', '      IERC20(swrv).safeApprove(uni, swrvBalance);\n', '      SSUSDUniswapRouter(uni).swapExactTokensForTokens(swrvBalance, uint(0), uniswap_swrv2want, address(this), now.add(1800));\n', '    }\n', '    uint _after = IERC20(want).balanceOf(address(this));\n', '    if (_after > _before) {\n', '      uint profit = _after.sub(_before);\n', '      uint _fee = profit.mul(performanceFee).div(performanceMax);\n', '      IERC20(want).safeTransfer(SSUSDController(controller).rewards(), _fee);\n', '      deposit();\n', '    }\n', '  }\n', '\n', '  function _withdrawSome(uint256 _amount) internal returns (uint) {\n', '    uint _before = IERC20(want).balanceOf(address(this));\n', '    // withdraw all from gauge\n', '    SSUSDGauge(gauge).withdraw(SSUSDGauge(gauge).balanceOf(address(this)));\n', '    // convert the swusd to want, but get at most _amount\n', '    swusdToWant(_amount);\n', '    uint _after = IERC20(want).balanceOf(address(this));\n', '    return _after.sub(_before);\n', '  }\n', '\n', '  function balanceOfWant() public view returns (uint) {\n', '    return IERC20(want).balanceOf(address(this));\n', '  }\n', '\n', '  function balanceOfPool() public view returns (uint) {\n', '    uint256 swusdBalance = SSUSDGauge(gauge).balanceOf(address(this));\n', '    return ISwerveFi(curve).calc_withdraw_one_coin(swusdBalance, int128(tokenIndex));\n', '  }\n', '\n', '  function balanceOf() public view returns (uint) {\n', '    return balanceOfWant().add(balanceOfPool());\n', '  }\n', '\n', '  function riskAnalysis() public view returns (bool) {\n', '    uint256 price = ISwerveFi(curve).calc_withdraw_one_coin(10 ** 18, int128(tokenIndex));\n', '    return (price >= arbMin) && (price <= arbMax);\n', '  }\n', '\n', '  function setGovernance(address _governance) external {\n', '    require(msg.sender == governance, "!governance");\n', '    governance = _governance;\n', '  }\n', '\n', '  function setController(address _controller) external {\n', '    require(msg.sender == governance, "!governance");\n', '    controller = _controller;\n', '  }\n', '}']