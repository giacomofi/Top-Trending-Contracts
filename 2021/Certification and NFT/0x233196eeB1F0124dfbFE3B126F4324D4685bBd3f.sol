['pragma solidity ^0.6.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', '// proof of concept for keeping score based on different contracts that can add to it with right role\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address tokenOwner)\n', '        external\n', '        view\n', '        returns (uint256 balance);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '}\n', '\n', 'interface IMasterChef {\n', '    struct UserInfo {\n', '        uint256 amount;\n', '        uint256 rewardDebt;\n', '    }\n', '\n', '    function userInfo(uint256 _poolId, address _user)\n', '        external\n', '        view\n', '        returns (IMasterChef.UserInfo memory);\n', '}\n', '\n', 'contract GetVotes {\n', '    using SafeMath for uint256;\n', '    IERC20 public muse = IERC20(0xB6Ca7399B4F9CA56FC27cBfF44F4d2e4Eef1fc81);\n', '    IERC20 public uniLp = IERC20(0x20d2C17d1928EF4290BF17F922a10eAa2770BF43);\n', '    IMasterChef public masterChef = IMasterChef(0x8aFc8Ade73393728d548d8Ca4Fd7Bde76C354f28);\n', '\n', '    function getVotes(address _user) public view returns (uint256) {\n', '        uint256 userMuseBalance = muse.balanceOf(_user);\n', '        // lp tokens from user on masterchef\n', '        uint256 userLpTokens = masterChef.userInfo(0, _user).amount;\n', '        //total supply of of muse in lp\n', '        uint256 museInLpPool = muse.balanceOf(address(uniLp));\n', '        //total supply of lp tokens\n', '        uint256 lpTokensTotalSupply = uniLp.totalSupply();\n', '        // do calc for uniswap\n', '        uint256 museFromStake = museInLpPool.div(lpTokensTotalSupply).mul(userLpTokens);\n', '        return (userMuseBalance.add(museFromStake).div(1 ether));\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}']