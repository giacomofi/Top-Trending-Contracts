['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-27\n', '*/\n', '\n', '// Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * // importANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// Dependency file: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', '// pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/interfaces/ICurveFiSwap.sol\n', '\n', '\n', '// pragma solidity >=0.7.5 <0.8.0;\n', 'pragma abicoder v2;\n', '\n', 'interface ICurveFiSwap {\n', '    event TokenExchange(\n', '        address indexed buyer,\n', '        address indexed receiver,\n', '        address indexed pool,\n', '        address token_sold,\n', '        address token_bought,\n', '        uint256 amount_sold,\n', '        uint256 amount_bought\n', '    );\n', '\n', '    function exchange_with_best_rate(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount,\n', '        uint256 _expected\n', '    ) external payable returns (uint256);\n', '\n', '    function exchange_with_best_rate(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount,\n', '        uint256 _expected,\n', '        address _receiver\n', '    ) external payable returns (uint256);\n', '\n', '    function exchange(\n', '        address _pool,\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount,\n', '        uint256 _expected\n', '    ) external payable returns (uint256);\n', '\n', '    function exchange(\n', '        address _pool,\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount,\n', '        uint256 _expected,\n', '        address _receiver\n', '    ) external payable returns (uint256);\n', '\n', '    function get_best_rate(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) view external returns (address, uint256);\n', '\n', '    function get_exchange_amount(\n', '        address _pool,\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) view external returns (uint256);\n', '\n', '    function get_input_amount(\n', '        address _pool,\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) view external returns (uint256);\n', '\n', '    function get_exchange_amounts(\n', '        address _pool,\n', '        address _from,\n', '        address _to,\n', '        uint256[100] calldata _amounts\n', '    ) view external returns (uint256[100] memory);\n', '\n', '    function get_calculator(address _pool) view external returns (address);\n', '\n', '    function update_registry_address() external returns (bool);\n', '\n', '    function set_calculator(address _pool, address _calculator) external returns (bool);\n', '\n', '    function set_default_calculator(address _calculator) external returns (bool);\n', '\n', '    function claim_balance(address _token) external returns (bool);\n', '\n', '    function set_killed(bool _is_killed) external returns (bool);\n', '\n', '    function registry() view external returns (address);\n', '\n', '    function default_calculator() view external returns (address);\n', '\n', '    function is_killed() view external returns (bool);\n', '}\n', '\n', '\n', '// Dependency file: contracts/libraries/Helper.sol\n', '\n', '// Helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library Helper {\n', '  function safeApprove(\n', '    address token,\n', '    address to,\n', '    uint256 value\n', '  ) internal {\n', "    // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '    require(\n', '      success && (data.length == 0 || abi.decode(data, (bool))),\n', "      'Helper::safeApprove: approve failed'\n", '    );\n', '  }\n', '\n', '  function safeTransfer(\n', '    address token,\n', '    address to,\n', '    uint256 value\n', '  ) internal {\n', "    // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '    require(\n', '      success && (data.length == 0 || abi.decode(data, (bool))),\n', "      'Helper::safeTransfer: transfer failed'\n", '    );\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    address token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  ) internal {\n', "    // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '    require(\n', '      success && (data.length == 0 || abi.decode(data, (bool))),\n', "      'Helper::transferFrom: transferFrom failed'\n", '    );\n', '  }\n', '\n', '  function safeTransferETH(address to, uint256 value) internal {\n', '    (bool success, ) = to.call{value: value}(new bytes(0));\n', "    require(success, 'Helper::safeTransferETH: ETH transfer failed');\n", '  }\n', '}\n', '\n', '\n', '// Root file: contracts/DePayRouterV1CurveFiSwap01.sol\n', '\n', '\n', 'pragma solidity >=0.7.5 <0.8.0;\n', '\n', '// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '// import "@openzeppelin/contracts/math/SafeMath.sol";\n', "// import 'contracts/interfaces/ICurveFiSwap.sol';\n", "// import 'contracts/libraries/Helper.sol';\n", '\n', 'contract DePayRouterV1CurveFiSwap01 {\n', '  \n', '  using SafeMath for uint;\n', '\n', '  // Address representating ETH (e.g. in payment routing paths)\n', '  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '  // MAXINT to be used only, to increase allowance from\n', '  // payment protocol contract towards known \n', '  // decentralized exchanges, not to dyanmically called contracts!!!\n', '  uint public immutable MAXINT = type(uint256).max;\n', '  \n', '  // Address of Synth sETH (sETH).\n', "  // They're mostly using sETH\n", '  // https://etherscan.io/address/0x5e74C9036fb86BD7eCdcb084a0673EFc32eA31cb\n', '  address public immutable SETH;\n', '\n', '  // Address of CurveFiSwap\n', '  address public immutable CurveFiSwap;\n', '\n', '  // Indicates that this plugin requires delegate call\n', '  bool public immutable delegate = true;\n', '\n', '  // Pass SETH and the _CurveFiSwap when deploying this contract.\n', '  constructor ( address _SETH, address _CurveFiSwap) {\n', '    SETH = _SETH;\n', '    CurveFiSwap = _CurveFiSwap;\n', '  }\n', '\n', '  // Swap tokenA<>tokenB, ETH<>sETH or sETH<>ETH on CureFi.\n', '  //\n', '  // path -> [from, to]\n', '  // amounts -> [amount, expected]\n', '  // addresses -> [pool]\n', '  //\n', '  //  function exchange(\n', '  //      address _pool,      # Pool address, could able to get from \n', '  //      address _from,      # From token address\n', '  //      address _to,        # To token address\n', '  //      uint256 _amount,    # Amount\n', '  //      uint256 _expected,  # Minimum amount of from token, like you expect to exchange for 1 USDT\n', '  //      address _receiver,  # Receiver address\n', '  //  ) payable returns (uint256);\n', '  //\n', '  function execute(\n', '    address[] calldata path,\n', '    uint[] calldata amounts,\n', '    address[] calldata addresses,\n', '    string[] calldata data\n', '  ) external payable returns(bool) {\n', '    // Make sure swapping the token within the payment protocol contract is approved on the CurveFiSwap.\n', '    if( \n', '      // from != ETH address\n', '      path[0] != ETH &&\n', '      IERC20(path[0]).allowance(address(this), CurveFiSwap) < amounts[0]\n', '    ) {\n', '      // Allow CurveFi transfer token\n', '      Helper.safeApprove(path[0], CurveFiSwap, MAXINT);\n', '    }\n', '\n', '    // From token is ETH, \n', '    if(path[0] == ETH) {\n', '      ICurveFiSwap(CurveFiSwap).exchange{value: amounts[0]}(\n', '        addresses[0], // pool\n', '        path[0],      // from token\n', '        path[1],      // to token\n', '        amounts[0],   // amount\n', '        amounts[1],   // expected\n', '        address(this) // receiver\n', '      );\n', '    } else {\n', '      ICurveFiSwap(CurveFiSwap).exchange(\n', '        addresses[0], // pool\n', '        path[0],      // from token\n', '        path[1],      // to token\n', '        amounts[0],   // amount\n', '        amounts[1],   // expected\n', '        address(this) // receiver\n', '      );\n', '    }\n', '\n', '    return true;\n', '  }\n', '}']