['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-04\n', '*/\n', '\n', '//SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.6.12;\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IUniswapV2Pair {\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '}\n', '\n', 'abstract contract UniswapV2Factory  {\n', '    mapping(address => mapping(address => address)) public getPair;\n', '    address[] public allPairs;\n', '    function allPairsLength() external view virtual returns (uint);\n', '}\n', '\n', '// In order to quickly load up data from Uniswap-like market, this contract allows easy iteration with a single eth_call\n', 'contract FlashBotsUniswapQuery {\n', '    function getReservesByPairs(IUniswapV2Pair[] calldata _pairs) external view returns (uint256[3][] memory) {\n', '        uint256[3][] memory result = new uint256[3][](_pairs.length);\n', '        for (uint i = 0; i < _pairs.length; i++) {\n', '            (result[i][0], result[i][1], result[i][2]) = _pairs[i].getReserves();\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function getPairsByIndexRange(UniswapV2Factory _uniswapFactory, uint256 _start, uint256 _stop) external view returns (address[3][] memory)  {\n', '        uint256 _allPairsLength = _uniswapFactory.allPairsLength();\n', '        if (_stop > _allPairsLength) {\n', '            _stop = _allPairsLength;\n', '        }\n', '        require(_stop >= _start, "start cannot be higher than stop");\n', '        uint256 _qty = _stop - _start;\n', '        address[3][] memory result = new address[3][](_qty);\n', '        for (uint i = 0; i < _qty; i++) {\n', '            IUniswapV2Pair _uniswapPair = IUniswapV2Pair(_uniswapFactory.allPairs(_start + i));\n', '            result[i][0] = _uniswapPair.token0();\n', '            result[i][1] = _uniswapPair.token1();\n', '            result[i][2] = address(_uniswapPair);\n', '        }\n', '        return result;\n', '    }\n', '}']