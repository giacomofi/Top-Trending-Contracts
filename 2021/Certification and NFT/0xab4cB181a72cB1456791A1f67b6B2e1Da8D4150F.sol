['// SPDX-License-Identifier: MIT\n', 'pragma solidity =0.7.6;\n', '\n', 'import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";\n', '\n', 'import "./interfaces/IEthUsdOracle.sol";\n', '\n', 'import "../external-lib/SafeDecimalMath.sol";\n', '\n', 'contract ChainlinkEthUsdConsumer is IEthUsdOracle {\n', '  using SafeDecimalMath for uint256;\n', '\n', '  AggregatorV3Interface public immutable priceFeed;\n', '\n', '  /**\n', '   * @notice Construct a new price consumer\n', '   * @dev Mainnet ETH/USD: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419\n', '      Source: https://docs.chain.link/docs/ethereum-addresses#config\n', '   */\n', '  constructor(address aggregatorAddress) {\n', '    priceFeed = AggregatorV3Interface(aggregatorAddress);\n', '  }\n', '\n', '  /// @inheritdoc IEthUsdOracle\n', '  function consult()\n', '    external\n', '    view\n', '    override(IEthUsdOracle)\n', '    returns (uint256 price)\n', '  {\n', '    (, int256 _price, , , ) = priceFeed.latestRoundData();\n', '    require(_price >= 0, "ChainlinkConsumer/StrangeOracle");\n', '    return (price = uint256(_price).decimalToPreciseDecimal());\n', '  }\n', '\n', '  /**\n', '   * @notice Retrieves decimals of price feed\n', '   * @dev (18 for ETH-USD by default, scaled up)\n', '   */\n', '  function getDecimals() external pure returns (uint8 decimals) {\n', '    return (decimals = 27);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.7.0;\n', '\n', 'interface AggregatorV3Interface {\n', '\n', '  function decimals() external view returns (uint8);\n', '  function description() external view returns (string memory);\n', '  function version() external view returns (uint256);\n', '\n', '  // getRoundData and latestRoundData should both raise "No data present"\n', '  // if they do not have data to report, instead of returning unset values\n', '  // which could be misinterpreted as actual reported values.\n', '  function getRoundData(uint80 _roundId)\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '  function latestRoundData()\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.7.6;\n', '\n', 'interface IEthUsdOracle {\n', '  /**\n', '   * @notice Spot price\n', '   * @return price The latest price as an [e27]\n', '   */\n', '  function consult() external view returns (uint256 price);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', '// https://docs.synthetix.io/contracts/source/libraries/safedecimalmath\n', 'library SafeDecimalMath {\n', '  using SafeMath for uint256;\n', '\n', '  /* Number of decimal places in the representations. */\n', '  uint8 public constant decimals = 18;\n', '  uint8 public constant highPrecisionDecimals = 27;\n', '\n', '  /* The number representing 1.0. */\n', '  uint256 public constant UNIT = 10**uint256(decimals);\n', '\n', '  /* The number representing 1.0 for higher fidelity numbers. */\n', '  uint256 public constant PRECISE_UNIT = 10**uint256(highPrecisionDecimals);\n', '  uint256 private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR =\n', '    10**uint256(highPrecisionDecimals - decimals);\n', '\n', '  /**\n', '   * @return Provides an interface to UNIT.\n', '   */\n', '  function unit() external pure returns (uint256) {\n', '    return UNIT;\n', '  }\n', '\n', '  /**\n', '   * @return Provides an interface to PRECISE_UNIT.\n', '   */\n', '  function preciseUnit() external pure returns (uint256) {\n', '    return PRECISE_UNIT;\n', '  }\n', '\n', '  /**\n', '   * @return The result of multiplying x and y, interpreting the operands as fixed-point\n', '   * decimals.\n', '   *\n', '   * @dev A unit factor is divided out after the product of x and y is evaluated,\n', '   * so that product must be less than 2**256. As this is an integer division,\n', '   * the internal division always rounds down. This helps save on gas. Rounding\n', '   * is more expensive on gas.\n', '   */\n', '  function multiplyDecimal(uint256 x, uint256 y)\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    /* Divide by UNIT to remove the extra factor introduced by the product. */\n', '    return x.mul(y) / UNIT;\n', '  }\n', '\n', '  /**\n', '   * @return The result of safely multiplying x and y, interpreting the operands\n', '   * as fixed-point decimals of the specified precision unit.\n', '   *\n', '   * @dev The operands should be in the form of a the specified unit factor which will be\n', '   * divided out after the product of x and y is evaluated, so that product must be\n', '   * less than 2**256.\n', '   *\n', '   * Unlike multiplyDecimal, this function rounds the result to the nearest increment.\n', '   * Rounding is useful when you need to retain fidelity for small decimal numbers\n', '   * (eg. small fractions or percentages).\n', '   */\n', '  function _multiplyDecimalRound(\n', '    uint256 x,\n', '    uint256 y,\n', '    uint256 precisionUnit\n', '  ) private pure returns (uint256) {\n', '    /* Divide by UNIT to remove the extra factor introduced by the product. */\n', '    uint256 quotientTimesTen = x.mul(y) / (precisionUnit / 10);\n', '\n', '    if (quotientTimesTen % 10 >= 5) {\n', '      quotientTimesTen += 10;\n', '    }\n', '\n', '    return quotientTimesTen / 10;\n', '  }\n', '\n', '  /**\n', '   * @return The result of safely multiplying x and y, interpreting the operands\n', '   * as fixed-point decimals of a precise unit.\n', '   *\n', '   * @dev The operands should be in the precise unit factor which will be\n', '   * divided out after the product of x and y is evaluated, so that product must be\n', '   * less than 2**256.\n', '   *\n', '   * Unlike multiplyDecimal, this function rounds the result to the nearest increment.\n', '   * Rounding is useful when you need to retain fidelity for small decimal numbers\n', '   * (eg. small fractions or percentages).\n', '   */\n', '  function multiplyDecimalRoundPrecise(uint256 x, uint256 y)\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    return _multiplyDecimalRound(x, y, PRECISE_UNIT);\n', '  }\n', '\n', '  /**\n', '   * @return The result of safely multiplying x and y, interpreting the operands\n', '   * as fixed-point decimals of a standard unit.\n', '   *\n', '   * @dev The operands should be in the standard unit factor which will be\n', '   * divided out after the product of x and y is evaluated, so that product must be\n', '   * less than 2**256.\n', '   *\n', '   * Unlike multiplyDecimal, this function rounds the result to the nearest increment.\n', '   * Rounding is useful when you need to retain fidelity for small decimal numbers\n', '   * (eg. small fractions or percentages).\n', '   */\n', '  function multiplyDecimalRound(uint256 x, uint256 y)\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    return _multiplyDecimalRound(x, y, UNIT);\n', '  }\n', '\n', '  /**\n', '   * @return The result of safely dividing x and y. The return value is a high\n', '   * precision decimal.\n', '   *\n', '   * @dev y is divided after the product of x and the standard precision unit\n', '   * is evaluated, so the product of x and UNIT must be less than 2**256. As\n', '   * this is an integer division, the result is always rounded down.\n', '   * This helps save on gas. Rounding is more expensive on gas.\n', '   */\n', '  function divideDecimal(uint256 x, uint256 y) internal pure returns (uint256) {\n', '    /* Reintroduce the UNIT factor that will be divided out by y. */\n', '    return x.mul(UNIT).div(y);\n', '  }\n', '\n', '  /**\n', '   * @return The result of safely dividing x and y. The return value is as a rounded\n', '   * decimal in the precision unit specified in the parameter.\n', '   *\n', '   * @dev y is divided after the product of x and the specified precision unit\n', '   * is evaluated, so the product of x and the specified precision unit must\n', '   * be less than 2**256. The result is rounded to the nearest increment.\n', '   */\n', '  function _divideDecimalRound(\n', '    uint256 x,\n', '    uint256 y,\n', '    uint256 precisionUnit\n', '  ) private pure returns (uint256) {\n', '    uint256 resultTimesTen = x.mul(precisionUnit * 10).div(y);\n', '\n', '    if (resultTimesTen % 10 >= 5) {\n', '      resultTimesTen += 10;\n', '    }\n', '\n', '    return resultTimesTen / 10;\n', '  }\n', '\n', '  /**\n', '   * @return The result of safely dividing x and y. The return value is as a rounded\n', '   * standard precision decimal.\n', '   *\n', '   * @dev y is divided after the product of x and the standard precision unit\n', '   * is evaluated, so the product of x and the standard precision unit must\n', '   * be less than 2**256. The result is rounded to the nearest increment.\n', '   */\n', '  function divideDecimalRound(uint256 x, uint256 y)\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    return _divideDecimalRound(x, y, UNIT);\n', '  }\n', '\n', '  /**\n', '   * @return The result of safely dividing x and y. The return value is as a rounded\n', '   * high precision decimal.\n', '   *\n', '   * @dev y is divided after the product of x and the high precision unit\n', '   * is evaluated, so the product of x and the high precision unit must\n', '   * be less than 2**256. The result is rounded to the nearest increment.\n', '   */\n', '  function divideDecimalRoundPrecise(uint256 x, uint256 y)\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    return _divideDecimalRound(x, y, PRECISE_UNIT);\n', '  }\n', '\n', '  /**\n', '   * @dev Convert a standard decimal representation to a high precision one.\n', '   */\n', '  function decimalToPreciseDecimal(uint256 i) internal pure returns (uint256) {\n', '    return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);\n', '  }\n', '\n', '  /**\n', '   * @dev Convert a high precision decimal to a standard decimal representation.\n', '   */\n', '  function preciseDecimalToDecimal(uint256 i) internal pure returns (uint256) {\n', '    uint256 quotientTimesTen =\n', '      i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);\n', '\n', '    if (quotientTimesTen % 10 >= 5) {\n', '      quotientTimesTen += 10;\n', '    }\n', '\n', '    return quotientTimesTen / 10;\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 999999\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "bytecodeHash": "none",\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']