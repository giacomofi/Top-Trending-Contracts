['pragma solidity ^0.8.0;\n', '\n', 'contract UniswapPairManipulator {\n', '\n', '    uint256 public dai = 10**18;\n', '    uint256 public tree = 10**18;\n', '\n', '    // Manipulate result\n', '    function getReserves() public view returns (uint256 _reserve0, uint256 _reserve1, uint32 _blockTimestampLast) {\n', '        _reserve0 = dai;\n', '        _reserve1 = tree;\n', '        _blockTimestampLast = 100000;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']