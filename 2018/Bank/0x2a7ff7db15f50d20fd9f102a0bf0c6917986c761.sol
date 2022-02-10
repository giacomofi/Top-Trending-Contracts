['pragma solidity ^0.4.23;\n', '\n', 'contract Store4Less {\n', '  struct Pair {\n', '    uint96 address1;\n', '    uint32 data1;\n', '    uint96 address2;\n', '    uint32 data2;\n', '  }\n', '  \n', '  // stored[iteration][index] = Pair\n', '  mapping (uint => mapping (uint => Pair)) stored;\n', '\n', '  function store(uint32 data) external {\n', '    recursive_store(data, 1);\n', '  }\n', '\n', '  function recursive_store(uint32 data, uint iteration) internal {\n', '    uint96 sender = uint96(uint(msg.sender) / 2**64);\n', '    uint index = uint(msg.sender) % (4 ** iteration);\n', '    if (stored[iteration][index].address1 == 0) {\n', '      stored[iteration][index].address1 = sender;\n', '      stored[iteration][index].data1 = data;\n', '    } else if (stored[iteration][index].address1 == sender) {\n', '      stored[iteration][index].data1 = data;\n', '    } else if (stored[iteration][index].address2 == 0) {\n', '      stored[iteration][index].address2 = sender;\n', '      stored[iteration][index].data2 = data;\n', '    } else if (stored[iteration][index].address2 == sender) {\n', '      stored[iteration][index].data2 = data;\n', '    } else {\n', '      recursive_store(data, iteration + 1);\n', '    }\n', '  }\n', '\n', '  function read() external returns (uint32) {\n', '    return recursive_read(1);\n', '  }\n', '\n', '  function recursive_read(uint iteration) internal returns (uint32) {\n', '    uint96 sender = uint96(uint(msg.sender) / 2**64);\n', '    uint index = uint(msg.sender) % (4 ** iteration);\n', '    if (stored[iteration][index].address1 == 0) {\n', '      return 0;\n', '    } else if (stored[iteration][index].address1 == sender) {\n', '      return stored[iteration][index].data1;\n', '    } else if (stored[iteration][index].address2 == 0) {\n', '      return 0;\n', '    } else if (stored[iteration][index].address2 == sender) {\n', '      return stored[iteration][index].data2;\n', '    } else {\n', '      return recursive_read(iteration + 1);\n', '    }\n', '  }\n', '}']