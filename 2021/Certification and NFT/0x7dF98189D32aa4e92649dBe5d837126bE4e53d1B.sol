['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-12\n', '*/\n', '\n', '// File: @chainlink/contracts/src/v0.5/interfaces/AggregatorV3Interface.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface AggregatorV3Interface {\n', '\n', '  function decimals() external view returns (uint8);\n', '  function description() external view returns (string memory);\n', '  function version() external view returns (uint256);\n', '\n', '  // getRoundData and latestRoundData should both raise "No data present"\n', '  // if they do not have data to report, instead of returning unset values\n', '  // which could be misinterpreted as actual reported values.\n', '  function getRoundData(uint80 _roundId)\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '  function latestRoundData()\n', '    external\n', '    view\n', '    returns (\n', '      uint80 roundId,\n', '      int256 answer,\n', '      uint256 startedAt,\n', '      uint256 updatedAt,\n', '      uint80 answeredInRound\n', '    );\n', '\n', '}\n', '\n', '// File: contracts/price/ChainlinkService.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', 'contract ChainlinkService {  \n', '  \n', '    function getLatestPrice(address feedAddress) \n', '        public \n', '        view \n', '        returns (int, uint, uint8) \n', '    {\n', '        AggregatorV3Interface priceFeed = AggregatorV3Interface(feedAddress);\n', '        ( ,int price, ,uint timeStamp, ) = priceFeed.latestRoundData();\n', '        uint8 decimal = priceFeed.decimals();\n', '        return (price, timeStamp, decimal);\n', '    }\n', '}\n', '\n', '// File: contracts/external/YieldsterVaultMath.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', '/**\n', ' * @title YieldsterVaultMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' * Renamed from SafeMath to YieldsterVaultMath to avoid conflicts\n', ' * TODO: remove once open zeppelin update to solc 0.5.0\n', ' */\n', 'library YieldsterVaultMath{\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '\n', '\n', '  /**\n', '  * @dev Returns the largest of two numbers.\n', '  */\n', '  function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '}\n', '\n', '// File: contracts/interfaces/IRegistry.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', 'interface IRegistry {\n', '    \n', '    function get_virtual_price_from_lp_token(address) external view returns(uint256);\n', '\n', '}\n', '\n', '// File: contracts/interfaces/yearn/IVault.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', 'interface IVault {\n', '    function token() external view returns (address);\n', '\n', '    function underlying() external view returns (address);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function controller() external view returns (address);\n', '\n', '    function governance() external view returns (address);\n', '\n', '    function getPricePerFullShare() external view returns (uint256);\n', '\n', '    function deposit(uint256) external;\n', '\n', '    function depositAll() external;\n', '\n', '    function withdraw(uint256) external;\n', '\n', '    function withdrawAll() external;\n', '}\n', '\n', '// File: contracts/interfaces/IYieldsterVault.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', 'interface IYieldsterVault {\n', '    \n', '    function tokenValueInUSD() external view returns(uint256);\n', '\n', '}\n', '\n', '// File: contracts/interfaces/IYieldsterStrategy.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', 'interface IYieldsterStrategy {\n', '    \n', '    function tokenValueInUSD() external view returns(uint256);\n', '\n', '}\n', '\n', '// File: contracts/price/PriceModule.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract PriceModule is ChainlinkService\n', '{\n', '\n', '    using YieldsterVaultMath for uint256;\n', '    \n', '    address public priceModuleManager;\n', '    \n', '    address public curveRegistry;\n', '\n', '    struct Token {\n', '        address feedAddress;\n', '        uint256 tokenType;\n', '        bool created;\n', '    }\n', '\n', '    mapping(address => Token) tokens;\n', '\n', '    constructor(address _curveRegistry)\n', '    public\n', '    {\n', '        priceModuleManager = msg.sender;\n', '        curveRegistry = _curveRegistry;\n', '    }\n', '\n', '    function setManager(address _manager)\n', '        external\n', '    {\n', '        require(msg.sender == priceModuleManager, "Not Authorized");\n', '        priceModuleManager = _manager;\n', '    }\n', '\n', '    function addToken(\n', '        address _tokenAddress, \n', '        address _feedAddress, \n', '        uint256 _tokenType\n', '    )\n', '    external\n', '    {\n', '        require(msg.sender == priceModuleManager, "Not Authorized");\n', '        Token memory newToken = Token({ feedAddress:_feedAddress, tokenType: _tokenType, created:true});\n', '        tokens[_tokenAddress] = newToken;\n', '    }\n', '\n', '    function setCurveRegistry(address _curveRegistry)\n', '        external\n', '    {\n', '        require(msg.sender == priceModuleManager, "Not Authorized");\n', '        curveRegistry = _curveRegistry;\n', '    }\n', '\n', '\n', '    function getUSDPrice(address _tokenAddress) \n', '        public \n', '        view\n', '        returns(uint256)\n', '    {\n', '        require(tokens[_tokenAddress].created, "Token not present");\n', '\n', '        if(tokens[_tokenAddress].tokenType == 1) {\n', '            (int price, , uint8 decimals) = getLatestPrice(tokens[_tokenAddress].feedAddress);\n', '\n', '            if(decimals < 18) {\n', '                return (uint256(price)).mul(10 ** uint256(18 - decimals));\n', '            }\n', '            else if (decimals > 18) {\n', '                return (uint256(price)).div(uint256(decimals - 18));\n', '            }\n', '            else {\n', '                return uint256(price);\n', '            }\n', '\n', '        } else if(tokens[_tokenAddress].tokenType == 2) {\n', '            return IRegistry(curveRegistry).get_virtual_price_from_lp_token(_tokenAddress);\n', '\n', '        } else if(tokens[_tokenAddress].tokenType == 3) {\n', '            address token = IVault(_tokenAddress).token();\n', '            uint256 tokenPrice = getUSDPrice(token);\n', '            return (tokenPrice.mul(IVault(_tokenAddress).getPricePerFullShare())).div(1e18);\n', '\n', '        } else if(tokens[_tokenAddress].tokenType == 4) {\n', '            return IYieldsterStrategy(_tokenAddress).tokenValueInUSD();\n', '\n', '        } else if(tokens[_tokenAddress].tokenType == 5) {\n', '            return IYieldsterVault(_tokenAddress).tokenValueInUSD();\n', '\n', '        } else {\n', '            revert("Token not present");\n', '        }\n', '    }\n', '}']