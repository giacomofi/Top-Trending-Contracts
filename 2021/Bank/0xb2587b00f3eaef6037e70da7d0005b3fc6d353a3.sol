['// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Deployed with donations via Gitcoin GR9\n', '\n', 'pragma solidity 0.7.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IIntegralReader {\n', '    struct Parameters {\n', '        int256[] bidExponents;\n', '        int256[] bidQs;\n', '        int256[] askExponents;\n', '        int256[] askQs;\n', '    }\n', '\n', '    function getPairParameters(address pair)\n', '        external\n', '        view\n', '        returns (\n', '            bool exists,\n', '            uint112 reserve0,\n', '            uint112 reserve1,\n', '            uint112 reference0,\n', '            uint112 reference1,\n', '            uint256 mintFee,\n', '            uint256 burnFee,\n', '            uint256 swapFee,\n', '            uint32 pairEpoch,\n', '            uint32 oracleEpoch,\n', '            int256 price,\n', '            Parameters memory parameters\n', '        );\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Deployed with donations via Gitcoin GR9\n', '\n', 'pragma solidity 0.7.5;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Deployed with donations via Gitcoin GR9\n', '\n', 'pragma solidity 0.7.5;\n', '\n', "import 'IERC20.sol';\n", '\n', 'interface IIntegralERC20 is IERC20 {\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '\n', '    function nonces(address owner) external view returns (uint256);\n', '\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Deployed with donations via Gitcoin GR9\n', '\n', 'pragma solidity 0.7.5;\n', '\n', 'interface IReserves {\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '    event Fees(uint256 fee0, uint256 fee1);\n', '\n', '    function getReserves()\n', '        external\n', '        view\n', '        returns (\n', '            uint112 reserve0,\n', '            uint112 reserve1,\n', '            uint32 lastTimestamp\n', '        );\n', '\n', '    function getReferences()\n', '        external\n', '        view\n', '        returns (\n', '            uint112 reference0,\n', '            uint112 reference1,\n', '            uint32 epoch\n', '        );\n', '\n', '    function getFees() external view returns (uint256 fee0, uint256 fee1);\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Deployed with donations via Gitcoin GR9\n', '\n', 'pragma solidity 0.7.5;\n', '\n', "import 'IIntegralERC20.sol';\n", "import 'IReserves.sol';\n", '\n', 'interface IIntegralPair is IIntegralERC20, IReserves {\n', '    event Mint(address indexed sender, address indexed to);\n', '    event Burn(address indexed sender, address indexed to);\n', '    event Swap(address indexed sender, address indexed to);\n', '    event SetMintFee(uint256 fee);\n', '    event SetBurnFee(uint256 fee);\n', '    event SetSwapFee(uint256 fee);\n', '    event SetOracle(address account);\n', '    event SetTrader(address trader);\n', '    event SetToken0AbsoluteLimit(uint256 limit);\n', '    event SetToken1AbsoluteLimit(uint256 limit);\n', '    event SetToken0RelativeLimit(uint256 limit);\n', '    event SetToken1RelativeLimit(uint256 limit);\n', '    event SetPriceDeviationLimit(uint256 limit);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint256);\n', '\n', '    function factory() external view returns (address);\n', '\n', '    function token0() external view returns (address);\n', '\n', '    function token1() external view returns (address);\n', '\n', '    function oracle() external view returns (address);\n', '\n', '    function trader() external view returns (address);\n', '\n', '    function mintFee() external view returns (uint256);\n', '\n', '    function setMintFee(uint256 fee) external;\n', '\n', '    function mint(address to) external returns (uint256 liquidity);\n', '\n', '    function burnFee() external view returns (uint256);\n', '\n', '    function setBurnFee(uint256 fee) external;\n', '\n', '    function burn(address to) external returns (uint256 amount0, uint256 amount1);\n', '\n', '    function swapFee() external view returns (uint256);\n', '\n', '    function setSwapFee(uint256 fee) external;\n', '\n', '    function setOracle(address account) external;\n', '\n', '    function setTrader(address account) external;\n', '\n', '    function token0AbsoluteLimit() external view returns (uint256);\n', '\n', '    function setToken0AbsoluteLimit(uint256 limit) external;\n', '\n', '    function token1AbsoluteLimit() external view returns (uint256);\n', '\n', '    function setToken1AbsoluteLimit(uint256 limit) external;\n', '\n', '    function token0RelativeLimit() external view returns (uint256);\n', '\n', '    function setToken0RelativeLimit(uint256 limit) external;\n', '\n', '    function token1RelativeLimit() external view returns (uint256);\n', '\n', '    function setToken1RelativeLimit(uint256 limit) external;\n', '\n', '    function priceDeviationLimit() external view returns (uint256);\n', '\n', '    function setPriceDeviationLimit(uint256 limit) external;\n', '\n', '    function collect(address to) external;\n', '\n', '    function swap(\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        address to\n', '    ) external;\n', '\n', '    function sync() external;\n', '\n', '    function initialize(\n', '        address _token0,\n', '        address _token1,\n', '        address _oracle,\n', '        address _trader\n', '    ) external;\n', '\n', '    function syncWithOracle() external;\n', '\n', '    function fullSync() external;\n', '\n', '    function getSpotPrice() external view returns (uint256 spotPrice);\n', '\n', '    function getSwapAmount0In(uint256 amount1Out) external view returns (uint256 swapAmount0In);\n', '\n', '    function getSwapAmount1In(uint256 amount0Out) external view returns (uint256 swapAmount1In);\n', '\n', '    function getSwapAmount0Out(uint256 amount1In) external view returns (uint256 swapAmount0Out);\n', '\n', '    function getSwapAmount1Out(uint256 amount0In) external view returns (uint256 swapAmount1Out);\n', '\n', '    function getDepositAmount0In(uint256 amount0) external view returns (uint256 depositAmount0In);\n', '\n', '    function getDepositAmount1In(uint256 amount1) external view returns (uint256 depositAmount1In);\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Deployed with donations via Gitcoin GR9\n', '\n', 'pragma solidity 0.7.5;\n', '\n', 'interface IIntegralOracle {\n', '    event OwnerSet(address owner);\n', '    event UniswapPairSet(address uniswapPair);\n', '    event PriceUpdateIntervalSet(uint32 interval);\n', '    event ParametersSet(uint32 epoch, int256[] bidExponents, int256[] bidQs, int256[] askExponents, int256[] askQs);\n', '\n', '    function owner() external view returns (address);\n', '\n', '    function setOwner(address) external;\n', '\n', '    function epoch() external view returns (uint32);\n', '\n', '    function xDecimals() external view returns (uint8);\n', '\n', '    function yDecimals() external view returns (uint8);\n', '\n', '    function getParameters()\n', '        external\n', '        view\n', '        returns (\n', '            int256[] memory bidExponents,\n', '            int256[] memory bidQs,\n', '            int256[] memory askExponents,\n', '            int256[] memory askQs\n', '        );\n', '\n', '    function setParameters(\n', '        int256[] calldata bidExponents,\n', '        int256[] calldata bidQs,\n', '        int256[] calldata askExponents,\n', '        int256[] calldata askQs\n', '    ) external;\n', '\n', '    function price() external view returns (int256);\n', '\n', '    function priceUpdateInterval() external view returns (uint32);\n', '\n', '    function updatePrice() external returns (uint32 _epoch);\n', '\n', '    function setPriceUpdateInterval(uint32 interval) external;\n', '\n', '    function price0CumulativeLast() external view returns (uint256);\n', '\n', '    function blockTimestampLast() external view returns (uint32);\n', '\n', '    function tradeX(\n', '        uint256 xAfter,\n', '        uint256 xBefore,\n', '        uint256 yBefore\n', '    ) external view returns (uint256 yAfter);\n', '\n', '    function tradeY(\n', '        uint256 yAfter,\n', '        uint256 xBefore,\n', '        uint256 yBefore\n', '    ) external view returns (uint256 xAfter);\n', '\n', '    function getSpotPrice(uint256 xCurrent, uint256 xBefore) external view returns (uint256 spotPrice);\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// Deployed with donations via Gitcoin GR9\n', '\n', 'pragma solidity 0.7.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', "import 'IIntegralReader.sol';\n", "import 'IIntegralPair.sol';\n", "import 'IIntegralOracle.sol';\n", '\n', 'contract IntegralReader is IIntegralReader {\n', '    function isContract(address addressToCheck) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly {\n', '            size := extcodesize(addressToCheck)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    function getPairParameters(address pair)\n', '        external\n', '        view\n', '        override\n', '        returns (\n', '            bool exists,\n', '            uint112 reserve0,\n', '            uint112 reserve1,\n', '            uint112 reference0,\n', '            uint112 reference1,\n', '            uint256 mintFee,\n', '            uint256 burnFee,\n', '            uint256 swapFee,\n', '            uint32 pairEpoch,\n', '            uint32 oracleEpoch,\n', '            int256 price,\n', '            Parameters memory parameters\n', '        )\n', '    {\n', '        exists = isContract(pair);\n', '        if (exists) {\n', '            (reserve0, reserve1, ) = IIntegralPair(pair).getReserves();\n', '            (reference0, reference1, pairEpoch) = IIntegralPair(pair).getReferences();\n', '            mintFee = IIntegralPair(pair).mintFee();\n', '            burnFee = IIntegralPair(pair).burnFee();\n', '            swapFee = IIntegralPair(pair).swapFee();\n', '            address oracle = IIntegralPair(pair).oracle();\n', '            oracleEpoch = IIntegralOracle(oracle).epoch();\n', '            if (oracleEpoch != pairEpoch) {\n', '                reference0 = reserve0;\n', '                reference1 = reserve1;\n', '            }\n', '            price = IIntegralOracle(oracle).price();\n', '            {\n', '                (\n', '                    int256[] memory bidExponents,\n', '                    int256[] memory bidQs,\n', '                    int256[] memory askExponents,\n', '                    int256[] memory askQs\n', '                ) = IIntegralOracle(oracle).getParameters();\n', '                parameters = Parameters(bidExponents, bidQs, askExponents, askQs);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '{\n', '  "libraries": {\n', '    "IIntegralReader.sol": {},\n', '    "IERC20.sol": {},\n', '    "IIntegralERC20.sol": {},\n', '    "IReserves.sol": {},\n', '    "IIntegralPair.sol": {},\n', '    "IIntegralOracle.sol": {},\n', '    "IntegralReader.sol": {}\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']