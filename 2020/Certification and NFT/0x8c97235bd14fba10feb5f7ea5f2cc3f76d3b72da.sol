['pragma solidity ^0.6.12;\n', '\n', 'contract UniPoolAddress {\n', '    \n', '    // weth address: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2    \n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address tokenA, address tokenB) public pure returns (address pair) {\n', '        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'\n", '            ))));\n', '    }\n', '}']