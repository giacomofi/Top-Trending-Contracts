['// SPDX-License-Identifier: MIT\n', '\n', '// Speech on the blockchain cannot be censored.\n', '//\n', "// Token-powered smart contracts will take us where the mainstream media wouldn't dare.\n", '//\n', '// Acquire tokens from airdrop recipients. You can find them in /qresearch/.\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "ERC20.sol";\n', '\n', 'contract QToken is ERC20 {\n', "    constructor () ERC20('Q', 'WWG1WGA') {\n", '        _mint(msg.sender, 17000000 * 10 ** uint(decimals()));\n', '    }\n', '}']