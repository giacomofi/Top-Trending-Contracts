['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-28\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', '// Part: IBaseOracle\n', '\n', 'interface IBaseOracle {\n', '  /// @dev Return the value of the given input as ETH per unit, multiplied by 2**112.\n', '  /// @param token The ERC-20 token to check the value.\n', '  function getETHPx(address token) external view returns (uint);\n', '}\n', '\n', '// Part: ICurvePool\n', '\n', 'interface ICurvePool {\n', '  function add_liquidity(uint[2] calldata, uint) external;\n', '\n', '  function add_liquidity(uint[3] calldata, uint) external;\n', '\n', '  function add_liquidity(uint[4] calldata, uint) external;\n', '\n', '  function remove_liquidity(uint, uint[2] calldata) external;\n', '\n', '  function remove_liquidity(uint, uint[3] calldata) external;\n', '\n', '  function remove_liquidity(uint, uint[4] calldata) external;\n', '\n', '  function remove_liquidity_imbalance(uint[2] calldata, uint) external;\n', '\n', '  function remove_liquidity_imbalance(uint[3] calldata, uint) external;\n', '\n', '  function remove_liquidity_imbalance(uint[4] calldata, uint) external;\n', '\n', '  function remove_liquidity_one_coin(\n', '    uint,\n', '    int128,\n', '    uint\n', '  ) external;\n', '\n', '  function get_virtual_price() external view returns (uint);\n', '}\n', '\n', '// Part: ICurveRegistry\n', '\n', 'interface ICurveRegistry {\n', '  function get_n_coins(address lp) external view returns (uint, uint);\n', '\n', '  function pool_list(uint id) external view returns (address);\n', '\n', '  function get_coins(address pool) external view returns (address[8] memory);\n', '\n', '  function get_gauges(address pool) external view returns (address[10] memory, uint128[10] memory);\n', '\n', '  function get_lp_token(address pool) external view returns (address);\n', '\n', '  function get_pool_from_lp_token(address lp) external view returns (address);\n', '}\n', '\n', '// Part: IERC20Decimal\n', '\n', 'interface IERC20Decimal {\n', '  function decimals() external view returns (uint8);\n', '}\n', '\n', '// Part: OpenZeppelin/[email\xa0protected]/SafeMath\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// Part: UsingBaseOracle\n', '\n', 'contract UsingBaseOracle {\n', '  IBaseOracle public immutable base; // Base oracle source\n', '\n', '  constructor(IBaseOracle _base) public {\n', '    base = _base;\n', '  }\n', '}\n', '\n', '// File: CurveOracle.sol\n', '\n', 'contract CurveOracle is UsingBaseOracle, IBaseOracle {\n', '  using SafeMath for uint;\n', '\n', '  ICurveRegistry public immutable registry; // Curve registry\n', '\n', '  struct UnderlyingToken {\n', '    uint8 decimals; // token decimals\n', '    address token; // token address\n', '  }\n', '\n', '  mapping(address => UnderlyingToken[]) public ulTokens; // Mapping from LP token to underlying tokens\n', '  mapping(address => address) public poolOf; // Mapping from LP token to pool\n', '\n', '  constructor(IBaseOracle _base, ICurveRegistry _registry) public UsingBaseOracle(_base) {\n', '    registry = _registry;\n', '  }\n', '\n', '  /// @dev Register the pool given LP token address and set the pool info.\n', '  /// @param lp LP token to find the corresponding pool.\n', '  function registerPool(address lp) external {\n', '    address pool = poolOf[lp];\n', "    require(pool == address(0), 'lp is already registered');\n", '    pool = registry.get_pool_from_lp_token(lp);\n', "    require(pool != address(0), 'no corresponding pool for lp token');\n", '    poolOf[lp] = pool;\n', '    (uint n, ) = registry.get_n_coins(pool);\n', '    address[8] memory tokens = registry.get_coins(pool);\n', '    for (uint i = 0; i < n; i++) {\n', '      ulTokens[lp].push(\n', '        UnderlyingToken({token: tokens[i], decimals: IERC20Decimal(tokens[i]).decimals()})\n', '      );\n', '    }\n', '  }\n', '\n', '  /// @dev Return the value of the given input as ETH per unit, multiplied by 2**112.\n', '  /// @param lp The ERC-20 LP token to check the value.\n', '  function getETHPx(address lp) external view override returns (uint) {\n', '    address pool = poolOf[lp];\n', "    require(pool != address(0), 'lp is not registered');\n", '    UnderlyingToken[] memory tokens = ulTokens[lp];\n', '    uint minPx = uint(-1);\n', '    uint n = tokens.length;\n', '    for (uint idx = 0; idx < n; idx++) {\n', '      UnderlyingToken memory ulToken = tokens[idx];\n', '      uint tokenPx = base.getETHPx(ulToken.token);\n', '      if (ulToken.decimals < 18) tokenPx = tokenPx.div(10**(18 - uint(ulToken.decimals)));\n', '      if (ulToken.decimals > 18) tokenPx = tokenPx.mul(10**(uint(ulToken.decimals) - 18));\n', '      if (tokenPx < minPx) minPx = tokenPx;\n', '    }\n', "    require(minPx != uint(-1), 'no min px');\n", '    // use min underlying token prices\n', '    return minPx.mul(ICurvePool(pool).get_virtual_price()).div(1e18);\n', '  }\n', '}']