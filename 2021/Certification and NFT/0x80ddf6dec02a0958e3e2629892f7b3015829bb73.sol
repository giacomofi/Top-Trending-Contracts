['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-02\n', '*/\n', '\n', '//SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.6;\n', '\n', 'interface IPair {\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '}\n', '\n', 'abstract contract Factory  {\n', '    address[] public allPairs;\n', '    function allPairsLength() external view virtual returns (uint);\n', '}\n', '\n', 'contract PairQuery {\n', '    function getPairs(IPair[] calldata _pairs) external view returns (address[3][] memory, uint[2][] memory, uint) {\n', '        uint len = _pairs.length;\n', '        address[3][] memory result = new address[3][](len);\n', '        uint[2][] memory reserves = new uint[2][](len);\n', '        for (uint i = 0; i < len; i++) {\n', '            IPair pair = IPair(_pairs[i]);\n', '            result[i][0] = pair.token0();\n', '            result[i][1] = pair.token1();\n', '            result[i][2] = address(pair);\n', '            (reserves[i][0], reserves[i][1], ) = pair.getReserves();\n', '        }\n', '        return (result,reserves,block.number);\n', '    }\n', '    \n', '    function getPairsByIndexRange(Factory _factory, uint _start, uint _stop) external view returns (address[3][] memory, uint[2][] memory, uint) {\n', '        uint _allPairsLength =_factory.allPairsLength();\n', '        if (_stop > _allPairsLength) {\n', '            _stop = _allPairsLength;\n', '        }\n', '        require(_stop >= _start, "start cannot be higher than stop");\n', '        uint len = _stop - _start + 1;\n', '        address[3][] memory result = new address[3][](len);\n', '        uint[2][] memory reserves = new uint[2][](len);\n', '        for (uint i = 0; i < len; i++) {\n', '            IPair pair = IPair(_factory.allPairs(_start + i));\n', '            result[i][0] = pair.token0();\n', '            result[i][1] = pair.token1();\n', '            result[i][2] = address(pair);\n', '            (reserves[i][0], reserves[i][1], ) = pair.getReserves();\n', '        }\n', '        return (result,reserves,block.number);\n', '    }\n', '    \n', '    function getAllPairLength(Factory _factory) external view returns (uint) {\n', '        return _factory.allPairsLength();\n', '    }\n', '    \n', '    function getAllPairLengthByFactorys(Factory[] calldata _factorys) external view returns (uint[] memory, uint) {\n', '        uint len = _factorys.length;\n', '        uint[] memory result = new uint[](len);\n', '        for (uint i = 0; i < len; i++){\n', '            result[i] = _factorys[i].allPairsLength();\n', '        }\n', '        return (result, block.number);\n', '    }\n', '}']