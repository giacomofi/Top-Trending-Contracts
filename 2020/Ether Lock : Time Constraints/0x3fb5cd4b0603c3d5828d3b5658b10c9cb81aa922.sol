['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '//\n', '// SPDX-License-Identifier: LGPL-3.0-only\n', '\n', 'pragma solidity 0.7.1;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { Ownable } from "../../core/Ownable.sol";\n', '\n', '\n', 'struct PoolInfo {\n', '    address swap;       // stableswap contract address.\n', '    address deposit;    // deposit contract address.\n', '    uint256 totalCoins; // Number of coins used in stableswap contract.\n', '    string name;        // Pool name ("... Pool").\n', '}\n', '\n', '\n', '/**\n', ' * @title Registry for Curve contracts.\n', ' * @dev Implements two getters - getSwapAndTotalCoins(address) and getName(address).\n', ' * @notice Call getSwapAndTotalCoins(token) and getName(address) function and get address,\n', ' * coins number, and name of stableswap contract for the given token address.\n', ' * @author Igor Sobolev <sobolev@zerion.io>\n', ' */\n', 'contract CurveRegistry is Ownable {\n', '\n', '    mapping (address => PoolInfo) internal poolInfo_;\n', '\n', '    function setPoolsInfo(\n', '        address[] memory tokens,\n', '        PoolInfo[] memory poolsInfo\n', '    )\n', '        external\n', '        onlyOwner\n', '    {\n', '        uint256 length = tokens.length;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            setPoolInfo(tokens[i], poolsInfo[i]);\n', '        }\n', '    }\n', '\n', '    function setPoolInfo(\n', '        address token,\n', '        PoolInfo memory poolInfo\n', '    )\n', '        internal\n', '    {\n', '        poolInfo_[token] = poolInfo;\n', '    }\n', '\n', '    function getPoolInfo(address token) external view returns (PoolInfo memory) {\n', '        return poolInfo_[token];\n', '    }\n', '}\n']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '//\n', '// SPDX-License-Identifier: LGPL-3.0-only\n', '\n', 'pragma solidity 0.7.1;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'abstract contract Ownable {\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner_, "O: only owner");\n', '        _;\n', '    }\n', '\n', '    modifier onlyPendingOwner {\n', '        require(msg.sender == pendingOwner_, "O: only pending owner");\n', '        _;\n', '    }\n', '\n', '    address private owner_;\n', '    address private pendingOwner_;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @notice Initializes owner variable with msg.sender address.\n', '     */\n', '    constructor() {\n', '        owner_ = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice Sets pending owner to the desired address.\n', '     * The function is callable only by the owner.\n', '     */\n', '    function proposeOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0), "O: empty newOwner");\n', '        require(newOwner != owner_, "O: equal to owner_");\n', '        require(newOwner != pendingOwner_, "O: equal to pendingOwner_");\n', '        pendingOwner_ = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers ownership to the pending owner.\n', '     * The function is callable only by the pending owner.\n', '     */\n', '    function acceptOwnership() external onlyPendingOwner {\n', '        emit OwnershipTransferred(owner_, msg.sender);\n', '        owner_ = msg.sender;\n', '        delete pendingOwner_;\n', '    }\n', '\n', '    /**\n', '     * @return Owner of the contract.\n', '     */\n', '    function owner() external view returns (address) {\n', '        return owner_;\n', '    }\n', '\n', '    /**\n', '     * @return Pending owner of the contract.\n', '     */\n', '    function pendingOwner() external view returns (address) {\n', '        return pendingOwner_;\n', '    }\n', '}\n']
