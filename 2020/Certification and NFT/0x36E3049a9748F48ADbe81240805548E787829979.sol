['/*\n', '\n', '    /     |  __    / ____|\n', '   /      | |__) | | |\n', '  / /    |  _  /  | |\n', ' / ____   | |    | |____\n', '/_/    _ |_|  _  _____|\n', '\n', '* ARC: impl/ChainLinkOracle.sol\n', '*\n', '* Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/impl/ChainLinkOracle.sol\n', '*\n', '* Contract Dependencies: \n', '*\t- IOracle\n', '* Libraries: \n', '*\t- Decimal\n', '*\t- Math\n', '*\t- SafeMath\n', '*\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2020 ARC\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/* ===============================================\n', '* Flattened with Solidifier by Coinage\n', '* \n', '* https://solidifier.coina.ge\n', '* ===============================================\n', '*/\n', '\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '\n', '/**\n', ' * @title Math\n', ' *\n', ' * Library for non-standard Math functions\n', ' */\n', 'library Math {\n', '    using SafeMath for uint256;\n', '\n', '    // ============ Library Functions ============\n', '\n', '    /*\n', '     * Return target * (numerator / denominator).\n', '     */\n', '    function getPartial(\n', '        uint256 target,\n', '        uint256 numerator,\n', '        uint256 denominator\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return target.mul(numerator).div(denominator);\n', '    }\n', '\n', '    function to128(\n', '        uint256 number\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint128)\n', '    {\n', '        uint128 result = uint128(number);\n', '        require(\n', '            result == number,\n', '            "Math: Unsafe cast to uint128"\n', '        );\n', '        return result;\n', '    }\n', '\n', '    function to96(\n', '        uint256 number\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint96)\n', '    {\n', '        uint96 result = uint96(number);\n', '        require(\n', '            result == number,\n', '            "Math: Unsafe cast to uint96"\n', '        );\n', '        return result;\n', '    }\n', '\n', '    function to32(\n', '        uint256 number\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint32)\n', '    {\n', '        uint32 result = uint32(number);\n', '        require(\n', '            result == number,\n', '            "Math: Unsafe cast to uint32"\n', '        );\n', '        return result;\n', '    }\n', '\n', '    function min(\n', '        uint256 a,\n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max(\n', '        uint256 a,\n', '        uint256 b\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return a > b ? a : b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '\n', '/**\n', ' * @title Decimal\n', ' *\n', ' * Library that defines a fixed-point number with 18 decimal places.\n', ' */\n', 'library Decimal {\n', '    using SafeMath for uint256;\n', '\n', '    // ============ Constants ============\n', '\n', '    uint256 constant BASE = 10**18;\n', '\n', '    // ============ Structs ============\n', '\n', '    struct D256 {\n', '        uint256 value;\n', '    }\n', '\n', '    // ============ Functions ============\n', '\n', '    function one()\n', '        internal\n', '        pure\n', '        returns (D256 memory)\n', '    {\n', '        return D256({ value: BASE });\n', '    }\n', '\n', '    function onePlus(\n', '        D256 memory d\n', '    )\n', '        internal\n', '        pure\n', '        returns (D256 memory)\n', '    {\n', '        return D256({ value: d.value.add(BASE) });\n', '    }\n', '\n', '    function mul(\n', '        uint256 target,\n', '        D256 memory d\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return Math.getPartial(target, d.value, BASE);\n', '    }\n', '\n', '    function mul(\n', '        D256 memory d1,\n', '        D256 memory d2\n', '    )\n', '        internal\n', '        pure\n', '        returns (D256 memory)\n', '    {\n', '        return Decimal.D256({ value: Math.getPartial(d1.value, d2.value, BASE) });\n', '    }\n', '\n', '    function div(\n', '        uint256 target,\n', '        D256 memory d\n', '    )\n', '        internal\n', '        pure\n', '        returns (uint256)\n', '    {\n', '        return Math.getPartial(target, BASE, d.value);\n', '    }\n', '\n', '    function add(\n', '        D256 memory d,\n', '        uint256 amount\n', '    )\n', '        internal\n', '        pure\n', '        returns (D256 memory)\n', '    {\n', '        return D256({ value: d.value.add(amount) });\n', '    }\n', '\n', '    function sub(\n', '        D256 memory d,\n', '        uint256 amount\n', '    )\n', '        internal\n', '        pure\n', '        returns (D256 memory)\n', '    {\n', '        return D256({ value: d.value.sub(amount) });\n', '    }\n', '\n', '}\n', '\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '\n', 'interface IOracle {\n', '\n', '    function fetchCurrentPrice()\n', '        external\n', '        view\n', '        returns (Decimal.D256 memory);\n', '\n', '}\n', '\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '\n', 'interface IChainLinkAggregator {\n', '  function latestAnswer() external view returns (int256);\n', '  function latestTimestamp() external view returns (uint256);\n', '  function latestRound() external view returns (uint256);\n', '  function getAnswer(uint256 roundId) external view returns (int256);\n', '  function getTimestamp(uint256 roundId) external view returns (uint256);\n', '\n', '  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);\n', '  event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);\n', '}\n', '\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '\n', 'contract ChainLinkOracle is IOracle {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    IChainLinkAggregator public chainLinkAggregator;\n', '\n', '    uint256 constant public CHAIN_LINK_DECIMALS = 10**8;\n', '\n', '    constructor(address _chainLinkAggregator) public {\n', '        chainLinkAggregator = IChainLinkAggregator(_chainLinkAggregator);\n', '    }\n', '\n', '    function fetchCurrentPrice()\n', '        external\n', '        view\n', '        returns (Decimal.D256 memory)\n', '    {\n', '        return Decimal.D256({\n', '            value: uint256(chainLinkAggregator.latestAnswer()).mul(uint256(10**10))\n', '        });\n', '    }\n', '\n', '}']