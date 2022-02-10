['pragma solidity ^0.4.11;\n', '\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '    /**\n', '        constructor\n', '    */\n', '    function Utils() {\n', '    }\n', '\n', '    // verifies that an amount is greater than zero\n', '    modifier greaterThanZero(uint256 _amount) {\n', '        require(_amount > 0);\n', '        _;\n', '    }\n', '\n', '    // validates an address - currently only checks that it isn&#39;t null\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '/*\n', '    Standard Formula interface\n', '*/\n', 'contract IStandardFormula {\n', '    function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);\n', '    function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);\n', '}\n', '\n', 'contract StandardFormula is IStandardFormula, Utils {\n', '    string public version = &#39;0.2&#39;;\n', '\n', '    uint32 private constant MAX_CRR = 1000000;\n', '    uint256 private constant ONE = 1;\n', '    uint8 private constant MIN_PRECISION = 32;\n', '    uint8 private constant MAX_PRECISION = 127;\n', '\n', '    /**\n', '        The values below depend on MAX_PRECISION. If you choose to change it:\n', '        Apply the same change in file &#39;PrintIntScalingFactors.py&#39;, run it and paste the results below.\n', '    */\n', '    uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;\n', '    uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;\n', '    uint256 private constant MAX_NUM = 0x1ffffffffffffffffffffffffffffffff;\n', '\n', '    /**\n', '        The values below depend on MAX_PRECISION. If you choose to change it:\n', '        Apply the same change in file &#39;PrintLn2ScalingFactors.py&#39;, run it and paste the results below.\n', '    */\n', '    uint256 private constant LN2_MANTISSA = 0x2c5c85fdf473de6af278ece600fcbda;\n', '    uint8   private constant LN2_EXPONENT = 122;\n', '\n', '    /**\n', '        The values below depend on MIN_PRECISION and MAX_PRECISION. If you choose to change either one of them:\n', '        Apply the same change in file &#39;PrintFunctionStandardFormula.py&#39;, run it and paste the results below.\n', '    */\n', '    uint256[128] private maxExpArray;\n', '\n', '    function StandardFormula() {\n', '    //  maxExpArray[  0] = 0x60ffffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  1] = 0x5ebfffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  2] = 0x5cbfffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  3] = 0x5abfffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  4] = 0x58dfffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  5] = 0x56ffffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;\n', '    //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;\n', '    //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;\n', '    //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;\n', '    //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;\n', '    //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;\n', '    //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;\n', '    //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;\n', '        maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;\n', '        maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;\n', '        maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;\n', '        maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;\n', '        maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;\n', '        maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;\n', '        maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;\n', '        maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;\n', '        maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;\n', '        maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;\n', '        maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;\n', '        maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;\n', '        maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;\n', '        maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;\n', '        maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;\n', '        maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;\n', '        maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;\n', '        maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;\n', '        maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;\n', '        maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;\n', '        maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;\n', '        maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;\n', '        maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;\n', '        maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;\n', '        maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;\n', '        maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;\n', '        maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;\n', '        maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;\n', '        maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;\n', '        maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;\n', '        maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;\n', '        maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;\n', '        maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;\n', '        maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;\n', '        maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;\n', '        maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;\n', '        maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;\n', '        maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;\n', '        maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;\n', '        maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;\n', '        maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;\n', '        maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;\n', '        maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;\n', '        maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;\n', '        maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;\n', '        maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;\n', '        maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;\n', '        maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;\n', '        maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;\n', '        maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;\n', '        maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;\n', '        maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;\n', '        maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;\n', '        maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;\n', '        maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;\n', '        maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;\n', '        maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;\n', '        maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;\n', '        maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;\n', '        maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;\n', '        maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;\n', '        maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;\n', '        maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;\n', '        maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;\n', '        maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;\n', '        maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;\n', '        maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;\n', '        maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;\n', '        maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;\n', '        maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;\n', '        maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;\n', '        maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;\n', '        maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;\n', '        maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;\n', '        maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;\n', '        maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;\n', '        maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;\n', '        maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;\n', '        maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;\n', '        maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;\n', '        maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;\n', '        maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;\n', '        maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;\n', '        maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;\n', '        maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;\n', '        maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;\n', '        maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;\n', '        maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;\n', '        maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;\n', '        maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;\n', '        maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;\n', '        maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;\n', '        maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;\n', '        maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;\n', '        maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;\n', '        maxExpArray[127] = 0x006ae67b5f2f528d5f3189036ee0f27453;\n', '    }\n', '\n', '    /**\n', '        @dev given a token supply, reserve, CRR and a deposit amount (in the reserve token), calculates the return for a given change (in the main token)\n', '\n', '        Formula:\n', '        Return = _supply * ((1 + _depositAmount / _reserveBalance) ^ (_reserveRatio / 1000000) - 1)\n', '\n', '        @param _supply             token total supply\n', '        @param _reserveBalance     total reserve\n', '        @param _reserveRatio       constant reserve ratio, represented in ppm, 1-1000000\n', '        @param _depositAmount      deposit amount, in reserve token\n', '\n', '        @return purchase return amount\n', '    */\n', '    function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public constant returns (uint256) {\n', '        // validate input\n', '        require(_supply > 0 && _reserveBalance > 0 && _reserveRatio > 0 && _reserveRatio <= MAX_CRR);\n', '\n', '        // special case for 0 deposit amount\n', '        if (_depositAmount == 0)\n', '            return 0;\n', '\n', '        // special case if the CRR = 100%\n', '        if (_reserveRatio == MAX_CRR)\n', '            return safeMul(_supply, _depositAmount) / _reserveBalance;\n', '\n', '        uint256 baseN = safeAdd(_depositAmount, _reserveBalance);\n', '        var (result, precision) = power(baseN, _reserveBalance, _reserveRatio, MAX_CRR);\n', '        uint256 temp = safeMul(_supply, result) >> precision;\n', '        return temp - _supply;\n', '     }\n', '\n', '    /**\n', '        @dev given a token supply, reserve, CRR and a sell amount (in the main token), calculates the return for a given change (in the reserve token)\n', '\n', '        Formula:\n', '        Return = _reserveBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_reserveRatio / 1000000)))\n', '\n', '        @param _supply             token total supply\n', '        @param _reserveBalance     total reserve\n', '        @param _reserveRatio       constant reserve ratio, represented in ppm, 1-1000000\n', '        @param _sellAmount         sell amount, in the token itself\n', '\n', '        @return sale return amount\n', '    */\n', '    function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public constant returns (uint256) {\n', '        // validate input\n', '        require(_supply > 0 && _reserveBalance > 0 && _reserveRatio > 0 && _reserveRatio <= MAX_CRR && _sellAmount <= _supply);\n', '\n', '        // special case for 0 sell amount\n', '        if (_sellAmount == 0)\n', '            return 0;\n', '\n', '        // special case for selling the entire supply\n', '        if (_sellAmount == _supply)\n', '            return _reserveBalance;\n', '\n', '        // special case if the CRR = 100%\n', '        if (_reserveRatio == MAX_CRR)\n', '            return safeMul(_reserveBalance, _sellAmount) / _supply;\n', '\n', '        uint256 baseD = _supply - _sellAmount;\n', '        var (result, precision) = power(_supply, baseD, MAX_CRR, _reserveRatio);\n', '        uint256 temp1 = safeMul(_reserveBalance, result);\n', '        uint256 temp2 = _reserveBalance << precision;\n', '        return (temp1 - temp2) / result;\n', '    }\n', '\n', '    /**\n', '        General Description:\n', '            Determine a value of precision.\n', '            Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.\n', '            Return the result along with the precision used.\n', '        Detailed Description:\n', '            Instead of calculating "base ^ exp", we calculate "e ^ (ln(base) * exp)".\n', '            The value of "ln(base)" is represented with an integer slightly smaller than "ln(base) * 2 ^ precision".\n', '            The larger "precision" is, the more accurately this value represents the real value.\n', '            However, the larger "precision" is, the more bits are required in order to store this value.\n', '            And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").\n', '            This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".\n', '            Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.\n', '            This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.\n', '    */\n', '    function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) internal constant returns (uint256, uint8) {\n', '        uint256 lnBaseTimesExp = ln(_baseN, _baseD) * _expN / _expD;\n', '        uint8 precision = findPositionInMaxExpArray(lnBaseTimesExp);\n', '        return (fixedExp(lnBaseTimesExp >> (MAX_PRECISION - precision), precision), precision);\n', '    }\n', '\n', '    /**\n', '        Return floor(ln(numerator / denominator) * 2 ^ MAX_PRECISION), where:\n', '        - The numerator   is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1\n', '        - The denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1\n', '        - The output      is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)\n', '        This functions assumes that the numerator is larger than or equal to the denominator, because the output would be negative otherwise.\n', '    */\n', '    function ln(uint256 _numerator, uint256 _denominator) internal constant returns (uint256) {\n', '        assert(_numerator <= MAX_NUM);\n', '\n', '        uint256 res = 0;\n', '        uint256 x = _numerator * FIXED_1 / _denominator;\n', '\n', '        // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.\n', '        if (x >= FIXED_2) {\n', '            uint8 count = floorLog2(x / FIXED_1);\n', '            x >>= count; // now x < 2\n', '            res = count * FIXED_1;\n', '        }\n', '\n', '        // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.\n', '        if (x > FIXED_1) {\n', '            for (uint8 i = MAX_PRECISION; i > 0; --i) {\n', '                x = (x * x) / FIXED_1; // now 1 < x < 4\n', '                if (x >= FIXED_2) {\n', '                    x >>= 1; // now 1 < x < 2\n', '                    res += ONE << (i - 1);\n', '                }\n', '            }\n', '        }\n', '\n', '        return (res * LN2_MANTISSA) >> LN2_EXPONENT;\n', '    }\n', '\n', '    /**\n', '        Compute the largest integer smaller than or equal to the binary logarithm of the input.\n', '    */\n', '    function floorLog2(uint256 _n) internal constant returns (uint8) {\n', '        uint8 res = 0;\n', '\n', '        if (_n < 256) {\n', '            // At most 8 iterations\n', '            while (_n > 1) {\n', '                _n >>= 1;\n', '                res += 1;\n', '            }\n', '        }\n', '        else {\n', '            // Exactly 8 iterations\n', '            for (uint8 s = 128; s > 0; s >>= 1) {\n', '                if (_n >= (ONE << s)) {\n', '                    _n >>= s;\n', '                    res |= s;\n', '                }\n', '            }\n', '        }\n', '\n', '        return res;\n', '    }\n', '\n', '    /**\n', '        The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:\n', '        - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]\n', '        - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]\n', '    */\n', '    function findPositionInMaxExpArray(uint256 _x) internal constant returns (uint8) {\n', '        uint8 lo = MIN_PRECISION;\n', '        uint8 hi = MAX_PRECISION;\n', '\n', '        while (lo + 1 < hi) {\n', '            uint8 mid = (lo + hi) / 2;\n', '            if (maxExpArray[mid] >= _x)\n', '                lo = mid;\n', '            else\n', '                hi = mid;\n', '        }\n', '\n', '        if (maxExpArray[hi] >= _x)\n', '            return hi;\n', '        if (maxExpArray[lo] >= _x)\n', '            return lo;\n', '\n', '        assert(false);\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '        This function can be auto-generated by the script &#39;PrintFunctionFixedExp.py&#39;.\n', '        It approximates "e ^ x" via maclauren summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".\n', '        It returns "e ^ (x >> precision) << precision", that is, the result is upshifted for accuracy.\n', '        The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".\n', '        The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".\n', '    */\n', '    function fixedExp(uint256 _x, uint8 _precision) internal constant returns (uint256) {\n', '        uint256 xi = _x;\n', '        uint256 res = uint256(0xde1bc4d19efcac82445da75b00000000) << _precision;\n', '\n', '        res += xi * 0xde1bc4d19efcac82445da75b00000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x6f0de268cf7e5641222ed3ad80000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x2504a0cd9a7f7215b60f9be480000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x9412833669fdc856d83e6f920000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x1d9d4d714865f4de2b3fafea0000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x4ef8ce836bba8cfb1dff2a70000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0xb481d807d1aa66d04490610000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x16903b00fa354cda08920c2000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x281cdaac677b334ab9e732000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x402e2aad725eb8778fd85000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x5d5a6c9f31fe2396a2af000000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x7c7890d442a82f73839400000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x9931ed54034526b58e400000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0xaf147cf24ce150cf7e00000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0xbac08546b867cdaa200000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0xbac08546b867cdaa20000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0xafc441338061b2820000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x9c3cabbc0056d790000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x839168328705c30000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x694120286c049c000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x50319e98b3d2c000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x3a52a1e36b82000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x289286e0fce000;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x1b0c59eb53400;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x114f95b55400;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0xaa7210d200;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x650139600;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x39b78e80;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x1fd8080;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x10fbc0;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x8c40;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x462;\n', '        xi = (xi * _x) >> _precision;\n', '        res += xi * 0x22;\n', '\n', '        return res / 0xde1bc4d19efcac82445da75b00000000;\n', '    }\n', '}']