['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'interface AggregatorInterface {\n', '      function latestAnswer() external view returns (int256);\n', '      function latestTimestamp() external view returns (uint256);\n', '      function latestRound() external view returns (uint256);\n', '      function getAnswer(uint256 roundId) external view returns (int256);\n', '      function getTimestamp(uint256 roundId) external view returns (uint256);\n', '}\n', '\n', 'interface AggregatorV3Interface {\n', '\n', '      function decimals() external view returns (uint8);\n', '      function description() external view returns (string memory);\n', '      function version() external view returns (uint256);\n', '\n', '      // getRoundData and latestRoundData should both raise "No data present"\n', '      // if they do not have data to report, instead of returning unset values\n', '      // which could be misinterpreted as actual reported values.\n', '      function getRoundData(uint80 _roundId)\n', '            external\n', '            view\n', '            returns (\n', '                  uint80 roundId,\n', '                  int256 answer,\n', '                  uint256 startedAt,\n', '                  uint256 updatedAt,\n', '                  uint80 answeredInRound\n', '            );\n', '      function latestRoundData()\n', '            external\n', '            view\n', '            returns (\n', '                  uint80 roundId,\n', '                  int256 answer,\n', '                  uint256 startedAt,\n', '                  uint256 updatedAt,\n', '                  uint80 answeredInRound\n', '            );\n', '}\n', '\n', 'interface AggregatorV2V3Interface is AggregatorInterface, AggregatorV3Interface\n', '{\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'interface IStableSwap3PoolOracle {\n', '    function getEthereumPrice() external view returns (uint256);\n', '    function getMinimumPrice() external view returns (uint256);\n', '    function getSafeAnswer(address) external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', 'import "./IStableSwap3PoolOracle.sol";\n', 'import "../interfaces/Chainlink.sol";\n', '\n', 'contract StableSwap3PoolOracle is IStableSwap3PoolOracle {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public constant MAX_ROUND_TIME = 1 hours;\n', '    uint256 public constant MAX_STALE_ANSWER = 24 hours;\n', '    uint256 public constant ETH_USD_MUL = 1e10; // ETH-USD feed is to 8 decimals\n', '\n', '    address public ethUsd;\n', '    address[3] public feeds;\n', '\n', '    constructor(\n', '        address _feedETHUSD,\n', '        address _feedDAIETH,\n', '        address _feedUSDCETH,\n', '        address _feedUSDTETH\n', '    )\n', '        public\n', '    {\n', '        ethUsd = _feedETHUSD;\n', '        feeds[0] = _feedDAIETH;\n', '        feeds[1] = _feedUSDCETH;\n', '        feeds[2] = _feedUSDTETH;\n', '    }\n', '\n', '    /**\n', '     * @notice Retrieves the current price of ETH/USD as provided by Chainlink\n', '     * @dev Reverts if the answer from Chainlink is not safe\n', '     */\n', '    function getEthereumPrice() external view override returns (uint256 _price) {\n', '        _price = getSafeAnswer(ethUsd);\n', '        require(_price > 0, "!getEthereumPrice");\n', '        _price = _price.mul(ETH_USD_MUL);\n', '\n', '    }\n', '\n', '    /**\n', '     * @notice Retrieves the minimum price of the 3pool tokens as provided by Chainlink\n', '     * @dev Reverts if none of the Chainlink nodes are safe\n', '     */\n', '    function getMinimumPrice() external view override returns (uint256 _minPrice) {\n', '        for (uint8 i = 0; i < 3; i++) {\n', '            // get the safe answer from Chainlink\n', '            uint256 _answer = getSafeAnswer(feeds[i]);\n', '\n', '            // store the first iteration regardless (handle that later if 0)\n', '            // otherwise,check that _answer is greater than 0 and only store it if less\n', '            // than the previously observed price\n', '            if (i == 0 || (_answer > 0 && _answer < _minPrice)) {\n', '                _minPrice = _answer;\n', '            }\n', '        }\n', '\n', "        // if we couldn't get a valid price from any of the Chainlink feeds,\n", '        // revert because nothing is safe\n', '        require(_minPrice > 0, "!getMinimumPrice");\n', '    }\n', '\n', '    /**\n', '     * @notice Get and check the answer provided by Chainlink\n', '     * @param _feed The address of the Chainlink price feed\n', '     */\n', '    function getSafeAnswer(address _feed) public view override returns (uint256) {\n', '        (\n', '            uint80 roundId,\n', '            int256 answer,\n', '            uint256 startedAt,\n', '            uint256 updatedAt,\n', '            uint80 answeredInRound\n', '        ) = AggregatorV3Interface(_feed).latestRoundData();\n', '\n', '        // latest round is carried over from previous round\n', '        if (answeredInRound < roundId) {\n', '            return 0;\n', '        }\n', '\n', '        // latest answer is stale\n', '        // solhint-disable-next-line not-rely-on-time\n', '        if (updatedAt < block.timestamp.sub(MAX_STALE_ANSWER)) {\n', '            return 0;\n', '        }\n', '\n', '        // round has taken too long to collect answers\n', '        if (updatedAt.sub(startedAt) > MAX_ROUND_TIME) {\n', '            return 0;\n', '        }\n', '\n', '        // Chainlink already rejects answers outside of a range (like what would cause\n', '        // a negative answer)\n', '        return uint256(answer);\n', '    }\n', '}']