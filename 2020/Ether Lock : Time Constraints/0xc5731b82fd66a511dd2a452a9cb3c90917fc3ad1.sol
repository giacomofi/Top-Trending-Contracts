['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'interface ERC20 {\n', '    function approve(address, uint256) external returns (bool);\n', '    function transfer(address, uint256) external returns (bool);\n', '    function transferFrom(address, address, uint256) external returns (bool);\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address) external view returns (uint256);\n', '}\n']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { ERC20 } from "../../ERC20.sol";\n', 'import { ProtocolAdapter } from "../ProtocolAdapter.sol";\n', '\n', '\n', '/**\n', ' * @dev StakingRewards contract interface.\n', ' * Only the functions required for YearnStakingV1Adapter contract are added.\n', ' * The StakingRewards contract is available here\n', ' * github.com/Synthetixio/synthetix/blob/master/contracts/StakingRewards.sol.\n', ' */\n', 'interface StakingRewards {\n', '    function earned(address) external view returns (uint256);\n', '}\n', '\n', '\n', '/**\n', ' * @title Adapter for C.R.E.A.M. protocol.\n', ' * @dev Implementation of ProtocolAdapter interface.\n', ' * @author Igor Sobolev <sobolev@zerion.io>\n', ' */\n', 'contract CreamStakingAdapter is ProtocolAdapter {\n', '\n', '    string public constant override adapterType = "Asset";\n', '\n', '    string public constant override tokenType = "ERC20";\n', '\n', '    address internal constant BALANCER_CREAM_WETH = 0x5a82503652d05B21780f33178FDF53d31c29B916;\n', '    address internal constant UNISWAP_CREAM_WETH = 0xddF9b7a31b32EBAF5c064C80900046C9e5b7C65F;\n', '    address internal constant CREAM_CREAM_USDC = 0x4Fd2d9d6eF05E13Bf0B167509151A4EC3D4d4b93;\n', '    address internal constant CREAM_CREAM_WETH = 0xa49b3c7C260ce8A7C665e20Af8aA6E099A86cf8A;\n', '    address internal constant CREAM_CRCREAM_CRYFI = 0xA65405e0dD378C65308deAE51dA9e3BcEBb81261;\n', '    address internal constant CREAM_CRYETH_CRYYCRV = 0xB3284F2F22563F27cEF2912637b6A00F162317c4;\n', '    address internal constant CREAM_CRYETH_WETH = 0x6a3B875854f5518E85Ef97620c5e7de75bbc3fA0;\n', '    address internal constant CREAM_YYCRV_USDC = 0x661b94d96ADb18646e791A06576F7905a8d1BEF6;\n', '    address internal constant CREAM_YFI_USDC = 0x7350c6D00D63AB5988250aea347f277c19BEA785;\n', '    address internal constant CRCREAM = 0x892B14321a4FCba80669aE30Bd0cd99a7ECF6aC0;\n', '    address internal constant CREAM = 0x2ba592F78dB6436527729929AAf6c908497cB200;\n', '\n', '    address internal constant BALANCER_CREAM_WETH_POOL = 0xCcD5cb3401704AF8462a4FFE708a180d3C5c4Da0;\n', '    address internal constant BALANCER_CREAM_WETH_POOL_2 = 0xc29E89845fA794Aa0A0B8823de23B760c3d766F5;\n', '    address internal constant UNISWAP_CREAM_WETH_POOL = 0x65bC20147E2cA6F3bf0819c38E519F8792043b36;\n', '    address internal constant CREAM_CREAM_USDC_POOL = 0x1676fc274B65966ED0c6438a26d34c6C92A5981C;\n', '    address internal constant CREAM_CREAM_WETH_POOL = 0x43a8ecE49718E22D21077000768afF91849BCEfF;\n', '    address internal constant CREAM_CRCREAM_CRYFI_POOL = 0xCC5f8cA88cAbA27f15746aeb481F0C446991F863;\n', '    address internal constant CREAM_CRYETH_CRYYCRV_POOL = 0xD032BfeDC68CE5067E3E0b766Dbcf653ceEA541a;\n', '    address internal constant CREAM_CRYETH_WETH_POOL = 0xCF679b2E16498a866Bd4CBda60d42f208084c6E1;\n', '    address internal constant CREAM_YYCRV_USDC_POOL = 0xB8c3a282De181889EF20488e73e7A149a8C1bFe1;\n', '    address internal constant CREAM_YFI_USDC_POOL = 0x2aB765c2B4A4E197fBAE769f86870F2310A04D61;\n', '    address internal constant CRCREAM_POOL = 0x71A808Fd21171d992ebc17678e8ae139079922d0;\n', '\n', '    /**\n', '     * @return Amount of staked tokens / rewards earned after staking for a given account.\n', '     * @dev Implementation of ProtocolAdapter interface function.\n', '     */\n', '    function getBalance(address token, address account) external view override returns (uint256) {\n', '        if (token == CREAM) {\n', '            uint256 totalRewards = 0;\n', '\n', '            totalRewards += StakingRewards(BALANCER_CREAM_WETH_POOL).earned(account);\n', '            totalRewards += StakingRewards(BALANCER_CREAM_WETH_POOL_2).earned(account);\n', '            totalRewards += StakingRewards(UNISWAP_CREAM_WETH_POOL).earned(account);\n', '            totalRewards += StakingRewards(CREAM_CREAM_USDC_POOL).earned(account);\n', '            totalRewards += StakingRewards(CREAM_CREAM_WETH_POOL).earned(account);\n', '            totalRewards += StakingRewards(CREAM_CRCREAM_CRYFI_POOL).earned(account);\n', '            totalRewards += StakingRewards(CREAM_CRYETH_CRYYCRV_POOL).earned(account);\n', '            totalRewards += StakingRewards(CREAM_CRYETH_WETH_POOL).earned(account);\n', '            totalRewards += StakingRewards(CREAM_YYCRV_USDC_POOL).earned(account);\n', '            totalRewards += StakingRewards(CREAM_YFI_USDC_POOL).earned(account);\n', '            totalRewards += StakingRewards(CRCREAM_POOL).earned(account);\n', '\n', '            return totalRewards;\n', '        } else if (token == BALANCER_CREAM_WETH) {\n', '            uint256 totalBalance = 0;\n', '\n', '            totalBalance += ERC20(BALANCER_CREAM_WETH_POOL).balanceOf(account);\n', '            totalBalance += ERC20(BALANCER_CREAM_WETH_POOL_2).balanceOf(account);\n', '\n', '            return totalBalance;\n', '        } else if (token == UNISWAP_CREAM_WETH) {\n', '            return ERC20(UNISWAP_CREAM_WETH_POOL).balanceOf(account);\n', '        } else if (token == CREAM_CREAM_USDC) {\n', '            return ERC20(CREAM_CREAM_USDC_POOL).balanceOf(account);\n', '        } else if (token == CREAM_CREAM_WETH) {\n', '            return ERC20(CREAM_CREAM_WETH_POOL).balanceOf(account);\n', '        } else if (token == CREAM_CRCREAM_CRYFI) {\n', '            return ERC20(CREAM_CRCREAM_CRYFI_POOL).balanceOf(account);\n', '        } else if (token == CREAM_CRYETH_CRYYCRV) {\n', '            return ERC20(CREAM_CRYETH_CRYYCRV_POOL).balanceOf(account);\n', '        } else if (token == CREAM_CRYETH_WETH) {\n', '            return ERC20(CREAM_CRYETH_WETH_POOL).balanceOf(account);\n', '        } else if (token == CREAM_YYCRV_USDC) {\n', '            return ERC20(CREAM_YYCRV_USDC_POOL).balanceOf(account);\n', '        } else if (token == CREAM_YFI_USDC) {\n', '            return ERC20(CREAM_YFI_USDC_POOL).balanceOf(account);\n', '        } else if (token == CRCREAM) {\n', '            return ERC20(CRCREAM_POOL).balanceOf(account);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '}\n']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', '/**\n', ' * @title Protocol adapter interface.\n', ' * @dev adapterType(), tokenType(), and getBalance() functions MUST be implemented.\n', ' * @author Igor Sobolev <sobolev@zerion.io>\n', ' */\n', 'interface ProtocolAdapter {\n', '\n', '    /**\n', '     * @dev MUST return "Asset" or "Debt".\n', '     * SHOULD be implemented by the public constant state variable.\n', '     */\n', '    function adapterType() external pure returns (string memory);\n', '\n', '    /**\n', '     * @dev MUST return token type (default is "ERC20").\n', '     * SHOULD be implemented by the public constant state variable.\n', '     */\n', '    function tokenType() external pure returns (string memory);\n', '\n', '    /**\n', '     * @dev MUST return amount of the given token locked on the protocol by the given account.\n', '     */\n', '    function getBalance(address token, address account) external view returns (uint256);\n', '}\n']
