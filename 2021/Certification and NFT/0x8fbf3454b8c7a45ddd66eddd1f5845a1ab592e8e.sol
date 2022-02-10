['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-27\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.7.6;  \n', '\n', 'abstract contract IStakedTokenIncentivesController {\n', '     function claimRewards(\n', '    address[] calldata assets,\n', '    uint256 amount,\n', '    address to\n', '  ) external virtual returns (uint256);\n', '}\n', '\n', 'contract AaveClaimProxy {\n', '    \n', '    address public constant STAKED_CONTROLLER_ADDR = 0xd784927Ff2f95ba542BfC824c8a8a98F3495f6b5;\n', '    \n', '    function claimRewards(\n', '        address[] memory assets,\n', '    uint256 amount,\n', '    address to\n', '    ) public {\n', '        IStakedTokenIncentivesController(STAKED_CONTROLLER_ADDR).claimRewards(\n', '            assets,\n', '            amount,\n', '            to\n', '            );\n', '    }\n', '}']