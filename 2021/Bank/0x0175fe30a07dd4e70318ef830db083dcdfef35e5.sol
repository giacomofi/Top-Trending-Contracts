['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.6.12;\n', '\n', 'import "./AggregatorV3Interface.sol";\n', 'import "./SafeMath.sol";\n', 'import "./HoldefiOwnable.sol";\n', '\n', 'interface ERC20DecimalInterface {\n', '    function decimals () external view returns(uint256 res);\n', '}\n', '/// @title HoldefiPrices contract\n', '/// @author Holdefi Team\n', '/// @notice This contract is for getting tokens price\n', '/// @dev This contract uses Chainlink Oracle to get the tokens price\n', '/// @dev The address of ETH asset considered as 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE\n', '/// @dev Error codes description: \n', '///     E01: Asset should not be ETH\n', 'contract HoldefiPrices is HoldefiOwnable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    address constant private ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    uint256 constant private valueDecimals = 30;\n', '\n', '    struct Asset {\n', '        uint256 decimals;\n', '        AggregatorV3Interface priceContract;\n', '    }\n', '   \n', '    mapping(address => Asset) public assets;\n', '\n', '    /// @notice Event emitted when a new price aggregator is set for an asset\n', '    event NewPriceAggregator(address indexed asset, uint256 decimals, address priceAggregator);\n', '\n', '\t/// @notice Initializes ETH decimals\n', '    constructor() public {\n', '        assets[ethAddress].decimals = 18;\n', '    }\n', '\n', '    /// @notice You cannot send ETH to this contract\n', '    receive() payable external {\n', '        revert();\n', '    }\n', '\n', '    /// @notice Gets price of selected asset from Chainlink\n', '\t/// @dev The ETH price is assumed to be 1\n', '\t/// @param asset Address of the given asset\n', '    /// @return price Price of the given asset\n', '    /// @return priceDecimals Decimals of the given asset\n', '    function getPrice(address asset) public view returns (uint256 price, uint256 priceDecimals) {\n', '        if (asset == ethAddress){\n', '            price = 1;\n', '            priceDecimals = 0;\n', '        }\n', '        else {\n', '            (,int aggregatorPrice,,,) = assets[asset].priceContract.latestRoundData();\n', '            priceDecimals = assets[asset].priceContract.decimals();\n', '            if (aggregatorPrice > 0) {\n', '                price = uint256(aggregatorPrice);\n', '            }\n', '            else {\n', '                revert();\n', '            }\n', '        }\n', '    }\n', '\n', '    /// @notice Sets price aggregator for the given asset \n', '\t/// @param asset Address of the given asset\n', '    /// @param decimals Decimals of the given asset\n', "    /// @param priceContractAddress Address of asset's price aggregator\n", '    function setPriceAggregator(address asset, uint256 decimals, AggregatorV3Interface priceContractAddress)\n', '        external\n', '        onlyOwner\n', '    { \n', '        require (asset != ethAddress, "E01");\n', '        assets[asset].priceContract = priceContractAddress;\n', '\n', '        try ERC20DecimalInterface(asset).decimals() returns (uint256 tokenDecimals) {\n', '            assets[asset].decimals = tokenDecimals;\n', '        }\n', '        catch {\n', '            assets[asset].decimals = decimals;\n', '        }\n', '        emit NewPriceAggregator(asset, assets[asset].decimals, address(priceContractAddress));\n', '    }\n', '\n', '    /// @notice Calculates the given asset value based on the given amount \n', '\t/// @param asset Address of the given asset\n', '    /// @param amount Amount of the given asset\n', '    /// @return res Value calculated for asset based on the price and given amount\n', '    function getAssetValueFromAmount(address asset, uint256 amount) external view returns (uint256 res) {\n', '        uint256 decimalsDiff;\n', '        uint256 decimalsScale;\n', '\n', '        (uint256 price, uint256 priceDecimals) = getPrice(asset);\n', '        uint256 calValueDecimals = priceDecimals.add(assets[asset].decimals);\n', '        if (valueDecimals > calValueDecimals){\n', '            decimalsDiff = valueDecimals.sub(calValueDecimals);\n', '            decimalsScale =  10 ** decimalsDiff;\n', '            res = amount.mul(price).mul(decimalsScale);\n', '        }\n', '        else {\n', '            decimalsDiff = calValueDecimals.sub(valueDecimals);\n', '            decimalsScale =  10 ** decimalsDiff;\n', '            res = amount.mul(price).div(decimalsScale);\n', '        }   \n', '    }\n', '\n', '    /// @notice Calculates the given amount based on the given asset value\n', '    /// @param asset Address of the given asset\n', '    /// @param value Value of the given asset\n', '    /// @return res Amount calculated for asset based on the price and given value\n', '    function getAssetAmountFromValue(address asset, uint256 value) external view returns (uint256 res) {\n', '        uint256 decimalsDiff;\n', '        uint256 decimalsScale;\n', '\n', '        (uint256 price, uint256 priceDecimals) = getPrice(asset);\n', '        uint256 calValueDecimals = priceDecimals.add(assets[asset].decimals);\n', '        if (valueDecimals > calValueDecimals){\n', '            decimalsDiff = valueDecimals.sub(calValueDecimals);\n', '            decimalsScale =  10 ** decimalsDiff;\n', '            res = value.div(decimalsScale).div(price);\n', '        }\n', '        else {\n', '            decimalsDiff = calValueDecimals.sub(valueDecimals);\n', '            decimalsScale =  10 ** decimalsDiff;\n', '            res = value.mul(decimalsScale).div(price);\n', '        }   \n', '    }\n', '}']