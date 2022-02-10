['/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '    SPDX-License-Identifier: Apache-2.0\n', '\n', '*/\n', '\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'interface IChainlink {\n', '    function latestAnswer() external view returns (uint256);\n', '}\n', '\n', '\n', '// for SNX-USDC(decimals=6) price convert\n', '\n', 'contract ChainlinkSNXUSDCPriceOracleProxy {\n', '    address public chainlink = 0xDC3EA94CD0AC27d9A86C180091e7f78C683d3699;\n', '\n', '    function getPrice() external view returns (uint256) {\n', '        return IChainlink(chainlink).latestAnswer() / 100;\n', '    }\n', '}']