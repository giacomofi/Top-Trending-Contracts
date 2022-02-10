['contract Upkeep {\n', '  bool public shouldPerformUpkeep;\n', '  bytes public bytesToSend;\n', '  bytes public receivedBytes;\n', '  function setShouldPerformUpkeep(bool _should) public {\n', '    shouldPerformUpkeep = _should;\n', '  }\n', '  function setBytesToSend(bytes memory _bytes) public {\n', '    bytesToSend = _bytes;\n', '  }\n', '  function checkUpkeep(bytes calldata data) external returns (bool, bytes memory) {\n', '    return (shouldPerformUpkeep, bytesToSend);\n', '  }\n', '  function performUpkeep(bytes calldata data) external {\n', '    shouldPerformUpkeep = false;\n', '    receivedBytes = data;\n', '  }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']