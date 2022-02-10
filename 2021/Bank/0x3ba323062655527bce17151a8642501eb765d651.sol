['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-11\n', '*/\n', '\n', '//SPDX-License-Identifier: None\n', '\n', '// File contracts/interfaces/IComptroller.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IComptroller {\n', '    function getAccountLiquidity(address account) external view returns (uint256, uint256, uint256);\n', '}\n', '\n', '// File contracts/AnchorMulticall.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'contract AnchorMulticall {\n', '    IComptroller public comptroller = IComptroller(0x4dCf7407AE5C07f8681e1659f626E114A7667339);\n', '\n', '    function getAccountsLiquidity(address[] calldata accounts)\n', '        external\n', '        view\n', '        returns (uint256[] memory statuses)\n', '    {\n', '        for (uint256 i = 0; i < accounts.length; i++) {\n', '            (, , uint256 shortfall) = comptroller.getAccountLiquidity(accounts[i]);\n', '            statuses[i] = shortfall;\n', '        }\n', '    }\n', '}']