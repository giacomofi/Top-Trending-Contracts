['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.6.0;\n', '\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', 'library PowerImplLib {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private constant ONE = 1;\n', '    uint32 private constant MAX_WEIGHT = 1000000;\n', '    uint8 private constant MIN_PRECISION = 32;\n', '    uint8 private constant MAX_PRECISION = 127;\n', '\n', "    // Auto-generated via 'PrintIntScalingFactors.py'\n", '    uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;\n', '    uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;\n', '    uint256 private constant MAX_NUM = 0x200000000000000000000000000000000;\n', '\n', "    // Auto-generated via 'PrintLn2ScalingFactors.py'\n", '    uint256 private constant LN2_NUMERATOR = 0x3f80fe03f80fe03f80fe03f80fe03f8;\n', '    uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;\n', '\n', "    // Auto-generated via 'PrintFunctionOptimalLog.py' and 'PrintFunctionOptimalExp.py'\n", '    uint256 private constant OPT_LOG_MAX_VAL = 0x15bf0a8b1457695355fb8ac404e7a79e3;\n', '    uint256 private constant OPT_EXP_MAX_VAL = 0x800000000000000000000000000000000;\n', '\n', "    // Auto-generated via 'PrintLambertFactors.py'\n", '    uint256 private constant LAMBERT_CONV_RADIUS = 0x002f16ac6c59de6f8d5d6f63c1482a7c86;\n', '    uint256 private constant LAMBERT_POS2_SAMPLE = 0x0003060c183060c183060c183060c18306;\n', '    uint256 private constant LAMBERT_POS2_MAXVAL = 0x01af16ac6c59de6f8d5d6f63c1482a7c80;\n', '    uint256 private constant LAMBERT_POS3_MAXVAL = 0x6b22d43e72c326539cceeef8bb48f255ff;\n', '\n', "    // Auto-generated via 'PrintWeightFactors.py'\n", '    uint256 private constant MAX_UNF_WEIGHT = 0x10c6f7a0b5ed8d36b4c7f34938583621fafc8b0079a2834d26fa3fcc9ea9;\n', '\n', "    // Auto-generated via 'PrintMaxExpArray.py'\n", '\n', '    /**\n', '     * @dev General Description:\n', '     *     Determine a value of precision.\n', '     *     Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.\n', '     *     Return the result along with the precision used.\n', '     *\n', '     * Detailed Description:\n', '     *     Instead of calculating "base ^ exp", we calculate "e ^ (log(base) * exp)".\n', '     *     The value of "log(base)" is represented with an integer slightly smaller than "log(base) * 2 ^ precision".\n', '     *     The larger "precision" is, the more accurately this value represents the real value.\n', '     *     However, the larger "precision" is, the more bits are required in order to store this value.\n', '     *     And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").\n', '     *     This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".\n', '     *     Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.\n', '     *     This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.\n', '     *     This functions assumes that "_expN < 2 ^ 256 / log(MAX_NUM - 1)", otherwise the multiplication should be replaced with a "safeMul".\n', '     *     Since we rely on unsigned-integer arithmetic and "base < 1" ==> "log(base) < 0", this function does not support "_baseN < _baseD".\n', '     */\n', '    function _power(\n', '        uint256 _baseN,\n', '        uint256 _baseD,\n', '        uint32 _expN,\n', '        uint32 _expD\n', '    ) internal pure returns (uint256, uint8) {\n', '        require(_baseN < MAX_NUM);\n', '\n', '        uint256 baseLog;\n', '        uint256 base = (_baseN * FIXED_1) / _baseD;\n', '        if (base < OPT_LOG_MAX_VAL) {\n', '            baseLog = optimalLog(base);\n', '        } else {\n', '            baseLog = _generalLog(base);\n', '        }\n', '\n', '        uint256 baseLogTimesExp = (baseLog * _expN) / _expD;\n', '        if (baseLogTimesExp < OPT_EXP_MAX_VAL) {\n', '            return (optimalExp(baseLogTimesExp), MAX_PRECISION);\n', '        } else {\n', '            uint8 precision = findPositionInMaxExpArray(baseLogTimesExp);\n', '            return (_generalExp(baseLogTimesExp >> (MAX_PRECISION - precision), precision), precision);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev computes log(x / FIXED_1) * FIXED_1.\n', '     * This functions assumes that "x >= FIXED_1", because the output would be negative otherwise.\n', '     */\n', '    function _generalLog(uint256 x) internal pure returns (uint256) {\n', '        uint256 res = 0;\n', '\n', '        // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.\n', '        if (x >= FIXED_2) {\n', '            uint8 count = _floorLog2(x / FIXED_1);\n', '            x >>= count; // now x < 2\n', '            res = count * FIXED_1;\n', '        }\n', '\n', '        // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.\n', '        if (x > FIXED_1) {\n', '            for (uint8 i = MAX_PRECISION; i > 0; --i) {\n', '                x = (x * x) / FIXED_1; // now 1 < x < 4\n', '                if (x >= FIXED_2) {\n', '                    x >>= 1; // now 1 < x < 2\n', '                    res += ONE << (i - 1);\n', '                }\n', '            }\n', '        }\n', '\n', '        return (res * LN2_NUMERATOR) / LN2_DENOMINATOR;\n', '    }\n', '    function getMaxExpArray() internal pure returns (uint256[128] memory maxExpArray) {\n', '        //  maxExpArray[  0] = 0x6bffffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  1] = 0x67ffffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  2] = 0x637fffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  3] = 0x5f6fffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  4] = 0x5b77ffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  5] = 0x57b3ffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;\n', '        //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;\n', '        //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;\n', '        //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;\n', '        //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;\n', '        //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;\n', '        //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;\n', '        //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;\n', '        maxExpArray[32] = 0x1c35fedd14ffffffffffffffffffffffff;\n', '        maxExpArray[33] = 0x1b0ce43b323fffffffffffffffffffffff;\n', '        maxExpArray[34] = 0x19f0028ec1ffffffffffffffffffffffff;\n', '        maxExpArray[35] = 0x18ded91f0e7fffffffffffffffffffffff;\n', '        maxExpArray[36] = 0x17d8ec7f0417ffffffffffffffffffffff;\n', '        maxExpArray[37] = 0x16ddc6556cdbffffffffffffffffffffff;\n', '        maxExpArray[38] = 0x15ecf52776a1ffffffffffffffffffffff;\n', '        maxExpArray[39] = 0x15060c256cb2ffffffffffffffffffffff;\n', '        maxExpArray[40] = 0x1428a2f98d72ffffffffffffffffffffff;\n', '        maxExpArray[41] = 0x13545598e5c23fffffffffffffffffffff;\n', '        maxExpArray[42] = 0x1288c4161ce1dfffffffffffffffffffff;\n', '        maxExpArray[43] = 0x11c592761c666fffffffffffffffffffff;\n', '        maxExpArray[44] = 0x110a688680a757ffffffffffffffffffff;\n', '        maxExpArray[45] = 0x1056f1b5bedf77ffffffffffffffffffff;\n', '        maxExpArray[46] = 0x0faadceceeff8bffffffffffffffffffff;\n', '        maxExpArray[47] = 0x0f05dc6b27edadffffffffffffffffffff;\n', '        maxExpArray[48] = 0x0e67a5a25da4107fffffffffffffffffff;\n', '        maxExpArray[49] = 0x0dcff115b14eedffffffffffffffffffff;\n', '        maxExpArray[50] = 0x0d3e7a392431239fffffffffffffffffff;\n', '        maxExpArray[51] = 0x0cb2ff529eb71e4fffffffffffffffffff;\n', '        maxExpArray[52] = 0x0c2d415c3db974afffffffffffffffffff;\n', '        maxExpArray[53] = 0x0bad03e7d883f69bffffffffffffffffff;\n', '        maxExpArray[54] = 0x0b320d03b2c343d5ffffffffffffffffff;\n', '        maxExpArray[55] = 0x0abc25204e02828dffffffffffffffffff;\n', '        maxExpArray[56] = 0x0a4b16f74ee4bb207fffffffffffffffff;\n', '        maxExpArray[57] = 0x09deaf736ac1f569ffffffffffffffffff;\n', '        maxExpArray[58] = 0x0976bd9952c7aa957fffffffffffffffff;\n', '        maxExpArray[59] = 0x09131271922eaa606fffffffffffffffff;\n', '        maxExpArray[60] = 0x08b380f3558668c46fffffffffffffffff;\n', '        maxExpArray[61] = 0x0857ddf0117efa215bffffffffffffffff;\n', '        maxExpArray[62] = 0x07ffffffffffffffffffffffffffffffff;\n', '        maxExpArray[63] = 0x07abbf6f6abb9d087fffffffffffffffff;\n', '        maxExpArray[64] = 0x075af62cbac95f7dfa7fffffffffffffff;\n', '        maxExpArray[65] = 0x070d7fb7452e187ac13fffffffffffffff;\n', '        maxExpArray[66] = 0x06c3390ecc8af379295fffffffffffffff;\n', '        maxExpArray[67] = 0x067c00a3b07ffc01fd6fffffffffffffff;\n', '        maxExpArray[68] = 0x0637b647c39cbb9d3d27ffffffffffffff;\n', '        maxExpArray[69] = 0x05f63b1fc104dbd39587ffffffffffffff;\n', '        maxExpArray[70] = 0x05b771955b36e12f7235ffffffffffffff;\n', '        maxExpArray[71] = 0x057b3d49dda84556d6f6ffffffffffffff;\n', '        maxExpArray[72] = 0x054183095b2c8ececf30ffffffffffffff;\n', '        maxExpArray[73] = 0x050a28be635ca2b888f77fffffffffffff;\n', '        maxExpArray[74] = 0x04d5156639708c9db33c3fffffffffffff;\n', '        maxExpArray[75] = 0x04a23105873875bd52dfdfffffffffffff;\n', '        maxExpArray[76] = 0x0471649d87199aa990756fffffffffffff;\n', '        maxExpArray[77] = 0x04429a21a029d4c1457cfbffffffffffff;\n', '        maxExpArray[78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;\n', '        maxExpArray[79] = 0x03eab73b3bbfe282243ce1ffffffffffff;\n', '        maxExpArray[80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;\n', '        maxExpArray[81] = 0x0399e96897690418f785257fffffffffff;\n', '        maxExpArray[82] = 0x0373fc456c53bb779bf0ea9fffffffffff;\n', '        maxExpArray[83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;\n', '        maxExpArray[84] = 0x032cbfd4a7adc790560b3337ffffffffff;\n', '        maxExpArray[85] = 0x030b50570f6e5d2acca94613ffffffffff;\n', '        maxExpArray[86] = 0x02eb40f9f620fda6b56c2861ffffffffff;\n', '        maxExpArray[87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;\n', '        maxExpArray[88] = 0x02af09481380a0a35cf1ba02ffffffffff;\n', '        maxExpArray[89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;\n', '        maxExpArray[90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;\n', '        maxExpArray[91] = 0x025daf6654b1eaa55fd64df5efffffffff;\n', '        maxExpArray[92] = 0x0244c49c648baa98192dce88b7ffffffff;\n', '        maxExpArray[93] = 0x022ce03cd5619a311b2471268bffffffff;\n', '        maxExpArray[94] = 0x0215f77c045fbe885654a44a0fffffffff;\n', '        maxExpArray[95] = 0x01ffffffffffffffffffffffffffffffff;\n', '        maxExpArray[96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;\n', '        maxExpArray[97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;\n', '        maxExpArray[98] = 0x01c35fedd14b861eb0443f7f133fffffff;\n', '        maxExpArray[99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;\n', '        maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;\n', '        maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;\n', '        maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;\n', '        maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;\n', '        maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;\n', '        maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;\n', '        maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;\n', '        maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;\n', '        maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;\n', '        maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;\n', '        maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;\n', '        maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;\n', '        maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;\n', '        maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;\n', '        maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;\n', '        maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;\n', '        maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;\n', '        maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;\n', '        maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;\n', '        maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;\n', '        maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;\n', '        maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;\n', '        maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;\n', '        maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;\n', '        maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;\n', '        maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;\n', '        maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;\n', '        maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;\n', '    }\n', '\n', '    /**\n', '     * @dev computes the largest integer smaller than or equal to the binary logarithm of the input.\n', '     */\n', '    function _floorLog2(uint256 _n) internal pure returns (uint8) {\n', '        uint8 res = 0;\n', '\n', '        if (_n < 256) {\n', '            // At most 8 iterations\n', '            while (_n > 1) {\n', '                _n >>= 1;\n', '                res += 1;\n', '            }\n', '        } else {\n', '            // Exactly 8 iterations\n', '            for (uint8 s = 128; s > 0; s >>= 1) {\n', '                if (_n >= (ONE << s)) {\n', '                    _n >>= s;\n', '                    res |= s;\n', '                }\n', '            }\n', '        }\n', '\n', '        return res;\n', '    }\n', '\n', '    /**\n', '     * @dev the global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:\n', '     * - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]\n', '     * - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]\n', '     */\n', '    function findPositionInMaxExpArray(uint256 _x) internal pure returns (uint8) {\n', '        uint256[128] memory maxExpArray = getMaxExpArray();\n', '        uint8 lo = MIN_PRECISION;\n', '        uint8 hi = MAX_PRECISION;\n', '\n', '        while (lo + 1 < hi) {\n', '            uint8 mid = (lo + hi) / 2;\n', '            if (maxExpArray[mid] >= _x) lo = mid;\n', '            else hi = mid;\n', '        }\n', '\n', '        if (maxExpArray[hi] >= _x) return hi;\n', '        if (maxExpArray[lo] >= _x) return lo;\n', '        revert("PowerImplLib.sol: out of bounds");\n', '    }\n', '\n', '    /**\n', "     * @dev this function can be auto-generated by the script 'PrintFunctionGeneralExp.py'.\n", '     * it approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".\n', '     * it returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.\n', '     * the global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".\n', '     * the maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".\n', '     */\n', '    function _generalExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {\n', '        uint256 xi = _x;\n', '        uint256 res = 0;\n', '\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x3442c4e6074a82f1797f72ac0000000; // add x^02 * (33! / 02!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x116b96f757c380fb287fd0e40000000; // add x^03 * (33! / 03!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x045ae5bdd5f0e03eca1ff4390000000; // add x^04 * (33! / 04!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00defabf91302cd95b9ffda50000000; // add x^05 * (33! / 05!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x002529ca9832b22439efff9b8000000; // add x^06 * (33! / 06!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00054f1cf12bd04e516b6da88000000; // add x^07 * (33! / 07!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000a9e39e257a09ca2d6db51000000; // add x^08 * (33! / 08!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x000012e066e7b839fa050c309000000; // add x^09 * (33! / 09!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x000000000057e22099c030d94100000; // add x^15 * (33! / 15!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000000057e22099c030d9410000; // add x^16 * (33! / 16!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000000000052b6b54569976310000; // add x^17 * (33! / 17!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000000000004985f67696bf748000; // add x^18 * (33! / 18!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000000000000031880f2214b6e000; // add x^20 * (33! / 20!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000000000000001317c70077000; // add x^23 * (33! / 23!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000000000000000000cba84aafa00; // add x^24 * (33! / 24!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000000000000000000082573a0a00; // add x^25 * (33! / 25!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000000000000000000005035ad900; // add x^26 * (33! / 26!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x000000000000000000000002f881b00; // add x^27 * (33! / 27!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000000000000000000001b29340; // add x^28 * (33! / 28!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x00000000000000000000000000efc40; // add x^29 * (33! / 29!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000000000000000000000007fe0; // add x^30 * (33! / 30!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000000000000000000000000420; // add x^31 * (33! / 31!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000000000000000000000000021; // add x^32 * (33! / 32!)\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x0000000000000000000000000000001; // add x^33 * (33! / 33!)\n', '\n', '        return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!\n', '    }\n', '\n', '    /**\n', '     * @dev computes log(x / FIXED_1) * FIXED_1\n', '     * Input range: FIXED_1 <= x <= OPT_LOG_MAX_VAL - 1\n', "     * Auto-generated via 'PrintFunctionOptimalLog.py'\n", '     * Detailed description:\n', '     * - Rewrite the input as a product of natural exponents and a single residual r, such that 1 < r < 2\n', '     * - The natural logarithm of each (pre-calculated) exponent is the degree of the exponent\n', '     * - The natural logarithm of r is calculated via Taylor series for log(1 + x), where x = r - 1\n', '     * - The natural logarithm of the input is calculated by summing up the intermediate results above\n', '     * - For example: log(250) = log(e^4 * e^1 * e^0.5 * 1.021692859) = 4 + 1 + 0.5 + log(1 + 0.021692859)\n', '     */\n', '    function optimalLog(uint256 x) internal pure returns (uint256) {\n', '        uint256 res = 0;\n', '\n', '        uint256 y;\n', '        uint256 z;\n', '        uint256 w;\n', '\n', '        if (x >= 0xd3094c70f034de4b96ff7d5b6f99fcd8) {\n', '            res += 0x40000000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0xd3094c70f034de4b96ff7d5b6f99fcd8;\n', '        } // add 1 / 2^1\n', '        if (x >= 0xa45af1e1f40c333b3de1db4dd55f29a7) {\n', '            res += 0x20000000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0xa45af1e1f40c333b3de1db4dd55f29a7;\n', '        } // add 1 / 2^2\n', '        if (x >= 0x910b022db7ae67ce76b441c27035c6a1) {\n', '            res += 0x10000000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0x910b022db7ae67ce76b441c27035c6a1;\n', '        } // add 1 / 2^3\n', '        if (x >= 0x88415abbe9a76bead8d00cf112e4d4a8) {\n', '            res += 0x08000000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0x88415abbe9a76bead8d00cf112e4d4a8;\n', '        } // add 1 / 2^4\n', '        if (x >= 0x84102b00893f64c705e841d5d4064bd3) {\n', '            res += 0x04000000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0x84102b00893f64c705e841d5d4064bd3;\n', '        } // add 1 / 2^5\n', '        if (x >= 0x8204055aaef1c8bd5c3259f4822735a2) {\n', '            res += 0x02000000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0x8204055aaef1c8bd5c3259f4822735a2;\n', '        } // add 1 / 2^6\n', '        if (x >= 0x810100ab00222d861931c15e39b44e99) {\n', '            res += 0x01000000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0x810100ab00222d861931c15e39b44e99;\n', '        } // add 1 / 2^7\n', '        if (x >= 0x808040155aabbbe9451521693554f733) {\n', '            res += 0x00800000000000000000000000000000;\n', '            x = (x * FIXED_1) / 0x808040155aabbbe9451521693554f733;\n', '        } // add 1 / 2^8\n', '\n', '        z = y = x - FIXED_1;\n', '        w = (y * y) / FIXED_1;\n', '        res += (z * (0x100000000000000000000000000000000 - y)) / 0x100000000000000000000000000000000;\n', '        z = (z * w) / FIXED_1; // add y^01 / 01 - y^02 / 02\n', '        res += (z * (0x0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa - y)) / 0x200000000000000000000000000000000;\n', '        z = (z * w) / FIXED_1; // add y^03 / 03 - y^04 / 04\n', '        res += (z * (0x099999999999999999999999999999999 - y)) / 0x300000000000000000000000000000000;\n', '        z = (z * w) / FIXED_1; // add y^05 / 05 - y^06 / 06\n', '        res += (z * (0x092492492492492492492492492492492 - y)) / 0x400000000000000000000000000000000;\n', '        z = (z * w) / FIXED_1; // add y^07 / 07 - y^08 / 08\n', '        res += (z * (0x08e38e38e38e38e38e38e38e38e38e38e - y)) / 0x500000000000000000000000000000000;\n', '        z = (z * w) / FIXED_1; // add y^09 / 09 - y^10 / 10\n', '        res += (z * (0x08ba2e8ba2e8ba2e8ba2e8ba2e8ba2e8b - y)) / 0x600000000000000000000000000000000;\n', '        z = (z * w) / FIXED_1; // add y^11 / 11 - y^12 / 12\n', '        res += (z * (0x089d89d89d89d89d89d89d89d89d89d89 - y)) / 0x700000000000000000000000000000000;\n', '        z = (z * w) / FIXED_1; // add y^13 / 13 - y^14 / 14\n', '        res += (z * (0x088888888888888888888888888888888 - y)) / 0x800000000000000000000000000000000; // add y^15 / 15 - y^16 / 16\n', '\n', '        return res;\n', '    }\n', '\n', '    /**\n', '     * @dev computes e ^ (x / FIXED_1) * FIXED_1\n', '     * input range: 0 <= x <= OPT_EXP_MAX_VAL - 1\n', "     * auto-generated via 'PrintFunctionOptimalExp.py'\n", '     * Detailed description:\n', '     * - Rewrite the input as a sum of binary exponents and a single residual r, as small as possible\n', '     * - The exponentiation of each binary exponent is given (pre-calculated)\n', '     * - The exponentiation of r is calculated via Taylor series for e^x, where x = r\n', '     * - The exponentiation of the input is calculated by multiplying the intermediate results above\n', '     * - For example: e^5.521692859 = e^(4 + 1 + 0.5 + 0.021692859) = e^4 * e^1 * e^0.5 * e^0.021692859\n', '     */\n', '    function optimalExp(uint256 x) internal pure returns (uint256) {\n', '        uint256 res = 0;\n', '\n', '        uint256 y;\n', '        uint256 z;\n', '\n', '        z = y = x % 0x10000000000000000000000000000000; // get the input modulo 2^(-3)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x10e1b3be415a0000; // add y^02 * (20! / 02!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x05a0913f6b1e0000; // add y^03 * (20! / 03!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0168244fdac78000; // add y^04 * (20! / 04!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x004807432bc18000; // add y^05 * (20! / 05!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x000c0135dca04000; // add y^06 * (20! / 06!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0001b707b1cdc000; // add y^07 * (20! / 07!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x000036e0f639b800; // add y^08 * (20! / 08!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x00000618fee9f800; // add y^09 * (20! / 09!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0000009c197dcc00; // add y^10 * (20! / 10!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0000000e30dce400; // add y^11 * (20! / 11!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x000000012ebd1300; // add y^12 * (20! / 12!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0000000017499f00; // add y^13 * (20! / 13!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0000000001a9d480; // add y^14 * (20! / 14!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x00000000001c6380; // add y^15 * (20! / 15!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x000000000001c638; // add y^16 * (20! / 16!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0000000000001ab8; // add y^17 * (20! / 17!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x000000000000017c; // add y^18 * (20! / 18!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0000000000000014; // add y^19 * (20! / 19!)\n', '        z = (z * y) / FIXED_1;\n', '        res += z * 0x0000000000000001; // add y^20 * (20! / 20!)\n', '        res = res / 0x21c3677c82b40000 + y + FIXED_1; // divide by 20! and then add y^1 / 1! + y^0 / 0!\n', '\n', '        if ((x & 0x010000000000000000000000000000000) != 0)\n', '            res = (res * 0x1c3d6a24ed82218787d624d3e5eba95f9) / 0x18ebef9eac820ae8682b9793ac6d1e776; // multiply by e^2^(-3)\n', '        if ((x & 0x020000000000000000000000000000000) != 0)\n', '            res = (res * 0x18ebef9eac820ae8682b9793ac6d1e778) / 0x1368b2fc6f9609fe7aceb46aa619baed4; // multiply by e^2^(-2)\n', '        if ((x & 0x040000000000000000000000000000000) != 0)\n', '            res = (res * 0x1368b2fc6f9609fe7aceb46aa619baed5) / 0x0bc5ab1b16779be3575bd8f0520a9f21f; // multiply by e^2^(-1)\n', '        if ((x & 0x080000000000000000000000000000000) != 0)\n', '            res = (res * 0x0bc5ab1b16779be3575bd8f0520a9f21e) / 0x0454aaa8efe072e7f6ddbab84b40a55c9; // multiply by e^2^(+0)\n', '        if ((x & 0x100000000000000000000000000000000) != 0)\n', '            res = (res * 0x0454aaa8efe072e7f6ddbab84b40a55c5) / 0x00960aadc109e7a3bf4578099615711ea; // multiply by e^2^(+1)\n', '        if ((x & 0x200000000000000000000000000000000) != 0)\n', '            res = (res * 0x00960aadc109e7a3bf4578099615711d7) / 0x0002bf84208204f5977f9a8cf01fdce3d; // multiply by e^2^(+2)\n', '        if ((x & 0x400000000000000000000000000000000) != 0)\n', '            res = (res * 0x0002bf84208204f5977f9a8cf01fdc307) / 0x0000003c6ab775dd0b95b4cbee7e65d11; // multiply by e^2^(+3)\n', '\n', '        return res;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.6.0;\n', '\n', 'import { PowerImplLib } from "./PowerImplLib.sol";\n', '\n', 'library PowerLib {\n', '  function power(uint256 baseN, uint256 baseD, uint8 expN, uint8 expD) external pure returns (uint256, uint8) {\n', '    return PowerImplLib._power(baseN, baseD, expN, expD);\n', '  }\n', '}\n', '\n', '{\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "metadata": {\n', '    "bytecodeHash": "ipfs",\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 1000\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']