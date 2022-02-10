['/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '    SPDX-License-Identifier: Apache-2.0\n', '\n', '*/\n', '\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'interface IChainlink {\n', '    function latestAnswer() external view returns (uint256);\n', '}\n', '\n', '\n', '// for COMP-USDC(decimals=6) price convert\n', '\n', 'contract ChainlinkCOMPUSDCPriceOracleProxy {\n', '    address public chainlink = 0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5;\n', '\n', '    function getPrice() external view returns (uint256) {\n', '        return IChainlink(chainlink).latestAnswer() / 100;\n', '    }\n', '}']