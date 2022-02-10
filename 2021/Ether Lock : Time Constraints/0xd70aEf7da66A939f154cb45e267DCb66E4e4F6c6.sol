['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface ERC20 {\n', '    function approve(address, uint256) external returns (bool);\n', '    function transfer(address, uint256) external returns (bool);\n', '    function transferFrom(address, address, uint256) external returns (bool);\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address) external view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title Protocol adapter interface.\n', ' * @dev adapterType(), tokenType(), and getBalance() functions MUST be implemented.\n', ' * @author Igor Sobolev <[email\xa0protected]>\n', ' */\n', 'interface ProtocolAdapter {\n', '\n', '    /**\n', '     * @dev MUST return "Asset" or "Debt".\n', '     * SHOULD be implemented by the public constant state variable.\n', '     */\n', '    function adapterType() external pure returns (string memory);\n', '\n', '    /**\n', '     * @dev MUST return token type (default is "ERC20").\n', '     * SHOULD be implemented by the public constant state variable.\n', '     */\n', '    function tokenType() external pure returns (string memory);\n', '\n', '    /**\n', '     * @dev MUST return amount of the given token locked on the protocol by the given account.\n', '     */\n', '    function getBalance(address token, address account) external view returns (uint256);\n', '}\n', '\n', '\n', 'interface ITimeWarpPool {\n', '    function userStacked(address) external view returns (uint256);\n', '\n', '    function userLastReward(address) external view returns (uint32);\n', '\n', '    function getReward(address, uint32) external view returns (uint256, uint32);\n', '}\n', '\n', '\n', 'interface IUniswapV2Pair {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '}\n', '\n', '/**\n', ' * @title Adapter for Time protocol (staking).\n', ' * @dev Implementation of ProtocolAdapter interface.\n', ' * @author Igor Sobolev <[email\xa0protected]>\n', ' */\n', 'contract TimeStakingAdapter is ProtocolAdapter {\n', '\n', '    string public constant override adapterType = "Asset";\n', '\n', '    string public constant override tokenType = "ERC20";\n', '\n', '    address internal constant STACKING_POOL_TIME = 0xa106dd3Bc6C42B3f28616FfAB615c7d494Eb629D;\n', '    address internal constant STACKING_POOL_TIME_ETH_LP = 0x55c825983783c984890bA89F7d7C9575814D83F2;\n', '    address internal constant UNISWAP_POOL_TIME_ETH_LP = 0x1d474d4B4A62b0Ad0C819841eB2C74d1c5050524;\n', '\n', '    /**\n', '     * @return Amount of staked TIME tokens for a given account.\n', '     * @dev Implementation of ProtocolAdapter interface function.\n', '     */\n', '    function getBalance(address, address account) external view override returns (uint256) {\n', '        uint256 totalBalance = 0;\n', '\n', '        totalBalance += ITimeWarpPool(STACKING_POOL_TIME).userStacked(account);\n', '        uint32 lastReward = ITimeWarpPool(STACKING_POOL_TIME).userLastReward(account);\n', '        (uint256 amount,) = ITimeWarpPool(STACKING_POOL_TIME).getReward(account, lastReward);\n', '        totalBalance += amount;\n', '\n', '        uint256 balanceLP = ITimeWarpPool(STACKING_POOL_TIME_ETH_LP).userStacked(account);\n', '        uint256 totalSupply = IUniswapV2Pair(UNISWAP_POOL_TIME_ETH_LP).totalSupply();\n', '        (uint112 reserve0,,) = IUniswapV2Pair(UNISWAP_POOL_TIME_ETH_LP).getReserves();\n', '        if (balanceLP > 0) {\n', '            totalBalance += balanceLP / totalSupply * reserve0;\n', '        }\n', '        return totalBalance;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']