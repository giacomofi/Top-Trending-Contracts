['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-03\n', '*/\n', '\n', '/*\n', "    .'''''''''''..     ..''''''''''''''''..       ..'''''''''''''''..\n", "    .;;;;;;;;;;;'.   .';;;;;;;;;;;;;;;;;;,.     .,;;;;;;;;;;;;;;;;;,.\n", '    .;;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;,.    .,;;;;;;;;;;;;;;;;;;,.\n', '    .;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.   .;;;;;;;;;;;;;;;;;;;;,.\n', "    ';;;;;;;;'.  .';;;;;;;;;;;;;;;;;;;;;;,. .';;;;;;;;;;;;;;;;;;;;;,.\n", "    ';;;;;,..   .';;;;;;;;;;;;;;;;;;;;;;;,..';;;;;;;;;;;;;;;;;;;;;;,.\n", "    ......     .';;;;;;;;;;;;;,'''''''''''.,;;;;;;;;;;;;;,'''''''''..\n", '              .,;;;;;;;;;;;;;.           .,;;;;;;;;;;;;;.\n', '             .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.\n', '            .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.\n', '           .,;;;;;;;;;;;;,.           .;;;;;;;;;;;;;,.     .....\n', "          .;;;;;;;;;;;;;'.         ..';;;;;;;;;;;;;'.    .',;;;;,'.\n", "        .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.   .';;;;;;;;;;.\n", "       .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.    .;;;;;;;;;;;,.\n", "      .,;;;;;;;;;;;;;'...........,;;;;;;;;;;;;;;.      .;;;;;;;;;;;,.\n", '     .,;;;;;;;;;;;;,..,;;;;;;;;;;;;;;;;;;;;;;;,.       ..;;;;;;;;;,.\n', "    .,;;;;;;;;;;;;,. .,;;;;;;;;;;;;;;;;;;;;;;,.          .',;;;,,..\n", '   .,;;;;;;;;;;;;,.  .,;;;;;;;;;;;;;;;;;;;;;,.              ....\n', "    ..',;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.\n", "       ..',;;;;'.    .,;;;;;;;;;;;;;;;;;;;'.\n", "          ...'..     .';;;;;;;;;;;;;;,,,'.\n", '                       ...............\n', '*/\n', '\n', '// https://github.com/trusttoken/smart-contracts\n', '// Dependency file: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/interface/ICrvPriceOracle.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', 'interface ICrvPriceOracle {\n', '    function usdToCrv(uint256 amount) external view returns (uint256);\n', '\n', '    function crvToUsd(uint256 amount) external view returns (uint256);\n', '}\n', '\n', '\n', '// Dependency file: @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol\n', '\n', '// pragma solidity >=0.6.0;\n', '\n', 'interface AggregatorV3Interface {\n', '\n', '  function decimals() external view returns (uint8);\n', '  function description() external view returns (string memory);\n', '  function version() external view returns (uint256);\n', '\n', '  // getRoundData and latestRoundData should both raise "No data present"\n', '  // if they do not have data to report, instead of returning unset values\n', '  // which could be misinterpreted as actual reported values.\n', '  function getRoundData(uint80 _roundId)\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '  function latestRoundData()\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '\n', '}\n', '\n', '\n', '// Root file: contracts/truefi/CrvPriceOracle.sol\n', '\n', 'pragma solidity 0.6.10;\n', '\n', '// import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";\n', '// import {ICrvPriceOracle} from "contracts/truefi/interface/ICrvPriceOracle.sol";\n', '// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";\n', '\n', 'contract CrvPriceOracle is ICrvPriceOracle {\n', '    AggregatorV3Interface internal crvPriceFeed;\n', '    AggregatorV3Interface internal ethPriceFeed;\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * Network: Mainnet\n', '     * Aggregator: CRV/ETH\n', '     * Address: 0x8a12Be339B0cD1829b91Adc01977caa5E9ac121e\n', '     * Network: Mainnet\n', '     * Aggregator: ETH/USD\n', '     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331\n', '     */\n', '    constructor() public {\n', '        crvPriceFeed = AggregatorV3Interface(0x8a12Be339B0cD1829b91Adc01977caa5E9ac121e);\n', '        ethPriceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);\n', '    }\n', '\n', '    /**\n', '     * @dev return the lastest price for CRV/USD with 18 decimals places\n', '     * @return CRV/USD price\n', '     */\n', '    function getLatestPrice() public view returns (uint256) {\n', '        (, int256 crvEthPrice, , , ) = crvPriceFeed.latestRoundData();\n', '        (, int256 ethPrice, , , ) = ethPriceFeed.latestRoundData();\n', '        uint256 crvPrice = (safeUint(crvEthPrice));\n', '        return crvPrice;\n', '    }\n', '\n', '    /**\n', '     * @dev converts from USD with 18 decimals to CRV with 18 decimals\n', '     * @param amount Amount in USD\n', '     * @return CRV value of USD input\n', '     */\n', '    function usdToCrv(uint256 amount) external override view returns (uint256) {\n', '        return amount.div(getLatestPrice());\n', '    }\n', '\n', '    /**\n', '     * @dev converts from CRV with 18 decimals to USD with 18 decimals\n', '     * @param amount Amount in CRV\n', '     * @return USD value of CRV input\n', '     */\n', '    function crvToUsd(uint256 amount) external override view returns (uint256) {\n', '        return amount.mul(getLatestPrice());\n', '    }\n', '\n', '    /**\n', '     * @dev convert int256 to uint256\n', '     * @param value to convert to uint\n', '     * @return the converted uint256 value\n', '     */\n', '    function safeUint(int256 value) internal pure returns (uint256) {\n', '        require(value >= 0, "CrvPriceChainLinkOracle: uint underflow");\n', '        return uint256(value);\n', '    }\n', '}']