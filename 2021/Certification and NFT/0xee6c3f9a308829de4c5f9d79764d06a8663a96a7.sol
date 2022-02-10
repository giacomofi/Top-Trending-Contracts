['// SPDX-License-Identifier: BSD-3-Clause\n', '\n', 'pragma solidity 0.6.11;\n', '\n', "import './TeazersBase.sol';\n", '\n', 'contract Teazers is TeazersBase {\n', '    constructor(address _addr) public {\n', '        owner = msg.sender;\n', '\n', '        reentry_status = ENTRY_ENABLED;\n', '\n', '        levelCost[1] = 0.003 ether;\n', '        for (uint8 i = 2; i <= TOP_LEVEL; i++) {\n', '            levelCost[i] = levelCost[i - 1] * 2;\n', '        }\n', '\n', '        createAccount(_addr, _addr, true);\n', '\n', '        for (uint8 j = 1; j <= TOP_LEVEL; j++) {\n', '            handlePositionX3(_addr, _addr, _addr, j, true);\n', '            handlePositionX4(_addr, _addr, _addr, j, true);\n', '        }\n', '    }\n', '}']