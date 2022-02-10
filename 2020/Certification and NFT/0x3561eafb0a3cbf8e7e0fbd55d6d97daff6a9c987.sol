['// File: contracts/lib/SafeMath.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '    SPDX-License-Identifier: Apache-2.0\n', '\n', '*/\n', '\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "MUL_ERROR");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "DIVIDING_ERROR");\n', '        return a / b;\n', '    }\n', '\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 quotient = div(a, b);\n', '        uint256 remainder = a - quotient * b;\n', '        if (remainder > 0) {\n', '            return quotient + 1;\n', '        } else {\n', '            return quotient;\n', '        }\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SUB_ERROR");\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "ADD_ERROR");\n', '        return c;\n', '    }\n', '\n', '    function sqrt(uint256 x) internal pure returns (uint256 y) {\n', '        uint256 z = x / 2 + 1;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/helper/ChainlinkYFIUSDCPriceOracleProxy.sol\n', '\n', 'interface IChainlink {\n', '    function latestAnswer() external view returns (uint256);\n', '}\n', '\n', '\n', '// for YFI-USDC(decimals=6) price convert\n', '\n', 'contract ChainlinkYFIUSDCPriceOracleProxy {\n', '    using SafeMath for uint256;\n', '\n', '    address public yfiEth = 0x7c5d4F8345e66f68099581Db340cd65B078C41f4;\n', '    address public EthUsd = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;\n', '\n', '    function getPrice() external view returns (uint256) {\n', '        uint256 yfiEthPrice = IChainlink(yfiEth).latestAnswer();\n', '        uint256 EthUsdPrice = IChainlink(EthUsd).latestAnswer();\n', '        return yfiEthPrice.mul(EthUsdPrice).div(10**20);\n', '    }\n', '}']