['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./interfaces/IChainLinkOracle.sol";\n', 'import "./interfaces/IXToken.sol";\n', '\n', 'contract ibBtcOracleHelper is IChainLinkOracle {\n', '    IChainLinkOracle constant public btcFeed = IChainLinkOracle(0x8Aa3932790b33C7Cc751231161Ae5221af058D12);\n', '    IXToken constant public ibBTC = IXToken(0xc4E15973E6fF2A35cC804c2CF9D2a1b817a8b40F);\n', '\n', '    function latestAnswer() external override view returns (uint256 answer) {\n', '        uint256 btcPrice = btcFeed.latestAnswer();\n', '        answer = btcPrice * ibBTC.pricePerShare() / 1e18;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: No License\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IChainLinkOracle {\n', '    function latestAnswer() external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: No License\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IXToken {\n', '    function pricePerShare() external view returns (uint256);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 2000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']