['//SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.5.0;\n', '\n', 'import {UniswapV2Pair} from "./UniswapV2Pair.sol";\n', '\n', 'interface StakingPools {\n', '  function getStakeTotalDeposited(address _account, uint256 _poolId) external view returns (uint256);\n', '}\n', '\n', 'interface MasterChef {\n', '  function userInfo(uint256 _poolId, address _account) external view returns (uint256 amount, int256 rewardDebt);\n', '}\n', '\n', 'contract AlchemixVotes {\n', '  function getUnderlyingALCXTokens(address account) external view returns (uint256){\n', '    UniswapV2Pair slp = UniswapV2Pair(0xC3f279090a47e80990Fe3a9c30d24Cb117EF91a8);\n', '    MasterChef masterChecf = MasterChef(0xEF0881eC094552b2e128Cf945EF17a6752B4Ec5d);\n', '    StakingPools pools = StakingPools(0xAB8e74017a8Cc7c15FFcCd726603790d26d7DeCa);\n', '    uint256 alcxBalance = pools.getStakeTotalDeposited(account, 1);\n', '    uint256 lpBalance = slp.balanceOf(account);\n', '    (uint stakedLp,) = masterChecf.userInfo(0, account);\n', '    lpBalance += stakedLp;\n', '    (uint256 reserveETH, uint256 reserveALCX,) = slp.getReserves();\n', '    uint256 alcxInSlp = (lpBalance * reserveALCX)/slp.totalSupply();\n', '    alcxBalance += alcxInSlp;\n', '    return alcxBalance;\n', '  }\n', '}']