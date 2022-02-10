['/**\n', ' * SPDX-License-Identifier: UNLICENSED\n', ' */\n', 'pragma solidity 0.6.10;\n', '\n', '/**\n', ' * @dev Interface of the Chainlink aggregator\n', ' */\n', 'interface AggregatorInterface {\n', '    function decimals() external view returns (uint8);\n', '\n', '    function description() external view returns (string memory);\n', '\n', '    function version() external view returns (uint256);\n', '\n', '    // getRoundData and latestRoundData should both raise "No data present"\n', '    // if they do not have data to report, instead of returning unset values\n', '    // which could be misinterpreted as actual reported values.\n', '    function getRoundData(uint80 _roundId)\n', '        external\n', '        view\n', '        returns (\n', '            uint80 roundId,\n', '            int256 answer,\n', '            uint256 startedAt,\n', '            uint256 updatedAt,\n', '            uint80 answeredInRound\n', '        );\n', '\n', '    function latestRoundData()\n', '        external\n', '        view\n', '        returns (\n', '            uint80 roundId,\n', '            int256 answer,\n', '            uint256 startedAt,\n', '            uint256 updatedAt,\n', '            uint80 answeredInRound\n', '        );\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.6.10;\n', '\n', 'interface OpynPricerInterface {\n', '    function getPrice() external view returns (uint256);\n', '\n', '    function getHistoricalPrice(uint80 _roundId) external view returns (uint256, uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.6.10;\n', '\n', 'interface OracleInterface {\n', '    function isLockingPeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);\n', '\n', '    function isDisputePeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);\n', '\n', '    function getExpiryPrice(address _asset, uint256 _expiryTimestamp) external view returns (uint256, bool);\n', '\n', '    function getDisputer() external view returns (address);\n', '\n', '    function getPricer(address _asset) external view returns (address);\n', '\n', '    function getPrice(address _asset) external view returns (uint256);\n', '\n', '    function getPricerLockingPeriod(address _pricer) external view returns (uint256);\n', '\n', '    function getPricerDisputePeriod(address _pricer) external view returns (uint256);\n', '\n', '    function getChainlinkRoundData(address _asset, uint80 _roundId) external view returns (uint256, uint256);\n', '\n', '    // Non-view function\n', '\n', '    function setAssetPricer(address _asset, address _pricer) external;\n', '\n', '    function setLockingPeriod(address _pricer, uint256 _lockingPeriod) external;\n', '\n', '    function setDisputePeriod(address _pricer, uint256 _disputePeriod) external;\n', '\n', '    function setExpiryPrice(\n', '        address _asset,\n', '        uint256 _expiryTimestamp,\n', '        uint256 _price\n', '    ) external;\n', '\n', '    function disputeExpiryPrice(\n', '        address _asset,\n', '        uint256 _expiryTimestamp,\n', '        uint256 _price\n', '    ) external;\n', '\n', '    function setDisputer(address _disputer) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '// openzeppelin-contracts v3.1.0\n', '\n', '/* solhint-disable */\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.6.10;\n', '\n', 'import {AggregatorInterface} from "../interfaces/AggregatorInterface.sol";\n', 'import {OracleInterface} from "../interfaces/OracleInterface.sol";\n', 'import {OpynPricerInterface} from "../interfaces/OpynPricerInterface.sol";\n', 'import {SafeMath} from "../packages/oz/SafeMath.sol";\n', '\n', '/**\n', ' * @notice A Pricer contract for one asset as reported by Chainlink\n', ' */\n', 'contract ChainLinkPricer is OpynPricerInterface {\n', '    using SafeMath for uint256;\n', '\n', '    /// @dev base decimals\n', '    uint256 internal constant BASE = 8;\n', '\n', '    /// @notice chainlink response decimals\n', '    uint256 public aggregatorDecimals;\n', '\n', '    /// @notice the opyn oracle address\n', '    OracleInterface public oracle;\n', '    /// @notice the aggregator for an asset\n', '    AggregatorInterface public aggregator;\n', '\n', '    /// @notice asset that this pricer will a get price for\n', '    address public asset;\n', '    /// @notice bot address that is allowed to call setExpiryPriceInOracle\n', '    address public bot;\n', '\n', '    /**\n', '     * @param _bot priveleged address that can call setExpiryPriceInOracle\n', '     * @param _asset asset that this pricer will get a price for\n', '     * @param _aggregator Chainlink aggregator contract for the asset\n', '     * @param _oracle Opyn Oracle address\n', '     */\n', '    constructor(\n', '        address _bot,\n', '        address _asset,\n', '        address _aggregator,\n', '        address _oracle\n', '    ) public {\n', '        require(_bot != address(0), "ChainLinkPricer: Cannot set 0 address as bot");\n', '        require(_oracle != address(0), "ChainLinkPricer: Cannot set 0 address as oracle");\n', '        require(_aggregator != address(0), "ChainLinkPricer: Cannot set 0 address as aggregator");\n', '\n', '        bot = _bot;\n', '        oracle = OracleInterface(_oracle);\n', '        aggregator = AggregatorInterface(_aggregator);\n', '        asset = _asset;\n', '\n', '        aggregatorDecimals = uint256(aggregator.decimals());\n', '    }\n', '\n', '    /**\n', '     * @notice modifier to check if sender address is equal to bot address\n', '     */\n', '    modifier onlyBot() {\n', '        require(msg.sender == bot, "ChainLinkPricer: unauthorized sender");\n', '\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @notice set the expiry price in the oracle, can only be called by Bot address\n', '     * @dev a roundId must be provided to confirm price validity, which is the first Chainlink price provided after the expiryTimestamp\n', '     * @param _expiryTimestamp expiry to set a price for\n', '     * @param _roundId the first roundId after expiryTimestamp\n', '     */\n', '    function setExpiryPriceInOracle(uint256 _expiryTimestamp, uint80 _roundId) external onlyBot {\n', '        (, int256 price, , uint256 roundTimestamp, ) = aggregator.getRoundData(_roundId);\n', '\n', '        require(_expiryTimestamp <= roundTimestamp, "ChainLinkPricer: invalid roundId");\n', '\n', '        oracle.setExpiryPrice(asset, _expiryTimestamp, uint256(price));\n', '    }\n', '\n', '    /**\n', '     * @notice get the live price for the asset\n', '     * @dev overides the getPrice function in OpynPricerInterface\n', '     * @return price of the asset in USD, scaled by 1e8\n', '     */\n', '    function getPrice() external override view returns (uint256) {\n', '        (, int256 answer, , , ) = aggregator.latestRoundData();\n', '        require(answer > 0, "ChainLinkPricer: price is lower than 0");\n', "        // chainlink's answer is already 1e8\n", '        return _scaleToBase(uint256(answer));\n', '    }\n', '\n', '    /**\n', '     * @notice get historical chainlink price\n', '     * @param _roundId chainlink round id\n', '     * @return round price and timestamp\n', '     */\n', '    function getHistoricalPrice(uint80 _roundId) external override view returns (uint256, uint256) {\n', '        (, int256 price, , uint256 roundTimestamp, ) = aggregator.getRoundData(_roundId);\n', '        return (_scaleToBase(uint256(price)), roundTimestamp);\n', '    }\n', '\n', '    /**\n', '     * @notice scale aggregator response to base decimals (1e8)\n', '     * @param _price aggregator price\n', '     * @return price scaled to 1e8\n', '     */\n', '    function _scaleToBase(uint256 _price) internal view returns (uint256) {\n', '        if (aggregatorDecimals > BASE) {\n', '            uint256 exp = aggregatorDecimals.sub(BASE);\n', '            _price = _price.div(10**exp);\n', '        } else if (aggregatorDecimals < BASE) {\n', '            uint256 exp = BASE.sub(aggregatorDecimals);\n', '            _price = _price.mul(10**exp);\n', '        }\n', '\n', '        return _price;\n', '    }\n', '}\n', '\n', '{\n', '  "remappings": [],\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "libraries": {\n', '    "": {}\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']