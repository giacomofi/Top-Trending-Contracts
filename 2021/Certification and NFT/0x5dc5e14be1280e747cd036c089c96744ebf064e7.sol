['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-14\n', '*/\n', '\n', '// SPDX-License-Identifier:  AGPL-3.0-or-later // hevm: flattened sources of contracts/oracles/UsdOracle.sol\n', 'pragma solidity =0.6.11;\n', '\n', '////// contracts/oracles/UsdOracle.sol\n', '/* pragma solidity 0.6.11; */\n', '\n', '/// @title UsdOracle is a constant price oracle feed that always returns 1 USD in 8 decimal precision.\n', 'contract UsdOracle {\n', '\n', '    int256 constant USD_PRICE = 1 * 10 ** 8;\n', '\n', '    /**\n', '        @dev Returns the constant USD price.\n', '    */\n', '    function getLatestPrice() public pure returns (int256) {\n', '        return USD_PRICE;\n', '    }\n', '}']